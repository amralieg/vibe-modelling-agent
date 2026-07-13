-- Schema for Domain: marine | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:17

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`marine` COMMENT 'Covers specialist marine services including pilotage scheduling and logs, towage operations, mooring services, launch boat dispatch, and marine surveyor coordination. Manages P&I club notifications and marine incident records aligned with SOLAS and MARPOL requirements. SSOT for all marine service delivery data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` (
    `pilotage_assignment_id` BIGINT COMMENT 'Unique surrogate identifier for the pilotage assignment record. Primary key for the pilotage_assignment data product in the marine domain.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Pilotage assignments must reference the applicable tariff schedule for billing calculation, regulatory compliance, and audit trail. Port operations require linking each pilotage event to its tariff ba',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Pilots board vessels at designated anchorages; boarding_station_name currently denormalized. Essential for pilot dispatch coordination, launch boat routing, and service billing accuracy.',
    `call_id` BIGINT COMMENT 'FK to vessel.call.call_id — Pilotage assignments are scheduled per vessel call. This FK enables pilot resource planning and marine service billing reconciliation.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Pilotage operations navigate vessels through designated channels; passage planning, VTS reporting, and incident investigation require channel reference. Core operational link for maritime safety and b',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: SOLAS Chapter XI-2 requires pilots to verify facility security level and Declaration of Security (DoS) before boarding. Pilotage operations must confirm ISPS compliance and current security level at b',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Pilotage services are governed by port service agreements defining tariffs, SLAs, and billing terms. Essential for rate lookup, penalty assessment, and invoice reconciliation. Natural business link in',
    `pilot_id` BIGINT COMMENT 'Reference to the licensed marine pilot assigned to conduct the pilotage service. Links to the pilot master record in the workforce/marine services domain.',
    `pilotage_route_id` BIGINT COMMENT 'Reference to the approved pilotage route assigned for this service, defining waypoints, distance, Under-Keel Clearance (UKC) requirements, speed restrictions, and tidal windows.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Pilotage assignments are scheduled and executed for booked vessel calls. Booking triggers pilot resource allocation, passage planning, and billing. Essential for operational coordination between booki',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Pilotage operations are cost-tracked by operational cost centres (VTS, pilot station) for service costing, budget variance analysis, and departmental P&L reporting. Essential for maritime service line',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Pilotage billing process requires direct lookup of the applicable port tariff rate to calculate service_charge_amount. Port authority billing teams reference the port_tariff to validate and generate p',
    `service_order_id` BIGINT COMMENT 'Foreign key linking to marine.marine_service_order. Business justification: Pilotage assignment is the operational execution of pilotage services ordered via marine_service_order. The marine_service_order product has pilotage_required flag, pilotage_type, and pilot_boarding_l',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Pilotage safety planning requires authoritative vessel master data (LOA, DWT, draft limits) for passage plan approval, pilot licensing verification, and SOLAS compliance. Removes denormalized vessel d',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Pilotage tariff calculation, pilot licensing requirements (vessel type endorsements), and tug requirement determination depend on vessel type classification (container, tanker, LNG carrier) from maste',
    `voyage_id` BIGINT COMMENT 'Reference to the vessel voyage record associated with this pilotage assignment, linking pilotage service to the broader vessel traffic management context.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: High-risk pilotage operations (confined waters, hazardous cargo, night operations, extreme weather) may require permits to work. Safety systems link permits to specific pilotage assignments for author',
    `actual_boarding_timestamp` TIMESTAMP COMMENT 'Actual date and time at which the pilot boarded the vessel. Used for service performance measurement, billing, and SOLAS compliance logging.',
    `assignment_number` STRING COMMENT 'Externally-known business identifier for the pilotage assignment, used in operational communications, billing, and regulatory reporting. Format: PLT-YYYY-NNNNNN.. Valid values are `^PLT-[0-9]{4}-[0-9]{6}$`',
    `assignment_status` STRING COMMENT 'Current lifecycle state of the pilotage assignment. Tracks progression from scheduling through active pilotage to completion or cancellation. [ENUM-REF-CANDIDATE: scheduled|active|completed|cancelled|diverted|suspended — promote to reference product if additional states are required]. Valid values are `scheduled|active|completed|cancelled|diverted|suspended`',
    `billing_status` STRING COMMENT 'Current billing status of the pilotage assignment. Tracks the progression from service completion through invoicing to payment or dispute resolution. Feeds into the port billing and tariff management system.. Valid values are `pending|invoiced|paid|disputed|waived`',
    `boarding_method` STRING COMMENT 'Method used for pilot transfer to the vessel. Determines safety compliance requirements under SOLAS and informs launch boat dispatch scheduling.. Valid values are `pilot_boat|helicopter|ladder|gangway`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the pilotage assignment record was first created in the system. Supports audit trail, data lineage, and SLA measurement from scheduling to execution.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the pilotage service charge amount (e.g., USD, EUR, SGD). Supports multi-currency port operations and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `deviation_from_passage_plan` BOOLEAN COMMENT 'Indicates whether the pilot deviated from the approved passage plan during the pilotage. Triggers mandatory deviation narrative entry and may require post-incident review under SOLAS Chapter V.',
    `deviation_reason` STRING COMMENT 'Narrative description of the reason for any deviation from the approved passage plan. Mandatory when deviation_from_passage_plan is True. Supports SOLAS Chapter V compliance and post-incident analysis.',
    `incident_reference` STRING COMMENT 'Reference number of the associated marine incident record when incident_reported is True. Links pilotage assignment to the incident management record for investigation and regulatory reporting.',
    `incident_reported` BOOLEAN COMMENT 'Indicates whether a marine incident was reported during or as a result of this pilotage assignment. Triggers mandatory incident record creation and P&I club notification workflow.',
    `isps_compliance_verified` BOOLEAN COMMENT 'Indicates whether ISPS Code security compliance was verified for the vessel prior to commencement of pilotage. Mandatory check under ISPS Code Part A for port facility security.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the pilotage assignment record was last modified. Supports change tracking, data lineage, and Silver layer incremental processing in the Databricks Lakehouse.',
    `min_ukc_recorded_m` DECIMAL(18,2) COMMENT 'Minimum Under-Keel Clearance (UKC) recorded during the pilotage passage in metres. Critical safety metric for SOLAS compliance and post-passage audit. Must meet or exceed route UKC requirements.',
    `passage_distance_nm` DECIMAL(18,2) COMMENT 'Total distance of the pilotage passage in nautical miles as recorded upon completion. Used for billing, performance benchmarking, and route validation.',
    `passage_narrative` STRING COMMENT 'Structured narrative of the pilotage passage including key helm orders, manoeuvres, waypoints transited, and significant events. Forms part of the official pilotage completion log for SOLAS compliance and post-incident analysis.',
    `pi_club_notified` BOOLEAN COMMENT 'Indicates whether the vessels Protection and Indemnity (P&I) club has been notified of an incident arising from this pilotage assignment. Required for insurance and liability management.',
    `pilot_licence_class` STRING COMMENT 'Classification of the pilots licence indicating the scope of authorisation (e.g., vessel size limits, route restrictions). Ensures the assigned pilot holds the appropriate licence class for the vessel and route.. Valid values are `class_1|class_2|class_3|trainee`',
    `pilot_off_vessel_timestamp` TIMESTAMP COMMENT 'Timestamp when the pilot disembarked the vessel, marking the official end of the pilotage service. Used for billing duration calculation and service completion logging.',
    `pilot_on_board_timestamp` TIMESTAMP COMMENT 'Timestamp when the pilot assumed navigational advisory responsibility on the bridge, marking the official commencement of the pilotage service. Distinct from boarding time if transfer involved a pilot ladder or boat.',
    `scheduled_boarding_timestamp` TIMESTAMP COMMENT 'Planned date and time at which the pilot is scheduled to board the vessel at the boarding station. Used for pilot dispatch planning and Vessel Traffic Service (VTS) coordination.',
    `scheduled_disembarkation_timestamp` TIMESTAMP COMMENT 'Planned date and time at which the pilot is scheduled to disembark the vessel at the disembarkation point. Used for pilot rotation planning and launch boat scheduling.',
    `service_charge_amount` DECIMAL(18,2) COMMENT 'Gross pilotage service charge amount in the ports operating currency, calculated based on the applicable tariff code, vessel DWT, and passage distance. Used for invoice generation and revenue reporting.',
    `service_type` STRING COMMENT 'Classification of the pilotage service indicating the nature of the vessel movement: inbound (arrival), outbound (departure), shifting (berth-to-berth), canal transit, or anchorage movement.. Valid values are `inbound|outbound|shifting|canal_transit|anchorage`',
    `speed_over_ground_avg_knots` DECIMAL(18,2) COMMENT 'Average speed over ground in knots recorded during the pilotage passage. Used for passage time analysis, route compliance, and post-incident review.',
    `tidal_window_end` TIMESTAMP COMMENT 'End of the approved tidal window within which the pilotage must be completed to ensure adequate Under-Keel Clearance (UKC) along the assigned route.',
    `tidal_window_start` TIMESTAMP COMMENT 'Start of the approved tidal window within which the pilotage must commence to ensure adequate Under-Keel Clearance (UKC) along the assigned route.',
    `tide_height_m` DECIMAL(18,2) COMMENT 'Predicted or observed tide height in metres at the time of pilotage commencement. Used for Under-Keel Clearance (UKC) calculation and tidal window compliance.',
    `tug_count` STRING COMMENT 'Number of tugs deployed to assist the vessel during the pilotage. Determined by pilot based on vessel size, weather conditions, and berth configuration. Used for towage billing and resource planning.',
    `tug_required` BOOLEAN COMMENT 'Indicates whether tug assistance was required for this pilotage assignment based on vessel characteristics, weather conditions, or port authority requirements.',
    `vhf_channel_primary` STRING COMMENT 'Primary VHF radio channel used for communication between the pilot and Vessel Traffic Service (VTS) during the pilotage passage. Recorded for communications audit and incident investigation.. Valid values are `^CH[0-9]{2}[A-Z]?$`',
    `visibility_nm` DECIMAL(18,2) COMMENT 'Observed meteorological visibility in nautical miles at the time of pilotage. Used for safety assessment, radar pilotage determination, and COLREGS compliance logging.',
    `vts_reporting_point_count` STRING COMMENT 'Number of mandatory Vessel Traffic Service (VTS) reporting points transited during the pilotage passage. Used for VTS compliance verification and passage plan adherence assessment.',
    `wind_direction_degrees` DECIMAL(18,2) COMMENT 'Observed wind direction in degrees true (0-360) at the time of pilotage commencement. Used alongside wind speed for manoeuvring assessment and tug deployment decisions.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Observed wind speed in knots at the time of pilotage commencement. Recorded for safety assessment, tug requirement determination, and post-incident analysis.',
    CONSTRAINT pk_pilotage_assignment PRIMARY KEY(`pilotage_assignment_id`)
) COMMENT 'SSOT for the complete pilotage service lifecycle from scheduling through execution to completion log. Captures assignment details (scheduled/actual boarding and disembarkation times, POB/POF timestamps, boarding station, vessel LOA/DWT, tide and weather conditions, service status), approved pilotage route reference data (route code, waypoints, distance, UKC requirements, speed restrictions, tidal windows, VTS reporting points), and completion log (passage narrative, waypoints transited, helm orders, speed over ground, under-keel clearance readings, VHF usage, tug assistance, deviations from passage plan, pilot remarks). Supports SOLAS Chapter V compliance and post-incident analysis.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` (
    `pilot_id` BIGINT COMMENT 'Unique surrogate identifier for each licensed marine pilot record in the port authority system. Primary key for the pilot master data product.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Pilot licensing authority verification, STCW certification validation, and port access credential issuance require country master data (IMO member status, STCW ratification) for regulatory compliance.',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Pilots are licensed and operate within specific port jurisdictions. Port authorities issue pilot licenses, maintain pilot rosters, and manage deployment zones. Essential for license validation, regula',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Pilots are covered by specific labour agreements governing pay, conditions, and entitlements - real industrial relations requirement enabling payroll calculation and entitlement management.',
    `competency_class` STRING COMMENT 'IMO-recognised competency class of the pilot licence, defining the category of vessels and waterways the pilot is authorised to handle (e.g., Class 1, Class 2, Class 3). Determines assignment eligibility in VTMS scheduling. [ENUM-REF-CANDIDATE: Class 1|Class 2|Class 3|Class 4|Class 5 — promote to reference product]',
    `date_of_birth` DATE COMMENT 'Date of birth of the pilot. Used for age verification, mandatory retirement age compliance, and medical fitness scheduling under national maritime authority regulations.',
    `deep_sea_pilot_endorsement` BOOLEAN COMMENT 'Indicates whether the pilot holds a deep sea pilotage endorsement, authorising operations beyond the standard port approach limits. Relevant for ports with extended pilotage districts.',
    `duty_status` STRING COMMENT 'Current operational duty status of the pilot indicating availability for pilotage assignments. Drives real-time scheduling logic in the Vessel Traffic Management System (VTMS). Values: on_duty (actively available), off_duty (not available), standby (on-call), leave (approved absence), suspended (regulatory action), retired (no longer active).. Valid values are `on_duty|off_duty|standby|leave|suspended|retired`',
    `emergency_contact_name` STRING COMMENT 'Full name of the pilots designated emergency contact person. Required for safety and incident management procedures under SOLAS and OHS regulations.',
    `emergency_contact_phone` STRING COMMENT 'Phone number of the pilots designated emergency contact. Used by port operations and marine services teams in the event of an incident or emergency involving the pilot.',
    `emergency_contact_relationship` STRING COMMENT 'Relationship of the emergency contact person to the pilot (e.g., spouse, parent, sibling). Provides context for emergency communications.. Valid values are `spouse|parent|sibling|child|friend|other`',
    `employment_type` STRING COMMENT 'Classification of the pilots employment arrangement with the port authority. Determines applicable HR policies, entitlements, and billing arrangements. Values: permanent, contract, casual, seconded.. Valid values are `permanent|contract|casual|seconded`',
    `english_proficiency_level` STRING COMMENT 'Assessed level of English language proficiency for maritime communications, as English is the IMO-mandated working language for international pilotage. Values: basic, operational, proficient, expert.. Valid values are `basic|operational|proficient|expert`',
    `full_name` STRING COMMENT 'Full legal name of the licensed marine pilot as recorded on the pilot licence and identity documents. Used for scheduling, manifests, and regulatory reporting.',
    `incident_count_ytd` STRING COMMENT 'Number of marine incidents or near-misses recorded against this pilot in the current calendar year. Used for safety performance monitoring, P&I club notifications, and SOLAS/MARPOL compliance reporting. Not a calculated KPI — sourced directly from the incident management system.',
    `isps_clearance_level` STRING COMMENT 'ISPS security clearance level granted to the pilot, determining access permissions to restricted port areas and vessels. Aligned with the ISPS Code security framework. Values: level_1 (normal), level_2 (heightened), level_3 (exceptional).. Valid values are `level_1|level_2|level_3`',
    `issuing_authority` STRING COMMENT 'Name of the national maritime authority or regulatory body that issued the pilot licence (e.g., Australian Maritime Safety Authority, Maritime and Port Authority of Singapore). Required for regulatory correspondence and PSC inspections.',
    `language_proficiencies` STRING COMMENT 'Comma-separated list of ISO 639-1 language codes representing languages in which the pilot is proficient for maritime communications. IMO requires English as the working language; additional languages support multi-national vessel operations. Example: EN,ZH,AR.',
    `last_incident_date` DATE COMMENT 'Date of the most recent marine incident or near-miss recorded against this pilot. Used for safety trend analysis and to trigger mandatory review processes under SOLAS and port safety procedures.',
    `licence_expiry_date` DATE COMMENT 'Date on which the pilots current licence expires and must be renewed. Used for proactive renewal alerts and to prevent scheduling of pilots with lapsed licences.',
    `licence_issue_date` DATE COMMENT 'Date on which the current pilot licence was issued by the national maritime authority. Used for licence tenure tracking and regulatory audit trails.',
    `licence_number` STRING COMMENT 'Officially issued pilot licence number assigned by the national maritime authority. Serves as the primary external business identifier for the pilot across regulatory and operational systems including VTMS and PCS.',
    `licence_status` STRING COMMENT 'Current regulatory status of the pilots licence as maintained by the national maritime authority. Determines whether the pilot is legally authorised to conduct pilotage operations. Values: active, expired, suspended, revoked, pending_renewal.. Valid values are `active|expired|suspended|revoked|pending_renewal`',
    `max_dwt_mt` DECIMAL(18,2) COMMENT 'Maximum vessel Deadweight Tonnage (DWT) in metric tonnes that this pilot is authorised to handle. Used alongside LOA and GRT limits to determine vessel assignment eligibility in VTMS scheduling.',
    `max_grt` DECIMAL(18,2) COMMENT 'Maximum vessel Gross Registered Tonnage (GRT) that this pilot is authorised to handle. Complements LOA and DWT limits for comprehensive vessel size authorisation management.',
    `max_loa_m` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall (LOA) in metres that this pilot is authorised to handle, as specified on the pilot licence. Used by VTMS to validate pilot-vessel assignment eligibility.',
    `medical_cert_expiry_date` DATE COMMENT 'Date on which the pilots current medical fitness certificate expires. Triggers renewal workflow and prevents scheduling of pilots with expired medical certificates.',
    `medical_cert_number` STRING COMMENT 'Reference number of the pilots current medical fitness certificate issued by an approved medical examiner. Used for regulatory verification and audit purposes.',
    `medical_cert_status` STRING COMMENT 'Current status of the pilots medical fitness certificate as required under maritime health standards. A valid certificate is a prerequisite for active pilotage duty. Values: valid, expired, suspended, pending_review.. Valid values are `valid|expired|suspended|pending_review`',
    `night_pilotage_authorised` BOOLEAN COMMENT 'Indicates whether the pilot is authorised to conduct pilotage operations during night-time hours. Some pilots may have restrictions based on experience level or port-specific regulations.',
    `pilotage_commencement_date` DATE COMMENT 'Date on which the pilot first commenced licensed pilotage operations at this port. Used to calculate seniority, experience tenure, and for workforce planning analytics.',
    `pni_club_notified` BOOLEAN COMMENT 'Indicates whether the ports Protection and Indemnity (P&I) club has been notified of any incident involving this pilot. Required for liability management and insurance claim processing.',
    `port_authority_employee_number` STRING COMMENT 'Internal employee or contractor reference number assigned by the port authoritys HR system (Oracle HCM Cloud). Links the pilot master record to the workforce management system for payroll, scheduling, and HR administration.',
    `radar_arpa_endorsement` BOOLEAN COMMENT 'Indicates whether the pilot holds a valid Radar/ARPA endorsement, confirming competency in radar navigation and collision avoidance systems. Required for pilotage in restricted visibility conditions.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the pilot master record was first created in the system. Provides the audit trail creation point for data governance and regulatory compliance purposes.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the pilot master record was most recently updated. Supports data lineage tracking, change auditing, and Silver layer incremental processing in the Databricks Lakehouse.',
    `refresher_training_due_date` DATE COMMENT 'Date by which the pilot must complete the next mandatory refresher or recurrent training programme. Triggers training scheduling workflows and compliance alerts.',
    `remarks` STRING COMMENT 'Free-text field for operational notes, special conditions, or administrative remarks pertaining to the pilot record. May include details on licence restrictions, special authorisations, or operational caveats not captured in structured fields.',
    `simulator_training_date` DATE COMMENT 'Date on which the pilot last completed mandatory bridge simulator training. Used to track recurrent training compliance and schedule upcoming simulator sessions per IMO and national authority requirements.',
    `stcw_cert_expiry_date` DATE COMMENT 'Expiry date of the pilots STCW certificate. Drives compliance monitoring and renewal scheduling to ensure continuous regulatory validity.',
    `stcw_cert_number` STRING COMMENT 'Certificate number issued under the STCW Convention confirming the pilot meets international standards for training, certification, and watchkeeping. Required for IMO compliance and PSC inspections.',
    `vhf_radio_operator_cert` BOOLEAN COMMENT 'Indicates whether the pilot holds a valid VHF (Very High Frequency) radio operator certificate, required for maritime communications during pilotage operations. True = certificate held and valid.',
    `years_of_experience` STRING COMMENT 'Total number of years of active pilotage experience accumulated by the pilot. Used for competency assessment, assignment prioritisation for complex manoeuvres, and workforce analytics.',
    CONSTRAINT pk_pilot PRIMARY KEY(`pilot_id`)
) COMMENT 'Master record for each licensed marine pilot authorised to conduct pilotage operations at the port. Captures pilot licence number, IMO-recognised competency class, authorised vessel size limits (LOA, DWT, GRT), authorised fairway sections, licence expiry date, medical fitness certificate status, language proficiencies, emergency contact, and current duty status. SSOT for pilot identity, qualifications, and authorisation data.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` (
    `towage_order_id` BIGINT COMMENT 'Unique system-generated identifier for each towage service order record. Primary key for the towage_order data product.',
    `agent_appointment_id` BIGINT COMMENT 'Reference to the shipping agent or vessel operator who requested the towage service. Primary party reference linking the towage order to the commercial counterparty responsible for the vessel.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Tugs service vessels at anchorage for shifting, emergency response, and pre-berthing preparation. Common maritime operation requiring anchorage identification for dispatch and billing.',
    `berth_id` BIGINT COMMENT 'Reference to the berth or terminal location that is the origin or destination of the towage movement. Used for berth allocation planning and towage route coordination.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Tugs escort vessels through channels; towage planning requires channel depth, width, tidal restrictions, and navigational aid coordination. Critical for safe vessel movements and resource allocation.',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: ISPS security level at the facility directly governs towage authorization — elevated security levels restrict tug movements and boarding procedures. Port security officers reference the active ISPS fa',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Towage services are contracted with rates, volume commitments, and performance targets defined in agreements. Required for tariff application, SLA compliance tracking, and billing. Core commercial rel',
    `pilot_id` BIGINT COMMENT 'Reference to the marine pilot assigned to the vessel during the towage operation. Towage and pilotage are coordinated services; the pilot directs tug movements during berthing/unberthing.',
    `pilotage_assignment_id` BIGINT COMMENT 'Reference to a marine incident record if an incident occurred during the towage operation. Null if no incident was recorded. Links to the marine incident management data product.',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Tugs are depreciable port assets requiring lifecycle tracking in asset register for financial reporting, capex planning, insurance valuation, and disposal decisions. Towage orders need asset register ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Towage services are delivered by specific operational cost centres (marine services, harbour operations). Required for activity-based costing, budget tracking, and operational cost allocation in port ',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Towage charge calculation (towage_charge_amount) is governed by port tariff rate bands. Port billing teams must link each towage order to the applicable port_tariff schedule to compute and audit charg',
    `call_id` BIGINT COMMENT 'FK to vessel.call.call_id — Marine service billing and operational coordination require linking towage orders to the vessel call being serviced. Without this, towage cannot be reconciled to vessel visits.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Towage orders are raised by shipping agents who are port community participants. Direct link supports agent authorization checks, credit limit validation, billing account lookup, and service request t',
    `service_order_id` BIGINT COMMENT 'Foreign key linking to marine.marine_service_order. Business justification: Towage order is the operational execution of towage services ordered via marine_service_order. The marine_service_order product has towage_required flag, number_of_tugs, and tug_horsepower_required, i',
    `surcharge_rule_id` BIGINT COMMENT 'Foreign key linking to tariff.surcharge_rule. Business justification: Towage orders with imdg_hazmat_flag or night/weekend operations trigger specific surcharge rules (hazmat surcharge, overtime surcharge). Recording the applicable surcharge_rule on the towage order is ',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Towage planning and tug assignment calculations require vessel master data (LOA, beam, DWT, GRT) for bollard pull determination, tariff calculation, and P&I club verification. Removes denormalized ves',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Towage tariff calculation, tug count determination, and bollard pull requirements depend on vessel type classification (container, tanker, bulk carrier) for service specification and pricing. Vessel t',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Voyage-level towage cost reporting and pre-arrival planning: towage orders are planned and billed at voyage level. Port finance and operations teams aggregate towage charges per voyage for disbursemen',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: High-risk towage operations (heavy weather, restricted visibility, hazmat vessels, confined spaces) require permits to work. Safety systems link permits to towage orders for authorization tracking, ri',
    `abort_reason` STRING COMMENT 'Free-text description of the reason for aborting or cancelling the towage operation. Mandatory when service_outcome is aborted or cancelled. Used for root cause analysis and operational improvement.',
    `actual_commencement` TIMESTAMP COMMENT 'Actual date and time when the towage operation commenced, defined as first tug line made fast to the vessel. Used for KPI measurement, billing, and SLA compliance reporting.',
    `actual_completion` TIMESTAMP COMMENT 'Actual date and time when the towage operation was completed, defined as last tug line cast off from the vessel. Used for duration calculation, billing, and KPI reporting.',
    `billing_status` STRING COMMENT 'Current billing and invoicing status of the towage order. pending = charge calculated but not yet invoiced; invoiced = invoice raised; disputed = charge under dispute; paid = payment received; waived = charge waived by port authority.. Valid values are `pending|invoiced|disputed|paid|waived`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the towage order record was first created in the data platform. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the towage charge amount (e.g., USD, EUR, SGD, AUD). Required for multi-currency port operations and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `current_speed_knots` DECIMAL(18,2) COMMENT 'Recorded tidal current speed in knots at the berth or channel location at the time of towage. Critical environmental parameter influencing tug power requirements and safety assessment.',
    `duration_minutes` STRING COMMENT 'Total duration of the towage operation in minutes, calculated from actual_commencement to actual_completion. Used for billing, performance benchmarking, and port throughput analytics.',
    `imdg_hazmat_flag` BOOLEAN COMMENT 'Indicates whether the vessel is carrying International Maritime Dangerous Goods (IMDG) classified hazardous cargo at the time of towage. True = hazardous cargo on board. Influences tug safety protocols and emergency response readiness.',
    `min_bollard_pull_tonnes` DECIMAL(18,2) COMMENT 'Minimum total bollard pull force in metric tonnes required for the towage operation, calculated based on vessel DWT, environmental conditions, and port-specific towage assessment criteria.',
    `order_reference` STRING COMMENT 'Externally-known human-readable reference number assigned to the towage order, used in communications with shipping agents, tug operators, and port authority. Format: TOW-YYYY-NNNNNN.. Valid values are `^TOW-[0-9]{4}-[0-9]{6}$`',
    `order_status` STRING COMMENT 'Current lifecycle status of the towage order. requested = initial request received; confirmed = tugs allocated and confirmed; in_progress = towage operation underway; completed = service successfully delivered; aborted = commenced but terminated early; cancelled = cancelled before commencement.. Valid values are `requested|confirmed|in_progress|completed|aborted|cancelled`',
    `port_code` STRING COMMENT 'UN/LOCODE five-character port code identifying the port where the towage service is performed. Supports multi-port operations and regulatory reporting to IMO and national maritime authorities.. Valid values are `^[A-Z]{2}[A-Z0-9]{3}$`',
    `requested_timestamp` TIMESTAMP COMMENT 'Date and time when the towage service was formally requested by the shipping agent or vessel operator. Principal business event timestamp marking the start of the towage order lifecycle.',
    `safety_observation_flag` BOOLEAN COMMENT 'Indicates whether a safety observation, near-miss, or safety concern was recorded during the towage operation. True = safety observation exists. Triggers mandatory safety review process per SOLAS and ISPS requirements.',
    `safety_observation_notes` STRING COMMENT 'Free-text description of any safety observations, near-misses, or hazards identified during the towage operation. Populated when safety_observation_flag is True. Used for safety management system reporting.',
    `scheduled_commencement` TIMESTAMP COMMENT 'Planned date and time for the towage operation to commence, aligned with the vessels Estimated Time of Berthing (ETB) or Estimated Time of Departure (ETD) schedule.',
    `service_outcome` STRING COMMENT 'Final outcome of the towage service delivery. completed = full service delivered successfully; aborted = commenced but terminated before completion; cancelled = cancelled before commencement; partial = service partially delivered due to operational constraints.. Valid values are `completed|aborted|cancelled|partial`',
    `shipping_line_code` STRING COMMENT 'Standard Carrier Alpha Code (SCAC) of the shipping line or vessel operator on whose behalf the towage is requested. Four-letter uppercase code per NMFTA standard.. Valid values are `^[A-Z]{4}$`',
    `special_instructions` STRING COMMENT 'Free-text field for any special operational instructions, constraints, or requirements for the towage operation, such as restricted manoeuvring areas, hazardous cargo considerations, or vessel-specific handling notes.',
    `towage_charge_amount` DECIMAL(18,2) COMMENT 'Gross towage service charge amount in the ports base currency, calculated per the applicable port tariff schedule based on vessel GRT, towage type, duration, and number of tugs. Used for billing and revenue reporting.',
    `towage_type` STRING COMMENT 'Classification of the towage operation by purpose. arrival = vessel inbound to berth; departure = vessel outbound from berth; shifting = vessel moving between berths within port; emergency = unplanned emergency towage; dry_dock = towage to/from dry dock facility.. Valid values are `arrival|departure|shifting|emergency|dry_dock`',
    `tug_attachment_bow` BOOLEAN COMMENT 'Indicates whether a tug is required to be attached at the bow (forward) of the vessel as part of the towage configuration. True = bow tug required.',
    `tug_attachment_breast` BOOLEAN COMMENT 'Indicates whether a tug is required to be attached breast (alongside) the vessel as part of the towage configuration. True = breast tug required.',
    `tug_attachment_stern` BOOLEAN COMMENT 'Indicates whether a tug is required to be attached at the stern (aft) of the vessel as part of the towage configuration. True = stern tug required.',
    `tugs_assigned` STRING COMMENT 'Actual number of tug vessels assigned and dispatched for the towage operation. May differ from tugs_required if operational adjustments are made.',
    `tugs_required` STRING COMMENT 'Total number of tug vessels required to safely execute the towage operation as determined by the ports towage assessment based on vessel LOA, DWT, wind, and current conditions.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when the towage order record was last modified. Used for change tracking, incremental data loads, and audit compliance.',
    `visibility_category` STRING COMMENT 'Meteorological visibility category at the time of towage commencement. good = >5nm; moderate = 2-5nm; poor = 0.5-2nm; very_poor = <0.5nm. Used for safety risk assessment and incident reporting.. Valid values are `good|moderate|poor|very_poor`',
    `wind_direction` STRING COMMENT 'Recorded wind direction using 16-point compass bearing at the time of towage commencement. Used in conjunction with wind speed for environmental condition assessment and safety reporting.. Valid values are `^(N|NNE|NE|ENE|E|ESE|SE|SSE|S|SSW|SW|WSW|W|WNW|NW|NNW)$`',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Recorded wind speed in knots at the time of towage commencement. Environmental condition captured for safety assessment, incident investigation, and towage risk analysis.',
    CONSTRAINT pk_towage_order PRIMARY KEY(`towage_order_id`)
) COMMENT 'Transactional record for each towage service request and execution within port waters. Captures requesting shipping line or vessel agent, vessel details (name, IMO, LOA, DWT), number and class of tugs required, bollard pull requirements, tug attachment configuration (bow, stern, breast), towage commencement and completion timestamps, tug master identifiers, weather conditions, service outcome (completed, aborted, cancelled), and any safety observations. Links to individual tug_assignment records for multi-tug operations. SSOT for towage service delivery events.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`tug` (
    `tug_id` BIGINT COMMENT 'Unique surrogate identifier for each tug vessel record in the ports marine services master data. Primary key for the tug asset identity table. Entity role: MASTER_RESOURCE.',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Tug regulatory compliance, PSC inspection targeting, and flag state survey requirements depend on flag state master data (PSC targeting factor, flag state authority, MOU membership) for operational co',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Tugs are both operational vessels (marine domain) and depreciable capital assets (asset domain). Asset register tracks acquisition cost, depreciation, book value, disposal planning, and insurance valu',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Tugs with ownership_type = contracted or leased are provided by external vendors. This FK enables linking contracted tug assets to vendor records for contract management, invoicing, and performanc',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Tugs are registered and operate within specific port jurisdictions. Port authorities maintain tug registries, issue operating permits, manage emergency response planning, and enforce safety regulation',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Tugs are capital assets requiring depreciation, maintenance capex tracking, insurance valuation, and asset register compliance. Core fixed asset management requirement for maritime fleet financial rep',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: Tug vessel registration documentation and flag state authority reporting require a standardized port of registry reference. tug.port_of_registry is a free-text denormalization; linking to un_locode pr',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Tugs are vessels requiring vessel master data (classification society, P&I club, flag state authority, PSC inspection history) for regulatory compliance, insurance verification, and operational status',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Tug classification (harbor tug, ocean-going tug, AHTS, escort tug) requires vessel type master data for capability categorization, tariff classification, and service assignment matching. Tug_type fiel',
    `ahts_capable` BOOLEAN COMMENT 'Indicates whether the tug vessel is equipped and certified for anchor handling and towing supply (AHTS) operations, including offshore anchor deployment and retrieval. True = AHTS capable; False = harbour towage only. Relevant for ports serving offshore oil and gas support operations.',
    `ais_transponder_class` STRING COMMENT 'Class of the Automatic Identification System (AIS) transponder fitted on the tug vessel. Class A transponders are mandatory for SOLAS vessels and provide full dynamic data; Class B transponders are used on smaller non-SOLAS vessels with reduced transmission frequency. Determines the vessels real-time tracking capability within the ports VTS system.. Valid values are `Class A|Class B`',
    `beam_m` DECIMAL(18,2) COMMENT 'Maximum breadth (beam) of the tug vessel in metres measured at the widest point of the hull. Used in navigation clearance calculations, dry dock planning, and assessing compatibility with port infrastructure such as lock chambers and fendering systems.',
    `bollard_pull_tonnes` DECIMAL(18,2) COMMENT 'Certified static bollard pull force of the tug in metric tonnes, as measured and certified under controlled test conditions. The principal performance metric used to match tug capability to vessel assistance requirements based on the assisted vessels DWT, LOA, and environmental conditions. Critical for berth allocation planning and safe towage operations.',
    `build_shipyard` STRING COMMENT 'Name of the shipyard where the tug vessel was constructed. Retained for asset provenance records, warranty claims, technical documentation retrieval, and historical maintenance reference in Maximo Asset Management.',
    `call_sign` STRING COMMENT 'International radio call sign assigned to the tug vessel by the flag state telecommunications authority. Used for VHF radio communications with Vessel Traffic Service (VTS) and port control during towage and escort operations.. Valid values are `^[A-Z0-9]{4,7}$`',
    `class_notation` STRING COMMENT 'Full classification notation string assigned by the classification society, describing the vessels structural class, machinery class, and any additional notations (e.g., fire-fighting, escort, ice class). Provides a concise technical summary of the vessels certified capabilities and construction standards.',
    `class_survey_due_date` DATE COMMENT 'Date by which the next mandatory classification society survey (annual, intermediate, or special/renewal) must be completed to maintain the vessels class certificate in good standing. Used in maintenance planning and operational availability forecasting in Maximo Asset Management.',
    `classification_society` STRING COMMENT 'Name of the international classification society (e.g., Lloyds Register, DNV, Bureau Veritas, ABS, ClassNK) that has classed the tug vessel and issues its class certificates. Determines the survey regime, structural standards, and equipment certification applicable to the vessel.',
    `commissioned_date` DATE COMMENT 'Date on which the tug vessel was formally commissioned into service at the port, either as a new build delivery or upon commencement of a charter/contract arrangement. Marks the start of the vessels operational lifecycle record in Maximo Asset Management and the ports marine services SSOT.',
    `contract_end_date` DATE COMMENT 'Date on which the current charter or service contract for the tug vessel is scheduled to expire. Nullable for open-ended arrangements. Used to trigger contract renewal workflows and ensure continuity of towage service capacity planning.',
    `contract_start_date` DATE COMMENT 'Date on which the current charter or service contract for the tug vessel became effective. Applicable for chartered or contracted tugs. Used in commercial management, billing cycle determination, and contract renewal planning in SAP S/4HANA.',
    `crew_complement` STRING COMMENT 'Minimum number of crew members required to safely operate the tug vessel as specified in the vessels Safe Manning Certificate issued by the flag state. Used in workforce planning, shift rostering, and compliance with ILO Maritime Labour Convention (MLC 2006) crewing requirements.',
    `decommissioned_date` DATE COMMENT 'Date on which the tug vessel was formally withdrawn from service at the port, either permanently or for an extended lay-up period. Nullable for vessels currently in service. Used to close the asset lifecycle record and trigger final compliance and financial close-out processes.',
    `draught_m` DECIMAL(18,2) COMMENT 'Maximum operational draught of the tug vessel in metres. Used to assess navigability in shallow harbour areas, tidal windows for operations, and compliance with port water depth restrictions. Critical for safe operations in ports with tidal or dredging constraints.',
    `engine_power_kw` DECIMAL(18,2) COMMENT 'Total installed main engine power output of the tug vessel measured in kilowatts (kW). Used alongside bollard pull rating to assess tug capability, fuel consumption planning, and compliance with port emission standards. Sourced from the vessels engine certificate and classification society records.',
    `escort_bollard_pull_tonnes` DECIMAL(18,2) COMMENT 'Certified escort bollard pull force in metric tonnes, measured under dynamic escort conditions as distinct from static bollard pull. Applicable only to escort-certified tugs. Used to determine the maximum DWT of tankers and gas carriers the tug can safely escort through the port approach channel.',
    `escort_certified` BOOLEAN COMMENT 'Indicates whether the tug vessel holds a valid escort tug certification from its classification society, confirming it meets the structural, stability, and equipment standards required for escort towage of large tankers and gas carriers in restricted waterways. True = certified for escort operations; False = not certified.',
    `fifi_class` STRING COMMENT 'IMO/classification society fire-fighting system class notation of the tug vessel. FiFi1 denotes basic fire-fighting capability; FiFi1+WS includes water spray; FiFi2 and FiFi3 denote progressively higher capacity systems. none indicates no certified fire-fighting equipment. Determines eligibility for fire-fighting standby duties and emergency response assignments in the port.. Valid values are `FiFi1|FiFi1+WS|FiFi2|FiFi3|none`',
    `fuel_type` STRING COMMENT 'Primary fuel type used by the tug vessels main engines. HFO = Heavy Fuel Oil; MGO = Marine Gas Oil; MDO = Marine Diesel Oil; LNG = Liquefied Natural Gas; methanol = methanol fuel; hybrid = dual-fuel or battery-hybrid arrangement. Used in emissions reporting under MARPOL Annex VI, GHG tracking, and port environmental management.. Valid values are `HFO|MGO|MDO|LNG|methanol|hybrid`',
    `gross_tonnage` DECIMAL(18,2) COMMENT 'Gross Registered Tonnage (GRT) of the tug vessel as certified under the International Convention on Tonnage Measurement of Ships. Used for port dues calculation, PSC inspection scheduling, and regulatory reporting to maritime authorities.',
    `ice_class` STRING COMMENT 'Ice class notation assigned by the classification society indicating the tug vessels structural capability to operate in ice-covered waters. Ranges from IA Super (highest) to ID (lowest ice class) or none for no ice capability. Relevant for ports in seasonal ice regions and for compliance with IACS Polar Class requirements.. Valid values are `IA Super|IA|IB|IC|ID|none`',
    `isps_cert_expiry` DATE COMMENT 'Expiry date of the International Ship Security Certificate (ISSC) issued under the ISPS Code. Confirms the vessel has an approved Ship Security Plan and complies with SOLAS Chapter XI-2 security requirements. Required for port access and monitored by port facility security officers.',
    `last_dry_dock_date` DATE COMMENT 'Date on which the tug vessel most recently completed a dry docking for hull inspection, underwater maintenance, and classification society survey. Used in maintenance planning to calculate the next scheduled dry dock and assess hull condition for operational readiness.',
    `loa_m` DECIMAL(18,2) COMMENT 'Length Overall (LOA) of the tug vessel in metres, measured from the foremost point to the aftermost point of the hull. Used in berth planning, harbour navigation clearance assessments, and determining operational constraints within the port basin.',
    `marpol_cert_expiry` DATE COMMENT 'Expiry date of the vessels MARPOL compliance certificate (International Oil Pollution Prevention Certificate or equivalent), confirming the tug meets IMO Marine Pollution Convention requirements for prevention of pollution from ships. Monitored for environmental compliance and PSC inspection readiness.',
    `max_speed_knots` DECIMAL(18,2) COMMENT 'Maximum service speed of the tug vessel in knots under normal operating conditions. Used in marine service scheduling to calculate transit times to vessel rendezvous positions, optimise tug dispatch timing, and assess response capability for emergency towage.',
    `mmsi_number` STRING COMMENT 'Nine-digit Maritime Mobile Service Identity number used for Automatic Identification System (AIS) transmissions and Digital Selective Calling (DSC) communications. Enables real-time vessel tracking via VTS and port monitoring systems.. Valid values are `^[0-9]{9}$`',
    `tug_name` STRING COMMENT 'Official registered name of the tug vessel as recorded on the vessels certificate of registry. Used as the primary human-readable identity label in port operations, VTS communications, and marine service scheduling.',
    `net_tonnage` DECIMAL(18,2) COMMENT 'Net Registered Tonnage (NRT) of the tug vessel as certified under the International Convention on Tonnage Measurement of Ships. Represents the vessels earning capacity and is used in certain port tariff calculations and regulatory filings.',
    `next_dry_dock_date` DATE COMMENT 'Planned date for the tug vessels next dry docking. Used in long-term maintenance scheduling, operational availability planning, and budget forecasting for CAPEX dry dock expenditure in SAP S/4HANA.',
    `official_number` STRING COMMENT 'National official registration number assigned by the flag state maritime authority at the port of registry. Complements the IMO number as a domestic regulatory identifier used in national maritime administration and port authority records.',
    `operating_company` STRING COMMENT 'Legal name of the company responsible for the day-to-day commercial and technical management and operation of the tug vessel. May be the same as the owning company or a contracted towage operator. Used in service agreements, billing, and ISM Code compliance documentation.',
    `operational_status` STRING COMMENT 'Current lifecycle and availability status of the tug vessel within port marine services operations. available indicates ready for dispatch; assigned indicates currently engaged on a towage or escort job; maintenance indicates undergoing scheduled or unscheduled maintenance; out_of_service indicates temporarily non-operational; laid_up indicates long-term decommissioning or storage.. Valid values are `available|assigned|maintenance|out_of_service|laid_up`',
    `ownership_type` STRING COMMENT 'Classification of the commercial arrangement under which the port or towage operator controls the tug vessel. owned = port authority or operator owns the vessel outright; bareboat_charter = vessel chartered without crew; time_charter = vessel chartered with crew for a fixed period; contracted = third-party towage company provides the vessel under a service contract.. Valid values are `owned|bareboat_charter|time_charter|contracted`',
    `owning_company` STRING COMMENT 'Legal name of the company that holds registered ownership of the tug vessel. May differ from the operating company in cases of bareboat charter or leasing arrangements. Used in commercial contracts, insurance documentation, P&I Club notifications, and port authority vessel registration records.',
    `pi_club` STRING COMMENT 'Name of the Protection and Indemnity (P&I) Club providing third-party liability insurance coverage for the tug vessel. P&I insurance covers liabilities arising from towage operations including collision, pollution, and crew injury. Required for port entry and towage service authorisation under ISPS and port authority regulations.',
    `pi_expiry_date` DATE COMMENT 'Date on which the current P&I Club insurance certificate expires. Used to trigger renewal alerts and ensure continuous insurance coverage. Tugs with expired P&I cover must not be dispatched for towage operations under port authority rules.',
    `pi_policy_number` STRING COMMENT 'Policy or certificate number of the current P&I Club insurance cover for the tug vessel. Used in incident reporting, claims management, and port authority compliance verification. Required to be presented during PSC inspections and port entry clearance.',
    `remarks` STRING COMMENT 'Free-text field for recording operational notes, special conditions, known limitations, or temporary restrictions applicable to the tug vessel that are not captured in structured fields. Examples include temporary equipment deficiencies, operational restrictions imposed by the classification society, or special port authority conditions.',
    `safety_management_cert_expiry` DATE COMMENT 'Expiry date of the Safety Management Certificate (SMC) issued under the ISM Code, confirming the vessels safety management system complies with IMO requirements. Tugs operating under the ISM Code must maintain a valid SMC. Used in compliance monitoring and PSC inspection preparation.',
    `tug_type` STRING COMMENT 'Classification of the tug vessel by propulsion and manoeuvring system design. ASD (Azimuth Stern Drive) tugs offer 360-degree thrust; conventional tugs use fixed propellers; voith tugs use Voith-Schneider cycloidal propellers; tractor tugs use forward-mounted azimuth drives; rotor tugs use a hybrid arrangement. Determines operational capability and assignment suitability for specific towage tasks.. Valid values are `ASD|conventional|voith|tractor|rotor`',
    `year_built` STRING COMMENT 'Calendar year in which the tug vessel was constructed and delivered from the shipyard. Used in asset lifecycle management, maintenance planning, insurance valuation, and assessing compliance with age-related regulatory requirements under PSC and flag state rules.',
    CONSTRAINT pk_tug PRIMARY KEY(`tug_id`)
) COMMENT 'Master record for each tug vessel operated or contracted at the port, including tug name, IMO number, flag state, bollard pull rating (tonnes), engine power (kW), tug type (ASD, conventional, voith), LOA, beam, draught, fire-fighting class (FiFi), escort tug certification, current operational status, and owning/operating company. SSOT for tug asset identity.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` (
    `mooring_operation_id` BIGINT COMMENT 'Unique surrogate identifier for each mooring or unmooring service event recorded in the port. Primary key for the mooring_operation data product.',
    `berth_id` BIGINT COMMENT 'Reference to the berth, buoy, or dolphin at which the mooring operation is performed. Links to the berth/facility master record for infrastructure details.',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: ISPS security level determines mooring gang access permissions, escort requirements, and restricted zone procedures at the berth. Port facility security officers must verify the active ISPS facility r',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Mooring services fall under terminal service agreements with defined rates and SLA targets. Necessary for billing, performance measurement, and dispute resolution. Standard practice in maritime termin',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Mooring operations use SWL-certified equipment (capstans, bollards, quick-release hooks) that must be tracked in asset register for inspection scheduling, failure analysis, and regulatory compliance. ',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Mooring operations are executed for booked vessel calls. Booking specifies mooring requirements that drive gang allocation and scheduling. Essential for operational coordination and billing reconcilia',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Mooring charge calculation (charge_amount) requires the applicable port tariff rate. Port billing teams link mooring operations to port_tariff to validate billable amounts and produce invoices. tariff',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Mooring lines secure to quay wall bollards; structural load calculations, bollard SWL compliance verification, and safety inspections depend on quay wall identification. Engineering and safety require',
    `service_order_id` BIGINT COMMENT 'Reference to the parent marine service order or work order under which this mooring operation was dispatched. Links to the service order management record for billing and scheduling context.',
    `towage_order_id` BIGINT COMMENT 'Foreign key linking to marine.towage_order. Business justification: mooring_operation has a boolean flag `towage_assist_used` indicating that tug assistance was used during the mooring/unmooring operation. Adding a FK towage_order_id to mooring_operation provides dire',
    `call_id` BIGINT COMMENT 'Reference to the vessel call (port visit) record associated with this mooring operation. A vessel call may have multiple mooring operations (arrival, departure, shifts). Links to the vessel_call data product.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Mooring gang sizing, line specification (SWL), and bollard selection require vessel master data (LOA, beam, DWT) for safe mooring operations and SOLAS compliance. Removes denormalized vessel identifie',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Mooring tariff calculation, gang size planning, and line configuration (breast/spring/head lines) are determined by vessel type. Port operations reports and tariff audits group mooring operations by v',
    `billable` BOOLEAN COMMENT 'Indicates whether this mooring operation is subject to a tariff charge to the vessel operator or shipping agent. Non-billable operations may include emergency services or internal port movements.',
    `bollards_used_count` STRING COMMENT 'Number of shore-side bollards engaged during the mooring operation. Used for infrastructure utilisation tracking, SWL compliance, and berth equipment maintenance scheduling in Maximo.',
    `breast_lines_count` STRING COMMENT 'Number of breast lines (mooring lines running perpendicular to the vessels centreline) deployed during the mooring operation. Critical for lateral restraint and SWL compliance verification.',
    `capstans_used` BOOLEAN COMMENT 'Indicates whether shore-side capstans (powered mooring winches) were utilised during this mooring operation to assist in line tensioning and vessel positioning.',
    `charge_amount` DECIMAL(18,2) COMMENT 'Gross charge amount levied for this mooring operation in the ports operating currency, as calculated from the applicable tariff code and gang size/duration. Used for revenue recognition and billing reconciliation.',
    `commencement_timestamp` TIMESTAMP COMMENT 'Date and time when the mooring operation physically commenced, i.e., when the first line was passed or the unmooring sequence began. Principal business event timestamp for this transaction.',
    `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the mooring operation was fully completed, i.e., all lines secured and vessel confirmed fast, or all lines cast off and vessel clear. Used for duration calculation and billing.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this mooring operation record was first created in the system, representing the audit trail creation point. Used for data lineage and compliance auditing.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the charge amount (e.g., USD, AUD, SGD). Supports multi-currency port operations and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `current_speed_knots` DECIMAL(18,2) COMMENT 'Recorded water current speed in knots at the berth location during the mooring operation. Relevant for mooring load assessment and safety compliance.',
    `duration_minutes` STRING COMMENT 'Total elapsed time in minutes from commencement to completion of the mooring operation. Captured as a business field from the operational system for KPI reporting and SLA compliance tracking.',
    `gang_size` STRING COMMENT 'Number of mooring personnel deployed for this operation. Used for resource planning, billing calculation, and compliance with minimum manning requirements.',
    `gang_supervisor` STRING COMMENT 'Name or employee identifier of the supervisor leading the mooring gang for this operation. Used for accountability, incident investigation, and performance management.',
    `head_lines_count` STRING COMMENT 'Number of head lines (forward mooring lines running ahead of the vessel) deployed during the mooring operation. Part of the line configuration record for SWL compliance and operational audit.',
    `incident_ref` STRING COMMENT 'Reference number of the formal marine incident report raised in connection with this mooring operation. Populated when incident_reported is true. Links to the marine incident management record.',
    `incident_reported` BOOLEAN COMMENT 'Indicates whether a formal marine incident report was raised as a result of this mooring operation. When true, the incident is tracked in the marine incident management system aligned with SOLAS and MARPOL requirements.',
    `irregularity_description` STRING COMMENT 'Free-text description of any mooring irregularity, safety observation, equipment deficiency, or non-conformance observed during the operation. Populated when irregularity_observed is true. Used for incident investigation and safety reporting.',
    `irregularity_observed` BOOLEAN COMMENT 'Indicates whether any mooring irregularity, safety observation, or non-conformance was recorded during this operation. When true, details are captured in the irregularity_description field.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this mooring operation record was most recently modified, supporting audit trail requirements and data lineage tracking in the Databricks Silver Layer.',
    `line_material_type` STRING COMMENT 'Material composition of the mooring lines used in this operation. Relevant for SWL compliance verification and equipment condition assessment. HMPE = High Modulus Polyethylene (e.g., Dyneema).. Valid values are `wire|polyester|polypropylene|nylon|HMPE|mixed`',
    `mooring_location_type` STRING COMMENT 'Classification of the physical mooring location type where the vessel is secured: conventional berth alongside a quay, single-point or multi-buoy mooring, dolphin structure, jetty, or open quay face.. Valid values are `berth|buoy|dolphin|jetty|quay`',
    `operation_ref` STRING COMMENT 'Externally-known business reference number assigned to this mooring or unmooring service event, used in billing, port management information system (PMIS) records, and inter-agency communications.. Valid values are `^MOR-[0-9]{4}-[0-9]{6}$`',
    `operation_status` STRING COMMENT 'Current lifecycle state of the mooring operation, tracking progression from planning through execution to completion or cancellation.. Valid values are `planned|in_progress|completed|cancelled|suspended`',
    `operation_type` STRING COMMENT 'Classification of the mooring service performed: mooring (securing vessel on arrival), unmooring (releasing vessel on departure), shifting (moving vessel between berths), or re-mooring (re-securing after adjustment).. Valid values are `mooring|unmooring|shifting|re-mooring`',
    `pi_club_notified` BOOLEAN COMMENT 'Indicates whether the vessels Protection and Indemnity (P&I) Club insurer was notified of an incident or irregularity arising from this mooring operation. Relevant for liability and insurance claim management.',
    `pilot_on_board` BOOLEAN COMMENT 'Indicates whether a marine pilot was on board the vessel during this mooring operation. Relevant for coordination between pilotage and mooring services and for incident liability determination.',
    `quick_release_hooks_used` BOOLEAN COMMENT 'Indicates whether quick-release mooring hooks were deployed during this operation. Quick-release hooks are critical safety equipment for emergency vessel release and are tracked for compliance and maintenance purposes.',
    `spring_lines_count` STRING COMMENT 'Number of spring lines (mooring lines running at an angle fore and aft to prevent surging) deployed during the mooring operation. Part of the full line configuration record.',
    `stern_lines_count` STRING COMMENT 'Number of stern lines (aft mooring lines running astern of the vessel) deployed during the mooring operation. Part of the line configuration record for SWL compliance and operational audit.',
    `swl_compliant` BOOLEAN COMMENT 'Indicates whether all mooring lines and equipment used in this operation were verified to be within their Safe Working Load (SWL) limits at the time of the operation. Mandatory compliance check per OCIMF and port safety regulations.',
    `tide_height_m` DECIMAL(18,2) COMMENT 'Recorded tide height in metres above chart datum at the time of the mooring operation commencement. Critical for under-keel clearance assessment and mooring line angle calculations.',
    `total_lines_count` STRING COMMENT 'Total number of mooring lines deployed across all configurations (head, stern, breast, spring) for this operation. Used for equipment inventory reconciliation and billing.',
    `towage_assist_used` BOOLEAN COMMENT 'Indicates whether tug assistance was used in conjunction with this mooring operation to manoeuvre the vessel to or from the berth. Used for service coordination and billing linkage to towage operations.',
    `vessel_movement_type` STRING COMMENT 'Indicates the vessel movement context for which the mooring service is being performed: arrival at berth, departure from berth, or an intra-port shift between berths or positions.. Valid values are `arrival|departure|shift`',
    `visibility_category` STRING COMMENT 'Categorical assessment of meteorological visibility conditions at the time of the mooring operation: good (>5nm), moderate (2-5nm), poor (0.5-2nm), very poor (<0.5nm). Used for safety risk assessment.. Valid values are `good|moderate|poor|very_poor`',
    `wind_direction` STRING COMMENT 'Compass direction from which the wind was blowing at the berth location during the mooring operation, expressed as a 16-point compass bearing. Used for safety assessment and incident investigation.. Valid values are `^(N|NNE|NE|ENE|E|ESE|SE|SSE|S|SSW|SW|WSW|W|WNW|NW|NNW)$`',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Recorded wind speed in knots at the berth location at the time of the mooring operation. Used for safety assessment, incident investigation, and environmental condition logging.',
    CONSTRAINT pk_mooring_operation PRIMARY KEY(`mooring_operation_id`)
) COMMENT 'Transactional record for each mooring and unmooring service performed at a berth, buoy, or dolphin within port waters. Captures mooring gang assigned, number and configuration of lines deployed (head, breast, spring, stern), mooring equipment used (capstans, bollards, quick-release hooks), SWL compliance verification, commencement and completion timestamps, tide height and weather conditions, vessel movement type (arrival, departure, shift), and any mooring irregularities or safety observations. SSOT for all mooring service delivery events.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` (
    `service_order_id` BIGINT COMMENT 'Unique identifier for the marine service order. Primary key for this entity.',
    `agent_appointment_id` BIGINT COMMENT 'Reference to the shipping agent or port community participant who requested the marine services on behalf of the vessel operator.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Marine service orders reference specific mooring tariffs for billing. Currently has tariff_code_mooring as a string. Adding FK to tariff.mooring_tariff enables proper tariff application and rate looku',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Marine service orders coordinate pilotage, towage, and mooring within ISPS-controlled facilities. The order must reference the active ISPS facility record to confirm services are authorized under the ',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Master service order consolidating pilotage, towage, mooring services directly references the commercial agreement governing all services. Essential for rate lookup, SLA tracking, and consolidated bil',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Marine service orders (pilotage, towage, mooring) are executed under a governing service agreement that dictates contracted rates, payment terms, and billing rules. Port billing teams require this lin',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Service orders specify which security zones vessel will transit during pilotage/towage; VTS coordinates with PFSO to pre-authorize zone access, issue temporary zone permits, and configure access contr',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Marine service orders (covering pilotage, towage, mooring) drive charge estimation (estimated_total_charge). The applicable port_tariff must be recorded on the order at creation to lock in the rate sc',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the licensed pilotage service provider assigned to deliver pilotage services for this order. Must be an authorized pilot organization per port regulations.',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Shipping lines and agents with negotiated rate cards receive discounted marine service pricing. Linking marine_service_order to rate_card enables the billing system to apply customer-specific rates (d',
    `service_request_id` BIGINT COMMENT 'Foreign key linking to customer.service_request. Business justification: A customer service request (e.g., request for pilotage or towage) triggers creation of a marine service order. This link enables end-to-end traceability from customer request to operational fulfillmen',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Marine service orders are subject to SLA commitments (pilot boarding response time, tug mobilisation time). Linking to the governing SLA profile enables automated breach detection, penalty calculation',
    `tertiary_marine_approved_mooring_provider_port_community_participant_id` BIGINT COMMENT 'Reference to the mooring service provider assigned to deliver line handling services for this order. Must be a certified mooring contractor with trained personnel.',
    `call_id` BIGINT COMMENT 'Reference to the specific vessel call for which marine services are being ordered. Links this service order to the vessel visit event.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Marine service orders are placed for specific vessels; vessel dimensions (LOA, draft, beam) from the vessel master record drive tug horsepower requirements, mooring gang size, and dimension-based tari',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Marine service orders reference specific pilotage tariffs for billing. Currently has tariff_code_pilotage as a string. Adding FK to tariff.pilotage_tariff enables proper tariff application and rate lo',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Voyage-level marine service planning and billing aggregation: port operations teams raise and reconcile marine service orders (pilotage, towage, mooring) at the voyage level for pre-arrival planning a',
    `actual_service_end` TIMESTAMP COMMENT 'Actual date and time when all marine services were completed. Used for final billing calculation and Key Performance Indicator (KPI) measurement.',
    `actual_service_start` TIMESTAMP COMMENT 'Actual date and time when marine services commenced. Recorded for billing accuracy, Service Level Agreement (SLA) compliance, and operational performance tracking.',
    `cancellation_reason` STRING COMMENT 'Reason for order cancellation if status is cancelled. Examples: vessel schedule change, weather delay, agent request, service provider unavailability.',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Date and time when the marine service order was cancelled. Used to calculate cancellation fees per tariff terms and conditions.',
    `completion_timestamp` TIMESTAMP COMMENT 'Date and time when all marine services in the order were marked as completed and the order was closed. Triggers final billing and invoicing processes.',
    `confirmation_timestamp` TIMESTAMP COMMENT 'Date and time when the marine service order was confirmed by the port authority or service coordinator. Marks the transition from requested to confirmed status.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the marine service order record was first created in the system. Used for audit trail and order lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this order. Typically the local port currency unless otherwise agreed with the agent.. Valid values are `^[A-Z]{3}$`',
    `estimated_service_end` TIMESTAMP COMMENT 'Estimated date and time when all requested marine services are expected to be completed. Used for resource planning and scheduling.',
    `estimated_service_start` TIMESTAMP COMMENT 'Estimated date and time when the marine services are expected to commence. Typically aligned with vessel Estimated Time of Berthing (ETB) or Estimated Time of Departure (ETD).',
    `estimated_total_charge` DECIMAL(18,2) COMMENT 'Estimated total charge for all marine services in this order, calculated from applicable tariff rates and estimated service parameters. Excludes taxes and adjustments.',
    `launch_service_required` BOOLEAN COMMENT 'Indicates whether launch boat services are requested for personnel transfer between shore and vessel, or between vessels.',
    `launch_trip_count` STRING COMMENT 'Number of launch boat trips requested for personnel or light cargo transfer. Each round trip between shore and vessel counts as one trip.',
    `modified_by` STRING COMMENT 'Username or identifier of the user who last modified the marine service order record. Tracks accountability for order changes and updates.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the marine service order record was last modified. Used for audit trail, change tracking, and data synchronization.',
    `mooring_gang_size` STRING COMMENT 'Number of mooring personnel required for the line handling operation. Typically ranges from 4 to 12 personnel depending on vessel size and berth configuration.',
    `mooring_required` BOOLEAN COMMENT 'Indicates whether mooring services (line handling and securing vessel to berth) are requested as part of this service order.',
    `number_of_tugs` STRING COMMENT 'Number of tug boats requested for the towage operation. Determined by vessel size, weather conditions, and port regulations. Typically ranges from 1 to 4 tugs.',
    `order_number` STRING COMMENT 'Externally visible unique business identifier for the marine service order, used in communications with agents, service providers, and billing systems. Format: MSO-YYYYNNNN.. Valid values are `^MSO-[0-9]{8}$`',
    `order_status` STRING COMMENT 'Current lifecycle status of the marine service order. Tracks progression from initial request through service delivery completion or cancellation.. Valid values are `requested|confirmed|in_progress|completed|cancelled|rejected`',
    `order_type` STRING COMMENT 'Classification of the marine service order based on urgency and scheduling requirements. Emergency orders receive priority dispatch and may incur premium charges.. Valid values are `standard|urgent|emergency|scheduled`',
    `pilot_boarding_location` STRING COMMENT 'Designated location where the marine pilot will board or disembark the vessel. Typically specified as a named pilot station, anchorage, or berth identifier.',
    `pilotage_required` BOOLEAN COMMENT 'Indicates whether marine pilotage services are requested as part of this service order. Pilotage is typically mandatory for vessels above certain size thresholds per port regulations.',
    `pilotage_type` STRING COMMENT 'Specific type of pilotage service requested. Inbound covers entry from sea to berth, outbound covers departure from berth to sea, shifting covers berth-to-berth movements within port.. Valid values are `inbound|outbound|shifting|docking|undocking`',
    `priority_level` STRING COMMENT 'Priority classification for service delivery scheduling and resource allocation. Critical priority is reserved for safety-related or emergency situations.. Valid values are `low|normal|high|critical`',
    `service_duration_minutes` STRING COMMENT 'Total duration of marine service delivery in minutes, calculated from actual start to actual end. Used for billing time-based charges and productivity analysis.',
    `special_instructions` STRING COMMENT 'Free-text field for special handling instructions, safety requirements, or operational notes relevant to the marine service delivery. Examples: dangerous cargo notifications, restricted maneuvering areas, VIP vessel handling.',
    `surveyor_required` BOOLEAN COMMENT 'Indicates whether a marine surveyor boarding is requested for cargo inspection, damage assessment, or compliance verification purposes.',
    `surveyor_type` STRING COMMENT 'Type of marine survey requested. Cargo surveys verify quantity and condition, hull surveys assess vessel structure, draft surveys measure cargo weight via vessel displacement. [ENUM-REF-CANDIDATE: cargo|hull|bunker|draft|damage|pre_loading|post_discharge — 7 candidates stripped; promote to reference product]',
    `towage_required` BOOLEAN COMMENT 'Indicates whether towage (tug boat) services are requested as part of this service order. Towage assists with vessel maneuvering, berthing, and unberthing operations.',
    `tug_horsepower_required` STRING COMMENT 'Minimum total horsepower (HP) required for the towage operation, calculated based on vessel deadweight tonnage (DWT), length overall (LOA), and environmental conditions.',
    `weather_restrictions` STRING COMMENT 'Weather or environmental conditions under which the marine services cannot be safely delivered. Examples: maximum wind speed, minimum visibility, sea state limits.',
    CONSTRAINT pk_service_order PRIMARY KEY(`service_order_id`)
) COMMENT 'Commercial service order record capturing the formal request and authorisation for bundled marine services (pilotage, towage, mooring, launch, surveyor boarding) for a specific vessel call. Captures requesting agent, vessel call reference, services requested with estimated service windows, approved service providers, agreed tariff codes, priority/urgency classification, and order lifecycle status (requested, confirmed, in-progress, completed, cancelled). Acts as the commercial anchor linking marine service delivery to the billing and tariff domains. SSOT for marine service commercials.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` (
    `tug_assignment_id` BIGINT COMMENT 'Unique identifier for the tug assignment record. Primary key for the tug assignment entity.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Incident reporting, PSC follow-up investigations, and operational performance analytics require knowing which specific vessel was assisted in each tug assignment. Role-prefixed assisted_ distinguish',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Port call billing reconciliation and operational performance reporting: tug assignments must be traceable to the specific port call for billing sign-off, port call performance KPIs, and PSC documentat',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: Tug assignments are individually billable events (billable, billing_reference on record). Linking tug_assignment to charge_event enables per-tug charge reconciliation, bollard-pull-based tariff verifi',
    `failure_report_id` BIGINT COMMENT 'Foreign key linking to asset.failure_report. Business justification: Operational failures during tug assignments (engine failure, winch malfunction, steering issues) must be documented with the specific assignment context. Maritime safety regulations require failure re',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Individual tug deployments are cost-tracked for fuel, crew, and maintenance allocation to operational cost centres. Required for activity-based costing and tug fleet profitability analysis in port ope',
    `reassigned_tug_assignment_id` BIGINT COMMENT 'Self-referencing FK on tug_assignment (reassigned_tug_assignment_id)',
    `towage_order_id` BIGINT COMMENT 'Reference to the parent towage order that this tug assignment fulfills. Links the individual tug assignment to the overall towage service request.',
    `tug_id` BIGINT COMMENT 'Reference to the specific tug vessel assigned to this towage operation. Identifies which tug from the fleet is performing the service.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Tug assignments are matched to vessels based on vessel type bollard pull requirements. Operational performance reports and resource planning analytics group tug assignments by vessel type to optimize ',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: When a tug experiences mechanical failure or requires emergency maintenance during an assignment, the work order must reference the specific assignment for incident tracking, warranty claims, and oper',
    `abort_reason` STRING COMMENT 'Detailed explanation if the tug assignment was aborted before completion. Captures operational, safety, or environmental factors that prevented completion.',
    `actual_demobilisation_timestamp` TIMESTAMP COMMENT 'Actual date and time when the tug returned to its berth or anchorage after completing the towage assignment. Used for utilisation tracking and billing.',
    `actual_mobilisation_timestamp` TIMESTAMP COMMENT 'Actual date and time when the tug departed from its berth or anchorage to commence the towage assignment. Used for performance tracking and billing.',
    `assigned_position` STRING COMMENT 'The designated attachment position or role of the tug relative to the vessel being assisted. Critical for operational coordination and safety planning. [ENUM-REF-CANDIDATE: bow|stern|port_bow|starboard_bow|port_quarter|starboard_quarter|standby|escort — 8 candidates stripped; promote to reference product]',
    `assignment_duration_minutes` STRING COMMENT 'Total duration of the tug assignment from mobilisation to demobilisation, measured in minutes. Used for billing and performance analysis.',
    `assignment_number` STRING COMMENT 'Business reference number for this tug assignment, used for operational tracking and communication. May follow port-specific numbering conventions.',
    `assignment_outcome` STRING COMMENT 'Final outcome of the tug assignment. Indicates whether the towage operation was completed successfully or encountered issues.. Valid values are `successful|partially_successful|aborted|cancelled|incident_occurred`',
    `assignment_status` STRING COMMENT 'Current lifecycle status of the tug assignment. Tracks the progression from scheduling through completion or cancellation. [ENUM-REF-CANDIDATE: scheduled|mobilising|on_station|engaged|demobilising|completed|cancelled|aborted — 8 candidates stripped; promote to reference product]',
    `billable` BOOLEAN COMMENT 'Indicates whether this tug assignment is billable to the customer. Some assignments may be non-billable due to operational reasons or contractual arrangements.',
    `billing_reference` STRING COMMENT 'Reference number linking this tug assignment to the billing system. Used for revenue recognition and invoice reconciliation.',
    `bollard_pull_applied_tonnes` DECIMAL(18,2) COMMENT 'Actual bollard pull force applied by the tug during the towage operation, measured in tonnes. Critical for safety assessment and performance verification.',
    `cancellation_reason` STRING COMMENT 'Detailed explanation if the tug assignment was cancelled before mobilisation. Captures business or operational reasons for cancellation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this tug assignment record was first created in the system. Used for audit trail and data lineage tracking.',
    `current_direction_degrees` STRING COMMENT 'Water current direction during the towage operation, measured in degrees (0-360, where 0/360 is North). Affects vessel handling and tug positioning.',
    `current_speed_knots` DECIMAL(18,2) COMMENT 'Water current speed during the towage operation, measured in knots. Critical environmental factor affecting towage safety and difficulty.',
    `disengagement_timestamp` TIMESTAMP COMMENT 'Date and time when the tug disengaged from the vessel (lines cast off or push ceased). Marks the end of active towage.',
    `engagement_duration_minutes` STRING COMMENT 'Duration of active towage engagement (from engagement to disengagement), measured in minutes. Distinguishes active towing time from standby time.',
    `engagement_timestamp` TIMESTAMP COMMENT 'Date and time when the tug physically engaged with the vessel (lines made fast or push commenced). Marks the start of active towage.',
    `fuel_consumed_litres` DECIMAL(18,2) COMMENT 'Volume of fuel consumed by the tug during this assignment, measured in litres. Used for cost allocation and environmental reporting.',
    `fuel_type` STRING COMMENT 'Type of fuel used by the tug during this assignment. Relevant for emissions calculations and MARPOL compliance reporting.. Valid values are `mdo|mgo|hfo|lng|hybrid`',
    `incident_reported` BOOLEAN COMMENT 'Indicates whether a formal incident was reported during or as a result of this tug assignment. Triggers incident investigation and regulatory reporting.',
    `max_bollard_pull_applied_tonnes` DECIMAL(18,2) COMMENT 'Peak bollard pull force applied by the tug during the towage operation, measured in tonnes. Used for safety analysis and equipment stress assessment.',
    `on_station_timestamp` TIMESTAMP COMMENT 'Date and time when the tug arrived at the designated position and was ready to commence towage operations. Marks the start of active service.',
    `operational_narrative` STRING COMMENT 'Detailed narrative description of the towage operation, including key events, decisions, and outcomes. Provides comprehensive operational record.',
    `pi_club_notified` BOOLEAN COMMENT 'Indicates whether the Protection and Indemnity (P&I) club was notified of any incident or potential claim arising from this tug assignment.',
    `pi_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the Protection and Indemnity (P&I) club was notified of the incident or potential claim. Critical for claims management and compliance.',
    `safety_observation_flag` BOOLEAN COMMENT 'Indicates whether any safety observations, near-misses, or concerns were noted during the tug assignment. Triggers review and follow-up actions.',
    `safety_observation_notes` STRING COMMENT 'Detailed description of any safety observations, near-misses, or concerns noted during the tug assignment. Used for safety management and continuous improvement.',
    `scheduled_mobilisation_timestamp` TIMESTAMP COMMENT 'Planned date and time when the tug is scheduled to depart from its berth or anchorage to commence the towage assignment.',
    `sea_state_code` STRING COMMENT 'Sea state during the towage operation, classified according to the Douglas Sea Scale. Affects operational safety and tug performance. [ENUM-REF-CANDIDATE: calm|slight|moderate|rough|very_rough|high|very_high — 7 candidates stripped; promote to reference product]',
    `tide_height_m` DECIMAL(18,2) COMMENT 'Tidal height at the time of the towage operation, measured in meters above chart datum. Affects under-keel clearance and operational planning.',
    `tow_line_length_m` DECIMAL(18,2) COMMENT 'Length of the tow line deployed during the towage operation, measured in meters. Affects the mechanical advantage and safety margin.',
    `tow_line_type` STRING COMMENT 'Type of tow line used for the towage operation. Different line types have different strength, elasticity, and handling characteristics.. Valid values are `synthetic|wire|composite|gog_rope`',
    `tug_master_licence_number` STRING COMMENT 'The professional licence or certificate number of the tug master, verifying their competency and authorization to command the tug.',
    `tug_master_name` STRING COMMENT 'Full name of the tug master on duty for this assignment. Captured for operational records and incident investigation purposes.',
    `tug_master_remarks` STRING COMMENT 'Free-text remarks and observations recorded by the tug master regarding the towage operation. Captures operational insights and lessons learned.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this tug assignment record was last modified in the system. Used for audit trail and change tracking.',
    `vhf_channel_primary` STRING COMMENT 'Primary VHF radio channel used for communication during the tug assignment. Essential for operational coordination and safety communications.',
    `visibility_nm` DECIMAL(18,2) COMMENT 'Visibility during the towage operation, measured in nautical miles. Critical safety factor affecting operational procedures and risk assessment.',
    `weather_conditions` STRING COMMENT 'General description of weather conditions during the towage operation. Provides context for operational decisions and safety assessments.',
    `wind_direction_degrees` STRING COMMENT 'Wind direction during the towage operation, measured in degrees (0-360, where 0/360 is North). Affects vessel handling and tug positioning.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Wind speed during the towage operation, measured in knots. Critical environmental factor affecting towage safety and difficulty.',
    CONSTRAINT pk_tug_assignment PRIMARY KEY(`tug_assignment_id`)
) COMMENT 'Transactional record linking specific tugs to towage orders, capturing tug identifier, assigned position (bow/stern/standby), tug master on duty, mobilisation and demobilisation timestamps, actual bollard pull applied, fuel consumption, and assignment outcome. Enables tracking of individual tug utilisation per towage event when multiple tugs serve a single vessel.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` (
    `pilotage_route_id` BIGINT COMMENT 'Primary key for pilotage_route',
    `alternate_pilotage_route_id` BIGINT COMMENT 'Self-referencing FK on pilotage_route (alternate_pilotage_route_id)',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Pilotage routes are defined, published, and regulated within specific port jurisdictions. Port authorities maintain route charts, enforce route compliance, conduct safety audits, and update route rest',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Pilotage routes are defined and managed within specific port locations. Port authority regulatory reporting, route approval workflows, and compulsory pilotage zone management require associating each ',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Compulsory pilotage routes (compulsory_pilotage_flag=true) are associated with specific tariff rate schedules that determine the applicable charge band by LOA/GRT. Port tariff management teams configu',
    `channel_depth_meters` DECIMAL(18,2) COMMENT 'Maintained depth of the navigation channel along this route, measured in meters below chart datum. Critical for under-keel clearance calculations.',
    `channel_width_meters` DECIMAL(18,2) COMMENT 'Width of the navigation channel along this route in meters. Used for safe passing distance and maneuvering calculations.',
    `compulsory_pilotage_flag` BOOLEAN COMMENT 'Indicates whether pilotage is legally compulsory for this route under port regulations. True if mandatory, false if voluntary or exempt vessels exist.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this pilotage route record was first created in the system. Used for audit trail and data lineage.',
    `daylight_only_flag` BOOLEAN COMMENT 'Indicates whether this route can only be navigated during daylight hours due to safety or regulatory restrictions. True if daylight-only, false if 24-hour operation permitted.',
    `destination_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the route destination point in decimal degrees format.',
    `destination_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the route destination point in decimal degrees format.',
    `destination_point` STRING COMMENT 'Ending location of the pilotage route, typically a berth, anchorage, or pilot disembarkation station.',
    `distance_nautical_miles` DECIMAL(18,2) COMMENT 'Total navigational distance of the pilotage route measured in nautical miles. Used for time estimation and billing calculations.',
    `effective_from_date` DATE COMMENT 'Date when this pilotage route configuration became or will become effective. Used for historical tracking and future route changes.',
    `effective_to_date` DATE COMMENT 'Date when this pilotage route configuration ceased or will cease to be effective. Null for currently active configurations.',
    `environmental_sensitive_area_flag` BOOLEAN COMMENT 'Indicates whether this route passes through or adjacent to an environmentally sensitive area with special protection measures. True if additional environmental protocols apply.',
    `estimated_duration_minutes` STRING COMMENT 'Standard estimated time to complete the pilotage route under normal conditions, measured in minutes. Used for scheduling and resource planning.',
    `hazardous_cargo_restriction` STRING COMMENT 'Level of restriction applied to vessels carrying hazardous cargo on this route. Values: none (no restrictions), imdg_class_restricted (specific IMDG classes prohibited), no_hazmat (all hazardous materials prohibited), special_approval (case-by-case approval required).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this pilotage route record was last updated. Used for change tracking and audit purposes.',
    `maximum_beam_meters` DECIMAL(18,2) COMMENT 'Maximum vessel beam (width) in meters that can safely navigate this route. Used for channel width restrictions.',
    `maximum_draft_meters` DECIMAL(18,2) COMMENT 'Maximum vessel draft in meters that can safely navigate this route under normal tidal conditions. Critical for vessel clearance and safety.',
    `maximum_length_meters` DECIMAL(18,2) COMMENT 'Maximum vessel length overall in meters that can safely navigate this route. Used for turning basin and berth restrictions.',
    `maximum_wave_height_meters` DECIMAL(18,2) COMMENT 'Maximum significant wave height in meters under which this route can be safely navigated. Applicable when weather_restricted_flag is true.',
    `maximum_wind_speed_knots` STRING COMMENT 'Maximum sustained wind speed in knots under which this route can be safely navigated. Applicable when weather_restricted_flag is true.',
    `minimum_draft_meters` DECIMAL(18,2) COMMENT 'Minimum vessel draft in meters that can safely navigate this route. Used for vessel eligibility determination.',
    `minimum_tide_height_meters` DECIMAL(18,2) COMMENT 'Minimum tide height in meters above chart datum required for safe navigation of this route. Applicable only when tidal_dependency_flag is true.',
    `minimum_tug_count` STRING COMMENT 'Minimum number of tugs required to assist vessels on this route when towage is mandatory. Applicable when towage_required_flag is true.',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special instructions, or remarks about the pilotage route. Used for communicating non-standard conditions or procedures.',
    `origin_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the route origin point in decimal degrees format.',
    `origin_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the route origin point in decimal degrees format.',
    `origin_point` STRING COMMENT 'Starting location of the pilotage route, typically a pilot boarding station, anchorage, or berth designation.',
    `overtaking_permitted_flag` BOOLEAN COMMENT 'Indicates whether vessels are permitted to overtake other vessels on this route. True if overtaking is allowed, false if prohibited due to channel width or safety concerns.',
    `pilot_exemption_allowed_flag` BOOLEAN COMMENT 'Indicates whether pilot exemption certificates are recognized for this route. True if qualified masters may be granted exemption from compulsory pilotage.',
    `pilotage_route_status` STRING COMMENT 'Current operational status of the pilotage route. Active routes are available for scheduling, inactive routes are permanently closed, suspended routes are temporarily unavailable, seasonal routes operate during specific periods.',
    `route_code` STRING COMMENT 'Externally-known unique alphanumeric code identifying the pilotage route. Used in operational communications and scheduling systems.',
    `route_name` STRING COMMENT 'Human-readable name of the pilotage route, typically including origin and destination points.',
    `route_type` STRING COMMENT 'Classification of the pilotage route based on operational purpose: inbound (vessel entering port), outbound (vessel departing port), shifting (vessel moving within port), harbor (harbor navigation), or channel (channel transit).',
    `seasonal_end_date` DATE COMMENT 'Annual recurring end date for seasonal routes in MM-DD format. Applicable when status is seasonal. Represents the date each year when the route ceases operation.',
    `seasonal_start_date` DATE COMMENT 'Annual recurring start date for seasonal routes in MM-DD format. Applicable when status is seasonal. Represents the date each year when the route becomes operational.',
    `speed_limit_knots` DECIMAL(18,2) COMMENT 'Maximum permitted vessel speed through water in knots for this route. Enforced for safety, wake control, or environmental protection.',
    `tidal_dependency_flag` BOOLEAN COMMENT 'Indicates whether this route has tidal restrictions that affect vessel transit windows. True if route requires specific tidal conditions, false otherwise.',
    `towage_required_flag` BOOLEAN COMMENT 'Indicates whether tug assistance is mandatory for vessels navigating this route. True if towage is required by regulation or port authority directive.',
    `traffic_separation_scheme_flag` BOOLEAN COMMENT 'Indicates whether this route includes or intersects with an International Maritime Organization (IMO) Traffic Separation Scheme. True if TSS rules apply.',
    `two_way_traffic_flag` BOOLEAN COMMENT 'Indicates whether this route supports simultaneous two-way vessel traffic. True if bidirectional traffic is permitted, false if one-way or alternating traffic only.',
    `vessel_traffic_service_area_flag` BOOLEAN COMMENT 'Indicates whether this route is within a Vessel Traffic Service area requiring mandatory reporting and communication. True if VTS participation is required.',
    `vts_channel_number` STRING COMMENT 'VHF radio channel number used for Vessel Traffic Service communications along this route. Format: VHF followed by two-digit channel number.',
    `weather_restricted_flag` BOOLEAN COMMENT 'Indicates whether this route has weather-related operational restrictions. True if route is subject to closure or restrictions during adverse weather conditions.',
    CONSTRAINT pk_pilotage_route PRIMARY KEY(`pilotage_route_id`)
) COMMENT 'Master reference table for pilotage_route. Referenced by pilotage_route_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_pilotage_route_id` FOREIGN KEY (`pilotage_route_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_route`(`pilotage_route_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_service_order_id` FOREIGN KEY (`service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`service_order`(`service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_service_order_id` FOREIGN KEY (`service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`service_order`(`service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_service_order_id` FOREIGN KEY (`service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`service_order`(`service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_towage_order_id` FOREIGN KEY (`towage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`towage_order`(`towage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_reassigned_tug_assignment_id` FOREIGN KEY (`reassigned_tug_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug_assignment`(`tug_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_towage_order_id` FOREIGN KEY (`towage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`towage_order`(`towage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ADD CONSTRAINT `fk_marine_pilotage_route_alternate_pilotage_route_id` FOREIGN KEY (`alternate_pilotage_route_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_route`(`pilotage_route_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`marine` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`marine` SET TAGS ('dbx_domain' = 'marine');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` SET TAGS ('dbx_subdomain' = 'pilotage_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Boarding Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilotage_route_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Route ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `actual_boarding_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Pilot Boarding Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `assignment_number` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `assignment_number` SET TAGS ('dbx_value_regex' = '^PLT-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_value_regex' = 'scheduled|active|completed|cancelled|diverted|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `billing_status` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Billing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `billing_status` SET TAGS ('dbx_value_regex' = 'pending|invoiced|paid|disputed|waived');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `boarding_method` SET TAGS ('dbx_business_glossary_term' = 'Pilot Boarding Method');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `boarding_method` SET TAGS ('dbx_value_regex' = 'pilot_boat|helicopter|ladder|gangway');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `deviation_from_passage_plan` SET TAGS ('dbx_business_glossary_term' = 'Deviation from Passage Plan Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `deviation_reason` SET TAGS ('dbx_business_glossary_term' = 'Passage Plan Deviation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `incident_reference` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `incident_reported` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `isps_compliance_verified` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliance Verified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `min_ukc_recorded_m` SET TAGS ('dbx_business_glossary_term' = 'Minimum Under-Keel Clearance (UKC) Recorded in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `passage_distance_nm` SET TAGS ('dbx_business_glossary_term' = 'Passage Distance in Nautical Miles');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `passage_narrative` SET TAGS ('dbx_business_glossary_term' = 'Passage Narrative');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pi_club_notified` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilot_licence_class` SET TAGS ('dbx_business_glossary_term' = 'Pilot Licence Class');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilot_licence_class` SET TAGS ('dbx_value_regex' = 'class_1|class_2|class_3|trainee');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilot_off_vessel_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pilot off Vessel (POF) Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilot_on_board_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pilot on Board (POB) Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `scheduled_boarding_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Pilot Boarding Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `scheduled_disembarkation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Pilot Disembarkation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `service_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Service Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `service_charge_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|shifting|canal_transit|anchorage');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `speed_over_ground_avg_knots` SET TAGS ('dbx_business_glossary_term' = 'Average Speed Over Ground (SOG) in Knots');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `tidal_window_end` SET TAGS ('dbx_business_glossary_term' = 'Tidal Window End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `tidal_window_start` SET TAGS ('dbx_business_glossary_term' = 'Tidal Window Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `tide_height_m` SET TAGS ('dbx_business_glossary_term' = 'Tide Height in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `tug_count` SET TAGS ('dbx_business_glossary_term' = 'Tug Assistance Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `tug_required` SET TAGS ('dbx_business_glossary_term' = 'Tug Assistance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vhf_channel_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary VHF Working Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vhf_channel_primary` SET TAGS ('dbx_value_regex' = '^CH[0-9]{2}[A-Z]?$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `visibility_nm` SET TAGS ('dbx_business_glossary_term' = 'Visibility in Nautical Miles');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vts_reporting_point_count` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Reporting Point Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `wind_direction_degrees` SET TAGS ('dbx_business_glossary_term' = 'Wind Direction in Degrees True');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed in Knots');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` SET TAGS ('dbx_subdomain' = 'pilotage_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Nationality Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `country_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `country_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Labour Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `competency_class` SET TAGS ('dbx_business_glossary_term' = 'IMO Competency Class');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Date of Birth');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `deep_sea_pilot_endorsement` SET TAGS ('dbx_business_glossary_term' = 'Deep Sea Pilot Endorsement');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `duty_status` SET TAGS ('dbx_business_glossary_term' = 'Pilot Duty Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `duty_status` SET TAGS ('dbx_value_regex' = 'on_duty|off_duty|standby|leave|suspended|retired');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_relationship` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Relationship');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `emergency_contact_relationship` SET TAGS ('dbx_value_regex' = 'spouse|parent|sibling|child|friend|other');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'permanent|contract|casual|seconded');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `english_proficiency_level` SET TAGS ('dbx_business_glossary_term' = 'English Language Proficiency Level');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `english_proficiency_level` SET TAGS ('dbx_value_regex' = 'basic|operational|proficient|expert');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Pilot Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `incident_count_ytd` SET TAGS ('dbx_business_glossary_term' = 'Incident Count Year to Date (YTD)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Clearance Level');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Licence Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `language_proficiencies` SET TAGS ('dbx_business_glossary_term' = 'Language Proficiencies');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `last_incident_date` SET TAGS ('dbx_business_glossary_term' = 'Last Incident Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `licence_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Pilot Licence Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `licence_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Pilot Licence Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `licence_number` SET TAGS ('dbx_business_glossary_term' = 'Pilot Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `licence_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `licence_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `licence_status` SET TAGS ('dbx_business_glossary_term' = 'Pilot Licence Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `licence_status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|revoked|pending_renewal');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `max_dwt_mt` SET TAGS ('dbx_business_glossary_term' = 'Maximum Authorised Deadweight Tonnage (DWT) in Metric Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `max_grt` SET TAGS ('dbx_business_glossary_term' = 'Maximum Authorised Gross Registered Tonnage (GRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `max_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Authorised Length Overall (LOA) in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_expiry_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_expiry_date` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_number` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_status` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Certificate Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_status` SET TAGS ('dbx_value_regex' = 'valid|expired|suspended|pending_review');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_status` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `medical_cert_status` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `night_pilotage_authorised` SET TAGS ('dbx_business_glossary_term' = 'Night Pilotage Authorised');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `pilotage_commencement_date` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Commencement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `pni_club_notified` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `port_authority_employee_number` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Employee Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `port_authority_employee_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `radar_arpa_endorsement` SET TAGS ('dbx_business_glossary_term' = 'Radar and Automatic Radar Plotting Aid (ARPA) Endorsement');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `refresher_training_due_date` SET TAGS ('dbx_business_glossary_term' = 'Refresher Training Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Pilot Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `simulator_training_date` SET TAGS ('dbx_business_glossary_term' = 'Last Simulator Training Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `stcw_cert_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training Certification and Watchkeeping (STCW) Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `stcw_cert_number` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training Certification and Watchkeeping (STCW) Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `vhf_radio_operator_cert` SET TAGS ('dbx_business_glossary_term' = 'VHF Radio Operator Certificate Held');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `years_of_experience` SET TAGS ('dbx_business_glossary_term' = 'Years of Pilotage Experience');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` SET TAGS ('dbx_subdomain' = 'vessel_assistance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Tug Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Agent Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `abort_reason` SET TAGS ('dbx_business_glossary_term' = 'Towage Abort or Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `actual_commencement` SET TAGS ('dbx_business_glossary_term' = 'Actual Towage Commencement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `actual_completion` SET TAGS ('dbx_business_glossary_term' = 'Actual Towage Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `billing_status` SET TAGS ('dbx_business_glossary_term' = 'Towage Billing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `billing_status` SET TAGS ('dbx_value_regex' = 'pending|invoiced|disputed|paid|waived');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `current_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Tidal Current Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Towage Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `imdg_hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Hazardous Material Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `min_bollard_pull_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Minimum Bollard Pull Requirement (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `order_reference` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `order_reference` SET TAGS ('dbx_value_regex' = '^TOW-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'requested|confirmed|in_progress|completed|aborted|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_code` SET TAGS ('dbx_business_glossary_term' = 'United Nations Location Code (UN/LOCODE) Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `requested_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Towage Request Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `safety_observation_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Observation Raised Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `safety_observation_notes` SET TAGS ('dbx_business_glossary_term' = 'Safety Observation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `scheduled_commencement` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Towage Commencement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `service_outcome` SET TAGS ('dbx_business_glossary_term' = 'Towage Service Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `service_outcome` SET TAGS ('dbx_value_regex' = 'completed|aborted|cancelled|partial');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `shipping_line_code` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line SCAC Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `shipping_line_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Towage Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `towage_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Towage Service Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `towage_charge_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `towage_type` SET TAGS ('dbx_business_glossary_term' = 'Towage Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `towage_type` SET TAGS ('dbx_value_regex' = 'arrival|departure|shifting|emergency|dry_dock');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `tug_attachment_bow` SET TAGS ('dbx_business_glossary_term' = 'Tug Attachment at Bow');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `tug_attachment_breast` SET TAGS ('dbx_business_glossary_term' = 'Tug Attachment Breast (Alongside)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `tug_attachment_stern` SET TAGS ('dbx_business_glossary_term' = 'Tug Attachment at Stern');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `tugs_assigned` SET TAGS ('dbx_business_glossary_term' = 'Number of Tugs Assigned');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `tugs_required` SET TAGS ('dbx_business_glossary_term' = 'Number of Tugs Required');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `visibility_category` SET TAGS ('dbx_business_glossary_term' = 'Visibility Category at Commencement');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `visibility_category` SET TAGS ('dbx_value_regex' = 'good|moderate|poor|very_poor');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `wind_direction` SET TAGS ('dbx_business_glossary_term' = 'Wind Direction at Commencement');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `wind_direction` SET TAGS ('dbx_value_regex' = '^(N|NNE|NE|ENE|E|ESE|SE|SSE|S|SSW|SW|WSW|W|WNW|NW|NNW)$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed at Commencement (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` SET TAGS ('dbx_subdomain' = 'vessel_assistance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Registry Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `ahts_capable` SET TAGS ('dbx_business_glossary_term' = 'Anchor Handling and Towing Supply (AHTS) Capable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `ais_transponder_class` SET TAGS ('dbx_business_glossary_term' = 'Automatic Identification System (AIS) Transponder Class');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `ais_transponder_class` SET TAGS ('dbx_value_regex' = 'Class A|Class B');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `beam_m` SET TAGS ('dbx_business_glossary_term' = 'Beam (Breadth) in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `bollard_pull_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Bollard Pull Rating (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `build_shipyard` SET TAGS ('dbx_business_glossary_term' = 'Build Shipyard Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `call_sign` SET TAGS ('dbx_business_glossary_term' = 'Radio Call Sign');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `call_sign` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `class_notation` SET TAGS ('dbx_business_glossary_term' = 'Classification Notation');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `class_survey_due_date` SET TAGS ('dbx_business_glossary_term' = 'Classification Society Survey Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `classification_society` SET TAGS ('dbx_business_glossary_term' = 'Classification Society');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `commissioned_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioned Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract / Charter End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract / Charter Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `crew_complement` SET TAGS ('dbx_business_glossary_term' = 'Minimum Safe Manning Crew Complement');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `decommissioned_date` SET TAGS ('dbx_business_glossary_term' = 'Decommissioned Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `draught_m` SET TAGS ('dbx_business_glossary_term' = 'Draught in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `engine_power_kw` SET TAGS ('dbx_business_glossary_term' = 'Engine Power (kW)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `escort_bollard_pull_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Escort Bollard Pull Rating (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `escort_certified` SET TAGS ('dbx_business_glossary_term' = 'Escort Tug Certification Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `fifi_class` SET TAGS ('dbx_business_glossary_term' = 'Fire-Fighting (FiFi) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `fifi_class` SET TAGS ('dbx_value_regex' = 'FiFi1|FiFi1+WS|FiFi2|FiFi3|none');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Primary Fuel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'HFO|MGO|MDO|LNG|methanol|hybrid');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `gross_tonnage` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `ice_class` SET TAGS ('dbx_business_glossary_term' = 'Ice Class Notation');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `ice_class` SET TAGS ('dbx_value_regex' = 'IA Super|IA|IB|IC|ID|none');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `isps_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `last_dry_dock_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dry Dock Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `loa_m` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `marpol_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Compliance Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `max_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Maximum Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_business_glossary_term' = 'Maritime Mobile Service Identity (MMSI) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `tug_name` SET TAGS ('dbx_business_glossary_term' = 'Tug Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `net_tonnage` SET TAGS ('dbx_business_glossary_term' = 'Net Registered Tonnage (NRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `next_dry_dock_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Dry Dock Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `official_number` SET TAGS ('dbx_business_glossary_term' = 'Official Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `operating_company` SET TAGS ('dbx_business_glossary_term' = 'Operating Company Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `operating_company` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'available|assigned|maintenance|out_of_service|laid_up');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership / Charter Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `ownership_type` SET TAGS ('dbx_value_regex' = 'owned|bareboat_charter|time_charter|contracted');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `owning_company` SET TAGS ('dbx_business_glossary_term' = 'Owning Company Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `owning_company` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `pi_club` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `pi_club` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `pi_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'P&I Insurance Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `pi_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `pi_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Operational Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `safety_management_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'Safety Management Certificate (SMC) Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `tug_type` SET TAGS ('dbx_business_glossary_term' = 'Tug Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `tug_type` SET TAGS ('dbx_value_regex' = 'ASD|conventional|voith|tractor|rotor');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `year_built` SET TAGS ('dbx_business_glossary_term' = 'Year Built');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` SET TAGS ('dbx_subdomain' = 'vessel_assistance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `mooring_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Mooring Equipment Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `billable` SET TAGS ('dbx_business_glossary_term' = 'Billable Operation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `bollards_used_count` SET TAGS ('dbx_business_glossary_term' = 'Bollards Used Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `breast_lines_count` SET TAGS ('dbx_business_glossary_term' = 'Breast Lines Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `capstans_used` SET TAGS ('dbx_business_glossary_term' = 'Capstans Used Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Mooring Service Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `charge_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `commencement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation Commencement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `current_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Current Speed at Operation (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `gang_size` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang Size');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `gang_supervisor` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang Supervisor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `gang_supervisor` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `gang_supervisor` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `head_lines_count` SET TAGS ('dbx_business_glossary_term' = 'Head Lines Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `incident_ref` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `incident_reported` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `irregularity_description` SET TAGS ('dbx_business_glossary_term' = 'Mooring Irregularity Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `irregularity_observed` SET TAGS ('dbx_business_glossary_term' = 'Mooring Irregularity Observed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `line_material_type` SET TAGS ('dbx_business_glossary_term' = 'Mooring Line Material Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `line_material_type` SET TAGS ('dbx_value_regex' = 'wire|polyester|polypropylene|nylon|HMPE|mixed');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `mooring_location_type` SET TAGS ('dbx_business_glossary_term' = 'Mooring Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `mooring_location_type` SET TAGS ('dbx_value_regex' = 'berth|buoy|dolphin|jetty|quay');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `operation_ref` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `operation_ref` SET TAGS ('dbx_value_regex' = '^MOR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `operation_status` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `operation_status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `operation_type` SET TAGS ('dbx_value_regex' = 'mooring|unmooring|shifting|re-mooring');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `pi_club_notified` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `pilot_on_board` SET TAGS ('dbx_business_glossary_term' = 'Pilot on Board Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `quick_release_hooks_used` SET TAGS ('dbx_business_glossary_term' = 'Quick Release Hooks Used Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `spring_lines_count` SET TAGS ('dbx_business_glossary_term' = 'Spring Lines Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `stern_lines_count` SET TAGS ('dbx_business_glossary_term' = 'Stern Lines Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `swl_compliant` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `tide_height_m` SET TAGS ('dbx_business_glossary_term' = 'Tide Height at Operation (Metres)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `total_lines_count` SET TAGS ('dbx_business_glossary_term' = 'Total Mooring Lines Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `towage_assist_used` SET TAGS ('dbx_business_glossary_term' = 'Towage Assistance Used Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `vessel_movement_type` SET TAGS ('dbx_business_glossary_term' = 'Vessel Movement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `vessel_movement_type` SET TAGS ('dbx_value_regex' = 'arrival|departure|shift');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `visibility_category` SET TAGS ('dbx_business_glossary_term' = 'Visibility Category at Operation');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `visibility_category` SET TAGS ('dbx_value_regex' = 'good|moderate|poor|very_poor');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `wind_direction` SET TAGS ('dbx_business_glossary_term' = 'Wind Direction at Operation');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `wind_direction` SET TAGS ('dbx_value_regex' = '^(N|NNE|NE|ENE|E|ESE|SE|SSE|S|SSW|SW|WSW|W|WNW|NW|NNW)$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed at Operation (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` SET TAGS ('dbx_subdomain' = 'vessel_assistance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Pilot Provider ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `service_request_id` SET TAGS ('dbx_business_glossary_term' = 'Service Request Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `tertiary_marine_approved_mooring_provider_port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Mooring Provider ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `actual_service_end` SET TAGS ('dbx_business_glossary_term' = 'Actual Service End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `actual_service_start` SET TAGS ('dbx_business_glossary_term' = 'Actual Service Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `cancellation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `confirmation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `estimated_service_end` SET TAGS ('dbx_business_glossary_term' = 'Estimated Service End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `estimated_service_start` SET TAGS ('dbx_business_glossary_term' = 'Estimated Service Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `estimated_total_charge` SET TAGS ('dbx_business_glossary_term' = 'Estimated Total Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `launch_service_required` SET TAGS ('dbx_business_glossary_term' = 'Launch Service Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `launch_trip_count` SET TAGS ('dbx_business_glossary_term' = 'Launch Trip Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `mooring_gang_size` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang Size');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `mooring_required` SET TAGS ('dbx_business_glossary_term' = 'Mooring Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `number_of_tugs` SET TAGS ('dbx_business_glossary_term' = 'Number of Tugs');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `order_number` SET TAGS ('dbx_value_regex' = '^MSO-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Order Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'requested|confirmed|in_progress|completed|cancelled|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Order Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'standard|urgent|emergency|scheduled');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `pilot_boarding_location` SET TAGS ('dbx_business_glossary_term' = 'Pilot Boarding Location');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `pilotage_required` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `pilotage_type` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `pilotage_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|shifting|docking|undocking');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|normal|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `service_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `surveyor_required` SET TAGS ('dbx_business_glossary_term' = 'Marine Surveyor Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `surveyor_type` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `towage_required` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `tug_horsepower_required` SET TAGS ('dbx_business_glossary_term' = 'Tug Horsepower Required');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ALTER COLUMN `weather_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Weather Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` SET TAGS ('dbx_subdomain' = 'vessel_assistance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Assignment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Assisted Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `failure_report_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Report Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `reassigned_tug_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Reassigned Tug Assignment Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `reassigned_tug_assignment_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `abort_reason` SET TAGS ('dbx_business_glossary_term' = 'Abort Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `actual_demobilisation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Demobilisation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `actual_mobilisation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Mobilisation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `assigned_position` SET TAGS ('dbx_business_glossary_term' = 'Assigned Position');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `assignment_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Assignment Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `assignment_number` SET TAGS ('dbx_business_glossary_term' = 'Assignment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `assignment_outcome` SET TAGS ('dbx_business_glossary_term' = 'Assignment Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `assignment_outcome` SET TAGS ('dbx_value_regex' = 'successful|partially_successful|aborted|cancelled|incident_occurred');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `billable` SET TAGS ('dbx_business_glossary_term' = 'Billable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `billing_reference` SET TAGS ('dbx_business_glossary_term' = 'Billing Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `bollard_pull_applied_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Bollard Pull Applied (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `current_direction_degrees` SET TAGS ('dbx_business_glossary_term' = 'Current Direction (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `current_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Current Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `disengagement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Disengagement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `engagement_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Engagement Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `engagement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Engagement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `fuel_consumed_litres` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumed (Litres)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'mdo|mgo|hfo|lng|hybrid');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `incident_reported` SET TAGS ('dbx_business_glossary_term' = 'Incident Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `max_bollard_pull_applied_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Bollard Pull Applied (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `on_station_timestamp` SET TAGS ('dbx_business_glossary_term' = 'On Station Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `operational_narrative` SET TAGS ('dbx_business_glossary_term' = 'Operational Narrative');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `pi_club_notified` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `pi_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `safety_observation_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Observation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `safety_observation_notes` SET TAGS ('dbx_business_glossary_term' = 'Safety Observation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `scheduled_mobilisation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Mobilisation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_business_glossary_term' = 'Sea State Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tide_height_m` SET TAGS ('dbx_business_glossary_term' = 'Tide Height (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tow_line_length_m` SET TAGS ('dbx_business_glossary_term' = 'Tow Line Length (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tow_line_type` SET TAGS ('dbx_business_glossary_term' = 'Tow Line Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tow_line_type` SET TAGS ('dbx_value_regex' = 'synthetic|wire|composite|gog_rope');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_master_licence_number` SET TAGS ('dbx_business_glossary_term' = 'Tug Master Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_master_licence_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_master_licence_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_master_name` SET TAGS ('dbx_business_glossary_term' = 'Tug Master Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_master_remarks` SET TAGS ('dbx_business_glossary_term' = 'Tug Master Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `vhf_channel_primary` SET TAGS ('dbx_business_glossary_term' = 'Very High Frequency (VHF) Channel Primary');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `visibility_nm` SET TAGS ('dbx_business_glossary_term' = 'Visibility (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `wind_direction_degrees` SET TAGS ('dbx_business_glossary_term' = 'Wind Direction (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` SET TAGS ('dbx_subdomain' = 'pilotage_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `pilotage_route_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Route Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `alternate_pilotage_route_id` SET TAGS ('dbx_business_glossary_term' = 'Alternate Pilotage Route Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `alternate_pilotage_route_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `channel_depth_meters` SET TAGS ('dbx_business_glossary_term' = 'Channel Depth Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `channel_width_meters` SET TAGS ('dbx_business_glossary_term' = 'Channel Width Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `compulsory_pilotage_flag` SET TAGS ('dbx_business_glossary_term' = 'Compulsory Pilotage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `daylight_only_flag` SET TAGS ('dbx_business_glossary_term' = 'Daylight Only Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `destination_latitude` SET TAGS ('dbx_business_glossary_term' = 'Destination Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `destination_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `destination_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `destination_longitude` SET TAGS ('dbx_business_glossary_term' = 'Destination Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `destination_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `destination_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `destination_point` SET TAGS ('dbx_business_glossary_term' = 'Destination Point');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `distance_nautical_miles` SET TAGS ('dbx_business_glossary_term' = 'Distance Nautical Miles');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `environmental_sensitive_area_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Sensitive Area Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `hazardous_cargo_restriction` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Cargo Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `maximum_beam_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Beam Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `maximum_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Draft Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `maximum_length_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Length Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `maximum_wave_height_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Wave Height Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `maximum_wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Maximum Wind Speed Knots');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `minimum_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Minimum Draft Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `minimum_tide_height_meters` SET TAGS ('dbx_business_glossary_term' = 'Minimum Tide Height Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `minimum_tug_count` SET TAGS ('dbx_business_glossary_term' = 'Minimum Tug Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `origin_latitude` SET TAGS ('dbx_business_glossary_term' = 'Origin Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `origin_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `origin_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `origin_longitude` SET TAGS ('dbx_business_glossary_term' = 'Origin Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `origin_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `origin_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `origin_point` SET TAGS ('dbx_business_glossary_term' = 'Origin Point');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `overtaking_permitted_flag` SET TAGS ('dbx_business_glossary_term' = 'Overtaking Permitted Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `pilot_exemption_allowed_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilot Exemption Allowed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `pilotage_route_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `route_code` SET TAGS ('dbx_business_glossary_term' = 'Route Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `route_name` SET TAGS ('dbx_business_glossary_term' = 'Route Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `route_type` SET TAGS ('dbx_business_glossary_term' = 'Route Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `seasonal_end_date` SET TAGS ('dbx_business_glossary_term' = 'Seasonal End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `seasonal_start_date` SET TAGS ('dbx_business_glossary_term' = 'Seasonal Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `speed_limit_knots` SET TAGS ('dbx_business_glossary_term' = 'Speed Limit Knots');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `tidal_dependency_flag` SET TAGS ('dbx_business_glossary_term' = 'Tidal Dependency Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `towage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `traffic_separation_scheme_flag` SET TAGS ('dbx_business_glossary_term' = 'Traffic Separation Scheme Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `two_way_traffic_flag` SET TAGS ('dbx_business_glossary_term' = 'Two Way Traffic Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `vessel_traffic_service_area_flag` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service Area Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `vts_channel_number` SET TAGS ('dbx_business_glossary_term' = 'Vts Channel Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `weather_restricted_flag` SET TAGS ('dbx_business_glossary_term' = 'Weather Restricted Flag');
