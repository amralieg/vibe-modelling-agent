-- Schema for Domain: compliance | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:21

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`compliance` COMMENT 'Manages regulatory compliance tracking, food safety (FDA/FSMA) audit schedules, OSHA workplace safety compliance, PCI-DSS payment security, GDPR/CCPA privacy compliance programs, environmental regulations, and certification lifecycle management across all retail operations.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`compliance_program` (
    `compliance_program_id` BIGINT COMMENT 'Unique identifier for the compliance program. Primary key. Inferred role: MASTER_AGREEMENT (long-running compliance framework container).',
    `parent_compliance_program_id` BIGINT COMMENT 'Self-referencing FK on compliance_program (parent_compliance_program_id)',
    `audit_frequency` STRING COMMENT 'Required or planned frequency of compliance audits for this program. Continuous: real-time monitoring. Ad_hoc: event-driven or unscheduled audits.. Valid values are `annual|semi_annual|quarterly|monthly|continuous|ad_hoc`',
    `certification_expiration_date` DATE COMMENT 'Date when the current certification or accreditation expires and must be renewed. Null if not applicable or perpetual.',
    `certification_number` STRING COMMENT 'Official certification or accreditation number issued by the governing body or third-party auditor (e.g., ISO 27001 certificate number, PCI-DSS Attestation of Compliance number). Null if program does not issue certifications.',
    `certification_status` STRING COMMENT 'Current status of external certification or accreditation for this program. Not_applicable: program does not require external certification.. Valid values are `certified|pending_certification|expired|revoked|not_applicable`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this compliance program record was first created in the system.',
    `compliance_program_description` STRING COMMENT 'Detailed narrative description of the compliance program purpose, objectives, key requirements, and business rationale.',
    `effective_date` DATE COMMENT 'Date when the compliance program became or will become binding and enforceable within the organization.',
    `expiration_date` DATE COMMENT 'Date when the compliance program ends or requires renewal. Null for perpetual programs without fixed term.',
    `governing_body` STRING COMMENT 'Name of the external regulatory authority, standards organization, or certification body that oversees this compliance program (e.g., Federal Trade Commission, Consumer Product Safety Commission, PCI Security Standards Council).',
    `incident_count_ytd` STRING COMMENT 'Number of compliance incidents, violations, or breaches recorded for this program in the current calendar year.',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit or assessment conducted for this program.',
    `last_audit_result` STRING COMMENT 'Outcome of the most recent compliance audit. Passed: full compliance. Passed_with_findings: compliant but with minor issues noted. Failed: non-compliant. Not_applicable: audit not yet conducted or program not subject to audit.. Valid values are `passed|passed_with_findings|failed|not_applicable`',
    `manager` STRING COMMENT 'Name or employee identifier of the individual responsible for day-to-day program management and coordination. Business-confidential organizational information.',
    `modified_by` STRING COMMENT 'User identifier or system account that last modified this compliance program record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this compliance program record was last updated or modified.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next compliance audit or assessment for this program.',
    `notes` STRING COMMENT 'Free-text field for additional context, special instructions, historical notes, or program-specific considerations not captured in structured fields.',
    `owning_business_unit` STRING COMMENT 'Name of the business unit, division, or department responsible for managing and executing this compliance program (e.g., Legal & Compliance, Food Safety, Information Security, Store Operations).',
    `penalty_amount_max` DECIMAL(18,2) COMMENT 'Maximum potential financial penalty or fine (in USD) for non-compliance with this program, based on regulatory framework or historical precedent. Business-confidential risk assessment data.',
    `policy_document_url` STRING COMMENT 'URL or document management system reference to the official compliance program policy document, standard operating procedures, or program charter.',
    `program_code` STRING COMMENT 'Externally-known unique business identifier for the compliance program (e.g., FDA-FSMA-2024, PCI-DSS-V4, GDPR-EU). Used in regulatory filings and audit documentation.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `program_name` STRING COMMENT 'Full business name of the compliance program (e.g., Food and Drug Administration Food Safety Modernization Act Program, Payment Card Industry Data Security Standard Program).',
    `program_scope` STRING COMMENT 'Organizational scope of the compliance program. Enterprise_wide: applies to all Retail operations. Banner_specific: applies to specific retail banners. Channel_specific: applies to e-commerce, stores, or distribution only. Region_specific: applies to specific geographic regions. Store_specific: applies to individual stores. DC_specific: applies to distribution centers.. Valid values are `enterprise_wide|banner_specific|channel_specific|region_specific|store_specific|dc_specific`',
    `program_status` STRING COMMENT 'Current lifecycle state of the compliance program. Active: program is operational and enforced. Suspended: temporarily paused. Under_review: being evaluated for changes. Retired: no longer applicable. Pending_activation: approved but not yet effective. Non_compliant: program exists but organization is currently out of compliance.. Valid values are `active|suspended|under_review|retired|pending_activation|non_compliant`',
    `program_type` STRING COMMENT 'Classification of the compliance program by its nature: regulatory (government-mandated), industry_standard (voluntary best practice), internal_policy (company-specific), certification (third-party accreditation), environmental (sustainability/emissions), safety (workplace/product), privacy (data protection), security (information/payment). [ENUM-REF-CANDIDATE: regulatory|industry_standard|internal_policy|certification|environmental|safety|privacy|security — 8 candidates stripped; promote to reference product]',
    `regulatory_framework` STRING COMMENT 'Primary regulatory or industry standard framework(s) that this program addresses (e.g., FDA/FSMA, OSHA, PCI-DSS, GDPR, CCPA, ISO 27001, GS1). Multiple frameworks may be listed comma-separated.',
    `renewal_date` DATE COMMENT 'Next scheduled date for program recertification, re-assessment, or formal renewal review. Applicable for certification-based and time-bound programs.',
    `risk_level` STRING COMMENT 'Assessed risk severity if the organization fails to maintain compliance with this program. Critical: regulatory shutdown or major financial penalty. High: significant fines or reputational damage. Medium: moderate penalties. Low: minor impact.. Valid values are `critical|high|medium|low`',
    `sponsor` STRING COMMENT 'Name or title of the executive sponsor accountable for the compliance program (e.g., Chief Compliance Officer, VP Food Safety, Chief Information Security Officer). Business-confidential organizational information.',
    `training_frequency` STRING COMMENT 'Required frequency of compliance training for employees covered by this program. Not_applicable: training not required.. Valid values are `annual|semi_annual|quarterly|one_time|continuous|not_applicable`',
    `training_required` BOOLEAN COMMENT 'Indicates whether employee training is mandatory for this compliance program. True: training required. False: no training requirement.',
    `created_by` STRING COMMENT 'User identifier or system account that created this compliance program record.',
    CONSTRAINT pk_compliance_program PRIMARY KEY(`compliance_program_id`)
) COMMENT 'Master record for each formal compliance program operated by Retail, such as the FDA/FSMA Food Safety Program, OSHA Safety Program, PCI-DSS Payment Security Program, GDPR Privacy Program, CCPA Privacy Program, and Environmental Compliance Program. Captures program name, owning business unit, program sponsor, regulatory framework(s) covered, program status (active, suspended, under review), effective date, renewal date, and program scope (enterprise-wide, banner-specific, channel-specific). Acts as the top-level organizing entity for all compliance activities.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`obligation` (
    `obligation_id` BIGINT COMMENT 'Unique identifier for the compliance obligation record. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the specific employee or user assigned as the current owner of this obligation. Links to workforce or user entity.',
    `compliance_program_id` BIGINT COMMENT 'Reference to the compliance program under which this obligation is managed. Links to the compliance program entity.',
    `parent_obligation_id` BIGINT COMMENT 'Self-referencing FK on obligation (parent_obligation_id)',
    `requirement_id` BIGINT COMMENT 'Reference to the regulatory requirement that mandates this obligation. Links to the regulatory requirement catalog.',
    `audit_frequency` STRING COMMENT 'The frequency at which this obligation is subject to internal or external audit review. May differ from fulfillment cadence.',
    `cadence` STRING COMMENT 'Frequency at which the obligation must be fulfilled. Determines scheduling and recurrence rules for compliance tasks. [ENUM-REF-CANDIDATE: annual|semi_annual|quarterly|monthly|weekly|event_driven|one_time — 7 candidates stripped; promote to reference product]',
    `obligation_code` STRING COMMENT 'Business identifier code for the obligation, used for external reporting and cross-system reference. Typically follows organizational coding standards.. Valid values are `^[A-Z0-9]{3,20}$`',
    `compliance_framework` STRING COMMENT 'The specific compliance framework or standard under which this obligation is classified. Examples include PCI-DSS, GDPR, CCPA, FSMA, ISO 27001.',
    `control_objective` STRING COMMENT 'The high-level control objective this obligation supports. Examples include data privacy protection, payment security, food safety, workplace safety.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this obligation record was first created in the system. Audit trail field.',
    `obligation_description` STRING COMMENT 'Detailed description of the compliance obligation, including the specific control action required, scope, and expected outcome.',
    `due_date` DATE COMMENT 'The date by which the obligation must be fulfilled to maintain compliance. Used for scheduling and alerting.',
    `effective_date` DATE COMMENT 'The date from which the obligation becomes active and enforceable. Aligns with regulatory effective dates.',
    `escalation_threshold_days` STRING COMMENT 'The number of days before the due date at which the obligation should be escalated to management if not yet fulfilled.',
    `evidence_required` BOOLEAN COMMENT 'Indicates whether documented evidence of fulfillment is required for audit purposes. True if evidence must be collected and retained.',
    `evidence_type` STRING COMMENT 'The type of evidence required to demonstrate fulfillment. Examples include document, certificate, training record, audit report, system log, attestation.',
    `expiration_date` DATE COMMENT 'The date on which the obligation is no longer required, either due to regulatory sunset or program termination. Nullable for ongoing obligations.',
    `financial_penalty_amount` DECIMAL(18,2) COMMENT 'The estimated financial penalty or fine that could be incurred for non-compliance with this obligation. Used for risk quantification.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this obligation is currently active and enforceable. False for archived or superseded obligations.',
    `jurisdiction` STRING COMMENT 'The legal or regulatory jurisdiction under which this obligation is mandated. Examples include USA, CAN, EU, or specific state/province codes.',
    `last_audit_date` DATE COMMENT 'The most recent date on which this obligation was audited for compliance. Used for audit scheduling and tracking.',
    `last_fulfilled_date` DATE COMMENT 'The most recent date on which this obligation was successfully fulfilled. Used for tracking compliance history and scheduling next occurrence.',
    `location_scope` STRING COMMENT 'Defines the geographic or organizational scope to which this obligation applies. May reference specific stores, distribution centers, regions, or enterprise-wide applicability.',
    `next_audit_date` DATE COMMENT 'The scheduled date for the next audit of this obligation. Calculated based on audit frequency and last audit date.',
    `next_due_date` DATE COMMENT 'The calculated next due date for recurring obligations. Automatically updated based on cadence and last fulfilled date.',
    `notes` STRING COMMENT 'Free-text field for additional context, special instructions, or operational notes related to the obligation. Used by compliance officers.',
    `obligation_status` STRING COMMENT 'Current fulfillment status of the obligation. Tracks lifecycle from assignment through completion or waiver.. Valid values are `pending|in_progress|fulfilled|overdue|waived|cancelled`',
    `obligation_type` STRING COMMENT 'Classification of the obligation by the type of control action required. Determines workflow and fulfillment process.. Valid values are `policy|procedure|training|audit|certification|reporting`',
    `penalty_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the financial penalty amount. Examples include USD, EUR, GBP.. Valid values are `^[A-Z]{3}$`',
    `priority` STRING COMMENT 'Business priority level assigned to the obligation based on regulatory risk, financial impact, and operational criticality.. Valid values are `critical|high|medium|low`',
    `regulatory_body` STRING COMMENT 'The governing body or regulatory agency that mandates this obligation. Examples include FDA, FTC, OSHA, PCI SSC, GDPR authority.',
    `responsible_role` STRING COMMENT 'The organizational role or job title responsible for fulfilling this obligation. Used for assignment and accountability tracking.',
    `retention_period_days` STRING COMMENT 'The number of days that evidence and records related to this obligation must be retained for regulatory and audit purposes.',
    `risk_rating` STRING COMMENT 'The assessed risk level associated with non-fulfillment of this obligation. Based on regulatory penalties, operational impact, and reputational risk.. Valid values are `critical|high|medium|low`',
    `title` STRING COMMENT 'Concise title describing the specific compliance obligation. Used in dashboards, reports, and audit schedules.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this obligation record was last modified. Audit trail field for change tracking.',
    `waiver_approved` BOOLEAN COMMENT 'Indicates whether a formal waiver or exception has been approved for this obligation. True if waiver is in effect.',
    `waiver_expiration_date` DATE COMMENT 'The date on which the approved waiver expires and the obligation becomes enforceable again. Nullable for permanent waivers.',
    `waiver_reason` STRING COMMENT 'The business justification for granting a waiver or exception to this obligation. Required when waiver is approved.',
    CONSTRAINT pk_obligation PRIMARY KEY(`obligation_id`)
) COMMENT 'Operational record linking a specific regulatory requirement to a compliance program, defining the specific control obligation the retailer must fulfill. Captures obligation title, obligation type (policy, procedure, training, audit, certification, reporting), due date cadence (annual, quarterly, monthly, event-driven), responsible owner role, applicable location scope, and current fulfillment status. Bridges the regulatory requirement catalog to actionable compliance tasks and audit schedules.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` (
    `audit_schedule_id` BIGINT COMMENT 'Unique identifier for the audit schedule record. Primary key for the audit schedule entity.',
    `audit_checklist_template_id` BIGINT COMMENT 'Reference to the standardized audit checklist template that will be used for this audit, ensuring consistent evaluation criteria.',
    `compliance_program_id` BIGINT COMMENT 'Reference to the parent compliance program under which this audit is scheduled (e.g., Food Safety Program, PCI-DSS Program, OSHA Safety Program).',
    `location_id` BIGINT COMMENT 'Reference to the retail location, distribution center, or corporate facility where the audit will be conducted.',
    `associate_id` BIGINT COMMENT 'Reference to the internal auditor or third-party audit firm assigned to conduct this audit.',
    `primary_previous_audit_audit_schedule_id` BIGINT COMMENT 'Reference to the most recent prior audit of the same type at the same location, enabling trend analysis and follow-up tracking.',
    `tertiary_audit_modified_by_user_associate_id` BIGINT COMMENT 'Reference to the user who last modified this audit schedule record. Used for accountability and audit trail.',
    `advance_notice_days` STRING COMMENT 'The number of days of advance notice provided to the location before the audit. Some audits require surprise inspections (0 days), others require 7-30 days notice.',
    `audit_number` STRING COMMENT 'Human-readable unique identifier for the audit schedule, used for tracking and reporting purposes. Format: AUD-XXXXXXXX.. Valid values are `^AUD-[A-Z0-9]{8,12}$`',
    `audit_scope` STRING COMMENT 'Detailed description of the audit scope, including specific areas, processes, or systems to be audited (e.g., Refrigeration units and cold chain compliance, Payment terminal encryption and key management).',
    `audit_type` STRING COMMENT 'Classification of the audit based on the regulatory or compliance domain being assessed. Determines the audit scope, checklist, and governing standards. [ENUM-REF-CANDIDATE: food_safety|osha_workplace_safety|pci_dss_payment_security|gdpr_privacy|ccpa_privacy|environmental|fire_safety|liquor_license|health_permit|building_code|ada_accessibility — 11 candidates stripped; promote to reference product]',
    `budget_code` STRING COMMENT 'The financial budget code or cost center to which audit expenses will be charged.',
    `cancellation_reason` STRING COMMENT 'Explanation for why the audit was cancelled. Null if the audit has not been cancelled.',
    `certification_body` STRING COMMENT 'The accreditation or certification body under whose standards the audit is being conducted (e.g., NSF International, Intertek, Bureau Veritas).',
    `confirmation_timestamp` TIMESTAMP COMMENT 'The date and time when the audit schedule was confirmed by all parties (auditor, location contact, and coordinator). Null until confirmed.',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated audit cost (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this audit schedule record was first created in the system. Used for audit trail and data lineage.',
    `estimated_cost` DECIMAL(18,2) COMMENT 'The estimated total cost of conducting the audit, including auditor fees, travel expenses, and internal resource costs. Used for budget planning.',
    `estimated_duration_hours` DECIMAL(18,2) COMMENT 'The estimated number of hours required to complete the audit, based on audit type, scope, and historical data.',
    `frequency` STRING COMMENT 'The recurrence pattern for this audit schedule. Regulatory audits often have mandated frequencies (e.g., annual food safety audits, quarterly PCI-DSS scans). [ENUM-REF-CANDIDATE: daily|weekly|monthly|quarterly|semi_annual|annual|biennial|ad_hoc — 8 candidates stripped; promote to reference product]',
    `is_follow_up_audit` BOOLEAN COMMENT 'Indicates whether this audit is a follow-up to address findings or corrective actions from a previous audit.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this audit schedule record was most recently updated. Used for change tracking and audit trail.',
    `notification_sent_date` DATE COMMENT 'The date on which the audit notification was sent to stakeholders. Used to track compliance with advance notice requirements.',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether advance notification has been sent to the location manager and relevant stakeholders about the upcoming audit.',
    `priority` STRING COMMENT 'Business priority level for the audit, used for resource allocation and scheduling conflict resolution. Critical audits are typically regulatory-mandated with legal deadlines.. Valid values are `critical|high|medium|low`',
    `recurrence_rule` STRING COMMENT 'Detailed recurrence pattern specification in iCalendar RRULE format or similar, for complex recurring audit schedules (e.g., Every first Monday of the quarter).',
    `regulatory_deadline` DATE COMMENT 'The hard deadline by which the audit must be completed to maintain regulatory compliance. Null for non-mandatory audits.',
    `requires_site_access_approval` BOOLEAN COMMENT 'Indicates whether the auditor requires special site access approval or security clearance to conduct the audit (e.g., for restricted areas, DCs with high-security zones).',
    `reschedule_reason` STRING COMMENT 'Explanation for why the audit was rescheduled from its original date. Null if the audit has not been rescheduled.',
    `schedule_status` STRING COMMENT 'Current lifecycle status of the audit schedule. Tracks progression from planning through execution to completion or cancellation.. Valid values are `planned|confirmed|in_progress|rescheduled|completed|cancelled`',
    `scheduled_date` DATE COMMENT 'The planned date on which the audit is scheduled to occur. This is the primary business event date for audit calendar management.',
    `scheduled_end_time` TIMESTAMP COMMENT 'The anticipated date and time when the audit is expected to conclude, used for resource planning and scheduling conflicts.',
    `scheduled_start_time` TIMESTAMP COMMENT 'The precise date and time when the audit is scheduled to begin, including time zone information for multi-region coordination.',
    `special_instructions` STRING COMMENT 'Additional instructions or notes for the auditor and location staff, such as access requirements, safety protocols, or specific areas of focus.',
    `third_party_firm_name` STRING COMMENT 'Name of the external audit firm or certification body conducting the audit, if applicable. Null for internal audits.',
    CONSTRAINT pk_audit_schedule PRIMARY KEY(`audit_schedule_id`)
) COMMENT 'Master record for planned compliance audit schedules across all retail locations and operational domains. Captures audit type (food safety, OSHA, PCI-DSS, GDPR, environmental, fire safety, liquor license), scheduled date, audit frequency (daily, weekly, monthly, quarterly, annual), assigned auditor or third-party firm, target location or business unit, associated compliance program, and schedule status (planned, confirmed, rescheduled, cancelled). Drives the operational audit calendar for store operations, DCs, and corporate functions.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`audit_event` (
    `audit_event_id` BIGINT COMMENT 'Unique identifier for the audit event record. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the employee who served as the lead auditor responsible for conducting and signing off on the audit.',
    `audit_schedule_id` BIGINT COMMENT 'Reference to the originating audit schedule that triggered this audit event execution.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Retail compliance audits (food safety, OSHA, PCI, environmental) incur costs (auditor fees, remediation, lost productivity) allocated to audited cost centers. Finance charges audit costs to responsibl',
    `follow_up_audit_event_id` BIGINT COMMENT 'Self-referencing FK on audit_event (follow_up_audit_event_id)',
    `location_id` BIGINT COMMENT 'Reference to the retail location (store, distribution center, warehouse, or corporate office) where the audit was conducted.',
    `org_unit_id` BIGINT COMMENT 'Reference to the business unit or division responsible for the audited operations.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Supplier audits (factory inspections, food safety, social compliance) are conducted at vendor facilities. Audit results drive vendor scorecards, approval status, and purchase order decisions.',
    `audit_date` DATE COMMENT 'The date on which the audit was conducted or is scheduled to be conducted. Principal business event timestamp for the audit execution.',
    `audit_duration_hours` DECIMAL(18,2) COMMENT 'Total duration of the audit execution in hours, calculated from start to end timestamp.',
    `audit_end_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the audit execution was completed at the audited location.',
    `audit_method` STRING COMMENT 'Method by which the audit was conducted: on-site physical inspection, remote virtual audit, hybrid combination, or document review only.. Valid values are `on_site|remote|hybrid|document_review`',
    `audit_number` STRING COMMENT 'Externally-known unique business identifier for the audit event, used for regulatory reporting and cross-system tracking.. Valid values are `^AUD-[0-9]{8}-[A-Z0-9]{6}$`',
    `audit_report_url` STRING COMMENT 'URL or file path to the complete audit report document stored in the document management system.. Valid values are `^https?://.*$`',
    `audit_result` STRING COMMENT 'Overall outcome of the audit event: pass (full compliance), conditional pass (minor findings requiring follow-up), fail (critical non-compliance), or not applicable.. Valid values are `pass|conditional_pass|fail|not_applicable`',
    `audit_scope` STRING COMMENT 'Detailed description of the areas, processes, and systems covered by this audit event (e.g., receiving area, cold storage, POS terminals, employee records).',
    `audit_score` DECIMAL(18,2) COMMENT 'Numerical score representing the overall compliance level achieved during the audit, typically expressed as a percentage (0.00 to 100.00).',
    `audit_start_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the audit execution began at the audited location.',
    `audit_status` STRING COMMENT 'Current lifecycle status of the audit event execution.. Valid values are `scheduled|in_progress|completed|cancelled|deferred`',
    `audit_team_members` STRING COMMENT 'Comma-separated list of additional auditor names who participated in the audit execution alongside the lead auditor.',
    `audit_type` STRING COMMENT 'Classification of the audit based on regulatory domain: food safety (FDA/FSMA), workplace safety (OSHA), payment security (PCI-DSS), data privacy (GDPR/CCPA), environmental compliance, or quality assurance.. Valid values are `food_safety|workplace_safety|pci_dss|gdpr_ccpa|environmental|quality_assurance`',
    `auditee_signature` STRING COMMENT 'Digital signature or signature capture data from the location manager or responsible party acknowledging receipt of audit findings.',
    `auditor_signature` STRING COMMENT 'Digital signature or signature capture data from the lead auditor certifying the accuracy and completeness of the audit report.',
    `certification_body` STRING COMMENT 'Name of the external certification or accreditation body if this audit was conducted by or on behalf of a third-party certifier (e.g., NSF, SGS, Bureau Veritas, QSA firm).',
    `corrective_action_plan_required_flag` BOOLEAN COMMENT 'Indicates whether a formal Corrective Action Plan must be submitted by the audited location in response to findings.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit event record was first created in the compliance management system.',
    `critical_findings_count` STRING COMMENT 'Number of critical or major non-conformances identified that pose immediate risk to compliance, safety, or business operations.',
    `executive_summary` STRING COMMENT 'High-level summary of audit findings, key observations, and overall compliance status for executive reporting and dashboard purposes.',
    `follow_up_due_date` DATE COMMENT 'Target date by which corrective actions must be completed and verified for findings identified in this audit.',
    `follow_up_required_flag` BOOLEAN COMMENT 'Indicates whether corrective actions and follow-up audit activities are required based on the findings from this audit event.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit event record was last updated in the compliance management system.',
    `lead_auditor_credentials` STRING COMMENT 'Professional certifications and credentials held by the lead auditor (e.g., Certified Food Safety Auditor, OSHA 30-Hour, PCI QSA, CISA).',
    `lead_auditor_name` STRING COMMENT 'Full name of the lead auditor who conducted the audit, captured for regulatory reporting and audit trail purposes.',
    `major_findings_count` STRING COMMENT 'Number of major non-conformances identified that represent significant deviations from compliance requirements but do not pose immediate critical risk.',
    `minor_findings_count` STRING COMMENT 'Number of minor non-conformances or observations identified that represent opportunities for improvement but do not constitute significant compliance violations.',
    `notes` STRING COMMENT 'Additional free-text notes, observations, or context captured by the auditor during the audit execution.',
    `regulatory_framework` STRING COMMENT 'Specific regulatory standard, framework, or compliance program against which this audit was conducted (e.g., FDA FSMA, OSHA 29 CFR 1910, PCI DSS v4.0, GDPR Article 32).',
    `regulatory_notification_date` DATE COMMENT 'Date on which regulatory authorities were notified of critical findings from this audit, if applicable.',
    `regulatory_notification_required_flag` BOOLEAN COMMENT 'Indicates whether critical findings from this audit require mandatory notification to regulatory authorities (FDA, OSHA, PCI Council, data protection authorities).',
    `total_findings_count` STRING COMMENT 'Total number of compliance findings (observations, non-conformances, and opportunities for improvement) identified during the audit.',
    CONSTRAINT pk_audit_event PRIMARY KEY(`audit_event_id`)
) COMMENT 'Transactional record of a completed or in-progress compliance audit execution at a specific retail location or business unit. Captures audit date, auditor name and credentials, audit type, location audited, overall audit result (pass, conditional pass, fail), total findings count, critical findings count, audit score, lead auditor signature, and follow-up required flag. Links to the originating audit schedule and generates compliance findings. Serves as the authoritative record of audit execution for regulatory reporting.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`audit_finding` (
    `audit_finding_id` BIGINT COMMENT 'Unique identifier for the audit finding record. Primary key.',
    `audit_event_id` BIGINT COMMENT 'Reference to the parent audit event during which this finding was identified. Links finding to the specific audit inspection or assessment session.',
    `dc_facility_id` BIGINT COMMENT 'Reference to the specific distribution center or warehouse where the finding was identified, if applicable. Null for store or corporate findings.',
    `location_id` BIGINT COMMENT 'Reference to the specific retail store location where the finding was identified, if applicable. Null for corporate, distribution center, or e-commerce findings.',
    `parent_audit_finding_id` BIGINT COMMENT 'Self-referencing FK on audit_finding (related_audit_finding_id)',
    `associate_id` BIGINT COMMENT 'Reference to the auditor or inspector who identified and documented this finding. May be internal auditor, third-party auditor, or regulatory inspector.',
    `primary_previous_finding_audit_finding_id` BIGINT COMMENT 'Reference to the previous audit finding record if this is a recurrence. Null if this is the first occurrence.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Audit findings frequently identify specific non-compliant SKUs (expired products on shelf, mislabeled items, unauthorized SKUs, temperature abuse). Essential for corrective action plans, inventory dis',
    `tertiary_audit_verified_by_associate_id` BIGINT COMMENT 'Reference to the auditor or compliance officer who verified the corrective action completion. Null if not yet verified.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Audit findings at vendor facilities (non-compliance, quality issues, labor violations) require vendor-level tracking. Corrective action plans are assigned to vendors, impacting supplier approval and s',
    `affected_area` STRING COMMENT 'The business area, department, store location, distribution center, process, or system affected by the finding (e.g., Store #1234 Bakery Department, DC-West Receiving Dock, Payment Processing System, Cold Chain Transport).',
    `audit_finding_status` STRING COMMENT 'Current lifecycle status of the finding. Open: newly identified; In Remediation: corrective action in progress; Pending Verification: awaiting auditor verification; Closed: resolved and verified; Disputed: under review or appeal.. Valid values are `open|in_remediation|pending_verification|closed|disputed`',
    `audit_finding_category` STRING COMMENT 'Severity classification of the finding. Critical: immediate risk to safety/compliance; Major: significant non-conformance requiring prompt action; Minor: isolated deficiency; Observation: improvement opportunity without non-conformance.. Valid values are `critical|major|minor|observation`',
    `closed_date` DATE COMMENT 'The date on which the finding was formally closed after successful verification of corrective action. Null if finding is not yet closed.',
    `control_reference` STRING COMMENT 'Specific control number, clause, section, or requirement citation from the regulatory standard that was violated or assessed (e.g., PCI DSS Requirement 3.4, OSHA 1910.22(a)(1), GDPR Article 32(1)(b)).',
    `corrective_action_plan` STRING COMMENT 'Detailed description of the corrective action plan developed to address the finding, including specific steps, resources, and timelines.',
    `corrective_action_required_flag` BOOLEAN COMMENT 'Indicates whether a formal corrective action plan is required to address this finding. True for critical, major, and most minor findings; False for observations that are advisory only.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit finding record was first created in the system. Audit trail for data governance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the financial impact amount (e.g., USD, EUR, GBP). Null if financial impact is not quantified.. Valid values are `^[A-Z]{3}$`',
    `audit_finding_description` STRING COMMENT 'Detailed narrative description of the compliance deficiency, observation, or non-conformance identified during the audit. Includes context, evidence, and specific details of what was observed.',
    `due_date` DATE COMMENT 'The target date by which corrective action must be completed and verified. Driven by regulatory timelines or internal policy based on finding severity.',
    `evidence_location` STRING COMMENT 'File path, document management system reference, or storage location where supporting evidence (photos, documents, logs) for this finding is stored.',
    `financial_impact_amount` DECIMAL(18,2) COMMENT 'Estimated or actual financial impact of the finding, including potential fines, penalties, remediation costs, or lost revenue. Null if not quantified.',
    `finding_number` STRING COMMENT 'Business-facing sequential or hierarchical identifier for the finding within the audit event (e.g., F-001, 2024-Q1-FDA-003). Used for tracking and communication.',
    `identified_date` DATE COMMENT 'The date on which the finding was identified during the audit event. Represents the real-world observation date.',
    `notes` STRING COMMENT 'Additional free-text notes, comments, or context related to the finding, corrective action, or verification process. Used for collaboration and audit trail.',
    `photographic_evidence_flag` BOOLEAN COMMENT 'Indicates whether photographic or video evidence was captured to document the finding. True if evidence exists; False otherwise.',
    `recurrence_flag` BOOLEAN COMMENT 'Indicates whether this finding is a recurrence of a previously identified and closed finding. True if recurring; False if first occurrence.',
    `regulatory_report_date` DATE COMMENT 'The date on which this finding was reported to the external regulatory authority, if applicable. Null if not yet reported or reporting not required.',
    `regulatory_reporting_required_flag` BOOLEAN COMMENT 'Indicates whether this finding must be reported to an external regulatory body (FDA, OSHA, PCI SSC, state agencies). True if external reporting is mandatory; False otherwise.',
    `regulatory_standard` STRING COMMENT 'The specific regulatory framework, standard, or compliance program violated or referenced by this finding (e.g., FDA FSMA, OSHA 1910.22, PCI DSS 3.2.1, GDPR Article 32, ISO 9001:2015).',
    `root_cause` STRING COMMENT 'Documented root cause analysis explaining the underlying reason for the deficiency. Completed during corrective action planning to prevent recurrence.',
    `title` STRING COMMENT 'Concise summary title of the compliance deficiency or observation. Provides quick identification of the issue.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit finding record was last modified. Audit trail for data governance and change tracking.',
    `verification_date` DATE COMMENT 'The date on which corrective action was verified as complete and effective by the auditor or compliance team. Null if not yet verified.',
    `verification_method` STRING COMMENT 'The method by which corrective action completion will be verified (e.g., follow-up audit, document review, photographic evidence, system validation, third-party certification).',
    CONSTRAINT pk_audit_finding PRIMARY KEY(`audit_finding_id`)
) COMMENT 'Individual compliance deficiency or observation identified during an audit event. Captures finding title, finding description, finding category (critical, major, minor, observation), regulatory standard violated, specific control or requirement reference, affected area or process, photographic evidence flag, corrective action required flag, and finding status (open, in remediation, closed, disputed). Each audit event may generate multiple findings. Drives the corrective action workflow and regulatory reporting obligations.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`corrective_action` (
    `corrective_action_id` BIGINT COMMENT 'Unique identifier for the corrective action record. Primary key for the corrective action entity.',
    `audit_finding_id` BIGINT COMMENT 'Reference to the compliance audit finding or regulatory violation that triggered this corrective action.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Corrective actions for DC-specific findings (equipment safety, temperature control failures, hazmat storage violations) require facility-level assignment and verification. Existing location_id covers',
    `environmental_event_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_event. Business justification: Environmental events (spills, waste disposal issues, etc.) require corrective actions. This FK links the corrective action to the environmental event that triggered it. Cardinality: Many corrective ac',
    `follow_up_corrective_action_id` BIGINT COMMENT 'Self-referencing FK on corrective_action (follow_up_corrective_action_id)',
    `location_id` BIGINT COMMENT 'Reference to the store, distribution center, or facility where the corrective action is being implemented.',
    `osha_incident_id` BIGINT COMMENT 'Foreign key linking to compliance.osha_incident. Business justification: OSHA incidents require corrective actions to remediate workplace safety issues. This FK links the corrective action to the incident that triggered it. Cardinality: Many corrective actions → One incide',
    `associate_id` BIGINT COMMENT 'Reference to the employee or team member responsible for executing and completing the corrective action.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Corrective actions often target specific SKUs (relabeling campaigns, reformulation projects, discontinuation decisions, packaging changes). Product-specific remediation is core to compliance managemen',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Corrective actions for vendor non-compliance (food safety, labor, quality) are assigned to suppliers. Completion tracking, verification, and vendor scorecard impact require vendor-level attribution.',
    `violation_notice_id` BIGINT COMMENT 'Foreign key linking to compliance.violation_notice. Business justification: Corrective actions can be triggered by violation notices in addition to audit findings. This provides an alternative parent for corrective actions. Cardinality: Many corrective actions → One violation',
    `action_number` STRING COMMENT 'Business identifier for the corrective action, typically formatted as CA-NNNNNN for external reference and tracking.. Valid values are `^CA-[0-9]{6,10}$`',
    `action_type` STRING COMMENT 'Classification of the corrective action approach: immediate fix (quick remediation), process change (workflow modification), training (employee education), system update (IT system enhancement), policy revision (documentation update), or equipment upgrade (physical asset replacement).. Valid values are `immediate_fix|process_change|training|system_update|policy_revision|equipment_upgrade`',
    `actual_completion_date` DATE COMMENT 'Actual date when the corrective action was completed. Null if still in progress.',
    `actual_cost` DECIMAL(18,2) COMMENT 'Actual financial cost incurred to implement the corrective action. Null if not yet completed or cost not yet finalized.',
    `assigned_department` STRING COMMENT 'Business department or functional area responsible for implementing the corrective action (e.g., Store Operations, Food Safety, IT Security, Human Resources).',
    `assigned_owner_name` STRING COMMENT 'Full name of the employee or team member assigned as the owner of this corrective action.',
    `closure_date` DATE COMMENT 'Date when the corrective action was formally closed after successful verification. Null if not yet closed.',
    `closure_notes` STRING COMMENT 'Final summary notes documenting the closure of the corrective action, including lessons learned and recommendations for preventive actions.',
    `compliance_category` STRING COMMENT 'High-level compliance domain category: food_safety (FDA/FSMA), workplace_safety (OSHA), payment_security (PCI-DSS), data_privacy (GDPR/CCPA), environmental (EPA), or product_safety (CPSC).. Valid values are `food_safety|workplace_safety|payment_security|data_privacy|environmental|product_safety`',
    `corrective_action_status` STRING COMMENT 'Current lifecycle status of the corrective action: open (newly created), in_progress (work underway), pending_verification (awaiting validation), closed (completed and verified), or overdue (past target completion date).. Valid values are `open|in_progress|pending_verification|closed|overdue`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the corrective action record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for estimated and actual cost amounts (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `corrective_action_description` STRING COMMENT 'Detailed description of the corrective action plan, including specific steps, resources, and expected outcomes.',
    `effectiveness_rating` STRING COMMENT 'Assessment of whether the corrective action successfully addressed the root cause: effective (fully resolved), partially_effective (improvement but not complete), ineffective (did not resolve issue), or pending (awaiting verification).. Valid values are `effective|partially_effective|ineffective|pending`',
    `escalation_date` DATE COMMENT 'Date when the corrective action was escalated to senior management or regulatory authorities. Null if no escalation occurred.',
    `escalation_required` BOOLEAN COMMENT 'Boolean flag indicating whether this corrective action requires escalation to senior management or regulatory authorities due to severity or complexity.',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Estimated financial cost to implement the corrective action, including labor, materials, training, and system changes.',
    `external_report_date` DATE COMMENT 'Date when the corrective action was reported to external regulatory authorities. Null if no external reporting occurred.',
    `external_reporting_required` BOOLEAN COMMENT 'Boolean flag indicating whether this corrective action must be reported to external regulatory bodies (FDA, OSHA, FTC, etc.).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the corrective action record was last updated or modified.',
    `priority` STRING COMMENT 'Business priority level assigned to the corrective action based on risk severity, regulatory impact, and business criticality.. Valid values are `critical|high|medium|low`',
    `recurrence_prevention_plan` STRING COMMENT 'Description of preventive measures and controls implemented to prevent recurrence of the same or similar compliance violations.',
    `regulatory_framework` STRING COMMENT 'Specific regulatory framework or standard that governs this corrective action (e.g., FDA FSMA, OSHA, PCI-DSS, GDPR, CCPA, ISO 9001, ISO 22000).',
    `root_cause_description` STRING COMMENT 'Analysis and description of the underlying root cause of the compliance violation or audit finding that necessitated this corrective action.',
    `target_completion_date` DATE COMMENT 'Planned date by which the corrective action must be completed to meet regulatory or business requirements.',
    `title` STRING COMMENT 'Brief descriptive title summarizing the corrective action to be taken.',
    `verification_date` DATE COMMENT 'Date when the corrective action effectiveness was verified and validated. Null if verification has not yet occurred.',
    `verification_method` STRING COMMENT 'Method used to verify and validate that the corrective action was effective: document review, on-site inspection, testing, audit, management review, or third-party validation.. Valid values are `document_review|on_site_inspection|testing|audit|management_review|third_party_validation`',
    `verification_notes` STRING COMMENT 'Detailed notes and observations from the verification process, including evidence of effectiveness and any residual concerns.',
    `verified_by_name` STRING COMMENT 'Full name of the person who verified the corrective action effectiveness.',
    CONSTRAINT pk_corrective_action PRIMARY KEY(`corrective_action_id`)
) COMMENT 'Operational record tracking the remediation workflow for a compliance audit finding or regulatory violation. Captures corrective action title, root cause description, corrective action type (immediate fix, process change, training, system update, policy revision), assigned owner, target completion date, actual completion date, verification method, verification date, and closure status (open, in progress, pending verification, closed, overdue). Supports CAPA (Corrective and Preventive Action) management required by FDA/FSMA and ISO standards.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` (
    `food_safety_plan_id` BIGINT COMMENT 'Unique identifier for the food safety plan record. Primary key for the food safety plan entity.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Food safety plans are maintained under the FDA/FSMA food safety compliance program. This FK links each plan to the master compliance program record. Cardinality: Many plans → One program (N:1). This p',
    `dc_facility_id` BIGINT COMMENT 'Reference to the retail location, distribution center, or food production facility where this food safety plan is maintained and enforced.',
    `superseded_food_safety_plan_id` BIGINT COMMENT 'Self-referencing FK on food_safety_plan (superseded_food_safety_plan_id)',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Retailers require vendor food safety plans for FSMA compliance. Supplier approval, HACCP validation, and preventive controls verification are vendor-specific. Critical for inbound product acceptance a',
    `allergen_controls_included` BOOLEAN COMMENT 'Indicates whether this food safety plan includes specific preventive controls for managing food allergens (major allergens per FALCPA).',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this food safety plan record was first created in the system.',
    `critical_control_points_count` STRING COMMENT 'The number of Critical Control Points identified in this food safety plan where control is essential to prevent or eliminate a food safety hazard.',
    `document_location` STRING COMMENT 'The physical or digital location where the complete food safety plan documentation is stored and maintained for regulatory inspection.',
    `environmental_monitoring_program` BOOLEAN COMMENT 'Indicates whether this food safety plan includes an environmental monitoring program for detecting pathogens in the production environment.',
    `facility_scope` STRING COMMENT 'Description of the facility areas, operations, and food categories covered by this food safety plan (e.g., bakery operations, deli department, produce handling, meat processing).',
    `fda_registration_number` STRING COMMENT 'The unique FDA facility registration number assigned to the food facility where this plan is implemented, required under FDA Food Facility Registration.',
    `hazard_analysis_completion_date` DATE COMMENT 'The date when the comprehensive hazard analysis (biological, chemical, physical, and radiological hazards) was completed for this food safety plan.',
    `last_audit_date` DATE COMMENT 'The date of the most recent internal or external audit of this food safety plan and its implementation at the facility.',
    `last_audit_result` STRING COMMENT 'The outcome of the most recent audit, indicating compliance status and severity of any findings.. Valid values are `compliant|non-compliant|minor findings|major findings|pending`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this food safety plan record was most recently updated or modified.',
    `last_regulatory_inspection_date` DATE COMMENT 'The date of the most recent inspection by FDA or other regulatory authority at the facility covered by this food safety plan.',
    `modified_by_user` STRING COMMENT 'The username or identifier of the person who last modified this food safety plan record.',
    `next_audit_due_date` DATE COMMENT 'The scheduled date for the next internal or external audit of this food safety plan.',
    `next_review_due_date` DATE COMMENT 'The scheduled date for the next mandatory review of the food safety plan to ensure continued compliance and effectiveness.',
    `notes` STRING COMMENT 'Additional notes, comments, or special instructions related to this food safety plan, including any deviations, special circumstances, or implementation guidance.',
    `plan_approval_date` DATE COMMENT 'The date when this food safety plan was officially approved by the qualified food safety professional and authorized for implementation.',
    `plan_effective_date` DATE COMMENT 'The date when this food safety plan became active and enforceable at the facility.',
    `plan_expiration_date` DATE COMMENT 'The date when this food safety plan version expires and must be renewed or replaced, if applicable.',
    `plan_name` STRING COMMENT 'The official name or title of the food safety plan document as registered with regulatory authorities.',
    `plan_review_date` DATE COMMENT 'The date of the most recent comprehensive review of the food safety plan, required at least once every three years or when significant changes occur.',
    `plan_status` STRING COMMENT 'The current lifecycle status of the food safety plan indicating whether it is actively enforced, under review for updates, awaiting approval, expired, or superseded by a newer version.. Valid values are `active|under review|pending approval|expired|superseded|suspended`',
    `plan_type` STRING COMMENT 'The regulatory framework and methodology used for this food safety plan. HACCP (Hazard Analysis and Critical Control Points) for traditional food safety, HARPC (Hazard Analysis and Risk-Based Preventive Controls) for FSMA compliance, or other FDA-mandated plan types.. Valid values are `HACCP|HARPC|Preventive Controls|Juice HACCP|Seafood HACCP|Produce Safety`',
    `plan_version` STRING COMMENT 'Version number or identifier for this iteration of the food safety plan, used to track revisions and updates over time.',
    `preventive_controls_summary` STRING COMMENT 'High-level summary of the preventive controls implemented under this plan, including process controls, allergen controls, sanitation controls, supply chain controls, and recall plan.',
    `qfsp_certification_date` DATE COMMENT 'The date when the QFSP completed their qualifying training or obtained their food safety certification.',
    `qfsp_contact_email` STRING COMMENT 'The business email address of the QFSP responsible for this food safety plan.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `qfsp_contact_phone` STRING COMMENT 'The business phone number of the QFSP responsible for this food safety plan.',
    `qfsp_credentials` STRING COMMENT 'The professional certifications, training completion records, and qualifications of the QFSP (e.g., FSPCA Preventive Controls for Human Food course completion, HACCP certification).',
    `qfsp_name` STRING COMMENT 'The full name of the Preventive Controls Qualified Individual (PCQI) or Qualified Food Safety Professional who prepared or supervised the preparation of this food safety plan.',
    `recall_plan_included` BOOLEAN COMMENT 'Indicates whether this food safety plan includes a written recall plan for rapid product removal from commerce in the event of a food safety incident.',
    `record_retention_years` STRING COMMENT 'The number of years that records associated with this food safety plan must be retained per regulatory requirements (typically 2 years for most FSMA records).',
    `regulatory_authority` STRING COMMENT 'The primary regulatory body with jurisdiction over this food safety plan (e.g., FDA, state health department, USDA FSIS for meat/poultry).',
    `supply_chain_program_included` BOOLEAN COMMENT 'Indicates whether this food safety plan includes a supply chain preventive controls program for managing risks from suppliers and raw materials.',
    `verification_activities_summary` STRING COMMENT 'Summary of the verification activities defined in the plan, including monitoring, verification procedures, corrective actions, and validation activities.',
    CONSTRAINT pk_food_safety_plan PRIMARY KEY(`food_safety_plan_id`)
) COMMENT 'Master record for FDA/FSMA-mandated food safety plans (HACCP/HARPC) maintained at each retail location or food production facility. Captures plan name, facility scope, plan version, FDA registration number, plan type (HACCP, HARPC, Preventive Controls), hazard analysis completion date, plan approval date, plan review date, qualified food safety professional (QFSP) name and credentials, and plan status (active, under review, expired). Required for FDA FSMA Preventive Controls for Human Food compliance across grocery and food service operations.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` (
    `haccp_control_point_id` BIGINT COMMENT 'Unique identifier for the HACCP control point record. Primary key.',
    `food_safety_plan_id` BIGINT COMMENT 'Reference to the parent food safety plan that contains this control point. Each control point belongs to a specific food safety plan document.',
    `parent_haccp_control_point_id` BIGINT COMMENT 'Self-referencing FK on haccp_control_point (parent_haccp_control_point_id)',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Supplier HACCP controls (critical limits, monitoring procedures) are verified during vendor audits. Retailers track vendor-specific control points for supply chain risk management and regulatory compl',
    `allergen_control_flag` BOOLEAN COMMENT 'Indicates whether this control point specifically addresses allergen cross-contact prevention or allergen labeling accuracy. Allergen controls are a critical subset of preventive controls.',
    `approval_date` DATE COMMENT 'Date when the Preventive Controls Qualified Individual approved this control point or its most recent modification.',
    `approved_by_pcqi` STRING COMMENT 'Name or ID of the Preventive Controls Qualified Individual who reviewed and approved this control point. FDA FSMA requires PCQI oversight of food safety plans.',
    `control_point_code` STRING COMMENT 'Unique business identifier or code for the control point used in operational documentation and audit trails (e.g., CCP-001, PC-ALLER-05).',
    `control_point_name` STRING COMMENT 'Business name of the critical control point or preventive control (e.g., Cooking Temperature Control, Metal Detection, Allergen Cleaning Verification).',
    `control_point_status` STRING COMMENT 'Current operational status of the control point within the food safety plan. Active control points are currently enforced. Inactive or archived control points are no longer in use but retained for historical compliance records.. Valid values are `active|inactive|under_review|suspended|archived`',
    `control_point_type` STRING COMMENT 'Classification of the control point within the food safety management system. Critical Control Points (CCPs) are points where control is essential to prevent or eliminate a food safety hazard. Preventive controls are broader risk-based measures.. Valid values are `critical_control_point|prerequisite_program|preventive_control|allergen_control|sanitation_control|supply_chain_control`',
    `corrective_action_procedure` STRING COMMENT 'Documented procedure to be followed when monitoring indicates a deviation from the critical limit. Includes steps to identify cause, correct the deviation, prevent recurrence, and handle affected product.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this control point record was first created in the system. Part of audit trail for regulatory compliance and change management.',
    `critical_limit_parameter` STRING COMMENT 'The measurable parameter that defines the boundary of safety for this control point (e.g., Temperature, Time, pH, Water Activity, Metal Detection Sensitivity, Chlorine Concentration).',
    `critical_limit_unit` STRING COMMENT 'Unit of measurement for the critical limit value (e.g., degrees Fahrenheit, degrees Celsius, minutes, hours, pH units, ppm, mm).',
    `critical_limit_value` DECIMAL(18,2) COMMENT 'The specific threshold value that must be met or maintained to ensure food safety (e.g., 165°F minimum, pH below 4.6, 2 hours maximum, 1.5mm ferrous detection). May include ranges or multiple conditions.',
    `effective_date` DATE COMMENT 'Date when this control point became or will become operational and enforceable within the food safety plan.',
    `environmental_monitoring_flag` BOOLEAN COMMENT 'Indicates whether this control point includes environmental monitoring for pathogens (e.g., Listeria in ready-to-eat food production environments). Required for certain high-risk food categories.',
    `expiration_date` DATE COMMENT 'Date when this control point is scheduled to be reviewed, updated, or retired. Null if the control point has no planned end date. Supports periodic revalidation requirements.',
    `gfsi_scheme_alignment` STRING COMMENT 'Identifies which GFSI-benchmarked certification scheme this control point supports (e.g., SQF, BRC, FSSC 22000, IFS). Used when facility maintains third-party food safety certifications.',
    `hazard_description` STRING COMMENT 'Detailed description of the specific food safety hazard being controlled at this point (e.g., Survival of Salmonella in raw poultry, Cross-contamination of allergens during packaging, Metal fragments from equipment wear).',
    `hazard_type` STRING COMMENT 'Category of food safety hazard addressed by this control point. Biological hazards include pathogens (Salmonella, Listeria, E. coli). Chemical hazards include pesticides, cleaning agents, toxins. Physical hazards include metal, glass, plastic. Allergens are a special category of chemical hazards.. Valid values are `biological|chemical|physical|radiological|allergen`',
    `last_validation_date` DATE COMMENT 'Date when the control point was last validated to ensure it effectively controls the identified hazard. FDA FSMA requires revalidation at least every 3 years or when significant changes occur.',
    `likelihood_level` STRING COMMENT 'Probability that the hazard will occur if the control point is not properly managed. Combined with severity to determine overall risk level.. Valid values are `high|medium|low|negligible`',
    `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this control point record. Supports accountability and change management for food safety plan modifications.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this control point record was last modified. Any change to critical limits, monitoring procedures, or corrective actions must be documented with timestamp for audit trail.',
    `monitoring_equipment` STRING COMMENT 'Specific equipment or instruments used to perform monitoring (e.g., Digital probe thermometer Model XYZ, Metal detector Unit 5, pH meter, ATP luminometer). Supports calibration and maintenance tracking.',
    `monitoring_frequency` STRING COMMENT 'How often the control point must be monitored and measured (e.g., Continuous, Every batch, Every 2 hours, Daily, Per shift, Each production run).',
    `monitoring_method` STRING COMMENT 'The procedure or technique used to measure and verify the critical limit (e.g., Calibrated thermometer reading, Metal detector scan, Visual inspection, ATP swab test, pH meter measurement, Time-temperature recording).',
    `next_validation_due_date` DATE COMMENT 'Scheduled date for the next required validation of this control point. Used for compliance tracking and audit preparation.',
    `notes` STRING COMMENT 'Additional operational notes, special instructions, or contextual information about the control point. May include seasonal variations, equipment-specific considerations, or historical context.',
    `prerequisite_program_flag` BOOLEAN COMMENT 'Indicates whether this control point is part of a prerequisite program (basic conditions and activities necessary to maintain a hygienic environment) rather than a process-specific preventive control.',
    `process_step` STRING COMMENT 'The specific step in the food production or handling process where this control point is applied (e.g., Receiving, Cooking, Cooling, Packaging, Storage, Distribution).',
    `record_keeping_requirement` STRING COMMENT 'Documentation requirements for this control point including what records must be maintained, format, retention period, and storage location. Supports regulatory compliance and audit trails.',
    `regulatory_reference` STRING COMMENT 'Specific regulatory citation or standard that mandates or guides this control point (e.g., FDA 21 CFR 117.135, USDA 9 CFR 417, Codex CAC/RCP 1-1969, GFSI requirement).',
    `responsible_role` STRING COMMENT 'Job role or position responsible for monitoring this control point (e.g., Line Supervisor, Quality Technician, Receiving Manager, Sanitation Lead). Used for training and accountability.',
    `severity_level` STRING COMMENT 'Risk severity classification of the hazard controlled by this point. Critical severity indicates potential for serious adverse health consequences or death. Used for risk prioritization and resource allocation.. Valid values are `critical|major|moderate|minor`',
    `supplier_control_flag` BOOLEAN COMMENT 'Indicates whether this control point is part of the supply chain preventive controls program, addressing hazards in incoming raw materials and ingredients through supplier verification.',
    `validation_method` STRING COMMENT 'Scientific or technical approach used to validate that the control point effectively controls the hazard (e.g., Challenge study, Inoculation study, Literature review, Historical data analysis, Predictive modeling).',
    `verification_frequency` STRING COMMENT 'How often verification activities must be performed (e.g., Weekly, Monthly, Quarterly, Annually, Before each production run).',
    `verification_procedure` STRING COMMENT 'Methods used to verify that the control point is working as intended. May include calibration checks, record review, testing, audits, and validation studies.',
    CONSTRAINT pk_haccp_control_point PRIMARY KEY(`haccp_control_point_id`)
) COMMENT 'Individual Critical Control Point (CCP) or Preventive Control defined within a food safety plan. Captures control point name, control point type (CCP, prerequisite program, allergen control, sanitation control, supply chain control), hazard type (biological, chemical, physical, radiological), critical limit (temperature, pH, time, etc.), monitoring frequency, monitoring method, corrective action procedure, and verification procedure. Each food safety plan contains multiple control points that must be monitored and documented during food handling operations.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` (
    `food_safety_log_id` BIGINT COMMENT 'Unique identifier for the food safety monitoring log entry. Primary key for the food safety log product.',
    `corrected_food_safety_log_id` BIGINT COMMENT 'Self-referencing FK on food_safety_log (corrected_food_safety_log_id)',
    `dc_facility_id` BIGINT COMMENT 'add column dc_facility_id (BIGINT) with FK to supplychain.dc_facility.dc_facility_id - food safety logs are recorded at DC facilities in addition to store locations',
    `haccp_control_point_id` BIGINT COMMENT 'Foreign key linking to compliance.haccp_control_point. Business justification: Food safety logs are monitoring records for specific HACCP control points. Each log entry records monitoring activities against a defined control point. Cardinality: Many logs → One control point (1:N',
    `location_id` BIGINT COMMENT 'Identifier of the retail location where the food safety monitoring activity was performed.',
    `associate_id` BIGINT COMMENT 'Identifier of the employee who performed the monitoring activity. Required for accountability and training verification.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Food safety monitoring tracks specific products (temperature logs for refrigerated SKUs, cooking temps for prepared foods, allergen cross-contamination for specific items). Real-world HACCP implementa',
    `audit_trail_reference` STRING COMMENT 'Unique identifier linking this record to the broader audit trail and compliance documentation system. Enables cross-referencing with inspection reports and corrective action logs.',
    `comments` STRING COMMENT 'Additional notes, observations, or context related to the monitoring activity, deviation, or corrective action. Provides supplementary information for audit and investigation purposes.',
    `control_point_type` STRING COMMENT 'Classification of the control point monitored: CCP (Critical Control Point per HACCP), CP (Control Point), or PRP (Prerequisite Program). Determines the level of regulatory scrutiny and corrective action requirements.. Valid values are `ccp|cp|prp`',
    `corrective_action_required` BOOLEAN COMMENT 'Boolean flag indicating whether a corrective action was required due to critical limit deviation or other food safety concern.',
    `corrective_action_taken` STRING COMMENT 'Detailed description of the corrective action taken in response to a critical limit deviation or food safety concern. Required for regulatory compliance and audit documentation.',
    `corrective_action_timestamp` TIMESTAMP COMMENT 'Date and time when the corrective action was completed. Critical for demonstrating timely response to food safety deviations.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this monitoring log record was first created in the database. Required for audit trail and data lineage.',
    `critical_limit_lower` DECIMAL(18,2) COMMENT 'Lower boundary of the acceptable range for the control point as defined in the HACCP or HARPC plan. Values below this threshold indicate a deviation requiring corrective action.',
    `critical_limit_upper` DECIMAL(18,2) COMMENT 'Upper boundary of the acceptable range for the control point as defined in the HACCP or HARPC plan. Values above this threshold indicate a deviation requiring corrective action.',
    `department` STRING COMMENT 'Store department where the monitoring activity was conducted. Identifies the operational area subject to food safety controls. [ENUM-REF-CANDIDATE: deli|bakery|produce|seafood|meat|dairy|frozen|grocery — 8 candidates stripped; promote to reference product]',
    `deviation_severity` STRING COMMENT 'Severity classification of any deviation from critical limits: none (within limits), minor (approaching limits), major (exceeds limits), or critical (significant food safety risk). Determines escalation and reporting requirements.. Valid values are `none|minor|major|critical`',
    `equipment_code` STRING COMMENT 'Identifier of the specific equipment or asset being monitored (e.g., refrigerator unit number, oven identifier, display case number). Enables equipment-level traceability and maintenance correlation.',
    `health_department_reportable` BOOLEAN COMMENT 'Boolean flag indicating whether this monitoring record or deviation must be reported to local health department authorities per regulatory requirements.',
    `instrument_calibration_date` DATE COMMENT 'Date when the monitoring instrument was last calibrated. Required to ensure measurement accuracy and regulatory compliance.',
    `instrument_code` STRING COMMENT 'Identifier of the measuring instrument or device used (e.g., thermometer serial number, pH meter ID). Required for calibration tracking and measurement traceability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this monitoring log record was last updated. Required for audit trail and change tracking.',
    `limit_status` STRING COMMENT 'Indicates whether the measured value falls within acceptable limits, exceeds critical limits, or is approaching limits. Determines whether corrective action is required.. Valid values are `within_limit|limit_exceeded|limit_approached`',
    `measured_value` DECIMAL(18,2) COMMENT 'Numeric value recorded during the monitoring activity (e.g., temperature reading in degrees, pH level, time elapsed in minutes, sanitizer concentration in ppm).',
    `monitoring_employee_name` STRING COMMENT 'Full name of the employee who performed the monitoring activity. Required for FDA FSMA compliance documentation and audit trail.',
    `monitoring_method` STRING COMMENT 'Method used to perform the monitoring activity: manual measurement, automated sensor, calibrated instrument, or visual inspection. Impacts data reliability and audit requirements.. Valid values are `manual|automated|calibrated_instrument|visual_inspection`',
    `monitoring_timestamp` TIMESTAMP COMMENT 'Date and time when the food safety monitoring activity was performed. Critical for establishing compliance timeline and traceability.',
    `product_affected` STRING COMMENT 'Description or identifier of the food product(s) affected by the monitoring activity or deviation. Critical for traceability and potential recall actions.',
    `product_disposition` STRING COMMENT 'Final disposition of affected product following monitoring or corrective action: released for sale, held for further evaluation, destroyed, reworked, or returned to vendor.. Valid values are `released|held|destroyed|reworked|returned`',
    `record_status` STRING COMMENT 'Current status of the monitoring log record in the compliance workflow: draft (in progress), submitted (awaiting verification), verified (supervisor approved), or archived (retained for regulatory period).. Valid values are `draft|submitted|verified|archived`',
    `supervisor_name` STRING COMMENT 'Full name of the supervisor or qualified individual who verified the monitoring record. Required for FDA compliance documentation.',
    `supervisor_verified` BOOLEAN COMMENT 'Boolean flag indicating whether a supervisor or qualified individual has reviewed and verified the monitoring record and any corrective actions taken.',
    `unit_of_measure` STRING COMMENT 'Unit of measurement for the recorded value (e.g., Fahrenheit, Celsius, minutes, hours, parts per million, pH scale, percentage). [ENUM-REF-CANDIDATE: fahrenheit|celsius|minutes|hours|ppm|ph|percent — 7 candidates stripped; promote to reference product]',
    `verification_signature` STRING COMMENT 'Electronic or digitized signature of the supervisor verifying the monitoring record. Required for regulatory compliance and audit trail integrity.',
    `verification_timestamp` TIMESTAMP COMMENT 'Date and time when the supervisor verification was completed. Establishes timeline for management oversight and compliance review.',
    CONSTRAINT pk_food_safety_log PRIMARY KEY(`food_safety_log_id`)
) COMMENT 'Transactional log of food safety monitoring activities performed at retail locations against HACCP/HARPC control points. Captures monitoring date and time, location, department (deli, bakery, produce, seafood, meat), control point monitored, measured value (temperature reading, pH level, time elapsed), critical limit status (within limit, limit exceeded), monitoring employee name, corrective action taken flag, and supervisor verification signature. Required for FDA FSMA compliance documentation and health department inspections.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`osha_incident` (
    `osha_incident_id` BIGINT COMMENT 'Unique identifier for the OSHA-recordable workplace safety incident. Primary key. _canonical_skip_reason: This product is explicitly marked as a duplicate of workforce.osha_incident and should not be generated. However, proceeding with schema design as instructed.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: OSHA incidents are tracked under the OSHA workplace safety compliance program. This FK links each incident to the master compliance program record. Cardinality: Many incidents → One program (N:1). Thi',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Workplace injuries occur at DCs (forklifts, conveyors, loading docks). OSHA 300 logs require facility-level aggregation for regulatory filings. Location_id covers stores; DCs need separate tracking.',
    `location_id` BIGINT COMMENT 'Identifier of the retail location (store, distribution center, or corporate office) where the incident occurred.',
    `parent_osha_incident_id` BIGINT COMMENT 'Self-referencing FK on osha_incident (related_osha_incident_id)',
    `associate_id` BIGINT COMMENT 'Unique identifier of the employee involved in the incident. Protected as personally identifiable information.',
    `primary_previous_incident_osha_incident_id` BIGINT COMMENT 'Reference to a previous related incident if this is a recurrence or follow-up event.',
    `tertiary_osha_investigator_employee_associate_id` BIGINT COMMENT 'Identifier of the safety professional or manager assigned to investigate the incident.',
    `body_part_affected` STRING COMMENT 'The specific body part or region injured in the incident: head, neck, back, shoulder, arm, hand, finger, leg, knee, ankle, foot, multiple body parts, etc. Null for non-injury incidents.',
    `case_closed_date` DATE COMMENT 'The date the incident case was officially closed after all corrective actions were completed and verified.',
    `corrective_action_plan` STRING COMMENT 'Detailed description of corrective and preventive actions implemented to prevent recurrence: equipment repair, process modification, additional training, policy update, engineering controls, etc.',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated cost amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this incident record was first created in the system.',
    `days_away_from_work` STRING COMMENT 'Total number of calendar days the employee was unable to work as a result of the incident, excluding the day of injury. Used for OSHA 300 Log column H.',
    `days_restricted_duty` STRING COMMENT 'Total number of calendar days the employee was on restricted work activity or job transfer due to the incident. Used for OSHA 300 Log column I.',
    `estimated_cost_amount` DECIMAL(18,2) COMMENT 'Estimated total cost of the incident including medical expenses, lost time, workers compensation, property damage, and administrative costs.',
    `incident_date` DATE COMMENT 'The calendar date on which the workplace safety incident occurred.',
    `incident_description` STRING COMMENT 'Detailed narrative description of how the incident occurred, including the sequence of events, equipment involved, environmental conditions, and any contributing factors.',
    `incident_number` STRING COMMENT 'Business-assigned unique incident tracking number following the format: location code, year, and sequential number (e.g., DC01-2024-000123).. Valid values are `^[A-Z]{2,4}-d{4}-d{6}$`',
    `incident_timestamp` TIMESTAMP COMMENT 'The precise date and time when the workplace safety incident occurred, including time zone information.',
    `incident_type` STRING COMMENT 'Primary classification of the incident: injury (physical harm to employee), illness (occupational disease), near-miss (potential incident with no harm), property damage, environmental event, or vehicle-related incident.. Valid values are `injury|illness|near_miss|property_damage|environmental|vehicle`',
    `injury_type` STRING COMMENT 'Specific nature of the injury sustained: laceration, strain, sprain, fracture, contusion, burn, chemical exposure, fall, struck by object, caught in equipment, repetitive motion, etc. Null for non-injury incidents.',
    `investigation_completed_date` DATE COMMENT 'The date the incident investigation was completed and findings documented.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this incident record was most recently updated.',
    `location_description` STRING COMMENT 'Specific area within the facility where the incident occurred: sales floor, stockroom, loading dock, parking lot, break room, warehouse aisle, etc.',
    `medical_facility_name` STRING COMMENT 'Name of the medical facility, hospital, or clinic where the employee received treatment, if applicable.',
    `notes` STRING COMMENT 'Additional free-form notes, comments, or observations related to the incident that do not fit in other structured fields.',
    `osha_300_log_entry_flag` BOOLEAN COMMENT 'Indicates whether the incident was entered on the OSHA 300 Log of Work-Related Injuries and Illnesses.',
    `osha_301_reportable_flag` BOOLEAN COMMENT 'Indicates whether the incident requires completion of OSHA Form 301 (Injury and Illness Incident Report) or equivalent documentation.',
    `osha_incident_status` STRING COMMENT 'Current status of the incident case in the investigation and resolution workflow.. Valid values are `reported|under_investigation|investigation_complete|closed|pending_review`',
    `osha_recordable_flag` BOOLEAN COMMENT 'Indicates whether the incident meets OSHA criteria for recordability on the OSHA 300 Log (requires medical treatment beyond first aid, days away from work, restricted duty, or loss of consciousness).',
    `photographic_evidence_flag` BOOLEAN COMMENT 'Indicates whether photographic or video evidence of the incident scene was collected as part of the investigation.',
    `privacy_case_flag` BOOLEAN COMMENT 'Indicates whether the incident qualifies as a privacy case under OSHA regulations (certain injuries or illnesses where employee name may be withheld from OSHA 300 Log).',
    `recurrence_flag` BOOLEAN COMMENT 'Indicates whether this incident is a recurrence of a similar previous incident at the same location or involving similar circumstances.',
    `regulatory_report_date` DATE COMMENT 'The date the incident was reported to OSHA or other regulatory authorities, if required.',
    `regulatory_reporting_required_flag` BOOLEAN COMMENT 'Indicates whether the incident must be reported to OSHA or other regulatory authorities (e.g., fatality, hospitalization of three or more employees, amputation, loss of eye).',
    `reported_date` DATE COMMENT 'The date the incident was officially reported to management or the safety department.',
    `root_cause` STRING COMMENT 'Identified underlying cause of the incident determined through investigation: unsafe condition, equipment failure, inadequate training, procedural violation, environmental factor, human error, etc.',
    `severity_level` STRING COMMENT 'Classification of the incidents severity based on injury extent, treatment required, and impact: minor (first aid only), moderate (medical treatment), serious (hospitalization), severe (permanent impairment), fatal (death).. Valid values are `minor|moderate|serious|severe|fatal`',
    `treatment_provided` STRING COMMENT 'Description of the medical treatment provided: first aid, medical treatment by physician, emergency room visit, hospitalization, surgery, physical therapy, etc.',
    `witness_count` STRING COMMENT 'Number of witnesses to the incident who provided statements during the investigation.',
    `work_activity` STRING COMMENT 'The specific work task or activity the employee was performing at the time of the incident: lifting, stocking shelves, operating equipment, customer service, maintenance, etc.',
    `workers_compensation_claim_number` STRING COMMENT 'The claim number assigned by the workers compensation insurance carrier for this incident, if a claim was filed.',
    CONSTRAINT pk_osha_incident PRIMARY KEY(`osha_incident_id`)
) COMMENT 'OSHA-recordable workplace safety incident records for all retail locations including stores, DCs, and corporate offices. Captures incident date and time, location, incident type (injury, illness, near-miss, property damage), injury type (laceration, strain, fall, chemical exposure), body part affected, days away from work, restricted duty days, OSHA recordability determination (300 log recordable, 301 reportable, non-recordable), incident description, root cause, and case status. NOTE: This product already exists in the workforce domain (workforce.osha_incident) — DO NOT DUPLICATE. This entry is intentionally excluded; see workforce domain.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` (
    `safety_inspection_id` BIGINT COMMENT 'Unique identifier for the workplace safety inspection record. Primary key.',
    `associate_id` BIGINT COMMENT 'Employee identifier of the internal safety inspector or auditor who conducted the inspection.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Safety inspections are conducted under OSHA and workplace safety compliance programs. This FK links each inspection to the master compliance program record. Cardinality: Many inspections → One program',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC safety inspections are mandatory retail operations covering equipment, hazmat storage, and OSHA compliance. Inspectors need facility-specific context for regulatory reporting and corrective action',
    `follow_up_safety_inspection_id` BIGINT COMMENT 'Self-referencing FK on safety_inspection (follow_up_safety_inspection_id)',
    `location_id` BIGINT COMMENT 'Identifier of the retail location, distribution center, or facility where the safety inspection was conducted.',
    `checklist_version` STRING COMMENT 'Version identifier of the safety inspection checklist or protocol used during this inspection. Ensures traceability to specific compliance standards.',
    `compliance_score` DECIMAL(18,2) COMMENT 'Calculated compliance score or percentage representing the overall safety compliance level achieved during the inspection (0-100 scale).',
    `corrective_action_deadline` DATE COMMENT 'Deadline date by which all corrective actions must be completed to achieve compliance.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether corrective actions are required to address identified safety violations or deficiencies.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this safety inspection record was first created in the system.',
    `critical_violations_count` STRING COMMENT 'Number of critical or high-severity safety violations identified that pose immediate risk to employee safety or regulatory non-compliance.',
    `emergency_preparedness_compliant` BOOLEAN COMMENT 'Indicates whether emergency preparedness standards were met including evacuation plans, emergency lighting, first aid kits, and emergency contact information.',
    `equipment_safety_compliant` BOOLEAN COMMENT 'Indicates whether equipment safety standards were met including machine guarding, lockout/tagout procedures, and powered industrial truck safety.',
    `ergonomics_compliant` BOOLEAN COMMENT 'Indicates whether workplace ergonomics standards were met to prevent musculoskeletal disorders including workstation setup, lifting procedures, and repetitive motion controls.',
    `fire_safety_compliant` BOOLEAN COMMENT 'Indicates whether the location passed fire safety inspection criteria including fire extinguishers, alarms, exits, and sprinkler systems.',
    `followup_inspection_date` DATE COMMENT 'Scheduled date for the follow-up inspection to verify corrective action completion.',
    `followup_inspection_required` BOOLEAN COMMENT 'Indicates whether a follow-up inspection is required to verify that corrective actions have been completed.',
    `hazmat_storage_compliant` BOOLEAN COMMENT 'Indicates whether hazardous materials and chemical storage met OSHA and EPA standards including proper labeling, SDS availability, and containment.',
    `inspection_date` DATE COMMENT 'Date on which the workplace safety inspection was conducted. Primary business event timestamp for this inspection.',
    `inspection_duration_minutes` STRING COMMENT 'Total duration of the inspection in minutes from start to completion.',
    `inspection_notes` STRING COMMENT 'Free-text notes and observations recorded by the inspector during the safety inspection including specific findings, recommendations, and context.',
    `inspection_number` STRING COMMENT 'Business-assigned unique inspection number or reference code for tracking and audit purposes.',
    `inspection_scope` STRING COMMENT 'Description of the areas, departments, or systems covered by this inspection (e.g., sales floor, warehouse, loading dock, HVAC systems, emergency exits).',
    `inspection_status` STRING COMMENT 'Current lifecycle status of the safety inspection: scheduled, in progress, completed, cancelled, or pending review by management.. Valid values are `scheduled|in_progress|completed|cancelled|pending_review`',
    `inspection_type` STRING COMMENT 'Classification of the inspection: routine scheduled inspection, triggered by incident or complaint, pre-opening inspection for new facility, regulatory inspection by external authority, incident follow-up, or annual comprehensive audit.. Valid values are `routine|triggered|pre_opening|regulatory|incident_followup|annual`',
    `inspector_certification_number` STRING COMMENT 'Professional certification or license number of the inspector (e.g., Certified Safety Professional, OSHA 30-Hour certification).',
    `inspector_name` STRING COMMENT 'Full name of the inspector who conducted the workplace safety inspection.',
    `inspector_role` STRING COMMENT 'Job title or role of the inspector (e.g., Safety Manager, EHS Specialist, Regional Safety Auditor, Third-Party Auditor).',
    `items_failed` STRING COMMENT 'Number of inspection items that did not meet safety standards and failed the inspection.',
    `items_passed` STRING COMMENT 'Number of inspection items that met safety standards and passed the inspection.',
    `location_manager_notified` BOOLEAN COMMENT 'Indicates whether the location or facility manager was notified of the inspection results and required corrective actions.',
    `major_violations_count` STRING COMMENT 'Number of major safety violations identified that require corrective action but do not pose immediate danger.',
    `minor_violations_count` STRING COMMENT 'Number of minor safety violations or observations that represent best-practice improvements but are not regulatory violations.',
    `overall_result` STRING COMMENT 'Overall outcome of the safety inspection: pass (full compliance), pass with observations (compliant but improvements recommended), fail (non-compliant, corrective action required), or conditional pass (compliant pending minor corrections).. Valid values are `pass|pass_with_observations|fail|conditional_pass`',
    `regulatory_authority_notified` BOOLEAN COMMENT 'Indicates whether external regulatory authorities (OSHA, local fire marshal, etc.) were notified of inspection results or violations.',
    `report_document_url` STRING COMMENT 'URL or file path to the detailed safety inspection report document stored in the document management system.',
    `report_generated_date` DATE COMMENT 'Date on which the formal safety inspection report was generated and distributed to stakeholders.',
    `scheduled_date` DATE COMMENT 'Originally scheduled date for the inspection. May differ from actual inspection date if rescheduled.',
    `total_items_inspected` STRING COMMENT 'Total number of checklist items, safety points, or equipment units evaluated during the inspection.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this safety inspection record was last modified in the system.',
    CONSTRAINT pk_safety_inspection PRIMARY KEY(`safety_inspection_id`)
) COMMENT 'Operational record of workplace safety inspections conducted at retail locations and DCs, covering OSHA compliance checks, fire safety, equipment safety, chemical storage (HAZMAT), ergonomics, and emergency preparedness. Captures inspection date, inspector name and role, inspection type (routine, triggered, pre-opening, regulatory), location inspected, inspection checklist version, total items inspected, items passed, items failed, critical violations count, and overall inspection result. Distinct from food safety audits — covers physical workplace safety per OSHA 29 CFR standards.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` (
    `pci_assessment_id` BIGINT COMMENT 'Unique identifier for the PCI-DSS compliance assessment record.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: PCI assessments are conducted under the PCI-DSS compliance program. This FK links each assessment to the master compliance program record. Cardinality: Many assessments → One program (N:1). This provi',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Retail PCI assessments (QSA audits, penetration tests, remediation) incur significant costs allocated to IT or store operations cost centers. Finance tracks PCI compliance costs by cost center for ann',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DCs process payment data for e-commerce order fulfillment and returns. PCI DSS scope includes cardholder data environments at fulfillment centers. Assessments must cover DC-specific systems and contro',
    `prior_pci_assessment_id` BIGINT COMMENT 'Self-referencing FK on pci_assessment (prior_pci_assessment_id)',
    `vendor_id` BIGINT COMMENT 'Unique identifier assigned to the QSA firm by the PCI Security Standards Council.',
    `acquiring_bank_name` STRING COMMENT 'Name of the acquiring bank or payment processor to which PCI-DSS compliance documentation is submitted.',
    `annual_transaction_volume` BIGINT COMMENT 'Total number of payment card transactions processed annually across all channels, used to determine merchant level classification.',
    `assessment_date` DATE COMMENT 'Date on which the PCI-DSS assessment was completed and finalized.',
    `assessment_number` STRING COMMENT 'Business-facing reference number or code assigned to this PCI-DSS assessment for tracking and reporting purposes.',
    `assessment_report_url` STRING COMMENT 'URL or file path to the complete PCI-DSS assessment report document (SAQ or ROC) stored in the document management system.',
    `assessment_scope_notes` STRING COMMENT 'Additional notes and details regarding the scope boundaries, exclusions, and special considerations for this PCI-DSS assessment.',
    `assessment_start_date` DATE COMMENT 'Date on which the PCI-DSS assessment activities commenced.',
    `assessment_type` STRING COMMENT 'Type of PCI-DSS assessment performed. SAQ (Self-Assessment Questionnaire) variants for different merchant environments, or ROC (Report on Compliance) for Level 1 merchants requiring external audit by a Qualified Security Assessor (QSA). [ENUM-REF-CANDIDATE: SAQ-A|SAQ-A-EP|SAQ-B|SAQ-B-IP|SAQ-C|SAQ-C-VT|SAQ-D|SAQ-P2PE|ROC — 9 candidates stripped; promote to reference product]',
    `assessor_name` STRING COMMENT 'Name of the individual lead assessor or internal compliance officer who conducted or coordinated the assessment.',
    `attestation_of_compliance_submitted_flag` BOOLEAN COMMENT 'Indicates whether the Attestation of Compliance (AOC) document has been submitted to the acquiring bank or payment card brands.',
    `attestation_submission_date` DATE COMMENT 'Date on which the Attestation of Compliance (AOC) was submitted to the acquiring bank or payment card brands.',
    `cardholder_data_environment_scope` STRING COMMENT 'Detailed description of the systems, networks, applications, and physical locations that comprise the Cardholder Data Environment (CDE) and are in scope for this PCI-DSS assessment.',
    `compensating_controls_count` STRING COMMENT 'Number of PCI-DSS requirements for which compensating controls were implemented and accepted in lieu of standard controls.',
    `compliance_status` STRING COMMENT 'Overall compliance determination for this assessment. Compliant indicates all requirements met; Non-Compliant indicates one or more requirements failed; Compliant with Compensating Controls indicates alternative controls in place where standard controls cannot be implemented.. Valid values are `Compliant|Non-Compliant|Compliant with Compensating Controls|In Progress`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this PCI-DSS assessment record was first created in the compliance tracking system.',
    `critical_findings_count` STRING COMMENT 'Number of critical security findings or high-risk vulnerabilities identified during the assessment that require immediate remediation.',
    `executive_summary` STRING COMMENT 'High-level executive summary of the assessment findings, compliance status, and key recommendations for leadership review.',
    `in_scope_locations_count` STRING COMMENT 'Number of physical retail locations, data centers, or facilities included in the scope of this PCI-DSS assessment.',
    `in_scope_systems_count` STRING COMMENT 'Number of systems, servers, and network devices included in the Cardholder Data Environment (CDE) scope for this assessment.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this PCI-DSS assessment record was most recently updated or modified.',
    `last_vulnerability_scan_date` DATE COMMENT 'Date of the most recent external vulnerability scan conducted by an Approved Scanning Vendor (ASV) for this assessment period.',
    `merchant_level` STRING COMMENT 'Merchant classification level based on annual transaction volume as defined by card brands (Visa, Mastercard). Level 1: over 6 million transactions/year; Level 2: 1-6 million; Level 3: 20,000-1 million e-commerce; Level 4: fewer than 20,000 e-commerce or up to 1 million other.. Valid values are `Level 1|Level 2|Level 3|Level 4`',
    `next_assessment_due_date` DATE COMMENT 'Date by which the next PCI-DSS compliance assessment must be completed to maintain continuous compliance status. Typically annual for most merchant levels.',
    `pci_dss_version` STRING COMMENT 'Version of the PCI-DSS standard against which this assessment was conducted (e.g., 3.2.1, 4.0).',
    `penetration_test_date` DATE COMMENT 'Date of the most recent penetration test conducted on the Cardholder Data Environment (CDE) as required by PCI-DSS requirement 11.3.',
    `penetration_test_pass_flag` BOOLEAN COMMENT 'Indicates whether the penetration test was successfully completed with all identified vulnerabilities remediated.',
    `qsa_firm_name` STRING COMMENT 'Name of the external Qualified Security Assessor (QSA) firm that conducted the assessment. Applicable for ROC assessments; null for self-assessments (SAQ).',
    `remediation_deadline_date` DATE COMMENT 'Target date by which all identified non-compliant items and critical findings must be remediated to achieve full compliance.',
    `remediation_plan_required_flag` BOOLEAN COMMENT 'Indicates whether a formal remediation plan is required to address failed requirements or critical findings from this assessment.',
    `requirements_failed_count` STRING COMMENT 'Number of PCI-DSS requirements that were not met or failed during this assessment, requiring remediation.',
    `requirements_met_count` STRING COMMENT 'Number of PCI-DSS requirements that were fully satisfied and passed during this assessment.',
    `total_requirements_count` STRING COMMENT 'Total number of PCI-DSS requirements applicable to this assessment based on the assessment type and merchant environment.',
    `vulnerability_scan_pass_flag` BOOLEAN COMMENT 'Indicates whether the most recent quarterly vulnerability scan received a passing result with no critical vulnerabilities.',
    `vulnerability_scan_vendor` STRING COMMENT 'Name of the PCI Security Standards Council Approved Scanning Vendor (ASV) that conducted quarterly vulnerability scans as part of PCI-DSS requirement 11.2.',
    CONSTRAINT pk_pci_assessment PRIMARY KEY(`pci_assessment_id`)
) COMMENT 'PCI-DSS compliance assessment records for all in-scope payment systems and environments across Retail. Captures assessment type (SAQ, ROC — Report on Compliance), PCI-DSS version assessed, assessment date, Qualified Security Assessor (QSA) firm name, merchant level (1, 2, 3, 4), cardholder data environment (CDE) scope description, overall compliance status (compliant, non-compliant, compensating controls), number of requirements met, number of requirements failed, and next assessment due date. Required for Visa/Mastercard merchant compliance programs.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`pci_control` (
    `pci_control_id` BIGINT COMMENT 'Unique identifier for the PCI-DSS security control record. Primary key for the pci_control product.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: PCI controls are requirements defined under the PCI-DSS compliance program. This FK links each control definition to the master compliance program record. Cardinality: Many controls → One program (N:1',
    `parent_pci_control_id` BIGINT COMMENT 'Self-referencing FK on pci_control (parent_pci_control_id)',
    `active_flag` BOOLEAN COMMENT 'Indicates whether this control is currently active and in scope for compliance assessment. False if the control has been retired or is no longer applicable.',
    `applicable_payment_channels` STRING COMMENT 'Comma-separated list of payment channels this control protects (e.g., Point of Sale (POS), e-commerce, mobile app, call center). Identifies where the control is enforced across the omnichannel payment ecosystem.',
    `assessor_notes` STRING COMMENT 'Free-text field for Qualified Security Assessor (QSA) or Internal Security Assessor (ISA) observations, findings, and recommendations related to this control.',
    `automation_level` STRING COMMENT 'Indicates the degree to which this control is automated versus requiring manual intervention. Helps assess operational efficiency and consistency.. Valid values are `fully_automated|partially_automated|manual`',
    `cardholder_data_environment_scope` STRING COMMENT 'Defines which systems, networks, or locations within the Cardholder Data Environment (CDE) this control applies to. Supports segmentation and scope management for PCI compliance.',
    `compensating_control_flag` BOOLEAN COMMENT 'Indicates whether this control is implemented as a compensating control rather than the standard requirement. True if an alternative control approach has been approved.',
    `compensating_control_justification` STRING COMMENT 'Detailed explanation of why a compensating control is necessary and how it provides equivalent protection to the original requirement. Required documentation for compensating control approval.',
    `control_category` STRING COMMENT 'High-level classification of the control type. Groups controls into major security domains for reporting and management purposes.. Valid values are `network_security|access_control|encryption|vulnerability_management|monitoring_logging|policy_procedure`',
    `control_objective` STRING COMMENT 'The business and security objective that this control is designed to achieve. Explains the purpose and intent behind the requirement.',
    `control_owner_role` STRING COMMENT 'The job title or role responsible for implementing and maintaining this control (e.g., Chief Information Security Officer (CISO), IT Security Manager, Network Administrator). Identifies accountability for control execution.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this control record was first created in the compliance management system. Supports audit trail and data lineage.',
    `evidence_location` STRING COMMENT 'File path, document repository location, or system reference where audit evidence for this control is stored. Facilitates evidence retrieval during assessments.',
    `implementation_date` DATE COMMENT 'The date when this control was first fully implemented and became operational in the payment environment.',
    `implementation_status` STRING COMMENT 'Current state of control implementation. Tracks whether the control is fully operational, in progress, not yet started, addressed through alternative means, or not required for this environment.. Valid values are `implemented|partially_implemented|not_implemented|compensating_control|not_applicable`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this control record was most recently updated. Tracks change history for compliance reporting.',
    `last_tested_date` DATE COMMENT 'The most recent date when this control was formally tested or validated for effectiveness. Used to track testing frequency and identify controls due for re-assessment.',
    `monitoring_tool` STRING COMMENT 'Name of the security tool, platform, or system used to monitor and enforce this control (e.g., Security Information and Event Management (SIEM), Data Loss Prevention (DLP), Intrusion Detection System (IDS)).',
    `next_test_due_date` DATE COMMENT 'The scheduled date for the next required testing or validation of this control. Supports proactive compliance management and audit scheduling.',
    `policy_reference` STRING COMMENT 'Reference to the internal security policy or procedure document that governs this control. Links operational controls to corporate policy framework.',
    `remediation_due_date` DATE COMMENT 'Target date by which control deficiencies must be resolved. Used to track progress on compliance improvement initiatives.',
    `remediation_plan` STRING COMMENT 'Documented action plan to address control gaps or failures. Includes steps, timelines, and resources needed to achieve full compliance.',
    `requirement_description` STRING COMMENT 'Full text description of the PCI-DSS requirement as stated in the official standard. Provides the complete regulatory language for this control.',
    `requirement_number` STRING COMMENT 'The official PCI-DSS requirement identifier (e.g., 3.4, 6.3.2, 12.1). Maps to the specific section of the PCI-DSS standard that this control addresses.. Valid values are `^[0-9]{1,2}.[0-9]{1,2}(.[0-9]{1,2})?$`',
    `risk_rating` STRING COMMENT 'The assessed risk level if this control fails or is not implemented. Used to prioritize remediation efforts and resource allocation.. Valid values are `critical|high|medium|low`',
    `test_result` STRING COMMENT 'Outcome of the most recent control test. Indicates whether the control is operating effectively as designed.. Valid values are `pass|fail|partial_pass|not_tested`',
    `testing_frequency` STRING COMMENT 'How often this control must be tested per PCI-DSS requirements or internal policy. Defines the cadence for ongoing validation activities. [ENUM-REF-CANDIDATE: continuous|daily|weekly|monthly|quarterly|annually|on_change — 7 candidates stripped; promote to reference product]',
    `testing_method` STRING COMMENT 'The methodology used to validate control effectiveness. Aligns with PCI-DSS prescribed testing procedures for each requirement type.. Valid values are `observation|examination|interview|penetration_test|vulnerability_scan|automated_monitoring`',
    `third_party_dependency_flag` BOOLEAN COMMENT 'Indicates whether this control relies on a third-party service provider or vendor for implementation or operation. True if external dependency exists.',
    `third_party_provider_name` STRING COMMENT 'Name of the third-party service provider responsible for this control, if applicable. Used to track vendor compliance obligations.',
    CONSTRAINT pk_pci_control PRIMARY KEY(`pci_control_id`)
) COMMENT 'Master record for individual PCI-DSS security controls and requirements tracked within the retailers compliance program. Captures PCI-DSS requirement number (e.g., Req 3.4, Req 6.3.2), requirement description, control category (network security, access control, encryption, vulnerability management, monitoring, policy), control owner role, implementation status (implemented, partially implemented, not implemented, compensating control), last tested date, and testing method. Enables granular tracking of PCI-DSS control compliance across all payment environments.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` (
    `privacy_assessment_id` BIGINT COMMENT 'Unique identifier for the privacy assessment record. Primary key.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Privacy assessments (PIAs, DPIAs) are conducted under privacy compliance programs (GDPR, CCPA, etc.). This FK links each assessment to the master compliance program record. Cardinality: Many assessmen',
    `prior_privacy_assessment_id` BIGINT COMMENT 'Self-referencing FK on privacy_assessment (prior_privacy_assessment_id)',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Privacy impact assessments may be triggered by new account types or processing activities (e.g., B2B accounts with special data handling). Links assessment to business process being evaluated.',
    `assessment_completion_date` DATE COMMENT 'Date when the privacy assessment was finalized and approved.',
    `assessment_methodology` STRING COMMENT 'Framework or methodology used to conduct the privacy assessment (e.g., ISO/IEC 29134, NIST Privacy Framework, CNIL DPIA methodology, ICO DPIA guidance, Internal privacy assessment framework).',
    `assessment_name` STRING COMMENT 'Business-friendly name or title of the privacy assessment (e.g., Customer Loyalty Program DPIA, E-Commerce Platform PIA).',
    `assessment_outcome` STRING COMMENT 'Final outcome of the privacy assessment: approved (no significant risks, proceed), approved_with_conditions (proceed with mandatory mitigations), rejected (unacceptable risk, do not proceed), requires_consultation (high residual risk requiring supervisory authority consultation per GDPR Article 36).. Valid values are `approved|approved_with_conditions|rejected|requires_consultation`',
    `assessment_start_date` DATE COMMENT 'Date when the privacy assessment was initiated.',
    `assessment_status` STRING COMMENT 'Current lifecycle status of the privacy assessment: draft (initial preparation), in_review (under business review), dpo_review (awaiting DPO validation), completed (finalized and approved), archived (historical record).. Valid values are `draft|in_review|dpo_review|completed|archived`',
    `assessment_type` STRING COMMENT 'Type of privacy assessment conducted. PIA = Privacy Impact Assessment, DPIA = Data Protection Impact Assessment (GDPR Article 35), LIA = Legitimate Interest Assessment.. Valid values are `PIA|DPIA|LIA`',
    `assessor_name` STRING COMMENT 'Full name of the individual or team who conducted the privacy assessment.',
    `assessor_role` STRING COMMENT 'Role or title of the assessor (e.g., Privacy Analyst, Compliance Manager, Data Protection Officer, Information Security Manager).',
    `automated_decision_making` BOOLEAN COMMENT 'Indicates whether the assessed process involves automated decision-making or profiling that produces legal or similarly significant effects on data subjects. True if automated decision-making is present, False otherwise. Required disclosure under GDPR Article 22.',
    `business_process` STRING COMMENT 'The retail business process or function being assessed (e.g., Customer Loyalty and Engagement Programs, E-Commerce and Digital Commerce Operations, Order Fulfillment and Last-Mile Delivery, Workforce Management).',
    `business_unit` STRING COMMENT 'Business unit or division responsible for the assessed process or system (e.g., E-Commerce, Store Operations, Supply Chain, Human Resources, Marketing).',
    `children_data_processing` BOOLEAN COMMENT 'Indicates whether the assessed process involves processing personal data of children (individuals under 16 years of age, or lower age as defined by member state law). True if childrens data is processed, False otherwise. Requires parental consent under GDPR Article 8.',
    `consultation_date` DATE COMMENT 'Date when the supervisory authority was consulted regarding high-risk processing. Applicable only if supervisory_authority_consulted is True.',
    `consultation_outcome` STRING COMMENT 'Summary of the supervisory authoritys response or guidance following consultation (e.g., Approved with additional safeguards, Requires further mitigation, Processing prohibited).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the privacy assessment record was first created in the system.',
    `data_retention_period` STRING COMMENT 'Defined retention period for personal data processed in the assessed system or process (e.g., 7 years, 90 days post-transaction, Duration of employment plus 3 years). Required for GDPR Article 5(1)(e) storage limitation principle.',
    `data_subject_rights_supported` STRING COMMENT 'Data subject rights mechanisms implemented in the assessed system or process (e.g., Right to access, Right to rectification, Right to erasure (right to be forgotten), Right to data portability, Right to object, Right to restrict processing). Comma-separated list per GDPR Chapter III.',
    `data_subjects` STRING COMMENT 'Categories of individuals whose personal data is processed (e.g., Customers, Employees, Minors, Suppliers, Job applicants). Comma-separated list.',
    `data_transfer_countries` STRING COMMENT 'Countries or regions to which personal data is transferred (e.g., USA, GBR, IND, EU). Required for GDPR Chapter V compliance on international data transfers. Comma-separated ISO 3166-1 alpha-3 country codes.',
    `dpo_review_date` DATE COMMENT 'Date when the Data Protection Officer reviewed and validated the privacy assessment. Required for GDPR Article 35(2) compliance.',
    `dpo_reviewer_name` STRING COMMENT 'Full name of the Data Protection Officer who reviewed the assessment.',
    `geographic_scope` STRING COMMENT 'Geographic regions or jurisdictions where the assessed processing activities occur (e.g., European Union, United States, California, Global). Comma-separated list.',
    `legal_basis` STRING COMMENT 'Legal basis for processing personal data under GDPR Article 6: consent, contract (performance of contract), legal_obligation (compliance with legal obligation), vital_interests (protection of vital interests), public_task (public interest or official authority), legitimate_interests (legitimate interests pursued by controller or third party).. Valid values are `consent|contract|legal_obligation|vital_interests|public_task|legitimate_interests`',
    `mitigations_applied` STRING COMMENT 'Privacy risk mitigation measures implemented or planned (e.g., Encryption of data at rest and in transit, Role-based access controls, Data minimization procedures, Automated data retention policies, Privacy-by-design architecture, Third-party data processing agreements). Comma-separated or narrative format.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the privacy assessment record was last modified.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this privacy assessment. Privacy assessments should be reviewed regularly or when significant changes occur.',
    `personal_data_categories` STRING COMMENT 'Categories of personal data involved in the assessed process or system (e.g., Contact information (email, phone), Purchase history, Payment card data, Geolocation data, Biometric data, Employee performance records). Comma-separated list.',
    `privacy_risks_identified` STRING COMMENT 'Summary of privacy risks identified during the assessment (e.g., Unauthorized access to customer PII, Excessive data retention, Lack of consent mechanism, Third-party data sharing without adequate safeguards, Inadequate data subject rights procedures). Comma-separated or narrative format.',
    `processing_purpose` STRING COMMENT 'Business purpose for processing personal data (e.g., Customer relationship management, Order fulfillment, Marketing and promotions, Workforce scheduling, Fraud prevention).',
    `regulatory_frameworks` STRING COMMENT 'Privacy and data protection regulations applicable to the assessed processing (e.g., GDPR, CCPA, CPRA, LGPD, PIPEDA, HIPAA, PCI DSS). Comma-separated list.',
    `residual_risk_level` STRING COMMENT 'Privacy risk level remaining after mitigation measures have been applied. Used to determine if additional controls are required or if the risk is acceptable.. Valid values are `low|medium|high|critical`',
    `risk_level` STRING COMMENT 'Overall privacy risk level determined by the assessment: low (minimal risk to data subjects), medium (moderate risk requiring mitigation), high (significant risk requiring immediate action), critical (severe risk requiring executive escalation).. Valid values are `low|medium|high|critical`',
    `special_category_data` BOOLEAN COMMENT 'Indicates whether the assessed process involves special categories of personal data (racial/ethnic origin, political opinions, religious beliefs, trade union membership, genetic data, biometric data, health data, sex life, sexual orientation). True if special category data is processed, False otherwise. Requires heightened protection under GDPR Article 9.',
    `supervisory_authority_consulted` BOOLEAN COMMENT 'Indicates whether the supervisory authority (data protection authority) was consulted prior to processing, as required when a DPIA indicates high residual risk. True if consultation occurred, False otherwise. Required under GDPR Article 36 for high-risk processing.',
    `system_name` STRING COMMENT 'Name of the operational system or platform being assessed (e.g., the e-commerce platform, SAP S/4HANA Retail, Workday HCM, the customer master data system).',
    `third_party_processors` STRING COMMENT 'Names of third-party data processors or vendors involved in processing personal data (e.g., AWS, Google Cloud, the e-commerce platform, Payment gateway provider). Comma-separated list.',
    `transfer_safeguards` STRING COMMENT 'Legal mechanisms used to safeguard international data transfers (e.g., Standard Contractual Clauses (SCC), Binding Corporate Rules (BCR), Adequacy Decision, Privacy Shield (legacy), Explicit consent).',
    `triggering_event` STRING COMMENT 'Business event or initiative that triggered the privacy assessment (e.g., New CRM system implementation, Third-party data sharing agreement, Marketing campaign launch, Process change in order fulfillment).',
    CONSTRAINT pk_privacy_assessment PRIMARY KEY(`privacy_assessment_id`)
) COMMENT 'Privacy impact assessment (PIA) and data protection impact assessment (DPIA) records conducted for retail business processes, systems, and data initiatives involving personal data. Captures assessment name, assessment type (PIA, DPIA, LIA — Legitimate Interest Assessment), triggering event (new system, process change, third-party sharing, marketing campaign), personal data categories involved, data subjects affected (customers, employees, minors), risk level (low, medium, high), privacy risks identified, mitigations applied, DPO review date, and assessment outcome. Required for GDPR Article 35 and CCPA compliance.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` (
    `regulatory_filing_id` BIGINT COMMENT 'Unique identifier for the regulatory filing record. Primary key.',
    `amended_regulatory_filing_id` BIGINT COMMENT 'Self-referencing FK on regulatory_filing (amended_regulatory_filing_id)',
    `certification_id` BIGINT COMMENT 'Foreign key linking to compliance.certification. Business justification: Regulatory filings can be made for certification applications, renewals, or compliance reporting related to a specific certification. This FK links the filing transaction to the certification it perta',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: regulatory_filing represents submissions to regulatory agencies (FDA filings, OSHA reports, EPA notifications). These filings are made to satisfy obligations under a specific compliance_program (e.g.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Retail regulatory filings (EPA reports, health dept renewals, alcohol/tobacco filings) incur preparation and filing fees allocated to responsible cost centers. Finance tracks regulatory compliance cos',
    `license_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.license_permit. Business justification: Regulatory filings are often made for license applications, renewals, or compliance reporting related to a specific license or permit. This FK links the filing transaction to the license/permit it per',
    `location_id` BIGINT COMMENT 'Identifier of the retail store location to which this filing pertains. Used when the filing is specific to a store-level regulatory requirement (e.g., local health permit, liquor license).',
    `dc_facility_id` BIGINT COMMENT 'Identifier of the retail facility, store, distribution center, or warehouse to which this filing pertains. Links the filing to the specific operational location subject to regulatory oversight.',
    `regulatory_agency_id` BIGINT COMMENT 'FK to compliance.regulatory_agency',
    `acceptance_date` DATE COMMENT 'Date when the regulatory agency officially accepted the filing as complete and compliant. Represents successful fulfillment of the regulatory requirement.',
    `acknowledgment_date` DATE COMMENT 'Date when the regulatory agency formally acknowledged receipt of the filing. Marks the beginning of the review process.',
    `compliance_certification_number` STRING COMMENT 'Official certification or attestation number issued by the regulatory agency upon successful acceptance of the filing. Serves as proof of compliance for audit purposes.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory filing record was first created in the system. Used for audit trail and data lineage tracking.',
    `expiration_date` DATE COMMENT 'Date when this filing or the associated certification expires and renewal is required. Used for proactive compliance lifecycle management.',
    `filing_date` DATE COMMENT 'Date when the regulatory filing was officially submitted to the regulatory agency. This is the business event date for compliance tracking and audit purposes.',
    `filing_description` STRING COMMENT 'Detailed narrative description of the filing content, purpose, and scope. Provides context for compliance auditors and internal stakeholders.',
    `filing_document_url` STRING COMMENT 'Uniform Resource Locator (URL) or file path to the stored copy of the submitted filing document. Provides access to the official record for audit and reference purposes.',
    `filing_fee_amount` DECIMAL(18,2) COMMENT 'Monetary fee charged by the regulatory agency for processing this filing. Captured in the base currency of the business (USD for US-based retail operations).',
    `filing_fee_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the filing fee amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `filing_jurisdiction` STRING COMMENT 'Geographic or legal jurisdiction under which this filing is required (e.g., Federal, State of California, European Union). Identifies the scope of regulatory authority.',
    `filing_number` STRING COMMENT 'External reference number or confirmation number assigned by the regulatory agency upon submission. Used for tracking and correspondence with the regulatory body.',
    `filing_period_end_date` DATE COMMENT 'End date of the reporting period covered by this regulatory filing. Defines the conclusion of the time window for which compliance data is being reported.',
    `filing_period_start_date` DATE COMMENT 'Start date of the reporting period covered by this regulatory filing. Defines the beginning of the time window for which compliance data is being reported.',
    `filing_status` STRING COMMENT 'Current lifecycle status of the regulatory filing. Tracks progression from draft through submission to final disposition by the regulatory agency. [ENUM-REF-CANDIDATE: DRAFT|SUBMITTED|ACKNOWLEDGED|ACCEPTED|REJECTED|UNDER_REVIEW|PENDING_CORRECTION|WITHDRAWN|EXPIRED — 9 candidates stripped; promote to reference product]',
    `filing_type` STRING COMMENT 'Category of regulatory filing or submission. Identifies the specific regulatory requirement being fulfilled (e.g., FDA food facility registration, OSHA 300A annual summary, environmental permit renewal, state liquor license renewal, PCI attestation of compliance). [ENUM-REF-CANDIDATE: FDA_FOOD_FACILITY_REGISTRATION|OSHA_300A_ANNUAL_SUMMARY|ENVIRONMENTAL_PERMIT_RENEWAL|STATE_LIQUOR_LICENSE_RENEWAL|PCI_ATTESTATION_OF_COMPLIANCE|GDPR_DATA_BREACH_NOTIFICATION|CCPA_CONSUMER_REQUEST_REPORT|FTC_ADVERTISING_DISCLOSURE|CPSC_PRODUCT_RECALL_REPORT|EEO_WORKFORCE_REPORT|EPA_HAZARDOUS_WASTE_REPORT|STATE_SALES_TAX_FILING|CUSTOMS_IMPORT_DECLARATION|FSMA_PREVENTIVE_CONTROLS_PLAN|OTHER — 15 candidates stripped; promote to reference product]',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory filing record was last updated. Tracks the most recent change for audit and data quality purposes.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified this record. Provides accountability for changes to compliance data.',
    `next_filing_due_date` DATE COMMENT 'Scheduled due date for the next required filing of this type. Used for compliance calendar management and proactive deadline tracking.',
    `notes` STRING COMMENT 'Free-text field for additional comments, observations, or context related to the filing. Used by compliance team for internal documentation and knowledge transfer.',
    `payment_reference_number` STRING COMMENT 'Reference number or transaction identifier for the payment of the filing fee. Links the filing to the corresponding financial transaction for reconciliation.',
    `rejection_date` DATE COMMENT 'Date when the regulatory agency rejected the filing due to incompleteness, errors, or non-compliance. Triggers corrective action and resubmission workflow.',
    `rejection_reason` STRING COMMENT 'Detailed explanation provided by the regulatory agency for rejecting the filing. Documents the specific deficiencies or compliance gaps that must be addressed for resubmission.',
    `renewal_frequency` STRING COMMENT 'Cadence at which this type of regulatory filing must be renewed or resubmitted (e.g., annual, biennial, quarterly). Supports automated compliance calendar generation. [ENUM-REF-CANDIDATE: ANNUAL|BIENNIAL|QUARTERLY|MONTHLY|ONE_TIME|AS_NEEDED|OTHER — 7 candidates stripped; promote to reference product]',
    `responsible_party_email` STRING COMMENT 'Email address of the individual or department responsible for this filing. Used for correspondence and follow-up regarding the submission.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `responsible_party_name` STRING COMMENT 'Name of the individual or department responsible for preparing and submitting this regulatory filing. Used for accountability and audit trail purposes.',
    `responsible_party_phone` STRING COMMENT 'Contact phone number for the individual or department responsible for this filing. Used for urgent inquiries or clarifications from regulatory agencies.',
    `resubmission_required_flag` BOOLEAN COMMENT 'Boolean indicator of whether this filing requires resubmission due to rejection or requested corrections. True indicates resubmission is needed; False indicates no resubmission required.',
    `submission_confirmation_number` STRING COMMENT 'Confirmation or tracking number provided by the submission system or regulatory agency upon receipt of the filing. Used for proof of submission and follow-up inquiries.',
    `submission_method` STRING COMMENT 'Channel or mechanism used to submit the filing to the regulatory agency (e.g., online portal, EDI, mail, in-person delivery). [ENUM-REF-CANDIDATE: ONLINE_PORTAL|EDI|EMAIL|POSTAL_MAIL|FAX|IN_PERSON|API|OTHER — 8 candidates stripped; promote to reference product]',
    CONSTRAINT pk_regulatory_filing PRIMARY KEY(`regulatory_filing_id`)
) COMMENT 'Transactional record of regulatory reports, filings, and submissions made to government agencies and regulatory bodies. Captures filing type (FDA food facility registration, OSHA 300A annual summary, environmental permit renewal, state liquor license renewal, PCI attestation of compliance), filing date, submission method (online portal, mail, EDI), regulatory agency, filing period covered, filing status (draft, submitted, acknowledged, accepted, rejected), submission reference number, and next filing due date. Provides the compliance team with a complete audit trail of all regulatory submissions.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`license_permit` (
    `license_permit_id` BIGINT COMMENT 'Unique identifier for the license or permit record. Primary key for the license_permit product. Role: MASTER_AGREEMENT.',
    `associate_id` BIGINT COMMENT 'The identifier of the user or system process that last modified this license or permit record.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key reference to the compliance program under which this license or permit is managed.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Retail licenses/permits (liquor, food service, pharmacy, tobacco) are location-specific with costs allocated to responsible cost centers. Finance tracks license fees and renewal costs by cost center f',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DCs require operating licenses (business, hazmat storage, food handling, alcohol distribution). Permit tracking, renewal management, and regulatory inspections are facility-specific. Associated_entity',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Licenses govern product categories (alcohol permits for beer/wine/spirits hierarchy, tobacco licenses for tobacco products, pharmacy licenses for OTC drugs, food service permits for prepared foods). C',
    `renewed_from_license_permit_id` BIGINT COMMENT 'Self-referencing FK on license_permit (renewed_from_license_permit_id)',
    `associated_entity_reference` BIGINT COMMENT 'The identifier of the entity (store, banner, or enterprise) to which this license is associated. Polymorphic reference depending on license_scope.',
    `associated_entity_type` STRING COMMENT 'The type of entity to which this license is associated. Used in conjunction with associated_entity_id to resolve the polymorphic reference.. Valid values are `store|banner|enterprise|distribution_center`',
    `certification_body` STRING COMMENT 'The name of the third-party certification body or auditor that validated compliance for this license or permit, if applicable.',
    `conditions_of_license` STRING COMMENT 'Any special conditions, restrictions, or requirements attached to the license or permit by the issuing authority.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this license or permit record was first created in the system.',
    `document_reference_url` STRING COMMENT 'URL or file path to the digital copy of the license or permit document stored in the document management system.',
    `expiration_date` DATE COMMENT 'The date on which the license or permit expires and is no longer valid. Nullable for perpetual licenses.',
    `fee_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the license fee amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `inspection_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether periodic inspections are required to maintain this license or permit.',
    `issue_date` DATE COMMENT 'The date on which the license or permit was originally issued by the regulatory authority. Represents the effective start of the license.',
    `issuing_authority` STRING COMMENT 'The name of the government agency, regulatory body, or certification organization that issued the license or permit.',
    `issuing_jurisdiction` STRING COMMENT 'The geographic or administrative jurisdiction of the issuing authority (e.g., state, county, city, federal).',
    `last_inspection_date` DATE COMMENT 'The date of the most recent inspection conducted for this license or permit.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this license or permit record was last updated in the system.',
    `last_renewal_date` DATE COMMENT 'The date on which the license or permit was most recently renewed.',
    `license_fee_amount` DECIMAL(18,2) COMMENT 'The monetary fee paid to obtain or renew the license or permit.',
    `license_number` STRING COMMENT 'The official license or permit number issued by the regulatory authority. This is the externally-known unique identifier for the license.',
    `license_scope` STRING COMMENT 'The organizational level at which the license applies: enterprise-wide, specific banner, individual location, or department.. Valid values are `enterprise|banner|location|department`',
    `license_status` STRING COMMENT 'Current lifecycle status of the license or permit. Indicates whether the license is valid, expired, suspended, or under review.. Valid values are `active|expired|suspended|revoked|pending_renewal|pending_approval`',
    `license_type` STRING COMMENT 'Classification of the license or permit. Indicates the regulatory category and scope of the license. [ENUM-REF-CANDIDATE: business_operating_license|food_handler_permit|liquor_license|beer_wine_license|pharmacy_license|tobacco_retail_license|lottery_license|health_department_permit|fire_occupancy_permit|environmental_discharge_permit|building_permit|signage_permit — 12 candidates stripped; promote to reference product]',
    `next_inspection_due_date` DATE COMMENT 'The date by which the next inspection must be completed to maintain compliance with the license or permit requirements.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special instructions related to the license or permit.',
    `regulatory_framework` STRING COMMENT 'The specific regulatory framework, statute, or code under which this license or permit is governed (e.g., FDA FSMA, OSHA 1910, PCI DSS).',
    `reinstatement_date` DATE COMMENT 'The date on which a suspended or revoked license or permit was reinstated to active status.',
    `renewal_due_date` DATE COMMENT 'The date by which the license or permit must be renewed to avoid expiration or lapse.',
    `renewal_frequency` STRING COMMENT 'The frequency at which the license or permit must be renewed (e.g., annually, every two years, perpetual).. Valid values are `annual|biennial|triennial|quinquennial|perpetual`',
    `renewal_status` STRING COMMENT 'The current status of the license renewal process. Indicates whether renewal is required and the stage of the renewal workflow.. Valid values are `not_required|pending|submitted|approved|denied`',
    `responsible_party_email` STRING COMMENT 'The email address of the individual or role responsible for managing this license or permit.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `responsible_party_name` STRING COMMENT 'The name of the individual or role responsible for managing and renewing this license or permit.',
    `responsible_party_phone` STRING COMMENT 'The phone number of the individual or role responsible for managing this license or permit.',
    `revocation_date` DATE COMMENT 'The date on which the license or permit was revoked.',
    `revocation_reason` STRING COMMENT 'The reason for revocation of the license or permit, if applicable. Populated when license_status is revoked.',
    `suspension_date` DATE COMMENT 'The date on which the license or permit was suspended.',
    `suspension_reason` STRING COMMENT 'The reason for suspension of the license or permit, if applicable. Populated when license_status is suspended.',
    CONSTRAINT pk_license_permit PRIMARY KEY(`license_permit_id`)
) COMMENT 'Master record for all business licenses, operating permits, and regulatory certifications held at the enterprise, banner, or location level. Captures license type (business operating license, food handler permit, liquor/beer/wine license, pharmacy license, tobacco retail license, lottery license, health department permit, fire occupancy permit, environmental discharge permit), issuing authority, license number, issue date, expiration date, renewal status, associated location or entity, and license fee amount. Distinct from store.store_license which is store-location-scoped; this record covers enterprise and banner-level licenses as well.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`certification` (
    `certification_id` BIGINT COMMENT 'Unique identifier for the organizational compliance certification record. Primary key.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key reference to the overarching compliance program under which this certification is managed (e.g., Food Safety Program, Environmental Sustainability Program).',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DCs obtain ISO 9001, FSSC 22000, and organic certifications. Certification scope, audit schedules, and renewal tracking require facility-level attribution. Existing location_id covers stores; DCs need',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Certifications apply to product categories (organic certification for organic food category, Fair Trade for coffee/cocoa, MSC for seafood, FSC for paper products). Category-level certification managem',
    `location_id` BIGINT COMMENT 'Foreign key reference to the specific facility (store, distribution center, warehouse, plant) to which this certification applies. Nullable if certification is enterprise-wide or program-level.',
    `org_unit_id` BIGINT COMMENT 'Foreign key reference to the business unit or division that holds this certification. Nullable if certification is enterprise-wide.',
    `associate_id` BIGINT COMMENT 'Foreign key reference to the workforce member (manager or compliance officer) who is accountable for maintaining this certification and managing renewal activities.',
    `renewed_from_certification_id` BIGINT COMMENT 'Self-referencing FK on certification (renewed_from_certification_id)',
    `tertiary_certification_modified_by_user_associate_id` BIGINT COMMENT 'Foreign key reference to the user or system account that most recently modified this certification record.',
    `accreditation_body` STRING COMMENT 'The name of the national or international accreditation body that accredits the certifying body (e.g., ANAB - ANSI National Accreditation Board, UKAS - United Kingdom Accreditation Service, IAF - International Accreditation Forum).',
    `audit_frequency` STRING COMMENT 'The required frequency of surveillance or re-certification audits to maintain the certification. Annual indicates yearly; semi_annual indicates twice per year; quarterly indicates every three months; biennial indicates every two years; triennial indicates every three years; on_demand indicates audits triggered by events.. Valid values are `annual|semi_annual|quarterly|biennial|triennial|on_demand`',
    `certificate_document_url` STRING COMMENT 'URL or file path to the digital copy of the official certificate document stored in the document management system.',
    `certificate_number` STRING COMMENT 'The externally-issued unique certificate or accreditation number assigned by the certifying body. This is the official identifier printed on the certificate document.',
    `certification_status` STRING COMMENT 'Current lifecycle status of the certification. Active indicates the certification is valid and in force; expired indicates it has passed its expiration date; suspended indicates temporary hold; pending indicates application submitted but not yet granted; withdrawn indicates voluntarily or involuntarily revoked; in_renewal indicates renewal process underway.. Valid values are `active|expired|suspended|pending|withdrawn|in_renewal`',
    `certification_type` STRING COMMENT 'The category or standard of certification held by the organization. Examples include ISO 22000 Food Safety, ISO 14001 Environmental Management, GFSI (Global Food Safety Initiative), SQF (Safe Quality Food), BRC (British Retail Consortium), Rainforest Alliance, Fair Trade, Organic Certification, LEED Building Certification.. Valid values are `ISO 22000 Food Safety|ISO 14001 Environmental|GFSI|SQF|BRC|Rainforest Alliance`',
    `certifying_body` STRING COMMENT 'The name of the independent third-party organization or accreditation body that issued the certification (e.g., NSF International, SGS, Bureau Veritas, DNV GL, Intertek).',
    `cost_amount` DECIMAL(18,2) COMMENT 'The total cost incurred for obtaining and maintaining this certification, including application fees, audit fees, consulting fees, and annual maintenance fees.',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the cost amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `coverage_level` STRING COMMENT 'The organizational level at which the certification applies. Enterprise indicates company-wide; division indicates a specific business unit; facility indicates a single location (store, DC, plant); program indicates a specific operational program; product_line indicates a category of products.. Valid values are `enterprise|division|facility|program|product_line`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this certification record was first created in the system. Follows format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `effective_date` DATE COMMENT 'The date from which the certification becomes valid and enforceable. May differ from issue_date if there is a grace period or delayed activation.',
    `expiration_date` DATE COMMENT 'The date on which the certification expires and is no longer valid unless renewed. Nullable for certifications with indefinite validity pending periodic audits.',
    `issue_date` DATE COMMENT 'The date on which the certification was officially granted and the certificate was issued by the certifying body.',
    `last_audit_date` DATE COMMENT 'The date of the most recent surveillance or re-certification audit conducted by the certifying body to verify ongoing compliance.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this certification record was most recently updated. Follows format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `logo_url` STRING COMMENT 'URL or file path to the official certification logo or seal provided by the certifying body for use in marketing and communications materials.',
    `next_audit_date` DATE COMMENT 'The scheduled date for the next surveillance or re-certification audit required to maintain the certification.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special instructions related to the certification, including historical context, special conditions, or internal reminders.',
    `public_disclosure_flag` BOOLEAN COMMENT 'Boolean indicator of whether this certification is publicly disclosed on the company website, in sustainability reports, or in marketing materials. True indicates public disclosure; False indicates internal-only tracking.',
    `regulatory_framework` STRING COMMENT 'The governing regulatory or industry standard framework that this certification demonstrates compliance with (e.g., FDA FSMA, GFSI Benchmarking Requirements, ISO 9001:2015, LEED v4).',
    `renewal_due_date` DATE COMMENT 'The target date by which the renewal application or re-certification audit must be completed to maintain continuous certification status.',
    `renewal_workflow_status` STRING COMMENT 'Current status of the certification renewal process workflow. Tracks the progression from initial renewal planning through final approval or rejection. [ENUM-REF-CANDIDATE: not_started|application_submitted|audit_scheduled|audit_in_progress|audit_completed|pending_approval|approved|rejected — 8 candidates stripped; promote to reference product]',
    `scope_description` STRING COMMENT 'Detailed textual description of the scope of certification, including the specific business processes, product categories, facilities, or operational areas covered by the certification. For example, Procurement, storage, and distribution of ambient, chilled, and frozen food products across all US distribution centers.',
    `suspension_reason` STRING COMMENT 'Textual explanation of why the certification was suspended, if applicable. Includes details of non-conformities, audit findings, or administrative issues that led to suspension.',
    `withdrawal_reason` STRING COMMENT 'Textual explanation of why the certification was withdrawn or revoked, if applicable. Includes details of major non-conformities, failure to remediate findings, or voluntary surrender.',
    CONSTRAINT pk_certification PRIMARY KEY(`certification_id`)
) COMMENT 'Master record for compliance certifications and accreditations held by the retail organization at the enterprise, facility, or program level. Captures certification type (ISO 22000 Food Safety, ISO 14001 Environmental, GFSI — Global Food Safety Initiative, SQF — Safe Quality Food, BRC, Rainforest Alliance, Fair Trade, organic certification, LEED building certification), certifying body, certificate number, issue date, expiration date, scope of certification, and renewal workflow status. Distinct from supplier.certification (vendor certs) and workforce.wf_certification (associate certs) — this covers organizational-level certifications.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`environmental_event` (
    `environmental_event_id` BIGINT COMMENT 'Unique identifier for the environmental compliance event record. Primary key.',
    `associate_id` BIGINT COMMENT 'User ID of the individual who last modified this environmental event record, for audit trail purposes.',
    `compliance_program_id` BIGINT COMMENT 'Reference to the parent compliance program under which this environmental event is tracked (e.g., EPA Section 608, RCRA, stormwater management program).',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Retail environmental events (refrigerant leaks, hazmat spills, waste violations) incur remediation costs charged to responsible cost centers. Environmental compliance tracks cost center for expense al',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Hazmat spills, refrigerant leaks, and waste disposal events occur at DCs. EPA reporting requires facility-specific manifest numbers and disposal records. Existing location_id covers stores only.',
    `location_id` BIGINT COMMENT 'Reference to the store, distribution center, or facility where the environmental event occurred.',
    `parent_environmental_event_id` BIGINT COMMENT 'Self-referencing FK on environmental_event (related_environmental_event_id)',
    `containment_method` STRING COMMENT 'Method used to contain or remediate the spill or leak (e.g., absorbent pads, containment boom, vacuum recovery, neutralization).',
    `corrective_action_completed_date` DATE COMMENT 'Actual date on which corrective actions were completed and verified.',
    `corrective_action_description` STRING COMMENT 'Detailed description of the corrective actions taken or planned to remediate the environmental event and ensure compliance.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which corrective actions must be completed to resolve the environmental event.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether corrective action is required to address the environmental event and prevent recurrence.',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the remediation cost (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this environmental event record was first created in the system.',
    `disposal_facility_epa_number` STRING COMMENT 'EPA-issued identification number for the treatment, storage, or disposal facility (TSDF) that received the waste.. Valid values are `^[A-Z]{2}[A-Z0-9]{9}$`',
    `disposal_facility_name` STRING COMMENT 'Name of the final disposal, treatment, or recycling facility where the environmental material was delivered.',
    `disposal_method` STRING COMMENT 'Method used to dispose of or manage the environmental material (e.g., landfill, incineration, recycling, treatment facility). Applicable to waste disposal events. [ENUM-REF-CANDIDATE: landfill|incineration|recycling|treatment|recovery|neutralization|containment — 7 candidates stripped; promote to reference product]',
    `event_date` DATE COMMENT 'The date on which the environmental event occurred or was observed.',
    `event_number` STRING COMMENT 'Business-assigned unique identifier for the environmental event, used for tracking and reporting to regulatory agencies.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `event_status` STRING COMMENT 'Current lifecycle status of the environmental event in the compliance tracking workflow.. Valid values are `reported|under_review|remediation_in_progress|closed|pending_approval`',
    `event_timestamp` TIMESTAMP COMMENT 'Precise date and time when the environmental event occurred, used for detailed incident tracking and regulatory reporting.',
    `event_type` STRING COMMENT 'Classification of the environmental compliance event (e.g., waste disposal, HAZMAT handling, refrigerant leak, stormwater discharge, energy consumption reporting, plastic bag ban compliance). [ENUM-REF-CANDIDATE: waste_disposal|hazmat_handling|refrigerant_leak|stormwater_discharge|energy_reporting|plastic_bag_compliance|spill_incident — 7 candidates stripped; promote to reference product]',
    `hazmat_class` STRING COMMENT 'DOT hazard class for hazardous materials involved in the event, if applicable (e.g., Class 2.2 for non-flammable gases, Class 9 for miscellaneous hazardous materials).',
    `inspection_date` DATE COMMENT 'Date on which the environmental inspection or audit that identified this event was conducted.',
    `inspector_name` STRING COMMENT 'Name of the internal or external inspector who documented or verified the environmental event.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this environmental event record was last updated or modified.',
    `manifest_number` STRING COMMENT 'Unique manifest tracking number for hazardous waste shipments, as required by EPA RCRA regulations. Applicable to waste disposal events.. Valid values are `^[A-Z0-9]{9,12}$`',
    `material_type` STRING COMMENT 'Type of material or substance involved in the environmental event (e.g., refrigerant R-410A, used oil, electronic waste, stormwater runoff, plastic bags).',
    `notes` STRING COMMENT 'Additional free-text notes, observations, or context related to the environmental event, including special circumstances or follow-up actions.',
    `penalty_amount` DECIMAL(18,2) COMMENT 'Monetary amount of the penalty or fine assessed by the regulatory agency for non-compliance related to this environmental event.',
    `penalty_assessed` BOOLEAN COMMENT 'Indicates whether a regulatory penalty or fine was assessed against the organization for this environmental event.',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of material or substance involved in the environmental event (e.g., gallons of waste oil, pounds of refrigerant leaked, kilowatt-hours of energy consumed).',
    `regulation_reference` STRING COMMENT 'Specific citation or reference code for the environmental regulation applicable to this event (e.g., 40 CFR Part 82 for refrigerant management).',
    `regulatory_framework` STRING COMMENT 'The primary environmental regulation or framework governing this event (e.g., EPA Section 608 for refrigerants, RCRA for hazardous waste, Clean Water Act for stormwater). [ENUM-REF-CANDIDATE: EPA_SECTION_608|RCRA|CERCLA|CLEAN_WATER_ACT|CLEAN_AIR_ACT|STATE_DEQ|LOCAL_ORDINANCE — 7 candidates stripped; promote to reference product]',
    `regulatory_reporting_required` BOOLEAN COMMENT 'Indicates whether this environmental event triggers a mandatory reporting obligation to EPA, state DEQ, or local environmental agencies.',
    `remediation_cost` DECIMAL(18,2) COMMENT 'Total cost incurred for remediation, cleanup, or disposal activities related to the environmental event.',
    `report_confirmation_number` STRING COMMENT 'Confirmation or tracking number issued by the regulatory agency upon receipt of the environmental event report.. Valid values are `^[A-Z0-9-]{8,20}$`',
    `report_submitted_date` DATE COMMENT 'The date on which the environmental event report was submitted to the regulatory agency.',
    `reported_date` DATE COMMENT 'The date on which the environmental event was formally reported to internal compliance teams or external regulatory agencies.',
    `reporting_deadline` DATE COMMENT 'The deadline by which this environmental event must be reported to the applicable regulatory agency.',
    `responsible_party_email` STRING COMMENT 'Email address of the individual or department responsible for the environmental event.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `responsible_party_name` STRING COMMENT 'Name of the individual or department responsible for managing and resolving the environmental event.',
    `spill_volume` DECIMAL(18,2) COMMENT 'Volume of material spilled or released during an environmental incident (e.g., gallons of oil, pounds of refrigerant). Applicable to spill and leak events.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity reported in this environmental event (e.g., gallons, pounds, kWh). [ENUM-REF-CANDIDATE: gallons|pounds|kilograms|liters|cubic_meters|kilowatt_hours|tons|units — 8 candidates stripped; promote to reference product]',
    `waste_hauler_license_number` STRING COMMENT 'State or federal license number of the waste hauler, verifying their authorization to transport hazardous or regulated materials.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `waste_hauler_name` STRING COMMENT 'Name of the licensed third-party waste hauler or disposal company that transported or managed the environmental material.',
    CONSTRAINT pk_environmental_event PRIMARY KEY(`environmental_event_id`)
) COMMENT 'Transactional record of environmental compliance activities and regulatory events including waste disposal manifests, hazardous material (HAZMAT) handling events, refrigerant leak reports (EPA Section 608), stormwater discharge monitoring, energy consumption reporting, and plastic bag ban compliance checks. Captures event type, event date, location, environmental regulation reference, quantity or measurement involved (gallons, pounds, kWh), disposal method, licensed waste hauler, manifest number, and regulatory reporting obligation triggered. Supports EPA, state DEQ, and local environmental agency compliance.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`training_program` (
    `training_program_id` BIGINT COMMENT 'Unique identifier for the compliance training program. Primary key.',
    `associate_id` BIGINT COMMENT 'User identifier of the person who last modified this training program record.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Training programs are designed to support specific compliance programs (e.g., OSHA safety training for OSHA compliance program, food safety training for FDA/FSMA program). This FK links the training p',
    `prerequisite_training_program_id` BIGINT COMMENT 'Self-referencing FK on training_program (prerequisite_training_program_id)',
    `accessibility_compliant_flag` BOOLEAN COMMENT 'Indicates whether the training program meets ADA and WCAG 2.1 accessibility standards for associates with disabilities (True/False).',
    `annual_enrollment_target` STRING COMMENT 'Target number of associates expected to complete this training program annually, used for capacity planning and compliance tracking.',
    `assessment_required_flag` BOOLEAN COMMENT 'Indicates whether the training program requires a formal assessment or exam for completion (True) or is completion-based only (False).',
    `certification_issued_flag` BOOLEAN COMMENT 'Indicates whether successful completion of this training results in a formal certification or credential (True) or is for awareness only (False).',
    `certification_validity_months` STRING COMMENT 'Number of months the certification remains valid before renewal is required. Null if certification does not expire or training is one-time only.',
    `completion_frequency` STRING COMMENT 'Required frequency for associates to complete or renew this training (one-time upon hire, annual recertification, biennial, triennial, quarterly, as-needed based on role change).. Valid values are `one_time|annual|biennial|triennial|quarterly|as_needed`',
    `content_last_updated_date` DATE COMMENT 'Date when the training curriculum content was last revised or updated.',
    `continuing_education_credits` DECIMAL(18,2) COMMENT 'Number of continuing education units (CEUs) or professional development credits awarded upon successful completion, if applicable. Null if not applicable.',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the cost per learner (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `cost_per_learner` DECIMAL(18,2) COMMENT 'Average cost per associate to deliver this training program, including vendor fees, materials, and instructor time. Used for budget planning and ROI analysis.',
    `course_materials_url` STRING COMMENT 'URL or file path to the training course materials, curriculum guide, or e-learning module.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this training program record was first created in the system.',
    `training_program_description` STRING COMMENT 'Detailed description of the training program objectives, learning outcomes, and content coverage.',
    `duration_hours` DECIMAL(18,2) COMMENT 'Expected duration of the training program in hours (e.g., 2.5 hours for e-learning, 10 hours for OSHA 10-hour certification).',
    `effective_date` DATE COMMENT 'Date when this training program became or will become active and available for associate enrollment.',
    `expiration_date` DATE COMMENT 'Date when this training program is scheduled to be retired or replaced. Null if no planned expiration.',
    `job_role_scope` STRING COMMENT 'Comma-separated list of job roles or job families required to complete this training (e.g., FOOD_HANDLER, CASHIER, STORE_MGR, IT_ADMIN, WAREHOUSE_ASSOC).',
    `language_availability` STRING COMMENT 'Comma-separated list of language codes (ISO 639-1) in which the training content is available (e.g., EN, ES, FR, ZH).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this training program record was last updated.',
    `learning_management_system_code` STRING COMMENT 'External identifier for this training program in the corporate Learning Management System (LMS) platform (e.g., Workday Learning, Cornerstone, SAP SuccessFactors).',
    `mandatory_flag` BOOLEAN COMMENT 'Indicates whether this training is mandatory for the target audience (True) or optional/recommended (False).',
    `notes` STRING COMMENT 'Additional administrative notes, special instructions, or context for the training program.',
    `owning_department` STRING COMMENT 'Business unit or department responsible for maintaining and administering this training program (e.g., Compliance, Human Resources, IT Security, Store Operations).',
    `passing_score_threshold` DECIMAL(18,2) COMMENT 'Minimum score (percentage or points) required to pass the training assessment and achieve certification. Null if no assessment is required.',
    `policy_reference_document` STRING COMMENT 'Reference to the corporate policy or regulatory standard document that mandates this training (e.g., POL-COMP-001 Food Safety Policy, OSHA 1910.120 Hazardous Waste Operations).',
    `prerequisite_programs` STRING COMMENT 'Comma-separated list of training program codes that must be completed before enrolling in this program. Null if no prerequisites.',
    `program_code` STRING COMMENT 'Business identifier code for the training program, used for external references and reporting (e.g., FSMA-FH-2024, OSHA10-GEN).. Valid values are `^[A-Z0-9]{4,20}$`',
    `program_name` STRING COMMENT 'Full descriptive name of the compliance training program (e.g., Food Safety Modernization Act Handler Certification, OSHA 10-Hour General Industry Safety).',
    `program_owner_name` STRING COMMENT 'Name of the individual responsible for the training program content, compliance, and administration.',
    `program_status` STRING COMMENT 'Current lifecycle status of the training program (active and available for enrollment, inactive, under development, retired/obsolete, temporarily suspended).. Valid values are `active|inactive|under_development|retired|suspended`',
    `program_type` STRING COMMENT 'High-level classification of the training program purpose (regulatory compliance, safety, security, privacy, ethics, operational).. Valid values are `regulatory_compliance|safety|security|privacy|ethics|operational`',
    `regulatory_framework` STRING COMMENT 'Primary regulatory framework or mandate requiring this training (FSMA food safety, OSHA workplace safety, PCI-DSS payment security, GDPR/CCPA privacy, FCPA anti-bribery, ADA accessibility, Title VII harassment prevention, SOX financial controls, HIPAA health privacy). [ENUM-REF-CANDIDATE: FSMA|OSHA|PCI_DSS|GDPR|CCPA|FCPA|ADA|Title_VII|SOX|HIPAA|Other — 11 candidates stripped; promote to reference product]',
    `target_audience` STRING COMMENT 'Description of the intended audience for this training program (e.g., all associates, food handlers, store managers, IT staff, cashiers, distribution center workers, executives).',
    `training_format` STRING COMMENT 'Delivery method for the training program (in-person classroom, e-learning module, virtual instructor-led, on-the-job training, blended approach, self-paced online).. Valid values are `in_person|e_learning|virtual_instructor_led|on_the_job|blended|self_paced`',
    `vendor_provider_name` STRING COMMENT 'Name of the third-party vendor or training provider delivering the program content, if externally sourced. Null if developed in-house.',
    `version_number` STRING COMMENT 'Version identifier for the training curriculum content (e.g., 1.0, 2.3). Incremented when content is updated to reflect regulatory changes or best practices.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_training_program PRIMARY KEY(`training_program_id`)
) COMMENT 'Master record for compliance training programs and curricula required under regulatory mandates. Captures training program name, regulatory framework requiring the training (FSMA food handler, OSHA 10/30-hour, PCI-DSS security awareness, GDPR/CCPA privacy, anti-bribery/FCPA, ADA accessibility, harassment prevention), training format (in-person, e-learning, on-the-job), required completion frequency (one-time, annual, biennial), target audience (all associates, food handlers, managers, IT staff, cashiers), training duration, and passing score threshold. Distinct from workforce.training_enrollment which tracks individual associate completions.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`training_completion` (
    `training_completion_id` BIGINT COMMENT 'Unique identifier for the training completion record. Primary key for this transactional record of compliance training completion.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Associates completing compliance training (alcohol sales certification, pharmacy promotion authorization, tobacco handling) are authorized to execute specific regulated promotional campaigns. Links tr',
    `compliance_program_id` BIGINT COMMENT 'Identifier of the compliance program under which this training is mandated. Links to the compliance program master.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC employees require facility-specific training (forklift certification, hazmat handling, food safety). Training records must be auditable by facility for OSHA and FDA inspections.',
    `associate_id` BIGINT COMMENT 'Unique identifier of the retail associate who completed the training. Links to the workforce associate master record.',
    `retake_of_training_completion_id` BIGINT COMMENT 'Self-referencing FK on training_completion (retake_of_training_completion_id)',
    `tertiary_training_waiver_approved_by_associate_id` BIGINT COMMENT 'Identifier of the manager or compliance officer who approved the training waiver, if applicable. Null if no waiver was granted.',
    `training_associate_id` BIGINT COMMENT 'Identifier of the system user or administrator who last modified this training completion record. Audit trail field for accountability.',
    `location_id` BIGINT COMMENT 'Identifier of the physical location (store, distribution center, training facility) where the training was conducted, if applicable for in-person sessions.',
    `training_program_id` BIGINT COMMENT 'Identifier of the specific training course or module completed by the associate. Links to the training course catalog.',
    `vendor_id` BIGINT COMMENT 'Identifier of the third-party training vendor or certification body that provided the training content or certification, if applicable.',
    `assessment_score` DECIMAL(18,2) COMMENT 'Numeric score achieved by the associate on the final assessment or quiz, typically expressed as a percentage (0-100).',
    `attempt_number` STRING COMMENT 'Sequential number indicating which attempt this represents if the associate took the training multiple times (1 for first attempt, 2 for second, etc.).',
    `certificate_issued_date` DATE COMMENT 'Date on which the certificate of completion was officially issued to the associate.',
    `certificate_number` STRING COMMENT 'Unique certificate of completion number issued to the associate upon successful completion. Used for audit verification and regulatory reporting.',
    `certification_expiration_date` DATE COMMENT 'Date on which the certification earned from this training expires and requires renewal. Null for non-expiring certifications.',
    `completion_date` DATE COMMENT 'Date on which the associate successfully completed the compliance training program. Principal business event timestamp for this transaction.',
    `completion_number` STRING COMMENT 'Business-facing unique completion record number assigned by the learning management system for tracking and audit purposes.',
    `completion_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the associate completed the final assessment or training module, recorded by the learning management system.',
    `compliance_status` STRING COMMENT 'Current compliance status of the associate for this training requirement. Indicates whether certification is current, expiring soon, expired, or not yet started.. Valid values are `current|expiring_soon|expired|not_started|in_progress|overdue`',
    `cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred for this training completion, including course fees, materials, instructor costs, and any certification fees.',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the training cost amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this training completion record was first created in the system. Audit trail field for data lineage and compliance tracking.',
    `delivery_method` STRING COMMENT 'Method by which the training was delivered to the associate. Distinguishes between online self-paced, instructor-led classroom, virtual sessions, and on-the-job training.. Valid values are `online|in_person|virtual_instructor_led|self_paced|blended|on_the_job`',
    `job_role_category` STRING COMMENT 'Category of job role for which this training is required (e.g., Food Handler, Forklift Operator, Manager, Cashier, Security Personnel). Used for role-based compliance tracking.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this training completion record was last updated in the system. Audit trail field for change tracking and compliance verification.',
    `mandatory_flag` BOOLEAN COMMENT 'Boolean indicator of whether this training is mandatory for the associates role and compliance requirements (True) or optional/recommended (False).',
    `notes` STRING COMMENT 'Free-text notes or comments about the training completion, including any special circumstances, accommodations provided, or follow-up actions required.',
    `pass_fail_result` STRING COMMENT 'Outcome of the training assessment indicating whether the associate passed, failed, was waived, or was exempt from the requirement.. Valid values are `pass|fail|waived|exempt`',
    `passing_score_threshold` DECIMAL(18,2) COMMENT 'Minimum score required to pass the training assessment, expressed as a percentage. Used to determine pass/fail result.',
    `recertification_due_date` DATE COMMENT 'Date by which the associate must complete recertification training to maintain compliance status. Calculated based on certification expiration and advance notice requirements.',
    `regulatory_framework` STRING COMMENT 'Name of the regulatory framework or standard that mandates this training (e.g., OSHA Hazard Communication, FDA FSMA Preventive Controls, PCI DSS Security Awareness).',
    `regulatory_reporting_required_flag` BOOLEAN COMMENT 'Boolean indicator of whether this training completion must be reported to regulatory authorities or included in compliance audits (True) or is for internal tracking only (False).',
    `training_duration_hours` DECIMAL(18,2) COMMENT 'Total duration in hours that the associate spent completing the training program, including all modules and assessments.',
    `waiver_approval_date` DATE COMMENT 'Date on which the training waiver was approved by the authorized manager or compliance officer. Null if no waiver was granted.',
    `waiver_reason` STRING COMMENT 'Explanation of why the training requirement was waived for this associate, if applicable. Null if training was completed normally.',
    CONSTRAINT pk_training_completion PRIMARY KEY(`training_completion_id`)
) COMMENT 'Transactional record tracking individual associate completion of mandatory compliance training programs. Captures associate identifier, compliance training program, completion date, training delivery method, assessment score, pass/fail result, certificate of completion number, expiration date of certification earned, and compliance status (current, expiring soon, expired, not started). Complements workforce.training_enrollment (which covers all training) by providing the compliance domains authoritative view of regulatory training completion rates for audit and regulatory reporting purposes.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`violation_notice` (
    `violation_notice_id` BIGINT COMMENT 'Unique identifier for the regulatory violation notice record. Primary key for the violation notice entity.',
    `associate_id` BIGINT COMMENT 'Reference to the employee or role responsible for managing the violation response and corrective actions.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: violation_notice represents regulatory citations issued by agencies. Each violation is a violation of requirements under a specific compliance_program (e.g., FDA citation for food safety violation und',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Retail violation notices (health dept, OSHA, environmental) are assigned to responsible cost centers for financial accountability and remediation budget tracking. Finance allocates penalty costs and r',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Regulatory agencies issue citations to specific DC facilities (OSHA, EPA, FDA). Violation tracking, penalty management, and corrective action plans require facility-level attribution beyond store loca',
    `location_id` BIGINT COMMENT 'Reference to the retail location (store, distribution center, or facility) where the violation occurred.',
    `parent_violation_notice_id` BIGINT COMMENT 'Self-referencing FK on violation_notice (related_violation_notice_id)',
    `primary_previous_violation_notice_id` BIGINT COMMENT 'Reference to the previous violation notice if this is a recurrence. Links to the original violation for trend analysis.',
    `regulatory_agency_id` BIGINT COMMENT 'Reference to the regulatory agency or governing body that issued this violation notice.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Regulatory violations frequently cite specific products (mislabeled SKUs, banned ingredients, unauthorized health claims, expired items). Essential for corrective action, regulatory response documenta',
    `appeal_filed_date` DATE COMMENT 'Date when the formal appeal was filed with the regulatory agency or legal authority.',
    `appeal_filed_flag` BOOLEAN COMMENT 'Indicates whether Retail has filed a formal appeal of the violation notice with the regulatory agency or through legal channels.',
    `appeal_outcome` STRING COMMENT 'Result of the appeal process if an appeal was filed. Indicates whether the original violation was upheld, overturned, or modified.. Valid values are `upheld|overturned|modified|pending|withdrawn`',
    `case_closure_date` DATE COMMENT 'Date when the violation case was officially closed by the regulatory agency after all requirements, payments, and corrective actions were completed.',
    `citation_number` STRING COMMENT 'Official citation or case number assigned by the issuing regulatory agency. This is the externally-known identifier for tracking the violation with the regulatory body.',
    `corrective_action_completed_date` DATE COMMENT 'Date when all required corrective actions were completed and verified by Retail.',
    `corrective_action_deadline` DATE COMMENT 'Regulatory deadline by which all required corrective actions must be completed and verified.',
    `corrective_action_description` STRING COMMENT 'Detailed description of the corrective actions required by the regulatory agency to remediate the violation and prevent recurrence.',
    `corrective_action_required_flag` BOOLEAN COMMENT 'Indicates whether the regulatory agency requires specific corrective actions to be implemented beyond monetary penalties.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this violation notice record was first created in the system.',
    `followup_inspection_date` DATE COMMENT 'Scheduled or completed date of the regulatory agencys follow-up inspection to verify corrective actions.',
    `followup_inspection_required_flag` BOOLEAN COMMENT 'Indicates whether the regulatory agency requires a follow-up inspection to verify corrective actions have been implemented.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this violation notice record was last updated in the system.',
    `legal_counsel_assigned_flag` BOOLEAN COMMENT 'Indicates whether internal or external legal counsel has been assigned to manage this violation case.',
    `notes` STRING COMMENT 'Additional notes, comments, or context regarding the violation notice, response strategy, or case management.',
    `notice_received_date` DATE COMMENT 'Date when Retail received the formal violation notice from the regulatory agency.',
    `payment_date` DATE COMMENT 'Date when the penalty or settlement amount was paid to the regulatory agency.',
    `payment_due_date` DATE COMMENT 'Deadline by which the penalty or settlement amount must be paid to the regulatory agency.',
    `penalty_amount` DECIMAL(18,2) COMMENT 'Monetary penalty or fine amount assessed by the regulatory agency for the violation. Represents the initial penalty before any appeals or settlements.',
    `penalty_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the penalty amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `public_disclosure_date` DATE COMMENT 'Date when the violation was publicly disclosed through regulatory filings, press releases, or other public channels.',
    `public_disclosure_required_flag` BOOLEAN COMMENT 'Indicates whether the violation must be publicly disclosed per regulatory requirements or corporate governance policies.',
    `recurrence_flag` BOOLEAN COMMENT 'Indicates whether this violation is a repeat occurrence of a previously cited violation at the same location or for the same regulatory standard.',
    `regulatory_standard_violated` STRING COMMENT 'Specific regulatory standard, code section, or compliance requirement that was violated. References the exact regulation or standard cited by the agency.',
    `response_deadline` DATE COMMENT 'Regulatory deadline by which Retail must submit a formal response or corrective action plan to the issuing agency.',
    `response_document_url` STRING COMMENT 'URL or file path to the formal response document submitted to the regulatory agency.',
    `response_submitted_date` DATE COMMENT 'Date when Retail submitted its formal response or corrective action plan to the regulatory agency.',
    `settlement_amount` DECIMAL(18,2) COMMENT 'Final monetary amount agreed upon in a settlement with the regulatory agency. May differ from the original penalty amount.',
    `settlement_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the settlement amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `settlement_negotiated_flag` BOOLEAN COMMENT 'Indicates whether a settlement agreement was negotiated with the regulatory agency in lieu of the original penalty.',
    `severity_level` STRING COMMENT 'Classification of the violations severity as determined by the regulatory agency. Indicates the risk level and urgency of remediation required.. Valid values are `critical|major|minor|warning`',
    `violation_date` DATE COMMENT 'Date when the regulatory violation occurred or was observed by the regulatory agency. This is the principal business event timestamp for the violation.',
    `violation_description` STRING COMMENT 'Detailed narrative description of the regulatory violation as documented by the issuing agency. Includes specific findings, observations, and conditions that constitute the violation.',
    `violation_status` STRING COMMENT 'Current lifecycle status of the violation notice from receipt through resolution. Tracks the progression of the case through regulatory response and closure. [ENUM-REF-CANDIDATE: received|under_review|response_submitted|appeal_filed|settled|closed|contested — 7 candidates stripped; promote to reference product]',
    `violation_type` STRING COMMENT 'Category of regulatory violation. Classifies the nature of the violation for reporting and remediation tracking. [ENUM-REF-CANDIDATE: food_safety|workplace_safety|environmental|payment_security|data_privacy|fire_safety|building_code|labor_law|consumer_protection|advertising|other — 11 candidates stripped; promote to reference product]',
    CONSTRAINT pk_violation_notice PRIMARY KEY(`violation_notice_id`)
) COMMENT 'Formal regulatory violation notice or citation record issued to Retail by a government agency or regulatory body. Captures issuing agency (FDA, OSHA, EPA, state health department, fire marshal, PCI council), violation date, violation type, citation number, violation description, regulatory standard violated, penalty amount assessed, response deadline, response submitted date, appeal filed flag, settlement amount, and case closure date. Tracks the full lifecycle of externally-issued regulatory violations from receipt through resolution, distinct from internally-identified audit findings.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`policy` (
    `policy_id` BIGINT COMMENT 'Unique identifier for the compliance policy record. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the executive who approved the policy. Typically C-suite or SVP level.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key to the parent compliance program that this policy supports. Links policy to broader compliance initiatives and audit schedules.',
    `primary_policy_associate_id` BIGINT COMMENT 'Identifier of the employee who owns and is accountable for the policy. Typically a director or VP-level role.',
    `regulatory_agency_id` BIGINT COMMENT 'add column regulatory_agency_id (BIGINT) with FK to compliance.regulatory_agency.regulatory_agency_id - policies are often mandated by regulatory agencies and need this traceability',
    `superseded_policy_id` BIGINT COMMENT 'Foreign key to the previous version of this policy that this version replaces. Null for initial policy versions. Enables policy lineage tracking.',
    `tertiary_policy_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the user who last modified this policy record. Links to employee or system user master.',
    `acknowledgment_required_flag` BOOLEAN COMMENT 'Indicates whether employees must formally acknowledge they have read and understood the policy. Used for code of conduct and ethics policies.',
    `applicable_business_units` STRING COMMENT 'Comma-separated list of business unit codes or names where this policy is enforceable (e.g., Retail Stores, E-Commerce, Distribution Centers). All indicates enterprise-wide applicability.',
    `applicable_locations` STRING COMMENT 'Geographic scope of the policy. May specify countries, regions, or Global for worldwide applicability. Drives jurisdiction-specific compliance requirements.',
    `approval_date` DATE COMMENT 'Date when the policy was formally approved by the designated authority. Must precede or equal effective date.',
    `policy_category` STRING COMMENT 'High-level grouping of the policy by business function. Used for policy library organization and reporting. [ENUM-REF-CANDIDATE: regulatory_compliance|operational_standard|safety_protocol|security_control|privacy_protection|ethical_conduct|environmental_stewardship — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this policy record was first created in the system. Audit trail field.',
    `policy_description` STRING COMMENT 'Executive summary of the policy purpose, key requirements, and business rationale. Provides context for policy library users.',
    `distribution_scope` STRING COMMENT 'Target audience for policy distribution. Determines who receives policy notifications and has access to the policy document.. Valid values are `all_employees|management_only|specific_roles|suppliers|contractors|public`',
    `document_url` STRING COMMENT 'Hyperlink or file path to the full policy document in the document management system. Provides access to detailed procedures and guidelines.',
    `document_version` STRING COMMENT 'Version identifier of the linked policy document. Should match the policy version field for consistency.',
    `effective_date` DATE COMMENT 'Date when the policy becomes enforceable and binding across applicable business units. Must be on or after approval date.',
    `enforcement_mechanism` STRING COMMENT 'Description of how policy compliance is monitored and enforced (e.g., Quarterly audits, Automated system controls, Manager spot checks).',
    `expiration_date` DATE COMMENT 'Date when the policy ceases to be active and must be reviewed or renewed. Nullable for policies without scheduled expiration.',
    `external_publication_flag` BOOLEAN COMMENT 'Indicates whether this policy is published externally (e.g., on corporate website, in supplier portals). True for supplier codes of conduct and public-facing policies.',
    `governing_body` STRING COMMENT 'Name of the regulatory authority or standards organization that issued the framework (e.g., FDA, OSHA, PCI SSC, FTC).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this policy record was last updated. Audit trail field for change tracking.',
    `policy_name` STRING COMMENT 'Official name of the compliance policy or Standard Operating Procedure (SOP).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next mandatory policy review cycle. Driven by regulatory requirements or internal governance standards.',
    `notes` STRING COMMENT 'Additional comments, implementation guidance, or special instructions for policy administrators. Free-text field for operational context.',
    `owner_role` STRING COMMENT 'Job title or role of the policy owner (e.g., VP of Compliance, Director of Food Safety, Chief Privacy Officer).',
    `policy_number` STRING COMMENT 'Business-facing unique identifier for the policy, formatted as POL-{TYPE}-{SEQUENCE}. Used in policy communications and references.. Valid values are `^POL-[A-Z]{3}-[0-9]{6}$`',
    `policy_status` STRING COMMENT 'Current lifecycle state of the policy. Only active policies are enforceable; superseded policies are retained for audit history. [ENUM-REF-CANDIDATE: draft|under_review|approved|active|superseded|archived|withdrawn — 7 candidates stripped; promote to reference product]',
    `policy_type` STRING COMMENT 'Classification of the policy by regulatory domain. Determines which compliance framework and regulatory requirements the policy addresses. [ENUM-REF-CANDIDATE: food_safety_sop|osha_safety_policy|data_privacy_policy|pci_security_policy|environmental_policy|code_of_conduct|anti_corruption_policy|supplier_code_of_conduct|workplace_safety_policy|product_safety_policy — 10 candidates stripped; promote to reference product]',
    `regulatory_framework` STRING COMMENT 'Primary external regulatory standard or law that this policy operationalizes (e.g., FDA FSMA, OSHA 29 CFR 1910, GDPR, PCI DSS v4.0, CCPA).',
    `related_policies` STRING COMMENT 'Comma-separated list of policy IDs or policy numbers that are related or cross-referenced by this policy. Enables policy network analysis.',
    `review_frequency_months` STRING COMMENT 'Number of months between mandatory policy reviews. Typically 12, 24, or 36 months depending on regulatory requirements and risk level.',
    `risk_level` STRING COMMENT 'Business risk rating if this policy is not followed. Critical policies require immediate escalation for violations; low policies may have flexible enforcement.. Valid values are `critical|high|medium|low`',
    `scope` STRING COMMENT 'Detailed description of what business processes, systems, or activities this policy governs. Defines boundaries of applicability.',
    `training_frequency_months` STRING COMMENT 'Number of months between mandatory training refreshers for this policy. Null if training is one-time only.',
    `training_required_flag` BOOLEAN COMMENT 'Indicates whether employees in applicable business units must complete training on this policy. True triggers training assignment workflows.',
    `version` STRING COMMENT 'Version number of the policy document, following semantic versioning (major.minor). Incremented with each policy revision.. Valid values are `^[0-9]+.[0-9]+$`',
    `violation_penalty_description` STRING COMMENT 'Description of consequences for policy violations, ranging from retraining to termination. May reference disciplinary action matrix.',
    CONSTRAINT pk_policy PRIMARY KEY(`policy_id`)
) COMMENT 'Master record for internal compliance policies and standard operating procedures (SOPs) that govern how Retail meets its regulatory obligations. Captures policy name, policy type (food safety SOP, OSHA safety policy, data privacy policy, PCI security policy, environmental policy, code of conduct, anti-corruption policy), policy version, effective date, expiration/review date, policy owner, applicable business units, regulatory frameworks addressed, approval status, and distribution scope. Serves as the internal policy library that operationalizes external regulatory requirements.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`risk_register` (
    `risk_register_id` BIGINT COMMENT 'Unique identifier for the compliance risk register entry. Primary key.',
    `audit_finding_id` BIGINT COMMENT 'Identifier of the audit finding that triggered or is associated with this risk entry, enabling traceability between audit results and risk management.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: risk_register tracks compliance risks across the organization. Each risk should be associated with a specific compliance_program under which the risk is managed (e.g., food safety risks under the food',
    `environmental_event_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_event. Business justification: Environmental events create compliance and operational risks that should be tracked in the risk register. This FK links a risk entry to the environmental event that created the risk. Cardinality: Many',
    `org_unit_id` BIGINT COMMENT 'Identifier of the business unit, division, or operational area most affected by this risk.',
    `parent_risk_register_id` BIGINT COMMENT 'Self-referencing FK on risk_register (parent_risk_register_id)',
    `associate_id` BIGINT COMMENT 'FK to workforce.associate',
    `osha_incident_id` BIGINT COMMENT 'Identifier of a compliance incident or violation event that is linked to this risk, supporting root cause analysis and trend identification.',
    `tertiary_risk_identified_by_associate_id` BIGINT COMMENT 'Identifier of the employee, auditor, or system that identified the risk.',
    `violation_notice_id` BIGINT COMMENT 'Foreign key linking to compliance.violation_notice. Business justification: Violation notices represent compliance risks that should be tracked in the risk register. This FK links a risk entry to the violation notice that created or evidences the risk. Cardinality: Many risks',
    `actual_closure_date` DATE COMMENT 'Date when the risk was formally closed after successful mitigation or acceptance, enabling performance tracking against target dates.',
    `affected_locations` STRING COMMENT 'Comma-separated list or description of stores, distribution centers, or facilities where this risk is present, enabling geographic risk analysis.',
    `control_effectiveness_rating` STRING COMMENT 'Assessment of how well existing controls mitigate the risk on a scale of 1 (ineffective) to 5 (highly effective), based on control testing, audit results, and operational performance.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the risk register entry was first created in the compliance management system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the financial impact estimate (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `risk_register_description` STRING COMMENT 'Comprehensive narrative describing the nature of the compliance risk, potential violation scenarios, affected operations, and regulatory context.',
    `escalation_date` DATE COMMENT 'Date when the risk was escalated to senior leadership or governance bodies for awareness and decision-making.',
    `escalation_required` BOOLEAN COMMENT 'Indicates whether the risk severity or status requires escalation to executive leadership, board of directors, or audit committee.',
    `financial_impact_estimate` DECIMAL(18,2) COMMENT 'Estimated monetary cost if the risk materializes, including potential fines, penalties, remediation costs, legal fees, and business disruption losses.',
    `identified_date` DATE COMMENT 'Date when the compliance risk was first identified and entered into the risk register.',
    `impact_rating` STRING COMMENT 'Severity assessment of the consequences if the risk materializes on a scale of 1 (negligible) to 5 (catastrophic), considering financial, reputational, operational, and legal impacts.',
    `inherent_risk_score` STRING COMMENT 'Calculated risk exposure before considering controls, computed as likelihood_rating multiplied by impact_rating (range 1-25), representing the raw risk level.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to any field in the risk register entry, supporting audit trail and change tracking.',
    `last_review_date` DATE COMMENT 'Date of the most recent risk assessment review, when likelihood, impact, and control effectiveness were re-evaluated.',
    `likelihood_rating` STRING COMMENT 'Probability assessment of the risk occurring on a scale of 1 (rare) to 5 (almost certain), based on historical data, control environment, and operational exposure.',
    `mitigation_strategy` STRING COMMENT 'Detailed action plan describing controls, processes, training, technology, or policy changes implemented or planned to reduce the risk to an acceptable level.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic risk review, ensuring ongoing monitoring and reassessment of risk exposure.',
    `notes` STRING COMMENT 'Additional context, observations, or commentary from risk owners, compliance officers, or auditors regarding the risk assessment, mitigation progress, or special circumstances.',
    `regulatory_deadline` DATE COMMENT 'Mandatory compliance deadline imposed by the regulatory authority by which mitigation or corrective action must be completed to avoid penalties.',
    `regulatory_reporting_required` BOOLEAN COMMENT 'Indicates whether this risk must be reported to external regulatory authorities or governing bodies if it materializes.',
    `residual_risk_score` STRING COMMENT 'Net risk exposure after applying control effectiveness, calculated by adjusting inherent risk score based on control strength, representing the current risk level the organization carries.',
    `review_frequency` STRING COMMENT 'Cadence for periodic risk reassessment, aligned with the risk level and regulatory requirements.. Valid values are `monthly|quarterly|semi_annually|annually`',
    `risk_category` STRING COMMENT 'Primary regulatory domain classification of the risk: food safety (FDA/FSMA), workplace safety (OSHA), payment security (PCI-DSS), data privacy (GDPR/CCPA), environmental regulations, or labor law compliance.. Valid values are `food_safety|workplace_safety|payment_security|data_privacy|environmental|labor_law`',
    `risk_number` STRING COMMENT 'Business-facing unique identifier for the risk entry, formatted as RISK-NNNNNN for external communication and tracking.. Valid values are `^RISK-[0-9]{6}$`',
    `risk_register_status` STRING COMMENT 'Current lifecycle state of the risk: open (identified, not yet addressed), in_progress (mitigation underway), mitigated (controls implemented), accepted (formally acknowledged), or closed (no longer applicable).. Valid values are `open|in_progress|mitigated|accepted|closed`',
    `risk_response_type` STRING COMMENT 'Strategic approach to managing the risk: mitigate (reduce likelihood/impact), accept (acknowledge and monitor), transfer (insurance or third-party), or avoid (eliminate the activity).. Valid values are `mitigate|accept|transfer|avoid`',
    `risk_subcategory` STRING COMMENT 'Detailed classification within the primary risk category, providing granular segmentation for specialized compliance tracking (e.g., allergen labeling, forklift safety, cardholder data storage).',
    `target_closure_date` DATE COMMENT 'Planned date by which mitigation actions should be completed and the risk reduced to an acceptable level or closed.',
    `title` STRING COMMENT 'Concise title summarizing the compliance risk for executive reporting and dashboard display.',
    CONSTRAINT pk_risk_register PRIMARY KEY(`risk_register_id`)
) COMMENT 'Enterprise compliance risk register capturing identified compliance risks across all regulatory domains. Captures risk title, risk category (food safety, workplace safety, payment security, data privacy, environmental, labor law, anti-corruption), risk description, likelihood rating (1-5), impact rating (1-5), inherent risk score, control effectiveness rating, residual risk score, risk owner, mitigation strategy, risk status (open, mitigated, accepted, transferred), and last review date. Provides the compliance leadership team with a consolidated view of the organizations regulatory risk exposure.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` (
    `third_party_assessment_id` BIGINT COMMENT 'Unique identifier for the third-party compliance assessment record.',
    `certification_id` BIGINT COMMENT 'Foreign key linking to compliance.certification. Business justification: Third-party assessments are often conducted to validate, renew, or audit existing certifications. When an assessment is for certification purposes, it should link to the certification master record. C',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Third-party assessments are conducted under specific compliance programs (e.g., vendor security assessments under PCI program, supplier audits under food safety program). This FK links each assessment',
    `org_unit_id` BIGINT COMMENT 'Identifier for the Retail business unit or division that owns the relationship with this third party.',
    `associate_id` BIGINT COMMENT 'Identifier for the internal employee or external auditor who conducted the third-party compliance assessment.',
    `prior_third_party_assessment_id` BIGINT COMMENT 'Self-referencing FK on third_party_assessment (prior_third_party_assessment_id)',
    `vendor_id` BIGINT COMMENT 'Identifier for the third-party vendor, service provider, or business partner being assessed.',
    `assessment_date` DATE COMMENT 'The date on which the third-party compliance assessment was conducted or completed.',
    `assessment_method` STRING COMMENT 'The methodology or approach used to conduct the third-party compliance assessment.. Valid values are `onsite_audit|remote_audit|document_review|questionnaire|certification_review|continuous_monitoring`',
    `assessment_number` STRING COMMENT 'Unique business identifier or tracking number assigned to this compliance assessment.',
    `assessment_report_url` STRING COMMENT 'File path or URL to the detailed third-party compliance assessment report document.',
    `assessment_result` STRING COMMENT 'Overall outcome of the third-party compliance assessment indicating whether the third party meets the required compliance standards.. Valid values are `compliant|non_compliant|partially_compliant|pending_review|not_assessed`',
    `assessment_score` DECIMAL(18,2) COMMENT 'Numerical score or rating assigned to the third-party based on the compliance assessment, typically expressed as a percentage or on a defined scale.',
    `assessment_status` STRING COMMENT 'Current lifecycle status of the third-party compliance assessment. [ENUM-REF-CANDIDATE: scheduled|in_progress|completed|passed|failed|remediation_required|cancelled — 7 candidates stripped; promote to reference product]',
    `assessor_name` STRING COMMENT 'Full name of the individual or firm responsible for conducting the third-party compliance assessment.',
    `certification_expiration_date` DATE COMMENT 'Date on which the third partys compliance certification expires and requires renewal.',
    `compliance_framework` STRING COMMENT 'The regulatory or industry compliance framework under which this third-party assessment is conducted (e.g., GDPR Data Processor Agreement, PCI-DSS SAQ, SOC 2, FDA Supplier Verification, FSMA Foreign Supplier Verification Program). [ENUM-REF-CANDIDATE: gdpr_dpa|pci_dss_saq|soc2_type1|soc2_type2|fda_supplier_verification|fsma_fsvp|iso27001|hipaa_baa|ccpa_dpa|other — 10 candidates stripped; promote to reference product]',
    `contractual_obligations` STRING COMMENT 'Summary of the specific compliance obligations and requirements that the third party is contractually bound to meet as part of their service agreement with Retail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this third-party assessment record was first created in the system.',
    `critical_findings_count` STRING COMMENT 'Number of critical-severity compliance findings identified during the assessment that require immediate remediation.',
    `data_access_level` STRING COMMENT 'Classification of the type and sensitivity of data that the third party has access to as part of their service delivery.. Valid values are `cardholder_data|personal_data|confidential_business_data|public_data|no_data_access`',
    `data_processing_agreement_status` STRING COMMENT 'Current status of the Data Processing Agreement between Retail and the third-party data processor, required under GDPR Article 28 for entities processing personal data on behalf of Retail.. Valid values are `executed|pending|expired|not_required|under_review`',
    `dpa_execution_date` DATE COMMENT 'The date on which the Data Processing Agreement was signed and became effective.',
    `dpa_expiration_date` DATE COMMENT 'The date on which the Data Processing Agreement expires and requires renewal or renegotiation.',
    `executive_summary` STRING COMMENT 'High-level summary of the third-party assessment results, key findings, and recommendations for executive review.',
    `findings_count` STRING COMMENT 'Total number of compliance findings, issues, or deficiencies identified during the third-party assessment.',
    `high_findings_count` STRING COMMENT 'Number of high-severity compliance findings identified during the assessment.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this third-party assessment record was last updated or modified.',
    `low_findings_count` STRING COMMENT 'Number of low-severity compliance findings identified during the assessment.',
    `medium_findings_count` STRING COMMENT 'Number of medium-severity compliance findings identified during the assessment.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic compliance assessment or review of the third-party vendor.',
    `notes` STRING COMMENT 'Additional free-text notes, observations, or context related to the third-party compliance assessment.',
    `regulatory_report_date` DATE COMMENT 'Date on which the assessment results were reported to the relevant regulatory authority.',
    `regulatory_reporting_required_flag` BOOLEAN COMMENT 'Indicates whether the assessment results or findings must be reported to a regulatory authority or governing body.',
    `remediation_due_date` DATE COMMENT 'Target date by which the third party must complete all required remediation activities to address identified compliance gaps.',
    `remediation_required_flag` BOOLEAN COMMENT 'Indicates whether corrective actions or remediation activities are required based on the assessment findings.',
    `remediation_status` STRING COMMENT 'Current status of remediation efforts undertaken by the third party to address assessment findings.. Valid values are `not_started|in_progress|completed|overdue|verified`',
    `review_frequency` STRING COMMENT 'The cadence at which the third-party compliance assessment is scheduled to be conducted.. Valid values are `annual|semi_annual|quarterly|monthly|ad_hoc|continuous`',
    `risk_rating` STRING COMMENT 'Risk classification assigned to the third party based on the nature of services provided, data access level, and potential impact to Retail operations and compliance posture.. Valid values are `critical|high|medium|low`',
    `third_party_name` STRING COMMENT 'Legal or business name of the third-party entity being assessed for compliance.',
    `third_party_type` STRING COMMENT 'Classification of the third-party entity based on the services or products they provide to Retail. [ENUM-REF-CANDIDATE: data_processor|food_supplier|waste_hauler|security_vendor|payment_processor|logistics_provider|technology_vendor|marketing_agency|facility_services|other — 10 candidates stripped; promote to reference product]',
    CONSTRAINT pk_third_party_assessment PRIMARY KEY(`third_party_assessment_id`)
) COMMENT 'Compliance assessment and monitoring records for third-party vendors, service providers, and business partners who handle regulated data or activities on behalf of Retail. Captures third-party name, third-party type (data processor, food supplier, waste hauler, security vendor, payment processor), compliance framework assessed (GDPR data processor agreement, PCI-DSS SAQ, SOC 2, FDA supplier verification), assessment date, assessment result, contractual compliance obligations, data processing agreement status, and next review date. Supports GDPR Article 28 processor obligations, FSMA supplier verification, and PCI-DSS third-party management requirements.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`facility_training_requirement` (
    `facility_training_requirement_id` BIGINT COMMENT 'Unique identifier for this facility-specific training requirement record. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key to supplychain.dc_facility identifying which distribution center has this training requirement',
    `training_program_id` BIGINT COMMENT 'Foreign key to compliance.training_program identifying which training program is deployed at this facility',
    `completion_frequency` STRING COMMENT 'Required frequency for associates at this facility to complete or renew this training. May differ from the program default based on facility-specific regulatory requirements or operational needs.',
    `compliance_rate_percentage` DECIMAL(18,2) COMMENT 'Percentage of target associates at this facility who have completed this training program and are currently compliant. Calculated metric updated periodically.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility training requirement record was created in the system.',
    `facility_specific_content` STRING COMMENT 'Description of any facility-specific training content, addendums, or customizations required for this DC (e.g., facility layout, local emergency procedures, site-specific equipment).',
    `facility_training_coordinator_name` STRING COMMENT 'Name of the individual at this facility responsible for coordinating and tracking completion of this training program.',
    `last_training_date` DATE COMMENT 'Date when this training program was most recently delivered or completed by associates at this facility. Used to calculate next due date and compliance status.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility training requirement record was last modified.',
    `mandatory_flag` BOOLEAN COMMENT 'Indicates whether this training program is mandatory or optional for associates at this specific facility. Facility-specific because some DCs may have hazmat/forklift requirements while others do not.',
    `next_due_date` DATE COMMENT 'Date when the next training session or compliance check is due at this facility based on completion frequency and last training date.',
    `notes` STRING COMMENT 'Free-text notes about this facility-specific training requirement, including special circumstances, exemptions, or compliance issues.',
    `requirement_effective_date` DATE COMMENT 'Date when this training requirement became effective at this facility. Used to track when new training programs are rolled out to specific DCs.',
    `requirement_status` STRING COMMENT 'Current status of this training requirement at this facility. Active requirements are enforced; planned are scheduled for future deployment; suspended are temporarily paused; retired are no longer required.',
    `target_audience` STRING COMMENT 'Facility-specific description of which job roles or associate groups at this DC must complete this training (e.g., all warehouse associates, forklift operators only, receiving dock staff).',
    `total_associates_compliant` STRING COMMENT 'Number of associates at this facility who have completed this training and are currently compliant (certification not expired).',
    `total_associates_required` STRING COMMENT 'Total number of associates at this facility who are required to complete this training based on their job roles and the target audience definition.',
    CONSTRAINT pk_facility_training_requirement PRIMARY KEY(`facility_training_requirement_id`)
) COMMENT 'This association product represents the deployment and compliance tracking of training programs at distribution center facilities. It captures which training programs are required or optional at each DC, facility-specific training schedules, completion tracking, and compliance status. Each record links one training program to one DC facility with attributes that exist only in the context of this facility-specific training deployment.. Existence Justification: In retail distribution operations, training programs (forklift certification, hazmat handling, food safety, OSHA compliance) are deployed to multiple DC facilities based on facility type and operational requirements. Each DC facility requires multiple training programs depending on the products handled, equipment used, and regulatory mandates. The business actively manages facility-specific training requirements, tracking which programs are mandatory vs. optional at each location, facility-specific completion schedules, compliance rates, and customized content for site-specific procedures.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` (
    `facility_compliance_certification_id` BIGINT COMMENT 'Unique identifier for this facility-program certification record. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key to dc_facility. Identifies which distribution center facility is being certified.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key to compliance_program. Identifies which compliance program this certification record pertains to.',
    `facility_program_compliance_program_id` BIGINT COMMENT 'Foreign key linking to the compliance program that governs this facility certification',
    `audit_frequency` STRING COMMENT 'Required or planned frequency of compliance audits for this facility under this program. May vary by facility based on risk level, facility type, or past audit performance.',
    `certification_number` STRING COMMENT 'Official certification or accreditation number issued by the governing body or third-party auditor for this facility under this program. Unique to this facility-program combination.',
    `certification_status` STRING COMMENT 'Current certification status of this specific facility under this specific compliance program. Values: Not_Required (program does not apply to this facility type), In_Progress (certification application submitted), Certified (facility is compliant and certified), Expired (certification lapsed), Suspended (certification temporarily revoked), Under_Review (audit findings under remediation).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility-program certification record was first created in the system.',
    `effective_date` DATE COMMENT 'Date when this compliance program became binding and enforceable for this specific facility. May differ from the enterprise-level program effective date if facilities were phased into the program.',
    `expiration_date` DATE COMMENT 'Date when this facilitys certification under this program expires and requires renewal. Null for perpetual programs or facilities not yet certified.',
    `facility_risk_level` STRING COMMENT 'Assessed risk severity for this specific facility under this compliance program. May differ from the enterprise program risk level based on facility-specific factors (e.g., a frozen food DC has higher food safety risk than an apparel DC).',
    `incident_count_ytd` STRING COMMENT 'Number of compliance incidents, violations, or breaches recorded for this facility under this program year-to-date.',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit conducted at this facility for this program.',
    `last_audit_result` STRING COMMENT 'Outcome of the most recent compliance audit for this facility under this program. Passed: full compliance. Passed_with_Observations: compliant but minor issues noted. Failed: non-compliance requiring remediation. Conditional_Pass: compliant pending corrective actions. Not_Yet_Audited: facility not yet audited under this program.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next compliance audit at this facility for this program.',
    `notes` STRING COMMENT 'Free-text field for facility-specific compliance notes, special conditions, audit findings, remediation plans, or historical context for this facility-program relationship.',
    `program_scope` STRING COMMENT 'Scope of the compliance program as it applies to this specific facility. Full_Facility: entire facility operations covered. Specific_Zones: only certain temperature zones or storage areas (e.g., frozen zone for food safety). Specific_Operations: only certain processes (e.g., hazmat handling for OSHA). Excluded: facility is exempt from this program.',
    `responsible_manager` STRING COMMENT 'Name or employee identifier of the facility manager or compliance coordinator responsible for maintaining this programs compliance at this specific facility.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility-program certification record was last modified.',
    CONSTRAINT pk_facility_compliance_certification PRIMARY KEY(`facility_compliance_certification_id`)
) COMMENT 'This association product represents the certification relationship between compliance programs and distribution center facilities. It captures facility-specific compliance certification status, audit schedules, scope variations, and program participation details. Each record links one compliance program to one DC facility with attributes that exist only in the context of this specific facility-program certification relationship.. Existence Justification: In retail distribution operations, compliance programs (FDA food safety, OSHA workplace safety, ISO quality, organic certification, PCI-DSS) apply to multiple distribution centers, and each DC must maintain certification under multiple programs simultaneously. The relationship is actively managed by compliance teams who track facility-specific certification status, audit schedules, scope variations (e.g., food safety only applies to food DCs or specific temperature zones), and incident history. This is not a simple reference—its an operational certification management process with facility-specific data.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`audit_checklist_template` (
    `audit_checklist_template_id` BIGINT COMMENT 'Primary key for audit_checklist_template',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: audit_checklist_template defines audit procedures and checklists. Each template should be associated with a specific compliance_program (e.g., FDA audit checklist for the food safety program, OSHA ins',
    `parent_audit_checklist_template_id` BIGINT COMMENT 'Self-referencing FK on audit_checklist_template (parent_audit_checklist_template_id)',
    `applicable_departments` STRING COMMENT 'Comma-separated list of departments or business units to which this audit template applies (e.g., Food Safety, IT Security, Store Operations, Warehouse).',
    `approval_date` DATE COMMENT 'The date when this template was officially approved for use in compliance audits.',
    `approval_required` BOOLEAN COMMENT 'Indicates whether completed audits using this template require formal approval by a supervisor or compliance officer.',
    `approved_by` STRING COMMENT 'Name or identifier of the person or role who approved this template for use in compliance audits.',
    `audit_scope` STRING COMMENT 'The operational scope or location type this template is designed for (store, warehouse, distribution center, corporate office, supplier facility, multi-site, enterprise-wide).',
    `audit_type` STRING COMMENT 'Classification of the audit type this template supports (internal, external, regulatory, certification, supplier, operational, financial, safety, environmental).',
    `average_completion_time_minutes` STRING COMMENT 'The average actual time in minutes taken to complete audits using this template, based on historical data.',
    `certification_type` STRING COMMENT 'The type of certification required for auditors to use this template (e.g., Certified Food Safety Auditor, OSHA 30-Hour, PCI QSA).',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this audit checklist template record was first created in the system.',
    `critical_items_count` STRING COMMENT 'The number of checklist items marked as critical or mandatory for compliance within this template.',
    `effective_end_date` DATE COMMENT 'The date after which this audit checklist template is no longer valid for use. Null indicates no expiration.',
    `effective_start_date` DATE COMMENT 'The date from which this audit checklist template becomes active and available for use in compliance audits.',
    `estimated_duration_minutes` STRING COMMENT 'The estimated time in minutes required to complete an audit using this checklist template.',
    `frequency_type` STRING COMMENT 'The recommended or required frequency for conducting audits using this template (daily, weekly, monthly, quarterly, annual, ad-hoc, event-driven).',
    `industry_standard_reference` STRING COMMENT 'Reference to the specific industry standard, regulation, or guideline this template is based on (e.g., ISO 22000:2018, FSMA Section 117).',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether use of this template is mandatory for compliance purposes or optional for operational improvement.',
    `language_code` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the primary language of the template content (e.g., en for English, es for Spanish).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this audit checklist template record was last updated or modified.',
    `last_review_date` DATE COMMENT 'The date when this template was last reviewed for accuracy, relevance, and regulatory compliance.',
    `next_review_date` DATE COMMENT 'The scheduled date for the next review of this template to ensure continued compliance and relevance.',
    `notes` STRING COMMENT 'Additional notes, instructions, or context about the template for auditors or administrators.',
    `owner_contact_email` STRING COMMENT 'Email address of the primary contact or owner responsible for this template.',
    `owner_department` STRING COMMENT 'The department or business unit responsible for maintaining and updating this audit checklist template.',
    `passing_score_threshold` DECIMAL(18,2) COMMENT 'The minimum percentage score required for an audit to be considered passing when using this template.',
    `regulatory_authority` STRING COMMENT 'The government or regulatory body that mandates or oversees compliance for this audit template (e.g., FDA, OSHA, PCI SSC, FTC).',
    `requires_certification` BOOLEAN COMMENT 'Indicates whether auditors must hold specific certifications to conduct audits using this template.',
    `risk_level` STRING COMMENT 'The risk level associated with non-compliance in areas covered by this template (low, medium, high, critical).',
    `supports_corrective_action` BOOLEAN COMMENT 'Indicates whether this template includes provisions for documenting corrective actions for identified non-compliance issues.',
    `supports_digital_signature` BOOLEAN COMMENT 'Indicates whether this template supports digital signatures for audit completion and approval.',
    `supports_photo_evidence` BOOLEAN COMMENT 'Indicates whether this template supports or requires photographic evidence to be captured during the audit.',
    `template_category` STRING COMMENT 'High-level category classification of the template based on the compliance domain it addresses.',
    `template_code` STRING COMMENT 'Unique business identifier code for the audit checklist template, used for external reference and system integration.',
    `template_description` STRING COMMENT 'Detailed description of the audit checklist template, including its objectives, scope, and intended use cases.',
    `template_name` STRING COMMENT 'Human-readable name of the audit checklist template describing its purpose and scope.',
    `template_status` STRING COMMENT 'Current lifecycle status of the audit checklist template indicating whether it is available for use in audits.',
    `total_checklist_items` STRING COMMENT 'The total number of individual checklist items or questions included in this template.',
    `usage_count` STRING COMMENT 'The total number of times this template has been used to conduct audits since its creation.',
    `version_number` STRING COMMENT 'Version number of the template following semantic versioning (e.g., 1.0, 2.1) to track template revisions and updates.',
    CONSTRAINT pk_audit_checklist_template PRIMARY KEY(`audit_checklist_template_id`)
) COMMENT 'Master reference table for audit_checklist_template. Referenced by audit_checklist_template_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`requirement` (
    `requirement_id` BIGINT COMMENT 'Primary key for requirement',
    `compliance_program_id` BIGINT COMMENT 'add column compliance_program_id (BIGINT) with FK to compliance.compliance_program.compliance_program_id - requirements belong to compliance programs and this structural relationship is missing',
    `parent_requirement_id` BIGINT COMMENT 'Reference to the requirement_id of a higher-level or umbrella requirement of which this is a sub-requirement or detailed control.',
    `primary_superseded_by_requirement_id` BIGINT COMMENT 'Reference to the requirement_id of the newer requirement that replaces or supersedes this requirement, if applicable.',
    `regulatory_agency_id` BIGINT COMMENT 'add column regulatory_agency_id (BIGINT) with FK to compliance.regulatory_agency.regulatory_agency_id - requirements originate from regulatory agencies',
    `applicable_business_units` STRING COMMENT 'Comma-separated list or description of business units, departments, or operational areas within the retail organization to which this requirement applies (e.g., all stores, distribution centers, e-commerce, food service).',
    `applicable_locations` STRING COMMENT 'Description of geographic locations, facilities, or site types where this requirement must be enforced (e.g., all US stores, California distribution centers, food preparation areas).',
    `audit_frequency` STRING COMMENT 'Required or recommended frequency for auditing compliance with this requirement.',
    `certification_body` STRING COMMENT 'Name of the accredited organization or authority that issues certifications for compliance with this requirement (e.g., Qualified Security Assessor for PCI-DSS, accredited food safety auditor).',
    `certification_required` BOOLEAN COMMENT 'Indicates whether formal certification or attestation is required to demonstrate compliance with this requirement.',
    `requirement_code` STRING COMMENT 'Externally-known unique code or reference number for the compliance requirement (e.g., FDA-FSMA-2011, PCI-DSS-3.2.1, OSHA-1910.22).',
    `compliance_category` STRING COMMENT 'Functional area or domain of compliance that this requirement addresses within retail operations.',
    `compliance_obligation` STRING COMMENT 'Specific actions, controls, or outcomes that the organization must achieve to satisfy this requirement.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this compliance requirement record was first created in the system.',
    `requirement_description` STRING COMMENT 'Detailed narrative description of what the compliance requirement mandates, including specific obligations and expectations.',
    `documentation_required` BOOLEAN COMMENT 'Indicates whether formal documentation, records, or evidence must be maintained to demonstrate compliance.',
    `effective_date` DATE COMMENT 'The date when this compliance requirement becomes or became enforceable and binding.',
    `escalation_contact` STRING COMMENT 'Role or department to be contacted for escalation of compliance issues or questions related to this requirement.',
    `expiration_date` DATE COMMENT 'The date when this compliance requirement ceases to be enforceable or is superseded. Null for requirements with no defined end date.',
    `internal_policy_reference` STRING COMMENT 'Reference number or identifier of the internal company policy, procedure, or standard operating procedure that implements this compliance requirement.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether compliance with this requirement is legally mandatory (true) or recommended best practice (false).',
    `issuing_authority` STRING COMMENT 'The government agency, regulatory body, or standards organization that issued or enforces this requirement (e.g., Food and Drug Administration, Occupational Safety and Health Administration, Payment Card Industry Security Standards Council).',
    `jurisdiction` STRING COMMENT 'Three-letter ISO country code representing the geographic jurisdiction where this requirement applies (e.g., USA, CAN, GBR, DEU).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this compliance requirement record was last updated or modified.',
    `last_review_date` DATE COMMENT 'The date when this requirement was last reviewed by the compliance team for accuracy and applicability.',
    `maximum_penalty_amount` DECIMAL(18,2) COMMENT 'The maximum monetary penalty or fine that can be imposed for violation of this requirement, in the organizations reporting currency.',
    `requirement_name` STRING COMMENT 'Human-readable name or title of the compliance requirement.',
    `next_review_date` DATE COMMENT 'The scheduled date for the next periodic review of this requirement to ensure continued accuracy and relevance.',
    `notes` STRING COMMENT 'Additional free-text notes, clarifications, or implementation guidance related to this compliance requirement.',
    `penalty_description` STRING COMMENT 'Description of potential penalties, fines, sanctions, or legal consequences for non-compliance with this requirement.',
    `record_retention_period_days` STRING COMMENT 'Number of days that compliance records and documentation must be retained to satisfy this requirement.',
    `reference_document_url` STRING COMMENT 'Web address or hyperlink to the official regulatory text, standard document, or authoritative source for this requirement.',
    `regulatory_framework` STRING COMMENT 'The governing regulatory framework or standard to which this requirement belongs (e.g., FDA Food Safety Modernization Act, Payment Card Industry Data Security Standard, General Data Protection Regulation).',
    `requirement_status` STRING COMMENT 'Current lifecycle status of the compliance requirement indicating whether it is currently enforceable.',
    `requirement_type` STRING COMMENT 'Classification of the requirement based on its origin and binding nature.',
    `responsible_role` STRING COMMENT 'Job title or organizational role responsible for ensuring compliance with this requirement (e.g., Food Safety Manager, Data Protection Officer, Store Manager, Chief Compliance Officer).',
    `severity_level` STRING COMMENT 'Risk-based classification of the requirement indicating the potential impact of non-compliance on the organization.',
    `training_frequency` STRING COMMENT 'Required frequency for employee training related to this compliance requirement.',
    `training_required` BOOLEAN COMMENT 'Indicates whether employee training or education is mandated as part of compliance with this requirement.',
    `version_number` STRING COMMENT 'Version identifier of the regulatory requirement or standard (e.g., 3.2.1 for PCI-DSS version 3.2.1).',
    CONSTRAINT pk_requirement PRIMARY KEY(`requirement_id`)
) COMMENT 'Master reference table for requirement. Referenced by requirement_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`regulatory_agency` (
    `regulatory_agency_id` BIGINT COMMENT 'Primary key for regulatory_agency',
    `parent_regulatory_agency_id` BIGINT COMMENT 'Self-referencing FK on regulatory_agency (parent_regulatory_agency_id)',
    `address_line_1` STRING COMMENT 'First line of the regulatory agencys physical mailing address (street address).',
    `address_line_2` STRING COMMENT 'Second line of the regulatory agencys physical mailing address (suite, floor, building).',
    `agency_code` STRING COMMENT 'Standardized code or identifier assigned to the regulatory agency for system integration and reporting purposes.',
    `agency_name` STRING COMMENT 'Official full name of the regulatory agency (e.g., Food and Drug Administration, Occupational Safety and Health Administration).',
    `agency_short_name` STRING COMMENT 'Commonly used abbreviation or acronym for the agency (e.g., FDA, OSHA, PCI SSC, FTC).',
    `agency_type` STRING COMMENT 'Classification of the regulatory agency by jurisdiction level and authority type.',
    `certification_renewal_months` STRING COMMENT 'Number of months between required certification renewals if certification is required by this agency.',
    `certification_required` BOOLEAN COMMENT 'Indicates whether the agency requires formal certification or accreditation for compliance (True/False).',
    `city` STRING COMMENT 'City where the regulatory agency is headquartered.',
    `contact_email` STRING COMMENT 'Primary email address for contacting the regulatory agency regarding compliance inquiries and submissions.',
    `contact_phone` STRING COMMENT 'Primary phone number for contacting the regulatory agency.',
    `country_code` STRING COMMENT 'Three-letter ISO country code representing the primary country of the agencys authority (e.g., USA, GBR, DEU).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory agency record was first created in the system.',
    `dissolved_date` DATE COMMENT 'Date when the regulatory agency was dissolved, merged, or ceased operations (null if still active).',
    `enabling_legislation` STRING COMMENT 'Name and citation of the primary law or statute that established the regulatory agency and grants it authority (e.g., Food Safety Modernization Act, Occupational Safety and Health Act).',
    `enforcement_authority` STRING COMMENT 'Level of enforcement power the agency holds (full enforcement with penalties, advisory only, certification authority, audit-only).',
    `established_date` DATE COMMENT 'Date when the regulatory agency was officially established or incorporated.',
    `inspection_frequency_days` STRING COMMENT 'Typical number of days between required inspections or audits mandated by this agency for retail operations.',
    `jurisdiction` STRING COMMENT 'Geographic or functional jurisdiction of the regulatory agency (e.g., United States, European Union, California, Payment Card Industry).',
    `maximum_penalty_amount` DECIMAL(18,2) COMMENT 'Maximum monetary penalty amount that the agency can impose for a single violation.',
    `notes` STRING COMMENT 'Additional notes, special instructions, or context regarding the regulatory agency and its compliance requirements.',
    `penalty_authority` BOOLEAN COMMENT 'Indicates whether the agency has authority to impose fines, penalties, or sanctions for non-compliance (True/False).',
    `penalty_currency_code` STRING COMMENT 'Three-letter ISO currency code for penalty amounts (e.g., USD, EUR, GBP).',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the regulatory agencys headquarters address.',
    `primary_contact_name` STRING COMMENT 'Name of the primary contact person or department at the regulatory agency for compliance coordination.',
    `primary_contact_title` STRING COMMENT 'Job title or role of the primary contact person at the regulatory agency.',
    `regulatory_domain` STRING COMMENT 'Primary area of regulatory focus and enforcement (e.g., food safety, workplace safety, payment security, data privacy).',
    `reporting_frequency` STRING COMMENT 'Standard frequency at which compliance reports must be submitted to this regulatory agency.',
    `state_province` STRING COMMENT 'State or province where the regulatory agency is headquartered.',
    `regulatory_agency_status` STRING COMMENT 'Current operational status of the regulatory agency.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory agency record was last modified in the system.',
    `website_url` STRING COMMENT 'Official website URL of the regulatory agency for accessing regulations, guidance, and compliance resources.',
    CONSTRAINT pk_regulatory_agency PRIMARY KEY(`regulatory_agency_id`)
) COMMENT 'Master reference table for regulatory_agency. Referenced by issuing_agency_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`compliance`.`consent` (
    `consent_id` BIGINT COMMENT 'Primary key for consent',
    `profile_id` BIGINT COMMENT 'Reference to the customer who provided or withdrew consent. Links to the customer master record.',
    `collection_channel` STRING COMMENT 'The channel through which the consent was collected: web (e-commerce site), mobile app, POS (point of sale terminal), paper form (in-store signup), call center, email campaign, or in-store kiosk. [ENUM-REF-CANDIDATE: web|mobile_app|pos|paper_form|call_center|email|in_store_kiosk — 7 candidates stripped; promote to reference product]',
    `consent_status` STRING COMMENT 'Current status of the consent: granted (customer opted in), withdrawn (customer opted out), pending (awaiting customer action), expired (consent period ended), or revoked (administratively cancelled).. Valid values are `granted|withdrawn|pending|expired|revoked`',
    `consent_timestamp` TIMESTAMP COMMENT 'The exact date and time when the consent decision was captured. Critical for audit trails and regulatory proof of consent timing.',
    `consent_type` STRING COMMENT 'The specific type of consent being recorded: marketing email, SMS, push notifications, data sharing with partners, profiling for personalization, cookie tracking, or third-party data sharing. [ENUM-REF-CANDIDATE: marketing_email|marketing_sms|marketing_push|data_sharing|profiling|cookies|third_party_sharing — 7 candidates stripped; promote to reference product]',
    `data_subject_rights_notice` BOOLEAN COMMENT 'Boolean flag indicating whether the customer was informed of their data subject rights (right to access, rectification, erasure, restriction, portability, objection) at the time of consent collection.',
    `double_opt_in_confirmed` BOOLEAN COMMENT 'Boolean flag indicating whether the customer confirmed their consent via a double opt-in process (e.g., email confirmation link). Best practice for email marketing consent.',
    `double_opt_in_timestamp` TIMESTAMP COMMENT 'The date and time when the customer confirmed their consent via double opt-in. Null if double opt-in was not used or not yet confirmed.',
    `expiration_date` DATE COMMENT 'The date on which this consent expires and must be re-obtained. Null if consent does not expire. Used for consent refresh workflows.',
    `granularity` STRING COMMENT 'The level of granularity at which consent was obtained: global (all purposes), channel-specific (email vs SMS), purpose-specific (marketing vs analytics), or brand-specific (for multi-brand retailers).. Valid values are `global|channel_specific|purpose_specific|brand_specific`',
    `ip_address` STRING COMMENT 'The IP address from which the consent was submitted. Used as proof of consent origin for regulatory compliance and fraud detection.',
    `jurisdiction` STRING COMMENT 'The legal jurisdiction (country or state code) under which this consent was collected and is governed. Determines applicable privacy regulations (GDPR, CCPA, etc.).',
    `language` STRING COMMENT 'The language in which the consent form was presented to the customer (ISO 639-1 two-letter code, e.g., EN, ES, FR). Required for multi-lingual compliance.',
    `legal_basis` STRING COMMENT 'The legal basis under GDPR for processing this data: consent, contract fulfillment, legal obligation, vital interest, public task, or legitimate interest. Required for GDPR Article 6 compliance.. Valid values are `consent|contract|legal_obligation|vital_interest|public_task|legitimate_interest`',
    `method` STRING COMMENT 'The method by which consent was obtained: explicit opt-in (customer actively checked box), implicit opt-in (inferred from action), pre-checked box (legacy, non-compliant), verbal (phone), or written signature (paper form).. Valid values are `explicit_opt_in|implicit_opt_in|pre_checked_box|verbal|written_signature`',
    `minor_consent_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this consent record pertains to a minor (under age of digital consent in jurisdiction). Triggers additional parental consent requirements under GDPR Article 8 and COPPA.',
    `parental_consent_verified` BOOLEAN COMMENT 'Boolean flag indicating whether parental or guardian consent has been verified for a minor. Required for COPPA and GDPR Article 8 compliance.',
    `privacy_policy_version` STRING COMMENT 'The specific version of the privacy policy document that was in effect and accepted by the customer at the time of consent. Required for regulatory audit trails.',
    `proof_document_url` STRING COMMENT 'URL or storage path to the digitally signed or archived copy of the consent form as presented to the customer. Used for audit and regulatory inspection.',
    `record_created_timestamp` TIMESTAMP COMMENT 'System timestamp when this consent record was first created in the data platform. Immutable. Used for audit trail and data lineage.',
    `record_source_system` STRING COMMENT 'The name or identifier of the source system that originated this consent record (e.g., the e-commerce platform, POS system, call center CRM). Used for data lineage and troubleshooting.',
    `scope` STRING COMMENT 'Detailed description of the scope and purpose of the consent. Explains what data will be used for and how, ensuring transparency and specificity required by privacy regulations.',
    `third_party_recipient` STRING COMMENT 'Name or identifier of the third party with whom data may be shared under this consent. Null if no third-party sharing is involved. Required for transparency under GDPR Article 13.',
    `user_agent` STRING COMMENT 'The browser or application user agent string captured at the time of consent. Provides additional context for consent collection environment.',
    `version` STRING COMMENT 'Version identifier of the consent form or privacy policy that was presented to the customer at the time of consent. Enables tracking of which policy version the customer agreed to.',
    `withdrawal_reason` STRING COMMENT 'Optional free-text reason provided by the customer for withdrawing consent. Used for customer experience analysis and compliance documentation.',
    `withdrawal_timestamp` TIMESTAMP COMMENT 'The exact date and time when the customer withdrew their consent. Null if consent has not been withdrawn. Critical for right-to-erasure workflows.',
    `consent_given_at` STRING COMMENT '',
    `consent_withdrawn_at` STRING COMMENT '',
    `purpose` STRING COMMENT '',
    `channel` STRING COMMENT '',
    CONSTRAINT pk_consent PRIMARY KEY(`consent_id`)
) COMMENT 'Authoritative audit trail of customer privacy consent decisions required for GDPR and CCPA compliance. Each row captures consent type (marketing email, SMS, data sharing, profiling, cookies), consent status (granted/withdrawn/pending), consent version, collection channel (web/POS/mobile/paper), collection timestamp, IP address at time of consent, the specific privacy policy version accepted, and the profile reference for the consenting customer. Immutable append-only records supporting regulatory reporting, right-to-erasure workflows, and consent proof during audits.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ADD CONSTRAINT `fk_compliance_compliance_program_parent_compliance_program_id` FOREIGN KEY (`parent_compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_parent_obligation_id` FOREIGN KEY (`parent_obligation_id`) REFERENCES `vibe_retail_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_requirement_id` FOREIGN KEY (`requirement_id`) REFERENCES `vibe_retail_v1`.`compliance`.`requirement`(`requirement_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ADD CONSTRAINT `fk_compliance_audit_schedule_audit_checklist_template_id` FOREIGN KEY (`audit_checklist_template_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_checklist_template`(`audit_checklist_template_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ADD CONSTRAINT `fk_compliance_audit_schedule_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ADD CONSTRAINT `fk_compliance_audit_schedule_primary_previous_audit_audit_schedule_id` FOREIGN KEY (`primary_previous_audit_audit_schedule_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_schedule`(`audit_schedule_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ADD CONSTRAINT `fk_compliance_audit_event_audit_schedule_id` FOREIGN KEY (`audit_schedule_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_schedule`(`audit_schedule_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ADD CONSTRAINT `fk_compliance_audit_event_follow_up_audit_event_id` FOREIGN KEY (`follow_up_audit_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_event`(`audit_event_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_audit_event_id` FOREIGN KEY (`audit_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_event`(`audit_event_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_parent_audit_finding_id` FOREIGN KEY (`parent_audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_primary_previous_finding_audit_finding_id` FOREIGN KEY (`primary_previous_finding_audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_environmental_event_id` FOREIGN KEY (`environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_follow_up_corrective_action_id` FOREIGN KEY (`follow_up_corrective_action_id`) REFERENCES `vibe_retail_v1`.`compliance`.`corrective_action`(`corrective_action_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_osha_incident_id` FOREIGN KEY (`osha_incident_id`) REFERENCES `vibe_retail_v1`.`compliance`.`osha_incident`(`osha_incident_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_violation_notice_id` FOREIGN KEY (`violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ADD CONSTRAINT `fk_compliance_food_safety_plan_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ADD CONSTRAINT `fk_compliance_food_safety_plan_superseded_food_safety_plan_id` FOREIGN KEY (`superseded_food_safety_plan_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_plan`(`food_safety_plan_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ADD CONSTRAINT `fk_compliance_haccp_control_point_food_safety_plan_id` FOREIGN KEY (`food_safety_plan_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_plan`(`food_safety_plan_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ADD CONSTRAINT `fk_compliance_haccp_control_point_parent_haccp_control_point_id` FOREIGN KEY (`parent_haccp_control_point_id`) REFERENCES `vibe_retail_v1`.`compliance`.`haccp_control_point`(`haccp_control_point_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ADD CONSTRAINT `fk_compliance_food_safety_log_corrected_food_safety_log_id` FOREIGN KEY (`corrected_food_safety_log_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_log`(`food_safety_log_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ADD CONSTRAINT `fk_compliance_food_safety_log_haccp_control_point_id` FOREIGN KEY (`haccp_control_point_id`) REFERENCES `vibe_retail_v1`.`compliance`.`haccp_control_point`(`haccp_control_point_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ADD CONSTRAINT `fk_compliance_osha_incident_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ADD CONSTRAINT `fk_compliance_osha_incident_parent_osha_incident_id` FOREIGN KEY (`parent_osha_incident_id`) REFERENCES `vibe_retail_v1`.`compliance`.`osha_incident`(`osha_incident_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ADD CONSTRAINT `fk_compliance_osha_incident_primary_previous_incident_osha_incident_id` FOREIGN KEY (`primary_previous_incident_osha_incident_id`) REFERENCES `vibe_retail_v1`.`compliance`.`osha_incident`(`osha_incident_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ADD CONSTRAINT `fk_compliance_safety_inspection_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ADD CONSTRAINT `fk_compliance_safety_inspection_follow_up_safety_inspection_id` FOREIGN KEY (`follow_up_safety_inspection_id`) REFERENCES `vibe_retail_v1`.`compliance`.`safety_inspection`(`safety_inspection_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ADD CONSTRAINT `fk_compliance_pci_assessment_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ADD CONSTRAINT `fk_compliance_pci_assessment_prior_pci_assessment_id` FOREIGN KEY (`prior_pci_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`pci_assessment`(`pci_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ADD CONSTRAINT `fk_compliance_pci_control_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ADD CONSTRAINT `fk_compliance_pci_control_parent_pci_control_id` FOREIGN KEY (`parent_pci_control_id`) REFERENCES `vibe_retail_v1`.`compliance`.`pci_control`(`pci_control_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ADD CONSTRAINT `fk_compliance_privacy_assessment_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ADD CONSTRAINT `fk_compliance_privacy_assessment_prior_privacy_assessment_id` FOREIGN KEY (`prior_privacy_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`privacy_assessment`(`privacy_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_amended_regulatory_filing_id` FOREIGN KEY (`amended_regulatory_filing_id`) REFERENCES `vibe_retail_v1`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_license_permit_id` FOREIGN KEY (`license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_regulatory_agency_id` FOREIGN KEY (`regulatory_agency_id`) REFERENCES `vibe_retail_v1`.`compliance`.`regulatory_agency`(`regulatory_agency_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ADD CONSTRAINT `fk_compliance_license_permit_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ADD CONSTRAINT `fk_compliance_license_permit_renewed_from_license_permit_id` FOREIGN KEY (`renewed_from_license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_renewed_from_certification_id` FOREIGN KEY (`renewed_from_certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ADD CONSTRAINT `fk_compliance_environmental_event_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ADD CONSTRAINT `fk_compliance_environmental_event_parent_environmental_event_id` FOREIGN KEY (`parent_environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ADD CONSTRAINT `fk_compliance_training_program_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ADD CONSTRAINT `fk_compliance_training_program_prerequisite_training_program_id` FOREIGN KEY (`prerequisite_training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_retake_of_training_completion_id` FOREIGN KEY (`retake_of_training_completion_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_completion`(`training_completion_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_parent_violation_notice_id` FOREIGN KEY (`parent_violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_primary_previous_violation_notice_id` FOREIGN KEY (`primary_previous_violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_regulatory_agency_id` FOREIGN KEY (`regulatory_agency_id`) REFERENCES `vibe_retail_v1`.`compliance`.`regulatory_agency`(`regulatory_agency_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_regulatory_agency_id` FOREIGN KEY (`regulatory_agency_id`) REFERENCES `vibe_retail_v1`.`compliance`.`regulatory_agency`(`regulatory_agency_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_superseded_policy_id` FOREIGN KEY (`superseded_policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_environmental_event_id` FOREIGN KEY (`environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_parent_risk_register_id` FOREIGN KEY (`parent_risk_register_id`) REFERENCES `vibe_retail_v1`.`compliance`.`risk_register`(`risk_register_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_osha_incident_id` FOREIGN KEY (`osha_incident_id`) REFERENCES `vibe_retail_v1`.`compliance`.`osha_incident`(`osha_incident_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_violation_notice_id` FOREIGN KEY (`violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ADD CONSTRAINT `fk_compliance_third_party_assessment_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ADD CONSTRAINT `fk_compliance_third_party_assessment_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ADD CONSTRAINT `fk_compliance_third_party_assessment_prior_third_party_assessment_id` FOREIGN KEY (`prior_third_party_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`third_party_assessment`(`third_party_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_training_requirement` ADD CONSTRAINT `fk_compliance_facility_training_requirement_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` ADD CONSTRAINT `fk_compliance_facility_compliance_certification_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` ADD CONSTRAINT `fk_compliance_facility_compliance_certification_facility_program_compliance_program_id` FOREIGN KEY (`facility_program_compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_checklist_template` ADD CONSTRAINT `fk_compliance_audit_checklist_template_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_checklist_template` ADD CONSTRAINT `fk_compliance_audit_checklist_template_parent_audit_checklist_template_id` FOREIGN KEY (`parent_audit_checklist_template_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_checklist_template`(`audit_checklist_template_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`requirement` ADD CONSTRAINT `fk_compliance_requirement_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`requirement` ADD CONSTRAINT `fk_compliance_requirement_parent_requirement_id` FOREIGN KEY (`parent_requirement_id`) REFERENCES `vibe_retail_v1`.`compliance`.`requirement`(`requirement_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`requirement` ADD CONSTRAINT `fk_compliance_requirement_primary_superseded_by_requirement_id` FOREIGN KEY (`primary_superseded_by_requirement_id`) REFERENCES `vibe_retail_v1`.`compliance`.`requirement`(`requirement_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`requirement` ADD CONSTRAINT `fk_compliance_requirement_regulatory_agency_id` FOREIGN KEY (`regulatory_agency_id`) REFERENCES `vibe_retail_v1`.`compliance`.`regulatory_agency`(`regulatory_agency_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_agency` ADD CONSTRAINT `fk_compliance_regulatory_agency_parent_regulatory_agency_id` FOREIGN KEY (`parent_regulatory_agency_id`) REFERENCES `vibe_retail_v1`.`compliance`.`regulatory_agency`(`regulatory_agency_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`compliance` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_retail_v1`.`compliance` SET TAGS ('dbx_domain' = 'compliance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `audit_frequency` SET TAGS ('dbx_value_regex' = 'annual|semi_annual|quarterly|monthly|continuous|ad_hoc');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'certified|pending_certification|expired|revoked|not_applicable');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `compliance_program_description` SET TAGS ('dbx_business_glossary_term' = 'Program Description');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `incident_count_ytd` SET TAGS ('dbx_business_glossary_term' = 'Incident Count Year-to-Date (YTD)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `last_audit_result` SET TAGS ('dbx_value_regex' = 'passed|passed_with_findings|failed|not_applicable');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `manager` SET TAGS ('dbx_business_glossary_term' = 'Program Manager');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Modified By');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Program Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `penalty_amount_max` SET TAGS ('dbx_business_glossary_term' = 'Maximum Penalty Amount');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `policy_document_url` SET TAGS ('dbx_business_glossary_term' = 'Policy Document URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `program_scope` SET TAGS ('dbx_value_regex' = 'enterprise_wide|banner_specific|channel_specific|region_specific|store_specific|dc_specific');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `program_status` SET TAGS ('dbx_value_regex' = 'active|suspended|under_review|retired|pending_activation|non_compliant');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `sponsor` SET TAGS ('dbx_business_glossary_term' = 'Program Sponsor');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `training_frequency` SET TAGS ('dbx_value_regex' = 'annual|semi_annual|quarterly|one_time|continuous|not_applicable');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `training_required` SET TAGS ('dbx_business_glossary_term' = 'Training Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`compliance_program` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `cadence` SET TAGS ('dbx_business_glossary_term' = 'Obligation Cadence');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `obligation_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Obligation Due Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Obligation Effective Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `evidence_required` SET TAGS ('dbx_business_glossary_term' = 'Evidence Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Obligation Expiration Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Obligation Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `obligation_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|fulfilled|overdue|waived|cancelled');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `obligation_type` SET TAGS ('dbx_value_regex' = 'policy|procedure|training|audit|certification|reporting');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Obligation Priority');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Obligation Title');
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ALTER COLUMN `waiver_approved` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` SET TAGS ('dbx_subdomain' = 'audit_control');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Auditor ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `primary_previous_audit_audit_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Audit ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `tertiary_audit_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `audit_number` SET TAGS ('dbx_business_glossary_term' = 'Audit Schedule Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^AUD-[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `confirmation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Schedule Confirmation Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Audit Cost');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `estimated_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration (Hours)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Audit Frequency');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `is_follow_up_audit` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Audit Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Audit Priority');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `regulatory_deadline` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Deadline Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `requires_site_access_approval` SET TAGS ('dbx_business_glossary_term' = 'Site Access Approval Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_value_regex' = 'planned|confirmed|in_progress|rescheduled|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Audit Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ALTER COLUMN `third_party_firm_name` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Audit Firm Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` SET TAGS ('dbx_subdomain' = 'audit_control');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Business Unit ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `audit_method` SET TAGS ('dbx_value_regex' = 'on_site|remote|hybrid|document_review');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^AUD-[0-9]{8}-[A-Z0-9]{6}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `audit_report_url` SET TAGS ('dbx_value_regex' = '^https?://.*$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `audit_result` SET TAGS ('dbx_value_regex' = 'pass|conditional_pass|fail|not_applicable');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `audit_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|deferred');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'food_safety|workplace_safety|pci_dss|gdpr_ccpa|environmental|quality_assurance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `corrective_action_plan_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Plan (CAP) Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `follow_up_due_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Due Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `follow_up_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Audit Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` SET TAGS ('dbx_subdomain' = 'audit_control');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `audit_event_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Event Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Auditor Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `primary_previous_finding_audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Finding Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `tertiary_audit_verified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Verified By Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `affected_area` SET TAGS ('dbx_business_glossary_term' = 'Affected Area or Process');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `audit_finding_status` SET TAGS ('dbx_business_glossary_term' = 'Finding Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `audit_finding_status` SET TAGS ('dbx_value_regex' = 'open|in_remediation|pending_verification|closed|disputed');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `audit_finding_category` SET TAGS ('dbx_business_glossary_term' = 'Finding Category');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `audit_finding_category` SET TAGS ('dbx_value_regex' = 'critical|major|minor|observation');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Finding Closed Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `control_reference` SET TAGS ('dbx_business_glossary_term' = 'Control or Requirement Reference');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `corrective_action_plan` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Plan (CAP)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `audit_finding_description` SET TAGS ('dbx_business_glossary_term' = 'Finding Description');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `evidence_location` SET TAGS ('dbx_business_glossary_term' = 'Evidence Storage Location');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `identified_date` SET TAGS ('dbx_business_glossary_term' = 'Finding Identified Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Finding Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Finding Title');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` SET TAGS ('dbx_subdomain' = 'audit_control');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `environmental_event_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `osha_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Osha Incident Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Owner ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `violation_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Violation Notice Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `action_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `action_number` SET TAGS ('dbx_value_regex' = '^CA-[0-9]{6,10}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `action_type` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Type');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `action_type` SET TAGS ('dbx_value_regex' = 'immediate_fix|process_change|training|system_update|policy_revision|equipment_upgrade');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `compliance_category` SET TAGS ('dbx_value_regex' = 'food_safety|workplace_safety|payment_security|data_privacy|environmental|product_safety');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `corrective_action_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|pending_verification|closed|overdue');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_value_regex' = 'effective|partially_effective|ineffective|pending');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `escalation_required` SET TAGS ('dbx_business_glossary_term' = 'Escalation Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `external_reporting_required` SET TAGS ('dbx_business_glossary_term' = 'External Reporting Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Priority');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Title');
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ALTER COLUMN `verification_method` SET TAGS ('dbx_value_regex' = 'document_review|on_site_inspection|testing|audit|management_review|third_party_validation');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `allergen_controls_included` SET TAGS ('dbx_business_glossary_term' = 'Allergen Controls Included Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `critical_control_points_count` SET TAGS ('dbx_business_glossary_term' = 'Critical Control Points (CCP) Count');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `environmental_monitoring_program` SET TAGS ('dbx_business_glossary_term' = 'Environmental Monitoring Program Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `facility_scope` SET TAGS ('dbx_business_glossary_term' = 'Facility Scope Description');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `fda_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Food and Drug Administration (FDA) Registration Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `last_audit_result` SET TAGS ('dbx_value_regex' = 'compliant|non-compliant|minor findings|major findings|pending');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Plan Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Food Safety Plan Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Food Safety Plan Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'active|under review|pending approval|expired|superseded|suspended');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Food Safety Plan Type');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'HACCP|HARPC|Preventive Controls|Juice HACCP|Seafood HACCP|Produce Safety');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Food Safety Plan Version');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `qfsp_certification_date` SET TAGS ('dbx_business_glossary_term' = 'Qualified Food Safety Professional (QFSP) Certification Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `qfsp_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Qualified Food Safety Professional (QFSP) Contact Email');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `qfsp_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `qfsp_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Qualified Food Safety Professional (QFSP) Contact Phone');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `qfsp_credentials` SET TAGS ('dbx_business_glossary_term' = 'Qualified Food Safety Professional (QFSP) Credentials');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `qfsp_name` SET TAGS ('dbx_business_glossary_term' = 'Qualified Food Safety Professional (QFSP) Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `recall_plan_included` SET TAGS ('dbx_business_glossary_term' = 'Recall Plan Included Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ALTER COLUMN `supply_chain_program_included` SET TAGS ('dbx_business_glossary_term' = 'Supply Chain Program Included Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `haccp_control_point_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Analysis and Critical Control Point (HACCP) Control Point ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'PCQI Approval Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `approved_by_pcqi` SET TAGS ('dbx_business_glossary_term' = 'Approved By Preventive Controls Qualified Individual (PCQI)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `control_point_status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|suspended|archived');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `control_point_type` SET TAGS ('dbx_value_regex' = 'critical_control_point|prerequisite_program|preventive_control|allergen_control|sanitation_control|supply_chain_control');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `critical_limit_unit` SET TAGS ('dbx_business_glossary_term' = 'Critical Limit Unit of Measure');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `gfsi_scheme_alignment` SET TAGS ('dbx_business_glossary_term' = 'Global Food Safety Initiative (GFSI) Scheme Alignment');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `hazard_type` SET TAGS ('dbx_value_regex' = 'biological|chemical|physical|radiological|allergen');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `likelihood_level` SET TAGS ('dbx_value_regex' = 'high|medium|low|negligible');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Control Point Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|major|moderate|minor');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `haccp_control_point_id` SET TAGS ('dbx_business_glossary_term' = 'Haccp Control Point Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Employee ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `audit_trail_reference` SET TAGS ('dbx_business_glossary_term' = 'Audit Trail ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `control_point_type` SET TAGS ('dbx_value_regex' = 'ccp|cp|prp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `critical_limit_lower` SET TAGS ('dbx_business_glossary_term' = 'Critical Limit Lower Bound');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `critical_limit_upper` SET TAGS ('dbx_business_glossary_term' = 'Critical Limit Upper Bound');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `deviation_severity` SET TAGS ('dbx_value_regex' = 'none|minor|major|critical');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `equipment_code` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `health_department_reportable` SET TAGS ('dbx_business_glossary_term' = 'Health Department Reportable Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `instrument_code` SET TAGS ('dbx_business_glossary_term' = 'Instrument ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `limit_status` SET TAGS ('dbx_business_glossary_term' = 'Critical Limit Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `limit_status` SET TAGS ('dbx_value_regex' = 'within_limit|limit_exceeded|limit_approached');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_value_regex' = 'manual|automated|calibrated_instrument|visual_inspection');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `product_disposition` SET TAGS ('dbx_value_regex' = 'released|held|destroyed|reworked|returned');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `record_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|verified|archived');
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ALTER COLUMN `supervisor_verified` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Verified Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `osha_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Occupational Safety and Health Administration (OSHA) Incident ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `primary_previous_incident_osha_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Incident ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `tertiary_osha_investigator_employee_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Investigator Employee ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `days_restricted_duty` SET TAGS ('dbx_business_glossary_term' = 'Days on Restricted Duty');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `incident_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-d{4}-d{6}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_value_regex' = 'injury|illness|near_miss|property_damage|environmental|vehicle');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `osha_300_log_entry_flag` SET TAGS ('dbx_business_glossary_term' = 'Occupational Safety and Health Administration (OSHA) 300 Log Entry Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `osha_301_reportable_flag` SET TAGS ('dbx_business_glossary_term' = 'Occupational Safety and Health Administration (OSHA) 301 Reportable Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `osha_incident_status` SET TAGS ('dbx_business_glossary_term' = 'Incident Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `osha_incident_status` SET TAGS ('dbx_value_regex' = 'reported|under_investigation|investigation_complete|closed|pending_review');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `osha_recordable_flag` SET TAGS ('dbx_business_glossary_term' = 'Occupational Safety and Health Administration (OSHA) Recordable Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'minor|moderate|serious|severe|fatal');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `followup_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Inspection Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `followup_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Inspection Required');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `hazmat_storage_compliant` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Storage Compliant');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `inspection_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|pending_review');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = 'routine|triggered|pre_opening|regulatory|incident_followup|annual');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `overall_result` SET TAGS ('dbx_business_glossary_term' = 'Overall Inspection Result');
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ALTER COLUMN `overall_result` SET TAGS ('dbx_value_regex' = 'pass|pass_with_observations|fail|conditional_pass');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` SET TAGS ('dbx_subdomain' = 'privacy_protection');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `pci_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry Data Security Standard (PCI-DSS) Assessment ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Qualified Security Assessor (QSA) Company Identifier');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Completion Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Assessment Reference Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `assessment_report_url` SET TAGS ('dbx_business_glossary_term' = 'Assessment Report Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `assessor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Assessor Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `attestation_of_compliance_submitted_flag` SET TAGS ('dbx_business_glossary_term' = 'Attestation of Compliance (AOC) Submitted Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `attestation_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Attestation of Compliance (AOC) Submission Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `cardholder_data_environment_scope` SET TAGS ('dbx_business_glossary_term' = 'Cardholder Data Environment (CDE) Scope Description');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Overall Compliance Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'Compliant|Non-Compliant|Compliant with Compensating Controls|In Progress');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `in_scope_locations_count` SET TAGS ('dbx_business_glossary_term' = 'In-Scope Locations Count');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `in_scope_systems_count` SET TAGS ('dbx_business_glossary_term' = 'In-Scope Systems Count');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `merchant_level` SET TAGS ('dbx_value_regex' = 'Level 1|Level 2|Level 3|Level 4');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `pci_dss_version` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry Data Security Standard (PCI-DSS) Version');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `qsa_firm_name` SET TAGS ('dbx_business_glossary_term' = 'Qualified Security Assessor (QSA) Firm Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ALTER COLUMN `vulnerability_scan_vendor` SET TAGS ('dbx_business_glossary_term' = 'Approved Scanning Vendor (ASV) Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` SET TAGS ('dbx_subdomain' = 'privacy_protection');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `pci_control_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `active_flag` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Active Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `assessor_notes` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Assessor Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `automation_level` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Automation Level');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `automation_level` SET TAGS ('dbx_value_regex' = 'fully_automated|partially_automated|manual');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `cardholder_data_environment_scope` SET TAGS ('dbx_business_glossary_term' = 'Cardholder Data Environment (CDE) Scope');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `compensating_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Compensating Control Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `compensating_control_justification` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Compensating Control Justification');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `control_category` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Category');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `control_category` SET TAGS ('dbx_value_regex' = 'network_security|access_control|encryption|vulnerability_management|monitoring_logging|policy_procedure');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `control_objective` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Objective');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `control_owner_role` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Owner Role');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `evidence_location` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Evidence Location');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Implementation Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `implementation_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Implementation Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `implementation_status` SET TAGS ('dbx_value_regex' = 'implemented|partially_implemented|not_implemented|compensating_control|not_applicable');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `last_tested_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Last Tested Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `monitoring_tool` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Monitoring Tool');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `next_test_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Next Test Due Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `policy_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Policy Reference');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `remediation_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Remediation Due Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `remediation_plan` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Remediation Plan');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `requirement_description` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry Data Security Standard (PCI-DSS) Requirement Description');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `requirement_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry Data Security Standard (PCI-DSS) Requirement Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `requirement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}.[0-9]{1,2}(.[0-9]{1,2})?$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Risk Rating');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `test_result` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Test Result');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `test_result` SET TAGS ('dbx_value_regex' = 'pass|fail|partial_pass|not_tested');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `testing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Testing Frequency');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `testing_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Control Testing Method');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `testing_method` SET TAGS ('dbx_value_regex' = 'observation|examination|interview|penetration_test|vulnerability_scan|automated_monitoring');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `third_party_dependency_flag` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Third-Party Dependency Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_control` ALTER COLUMN `third_party_provider_name` SET TAGS ('dbx_business_glossary_term' = 'Payment Card Industry (PCI) Third-Party Provider Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` SET TAGS ('dbx_subdomain' = 'privacy_protection');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Triggering Customer Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `assessment_outcome` SET TAGS ('dbx_value_regex' = 'approved|approved_with_conditions|rejected|requires_consultation');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `assessment_status` SET TAGS ('dbx_value_regex' = 'draft|in_review|dpo_review|completed|archived');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'PIA|DPIA|LIA');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `dpo_review_date` SET TAGS ('dbx_business_glossary_term' = 'Data Protection Officer (DPO) Review Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `dpo_reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Data Protection Officer (DPO) Reviewer Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `legal_basis` SET TAGS ('dbx_value_regex' = 'consent|contract|legal_obligation|vital_interests|public_task|legitimate_interests');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `residual_risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ALTER COLUMN `third_party_processors` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Processors');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `certification_id` SET TAGS ('dbx_business_glossary_term' = 'Certification Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `license_permit_id` SET TAGS ('dbx_business_glossary_term' = 'License Permit Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Filing Expiration Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `filing_date` SET TAGS ('dbx_business_glossary_term' = 'Filing Submission Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `filing_fee_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `filing_number` SET TAGS ('dbx_business_glossary_term' = 'Filing Reference Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Filing Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `responsible_party_email` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party Email Address');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `responsible_party_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ALTER COLUMN `responsible_party_phone` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party Phone Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `associated_entity_reference` SET TAGS ('dbx_business_glossary_term' = 'Associated Entity ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `associated_entity_type` SET TAGS ('dbx_value_regex' = 'store|banner|enterprise|distribution_center');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `fee_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `license_scope` SET TAGS ('dbx_value_regex' = 'enterprise|banner|location|department');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `license_status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|revoked|pending_renewal|pending_approval');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `renewal_frequency` SET TAGS ('dbx_value_regex' = 'annual|biennial|triennial|quinquennial|perpetual');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `renewal_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|submitted|approved|denied');
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ALTER COLUMN `responsible_party_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Facility ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Business Unit ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Manager ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `tertiary_certification_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `audit_frequency` SET TAGS ('dbx_value_regex' = 'annual|semi_annual|quarterly|biennial|triennial|on_demand');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|pending|withdrawn|in_renewal');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_value_regex' = 'ISO 22000 Food Safety|ISO 14001 Environmental|GFSI|SQF|BRC|Rainforest Alliance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `coverage_level` SET TAGS ('dbx_value_regex' = 'enterprise|division|facility|program|product_line');
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ALTER COLUMN `logo_url` SET TAGS ('dbx_business_glossary_term' = 'Certification Logo URL');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `containment_method` SET TAGS ('dbx_business_glossary_term' = 'Spill Containment Method');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `disposal_facility_epa_number` SET TAGS ('dbx_business_glossary_term' = 'Disposal Facility EPA (Environmental Protection Agency) ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `disposal_facility_epa_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[A-Z0-9]{9}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Waste Disposal Method');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `event_date` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `event_number` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `event_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `event_status` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `event_status` SET TAGS ('dbx_value_regex' = 'reported|under_review|remediation_in_progress|closed|pending_approval');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Type');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `hazmat_class` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Class');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `manifest_number` SET TAGS ('dbx_business_glossary_term' = 'Waste Manifest Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `manifest_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{9,12}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `material_type` SET TAGS ('dbx_business_glossary_term' = 'Environmental Material Type');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `penalty_assessed` SET TAGS ('dbx_business_glossary_term' = 'Penalty Assessed Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Material Quantity');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `regulation_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulation Reference Code');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `regulatory_reporting_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `report_confirmation_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `reported_date` SET TAGS ('dbx_business_glossary_term' = 'Event Reported Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `reporting_deadline` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Deadline');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `responsible_party_email` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party Email Address');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `responsible_party_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `waste_hauler_license_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ALTER COLUMN `waste_hauler_name` SET TAGS ('dbx_business_glossary_term' = 'Licensed Waste Hauler Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` SET TAGS ('dbx_subdomain' = 'training_workforce');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `completion_frequency` SET TAGS ('dbx_value_regex' = 'one_time|annual|biennial|triennial|quarterly|as_needed');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Training Duration Hours');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Training Program Effective Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Training Program Expiration Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `learning_management_system_code` SET TAGS ('dbx_business_glossary_term' = 'Learning Management System (LMS) ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `mandatory_flag` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Training Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Training Program Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `prerequisite_programs` SET TAGS ('dbx_business_glossary_term' = 'Prerequisite Training Programs');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Training Program Code');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Training Program Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_owner_name` SET TAGS ('dbx_business_glossary_term' = 'Training Program Owner Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_status` SET TAGS ('dbx_business_glossary_term' = 'Training Program Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_development|retired|suspended');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_type` SET TAGS ('dbx_business_glossary_term' = 'Training Program Type');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `program_type` SET TAGS ('dbx_value_regex' = 'regulatory_compliance|safety|security|privacy|ethics|operational');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `training_format` SET TAGS ('dbx_value_regex' = 'in_person|e_learning|virtual_instructor_led|on_the_job|blended|self_paced');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Training Program Version Number');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` SET TAGS ('dbx_subdomain' = 'training_workforce');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Associate ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `tertiary_training_waiver_approved_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved By ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `training_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `training_program_id` SET TAGS ('dbx_business_glossary_term' = 'Training Course ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'current|expiring_soon|expired|not_started|in_progress|overdue');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Training Cost Amount');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Training Delivery Method');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'online|in_person|virtual_instructor_led|self_paced|blended|on_the_job');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `mandatory_flag` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Training Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Completion Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ALTER COLUMN `pass_fail_result` SET TAGS ('dbx_value_regex' = 'pass|fail|waived|exempt');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `appeal_outcome` SET TAGS ('dbx_value_regex' = 'upheld|overturned|modified|pending|withdrawn');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `followup_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-up Inspection Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `followup_inspection_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-up Inspection Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `settlement_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|major|minor|warning');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `primary_policy_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Policy Owner ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `tertiary_policy_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `distribution_scope` SET TAGS ('dbx_value_regex' = 'all_employees|management_only|specific_roles|suppliers|contractors|public');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `document_url` SET TAGS ('dbx_business_glossary_term' = 'Policy Document URL');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `document_version` SET TAGS ('dbx_business_glossary_term' = 'Policy Document Version');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Policy Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `owner_role` SET TAGS ('dbx_business_glossary_term' = 'Policy Owner Role');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `policy_number` SET TAGS ('dbx_value_regex' = '^POL-[A-Z]{3}-[0-9]{6}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency (Months)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `training_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Training Frequency (Months)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Policy Version');
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Related Audit Finding ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `environmental_event_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Business Unit ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `osha_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Related Incident ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `tertiary_risk_identified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Identified By ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `violation_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Violation Notice Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `risk_register_description` SET TAGS ('dbx_business_glossary_term' = 'Risk Description');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `escalation_required` SET TAGS ('dbx_business_glossary_term' = 'Escalation Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Risk Notes');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `regulatory_reporting_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Required Flag');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annually|annually');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `risk_category` SET TAGS ('dbx_value_regex' = 'food_safety|workplace_safety|payment_security|data_privacy|environmental|labor_law');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `risk_number` SET TAGS ('dbx_value_regex' = '^RISK-[0-9]{6}$');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `risk_register_status` SET TAGS ('dbx_business_glossary_term' = 'Risk Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `risk_register_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|mitigated|accepted|closed');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `risk_response_type` SET TAGS ('dbx_value_regex' = 'mitigate|accept|transfer|avoid');
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Risk Title');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` SET TAGS ('dbx_subdomain' = 'audit_control');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `third_party_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Assessment ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `certification_id` SET TAGS ('dbx_business_glossary_term' = 'Certification Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assessor ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Third-Party ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `assessment_method` SET TAGS ('dbx_value_regex' = 'onsite_audit|remote_audit|document_review|questionnaire|certification_review|continuous_monitoring');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `assessment_report_url` SET TAGS ('dbx_business_glossary_term' = 'Assessment Report Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `assessment_result` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|partially_compliant|pending_review|not_assessed');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `contractual_obligations` SET TAGS ('dbx_business_glossary_term' = 'Contractual Compliance Obligations');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `data_access_level` SET TAGS ('dbx_value_regex' = 'cardholder_data|personal_data|confidential_business_data|public_data|no_data_access');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `data_processing_agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Agreement (DPA) Status');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `data_processing_agreement_status` SET TAGS ('dbx_value_regex' = 'executed|pending|expired|not_required|under_review');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `dpa_execution_date` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Agreement (DPA) Execution Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `dpa_expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Agreement (DPA) Expiration Date');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `remediation_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|overdue|verified');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'annual|semi_annual|quarterly|monthly|ad_hoc|continuous');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `third_party_name` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Name');
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ALTER COLUMN `third_party_type` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Type');
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_training_requirement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_training_requirement` SET TAGS ('dbx_subdomain' = 'training_workforce');
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_training_requirement` SET TAGS ('dbx_association_edges' = 'compliance.training_program,supplychain.dc_facility');
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` SET TAGS ('dbx_subdomain' = 'training_workforce');
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` SET TAGS ('dbx_association_edges' = 'compliance.compliance_program,supplychain.dc_facility');
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` ALTER COLUMN `facility_program_compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Compliance Certification - Compliance Program Id');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_checklist_template` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_checklist_template` SET TAGS ('dbx_subdomain' = 'audit_control');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_checklist_template` ALTER COLUMN `audit_checklist_template_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Checklist Template Identifier');
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_checklist_template` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`compliance`.`requirement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`requirement` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`requirement` ALTER COLUMN `requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Requirement Identifier');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_agency` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_agency` SET TAGS ('dbx_subdomain' = 'regulatory_governance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_agency` ALTER COLUMN `regulatory_agency_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Agency Identifier');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_agency` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_agency` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` SET TAGS ('dbx_subdomain' = 'privacy_compliance');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `consent_id` SET TAGS ('dbx_business_glossary_term' = 'Consent Identifier');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `consent_status` SET TAGS ('dbx_value_regex' = 'granted|withdrawn|pending|expired|revoked');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `double_opt_in_confirmed` SET TAGS ('dbx_business_glossary_term' = 'Double Opt-In Confirmed');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `double_opt_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Double Opt-In Timestamp');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `granularity` SET TAGS ('dbx_business_glossary_term' = 'Consent Granularity');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `granularity` SET TAGS ('dbx_value_regex' = 'global|channel_specific|purpose_specific|brand_specific');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `language` SET TAGS ('dbx_business_glossary_term' = 'Consent Language');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `legal_basis` SET TAGS ('dbx_value_regex' = 'consent|contract|legal_obligation|vital_interest|public_task|legitimate_interest');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'explicit_opt_in|implicit_opt_in|pre_checked_box|verbal|written_signature');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `proof_document_url` SET TAGS ('dbx_business_glossary_term' = 'Consent Proof Document URL');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Consent Version');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `consent_given_at` SET TAGS ('dbx_gdpr_relevant' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `consent_given_at` SET TAGS ('dbx_ccpa_relevant' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `consent_withdrawn_at` SET TAGS ('dbx_gdpr_relevant' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `consent_withdrawn_at` SET TAGS ('dbx_ccpa_relevant' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `purpose` SET TAGS ('dbx_gdpr_relevant' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `purpose` SET TAGS ('dbx_ccpa_relevant' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `channel` SET TAGS ('dbx_gdpr_relevant' = 'true');
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ALTER COLUMN `channel` SET TAGS ('dbx_ccpa_relevant' = 'true');
