-- Schema for Domain: marine | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:28

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`marine` COMMENT 'Covers specialist marine services including pilotage scheduling and logs, towage operations, mooring services, launch boat dispatch, and marine surveyor coordination. Manages P&I club notifications and marine incident records aligned with SOLAS and MARPOL requirements. SSOT for all marine service delivery data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` (
    `pilotage_assignment_id` BIGINT COMMENT 'Unique surrogate identifier for the pilotage assignment record. Primary key for the pilotage_assignment data product in the marine domain.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Pilotage services are governed by port service agreements defining tariffs, SLAs, and billing terms. Essential for rate lookup, penalty assessment, and invoice reconciliation. Natural business link in',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Pilots board vessels at designated anchorages; boarding_station_name currently denormalized. Essential for pilot dispatch coordination, launch boat routing, and service billing accuracy.',
    `call_id` BIGINT COMMENT 'FK to vessel.call.call_id — Pilotage assignments are scheduled per vessel call. This FK enables pilot resource planning and marine service billing reconciliation.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Pilotage operations navigate vessels through designated channels; passage planning, VTS reporting, and incident investigation require channel reference. Core operational link for maritime safety and b',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Pilotage operations are cost-tracked by operational cost centres (VTS, pilot station) for service costing, budget variance analysis, and departmental P&L reporting. Essential for maritime service line',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: SOLAS Chapter XI-2 requires pilots to verify facility security level and Declaration of Security (DoS) before boarding. Pilotage operations must confirm ISPS compliance and current security level at b',
    `marine_service_order_id` BIGINT COMMENT 'Foreign key linking to marine.marine_service_order. Business justification: Pilotage assignment is the operational execution of pilotage services ordered via marine_service_order. The marine_service_order product has pilotage_required flag, pilotage_type, and pilot_boarding_l',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: High-risk pilotage operations (confined waters, hazardous cargo, night operations, extreme weather) may require permits to work. Safety systems link permits to specific pilotage assignments for author',
    `pilot_id` BIGINT COMMENT 'Reference to the licensed marine pilot assigned to conduct the pilotage service. Links to the pilot master record in the workforce/marine services domain.',
    `pilotage_route_id` BIGINT COMMENT 'Reference to the approved pilotage route assigned for this service, defining waypoints, distance, Under-Keel Clearance (UKC) requirements, speed restrictions, and tidal windows.',
    `pilotage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.pilotage_tariff. Business justification: Pilotage assignments must reference the applicable tariff schedule for billing calculation, regulatory compliance, and audit trail. Port operations require linking each pilotage event to its tariff ba',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Pilotage assignments require audit trail of which port operations employee recorded/verified the pilot boarding for compliance and liability purposes - standard maritime operational logging requiremen',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Pilotage operations trigger security incidents when vessels deviate from passage plans into restricted zones, approach unauthorized boarding areas, or breach ISPS security perimeters during transit. V',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Pilotage assignments are scheduled and executed for booked vessel calls. Booking triggers pilot resource allocation, passage planning, and billing. Essential for operational coordination between booki',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel requiring pilotage services. Links to the vessel master record in the vessel operations domain.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Pilotage safety planning requires authoritative vessel master data (LOA, DWT, draft limits) for passage plan approval, pilot licensing verification, and SOLAS compliance. Removes denormalized vessel d',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Pilotage tariff calculation, pilot licensing requirements (vessel type endorsements), and tug requirement determination depend on vessel type classification (container, tanker, LNG carrier) from maste',
    `voyage_id` BIGINT COMMENT 'Reference to the vessel voyage record associated with this pilotage assignment, linking pilotage service to the broader vessel traffic management context.',
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
    `labour_agreement_id` BIGINT COMMENT 'Foreign key linking to workforce.labour_agreement. Business justification: Pilots are covered by specific labour agreements governing pay, conditions, and entitlements - real industrial relations requirement enabling payroll calculation and entitlement management.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Pilot licensing authority verification, STCW certification validation, and port access credential issuance require country master data (IMO member status, STCW ratification) for regulatory compliance.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Pilots belong to pilotage department/unit within port authority - real organizational hierarchy enabling cost center allocation, budget management, and operational reporting.',
    `position_id` BIGINT COMMENT 'Foreign key linking to workforce.position. Business justification: Pilots hold specific positions in port authority organizational structure - real organizational relationship enabling workforce planning, succession management, and HR administration for pilotage staf',
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
    `home_port_code` STRING COMMENT 'UN/LOCODE of the pilots designated home port or primary operating port. Used for scheduling, deployment planning, and inter-port transfer management.. Valid values are `^[A-Z]{5}$`',
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
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Towage services are contracted with rates, volume commitments, and performance targets defined in agreements. Required for tariff application, SLA compliance tracking, and billing. Core commercial rel',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Tugs service vessels at anchorage for shifting, emergency response, and pre-berthing preparation. Common maritime operation requiring anchorage identification for dispatch and billing.',
    `berth_id` BIGINT COMMENT 'Reference to the berth or terminal location that is the origin or destination of the towage movement. Used for berth allocation planning and towage route coordination.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Tugs escort vessels through channels; towage planning requires channel depth, width, tidal restrictions, and navigational aid coordination. Critical for safe vessel movements and resource allocation.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Towage services are delivered by specific operational cost centres (marine services, harbour operations). Required for activity-based costing, budget tracking, and operational cost allocation in port ',
    `employee_id` BIGINT COMMENT 'Reference to the tug master (officer in charge) of the lead tug vessel for the towage operation. Used for accountability, competency tracking, and incident investigation.',
    `invoice_id` BIGINT COMMENT 'Reference to the billing invoice record generated for this towage service. Links to the financial invoice data product in the Finance domain for accounts receivable tracking.',
    `marine_incident_id` BIGINT COMMENT 'Reference to a marine incident record if an incident occurred during the towage operation. Null if no incident was recorded. Links to the marine incident management data product.',
    `marine_service_order_id` BIGINT COMMENT 'Foreign key linking to marine.marine_service_order. Business justification: Towage order is the operational execution of towage services ordered via marine_service_order. The marine_service_order product has towage_required flag, number_of_tugs, and tug_horsepower_required, i',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: High-risk towage operations (heavy weather, restricted visibility, hazmat vessels, confined spaces) require permits to work. Safety systems link permits to towage orders for authorization tracking, ri',
    `pilot_id` BIGINT COMMENT 'Reference to the marine pilot assigned to the vessel during the towage operation. Towage and pilotage are coordinated services; the pilot directs tug movements during berthing/unberthing.',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Tugs are depreciable port assets requiring lifecycle tracking in asset register for financial reporting, capex planning, insurance valuation, and disposal decisions. Towage orders need asset register ',
    `call_id` BIGINT COMMENT 'FK to vessel.call.call_id — Marine service billing and operational coordination require linking towage orders to the vessel call being serviced. Without this, towage cannot be reconciled to vessel visits.',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Towage operations position vessels at berths serving rail terminals; operations teams track which vessel movements support rail cargo transfers for resource planning, scheduling coordination, and inte',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Towage orders are raised by shipping agents who are port community participants. Direct link supports agent authorization checks, credit limit validation, billing account lookup, and service request t',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Towage orders are raised from vessel call bookings specifying tug requirements. Booking drives tug resource allocation, scheduling, and billing. Core operational link between booking and towage servic',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel requiring towage assistance. Links to the vessel master data product for full vessel details.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Towage planning and tug assignment calculations require vessel master data (LOA, beam, DWT, GRT) for bollard pull determination, tariff calculation, and P&I club verification. Removes denormalized ves',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Towage tariff calculation, tug count determination, and bollard pull requirements depend on vessel type classification (container, tanker, bulk carrier) for service specification and pricing. Vessel t',
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
    `tariff_code` STRING COMMENT 'Port tariff code applied to calculate the towage service charge. References the applicable tariff schedule item for the towage type, vessel class, and service conditions.',
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
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Tugs operated under concession/lease agreements with port authority or third-party operators. Required for concession tracking, performance bond management, revenue share calculation, and contract com',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Tugs are capital assets requiring depreciation, maintenance capex tracking, insurance valuation, and asset register compliance. Core fixed asset management requirement for maritime fleet financial rep',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Tug regulatory compliance, PSC inspection targeting, and flag state survey requirements depend on flag state master data (PSC targeting factor, flag state authority, MOU membership) for operational co',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Tugs are both operational vessels (marine domain) and depreciable capital assets (asset domain). Asset register tracks acquisition cost, depreciation, book value, disposal planning, and insurance valu',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Tugs with ownership_type = contracted or leased are provided by external vendors. This FK enables linking contracted tug assets to vendor records for contract management, invoicing, and performanc',
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
    `home_port` STRING COMMENT 'Name of the port or terminal at which the tug vessel is normally based and from which it is dispatched for towage and marine service operations. Used in operational planning, crew logistics, and maintenance scheduling within the ports marine services management system.',
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
    `port_of_registry` STRING COMMENT 'Name of the port where the tug vessel is officially registered as recorded on the vessels certificate of registry. Displayed on the vessels stern and used in official maritime documentation and PSC inspections.',
    `remarks` STRING COMMENT 'Free-text field for recording operational notes, special conditions, known limitations, or temporary restrictions applicable to the tug vessel that are not captured in structured fields. Examples include temporary equipment deficiencies, operational restrictions imposed by the classification society, or special port authority conditions.',
    `safety_management_cert_expiry` DATE COMMENT 'Expiry date of the Safety Management Certificate (SMC) issued under the ISM Code, confirming the vessels safety management system complies with IMO requirements. Tugs operating under the ISM Code must maintain a valid SMC. Used in compliance monitoring and PSC inspection preparation.',
    `tug_type` STRING COMMENT 'Classification of the tug vessel by propulsion and manoeuvring system design. ASD (Azimuth Stern Drive) tugs offer 360-degree thrust; conventional tugs use fixed propellers; voith tugs use Voith-Schneider cycloidal propellers; tractor tugs use forward-mounted azimuth drives; rotor tugs use a hybrid arrangement. Determines operational capability and assignment suitability for specific towage tasks.. Valid values are `ASD|conventional|voith|tractor|rotor`',
    `year_built` STRING COMMENT 'Calendar year in which the tug vessel was constructed and delivered from the shipyard. Used in asset lifecycle management, maintenance planning, insurance valuation, and assessing compliance with age-related regulatory requirements under PSC and flag state rules.',
    CONSTRAINT pk_tug PRIMARY KEY(`tug_id`)
) COMMENT 'Master record for each tug vessel operated or contracted at the port, including tug name, IMO number, flag state, bollard pull rating (tonnes), engine power (kW), tug type (ASD, conventional, voith), LOA, beam, draught, fire-fighting class (FiFi), escort tug certification, current operational status, and owning/operating company. SSOT for tug asset identity.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` (
    `mooring_operation_id` BIGINT COMMENT 'Unique surrogate identifier for each mooring or unmooring service event recorded in the port. Primary key for the mooring_operation data product.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Mooring services fall under terminal service agreements with defined rates and SLA targets. Necessary for billing, performance measurement, and dispute resolution. Standard practice in maritime termin',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Mooring operations require supervisor sign-off by named employee for safety compliance and liability management - mandatory operational control in maritime terminal operations.',
    `berth_id` BIGINT COMMENT 'Reference to the berth, buoy, or dolphin at which the mooring operation is performed. Links to the berth/facility master record for infrastructure details.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Mooring gangs operate under specific cost centres (stevedoring dept, marine operations). Essential for labour cost allocation, gang productivity analysis, and operational budgeting in maritime termina',
    `gang_id` BIGINT COMMENT 'Reference to the mooring gang (crew team) assigned to perform this mooring operation. Links to the workforce/gang master record for crew composition and certification details.',
    `marine_service_order_id` BIGINT COMMENT 'Reference to the parent marine service order or work order under which this mooring operation was dispatched. Links to the service order management record for billing and scheduling context.',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Mooring operations in hazardous conditions (heavy weather, dangerous cargo, night operations) require permits to work. Safety systems link permits to specific mooring operations for authorization trac',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Mooring operations use SWL-certified equipment (capstans, bollards, quick-release hooks) that must be tracked in asset register for inspection scheduling, failure analysis, and regulatory compliance. ',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Mooring lines secure to quay wall bollards; structural load calculations, bollard SWL compliance verification, and safety inspections depend on quay wall identification. Engineering and safety require',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Mooring gangs operate in restricted berth security zones; incidents include unauthorized personnel accessing mooring lines, tampering with vessel securing equipment, or ISPS breaches during line handl',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Mooring operations are executed for booked vessel calls. Booking specifies mooring requirements that drive gang allocation and scheduling. Essential for operational coordination and billing reconcilia',
    `call_id` BIGINT COMMENT 'Reference to the vessel call (port visit) record associated with this mooring operation. A vessel call may have multiple mooring operations (arrival, departure, shifts). Links to the vessel_call data product.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel master record for the vessel receiving the mooring service. Links to the vessel data product for vessel particulars including LOA, DWT, and GRT.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Mooring gang sizing, line specification (SWL), and bollard selection require vessel master data (LOA, beam, DWT) for safe mooring operations and SOLAS compliance. Removes denormalized vessel identifie',
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
    `tariff_code` STRING COMMENT 'Port tariff code applied to this mooring operation for billing purposes, referencing the applicable rate schedule in the ports tariff book. Used in SAP S/4HANA billing integration.',
    `tide_height_m` DECIMAL(18,2) COMMENT 'Recorded tide height in metres above chart datum at the time of the mooring operation commencement. Critical for under-keel clearance assessment and mooring line angle calculations.',
    `total_lines_count` STRING COMMENT 'Total number of mooring lines deployed across all configurations (head, stern, breast, spring) for this operation. Used for equipment inventory reconciliation and billing.',
    `towage_assist_used` BOOLEAN COMMENT 'Indicates whether tug assistance was used in conjunction with this mooring operation to manoeuvre the vessel to or from the berth. Used for service coordination and billing linkage to towage operations.',
    `vessel_movement_type` STRING COMMENT 'Indicates the vessel movement context for which the mooring service is being performed: arrival at berth, departure from berth, or an intra-port shift between berths or positions.. Valid values are `arrival|departure|shift`',
    `visibility_category` STRING COMMENT 'Categorical assessment of meteorological visibility conditions at the time of the mooring operation: good (>5nm), moderate (2-5nm), poor (0.5-2nm), very poor (<0.5nm). Used for safety risk assessment.. Valid values are `good|moderate|poor|very_poor`',
    `wind_direction` STRING COMMENT 'Compass direction from which the wind was blowing at the berth location during the mooring operation, expressed as a 16-point compass bearing. Used for safety assessment and incident investigation.. Valid values are `^(N|NNE|NE|ENE|E|ESE|SE|SSE|S|SSW|SW|WSW|W|WNW|NW|NNW)$`',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Recorded wind speed in knots at the berth location at the time of the mooring operation. Used for safety assessment, incident investigation, and environmental condition logging.',
    CONSTRAINT pk_mooring_operation PRIMARY KEY(`mooring_operation_id`)
) COMMENT 'Transactional record for each mooring and unmooring service performed at a berth, buoy, or dolphin within port waters. Captures mooring gang assigned, number and configuration of lines deployed (head, breast, spring, stern), mooring equipment used (capstans, bollards, quick-release hooks), SWL compliance verification, commencement and completion timestamps, tide height and weather conditions, vessel movement type (arrival, departure, shift), and any mooring irregularities or safety observations. SSOT for all mooring service delivery events.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` (
    `launch_dispatch_id` BIGINT COMMENT 'Unique surrogate identifier for each launch boat dispatch event record in the silver layer lakehouse. Primary key for the launch_dispatch data product.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Launch/pilot boat operations are cost-tracked by marine services cost centre for fuel, maintenance, and crew cost allocation. Required for marine services departmental budgeting and cost recovery calc',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Launch boats transfer pilots and crew to vessels at anchorage; destination_location and anchorage_block currently text. Essential for pilot boat routing, fuel planning, and service coordination.',
    `employee_id` BIGINT COMMENT 'Reference to the workforce record of the coxswain (launch boat operator) assigned to and responsible for this dispatch. Links to the crew/workforce master.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Launch/pilot boat services are billable marine services. Each dispatch (pilot transfer, crew change, stores delivery) generates charges. Links dispatch to invoice for launch service revenue recognitio',
    `marine_service_order_id` BIGINT COMMENT 'Foreign key linking to marine.marine_service_order. Business justification: Launch dispatch is the operational execution of launch services ordered via marine_service_order. The marine_service_order product has launch_service_required flag and launch_trip_count, indicating it',
    `pilot_id` BIGINT COMMENT 'Reference to the marine pilot record transported on this dispatch, applicable when dispatch_purpose is pilot_transfer. Enables traceability between pilot assignments and launch dispatch operations.',
    `pilotage_assignment_id` BIGINT COMMENT 'Reference to the associated pilotage order or marine service request that triggered this launch dispatch, enabling traceability between the service request and the physical dispatch execution.',
    `port_asset_id` BIGINT COMMENT 'Reference to the launch boat asset record assigned to this dispatch. Links to the fleet asset management entity capturing vessel name, registration, hull type, engine configuration, and certification status.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel record that this launch boat dispatch is serving (e.g., the ship receiving the pilot, crew, or surveyor). Links to the vessel master data product.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Launch dispatch to vessels requires vessel master data for ISPS security verification, pilot boarding ground determination, and P&I club notification protocols. Role-prefixed to distinguish from launc',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Launch services (pilot boats) are dispatched to serve booked vessel calls for pilot transfer. Booking triggers launch resource planning and scheduling. Operational necessity for pilot boarding/disemba',
    `actual_departure_time` TIMESTAMP COMMENT 'Actual timestamp when the launch boat departed the jetty. Compared against scheduled departure time to measure on-time performance and SLA compliance.',
    `actual_return_time` TIMESTAMP COMMENT 'Actual timestamp when the launch boat returned to the departure jetty after completing the dispatch mission. Used to calculate total mission duration and vessel availability.',
    `billing_reference` STRING COMMENT 'Reference number linking this dispatch event to the port billing and tariff management system (NAVIS N4 Billing module or SAP FI) for invoicing of launch boat service charges (THC, launch fees).',
    `cancellation_reason` STRING COMMENT 'Free-text reason for cancellation or abort of this dispatch, populated when dispatch_status is cancelled or aborted. Used for operational analysis and SLA dispute resolution.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Total weight in kilograms of any cargo or stores carried on this dispatch (e.g., chandler supplies, spare parts, provisions). Must not exceed the launch boats Safe Working Load (SWL). Null if no cargo carried.',
    `coxswain_licence_number` STRING COMMENT 'Official maritime authority licence number of the coxswain, verified at dispatch to confirm the operator holds a valid and current certification to operate the launch vessel.',
    `coxswain_name` STRING COMMENT 'Full name of the coxswain operating the launch boat for this dispatch, retained in the dispatch log for accountability, incident investigation, and regulatory compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this dispatch record was first created in the system, providing the audit trail creation marker for data lineage and compliance purposes.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the service charge amount (e.g., USD, SGD, AUD). Supports multi-currency port operations and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `departure_jetty` STRING COMMENT 'Name or code of the jetty, berth, or landing point from which the launch boat departed for this dispatch mission. Used for operational planning and berth utilisation reporting.',
    `destination_location` STRING COMMENT 'Target location or anchorage position where the launch boat is dispatched to (e.g., anchorage block, berth number, pilot boarding ground coordinates). Supports route planning and safety monitoring.',
    `dispatch_authorised_by` STRING COMMENT 'Name or identifier of the port operations officer or VTS controller who authorised this launch boat dispatch, providing an accountability trail for operational decisions.',
    `dispatch_priority` STRING COMMENT 'Operational priority classification of this dispatch. routine = standard scheduled service; urgent = expedited service required; emergency = immediate response (e.g., medical evacuation, safety incident).. Valid values are `routine|urgent|emergency`',
    `dispatch_purpose` STRING COMMENT 'Primary operational purpose of the launch boat dispatch. Drives resource allocation, safety protocols, and billing tariff selection. [ENUM-REF-CANDIDATE: pilot_transfer|crew_change|chandler_delivery|inspection|surveyor_boarding|customs_boarding|medical_evacuation — promote to reference product]',
    `dispatch_reference` STRING COMMENT 'Externally-known business reference number assigned to this dispatch event, used for cross-system tracking and communication with vessel agents, pilots, and port operations. Format: LD-YYYY-NNNNNN.. Valid values are `^LD-[0-9]{4}-[0-9]{6}$`',
    `dispatch_status` STRING COMMENT 'Current lifecycle state of the launch boat dispatch event. scheduled = assigned and awaiting departure; in_progress = launch underway; completed = mission accomplished and returned; cancelled = cancelled before departure; aborted = mission terminated mid-operation.. Valid values are `scheduled|in_progress|completed|cancelled|aborted`',
    `fuel_consumed_litres` DECIMAL(18,2) COMMENT 'Volume of fuel consumed in litres during this dispatch mission, recorded for fleet cost management, GHG emissions tracking, and MARPOL environmental reporting.',
    `incident_reference` STRING COMMENT 'Reference number of the formal marine incident report filed in connection with this dispatch, when incident_reported is True. Links to the marine incident management system for investigation tracking.',
    `incident_reported` BOOLEAN COMMENT 'Indicates whether a formal marine incident or near-miss report was raised in connection with this dispatch event. True = incident report filed; False = no incident. Triggers P&I club notification workflow when True.',
    `isps_clearance_verified` BOOLEAN COMMENT 'Indicates whether ISPS security clearance was verified for all persons and cargo on this dispatch prior to departure. Mandatory for port facility security compliance.',
    `life_jackets_worn` BOOLEAN COMMENT 'Indicates whether all persons on board the launch boat wore life jackets for the duration of this dispatch, as required by SOLAS and port safety standing orders.',
    `marpol_compliance_checked` BOOLEAN COMMENT 'Indicates whether MARPOL environmental compliance checks (e.g., no illegal discharge, waste handling) were completed for this dispatch. Mandatory for environmental management system (EMS) audit trails.',
    `mission_duration_minutes` STRING COMMENT 'Total elapsed time in minutes from actual departure to actual return for this dispatch mission. Stored as a raw operational field to support billing, SLA analysis, and fleet utilisation reporting.',
    `night_operation` BOOLEAN COMMENT 'Indicates whether this dispatch was conducted during night hours (typically between sunset and sunrise as defined by port standing orders). Night operations attract additional safety requirements and may carry premium tariff rates.',
    `passengers_carried` STRING COMMENT 'Total number of persons (pilots, crew, surveyors, inspectors, chandlers) transported on this dispatch. Must not exceed the launch boats certified passenger capacity. Critical for SOLAS safety compliance.',
    `pi_club_notified` BOOLEAN COMMENT 'Indicates whether the vessels Protection and Indemnity (P&I) club has been formally notified of an incident arising from this dispatch. Required for insurance and liability management.',
    `pilot_boarding_ground` STRING COMMENT 'Name or code of the designated pilot boarding/disembarking ground where the pilot transfer took place (e.g., anchorage block, outer roads, inner harbour). Defined by port authority standing orders.',
    `safety_observation` STRING COMMENT 'Free-text field for the coxswain or dispatcher to record any safety observations, near-misses, equipment anomalies, or unusual conditions encountered during the dispatch mission. Feeds into the port safety management system.',
    `scheduled_departure_time` TIMESTAMP COMMENT 'Planned departure timestamp for the launch boat from the jetty, aligned with the pilotage schedule or service request. Used for SLA monitoring and resource scheduling.',
    `sea_state_code` STRING COMMENT 'Observed sea state at time of dispatch using the Douglas Sea Scale (0=Glassy to 9=Phenomenal). Values 0-6 captured operationally; values above the launch boats operational limit trigger a safety hold. Critical for SOLAS and OHS compliance. [ENUM-REF-CANDIDATE: 0|1|2|3|4|5|6 — 7 candidates stripped; promote to reference product]',
    `service_charge_amount` DECIMAL(18,2) COMMENT 'Gross charge amount levied for this launch boat dispatch service as per the port tariff schedule. Expressed in the ports operating currency. Used for revenue recognition and billing reconciliation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this dispatch record, supporting audit trail requirements and change tracking in the silver layer lakehouse.',
    `visibility_nm` DECIMAL(18,2) COMMENT 'Observed meteorological visibility in nautical miles at time of dispatch. Low visibility conditions may require additional safety measures or dispatch suspension per port standing orders.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Recorded wind speed in knots at the time of dispatch departure, used to assess operational safety conditions and validate compliance with launch boat operational weather limits.',
    CONSTRAINT pk_launch_dispatch PRIMARY KEY(`launch_dispatch_id`)
) COMMENT 'SSOT for the complete launch boat service including fleet asset management and operational dispatch. Captures launch boat master data (vessel name, registration, hull type, engine configuration, passenger capacity, SWL for cargo, certification status, survey dates, assigned berth/jetty, operational availability) and each dispatch event (purpose — pilot transfer, crew change, chandler delivery, inspection, surveyor boarding — vessel served, departure/return times, sea state, passengers carried, coxswain identity, safety observations). Supports 24/7 pilot transfer operations and anchorage service delivery.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` (
    `surveyor_id` BIGINT COMMENT 'Unique system-generated identifier for each marine surveyor record. Primary key for the surveyor master data product within the marine domain.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Surveyor port access credential verification, passport validation, and accreditation body recognition require country master data (IMO member status, MOU membership) for security clearance and authori',
    `accreditation_body` STRING COMMENT 'Name of the classification society or professional body that has accredited and authorised the surveyor to conduct marine surveys. Determines the scope of surveys the individual may certify. [ENUM-REF-CANDIDATE: Lloyds|DNV|Bureau Veritas|ClassNK|ABS|RINA|CCS|BKI|other — promote to reference product]',
    `authorisation_granted_date` DATE COMMENT 'Date on which the port authority formally granted the surveyor authorisation to operate within port jurisdiction. Marks the start of the surveyors active engagement lifecycle at the port.',
    `authorisation_revocation_date` DATE COMMENT 'Date on which the surveyors port authorisation was revoked or permanently withdrawn. Null if the surveyor has never been revoked. Used for compliance audit trails and ISPS security records.',
    `authorisation_status` STRING COMMENT 'Current lifecycle status of the surveyors authorisation to operate within port jurisdiction. Controls gate access, survey report acceptance, and P&I notification eligibility. Active = fully authorised; Suspended = temporarily restricted; Expired = credentials lapsed; Revoked = permanently withdrawn; Pending = application under review.. Valid values are `active|suspended|expired|revoked|pending`',
    `availability_status` STRING COMMENT 'Current operational availability of the surveyor for new survey assignments. Used by the Port Management Information System (PMIS) and marine services scheduling to dispatch surveyors to vessels in a timely manner.. Valid values are `available|on_assignment|unavailable|on_leave`',
    `surveyor_code` STRING COMMENT 'Externally-known unique alphanumeric code assigned to the surveyor by the port authority or accreditation body. Used as the business-facing identifier on survey certificates, gate access systems, and Port Community System (PCS) messaging.. Valid values are `^[A-Z]{2,4}-[0-9]{4,8}$`',
    `company_name` STRING COMMENT 'Name of the surveying firm, classification society branch, or P&I correspondent organisation to which the surveyor is affiliated. Used for billing, correspondence, and stakeholder management in the Port Community System (PCS).',
    `company_registration_number` STRING COMMENT 'Official business registration number of the surveyors affiliated company as issued by the relevant national corporate registry. Required for trade compliance verification and customs integration via the Port Community System (PCS).',
    `email` STRING COMMENT 'Primary professional email address for the surveyor. Used for survey appointment notifications, P&I club correspondence, port access credential communications, and EDI messaging via the Port Community System (PCS).. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `full_name` STRING COMMENT 'Full legal name of the marine surveyor as registered with their accreditation body and port authority. Used for identification on survey reports, port access credentials, and P&I correspondence.',
    `home_port_code` STRING COMMENT 'Five-character UN/LOCODE of the port at which the surveyor is primarily based and authorised to operate. Determines jurisdiction of authorisation and primary assignment area within the port network.. Valid values are `^[A-Z]{5}$`',
    `imdg_certified` BOOLEAN COMMENT 'Indicates whether the surveyor is certified to survey and certify the handling, stowage, and transport of dangerous goods in accordance with the International Maritime Dangerous Goods (IMDG) Code.',
    `insurance_expiry_date` DATE COMMENT 'Date on which the surveyors professional indemnity insurance coverage expires. Port access authorisation is contingent on valid insurance; this date triggers renewal alerts and access suspension workflows.',
    `insurance_policy_number` STRING COMMENT 'Policy reference number for the surveyors professional indemnity insurance. Recorded for port authority compliance verification and P&I club notification processes.',
    `insurance_provider` STRING COMMENT 'Name of the insurance company or P&I Club providing professional indemnity coverage for the surveyor. Required as part of port authorisation to ensure liability coverage for survey activities within port waters.',
    `languages_spoken` STRING COMMENT 'Comma-separated list of ISO 639-1 language codes for languages the surveyor is proficient in. Relevant for vessel boarding communications, survey report preparation, and coordination with international vessel crews.',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit or vetting review conducted by the port authority or accreditation body on the surveyors credentials, insurance, and operational performance. Supports Port State Control (PSC) readiness.',
    `licence_expiry_date` DATE COMMENT 'Date on which the surveyors current licence or accreditation certificate expires. Port access and survey report acceptance are automatically restricted when this date is passed and authorisation_status is not renewed.',
    `licence_issue_date` DATE COMMENT 'Date on which the surveyors current licence or accreditation certificate was issued by the authorising body. Used to calculate licence age and determine renewal eligibility.',
    `licence_number` STRING COMMENT 'Official licence or certificate number issued by the accreditation body or national maritime authority authorising the surveyor to conduct marine surveys. Referenced on all survey certificates and port access documentation.',
    `marpol_certified` BOOLEAN COMMENT 'Indicates whether the surveyor holds a valid certification to conduct surveys and inspections under the International Convention for the Prevention of Pollution from Ships (MARPOL). Required for pollution prevention and environmental compliance surveys.',
    `mobile_phone` STRING COMMENT 'Mobile/cell phone number for the surveyor in E.164 international format. Used for on-call survey dispatch, real-time vessel boarding coordination, and emergency contact during port operations.. Valid values are `^+[1-9][0-9]{6,14}$`',
    `multi_port_authorised` BOOLEAN COMMENT 'Indicates whether the surveyor holds authorisation to operate across multiple port facilities within the port authoritys jurisdiction, beyond their primary home port. Relevant for port groups managing multiple terminals.',
    `next_audit_due_date` DATE COMMENT 'Scheduled date for the next mandatory compliance audit or credential review of the surveyor. Drives proactive renewal workflows and prevents lapsed authorisations from disrupting port operations.',
    `notes` STRING COMMENT 'Free-text operational notes recorded by port authority staff regarding the surveyors credentials, special conditions of authorisation, known limitations, or relevant historical context. Not used for structured reporting.',
    `on_call_flag` BOOLEAN COMMENT 'Indicates whether the surveyor is currently designated as on-call for emergency or after-hours survey dispatch, including marine incident response, P&I notifications, and urgent cargo condition surveys.',
    `passport_number` STRING COMMENT 'Passport number of the surveyor as recorded for ISPS port security screening and identity verification. Required for international surveyors accessing restricted port areas.',
    `phone` STRING COMMENT 'Primary contact phone number for the surveyor in E.164 international format. Used for urgent survey dispatch, marine incident response coordination, and P&I club notifications.. Valid values are `^+[1-9][0-9]{6,14}$`',
    `pi_club_affiliation` STRING COMMENT 'Name of the Protection and Indemnity (P&I) Club for which the surveyor acts as a correspondent or appointed representative. Relevant for P&I surveyors handling cargo claims, collision liability, and pollution incidents within port waters.',
    `port_access_credential_number` STRING COMMENT 'Unique credential or pass number issued by the port authority granting the surveyor physical access to port facilities, berths, and vessels. Linked to ISPS-compliant access control systems and gate operations in NAVIS N4.',
    `port_access_expiry_date` DATE COMMENT 'Date on which the surveyors port access credential expires. Expiry triggers automatic access revocation in the ports ISPS-compliant gate control system and requires re-application.',
    `port_access_issue_date` DATE COMMENT 'Date on which the port access credential was issued to the surveyor. Used for access lifecycle management and ISPS compliance auditing.',
    `preferred_contact_method` STRING COMMENT 'The surveyors preferred channel for receiving survey dispatch notifications and port communications. Options include email, phone, mobile, pcs_message (Port Community System message), or edi (Electronic Data Interchange).. Valid values are `email|phone|mobile|pcs_message|edi`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the surveyor master record was first created in the system. Provides the audit trail entry point for the surveyors lifecycle within the ports data systems, aligned with Silver Layer lineage requirements.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the surveyor master record. Used for change data capture (CDC) in the Databricks Silver Layer pipeline and compliance audit trails.',
    `revocation_reason` STRING COMMENT 'Textual description of the reason for revocation of the surveyors port authorisation, where applicable. Supports compliance investigations, PSC audit responses, and ISPS security incident records.',
    `scope_of_authorisation` STRING COMMENT 'Detailed description of the specific survey activities, vessel types, cargo categories, or operational areas the surveyor is authorised to cover within port jurisdiction. May reference SOLAS, MARPOL, IMDG, or classification society-specific survey categories.',
    `seaman_book_number` STRING COMMENT 'Seafarers identity document or continuous discharge book number, where applicable. Some classification society and P&I surveyors hold seafarer credentials that facilitate vessel boarding under ILO Maritime Labour Convention requirements.',
    `solas_certified` BOOLEAN COMMENT 'Indicates whether the surveyor holds a valid certification to conduct surveys under the International Convention for the Safety of Life at Sea (SOLAS). Required for structural, safety equipment, and load line surveys.',
    `specialisation_codes` STRING COMMENT 'Comma-separated list of specialisation codes indicating the surveyors certified areas of expertise, such as IMDG dangerous goods, MARPOL pollution prevention, SOLAS structural surveys, draught surveys, or reefer cargo. Drives survey assignment matching in the Port Management Information System (PMIS).',
    `surveyor_type` STRING COMMENT 'Categorical classification of the surveyors primary function within port operations. Values: classification (classification society surveyor), pi_correspondent (P&I Club correspondent), cargo (cargo surveyor), condition (condition/on-hire/off-hire surveyor), draught (draught survey specialist).. Valid values are `classification|pi_correspondent|cargo|condition|draught`',
    `vessel_type_authorisations` STRING COMMENT 'Comma-separated list of vessel types the surveyor is authorised to survey, such as container vessels, bulk carriers, tankers, RoRo vessels, LNG carriers, or passenger ships. Ensures correct surveyor-to-vessel matching for survey assignments.',
    `years_of_experience` STRING COMMENT 'Total number of years of professional marine surveying experience. Used for surveyor capability assessment, complex survey assignment eligibility, and SLA performance benchmarking.',
    CONSTRAINT pk_surveyor PRIMARY KEY(`surveyor_id`)
) COMMENT 'Master record for each marine surveyor authorised to operate within port jurisdiction. Covers classification society surveyors, P&I correspondents, cargo surveyors, condition surveyors, and draught surveyors. Captures surveyor name, accreditation body (Lloyds, DNV, Bureau Veritas, ClassNK, ABS), surveyor type, scope of authorisation, contact details, company affiliation, port access credentials, insurance validity, and current active status. SSOT for surveyor identity and authorisation within port waters.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` (
    `survey_appointment_id` BIGINT COMMENT 'Unique system-generated identifier for each marine survey appointment record. Primary key for the survey_appointment data product.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Survey services (cargo, vessel condition) are contracted under framework agreements with surveyors or survey companies. Required for rate application, service scope verification, and billing. Common i',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Draft surveys, bunker surveys, and condition surveys conducted at anchorage; anchorage_reference currently text. Required for surveyor dispatch, launch coordination, and survey report accuracy.',
    `berth_id` BIGINT COMMENT 'Reference to the berth where the vessel is moored at the time of the survey, linking to the berth master data product.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Cargo survey scope and surveyor authorization depend on commodity code (HS code, IMDG class, quarantine requirements) for customs compliance, dangerous goods verification, and handling method approval',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Survey appointments are coordinated by specific port operations staff - real scheduling workflow requiring employee accountability for appointment management and stakeholder coordination.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Survey coordination is an administrative function under marine compliance or port operations cost centre. Required for overhead allocation and regulatory compliance cost tracking in port authority fin',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Marine surveys (draft, cargo, condition, bunker) are chargeable services provided by port-appointed or independent surveyors. Each appointment must be invoiced. Links survey to billing document for su',
    `marine_incident_id` BIGINT COMMENT 'Reference to an associated marine incident record when the survey is triggered by a marine incident (e.g., collision, grounding, cargo damage). Links to the marine incident data product.',
    `marine_service_order_id` BIGINT COMMENT 'Foreign key linking to marine.marine_service_order. Business justification: Survey appointment is the operational execution of surveyor services ordered via marine_service_order. The marine_service_order product has surveyor_required flag and surveyor_type, indicating it is t',
    `personnel_id` BIGINT COMMENT 'Foreign key linking to security.security_personnel. Business justification: ISPS Code requires security escort for surveyors accessing restricted cargo holds, engine rooms, and security-sensitive vessel areas. Port facility security plan mandates tracking which security offic',
    `call_id` BIGINT COMMENT 'Reference to the specific port call or vessel visit during which the survey is conducted, linking to the port call or vessel visit record.',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Surveyors inspect quay wall condition during vessel operations (fender damage, bollard integrity). Coordinates structural inspection scheduling and links marine incidents to infrastructure asset manag',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Survey appointments are requested by shipping agents, cargo owners, or P&I clubs - all port community participants. Link enables survey authorization validation, billing to correct party, service requ',
    `surveyor_id` BIGINT COMMENT 'Reference to the appointed marine surveyor responsible for conducting the survey, linking to the surveyor or workforce master record.',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Survey appointments (cargo, draft, condition surveys) are scheduled for booked vessel calls. Booking drives surveyor allocation and scheduling. Essential for operational coordination, regulatory compl',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel being surveyed, linking to the vessel master data product.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Survey scope determination and certificate issuance require vessel master data (classification society, flag state, P&I club, SOLAS/MARPOL compliance status) for regulatory compliance and surveyor aut',
    `actual_commencement` TIMESTAMP COMMENT 'The actual date and time at which the survey commenced on board or at the survey location. Used for SLA performance measurement and billing.',
    `actual_completion` TIMESTAMP COMMENT 'The actual date and time at which the survey was concluded and the surveyor departed the vessel or survey location. Used for duration calculation and billing.',
    `appointment_reference` STRING COMMENT 'Externally-known alphanumeric reference number assigned to the survey appointment, used in correspondence with surveyors, P&I clubs, and port stakeholders. Format: SVY-YYYY-NNNNNN.. Valid values are `^SVY-[0-9]{4}-[0-9]{6}$`',
    `appointment_status` STRING COMMENT 'Current lifecycle state of the survey appointment, tracking progression from scheduling through completion or cancellation. [ENUM-REF-CANDIDATE: scheduled|in_progress|completed|cancelled|postponed|on_hold — promote to reference product]. Valid values are `scheduled|in_progress|completed|cancelled|postponed|on_hold`',
    `cancellation_reason` STRING COMMENT 'Reason for cancellation or postponement of the survey appointment when appointment_status is cancelled or postponed. Captures operational context such as vessel departure, weather, surveyor unavailability.',
    `cargo_quantity_mt` DECIMAL(18,2) COMMENT 'Quantity of cargo in metric tonnes within the scope of the survey, particularly relevant for draught surveys and pre-loading surveys where cargo weight determination is the primary objective.',
    `cargo_scope` STRING COMMENT 'Description of the cargo or equipment included within the scope of the survey, including commodity type, quantity, and relevant cargo identifiers (e.g., Bill of Lading numbers, container numbers, bulk cargo description).',
    `certificate_reference` STRING COMMENT 'Reference number of the survey certificate or formal survey report issued upon completion of the survey, used for regulatory compliance tracking and document management.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the survey appointment record was first created in the system, providing the audit trail creation marker.',
    `deficiency_count` STRING COMMENT 'Number of deficiencies or non-conformances identified during the survey. Used for PSC inspection risk profiling and vessel performance tracking.',
    `deficiency_description` STRING COMMENT 'Narrative description of deficiencies, non-conformances, or observations identified during the survey. Provides qualitative context beyond the deficiency count.',
    `draught_aft_m` DECIMAL(18,2) COMMENT 'Aft draught reading of the vessel in metres at the time of the survey, recorded for draught surveys to determine cargo weight by displacement calculation.',
    `draught_forward_m` DECIMAL(18,2) COMMENT 'Forward draught reading of the vessel in metres at the time of the survey, recorded for draught surveys to determine cargo weight by displacement calculation.',
    `draught_midship_m` DECIMAL(18,2) COMMENT 'Midship draught reading of the vessel in metres at the time of the survey, used in conjunction with forward and aft draughts for accurate displacement and cargo weight calculation.',
    `isps_compliance_flag` BOOLEAN COMMENT 'Indicates whether ISPS Code security requirements were verified as part of the survey scope, applicable for condition surveys and port facility security assessments.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the survey appointment record was most recently modified, supporting audit trail and data lineage requirements.',
    `marpol_compliance_flag` BOOLEAN COMMENT 'Indicates whether MARPOL-related environmental compliance aspects were assessed during the survey, particularly relevant for condition surveys and damage surveys involving potential pollution risk.',
    `pi_club_name` STRING COMMENT 'Name of the P&I club insuring the vessel, notified in connection with damage surveys or marine incidents (e.g., UK P&I Club, Gard, Skuld, West of England).',
    `pi_club_notified` BOOLEAN COMMENT 'Indicates whether the vessels P&I (Protection and Indemnity) club has been formally notified of the survey appointment, particularly relevant for damage surveys and incident-related surveys.',
    `pi_notification_timestamp` TIMESTAMP COMMENT 'Date and time at which the P&I club was formally notified of the survey or marine incident, used for insurance claim timeline management.',
    `psc_inspection_triggered` BOOLEAN COMMENT 'Indicates whether the survey outcome or deficiencies identified triggered a formal Port State Control inspection by the relevant PSC authority.',
    `rectification_deadline` DATE COMMENT 'The date by which identified deficiencies must be rectified and evidence of rectification submitted to the surveying authority. Applicable when survey outcome is failed or conditional_pass.',
    `report_reference` STRING COMMENT 'Reference number of the detailed survey report document produced by the surveyor, distinct from the certificate number. Used for document retrieval and audit trail.',
    `scheduled_commencement` TIMESTAMP COMMENT 'The planned date and time at which the survey is scheduled to commence, used for surveyor dispatch planning and vessel scheduling coordination.',
    `solas_compliance_flag` BOOLEAN COMMENT 'Indicates whether the survey was conducted in compliance with SOLAS requirements, confirming that mandatory SOLAS survey protocols were followed.',
    `survey_duration_minutes` STRING COMMENT 'Total elapsed time in minutes from actual survey commencement to actual completion. Used for operational performance analysis and billing verification.',
    `survey_location_type` STRING COMMENT 'Classification of the physical location where the survey is conducted, distinguishing between berth-side, anchorage, dry dock, buoy mooring, or offshore positions.. Valid values are `berth|anchorage|dry_dock|buoy|offshore`',
    `survey_notes` STRING COMMENT 'Free-text operational notes and observations recorded by the surveyor or port marine services team regarding the survey appointment, including special conditions, access arrangements, or supplementary findings.',
    `survey_outcome` STRING COMMENT 'The formal result or finding of the survey engagement. passed indicates satisfactory condition, failed indicates deficiencies requiring rectification, conditional_pass indicates minor deficiencies with conditions attached, inconclusive indicates insufficient evidence for determination, deferred indicates survey could not be completed and must be rescheduled.. Valid values are `passed|failed|conditional_pass|inconclusive|deferred`',
    `survey_type` STRING COMMENT 'Classification of the marine survey engagement indicating the nature and scope of the inspection. Values include: condition survey (general vessel condition assessment), draught survey (cargo weight determination by displacement), damage survey (assessment of vessel or cargo damage), pre-loading survey (cargo readiness inspection before loading), hatch inspection (hatch cover integrity and weathertightness check).. Valid values are `condition_survey|draught_survey|damage_survey|pre_loading_survey|hatch_inspection`',
    `surveying_organisation` STRING COMMENT 'Name of the classification society, P&I club surveying firm, or independent marine surveying organisation that appointed the surveyor (e.g., Lloyds Register, Bureau Veritas, DNV, ABS).',
    `weather_conditions` STRING COMMENT 'Description of prevailing weather conditions at the time of the survey, relevant for draught surveys and condition surveys where environmental conditions affect survey accuracy and safety.',
    CONSTRAINT pk_survey_appointment PRIMARY KEY(`survey_appointment_id`)
) COMMENT 'Transactional record for each marine survey engagement at the port, capturing the survey type (condition survey, draught survey, damage survey, pre-loading survey, hatch inspection), vessel being surveyed, appointed surveyor, survey commencement and completion timestamps, berth or anchorage location, cargo or equipment scope, survey outcome, and certificate or report reference number.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` (
    `marine_incident_id` BIGINT COMMENT 'Unique system-generated identifier for each marine incident record. Primary key for the incident data product.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Incidents at anchorage (dragging anchor, vessel collision, pollution) require precise location for investigation, anchorage closure decisions, and holding ground assessment. Safety and environmental c',
    `berth_id` BIGINT COMMENT 'Reference to the berth or terminal location where the incident occurred, if applicable. Links to the berth/facility master data product.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Marine incidents in channels (grounding, collision, navigation error) require channel identification for safety analysis, channel closure decisions, and dredging priority assessment. Regulatory report',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Marine incidents involving pollution, ballast water discharge violations, or emissions breaches must reference the underlying MARPOL operation record. PSC inspections and environmental investigations ',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: Marine incidents triggering regulatory breaches (MARPOL pollution, SOLAS safety violations, ISPS security failures) generate formal compliance violation records. Port authorities must link incident in',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Incidents trigger investigation and remediation costs allocated to responsible operational cost centres. Essential for safety cost tracking, insurance claim preparation, and risk management financial ',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Marine incidents frequently damage port assets (fenders, cranes, bollards, tugs). Insurance claims, corrective action planning, and root cause analysis require linking incidents to affected assets for',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Incident reporting obligations, investigation protocols, and notification timelines are determined by flag state regulations (SOLAS/MARPOL ratification, flag state authority contact) for regulatory co',
    `gang_id` BIGINT COMMENT 'Foreign key linking to workforce.gang. Business justification: Incidents involving stevedore gangs require gang identification for safety investigation and root cause analysis - real safety management requirement in terminal operations.',
    `pilotage_assignment_id` BIGINT COMMENT 'Reference to the pilotage assignment active at the time of the incident, if a pilot was on board. Links to the pilotage service record.',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Vessel contact with quay wall is common incident type; links marine incident to infrastructure damage assessment, structural inspection triggering, and repair cost allocation. Asset management integra',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Incidents must be logged by specific employee for accountability and investigation chain-of-custody - mandatory safety management and regulatory reporting requirement in maritime operations.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Marine incidents often have security dimensions requiring parallel security incident records: sabotage causing vessel damage, unauthorized boarding attempts, piracy threats, ISPS breaches during cargo',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: Marine incidents (collisions, spills, damage) may involve trucks on terminal; incident investigation requires truck visit records for root cause analysis, liability determination, and comprehensive sa',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Marine incidents are tracked against vessel call bookings for liability determination, insurance claims, and operational reporting. Critical for P&I club notifications, port authority incident managem',
    `vessel_id` BIGINT COMMENT 'Reference to the primary vessel involved in the incident. Links to the vessel master data product.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Incident reporting to flag state authorities, P&I clubs, classification societies, and IMO requires authoritative vessel master data (registered owner, P&I club code, flag state authority contact) for',
    `amsa_notified` BOOLEAN COMMENT 'Indicates whether the Australian Maritime Safety Authority (AMSA) has been formally notified of the incident as required under national maritime safety regulations.',
    `contributing_factors` STRING COMMENT 'Structured narrative of secondary contributing factors identified during investigation, such as weather conditions, equipment state, crew fatigue, or procedural non-compliance. Supports multi-causal analysis.',
    `corrective_actions` STRING COMMENT 'Structured narrative of corrective and preventive actions (CAPAs) identified during the investigation, including responsible parties and target completion dates. Drives safety management system updates.',
    `corrective_actions_completed` BOOLEAN COMMENT 'Indicates whether all corrective and preventive actions identified in the investigation have been fully implemented and verified as effective.',
    `corrective_actions_due_date` DATE COMMENT 'Target date by which all corrective and preventive actions identified in the investigation must be completed and verified. Used for safety management follow-up tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the incident record was first created in the system. Audit trail field for data lineage and regulatory compliance.',
    `datetime` TIMESTAMP COMMENT 'The precise date and time (UTC) at which the marine incident occurred or was first observed. This is the principal real-world event timestamp used for regulatory reporting and investigation timelines.',
    `estimated_damage_cost_usd` DECIMAL(18,2) COMMENT 'Estimated total financial cost of damage to vessel, cargo, and port infrastructure resulting from the incident, expressed in USD. Used for insurance claims, P&I notifications, and financial reporting.',
    `fatalities_count` STRING COMMENT 'Total number of fatalities directly resulting from the incident. A non-zero value triggers mandatory IMO Very Serious Casualty classification and flag-state notification.',
    `flag_state_notified` BOOLEAN COMMENT 'Indicates whether the vessels flag state administration has been formally notified of the incident as required under SOLAS Chapter XI-1 Regulation 6.',
    `human_factor_involved` BOOLEAN COMMENT 'Indicates whether a human factor (crew error, pilot error, shore-side decision) was identified as a contributing cause of the incident. Used for safety trend analysis and training programme targeting.',
    `immediate_cause` STRING COMMENT 'Narrative description of the direct, proximate cause of the incident as determined during initial reporting (e.g., Mooring line parted under excessive load, Engine failure during berthing manoeuvre). May be updated during formal investigation.',
    `imo_notified` BOOLEAN COMMENT 'Indicates whether the IMO has been formally notified of the incident. Required for Very Serious Casualties under the IMO Casualty Investigation Code.',
    `incident_category` STRING COMMENT 'IMO casualty severity classification of the incident. Very Serious Casualty involves loss of vessel, loss of life, or severe pollution. Drives mandatory flag-state and IMO reporting obligations. [ENUM-REF-CANDIDATE: very_serious_casualty|serious_casualty|less_serious_casualty|marine_incident|near_miss — promote to reference product]. Valid values are `very_serious_casualty|serious_casualty|less_serious_casualty|marine_incident|near_miss`',
    `incident_type` STRING COMMENT 'Operational classification of the type of marine incident. Determines applicable SOLAS/MARPOL regulatory framework and investigation protocol. [ENUM-REF-CANDIDATE: collision|grounding|allision|mooring_failure|pollution_event|fire_explosion|man_overboard|structural_failure|near_miss|flooding — promote to reference product]',
    `infrastructure_damage_description` STRING COMMENT 'Narrative description of damage to port infrastructure (berth, fender, quay wall, mooring bollard, crane) resulting from the incident. Triggers Maximo work order creation for repair.',
    `injuries_count` STRING COMMENT 'Total number of persons sustaining injuries (non-fatal) as a direct result of the incident. Includes crew, port workers, and any other persons on board or in the vicinity.',
    `investigation_close_date` DATE COMMENT 'Date on which the formal investigation was officially closed and findings were finalised. Null if investigation is still open.',
    `investigation_lead` STRING COMMENT 'Name or employee identifier of the designated lead investigator responsible for conducting the formal investigation under the IMO Casualty Investigation Code.',
    `investigation_start_date` DATE COMMENT 'Date on which the formal investigation was officially opened. Used to track investigation duration against regulatory and internal SLA targets.',
    `investigation_status` STRING COMMENT 'Current lifecycle status of the incident investigation workflow. Tracks progression from initial report through formal investigation under the IMO Casualty Investigation Code to final closure.. Valid values are `reported|under_investigation|findings_issued|corrective_action_pending|closed|cancelled`',
    `investigation_team` STRING COMMENT 'Comma-separated list of investigation team member names or employee IDs assigned to the formal investigation. Supports accountability and audit trail for the investigation process.',
    `isps_security_implication` BOOLEAN COMMENT 'Indicates whether the incident has a security dimension requiring notification or action under the ISPS (International Ship and Port Facility Security) Code.',
    `location_description` STRING COMMENT 'Human-readable description of the incident location referencing port-specific landmarks such as berth number, fairway name, anchorage zone, or channel designation (e.g., Berth 7 - North Quay, Main Fairway Km 3.2).',
    `location_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate (decimal degrees, WGS84) of the incident location within port waters. Used for spatial analysis, VTS replay, and regulatory reporting.',
    `location_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate (decimal degrees, WGS84) of the incident location within port waters. Used for spatial analysis, VTS replay, and regulatory reporting.',
    `marpol_classification` STRING COMMENT 'The specific MARPOL annex under which a pollution incident is classified (e.g., Annex I - Oil, Annex II - Noxious Liquid Substances, Annex V - Garbage). Null if no pollution component.',
    `missing_persons_count` STRING COMMENT 'Number of persons reported missing following the incident (e.g., man-overboard events). Drives search-and-rescue coordination and regulatory notification.',
    `pi_club_notification_datetime` TIMESTAMP COMMENT 'Date and time the P&I (Protection and Indemnity) club was formally notified of the incident. Used to verify compliance with P&I notification windows.',
    `pi_club_notified` BOOLEAN COMMENT 'Indicates whether the vessel owners P&I (Protection and Indemnity) club has been formally notified of the incident. Mandatory for incidents involving third-party liability, pollution, or personal injury.',
    `pollution_occurred` BOOLEAN COMMENT 'Indicates whether a pollution event (oil spill, chemical release, garbage discharge) occurred as part of or as a consequence of the incident. Triggers MARPOL reporting obligations.',
    `pollution_substance` STRING COMMENT 'Type of substance released into the marine environment (e.g., Bunker fuel oil, Bilge water, Noxious liquid substance - Category X). Populated only when pollution_occurred is True.',
    `pollution_volume_litres` DECIMAL(18,2) COMMENT 'Estimated or measured volume of pollutant released into port waters, expressed in litres. Used for environmental impact assessment and MARPOL regulatory reporting.',
    `psc_notified` BOOLEAN COMMENT 'Indicates whether Port State Control (PSC) authorities have been formally notified of the incident. Required for incidents meeting PSC notification thresholds under the Paris/Tokyo MOU.',
    `reference_number` STRING COMMENT 'Externally-known alphanumeric reference number assigned to the incident for cross-system tracking, regulatory notifications, and stakeholder communications (e.g., INC-2024-000123).. Valid values are `^INC-[0-9]{4}-[0-9]{6}$`',
    `reported_datetime` TIMESTAMP COMMENT 'The date and time the incident was formally reported to port authorities or the duty officer. Used to measure reporting lag and compliance with mandatory notification windows.',
    `root_cause` STRING COMMENT 'Formal root cause determination from the completed investigation, identifying the underlying systemic or human factor that enabled the incident. Populated upon investigation completion.',
    `solas_classification` STRING COMMENT 'The specific SOLAS chapter or regulation under which this incident is classified for regulatory reporting purposes (e.g., SOLAS Chapter II-1, Chapter III, Chapter XI-1). Null if incident is MARPOL-only.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the incident record was most recently modified. Supports audit trail, data lineage, and change tracking in the Databricks Silver Layer.',
    `vessel_damage_description` STRING COMMENT 'Narrative description of structural or mechanical damage sustained by the primary vessel as a result of the incident. Informs seaworthiness assessment and P&I club notification.',
    `visibility_nautical_miles` DECIMAL(18,2) COMMENT 'Recorded horizontal visibility in nautical miles at the incident location at the time of the incident. Relevant to collision and grounding investigations.',
    `weather_conditions` STRING COMMENT 'Recorded meteorological conditions at the time of the incident including wind speed/direction, visibility, sea state, and precipitation. Sourced from VTS or port meteorological station records.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'Recorded wind speed in knots at the incident location at the time of the incident. Key environmental factor in casualty investigation and risk modelling.',
    CONSTRAINT pk_marine_incident PRIMARY KEY(`marine_incident_id`)
) COMMENT 'SSOT for all marine incident records and their investigation lifecycle within port waters. Covers the full incident-to-closure process: initial reporting of near-misses, collisions, groundings, allisions, mooring failures, pollution events, and man-overboard events; formal investigation under IMO Casualty Investigation Code including root cause analysis, contributing factor classification, and corrective actions; and regulatory notification dispatch (AMSA, PSC, flag state, IMO). Captures incident datetime, location (lat/long and berth/fairway reference), vessels involved, incident category (SOLAS/MARPOL classification), immediate cause, injuries/fatalities, environmental impact, investigation team, findings, and closure status.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` (
    `pni_club_notification_id` BIGINT COMMENT 'Primary key for pni_club_notification',
    `adjustment_id` BIGINT COMMENT 'Foreign key linking to billing.billing_adjustment. Business justification: P&I club claims frequently result in credit notes for disputed pilotage, towage, or damage charges. Insurance settlements require billing adjustments. Links P&I notification to credit note for insuran',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Claims for incidents at anchorage require precise location for liability assessment (port authority vs vessel fault). Insurance and legal documentation standard.',
    `berth_id` BIGINT COMMENT 'Reference to the berth or terminal location where the vessel was berthed or operating at the time of the incident. Supports spatial analysis of incident patterns and infrastructure liability assessment.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: P&I claims reference incident location including channel for liability determination (pilotage error, channel defect). Legal documentation and insurance claim processing requirement.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: P&I club notifications track claims by or against specific port community participants (shipping lines, stevedores, agents). Link supports claims management, legal case tracking, settlement processing',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: P&I club notifications for regulatory breaches (customs violations, MARPOL non-compliance, ISPS failures) must link to formal violation records. Claims processing requires violation reference numbers,',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: P&I claims for cargo damage during drayage require drayage order details; claims processing links notifications to transport orders for cargo tracing, liability determination, and settlement documenta',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: P&I club jurisdiction, correspondent appointment, and legal hold protocols depend on flag state (flag state authority, registry type, recognized organizations) for claims processing and legal complian',
    `marine_incident_id` BIGINT COMMENT 'Foreign key linking to marine.marine_incident. Business justification: P&I club notifications are formal insurance notifications triggered by marine incidents. The notification should reference the incident that caused it. This creates a clear parent-child relationship w',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: P&I club notifications are filed by specific port staff - real compliance and legal workflow requiring employee accountability for insurance claim initiation and liability management.',
    `pilotage_assignment_id` BIGINT COMMENT 'Reference to the pilotage service record active at the time of the incident, where the incident occurred during a pilotage operation. Relevant for determining pilot liability and compulsory pilotage exemptions under applicable port regulations.',
    `call_id` BIGINT COMMENT 'Reference to the specific port call or vessel visit during which the incident occurred. Links the P&I notification to the vessels berth allocation, pilotage, and towage records for that call.',
    `provision_id` BIGINT COMMENT 'Foreign key linking to finance.provision. Business justification: P&I club notifications trigger provision recognition for estimated claim liabilities. Direct accounting standard requirement (IAS 37) linking marine insurance claims to financial statement provisions ',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Claims for quay wall damage require asset identification for insurance settlement, repair cost recovery, and liability determination. Links marine claim to infrastructure asset for financial recovery.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: P&I claims arising from security incidents (stowaway repatriation costs, piracy-related vessel damage, sabotage liability, ISPS non-compliance fines) require linkage between club notification and secu',
    `towage_order_id` BIGINT COMMENT 'Reference to the towage operation record active at the time of the incident, where the incident occurred during a towage operation. Relevant for determining tug operator liability and contractual terms under BIMCO Towcon/Towhire agreements.',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: P&I claims involving truck damage to vessels/infrastructure require truck visit evidence; claims handlers link notifications to gate transactions for liability assessment, evidence collection, and cla',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: P&I club notifications reference vessel call bookings for claim context, liability tracking, and insurer correspondence. Essential for insurance workflow, commercial dispute resolution, and linking cl',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel involved in the incident for which this P&I notification is raised. Enables cross-referencing with vessel operations, call records, and insurance history.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: P&I club claims processing requires vessel master data (P&I club code, registered owner, classification society) for jurisdiction determination, correspondent appointment, and reserve calculation. Rem',
    `acknowledgement_datetime` TIMESTAMP COMMENT 'Timestamp at which the P&I club formally acknowledged receipt of this notification. Used to measure notification response time and to confirm the clubs acceptance of the notification within required timeframes.',
    `bol_number` STRING COMMENT 'Bill of Lading number associated with the cargo involved in the incident, where the claim relates to cargo damage or loss. The BOL is the primary document of title and contract of carriage for the affected cargo.',
    `claim_type` STRING COMMENT 'Classification of the nature of the claim or liability event triggering this P&I notification. Determines the applicable P&I club rules, coverage provisions, and claims handling pathway. [ENUM-REF-CANDIDATE: cargo_damage|personal_injury|pollution|collision|property_damage|wreck_removal|third_party_liability — promote to reference product]',
    `closure_date` DATE COMMENT 'Date on which the P&I notification was formally closed, either following settlement of the claim, withdrawal of the notification, or determination that no liability exists. Null if the notification remains open.',
    `closure_reason` STRING COMMENT 'Reason for the closure of the P&I notification. Indicates the outcome of the claims process, including settlement, determination of no liability, withdrawal by the claimant, time-bar under applicable limitation convention, or subrogation to another insurer.. Valid values are `settled|no_liability|withdrawn|time_barred|subrogated`',
    `club_correspondent_contact` STRING COMMENT 'Contact details (phone, email, or address) for the P&I club correspondent assigned to this notification. Used for direct communication during claims handling and survey coordination.',
    `club_correspondent_name` STRING COMMENT 'Name of the local P&I club correspondent or appointed representative at the port who is handling this notification on behalf of the P&I club. Correspondents act as the clubs local agents for surveys, evidence gathering, and initial claims management.',
    `club_handler_name` STRING COMMENT 'Name of the claims handler or case manager assigned by the P&I club to manage this notification and any resulting claim. Primary point of contact at the club for all correspondence related to this matter.',
    `club_reference_number` STRING COMMENT 'The unique reference number assigned by the P&I club upon receipt and registration of this notification. Used in all subsequent correspondence, claims handling, and legal proceedings with the club.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp at which this P&I notification record was first created in the port management system. Audit trail field for data governance and lineage tracking.',
    `edi_message_reference` STRING COMMENT 'Reference number of the EDI message used to transmit this notification, where notification_channel is edi. Enables traceability of electronic transmissions through the Port Community System (PCS).',
    `estimated_liability_amount` DECIMAL(18,2) COMMENT 'Ports or insured partys initial estimate of the total financial liability exposure arising from this incident, expressed in the notification currency. Used for reserve setting, financial provisioning, and EBITDA impact assessment. This is an estimate, not a settled claim value.',
    `incident_date` DATE COMMENT 'Calendar date on which the marine incident or casualty event occurred. Used for statute of limitations tracking, regulatory reporting timelines, and claims aging analysis.',
    `incident_description` STRING COMMENT 'Narrative description of the marine incident, casualty, or event giving rise to this P&I notification. Includes circumstances, sequence of events, parties involved, and initial assessment of cause. Sourced from the marine incident report.',
    `incident_location` STRING COMMENT 'Description of the geographic location where the incident occurred, such as berth number, terminal name, anchorage area, port approach channel, or specific coordinates within port waters. Supports jurisdictional determination and liability assessment.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp at which this P&I notification record was most recently modified in the port management system. Supports change tracking, audit compliance, and Silver layer delta processing in the Databricks Lakehouse.',
    `legal_hold_flag` BOOLEAN COMMENT 'Indicates whether a legal hold has been placed on all records, evidence, and documentation related to this P&I notification. When True, all associated records must be preserved and must not be altered, deleted, or archived pending legal proceedings or investigation.',
    `liability_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the estimated liability exposure amount is denominated. Typically USD for international maritime claims, but may vary by jurisdiction.. Valid values are `^[A-Z]{3}$`',
    `marpol_reportable_flag` BOOLEAN COMMENT 'Indicates whether the incident involves a pollution event that triggers mandatory reporting obligations under MARPOL 73/78 (Marine Pollution Convention). When True, notification to the coastal state and flag state authority is required.',
    `notification_channel` STRING COMMENT 'The communication channel or method used to transmit the P&I notification to the club. EDI (Electronic Data Interchange) is increasingly used for structured notifications via Port Community Systems.. Valid values are `email|fax|edi|portal|telephone|letter`',
    `notification_datetime` TIMESTAMP COMMENT 'The principal real-world timestamp at which the P&I club was formally notified of the incident or claim. This is the legally significant notification moment, distinct from record creation time.',
    `notification_reference` STRING COMMENT 'Externally-known, human-readable reference number assigned to this P&I club notification at the time of creation. Used in all correspondence with the P&I club and legal parties. Format: PNI-YYYY-NNNNNN.. Valid values are `^PNI-[0-9]{4}-[0-9]{6}$`',
    `notification_status` STRING COMMENT 'Current lifecycle status of the P&I club notification. Tracks progression from initial drafting through submission, acknowledgement by the club, active review, and final closure or withdrawal.. Valid values are `draft|submitted|acknowledged|under_review|closed|withdrawn`',
    `notifying_party_role` STRING COMMENT 'Role or capacity in which the notifying party is acting when submitting the P&I notification. Determines the standing of the notifying party under the P&I club rules and applicable maritime law.. Valid values are `shipowner|operator|port_authority|legal_representative|correspondent|charterer`',
    `pi_club_name` STRING COMMENT 'Full legal name of the P&I (Protection and Indemnity) mutual insurance club to which the notification has been submitted. Examples include UK P&I Club, Gard, Skuld, West of England, North of England, Steamship Mutual.',
    `port_legal_counsel` STRING COMMENT 'Name of the legal counsel or law firm appointed by the port authority to represent its interests in connection with this P&I notification and any resulting legal proceedings.',
    `psc_notified_flag` BOOLEAN COMMENT 'Indicates whether the Port State Control (PSC) authority has been formally notified of the incident in accordance with applicable port state regulations and international conventions.',
    `reserve_amount` DECIMAL(18,2) COMMENT 'Financial reserve amount set aside by the P&I club or port authority against this notification to cover anticipated claim payments. Distinct from the estimated liability exposure; represents the formal accounting provision. Used for CAPEX/OPEX financial planning and EBITDA impact reporting.',
    `reserve_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the P&I reserve amount is denominated.. Valid values are `^[A-Z]{3}$`',
    `settled_amount` DECIMAL(18,2) COMMENT 'Final amount agreed and paid in settlement of the claim associated with this P&I notification. Populated upon closure with reason settled. Used for claims cost analysis, reserve adequacy assessment, and financial reporting.',
    `solas_reportable_flag` BOOLEAN COMMENT 'Indicates whether the underlying incident meets the threshold for mandatory reporting under SOLAS (Safety of Life at Sea) Convention requirements. When True, formal casualty reporting to the flag state and IMO is required.',
    `survey_date` DATE COMMENT 'Date on which the marine survey was conducted or is scheduled to be conducted. Used for tracking survey completion and ensuring timely evidence gathering within the claims process.',
    `surveyor_appointed_flag` BOOLEAN COMMENT 'Indicates whether a marine surveyor has been formally appointed by the P&I club or port authority to conduct a survey of the damage, loss, or incident. Surveyor appointment is a standard step in the P&I claims process.',
    `surveyor_name` STRING COMMENT 'Name of the marine surveyor or survey firm appointed to assess the damage or incident. Populated when surveyor_appointed_flag is True. Used for coordination of survey activities and report tracking.',
    CONSTRAINT pk_pni_club_notification PRIMARY KEY(`pni_club_notification_id`)
) COMMENT 'Records all P&I (Protection and Indemnity) club notifications raised in connection with marine incidents, cargo damage, personal injury, pollution events, or third-party liability claims occurring within port waters. Captures P&I club name, club reference number, notification datetime, notifying party, incident reference, nature of claim, estimated liability exposure, legal hold flag, and notification status. SSOT for P&I correspondence records.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` (
    `marpol_operation_id` BIGINT COMMENT 'Unique surrogate identifier for each MARPOL-regulated compliance operation record within the port. Primary key for this entity. Role: TRANSACTION_HEADER.',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: MARPOL waste reception operations (oily waste, sewage, garbage disposal) generate charge events for port reception facility fees. Each operation creates a billable event. Links MARPOL operation to cha',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Marine operational MARPOL records (waste reception, ballast water management) must link to compliance regulatory MARPOL records for audit trail. PSC inspections require evidence of proper waste dispos',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Environmental compliance operations (waste reception, ballast water treatment) are cost-tracked by environmental/marine services cost centre. Required for regulatory cost reporting and environmental l',
    `port_asset_id` BIGINT COMMENT 'Reference to the licensed port reception facility that received or processed the ship-generated waste or emissions for this operation.',
    `call_id` BIGINT COMMENT 'Reference to the specific port call (vessel visit) during which this MARPOL operation was conducted. Links the compliance activity to the vessels berth allocation and scheduling records.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the licensed waste management contractor responsible for collecting, transporting, and disposing of the ship-generated waste. Contractor must hold valid port authority and environmental licences.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: MARPOL waste operations require named supervisor for environmental compliance and regulatory accountability - mandatory requirement under international maritime environmental regulations.',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: Hazmat waste removal via truck requires MARPOL compliance tracking; environmental officers link waste operations to truck movements for regulatory reporting, manifest verification, and environmental a',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: MARPOL waste reception operations are scheduled for booked vessel calls. Booking drives environmental compliance service planning and port reception facility allocation. Regulatory requirement for was',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel that generated or delivered the waste/emission subject to this MARPOL operation. Links to the vessel master record.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: MARPOL compliance reporting to flag state and port state control requires vessel master data (MARPOL compliance status, classification society, flag state authority) for regulatory verification and PS',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Waste disposal operations require commodity classification (MARPOL category, UN number, disposal method) for regulatory compliance, facility licensing verification, and environmental monitoring. Role-',
    `ballast_water_treatment_method` STRING COMMENT 'Method used to treat or manage ballast water in compliance with the BWM Convention. Applicable when operation_type = ballast_water_management.. Valid values are `exchange|uv_treatment|chemical_treatment|filtration|heat_treatment|no_treatment`',
    `ballast_water_volume_m3` DECIMAL(18,2) COMMENT 'Volume of ballast water in cubic metres managed (exchanged, treated, or discharged) during this operation under the BWM Convention. Applicable when operation_type = ballast_water_management.',
    `berth_code` STRING COMMENT 'Code identifying the berth or terminal location where the vessel was moored during this MARPOL operation. Used for spatial analysis of waste generation and facility utilisation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this MARPOL operation record was first created in the system. Audit trail field for data governance and regulatory record-keeping compliance.',
    `disposal_method` STRING COMMENT 'Method by which the waste was disposed of or treated after reception at the port facility. Drives environmental compliance reporting and contractor performance tracking. [ENUM-REF-CANDIDATE: incineration|landfill|recycling|treatment|discharge_at_sea|reuse|composting — promote to reference product]',
    `environmental_monitoring_ref` STRING COMMENT 'Reference identifier linking this MARPOL operation to a corresponding record in the Environmental Monitoring System (EMS) for air quality, water quality, or emissions tracking data.',
    `facility_capacity_m3` DECIMAL(18,2) COMMENT 'Declared storage or processing capacity of the port reception facility in cubic metres at the time of this operation. Used for capacity planning and adequacy assessments per MARPOL requirements.',
    `facility_inspection_status` STRING COMMENT 'Current inspection and certification status of the port reception facility at the time of the operation. Facilities must maintain valid inspection status to legally receive MARPOL-regulated waste.. Valid values are `current|expired|suspended|pending_renewal`',
    `facility_licence_number` STRING COMMENT 'Official licence or permit number issued by the port authority or environmental regulator authorising the reception facility to receive and process specific categories of ship-generated waste.',
    `facility_type` STRING COMMENT 'Type of port reception facility used for this MARPOL operation: fixed onshore facility, mobile collection unit, reception barge, tanker truck, or pipeline connection.. Valid values are `fixed_facility|mobile_unit|barge|tanker_truck|pipeline`',
    `ghg_emission_mt_co2e` DECIMAL(18,2) COMMENT 'Total greenhouse gas (GHG) emissions in metric tonnes of CO₂ equivalent recorded or calculated for this MARPOL Annex VI operation. Supports IMO GHG Strategy reporting and CII (Carbon Intensity Indicator) calculations.',
    `marpol_annex_code` STRING COMMENT 'Identifies the specific MARPOL Annex governing this operation: ANNEX_I (Oil), ANNEX_II (Noxious Liquid Substances), ANNEX_IV (Sewage), ANNEX_V (Garbage), ANNEX_VI (Air Emissions — SOx, NOx, GHG). Drives applicable regulatory requirements and reporting obligations.. Valid values are `ANNEX_I|ANNEX_II|ANNEX_IV|ANNEX_V|ANNEX_VI`',
    `non_compliance_description` STRING COMMENT 'Free-text description of the nature of the MARPOL non-compliance identified during this operation, including the specific regulation breached and observed conditions. Populated only when non_compliance_flag = True.',
    `non_compliance_flag` BOOLEAN COMMENT 'Indicates whether this MARPOL operation was found to be non-compliant with applicable MARPOL Annex requirements. True = non-compliance identified; False = compliant. Triggers escalation to port authority and flag state.',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether the required regulatory notification (to flag state authority, port state authority, or P&I club) has been dispatched for this MARPOL operation. True = notification sent; False = pending.',
    `nox_emission_g_kwh` DECIMAL(18,2) COMMENT 'Measured nitrogen oxide (NOx) emission rate in grams per kilowatt-hour recorded during air emission monitoring under MARPOL Annex VI. Used to verify compliance with Tier I/II/III NOx limits.',
    `oil_record_book_entry_code` STRING COMMENT 'Standardised IMO operation code from the Oil Record Book (Part I — Machinery Space Operations; Part II — Cargo/Ballast Operations) that classifies the specific oil-related activity recorded under MARPOL Annex I. Applicable only when marpol_annex_code = ANNEX_I.',
    `operation_end_timestamp` TIMESTAMP COMMENT 'Date and time at which the MARPOL compliance operation was completed or concluded. Used to calculate operation duration and for regulatory log completeness.',
    `operation_reference_number` STRING COMMENT 'Externally-known unique alphanumeric reference number assigned to this MARPOL compliance operation, used in waste manifests, port authority sign-off documents, and regulatory submissions. Format: MARPOL-{PORT_CODE}-{YEAR}-{SEQUENCE}.. Valid values are `^MARPOL-[A-Z]{3}-[0-9]{4}-[0-9]{6}$`',
    `operation_status` STRING COMMENT 'Current lifecycle status of the MARPOL compliance operation, tracking progression from initiation through completion or cancellation. Used for operational dashboards and regulatory reporting.. Valid values are `pending|in_progress|completed|cancelled|under_review`',
    `operation_timestamp` TIMESTAMP COMMENT 'The principal real-world date and time at which the MARPOL compliance operation commenced (e.g., waste delivery start, oil record book entry time, emission monitoring event time). Stored in UTC with timezone offset per ISO 8601.',
    `operation_type` STRING COMMENT 'Classifies the nature of the MARPOL compliance activity: waste delivery to reception facility, oil record book entry, garbage management log, sewage discharge record, air emission monitoring event, or ballast water management operation. [ENUM-REF-CANDIDATE: waste_delivery|oil_record_entry|garbage_management|sewage_discharge|air_emission_monitoring|ballast_water_management — promote to reference product]. Valid values are `waste_delivery|oil_record_entry|garbage_management|sewage_discharge|air_emission_monitoring|ballast_water_management`',
    `pi_club_notified_flag` BOOLEAN COMMENT 'Indicates whether the vessels Protection and Indemnity (P&I) club has been notified of this MARPOL operation, particularly relevant for incidents, non-compliance events, or significant waste deliveries.',
    `port_authority_signoff_by` STRING COMMENT 'Name or identifier of the port authority officer who officially signed off and verified this MARPOL compliance operation. Required for regulatory audit trail and PSC inspection records.',
    `port_authority_signoff_timestamp` TIMESTAMP COMMENT 'Date and time at which the port authority officer officially signed off on this MARPOL compliance operation, confirming regulatory requirements were met.',
    `psc_deficiency_noted` BOOLEAN COMMENT 'Indicates whether a PSC inspector noted a deficiency or non-conformance during inspection of this MARPOL operation. True = deficiency recorded; False = no deficiency. Applicable when psc_inspection_flag = True.',
    `psc_inspection_flag` BOOLEAN COMMENT 'Indicates whether this MARPOL operation was subject to a Port State Control (PSC) inspection. True = PSC inspection conducted; False = routine operation without PSC inspection.',
    `quantity` DECIMAL(18,2) COMMENT 'The measured quantity of waste delivered, discharged, or emission recorded in this MARPOL operation. Expressed in the unit defined by quantity_unit. For oil: cubic metres (m³); for garbage: cubic metres or kilograms; for emissions: metric tonnes.',
    `quantity_unit` STRING COMMENT 'Unit of measurement for the waste or emission quantity recorded in this operation. m3 = cubic metres, kg = kilograms, mt = metric tonnes, litres = litres. Aligns with MARPOL reporting unit requirements per annex.. Valid values are `m3|kg|mt|litres|TEU`',
    `remarks` STRING COMMENT 'Free-text field for additional operational notes, special circumstances, or supplementary information recorded by the port officer or contractor regarding this MARPOL compliance operation.',
    `source_system_reference` STRING COMMENT 'Original record identifier from the operational source system (e.g., Port Community System PCS, Environmental Monitoring System EMS, or PMIS) that originated this MARPOL operation record. Supports data lineage and reconciliation.',
    `sox_emission_ppm` DECIMAL(18,2) COMMENT 'Measured concentration of sulphur oxide (SOx) emissions in parts per million (ppm) recorded during air emission monitoring operations under MARPOL Annex VI. Applicable when marpol_annex_code = ANNEX_VI.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this MARPOL operation record was most recently modified. Supports audit trail, data lineage, and change tracking for regulatory compliance.',
    `waste_category` STRING COMMENT 'Specific category of waste or pollutant managed in this operation, aligned with MARPOL waste classification (e.g., oily bilge water, sludge, garbage — food waste, garbage — plastics, sewage, noxious liquid substances, SOx emissions, NOx emissions, GHG). [ENUM-REF-CANDIDATE: oily_bilge_water|oily_sludge|noxious_liquid|sewage|food_waste|plastics|operational_waste|cargo_residues|sox_emissions|nox_emissions|ghg_emissions|ballast_water — promote to reference product]',
    `waste_manifest_number` STRING COMMENT 'Reference number of the official waste transfer manifest document accompanying the ship-generated waste delivery. Used for chain-of-custody tracking and regulatory audit trail.',
    CONSTRAINT pk_marpol_operation PRIMARY KEY(`marpol_operation_id`)
) COMMENT 'SSOT for all MARPOL-regulated compliance activities within port waters, consolidating operational records, waste reception transactions, and port reception facility master data. Covers oil record book entries (Annex I), garbage management (Annex V), sewage discharge (Annex IV), air emissions monitoring (Annex VI — SOx, NOx, GHG), ballast water management (BWM Convention), and ship-generated waste deliveries. Captures vessel, activity type, waste category, quantity, disposal method, receiving facility details (type, capacity, licensed contractor, inspection status), waste manifest references, collection timestamps, and port authority sign-off. Supports MARPOL compliance reporting to flag state and port state authorities.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` (
    `pilotage_exemption_id` BIGINT COMMENT 'Unique identifier for the Pilotage Exemption Certificate record. Primary key.',
    `pilotage_route_id` BIGINT COMMENT 'add column pilotage_route_id (BIGINT) with FK to marine.pilotage_route.pilotage_route_id - exemptions are route-specific and must reference the applicable pilotage route',
    `port_community_participant_id` BIGINT COMMENT 'add column port_community_participant_id (BIGINT) with FK to customer.port_community_participant.port_community_participant_id - pilotage exemptions are issued to a specific shipping line or master who is a port community participant',
    `vessel_master_id` BIGINT COMMENT 'add column vessel_master_id (BIGINT) with FK to masterdata.vessel_master.vessel_master_id - pilotage exemptions are granted per vessel and must link to the vessel master record',
    `authorized_berths` STRING COMMENT 'Comma-separated list of specific berth numbers or terminal areas the master is authorized to approach and berth at under this exemption.',
    `authorized_fairway_sections` STRING COMMENT 'Comma-separated list or description of specific fairway sections, channels, or routes within the port that the master is authorized to navigate without a compulsory pilot.',
    `authorized_vessel_types` STRING COMMENT 'Comma-separated list or description of vessel types the master is authorized to navigate under this exemption (e.g., container vessels, bulk carriers, tankers, RoRo vessels).',
    `certificate_number` STRING COMMENT 'The official certificate number issued by the port authority or maritime regulatory body for this pilotage exemption. Externally-known business identifier.. Valid values are `^PEC-[A-Z0-9]{8,12}$`',
    `conditions_and_restrictions` STRING COMMENT 'Any special conditions, limitations, or restrictions attached to this pilotage exemption certificate (e.g., daylight only, specific weather conditions, tug assistance required).',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this pilotage exemption certificate record was first created in the system.',
    `effective_from_date` DATE COMMENT 'The date from which the pilotage exemption certificate becomes valid and the master is authorized to navigate without a compulsory pilot.',
    `examination_date` DATE COMMENT 'The date on which the master completed the pilotage exemption examination or assessment.',
    `examination_result` STRING COMMENT 'The outcome of the pilotage exemption examination: pass (met all requirements), fail (did not meet requirements), conditional_pass (passed with conditions), or exempt (waived based on experience).. Valid values are `pass|fail|conditional_pass|exempt`',
    `examination_score` DECIMAL(18,2) COMMENT 'The numerical score or percentage achieved by the master in the pilotage exemption examination.',
    `examiner_name` STRING COMMENT 'Name of the authorized examiner or pilot who conducted the pilotage exemption assessment.',
    `exemption_type` STRING COMMENT 'Classification of the pilotage exemption: full (all fairways), partial (specific routes only), conditional (subject to conditions), or temporary (limited duration trial).. Valid values are `full|partial|conditional|temporary`',
    `expiry_date` DATE COMMENT 'The date on which the pilotage exemption certificate expires and is no longer valid unless renewed.',
    `insurance_certificate_number` STRING COMMENT 'The certificate number of the Protection and Indemnity (P&I) insurance or professional indemnity insurance covering the master for pilotage exemption operations.',
    `insurance_expiry_date` DATE COMMENT 'The expiry date of the P&I or professional indemnity insurance coverage associated with this pilotage exemption.',
    `issue_date` DATE COMMENT 'The date on which the pilotage exemption certificate was officially issued to the vessel master.',
    `issuing_authority` STRING COMMENT 'Name of the port authority, harbor master office, or maritime regulatory body that issued this pilotage exemption certificate.',
    `issuing_authority_code` STRING COMMENT 'Standardized code identifying the issuing authority (e.g., port authority abbreviation or regulatory body code).. Valid values are `^[A-Z]{2,6}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this pilotage exemption certificate record was last updated or modified in the system.',
    `last_passage_date` DATE COMMENT 'The date of the most recent passage made by the master using this pilotage exemption certificate.',
    `last_renewal_date` DATE COMMENT 'The most recent date on which this pilotage exemption certificate was renewed or revalidated.',
    `master_license_number` STRING COMMENT 'The official license or certificate of competency number held by the vessel master, issued by the national maritime authority.',
    `master_name` STRING COMMENT 'Full legal name of the vessel master authorized under this pilotage exemption certificate.',
    `max_dwt_tonnes` DECIMAL(18,2) COMMENT 'The maximum vessel Deadweight Tonnage (DWT) in metric tonnes that the master is authorized to navigate under this pilotage exemption.',
    `max_grt_tonnes` DECIMAL(18,2) COMMENT 'The maximum vessel Gross Registered Tonnage (GRT) in tonnes that the master is authorized to navigate under this pilotage exemption.',
    `max_loa_meters` DECIMAL(18,2) COMMENT 'The maximum vessel Length Overall (LOA) in meters that the master is authorized to navigate under this pilotage exemption.',
    `medical_certificate_expiry_date` DATE COMMENT 'The expiry date of the masters medical fitness certificate, which may be a prerequisite for maintaining pilotage exemption validity.',
    `next_renewal_due_date` DATE COMMENT 'The date by which the certificate holder must apply for renewal to maintain continuous validity.',
    `pilotage_exemption_status` STRING COMMENT 'Current lifecycle status of the pilotage exemption certificate: active (valid and in use), expired (past expiry date), suspended (temporarily invalid), revoked (permanently cancelled), pending (awaiting approval), or under_review (renewal or modification in progress).. Valid values are `active|expired|suspended|revoked|pending|under_review`',
    `qualifying_passages_completed` STRING COMMENT 'The actual number of supervised qualifying passages the master completed before being issued this exemption certificate.',
    `qualifying_passages_required` STRING COMMENT 'The number of supervised passages through the authorized fairways that the master was required to complete before being granted the exemption certificate.',
    `remarks` STRING COMMENT 'Additional notes, comments, or observations related to this pilotage exemption certificate, including any special circumstances or historical context.',
    `renewal_requirements` STRING COMMENT 'Description of the requirements the master must fulfill for certificate renewal, such as minimum number of passages, re-examination, medical fitness, or continuing education.',
    `revocation_date` DATE COMMENT 'The date on which the pilotage exemption certificate was permanently revoked.',
    `revocation_reason` STRING COMMENT 'Reason for permanent revocation of the pilotage exemption certificate, if applicable (e.g., serious safety violation, loss of master license, fraudulent application).',
    `suspension_date` DATE COMMENT 'The date on which the pilotage exemption certificate was suspended.',
    `suspension_reason` STRING COMMENT 'Reason for suspension of the pilotage exemption certificate, if applicable (e.g., safety incident, medical unfitness, regulatory non-compliance).',
    `total_passages_under_exemption` STRING COMMENT 'The cumulative number of passages the master has completed using this pilotage exemption certificate since it was issued.',
    CONSTRAINT pk_pilotage_exemption PRIMARY KEY(`pilotage_exemption_id`)
) COMMENT 'Master record for each Pilotage Exemption Certificate (PEC) issued to a vessel master authorised to navigate specific port fairways without a compulsory pilot. Captures master name, certificate number, issuing authority, authorised vessel types and size limits (LOA, DWT, GRT), authorised fairway sections/routes, issue date, expiry date, number of qualifying passages completed, renewal requirements, examination results, and current validity status. SSOT for PEC management and compulsory pilotage exemption compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` (
    `marine_service_order_id` BIGINT COMMENT 'Unique identifier for the marine service order. Primary key for this entity.',
    `agent_appointment_id` BIGINT COMMENT 'Reference to the shipping agent or port community participant who requested the marine services on behalf of the vessel operator.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Master service order consolidating pilotage, towage, mooring services directly references the commercial agreement governing all services. Essential for rate lookup, SLA tracking, and consolidated bil',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Service orders specify which security zones vessel will transit during pilotage/towage; VTS coordinates with PFSO to pre-authorize zone access, issue temporary zone permits, and configure access contr',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Service orders are fulfilled by specific operational cost centres. Essential for service costing, profitability analysis by service line, and transfer pricing between port authority business units.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Marine service orders are raised by port operations staff - essential workflow tracking for service request authorization, accountability, and operational audit trails.',
    `mooring_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.mooring_tariff. Business justification: Marine service orders reference specific mooring tariffs for billing. Currently has tariff_code_mooring as a string. Adding FK to tariff.mooring_tariff enables proper tariff application and rate looku',
    `pilotage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.pilotage_tariff. Business justification: Marine service orders reference specific pilotage tariffs for billing. Currently has tariff_code_pilotage as a string. Adding FK to tariff.pilotage_tariff enables proper tariff application and rate lo',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the licensed pilotage service provider assigned to deliver pilotage services for this order. Must be an authorized pilot organization per port regulations.',
    `proforma_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.proforma_invoice. Business justification: Proforma invoices are issued before vessel arrival based on service orders (estimated pilotage, towage, mooring charges). Links service order to proforma for advance billing and pre-arrival payment co',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Service orders orchestrate vessel operations at rail-connected terminals; integrated planning requires linking marine services to rail schedules for coordinated vessel-rail transfers, resource allocat',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.service_code. Business justification: Marine service order billing, tariff application, GL account mapping, and revenue recognition require service code master data (billing basis, tax code, tariff schedule) for financial processing and r',
    `tertiary_marine_approved_mooring_provider_port_community_participant_id` BIGINT COMMENT 'Reference to the mooring service provider assigned to deliver line handling services for this order. Must be a certified mooring contractor with trained personnel.',
    `towage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.towage_tariff. Business justification: Marine service orders reference specific towage tariffs for billing. Currently has tariff_code_towage as a string. Adding FK to tariff.towage_tariff enables proper tariff application and rate lookup. ',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: Marine service orders coordinate vessel operations that trigger landside truck movements; port community systems integrate marine and gate operations for seamless cargo flow, appointment synchronizati',
    `call_id` BIGINT COMMENT 'Reference to the specific vessel call for which marine services are being ordered. Links this service order to the vessel visit event.',
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
    CONSTRAINT pk_marine_service_order PRIMARY KEY(`marine_service_order_id`)
) COMMENT 'Commercial service order record capturing the formal request and authorisation for bundled marine services (pilotage, towage, mooring, launch, surveyor boarding) for a specific vessel call. Captures requesting agent, vessel call reference, services requested with estimated service windows, approved service providers, agreed tariff codes, priority/urgency classification, and order lifecycle status (requested, confirmed, in-progress, completed, cancelled). Acts as the commercial anchor linking marine service delivery to the billing and tariff domains. SSOT for marine service commercials.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` (
    `pilot_duty_roster_id` BIGINT COMMENT 'Unique identifier for the pilot duty roster record. Primary key for the pilot duty roster entity.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Pilots assigned to specific boarding stations require security zone access credentials for that duty period; roster tracks which zones pilot is authorized to access (outer anchorage, inner harbor, res',
    `pilot_id` BIGINT COMMENT 'Reference to the pilot assigned to this duty roster. Links to the pilot master record.',
    `shift_pattern_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_pattern. Business justification: Pilot duty rosters follow defined shift patterns for fatigue management and MLC compliance - real scheduling relationship enabling rest hour compliance and workforce planning.',
    `swapped_pilot_duty_roster_id` BIGINT COMMENT 'Self-referencing FK on pilot_duty_roster (swapped_pilot_duty_roster_id)',
    `tertiary_relief_pilot_id` BIGINT COMMENT 'Reference to the relief pilot assigned to cover this duty roster in case of absence, emergency, or workload overflow.',
    `actual_assignments_completed` STRING COMMENT 'Number of pilotage assignments actually completed by the pilot during this roster period. Tracked for workload monitoring and billing.',
    `assigned_boarding_station` STRING COMMENT 'Name or code of the pilot boarding station where the pilot is assigned to operate during this roster period. Critical for geographic coverage planning.',
    `availability_status` STRING COMMENT 'Real-time availability status of the pilot during the roster period. Updated dynamically as assignments are made or pilot status changes.. Valid values are `available|assigned|unavailable|off_duty|on_leave|sick_leave`',
    `boarding_station_location` STRING COMMENT 'Geographic location description or coordinates of the assigned boarding station for operational reference and dispatch planning.',
    `cancellation_reason` STRING COMMENT 'Explanation or justification for cancelling this duty roster assignment, such as pilot illness, emergency, or operational changes.',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Date and time when this duty roster assignment was cancelled.',
    `contact_phone_number` STRING COMMENT 'Primary phone number for reaching the pilot during this duty roster period for assignment dispatch and operational coordination.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this duty roster record was first created in the system. Audit trail for roster scheduling lifecycle.',
    `cumulative_duty_hours_month` DECIMAL(18,2) COMMENT 'Total accumulated duty hours for the pilot in the current calendar month. Tracked for fatigue management and regulatory compliance.',
    `cumulative_duty_hours_week` DECIMAL(18,2) COMMENT 'Total accumulated duty hours for the pilot in the current rolling 7-day period. Monitored for compliance with maximum work hour regulations.',
    `duty_priority_level` STRING COMMENT 'Priority ranking of the pilot within the duty roster for assignment dispatch. Determines call-out sequence for pilotage requests.. Valid values are `primary|secondary|backup|emergency`',
    `fatigue_compliance_flag` BOOLEAN COMMENT 'Boolean indicator of whether the pilot is in compliance with mandatory rest hour requirements and fatigue management regulations for this roster period.',
    `fatigue_risk_score` DECIMAL(18,2) COMMENT 'Calculated fatigue risk assessment score based on cumulative duty hours, rest periods, and shift patterns. Used for proactive safety management.',
    `hours_of_rest_prior` DECIMAL(18,2) COMMENT 'Number of hours of rest the pilot has completed prior to commencing this duty roster period. Critical for fatigue management compliance.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this duty roster record was last updated or modified. Tracks changes to roster assignments and status updates.',
    `max_assignments_allowed` STRING COMMENT 'Maximum number of pilotage assignments the pilot is permitted to undertake during this roster period, based on fatigue management and safety regulations.',
    `night_pilotage_authorised` BOOLEAN COMMENT 'Boolean indicator of whether the pilot is authorized to conduct pilotage operations during night hours for this roster period.',
    `relief_reason` STRING COMMENT 'Explanation or justification for assigning a relief pilot to this duty roster, such as illness, emergency, or fatigue management.',
    `relief_timestamp` TIMESTAMP COMMENT 'Date and time when the relief pilot assumed duty for this roster assignment.',
    `roster_notes` STRING COMMENT 'Free-text operational notes, special instructions, or remarks related to this duty roster assignment for coordination and reference purposes.',
    `roster_period_end_timestamp` TIMESTAMP COMMENT 'Date and time when the pilot duty roster period concludes. Marks the end of the pilots scheduled availability window.',
    `roster_period_start_timestamp` TIMESTAMP COMMENT 'Date and time when the pilot duty roster period commences. Marks the beginning of the pilots scheduled availability window.',
    `roster_publication_date` DATE COMMENT 'Date when the duty roster was officially published and communicated to the pilot and operational teams. Establishes the baseline schedule.',
    `roster_published_by` STRING COMMENT 'Name or identifier of the duty scheduler or operations manager who published this roster assignment.',
    `roster_reference_number` STRING COMMENT 'Externally-known unique reference number for this duty roster assignment, used for operational communication and scheduling coordination.',
    `roster_status` STRING COMMENT 'Current lifecycle status of the duty roster assignment. Tracks progression from draft through publication to completion or cancellation.. Valid values are `draft|published|active|completed|cancelled|suspended`',
    `special_qualifications` STRING COMMENT 'Additional certifications, endorsements, or special qualifications held by the pilot that are relevant to this duty roster assignment, such as LNG carrier endorsement or deep-sea pilot authorization.',
    `standby_location` STRING COMMENT 'Physical location where the pilot is required to remain on standby during this roster period, such as pilot station, office, or designated facility.',
    `swap_approval_timestamp` TIMESTAMP COMMENT 'Date and time when the duty swap request was approved by the authorized scheduler or manager.',
    `swap_approved_flag` BOOLEAN COMMENT 'Boolean indicator of whether a requested duty swap has been approved by the duty scheduler or operations manager.',
    `swap_request_flag` BOOLEAN COMMENT 'Boolean indicator of whether a duty swap or exchange request has been submitted for this roster assignment.',
    `vhf_radio_channel` STRING COMMENT 'VHF radio channel assigned to the pilot for communication during this duty roster period. Critical for vessel traffic coordination.',
    `weather_restrictions` STRING COMMENT 'Any weather-related operational restrictions or limitations applicable to this duty roster period, such as maximum wind speed or minimum visibility requirements.',
    CONSTRAINT pk_pilot_duty_roster PRIMARY KEY(`pilot_duty_roster_id`)
) COMMENT 'Transactional scheduling record for pilot duty assignments, capturing roster period, pilot identifier, duty shift (day/night/standby), assigned boarding station, fatigue management compliance (hours of rest), roster publication date, swap/relief records, and availability status. SSOT for daily pilot scheduling and workload distribution, critical for ensuring compulsory pilotage coverage 24/7.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` (
    `tug_assignment_id` BIGINT COMMENT 'Unique identifier for the tug assignment record. Primary key for the tug assignment entity.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Individual tug deployments are cost-tracked for fuel, crew, and maintenance allocation to operational cost centres. Required for activity-based costing and tug fleet profitability analysis in port ope',
    `employee_id` BIGINT COMMENT 'Reference to the tug master (captain) in command of the tug during this assignment. Essential for crew accountability and competency tracking.',
    `reassigned_tug_assignment_id` BIGINT COMMENT 'Self-referencing FK on tug_assignment (reassigned_tug_assignment_id)',
    `towage_order_id` BIGINT COMMENT 'Reference to the parent towage order that this tug assignment fulfills. Links the individual tug assignment to the overall towage service request.',
    `tug_id` BIGINT COMMENT 'Reference to the specific tug vessel assigned to this towage operation. Identifies which tug from the fleet is performing the service.',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` (
    `weather_tide_window_id` BIGINT COMMENT 'Unique identifier for the weather and tidal condition observation record. Primary key for the weather_tide_window product.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Weather restrictions affect anchorage safety (wind exposure, holding ground); determines when vessels can safely anchor or must depart. Operational planning and VTS advisory requirement.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Tidal windows determine channel navigability; fairway_point_reference currently text. Critical for VTS coordination, pilotage scheduling, and vessel movement planning based on channel depth and tidal ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Weather and tide observations are recorded by specific port staff for operational safety decisions - real logging requirement enabling accountability for critical navigational safety data.',
    `revised_weather_tide_window_id` BIGINT COMMENT 'Self-referencing FK on weather_tide_window (revised_weather_tide_window_id)',
    `air_temperature_c` DECIMAL(18,2) COMMENT 'The ambient air temperature in degrees Celsius at the observation location and timestamp.',
    `barometric_pressure_hpa` DECIMAL(18,2) COMMENT 'The atmospheric pressure in hectopascals (hPa) at the observation location. Rapid pressure changes can indicate approaching weather systems and affect tidal predictions.',
    `chart_datum_reference` STRING COMMENT 'The vertical datum reference system used for tide height measurements (e.g., Lowest Astronomical Tide - LAT, Mean Lower Low Water - MLLW, Mean Sea Level - MSL).',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this weather and tide observation record was first created in the system, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Audit trail field.',
    `forecast_source` STRING COMMENT 'The meteorological or hydrographic agency or system that provided the forecast data used for predicted values (e.g., National Weather Service, Bureau of Meteorology, port tide prediction model).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this weather and tide observation record was last updated or modified in the system, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Audit trail field.',
    `marpol_environmental_flag` BOOLEAN COMMENT 'Boolean flag indicating whether environmental conditions (e.g., high winds, heavy seas) pose a risk for MARPOL compliance during cargo or bunkering operations (True = environmental risk present, False = no risk).',
    `max_vessel_draft_permitted_m` DECIMAL(18,2) COMMENT 'The maximum vessel draft in meters permitted to transit or berth under the observed tidal conditions, ensuring adequate under keel clearance (UKC).',
    `max_vessel_loa_permitted_m` DECIMAL(18,2) COMMENT 'The maximum vessel LOA (Length Overall) in meters permitted to conduct marine operations under the observed conditions. Larger vessels may be restricted due to wind, current, or UKC constraints.',
    `mooring_restriction_flag` BOOLEAN COMMENT 'Boolean flag indicating whether mooring operations are restricted or suspended due to the observed weather and tidal conditions (True = restricted, False = unrestricted).',
    `observation_location` STRING COMMENT 'The specific location within port waters where the observation was taken (e.g., fairway entrance, pilot boarding ground, berth approach channel, anchorage block).',
    `observation_reference` STRING COMMENT 'Human-readable unique reference number for the weather and tide observation window, formatted as WTW-YYYYMMDD-NNNN.. Valid values are `^WTW-[0-9]{8}-[0-9]{4}$`',
    `observation_remarks` STRING COMMENT 'Free-text field for additional notes, observations, or context provided by the observer or VTS operator regarding the weather and tidal conditions.',
    `observation_source` STRING COMMENT 'The source or method by which the observation was captured: automated sensor, manual reading by marine personnel, VTS (Vessel Traffic Service) report, weather station, tide gauge, or forecast model.. Valid values are `automated_sensor|manual_reading|vts_report|weather_station|tide_gauge|forecast_model`',
    `observation_status` STRING COMMENT 'Current lifecycle status of the observation record: preliminary (initial reading), validated (quality-checked), revised (corrected after review), final (confirmed and locked), or superseded (replaced by newer reading).. Valid values are `preliminary|validated|revised|final|superseded`',
    `observation_timestamp` TIMESTAMP COMMENT 'The precise date and time when the weather and tidal conditions were observed or recorded, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). This is the principal real-world event time for this observation.',
    `pilotage_restriction_flag` BOOLEAN COMMENT 'Boolean flag indicating whether pilotage operations are restricted or suspended due to the observed weather and tidal conditions (True = restricted, False = unrestricted).',
    `precipitation_mm` DECIMAL(18,2) COMMENT 'The amount of precipitation (rain, snow, sleet) in millimeters recorded during the observation period. Heavy precipitation can affect visibility and deck operations.',
    `restriction_reason` STRING COMMENT 'Detailed explanation of why marine service restrictions were imposed, referencing specific threshold breaches (e.g., wind speed exceeds 25 knots, visibility below 1 NM, tide height insufficient for UKC).',
    `sea_state_code` STRING COMMENT 'The Douglas Sea State code (0-9) describing sea surface conditions: 0=calm (glassy), 1=calm (rippled), 2=smooth, 3=slight, 4=moderate, 5=rough, 6=very rough, 7=high, 8=very high, 9=phenomenal.',
    `service_window_status` STRING COMMENT 'The derived operational decision for marine service delivery based on observed conditions: go (safe to proceed), no-go (unsafe, operations suspended), conditional (proceed with restrictions), or restricted (limited operations only).. Valid values are `go|no_go|conditional|restricted`',
    `solas_compliance_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the observation and any resulting operational decisions comply with SOLAS Chapter V navigation safety requirements (True = compliant, False = non-compliant or under review).',
    `swell_height_m` DECIMAL(18,2) COMMENT 'The height of ocean swell in meters at the observation location. Swell is long-period wave motion distinct from locally generated wind waves.',
    `tidal_phase` STRING COMMENT 'The current phase of the tidal cycle at observation time: high water (peak tide), low water (minimum tide), flood (rising tide), ebb (falling tide), or slack water (minimal current between flood and ebb).. Valid values are `high_water|low_water|flood|ebb|slack_water`',
    `tidal_stream_direction_degrees` STRING COMMENT 'The direction of the tidal current flow in degrees true (0-360), where 0/360 is north, 90 is east, 180 is south, and 270 is west.',
    `tidal_stream_rate_knots` DECIMAL(18,2) COMMENT 'The speed of the tidal current or stream in knots at the observation location and timestamp. Critical for pilotage and towage planning.',
    `tidal_window_end_timestamp` TIMESTAMP COMMENT 'The timestamp when the favorable tidal window closes for vessel movements requiring specific tide heights or UKC, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX).',
    `tidal_window_start_timestamp` TIMESTAMP COMMENT 'The timestamp when the favorable tidal window opens for vessel movements requiring specific tide heights or UKC, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX).',
    `tide_height_actual_m` DECIMAL(18,2) COMMENT 'The actual observed tidal height in meters above chart datum at the observation timestamp, measured by tide gauge or sensor. May differ from predicted due to meteorological effects (storm surge, barometric pressure).',
    `tide_height_predicted_m` DECIMAL(18,2) COMMENT 'The predicted tidal height in meters above chart datum at the observation timestamp, based on published tide tables and astronomical predictions.',
    `tide_height_variance_m` DECIMAL(18,2) COMMENT 'The difference between actual and predicted tide height in meters (actual minus predicted). Positive values indicate higher than predicted tide; negative values indicate lower than predicted.',
    `towage_restriction_flag` BOOLEAN COMMENT 'Boolean flag indicating whether towage operations are restricted or suspended due to the observed weather and tidal conditions (True = restricted, False = unrestricted).',
    `ukc_available_m` DECIMAL(18,2) COMMENT 'The calculated under keel clearance in meters available at the observation location based on current tide height and charted depth. Critical for deep-draft vessel movements.',
    `visibility_category` STRING COMMENT 'Categorical classification of visibility conditions: excellent (>10 NM), good (5-10 NM), moderate (2-5 NM), poor (1-2 NM), very poor (0.5-1 NM), or fog (<0.5 NM).. Valid values are `excellent|good|moderate|poor|very_poor|fog`',
    `visibility_nm` DECIMAL(18,2) COMMENT 'The horizontal visibility distance in nautical miles at the observation location. Critical for determining safe navigation conditions and pilotage operations.',
    `vts_notification_sent_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a notification of the weather and tidal conditions was sent to the Vessel Traffic Service (VTS) for broadcast to vessels (True = notification sent, False = not sent).',
    `water_temperature_c` DECIMAL(18,2) COMMENT 'The sea water temperature in degrees Celsius at the observation location. Relevant for vessel draft calculations and environmental monitoring.',
    `wave_height_m` DECIMAL(18,2) COMMENT 'The significant wave height in meters at the observation location, representing locally generated wind waves. Used to assess vessel motion and mooring safety.',
    `weather_condition` STRING COMMENT 'The general weather condition at the observation time: clear, partly cloudy, overcast, rain, heavy rain, drizzle, fog, mist, thunderstorm, or snow. [ENUM-REF-CANDIDATE: clear|partly_cloudy|overcast|rain|heavy_rain|drizzle|fog|mist|thunderstorm|snow|sleet|hail|squall — promote to reference product]',
    `wind_direction_degrees` STRING COMMENT 'The direction from which the wind is blowing, expressed in degrees true (0-360), where 0/360 is north, 90 is east, 180 is south, and 270 is west.',
    `wind_gust_speed_knots` DECIMAL(18,2) COMMENT 'The maximum wind gust speed in knots recorded during the observation period. Used to assess peak wind loading on vessels and equipment.',
    `wind_speed_knots` DECIMAL(18,2) COMMENT 'The sustained wind speed in knots at the observation location and timestamp. Critical for determining safe operating conditions for pilotage, towage, and mooring operations.',
    CONSTRAINT pk_weather_tide_window PRIMARY KEY(`weather_tide_window_id`)
) COMMENT 'Operational record of weather and tidal conditions affecting marine service delivery windows within port waters. Captures tide height predictions and actuals (referenced to chart datum), tidal stream rates, wind speed/direction, visibility, swell height, current readings at key fairway points, and derived go/no-go decisions for pilotage, towage, and mooring operations. Used for real-time service scheduling decisions and post-event analysis. SSOT for marine-operational weather and tide data within port jurisdiction.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` (
    `pilot_channel_authorisation_id` BIGINT COMMENT 'Primary key for the pilot_channel_authorisation association',
    `channel_id` BIGINT COMMENT 'Foreign key linking to the navigable channel for which this authorisation is granted',
    `pilot_id` BIGINT COMMENT 'Foreign key linking to the licensed marine pilot who holds this channel authorisation',
    `authorisation_date` DATE COMMENT 'Date on which this specific pilot-channel authorisation was officially granted by the port authority or maritime regulator. Used for compliance tracking and authorisation history.',
    `authorisation_expiry_date` DATE COMMENT 'Date on which this pilot-channel authorisation expires and must be renewed. Drives operational scheduling and compliance monitoring to ensure only authorised pilots are assigned to channels.',
    `authorisation_status` STRING COMMENT 'Current regulatory status of this pilot-channel authorisation. Determines whether the pilot can be operationally assigned to vessels transiting this channel.',
    `authorised_fairways` STRING COMMENT 'Comma-separated list of fairway section codes or names within the port jurisdiction that this pilot is authorised to navigate. Restricts pilot assignments to approved waterway sections in VTMS. Example: MAIN_CHANNEL,NORTH_APPROACH,INNER_HARBOUR. [Moved from pilot: This comma-separated text field is a denormalized representation of the many-to-many relationship between pilots and channels. Each pilot-channel authorisation should be a separate record in the association product, eliminating the need for this denormalized field. The detection reasoning explicitly identified this as currently denormalized as authorised_fairways text field on pilot table.]',
    `authorising_officer` STRING COMMENT 'Name or employee reference of the port authority officer or maritime regulator who granted this pilot-channel authorisation. Used for audit trail and regulatory compliance documentation.',
    `examination_date` DATE COMMENT 'Date on which the pilot successfully completed the mandatory examination or assessment for this specific channel. Required for initial authorisation and may be required for renewal after extended absence.',
    `last_passage_date` DATE COMMENT 'Date of the most recent pilotage passage completed by this pilot in this channel. Used to monitor recency of experience and trigger refresher requirements if extended periods elapse without activity.',
    `licence_endorsement_code` STRING COMMENT 'Specific endorsement code or reference number issued for this pilot-channel authorisation, linking to the pilots licence documentation and regulatory approval records.',
    `max_vessel_dwt_authorised` DECIMAL(18,2) COMMENT 'Maximum vessel Deadweight Tonnage (DWT) in metric tonnes that this pilot is authorised to handle specifically within this channel. Channel-specific authorisation may be more restrictive than the pilots general licence limits.',
    `max_vessel_loa_authorised_m` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall (LOA) in metres that this pilot is authorised to handle specifically within this channel. May differ from the pilots general max_loa_m based on channel-specific examination and experience requirements.',
    `passages_completed_count` STRING COMMENT 'Total number of pilotage passages this pilot has completed in this specific channel. Used for experience tracking, proficiency assessment, and authorisation renewal decisions.',
    CONSTRAINT pk_pilot_channel_authorisation PRIMARY KEY(`pilot_channel_authorisation_id`)
) COMMENT 'This association product represents the formal authorisation granted to a licensed marine pilot to conduct pilotage operations within a specific navigable channel or fairway. It captures the regulatory approval process, vessel size limits specific to the pilot-channel combination, examination results, passage experience, and authorisation validity periods. Each record links one pilot to one channel with attributes that exist only in the context of this specific authorisation relationship.. Existence Justification: In maritime port operations, pilots must obtain specific authorisation for each channel or fairway they are qualified to navigate, based on channel-specific examinations, passage experience, and vessel size limits. A single pilot holds authorisations for multiple channels (enabling operational flexibility), and each channel requires multiple authorised pilots to ensure 24/7 coverage and operational continuity. The authorisation itself is a regulated business entity with its own lifecycle (grant date, expiry, status, examination records, passage counts) that is actively managed by port authorities.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` (
    `pilot_vessel_type_endorsement_id` BIGINT COMMENT 'Primary key for the pilot_vessel_type_endorsement association',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to the vessel type classification for which this endorsement is granted',
    `pilot_id` BIGINT COMMENT 'Foreign key linking to the licensed marine pilot holding this vessel type endorsement',
    `created_date` TIMESTAMP COMMENT 'System timestamp when this endorsement record was created in the port authority system.',
    `endorsement_certificate_number` STRING COMMENT 'Unique certificate or reference number assigned to this vessel type endorsement by the issuing authority. Used for regulatory audit and verification.',
    `endorsement_date` DATE COMMENT 'Date on which this specific vessel type endorsement was granted to the pilot by the licensing authority. Used for tracking endorsement history and calculating experience duration.',
    `endorsement_expiry_date` DATE COMMENT 'Date on which this vessel type endorsement expires and must be renewed. Drives compliance monitoring and pilot assignment eligibility for this vessel type.',
    `endorsement_restrictions` STRING COMMENT 'Free-text description of any specific restrictions or conditions applied to this vessel type endorsement (e.g., daylight only, specific berths only, tug assistance required, supervision required).',
    `endorsement_status` STRING COMMENT 'Current regulatory status of this specific vessel type endorsement. Determines whether the pilot is currently authorized to pilot vessels of this type.',
    `issuing_authority` STRING COMMENT 'Name of the maritime authority or regulatory body that issued this specific vessel type endorsement. May differ from the general pilot licence issuing authority for specialized endorsements.',
    `last_pilotage_date_for_type` DATE COMMENT 'Date on which the pilot last conducted pilotage operations on a vessel of this type. Used for recency requirements and endorsement renewal eligibility.',
    `last_updated_date` TIMESTAMP COMMENT 'System timestamp when this endorsement record was last modified.',
    `max_dwt_for_type_mt` DECIMAL(18,2) COMMENT 'Maximum vessel Deadweight Tonnage (DWT) in metric tonnes that this pilot is authorized to handle specifically for this vessel type under this endorsement. May differ from the pilots general max_dwt_mt based on type-specific qualifications.',
    `max_loa_for_type_m` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall (LOA) in metres that this pilot is authorized to handle specifically for this vessel type under this endorsement. May differ from the pilots general max_loa_m based on type-specific training and experience.',
    `practical_assessments_completed` STRING COMMENT 'Number of supervised practical pilotage assessments completed by the pilot for this specific vessel type. Used to track progression toward full endorsement and recurrent competency validation.',
    `simulator_training_completed` BOOLEAN COMMENT 'Indicates whether the pilot has completed mandatory bridge simulator training specific to this vessel type. Required for certain high-risk vessel types (LNG, tanker, large container ships).',
    `simulator_training_date` DATE COMMENT 'Date on which the pilot completed vessel-type-specific simulator training for this endorsement. Used for tracking recurrent training requirements.',
    `vessel_type_endorsements` STRING COMMENT 'Comma-separated list of vessel type endorsements held by the pilot, indicating specialised authorisation for specific vessel categories (e.g., LNG_TANKER, VLCC, RORO, CRUISE, CONTAINER). Drives assignment eligibility for specialist vessel calls. [Moved from pilot: This comma-separated list attribute in the pilot product is a denormalized representation of the many-to-many relationship. The proper model is to capture each endorsement as a separate record in the pilot_vessel_type_endorsement association with full endorsement-specific attributes (dates, limits, status, training). The vessel_type_endorsements attribute should be removed from pilot and replaced by queries against the association product.]',
    CONSTRAINT pk_pilot_vessel_type_endorsement PRIMARY KEY(`pilot_vessel_type_endorsement_id`)
) COMMENT 'This association product represents the regulatory endorsement relationship between a licensed marine pilot and a specific vessel type classification. It captures the pilots authorization, training, and operational limits for conducting pilotage operations on vessels of a specific type. Each record links one pilot to one vessel type with endorsement-specific attributes including dates, limits, training status, and regulatory compliance data that exist only in the context of this specific endorsement.. Existence Justification: In maritime pilotage operations, pilots hold multiple vessel type endorsements (container ships, tankers, LNG carriers, bulk carriers, etc.), and each vessel type can be piloted by multiple qualified pilots. Licensing authorities track endorsement-specific training, operational limits (LOA, DWT), simulator training completion, expiry dates, and restrictions for each pilot-vessel type combination. This is an actively managed regulatory compliance relationship where endorsements are issued, renewed, suspended, and tracked independently.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` (
    `surveyor_authorization_id` BIGINT COMMENT 'Unique system-generated identifier for each surveyor authorization record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to the commercial agreement that authorizes the surveyor',
    `surveyor_id` BIGINT COMMENT 'Foreign key linking to the marine surveyor authorized under this agreement',
    `authorised_survey_types` STRING COMMENT 'Comma-separated list of survey types the surveyor is authorized to perform under this specific agreement. May be a subset of the surveyors full scope of authorization, restricted by the agreement terms or client requirements.',
    `authorization_status` STRING COMMENT 'Current lifecycle status of this surveyor authorization. Active: surveyor can perform authorized surveys; Suspended: temporarily inactive due to performance or compliance issues; Expired: effective_to_date has passed; Revoked: authorization terminated before expiry.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this surveyor authorization record was created. Used for audit trail and authorization history tracking.',
    `effective_from_date` DATE COMMENT 'Date from which the surveyor is authorized to perform surveys under this agreement. May differ from the agreement effective date if surveyors are added mid-term.',
    `effective_to_date` DATE COMMENT 'Date until which the surveyor authorization remains valid under this agreement. May be earlier than agreement expiry if surveyor is removed from the panel. Null indicates authorization continues for the full agreement term.',
    `exclusivity_flag` BOOLEAN COMMENT 'Indicates whether this surveyor has exclusive rights to perform certain survey types under this agreement, preventing other authorized surveyors from performing those specific surveys. Used in premium service agreements.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this surveyor authorization record was last updated. Tracks changes to rates, scope, status, or performance ratings.',
    `performance_rating` DECIMAL(18,2) COMMENT 'Aggregated performance rating (0.00 to 5.00) for this surveyors work under this specific agreement, based on client feedback, timeliness, report quality, and compliance. Tracked per authorization to enable agreement-specific performance management.',
    `rate_override` DECIMAL(18,2) COMMENT 'Negotiated hourly or daily rate for this surveyor under this specific agreement, overriding standard surveyor rates. Null if standard rates apply. Enables agreement-specific pricing arrangements.',
    CONSTRAINT pk_surveyor_authorization PRIMARY KEY(`surveyor_authorization_id`)
) COMMENT 'This association product represents the contractual authorization between a marine surveyor and a commercial agreement. It captures the specific scope, rates, and terms under which a surveyor is authorized to perform survey services under a given agreement. Each record links one surveyor to one agreement with attributes that exist only in the context of this authorization relationship, including authorized survey types, rate overrides, validity periods, exclusivity arrangements, and performance tracking.. Existence Justification: In maritime port operations, commercial agreements (with shipping lines, stevedoring companies, marine service providers) frequently establish surveyor panels authorizing multiple surveyors to perform various survey types under agreement-specific terms. A single surveyor operates under multiple agreements with different clients, and each agreement authorizes multiple surveyors to ensure coverage, specialization, and redundancy. The authorization relationship itself carries business-critical data including authorized survey types, negotiated rates, validity periods, exclusivity arrangements, and performance tracking that belongs neither to the surveyor master record nor the agreement master record.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` (
    `pilotage_route_id` BIGINT COMMENT 'Primary key for pilotage_route',
    `alternate_pilotage_route_id` BIGINT COMMENT 'Self-referencing FK on pilotage_route (alternate_pilotage_route_id)',
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
    `route_code` STRING COMMENT 'Externally-known unique alphanumeric code identifying the pilotage route. Used in operational communications and scheduling systems.',
    `route_name` STRING COMMENT 'Human-readable name of the pilotage route, typically including origin and destination points.',
    `route_type` STRING COMMENT 'Classification of the pilotage route based on operational purpose: inbound (vessel entering port), outbound (vessel departing port), shifting (vessel moving within port), harbor (harbor navigation), or channel (channel transit).',
    `seasonal_end_date` DATE COMMENT 'Annual recurring end date for seasonal routes in MM-DD format. Applicable when status is seasonal. Represents the date each year when the route ceases operation.',
    `seasonal_start_date` DATE COMMENT 'Annual recurring start date for seasonal routes in MM-DD format. Applicable when status is seasonal. Represents the date each year when the route becomes operational.',
    `speed_limit_knots` DECIMAL(18,2) COMMENT 'Maximum permitted vessel speed through water in knots for this route. Enforced for safety, wake control, or environmental protection.',
    `pilotage_route_status` STRING COMMENT 'Current operational status of the pilotage route. Active routes are available for scheduling, inactive routes are permanently closed, suspended routes are temporarily unavailable, seasonal routes operate during specific periods.',
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_marine_service_order_id` FOREIGN KEY (`marine_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_service_order`(`marine_service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_pilotage_route_id` FOREIGN KEY (`pilotage_route_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_route`(`pilotage_route_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_marine_service_order_id` FOREIGN KEY (`marine_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_service_order`(`marine_service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_marine_service_order_id` FOREIGN KEY (`marine_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_service_order`(`marine_service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_marine_service_order_id` FOREIGN KEY (`marine_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_service_order`(`marine_service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_marine_service_order_id` FOREIGN KEY (`marine_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_service_order`(`marine_service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_surveyor_id` FOREIGN KEY (`surveyor_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`surveyor`(`surveyor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_towage_order_id` FOREIGN KEY (`towage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`towage_order`(`towage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ADD CONSTRAINT `fk_marine_pilotage_exemption_pilotage_route_id` FOREIGN KEY (`pilotage_route_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_route`(`pilotage_route_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ADD CONSTRAINT `fk_marine_pilot_duty_roster_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ADD CONSTRAINT `fk_marine_pilot_duty_roster_swapped_pilot_duty_roster_id` FOREIGN KEY (`swapped_pilot_duty_roster_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster`(`pilot_duty_roster_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ADD CONSTRAINT `fk_marine_pilot_duty_roster_tertiary_relief_pilot_id` FOREIGN KEY (`tertiary_relief_pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_reassigned_tug_assignment_id` FOREIGN KEY (`reassigned_tug_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug_assignment`(`tug_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_towage_order_id` FOREIGN KEY (`towage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`towage_order`(`towage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ADD CONSTRAINT `fk_marine_weather_tide_window_revised_weather_tide_window_id` FOREIGN KEY (`revised_weather_tide_window_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`weather_tide_window`(`weather_tide_window_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ADD CONSTRAINT `fk_marine_pilot_channel_authorisation_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ADD CONSTRAINT `fk_marine_pilot_vessel_type_endorsement_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ADD CONSTRAINT `fk_marine_surveyor_authorization_surveyor_id` FOREIGN KEY (`surveyor_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`surveyor`(`surveyor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ADD CONSTRAINT `fk_marine_pilotage_route_alternate_pilotage_route_id` FOREIGN KEY (`alternate_pilotage_route_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_route`(`pilotage_route_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`marine` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`marine` SET TAGS ('dbx_domain' = 'marine');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` SET TAGS ('dbx_subdomain' = 'pilotage_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Boarding Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `marine_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilotage_route_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Route ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `pilotage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Recorded By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage ID');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` SET TAGS ('dbx_subdomain' = 'pilotage_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `labour_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Labour Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Nationality Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `country_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `country_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `home_port_code` SET TAGS ('dbx_business_glossary_term' = 'Home Port UNLOCODE');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ALTER COLUMN `home_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` SET TAGS ('dbx_subdomain' = 'harbour_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Tug Master ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `marine_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `marine_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Tug Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Agent Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Code');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` SET TAGS ('dbx_subdomain' = 'harbour_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `home_port` SET TAGS ('dbx_business_glossary_term' = 'Home Port / Base Port');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `port_of_registry` SET TAGS ('dbx_business_glossary_term' = 'Port of Registry');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Operational Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `safety_management_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'Safety Management Certificate (SMC) Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `tug_type` SET TAGS ('dbx_business_glossary_term' = 'Tug Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `tug_type` SET TAGS ('dbx_value_regex' = 'ASD|conventional|voith|tractor|rotor');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ALTER COLUMN `year_built` SET TAGS ('dbx_business_glossary_term' = 'Year Built');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` SET TAGS ('dbx_subdomain' = 'harbour_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `mooring_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `marine_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Mooring Equipment Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Mooring Tariff Code');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` SET TAGS ('dbx_subdomain' = 'harbour_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `launch_dispatch_id` SET TAGS ('dbx_business_glossary_term' = 'Launch Dispatch ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Coxswain ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `marine_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Launch Boat Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Served Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Served Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `actual_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `actual_return_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Return Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `billing_reference` SET TAGS ('dbx_business_glossary_term' = 'Billing Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation / Abort Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `coxswain_licence_number` SET TAGS ('dbx_business_glossary_term' = 'Coxswain Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `coxswain_licence_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `coxswain_licence_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `coxswain_name` SET TAGS ('dbx_business_glossary_term' = 'Coxswain Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `coxswain_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `coxswain_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `departure_jetty` SET TAGS ('dbx_business_glossary_term' = 'Departure Jetty / Berth');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_authorised_by` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Authorised By');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_priority` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_priority` SET TAGS ('dbx_value_regex' = 'routine|urgent|emergency');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_purpose` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Purpose');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_reference` SET TAGS ('dbx_business_glossary_term' = 'Launch Dispatch Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_reference` SET TAGS ('dbx_value_regex' = '^LD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_status` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `dispatch_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|aborted');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `fuel_consumed_litres` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumed (Litres)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `incident_reference` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `incident_reported` SET TAGS ('dbx_business_glossary_term' = 'Incident Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `isps_clearance_verified` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Clearance Verified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `life_jackets_worn` SET TAGS ('dbx_business_glossary_term' = 'Life Jackets Worn Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `marpol_compliance_checked` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Compliance Checked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `mission_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Mission Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `night_operation` SET TAGS ('dbx_business_glossary_term' = 'Night Operation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `passengers_carried` SET TAGS ('dbx_business_glossary_term' = 'Passengers Carried');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `pi_club_notified` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `pilot_boarding_ground` SET TAGS ('dbx_business_glossary_term' = 'Pilot Boarding Ground');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `safety_observation` SET TAGS ('dbx_business_glossary_term' = 'Safety Observation');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `scheduled_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Departure Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_business_glossary_term' = 'Sea State Code (Douglas Scale)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `service_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Launch Service Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `service_charge_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `visibility_nm` SET TAGS ('dbx_business_glossary_term' = 'Visibility (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` SET TAGS ('dbx_subdomain' = 'survey_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `surveyor_id` SET TAGS ('dbx_business_glossary_term' = 'Surveyor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Nationality Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `country_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `country_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `accreditation_body` SET TAGS ('dbx_business_glossary_term' = 'Accreditation Body');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `authorisation_granted_date` SET TAGS ('dbx_business_glossary_term' = 'Authorisation Granted Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `authorisation_revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Authorisation Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `authorisation_status` SET TAGS ('dbx_business_glossary_term' = 'Authorisation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `authorisation_status` SET TAGS ('dbx_value_regex' = 'active|suspended|expired|revoked|pending');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `availability_status` SET TAGS ('dbx_business_glossary_term' = 'Availability Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `availability_status` SET TAGS ('dbx_value_regex' = 'available|on_assignment|unavailable|on_leave');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `surveyor_code` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `surveyor_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[0-9]{4,8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `company_name` SET TAGS ('dbx_business_glossary_term' = 'Company Affiliation Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `company_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Company Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `company_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `home_port_code` SET TAGS ('dbx_business_glossary_term' = 'Home Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `home_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `imdg_certified` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Insurance Validity Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `insurance_provider` SET TAGS ('dbx_business_glossary_term' = 'Professional Indemnity Insurance Provider');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `languages_spoken` SET TAGS ('dbx_business_glossary_term' = 'Languages Spoken');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Compliance Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `licence_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Licence Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `licence_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Licence Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `licence_number` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `licence_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `marpol_certified` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution Convention (MARPOL) Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Mobile Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_value_regex' = '^+[1-9][0-9]{6,14}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `multi_port_authorised` SET TAGS ('dbx_business_glossary_term' = 'Multi-Port Authorisation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `next_audit_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Compliance Audit Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `on_call_flag` SET TAGS ('dbx_business_glossary_term' = 'On-Call Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `passport_number` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Passport Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `passport_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `passport_number` SET TAGS ('dbx_pii_passport' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `phone` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `phone` SET TAGS ('dbx_value_regex' = '^+[1-9][0-9]{6,14}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `pi_club_affiliation` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Affiliation');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `port_access_credential_number` SET TAGS ('dbx_business_glossary_term' = 'Port Access Credential Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `port_access_credential_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `port_access_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Port Access Credential Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `port_access_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Port Access Credential Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `preferred_contact_method` SET TAGS ('dbx_business_glossary_term' = 'Preferred Contact Method');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `preferred_contact_method` SET TAGS ('dbx_value_regex' = 'email|phone|mobile|pcs_message|edi');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Authorisation Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `scope_of_authorisation` SET TAGS ('dbx_business_glossary_term' = 'Scope of Authorisation');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `seaman_book_number` SET TAGS ('dbx_business_glossary_term' = 'Seafarers Book Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `seaman_book_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `solas_certified` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `specialisation_codes` SET TAGS ('dbx_business_glossary_term' = 'Survey Specialisation Codes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `surveyor_type` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `surveyor_type` SET TAGS ('dbx_value_regex' = 'classification|pi_correspondent|cargo|condition|draught');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `vessel_type_authorisations` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Authorisations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ALTER COLUMN `years_of_experience` SET TAGS ('dbx_business_glossary_term' = 'Years of Experience');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` SET TAGS ('dbx_subdomain' = 'survey_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Survey Appointment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `marine_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `marine_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Security Personnel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Party Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `surveyor_id` SET TAGS ('dbx_business_glossary_term' = 'Surveyor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `actual_commencement` SET TAGS ('dbx_business_glossary_term' = 'Actual Survey Commencement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `actual_completion` SET TAGS ('dbx_business_glossary_term' = 'Actual Survey Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `appointment_reference` SET TAGS ('dbx_business_glossary_term' = 'Survey Appointment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `appointment_reference` SET TAGS ('dbx_value_regex' = '^SVY-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Survey Appointment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|postponed|on_hold');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Survey Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `cargo_quantity_mt` SET TAGS ('dbx_business_glossary_term' = 'Cargo Quantity (Metric Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `cargo_scope` SET TAGS ('dbx_business_glossary_term' = 'Cargo Scope Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `certificate_reference` SET TAGS ('dbx_business_glossary_term' = 'Survey Certificate Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Survey Deficiency Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `deficiency_description` SET TAGS ('dbx_business_glossary_term' = 'Survey Deficiency Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `draught_aft_m` SET TAGS ('dbx_business_glossary_term' = 'Vessel Aft Draught (Metres)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `draught_forward_m` SET TAGS ('dbx_business_glossary_term' = 'Vessel Forward Draught (Metres)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `draught_midship_m` SET TAGS ('dbx_business_glossary_term' = 'Vessel Midship Draught (Metres)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `isps_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `marpol_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution Convention (MARPOL) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `pi_club_name` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `pi_club_notified` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `pi_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'P&I Club Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `psc_inspection_triggered` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection Triggered Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `rectification_deadline` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Rectification Deadline');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `report_reference` SET TAGS ('dbx_business_glossary_term' = 'Survey Report Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `scheduled_commencement` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Survey Commencement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `solas_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Survey Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_location_type` SET TAGS ('dbx_business_glossary_term' = 'Survey Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_location_type` SET TAGS ('dbx_value_regex' = 'berth|anchorage|dry_dock|buoy|offshore');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_notes` SET TAGS ('dbx_business_glossary_term' = 'Survey Appointment Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_outcome` SET TAGS ('dbx_business_glossary_term' = 'Survey Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_outcome` SET TAGS ('dbx_value_regex' = 'passed|failed|conditional_pass|inconclusive|deferred');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_type` SET TAGS ('dbx_business_glossary_term' = 'Survey Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `survey_type` SET TAGS ('dbx_value_regex' = 'condition_survey|draught_survey|damage_survey|pre_loading_survey|hatch_inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `surveying_organisation` SET TAGS ('dbx_business_glossary_term' = 'Surveying Organisation Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions at Survey');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` SET TAGS ('dbx_subdomain' = 'survey_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `marine_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Damaged Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Involved Gang Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `amsa_notified` SET TAGS ('dbx_business_glossary_term' = 'Australian Maritime Safety Authority (AMSA) Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `contributing_factors` SET TAGS ('dbx_business_glossary_term' = 'Contributing Factors');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `corrective_actions` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `corrective_actions_completed` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `corrective_actions_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `datetime` SET TAGS ('dbx_business_glossary_term' = 'Incident Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `estimated_damage_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Damage Cost (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `estimated_damage_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `fatalities_count` SET TAGS ('dbx_business_glossary_term' = 'Fatalities Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `flag_state_notified` SET TAGS ('dbx_business_glossary_term' = 'Flag State Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `human_factor_involved` SET TAGS ('dbx_business_glossary_term' = 'Human Factor Involved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `immediate_cause` SET TAGS ('dbx_business_glossary_term' = 'Immediate Cause');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `imo_notified` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `incident_category` SET TAGS ('dbx_business_glossary_term' = 'Incident Category');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `incident_category` SET TAGS ('dbx_value_regex' = 'very_serious_casualty|serious_casualty|less_serious_casualty|marine_incident|near_miss');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_business_glossary_term' = 'Incident Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `infrastructure_damage_description` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `injuries_count` SET TAGS ('dbx_business_glossary_term' = 'Injuries Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `investigation_close_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Close Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `investigation_lead` SET TAGS ('dbx_business_glossary_term' = 'Investigation Lead Officer');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `investigation_lead` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `investigation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `investigation_status` SET TAGS ('dbx_business_glossary_term' = 'Investigation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `investigation_status` SET TAGS ('dbx_value_regex' = 'reported|under_investigation|findings_issued|corrective_action_pending|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `investigation_team` SET TAGS ('dbx_business_glossary_term' = 'Investigation Team Members');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `isps_security_implication` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Implication Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `location_description` SET TAGS ('dbx_business_glossary_term' = 'Incident Location Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `location_latitude` SET TAGS ('dbx_business_glossary_term' = 'Incident Location Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `location_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `location_longitude` SET TAGS ('dbx_business_glossary_term' = 'Incident Location Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `location_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `marpol_classification` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution Convention (MARPOL) Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `missing_persons_count` SET TAGS ('dbx_business_glossary_term' = 'Missing Persons Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `pi_club_notification_datetime` SET TAGS ('dbx_business_glossary_term' = 'P&I Club Notification Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `pi_club_notified` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `pollution_occurred` SET TAGS ('dbx_business_glossary_term' = 'Pollution Occurred Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `pollution_substance` SET TAGS ('dbx_business_glossary_term' = 'Pollution Substance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `pollution_volume_litres` SET TAGS ('dbx_business_glossary_term' = 'Pollution Volume (Litres)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `psc_notified` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Incident Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `reference_number` SET TAGS ('dbx_value_regex' = '^INC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `reported_datetime` SET TAGS ('dbx_business_glossary_term' = 'Incident Reported Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `solas_classification` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `vessel_damage_description` SET TAGS ('dbx_business_glossary_term' = 'Vessel Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `visibility_nautical_miles` SET TAGS ('dbx_business_glossary_term' = 'Visibility (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions at Time of Incident');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` SET TAGS ('dbx_subdomain' = 'survey_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `pni_club_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Pni Club Notification Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Claimant Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `marine_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Notifying Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Service ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `provision_id` SET TAGS ('dbx_business_glossary_term' = 'Provision Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Service ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `acknowledgement_datetime` SET TAGS ('dbx_business_glossary_term' = 'P&I Club Acknowledgement Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `claim_type` SET TAGS ('dbx_business_glossary_term' = 'P&I Claim Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Notification Closure Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `closure_reason` SET TAGS ('dbx_business_glossary_term' = 'Notification Closure Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `closure_reason` SET TAGS ('dbx_value_regex' = 'settled|no_liability|withdrawn|time_barred|subrogated');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `club_correspondent_contact` SET TAGS ('dbx_business_glossary_term' = 'P&I Club Correspondent Contact Details');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `club_correspondent_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `club_correspondent_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `club_correspondent_name` SET TAGS ('dbx_business_glossary_term' = 'P&I Club Correspondent Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `club_handler_name` SET TAGS ('dbx_business_glossary_term' = 'P&I Club Claims Handler Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `club_reference_number` SET TAGS ('dbx_business_glossary_term' = 'P&I Club Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `edi_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `estimated_liability_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Liability Exposure Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `estimated_liability_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `incident_date` SET TAGS ('dbx_business_glossary_term' = 'Incident Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `incident_description` SET TAGS ('dbx_business_glossary_term' = 'Incident Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `incident_location` SET TAGS ('dbx_business_glossary_term' = 'Incident Location');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `legal_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Legal Hold Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `liability_currency` SET TAGS ('dbx_business_glossary_term' = 'Liability Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `liability_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `marpol_reportable_flag` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution Convention (MARPOL) Reportable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notification_channel` SET TAGS ('dbx_business_glossary_term' = 'Notification Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notification_channel` SET TAGS ('dbx_value_regex' = 'email|fax|edi|portal|telephone|letter');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notification_datetime` SET TAGS ('dbx_business_glossary_term' = 'P&I Notification Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notification_reference` SET TAGS ('dbx_business_glossary_term' = 'P&I Notification Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notification_reference` SET TAGS ('dbx_value_regex' = '^PNI-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notification_status` SET TAGS ('dbx_business_glossary_term' = 'P&I Notification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notification_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|acknowledged|under_review|closed|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notifying_party_role` SET TAGS ('dbx_business_glossary_term' = 'Notifying Party Role');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `notifying_party_role` SET TAGS ('dbx_value_regex' = 'shipowner|operator|port_authority|legal_representative|correspondent|charterer');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `pi_club_name` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `port_legal_counsel` SET TAGS ('dbx_business_glossary_term' = 'Port Legal Counsel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `psc_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `reserve_amount` SET TAGS ('dbx_business_glossary_term' = 'P&I Reserve Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `reserve_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `reserve_currency` SET TAGS ('dbx_business_glossary_term' = 'Reserve Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `reserve_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `settled_amount` SET TAGS ('dbx_business_glossary_term' = 'Settled Claim Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `settled_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `solas_reportable_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Reportable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `survey_date` SET TAGS ('dbx_business_glossary_term' = 'Marine Survey Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `surveyor_appointed_flag` SET TAGS ('dbx_business_glossary_term' = 'Marine Surveyor Appointed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ALTER COLUMN `surveyor_name` SET TAGS ('dbx_business_glossary_term' = 'Marine Surveyor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` SET TAGS ('dbx_subdomain' = 'survey_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `marpol_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Operation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Reception Facility (PRF) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Licensed Waste Contractor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Supervising Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Waste Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `ballast_water_treatment_method` SET TAGS ('dbx_business_glossary_term' = 'Ballast Water Treatment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `ballast_water_treatment_method` SET TAGS ('dbx_value_regex' = 'exchange|uv_treatment|chemical_treatment|filtration|heat_treatment|no_treatment');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `ballast_water_treatment_method` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `ballast_water_treatment_method` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `ballast_water_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Ballast Water Volume (m³)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `berth_code` SET TAGS ('dbx_business_glossary_term' = 'Berth Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Waste Disposal Method');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `environmental_monitoring_ref` SET TAGS ('dbx_business_glossary_term' = 'Environmental Monitoring System (EMS) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_capacity_m3` SET TAGS ('dbx_business_glossary_term' = 'Reception Facility Capacity (m³)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Reception Facility Inspection Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_inspection_status` SET TAGS ('dbx_value_regex' = 'current|expired|suspended|pending_renewal');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_licence_number` SET TAGS ('dbx_business_glossary_term' = 'Reception Facility Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_licence_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_licence_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_type` SET TAGS ('dbx_business_glossary_term' = 'Reception Facility Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `facility_type` SET TAGS ('dbx_value_regex' = 'fixed_facility|mobile_unit|barge|tanker_truck|pipeline');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `ghg_emission_mt_co2e` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Emission (metric tonnes CO₂ equivalent)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `marpol_annex_code` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Annex Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `marpol_annex_code` SET TAGS ('dbx_value_regex' = 'ANNEX_I|ANNEX_II|ANNEX_IV|ANNEX_V|ANNEX_VI');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `non_compliance_description` SET TAGS ('dbx_business_glossary_term' = 'Non-Compliance Description');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `non_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Non-Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Sent Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `nox_emission_g_kwh` SET TAGS ('dbx_business_glossary_term' = 'Nitrogen Oxide (NOx) Emission Rate (g/kWh)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `oil_record_book_entry_code` SET TAGS ('dbx_business_glossary_term' = 'Oil Record Book (ORB) Entry Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Operation End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_reference_number` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Operation Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_reference_number` SET TAGS ('dbx_value_regex' = '^MARPOL-[A-Z]{3}-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_status` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Operation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|cancelled|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Operation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'MARPOL Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `operation_type` SET TAGS ('dbx_value_regex' = 'waste_delivery|oil_record_entry|garbage_management|sewage_discharge|air_emission_monitoring|ballast_water_management');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `pi_club_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `port_authority_signoff_by` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Sign-Off Officer');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `port_authority_signoff_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `port_authority_signoff_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Sign-Off Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `psc_deficiency_noted` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Deficiency Noted');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `psc_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Waste or Emission Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_value_regex' = 'm3|kg|mt|litres|TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Operation Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `source_system_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `sox_emission_ppm` SET TAGS ('dbx_business_glossary_term' = 'Sulphur Oxide (SOx) Emission Concentration (ppm)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `waste_category` SET TAGS ('dbx_business_glossary_term' = 'Waste Category');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ALTER COLUMN `waste_manifest_number` SET TAGS ('dbx_business_glossary_term' = 'Waste Manifest Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` SET TAGS ('dbx_subdomain' = 'pilotage_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `pilotage_exemption_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Exemption Certificate (PEC) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `authorized_berths` SET TAGS ('dbx_business_glossary_term' = 'Authorized Berths');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `authorized_fairway_sections` SET TAGS ('dbx_business_glossary_term' = 'Authorized Fairway Sections');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `authorized_vessel_types` SET TAGS ('dbx_business_glossary_term' = 'Authorized Vessel Types');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Exemption Certificate (PEC) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `certificate_number` SET TAGS ('dbx_value_regex' = '^PEC-[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `conditions_and_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Conditions and Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `examination_date` SET TAGS ('dbx_business_glossary_term' = 'Examination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `examination_result` SET TAGS ('dbx_business_glossary_term' = 'Examination Result');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `examination_result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|exempt');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `examination_score` SET TAGS ('dbx_business_glossary_term' = 'Examination Score Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `examiner_name` SET TAGS ('dbx_business_glossary_term' = 'Examiner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `exemption_type` SET TAGS ('dbx_business_glossary_term' = 'Exemption Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `exemption_type` SET TAGS ('dbx_value_regex' = 'full|partial|conditional|temporary');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `insurance_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Insurance Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Insurance Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `last_passage_date` SET TAGS ('dbx_business_glossary_term' = 'Last Passage Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `last_renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Last Renewal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `master_license_number` SET TAGS ('dbx_business_glossary_term' = 'Master Mariner License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `master_license_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `master_license_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `master_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `master_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `master_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `max_dwt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Deadweight Tonnage (DWT) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `max_grt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gross Registered Tonnage (GRT) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `max_loa_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `next_renewal_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Renewal Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `pilotage_exemption_status` SET TAGS ('dbx_business_glossary_term' = 'Certificate Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `pilotage_exemption_status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|revoked|pending|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `qualifying_passages_completed` SET TAGS ('dbx_business_glossary_term' = 'Qualifying Passages Completed');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `qualifying_passages_required` SET TAGS ('dbx_business_glossary_term' = 'Qualifying Passages Required');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `renewal_requirements` SET TAGS ('dbx_business_glossary_term' = 'Renewal Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `suspension_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ALTER COLUMN `total_passages_under_exemption` SET TAGS ('dbx_business_glossary_term' = 'Total Passages Under Exemption');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` SET TAGS ('dbx_subdomain' = 'harbour_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `marine_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `mooring_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `pilotage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Pilot Provider ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `proforma_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Proforma Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Service Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `tertiary_marine_approved_mooring_provider_port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Mooring Provider ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `towage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `actual_service_end` SET TAGS ('dbx_business_glossary_term' = 'Actual Service End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `actual_service_start` SET TAGS ('dbx_business_glossary_term' = 'Actual Service Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `cancellation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `confirmation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `estimated_service_end` SET TAGS ('dbx_business_glossary_term' = 'Estimated Service End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `estimated_service_start` SET TAGS ('dbx_business_glossary_term' = 'Estimated Service Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `estimated_total_charge` SET TAGS ('dbx_business_glossary_term' = 'Estimated Total Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `launch_service_required` SET TAGS ('dbx_business_glossary_term' = 'Launch Service Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `launch_trip_count` SET TAGS ('dbx_business_glossary_term' = 'Launch Trip Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `mooring_gang_size` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang Size');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `mooring_required` SET TAGS ('dbx_business_glossary_term' = 'Mooring Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `number_of_tugs` SET TAGS ('dbx_business_glossary_term' = 'Number of Tugs');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Marine Service Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `order_number` SET TAGS ('dbx_value_regex' = '^MSO-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Order Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'requested|confirmed|in_progress|completed|cancelled|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Order Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'standard|urgent|emergency|scheduled');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `pilot_boarding_location` SET TAGS ('dbx_business_glossary_term' = 'Pilot Boarding Location');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `pilotage_required` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `pilotage_type` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `pilotage_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|shifting|docking|undocking');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|normal|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `service_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `surveyor_required` SET TAGS ('dbx_business_glossary_term' = 'Marine Surveyor Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `surveyor_type` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `towage_required` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `tug_horsepower_required` SET TAGS ('dbx_business_glossary_term' = 'Tug Horsepower Required');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ALTER COLUMN `weather_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Weather Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` SET TAGS ('dbx_subdomain' = 'pilotage_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `pilot_duty_roster_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Duty Roster Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `swapped_pilot_duty_roster_id` SET TAGS ('dbx_business_glossary_term' = 'Swapped Pilot Duty Roster Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `swapped_pilot_duty_roster_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `tertiary_relief_pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Relief Pilot Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `actual_assignments_completed` SET TAGS ('dbx_business_glossary_term' = 'Actual Assignments Completed');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `assigned_boarding_station` SET TAGS ('dbx_business_glossary_term' = 'Assigned Boarding Station');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `availability_status` SET TAGS ('dbx_business_glossary_term' = 'Availability Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `availability_status` SET TAGS ('dbx_value_regex' = 'available|assigned|unavailable|off_duty|on_leave|sick_leave');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `boarding_station_location` SET TAGS ('dbx_business_glossary_term' = 'Boarding Station Location');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `cancellation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `cumulative_duty_hours_month` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Duty Hours in Month');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `cumulative_duty_hours_week` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Duty Hours in Week');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `duty_priority_level` SET TAGS ('dbx_business_glossary_term' = 'Duty Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `duty_priority_level` SET TAGS ('dbx_value_regex' = 'primary|secondary|backup|emergency');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `fatigue_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Fatigue Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `fatigue_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Fatigue Risk Score');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `hours_of_rest_prior` SET TAGS ('dbx_business_glossary_term' = 'Hours of Rest Prior to Duty');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `max_assignments_allowed` SET TAGS ('dbx_business_glossary_term' = 'Maximum Assignments Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `night_pilotage_authorised` SET TAGS ('dbx_business_glossary_term' = 'Night Pilotage Authorised');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `relief_reason` SET TAGS ('dbx_business_glossary_term' = 'Relief Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `relief_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Relief Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_notes` SET TAGS ('dbx_business_glossary_term' = 'Roster Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_period_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Roster Period End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_period_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Roster Period Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_publication_date` SET TAGS ('dbx_business_glossary_term' = 'Roster Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_published_by` SET TAGS ('dbx_business_glossary_term' = 'Roster Published By');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Roster Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_status` SET TAGS ('dbx_business_glossary_term' = 'Roster Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `roster_status` SET TAGS ('dbx_value_regex' = 'draft|published|active|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `special_qualifications` SET TAGS ('dbx_business_glossary_term' = 'Special Qualifications');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `standby_location` SET TAGS ('dbx_business_glossary_term' = 'Standby Location');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `swap_approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Swap Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `swap_approved_flag` SET TAGS ('dbx_business_glossary_term' = 'Swap Approved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `swap_request_flag` SET TAGS ('dbx_business_glossary_term' = 'Swap Request Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `vhf_radio_channel` SET TAGS ('dbx_business_glossary_term' = 'Very High Frequency (VHF) Radio Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ALTER COLUMN `weather_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Weather Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` SET TAGS ('dbx_subdomain' = 'harbour_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Assignment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Master Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `reassigned_tug_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Reassigned Tug Assignment Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `reassigned_tug_assignment_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ALTER COLUMN `tug_id` SET TAGS ('dbx_business_glossary_term' = 'Tug Identifier (ID)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` SET TAGS ('dbx_subdomain' = 'harbour_services');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `weather_tide_window_id` SET TAGS ('dbx_business_glossary_term' = 'Weather Tide Window ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Observer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `revised_weather_tide_window_id` SET TAGS ('dbx_business_glossary_term' = 'Revised Weather Tide Window Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `revised_weather_tide_window_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `air_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Air Temperature (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `barometric_pressure_hpa` SET TAGS ('dbx_business_glossary_term' = 'Barometric Pressure (Hectopascals)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `chart_datum_reference` SET TAGS ('dbx_business_glossary_term' = 'Chart Datum Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `forecast_source` SET TAGS ('dbx_business_glossary_term' = 'Forecast Source');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `marpol_environmental_flag` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Environmental Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `max_vessel_draft_permitted_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Draft Permitted (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `max_vessel_loa_permitted_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Length Overall (LOA) Permitted (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `mooring_restriction_flag` SET TAGS ('dbx_business_glossary_term' = 'Mooring Restriction Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_location` SET TAGS ('dbx_business_glossary_term' = 'Observation Location');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_reference` SET TAGS ('dbx_business_glossary_term' = 'Observation Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_reference` SET TAGS ('dbx_value_regex' = '^WTW-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_remarks` SET TAGS ('dbx_business_glossary_term' = 'Observation Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_source` SET TAGS ('dbx_business_glossary_term' = 'Observation Source');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_source` SET TAGS ('dbx_value_regex' = 'automated_sensor|manual_reading|vts_report|weather_station|tide_gauge|forecast_model');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_status` SET TAGS ('dbx_business_glossary_term' = 'Observation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_status` SET TAGS ('dbx_value_regex' = 'preliminary|validated|revised|final|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `observation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Observation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `pilotage_restriction_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Restriction Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `precipitation_mm` SET TAGS ('dbx_business_glossary_term' = 'Precipitation (Millimeters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `restriction_reason` SET TAGS ('dbx_business_glossary_term' = 'Restriction Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `sea_state_code` SET TAGS ('dbx_business_glossary_term' = 'Sea State Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `service_window_status` SET TAGS ('dbx_business_glossary_term' = 'Service Window Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `service_window_status` SET TAGS ('dbx_value_regex' = 'go|no_go|conditional|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `solas_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `swell_height_m` SET TAGS ('dbx_business_glossary_term' = 'Swell Height (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tidal_phase` SET TAGS ('dbx_business_glossary_term' = 'Tidal Phase');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tidal_phase` SET TAGS ('dbx_value_regex' = 'high_water|low_water|flood|ebb|slack_water');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tidal_stream_direction_degrees` SET TAGS ('dbx_business_glossary_term' = 'Tidal Stream Direction (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tidal_stream_rate_knots` SET TAGS ('dbx_business_glossary_term' = 'Tidal Stream Rate (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tidal_window_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Tidal Window End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tidal_window_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Tidal Window Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tide_height_actual_m` SET TAGS ('dbx_business_glossary_term' = 'Tide Height Actual (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tide_height_predicted_m` SET TAGS ('dbx_business_glossary_term' = 'Tide Height Predicted (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `tide_height_variance_m` SET TAGS ('dbx_business_glossary_term' = 'Tide Height Variance (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `towage_restriction_flag` SET TAGS ('dbx_business_glossary_term' = 'Towage Restriction Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `ukc_available_m` SET TAGS ('dbx_business_glossary_term' = 'Under Keel Clearance (UKC) Available (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `visibility_category` SET TAGS ('dbx_business_glossary_term' = 'Visibility Category');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `visibility_category` SET TAGS ('dbx_value_regex' = 'excellent|good|moderate|poor|very_poor|fog');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `visibility_nm` SET TAGS ('dbx_business_glossary_term' = 'Visibility (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `vts_notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Notification Sent Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `water_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Water Temperature (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `wave_height_m` SET TAGS ('dbx_business_glossary_term' = 'Wave Height (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `weather_condition` SET TAGS ('dbx_business_glossary_term' = 'Weather Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `wind_direction_degrees` SET TAGS ('dbx_business_glossary_term' = 'Wind Direction (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `wind_gust_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Gust Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ALTER COLUMN `wind_speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Wind Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` SET TAGS ('dbx_subdomain' = 'pilotage_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` SET TAGS ('dbx_association_edges' = 'marine.pilot,infrastructure.channel');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `pilot_channel_authorisation_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Channel Authorisation - Pilot Channel Authorisation Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Channel Authorisation - Channel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Channel Authorisation - Pilot Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `authorisation_date` SET TAGS ('dbx_business_glossary_term' = 'Authorisation Grant Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `authorisation_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Authorisation Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `authorisation_status` SET TAGS ('dbx_business_glossary_term' = 'Authorisation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `authorised_fairways` SET TAGS ('dbx_business_glossary_term' = 'Authorised Fairway Sections');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `authorising_officer` SET TAGS ('dbx_business_glossary_term' = 'Authorising Officer');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `examination_date` SET TAGS ('dbx_business_glossary_term' = 'Channel Examination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `last_passage_date` SET TAGS ('dbx_business_glossary_term' = 'Last Passage Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `licence_endorsement_code` SET TAGS ('dbx_business_glossary_term' = 'Licence Endorsement Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `max_vessel_dwt_authorised` SET TAGS ('dbx_business_glossary_term' = 'Maximum Authorised Vessel DWT');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `max_vessel_loa_authorised_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Authorised Vessel LOA');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ALTER COLUMN `passages_completed_count` SET TAGS ('dbx_business_glossary_term' = 'Passages Completed Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` SET TAGS ('dbx_subdomain' = 'pilotage_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` SET TAGS ('dbx_association_edges' = 'marine.pilot,masterdata.vessel_type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `pilot_vessel_type_endorsement_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Vessel Type Endorsement - Pilot Vessel Type Endorsement Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Vessel Type Endorsement - Masterdata Vessel Type Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Vessel Type Endorsement - Pilot Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `endorsement_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Endorsement Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `endorsement_date` SET TAGS ('dbx_business_glossary_term' = 'Endorsement Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `endorsement_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Endorsement Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `endorsement_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Endorsement Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `endorsement_status` SET TAGS ('dbx_business_glossary_term' = 'Endorsement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Endorsement Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `last_pilotage_date_for_type` SET TAGS ('dbx_business_glossary_term' = 'Last Pilotage Date for Vessel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `max_dwt_for_type_mt` SET TAGS ('dbx_business_glossary_term' = 'Maximum DWT for Vessel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `max_loa_for_type_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum LOA for Vessel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `practical_assessments_completed` SET TAGS ('dbx_business_glossary_term' = 'Practical Assessments Completed Count');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `simulator_training_completed` SET TAGS ('dbx_business_glossary_term' = 'Simulator Training Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `simulator_training_date` SET TAGS ('dbx_business_glossary_term' = 'Simulator Training Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ALTER COLUMN `vessel_type_endorsements` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Endorsements');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` SET TAGS ('dbx_subdomain' = 'survey_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` SET TAGS ('dbx_association_edges' = 'marine.surveyor,contract.agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `surveyor_authorization_id` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Authorization ID');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Authorization - Agreement Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `surveyor_id` SET TAGS ('dbx_business_glossary_term' = 'Surveyor Authorization - Surveyor Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `authorised_survey_types` SET TAGS ('dbx_business_glossary_term' = 'Authorised Survey Types');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `authorization_status` SET TAGS ('dbx_business_glossary_term' = 'Authorization Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Authorization Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `exclusivity_flag` SET TAGS ('dbx_business_glossary_term' = 'Exclusivity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Authorization Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ALTER COLUMN `rate_override` SET TAGS ('dbx_business_glossary_term' = 'Rate Override');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` SET TAGS ('dbx_subdomain' = 'pilotage_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `pilotage_route_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Route Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `alternate_pilotage_route_id` SET TAGS ('dbx_business_glossary_term' = 'Alternate Pilotage Route Id');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `alternate_pilotage_route_id` SET TAGS ('dbx_self_ref_fk' = 'true');
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
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `route_code` SET TAGS ('dbx_business_glossary_term' = 'Route Code');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `route_name` SET TAGS ('dbx_business_glossary_term' = 'Route Name');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `route_type` SET TAGS ('dbx_business_glossary_term' = 'Route Type');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `seasonal_end_date` SET TAGS ('dbx_business_glossary_term' = 'Seasonal End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `seasonal_start_date` SET TAGS ('dbx_business_glossary_term' = 'Seasonal Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `speed_limit_knots` SET TAGS ('dbx_business_glossary_term' = 'Speed Limit Knots');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `pilotage_route_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `tidal_dependency_flag` SET TAGS ('dbx_business_glossary_term' = 'Tidal Dependency Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `towage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `traffic_separation_scheme_flag` SET TAGS ('dbx_business_glossary_term' = 'Traffic Separation Scheme Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `two_way_traffic_flag` SET TAGS ('dbx_business_glossary_term' = 'Two Way Traffic Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `vessel_traffic_service_area_flag` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service Area Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `vts_channel_number` SET TAGS ('dbx_business_glossary_term' = 'Vts Channel Number');
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ALTER COLUMN `weather_restricted_flag` SET TAGS ('dbx_business_glossary_term' = 'Weather Restricted Flag');
