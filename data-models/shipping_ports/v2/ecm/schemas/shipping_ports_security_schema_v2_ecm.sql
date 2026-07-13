-- Schema for Domain: security | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:30

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`security` COMMENT 'Manages port facility security operations including ISPS Code compliance, access control systems, CCTV surveillance, security patrols, threat assessments, maritime domain awareness, and cybersecurity incident management for port IT/OT systems.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` (
    `facility_security_plan_id` BIGINT COMMENT 'Unique identifier for the Port Facility Security Plan (PFSP) record. Primary key for this entity.',
    `employee_id` BIGINT COMMENT 'Reference to the designated Port Facility Security Officer responsible for implementing and maintaining this security plan.',
    `isps_facility_record_id` BIGINT COMMENT 'Reference to the port facility covered by this security plan.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Each port location (berth, terminal, facility) requires its own approved FSP under ISPS Code. FSPs are location-specific with unique approval certificates, PFSO assignments, and security measures tail',
    `superseded_facility_security_plan_id` BIGINT COMMENT 'Self-referencing FK on facility_security_plan (superseded_facility_security_plan_id)',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: FSPs reference specific vessels for security assessments when high-risk vessels call. ISPS Code requires facility to assess vessel security history and characteristics before interface. New attribute ',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: FSPs define security measures by vessel type per ISPS Code. Tankers, container ships, and passenger vessels require different security protocols (MARSEC level measures, screening requirements, access ',
    `access_control_system_type` STRING COMMENT 'Type or model of the access control system specified in the Port Facility Security Plan (e.g., RFID, biometric, card-based).',
    `amendment_count` STRING COMMENT 'Total number of amendments or revisions made to the Port Facility Security Plan since initial approval.',
    `approval_authority` STRING COMMENT 'Name of the flag state administration or Recognized Security Organization (RSO) that approved the PFSP.',
    `approval_certificate_number` STRING COMMENT 'Certificate reference number issued by the approval authority upon PFSP approval.',
    `approval_date` DATE COMMENT 'Date when the Port Facility Security Plan was officially approved by the designated authority.',
    `cctv_coverage_percentage` DECIMAL(18,2) COMMENT 'Percentage of the port facility area covered by CCTV surveillance systems as specified in the security plan.',
    `compliance_certificate_expiry` DATE COMMENT 'Expiry date of the ISPS Code compliance certificate associated with this Port Facility Security Plan.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this Port Facility Security Plan record was first created in the system.',
    `cybersecurity_measures_included` BOOLEAN COMMENT 'Indicates whether the Port Facility Security Plan includes specific cybersecurity measures for IT/OT systems protection.',
    `document_classification` STRING COMMENT 'Security classification level assigned to the Port Facility Security Plan document itself.. Valid values are `restricted|confidential|internal`',
    `document_storage_location` STRING COMMENT 'Physical or digital location where the official Port Facility Security Plan document is securely stored.',
    `drill_frequency_months` STRING COMMENT 'Frequency in months at which security drills and exercises must be conducted as specified in the plan.',
    `effective_from_date` DATE COMMENT 'Date from which the approved Port Facility Security Plan becomes operationally effective and binding.',
    `expiry_date` DATE COMMENT 'Date when the current Port Facility Security Plan expires and requires renewal or reapproval. Nullable for plans with indefinite validity subject to periodic review.',
    `last_amendment_date` DATE COMMENT 'Date of the most recent amendment or revision to the Port Facility Security Plan.',
    `last_amendment_description` STRING COMMENT 'Brief description of the changes made in the most recent amendment to the Port Facility Security Plan.',
    `last_audit_date` DATE COMMENT 'Date of the most recent internal or external audit conducted on the Port Facility Security Plan implementation.',
    `last_audit_outcome` STRING COMMENT 'Result or finding of the most recent audit of the Port Facility Security Plan.. Valid values are `compliant|non_compliant|conditional|not_audited`',
    `last_drill_date` DATE COMMENT 'Date of the most recent security drill or exercise conducted under this Port Facility Security Plan.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this Port Facility Security Plan record was last updated or modified in the system.',
    `marsec_level_1_measures` STRING COMMENT 'Summary of security measures and procedures defined in the plan for Maritime Security (MARSEC) Level 1 (normal operations).',
    `marsec_level_2_measures` STRING COMMENT 'Summary of heightened security measures and procedures defined in the plan for Maritime Security (MARSEC) Level 2 (heightened risk).',
    `marsec_level_3_measures` STRING COMMENT 'Summary of exceptional security measures and procedures defined in the plan for Maritime Security (MARSEC) Level 3 (probable or imminent security incident).',
    `next_drill_date` DATE COMMENT 'Scheduled date for the next mandatory security drill or exercise.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next mandatory review or revalidation of the Port Facility Security Plan.',
    `patrol_frequency_hours` DECIMAL(18,2) COMMENT 'Frequency in hours at which security patrols must be conducted as specified in the Port Facility Security Plan.',
    `pfso_contact_number` STRING COMMENT 'Primary contact telephone number for the designated Port Facility Security Officer.',
    `pfso_email_address` STRING COMMENT 'Official email address for the designated Port Facility Security Officer.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `pfso_name` STRING COMMENT 'Full name of the designated Port Facility Security Officer at the time of plan approval.',
    `plan_reference_number` STRING COMMENT 'Official reference number assigned to the Port Facility Security Plan by the approval authority. Externally-known unique identifier for the plan.. Valid values are `^PFSP-[A-Z0-9]{6,12}$`',
    `plan_scope_description` STRING COMMENT 'Detailed description of the scope and coverage of the Port Facility Security Plan, including physical boundaries, operations covered, and exclusions.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the Port Facility Security Plan. [ENUM-REF-CANDIDATE: draft|submitted|approved|active|under_review|suspended|expired — 7 candidates stripped; promote to reference product]',
    `plan_version` STRING COMMENT 'Version number of the approved Port Facility Security Plan following major.minor format (e.g., 2.1, 3.0).. Valid values are `^[0-9]{1,3}.[0-9]{1,3}$`',
    `remarks` STRING COMMENT 'Additional notes, comments, or special conditions related to the Port Facility Security Plan.',
    `review_cycle_months` STRING COMMENT 'Frequency in months at which the Port Facility Security Plan must be reviewed and updated (e.g., 12, 24, 36 months).',
    `security_assessment_reference` STRING COMMENT 'Reference number or identifier of the Port Facility Security Assessment (PFSA) upon which this plan is based.',
    `threat_assessment_date` DATE COMMENT 'Date of the most recent threat assessment conducted for the port facility as part of the security plan maintenance.',
    `training_program_reference` STRING COMMENT 'Reference to the security training and drill program defined in the Port Facility Security Plan.',
    CONSTRAINT pk_facility_security_plan PRIMARY KEY(`facility_security_plan_id`)
) COMMENT 'Master record for the Port Facility Security Plan (PFSP) as mandated by ISPS Code Part B. Captures the approved plan version, approval authority (flag state / RSO), plan scope covering all MARSEC levels (1, 2, 3), designated Port Facility Security Officer (PFSO), plan review cycle, last audit date, next review date, approval certificate reference, and amendment history. This is the foundational ISPS compliance document for each port facility.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`zone` (
    `zone_id` BIGINT COMMENT 'Unique identifier for the security zone within the port facility. Primary key for the security zone registry.',
    `parent_zone_id` BIGINT COMMENT 'Self-referencing FK on zone (parent_zone_id)',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Security zones are physical subdivisions of port locations (restricted areas, public areas, cargo zones). Each zone maps to a specific berth, terminal, or yard location for access control, patrol rout',
    `employee_id` BIGINT COMMENT 'Identifier of the security officer or manager responsible for this zone. Links to workforce or security personnel registry.',
    `tertiary_zone_manager_employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `access_control_requirement_marsec1` STRING COMMENT 'Detailed description of access control measures required for this zone when operating at MARSEC Level 1 (normal security). Includes badge requirements, escort policies, vehicle inspection protocols, and entry authorization procedures.',
    `access_control_requirement_marsec2` STRING COMMENT 'Enhanced access control measures required for this zone when operating at MARSEC Level 2 (heightened security threat). Typically includes additional screening, reduced access lists, mandatory escorts, and enhanced vehicle searches.',
    `access_control_requirement_marsec3` STRING COMMENT 'Maximum security access control measures required for this zone when operating at MARSEC Level 3 (imminent security threat). May include zone closure, armed security, biometric verification, and complete lockdown procedures.',
    `access_point_count` STRING COMMENT 'Number of controlled access points (gates, doors, turnstiles) into the security zone. Used for access control planning and security resource allocation.',
    `area_square_meters` DECIMAL(18,2) COMMENT 'Total area of the security zone measured in square meters. Used for resource allocation, patrol planning, and CCTV coverage calculations.',
    `boundary_description` STRING COMMENT 'Textual description of the physical boundaries of the security zone. Includes landmarks, fence lines, berth numbers, building identifiers, and geographic references for operational clarity.',
    `boundary_gis_polygon` STRING COMMENT 'GIS polygon coordinates defining the precise geographic boundaries of the security zone in WKT (Well-Known Text) format. Used for spatial analysis, mapping, and automated geofencing in access control systems.',
    `cctv_camera_count` STRING COMMENT 'Number of CCTV cameras actively monitoring this security zone. Used for surveillance coverage assessment and maintenance planning.',
    `cctv_coverage_flag` BOOLEAN COMMENT 'Indicates whether the security zone is covered by CCTV surveillance systems. True if cameras monitor the zone, false if no camera coverage exists.',
    `zone_code` STRING COMMENT 'Unique alphanumeric code assigned to the security zone for operational reference and access control system integration. Used in gate systems and patrol logs.. Valid values are `^[A-Z0-9]{3,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this security zone record was first created in the system. Used for audit trail and data lineage.',
    `critical_infrastructure_flag` BOOLEAN COMMENT 'Indicates whether this security zone contains critical infrastructure as defined by national security regulations. True for zones containing fuel storage, power generation, control centers, or other critical assets.',
    `cybersecurity_zone_flag` BOOLEAN COMMENT 'Indicates whether this zone includes IT/OT (Information Technology/Operational Technology) systems requiring cybersecurity controls. True for zones with control rooms, server facilities, or networked operational systems.',
    `effective_from_date` DATE COMMENT 'Date when this security zone designation became effective. Used for historical tracking and compliance documentation.',
    `effective_to_date` DATE COMMENT 'Date when this security zone designation expires or is scheduled for review. Null for indefinite zones. Used for temporary security zones or zones under periodic review.',
    `emergency_assembly_point` STRING COMMENT 'Designated emergency assembly point location for personnel evacuating from this security zone. Used for emergency response planning and safety drills.',
    `incident_count_ytd` STRING COMMENT 'Total number of security incidents recorded in this zone during the current calendar year. Used for security performance monitoring and resource allocation.',
    `last_incident_date` DATE COMMENT 'Date of the most recent security incident recorded in this zone. Used for risk assessment and security effectiveness analysis. Null if no incidents have occurred.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this security zone record was last updated. Used for change tracking and audit compliance.',
    `last_risk_assessment_date` DATE COMMENT 'Date when the most recent security risk assessment was conducted for this zone. ISPS Code requires periodic reassessment of security zones.',
    `lighting_adequacy_flag` BOOLEAN COMMENT 'Indicates whether the security zone has adequate lighting for security purposes as per ISPS Code requirements. True if lighting meets standards, false if lighting is insufficient or requires upgrade.',
    `marsec_level_applicability` STRING COMMENT 'Indicates which MARSEC security levels this zone designation applies to. MARSEC 1 is normal operations, MARSEC 2 is heightened threat, MARSEC 3 is imminent threat. Some zones may only be activated at higher MARSEC levels.. Valid values are `marsec_1|marsec_2|marsec_3|all_levels`',
    `modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified this security zone record. Used for accountability and audit trail.',
    `next_risk_assessment_due_date` DATE COMMENT 'Scheduled date for the next mandatory security risk assessment of this zone. Used for compliance tracking and audit preparation.',
    `operational_hours` STRING COMMENT 'Standard operational hours for this security zone. Format examples: 24/7, 0600-2200, Business Hours Only. Affects access control and patrol scheduling.',
    `patrol_frequency_hours` DECIMAL(18,2) COMMENT 'Required frequency of security patrols for this zone measured in hours. For example, 2.0 indicates patrols every 2 hours, 0.5 indicates patrols every 30 minutes. Used for patrol scheduling and compliance verification.',
    `patrol_type` STRING COMMENT 'Primary method of security patrol used for this zone. Foot patrols for pedestrian areas, vehicle patrols for large zones, marine patrols for waterside zones, combined for multi-modal, remote monitoring for camera-only surveillance.. Valid values are `foot_patrol|vehicle_patrol|marine_patrol|combined_patrol|remote_monitoring`',
    `perimeter_fencing_type` STRING COMMENT 'Type of physical barrier securing the perimeter of the security zone. Chain link for standard fencing, concrete wall for high-security areas, steel barrier for vehicle protection, water barrier for waterside zones, none for open zones.. Valid values are `chain_link|concrete_wall|steel_barrier|water_barrier|none|mixed`',
    `pfsp_reference_section` STRING COMMENT 'Reference to the specific section or annex in the Port Facility Security Plan that details this security zone. Used for audit compliance and security plan maintenance.',
    `remarks` STRING COMMENT 'Additional notes, special instructions, or operational considerations for this security zone. May include seasonal variations, temporary restrictions, or coordination requirements with other zones.',
    `restricted_cargo_types` STRING COMMENT 'Types of cargo that are restricted or prohibited within this security zone. Examples: IMDG Class 1 explosives, radioactive materials, high-value cargo. Pipe-separated list for multiple restrictions.',
    `threat_level` STRING COMMENT 'Current assessed threat level for this specific security zone based on intelligence, historical incidents, and risk assessments. May differ from overall port MARSEC level for high-value or vulnerable zones.. Valid values are `low|moderate|elevated|high|critical`',
    `zone_status` STRING COMMENT 'Current operational status of the security zone. Active zones are enforced, inactive zones are not currently monitored, suspended zones are temporarily disabled, under review zones are being reassessed.. Valid values are `active|inactive|suspended|under_review|decommissioned`',
    `zone_type` STRING COMMENT 'Classification of the security zone based on access restrictions and security requirements. Restricted areas require highest clearance, controlled areas require authorization, public areas allow general access with monitoring.. Valid values are `restricted_area|controlled_area|public_area|exclusion_zone|buffer_zone|critical_infrastructure_zone`',
    CONSTRAINT pk_zone PRIMARY KEY(`zone_id`)
) COMMENT 'Master registry of all designated security zones within the port facility as defined under ISPS Code requirements. Captures zone identifier, zone name, zone type (restricted area, controlled area, public area), MARSEC level applicability, physical boundaries (GIS polygon or textual description), access control requirements per MARSEC level, CCTV coverage flag, patrol frequency, and zone manager. Supports access control enforcement and security patrol planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` (
    `access_credential_id` BIGINT COMMENT 'Unique identifier for the access credential record. Primary key for the access credential entity.',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Customs brokers require facility access credentials to operate in restricted port areas for cargo clearance and documentation. Essential for access control management, broker authorization tracking, a',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Access credentials for organizational representatives (not individual employees) link to port community participants. This FK enables tracking which participant organization a credential holder repres',
    `replaced_access_credential_id` BIGINT COMMENT 'Self-referencing FK on access_credential (replaced_access_credential_id)',
    `access_attempt_count` STRING COMMENT 'Total number of access attempts (successful and failed) recorded for this credential. Used for usage analytics and anomaly detection.',
    `access_time_restrictions` STRING COMMENT 'Description of temporal access restrictions for this credential, such as specific days of the week, time windows, or shift-based access. Free-text or structured time range specification.',
    `background_check_date` DATE COMMENT 'Date on which the most recent background check or security vetting was completed for the credential holder.',
    `background_check_status` STRING COMMENT 'Status of the security background check or vetting process for the credential holder. Required for certain credential types and access levels.. Valid values are `pending|cleared|failed|expired|not_required`',
    `biometric_enrolled` BOOLEAN COMMENT 'Indicates whether the credential holder has completed biometric enrollment (fingerprint, facial recognition, iris scan) for enhanced access control verification.',
    `biometric_modality` STRING COMMENT 'Type of biometric authentication method enrolled for this credential. None indicates no biometric enrollment.. Valid values are `fingerprint|facial_recognition|iris_scan|palm_vein|none`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this credential record was first created in the system. Used for audit trail and record lifecycle tracking.',
    `credential_number` STRING COMMENT 'Unique externally-visible credential number or badge number printed on the physical credential. This is the business identifier used for access control system lookups and audit trails.. Valid values are `^[A-Z0-9]{8,20}$`',
    `credential_status` STRING COMMENT 'Current lifecycle status of the credential. Controls whether the credential is valid for access control system authorization. [ENUM-REF-CANDIDATE: active|suspended|revoked|expired|pending_activation|lost|stolen — 7 candidates stripped; promote to reference product]',
    `credential_type` STRING COMMENT 'Classification of the credential based on its purpose and holder category. Determines access privileges and validation requirements.. Valid values are `port_id_card|vehicle_pass|visitor_pass|contractor_badge|biometric_token|temporary_pass`',
    `escort_required` BOOLEAN COMMENT 'Indicates whether the credential holder must be accompanied by an authorized escort when accessing restricted areas. Typically true for visitors and contractors with limited clearance.',
    `expiry_date` DATE COMMENT 'Date on which the credential expires and is no longer valid for access authorization. Nullable for credentials with indefinite validity subject to periodic review.',
    `failed_access_count` STRING COMMENT 'Total number of failed or denied access attempts for this credential. High counts may indicate lost credentials, unauthorized use, or system issues.',
    `holder_email` STRING COMMENT 'Primary email address of the credential holder for notifications regarding credential expiry, renewal, or security alerts.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `holder_full_name` STRING COMMENT 'Full legal name of the individual or entity to whom the credential is issued. Used for identity verification and audit purposes.',
    `holder_national_identifier` STRING COMMENT 'Government-issued national identification number of the credential holder. Required for background checks and compliance with maritime security regulations.',
    `holder_organization` STRING COMMENT 'Name of the company, agency, or organization that the credential holder represents. Applicable for contractors, vendors, and external parties.',
    `holder_phone` STRING COMMENT 'Primary contact phone number of the credential holder for emergency contact and verification purposes.',
    `holder_type` STRING COMMENT 'Category of the individual or entity to whom this credential is issued. Used for access policy enforcement and reporting segmentation.. Valid values are `employee|contractor|visitor|vendor|government_official|service_provider`',
    `issue_date` DATE COMMENT 'Date on which the credential was officially issued to the holder. Marks the start of the credential validity period.',
    `issuing_authority` STRING COMMENT 'Name of the port security department, office, or authorized personnel who issued the credential. Used for accountability and audit trail.',
    `last_access_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful use of this credential at any port access control point. Used for activity monitoring and dormant credential identification.',
    `marsec_level_access` STRING COMMENT 'Maximum MARSEC security level at which this credential remains valid. MARSEC 1 is normal, MARSEC 2 is heightened, MARSEC 3 is exceptional threat. Credentials may be restricted at higher threat levels.. Valid values are `marsec_1|marsec_2|marsec_3`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this credential record was last modified. Used for audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text field for additional remarks, special instructions, or contextual information about the credential or holder. Used by security personnel for operational notes.',
    `photo_reference` STRING COMMENT 'File path, URL, or document management system reference to the credential holder photograph. Used for visual identity verification at access points.',
    `renewal_notification_sent` BOOLEAN COMMENT 'Indicates whether an automated renewal reminder notification has been sent to the credential holder prior to expiry.',
    `revocation_date` DATE COMMENT 'Date on which the credential was revoked or permanently invalidated. Nullable if the credential has never been revoked.',
    `revocation_reason` STRING COMMENT 'Explanation or justification for why the credential was revoked. Examples include employment termination, security breach, policy violation, or credential compromise.',
    `revoked_by` STRING COMMENT 'Name or identifier of the security officer or authorized personnel who revoked the credential. Used for accountability and audit purposes.',
    `rfid_tag_number` STRING COMMENT 'Unique RFID chip identifier embedded in the credential card for contactless access control system integration. Hexadecimal format.. Valid values are `^[A-F0-9]{16,24}$`',
    `sponsor_contact` STRING COMMENT 'Contact phone number or email of the sponsor for verification and emergency contact purposes.',
    `sponsor_name` STRING COMMENT 'Name of the internal port employee or department who sponsors or vouches for the credential holder. Applicable for visitor and contractor credentials.',
    `training_completion_date` DATE COMMENT 'Date on which the credential holder completed mandatory port security awareness training or ISPS Code familiarization. Required for certain credential types.',
    `vehicle_registration_number` STRING COMMENT 'License plate or registration number of the vehicle associated with this credential. Applicable for vehicle pass credential types.',
    CONSTRAINT pk_access_credential PRIMARY KEY(`access_credential_id`)
) COMMENT 'Master record for all port access credentials issued to personnel, vehicles, and contractors. Captures credential number, credential type (port ID card, vehicle pass, visitor pass, contractor badge, biometric token), holder identity reference, issuing authority, issue date, expiry date, MARSEC level access permissions, zone access entitlements, biometric enrolment status, and revocation details. SSOT for all physical access authorisation within the port precinct.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`access_event` (
    `access_event_id` BIGINT COMMENT 'Unique identifier for the physical access event record. Primary key for the access event log.',
    `access_credential_id` BIGINT COMMENT 'Identifier of the access credential presented during the event (badge, card, biometric token).',
    `access_point_id` BIGINT COMMENT 'Identifier of the physical access control point where the event occurred (gate, turnstile, door, vehicle barrier).',
    `correlated_access_event_id` BIGINT COMMENT 'Self-referencing FK on access_event (correlated_access_event_id)',
    `employee_id` BIGINT COMMENT 'Identifier of the individual who presented the credential and attempted access.',
    `personnel_id` BIGINT COMMENT 'Identifier of the authorized person who escorted the visitor, if escort was required. Null if no escort or escort not required.',
    `security_incident_id` BIGINT COMMENT 'Identifier of the security incident record created as a result of this access event, if the event triggered an incident investigation. Null if no incident was created.',
    `zone_id` BIGINT COMMENT 'Identifier of the restricted security zone that was accessed or attempted to be accessed.',
    `access_control_system_code` STRING COMMENT 'Identifier of the physical access control system (hardware/software platform) that recorded this event.',
    `access_decision` STRING COMMENT 'The access control system decision outcome for this event indicating whether access was granted, denied, or triggered an alarm.. Valid values are `granted|denied|alarm|forced|tailgate|override`',
    `access_duration_minutes` STRING COMMENT 'Duration in minutes that the person remained in the zone, calculated from entry to exit events. Null if exit event not yet recorded or for single-point events.',
    `access_point_type` STRING COMMENT 'Classification of the physical access control point type (vehicle gate, pedestrian gate, turnstile, door, barrier, bollard).. Valid values are `vehicle_gate|pedestrian_gate|turnstile|door|barrier|bollard`',
    `access_purpose` STRING COMMENT 'Stated business purpose or reason for the access (e.g., cargo operations, maintenance, delivery, inspection, meeting).',
    `alarm_triggered_flag` BOOLEAN COMMENT 'Indicates whether this access event triggered a security alarm condition. True if alarm was triggered, False otherwise.',
    `alarm_type` STRING COMMENT 'Classification of the security alarm that was triggered, if applicable. Null if no alarm was triggered.. Valid values are `forced_entry|tailgating|invalid_credential|unauthorized_zone|duress|system_tamper`',
    `anti_passback_violation_flag` BOOLEAN COMMENT 'Indicates whether this event violated anti-passback rules (attempting to enter without a prior exit, or vice versa). True if violation detected, False otherwise.',
    `audit_trail_hash` STRING COMMENT 'Cryptographic hash of the event record to ensure data integrity and prevent tampering for compliance and forensic purposes.',
    `biometric_match_score` DECIMAL(18,2) COMMENT 'Confidence score (0.00 to 100.00) of the biometric authentication match, if biometric credential was used. Null for non-biometric credentials.',
    `cctv_clip_reference` STRING COMMENT 'Reference identifier or file path to the CCTV video clip capturing this access event for forensic review and audit purposes.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this access event record was first created in the database. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX',
    `credential_number` STRING COMMENT 'The unique number or identifier encoded on the physical credential presented during the access event.',
    `credential_type` STRING COMMENT 'Type of credential technology used for the access attempt (RFID card, biometric scan, PIN code, QR code, vehicle RFID tag, visitor pass).. Valid values are `rfid_card|biometric|pin|qr_code|vehicle_tag|visitor_pass`',
    `denial_reason_code` STRING COMMENT 'Standardized code indicating the reason why access was denied, if applicable. Null for granted access events. [ENUM-REF-CANDIDATE: invalid_credential|expired_credential|unauthorized_zone|time_restriction|revoked_access|blacklisted|system_error|unknown — 8 candidates stripped; promote to reference product]',
    `device_serial_number` STRING COMMENT 'Serial number of the physical access control device (card reader, biometric scanner, barrier controller) that captured the event.',
    `direction` STRING COMMENT 'Direction of movement through the access point: inbound (entering the zone) or outbound (exiting the zone).. Valid values are `inbound|outbound`',
    `escort_required_flag` BOOLEAN COMMENT 'Indicates whether the person was required to be escorted while in the accessed zone per security policy. True if escort required, False otherwise.',
    `event_source_ip_address` STRING COMMENT 'IP address of the access control device or system that generated this event record.',
    `event_timestamp` TIMESTAMP COMMENT 'Precise date and time when the access event occurred at the access control point. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX',
    `event_type` STRING COMMENT 'Classification of the access event indicating whether it was an entry, exit, attempted access, or alarm condition.. Valid values are `entry|exit|entry_attempt|exit_attempt|alarm|override`',
    `marsec_level` STRING COMMENT 'The MARSEC security level in effect at the port facility at the time of the access event (1=normal, 2=heightened, 3=exceptional). MARSEC levels are defined by ISPS Code to indicate threat conditions.',
    `notes` STRING COMMENT 'Free-text notes or comments recorded by security personnel regarding this access event, if applicable.',
    `organization_name` STRING COMMENT 'Name of the company or organization that the person represents (e.g., port operator, shipping line, customs, contractor).',
    `override_authorized_by` STRING COMMENT 'Name or identifier of the security supervisor who authorized a manual override of the access control decision. Null for standard automated decisions.',
    `override_reason` STRING COMMENT 'Free-text explanation for why a manual override was authorized, if applicable. Null for standard automated decisions.',
    `person_name` STRING COMMENT 'Full name of the individual associated with the credential at the time of the access event.',
    `temperature_reading_celsius` DECIMAL(18,2) COMMENT 'Body temperature reading in Celsius captured at the access point for health screening purposes. Null if temperature screening not performed.',
    `time_zone_restriction_violated_flag` BOOLEAN COMMENT 'Indicates whether the access attempt violated time-based access restrictions for the credential or zone. True if violation, False otherwise.',
    `vehicle_registration` STRING COMMENT 'License plate or registration number of the vehicle involved in the access event, if applicable. Null for pedestrian access.',
    `visitor_flag` BOOLEAN COMMENT 'Indicates whether the person was a visitor (temporary access) rather than a regular employee or contractor. True if visitor, False if regular personnel.',
    `zone_classification` STRING COMMENT 'Security classification level of the zone: public (open access), restricted (controlled access), high security (limited personnel), or critical infrastructure (essential operations).. Valid values are `public|restricted|high_security|critical_infrastructure`',
    CONSTRAINT pk_access_event PRIMARY KEY(`access_event_id`)
) COMMENT 'Transactional record of every physical access attempt and entry/exit event at port access control points including gates, turnstiles, restricted area doors, and vehicle barriers. Captures event timestamp, access point identifier, credential presented, holder identity, zone accessed, access decision (granted/denied/alarm), denial reason code, MARSEC level at time of event, and CCTV clip reference. Provides the complete audit trail for port access control compliance and forensic investigation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`access_point` (
    `access_point_id` BIGINT COMMENT 'Unique identifier for the physical access control point within the port facility security infrastructure.',
    `facility_building_id` BIGINT COMMENT 'Reference to the port facility building or structure where this access point is physically installed.',
    `parent_access_point_id` BIGINT COMMENT 'Self-referencing FK on access_point (parent_access_point_id)',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Access points (gates, turnstiles, vehicle barriers) are physical entry/exit locations within port infrastructure. Each access point belongs to a specific port location for access control system config',
    `post_id` BIGINT COMMENT 'Reference to the security post or guard station responsible for monitoring and responding to events at this access point.',
    `zone_id` BIGINT COMMENT 'Reference to the security zone classification that this access point controls entry to, supporting ISPS Code restricted area management.',
    `access_level_required` STRING COMMENT 'Minimum security clearance or authorization level required to pass through this access control point.. Valid values are `public|restricted|confidential|high_security`',
    `access_point_type` STRING COMMENT 'Classification of the physical access control point based on its primary function and entry mode.. Valid values are `pedestrian_gate|vehicle_gate|turnstile|restricted_area_door|waterside_access|rail_access`',
    `alarm_integration_flag` BOOLEAN COMMENT 'Indicates whether the access point is integrated with the port facility alarm and intrusion detection system.',
    `anti_tailgating_enabled_flag` BOOLEAN COMMENT 'Indicates whether anti-tailgating or anti-passback technology is enabled to prevent unauthorized persons from following authorized users through the access point.',
    `automation_level` STRING COMMENT 'Degree of automation in the access control process, ranging from fully automated self-service to manual guard-operated.. Valid values are `fully_automated|semi_automated|manual`',
    `barrier_type` STRING COMMENT 'Type of physical barrier mechanism installed at the access point to control passage. [ENUM-REF-CANDIDATE: swing_gate|sliding_gate|boom_barrier|bollard|turnstile|door|none — 7 candidates stripped; promote to reference product]',
    `cctv_camera_ids` STRING COMMENT 'Comma-separated list of CCTV camera identifiers that provide surveillance coverage of this access point.',
    `cctv_coverage_flag` BOOLEAN COMMENT 'Indicates whether the access point is covered by CCTV surveillance cameras for security monitoring and incident investigation.',
    `certification_expiry_date` DATE COMMENT 'Expiration date of the compliance certification, after which re-certification or audit is required.',
    `access_point_code` STRING COMMENT 'Business identifier code assigned to the access control point for operational reference and security system integration.. Valid values are `^AP-[A-Z0-9]{6,12}$`',
    `compliance_certification_number` STRING COMMENT 'Certification or approval number indicating that the access control point meets ISPS Code and national security standards.',
    `control_technology_type` STRING COMMENT 'Primary access control technology deployed at this point for identity verification and authorization (ANPR = Automatic Number Plate Recognition, RFID = Radio Frequency Identification). [ENUM-REF-CANDIDATE: card_reader|biometric_fingerprint|biometric_facial|anpr|manual_guard|rfid|pin_keypad|multi_factor — 8 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this access point record was first created in the security management system.',
    `direction_control` STRING COMMENT 'Indicates whether the access point controls entry, exit, or both directions of movement through the control point.. Valid values are `entry_only|exit_only|bidirectional`',
    `emergency_exit_flag` BOOLEAN COMMENT 'Indicates whether this access point is designated as an emergency exit route for evacuation purposes.',
    `installation_date` DATE COMMENT 'Date when the access control point was originally installed and commissioned for operational use.',
    `integration_system_code` STRING COMMENT 'Identifier of the access control system or security management platform that this access point is integrated with for centralized monitoring.',
    `intercom_available_flag` BOOLEAN COMMENT 'Indicates whether an intercom or two-way communication system is available at this access point for visitor communication with security personnel.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance performed on the access control equipment.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this access point record was most recently modified or updated.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the access point location in decimal degrees for mapping and spatial analysis.',
    `location_description` STRING COMMENT 'Detailed textual description of the access point physical location within the port facility including landmarks and directional references.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the access point location in decimal degrees for mapping and spatial analysis.',
    `access_point_name` STRING COMMENT 'Descriptive name of the access control point for human-readable identification (e.g., Main Gate North, Terminal 3 Pedestrian Entry).',
    `next_maintenance_due_date` DATE COMMENT 'Scheduled date for the next preventive maintenance inspection or service of the access control equipment.',
    `operating_hours` STRING COMMENT 'Standard operating hours for this access point (e.g., 24/7, 0600-1800, business hours only).',
    `operational_status` STRING COMMENT 'Current operational state of the access control point indicating availability for security operations.. Valid values are `active|inactive|maintenance|suspended|decommissioned`',
    `remarks` STRING COMMENT 'Additional notes, special instructions, or operational considerations related to the access control point.',
    `secondary_control_technology` STRING COMMENT 'Secondary or backup access control technology deployed for redundancy or multi-factor authentication requirements. [ENUM-REF-CANDIDATE: card_reader|biometric_fingerprint|biometric_facial|anpr|manual_guard|rfid|pin_keypad|none — 8 candidates stripped; promote to reference product]',
    `throughput_capacity_per_hour` STRING COMMENT 'Maximum number of persons or vehicles that can be processed through this access point per hour under normal operating conditions.',
    `vendor_name` STRING COMMENT 'Name of the vendor or manufacturer that supplied the access control technology and equipment.',
    `visitor_management_integration_flag` BOOLEAN COMMENT 'Indicates whether the access point is integrated with the port visitor management system for pre-registration and visitor tracking.',
    CONSTRAINT pk_access_point PRIMARY KEY(`access_point_id`)
) COMMENT 'Master registry of all physical access control points deployed across the port facility including pedestrian gates, vehicle barriers, turnstiles, restricted area entry doors, and waterside access points. Captures access point identifier, location description, zone association, control technology type (card reader, biometric, ANPR, manual), operational status, CCTV camera coverage, and responsible security post. Supports access event logging and security infrastructure management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` (
    `cctv_camera_id` BIGINT COMMENT 'Unique identifier for the CCTV camera asset within the port facility security infrastructure. Primary key for the camera registry.',
    `access_point_id` BIGINT COMMENT 'add column access_point_id (BIGINT) with FK to security.access_point.access_point_id - CCTV cameras are often co-located with access points for integrated surveillance',
    `replaced_cctv_camera_id` BIGINT COMMENT 'Self-referencing FK on cctv_camera (replaced_cctv_camera_id)',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: CCTV cameras are deployed within specific security zones. The camera currently has security_zone as STRING attribute. This should be normalized to security_zone_id FK to security_zone.security_zone_id',
    `analytics_features` STRING COMMENT 'Comma-separated list of advanced video analytics features enabled for this camera (e.g., facial_recognition, license_plate_recognition, intrusion_detection, object_tracking, crowd_detection, abandoned_object_alert). Used for intelligent surveillance and automated threat detection.',
    `annual_maintenance_cost` DECIMAL(18,2) COMMENT 'Estimated or actual annual maintenance cost for this camera including preventive maintenance, repairs, and spare parts in the port facility base currency. Used for operational expenditure (OPEX) budgeting and total cost of ownership analysis.',
    `asset_owner` STRING COMMENT 'Port facility department or business unit responsible for this camera asset (e.g., Port Security, Terminal Operations, Marine Services). Used for budget allocation, maintenance responsibility, and asset governance.',
    `camera_code` STRING COMMENT 'Externally-known unique asset code for the camera following port facility naming convention (e.g., STS-CAM-00123 for ship-to-shore crane camera). Used for maintenance work orders and security incident reporting.. Valid values are `^[A-Z]{3}-[A-Z]{2,4}-[0-9]{3,5}$`',
    `camera_type` STRING COMMENT 'Classification of camera technology and operational capability. Fixed cameras provide static coverage, PTZ (pan-tilt-zoom) cameras offer remote directional control, thermal cameras enable night/low-visibility monitoring, vessel-monitoring cameras track ship movements, LPR cameras capture vehicle plates at gates, and underwater cameras monitor submerged infrastructure.. Valid values are `fixed|ptz|thermal|vessel_monitoring|license_plate_recognition|underwater`',
    `coverage_area_description` STRING COMMENT 'Textual description of the surveillance coverage area and field of view for this camera (e.g., Monitors container stacking operations in Yard Block A, rows 1-8, Covers vessel gangway and berth access point, Overlooks main gate vehicle inspection zone). Used for security coverage planning and incident response.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this camera record was first created in the asset management system. Used for data lineage, audit trail, and record lifecycle tracking.',
    `criticality_level` STRING COMMENT 'Business criticality classification of the camera based on coverage area importance and security risk. Critical cameras monitor ISPS restricted areas and require immediate fault response, high priority cameras cover operational zones, medium priority cameras provide supplementary coverage, low priority cameras monitor non-essential areas.. Valid values are `critical|high|medium|low`',
    `cybersecurity_zone` STRING COMMENT 'Network security zone classification for the camera. OT (Operational Technology) network for industrial control systems, IT network for corporate systems, DMZ (demilitarized zone) for internet-facing systems, isolated for segmented networks, air-gapped for physically disconnected systems. Used for cybersecurity risk assessment and network access control.. Valid values are `ot_network|it_network|dmz|isolated|air_gapped`',
    `decommission_date` DATE COMMENT 'Date when the camera was permanently removed from service and decommissioned. Null for active cameras. Used for asset lifecycle completion and historical record keeping.',
    `environmental_rating` STRING COMMENT 'IP (Ingress Protection) rating indicating the camera enclosure resistance to dust and water (e.g., IP66 for dust-tight and water-jet resistant, IP67 for submersion protection). Critical for outdoor and marine environment installations.. Valid values are `^IP[0-9]{2}$`',
    `firmware_version` STRING COMMENT 'Current firmware version installed on the camera device. Critical for cybersecurity vulnerability management, feature compatibility, and coordinated firmware update campaigns.',
    `frame_rate_fps` STRING COMMENT 'Video recording frame rate in frames per second (fps). Typical values range from 15 fps (basic surveillance) to 30 fps (smooth motion capture). Higher frame rates improve incident analysis but increase storage requirements.',
    `installation_date` DATE COMMENT 'Date when the camera was physically installed and commissioned at the port facility. Used for asset lifecycle tracking, warranty period calculation, and replacement planning.',
    `installation_location` STRING COMMENT 'Detailed physical location description of the camera installation within the port facility (e.g., Berth 5 North Corner, Container Yard Block C Row 12, Main Gate Entry Lane 3, Administration Building Roof East). Supports incident investigation and coverage gap analysis.',
    `ip_address` STRING COMMENT 'IPv4 network address assigned to the camera on the port facility security network. Used for Video Management System (VMS) integration, remote access, and network troubleshooting. Classified as confidential to prevent unauthorized access attempts.. Valid values are `^(?:[0-9]{1,3}.){3}[0-9]{1,3}$`',
    `last_firmware_update_date` DATE COMMENT 'Date when the camera firmware was last updated. Used for cybersecurity patch management tracking and vulnerability assessment.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance service performed on the camera. Used for maintenance schedule compliance tracking and predictive maintenance planning.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this camera record was last updated in the asset management system. Used for change tracking, data quality monitoring, and audit compliance.',
    `last_online_timestamp` TIMESTAMP COMMENT 'Timestamp when the camera last successfully communicated with the Video Management System. Used for connectivity monitoring, fault detection, and service level agreement (SLA) compliance tracking.',
    `mac_address` STRING COMMENT 'Hardware MAC address of the camera network interface. Used for network access control, device authentication, and cybersecurity incident investigation.. Valid values are `^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$`',
    `manufacturer` STRING COMMENT 'Name of the equipment manufacturer or brand (e.g., Hikvision, Axis Communications, Bosch Security Systems, Dahua Technology). Used for warranty management, spare parts procurement, and vendor performance tracking.',
    `model_number` STRING COMMENT 'Manufacturer model number or product code for the camera unit. Critical for technical specifications lookup, firmware updates, and replacement parts ordering.',
    `motion_detection_enabled_flag` BOOLEAN COMMENT 'Boolean indicator of whether motion detection analytics are enabled for this camera. When true, the camera or VMS triggers alerts on detected movement in defined zones, reducing manual monitoring workload.',
    `mounting_type` STRING COMMENT 'Physical mounting configuration of the camera installation. Pole mount for outdoor surveillance towers, wall mount for building facades, ceiling mount for indoor areas, gantry mount for crane-mounted cameras, mobile mount for temporary or relocatable surveillance.. Valid values are `pole_mount|wall_mount|ceiling_mount|gantry_mount|mobile_mount`',
    `next_maintenance_due_date` DATE COMMENT 'Scheduled date for the next preventive maintenance service on the camera. Calculated based on manufacturer recommendations and port facility maintenance plan. Used for work order scheduling and resource planning.',
    `night_vision_capability_flag` BOOLEAN COMMENT 'Boolean indicator of whether the camera has infrared or low-light night vision capability for 24/7 surveillance. True indicates night vision support, false indicates daylight-only operation.',
    `notes` STRING COMMENT 'Free-text field for additional notes, special instructions, or operational remarks about the camera (e.g., Requires manual cleaning monthly due to salt spray exposure, Shared coverage with camera STS-CAM-00124, Temporary installation pending infrastructure upgrade).',
    `operational_status` STRING COMMENT 'Current operational state of the camera in the surveillance network. Operational indicates active recording and monitoring, offline indicates connectivity loss, maintenance indicates scheduled service, faulty indicates malfunction requiring repair, decommissioned indicates permanent removal from service, testing indicates commissioning or post-repair validation.. Valid values are `operational|offline|maintenance|faulty|decommissioned|testing`',
    `power_source_type` STRING COMMENT 'Type of electrical power supply for the camera. PoE (Power over Ethernet) delivers power via network cable, AC mains uses standard electrical supply, solar uses photovoltaic panels for remote locations, battery backup provides emergency power, hybrid combines multiple sources for resilience.. Valid values are `poe|ac_mains|solar|battery_backup|hybrid`',
    `procurement_cost` DECIMAL(18,2) COMMENT 'Original purchase cost of the camera equipment in the port facility base currency. Used for capital expenditure (CAPEX) tracking, depreciation calculation, and return on investment analysis. Classified as confidential business financial data.',
    `ptz_capability_flag` BOOLEAN COMMENT 'Boolean indicator of whether the camera has pan-tilt-zoom remote control capability. True indicates PTZ functionality for operator-directed surveillance, false indicates fixed-position camera.',
    `recording_resolution` STRING COMMENT 'Maximum video recording resolution capability of the camera (e.g., 1080p Full HD, 4K Ultra HD, 5 megapixel). Higher resolution enables better forensic analysis and facial/license plate recognition but requires more storage capacity.. Valid values are `720p|1080p|2K|4K|5MP|8MP`',
    `retention_period_days` STRING COMMENT 'Number of days that recorded video footage from this camera is retained in the Video Management System before automatic deletion. ISPS Code requires minimum 90 days retention for port facility security footage. Longer retention may be required for critical areas or regulatory compliance.',
    `serial_number` STRING COMMENT 'Unique factory-assigned serial number for the camera device. Used for warranty claims, asset tracking, and cybersecurity device authentication.',
    `vms_integration_status` STRING COMMENT 'Status of camera integration with the central Video Management System platform. Integrated indicates active streaming and recording, pending indicates configuration in progress, failed indicates connectivity or authentication issues, not_configured indicates new camera awaiting setup.. Valid values are `integrated|pending|failed|not_configured`',
    `warranty_expiry_date` DATE COMMENT 'Date when the manufacturer warranty coverage expires for this camera. After this date, repairs and replacements are at port facility expense. Used for budget planning and procurement decisions.',
    CONSTRAINT pk_cctv_camera PRIMARY KEY(`cctv_camera_id`)
) COMMENT 'Master registry of all CCTV cameras deployed across the port facility including fixed cameras, PTZ (pan-tilt-zoom) cameras, thermal imaging cameras, and vessel-monitoring cameras. Captures camera identifier, make and model, installation location, zone coverage, IP address, recording resolution, retention period (days), operational status, last maintenance date, and integration with VMS (Video Management System). Supports surveillance coverage planning and maintenance scheduling.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` (
    `cctv_incident_clip_id` BIGINT COMMENT 'Unique identifier for the CCTV incident clip record. Primary key for the table.',
    `cctv_camera_id` BIGINT COMMENT 'Reference to the CCTV camera that captured this footage clip.',
    `employee_id` BIGINT COMMENT 'Reference to the security officer who authorized and performed the extraction of this CCTV incident clip.',
    `security_incident_id` BIGINT COMMENT 'Reference to the security incident that triggered the extraction of this CCTV footage clip.',
    `source_cctv_incident_clip_id` BIGINT COMMENT 'Self-referencing FK on cctv_incident_clip (source_cctv_incident_clip_id)',
    `access_restriction_level` STRING COMMENT 'Security classification level controlling who can access and view this CCTV incident clip.. Valid values are `public|internal|confidential|restricted|classified`',
    `camera_location` STRING COMMENT 'Physical location description of the CCTV camera that captured this footage (e.g., Gate 3, Berth 5, Container Yard A).',
    `camera_zone` STRING COMMENT 'Security zone classification where the camera is positioned within the port facility. [ENUM-REF-CANDIDATE: restricted_area|public_area|cargo_handling|gate_entry|berth|yard|perimeter|office|warehouse — 9 candidates stripped; promote to reference product]',
    `chain_of_custody_log` STRING COMMENT 'Detailed log of all personnel who have accessed, reviewed, or handled this CCTV incident clip to maintain evidential integrity.',
    `clip_reference_number` STRING COMMENT 'Externally-known unique reference number for the CCTV incident clip, used for chain of custody and legal proceedings.. Valid values are `^CLIP-[0-9]{8}-[A-Z0-9]{6}$`',
    `clip_status` STRING COMMENT 'Current lifecycle status of the CCTV incident clip in the evidence management workflow.. Valid values are `extracted|under_review|preserved|released|archived|deleted`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this CCTV incident clip record was first created in the system.',
    `duration_seconds` STRING COMMENT 'Total duration of the CCTV incident clip measured in seconds.',
    `event_type` STRING COMMENT 'Classification of the security event or incident type that triggered the extraction of this CCTV footage clip. [ENUM-REF-CANDIDATE: access_violation|intrusion|theft|vandalism|safety_incident|investigation|law_enforcement_request — 7 candidates stripped; promote to reference product]',
    `evidence_tag` STRING COMMENT 'Formal evidence tag or identifier assigned to this CCTV incident clip for legal proceedings or investigations.',
    `extraction_reason` STRING COMMENT 'Detailed explanation of why this CCTV footage clip was extracted and preserved.',
    `extraction_timestamp` TIMESTAMP COMMENT 'Date and time when the CCTV footage clip was extracted from the surveillance system.',
    `file_format` STRING COMMENT 'Video file format of the extracted CCTV incident clip.. Valid values are `MP4|AVI|MOV|MKV|H264|H265`',
    `file_size_mb` DECIMAL(18,2) COMMENT 'Size of the CCTV incident clip file measured in megabytes.',
    `footage_end_timestamp` TIMESTAMP COMMENT 'Date and time marking the end of the captured footage in this clip.',
    `footage_start_timestamp` TIMESTAMP COMMENT 'Date and time marking the beginning of the captured footage in this clip.',
    `frame_rate` STRING COMMENT 'Number of frames per second in the CCTV incident clip video.',
    `hash_checksum` STRING COMMENT 'Cryptographic hash (SHA-256) of the CCTV incident clip file to ensure integrity and detect tampering.. Valid values are `^[a-fA-F0-9]{64}$`',
    `investigation_status` STRING COMMENT 'Current status of the investigation associated with this CCTV incident clip.. Valid values are `pending|active|closed|evidence_submitted|no_further_action`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this CCTV incident clip record was last updated or modified.',
    `law_enforcement_agency` STRING COMMENT 'Name of the law enforcement or legal authority that requested this CCTV incident clip.',
    `law_enforcement_reference` STRING COMMENT 'Reference number or case identifier provided by the law enforcement agency for this CCTV incident clip request.',
    `law_enforcement_request_flag` BOOLEAN COMMENT 'Indicates whether this CCTV incident clip was extracted in response to a law enforcement or legal authority request.',
    `notes` STRING COMMENT 'Additional notes, observations, or context regarding this CCTV incident clip.',
    `release_authorization_document` STRING COMMENT 'Reference to the formal authorization document (court order, warrant, or official request) that permitted the release of this CCTV incident clip.',
    `release_date` DATE COMMENT 'Date when this CCTV incident clip was officially released to law enforcement, legal counsel, or other authorized parties.',
    `released_to` STRING COMMENT 'Name of the individual, organization, or authority to whom this CCTV incident clip was released.',
    `resolution` STRING COMMENT 'Video resolution of the CCTV incident clip (e.g., 1920x1080, 1280x720).. Valid values are `^[0-9]{3,4}x[0-9]{3,4}$`',
    `retention_expiry_date` DATE COMMENT 'Date when the retention period expires and the CCTV incident clip becomes eligible for deletion.',
    `retention_override_reason` STRING COMMENT 'Explanation for any extension or modification to the standard retention period for this CCTV incident clip.',
    `retention_period_days` STRING COMMENT 'Number of days this CCTV incident clip must be retained before eligible for deletion, based on regulatory and legal requirements.',
    `storage_location` STRING COMMENT 'File system path or storage repository location where the CCTV incident clip is preserved.',
    CONSTRAINT pk_cctv_incident_clip PRIMARY KEY(`cctv_incident_clip_id`)
) COMMENT 'Transactional record of CCTV footage clips extracted and preserved in connection with security incidents, access violations, investigations, or law enforcement requests. Captures clip identifier, originating camera, start and end timestamps, event type triggering extraction, associated security incident reference, chain of custody log, storage location, retention override reason, and authorising officer. Ensures evidential integrity of surveillance footage for investigations and legal proceedings.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`patrol` (
    `patrol_id` BIGINT COMMENT 'Unique identifier for the security patrol record. Primary key for the security patrol entity.',
    `zone_id` BIGINT COMMENT 'Port facility zone or area where the patrol is conducted, such as restricted area, cargo terminal, berth area, or perimeter zone.',
    `marine_incident_id` BIGINT COMMENT 'Reference to the security incident record if an incident was reported during or as a result of this patrol. Nullable if no incident was escalated.',
    `patrol_route_id` BIGINT COMMENT 'Predefined route or path that the patrol is scheduled to follow, referencing the patrol route master data with checkpoint sequences.',
    `personnel_id` BIGINT COMMENT 'Secondary security officer assigned to accompany or provide backup support during the patrol. Nullable for single-officer patrols.',
    `relieved_patrol_id` BIGINT COMMENT 'Self-referencing FK on patrol (relieved_patrol_id)',
    `shift_pattern_id` BIGINT COMMENT 'Reference to the security shift or duty roster during which this patrol was conducted, used for workforce scheduling and labor cost allocation.',
    `tertiary_patrol_supervisor_security_personnel_id` BIGINT COMMENT 'Security supervisor who reviewed and approved the patrol log. Nullable if review is pending or not required.',
    `access_control_checks` STRING COMMENT 'Number of access control points, gates, or entry barriers inspected during the patrol to verify proper functioning and compliance with security protocols.',
    `actual_end_time` TIMESTAMP COMMENT 'Actual date and time when the patrol was completed, recorded by the security officer at patrol conclusion for duration tracking and shift reconciliation.',
    `actual_start_time` TIMESTAMP COMMENT 'Actual date and time when the patrol commenced, recorded by the security officer at patrol initiation for compliance tracking and variance analysis.',
    `anomalies_detected` STRING COMMENT 'Count of security anomalies, irregularities, or suspicious activities observed during the patrol that require documentation or follow-up action.',
    `anomaly_description` STRING COMMENT 'Detailed narrative description of any security anomalies, irregularities, suspicious activities, or non-compliance observations identified during the patrol, including location, time, and nature of the finding.',
    `cctv_verification_flag` BOOLEAN COMMENT 'Boolean indicator whether CCTV surveillance systems were verified as operational during the patrol. True indicates verification performed, False indicates not checked.',
    `checkpoints_completed` STRING COMMENT 'Actual number of security checkpoints successfully visited and verified during the patrol execution, used for patrol compliance measurement.',
    `checkpoints_planned` STRING COMMENT 'Total number of security checkpoints or inspection points planned to be visited during this patrol route, used for patrol completion verification.',
    `compliance_flag` BOOLEAN COMMENT 'Boolean indicator whether the patrol met all ISPS Code patrol frequency and coverage requirements. True indicates compliant, False indicates non-compliance requiring corrective action.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the patrol record was first created in the system, typically at the time of patrol scheduling or assignment.',
    `distance_covered_km` DECIMAL(18,2) COMMENT 'Total distance covered during the patrol in kilometers, tracked via GPS or vehicle odometer for vehicle and waterside patrols, used for patrol coverage analysis.',
    `duration_minutes` STRING COMMENT 'Actual duration of the patrol in minutes, calculated from actual start time to actual end time, used for labor tracking and patrol efficiency analysis.',
    `equipment_used` STRING COMMENT 'Comma-separated list or description of security equipment and tools used during the patrol, such as radio, flashlight, RFID scanner, body camera, vehicle, or detection devices.',
    `incident_reported_flag` BOOLEAN COMMENT 'Boolean indicator whether a formal security incident was reported as a result of this patrol. True indicates an incident report was filed, False indicates no incident escalation required.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the patrol record was last updated, capturing any changes to patrol status, completion data, or officer notes.',
    `lighting_verification_flag` BOOLEAN COMMENT 'Boolean indicator whether security lighting systems were verified as operational during the patrol. True indicates verification performed, False indicates not checked.',
    `marsec_level` STRING COMMENT 'Maritime Security level in effect during the patrol execution. MARSEC 1 indicates normal security posture, MARSEC 2 indicates heightened security threat, MARSEC 3 indicates imminent or probable security incident requiring maximum protective measures.. Valid values are `MARSEC 1|MARSEC 2|MARSEC 3`',
    `non_compliance_reason` STRING COMMENT 'Explanation of why the patrol did not meet compliance requirements, such as incomplete route, missed checkpoints, or early termination. Nullable if patrol was compliant.',
    `notes` STRING COMMENT 'Free-text field for security officer to record additional observations, comments, or contextual information about the patrol that does not fit structured fields.',
    `patrol_number` STRING COMMENT 'Business identifier for the patrol assignment, formatted as PAT-YYYYMMDD-NNNN for external reference and reporting.. Valid values are `^PAT-[0-9]{8}-[0-9]{4}$`',
    `patrol_status` STRING COMMENT 'Current lifecycle status of the patrol: scheduled for planned but not started, in_progress for active patrol, completed for finished patrol, cancelled for pre-start cancellation, suspended for temporary halt, or aborted for early termination due to incident or emergency.. Valid values are `scheduled|in_progress|completed|cancelled|suspended|aborted`',
    `patrol_type` STRING COMMENT 'Classification of the patrol method used: foot patrol for walking inspections, vehicle patrol for mobile inspections, waterside patrol for marine-side security, perimeter patrol for fence line checks, combined for multi-method patrols, or roving for random pattern patrols.. Valid values are `foot|vehicle|waterside|perimeter|combined|roving`',
    `perimeter_integrity_flag` BOOLEAN COMMENT 'Boolean indicator whether the facility perimeter (fencing, barriers, gates) was verified as intact and secure during the patrol. True indicates integrity confirmed, False indicates breach or damage detected.',
    `review_timestamp` TIMESTAMP COMMENT 'Date and time when the patrol log was reviewed and approved by the supervisor. Nullable if review is pending.',
    `scheduled_end_time` TIMESTAMP COMMENT 'Planned date and time when the patrol is scheduled to be completed, used for patrol duration planning and shift management.',
    `scheduled_start_time` TIMESTAMP COMMENT 'Planned date and time when the patrol is scheduled to commence, as defined in the patrol roster or security operations plan.',
    `supervisor_review_flag` BOOLEAN COMMENT 'Boolean indicator whether the patrol log has been reviewed and approved by a security supervisor. True indicates reviewed, False indicates pending review.',
    `vehicle_code` BIGINT COMMENT 'Reference to the security vehicle or patrol vessel used for vehicle or waterside patrols. Nullable for foot patrols.',
    `visibility_level` STRING COMMENT 'Assessment of visibility conditions during the patrol, affecting the officers ability to detect security threats or anomalies. Factors include lighting, weather, and time of day.. Valid values are `excellent|good|moderate|poor|very_poor`',
    `weather_conditions` STRING COMMENT 'Prevailing weather conditions during the patrol execution that may impact patrol effectiveness, visibility, or officer safety. [ENUM-REF-CANDIDATE: clear|rain|fog|wind|storm|snow|extreme_heat — 7 candidates stripped; promote to reference product]',
    CONSTRAINT pk_patrol PRIMARY KEY(`patrol_id`)
) COMMENT 'Transactional record of security patrol assignments and execution logs for port facility patrols. Captures patrol identifier, patrol type (foot, vehicle, waterside, perimeter), assigned security officer(s), planned route, scheduled start and end times, actual start and end times, MARSEC level, checkpoints visited with timestamps, anomalies observed, and patrol completion status. Supports ISPS Code patrol frequency requirements and security operations management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` (
    `security_incident_id` BIGINT COMMENT 'Unique identifier for the security incident record. Primary key for the security incident entity.',
    `escalated_security_incident_id` BIGINT COMMENT 'Self-referencing FK on security_incident (escalated_security_incident_id)',
    `employee_id` BIGINT COMMENT 'Identifier of the security officer or staff member who filed the initial incident report.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Security incidents occur within specific security zones. The incident currently has location_zone as STRING attribute. This should be normalized to security_zone_id FK to security_zone.security_zone_i',
    `access_control_logs_reference` STRING COMMENT 'Reference identifier for access control system logs relevant to the incident (badge swipes, gate entries, biometric records).',
    `cargo_description` STRING COMMENT 'Description of cargo involved in the incident including container numbers, commodity type, and quantity if applicable.',
    `cargo_involved_flag` BOOLEAN COMMENT 'Boolean flag indicating whether cargo was involved in or affected by the security incident.',
    `cctv_footage_available_flag` BOOLEAN COMMENT 'Boolean flag indicating whether CCTV surveillance footage of the incident is available for review.',
    `cctv_footage_reference` STRING COMMENT 'Reference identifier or storage location for CCTV footage related to the incident.',
    `closed_datetime` TIMESTAMP COMMENT 'Date and time when the security incident was officially closed after resolution and completion of all follow-up actions.',
    `corrective_actions` STRING COMMENT 'Description of corrective actions implemented or planned to prevent recurrence of similar security incidents.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this security incident record was first created in the port security management system.',
    `datetime` TIMESTAMP COMMENT 'Date and time when the security incident occurred or was first detected. This is the principal business event timestamp for the incident.',
    `detected_by` STRING COMMENT 'Method or source through which the security incident was initially detected. [ENUM-REF-CANDIDATE: cctv_surveillance|security_patrol|access_control_system|vessel_crew|port_staff|third_party|automated_sensor — 7 candidates stripped; promote to reference product]',
    `estimated_financial_impact` DECIMAL(18,2) COMMENT 'Estimated financial impact of the security incident including property damage, theft losses, operational disruption costs, and response expenses in USD.',
    `immediate_response_actions` STRING COMMENT 'Detailed description of immediate response actions taken by security personnel, PFSO, or emergency responders to contain and address the incident.',
    `incident_number` STRING COMMENT 'Externally-known unique business identifier for the security incident, formatted as SI-YYYY-NNNNNN for tracking and reporting purposes.. Valid values are `^SI-[0-9]{4}-[0-9]{6}$`',
    `incident_status` STRING COMMENT 'Current lifecycle status of the security incident in the response and investigation workflow.. Valid values are `reported|under_investigation|contained|resolved|closed`',
    `incident_type` STRING COMMENT 'Classification of the security incident. Additional types include bomb threat, piracy attempt, cyber incident, and other security events as defined by ISPS Code and port security protocols.. Valid values are `unauthorised_access|perimeter_breach|theft|sabotage|stowaways|suspicious_behaviour`',
    `investigation_status` STRING COMMENT 'Current status of the security investigation into the incident.. Valid values are `not_started|in_progress|completed|closed_unresolved`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this security incident record was last updated or modified.',
    `law_enforcement_case_number` STRING COMMENT 'Case or reference number assigned by law enforcement agency if the incident was reported to police or other authorities.',
    `law_enforcement_notified_flag` BOOLEAN COMMENT 'Boolean flag indicating whether local or national law enforcement agencies were notified of the incident.',
    `lessons_learned` STRING COMMENT 'Summary of lessons learned from the incident for knowledge sharing and continuous improvement of security protocols.',
    `location_berth` STRING COMMENT 'Specific berth identifier where the incident occurred, if applicable. Null if incident did not occur at a berth.',
    `location_coordinates` STRING COMMENT 'Geographic coordinates (latitude, longitude) of the incident location for precise mapping and spatial analysis.. Valid values are `^-?[0-9]{1,3}.[0-9]+,-?[0-9]{1,3}.[0-9]+$`',
    `location_gate` STRING COMMENT 'Specific gate identifier where the incident occurred, if applicable. Null if incident did not occur at a gate.',
    `marsec_level` STRING COMMENT 'The MARSEC (Maritime Security) level in effect at the time of the incident. MARSEC 1 is normal, MARSEC 2 is heightened, MARSEC 3 is exceptional.. Valid values are `MARSEC_1|MARSEC_2|MARSEC_3`',
    `national_authority_escalated_datetime` TIMESTAMP COMMENT 'Date and time when the incident was escalated to the national maritime security authority.',
    `national_authority_escalated_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the incident was escalated to the national maritime security authority or designated security agency.',
    `operational_impact_description` STRING COMMENT 'Description of the impact of the security incident on port operations including delays, berth closures, cargo holds, or service disruptions.',
    `persons_involved_count` STRING COMMENT 'Number of persons directly involved in or associated with the security incident (perpetrators, suspects, witnesses).',
    `persons_involved_description` STRING COMMENT 'Detailed description of persons involved in the incident including physical descriptions, identification details, and roles. Confidential for security purposes.',
    `pfso_notified_datetime` TIMESTAMP COMMENT 'Date and time when the PFSO was notified of the security incident.',
    `pfso_notified_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the Port Facility Security Officer was notified of the incident as required by ISPS Code.',
    `port_authority_notified_datetime` TIMESTAMP COMMENT 'Date and time when the port authority was notified of the security incident.',
    `port_authority_notified_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the port authority was notified of the incident.',
    `report_document_reference` STRING COMMENT 'Reference identifier or storage location for the formal written incident report document.',
    `reported_datetime` TIMESTAMP COMMENT 'Date and time when the security incident was officially reported to the Port Facility Security Officer (PFSO) or security operations center.',
    `reporting_officer_name` STRING COMMENT 'Full name of the security officer or staff member who filed the initial incident report.',
    `root_cause_analysis` STRING COMMENT 'Detailed root cause analysis findings identifying underlying factors that contributed to the security incident.',
    `severity_level` STRING COMMENT 'Assessed severity level of the security incident based on potential impact to port operations, safety, and security.. Valid values are `low|medium|high|critical`',
    `subtype` STRING COMMENT 'Detailed sub-classification of the incident type providing additional granularity for analysis and reporting (e.g., vehicle intrusion, gate breach, cargo tampering).',
    `threat_level` STRING COMMENT 'Assessed threat level associated with the incident based on intelligence and risk analysis.. Valid values are `minimal|moderate|substantial|severe`',
    `vessel_imo_number` STRING COMMENT 'IMO number of the vessel involved in or associated with the security incident, if applicable. Null if no vessel involved.. Valid values are `^IMO[0-9]{7}$`',
    `vessel_name` STRING COMMENT 'Name of the vessel involved in or associated with the security incident, if applicable.',
    CONSTRAINT pk_security_incident PRIMARY KEY(`security_incident_id`)
) COMMENT 'Core transactional record of all security incidents occurring within the port facility or port waters. Captures incident number, incident type (unauthorised access, perimeter breach, theft, sabotage, stowaways, suspicious behaviour, bomb threat, piracy attempt, cyber incident), date and time, location (zone, berth, gate), MARSEC level at time, persons involved, vessels involved, immediate response actions taken, reporting officer, notification to port authority and PFSO, and escalation to national maritime security authority. SSOT for port security incident management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`investigation` (
    `investigation_id` BIGINT COMMENT 'Unique identifier for the security investigation record. Primary key.',
    `cyber_incident_id` BIGINT COMMENT 'Foreign key linking to security.cyber_incident. Business justification: Formal investigations are opened for cyber incidents (in addition to security incidents). Cyber incidents have investigation_status field, confirming this relationship. Adding explicit FK enables trac',
    `employee_id` BIGINT COMMENT 'Reference to the security officer or investigator assigned as the lead for this investigation. Responsible for coordinating investigation activities and reporting.',
    `parent_investigation_id` BIGINT COMMENT 'Self-referencing FK on investigation (related_investigation_id)',
    `security_incident_id` BIGINT COMMENT 'Reference to the security incident that triggered this investigation. Links investigation to the originating incident report.',
    `stowaway_case_id` BIGINT COMMENT 'Foreign key linking to security.stowaway_case. Business justification: Formal investigations are opened for stowaway cases to determine how the security breach occurred. Stowaway cases have security_breach_flag and corrective_action_required_flag fields, confirming inves',
    `access_log_references` STRING COMMENT 'References to access control system logs examined during the investigation. Includes badge swipes, gate entries, biometric scans, and system access records.',
    `cctv_footage_references` STRING COMMENT 'References to CCTV video clips and camera identifiers relevant to the investigation. Includes camera locations, timestamps, and storage system references.',
    `closed_by` STRING COMMENT 'Name or identifier of the person or role who authorized closure of the investigation. Typically Port Facility Security Officer (PFSO) or senior security management.',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the investigation was formally closed after all findings were documented, recommendations issued, and required notifications completed.',
    `confidentiality_classification` STRING COMMENT 'Data classification level for the investigation record. Determines access controls and information sharing restrictions. Most investigations are confidential or restricted.. Valid values are `public|internal|confidential|restricted`',
    `contributing_factors` STRING COMMENT 'Additional factors that contributed to the incident or enabled its occurrence. May include environmental conditions, staffing levels, equipment status, or procedural weaknesses.',
    `corrective_actions_required` STRING COMMENT 'Specific corrective actions mandated as a result of the investigation. May include immediate remediation, policy updates, system upgrades, or personnel actions.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this investigation record was first created in the security management system.',
    `disciplinary_action_taken` BOOLEAN COMMENT 'Indicates whether disciplinary action was taken against personnel as a result of the investigation findings. Details stored separately with HR records.',
    `estimated_financial_impact` DECIMAL(18,2) COMMENT 'Estimated financial impact of the security incident in USD including direct losses, damage costs, operational disruption, and remediation expenses.',
    `evidence_collected` STRING COMMENT 'Comprehensive list of evidence collected during the investigation including CCTV footage references, access log extracts, witness statement identifiers, physical evidence, and digital forensics artifacts.',
    `findings_summary` STRING COMMENT 'Comprehensive summary of investigation findings including what occurred, how it occurred, who was involved, and what security controls failed or were bypassed.',
    `incident_end_timestamp` TIMESTAMP COMMENT 'Reconstructed date and time when the security incident concluded or was contained, based on investigation findings and evidence analysis.',
    `incident_location` STRING COMMENT 'Specific location within the port facility where the security incident occurred. May include terminal, berth, gate, warehouse, or facility zone identifier.',
    `incident_start_timestamp` TIMESTAMP COMMENT 'Reconstructed date and time when the security incident is believed to have started, based on investigation findings and evidence analysis.',
    `initiated_by` STRING COMMENT 'Name or identifier of the person or role who authorized the initiation of the investigation. Typically Port Facility Security Officer (PFSO) or senior security management.',
    `initiated_timestamp` TIMESTAMP COMMENT 'Date and time when the formal investigation was officially initiated following the security incident report.',
    `investigation_number` STRING COMMENT 'Externally-known unique investigation reference number assigned for tracking and reporting purposes. Format: INV-YYYY-NNNNNN.. Valid values are `^INV-[0-9]{4}-[0-9]{6}$`',
    `investigation_status` STRING COMMENT 'Current lifecycle status of the investigation. Tracks progression from initiation through evidence collection, analysis, review, and closure.. Valid values are `initiated|evidence_collection|analysis|pending_review|closed|suspended`',
    `investigation_type` STRING COMMENT 'Classification of the investigation based on the nature of the security incident being investigated. Determines investigation protocols and regulatory reporting requirements.. Valid values are `security_breach|access_violation|theft|sabotage|cyber_incident|isps_non_compliance`',
    `isps_compliance_impact` STRING COMMENT 'Assessment of how the incident and findings impact the port facilitys ISPS Code compliance status. May trigger security plan amendments or additional measures.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this investigation record was last updated. Tracks changes throughout the investigation lifecycle.',
    `law_enforcement_agency` STRING COMMENT 'Name of the law enforcement agency notified or involved in the investigation. May include port police, national maritime security, customs, or other authorities.',
    `law_enforcement_case_number` STRING COMMENT 'Case or reference number assigned by law enforcement agency if they opened a parallel investigation or criminal case.',
    `law_enforcement_notified` BOOLEAN COMMENT 'Indicates whether law enforcement authorities were notified of the incident and investigation. Required for certain incident types under ISPS Code and local regulations.',
    `lessons_learned` STRING COMMENT 'Key lessons learned from the investigation to be shared with security teams and incorporated into training programs and security awareness initiatives.',
    `operational_impact_hours` DECIMAL(18,2) COMMENT 'Total hours of operational disruption caused by the security incident. Includes facility closures, berth unavailability, gate delays, or system downtime.',
    `personnel_involved_count` STRING COMMENT 'Number of personnel identified as involved in or affected by the security incident. May include suspects, victims, witnesses, or responders.',
    `priority` STRING COMMENT 'Priority level assigned to the investigation based on severity of the incident, potential impact, and regulatory urgency.. Valid values are `critical|high|medium|low`',
    `recommendations` STRING COMMENT 'Formal recommendations for corrective actions, security enhancements, procedural changes, training requirements, or system improvements to prevent recurrence.',
    `regulatory_authority_notified` STRING COMMENT 'Name of the regulatory authority or authorities notified of the investigation findings. May include national maritime authority, port state control, or IMO designated authority.',
    `regulatory_notification_date` DATE COMMENT 'Date when regulatory authorities were formally notified of the investigation findings and outcomes.',
    `regulatory_notification_required` BOOLEAN COMMENT 'Indicates whether the incident and investigation findings must be reported to maritime regulatory authorities under ISPS Code or other compliance frameworks.',
    `report_reference` STRING COMMENT 'Reference to the formal investigation report document stored in the document management system. Contains full investigation details, evidence, and findings.',
    `root_cause_determination` STRING COMMENT 'Identified root cause of the security incident based on investigation analysis. May include human error, system failure, procedural gap, external threat, or combination of factors.',
    `scope_description` STRING COMMENT 'Detailed description of the investigation scope including areas, systems, personnel, and timeframes to be examined. Defines boundaries and objectives of the investigation.',
    `security_control_failures` STRING COMMENT 'Specific security controls, systems, or procedures that failed or were found inadequate during the incident. Identifies gaps in the port facility security plan.',
    `security_plan_amendment_required` BOOLEAN COMMENT 'Indicates whether the Port Facility Security Plan (PFSP) must be amended based on investigation findings and identified security gaps.',
    `team` STRING COMMENT 'Comma-separated list of team member names or identifiers involved in the investigation. May include internal security staff, external consultants, and law enforcement liaisons.',
    `timeline_of_events` STRING COMMENT 'Chronological reconstruction of events during the incident based on evidence collected. Includes key actions, observations, and system events in sequence.',
    `witness_statement_summary` STRING COMMENT 'Aggregated summary of key information from witness statements. Individual witness identities are protected; detailed statements stored separately with restricted access.',
    `witness_statements_count` STRING COMMENT 'Number of formal witness statements collected during the investigation from personnel, contractors, visitors, or other parties with relevant information.',
    CONSTRAINT pk_investigation PRIMARY KEY(`investigation_id`)
) COMMENT 'Formal investigation record linked to a reported security incident, capturing the full investigation lifecycle from initiation through findings to closure. Captures investigation number, linked incident, investigation type, lead investigator, investigation team, scope of investigation, timeline of events reconstructed, evidence collected (CCTV clips, access logs, witness statements), root cause determination, findings summary, recommendations, and regulatory notification outcomes. Supports ISPS Code investigation obligations and law enforcement liaison.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` (
    `threat_assessment_id` BIGINT COMMENT 'Unique identifier for the threat assessment record. Primary key for the threat assessment entity.',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Threat assessments are conducted to support and validate the Port Facility Security Plan (PFSP). Each assessment should reference the specific plan version it supports or informs. This is a clear 1:N ',
    `isps_facility_record_id` BIGINT COMMENT 'Reference to the port facility that is the subject of this threat assessment. Links to the facility master data in the Port Infrastructure domain.',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Threat assessments evaluate flag state risk profiles using Paris/Tokyo MOU targeting factors, PSC deficiency rates, and flag of convenience status. ISPS Code requires facility to assess vessel flag st',
    `primary_superseded_by_assessment_threat_assessment_id` BIGINT COMMENT 'Reference to the newer threat assessment that supersedes this record. Used to maintain assessment lineage and ensure only the current assessment is operationally active. Null if this is the current active assessment.',
    `vessel_id` BIGINT COMMENT 'Reference to a specific vessel when the assessment is vessel-specific. Null for facility-wide assessments. Links to vessel master data in the Vessel Operations domain.',
    `approval_date` DATE COMMENT 'Date when the threat assessment was formally approved by the designated authority. This date marks the activation of the assessment findings and recommendations for operational implementation.',
    `approval_status` STRING COMMENT 'Approval status of the threat assessment by the designated approving authority (typically the national maritime security authority or port state control). Pending approval indicates submission awaiting review; approved indicates acceptance without conditions; conditionally approved indicates acceptance with specified modifications; rejected indicates non-acceptance; revision required indicates substantive changes needed before resubmission.. Valid values are `pending_approval|approved|conditionally_approved|rejected|revision_required`',
    `approved_by` STRING COMMENT 'Name and title of the authority or individual who approved the threat assessment. Typically a representative of the national maritime security authority, port state control, or designated security official.',
    `assessment_date` DATE COMMENT 'Date when the threat assessment was completed and finalized by the conducting authority. This is the principal business event timestamp representing when the assessment findings were documented.',
    `assessment_methodology` STRING COMMENT 'Description of the methodology, framework, or standard used to conduct the threat assessment. Examples include ISPS Code methodology, CARVER+Shock, FEMA Risk Assessment methodology, or proprietary security assessment frameworks.',
    `assessment_number` STRING COMMENT 'Business reference number for the threat assessment. Format varies by assessment type: PFSA-YYYY-#### for Port Facility Security Assessments, TA-YYYY-#### for ad-hoc threat assessments, VTA-YYYY-#### for vessel-specific threat assessments.. Valid values are `^PFSA-[0-9]{4}-[0-9]{4}$|^TA-[0-9]{4}-[0-9]{4}$|^VTA-[0-9]{4}-[0-9]{4}$`',
    `assessment_report_document_reference` STRING COMMENT 'Reference identifier or file path to the full threat assessment report document. The report contains detailed findings, evidence, analysis, and recommendations that support the summary data captured in this record.',
    `assessment_start_date` DATE COMMENT 'Date when the threat assessment process was initiated. Used to track assessment duration and compliance with mandated assessment timelines.',
    `assessment_status` STRING COMMENT 'Current lifecycle status of the threat assessment. Draft indicates work in progress; under review indicates submission to approving authority; approved indicates acceptance and activation; rejected indicates non-acceptance requiring revision; superseded indicates replacement by newer assessment; archived indicates historical record retention.. Valid values are `draft|under_review|approved|rejected|superseded|archived`',
    `assessment_type` STRING COMMENT 'Classification of the threat assessment. Port Facility Security Assessment (PFSA) is the comprehensive ISPS-mandated assessment; ad-hoc assessments respond to emerging threats; vessel-specific assessments evaluate risks from particular vessels or cargo; infrastructure assessments focus on physical vulnerabilities; cyber assessments evaluate IT/OT security posture; periodic reviews are scheduled reassessments.. Valid values are `port_facility_security_assessment|ad_hoc_threat_assessment|vessel_specific_threat_assessment|infrastructure_vulnerability_assessment|cyber_threat_assessment|periodic_review`',
    `classification_level` STRING COMMENT 'Security classification level assigned to the threat assessment document and data. Determines access controls and handling procedures. Most threat assessments are classified as confidential or restricted due to sensitive security information.. Valid values are `unclassified|confidential|restricted|secret`',
    `conducting_authority` STRING COMMENT 'Entity or role responsible for conducting the threat assessment. Recognized Security Organization (RSO) is an accredited third-party assessor; Port Facility Security Officer (PFSO) is the internal security lead; internal security team represents in-house capability; external consultant is a contracted specialist; government agency is a regulatory or intelligence body; joint assessment team is a multi-party collaboration.. Valid values are `recognized_security_organization|port_facility_security_officer|internal_security_team|external_consultant|government_agency|joint_assessment_team`',
    `conducting_organization_name` STRING COMMENT 'Name of the organization or entity that performed the threat assessment. For RSO assessments, this is the accredited security organization; for internal assessments, this is the port authority or terminal operator name.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this threat assessment record was first created in the system. Used for audit trail and data lineage tracking.',
    `intelligence_sources_consulted` STRING COMMENT 'Description of threat intelligence sources consulted during the assessment, such as national maritime security bulletins, port state control advisories, regional security information sharing networks, law enforcement intelligence, or commercial threat intelligence services.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this threat assessment record was last updated. Tracks the most recent change to any field in the record for audit and version control purposes.',
    `lead_assessor_credentials` STRING COMMENT 'Professional qualifications and certifications held by the lead assessor, such as Certified Protection Professional (CPP), Physical Security Professional (PSP), ISPS auditor certification, or equivalent credentials demonstrating competence in maritime security assessment.',
    `lead_assessor_name` STRING COMMENT 'Name of the individual who led the threat assessment. This person is accountable for the assessment methodology, findings, and recommendations.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified this threat assessment record. Supports audit trail and accountability for data changes.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review or reassessment. ISPS Code requires regular reassessment of threat and vulnerability conditions. Typical review cycles are annual or biennial, or triggered by significant security incidents or infrastructure changes.',
    `overall_risk_rating` STRING COMMENT 'Composite risk rating representing the aggregate security posture of the facility or vessel based on all evaluated threat categories and identified vulnerabilities. This rating informs the security level and countermeasure requirements in the Port Facility Security Plan (PFSP).. Valid values are `critical|high|medium|low|negligible`',
    `recommended_countermeasures` STRING COMMENT 'Detailed recommendations for security countermeasures to mitigate identified threats and vulnerabilities. May include physical security enhancements, procedural changes, technology deployments, training requirements, and policy updates. These recommendations form the basis for PFSP development or revision.',
    `review_frequency_months` STRING COMMENT 'Mandated or recommended frequency for reassessment, expressed in months. Common values are 12 (annual), 24 (biennial), or 36 (triennial) depending on facility risk profile and regulatory requirements.',
    `stakeholder_consultation_conducted` BOOLEAN COMMENT 'Indicates whether consultation with relevant stakeholders (terminal operators, shipping lines, customs, law enforcement, emergency services) was conducted as part of the assessment process. Stakeholder input enhances assessment comprehensiveness and operational feasibility of recommendations.',
    `threat_cyber_evaluated` BOOLEAN COMMENT 'Indicates whether cyber threats to port IT and OT systems were evaluated in this assessment. Cyber threats include ransomware, data breaches, operational technology disruption, and denial-of-service attacks.',
    `threat_cyber_rating` STRING COMMENT 'Risk rating assigned to cyber threats based on IT/OT security posture, network segmentation, patch management, incident response capability, and threat intelligence on cyber attacks targeting maritime infrastructure.. Valid values are `critical|high|medium|low|negligible|not_evaluated`',
    `threat_piracy_evaluated` BOOLEAN COMMENT 'Indicates whether piracy and armed robbery threats were evaluated in this assessment. Relevant for ports in regions with maritime piracy activity.',
    `threat_piracy_rating` STRING COMMENT 'Risk rating assigned to piracy and armed robbery threats based on regional threat intelligence, historical incidents, and current security conditions.. Valid values are `critical|high|medium|low|negligible|not_evaluated`',
    `threat_sabotage_evaluated` BOOLEAN COMMENT 'Indicates whether sabotage threats (intentional damage to infrastructure, equipment, or cargo) were evaluated in this assessment.',
    `threat_sabotage_rating` STRING COMMENT 'Risk rating assigned to sabotage threats based on insider threat controls, access restrictions to critical infrastructure, and background screening effectiveness.. Valid values are `critical|high|medium|low|negligible|not_evaluated`',
    `threat_smuggling_evaluated` BOOLEAN COMMENT 'Indicates whether smuggling threats (contraband, narcotics, weapons, illegal goods) were evaluated in this assessment. Smuggling undermines customs compliance and can facilitate other security threats.',
    `threat_smuggling_rating` STRING COMMENT 'Risk rating assigned to smuggling threats based on cargo inspection procedures, customs integration, and intelligence on smuggling activity in the region.. Valid values are `critical|high|medium|low|negligible|not_evaluated`',
    `threat_stowaways_evaluated` BOOLEAN COMMENT 'Indicates whether stowaway infiltration threats were evaluated in this assessment. Stowaways pose security, safety, and legal risks to port and vessel operations.',
    `threat_stowaways_rating` STRING COMMENT 'Risk rating assigned to stowaway infiltration threats based on access control effectiveness, perimeter security, and historical stowaway incidents.. Valid values are `critical|high|medium|low|negligible|not_evaluated`',
    `threat_terrorism_evaluated` BOOLEAN COMMENT 'Indicates whether terrorism threats were evaluated in this assessment. ISPS Code mandates evaluation of terrorism as a primary threat category.',
    `threat_terrorism_rating` STRING COMMENT 'Risk rating assigned to terrorism threats based on likelihood and potential impact. Critical indicates imminent or highly probable threat with catastrophic consequences; high indicates probable threat with severe consequences; medium indicates possible threat with moderate consequences; low indicates unlikely threat with limited consequences; negligible indicates minimal or no credible threat; not evaluated indicates this category was not assessed.. Valid values are `critical|high|medium|low|negligible|not_evaluated`',
    `vulnerability_findings_summary` STRING COMMENT 'Executive summary of key vulnerabilities identified during the assessment. Describes weaknesses in physical security, access control, surveillance, cybersecurity, or operational procedures that could be exploited by threat actors.',
    CONSTRAINT pk_threat_assessment PRIMARY KEY(`threat_assessment_id`)
) COMMENT 'Formal threat and vulnerability assessment records for the port facility as required under ISPS Code. Captures assessment identifier, assessment type (Port Facility Security Assessment — PFSA, ad-hoc threat assessment, vessel-specific threat assessment), assessment date, conducting authority (RSO, internal PFSO), threat categories evaluated (terrorism, piracy, stowaways, smuggling, cyber), vulnerability findings, risk rating per threat category, recommended countermeasures, approval status, and next review date. Foundational input to the PFSP.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` (
    `marsec_level_change_id` BIGINT COMMENT 'Unique identifier for the MARSEC level change record. Primary key.',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: MARSEC level changes are executed under a specific version of the Port Facility Security Plan. The change record currently has security_plan_version as STRING. This should be normalized to facility_se',
    `primary_superseded_by_change_marsec_level_change_id` BIGINT COMMENT 'Reference to the subsequent MARSEC level change that superseded this one. Null if this is the current active change.',
    `zone_id` BIGINT COMMENT 'add column zone_id (BIGINT) with FK to security.zone.zone_id - MARSEC level changes apply to specific security zones within the port',
    `access_control_measures` STRING COMMENT 'Description of the access control measures to be implemented at this MARSEC level (e.g., enhanced ID checks, escort requirements, restricted access zones).',
    `cargo_screening_requirement` STRING COMMENT 'The level of cargo screening required at this MARSEC level.. Valid values are `standard|enhanced|100_percent_screening|random_sampling|risk_based`',
    `change_number` STRING COMMENT 'Business identifier for the MARSEC level change event, formatted as MARSEC-YYYY-NNNNNN.. Valid values are `^MARSEC-[0-9]{4}-[0-9]{6}$`',
    `change_reason_code` STRING COMMENT 'Coded reason category for the MARSEC level change. [ENUM-REF-CANDIDATE: threat_intelligence|security_incident|regional_conflict|terrorist_activity|piracy_alert|cyber_threat|drill_exercise — 7 candidates stripped; promote to reference product]',
    `change_reason_description` STRING COMMENT 'Detailed narrative explanation of the reason for the MARSEC level change, including threat assessment details and intelligence briefing summary.',
    `communication_protocol` STRING COMMENT 'The communication protocol and procedures to be followed by vessels and port users during this MARSEC level.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this MARSEC level change record was first created in the system.',
    `cybersecurity_posture` STRING COMMENT 'The cybersecurity posture level for port IT/OT systems corresponding to this MARSEC level.. Valid values are `normal|elevated|high_alert|lockdown`',
    `declaration_timestamp` TIMESTAMP COMMENT 'The date and time when the MARSEC level change was officially declared by the issuing authority.',
    `drill_exercise_flag` BOOLEAN COMMENT 'Indicates whether this MARSEC level change is part of a planned security drill or exercise rather than a real threat response.',
    `duration_type` STRING COMMENT 'Indicates whether the MARSEC level change is indefinite, temporary, or time-limited.. Valid values are `indefinite|temporary|time_limited|until_further_notice`',
    `effective_timestamp` TIMESTAMP COMMENT 'The date and time when the new MARSEC level becomes effective and operational security posture changes must be implemented.',
    `geographic_scope` STRING COMMENT 'The geographic area or zone within the port facility to which this MARSEC level change applies.. Valid values are `entire_port|specific_terminal|specific_berth|anchorage_area|port_waters|restricted_zone`',
    `issuing_authority_name` STRING COMMENT 'The name of the national maritime security authority or port authority that issued the MARSEC level change declaration.',
    `issuing_authority_type` STRING COMMENT 'The type or classification of the authority that issued the MARSEC level change.. Valid values are `national_maritime_security_authority|port_authority|coast_guard|navy|ministry_of_transport|other`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this MARSEC level change record was last modified.',
    `marsec_level_change_status` STRING COMMENT 'Current lifecycle status of the MARSEC level change record.. Valid values are `declared|active|superseded|cancelled|expired`',
    `new_marsec_level` STRING COMMENT 'The MARSEC level declared by this change. 1=Normal (minimum security measures), 2=Heightened (additional protective measures), 3=Exceptional (further specific protective measures).',
    `notification_method` STRING COMMENT 'The primary method or channel used to notify stakeholders of the MARSEC level change. [ENUM-REF-CANDIDATE: port_community_system|email|vts_broadcast|edi_message|secure_portal|phone|fax — 7 candidates stripped; promote to reference product]',
    `notification_sent_timestamp` TIMESTAMP COMMENT 'The date and time when notifications were sent to all required recipients (shipping lines, vessel masters, agents, Port Facility Security Officer).',
    `operational_impact_description` STRING COMMENT 'Description of the expected operational impacts on port operations, vessel turnaround times, and cargo handling due to this MARSEC level change.',
    `patrol_frequency_change` STRING COMMENT 'Description of changes to security patrol frequency and coverage required by this MARSEC level change.',
    `pfso_acknowledged_flag` BOOLEAN COMMENT 'Indicates whether the Port Facility Security Officer has acknowledged receipt and understanding of the MARSEC level change.',
    `pfso_acknowledged_timestamp` TIMESTAMP COMMENT 'The date and time when the PFSO acknowledged the MARSEC level change.',
    `pfso_name` STRING COMMENT 'The full name of the Port Facility Security Officer who acknowledged the MARSEC level change.',
    `planned_end_timestamp` TIMESTAMP COMMENT 'The planned date and time when the MARSEC level is expected to revert or change again. Null for indefinite changes.',
    `previous_marsec_level` STRING COMMENT 'The MARSEC level in effect before this change. 1=Normal (minimum security measures), 2=Heightened (additional protective measures), 3=Exceptional (further specific protective measures).',
    `surveillance_enhancement` STRING COMMENT 'Description of enhancements to CCTV surveillance and monitoring required by this MARSEC level change.',
    `threat_assessment_reference` STRING COMMENT 'Reference number or identifier of the threat assessment report that triggered the MARSEC level change.',
    `vessel_screening_requirement` STRING COMMENT 'The level of vessel security screening required at this MARSEC level.. Valid values are `standard|enhanced|pre_arrival_security_check|underwater_hull_inspection|mandatory_security_declaration`',
    CONSTRAINT pk_marsec_level_change PRIMARY KEY(`marsec_level_change_id`)
) COMMENT 'Transactional record of Maritime Security (MARSEC) level declarations and changes at the port facility. Captures change identifier, previous MARSEC level, new MARSEC level (1=normal, 2=heightened, 3=exceptional), effective date and time, issuing authority (national maritime security authority or port authority), reason for change, notification recipients (shipping lines, vessel masters, agents, PFSO), and acknowledgement records. Drives access control, patrol frequency, and operational security posture changes.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` (
    `dos_record_id` BIGINT COMMENT 'Unique identifier for the Declaration of Security record. Primary key.',
    `berth_id` BIGINT COMMENT 'Reference to the berth where the vessel is moored during the interface covered by this Declaration of Security.',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Declaration of Security (DoS) records are executed under the authority of the Port Facility Security Plan (PFSP). The DoS references the facilitys security measures as defined in the PFSP. Adding exp',
    `marsec_level_change_id` BIGINT COMMENT 'Foreign key linking to security.marsec_level_change. Business justification: DoS records capture the MARSEC level at time of execution (port_marsec_level, vessel_marsec_level fields). Linking to the specific marsec_level_change event that was in effect enables audit trail of w',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Declaration of Security is executed between port facility and shipping line/vessel operator per ISPS Code. DoS records the agreed security measures and responsibilities. Links to shipping line master ',
    `superseded_dos_record_id` BIGINT COMMENT 'Self-referencing FK on dos_record (superseded_dos_record_id)',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel involved in this Declaration of Security agreement.',
    `activities_covered` STRING COMMENT 'Comma-separated list of activities covered by this Declaration of Security, such as cargo operations, passenger embarkation/disembarkation, crew change, bunkering, stores delivery, waste removal, ship-to-ship transfer.',
    `bunkering_flag` BOOLEAN COMMENT 'Indicates whether bunkering (fuel supply) operations are covered under this Declaration of Security.',
    `cargo_operations_flag` BOOLEAN COMMENT 'Indicates whether cargo loading/discharge operations are covered under this Declaration of Security.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this Declaration of Security record was first created in the system.',
    `crew_change_flag` BOOLEAN COMMENT 'Indicates whether crew change operations are covered under this Declaration of Security.',
    `dos_number` STRING COMMENT 'Unique business identifier for the Declaration of Security document. Externally-known reference number used for regulatory filing and audit trail.. Valid values are `^DOS-[A-Z0-9]{8,12}$`',
    `dos_status` STRING COMMENT 'Current lifecycle status of the Declaration of Security record: draft (being prepared), active (in force), completed (interface concluded), cancelled (voided before completion), expired (validity period ended).. Valid values are `draft|active|completed|cancelled|expired`',
    `dos_type` STRING COMMENT 'Type of interface covered by this Declaration of Security: ship-to-port (vessel interfacing with port facility) or ship-to-ship (vessel-to-vessel transfer operations).. Valid values are `ship_to_port|ship_to_ship`',
    `filing_reference` STRING COMMENT 'Document management system reference or filing location where the signed Declaration of Security document is stored for regulatory compliance and audit purposes.',
    `imo_number` STRING COMMENT 'Seven-digit IMO ship identification number assigned to the vessel, prefixed with IMO. Permanent identifier for the vessel throughout its lifetime.. Valid values are `^IMO[0-9]{7}$`',
    `interface_location` STRING COMMENT 'Specific location within the port facility where the ship-to-port or ship-to-ship interface takes place (e.g., berth number, anchorage area, terminal name).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this Declaration of Security record was last updated in the system.',
    `marsec_level` STRING COMMENT 'Maritime Security level applicable at the time of the interface: 1 (normal), 2 (heightened), or 3 (exceptional). Determines the security measures to be implemented.',
    `notification_timestamp` TIMESTAMP COMMENT 'Date and time when the regulatory authority was notified of this Declaration of Security.',
    `passenger_operations_flag` BOOLEAN COMMENT 'Indicates whether passenger embarkation or disembarkation operations are covered under this Declaration of Security.',
    `pfso_name` STRING COMMENT 'Full name of the Port Facility Security Officer who signed this Declaration of Security on behalf of the port facility.',
    `pfso_signature_timestamp` TIMESTAMP COMMENT 'Date and time when the Port Facility Security Officer signed the Declaration of Security.',
    `port_marsec_level` STRING COMMENT 'MARSEC level declared by the port facility at the time of interface: 1 (normal), 2 (heightened), or 3 (exceptional).',
    `port_security_measures` STRING COMMENT 'Detailed description of the security measures the port facility agrees to implement during the interface, including access control, surveillance, patrols, screening procedures, and communication protocols.',
    `regulatory_authority_notified_flag` BOOLEAN COMMENT 'Indicates whether the relevant national maritime security authority or Port State Control was notified of this Declaration of Security as required by local regulations.',
    `remarks` STRING COMMENT 'Additional notes, comments, or special conditions related to this Declaration of Security, including any deviations from standard procedures or special security arrangements.',
    `security_incident_flag` BOOLEAN COMMENT 'Indicates whether any security incident occurred during the validity period of this Declaration of Security.',
    `ship_to_ship_transfer_flag` BOOLEAN COMMENT 'Indicates whether ship-to-ship transfer operations are covered under this Declaration of Security.',
    `stores_delivery_flag` BOOLEAN COMMENT 'Indicates whether ship stores delivery operations are covered under this Declaration of Security.',
    `threat_assessment_reference` STRING COMMENT 'Reference number or identifier of the threat assessment conducted prior to the interface, which informed the security measures agreed in this Declaration of Security.',
    `valid_from_timestamp` TIMESTAMP COMMENT 'Date and time from which this Declaration of Security becomes effective and the agreed security measures are in force.',
    `valid_until_timestamp` TIMESTAMP COMMENT 'Date and time until which this Declaration of Security remains valid. Typically aligned with the end of the interface or port call.',
    `vessel_marsec_level` STRING COMMENT 'MARSEC level declared by the vessel at the time of interface: 1 (normal), 2 (heightened), or 3 (exceptional).',
    `vessel_master_name` STRING COMMENT 'Full name of the vessel master (captain) who signed this Declaration of Security on behalf of the vessel.',
    `vessel_security_measures` STRING COMMENT 'Detailed description of the security measures the vessel agrees to implement during the interface, including access control, surveillance, restricted areas, and communication protocols.',
    `vessel_signature_timestamp` TIMESTAMP COMMENT 'Date and time when the vessel master or Ship Security Officer signed the Declaration of Security.',
    `vessel_sso_name` STRING COMMENT 'Full name of the Ship Security Officer who co-signed or endorsed this Declaration of Security on behalf of the vessel.',
    CONSTRAINT pk_dos_record PRIMARY KEY(`dos_record_id`)
) COMMENT 'Declaration of Security (DoS) record capturing the formal agreement between a port facility and a vessel on the respective security measures each will implement during an interface. Captures DoS number, vessel name and IMO number, port call reference, DoS type (ship-to-port, ship-to-ship), MARSEC level applicable, activities covered (cargo operations, passenger embarkation, crew change, bunkering), agreed security measures, signing PFSO and vessel master/SSO, validity period, and filing reference. Mandatory ISPS Code document.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`drill` (
    `drill_id` BIGINT COMMENT 'Unique identifier for the security drill record. Primary key for the security drill entity.',
    `escalated_drill_id` BIGINT COMMENT 'Self-referencing FK on drill (escalated_drill_id)',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Security drills are conducted to test and validate the Port Facility Security Plan (PFSP) as required by ISPS Code. Each drill should reference which plan version is being tested. This is a clear 1:N ',
    `employee_id` BIGINT COMMENT 'Identifier of the personnel assigned to coordinate and facilitate the security drill execution.',
    `zone_id` BIGINT COMMENT 'add column zone_id (BIGINT) with FK to security.zone.zone_id - security drills are conducted within specific security zones per ISPS requirements',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the security drill concluded, marking the completion of the exercise.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the security drill commenced. Represents the principal business event timestamp for the drill execution.',
    `audit_trail_notes` STRING COMMENT 'Additional audit trail notes and administrative comments related to the drill record, including any amendments or follow-up actions.',
    `compliance_status` STRING COMMENT 'Assessment of whether the drill meets ISPS Code requirements for frequency, scope, and documentation. Used for regulatory compliance reporting.. Valid values are `compliant|non_compliant|partially_compliant|pending_review`',
    `corrective_actions_raised` STRING COMMENT 'List of corrective actions and improvement measures raised as a result of the drill findings, to be tracked through completion.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this security drill record was first created in the system. Used for audit and data lineage purposes.',
    `deficiencies_identified` STRING COMMENT 'Detailed description of any deficiencies, gaps, or weaknesses identified during the security drill that require corrective action.',
    `drill_number` STRING COMMENT 'Business identifier for the security drill, typically a sequential or formatted reference number used for external communication and audit trails.',
    `drill_status` STRING COMMENT 'Current status of the security drill in its lifecycle from planning through completion and sign-off.. Valid values are `scheduled|in_progress|completed|cancelled|deferred`',
    `drill_type` STRING COMMENT 'Classification of the security drill type as required by ISPS Code. Defines the nature and scope of the drill conducted.. Valid values are `communication_drill|evacuation_drill|access_control_drill|bomb_threat_drill|full_scale_exercise|table_top_exercise`',
    `duration_minutes` STRING COMMENT 'Total duration of the security drill in minutes, calculated from start to end timestamp. Used for performance analysis and compliance reporting.',
    `equipment_tested` STRING COMMENT 'List of security equipment and systems tested during the drill (e.g., CCTV, access control systems, communication devices, alarms, barriers).',
    `external_agencies_involved` STRING COMMENT 'List of external agencies, authorities, or organizations that participated in or observed the security drill (e.g., coast guard, police, customs, port state control).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this security drill record was last updated or modified. Used for audit and data lineage purposes.',
    `lessons_learned` STRING COMMENT 'Key lessons learned and best practices identified during the drill that can be applied to improve future security preparedness and response.',
    `location` STRING COMMENT 'Specific location or area within the port facility where the security drill was conducted (e.g., terminal gate, berth, cargo yard, control room).',
    `next_drill_due_date` DATE COMMENT 'Calculated or scheduled date for the next required security drill of this type, based on ISPS Code frequency requirements (minimum intervals).',
    `objectives` STRING COMMENT 'Stated objectives and goals for the security drill, defining what capabilities, procedures, or responses are being tested and validated.',
    `outcomes_summary` STRING COMMENT 'Summary of the outcomes and results of the security drill, including performance observations, response effectiveness, and overall assessment.',
    `participant_count` STRING COMMENT 'Total number of personnel who participated in the security drill, used for compliance reporting and resource planning.',
    `participating_departments` STRING COMMENT 'List of port facility departments and units that participated in the security drill, comma-separated or structured format.',
    `pfso_sign_off_comments` STRING COMMENT 'Comments and observations provided by the PFSO during sign-off, including approval notes or additional recommendations.',
    `pfso_sign_off_timestamp` TIMESTAMP COMMENT 'Date and time when the PFSO formally signed off on the drill report and outcomes, confirming review and acceptance.',
    `procedures_tested` STRING COMMENT 'List of security procedures and protocols tested during the drill, referencing sections of the Port Facility Security Plan (PFSP).',
    `report_document_reference` STRING COMMENT 'Reference identifier or file path to the formal drill report document stored in the document management system.',
    `scenario_description` STRING COMMENT 'Detailed description of the security scenario simulated during the drill, including threat type, location, and simulated conditions. Confidential to prevent security vulnerability disclosure.',
    `scheduled_date` DATE COMMENT 'Planned date for conducting the security drill as per the annual drill schedule required by ISPS Code.',
    `security_level_during_drill` STRING COMMENT 'ISPS Code security level in effect at the port facility during the drill (Level 1: normal, Level 2: heightened, Level 3: exceptional). Impacts drill scope and procedures.. Valid values are `level_1|level_2|level_3`',
    CONSTRAINT pk_drill PRIMARY KEY(`drill_id`)
) COMMENT 'Transactional record of security drills and exercises conducted at the port facility as required by ISPS Code. Captures drill identifier, drill type (communication drill, evacuation drill, access control drill, bomb threat drill, full-scale exercise, table-top exercise), scheduled and actual date, participating personnel and departments, scenario description, objectives, outcomes, deficiencies identified, corrective actions raised, and sign-off by PFSO. Supports ISPS Code drill frequency compliance and security preparedness.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` (
    `security_audit_id` BIGINT COMMENT 'Unique identifier for the security audit record. Primary key for the security audit entity.',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Security audits explicitly audit the Port Facility Security Plan (PFSP) for ISPS Code compliance. The audit currently has pfsp_version_audited as STRING. This should be normalized to facility_security',
    `follow_up_security_audit_id` BIGINT COMMENT 'Self-referencing FK on security_audit (follow_up_security_audit_id)',
    `zone_id` BIGINT COMMENT 'add column zone_id (BIGINT) with FK to security.zone.zone_id - security audits are conducted for specific security zones under ISPS requirements',
    `areas_audited` STRING COMMENT 'Comma-separated list of specific security functional areas covered in the audit, such as access control, CCTV surveillance, perimeter security, cargo security, vessel interface security, cybersecurity, personnel security, security training, incident response, and security equipment maintenance.',
    `audit_date` DATE COMMENT 'The principal date when the security audit was conducted or commenced. For multi-day audits, this represents the start date of the audit activities.',
    `audit_number` STRING COMMENT 'Externally-known unique business identifier for the security audit, typically formatted as SA-YYYY-NNNNNN for tracking and reference purposes.. Valid values are `^SA-[0-9]{4}-[0-9]{6}$`',
    `audit_scope` STRING COMMENT 'Detailed description of the audit scope including specific security areas, facilities, systems, and processes covered by the audit. May include physical security, access control, CCTV surveillance, cybersecurity, personnel security, cargo security, and vessel interface security.',
    `audit_status` STRING COMMENT 'Current lifecycle status of the security audit. Scheduled indicates the audit is planned but not yet started, in progress indicates active audit activities, completed indicates audit findings have been documented, closed indicates all corrective actions have been verified and the audit is finalized, and cancelled indicates the audit was terminated before completion.. Valid values are `scheduled|in_progress|completed|closed|cancelled`',
    `audit_type` STRING COMMENT 'Classification of the security audit based on the auditing authority or scope. Internal audits are conducted by port security personnel, external audits by third-party auditors, RSO (Recognized Security Organization) audits by designated security organizations, flag state audits by vessel flag authorities, IMO (International Maritime Organization) audits for international compliance, and PSC (Port State Control) audits by port state authorities.. Valid values are `internal|external|rso|flag_state|imo|port_state_control`',
    `auditing_organization` STRING COMMENT 'Name of the organization or authority conducting the security audit. For internal audits, this is the port authority; for external audits, this is the third-party auditing firm or regulatory body.',
    `certification_impact` STRING COMMENT 'Impact of audit findings on port facility ISPS Code certification status. None indicates no impact on certification, warning indicates formal notice issued, suspension indicates temporary suspension of certification pending corrective action, and revocation indicates permanent withdrawal of certification.. Valid values are `none|warning|suspension|revocation`',
    `closure_status` STRING COMMENT 'Status of audit closure process. Open indicates corrective actions are in progress, pending verification indicates actions are complete but awaiting auditor verification, verified indicates auditor has confirmed corrective actions are effective, and closed indicates audit is fully closed with all actions verified.. Valid values are `open|pending_verification|verified|closed`',
    `closure_verification_date` DATE COMMENT 'Date when the auditing authority formally verified that all corrective actions have been effectively implemented and the audit can be closed.',
    `conformances_count` STRING COMMENT 'Total number of audit findings where port facility security operations were found to be in full conformance with ISPS Code requirements, national maritime security regulations, and internal security standards.',
    `corrective_action_plan_approved_date` DATE COMMENT 'Date when the corrective action plan was formally approved by the auditing authority, authorizing implementation of corrective measures.',
    `corrective_action_plan_due_date` DATE COMMENT 'Target date by which the corrective action plan must be submitted to address all identified non-conformances. Typically set by the auditing authority based on severity of findings.',
    `corrective_action_plan_required` BOOLEAN COMMENT 'Boolean flag indicating whether a formal corrective action plan is required to address audit non-conformances. True when non-conformances were identified, false when audit resulted in full conformance.',
    `corrective_action_plan_submitted_date` DATE COMMENT 'Actual date when the corrective action plan was formally submitted to the auditing authority for review and approval.',
    `corrective_actions_completion_date` DATE COMMENT 'Date when all corrective actions identified in the corrective action plan were completed and verified. This date marks the closure of all non-conformances.',
    `cost` DECIMAL(18,2) COMMENT 'Total cost incurred for conducting the security audit, including auditor fees, travel expenses, and administrative costs. Applicable primarily for external and third-party audits.',
    `cost_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the audit cost amount, such as USD, EUR, or GBP.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this security audit record was first created in the system. Part of audit trail for data governance and compliance tracking.',
    `end_timestamp` TIMESTAMP COMMENT 'Precise date and time when the security audit activities concluded, including closing meeting and final report handover.',
    `facilities_audited` STRING COMMENT 'Comma-separated list of specific port facilities, terminals, berths, or zones included in the audit scope. May include container terminals, bulk cargo terminals, passenger terminals, restricted areas, and security control rooms.',
    `findings_summary` STRING COMMENT 'Executive summary of all audit findings including conformances, non-conformances, and observations. Provides high-level overview of security posture, key risks identified, and priority areas for corrective action.',
    `follow_up_audit_date` DATE COMMENT 'Scheduled date for the follow-up audit to verify corrective action effectiveness. Typically scheduled 3-6 months after corrective actions completion.',
    `follow_up_audit_required` BOOLEAN COMMENT 'Boolean flag indicating whether a follow-up audit is required to verify implementation and effectiveness of corrective actions. True when major non-conformances were identified or when regulatory authority mandates verification audit.',
    `isps_code_compliance_level` STRING COMMENT 'Overall ISPS Code compliance level determined by the audit. Level 1 indicates normal security measures, Level 2 indicates heightened security measures, Level 3 indicates exceptional security measures, and non-compliant indicates failure to meet minimum ISPS Code requirements.. Valid values are `level_1|level_2|level_3|non_compliant`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this security audit record was last updated or modified. Tracks data lineage and change history for audit and compliance purposes.',
    `lead_auditor_certification` STRING COMMENT 'Professional certification or qualification held by the lead auditor, such as Certified Lead Auditor (CLA), ISPS Code auditor certification, or equivalent security audit credentials.',
    `lead_auditor_name` STRING COMMENT 'Full name of the lead auditor responsible for conducting and overseeing the security audit. The lead auditor is accountable for audit planning, execution, and reporting.',
    `major_non_conformances_count` STRING COMMENT 'Number of critical non-conformances that pose significant security risks or represent systemic failures in security management. Major non-conformances may result in suspension of ISPS Code certification or port facility security plan approval.',
    `methodology` STRING COMMENT 'Description of the audit methodology employed, including document review, physical inspection, personnel interviews, security system testing, and compliance verification techniques used during the audit.',
    `minor_non_conformances_count` STRING COMMENT 'Number of non-critical non-conformances that represent isolated lapses or documentation deficiencies but do not pose immediate security threats. Minor non-conformances require corrective action but do not jeopardize certification.',
    `next_scheduled_audit_date` DATE COMMENT 'Planned date for the next scheduled security audit. ISPS Code requires annual internal audits and periodic external audits to maintain port facility security certification.',
    `non_conformances_count` STRING COMMENT 'Total number of audit findings where port facility security operations failed to meet ISPS Code requirements, national maritime security regulations, or internal security standards. Non-conformances require mandatory corrective action.',
    `observations_count` STRING COMMENT 'Total number of audit observations representing opportunities for improvement or areas of concern that do not constitute non-conformances but warrant management attention.',
    `regulatory_framework` STRING COMMENT 'Comma-separated list of regulatory frameworks, standards, and codes against which the audit was conducted, such as ISPS Code, national maritime security regulations, ISO 28000, and internal port security standards.',
    `remarks` STRING COMMENT 'Additional remarks, notes, or contextual information about the security audit, including special circumstances, audit challenges, or commendations for exemplary security practices.',
    `report_reference` STRING COMMENT 'Document reference number or file path to the formal security audit report containing detailed findings, evidence, and recommendations. Audit reports are confidential security documents.',
    `start_timestamp` TIMESTAMP COMMENT 'Precise date and time when the security audit activities commenced, including opening meeting and initial site inspection.',
    `team_members` STRING COMMENT 'Comma-separated list of audit team member names who participated in the security audit alongside the lead auditor. May include technical experts, subject matter specialists, and trainee auditors.',
    CONSTRAINT pk_security_audit PRIMARY KEY(`security_audit_id`)
) COMMENT 'Formal security audit record for scheduled and ad-hoc audits of port facility security operations against ISPS Code, national maritime security regulations, and internal security standards. Captures audit identifier, audit type (internal, external, RSO, flag state, IMO), audit scope, lead auditor, audit date, findings (conformances, non-conformances, observations), corrective action plan, closure status, and next scheduled audit date. Distinct from the compliance domain audit which covers broader regulatory compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` (
    `stowaway_case_id` BIGINT COMMENT 'Unique identifier for the stowaway case record. Primary key for tracking the full lifecycle of stowaway detection and handling incidents at the port facility.',
    `employee_id` BIGINT COMMENT 'Reference to the security personnel record of the officer who detected the stowaway incident.',
    `parent_stowaway_case_id` BIGINT COMMENT 'Self-referencing FK on stowaway_case (linked_stowaway_case_id)',
    `personnel_id` BIGINT COMMENT 'Reference to the Port Facility Security Officer personnel record responsible for this case.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Stowaway cases are a specialized type of security incident. Each stowaway case should be linked to the parent security incident record that was created when the stowaway was detected. The case current',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line operating the vessel involved in the stowaway case.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel involved in the stowaway incident, if applicable.',
    `case_closure_reason` STRING COMMENT 'Explanation or reason for closing the stowaway case, including final disposition of the individuals involved.',
    `case_closure_timestamp` TIMESTAMP COMMENT 'Date and time when the stowaway case was formally closed after all actions completed and authorities satisfied.',
    `case_number` STRING COMMENT 'Business identifier for the stowaway case, formatted as STC-YYYY-NNNNNN for external reference and reporting to authorities.. Valid values are `^STC-[0-9]{4}-[0-9]{6}$`',
    `case_status` STRING COMMENT 'Current lifecycle status of the stowaway case from initial detection through final resolution and case closure. [ENUM-REF-CANDIDATE: detected|under_investigation|authorities_notified|detained|repatriation_arranged|repatriated|case_closed|escalated — 8 candidates stripped; promote to reference product]',
    `corrective_action_description` STRING COMMENT 'Description of corrective actions taken or planned to prevent future stowaway incidents, including security enhancements.',
    `corrective_action_required_flag` BOOLEAN COMMENT 'Indicates whether corrective actions to port facility security measures are required as a result of this stowaway incident.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this stowaway case record was first created in the system.',
    `detecting_officer_name` STRING COMMENT 'Name of the security officer or personnel who first detected the stowaway(s).',
    `detection_location_code` STRING COMMENT 'Specific location identifier within the port facility where detection occurred (berth number, gate ID, terminal zone, etc.).',
    `detection_location_type` STRING COMMENT 'Type of port facility location where the stowaway(s) were discovered. [ENUM-REF-CANDIDATE: vessel|terminal|gate|container_yard|warehouse|berth|anchorage — 7 candidates stripped; promote to reference product]',
    `detection_method` STRING COMMENT 'Method or mechanism by which the stowaway(s) were detected at the port facility. [ENUM-REF-CANDIDATE: cctv_surveillance|security_patrol|container_inspection|vessel_search|gate_screening|informant_tip|crew_report|other — 8 candidates stripped; promote to reference product]',
    `detection_timestamp` TIMESTAMP COMMENT 'Date and time when the stowaway(s) were first detected at the port facility, vessel, terminal, or gate location.',
    `detention_facility_name` STRING COMMENT 'Name of the facility where the stowaway(s) are being detained pending repatriation or other resolution.',
    `detention_start_timestamp` TIMESTAMP COMMENT 'Date and time when detention of the stowaway(s) commenced.',
    `detention_status` STRING COMMENT 'Current detention status and location of the stowaway(s) following detection.. Valid values are `not_detained|detained_onboard|detained_port_facility|detained_immigration_center|released`',
    `immigration_authority_notification_timestamp` TIMESTAMP COMMENT 'Date and time when immigration authorities were notified of the stowaway case.',
    `immigration_authority_notified_flag` BOOLEAN COMMENT 'Indicates whether national immigration authorities have been formally notified of the stowaway incident.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this stowaway case record was most recently modified.',
    `notes` STRING COMMENT 'Additional notes, observations, or details about the stowaway case for internal security and operational reference.',
    `number_of_stowaways` STRING COMMENT 'Total count of individuals detected as stowaways in this case incident.',
    `pfso_name` STRING COMMENT 'Name of the Port Facility Security Officer who managed or oversaw the stowaway case response.',
    `port_authority_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the port authority was notified of the stowaway case.',
    `port_authority_notified_flag` BOOLEAN COMMENT 'Indicates whether the port authority has been formally notified of the stowaway incident.',
    `repatriation_cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred for repatriation arrangements including travel, documentation, and administrative expenses.',
    `repatriation_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for repatriation cost amount.. Valid values are `^[A-Z]{3}$`',
    `repatriation_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the destination country for stowaway repatriation.. Valid values are `^[A-Z]{3}$`',
    `repatriation_date` DATE COMMENT 'Scheduled or actual date of stowaway repatriation to their country of origin.',
    `repatriation_status` STRING COMMENT 'Current status of repatriation arrangements for the stowaway(s) to their country of origin or nationality.. Valid values are `not_initiated|arrangements_in_progress|travel_documents_obtained|repatriation_scheduled|repatriated|repatriation_refused`',
    `responsible_party` STRING COMMENT 'Entity determined to be responsible for the stowaway case and associated costs under applicable maritime and immigration law.. Valid values are `shipping_line|vessel_owner|port_authority|immigration_authority|unknown`',
    `security_breach_flag` BOOLEAN COMMENT 'Indicates whether the stowaway incident represents a security breach requiring additional investigation or corrective action under ISPS Code.',
    `shipping_line_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the shipping line was notified of the stowaway case.',
    `shipping_line_notified_flag` BOOLEAN COMMENT 'Indicates whether the shipping line operating the vessel has been notified of the stowaway incident.',
    `stowaway_identity_documents` STRING COMMENT 'Description of identity documents presented or found on stowaways (passport numbers, national ID cards, etc.), if available. Highly sensitive personal information.',
    `stowaway_nationalities` STRING COMMENT 'Comma-separated list of nationalities of the stowaways involved, using ISO 3166-1 alpha-3 country codes where known.',
    `stowaway_personal_details` STRING COMMENT 'Names, ages, gender, and other identifying personal information of stowaways, captured for immigration and repatriation purposes.',
    `vessel_imo_number` STRING COMMENT 'Seven-digit IMO number of the vessel involved in the stowaway case, if detection occurred on or related to a specific vessel.. Valid values are `^IMO[0-9]{7}$`',
    `voyage_number` STRING COMMENT 'Voyage identifier for the vessel call during which the stowaway incident occurred.',
    CONSTRAINT pk_stowaway_case PRIMARY KEY(`stowaway_case_id`)
) COMMENT 'Transactional record managing the full lifecycle of stowaway detection and handling cases at the port. Captures case identifier, detection location (vessel, terminal, gate), detection date and time, number of stowaways, individual stowaway details (nationality, identity documents if available), vessel involved, shipping line notified, port authority notification, immigration authority notification, detention arrangements, repatriation status, and case closure. Supports IMO FAL Convention and national immigration compliance obligations.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` (
    `watchlist_entry_id` BIGINT COMMENT 'Unique identifier for the watchlist entry record. Primary key for the watchlist entry entity.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Watchlist entries track subject nationality and geographic scope for security screening. Links to country master for sanctions list checking, flag state risk assessment, and Paris/Tokyo MOU targeting.',
    `superseded_watchlist_entry_id` BIGINT COMMENT 'Self-referencing FK on watchlist_entry (superseded_watchlist_entry_id)',
    `access_control_integration_flag` BOOLEAN COMMENT 'Indicates whether this watchlist entry is integrated with automated access control systems (gates, turnstiles, biometric readers) for real-time screening. True if integrated, False if manual screening only.',
    `alert_action_required` STRING COMMENT 'Mandatory action to be taken when the subject is detected: deny access to port facility, detain subject and notify law enforcement, notify relevant authority (customs/immigration/security), apply enhanced screening procedures, monitor movements, or log encounter only.. Valid values are `deny_access|detain|notify_authority|enhanced_screening|monitor|log_only`',
    `alert_category` STRING COMMENT 'Classification of the watchlist alert: security threat, terrorism, international sanctions, smuggling, piracy, stolen property (vehicle/container), banned person (previous incident), immigration violation, or customs violation. [ENUM-REF-CANDIDATE: security_threat|terrorism|sanctions|smuggling|piracy|stolen_property|banned_person|immigration_violation|customs_violation — 9 candidates stripped; promote to reference product]',
    `applicable_facilities` STRING COMMENT 'List of port facility codes or terminal identifiers where this watchlist entry applies. Null if scope is global or national. Semi-colon separated list for multiple facilities.',
    `biometric_data_available_flag` BOOLEAN COMMENT 'Indicates whether biometric data (fingerprints, facial recognition, iris scan) is available for this watchlist subject to support automated identity verification. True if biometric data is attached, False otherwise.',
    `confidentiality_level` STRING COMMENT 'Security classification level of the watchlist entry information: public (shareable), law enforcement sensitive (restricted distribution), classified (government security clearance required), or top secret (highest classification).. Valid values are `public|law_enforcement_sensitive|classified|top_secret`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the watchlist entry record was first created in the system. Audit trail for record creation.',
    `detection_count` STRING COMMENT 'Total number of times the watchlist subject has been detected or encountered at port facilities since the entry became effective. Incremented by screening systems.',
    `distribution_restriction` STRING COMMENT 'Specific restrictions on who may access or be informed about this watchlist entry (e.g., PFSO and designated security personnel only, law enforcement only, need-to-know basis).',
    `effective_date` DATE COMMENT 'Date from which the watchlist entry becomes active and screening systems should enforce the alert action.',
    `entry_number` STRING COMMENT 'Business-facing unique reference number for the watchlist entry, used for external communication and audit trails.',
    `expiry_date` DATE COMMENT 'Date on which the watchlist entry expires and is no longer enforced. Null for indefinite entries. Requires periodic review per ISPS Code requirements.',
    `geographic_scope` STRING COMMENT 'Geographic applicability of the watchlist entry: global (all ports worldwide), regional (specific maritime region), national (all ports in country), or port-specific (this facility only).. Valid values are `global|regional|national|port_specific`',
    `incident_reference` STRING COMMENT 'Reference number of the security incident, violation, or intelligence report that triggered the watchlist entry. Links to incident management or case management systems.',
    `last_detection_timestamp` TIMESTAMP COMMENT 'Date and time when the watchlist subject was most recently detected or encountered at any port facility. Null if never detected since listing. Updated by access control or screening systems.',
    `last_updated_by` STRING COMMENT 'User identifier or name of the Port Facility Security Officer (PFSO) or security personnel who last modified the watchlist entry record.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the watchlist entry record was most recently modified. Audit trail for record changes.',
    `managing_authority` STRING COMMENT 'Name of the port authority, government agency, or security organization responsible for maintaining and reviewing this watchlist entry.',
    `notification_authority` STRING COMMENT 'Name of the authority or agency that must be notified when the subject is detected (e.g., national police, customs, immigration, coast guard, port state control, PFSO).',
    `notification_contact` STRING COMMENT 'Contact phone number, email, or radio channel for notifying the designated authority when the watchlist subject is detected.',
    `pfso_name` STRING COMMENT 'Name of the Port Facility Security Officer who approved or is responsible for this watchlist entry within the port facility.',
    `photo_reference` STRING COMMENT 'File path or document management system reference to photograph(s) of the watchlist subject for visual identification by security personnel.',
    `reason_description` STRING COMMENT 'Detailed explanation of why the subject was added to the watchlist, including incident details, intelligence source, or legal basis for the listing.',
    `remarks` STRING COMMENT 'Additional notes, operational guidance, or special instructions for security personnel regarding handling of this watchlist subject.',
    `removal_date` DATE COMMENT 'Date on which the watchlist entry was removed or deactivated. Null for active entries. Populated when status changes to removed.',
    `removal_reason` STRING COMMENT 'Explanation for why the watchlist entry was removed: threat resolved, incorrect identification, legal challenge, expiry without renewal, or administrative error.',
    `removed_by` STRING COMMENT 'Name or identifier of the Port Facility Security Officer (PFSO) or authorized security personnel who removed or deactivated the watchlist entry.',
    `review_due_date` DATE COMMENT 'Date by which the watchlist entry must be reviewed by the Port Facility Security Officer (PFSO) or managing authority to confirm continued validity and relevance.',
    `subject_additional_identifiers` STRING COMMENT 'Supplementary identifiers for the subject such as aliases, previous names, call signs, former vessel names, or alternative registration numbers. Stored as semi-colon separated list.',
    `subject_date_of_birth` DATE COMMENT 'Date of birth for person subjects. Null for non-person entities. Used for identity verification and age-based screening.',
    `subject_identifier_type` STRING COMMENT 'Type of primary identifier used for the subject: passport, national ID, seafarer identification document, IMO number (vessels), MMSI (Maritime Mobile Service Identity), vehicle registration, tax identification number, or container number. [ENUM-REF-CANDIDATE: passport|national_id|seafarer_id|imo_number|mmsi|vehicle_registration|tax_id|container_number — 8 candidates stripped; promote to reference product]',
    `subject_identifier_value` DECIMAL(18,2) COMMENT 'The actual identifier value corresponding to the subject identifier type. For vessels: IMO number or MMSI. For persons: passport or national ID number. For vehicles: registration plate number.',
    `subject_name` STRING COMMENT 'Full name or designation of the watchlisted subject. For persons: full legal name. For vessels: vessel name. For organisations: registered legal name. For vehicles: owner or operator name.',
    `subject_type` STRING COMMENT 'Type of entity being watchlisted: person (crew, passenger, visitor), vessel (ship, boat), vehicle (truck, car), organisation (company, agency), container, or cargo.. Valid values are `person|vessel|vehicle|organisation|container|cargo`',
    `supporting_document_reference` STRING COMMENT 'Reference to supporting documentation such as court orders, intelligence reports, sanction notices, or incident reports that justify the watchlist entry. Stored as document management system identifier or file path.',
    `threat_level` STRING COMMENT 'Assessed threat severity level of the watchlist subject: critical (immediate action required), high (deny access), medium (enhanced screening), low (monitor), or informational (awareness only).. Valid values are `critical|high|medium|low|informational`',
    `vessel_screening_integration_flag` BOOLEAN COMMENT 'Indicates whether this watchlist entry is integrated with Vessel Traffic Management System (VTMS) or Port Community System (PCS) for automated vessel pre-arrival screening. True if integrated, False if manual check required.',
    `watchlist_entry_status` STRING COMMENT 'Current lifecycle status of the watchlist entry: active (enforced), suspended (temporarily inactive), expired (past expiry date), removed (permanently deleted), or under review (pending PFSO decision).. Valid values are `active|suspended|expired|removed|under_review`',
    `watchlist_source` STRING COMMENT 'Origin or issuing authority of the watchlist entry: Interpol notices, national security agencies, international sanctions lists (OFAC, UN, EU), port authority internal list, customs, immigration, Port Facility Security Officer (PFSO) internal ban, or industry shared intelligence. [ENUM-REF-CANDIDATE: interpol|national_security|sanctions_list|port_authority|customs|immigration|pfso_internal|industry_shared — 8 candidates stripped; promote to reference product]',
    `watchlist_source_reference` STRING COMMENT 'External reference number or case identifier from the originating watchlist source authority. For Interpol: notice number. For sanctions: list entry ID. For internal: case reference.',
    `created_by` STRING COMMENT 'User identifier or name of the Port Facility Security Officer (PFSO) or security personnel who created the watchlist entry record.',
    CONSTRAINT pk_watchlist_entry PRIMARY KEY(`watchlist_entry_id`)
) COMMENT 'Master record of persons, vessels, vehicles, and organisations on port security watchlists including national security watchlists, Interpol notices, sanctions lists, and port-specific banned persons registers. Captures entry identifier, subject type (person, vessel, vehicle, organisation), subject identity details, watchlist source, alert category (security threat, sanctions, banned person, stolen vehicle), effective date, expiry date, alert action required (deny access, detain, notify authority), and managing authority. Feeds real-time access control and vessel screening decisions.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` (
    `screening_record_id` BIGINT COMMENT 'Unique identifier for the security screening record. Primary key for the screening transaction.',
    `access_point_id` BIGINT COMMENT 'Identifier of the port facility access point or gate where the screening took place. Links to access control infrastructure.',
    `personnel_id` BIGINT COMMENT 'Identifier of the security officer or personnel who conducted the screening. Links to workforce or security personnel master data.',
    `rescreened_screening_record_id` BIGINT COMMENT 'Self-referencing FK on screening_record (rescreened_screening_record_id)',
    `watchlist_entry_id` BIGINT COMMENT 'Foreign key linking to security.watchlist_entry. Business justification: Screening records that trigger watchlist matches should reference the specific watchlist entry that was matched. The screening record currently has watchlist_match_flag (BOOLEAN), watchlist_reference ',
    `zone_id` BIGINT COMMENT 'Identifier of the security zone the subject was attempting to enter or was screened within. Links to port facility security zone master data.',
    `alert_triggered_flag` BOOLEAN COMMENT 'Indicates whether the screening triggered an automated or manual security alert requiring further action.',
    `alert_type` STRING COMMENT 'Category of alert that was triggered during screening, if any. None indicates no alert was raised. [ENUM-REF-CANDIDATE: watchlist_match|document_anomaly|prohibited_item|radiation_detected|explosive_trace|behavioral_concern|system_alert|none — 8 candidates stripped; promote to reference product]',
    `biometric_match_score` DECIMAL(18,2) COMMENT 'Confidence score (0-100%) returned by the biometric verification system indicating the match quality. Higher scores indicate stronger matches.',
    `biometric_verification_type` STRING COMMENT 'Type of biometric verification performed during screening, if any. None indicates no biometric check was conducted.. Valid values are `fingerprint|facial_recognition|iris_scan|palm_vein|none`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this screening record was first created in the system. Audit trail for record lifecycle.',
    `customs_notification_flag` BOOLEAN COMMENT 'Indicates whether customs authorities were notified as a result of this screening (e.g., for prohibited goods, watchlist match, or trade compliance issue).',
    `customs_reference_number` STRING COMMENT 'Reference number provided by customs authorities for tracking the notification or referral, if applicable.',
    `document_expiry_date` DATE COMMENT 'Expiration date of the document checked, if applicable. Used to verify document validity at time of screening.',
    `document_issuing_authority` STRING COMMENT 'Name of the authority or country that issued the document being verified (e.g., government agency, port authority, classification society).',
    `document_number` STRING COMMENT 'Number or identifier of the document checked during screening (e.g., passport number, ID card number, certificate number).',
    `document_type_checked` STRING COMMENT 'Type of document verified during screening (e.g., passport, national ID, seafarer ID, driver license, port pass, vessel certificate, cargo manifest, dangerous goods declaration, BOL).',
    `follow_up_action` STRING COMMENT 'Action taken as a result of the screening outcome. Documents the operational response to the screening result. [ENUM-REF-CANDIDATE: none|secondary_screening|supervisor_review|law_enforcement_notified|customs_referral|access_denied|item_confiscated|incident_report_filed — 8 candidates stripped; promote to reference product]',
    `incident_report_reference` STRING COMMENT 'Reference number of any security incident report filed as a result of this screening, if applicable. Links to incident management system.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this screening record was last modified. Audit trail for record lifecycle and data quality monitoring.',
    `marsec_level` STRING COMMENT 'The MARSEC level in effect at the time of screening. MARSEC 1 = normal, MARSEC 2 = heightened, MARSEC 3 = exceptional. Determines screening intensity and protocols applied.. Valid values are `marsec_1|marsec_2|marsec_3`',
    `pfso_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the PFSO was notified of this screening event, if applicable.',
    `pfso_notified_flag` BOOLEAN COMMENT 'Indicates whether the Port Facility Security Officer was notified of this screening event due to its severity or outcome.',
    `prohibited_item_description` STRING COMMENT 'Detailed description of any prohibited or restricted items detected, including quantity, type, and classification (e.g., IMDG class for dangerous goods).',
    `prohibited_item_detected_flag` BOOLEAN COMMENT 'Indicates whether prohibited or restricted items (weapons, explosives, contraband, dangerous goods) were detected during screening.',
    `radiation_reading` DECIMAL(18,2) COMMENT 'Radiation level detected during screening, measured in microsieverts per hour (μSv/h). Applicable when radiation detection equipment is used.',
    `radiation_threshold_exceeded_flag` BOOLEAN COMMENT 'Indicates whether the detected radiation level exceeded the port facilitys safety threshold, triggering an alert.',
    `remarks` STRING COMMENT 'Additional notes, observations, or context recorded by the screening officer. May include behavioral observations, unusual circumstances, or clarifications. Confidential for security purposes.',
    `screening_duration_seconds` STRING COMMENT 'Total time taken to complete the screening process, measured in seconds. Used for throughput analysis and SLA monitoring.',
    `screening_location_description` STRING COMMENT 'Textual description of the specific location within the port facility where the screening took place (e.g., Main Gate 1, Container Yard Entrance, Vessel Gangway, CFS Building).',
    `screening_method` STRING COMMENT 'Primary method or technology used to conduct the screening. ANPR = Automatic Number Plate Recognition for vehicles. Biometric verification includes fingerprint, facial recognition, iris scan. [ENUM-REF-CANDIDATE: document_check|x_ray_scan|physical_search|anpr|biometric_verification|radiation_detection|explosive_trace_detection|canine_inspection|metal_detector|cctv_review — 10 candidates stripped; promote to reference product]',
    `screening_number` STRING COMMENT 'Human-readable unique reference number assigned to this screening event for tracking and audit purposes.. Valid values are `^SCR-[0-9]{10}$`',
    `screening_officer_name` STRING COMMENT 'Full name of the security officer who performed the screening for audit trail and accountability.',
    `screening_outcome` STRING COMMENT 'Result of the screening check. Cleared: passed all checks. Flagged: alert triggered, requires review. Denied: access refused. Referred: escalated to supervisor. Pending review: awaiting additional verification. Escalated: sent to law enforcement or customs.. Valid values are `cleared|flagged|denied|referred|pending_review|escalated`',
    `screening_status` STRING COMMENT 'Current lifecycle status of the screening record. Completed: screening finished and outcome recorded. In progress: screening underway. Cancelled: screening aborted. Voided: record invalidated due to error.. Valid values are `completed|in_progress|cancelled|voided`',
    `screening_timestamp` TIMESTAMP COMMENT 'Date and time when the screening was performed. Principal business event timestamp for this transaction.',
    `secondary_screening_method` STRING COMMENT 'Additional screening method applied if primary screening triggered an alert or as part of enhanced security protocol. Same value set as screening_method.',
    `subject_identifier` STRING COMMENT 'Unique identifier of the subject being screened. For persons: employee ID, visitor badge number, passport number. For vehicles: license plate (ANPR). For cargo: BOL number. For vessels: IMO number. For containers: container number.',
    `subject_name` STRING COMMENT 'Name or description of the subject being screened. For persons: full name. For vehicles: make/model. For cargo: cargo description. For vessels: vessel name. For containers: container owner/operator.',
    `subject_type` STRING COMMENT 'Category of entity being screened: person (crew, visitor, worker), vehicle (truck, car), cargo (shipment, package), vessel (ship, barge), container (TEU/FEU), or equipment (mobile harbor crane, forklift).. Valid values are `person|vehicle|cargo|vessel|container|equipment`',
    `supervisor_override_flag` BOOLEAN COMMENT 'Indicates whether a supervisor manually overrode the screening outcome or system recommendation.',
    `supervisor_override_reason` STRING COMMENT 'Explanation provided by the supervisor for overriding the screening outcome, if applicable. Confidential for security audit purposes.',
    `watchlist_match_flag` BOOLEAN COMMENT 'Indicates whether the subject matched an entry on a security watchlist (customs, border control, law enforcement, or internal port security watchlist).',
    CONSTRAINT pk_screening_record PRIMARY KEY(`screening_record_id`)
) COMMENT 'Transactional record of security screening checks performed on persons, vehicles, cargo, and vessels entering the port facility. Captures screening identifier, subject type and identity, screening method (document check, X-ray scan, physical search, ANPR, biometric verification, radiation detection), screening officer, date and time, screening outcome (cleared, flagged, denied), alert triggered, watchlist match reference, and follow-up action. Supports ISPS Code screening obligations and customs/border security integration.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` (
    `cyber_incident_id` BIGINT COMMENT 'Unique identifier for the cybersecurity incident record. Primary key for the cyber incident entity.',
    `cyber_risk_register_id` BIGINT COMMENT 'Foreign key linking to security.cyber_risk_register. Business justification: Cyber incidents often materialize identified risks from the cyber risk register. Linking incidents to the risk register entry enables risk tracking (likelihood validation, impact validation) and suppo',
    `employee_id` BIGINT COMMENT 'Identifier of the security personnel or incident response team member coordinating the incident response.',
    `parent_cyber_incident_id` BIGINT COMMENT 'Self-referencing FK on cyber_incident (related_cyber_incident_id)',
    `affected_system_primary` STRING COMMENT 'Primary IT or OT (Operational Technology) system affected by the incident. Includes TOS (NAVIS N4), VTS (Vessel Traffic Service), SCADA, PCS (Port Community System), gate automation, and crane control systems. [ENUM-REF-CANDIDATE: navis_n4_tos|vtms|scada|pcs|gate_automation|crane_control_system|sap_erp|maximo|network_infrastructure|other — 10 candidates stripped; promote to reference product]',
    `affected_systems_additional` STRING COMMENT 'Comma-separated list of additional IT/OT systems impacted by the incident beyond the primary affected system.',
    `attack_vector` STRING COMMENT 'Method or pathway through which the cyber attack was initiated or delivered into port systems. [ENUM-REF-CANDIDATE: email_phishing|malicious_attachment|compromised_credentials|network_vulnerability|usb_device|supply_chain|insider_threat|brute_force|zero_day_exploit|social_engineering|unknown — 11 candidates stripped; promote to reference product]',
    `business_impact_assessment` STRING COMMENT 'Detailed assessment of the business impact including operational disruption, financial loss, reputational damage, and safety implications for port operations.',
    `cert_notification_flag` BOOLEAN COMMENT 'Flag indicating whether the incident was reported to the national Computer Emergency Response Team (CERT) or cybersecurity authority.',
    `cert_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the incident was reported to the national CERT or cybersecurity authority.',
    `cert_reference_number` STRING COMMENT 'Reference number assigned by the national CERT or cybersecurity authority for tracking the reported incident.',
    `containment_actions` STRING COMMENT 'Description of immediate containment actions taken to limit the spread and impact of the incident, such as network isolation, system shutdown, or access revocation.',
    `containment_timestamp` TIMESTAMP COMMENT 'Date and time when the incident was successfully contained and prevented from further spread.',
    `corrective_actions_identified` STRING COMMENT 'Description of corrective actions and security improvements identified during post-incident review to prevent recurrence.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this incident record was first created in the system.',
    `data_breach_flag` BOOLEAN COMMENT 'Flag indicating whether the incident resulted in unauthorized access to, disclosure of, or loss of sensitive or personal data.',
    `data_breach_record_count` STRING COMMENT 'Estimated number of data records compromised or exposed in the incident, if applicable.',
    `detected_by` STRING COMMENT 'Source or method by which the incident was initially detected. [ENUM-REF-CANDIDATE: automated_monitoring|security_operations_center|end_user_report|external_notification|routine_audit|penetration_test|other — 7 candidates stripped; promote to reference product]',
    `detection_timestamp` TIMESTAMP COMMENT 'Date and time when the cybersecurity incident was first detected by monitoring systems or personnel. This is the principal business event timestamp for the incident.',
    `downtime_duration_minutes` STRING COMMENT 'Total duration in minutes that affected systems were unavailable or non-operational due to the incident.',
    `estimated_financial_impact` DECIMAL(18,2) COMMENT 'Estimated total financial impact of the incident including direct costs, recovery costs, lost revenue, and potential fines or penalties.',
    `external_support_engaged_flag` BOOLEAN COMMENT 'Flag indicating whether external cybersecurity consultants, forensic investigators, or incident response vendors were engaged to support incident response.',
    `external_support_vendor_name` STRING COMMENT 'Name of the external cybersecurity vendor or consultant engaged to support incident response, if applicable.',
    `financial_impact_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated financial impact amount.. Valid values are `^[A-Z]{3}$`',
    `incident_coordinator_name` STRING COMMENT 'Name of the security personnel or incident response team member coordinating the incident response.',
    `incident_number` STRING COMMENT 'Human-readable unique reference number for the cybersecurity incident, typically following format CYB-YYYY-NNNNNN for external communication and tracking.. Valid values are `^CYB-[0-9]{4}-[0-9]{6}$`',
    `incident_status` STRING COMMENT 'Current status of the cybersecurity incident in its lifecycle from detection through closure.. Valid values are `detected|under_investigation|contained|recovery_in_progress|resolved|closed`',
    `incident_type` STRING COMMENT 'Classification of the cybersecurity incident type. Aligned to IMO MSC-FAL.1/Circ.3 cyber risk categories for maritime systems.. Valid values are `ransomware|phishing|unauthorised_access|ddos|ot_network_intrusion|data_breach`',
    `indicators_of_compromise` STRING COMMENT 'Technical indicators of compromise such as IP addresses, file hashes, domain names, or registry keys associated with the incident.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this incident record was last modified or updated.',
    `law_enforcement_notification_flag` BOOLEAN COMMENT 'Flag indicating whether the incident was reported to law enforcement authorities for criminal investigation.',
    `malware_identified` STRING COMMENT 'Name or family of malware identified during the incident investigation, if applicable.',
    `maritime_authority_notification_flag` BOOLEAN COMMENT 'Flag indicating whether the incident was reported to the national maritime authority or port state control as required under IMO guidelines.',
    `maritime_authority_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the incident was reported to the maritime authority or port state control.',
    `occurrence_timestamp` TIMESTAMP COMMENT 'Estimated or confirmed date and time when the cybersecurity incident actually occurred or began, which may differ from detection time.',
    `operational_disruption_flag` BOOLEAN COMMENT 'Flag indicating whether the incident caused disruption to port operations such as vessel movements, cargo handling, or gate operations.',
    `pfso_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the Port Facility Security Officer was notified of the incident.',
    `pfso_notified_flag` BOOLEAN COMMENT 'Flag indicating whether the Port Facility Security Officer was notified of the cybersecurity incident as required under ISPS Code.',
    `pii_exposed_flag` BOOLEAN COMMENT 'Flag indicating whether personally identifiable information was exposed or compromised during the incident.',
    `post_incident_review_date` DATE COMMENT 'Date when the post-incident review was completed and documented.',
    `post_incident_review_reference` STRING COMMENT 'Reference identifier or document location for the post-incident review report containing lessons learned and improvement recommendations.',
    `recovery_actions` STRING COMMENT 'Description of recovery actions taken to restore affected systems and services to normal operation, including system restoration, data recovery, and security hardening.',
    `recovery_timestamp` TIMESTAMP COMMENT 'Date and time when affected systems were fully recovered and restored to normal operational status.',
    `remarks` STRING COMMENT 'Additional remarks, notes, or contextual information about the cybersecurity incident not captured in other fields.',
    `root_cause_analysis` STRING COMMENT 'Summary of the root cause analysis identifying the underlying vulnerabilities, weaknesses, or failures that allowed the incident to occur.',
    `severity_level` STRING COMMENT 'Severity classification of the cybersecurity incident based on business impact, data exposure, and operational disruption.. Valid values are `critical|high|medium|low`',
    `threat_actor_type` STRING COMMENT 'Classification of the suspected threat actor type based on tactics, techniques, and procedures observed during the incident.. Valid values are `nation_state|organized_crime|hacktivist|insider|opportunistic|unknown`',
    CONSTRAINT pk_cyber_incident PRIMARY KEY(`cyber_incident_id`)
) COMMENT 'Transactional record of cybersecurity incidents affecting port IT and OT (Operational Technology) systems including TOS (NAVIS N4), VTS, SCADA, PCS (Port Community System), gate automation, and crane control systems. Captures incident identifier, affected system(s), incident type (ransomware, phishing, unauthorised access, DDoS, OT network intrusion, data breach), detection date and time, attack vector, business impact assessment, containment actions, recovery actions, notification to national CERT and maritime authority, and post-incident review reference. Aligned to IMO MSC-FAL.1/Circ.3 cyber risk management guidelines.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` (
    `cyber_risk_register_id` BIGINT COMMENT 'Unique identifier for the cyber risk register entry. Primary key for the cyber risk register.',
    `parent_cyber_risk_register_id` BIGINT COMMENT 'Self-referencing FK on cyber_risk_register (parent_cyber_risk_register_id)',
    `employee_id` BIGINT COMMENT 'Identifier of the individual or role accountable for managing and monitoring this cyber risk.',
    `asset_at_risk` STRING COMMENT 'Specific asset, data repository, or operational technology component that could be compromised by this risk.',
    `closure_date` DATE COMMENT 'Date when this cyber risk was formally closed, either due to successful mitigation, elimination of the threat, or decommissioning of the affected system.',
    `closure_reason` STRING COMMENT 'Explanation of why this cyber risk entry was closed, documenting the resolution or change in circumstances.',
    `control_effectiveness` STRING COMMENT 'Assessment of how effectively the current controls reduce the likelihood or impact of the cyber risk.. Valid values are `ineffective|partially_effective|effective|highly_effective`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this cyber risk register entry was first created in the system.',
    `current_controls` STRING COMMENT 'Description of existing security controls, safeguards, and countermeasures currently in place to mitigate this cyber risk.',
    `cyber_risk_register_status` STRING COMMENT 'Current lifecycle status of the cyber risk register entry: active (ongoing monitoring), closed (risk eliminated or no longer relevant), archived (historical record), or under review (assessment in progress).. Valid values are `active|closed|archived|under_review`',
    `financial_impact_estimate` DECIMAL(18,2) COMMENT 'Estimated financial loss in the event this cyber risk materializes, including direct costs, business interruption, and recovery expenses.',
    `imo_msc_428_compliance_flag` BOOLEAN COMMENT 'Indicates whether this cyber risk assessment and treatment aligns with IMO Resolution MSC.428(98) maritime cyber risk management obligations.',
    `impact_rating` STRING COMMENT 'Assessment of the potential business impact if this cyber risk is realized, considering operational disruption, financial loss, safety implications, and reputational damage.. Valid values are `very_low|low|medium|high|very_high`',
    `impact_score` STRING COMMENT 'Numeric score representing the severity of impact if the risk materializes, typically on a scale of 1-5, used for quantitative risk calculations.',
    `inherent_risk_level` STRING COMMENT 'Qualitative classification of the inherent risk severity, derived from the inherent risk score and used for prioritization.. Valid values are `critical|high|medium|low`',
    `inherent_risk_score` STRING COMMENT 'Calculated risk score before considering any controls or mitigations, typically the product of likelihood and impact scores.',
    `iso_27001_alignment_flag` BOOLEAN COMMENT 'Indicates whether this cyber risk entry and its controls align with ISO/IEC 27001 information security management requirements.',
    `isps_code_relevance_flag` BOOLEAN COMMENT 'Indicates whether this cyber risk has implications for ISPS Code compliance and port facility security operations.',
    `last_assessment_date` DATE COMMENT 'Date when this cyber risk was most recently assessed or reviewed for changes in likelihood, impact, or control effectiveness.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this cyber risk register entry was most recently modified, supporting audit trails and change tracking.',
    `likelihood_rating` STRING COMMENT 'Assessment of the probability that this cyber risk will materialize, rated on a five-point scale from very low to very high.. Valid values are `very_low|low|medium|high|very_high`',
    `likelihood_score` STRING COMMENT 'Numeric score representing the likelihood of risk occurrence, typically on a scale of 1-5, used for quantitative risk calculations.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this cyber risk entry, ensuring ongoing relevance and accuracy.',
    `operational_impact_description` STRING COMMENT 'Description of how this cyber risk could disrupt port operations, including vessel traffic management, terminal operations, cargo handling, or safety systems.',
    `regulatory_impact_flag` BOOLEAN COMMENT 'Indicates whether realization of this cyber risk could result in regulatory non-compliance, fines, or sanctions from maritime or cybersecurity authorities.',
    `remarks` STRING COMMENT 'Additional notes, observations, or context relevant to this cyber risk entry, including lessons learned or special considerations.',
    `residual_risk_level` STRING COMMENT 'Qualitative classification of the residual risk severity after controls are applied, used to determine if additional treatment is required.. Valid values are `critical|high|medium|low`',
    `residual_risk_score` STRING COMMENT 'Calculated risk score after considering the effectiveness of current controls, representing the remaining exposure.',
    `review_frequency_months` STRING COMMENT 'Number of months between scheduled reviews of this cyber risk, with higher-severity risks typically reviewed more frequently.',
    `risk_acceptance_authority` STRING COMMENT 'Name and title of the senior executive or committee that formally accepted this residual risk.',
    `risk_acceptance_date` DATE COMMENT 'Date when the residual risk was formally accepted by authorized management, if applicable.',
    `risk_acceptance_flag` BOOLEAN COMMENT 'Indicates whether this residual risk has been formally accepted by senior management or the risk committee.',
    `risk_category` STRING COMMENT 'Classification of the cybersecurity risk type based on attack vector and threat nature. Includes network intrusion, data breach, OT/SCADA compromise, supply chain attack, insider threat, ransomware, phishing, DDoS, malware, and unauthorized access. [ENUM-REF-CANDIDATE: network_intrusion|data_breach|ot_scada_compromise|supply_chain_attack|insider_threat|ransomware|phishing|ddos_attack|malware|unauthorized_access — 10 candidates stripped; promote to reference product]',
    `risk_description` STRING COMMENT 'Detailed description of the cybersecurity risk, including threat vectors, vulnerabilities, and potential attack scenarios.',
    `risk_reference_number` STRING COMMENT 'Business identifier for the cyber risk entry, formatted as CR-YYYY-#### for external communication and audit trails.. Valid values are `^CR-[0-9]{4}-[0-9]{4}$`',
    `risk_subcategory` STRING COMMENT 'More granular classification within the primary risk category, providing additional context for risk treatment planning.',
    `risk_title` STRING COMMENT 'Concise title summarizing the cybersecurity risk for quick identification and reporting.',
    `safety_impact_flag` BOOLEAN COMMENT 'Indicates whether this cyber risk could result in physical harm to personnel, environmental damage, or compromise of safety-critical systems.',
    `system_at_risk` STRING COMMENT 'Name or identifier of the IT or OT system, application, or infrastructure component exposed to this cyber risk.',
    `threat_source` STRING COMMENT 'Origin or actor behind the potential threat, such as nation-state actors, cybercriminal groups, hacktivists, malicious insiders, or accidental user error.',
    `treatment_completion_date` DATE COMMENT 'Actual date when the risk treatment plan was completed and controls were fully implemented.',
    `treatment_due_date` DATE COMMENT 'Target date by which the risk treatment plan should be completed, used for tracking and accountability.',
    `treatment_plan` STRING COMMENT 'Detailed description of planned actions, controls, or initiatives to address this cyber risk according to the chosen treatment strategy.',
    `treatment_priority` STRING COMMENT 'Priority level assigned to the risk treatment activities, guiding resource allocation and scheduling.. Valid values are `critical|high|medium|low`',
    `treatment_status` STRING COMMENT 'Current status of the risk treatment plan implementation, tracking progress from planning through completion.. Valid values are `not_started|in_progress|completed|on_hold|cancelled`',
    `treatment_strategy` STRING COMMENT 'Selected risk treatment approach: mitigate (reduce likelihood/impact), accept (acknowledge and monitor), transfer (insurance or third-party), or avoid (eliminate the activity).. Valid values are `mitigate|accept|transfer|avoid`',
    `vulnerability_description` STRING COMMENT 'Description of the technical or procedural weakness that could be exploited to realize this cyber risk.',
    CONSTRAINT pk_cyber_risk_register PRIMARY KEY(`cyber_risk_register_id`)
) COMMENT 'Master register of identified cybersecurity risks across port IT and OT systems. Captures risk identifier, system or asset at risk, risk category (network intrusion, data breach, OT/SCADA compromise, supply chain attack, insider threat), likelihood rating, impact rating, inherent risk score, current controls in place, residual risk score, risk owner, treatment plan, treatment status, and review date. Supports IMO Resolution MSC-428(98) cyber risk management obligations and ISO 27001 alignment for port information security.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`personnel` (
    `personnel_id` BIGINT COMMENT 'Unique identifier for the security personnel record. Primary key for the security personnel master data.',
    `employee_id` BIGINT COMMENT 'Reference to the employee master record in the workforce domain. Links security personnel to their broader employment record for payroll, benefits, and HR management.',
    `post_id` BIGINT COMMENT 'Reference to the primary security post or station where this personnel is normally assigned for duty.',
    `supervisor_personnel_id` BIGINT COMMENT 'Self-referencing FK on personnel (supervisor_personnel_id)',
    `vendor_id` BIGINT COMMENT 'Reference to the contracted security company if employment_type is contracted. Null for direct employees.',
    `assignment_end_date` DATE COMMENT 'Planned or actual end date of the current security assignment. Null for ongoing assignments.',
    `assignment_start_date` DATE COMMENT 'Date on which the current security assignment or posting commenced. May differ from hire_date for personnel reassigned from other roles.',
    `clearance_expiry_date` DATE COMMENT 'Date on which the security clearance expires and re-vetting is required.',
    `clearance_issue_date` DATE COMMENT 'Date on which the current security clearance was granted following background checks and vetting.',
    `contact_email_address` STRING COMMENT 'Official email address for security communications, incident notifications, and operational coordination.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_phone_number` STRING COMMENT 'Primary contact phone number for reaching the security personnel during duty hours and for emergency call-out.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this security personnel record was first created in the system.',
    `date_of_birth` DATE COMMENT 'Date of birth of the security personnel, used for age verification, retirement planning, and identity confirmation.',
    `deputy_pfso_flag` BOOLEAN COMMENT 'Indicates whether this personnel is designated as a deputy PFSO authorized to act in the absence of the primary PFSO.',
    `emergency_contact_name` STRING COMMENT 'Name of the emergency contact person to be notified in case of incident or injury involving this security personnel.',
    `emergency_contact_phone` STRING COMMENT 'Phone number of the emergency contact person.',
    `employment_type` STRING COMMENT 'Classification of the employment relationship: direct port employee, contracted through security company, temporary assignment, or casual worker.. Valid values are `direct|contracted|temporary|casual`',
    `firearms_authorisation_flag` BOOLEAN COMMENT 'Indicates whether the security personnel is authorized to carry and use firearms while on duty at the port facility.',
    `firearms_licence_expiry_date` DATE COMMENT 'Expiry date of the firearms licence. Null if no firearms authorisation.',
    `firearms_licence_number` STRING COMMENT 'Official firearms licence number if the personnel is authorized to carry weapons. Null if firearms_authorisation_flag is false.',
    `full_name` STRING COMMENT 'Complete legal name of the security personnel as it appears on official identification documents and security credentials.',
    `hire_date` DATE COMMENT 'Date on which the security personnel was hired or contracted to begin security duties at the port facility.',
    `isps_training_certification` STRING COMMENT 'Certification number for ISPS Code training completion, demonstrating the personnel has received required security awareness and operational training.',
    `isps_training_completion_date` DATE COMMENT 'Date on which the personnel successfully completed ISPS Code security training.',
    `isps_training_expiry_date` DATE COMMENT 'Date on which the ISPS training certification expires and refresher training is required.',
    `last_training_date` DATE COMMENT 'Date of the most recent security training or refresher course completed by the personnel.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this security personnel record was most recently modified.',
    `licence_expiry_date` DATE COMMENT 'Date on which the security licence expires and must be renewed for the personnel to continue performing security duties.',
    `licence_issue_date` DATE COMMENT 'Date on which the security licence was originally issued to the personnel.',
    `licence_issuing_authority` STRING COMMENT 'Name of the government agency, regulatory body, or certification authority that issued the security licence.',
    `medical_fitness_certificate_expiry` DATE COMMENT 'Expiry date of the medical fitness certificate confirming the personnel is physically and mentally fit to perform security duties.',
    `national_id_number` STRING COMMENT 'Government-issued national identification number used for background checks and security vetting.',
    `nationality` STRING COMMENT 'Nationality of the security personnel using ISO 3166-1 alpha-3 country code. Relevant for security clearance and work permit requirements.. Valid values are `^[A-Z]{3}$`',
    `next_training_due_date` DATE COMMENT 'Date by which the next mandatory security training or refresher course must be completed to maintain certification.',
    `personnel_number` STRING COMMENT 'Business identifier for the security personnel, typically assigned by HR or security management system. Used for external reference and integration with workforce systems.. Valid values are `^[A-Z]{2,4}[0-9]{6,10}$`',
    `personnel_status` STRING COMMENT 'Current operational status of the security personnel indicating availability for duty.. Valid values are `active|on_leave|suspended|terminated|retired`',
    `pfso_designation_flag` BOOLEAN COMMENT 'Indicates whether this personnel holds the official PFSO designation as required by ISPS Code. Only one active PFSO per facility is permitted.',
    `position_title` STRING COMMENT 'Official job title or role designation for the security personnel within the port facility security organization (e.g., Port Facility Security Officer, Security Supervisor, Security Guard, CCTV Operator).',
    `position_type` STRING COMMENT 'Standardized classification of the security role for reporting and resource planning purposes. [ENUM-REF-CANDIDATE: pfso|deputy_pfso|security_supervisor|security_guard|cctv_operator|access_control_officer|patrol_officer|cybersecurity_officer — 8 candidates stripped; promote to reference product]',
    `remarks` STRING COMMENT 'Additional notes, comments, or special instructions related to the security personnel record.',
    `security_clearance_level` STRING COMMENT 'Level of background security clearance granted to the personnel, determining access to sensitive areas and information.. Valid values are `basic|standard|enhanced|top_secret`',
    `security_licence_number` STRING COMMENT 'Official security licence or certification number issued by the relevant national or regional authority authorizing the individual to perform security duties at the port facility.',
    `termination_date` DATE COMMENT 'Date on which the security personnel employment or contract was terminated. Null for active personnel.',
    `termination_reason` STRING COMMENT 'Reason for termination of employment or contract (e.g., resignation, contract expiry, dismissal, retirement). Null for active personnel.',
    `uniform_size` STRING COMMENT 'Uniform size for the security personnel for procurement and inventory management purposes.',
    `work_permit_expiry_date` DATE COMMENT 'Expiry date of the work permit. Null for nationals who do not require work permits.',
    `work_permit_number` STRING COMMENT 'Work permit or visa number for non-national personnel, required for legal employment verification.',
    CONSTRAINT pk_personnel PRIMARY KEY(`personnel_id`)
) COMMENT 'Master record for all security personnel assigned to port facility security operations including PFSO (Port Facility Security Officer), deputy PFSOs, security supervisors, security guards, CCTV operators, and contracted security company staff. Captures personnel identifier, full name, position title, PFSO designation flag, security licence number, licence issuing authority, licence expiry, ISPS training certification, firearms authorisation, assigned zones and posts, employment type (direct/contracted), and security company reference. Distinct from workforce.employee which covers all port staff — this is the security-domain SSOT for security-credentialled personnel.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`post` (
    `post_id` BIGINT COMMENT 'Unique identifier for the security post or guard position within the port facility security infrastructure.',
    `berth_id` BIGINT COMMENT 'Reference to the specific berth if this security post is assigned to quayside or vessel interface security.',
    `facility_building_id` BIGINT COMMENT 'Reference to the facility building or structure where this security post is located (e.g., security control room, administration building).',
    `parent_post_id` BIGINT COMMENT 'Self-referencing FK on post (parent_post_id)',
    `port_gate_id` BIGINT COMMENT 'Reference to the specific gate if this security post is assigned to gate operations and access control.',
    `employee_id` BIGINT COMMENT 'Reference to the security officer currently assigned to this post for the active shift.',
    `post_supervisor_employee_id` BIGINT COMMENT 'Reference to the security supervisor or shift commander responsible for overseeing this security post.',
    `zone_id` BIGINT COMMENT 'Reference to the security zone within which this post is located, supporting zone-based access control and threat assessment.',
    `access_control_function_flag` BOOLEAN COMMENT 'Indicates whether this security post has responsibility for controlling and verifying access of personnel, vehicles, or cargo into restricted areas.',
    `alarm_response_flag` BOOLEAN COMMENT 'Indicates whether this security post is designated as a first responder to security alarms in its assigned zone or area.',
    `barrier_control_flag` BOOLEAN COMMENT 'Indicates whether this security post has operational control over physical barriers such as gates, bollards, or vehicle barriers.',
    `cctv_camera_coverage` STRING COMMENT 'List or description of CCTV cameras that are monitored or within the surveillance responsibility of this security post.',
    `cctv_monitoring_flag` BOOLEAN COMMENT 'Indicates whether this security post has access to and responsibility for monitoring CCTV camera feeds.',
    `post_code` STRING COMMENT 'Unique alphanumeric code assigned to the security post for operational reference and radio communication (e.g., GATE-01, QUAY-A3, PATROL-05).. Valid values are `^[A-Z0-9]{4,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this security post record was first created in the system.',
    `current_assignment_status` STRING COMMENT 'Real-time status indicating whether the security post is currently staffed with the required number of officers.. Valid values are `staffed|unstaffed|partially_staffed|vacant|covered_remotely`',
    `current_staffing_level` STRING COMMENT 'Actual number of security officers currently assigned and deployed to this post at the present time.',
    `emergency_response_role` STRING COMMENT 'Specific role and responsibilities assigned to this security post during emergency situations, security incidents, or MARSEC level escalations.',
    `establishment_date` DATE COMMENT 'Date when this security post was first established and became operational within the port facility security infrastructure.',
    `intercom_available_flag` BOOLEAN COMMENT 'Indicates whether this security post is equipped with intercom or two-way communication system for visitor communication.',
    `last_review_date` DATE COMMENT 'Date when the security post configuration, staffing requirements, and operational procedures were last reviewed and validated by the Port Facility Security Officer (PFSO).',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this security post record was most recently modified or updated.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the security post location in decimal degrees for mapping and incident response.',
    `location_description` STRING COMMENT 'Detailed textual description of the physical location of the security post within the port facility (e.g., adjacent to Gate 3, near Container Yard Block C, at Berth 12 gangway).',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the security post location in decimal degrees for mapping and incident response.',
    `marsec_level_1_staffing` STRING COMMENT 'Required number of security officers to be assigned to this post when the port facility is operating at MARSEC Level 1 (normal security conditions).',
    `marsec_level_2_staffing` STRING COMMENT 'Required number of security officers to be assigned to this post when the port facility is operating at MARSEC Level 2 (heightened security threat).',
    `marsec_level_3_staffing` STRING COMMENT 'Required number of security officers to be assigned to this post when the port facility is operating at MARSEC Level 3 (imminent or actual security incident).',
    `post_name` STRING COMMENT 'Descriptive name of the security post indicating its location or function (e.g., Main Gate North, Berth 7 Waterside, Container Yard Patrol).',
    `next_review_due_date` DATE COMMENT 'Scheduled date for the next periodic review of this security post configuration and effectiveness as part of the Port Facility Security Plan (PFSP) review cycle.',
    `operating_hours_description` STRING COMMENT 'Detailed description of the operating hours and staffing schedule for this security post (e.g., 0600-1800 weekdays, 24/7 during vessel operations).',
    `operating_hours_type` STRING COMMENT 'Classification of the operating schedule for this security post indicating when it is required to be staffed.. Valid values are `24x7|business_hours|shift_based|on_demand|vessel_dependent`',
    `operational_status` STRING COMMENT 'Current operational state of the security post indicating whether it is actively staffed and functional.. Valid values are `active|inactive|temporarily_closed|under_maintenance|decommissioned`',
    `patrol_frequency_minutes` STRING COMMENT 'Required frequency in minutes for completing patrol rounds or checkpoint visits for roving security posts.',
    `patrol_function_flag` BOOLEAN COMMENT 'Indicates whether this security post involves mobile patrol duties covering multiple locations within the port facility.',
    `patrol_route_description` STRING COMMENT 'Detailed description of the patrol route, checkpoints, and coverage area for roving security posts.',
    `post_type` STRING COMMENT 'Classification of the security post based on its operational mode and location type within the port facility. [ENUM-REF-CANDIDATE: fixed|roving|waterside|control_room|gate|perimeter|quay|vehicle_patrol|foot_patrol — 9 candidates stripped; promote to reference product]',
    `primary_responsibility` STRING COMMENT 'Main security function and responsibility assigned to this post (e.g., vehicle inspection, personnel access control, CCTV monitoring, perimeter patrol, vessel interface security).',
    `radio_channel` STRING COMMENT 'Designated radio frequency or channel used by security officers at this post for operational communications.',
    `radio_equipment_assigned` STRING COMMENT 'Type and identifier of radio communication equipment assigned to this security post for coordination with security control room and other posts.',
    `remarks` STRING COMMENT 'Additional notes, special instructions, or operational considerations relevant to this security post.',
    `scanner_equipment_assigned` STRING COMMENT 'Type and identifier of scanning equipment assigned to this post (e.g., RFID reader, barcode scanner, biometric scanner, document scanner).',
    `shift_pattern` STRING COMMENT 'Standard shift rotation pattern applied to this security post (e.g., 3x8-hour shifts, 2x12-hour shifts, rotating 4-on-4-off).',
    `surveillance_function_flag` BOOLEAN COMMENT 'Indicates whether this security post has responsibility for monitoring CCTV systems, conducting visual surveillance, or observing restricted areas.',
    `vehicle_assigned` STRING COMMENT 'Identifier of the security patrol vehicle assigned to this post for mobile patrol duties (e.g., patrol car, motorcycle, bicycle, golf cart).',
    CONSTRAINT pk_post PRIMARY KEY(`post_id`)
) COMMENT 'Master record for all security posts and guard positions deployed across the port facility including gate posts, perimeter posts, quay posts, control room positions, and roving patrol assignments. Captures post identifier, post name, location (zone, gate, berth), post type (fixed, roving, waterside), required staffing level per MARSEC level, operating hours, equipment assigned (radio, scanner, vehicle), and current assignment status. Supports security resource planning and MARSEC-level staffing escalation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` (
    `visitor_log_id` BIGINT COMMENT 'Unique identifier for the visitor log record. Primary key for the visitor log transaction.',
    `employee_id` BIGINT COMMENT 'Identifier of the security officer or authorized employee assigned to escort the visitor during their time in the port facility.',
    `escorted_by_visitor_log_id` BIGINT COMMENT 'Self-referencing FK on visitor_log (escorted_by_visitor_log_id)',
    `access_point_id` BIGINT COMMENT 'Identifier of the physical access control point where the visitor entered the port facility.',
    `security_incident_id` BIGINT COMMENT 'Reference to the security incident record if this visit was involved in or triggered a security event.',
    `authorization_level` STRING COMMENT 'Maximum security zone access level granted to the visitor based on visit purpose and security clearance.. Valid values are `public_area|operational_area|restricted_area|critical_infrastructure`',
    `badge_returned_flag` BOOLEAN COMMENT 'Indicates whether the visitor returned their temporary badge upon exit from the port facility.',
    `biometric_capture_flag` BOOLEAN COMMENT 'Indicates whether biometric data (fingerprint, facial recognition, iris scan) was captured from the visitor for enhanced security verification.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this visitor log record was first created in the visitor management system.',
    `entry_timestamp` TIMESTAMP COMMENT 'Date and time when the visitor entered the port facility through the access control point. Principal business event timestamp for this transaction.',
    `escort_officer_name` STRING COMMENT 'Full name of the security officer or authorized employee assigned as escort for audit trail purposes.',
    `escort_required_flag` BOOLEAN COMMENT 'Indicates whether the visitor must be accompanied by an authorized escort at all times within the port facility based on security zone access requirements.',
    `exit_timestamp` TIMESTAMP COMMENT 'Date and time when the visitor exited the port facility. Null if visitor is still on-site or exit was not recorded.',
    `host_contact_name` STRING COMMENT 'Full name of the port facility employee or authorized person who is hosting or sponsoring the visitor.',
    `host_contact_phone` STRING COMMENT 'Contact telephone number of the host employee for visitor coordination and emergency contact purposes.',
    `host_department` STRING COMMENT 'Name of the port facility department or division that the host contact belongs to.',
    `identity_document_expiry_date` DATE COMMENT 'Expiration date of the visitors identity document. Used to validate document validity at time of visit.',
    `identity_document_issuing_country` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code of the authority that issued the identity document.. Valid values are `^[A-Z]{3}$`',
    `identity_document_number` STRING COMMENT 'Unique identification number from the visitors official identity document. Critical for security verification and audit trail compliance.',
    `identity_document_type` STRING COMMENT 'Type of official identity document presented by the visitor for verification and registration purposes.. Valid values are `passport|national_id|drivers_license|seafarer_id|port_pass|government_id`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this visitor log record was last updated, supporting audit trail and data lineage requirements.',
    `marsec_level` STRING COMMENT 'The ISPS Code maritime security level in effect at the port facility at the time of visitor entry. Determines applicable security measures and access restrictions.. Valid values are `marsec_1|marsec_2|marsec_3`',
    `nationality` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the visitors nationality as stated on identity document.. Valid values are `^[A-Z]{3}$`',
    `organization_name` STRING COMMENT 'Name of the company, agency, or organization that the visitor represents during this port facility visit.',
    `organization_type` STRING COMMENT 'Classification of the organization that the visitor represents, used for access control and reporting purposes. [ENUM-REF-CANDIDATE: shipping_line|freight_forwarder|customs_broker|government_agency|contractor|vendor|surveyor|other — 8 candidates stripped; promote to reference product]',
    `pfso_approval_required_flag` BOOLEAN COMMENT 'Indicates whether this visit required explicit approval from the Port Facility Security Officer due to high-risk classification or restricted area access.',
    `pfso_approval_timestamp` TIMESTAMP COMMENT 'Date and time when the PFSO approved this visitor access request.',
    `photo_captured_flag` BOOLEAN COMMENT 'Indicates whether a photograph of the visitor was captured during registration for badge printing and security records.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, observations, or special instructions related to this visitor log entry.',
    `restricted_area_access_flag` BOOLEAN COMMENT 'Indicates whether the visitor accessed any restricted security zones during their visit, requiring enhanced audit trail documentation.',
    `screening_method` STRING COMMENT 'Type of security screening method applied to the visitor during entry processing.. Valid values are `metal_detector|x_ray|physical_inspection|biometric|none`',
    `security_incident_flag` BOOLEAN COMMENT 'Indicates whether this visit was associated with or resulted in a security incident requiring investigation or reporting.',
    `security_screening_completed_flag` BOOLEAN COMMENT 'Indicates whether the visitor completed mandatory security screening procedures including metal detection, bag inspection, or other MARSEC-level requirements.',
    `vehicle_entry_flag` BOOLEAN COMMENT 'Indicates whether the visitor entered the port facility with a vehicle requiring separate vehicle registration and inspection.',
    `vehicle_make_model` STRING COMMENT 'Manufacturer and model description of the visitors vehicle for identification and security verification.',
    `vehicle_registration_number` STRING COMMENT 'License plate or registration number of the vehicle used by the visitor to enter the port facility. Required for vehicle access audit trail.',
    `vehicle_type` STRING COMMENT 'Classification of the vehicle type used by the visitor for access control and security screening purposes.. Valid values are `car|van|truck|motorcycle|bus|other`',
    `visit_duration_minutes` STRING COMMENT 'Calculated duration of the visit in minutes from entry to exit. Used for access pattern analysis and security monitoring.',
    `visit_number` STRING COMMENT 'Externally-known unique reference number assigned to this visit for tracking and audit purposes. Format: VIS-YYYYMMDD-NNNN.. Valid values are `^VIS-[0-9]{8}-[0-9]{4}$`',
    `visit_purpose` STRING COMMENT 'Detailed description of the business purpose or reason for the visitors entry into the port facility. Required for ISPS Code access justification.',
    `visit_purpose_category` STRING COMMENT 'Standardized category classification of the visit purpose for reporting and analytics. [ENUM-REF-CANDIDATE: cargo_operations|vessel_operations|maintenance|inspection|delivery|meeting|training|audit|emergency — 9 candidates stripped; promote to reference product]',
    `visit_status` STRING COMMENT 'Current lifecycle status of the visitor log record indicating whether the visit is ongoing, completed normally, or flagged for security review.. Valid values are `active|completed|cancelled|overstayed|security_incident`',
    `visitor_badge_number` STRING COMMENT 'Unique identification number of the temporary visitor badge issued to the visitor for the duration of their visit. Format: VB-NNNNNN.. Valid values are `^VB-[0-9]{6}$`',
    `visitor_full_name` STRING COMMENT 'Complete legal name of the visitor as shown on identity document. Required for ISPS Code visitor identification and access audit trail.',
    `watchlist_check_status` STRING COMMENT 'Result of security watchlist verification check performed against visitor identity information during registration.. Valid values are `cleared|flagged|not_performed|pending`',
    `zones_accessed` STRING COMMENT 'Comma-separated list of security zone identifiers or names that the visitor accessed during their visit. Critical for ISPS Code access audit trail.',
    CONSTRAINT pk_visitor_log PRIMARY KEY(`visitor_log_id`)
) COMMENT 'Transactional record of all visitor registrations and movements within the port facility for persons not holding permanent port access credentials. Captures visit identifier, visitor full name, nationality, identity document type and number, organisation represented, purpose of visit, host contact within port, escort required flag, escort officer assigned, entry date and time, exit date and time, zones accessed, vehicle details if applicable, and visitor badge number issued. Supports ISPS Code visitor management and access audit trail requirements.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` (
    `security_equipment_id` BIGINT COMMENT 'Unique identifier for the security equipment asset. Primary key for the security equipment registry.',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Security equipment (X-ray scanners, metal detectors, radiation detectors, barriers) are instances of equipment types with standardized specs, maintenance schedules, and certification requirements. Lin',
    `replaced_security_equipment_id` BIGINT COMMENT 'Self-referencing FK on security_equipment (replaced_security_equipment_id)',
    `post_id` BIGINT COMMENT 'Reference to the security post or control room responsible for monitoring and operating this equipment.',
    `zone_id` BIGINT COMMENT 'Reference to the security zone where this equipment is deployed. Security zones are defined in the Facility Security Plan per ISPS Code requirements.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'Original purchase cost of the security equipment in the ports functional currency. Used for asset valuation and depreciation calculations.',
    `backup_power_available_flag` BOOLEAN COMMENT 'Indicates whether the security equipment has backup power supply (UPS or generator) to maintain operation during power outages, as required by ISPS Code for critical security systems.',
    `calibration_frequency_months` STRING COMMENT 'Required interval in months between calibrations for this security equipment type as specified by manufacturer or regulatory authority.',
    `certification_authority` STRING COMMENT 'Name of the regulatory body or certification authority that issued the equipment certification (e.g., national maritime authority, TSA, customs authority).',
    `certification_expiry_date` DATE COMMENT 'Date when the current certification for this security equipment expires and recertification is required.',
    `certification_number` STRING COMMENT 'Official certification or approval number issued by the regulatory authority or standards body confirming the equipment meets required security standards.',
    `commissioning_date` DATE COMMENT 'Date when the security equipment was formally commissioned and approved for operational use following installation and testing.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this security equipment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the acquisition cost (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `deployment_location` STRING COMMENT 'Physical location within the port facility where the security equipment is deployed. Examples include main gate, cargo screening area, passenger terminal entrance, perimeter fence zone 3, etc.',
    `disposal_date` DATE COMMENT 'Date when the security equipment was decommissioned and disposed of or removed from service.',
    `disposal_method` STRING COMMENT 'Method by which the security equipment was disposed of when decommissioned (e.g., sold, scrapped, recycled, donated, transferred to another facility).. Valid values are `sold|scrapped|recycled|donated|transferred`',
    `environmental_rating` STRING COMMENT 'Ingress Protection (IP) rating indicating the equipments resistance to dust and water ingress. Critical for outdoor deployments in maritime environments (e.g., IP65, IP67).. Valid values are `^IP[0-9]{2}$`',
    `expected_useful_life_years` STRING COMMENT 'Expected useful operational life of the security equipment in years, used for asset replacement planning and depreciation calculations.',
    `firmware_version` STRING COMMENT 'Current firmware or software version installed on the security equipment. Critical for cybersecurity patch management and vulnerability tracking.',
    `installation_date` DATE COMMENT 'Date when the security equipment was installed and commissioned at the port facility.',
    `integration_system_code` STRING COMMENT 'Identifier of the integrated security management system or access control platform to which this equipment is connected (e.g., CCTV management system, access control system).',
    `ip_address` STRING COMMENT 'Network IP address assigned to the security equipment for network connectivity and remote monitoring. Applicable to networked devices such as CCTV cameras, ANPR systems, and biometric readers.. Valid values are `^(?:[0-9]{1,3}.){3}[0-9]{1,3}$`',
    `isps_compliance_flag` BOOLEAN COMMENT 'Indicates whether this security equipment meets ISPS Code requirements and is approved for use in port facility security operations.',
    `last_calibration_date` DATE COMMENT 'Date of the most recent calibration performed on the security equipment to ensure accuracy and compliance with operational standards.',
    `last_firmware_update_date` DATE COMMENT 'Date when the firmware or software on the security equipment was last updated or patched.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance performed on the security equipment.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this security equipment record was last modified in the system.',
    `lifecycle_stage` STRING COMMENT 'Current stage in the asset lifecycle indicating whether the equipment is new, in operational service, aging and requiring increased maintenance, approaching end of life, or obsolete.. Valid values are `new|operational|aging|end of life|obsolete`',
    `mac_address` STRING COMMENT 'Hardware MAC address of the security equipments network interface. Used for network access control and device authentication.. Valid values are `^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$`',
    `maintenance_schedule_reference` STRING COMMENT 'Reference number or identifier linking this equipment to its maintenance plan in the asset management system (e.g., Maximo work plan number).',
    `mean_time_between_failures` STRING COMMENT 'Manufacturer-specified mean time between failures in hours, indicating the expected reliability of the security equipment.',
    `next_calibration_due_date` DATE COMMENT 'Scheduled date for the next required calibration of the security equipment based on manufacturer recommendations and regulatory requirements.',
    `next_maintenance_due_date` DATE COMMENT 'Scheduled date for the next preventive maintenance activity on the security equipment.',
    `operating_temperature_range` STRING COMMENT 'Manufacturer-specified temperature range within which the security equipment can operate reliably (e.g., -20°C to +60°C). Important for equipment deployed in outdoor or extreme environments.',
    `operational_status` STRING COMMENT 'Current operational state of the security equipment indicating whether it is in active service, undergoing maintenance, awaiting calibration, or decommissioned.. Valid values are `operational|non-operational|maintenance|calibration|decommissioned|standby`',
    `power_source_type` STRING COMMENT 'Type of electrical power source supplying the security equipment (e.g., mains power, battery, UPS backup, solar, dual source).. Valid values are `mains power|battery|ups backup|solar|dual source`',
    `purchase_order_number` STRING COMMENT 'Purchase order number under which this security equipment was procured.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special handling instructions, or operational observations related to the security equipment.',
    `serial_number` STRING COMMENT 'Manufacturers unique serial number for this specific unit of security equipment. Used for warranty claims, maintenance tracking, and asset verification.',
    `tag_number` STRING COMMENT 'Unique asset tag number assigned to the security equipment for physical identification and tracking. Typically affixed to the equipment as a barcode or RFID tag.. Valid values are `^[A-Z]{2,4}-[0-9]{4,6}$`',
    `vendor_name` STRING COMMENT 'Name of the vendor or supplier who provided the security equipment to the port facility.',
    `warranty_expiry_date` DATE COMMENT 'Date when the manufacturers warranty coverage for this security equipment expires.',
    CONSTRAINT pk_security_equipment PRIMARY KEY(`security_equipment_id`)
) COMMENT 'Master registry of all security equipment assets deployed at the port facility including X-ray scanners, walk-through metal detectors, handheld metal detectors, radiation portal monitors, ANPR (Automatic Number Plate Recognition) systems, biometric readers, perimeter intrusion detection sensors, and security vehicles. Captures equipment identifier, equipment type, make and model, serial number, deployment location, operational status, last calibration date, next calibration due, maintenance schedule reference, and responsible security post. Distinct from asset.port_asset which covers all port operational assets — this is the security-domain view of security-specific equipment.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` (
    `mda_observation_id` BIGINT COMMENT 'Unique identifier for the maritime domain awareness observation record.',
    `correlated_mda_observation_id` BIGINT COMMENT 'Self-referencing FK on mda_observation (correlated_mda_observation_id)',
    `patrol_id` BIGINT COMMENT 'Unique identifier of the security patrol dispatched in response to this observation if applicable.',
    `personnel_id` BIGINT COMMENT 'Unique identifier of the security officer or VTS operator who reported the observation.',
    `security_incident_id` BIGINT COMMENT 'Unique identifier of the security incident record created from this observation if escalated to a formal incident.',
    `vessel_id` BIGINT COMMENT 'Unique identifier of the vessel involved in the observation if identified and registered in the port vessel master data.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.zone. Business justification: Maritime Domain Awareness observations occur in specific zones (waterside zones, approach zones, etc.). While mda_observation has location_description (STRING), adding explicit zone_id FK enables spat',
    `ais_data_reference` STRING COMMENT 'Reference identifier linking to the AIS data record or VTS system log associated with this observation.',
    `ais_status` STRING COMMENT 'Status of the vessel AIS transmission at the time of observation indicating whether the vessel was broadcasting, dark, or exhibiting anomalous AIS behaviour.. Valid values are `transmitting|dark|intermittent|spoofed|unknown`',
    `cctv_camera_ids` STRING COMMENT 'Comma-separated list of CCTV camera identifiers that captured footage relevant to the observation.',
    `cctv_footage_available_flag` BOOLEAN COMMENT 'Indicates whether CCTV footage of the observation location and time is available for review or evidence purposes.',
    `course_degrees` DECIMAL(18,2) COMMENT 'Vessel course over ground in degrees (0-360) at the time of observation if available from AIS or radar tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the observation record was first created in the maritime domain awareness system.',
    `distance_from_port_nm` DECIMAL(18,2) COMMENT 'Distance of the observation location from the port facility boundary measured in nautical miles.',
    `flag_state` STRING COMMENT 'Three-letter ISO country code representing the flag state of the vessel involved in the observation.. Valid values are `^[A-Z]{3}$`',
    `imo_number` STRING COMMENT 'Seven-digit IMO ship identification number assigned to the vessel if identified, providing permanent vessel identity.. Valid values are `^IMOd{7}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the observation record was last updated or modified.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the observation location in decimal degrees.',
    `location_description` STRING COMMENT 'Textual description of the observation location relative to port infrastructure, navigation channels, or maritime zones.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the observation location in decimal degrees.',
    `maritime_authority_name` STRING COMMENT 'Name of the maritime security authority or coast guard agency to which the observation was reported.',
    `maritime_authority_notified_flag` BOOLEAN COMMENT 'Indicates whether the observation was reported to the national maritime security authority, coast guard, or port state control.',
    `marsec_level` STRING COMMENT 'ISPS Code maritime security level in effect at the port at the time of the observation.. Valid values are `marsec_1|marsec_2|marsec_3`',
    `mmsi_number` STRING COMMENT 'Nine-digit MMSI number used for AIS identification of the vessel involved in the observation.. Valid values are `^d{9}$`',
    `notification_method` STRING COMMENT 'Communication method used to notify the maritime security authority of the observation.. Valid values are `phone|email|secure_portal|vhf_radio|edi_message`',
    `notification_reference_number` STRING COMMENT 'Reference number or case identifier assigned by the maritime security authority upon notification.',
    `notification_timestamp` TIMESTAMP COMMENT 'Date and time when the maritime security authority was notified of the observation.',
    `observation_notes` STRING COMMENT 'Detailed narrative description of the observation including circumstances, behaviour patterns, environmental conditions, and any other relevant contextual information.',
    `observation_number` STRING COMMENT 'Human-readable reference number assigned to the observation for tracking and reporting purposes.',
    `observation_status` STRING COMMENT 'Current lifecycle status of the maritime domain awareness observation indicating its processing state.. Valid values are `open|under_investigation|resolved|escalated|closed`',
    `observation_timestamp` TIMESTAMP COMMENT 'Date and time when the maritime domain awareness observation was made or the suspicious activity was detected.',
    `observation_type` STRING COMMENT 'Classification of the maritime domain awareness observation indicating the nature of the security concern or anomaly detected.. Valid values are `suspicious_vessel_behaviour|unidentified_vessel|unauthorised_approach|dark_vessel_ais_off|small_craft_incursion|underwater_threat`',
    `pfso_comments` STRING COMMENT 'Comments or assessment notes provided by the Port Facility Security Officer during review of the observation.',
    `pfso_review_timestamp` TIMESTAMP COMMENT 'Date and time when the Port Facility Security Officer reviewed the observation.',
    `pfso_reviewed_flag` BOOLEAN COMMENT 'Indicates whether the observation has been reviewed by the Port Facility Security Officer.',
    `reporting_officer_name` STRING COMMENT 'Name of the security officer or VTS operator who reported the observation for accountability and follow-up purposes.',
    `reporting_source` STRING COMMENT 'Source entity or system that generated or reported the maritime domain awareness observation. [ENUM-REF-CANDIDATE: vts|coast_guard|port_security_patrol|cctv|radar|pilot|harbour_master|third_party — 8 candidates stripped; promote to reference product]',
    `reporting_timestamp` TIMESTAMP COMMENT 'Date and time when the observation was formally reported into the port security operations centre or maritime domain awareness system.',
    `response_action_taken` STRING COMMENT 'Description of the immediate response actions taken by port security or VTS in response to the observation such as vessel challenge, patrol dispatch, or area restriction.',
    `security_incident_created_flag` BOOLEAN COMMENT 'Indicates whether a formal security incident record was created as a result of this observation.',
    `security_patrol_dispatched_flag` BOOLEAN COMMENT 'Indicates whether a security patrol was dispatched to investigate or respond to the observation.',
    `speed_knots` DECIMAL(18,2) COMMENT 'Vessel speed over ground in knots at the time of observation if available from AIS or radar tracking.',
    `threat_assessment_reference` STRING COMMENT 'Reference identifier linking to the formal threat assessment document or intelligence report supporting the threat level determination.',
    `threat_level` STRING COMMENT 'Assessed threat level of the observation based on the nature of the activity, proximity to critical infrastructure, and intelligence context.. Valid values are `low|medium|high|critical`',
    `vessel_challenged_flag` BOOLEAN COMMENT 'Indicates whether the vessel was challenged via VHF radio or other communication means to identify itself or explain its behaviour.',
    `vessel_response` STRING COMMENT 'Summary of the vessel response to any challenge or communication attempt made by port security or VTS.',
    `vessel_type` STRING COMMENT 'Classification of the vessel type involved in the observation such as cargo, tanker, fishing, pleasure craft, or unknown.',
    CONSTRAINT pk_mda_observation PRIMARY KEY(`mda_observation_id`)
) COMMENT 'Transactional record of Maritime Domain Awareness (MDA) observations and intelligence reports generated by the port VTS, coast guard liaison, and port security operations centre. Captures observation identifier, observation type (suspicious vessel behaviour, unidentified vessel, unauthorised approach, dark vessel — AIS off, small craft incursion, underwater threat), date and time, position (lat/long), vessel details if identified, AIS data reference, reporting source, threat level assessed, response action taken, and notification to maritime security authority. Supports port maritime domain awareness and early warning capabilities.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` (
    `security_corrective_action_id` BIGINT COMMENT 'Unique identifier for the security corrective action record. Primary key.',
    `cyber_incident_id` BIGINT COMMENT 'Foreign key linking to security.cyber_incident. Business justification: Corrective actions arise from cyber incidents. The source_type field indicates cyber_incident as a source. Cyber incidents have corrective_actions_identified field, confirming this relationship. Add',
    `drill_id` BIGINT COMMENT 'Foreign key linking to security.drill. Business justification: Corrective actions arise from drill deficiencies. The source_type field indicates drill as a source, and drill.deficiencies_identified and drill.corrective_actions_raised fields confirm this relatio',
    `parent_security_corrective_action_id` BIGINT COMMENT 'Self-referencing FK on security_corrective_action (parent_security_corrective_action_id)',
    `personnel_id` BIGINT COMMENT 'Identifier of the Port Facility Security Officer overseeing this corrective action. The PFSO has ultimate accountability for security compliance and corrective action closure.',
    `employee_id` BIGINT COMMENT 'Identifier of the security officer or personnel assigned primary responsibility for implementing this corrective action. Links to workforce or security personnel master data.',
    `security_audit_id` BIGINT COMMENT 'Foreign key linking to security.security_audit. Business justification: Corrective actions arise from audit findings (non-conformances). The source_type field indicates audit as a source. Adding explicit FK enables tracking which audit generated which corrective actions',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Corrective actions frequently arise from security incidents. The source_type field indicates incident as a source, and source_reference_code would store the incident_number. Adding explicit FK enabl',
    `threat_assessment_id` BIGINT COMMENT 'Foreign key linking to security.threat_assessment. Business justification: Corrective actions arise from threat assessment findings and recommended countermeasures. The source_type field indicates threat_assessment as a source. Adding explicit FK enables tracking which thr',
    `action_category` STRING COMMENT 'Classification of the corrective action by type: procedural (process changes), physical (infrastructure/equipment), technical (IT/OT systems), training (personnel development), policy (documentation updates), or organizational (structural changes).. Valid values are `procedural|physical|technical|training|policy|organizational`',
    `action_description` STRING COMMENT 'Detailed narrative description of the corrective or preventive action to be taken, including specific steps, controls to be implemented, and expected outcomes.',
    `action_number` STRING COMMENT 'Business-facing unique reference number for the corrective action, formatted as SCAPA-YYYY-NNNNNN for tracking and audit purposes.. Valid values are `^SCAPA-[0-9]{4}-[0-9]{6}$`',
    `action_priority` STRING COMMENT 'Priority level assigned to the corrective action based on risk severity and urgency. Critical actions require immediate implementation; low priority actions may be scheduled for routine maintenance windows.. Valid values are `critical|high|medium|low`',
    `action_status` STRING COMMENT 'Current lifecycle status of the corrective action. Tracks progression from identification through implementation, verification, and closure. [ENUM-REF-CANDIDATE: open|in_progress|pending_verification|verified|closed|cancelled|overdue — 7 candidates stripped; promote to reference product]',
    `actual_completion_date` DATE COMMENT 'The actual date on which the corrective action was completed and implemented. Null if the action is still open or in progress.',
    `actual_cost` DECIMAL(18,2) COMMENT 'Actual financial cost incurred to implement the corrective action. Null if the action is not yet complete or cost tracking is unavailable.',
    `closure_approved_by` STRING COMMENT 'Name or identifier of the authority (typically PFSO or senior security manager) who approved the closure of the corrective action.',
    `closure_date` DATE COMMENT 'The date on which the corrective action was formally closed. Null if the action remains open.',
    `closure_status` STRING COMMENT 'Final closure status of the corrective action. Closed_verified indicates successful completion and verification; closed_unverified indicates administrative closure without full verification; cancelled indicates the action was deemed unnecessary.. Valid values are `open|closed_verified|closed_unverified|cancelled`',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for estimated and actual costs (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this corrective action record was first created in the system. Used for audit trail and data lineage.',
    `days_to_complete` STRING COMMENT 'The number of calendar days between identification and actual completion. Used for performance measurement and SLA compliance tracking.',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Estimated financial cost to implement the corrective action, including labor, materials, equipment, and external services. Used for budgeting and cost-benefit analysis.',
    `identified_date` DATE COMMENT 'The date on which the need for this corrective action was identified, typically the date of the source incident, audit finding, or drill deficiency.',
    `isps_compliance_impact` STRING COMMENT 'Assessment of the impact of the underlying deficiency on ISPS Code compliance. Critical impact indicates a material breach requiring immediate remediation and potential regulatory notification.. Valid values are `no_impact|minor_impact|major_impact|critical_impact`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this corrective action record was last updated. Used for audit trail and change tracking.',
    `marsec_level` STRING COMMENT 'The Maritime Security level in effect at the time the corrective action was identified. MARSEC levels (1, 2, 3) indicate escalating threat conditions and corresponding security measures.. Valid values are `MARSEC_1|MARSEC_2|MARSEC_3`',
    `overdue_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the corrective action is past its target completion date without being closed. True indicates overdue status requiring escalation.',
    `pfso_name` STRING COMMENT 'Full name of the Port Facility Security Officer overseeing this corrective action. Denormalized for audit trail and reporting.',
    `preventive_action_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether this action is preventive (addressing potential future issues) rather than corrective (addressing existing deficiencies). True indicates preventive action.',
    `recurrence_prevention_measures` STRING COMMENT 'Description of measures implemented to prevent recurrence of the underlying issue, such as policy changes, training programs, or system enhancements.',
    `regulatory_notification_date` DATE COMMENT 'The date on which regulatory authorities were notified of the deficiency and corrective action plan. Null if notification was not required or has not yet occurred.',
    `regulatory_notification_required_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the underlying deficiency requires notification to regulatory authorities (e.g., port state control, national maritime authority). True indicates notification is required.',
    `related_action_ids` STRING COMMENT 'Comma-separated list of related corrective action IDs that address the same root cause or are part of a coordinated remediation effort. Enables tracking of action clusters.',
    `remarks` STRING COMMENT 'Additional free-text notes, comments, or context regarding the corrective action, including lessons learned, challenges encountered, or recommendations for future improvements.',
    `responsible_department` STRING COMMENT 'The organizational department or unit responsible for executing the corrective action (e.g., Port Security, IT Security, Operations, Facilities).',
    `responsible_officer_name` STRING COMMENT 'Full name of the security officer or personnel responsible for implementing the corrective action. Denormalized for reporting convenience.',
    `root_cause_analysis_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether a formal root cause analysis was conducted for the underlying issue. True indicates RCA was performed.',
    `root_cause_summary` STRING COMMENT 'Summary of the root cause identified through analysis. Describes the underlying systemic or procedural failure that necessitated the corrective action.',
    `security_plan_amendment_reference` STRING COMMENT 'Reference number or identifier of the Facility Security Plan amendment that incorporates this corrective action. Null if no amendment was required.',
    `security_plan_amendment_required_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the corrective action necessitates an amendment to the Facility Security Plan (FSP). True indicates FSP update is required.',
    `source_reference_code` STRING COMMENT 'The identifier of the originating record (incident ID, audit ID, drill ID, threat assessment ID) that generated this corrective action. Enables traceability back to the root cause event.',
    `source_type` STRING COMMENT 'The type of security event or activity that triggered this corrective action. Distinguishes whether the action arose from an incident, audit finding, drill deficiency, threat assessment recommendation, vulnerability scan result, or compliance review.. Valid values are `security_incident|security_audit|security_drill|threat_assessment|vulnerability_scan|compliance_review`',
    `target_completion_date` DATE COMMENT 'The planned or required date by which the corrective action must be completed. Used for tracking compliance with remediation timelines and Service Level Agreements (SLA).',
    `verification_date` DATE COMMENT 'The date on which the corrective action was verified as effective and complete. Null if verification has not yet occurred.',
    `verification_method` STRING COMMENT 'The method used to verify that the corrective action has been effectively implemented and the underlying issue resolved. May include document review, physical inspection, system testing, drill exercises, or follow-up audits. [ENUM-REF-CANDIDATE: document_review|physical_inspection|system_test|drill_exercise|audit|observation|interview — 7 candidates stripped; promote to reference product]',
    `verification_notes` STRING COMMENT 'Detailed notes from the verification officer documenting findings, evidence reviewed, and rationale for the verification outcome.',
    `verification_officer_name` STRING COMMENT 'Full name of the officer or auditor who verified the corrective action. Denormalized for audit trail purposes.',
    `verification_outcome` STRING COMMENT 'The result of the verification process. Effective indicates the action resolved the issue; partially effective or ineffective may trigger additional corrective actions.. Valid values are `effective|partially_effective|ineffective|pending`',
    CONSTRAINT pk_security_corrective_action PRIMARY KEY(`security_corrective_action_id`)
) COMMENT 'Corrective and preventive action (CAPA) records arising specifically from security incidents, security audits, security drills, and threat assessments within the security domain. Captures action identifier, source type (incident, audit, drill, threat assessment), source reference, action description, action category (procedural, physical, technical, training), responsible officer, target completion date, actual completion date, verification method, verification officer, and closure status. Distinct from safety.corrective_action which covers OHS/safety CAPAs — this is the SSOT for security-domain corrective actions.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` (
    `zone_access_authorization_id` BIGINT COMMENT 'Unique identifier for this zone access authorization record. Primary key.',
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to the access credential that is authorized for zone access',
    `zone_id` BIGINT COMMENT 'Foreign key linking to the security zone for which access is authorized',
    `access_count` STRING COMMENT 'Total number of times this credential has been used to access this zone. Used for usage analytics and audit.',
    `access_level` STRING COMMENT 'Level of access granted to the credential holder within this specific zone. Determines what activities are permitted.',
    `authorization_date` DATE COMMENT 'Date on which this zone access authorization was officially granted and recorded in the system.',
    `authorization_granted_by` STRING COMMENT 'Name or identifier of the security officer or zone manager who granted this specific zone access authorization.',
    `authorization_status` STRING COMMENT 'Current lifecycle status of this zone access authorization. Controls whether access control systems enforce this authorization.',
    `business_justification` STRING COMMENT 'Business reason or operational justification for granting this zone access authorization. Examples: assigned_to_zone, project_requirement, maintenance_contract, emergency_response_team.',
    `effective_from_date` DATE COMMENT 'Date from which this zone access authorization becomes active and enforceable.',
    `effective_to_date` DATE COMMENT 'Date on which this zone access authorization expires or is scheduled for review. Nullable for indefinite authorizations subject to credential expiry.',
    `escort_required_flag` BOOLEAN COMMENT 'Indicates whether the credential holder must be accompanied by an authorized escort when accessing this specific zone. Zone-specific override of credential-level escort requirement.',
    `last_access_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful access to this zone using this credential. Used for audit and anomaly detection.',
    `marsec_level_override` STRING COMMENT 'Zone-specific MARSEC level override for this credential. If set, this authorization is only valid at the specified MARSEC level, overriding the credentials general marsec_level_access.',
    `next_review_due_date` DATE COMMENT 'Scheduled date for the next mandatory review of this zone access authorization. Used for compliance with periodic access recertification requirements.',
    `review_date` DATE COMMENT 'Date when this zone access authorization was last reviewed for continued necessity and appropriateness. Used for periodic access recertification.',
    `revocation_date` DATE COMMENT 'Date on which this zone access authorization was permanently revoked. Nullable if never revoked.',
    `revocation_reason` STRING COMMENT 'Explanation for why this zone access authorization was revoked. Examples: security_breach, role_change, project_completion, credential_revoked.',
    `suspension_date` DATE COMMENT 'Date on which this zone access authorization was temporarily suspended. Nullable if never suspended.',
    `suspension_reason` STRING COMMENT 'Explanation for why this zone access authorization was suspended. Examples: security_incident, zone_maintenance, credential_under_review.',
    `time_restrictions` STRING COMMENT 'Temporal restrictions on when this credential can access this zone. Examples: 24/7, business_hours_only, 0600-1800, weekdays_only.',
    `zone_access_entitlements` STRING COMMENT 'Comma-separated list of port security zone codes or identifiers that this credential authorizes access to. Examples include restricted areas, cargo handling zones, vessel berths, and administrative buildings. [Moved from access_credential: This comma-separated list of zone codes in access_credential is a denormalized representation of the many-to-many relationship. Each zone entitlement should be a separate record in zone_access_authorization with its own access_level, time_restrictions, and lifecycle attributes. The current attribute conflates multiple authorizations into a single string, preventing proper tracking of zone-specific access rules and authorization history.]',
    CONSTRAINT pk_zone_access_authorization PRIMARY KEY(`zone_access_authorization_id`)
) COMMENT 'This association product represents the authorization relationship between access credentials and security zones within the port facility. It captures the specific access permissions granted to each credential for each zone, including access level, temporal restrictions, escort requirements, and authorization lifecycle. Each record links one access credential to one security zone with attributes that exist only in the context of this specific authorization. This is a core operational entity for ISPS Code compliance and access control enforcement.. Existence Justification: Port security operations explicitly manage which credentials are authorized to access which zones, with each authorization having zone-specific rules (access level, time restrictions, escort requirements) and its own lifecycle (granted, active, suspended, revoked). A single credential can be authorized for multiple zones (e.g., a port employee with access to terminal area, cargo storage, and administration building), and each zone has multiple authorized credentials (all personnel assigned to that zone). Security officers actively create, review, suspend, and revoke these authorizations as part of ISPS Code compliance and operational access control.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` (
    `patrol_route_id` BIGINT COMMENT 'Primary key for patrol_route',
    `facility_id` BIGINT COMMENT 'Reference to the port facility where this patrol route is established.',
    `parent_patrol_route_id` BIGINT COMMENT 'Self-referencing FK on patrol_route (parent_patrol_route_id)',
    `personnel_id` BIGINT COMMENT 'Reference to the Port Facility Security Officer (PFSO) or security manager responsible for this patrol route.',
    `risk_assessment_id` BIGINT COMMENT 'Reference to the facility security assessment that determined the need for this patrol route.',
    `infrastructure_terminal_id` BIGINT COMMENT 'Reference to the specific terminal within the port facility where this patrol route operates.',
    `access_control_points` STRING COMMENT 'Number of access control points or gates that must be verified during the patrol route.',
    `approval_date` DATE COMMENT 'Date when the patrol route was officially approved by the designated security authority.',
    `approved_by_authority` STRING COMMENT 'Name of the regulatory authority or designated security authority that approved this patrol route.',
    `cctv_coverage_percentage` DECIMAL(18,2) COMMENT 'Percentage of the patrol route covered by CCTV surveillance systems for monitoring and verification.',
    `checkpoint_count` STRING COMMENT 'Number of designated checkpoints or verification points along the patrol route.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this patrol route record was first created in the security management system.',
    `effective_from_date` DATE COMMENT 'Date when this patrol route became or will become operational in the facility security plan.',
    `effective_to_date` DATE COMMENT 'Date when this patrol route is scheduled to be discontinued or replaced. Null for indefinite routes.',
    `emergency_response_time_minutes` STRING COMMENT 'Maximum acceptable time in minutes for security response team to reach any point on this patrol route.',
    `end_location` STRING COMMENT 'Designated ending point or location for the patrol route within the port facility.',
    `estimated_duration_minutes` STRING COMMENT 'Expected time in minutes required to complete one full patrol of the route under normal conditions.',
    `gps_tracking_required` BOOLEAN COMMENT 'Indicates whether security personnel must use GPS tracking devices when patrolling this route for verification.',
    `incident_count_last_year` STRING COMMENT 'Number of security incidents reported along this patrol route in the previous 12-month period.',
    `isps_compliance_flag` BOOLEAN COMMENT 'Indicates whether this patrol route meets all ISPS Code requirements for port facility security.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this patrol route record was last updated in the security management system.',
    `last_review_date` DATE COMMENT 'Date when this patrol route was last reviewed and validated as part of security plan maintenance.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next mandatory review of this patrol route effectiveness and relevance.',
    `night_patrol_required` BOOLEAN COMMENT 'Indicates whether this route requires dedicated patrol coverage during night hours.',
    `notes` STRING COMMENT 'Additional notes, observations, or historical information about the patrol route for operational reference.',
    `patrol_frequency_per_shift` STRING COMMENT 'Required number of times this route must be patrolled during a single security shift.',
    `patrol_mode` STRING COMMENT 'Primary method of transportation used by security personnel when conducting patrols on this route.',
    `priority_level` STRING COMMENT 'Priority classification of the patrol route based on risk assessment and strategic importance of the area covered.',
    `requires_armed_patrol` BOOLEAN COMMENT 'Indicates whether security personnel conducting this patrol must be armed according to facility security plan.',
    `requires_two_person_patrol` BOOLEAN COMMENT 'Indicates whether this route requires a minimum of two security personnel for safety or security protocol compliance.',
    `restricted_area_flag` BOOLEAN COMMENT 'Indicates whether the patrol route passes through or monitors restricted areas requiring special clearance.',
    `route_code` STRING COMMENT 'Unique alphanumeric business identifier for the patrol route used in security operations and reporting.',
    `route_description` STRING COMMENT 'Detailed description of the patrol route including key landmarks, checkpoints, and areas of focus.',
    `route_distance_meters` DECIMAL(18,2) COMMENT 'Total distance of the patrol route measured in meters for planning and resource allocation.',
    `route_name` STRING COMMENT 'Human-readable name of the patrol route for operational reference and communication.',
    `route_status` STRING COMMENT 'Current operational status of the patrol route in the security management system.',
    `route_type` STRING COMMENT 'Classification of the patrol route based on the area of coverage within the port facility.',
    `security_level` STRING COMMENT 'ISPS Code security level for which this patrol route is designed. Level 1 is normal operations, Level 2 is heightened risk, Level 3 is imminent threat.',
    `special_instructions` STRING COMMENT 'Additional operational instructions or protocols specific to this patrol route for security personnel.',
    `start_location` STRING COMMENT 'Designated starting point or location for the patrol route within the port facility.',
    `version_number` STRING COMMENT 'Version number of the patrol route configuration for change tracking and audit purposes.',
    `waterside_interface_flag` BOOLEAN COMMENT 'Indicates whether the patrol route includes monitoring of the waterside perimeter or vessel interface areas.',
    `weather_dependent` BOOLEAN COMMENT 'Indicates whether patrol operations on this route are affected by weather conditions requiring alternative procedures.',
    CONSTRAINT pk_patrol_route PRIMARY KEY(`patrol_route_id`)
) COMMENT 'Master reference table for patrol_route. Referenced by route_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ADD CONSTRAINT `fk_security_facility_security_plan_superseded_facility_security_plan_id` FOREIGN KEY (`superseded_facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ADD CONSTRAINT `fk_security_zone_parent_zone_id` FOREIGN KEY (`parent_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ADD CONSTRAINT `fk_security_access_credential_replaced_access_credential_id` FOREIGN KEY (`replaced_access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_access_point_id` FOREIGN KEY (`access_point_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_point`(`access_point_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_correlated_access_event_id` FOREIGN KEY (`correlated_access_event_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_event`(`access_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ADD CONSTRAINT `fk_security_access_point_parent_access_point_id` FOREIGN KEY (`parent_access_point_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_point`(`access_point_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ADD CONSTRAINT `fk_security_access_point_post_id` FOREIGN KEY (`post_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`post`(`post_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ADD CONSTRAINT `fk_security_access_point_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ADD CONSTRAINT `fk_security_cctv_camera_access_point_id` FOREIGN KEY (`access_point_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_point`(`access_point_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ADD CONSTRAINT `fk_security_cctv_camera_replaced_cctv_camera_id` FOREIGN KEY (`replaced_cctv_camera_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cctv_camera`(`cctv_camera_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ADD CONSTRAINT `fk_security_cctv_camera_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ADD CONSTRAINT `fk_security_cctv_incident_clip_cctv_camera_id` FOREIGN KEY (`cctv_camera_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cctv_camera`(`cctv_camera_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ADD CONSTRAINT `fk_security_cctv_incident_clip_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ADD CONSTRAINT `fk_security_cctv_incident_clip_source_cctv_incident_clip_id` FOREIGN KEY (`source_cctv_incident_clip_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip`(`cctv_incident_clip_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ADD CONSTRAINT `fk_security_patrol_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ADD CONSTRAINT `fk_security_patrol_patrol_route_id` FOREIGN KEY (`patrol_route_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`patrol_route`(`patrol_route_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ADD CONSTRAINT `fk_security_patrol_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ADD CONSTRAINT `fk_security_patrol_relieved_patrol_id` FOREIGN KEY (`relieved_patrol_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`patrol`(`patrol_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ADD CONSTRAINT `fk_security_patrol_tertiary_patrol_supervisor_security_personnel_id` FOREIGN KEY (`tertiary_patrol_supervisor_security_personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_escalated_security_incident_id` FOREIGN KEY (`escalated_security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ADD CONSTRAINT `fk_security_investigation_cyber_incident_id` FOREIGN KEY (`cyber_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cyber_incident`(`cyber_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ADD CONSTRAINT `fk_security_investigation_parent_investigation_id` FOREIGN KEY (`parent_investigation_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`investigation`(`investigation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ADD CONSTRAINT `fk_security_investigation_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ADD CONSTRAINT `fk_security_investigation_stowaway_case_id` FOREIGN KEY (`stowaway_case_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`stowaway_case`(`stowaway_case_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ADD CONSTRAINT `fk_security_threat_assessment_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ADD CONSTRAINT `fk_security_threat_assessment_primary_superseded_by_assessment_threat_assessment_id` FOREIGN KEY (`primary_superseded_by_assessment_threat_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`threat_assessment`(`threat_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ADD CONSTRAINT `fk_security_marsec_level_change_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ADD CONSTRAINT `fk_security_marsec_level_change_primary_superseded_by_change_marsec_level_change_id` FOREIGN KEY (`primary_superseded_by_change_marsec_level_change_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`marsec_level_change`(`marsec_level_change_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ADD CONSTRAINT `fk_security_marsec_level_change_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ADD CONSTRAINT `fk_security_dos_record_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ADD CONSTRAINT `fk_security_dos_record_marsec_level_change_id` FOREIGN KEY (`marsec_level_change_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`marsec_level_change`(`marsec_level_change_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ADD CONSTRAINT `fk_security_dos_record_superseded_dos_record_id` FOREIGN KEY (`superseded_dos_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`dos_record`(`dos_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ADD CONSTRAINT `fk_security_drill_escalated_drill_id` FOREIGN KEY (`escalated_drill_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`drill`(`drill_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ADD CONSTRAINT `fk_security_drill_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ADD CONSTRAINT `fk_security_drill_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ADD CONSTRAINT `fk_security_security_audit_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ADD CONSTRAINT `fk_security_security_audit_follow_up_security_audit_id` FOREIGN KEY (`follow_up_security_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_audit`(`security_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ADD CONSTRAINT `fk_security_security_audit_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ADD CONSTRAINT `fk_security_stowaway_case_parent_stowaway_case_id` FOREIGN KEY (`parent_stowaway_case_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`stowaway_case`(`stowaway_case_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ADD CONSTRAINT `fk_security_stowaway_case_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ADD CONSTRAINT `fk_security_stowaway_case_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ADD CONSTRAINT `fk_security_watchlist_entry_superseded_watchlist_entry_id` FOREIGN KEY (`superseded_watchlist_entry_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`watchlist_entry`(`watchlist_entry_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ADD CONSTRAINT `fk_security_screening_record_access_point_id` FOREIGN KEY (`access_point_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_point`(`access_point_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ADD CONSTRAINT `fk_security_screening_record_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ADD CONSTRAINT `fk_security_screening_record_rescreened_screening_record_id` FOREIGN KEY (`rescreened_screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ADD CONSTRAINT `fk_security_screening_record_watchlist_entry_id` FOREIGN KEY (`watchlist_entry_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`watchlist_entry`(`watchlist_entry_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ADD CONSTRAINT `fk_security_screening_record_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ADD CONSTRAINT `fk_security_cyber_incident_cyber_risk_register_id` FOREIGN KEY (`cyber_risk_register_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cyber_risk_register`(`cyber_risk_register_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ADD CONSTRAINT `fk_security_cyber_incident_parent_cyber_incident_id` FOREIGN KEY (`parent_cyber_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cyber_incident`(`cyber_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ADD CONSTRAINT `fk_security_cyber_risk_register_parent_cyber_risk_register_id` FOREIGN KEY (`parent_cyber_risk_register_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cyber_risk_register`(`cyber_risk_register_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ADD CONSTRAINT `fk_security_personnel_post_id` FOREIGN KEY (`post_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`post`(`post_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ADD CONSTRAINT `fk_security_personnel_supervisor_personnel_id` FOREIGN KEY (`supervisor_personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ADD CONSTRAINT `fk_security_post_parent_post_id` FOREIGN KEY (`parent_post_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`post`(`post_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ADD CONSTRAINT `fk_security_post_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ADD CONSTRAINT `fk_security_visitor_log_escorted_by_visitor_log_id` FOREIGN KEY (`escorted_by_visitor_log_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`visitor_log`(`visitor_log_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ADD CONSTRAINT `fk_security_visitor_log_access_point_id` FOREIGN KEY (`access_point_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_point`(`access_point_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ADD CONSTRAINT `fk_security_visitor_log_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ADD CONSTRAINT `fk_security_security_equipment_replaced_security_equipment_id` FOREIGN KEY (`replaced_security_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_equipment`(`security_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ADD CONSTRAINT `fk_security_security_equipment_post_id` FOREIGN KEY (`post_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`post`(`post_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ADD CONSTRAINT `fk_security_security_equipment_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ADD CONSTRAINT `fk_security_mda_observation_correlated_mda_observation_id` FOREIGN KEY (`correlated_mda_observation_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`mda_observation`(`mda_observation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ADD CONSTRAINT `fk_security_mda_observation_patrol_id` FOREIGN KEY (`patrol_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`patrol`(`patrol_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ADD CONSTRAINT `fk_security_mda_observation_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ADD CONSTRAINT `fk_security_mda_observation_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ADD CONSTRAINT `fk_security_mda_observation_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_cyber_incident_id` FOREIGN KEY (`cyber_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cyber_incident`(`cyber_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_drill_id` FOREIGN KEY (`drill_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`drill`(`drill_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_parent_security_corrective_action_id` FOREIGN KEY (`parent_security_corrective_action_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_corrective_action`(`security_corrective_action_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_security_audit_id` FOREIGN KEY (`security_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_audit`(`security_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_threat_assessment_id` FOREIGN KEY (`threat_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`threat_assessment`(`threat_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ADD CONSTRAINT `fk_security_zone_access_authorization_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ADD CONSTRAINT `fk_security_zone_access_authorization_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ADD CONSTRAINT `fk_security_patrol_route_parent_patrol_route_id` FOREIGN KEY (`parent_patrol_route_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`patrol_route`(`patrol_route_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ADD CONSTRAINT `fk_security_patrol_route_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`security` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`security` SET TAGS ('dbx_domain' = 'security');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` SET TAGS ('dbx_subdomain' = 'isps_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Port Facility ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `superseded_facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Facility Security Plan Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `superseded_facility_security_plan_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `access_control_system_type` SET TAGS ('dbx_business_glossary_term' = 'Access Control System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `amendment_count` SET TAGS ('dbx_business_glossary_term' = 'Amendment Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `approval_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `cctv_coverage_percentage` SET TAGS ('dbx_business_glossary_term' = 'CCTV Coverage Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `compliance_certificate_expiry` SET TAGS ('dbx_business_glossary_term' = 'ISPS Compliance Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `cybersecurity_measures_included` SET TAGS ('dbx_business_glossary_term' = 'Cybersecurity Measures Included Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `document_classification` SET TAGS ('dbx_business_glossary_term' = 'Document Classification Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `document_classification` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `document_storage_location` SET TAGS ('dbx_business_glossary_term' = 'Document Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `document_storage_location` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `drill_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Security Drill Frequency (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `last_amendment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Amendment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `last_amendment_description` SET TAGS ('dbx_business_glossary_term' = 'Last Amendment Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `last_audit_outcome` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `last_audit_outcome` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|conditional|not_audited');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `last_drill_date` SET TAGS ('dbx_business_glossary_term' = 'Last Security Drill Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `marsec_level_1_measures` SET TAGS ('dbx_business_glossary_term' = 'MARSEC Level 1 Security Measures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `marsec_level_1_measures` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `marsec_level_2_measures` SET TAGS ('dbx_business_glossary_term' = 'MARSEC Level 2 Security Measures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `marsec_level_2_measures` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `marsec_level_3_measures` SET TAGS ('dbx_business_glossary_term' = 'MARSEC Level 3 Security Measures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `marsec_level_3_measures` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `next_drill_date` SET TAGS ('dbx_business_glossary_term' = 'Next Security Drill Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `patrol_frequency_hours` SET TAGS ('dbx_business_glossary_term' = 'Security Patrol Frequency (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_contact_number` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Contact Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_contact_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_contact_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_email_address` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_email_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `pfso_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `plan_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Plan Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `plan_reference_number` SET TAGS ('dbx_value_regex' = '^PFSP-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `plan_scope_description` SET TAGS ('dbx_business_glossary_term' = 'Plan Scope Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Plan Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}.[0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Plan Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `review_cycle_months` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle Period (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `security_assessment_reference` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Assessment (PFSA) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `security_assessment_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `threat_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Threat Assessment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ALTER COLUMN `training_program_reference` SET TAGS ('dbx_business_glossary_term' = 'Security Training Program Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` SET TAGS ('dbx_subdomain' = 'isps_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `parent_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Zone Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `parent_zone_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Manager ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `tertiary_zone_manager_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Zone Manager Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `tertiary_zone_manager_employee_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `access_control_requirement_marsec1` SET TAGS ('dbx_business_glossary_term' = 'Access Control Requirement at Maritime Security (MARSEC) Level 1');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `access_control_requirement_marsec2` SET TAGS ('dbx_business_glossary_term' = 'Access Control Requirement at Maritime Security (MARSEC) Level 2');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `access_control_requirement_marsec3` SET TAGS ('dbx_business_glossary_term' = 'Access Control Requirement at Maritime Security (MARSEC) Level 3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `access_point_count` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Access Point Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `area_square_meters` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Area in Square Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `boundary_description` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Boundary Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `boundary_gis_polygon` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Boundary Geographic Information System (GIS) Polygon');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `cctv_camera_count` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Camera Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `cctv_coverage_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Coverage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `zone_code` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `critical_infrastructure_flag` SET TAGS ('dbx_business_glossary_term' = 'Critical Infrastructure Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `cybersecurity_zone_flag` SET TAGS ('dbx_business_glossary_term' = 'Cybersecurity Zone Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `emergency_assembly_point` SET TAGS ('dbx_business_glossary_term' = 'Emergency Assembly Point Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `incident_count_ytd` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Count Year-to-Date (YTD)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `incident_count_ytd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `last_incident_date` SET TAGS ('dbx_business_glossary_term' = 'Last Security Incident Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `last_incident_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `last_risk_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Security Risk Assessment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `lighting_adequacy_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Lighting Adequacy Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `marsec_level_applicability` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `marsec_level_applicability` SET TAGS ('dbx_value_regex' = 'marsec_1|marsec_2|marsec_3|all_levels');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Record Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `next_risk_assessment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Security Risk Assessment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `operational_hours` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Operational Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `patrol_frequency_hours` SET TAGS ('dbx_business_glossary_term' = 'Security Patrol Frequency in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `patrol_type` SET TAGS ('dbx_business_glossary_term' = 'Security Patrol Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `patrol_type` SET TAGS ('dbx_value_regex' = 'foot_patrol|vehicle_patrol|marine_patrol|combined_patrol|remote_monitoring');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `perimeter_fencing_type` SET TAGS ('dbx_business_glossary_term' = 'Perimeter Fencing Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `perimeter_fencing_type` SET TAGS ('dbx_value_regex' = 'chain_link|concrete_wall|steel_barrier|water_barrier|none|mixed');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `pfsp_reference_section` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Plan (PFSP) Reference Section');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `pfsp_reference_section` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `restricted_cargo_types` SET TAGS ('dbx_business_glossary_term' = 'Restricted Cargo Types');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `threat_level` SET TAGS ('dbx_business_glossary_term' = 'Security Threat Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `threat_level` SET TAGS ('dbx_value_regex' = 'low|moderate|elevated|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `threat_level` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `zone_status` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `zone_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|under_review|decommissioned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `zone_type` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ALTER COLUMN `zone_type` SET TAGS ('dbx_value_regex' = 'restricted_area|controlled_area|public_area|exclusion_zone|buffer_zone|critical_infrastructure_zone');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Access Credential Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `replaced_access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Replaced Access Credential Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `replaced_access_credential_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `access_attempt_count` SET TAGS ('dbx_business_glossary_term' = 'Access Attempt Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `access_time_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Access Time Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `background_check_date` SET TAGS ('dbx_business_glossary_term' = 'Background Check Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `background_check_status` SET TAGS ('dbx_business_glossary_term' = 'Background Check Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `background_check_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|failed|expired|not_required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `biometric_enrolled` SET TAGS ('dbx_business_glossary_term' = 'Biometric Enrolled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `biometric_enrolled` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `biometric_enrolled` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `biometric_modality` SET TAGS ('dbx_business_glossary_term' = 'Biometric Modality');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `biometric_modality` SET TAGS ('dbx_value_regex' = 'fingerprint|facial_recognition|iris_scan|palm_vein|none');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `biometric_modality` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `biometric_modality` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `credential_number` SET TAGS ('dbx_business_glossary_term' = 'Credential Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `credential_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `credential_status` SET TAGS ('dbx_business_glossary_term' = 'Credential Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `credential_type` SET TAGS ('dbx_business_glossary_term' = 'Credential Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `credential_type` SET TAGS ('dbx_value_regex' = 'port_id_card|vehicle_pass|visitor_pass|contractor_badge|biometric_token|temporary_pass');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `escort_required` SET TAGS ('dbx_business_glossary_term' = 'Escort Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `failed_access_count` SET TAGS ('dbx_business_glossary_term' = 'Failed Access Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_email` SET TAGS ('dbx_business_glossary_term' = 'Holder Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_full_name` SET TAGS ('dbx_business_glossary_term' = 'Holder Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_national_identifier` SET TAGS ('dbx_business_glossary_term' = 'Holder National Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_national_identifier` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_national_identifier` SET TAGS ('dbx_pii_national_id' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_organization` SET TAGS ('dbx_business_glossary_term' = 'Holder Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_phone` SET TAGS ('dbx_business_glossary_term' = 'Holder Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_type` SET TAGS ('dbx_business_glossary_term' = 'Holder Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `holder_type` SET TAGS ('dbx_value_regex' = 'employee|contractor|visitor|vendor|government_official|service_provider');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `last_access_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Access Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `marsec_level_access` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level Access');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `marsec_level_access` SET TAGS ('dbx_value_regex' = 'marsec_1|marsec_2|marsec_3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `photo_reference` SET TAGS ('dbx_business_glossary_term' = 'Photo Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `renewal_notification_sent` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notification Sent Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `revoked_by` SET TAGS ('dbx_business_glossary_term' = 'Revoked By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `rfid_tag_number` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `rfid_tag_number` SET TAGS ('dbx_value_regex' = '^[A-F0-9]{16,24}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `sponsor_contact` SET TAGS ('dbx_business_glossary_term' = 'Sponsor Contact');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `sponsor_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `sponsor_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `sponsor_name` SET TAGS ('dbx_business_glossary_term' = 'Sponsor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `training_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Training Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_event_id` SET TAGS ('dbx_business_glossary_term' = 'Access Event ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Credential ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_point_id` SET TAGS ('dbx_business_glossary_term' = 'Access Point ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `correlated_access_event_id` SET TAGS ('dbx_business_glossary_term' = 'Correlated Access Event Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `correlated_access_event_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Person ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Escort Person ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_control_system_code` SET TAGS ('dbx_business_glossary_term' = 'Access Control System ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_decision` SET TAGS ('dbx_business_glossary_term' = 'Access Decision');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_decision` SET TAGS ('dbx_value_regex' = 'granted|denied|alarm|forced|tailgate|override');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Access Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_point_type` SET TAGS ('dbx_business_glossary_term' = 'Access Point Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_point_type` SET TAGS ('dbx_value_regex' = 'vehicle_gate|pedestrian_gate|turnstile|door|barrier|bollard');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `access_purpose` SET TAGS ('dbx_business_glossary_term' = 'Access Purpose');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `alarm_triggered_flag` SET TAGS ('dbx_business_glossary_term' = 'Alarm Triggered Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `alarm_type` SET TAGS ('dbx_business_glossary_term' = 'Alarm Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `alarm_type` SET TAGS ('dbx_value_regex' = 'forced_entry|tailgating|invalid_credential|unauthorized_zone|duress|system_tamper');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `anti_passback_violation_flag` SET TAGS ('dbx_business_glossary_term' = 'Anti-Passback Violation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `audit_trail_hash` SET TAGS ('dbx_business_glossary_term' = 'Audit Trail Hash');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `biometric_match_score` SET TAGS ('dbx_business_glossary_term' = 'Biometric Match Score');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `biometric_match_score` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `biometric_match_score` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `cctv_clip_reference` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Clip Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `credential_number` SET TAGS ('dbx_business_glossary_term' = 'Credential Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `credential_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `credential_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `credential_type` SET TAGS ('dbx_business_glossary_term' = 'Credential Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `credential_type` SET TAGS ('dbx_value_regex' = 'rfid_card|biometric|pin|qr_code|vehicle_tag|visitor_pass');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `denial_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Denial Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `device_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Device Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `direction` SET TAGS ('dbx_business_glossary_term' = 'Access Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `direction` SET TAGS ('dbx_value_regex' = 'inbound|outbound');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `escort_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Escort Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `event_source_ip_address` SET TAGS ('dbx_business_glossary_term' = 'Event Source Internet Protocol (IP) Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `event_source_ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Event Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'entry|exit|entry_attempt|exit_attempt|alarm|override');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Event Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `organization_name` SET TAGS ('dbx_business_glossary_term' = 'Organization Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `override_authorized_by` SET TAGS ('dbx_business_glossary_term' = 'Override Authorized By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `override_reason` SET TAGS ('dbx_business_glossary_term' = 'Override Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `person_name` SET TAGS ('dbx_business_glossary_term' = 'Person Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `person_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `person_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `temperature_reading_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Reading Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `time_zone_restriction_violated_flag` SET TAGS ('dbx_business_glossary_term' = 'Time Zone Restriction Violated Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `vehicle_registration` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `vehicle_registration` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `vehicle_registration` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `visitor_flag` SET TAGS ('dbx_business_glossary_term' = 'Visitor Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `zone_classification` SET TAGS ('dbx_business_glossary_term' = 'Zone Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ALTER COLUMN `zone_classification` SET TAGS ('dbx_value_regex' = 'public|restricted|high_security|critical_infrastructure');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_point_id` SET TAGS ('dbx_business_glossary_term' = 'Access Point Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `facility_building_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Building Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `parent_access_point_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Access Point Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `parent_access_point_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `post_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Security Post Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_level_required` SET TAGS ('dbx_business_glossary_term' = 'Access Level Required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_level_required` SET TAGS ('dbx_value_regex' = 'public|restricted|confidential|high_security');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_point_type` SET TAGS ('dbx_business_glossary_term' = 'Access Point Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_point_type` SET TAGS ('dbx_value_regex' = 'pedestrian_gate|vehicle_gate|turnstile|restricted_area_door|waterside_access|rail_access');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `alarm_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Alarm Integration Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `anti_tailgating_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Anti-Tailgating Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `automation_level` SET TAGS ('dbx_business_glossary_term' = 'Automation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `automation_level` SET TAGS ('dbx_value_regex' = 'fully_automated|semi_automated|manual');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `barrier_type` SET TAGS ('dbx_business_glossary_term' = 'Barrier Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `cctv_camera_ids` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Camera Identifiers (IDs)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `cctv_coverage_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Coverage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_point_code` SET TAGS ('dbx_business_glossary_term' = 'Access Point Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_point_code` SET TAGS ('dbx_value_regex' = '^AP-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `compliance_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `control_technology_type` SET TAGS ('dbx_business_glossary_term' = 'Control Technology Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `direction_control` SET TAGS ('dbx_business_glossary_term' = 'Direction Control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `direction_control` SET TAGS ('dbx_value_regex' = 'entry_only|exit_only|bidirectional');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `emergency_exit_flag` SET TAGS ('dbx_business_glossary_term' = 'Emergency Exit Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `integration_system_code` SET TAGS ('dbx_business_glossary_term' = 'Integration System Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `intercom_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercom Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `location_description` SET TAGS ('dbx_business_glossary_term' = 'Location Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `access_point_name` SET TAGS ('dbx_business_glossary_term' = 'Access Point Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `next_maintenance_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|inactive|maintenance|suspended|decommissioned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `secondary_control_technology` SET TAGS ('dbx_business_glossary_term' = 'Secondary Control Technology');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `throughput_capacity_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Throughput Capacity Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ALTER COLUMN `visitor_management_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Visitor Management Integration Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` SET TAGS ('dbx_subdomain' = 'surveillance_equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `cctv_camera_id` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Camera Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `replaced_cctv_camera_id` SET TAGS ('dbx_business_glossary_term' = 'Replaced Cctv Camera Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `replaced_cctv_camera_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `analytics_features` SET TAGS ('dbx_business_glossary_term' = 'Video Analytics Features');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `annual_maintenance_cost` SET TAGS ('dbx_business_glossary_term' = 'Annual Maintenance Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `annual_maintenance_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `asset_owner` SET TAGS ('dbx_business_glossary_term' = 'Asset Owner Department');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `camera_code` SET TAGS ('dbx_business_glossary_term' = 'Camera Asset Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `camera_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}-[A-Z]{2,4}-[0-9]{3,5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `camera_type` SET TAGS ('dbx_business_glossary_term' = 'Camera Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `camera_type` SET TAGS ('dbx_value_regex' = 'fixed|ptz|thermal|vessel_monitoring|license_plate_recognition|underwater');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `coverage_area_description` SET TAGS ('dbx_business_glossary_term' = 'Camera Coverage Area Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `criticality_level` SET TAGS ('dbx_business_glossary_term' = 'Camera Criticality Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `criticality_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `cybersecurity_zone` SET TAGS ('dbx_business_glossary_term' = 'Cybersecurity Network Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `cybersecurity_zone` SET TAGS ('dbx_value_regex' = 'ot_network|it_network|dmz|isolated|air_gapped');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `decommission_date` SET TAGS ('dbx_business_glossary_term' = 'Camera Decommission Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `environmental_rating` SET TAGS ('dbx_business_glossary_term' = 'Ingress Protection (IP) Environmental Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `environmental_rating` SET TAGS ('dbx_value_regex' = '^IP[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Camera Firmware Version');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `frame_rate_fps` SET TAGS ('dbx_business_glossary_term' = 'Video Frame Rate (Frames Per Second)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Camera Installation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `installation_location` SET TAGS ('dbx_business_glossary_term' = 'Camera Installation Location Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'Camera Internet Protocol (IP) Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `ip_address` SET TAGS ('dbx_value_regex' = '^(?:[0-9]{1,3}.){3}[0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_ip' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `last_firmware_update_date` SET TAGS ('dbx_business_glossary_term' = 'Last Firmware Update Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Service Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `last_online_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Online Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `mac_address` SET TAGS ('dbx_business_glossary_term' = 'Camera Media Access Control (MAC) Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `mac_address` SET TAGS ('dbx_value_regex' = '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `mac_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Camera Manufacturer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Camera Model Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `motion_detection_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Motion Detection Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `mounting_type` SET TAGS ('dbx_business_glossary_term' = 'Camera Mounting Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `mounting_type` SET TAGS ('dbx_value_regex' = 'pole_mount|wall_mount|ceiling_mount|gantry_mount|mobile_mount');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `next_maintenance_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `night_vision_capability_flag` SET TAGS ('dbx_business_glossary_term' = 'Night Vision Capability Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Camera Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Camera Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|offline|maintenance|faulty|decommissioned|testing');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `power_source_type` SET TAGS ('dbx_business_glossary_term' = 'Camera Power Source Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `power_source_type` SET TAGS ('dbx_value_regex' = 'poe|ac_mains|solar|battery_backup|hybrid');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `procurement_cost` SET TAGS ('dbx_business_glossary_term' = 'Camera Procurement Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `procurement_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `ptz_capability_flag` SET TAGS ('dbx_business_glossary_term' = 'Pan-Tilt-Zoom (PTZ) Capability Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `recording_resolution` SET TAGS ('dbx_business_glossary_term' = 'Video Recording Resolution');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `recording_resolution` SET TAGS ('dbx_value_regex' = '720p|1080p|2K|4K|5MP|8MP');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `retention_period_days` SET TAGS ('dbx_business_glossary_term' = 'Video Retention Period (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Camera Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `serial_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `vms_integration_status` SET TAGS ('dbx_business_glossary_term' = 'Video Management System (VMS) Integration Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `vms_integration_status` SET TAGS ('dbx_value_regex' = 'integrated|pending|failed|not_configured');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_camera` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Warranty Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` SET TAGS ('dbx_subdomain' = 'surveillance_equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `cctv_incident_clip_id` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Incident Clip Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `cctv_camera_id` SET TAGS ('dbx_business_glossary_term' = 'Camera Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Extracted By Officer Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `source_cctv_incident_clip_id` SET TAGS ('dbx_business_glossary_term' = 'Source Cctv Incident Clip Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `source_cctv_incident_clip_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `access_restriction_level` SET TAGS ('dbx_business_glossary_term' = 'Access Restriction Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `access_restriction_level` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted|classified');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `camera_location` SET TAGS ('dbx_business_glossary_term' = 'Camera Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `camera_zone` SET TAGS ('dbx_business_glossary_term' = 'Camera Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `chain_of_custody_log` SET TAGS ('dbx_business_glossary_term' = 'Chain of Custody Log');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `clip_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Clip Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `clip_reference_number` SET TAGS ('dbx_value_regex' = '^CLIP-[0-9]{8}-[A-Z0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `clip_status` SET TAGS ('dbx_business_glossary_term' = 'Clip Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `clip_status` SET TAGS ('dbx_value_regex' = 'extracted|under_review|preserved|released|archived|deleted');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Duration in Seconds');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Event Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `evidence_tag` SET TAGS ('dbx_business_glossary_term' = 'Evidence Tag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `extraction_reason` SET TAGS ('dbx_business_glossary_term' = 'Extraction Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `extraction_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Extraction Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'File Format');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'MP4|AVI|MOV|MKV|H264|H265');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `file_size_mb` SET TAGS ('dbx_business_glossary_term' = 'File Size in Megabytes (MB)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `footage_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Footage End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `footage_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Footage Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `frame_rate` SET TAGS ('dbx_business_glossary_term' = 'Frame Rate per Second (FPS)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `hash_checksum` SET TAGS ('dbx_business_glossary_term' = 'Hash Checksum');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `hash_checksum` SET TAGS ('dbx_value_regex' = '^[a-fA-F0-9]{64}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `investigation_status` SET TAGS ('dbx_business_glossary_term' = 'Investigation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `investigation_status` SET TAGS ('dbx_value_regex' = 'pending|active|closed|evidence_submitted|no_further_action');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `law_enforcement_agency` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Agency');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `law_enforcement_reference` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `law_enforcement_request_flag` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Request Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `release_authorization_document` SET TAGS ('dbx_business_glossary_term' = 'Release Authorization Document');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `release_date` SET TAGS ('dbx_business_glossary_term' = 'Release Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `released_to` SET TAGS ('dbx_business_glossary_term' = 'Released To');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `resolution` SET TAGS ('dbx_business_glossary_term' = 'Video Resolution');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `resolution` SET TAGS ('dbx_value_regex' = '^[0-9]{3,4}x[0-9]{3,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `retention_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Retention Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `retention_override_reason` SET TAGS ('dbx_business_glossary_term' = 'Retention Override Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `retention_period_days` SET TAGS ('dbx_business_glossary_term' = 'Retention Period in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_id` SET TAGS ('dbx_business_glossary_term' = 'Security Patrol Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `marine_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_route_id` SET TAGS ('dbx_business_glossary_term' = 'Patrol Route Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Backup Officer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `relieved_patrol_id` SET TAGS ('dbx_business_glossary_term' = 'Relieved Patrol Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `relieved_patrol_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `tertiary_patrol_supervisor_security_personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `access_control_checks` SET TAGS ('dbx_business_glossary_term' = 'Access Control Checks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `actual_end_time` SET TAGS ('dbx_business_glossary_term' = 'Actual End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `actual_start_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `anomalies_detected` SET TAGS ('dbx_business_glossary_term' = 'Anomalies Detected');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `anomaly_description` SET TAGS ('dbx_business_glossary_term' = 'Anomaly Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `anomaly_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `cctv_verification_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Verification Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `checkpoints_completed` SET TAGS ('dbx_business_glossary_term' = 'Checkpoints Completed');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `checkpoints_planned` SET TAGS ('dbx_business_glossary_term' = 'Checkpoints Planned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `distance_covered_km` SET TAGS ('dbx_business_glossary_term' = 'Distance Covered Kilometers (KM)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Patrol Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `equipment_used` SET TAGS ('dbx_business_glossary_term' = 'Equipment Used');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `incident_reported_flag` SET TAGS ('dbx_business_glossary_term' = 'Incident Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `lighting_verification_flag` SET TAGS ('dbx_business_glossary_term' = 'Lighting Verification Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `marsec_level` SET TAGS ('dbx_value_regex' = 'MARSEC 1|MARSEC 2|MARSEC 3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `non_compliance_reason` SET TAGS ('dbx_business_glossary_term' = 'Non-Compliance Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `non_compliance_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Patrol Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_number` SET TAGS ('dbx_business_glossary_term' = 'Patrol Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_number` SET TAGS ('dbx_value_regex' = '^PAT-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_status` SET TAGS ('dbx_business_glossary_term' = 'Patrol Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|suspended|aborted');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_type` SET TAGS ('dbx_business_glossary_term' = 'Patrol Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `patrol_type` SET TAGS ('dbx_value_regex' = 'foot|vehicle|waterside|perimeter|combined|roving');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `perimeter_integrity_flag` SET TAGS ('dbx_business_glossary_term' = 'Perimeter Integrity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `review_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Review Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `scheduled_end_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `supervisor_review_flag` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Review Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `vehicle_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `visibility_level` SET TAGS ('dbx_business_glossary_term' = 'Visibility Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `visibility_level` SET TAGS ('dbx_value_regex' = 'excellent|good|moderate|poor|very_poor');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` SET TAGS ('dbx_subdomain' = 'incident_investigation');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `escalated_security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Escalated Security Incident Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `escalated_security_incident_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reporting Officer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `access_control_logs_reference` SET TAGS ('dbx_business_glossary_term' = 'Access Control Logs Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `cargo_involved_flag` SET TAGS ('dbx_business_glossary_term' = 'Cargo Involved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `cctv_footage_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Footage Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `cctv_footage_reference` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Footage Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `closed_datetime` SET TAGS ('dbx_business_glossary_term' = 'Closed Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `corrective_actions` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `datetime` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `detected_by` SET TAGS ('dbx_business_glossary_term' = 'Detected By Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_business_glossary_term' = 'Estimated Financial Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `immediate_response_actions` SET TAGS ('dbx_business_glossary_term' = 'Immediate Response Actions');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `incident_number` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `incident_number` SET TAGS ('dbx_value_regex' = '^SI-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `incident_status` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `incident_status` SET TAGS ('dbx_value_regex' = 'reported|under_investigation|contained|resolved|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_value_regex' = 'unauthorised_access|perimeter_breach|theft|sabotage|stowaways|suspicious_behaviour');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `investigation_status` SET TAGS ('dbx_business_glossary_term' = 'Investigation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `investigation_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|closed_unresolved');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `law_enforcement_case_number` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Case Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `law_enforcement_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `lessons_learned` SET TAGS ('dbx_business_glossary_term' = 'Lessons Learned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `location_berth` SET TAGS ('dbx_business_glossary_term' = 'Location Berth');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `location_coordinates` SET TAGS ('dbx_business_glossary_term' = 'Location Coordinates');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `location_coordinates` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,3}.[0-9]+,-?[0-9]{1,3}.[0-9]+$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `location_gate` SET TAGS ('dbx_business_glossary_term' = 'Location Gate');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `marsec_level` SET TAGS ('dbx_value_regex' = 'MARSEC_1|MARSEC_2|MARSEC_3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `national_authority_escalated_datetime` SET TAGS ('dbx_business_glossary_term' = 'National Maritime Security Authority Escalated Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `national_authority_escalated_flag` SET TAGS ('dbx_business_glossary_term' = 'National Maritime Security Authority Escalated Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `operational_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `persons_involved_count` SET TAGS ('dbx_business_glossary_term' = 'Persons Involved Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `persons_involved_description` SET TAGS ('dbx_business_glossary_term' = 'Persons Involved Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `persons_involved_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `pfso_notified_datetime` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Notified Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `pfso_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `port_authority_notified_datetime` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Notified Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `port_authority_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `report_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Incident Report Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `reported_datetime` SET TAGS ('dbx_business_glossary_term' = 'Reported Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `reporting_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Reporting Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `root_cause_analysis` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Severity Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `subtype` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Subtype');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `threat_level` SET TAGS ('dbx_business_glossary_term' = 'Threat Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `threat_level` SET TAGS ('dbx_value_regex' = 'minimal|moderate|substantial|severe');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_business_glossary_term' = 'Vessel International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` SET TAGS ('dbx_subdomain' = 'incident_investigation');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `investigation_id` SET TAGS ('dbx_business_glossary_term' = 'Security Investigation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `cyber_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Cyber Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Investigator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `parent_investigation_id` SET TAGS ('dbx_business_glossary_term' = 'Related Investigation Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `parent_investigation_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `stowaway_case_id` SET TAGS ('dbx_business_glossary_term' = 'Stowaway Case Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `access_log_references` SET TAGS ('dbx_business_glossary_term' = 'Access Log References');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `cctv_footage_references` SET TAGS ('dbx_business_glossary_term' = 'CCTV (Closed-Circuit Television) Footage References');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `closed_by` SET TAGS ('dbx_business_glossary_term' = 'Investigation Closed By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Investigation Closed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `confidentiality_classification` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `confidentiality_classification` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `contributing_factors` SET TAGS ('dbx_business_glossary_term' = 'Contributing Factors');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `corrective_actions_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `disciplinary_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_business_glossary_term' = 'Estimated Financial Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `evidence_collected` SET TAGS ('dbx_business_glossary_term' = 'Evidence Collected');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Investigation Findings Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `incident_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `incident_location` SET TAGS ('dbx_business_glossary_term' = 'Incident Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `incident_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `initiated_by` SET TAGS ('dbx_business_glossary_term' = 'Investigation Initiated By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `initiated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Investigation Initiated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `investigation_number` SET TAGS ('dbx_business_glossary_term' = 'Investigation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `investigation_number` SET TAGS ('dbx_value_regex' = '^INV-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `investigation_status` SET TAGS ('dbx_business_glossary_term' = 'Investigation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `investigation_status` SET TAGS ('dbx_value_regex' = 'initiated|evidence_collection|analysis|pending_review|closed|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `investigation_type` SET TAGS ('dbx_business_glossary_term' = 'Investigation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `investigation_type` SET TAGS ('dbx_value_regex' = 'security_breach|access_violation|theft|sabotage|cyber_incident|isps_non_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `isps_compliance_impact` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Compliance Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `law_enforcement_agency` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Agency');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `law_enforcement_case_number` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Case Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `law_enforcement_notified` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Notified');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `lessons_learned` SET TAGS ('dbx_business_glossary_term' = 'Lessons Learned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `operational_impact_hours` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `personnel_involved_count` SET TAGS ('dbx_business_glossary_term' = 'Personnel Involved Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Investigation Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `recommendations` SET TAGS ('dbx_business_glossary_term' = 'Investigation Recommendations');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `regulatory_authority_notified` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority Notified');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `regulatory_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `regulatory_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `report_reference` SET TAGS ('dbx_business_glossary_term' = 'Investigation Report Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `root_cause_determination` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Determination');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `scope_description` SET TAGS ('dbx_business_glossary_term' = 'Investigation Scope Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `security_control_failures` SET TAGS ('dbx_business_glossary_term' = 'Security Control Failures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `security_plan_amendment_required` SET TAGS ('dbx_business_glossary_term' = 'Security Plan Amendment Required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `team` SET TAGS ('dbx_business_glossary_term' = 'Investigation Team');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `timeline_of_events` SET TAGS ('dbx_business_glossary_term' = 'Timeline of Events');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `witness_statement_summary` SET TAGS ('dbx_business_glossary_term' = 'Witness Statement Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `witness_statement_summary` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ALTER COLUMN `witness_statements_count` SET TAGS ('dbx_business_glossary_term' = 'Witness Statements Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` SET TAGS ('dbx_subdomain' = 'isps_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `primary_superseded_by_assessment_threat_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Assessment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending_approval|approved|conditionally_approved|rejected|revision_required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `approved_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_methodology` SET TAGS ('dbx_business_glossary_term' = 'Assessment Methodology');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Assessment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_value_regex' = '^PFSA-[0-9]{4}-[0-9]{4}$|^TA-[0-9]{4}-[0-9]{4}$|^VTA-[0-9]{4}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_report_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Assessment Report Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_report_document_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_status` SET TAGS ('dbx_business_glossary_term' = 'Assessment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|rejected|superseded|archived');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Assessment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'port_facility_security_assessment|ad_hoc_threat_assessment|vessel_specific_threat_assessment|infrastructure_vulnerability_assessment|cyber_threat_assessment|periodic_review');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `classification_level` SET TAGS ('dbx_business_glossary_term' = 'Classification Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `classification_level` SET TAGS ('dbx_value_regex' = 'unclassified|confidential|restricted|secret');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `conducting_authority` SET TAGS ('dbx_business_glossary_term' = 'Conducting Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `conducting_authority` SET TAGS ('dbx_value_regex' = 'recognized_security_organization|port_facility_security_officer|internal_security_team|external_consultant|government_agency|joint_assessment_team');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `conducting_organization_name` SET TAGS ('dbx_business_glossary_term' = 'Conducting Organization Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `conducting_organization_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `intelligence_sources_consulted` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Sources Consulted');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `intelligence_sources_consulted` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `lead_assessor_credentials` SET TAGS ('dbx_business_glossary_term' = 'Lead Assessor Credentials');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `lead_assessor_credentials` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `lead_assessor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Assessor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `lead_assessor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `overall_risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Risk Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `overall_risk_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `overall_risk_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `recommended_countermeasures` SET TAGS ('dbx_business_glossary_term' = 'Recommended Countermeasures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `recommended_countermeasures` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency in Months');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `stakeholder_consultation_conducted` SET TAGS ('dbx_business_glossary_term' = 'Stakeholder Consultation Conducted');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_cyber_evaluated` SET TAGS ('dbx_business_glossary_term' = 'Cyber Threat Evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_cyber_rating` SET TAGS ('dbx_business_glossary_term' = 'Cyber Threat Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_cyber_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible|not_evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_cyber_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_piracy_evaluated` SET TAGS ('dbx_business_glossary_term' = 'Piracy Threat Evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_piracy_rating` SET TAGS ('dbx_business_glossary_term' = 'Piracy Threat Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_piracy_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible|not_evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_piracy_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_sabotage_evaluated` SET TAGS ('dbx_business_glossary_term' = 'Sabotage Threat Evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_sabotage_rating` SET TAGS ('dbx_business_glossary_term' = 'Sabotage Threat Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_sabotage_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible|not_evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_sabotage_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_smuggling_evaluated` SET TAGS ('dbx_business_glossary_term' = 'Smuggling Threat Evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_smuggling_rating` SET TAGS ('dbx_business_glossary_term' = 'Smuggling Threat Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_smuggling_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible|not_evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_smuggling_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_stowaways_evaluated` SET TAGS ('dbx_business_glossary_term' = 'Stowaways Threat Evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_stowaways_rating` SET TAGS ('dbx_business_glossary_term' = 'Stowaways Threat Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_stowaways_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible|not_evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_stowaways_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_terrorism_evaluated` SET TAGS ('dbx_business_glossary_term' = 'Terrorism Threat Evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_terrorism_rating` SET TAGS ('dbx_business_glossary_term' = 'Terrorism Threat Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_terrorism_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible|not_evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `threat_terrorism_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `vulnerability_findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Findings Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ALTER COLUMN `vulnerability_findings_summary` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` SET TAGS ('dbx_subdomain' = 'isps_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `marsec_level_change_id` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level Change ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `primary_superseded_by_change_marsec_level_change_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Change ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `access_control_measures` SET TAGS ('dbx_business_glossary_term' = 'Access Control Measures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `cargo_screening_requirement` SET TAGS ('dbx_business_glossary_term' = 'Cargo Screening Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `cargo_screening_requirement` SET TAGS ('dbx_value_regex' = 'standard|enhanced|100_percent_screening|random_sampling|risk_based');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `change_number` SET TAGS ('dbx_business_glossary_term' = 'MARSEC Change Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `change_number` SET TAGS ('dbx_value_regex' = '^MARSEC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Change Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `change_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Change Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `change_reason_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_business_glossary_term' = 'Communication Protocol');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `cybersecurity_posture` SET TAGS ('dbx_business_glossary_term' = 'Cybersecurity Posture');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `cybersecurity_posture` SET TAGS ('dbx_value_regex' = 'normal|elevated|high_alert|lockdown');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `declaration_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Declaration Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `drill_exercise_flag` SET TAGS ('dbx_business_glossary_term' = 'Drill or Exercise Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `duration_type` SET TAGS ('dbx_business_glossary_term' = 'Duration Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `duration_type` SET TAGS ('dbx_value_regex' = 'indefinite|temporary|time_limited|until_further_notice');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `effective_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Effective Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'entire_port|specific_terminal|specific_berth|anchorage_area|port_waters|restricted_zone');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `issuing_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `issuing_authority_type` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `issuing_authority_type` SET TAGS ('dbx_value_regex' = 'national_maritime_security_authority|port_authority|coast_guard|navy|ministry_of_transport|other');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `marsec_level_change_status` SET TAGS ('dbx_business_glossary_term' = 'MARSEC Level Change Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `marsec_level_change_status` SET TAGS ('dbx_value_regex' = 'declared|active|superseded|cancelled|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `new_marsec_level` SET TAGS ('dbx_business_glossary_term' = 'New Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `notification_method` SET TAGS ('dbx_business_glossary_term' = 'Notification Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `notification_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `operational_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `patrol_frequency_change` SET TAGS ('dbx_business_glossary_term' = 'Patrol Frequency Change');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `pfso_acknowledged_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Acknowledged Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `pfso_acknowledged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Acknowledged Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `pfso_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `pfso_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `pfso_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `planned_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `previous_marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Previous Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `surveillance_enhancement` SET TAGS ('dbx_business_glossary_term' = 'Surveillance Enhancement');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `threat_assessment_reference` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `threat_assessment_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `vessel_screening_requirement` SET TAGS ('dbx_business_glossary_term' = 'Vessel Screening Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`marsec_level_change` ALTER COLUMN `vessel_screening_requirement` SET TAGS ('dbx_value_regex' = 'standard|enhanced|pre_arrival_security_check|underwater_hull_inspection|mandatory_security_declaration');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` SET TAGS ('dbx_subdomain' = 'isps_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `dos_record_id` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Security (DoS) Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `marsec_level_change_id` SET TAGS ('dbx_business_glossary_term' = 'Marsec Level Change Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `superseded_dos_record_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Dos Record Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `superseded_dos_record_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `activities_covered` SET TAGS ('dbx_business_glossary_term' = 'Activities Covered');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `bunkering_flag` SET TAGS ('dbx_business_glossary_term' = 'Bunkering Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `cargo_operations_flag` SET TAGS ('dbx_business_glossary_term' = 'Cargo Operations Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `crew_change_flag` SET TAGS ('dbx_business_glossary_term' = 'Crew Change Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `dos_number` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Security (DoS) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `dos_number` SET TAGS ('dbx_value_regex' = '^DOS-[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `dos_status` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Security (DoS) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `dos_status` SET TAGS ('dbx_value_regex' = 'draft|active|completed|cancelled|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `dos_type` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Security (DoS) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `dos_type` SET TAGS ('dbx_value_regex' = 'ship_to_port|ship_to_ship');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `filing_reference` SET TAGS ('dbx_business_glossary_term' = 'Filing Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `imo_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `interface_location` SET TAGS ('dbx_business_glossary_term' = 'Interface Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `passenger_operations_flag` SET TAGS ('dbx_business_glossary_term' = 'Passenger Operations Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `pfso_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `pfso_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `pfso_signature_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Signature Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `port_marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `port_security_measures` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Measures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `regulatory_authority_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `security_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `ship_to_ship_transfer_flag` SET TAGS ('dbx_business_glossary_term' = 'Ship-to-Ship Transfer Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `stores_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'Stores Delivery Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `threat_assessment_reference` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `threat_assessment_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `valid_from_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Valid From Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `valid_until_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Valid Until Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Vessel Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_master_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_master_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_security_measures` SET TAGS ('dbx_business_glossary_term' = 'Vessel Security Measures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_signature_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Vessel Signature Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_sso_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Ship Security Officer (SSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ALTER COLUMN `vessel_sso_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` SET TAGS ('dbx_subdomain' = 'isps_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `drill_id` SET TAGS ('dbx_business_glossary_term' = 'Security Drill Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `escalated_drill_id` SET TAGS ('dbx_business_glossary_term' = 'Escalated Drill Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `escalated_drill_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Drill Coordinator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Drill End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Drill Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `audit_trail_notes` SET TAGS ('dbx_business_glossary_term' = 'Audit Trail Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Code Compliance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|partially_compliant|pending_review');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `corrective_actions_raised` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Raised');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `deficiencies_identified` SET TAGS ('dbx_business_glossary_term' = 'Identified Deficiencies');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `drill_number` SET TAGS ('dbx_business_glossary_term' = 'Drill Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `drill_status` SET TAGS ('dbx_business_glossary_term' = 'Drill Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `drill_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|deferred');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `drill_type` SET TAGS ('dbx_business_glossary_term' = 'Drill Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `drill_type` SET TAGS ('dbx_value_regex' = 'communication_drill|evacuation_drill|access_control_drill|bomb_threat_drill|full_scale_exercise|table_top_exercise');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Drill Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `equipment_tested` SET TAGS ('dbx_business_glossary_term' = 'Equipment Tested');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `external_agencies_involved` SET TAGS ('dbx_business_glossary_term' = 'External Agencies Involved');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `lessons_learned` SET TAGS ('dbx_business_glossary_term' = 'Lessons Learned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Drill Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `next_drill_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Drill Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `objectives` SET TAGS ('dbx_business_glossary_term' = 'Drill Objectives');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `outcomes_summary` SET TAGS ('dbx_business_glossary_term' = 'Drill Outcomes Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `participant_count` SET TAGS ('dbx_business_glossary_term' = 'Total Participant Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `participating_departments` SET TAGS ('dbx_business_glossary_term' = 'Participating Departments');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `pfso_sign_off_comments` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Sign-Off Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `pfso_sign_off_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Sign-Off Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `procedures_tested` SET TAGS ('dbx_business_glossary_term' = 'Procedures Tested');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `report_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Drill Report Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `scenario_description` SET TAGS ('dbx_business_glossary_term' = 'Drill Scenario Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `scenario_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Drill Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `security_level_during_drill` SET TAGS ('dbx_business_glossary_term' = 'Security Level During Drill');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ALTER COLUMN `security_level_during_drill` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` SET TAGS ('dbx_subdomain' = 'isps_compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `security_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `follow_up_security_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Follow Up Security Audit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `follow_up_security_audit_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `areas_audited` SET TAGS ('dbx_business_glossary_term' = 'Security Areas Audited');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_date` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^SA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_scope` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'internal|external|rso|flag_state|imo|port_state_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `auditing_organization` SET TAGS ('dbx_business_glossary_term' = 'Auditing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `certification_impact` SET TAGS ('dbx_business_glossary_term' = 'Certification Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `certification_impact` SET TAGS ('dbx_value_regex' = 'none|warning|suspension|revocation');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Closure Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_value_regex' = 'open|pending_verification|verified|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `closure_verification_date` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Closure Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `conformances_count` SET TAGS ('dbx_business_glossary_term' = 'Conformances Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `corrective_action_plan_approved_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Plan (CAP) Approved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `corrective_action_plan_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Plan (CAP) Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `corrective_action_plan_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Plan (CAP) Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `corrective_action_plan_submitted_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Plan (CAP) Submitted Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `corrective_actions_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `cost` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Cost Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Security Audit End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `facilities_audited` SET TAGS ('dbx_business_glossary_term' = 'Port Facilities Audited');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Findings Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `findings_summary` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `follow_up_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `follow_up_audit_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Audit Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `isps_code_compliance_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Code Compliance Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `isps_code_compliance_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|non_compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `lead_auditor_certification` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `lead_auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `lead_auditor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `major_non_conformances_count` SET TAGS ('dbx_business_glossary_term' = 'Major Non-Conformances Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `methodology` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Methodology');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `minor_non_conformances_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Non-Conformances Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `next_scheduled_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Security Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `non_conformances_count` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformances Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `observations_count` SET TAGS ('dbx_business_glossary_term' = 'Observations Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Framework');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `report_reference` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Report Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `report_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `team_members` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Team Members');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_audit` ALTER COLUMN `team_members` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` SET TAGS ('dbx_subdomain' = 'incident_investigation');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_case_id` SET TAGS ('dbx_business_glossary_term' = 'Stowaway Case Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Detecting Officer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `parent_stowaway_case_id` SET TAGS ('dbx_business_glossary_term' = 'Linked Stowaway Case Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `parent_stowaway_case_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `case_closure_reason` SET TAGS ('dbx_business_glossary_term' = 'Case Closure Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `case_closure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Case Closure Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `case_number` SET TAGS ('dbx_business_glossary_term' = 'Stowaway Case Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `case_number` SET TAGS ('dbx_value_regex' = '^STC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `case_status` SET TAGS ('dbx_business_glossary_term' = 'Case Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `corrective_action_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detecting_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Detecting Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detecting_officer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detection_location_code` SET TAGS ('dbx_business_glossary_term' = 'Detection Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detection_location_type` SET TAGS ('dbx_business_glossary_term' = 'Detection Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detection_method` SET TAGS ('dbx_business_glossary_term' = 'Detection Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Detection Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detention_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Detention Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detention_facility_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detention_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Detention Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detention_status` SET TAGS ('dbx_business_glossary_term' = 'Detention Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `detention_status` SET TAGS ('dbx_value_regex' = 'not_detained|detained_onboard|detained_port_facility|detained_immigration_center|released');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `immigration_authority_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Immigration Authority Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `immigration_authority_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Immigration Authority Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Case Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `number_of_stowaways` SET TAGS ('dbx_business_glossary_term' = 'Number of Stowaways');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `pfso_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `port_authority_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `port_authority_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Repatriation Cost Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Repatriation Cost Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_country_code` SET TAGS ('dbx_business_glossary_term' = 'Repatriation Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_date` SET TAGS ('dbx_business_glossary_term' = 'Repatriation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_status` SET TAGS ('dbx_business_glossary_term' = 'Repatriation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `repatriation_status` SET TAGS ('dbx_value_regex' = 'not_initiated|arrangements_in_progress|travel_documents_obtained|repatriation_scheduled|repatriated|repatriation_refused');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `responsible_party` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `responsible_party` SET TAGS ('dbx_value_regex' = 'shipping_line|vessel_owner|port_authority|immigration_authority|unknown');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `security_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Breach Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `shipping_line_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `shipping_line_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_identity_documents` SET TAGS ('dbx_business_glossary_term' = 'Stowaway Identity Documents');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_identity_documents` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_identity_documents` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_nationalities` SET TAGS ('dbx_business_glossary_term' = 'Stowaway Nationalities');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_nationalities` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_personal_details` SET TAGS ('dbx_business_glossary_term' = 'Stowaway Personal Details');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_personal_details` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `stowaway_personal_details` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` SET TAGS ('dbx_subdomain' = 'surveillance_equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `watchlist_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Entry Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `superseded_watchlist_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Watchlist Entry Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `superseded_watchlist_entry_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `access_control_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Access Control Integration Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `alert_action_required` SET TAGS ('dbx_business_glossary_term' = 'Alert Action Required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `alert_action_required` SET TAGS ('dbx_value_regex' = 'deny_access|detain|notify_authority|enhanced_screening|monitor|log_only');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `alert_category` SET TAGS ('dbx_business_glossary_term' = 'Alert Category');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `applicable_facilities` SET TAGS ('dbx_business_glossary_term' = 'Applicable Facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `biometric_data_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Biometric Data Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `biometric_data_available_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `biometric_data_available_flag` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'public|law_enforcement_sensitive|classified|top_secret');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `detection_count` SET TAGS ('dbx_business_glossary_term' = 'Detection Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `distribution_restriction` SET TAGS ('dbx_business_glossary_term' = 'Distribution Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `entry_number` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Entry Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'global|regional|national|port_specific');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `incident_reference` SET TAGS ('dbx_business_glossary_term' = 'Incident Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `last_detection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Detection Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `last_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Last Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `managing_authority` SET TAGS ('dbx_business_glossary_term' = 'Managing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `notification_authority` SET TAGS ('dbx_business_glossary_term' = 'Notification Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `notification_contact` SET TAGS ('dbx_business_glossary_term' = 'Notification Contact Details');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `notification_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `notification_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `pfso_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `photo_reference` SET TAGS ('dbx_business_glossary_term' = 'Photo Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `photo_reference` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `photo_reference` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `removal_date` SET TAGS ('dbx_business_glossary_term' = 'Removal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `removal_reason` SET TAGS ('dbx_business_glossary_term' = 'Removal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `removed_by` SET TAGS ('dbx_business_glossary_term' = 'Removed By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Review Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_additional_identifiers` SET TAGS ('dbx_business_glossary_term' = 'Subject Additional Identifiers');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_additional_identifiers` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_additional_identifiers` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Subject Date of Birth');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_identifier_type` SET TAGS ('dbx_business_glossary_term' = 'Subject Identifier Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_identifier_value` SET TAGS ('dbx_business_glossary_term' = 'Subject Identifier Value');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_identifier_value` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_identifier_value` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_name` SET TAGS ('dbx_business_glossary_term' = 'Subject Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_type` SET TAGS ('dbx_business_glossary_term' = 'Subject Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `subject_type` SET TAGS ('dbx_value_regex' = 'person|vessel|vehicle|organisation|container|cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `supporting_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Supporting Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `threat_level` SET TAGS ('dbx_business_glossary_term' = 'Threat Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `threat_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|informational');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `vessel_screening_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Vessel Screening Integration Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `watchlist_entry_status` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Entry Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `watchlist_entry_status` SET TAGS ('dbx_value_regex' = 'active|suspended|expired|removed|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `watchlist_source` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Source');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `watchlist_source_reference` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Source Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` SET TAGS ('dbx_subdomain' = 'surveillance_equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_record_id` SET TAGS ('dbx_business_glossary_term' = 'Screening Record Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `access_point_id` SET TAGS ('dbx_business_glossary_term' = 'Access Point Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Screening Officer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `rescreened_screening_record_id` SET TAGS ('dbx_business_glossary_term' = 'Rescreened Screening Record Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `rescreened_screening_record_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `watchlist_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Entry Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `alert_triggered_flag` SET TAGS ('dbx_business_glossary_term' = 'Alert Triggered Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `alert_type` SET TAGS ('dbx_business_glossary_term' = 'Alert Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `biometric_match_score` SET TAGS ('dbx_business_glossary_term' = 'Biometric Match Score Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `biometric_match_score` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `biometric_verification_type` SET TAGS ('dbx_business_glossary_term' = 'Biometric Verification Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `biometric_verification_type` SET TAGS ('dbx_value_regex' = 'fingerprint|facial_recognition|iris_scan|palm_vein|none');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `biometric_verification_type` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `biometric_verification_type` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `customs_notification_flag` SET TAGS ('dbx_business_glossary_term' = 'Customs Notification Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `customs_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `customs_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `document_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `document_issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Document Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `document_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `document_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `document_type_checked` SET TAGS ('dbx_business_glossary_term' = 'Document Type Checked');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `follow_up_action` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `incident_report_reference` SET TAGS ('dbx_business_glossary_term' = 'Incident Report Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `incident_report_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `marsec_level` SET TAGS ('dbx_value_regex' = 'marsec_1|marsec_2|marsec_3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `pfso_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `pfso_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `prohibited_item_description` SET TAGS ('dbx_business_glossary_term' = 'Prohibited Item Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `prohibited_item_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `prohibited_item_detected_flag` SET TAGS ('dbx_business_glossary_term' = 'Prohibited Item Detected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `radiation_reading` SET TAGS ('dbx_business_glossary_term' = 'Radiation Reading in Microsieverts per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `radiation_threshold_exceeded_flag` SET TAGS ('dbx_business_glossary_term' = 'Radiation Threshold Exceeded Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Screening Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `remarks` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Screening Duration in Seconds');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_location_description` SET TAGS ('dbx_business_glossary_term' = 'Screening Location Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_method` SET TAGS ('dbx_business_glossary_term' = 'Screening Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_number` SET TAGS ('dbx_business_glossary_term' = 'Screening Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_number` SET TAGS ('dbx_value_regex' = '^SCR-[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Screening Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_outcome` SET TAGS ('dbx_business_glossary_term' = 'Screening Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_outcome` SET TAGS ('dbx_value_regex' = 'cleared|flagged|denied|referred|pending_review|escalated');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_status` SET TAGS ('dbx_business_glossary_term' = 'Screening Record Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_status` SET TAGS ('dbx_value_regex' = 'completed|in_progress|cancelled|voided');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `screening_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Screening Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `secondary_screening_method` SET TAGS ('dbx_business_glossary_term' = 'Secondary Screening Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_identifier` SET TAGS ('dbx_business_glossary_term' = 'Subject Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_identifier` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_identifier` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_name` SET TAGS ('dbx_business_glossary_term' = 'Subject Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_type` SET TAGS ('dbx_business_glossary_term' = 'Screening Subject Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `subject_type` SET TAGS ('dbx_value_regex' = 'person|vehicle|cargo|vessel|container|equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `supervisor_override_flag` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Override Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `supervisor_override_reason` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Override Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `supervisor_override_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`screening_record` ALTER COLUMN `watchlist_match_flag` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Match Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` SET TAGS ('dbx_subdomain' = 'cyber_risk');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `cyber_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Cyber Incident Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `cyber_risk_register_id` SET TAGS ('dbx_business_glossary_term' = 'Cyber Risk Register Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Coordinator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `parent_cyber_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Related Cyber Incident Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `parent_cyber_incident_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `affected_system_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary Affected System');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `affected_systems_additional` SET TAGS ('dbx_business_glossary_term' = 'Additional Affected Systems');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `attack_vector` SET TAGS ('dbx_business_glossary_term' = 'Attack Vector Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `business_impact_assessment` SET TAGS ('dbx_business_glossary_term' = 'Business Impact Assessment Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `cert_notification_flag` SET TAGS ('dbx_business_glossary_term' = 'Computer Emergency Response Team (CERT) Notification Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `cert_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Computer Emergency Response Team (CERT) Notification Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `cert_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Computer Emergency Response Team (CERT) Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `containment_actions` SET TAGS ('dbx_business_glossary_term' = 'Containment Actions Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `containment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Containment Achieved Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `corrective_actions_identified` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Identified');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `data_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Data Breach Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `data_breach_record_count` SET TAGS ('dbx_business_glossary_term' = 'Data Breach Record Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `detected_by` SET TAGS ('dbx_business_glossary_term' = 'Detection Source Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Detection Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `downtime_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'System Downtime Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_business_glossary_term' = 'Estimated Financial Impact Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `external_support_engaged_flag` SET TAGS ('dbx_business_glossary_term' = 'External Support Engaged Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `external_support_vendor_name` SET TAGS ('dbx_business_glossary_term' = 'External Support Vendor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `financial_impact_currency` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `financial_impact_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `incident_coordinator_name` SET TAGS ('dbx_business_glossary_term' = 'Incident Coordinator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `incident_number` SET TAGS ('dbx_business_glossary_term' = 'Incident Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `incident_number` SET TAGS ('dbx_value_regex' = '^CYB-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `incident_status` SET TAGS ('dbx_business_glossary_term' = 'Incident Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `incident_status` SET TAGS ('dbx_value_regex' = 'detected|under_investigation|contained|recovery_in_progress|resolved|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_business_glossary_term' = 'Incident Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_value_regex' = 'ransomware|phishing|unauthorised_access|ddos|ot_network_intrusion|data_breach');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `indicators_of_compromise` SET TAGS ('dbx_business_glossary_term' = 'Indicators of Compromise (IOC)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `law_enforcement_notification_flag` SET TAGS ('dbx_business_glossary_term' = 'Law Enforcement Notification Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `malware_identified` SET TAGS ('dbx_business_glossary_term' = 'Malware Identified Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `maritime_authority_notification_flag` SET TAGS ('dbx_business_glossary_term' = 'Maritime Authority Notification Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `maritime_authority_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Maritime Authority Notification Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `occurrence_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident Occurrence Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `operational_disruption_flag` SET TAGS ('dbx_business_glossary_term' = 'Operational Disruption Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `pfso_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Notification Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `pfso_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Notified Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `pii_exposed_flag` SET TAGS ('dbx_business_glossary_term' = 'Personally Identifiable Information (PII) Exposed Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `post_incident_review_date` SET TAGS ('dbx_business_glossary_term' = 'Post-Incident Review Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `post_incident_review_reference` SET TAGS ('dbx_business_glossary_term' = 'Post-Incident Review Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `recovery_actions` SET TAGS ('dbx_business_glossary_term' = 'Recovery Actions Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `recovery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Recovery Completed Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Incident Remarks and Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `root_cause_analysis` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Incident Severity Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `threat_actor_type` SET TAGS ('dbx_business_glossary_term' = 'Threat Actor Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ALTER COLUMN `threat_actor_type` SET TAGS ('dbx_value_regex' = 'nation_state|organized_crime|hacktivist|insider|opportunistic|unknown');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` SET TAGS ('dbx_subdomain' = 'cyber_risk');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `cyber_risk_register_id` SET TAGS ('dbx_business_glossary_term' = 'Cyber Risk Register ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `parent_cyber_risk_register_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Cyber Risk Register Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `parent_cyber_risk_register_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `asset_at_risk` SET TAGS ('dbx_business_glossary_term' = 'Asset at Risk');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Closure Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `closure_reason` SET TAGS ('dbx_business_glossary_term' = 'Closure Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `control_effectiveness` SET TAGS ('dbx_business_glossary_term' = 'Control Effectiveness');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `control_effectiveness` SET TAGS ('dbx_value_regex' = 'ineffective|partially_effective|effective|highly_effective');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `current_controls` SET TAGS ('dbx_business_glossary_term' = 'Current Controls');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `cyber_risk_register_status` SET TAGS ('dbx_business_glossary_term' = 'Risk Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `cyber_risk_register_status` SET TAGS ('dbx_value_regex' = 'active|closed|archived|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `financial_impact_estimate` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Estimate');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `financial_impact_estimate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `imo_msc_428_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'IMO (International Maritime Organization) MSC.428(98) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `impact_rating` SET TAGS ('dbx_business_glossary_term' = 'Impact Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `impact_rating` SET TAGS ('dbx_value_regex' = 'very_low|low|medium|high|very_high');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `impact_score` SET TAGS ('dbx_business_glossary_term' = 'Impact Score');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `inherent_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Inherent Risk Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `inherent_risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `inherent_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Inherent Risk Score');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `iso_27001_alignment_flag` SET TAGS ('dbx_business_glossary_term' = 'ISO (International Organization for Standardization) 27001 Alignment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `isps_code_relevance_flag` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Code Relevance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `last_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Assessment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `likelihood_rating` SET TAGS ('dbx_business_glossary_term' = 'Likelihood Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `likelihood_rating` SET TAGS ('dbx_value_regex' = 'very_low|low|medium|high|very_high');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `likelihood_score` SET TAGS ('dbx_business_glossary_term' = 'Likelihood Score');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `operational_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `regulatory_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `residual_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Residual Risk Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `residual_risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `residual_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Residual Risk Score');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency Months');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_acceptance_authority` SET TAGS ('dbx_business_glossary_term' = 'Risk Acceptance Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Acceptance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_acceptance_flag` SET TAGS ('dbx_business_glossary_term' = 'Risk Acceptance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_category` SET TAGS ('dbx_business_glossary_term' = 'Risk Category');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_description` SET TAGS ('dbx_business_glossary_term' = 'Risk Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Risk Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_reference_number` SET TAGS ('dbx_value_regex' = '^CR-[0-9]{4}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Risk Subcategory');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `risk_title` SET TAGS ('dbx_business_glossary_term' = 'Risk Title');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `safety_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `system_at_risk` SET TAGS ('dbx_business_glossary_term' = 'System at Risk');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `threat_source` SET TAGS ('dbx_business_glossary_term' = 'Threat Source');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Treatment Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_completion_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_completion_date` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Treatment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_due_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_due_date` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_plan` SET TAGS ('dbx_business_glossary_term' = 'Treatment Plan');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_priority` SET TAGS ('dbx_business_glossary_term' = 'Treatment Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_priority` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_priority` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_status` SET TAGS ('dbx_business_glossary_term' = 'Treatment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|on_hold|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_status` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_status` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_strategy` SET TAGS ('dbx_business_glossary_term' = 'Treatment Strategy');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_strategy` SET TAGS ('dbx_value_regex' = 'mitigate|accept|transfer|avoid');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_strategy` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `treatment_strategy` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ALTER COLUMN `vulnerability_description` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Security Personnel Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `post_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Security Post Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `supervisor_personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Personnel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `supervisor_personnel_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Security Company Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `assignment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `assignment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `clearance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Security Clearance Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `clearance_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Security Clearance Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `contact_email_address` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `contact_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `contact_email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `contact_email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `contact_phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Date of Birth');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `deputy_pfso_flag` SET TAGS ('dbx_business_glossary_term' = 'Deputy Port Facility Security Officer (PFSO) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'direct|contracted|temporary|casual');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `firearms_authorisation_flag` SET TAGS ('dbx_business_glossary_term' = 'Firearms Authorisation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `firearms_licence_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Firearms Licence Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `firearms_licence_number` SET TAGS ('dbx_business_glossary_term' = 'Firearms Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `firearms_licence_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `firearms_licence_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Full Legal Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Hire Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `isps_training_certification` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Training Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `isps_training_completion_date` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Training Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `isps_training_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Training Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `last_training_date` SET TAGS ('dbx_business_glossary_term' = 'Last Training Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `licence_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Licence Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `licence_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Licence Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `licence_issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Licence Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `medical_fitness_certificate_expiry` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `medical_fitness_certificate_expiry` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `medical_fitness_certificate_expiry` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `national_id_number` SET TAGS ('dbx_business_glossary_term' = 'National Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `national_id_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `national_id_number` SET TAGS ('dbx_pii_national_id' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `nationality` SET TAGS ('dbx_business_glossary_term' = 'Nationality');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `nationality` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `nationality` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `nationality` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `next_training_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Training Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `personnel_number` SET TAGS ('dbx_business_glossary_term' = 'Personnel Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `personnel_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `personnel_status` SET TAGS ('dbx_business_glossary_term' = 'Personnel Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `personnel_status` SET TAGS ('dbx_value_regex' = 'active|on_leave|suspended|terminated|retired');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `pfso_designation_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Designation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `position_title` SET TAGS ('dbx_business_glossary_term' = 'Position Title');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `position_type` SET TAGS ('dbx_business_glossary_term' = 'Position Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `security_clearance_level` SET TAGS ('dbx_business_glossary_term' = 'Security Clearance Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `security_clearance_level` SET TAGS ('dbx_value_regex' = 'basic|standard|enhanced|top_secret');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `security_clearance_level` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `security_licence_number` SET TAGS ('dbx_business_glossary_term' = 'Security Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `security_licence_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `security_licence_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `termination_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `uniform_size` SET TAGS ('dbx_business_glossary_term' = 'Uniform Size');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `work_permit_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Work Permit Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `work_permit_number` SET TAGS ('dbx_business_glossary_term' = 'Work Permit Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `work_permit_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ALTER COLUMN `work_permit_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_id` SET TAGS ('dbx_business_glossary_term' = 'Security Post Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `facility_building_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Building Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `parent_post_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Post Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `parent_post_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Security Officer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_supervisor_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_supervisor_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_supervisor_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `access_control_function_flag` SET TAGS ('dbx_business_glossary_term' = 'Access Control Function Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `alarm_response_flag` SET TAGS ('dbx_business_glossary_term' = 'Alarm Response Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `barrier_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Barrier Control Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `cctv_camera_coverage` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Camera Coverage');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `cctv_monitoring_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Monitoring Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_code` SET TAGS ('dbx_business_glossary_term' = 'Security Post Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `current_assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Current Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `current_assignment_status` SET TAGS ('dbx_value_regex' = 'staffed|unstaffed|partially_staffed|vacant|covered_remotely');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `current_staffing_level` SET TAGS ('dbx_business_glossary_term' = 'Current Staffing Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `emergency_response_role` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Role');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `establishment_date` SET TAGS ('dbx_business_glossary_term' = 'Establishment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `intercom_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercom Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `location_description` SET TAGS ('dbx_business_glossary_term' = 'Location Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `marsec_level_1_staffing` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level 1 Staffing Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `marsec_level_2_staffing` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level 2 Staffing Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `marsec_level_3_staffing` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level 3 Staffing Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_name` SET TAGS ('dbx_business_glossary_term' = 'Security Post Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `next_review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `operating_hours_description` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `operating_hours_type` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `operating_hours_type` SET TAGS ('dbx_value_regex' = '24x7|business_hours|shift_based|on_demand|vessel_dependent');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|inactive|temporarily_closed|under_maintenance|decommissioned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `patrol_frequency_minutes` SET TAGS ('dbx_business_glossary_term' = 'Patrol Frequency in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `patrol_function_flag` SET TAGS ('dbx_business_glossary_term' = 'Patrol Function Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `patrol_route_description` SET TAGS ('dbx_business_glossary_term' = 'Patrol Route Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `post_type` SET TAGS ('dbx_business_glossary_term' = 'Security Post Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `primary_responsibility` SET TAGS ('dbx_business_glossary_term' = 'Primary Responsibility');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `radio_channel` SET TAGS ('dbx_business_glossary_term' = 'Radio Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `radio_equipment_assigned` SET TAGS ('dbx_business_glossary_term' = 'Radio Equipment Assigned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `scanner_equipment_assigned` SET TAGS ('dbx_business_glossary_term' = 'Scanner Equipment Assigned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `surveillance_function_flag` SET TAGS ('dbx_business_glossary_term' = 'Surveillance Function Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ALTER COLUMN `vehicle_assigned` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Assigned');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visitor_log_id` SET TAGS ('dbx_business_glossary_term' = 'Visitor Log Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Escort Officer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `escorted_by_visitor_log_id` SET TAGS ('dbx_business_glossary_term' = 'Escorted By Visitor Log Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `escorted_by_visitor_log_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `access_point_id` SET TAGS ('dbx_business_glossary_term' = 'Entry Access Point Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `authorization_level` SET TAGS ('dbx_business_glossary_term' = 'Authorization Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `authorization_level` SET TAGS ('dbx_value_regex' = 'public_area|operational_area|restricted_area|critical_infrastructure');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `badge_returned_flag` SET TAGS ('dbx_business_glossary_term' = 'Badge Returned Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `biometric_capture_flag` SET TAGS ('dbx_business_glossary_term' = 'Biometric Capture Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `biometric_capture_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `biometric_capture_flag` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `entry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Entry Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `escort_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Escort Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `escort_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Escort Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `exit_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exit Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `host_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Host Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `host_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `host_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `host_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Host Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `host_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `host_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `host_department` SET TAGS ('dbx_business_glossary_term' = 'Host Department');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Identity Document Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_issuing_country` SET TAGS ('dbx_business_glossary_term' = 'Identity Document Issuing Country');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_issuing_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_number` SET TAGS ('dbx_business_glossary_term' = 'Identity Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_type` SET TAGS ('dbx_business_glossary_term' = 'Identity Document Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `identity_document_type` SET TAGS ('dbx_value_regex' = 'passport|national_id|drivers_license|seafarer_id|port_pass|government_id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `marsec_level` SET TAGS ('dbx_value_regex' = 'marsec_1|marsec_2|marsec_3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `nationality` SET TAGS ('dbx_business_glossary_term' = 'Visitor Nationality');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `nationality` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `nationality` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `nationality` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `organization_name` SET TAGS ('dbx_business_glossary_term' = 'Organization Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `organization_type` SET TAGS ('dbx_business_glossary_term' = 'Organization Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `pfso_approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Approval Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `pfso_approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `photo_captured_flag` SET TAGS ('dbx_business_glossary_term' = 'Photo Captured Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `restricted_area_access_flag` SET TAGS ('dbx_business_glossary_term' = 'Restricted Area Access Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `screening_method` SET TAGS ('dbx_business_glossary_term' = 'Security Screening Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `screening_method` SET TAGS ('dbx_value_regex' = 'metal_detector|x_ray|physical_inspection|biometric|none');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `security_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `security_screening_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Screening Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `vehicle_entry_flag` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Entry Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `vehicle_make_model` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Make and Model');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'car|van|truck|motorcycle|bus|other');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visit_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Visit Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visit_number` SET TAGS ('dbx_business_glossary_term' = 'Visit Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visit_number` SET TAGS ('dbx_value_regex' = '^VIS-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visit_purpose` SET TAGS ('dbx_business_glossary_term' = 'Visit Purpose');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visit_purpose_category` SET TAGS ('dbx_business_glossary_term' = 'Visit Purpose Category');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visit_status` SET TAGS ('dbx_business_glossary_term' = 'Visit Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visit_status` SET TAGS ('dbx_value_regex' = 'active|completed|cancelled|overstayed|security_incident');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visitor_badge_number` SET TAGS ('dbx_business_glossary_term' = 'Visitor Badge Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visitor_badge_number` SET TAGS ('dbx_value_regex' = '^VB-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visitor_full_name` SET TAGS ('dbx_business_glossary_term' = 'Visitor Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visitor_full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `visitor_full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `watchlist_check_status` SET TAGS ('dbx_business_glossary_term' = 'Watchlist Check Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `watchlist_check_status` SET TAGS ('dbx_value_regex' = 'cleared|flagged|not_performed|pending');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ALTER COLUMN `zones_accessed` SET TAGS ('dbx_business_glossary_term' = 'Security Zones Accessed');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` SET TAGS ('dbx_subdomain' = 'surveillance_equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `security_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Security Equipment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `replaced_security_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Replaced Security Equipment Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `replaced_security_equipment_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `post_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Security Post Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `backup_power_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Backup Power Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `calibration_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Calibration Frequency (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `certification_authority` SET TAGS ('dbx_business_glossary_term' = 'Certification Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `deployment_location` SET TAGS ('dbx_business_glossary_term' = 'Deployment Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `disposal_date` SET TAGS ('dbx_business_glossary_term' = 'Disposal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Disposal Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `disposal_method` SET TAGS ('dbx_value_regex' = 'sold|scrapped|recycled|donated|transferred');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `environmental_rating` SET TAGS ('dbx_business_glossary_term' = 'Environmental Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `environmental_rating` SET TAGS ('dbx_value_regex' = '^IP[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `expected_useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Expected Useful Life (Years)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `integration_system_code` SET TAGS ('dbx_business_glossary_term' = 'Integration System Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'Internet Protocol (IP) Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `ip_address` SET TAGS ('dbx_value_regex' = '^(?:[0-9]{1,3}.){3}[0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `isps_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `last_firmware_update_date` SET TAGS ('dbx_business_glossary_term' = 'Last Firmware Update Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_value_regex' = 'new|operational|aging|end of life|obsolete');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `mac_address` SET TAGS ('dbx_business_glossary_term' = 'Media Access Control (MAC) Address');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `mac_address` SET TAGS ('dbx_value_regex' = '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `mac_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `maintenance_schedule_reference` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Schedule Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `mean_time_between_failures` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Failures (MTBF)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `next_maintenance_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `operating_temperature_range` SET TAGS ('dbx_business_glossary_term' = 'Operating Temperature Range');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|non-operational|maintenance|calibration|decommissioned|standby');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `power_source_type` SET TAGS ('dbx_business_glossary_term' = 'Power Source Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `power_source_type` SET TAGS ('dbx_value_regex' = 'mains power|battery|ups backup|solar|dual source');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `serial_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `tag_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Tag Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `tag_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[0-9]{4,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` SET TAGS ('dbx_subdomain' = 'surveillance_equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `mda_observation_id` SET TAGS ('dbx_business_glossary_term' = 'Maritime Domain Awareness (MDA) Observation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `correlated_mda_observation_id` SET TAGS ('dbx_business_glossary_term' = 'Correlated Mda Observation Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `correlated_mda_observation_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `patrol_id` SET TAGS ('dbx_business_glossary_term' = 'Security Patrol ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Reporting Officer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `ais_data_reference` SET TAGS ('dbx_business_glossary_term' = 'Automatic Identification System (AIS) Data Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `ais_status` SET TAGS ('dbx_business_glossary_term' = 'Automatic Identification System (AIS) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `ais_status` SET TAGS ('dbx_value_regex' = 'transmitting|dark|intermittent|spoofed|unknown');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `cctv_camera_ids` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Camera IDs');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `cctv_footage_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Footage Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `course_degrees` SET TAGS ('dbx_business_glossary_term' = 'Course (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `distance_from_port_nm` SET TAGS ('dbx_business_glossary_term' = 'Distance from Port (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `flag_state` SET TAGS ('dbx_business_glossary_term' = 'Flag State');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `flag_state` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `imo_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `imo_number` SET TAGS ('dbx_value_regex' = '^IMOd{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `location_description` SET TAGS ('dbx_business_glossary_term' = 'Location Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `maritime_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Maritime Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `maritime_authority_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Maritime Authority Notified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `marsec_level` SET TAGS ('dbx_value_regex' = 'marsec_1|marsec_2|marsec_3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_business_glossary_term' = 'Maritime Mobile Service Identity (MMSI) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_value_regex' = '^d{9}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `notification_method` SET TAGS ('dbx_business_glossary_term' = 'Notification Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `notification_method` SET TAGS ('dbx_value_regex' = 'phone|email|secure_portal|vhf_radio|edi_message');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `notification_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Notification Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `observation_notes` SET TAGS ('dbx_business_glossary_term' = 'Observation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `observation_number` SET TAGS ('dbx_business_glossary_term' = 'Observation Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `observation_status` SET TAGS ('dbx_business_glossary_term' = 'Observation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `observation_status` SET TAGS ('dbx_value_regex' = 'open|under_investigation|resolved|escalated|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `observation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Observation Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `observation_type` SET TAGS ('dbx_business_glossary_term' = 'Observation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `observation_type` SET TAGS ('dbx_value_regex' = 'suspicious_vessel_behaviour|unidentified_vessel|unauthorised_approach|dark_vessel_ais_off|small_craft_incursion|underwater_threat');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `pfso_comments` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `pfso_review_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Review Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `pfso_reviewed_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Reviewed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `reporting_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Reporting Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `reporting_source` SET TAGS ('dbx_business_glossary_term' = 'Reporting Source');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `reporting_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reporting Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `response_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Response Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `security_incident_created_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Created Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `security_patrol_dispatched_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Patrol Dispatched Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `speed_knots` SET TAGS ('dbx_business_glossary_term' = 'Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `threat_assessment_reference` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `threat_level` SET TAGS ('dbx_business_glossary_term' = 'Threat Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `threat_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `vessel_challenged_flag` SET TAGS ('dbx_business_glossary_term' = 'Vessel Challenged Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `vessel_response` SET TAGS ('dbx_business_glossary_term' = 'Vessel Response');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ALTER COLUMN `vessel_type` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` SET TAGS ('dbx_subdomain' = 'incident_investigation');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `security_corrective_action_id` SET TAGS ('dbx_business_glossary_term' = 'Security Corrective Action Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `cyber_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Cyber Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `drill_id` SET TAGS ('dbx_business_glossary_term' = 'Drill Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `parent_security_corrective_action_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Security Corrective Action Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `parent_security_corrective_action_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Officer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `security_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Security Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `threat_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_category` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Category');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_category` SET TAGS ('dbx_value_regex' = 'procedural|physical|technical|training|policy|organizational');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_number` SET TAGS ('dbx_business_glossary_term' = 'Security Corrective Action Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_number` SET TAGS ('dbx_value_regex' = '^SCAPA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_priority` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `action_status` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `actual_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `actual_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `closure_approved_by` SET TAGS ('dbx_business_glossary_term' = 'Closure Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Closure Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `closure_status` SET TAGS ('dbx_business_glossary_term' = 'Closure Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `closure_status` SET TAGS ('dbx_value_regex' = 'open|closed_verified|closed_unverified|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `days_to_complete` SET TAGS ('dbx_business_glossary_term' = 'Days to Complete');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `identified_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Identified Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `isps_compliance_impact` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliance Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `isps_compliance_impact` SET TAGS ('dbx_value_regex' = 'no_impact|minor_impact|major_impact|critical_impact');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `marsec_level` SET TAGS ('dbx_business_glossary_term' = 'Maritime Security (MARSEC) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `marsec_level` SET TAGS ('dbx_value_regex' = 'MARSEC_1|MARSEC_2|MARSEC_3');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `overdue_flag` SET TAGS ('dbx_business_glossary_term' = 'Overdue Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `pfso_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Security Officer (PFSO) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `preventive_action_flag` SET TAGS ('dbx_business_glossary_term' = 'Preventive Action Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `recurrence_prevention_measures` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Prevention Measures');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `regulatory_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `regulatory_notification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `related_action_ids` SET TAGS ('dbx_business_glossary_term' = 'Related Action Identifiers (IDs)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `responsible_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `root_cause_analysis_flag` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis (RCA) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `root_cause_summary` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `security_plan_amendment_reference` SET TAGS ('dbx_business_glossary_term' = 'Security Plan Amendment Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `security_plan_amendment_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Security Plan Amendment Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `source_reference_code` SET TAGS ('dbx_business_glossary_term' = 'Source Reference Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `source_type` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Source Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `source_type` SET TAGS ('dbx_value_regex' = 'security_incident|security_audit|security_drill|threat_assessment|vulnerability_scan|compliance_review');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `target_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Target Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `verification_method` SET TAGS ('dbx_business_glossary_term' = 'Verification Method');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `verification_notes` SET TAGS ('dbx_business_glossary_term' = 'Verification Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `verification_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Verification Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `verification_outcome` SET TAGS ('dbx_business_glossary_term' = 'Verification Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ALTER COLUMN `verification_outcome` SET TAGS ('dbx_value_regex' = 'effective|partially_effective|ineffective|pending');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` SET TAGS ('dbx_association_edges' = 'security.access_credential,security.security_zone');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `zone_access_authorization_id` SET TAGS ('dbx_business_glossary_term' = 'Zone Access Authorization ID');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Zone Access Authorization - Access Credential Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Zone Access Authorization - Security Zone Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `access_count` SET TAGS ('dbx_business_glossary_term' = 'Access Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `access_level` SET TAGS ('dbx_business_glossary_term' = 'Access Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `authorization_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `authorization_granted_by` SET TAGS ('dbx_business_glossary_term' = 'Authorization Granted By');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `authorization_status` SET TAGS ('dbx_business_glossary_term' = 'Authorization Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `business_justification` SET TAGS ('dbx_business_glossary_term' = 'Business Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `escort_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Escort Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `last_access_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Access Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `marsec_level_override` SET TAGS ('dbx_business_glossary_term' = 'MARSEC Level Override');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `next_review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `suspension_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `time_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Time Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone_access_authorization` ALTER COLUMN `zone_access_entitlements` SET TAGS ('dbx_business_glossary_term' = 'Zone Access Entitlements');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` SET TAGS ('dbx_subdomain' = 'access_control');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `patrol_route_id` SET TAGS ('dbx_business_glossary_term' = 'Patrol Route Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `parent_patrol_route_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Patrol Route Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `parent_patrol_route_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Personnel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `risk_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `infrastructure_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `access_control_points` SET TAGS ('dbx_business_glossary_term' = 'Access Control Points');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `approved_by_authority` SET TAGS ('dbx_business_glossary_term' = 'Approved By Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `cctv_coverage_percentage` SET TAGS ('dbx_business_glossary_term' = 'Cctv Coverage Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `checkpoint_count` SET TAGS ('dbx_business_glossary_term' = 'Checkpoint Count');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `emergency_response_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Time Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `end_location` SET TAGS ('dbx_business_glossary_term' = 'End Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `gps_tracking_required` SET TAGS ('dbx_business_glossary_term' = 'Gps Tracking Required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `incident_count_last_year` SET TAGS ('dbx_business_glossary_term' = 'Incident Count Last Year');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `isps_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Isps Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `night_patrol_required` SET TAGS ('dbx_business_glossary_term' = 'Night Patrol Required');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `patrol_frequency_per_shift` SET TAGS ('dbx_business_glossary_term' = 'Patrol Frequency Per Shift');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `patrol_mode` SET TAGS ('dbx_business_glossary_term' = 'Patrol Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `requires_armed_patrol` SET TAGS ('dbx_business_glossary_term' = 'Requires Armed Patrol');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `requires_two_person_patrol` SET TAGS ('dbx_business_glossary_term' = 'Requires Two Person Patrol');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `restricted_area_flag` SET TAGS ('dbx_business_glossary_term' = 'Restricted Area Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `route_code` SET TAGS ('dbx_business_glossary_term' = 'Route Code');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `route_description` SET TAGS ('dbx_business_glossary_term' = 'Route Description');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `route_distance_meters` SET TAGS ('dbx_business_glossary_term' = 'Route Distance Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `route_name` SET TAGS ('dbx_business_glossary_term' = 'Route Name');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `route_status` SET TAGS ('dbx_business_glossary_term' = 'Route Status');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `route_type` SET TAGS ('dbx_business_glossary_term' = 'Route Type');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `start_location` SET TAGS ('dbx_business_glossary_term' = 'Start Location');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `waterside_interface_flag` SET TAGS ('dbx_business_glossary_term' = 'Waterside Interface Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ALTER COLUMN `weather_dependent` SET TAGS ('dbx_business_glossary_term' = 'Weather Dependent');
