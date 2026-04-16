-- Schema for Domain: hse | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:34

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`hse` COMMENT 'Manages Health, Safety, and Environment programs including incident reporting and tracking, safety audits, hazard assessments, OSHA/EPA compliance, chemical hazard management (REACH/RoHS), environmental permits, emissions monitoring, waste management, energy management (ISO 50001), and workplace safety across all facilities.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`incident` (
    `incident_id` BIGINT COMMENT 'Unique system-generated identifier for each workplace health, safety, or environmental incident record. Serves as the primary key and global reference across CAPA workflows, OSHA logs, and insurance reporting.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: HSE incidents involving customer personnel/property at manufacturing sites must track which customer account for liability, insurance claims, and contractual SLA reporting. Used daily by HSE and legal',
    `employee_id` BIGINT COMMENT 'Employee identification number of the person directly affected by the incident. Links to HR records for workers compensation, medical case management, and return-to-work tracking. Classified as restricted PII identifier.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Safety incidents involving specific products (equipment failure, chemical exposure) must track which product was involved for root cause analysis, product recalls, and liability management.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Incidents occur at specific cost centers (production lines, facilities). HSE tracks incident location for reporting and cost allocation. Used daily for incident reporting and financial impact analysis',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Incidents involving product/equipment failures use standardized defect codes for classification. Manufacturing plants use quality defect taxonomies to categorize safety incidents for trend analysis an',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Safety incidents frequently involve specific equipment. HSE teams must track which equipment was involved for root cause analysis, maintenance correlation, and regulatory reporting.',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: Safety incidents during field service work (equipment installation, maintenance) must be tracked back to the service order for liability, root cause analysis, and contractor safety management.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Incidents occur at specific plant locations. HSE tracks location for incident pattern analysis, area-specific safety measures, and emergency response planning.',
    `lab_resource_id` BIGINT COMMENT 'Foreign key linking to research.lab_resource. Business justification: Safety incidents in R&D labs are tracked against specific equipment or workstations. Incident reports reference the lab resource involved for root cause analysis and equipment safety reviews.',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Safety incidents occur during production order execution. HSE teams must track which production order was running when incident occurred for root cause analysis and production impact assessment.',
    `procurement_inbound_delivery_id` BIGINT COMMENT 'Foreign key linking to procurement.inbound_delivery. Business justification: Safety incidents often occur during material receiving (chemical spills, packaging failures, forklift accidents). HSE investigates incidents linked to specific deliveries for root cause analysis and s',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Safety incidents during order fulfillment (loading, packaging, shipping) must be traced to specific sales orders for liability, insurance claims, and root cause analysis in manufacturing operations.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Safety incidents must record exact warehouse location where they occurred for investigation, root cause analysis, and hazard mapping. HSE teams use this daily for incident reporting and location-based',
    `tooling_equipment_id` BIGINT COMMENT 'Foreign key linking to engineering.tooling_equipment. Business justification: Most manufacturing incidents involve tooling/equipment (presses, molds, fixtures). HSE teams must track which specific tooling was involved for investigation, maintenance correlation, and equipment-sp',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: Incidents happen at specific work centers. HSE tracks incident location by work center for safety pattern analysis, targeted interventions, and regulatory reporting by facility area.',
    `affected_person_name` STRING COMMENT 'Full name of the employee, contractor, or visitor directly affected by the incident. Required for OSHA 300/301 log entries, workers compensation claims, and insurance reporting. Classified as restricted PII.',
    `affected_person_type` STRING COMMENT 'Classification of the person affected by the incident. Determines applicable regulatory reporting requirements, insurance coverage, and workers compensation eligibility. Contractors and visitors may trigger different legal obligations.. Valid values are `employee|contractor|temporary_worker|visitor|customer|third_party|not_applicable`',
    `body_part_affected` STRING COMMENT 'Body part injured or affected in the incident. Required for OSHA 300 log and BLS OIICS coding. Used for ergonomic hazard analysis, PPE effectiveness assessment, and targeted safety training programs.. Valid values are `head|neck|eye|ear|back|shoulder|arm|hand|finger|leg|knee|foot|toe|trunk|multiple|not_applicable`',
    `capa_reference_number` STRING COMMENT 'Reference number of the associated Corrective and Preventive Action (CAPA) record initiated in response to this incident. Links the incident to its corrective action workflow for tracking resolution and recurrence prevention.',
    `chemical_name` STRING COMMENT 'Name of the chemical substance involved in the incident, if applicable (e.g., spill, exposure, release). Required for REACH/RoHS compliance reporting, EPA emergency release notifications, and SDS (Safety Data Sheet) cross-referencing.',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the incident record was formally closed following completion of investigation and all corrective and preventive actions (CAPA). Used for cycle time analytics and compliance reporting.',
    `contributing_factors` STRING COMMENT 'Narrative description of secondary or systemic factors that contributed to the incident occurring or worsening its severity. Supports multi-causal analysis and systemic CAPA development beyond the immediate cause.',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated incident cost. Supports multi-currency financial reporting across multinational operations (e.g., USD, EUR, GBP, CNY).. Valid values are `^[A-Z]{3}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the country where the incident occurred. Determines applicable regulatory framework (OSHA, EU-OSHA, local labor law) and reporting obligations for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `days_away_from_work` STRING COMMENT 'Number of calendar days the affected employee was away from work due to the incident. Key metric for OSHA 300 log, DART rate calculation, and workers compensation cost tracking. Zero for incidents without lost time.. Valid values are `^[0-9]+$`',
    `days_on_restricted_duty` STRING COMMENT 'Number of calendar days the affected employee was on job transfer or restricted work activity due to the incident. Required for OSHA 300 log and DART/DAFWII rate calculations. Zero if no restricted duty occurred.. Valid values are `^[0-9]+$`',
    `department` STRING COMMENT 'Organizational department or cost center where the incident occurred or where the affected employee is assigned. Used for departmental HSE performance tracking, resource allocation for corrective actions, and management reporting.',
    `description` STRING COMMENT 'Full narrative description of the incident event, including what happened, sequence of events, conditions at the time, and any immediate response actions taken. Core field for OSHA 301 form, insurance claims, and investigation reports.',
    `environmental_media_affected` STRING COMMENT 'Environmental media impacted by the incident (e.g., air release, water spill, soil contamination). Required for EPA regulatory reporting, ISO 14001 environmental impact assessment, and environmental permit compliance tracking.. Valid values are `air|water|soil|groundwater|multiple|none|unknown`',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Estimated total financial cost of the incident including medical expenses, property damage, lost productivity, investigation costs, and regulatory fines. Used for insurance reporting, CAPEX/OPEX impact analysis, and ROI justification for safety investments.',
    `facility_code` STRING COMMENT 'Alphanumeric code identifying the manufacturing facility or plant where the incident occurred. Used for site-level HSE performance reporting, regulatory jurisdiction determination, and multi-site benchmarking.',
    `first_aid_provided` BOOLEAN COMMENT 'Indicates whether first aid treatment was administered at the scene of the incident. Used in OSHA recordability determination — incidents requiring only first aid are generally not OSHA recordable per 29 CFR 1904.7.. Valid values are `true|false`',
    `hazard_category` STRING COMMENT 'Primary hazard category associated with the incident. Used for hazard trend analysis, risk register updates, and targeted safety program development. Aligns with OSHA hazard classification and REACH/RoHS chemical hazard frameworks.. Valid values are `chemical|biological|physical|ergonomic|electrical|mechanical|thermal|radiation|psychosocial|environmental|fire_explosion|other`',
    `immediate_cause` STRING COMMENT 'Narrative description of the direct, proximate cause of the incident — the specific act, condition, or failure that immediately preceded the event. Captured during initial investigation and refined through root cause analysis.',
    `injury_nature` STRING COMMENT 'Nature or type of physical injury or illness sustained by the affected person. Required for OSHA 300 log classification, workers compensation coding, and injury trend analysis. Null for non-injury incident types.. Valid values are `laceration|fracture|burn|strain_sprain|contusion|amputation|chemical_exposure|inhalation|electric_shock|eye_injury|hearing_loss|repetitive_stress|fatality|illness|no_injury|other`',
    `investigation_completion_date` DATE COMMENT 'Date on which the formal incident investigation was completed and the investigation report was finalized. Used to measure investigation cycle time compliance against internal SLA targets and ISO 45001 requirements.',
    `investigation_lead` STRING COMMENT 'Name or employee ID of the HSE professional or manager assigned as lead investigator for the incident. Accountable for completing the root cause analysis, investigation report, and CAPA initiation within required timeframes.',
    `is_epa_reportable` BOOLEAN COMMENT 'Indicates whether the incident triggers EPA mandatory reporting obligations under CERCLA, EPCRA, or Clean Water Act (e.g., release of a reportable quantity of a hazardous substance). Drives regulatory notification workflow.. Valid values are `true|false`',
    `is_osha_recordable` BOOLEAN COMMENT 'Indicates whether the incident meets OSHA criteria for recordability on the OSHA 300 log. Determined by whether the incident resulted in days away from work, restricted duty, medical treatment beyond first aid, loss of consciousness, or diagnosis of a significant injury/illness.. Valid values are `true|false`',
    `is_osha_reportable` BOOLEAN COMMENT 'Indicates whether the incident must be reported directly to OSHA within mandated timeframes (fatality within 8 hours; inpatient hospitalization, amputation, or eye loss within 24 hours). Distinct from recordability.. Valid values are `true|false`',
    `medical_treatment_required` BOOLEAN COMMENT 'Indicates whether the incident required medical treatment beyond first aid (e.g., physician visit, prescription medication, sutures). A key criterion for OSHA recordability determination under 29 CFR 1904.7.. Valid values are `true|false`',
    `number` STRING COMMENT 'Human-readable, business-facing reference number assigned to the incident at the time of reporting. Used in OSHA 300/301 logs, insurance claims, and CAPA tracking. Format: INC-YYYY-NNNNNN.. Valid values are `^INC-[0-9]{4}-[0-9]{6}$`',
    `occurred_timestamp` TIMESTAMP COMMENT 'Actual date and time when the incident event occurred on the shop floor or facility. Distinct from reported timestamp; used for root cause timeline analysis, shift correlation, and regulatory log entries.',
    `regulatory_notification_deadline` TIMESTAMP COMMENT 'Calculated deadline by which regulatory authorities must be notified of the incident (e.g., OSHA 8-hour fatality reporting, EPA 24-hour release notification). Used to trigger escalation alerts and ensure compliance with mandatory reporting windows.',
    `regulatory_notification_timestamp` TIMESTAMP COMMENT 'Actual date and time when the regulatory authority was notified of the incident. Used to verify compliance with mandatory notification deadlines and document the notification event for audit purposes.',
    `reported_timestamp` TIMESTAMP COMMENT 'Date and time when the incident was formally reported into the HSE system. Used to measure reporting timeliness compliance and trigger regulatory notification windows (e.g., OSHA 8-hour fatality reporting requirement).',
    `root_cause_category` STRING COMMENT 'Primary root cause category identified through incident investigation. Drives CAPA workflow type, systemic corrective action prioritization, and safety program improvement initiatives. Aligned with PFMEA and CAPA methodologies.. Valid values are `unsafe_act|unsafe_condition|equipment_failure|procedural_non_compliance|inadequate_training|design_deficiency|environmental_factor|management_system_failure|human_error|unknown|pending_investigation`',
    `severity` STRING COMMENT 'Severity classification of the incident based on actual or potential consequences to personnel, environment, or assets. Drives escalation protocols, regulatory notification timelines, and insurance reporting thresholds.. Valid values are `critical|major|moderate|minor|negligible`',
    `shift` STRING COMMENT 'Work shift during which the incident occurred. Used for shift-based trend analysis to identify patterns in incident frequency, fatigue-related incidents, and supervision gaps across shift schedules.. Valid values are `day|afternoon|night|weekend|rotating|not_applicable`',
    `source_system` STRING COMMENT 'Operational system of record from which the incident data originated (e.g., SAP S/4HANA QM, Siemens Opcenter MES, Maximo EAM). Supports data lineage tracking, reconciliation, and silver layer provenance in the Databricks lakehouse.. Valid values are `sap_s4hana|siemens_opcenter_mes|maximo_eam|salesforce_crm|manual_entry|other`',
    `status` STRING COMMENT 'Current lifecycle status of the incident record. Tracks progression from initial report through investigation, corrective action, and formal closure. Drives workflow routing in the HSE management system.. Valid values are `reported|under_investigation|capa_in_progress|pending_closure|closed|voided`',
    `type` STRING COMMENT 'Classification of the incident by its primary nature. Drives regulatory reporting obligations, CAPA workflow routing, and OSHA recordability determination. Aligned with OSHA and EPA incident taxonomy.. Valid values are `injury|illness|near_miss|property_damage|environmental_spill|fire|explosion|chemical_release|equipment_failure|security|utility_disruption|other`',
    CONSTRAINT pk_incident PRIMARY KEY(`incident_id`)
) COMMENT 'Master record for all workplace health, safety, and environmental incidents reported across manufacturing facilities. Captures incident type (injury, near-miss, spill, fire, equipment failure), severity classification, OSHA recordability status, affected personnel, location, root cause category, and regulatory reporting obligations. Serves as the SSOT for all HSE incident events and drives CAPA workflows, OSHA 300/301 log entries, and insurance reporting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`incident_investigation` (
    `incident_investigation_id` BIGINT COMMENT 'Unique system-generated identifier for each incident investigation record in the HSE management system.',
    `capa_record_id` BIGINT COMMENT 'Foreign key linking to compliance.capa_record. Business justification: Investigation findings require formal CAPA records for root cause remediation. Quality and safety teams track investigation-to-CAPA linkage for audit trails and effectiveness verification.',
    `incident_id` BIGINT COMMENT 'Foreign key linking to hse.incident. Business justification: incident_investigation is a child record of incident — every investigation belongs to exactly one incident. incident_reference_number is a denormalized string reference that should be replaced with a ',
    `employee_id` BIGINT COMMENT 'Employee identifier of the lead investigator, used for system linkage to workforce records and investigation accountability tracking.',
    `actual_completion_date` DATE COMMENT 'Actual date on which the investigation was completed and all findings documented. Used to measure investigation cycle time and SLA adherence.',
    `approval_date` DATE COMMENT 'Date on which the investigation findings and corrective action recommendations were formally approved by the responsible authority.',
    `approved_by_name` STRING COMMENT 'Name of the manager or HSE authority who formally approved and closed the investigation findings. Required for regulatory accountability and audit trail.',
    `capa_initiated` BOOLEAN COMMENT 'Indicates whether a formal CAPA record has been initiated in the quality management system as a result of this investigation. Supports ISO 45001 and ISO 9001 nonconformity management tracking.. Valid values are `true|false`',
    `capa_reference_number` STRING COMMENT 'Reference number of the associated CAPA record in the quality management system, enabling traceability between investigation findings and corrective action execution.',
    `closure_date` DATE COMMENT 'Date on which the investigation was formally closed following approval of findings and initiation of corrective actions. Required for ISO 45001 nonconformity closure records.',
    `contributing_factors` STRING COMMENT 'Documented factors that contributed to the incident but were not the direct cause, such as environmental conditions, equipment state, or procedural gaps. Supports systemic analysis.',
    `corrective_action_summary` STRING COMMENT 'Summary of recommended corrective and preventive actions identified during the investigation. Detailed CAPA records are managed in the CAPA system; this field captures the investigation-level recommendation.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the investigation record was first created in the HSE management system. Supports audit trail and data lineage requirements.',
    `department_code` STRING COMMENT 'Organizational department or cost center code where the incident occurred, used for departmental safety performance tracking and resource allocation.',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or site where the incident under investigation occurred. Enables facility-level safety performance reporting.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the incident occurred, supporting multi-national regulatory compliance and jurisdictional reporting.. Valid values are `^[A-Z]{3}$`',
    `immediate_cause` STRING COMMENT 'Direct, observable cause of the incident (unsafe act or unsafe condition) identified during investigation. Represents the last event in the causal chain before the incident.',
    `incident_date` DATE COMMENT 'Calendar date on which the originating incident occurred, used for regulatory reporting timelines and trend analysis.',
    `investigation_findings` STRING COMMENT 'Comprehensive narrative of all findings from the investigation, including evidence gathered, witness statements summary, and analytical conclusions. Core documentation for regulatory compliance.',
    `investigation_number` STRING COMMENT 'Human-readable business reference number for the investigation, used for cross-referencing with OSHA logs, CAPA records, and regulatory submissions.. Valid values are `^INV-[0-9]{4}-[0-9]{6}$`',
    `investigation_start_date` DATE COMMENT 'Date on which the formal investigation was initiated. Used to measure investigation response time and compliance with regulatory investigation timelines.',
    `investigation_team_members` STRING COMMENT 'Comma-separated list of employee IDs or names of all team members participating in the investigation, supporting multi-disciplinary team composition documentation.',
    `investigation_type` STRING COMMENT 'Classification of the investigation type based on the nature of the originating event, used for regulatory categorization and trend analysis.. Valid values are `incident|near_miss|hazard_observation|occupational_illness|environmental_release|property_damage|process_safety|security`',
    `iso_45001_nonconformity_type` STRING COMMENT 'Classification of the investigation finding against ISO 45001 nonconformity categories, supporting the occupational health and safety management system audit and certification process.. Valid values are `nonconformity|potential_nonconformity|observation|opportunity_for_improvement`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the investigation record. Supports change tracking, audit trail, and data governance requirements.',
    `lead_investigator_name` STRING COMMENT 'Full name of the primary investigator responsible for conducting and managing the investigation. Required for accountability and regulatory documentation.',
    `lessons_learned` STRING COMMENT 'Documented lessons learned from the investigation intended for sharing across facilities and departments to prevent recurrence. Supports organizational learning and safety culture improvement.',
    `osha_recordable` BOOLEAN COMMENT 'Indicates whether the incident meets OSHA recordability criteria under 29 CFR 1904, requiring entry in the OSHA 300 Log. Critical for regulatory compliance and annual OSHA 300A summary reporting.. Valid values are `true|false`',
    `osha_reportable` BOOLEAN COMMENT 'Indicates whether the incident requires mandatory reporting to OSHA within prescribed timeframes (e.g., fatality within 8 hours, hospitalization/amputation/eye loss within 24 hours).. Valid values are `true|false`',
    `rca_methodology` STRING COMMENT 'Root Cause Analysis methodology applied during the investigation (e.g., 5-Why, Fishbone/Ishikawa, Fault Tree Analysis). Standardizes analytical approach for benchmarking and audit purposes.. Valid values are `5_why|fishbone_ishikawa|fault_tree_analysis|bow_tie|taproot|apollo|combination|other`',
    `recurrence_prevention_measures` STRING COMMENT 'Specific preventive measures identified to eliminate or reduce the likelihood of recurrence, distinct from corrective actions. Supports proactive risk management under ISO 45001.',
    `regulatory_notification_date` DATE COMMENT 'Date on which the required regulatory notification was submitted to the relevant authority. Used to verify compliance with mandatory reporting deadlines.',
    `regulatory_notification_required` BOOLEAN COMMENT 'Indicates whether notification to any regulatory authority (OSHA, EPA, local environmental agency, or EU competent authority) is required for this incident, beyond standard OSHA recordability.. Valid values are `true|false`',
    `root_cause_category` STRING COMMENT 'Standardized category classification of the root cause, enabling trend analysis across incidents and identification of systemic weaknesses in the management system.. Valid values are `human_factors|equipment_failure|process_procedure|environmental|management_system|training_competency|design_engineering|maintenance|material|organizational|other`',
    `root_cause_description` STRING COMMENT 'Detailed narrative of the fundamental systemic root cause(s) identified through the RCA process. Forms the basis for corrective action recommendations and CAPA initiation.',
    `severity_level` STRING COMMENT 'Severity classification of the incident under investigation, determining investigation depth, escalation requirements, and regulatory notification obligations.. Valid values are `critical|major|moderate|minor|low`',
    `status` STRING COMMENT 'Current lifecycle status of the investigation, tracking progression from initiation through closure. Drives workflow routing and compliance reporting.. Valid values are `draft|open|in_progress|pending_review|pending_approval|closed|cancelled`',
    `systemic_cause` STRING COMMENT 'Underlying organizational or management system deficiency that allowed the immediate and root causes to exist, such as inadequate procedures, training gaps, or supervision failures.',
    `target_completion_date` DATE COMMENT 'Planned date by which the investigation must be completed, including root cause analysis and corrective action recommendations. Drives SLA compliance tracking.',
    `title` STRING COMMENT 'Concise descriptive title summarizing the nature and scope of the investigation for reporting and search purposes.',
    `work_area` STRING COMMENT 'Specific work area, production line, or functional location within the facility where the incident occurred (e.g., Assembly Line 3, Warehouse Bay B, CNC Cell 7).',
    CONSTRAINT pk_incident_investigation PRIMARY KEY(`incident_investigation_id`)
) COMMENT 'Structured investigation records linked to reported HSE incidents. Captures investigation team composition, root cause analysis methodology (5-Why, Fishbone/Ishikawa), contributing factors, immediate causes, systemic causes, investigation findings, corrective action recommendations, and investigation closure status. Supports OSHA compliance, ISO 45001 nonconformity management, and CAPA initiation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`hse_capa` (
    `hse_capa_id` BIGINT COMMENT 'Unique system-generated identifier for each Corrective and Preventive Action (CAPA) record within the HSE management system.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the individual assigned as the CAPA owner, used for workforce system integration (Kronos), accountability tracking, and escalation workflows.',
    `eco_id` BIGINT COMMENT 'Foreign key linking to engineering.eco. Business justification: HSE corrective actions from incidents/audits often require engineering changes (design modifications, material substitutions). CAPA systems link to ECOs to track implementation of engineering-based co',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Corrective actions often require capital expenditure tracked via internal orders. Finance uses this to track HSE improvement project costs and budget consumption.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: HSE CAPAs often originate from quality non-conformances that have safety implications (material defects causing hazards, process failures affecting environmental controls). Safety teams track source N',
    `report_id` BIGINT COMMENT 'Foreign key linking to service.service_report. Business justification: Service reports identifying safety issues (equipment defects, unsafe conditions) trigger corrective and preventive actions. CAPA tracks remediation linked to originating service report.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: CAPA corrective actions often require maintenance work orders (install guards, repair interlocks). Links CAPA to work order for action completion tracking and effectiveness verification.',
    `action_description` STRING COMMENT 'Detailed description of the corrective or preventive actions to be implemented, including specific steps, controls, and process changes required to eliminate the root cause and prevent recurrence.',
    `applicable_standard` STRING COMMENT 'Primary regulatory or management system standard under which this CAPA is raised, enabling standard-specific compliance reporting and audit trail management.. Valid values are `ISO_45001|ISO_14001|ISO_9001|ISO_50001|OSHA|EPA|REACH|RoHS|CE_marking|IEC_62443|NIST_CSF|other`',
    `approval_date` DATE COMMENT 'Date on which the CAPA action plan was formally approved by the designated authority, establishing the official start of the implementation timeline.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Name of the manager or HSE authority who formally approved the CAPA action plan, providing the authorization record required for ISO 45001 and ISO 14001 audit trails.',
    `assigned_department` STRING COMMENT 'Organizational department or business unit responsible for implementing the CAPA, used for departmental performance reporting and resource allocation.',
    `assigned_owner_name` STRING COMMENT 'Full name of the individual responsible for implementing and completing the CAPA actions within the defined due date. This person is accountable for action execution and closure.',
    `closure_date` DATE COMMENT 'Date on which the CAPA was formally closed following successful verification of effectiveness, signifying completion of the full CAPA lifecycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `closure_notes` STRING COMMENT 'Narrative summary recorded at CAPA closure, documenting the final outcome, lessons learned, and confirmation that the nonconformity has been resolved and actions are sustained.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility or jurisdiction where the CAPA applies, supporting multinational regulatory compliance reporting and regional HSE governance.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the nonconformity, hazard, or observation that triggered the CAPA, including context, scope, and initial findings.',
    `due_date` DATE COMMENT 'Target date by which all corrective or preventive actions must be fully implemented and ready for verification. Used for overdue tracking, escalation, and regulatory compliance monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effectiveness_review_date` DATE COMMENT 'Scheduled or actual date for the follow-up effectiveness review to confirm sustained improvement after CAPA closure, typically conducted 30-90 days post-implementation per ISO 45001 and ISO 14001.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effectiveness_review_outcome` STRING COMMENT 'Result of the post-closure effectiveness review, confirming whether the corrective or preventive action has been sustained over time or whether recurrence has been observed requiring a new CAPA.. Valid values are `sustained|recurrence_observed|inconclusive|pending`',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or plant where the CAPA originates, enabling multi-site performance benchmarking and regulatory reporting by location.',
    `hse_domain_category` STRING COMMENT 'HSE domain classification for the CAPA, indicating whether it relates to occupational health, occupational safety, environmental compliance, process safety, chemical hazard management, or energy management (ISO 50001).. Valid values are `occupational_health|occupational_safety|environmental|process_safety|chemical_hazard|fire_safety|ergonomics|radiation|noise|energy_management`',
    `immediate_containment_action` STRING COMMENT 'Short-term containment or interim corrective action taken immediately after the nonconformity or incident was identified to prevent further harm, damage, or regulatory exposure before the permanent corrective action is implemented.',
    `implementation_date` DATE COMMENT 'Actual date on which all corrective or preventive actions were fully implemented, used to measure on-time completion performance and calculate implementation cycle time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `initiation_date` DATE COMMENT 'Date on which the CAPA was formally initiated and entered into the management system, establishing the start of the CAPA lifecycle clock for compliance and SLA tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Human-readable business reference number for the CAPA record, used for cross-referencing in audits, reports, and regulatory submissions. Format: CAPA-YYYY-NNNNNN.. Valid values are `^CAPA-[0-9]{4}-[0-9]{6}$`',
    `originating_reference_number` STRING COMMENT 'Business reference number of the originating event (e.g., incident report number, audit finding ID, NCR number, regulatory observation reference) that triggered this CAPA.',
    `originating_source_type` STRING COMMENT 'Categorizes the type of event or process that triggered the CAPA, such as an HSE incident, safety audit finding, hazard assessment, regulatory inspection observation, or Non-Conformance Report (NCR).. Valid values are `hse_incident|safety_audit|hazard_assessment|regulatory_inspection|environmental_monitoring|internal_audit|customer_complaint|management_review|near_miss|ncr`',
    `priority` STRING COMMENT 'Business priority level assigned to the CAPA based on risk severity, regulatory obligation, or potential impact to health, safety, or environment. Drives escalation and resource allocation.. Valid values are `critical|high|medium|low`',
    `recurrence_flag` BOOLEAN COMMENT 'Indicates whether this CAPA was raised due to recurrence of a previously closed nonconformity or incident, used to identify systemic failures and evaluate the effectiveness of prior corrective actions.. Valid values are `true|false`',
    `regulatory_obligation_flag` BOOLEAN COMMENT 'Indicates whether this CAPA is required by a regulatory body (e.g., OSHA, EPA, ISO certification body) or is internally driven. Regulatory CAPAs may have mandatory reporting and closure timelines.. Valid values are `true|false`',
    `regulatory_reference` STRING COMMENT 'Specific regulatory standard, clause, or citation that this CAPA addresses (e.g., OSHA 29 CFR 1910.147, EPA 40 CFR Part 68, ISO 45001 Clause 10.2, REACH Article 31). Required for regulatory audit trails.',
    `related_capa_number` STRING COMMENT 'Reference to a prior or related CAPA record, used to track recurrence, link systemic issues, or associate parent-child CAPA relationships for trend analysis.. Valid values are `^CAPA-[0-9]{4}-[0-9]{6}$`',
    `revised_due_date` DATE COMMENT 'Updated target completion date if the original due date was extended due to resource constraints, scope changes, or regulatory negotiations. Requires documented justification.. Valid values are `^d{4}-d{2}-d{2}$`',
    `risk_level` STRING COMMENT 'Risk classification assigned to the CAPA based on the severity and likelihood of the underlying nonconformity or hazard, used to prioritize corrective actions and allocate resources.. Valid values are `critical|high|medium|low|negligible`',
    `root_cause_analysis_method` STRING COMMENT 'Structured methodology applied to identify the root cause of the nonconformity, such as 5-Why, Fishbone (Ishikawa), Failure Mode and Effects Analysis (FMEA), Fault Tree Analysis, or 8D.. Valid values are `five_why|fishbone|fmea|fault_tree|8d|pareto|brainstorming|other|not_applicable`',
    `root_cause_category` STRING COMMENT 'High-level categorization of the identified root cause of the nonconformity or hazard, used for trend analysis and systemic improvement programs.. Valid values are `human_error|process_failure|equipment_failure|material_defect|environmental_condition|management_system_gap|training_deficiency|design_deficiency|supplier_failure|unknown`',
    `root_cause_description` STRING COMMENT 'Detailed narrative of the root cause analysis findings, including methodology used (e.g., 5-Why, Fishbone/Ishikawa, FMEA) and the identified underlying cause(s) of the nonconformity.',
    `source_system` STRING COMMENT 'Operational system of record from which the CAPA was originated or imported (e.g., SAP S/4HANA QM module, Siemens Opcenter MES, Maximo EAM), supporting data lineage and integration traceability in the Databricks Silver layer.. Valid values are `sap_s4hana_qm|siemens_opcenter_mes|maximo_eam|salesforce_service|manual|other`',
    `status` STRING COMMENT 'Current lifecycle status of the CAPA record, tracking progression from initiation through verification and formal closure per ISO 45001 and ISO 14001 requirements.. Valid values are `draft|open|in_progress|pending_verification|verified|closed|cancelled|overdue`',
    `title` STRING COMMENT 'Short, descriptive title summarizing the CAPA, used for quick identification in dashboards, reports, and audit trails.',
    `type` STRING COMMENT 'Classifies the action as corrective (addressing an existing nonconformity or incident), preventive (eliminating the cause of a potential nonconformity), or improvement (proactive enhancement not tied to a specific nonconformity).. Valid values are `corrective|preventive|improvement`',
    `verification_date` DATE COMMENT 'Date on which the verification activity was conducted to confirm that the implemented actions are effective and the nonconformity has been resolved.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verification_method` STRING COMMENT 'Method used to verify that the implemented corrective or preventive actions are effective and that the root cause has been eliminated, as required by ISO 45001 and ISO 14001.. Valid values are `audit|inspection|testing|document_review|observation|measurement|management_review|third_party_review|other`',
    `verification_result` STRING COMMENT 'Outcome of the effectiveness verification activity, indicating whether the implemented CAPA actions successfully eliminated the root cause and prevented recurrence.. Valid values are `effective|partially_effective|not_effective|pending`',
    CONSTRAINT pk_hse_capa PRIMARY KEY(`hse_capa_id`)
) COMMENT 'Corrective and Preventive Action records generated from HSE incidents, audit findings, hazard assessments, and regulatory observations. Captures CAPA type (corrective/preventive), originating event reference, assigned owner, due date, action description, verification method, effectiveness review date, and closure status. Tracks the full CAPA lifecycle from initiation through verification and closure per ISO 45001 and ISO 14001 requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` (
    `hazard_assessment_id` BIGINT COMMENT 'Unique system-generated identifier for each hazard assessment record within the manufacturing HSE management system.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Hazard assessments evaluate risks associated with specific products during manufacturing, handling, or use. Required for product launch approvals and workplace risk management.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: When a hazard assessment involves a chemical hazard, it references a specific chemical substance. chemical_substance_name and cas_number in hazard_assessment are denormalized copies of master data hel',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Hazard assessments evaluate risks associated with specific equipment. Required for LOTO procedures, risk registers, and equipment-specific safety protocols before maintenance work.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Hazard assessments cover specific plant areas/locations. Used for area-specific JSAs, confined space entry permits, and location-based risk mitigation strategies.',
    `line_id` BIGINT COMMENT 'Foreign key linking to production.production_line. Business justification: Production lines require hazard assessments before startup or after modifications. HSE evaluates line-specific risks including machinery, ergonomics, and process hazards for worker protection.',
    `order_configuration_id` BIGINT COMMENT 'Foreign key linking to order.order_configuration. Business justification: Custom product configurations (special machinery, automation systems) require hazard assessments before production approval. Engineering teams assess risks specific to configured equipment specificati',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Hazard assessments are conducted at specific storage locations to identify risks related to material handling, stacking heights, and equipment operation. Safety teams perform location-based risk asses',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: Hazard assessments are conducted for specific work centers. HSE must evaluate risks at each production location to ensure worker safety and regulatory compliance before operations begin.',
    `additional_controls_required` STRING COMMENT 'Description of recommended additional control measures needed to further reduce residual risk to an acceptable level, including engineering improvements, procedural changes, or PPE upgrades.',
    `affected_personnel_groups` STRING COMMENT 'Description of the worker groups, roles, or populations exposed to the identified hazard (e.g., Machine Operators, Maintenance Technicians, Contractors, Visitors, Warehouse Staff).',
    `approval_date` DATE COMMENT 'Date on which the hazard assessment was formally reviewed and approved by the authorized approver.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `approved_by` STRING COMMENT 'Name of the manager, HSE director, or authorized person who formally approved the hazard assessment and its associated control measures.',
    `assessment_date` DATE COMMENT 'The date on which the hazard assessment was formally conducted or last performed.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `assessment_number` STRING COMMENT 'Human-readable business reference number for the hazard assessment, used for cross-referencing in safety documentation, audits, and regulatory submissions.. Valid values are `^HA-[A-Z]{2,6}-[0-9]{4}-[0-9]{5}$`',
    `assessment_type` STRING COMMENT 'The formal methodology used to conduct the hazard assessment. HAZOP (Hazard and Operability Study), JSA (Job Safety Analysis), PFMEA (Process Failure Mode and Effects Analysis), FMEA (Failure Mode and Effects Analysis), LOPA (Layers of Protection Analysis), PHA (Process Hazard Analysis), etc.. Valid values are `HAZOP|FMEA|JSA|PFMEA|DFMEA|What-If|Checklist|Bow-Tie|LOPA|PHA|Other`',
    `assessor_name` STRING COMMENT 'Full name of the qualified HSE professional or engineer who led the hazard assessment. Required for accountability and regulatory audit trail.',
    `assessor_qualification` STRING COMMENT 'Professional qualification, certification, or competency level of the lead assessor (e.g., Certified Safety Professional (CSP), NEBOSH, Six Sigma Black Belt, Process Safety Engineer).',
    `capa_reference` STRING COMMENT 'Reference number of the associated CAPA record in the quality or HSE management system, linking the hazard assessment to formal corrective and preventive action tracking.',
    `change_reason` STRING COMMENT 'Explanation for why this version of the hazard assessment was created or revised (e.g., process change, incident investigation finding, regulatory update, periodic review, ECN-triggered review).',
    `control_hierarchy_level` STRING COMMENT 'The highest level of the OSHA/NIOSH Hierarchy of Controls applied to the existing primary control measure (Elimination being most effective, PPE being least effective).. Valid values are `Elimination|Substitution|Engineering Control|Administrative Control|PPE`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, context, and objectives of the hazard assessment including the work environment and conditions evaluated.',
    `existing_controls` STRING COMMENT 'Narrative description of the current control measures already in place to mitigate the identified hazard (e.g., machine guarding, PPE requirements, SOP, interlocks, ventilation systems).',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the hazard assessment applies, supporting multinational regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `facility_name` STRING COMMENT 'Name of the manufacturing facility or plant where the hazard assessment was conducted.',
    `hazard_category` STRING COMMENT 'Primary classification of the hazard type identified in the assessment, used for aggregation, trending, and targeted control program management.. Valid values are `Physical|Chemical|Biological|Ergonomic|Psychosocial|Electrical|Mechanical|Thermal|Radiation|Environmental|Fire|Explosion|Other`',
    `hazard_subcategory` STRING COMMENT 'More granular classification of the hazard within its primary category (e.g., under Chemical: Flammable, Toxic, Corrosive; under Mechanical: Caught-in, Struck-by, Pinch Point).',
    `inherent_risk_level` STRING COMMENT 'Qualitative risk band derived from the inherent risk score (e.g., Critical: 20–25, High: 12–19, Medium: 6–11, Low: 1–5). Used for management escalation and reporting.. Valid values are `Critical|High|Medium|Low|Negligible`',
    `inherent_risk_score` STRING COMMENT 'Pre-control risk score calculated as Likelihood × Severity, representing the raw risk level before any controls are applied. Drives prioritization of control measures.. Valid values are `^([1-9]|[1-2][0-9]|25)$`',
    `likelihood_rating` STRING COMMENT 'Numerical score (1–5) representing the probability or frequency of the hazard occurring or causing harm. Used as a factor in the risk matrix calculation (Risk = Likelihood × Severity).. Valid values are `^[1-5]$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review or reassessment of this hazard assessment, based on the defined review frequency or triggered by a change in process, incident, or regulation.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `pfmea_reference` STRING COMMENT 'Reference number or identifier linking this hazard assessment to the corresponding PFMEA document in the quality management system, enabling traceability between safety and quality risk analyses.',
    `process_name` STRING COMMENT 'Name of the manufacturing process or production operation associated with the hazard (e.g., CNC Machining, Welding, Chemical Mixing, Assembly Line Operation).',
    `regulatory_requirement` STRING COMMENT 'Specific regulatory standard, law, or compliance obligation that this hazard assessment addresses (e.g., OSHA PSM 29 CFR 1910.119, EPA RMP, EU Machinery Directive, ISO 45001).',
    `residual_likelihood_rating` STRING COMMENT 'Revised likelihood score (1–5) after existing controls are applied, reflecting the remaining probability of harm occurring.. Valid values are `^[1-5]$`',
    `residual_risk_level` STRING COMMENT 'Qualitative risk band for the residual risk score after controls are applied. Determines whether additional controls are required or if the risk is acceptable.. Valid values are `Critical|High|Medium|Low|Negligible`',
    `residual_risk_score` STRING COMMENT 'Post-control risk score (Residual Likelihood × Residual Severity) representing the remaining risk level after existing controls are considered. Determines acceptability of the risk.. Valid values are `^([1-9]|[1-2][0-9]|25)$`',
    `residual_severity_rating` STRING COMMENT 'Revised severity score (1–5) after existing controls are applied, reflecting the remaining magnitude of potential harm.. Valid values are `^[1-5]$`',
    `review_frequency` STRING COMMENT 'Defined frequency at which this hazard assessment must be reviewed and updated to ensure continued relevance and effectiveness of controls.. Valid values are `Monthly|Quarterly|Semi-Annual|Annual|Biennial|Event-Triggered|As-Required`',
    `risk_acceptable` BOOLEAN COMMENT 'Indicates whether the residual risk level has been formally determined to be acceptable per the organizations risk acceptance criteria, or whether additional controls are required.. Valid values are `true|false`',
    `severity_rating` STRING COMMENT 'Numerical score (1–5) representing the potential magnitude of harm or consequence if the hazard event occurs (e.g., 1=Minor First Aid, 5=Fatality/Catastrophic).. Valid values are `^[1-5]$`',
    `status` STRING COMMENT 'Current lifecycle status of the hazard assessment record, from initial drafting through approval, active use, and eventual supersession or archival.. Valid values are `Draft|Under Review|Approved|Active|Superseded|Archived|Cancelled`',
    `title` STRING COMMENT 'Short descriptive title summarizing the hazard assessment scope, such as the work area, process, or activity being assessed.',
    `version_number` STRING COMMENT 'Version identifier of the hazard assessment document, incremented each time the assessment is revised and re-approved (e.g., 1.0, 1.1, 2.0).. Valid values are `^[0-9]+.[0-9]+$`',
    `work_activity` STRING COMMENT 'The specific work task, job step, or operational activity during which the hazard is present or could be triggered (e.g., machine changeover, chemical handling, overhead lifting).',
    `work_area` STRING COMMENT 'Specific work area, zone, department, or shop floor location within the facility where the hazard exists (e.g., Press Shop Bay 3, Chemical Storage Room B, Assembly Line 7).',
    CONSTRAINT pk_hazard_assessment PRIMARY KEY(`hazard_assessment_id`)
) COMMENT 'Formal hazard identification and risk assessment records for manufacturing operations, processes, and work areas. Captures hazard type, associated work activity or process, risk rating (likelihood × severity), existing controls, residual risk level, PFMEA linkage, assessment methodology (HAZOP, FMEA, JSA), assessor identity, review frequency, and approval status. Supports ISO 45001 risk-based thinking and OSHA PSM compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`safety_audit` (
    `safety_audit_id` BIGINT COMMENT 'Unique system-generated identifier for each safety audit or inspection record within the HSE management system.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Manufacturing companies conduct safety audits at customer sites for installed equipment, supplier facilities for quality assurance, or partner locations. Audit results tied to customer accounts for co',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Safety audits are conducted at specific plant locations/areas. Essential for location-based compliance tracking, area safety performance metrics, and audit scheduling.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Safety audits are conducted at production plant level. HSE performs regular facility-wide audits to verify compliance with safety standards and identify systemic risks across operations.',
    `actual_end_date` DATE COMMENT 'The actual date on which the safety audit was completed and all field activities concluded.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_start_date` DATE COMMENT 'The actual date on which the safety audit commenced, used to measure schedule adherence and audit program performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `audit_category` STRING COMMENT 'The HSE discipline or management system area being audited, such as occupational health and safety (ISO 45001), environmental management (ISO 14001), energy management (ISO 50001), or chemical hazard compliance (REACH/RoHS).. Valid values are `occupational_health_safety|environmental|energy_management|quality_hse|fire_safety|chemical_hazard|process_safety|ergonomics|emergency_preparedness|combined`',
    `audit_criteria` STRING COMMENT 'The set of policies, procedures, standards, regulations, and requirements against which the audit evidence is compared, such as ISO 45001, OSHA 29 CFR 1910, EPA regulations, or internal SOPs.',
    `audit_number` STRING COMMENT 'Human-readable business reference number for the safety audit, used for tracking, reporting, and cross-referencing with corrective action records and management review inputs.. Valid values are `^HSE-AUD-[0-9]{4}-[0-9]{6}$`',
    `audit_program_reference` STRING COMMENT 'Reference identifier of the annual or multi-year audit program under which this audit is scheduled, linking the individual audit to the broader HSE audit program plan.',
    `audit_scope` STRING COMMENT 'Narrative description of the boundaries and extent of the audit, including processes, departments, activities, and locations covered. Defines what is included and excluded from the audit.',
    `audit_team_members` STRING COMMENT 'Comma-separated list of names or employee IDs of all audit team members participating in the audit, including technical experts and observers.',
    `audit_type` STRING COMMENT 'Classification of the audit by its origin and purpose: internal audits conducted by company personnel, third-party audits by external bodies, regulatory inspections by OSHA/EPA, or management system audits for ISO certification.. Valid values are `internal|third_party|regulatory|management_system|supplier|customer|surveillance|certification|pre_audit`',
    `auditee_representative` STRING COMMENT 'Name and title of the primary management representative from the audited facility or department who is responsible for facilitating the audit and receiving findings.',
    `capa_due_date` DATE COMMENT 'The deadline by which all corrective and preventive actions (CAPA) identified during the audit must be implemented and verified, as agreed between the audit team and auditee.. Valid values are `^d{4}-d{2}-d{2}$`',
    `certifying_body` STRING COMMENT 'Name of the external certification or regulatory body conducting or overseeing the audit (e.g., Bureau Veritas, TÜV Rheinland, OSHA, EPA, DNV GL). Applicable for third-party and regulatory audits.',
    `checklist_items_total` STRING COMMENT 'Total number of audit checklist items or questions evaluated during the audit, providing the denominator for conformance score calculation and audit coverage assessment.. Valid values are `^[0-9]+$`',
    `closure_date` DATE COMMENT 'The date on which the audit was formally closed, confirming all findings have been addressed, corrective actions verified, and the audit record is complete.. Valid values are `^d{4}-d{2}-d{2}$`',
    `conformance_score` DECIMAL(18,2) COMMENT 'Numerical percentage score (0–100) representing the degree of conformance with audit criteria, calculated from the ratio of conforming to total audit checklist items. Used for trend analysis and benchmarking.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `department_name` STRING COMMENT 'Name of the specific department, production area, or functional unit within the facility that is the primary subject of the audit (e.g., Assembly Line 3, Chemical Storage, Maintenance Workshop).',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the audited facility is located, supporting multinational regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `facility_name` STRING COMMENT 'Name of the manufacturing facility or plant where the safety audit is conducted (e.g., Plant A – Detroit, Frankfurt Assembly Facility).',
    `facility_site_code` STRING COMMENT 'Internal site or plant code identifying the specific facility location, aligned with SAP S/4HANA plant codes and Maximo EAM location hierarchy.',
    `findings_critical_count` STRING COMMENT 'Number of critical or imminent danger findings identified during the audit, representing conditions that pose immediate risk to worker safety or severe regulatory violation requiring immediate corrective action.. Valid values are `^[0-9]+$`',
    `findings_major_count` STRING COMMENT 'Number of major non-conformances identified, representing significant failures to meet audit criteria that could result in system breakdown, regulatory penalty, or certification withdrawal.. Valid values are `^[0-9]+$`',
    `findings_minor_count` STRING COMMENT 'Number of minor non-conformances identified, representing isolated or low-risk failures to meet audit criteria that do not immediately threaten system integrity but require corrective action.. Valid values are `^[0-9]+$`',
    `findings_observation_count` STRING COMMENT 'Number of observations or opportunities for improvement (OFIs) noted during the audit that do not constitute non-conformances but represent areas where performance could be enhanced.. Valid values are `^[0-9]+$`',
    `follow_up_audit_date` DATE COMMENT 'Scheduled date for the follow-up audit or verification visit to confirm closure of corrective actions. Populated when follow_up_required is true.. Valid values are `^d{4}-d{2}-d{2}$`',
    `follow_up_required` BOOLEAN COMMENT 'Indicates whether a follow-up audit or verification visit is required to confirm the effective implementation of corrective actions arising from this audit.. Valid values are `true|false`',
    `lead_auditor_certification` STRING COMMENT 'Professional certification or qualification held by the lead auditor (e.g., ISO 45001 Lead Auditor – IRCA, OSHA 30-Hour Certified, ISO 14001 Lead Auditor). Validates auditor competency.',
    `lead_auditor_name` STRING COMMENT 'Full name of the lead auditor responsible for planning, conducting, and reporting the safety audit. For internal audits, this is the qualified internal auditor; for third-party audits, the external certification body auditor.',
    `management_review_input` BOOLEAN COMMENT 'Indicates whether this audits findings and outcomes have been submitted as an input to the management review process as required by ISO 45001 and ISO 14001 Clause 9.3.. Valid values are `true|false`',
    `overall_rating` STRING COMMENT 'The overall compliance rating or outcome of the safety audit, summarizing the aggregate conformance level of the audited area against the audit criteria.. Valid values are `satisfactory|minor_nonconformance|major_nonconformance|critical|observation_only|not_rated`',
    `positive_findings_count` STRING COMMENT 'Number of positive findings or areas of good practice identified during the audit, recognizing exemplary conformance or innovative safety practices that may be shared across facilities.. Valid values are `^[0-9]+$`',
    `previous_audit_reference` STRING COMMENT 'Audit number or identifier of the most recent prior audit conducted at the same facility/scope, enabling trend analysis, repeat finding identification, and follow-up verification.',
    `regulatory_standard` STRING COMMENT 'Primary regulatory standard, management system standard, or legal requirement against which the audit is conducted (e.g., ISO 45001, OSHA 29 CFR 1910, ISO 14001, REACH). Drives compliance reporting.. Valid values are `ISO_45001|ISO_14001|ISO_50001|ISO_9001|OSHA_29CFR1910|OSHA_29CFR1926|EPA|REACH|RoHS|CE_Marking|IEC_62443|NFPA|local_regulation|multiple`',
    `remarks` STRING COMMENT 'Free-text field for additional notes, context, or commentary from the audit team or HSE management regarding special circumstances, audit limitations, or key highlights not captured in structured fields.',
    `report_issued_date` DATE COMMENT 'The date on which the formal audit report was issued to the auditee and relevant stakeholders, triggering the corrective action response timeline.. Valid values are `^d{4}-d{2}-d{2}$`',
    `report_reference` STRING COMMENT 'Document reference number or URL/path to the formal audit report stored in the document management system (e.g., Siemens Teamcenter PLM), enabling traceability to the full audit findings and evidence.',
    `scheduled_end_date` DATE COMMENT 'The planned completion date for the safety audit as defined in the audit program.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scheduled_start_date` DATE COMMENT 'The planned start date for the safety audit as defined in the annual audit program or inspection schedule.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the safety audit, tracking progression from planning through execution to closure and management review.. Valid values are `planned|in_progress|completed|cancelled|on_hold|pending_review|closed`',
    `title` STRING COMMENT 'Descriptive title or name of the safety audit or inspection, summarizing the scope and purpose (e.g., Annual OSHA Compliance Inspection – Plant A, ISO 45001 Surveillance Audit).',
    CONSTRAINT pk_safety_audit PRIMARY KEY(`safety_audit_id`)
) COMMENT 'Records of formal HSE audits and inspections conducted at manufacturing facilities including internal audits, third-party audits, regulatory inspections (OSHA, EPA), and management system audits (ISO 45001, ISO 14001). Captures audit type, scope, facility, audit team, scheduled and actual dates, audit criteria, overall rating, number of findings by severity, and audit report reference. Drives corrective action and management review inputs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` (
    `hse_audit_finding_id` BIGINT COMMENT 'Unique system-generated identifier for each individual audit finding or nonconformity record within the HSE audit management system.',
    `capa_record_id` BIGINT COMMENT 'Foreign key linking to compliance.capa_record. Business justification: Safety audit findings mandate CAPA records for nonconformance closure. Auditors verify finding resolution through CAPA completion status during follow-up audits.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Audit findings often identify equipment-specific safety deficiencies (missing guards, faulty interlocks). Links finding to equipment for corrective maintenance and compliance closure.',
    `safety_audit_id` BIGINT COMMENT 'Foreign key linking to hse.safety_audit. Business justification: audit_finding is a child record of safety_audit — every finding is identified during a specific audit. audit_reference_number is a denormalized string reference that should be replaced with a proper F',
    `applicable_standard_clause` STRING COMMENT 'The specific clause, section, or article of the applicable standard, regulation, or internal procedure against which the nonconformity or observation was raised (e.g., ISO 45001:2018 Clause 8.1.3, OSHA 29 CFR 1910.147).',
    `audit_standard` STRING COMMENT 'The management system standard or regulatory framework under which the audit was conducted and against which this finding was raised.. Valid values are `ISO_9001|ISO_14001|ISO_45001|ISO_50001|IEC_62443|OSHA|EPA|REACH|RoHS|CE_Marking|UL|NIST|ANSI|INTERNAL`',
    `audit_type` STRING COMMENT 'Type of audit or inspection that generated this finding, distinguishing between internal HSE audits, third-party certification audits, regulatory inspections, and supplier audits.. Valid values are `internal_audit|external_audit|regulatory_inspection|supplier_audit|certification_audit|surveillance_audit|follow_up_audit`',
    `auditor_name` STRING COMMENT 'Name of the lead auditor or inspector who identified and documented this finding during the audit or regulatory inspection.',
    `auditor_organization` STRING COMMENT 'Name of the organization or body the auditor represents (e.g., internal HSE team, certification body such as Bureau Veritas, regulatory agency such as OSHA, EPA). Distinguishes internal from external audit sources.',
    `capa_reference_number` STRING COMMENT 'Reference number of the associated Corrective and Preventive Action (CAPA) record created to address this finding. Links the audit finding to the formal CAPA process for root cause analysis and systemic correction.',
    `chemical_substance_involved` BOOLEAN COMMENT 'Indicates whether the finding involves a chemical substance subject to REACH, RoHS, or other hazardous material regulations, triggering chemical hazard management workflows.. Valid values are `true|false`',
    `closed_date` DATE COMMENT 'Date on which the audit finding was formally verified as closed following successful implementation and verification of the corrective action. Used for cycle time analysis and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `corrective_action_description` STRING COMMENT 'Detailed description of the planned or implemented corrective action to eliminate the root cause of the finding and prevent recurrence, as documented in the CAPA record.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the audit finding record was first created in the HSE management system, providing an immutable audit trail for data governance and compliance purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Code of the organizational department or cost center within the facility where the finding was identified, enabling department-level HSE performance analysis and accountability assignment.',
    `description` STRING COMMENT 'Detailed narrative description of the finding, including the observed condition, objective evidence collected, and the specific deviation from the applicable standard, regulation, or internal requirement.',
    `due_date` DATE COMMENT 'Target date by which the corrective action for this finding must be implemented and the finding resolved. Drives overdue tracking, escalation workflows, and regulatory compliance timelines.. Valid values are `^d{4}-d{2}-d{2}$`',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or site where the audit finding was identified. Enables facility-level HSE performance reporting and benchmarking across the global plant network.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the finding was identified, supporting multi-country regulatory compliance tracking and regional HSE reporting.. Valid values are `^[A-Z]{3}$`',
    `finding_category` STRING COMMENT 'HSE domain category of the finding, enabling classification by subject matter for trend analysis and targeted corrective action programs (e.g., safety, environmental, chemical hazard, waste management).. Valid values are `safety|environmental|quality|regulatory_compliance|process|documentation|training|equipment|chemical_hazard|waste_management|energy|emergency_preparedness`',
    `finding_number` STRING COMMENT 'Human-readable business reference number for the audit finding, used for cross-referencing in reports, CAPA records, and regulatory submissions. Format: HSE-AF-YYYY-NNNNNN.. Valid values are `^HSE-AF-[0-9]{4}-[0-9]{6}$`',
    `finding_source` STRING COMMENT 'Origin or trigger of the audit finding, distinguishing between planned internal audits, unplanned inspections, regulatory visits, incident investigations, and management reviews.. Valid values are `planned_audit|unplanned_audit|regulatory_inspection|incident_investigation|management_review|customer_complaint|supplier_feedback|self_assessment`',
    `finding_type` STRING COMMENT 'Classification of the finding according to its severity and nature. Major nonconformities represent systemic failures; minor nonconformities are isolated deviations; observations are noteworthy items not yet nonconforming; opportunities for improvement are suggestions; positive findings recognize best practices.. Valid values are `major_nonconformity|minor_nonconformity|observation|opportunity_for_improvement|positive_finding`',
    `identified_date` DATE COMMENT 'Calendar date on which the audit finding was identified and documented during the audit or inspection. Used as the baseline for due date calculation and aging analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `immediate_action_taken` STRING COMMENT 'Description of the immediate containment or correction action taken at the time of finding identification to address the unsafe condition or nonconformity before the full corrective action is implemented.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the audit finding record, supporting change tracking, data lineage, and incremental data pipeline processing in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `objective_evidence` STRING COMMENT 'Factual, verifiable evidence collected during the audit that substantiates the finding, such as document references, observation records, measurement results, or interview notes. Required per ISO 19011 audit methodology.',
    `previous_finding_reference` STRING COMMENT 'Reference number of the prior audit finding that this finding is a recurrence of, enabling repeat finding trend analysis and escalation of persistent nonconformities.',
    `process_area` STRING COMMENT 'Specific shop floor area, production line, or operational zone within the facility where the finding was observed (e.g., Assembly Line 3, Paint Shop, Warehouse Zone B). Supports granular root cause analysis.',
    `regulatory_reference` STRING COMMENT 'Specific regulatory citation (e.g., OSHA standard number, EPA regulation, EU directive, REACH/RoHS article) applicable to this finding, used for regulatory reporting and compliance tracking.',
    `regulatory_reportable` BOOLEAN COMMENT 'Indicates whether this finding must be formally reported to a regulatory authority (e.g., OSHA, EPA, EU competent authority) within a mandated timeframe. Triggers regulatory notification workflows.. Valid values are `true|false`',
    `regulatory_reported_date` DATE COMMENT 'Date on which the finding was formally reported to the applicable regulatory authority, used for compliance documentation and audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `repeat_finding` BOOLEAN COMMENT 'Indicates whether this finding is a recurrence of a previously identified and closed finding at the same facility or department, signaling systemic corrective action ineffectiveness.. Valid values are `true|false`',
    `responsible_owner` STRING COMMENT 'Name or employee ID of the individual assigned as the accountable owner for implementing the corrective action and achieving closure of this finding.',
    `responsible_owner_email` STRING COMMENT 'Email address of the individual responsible for resolving the audit finding, used for automated notifications, escalation alerts, and due date reminders.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `revised_due_date` DATE COMMENT 'Updated target date for finding resolution when the original due date has been formally extended with management approval. Tracks approved deferrals separately from the original commitment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `risk_level` STRING COMMENT 'Overall risk level assigned to the finding based on the combination of likelihood and consequence assessment, aligned with the facilitys HSE risk matrix. Used to prioritize remediation resources.. Valid values are `extreme|high|medium|low|negligible`',
    `root_cause_category` STRING COMMENT 'High-level categorization of the root cause identified for the finding, used for systemic trend analysis and targeted preventive action programs across the manufacturing enterprise.. Valid values are `human_error|process_failure|equipment_failure|training_deficiency|documentation_gap|management_system|supplier_issue|design_deficiency|environmental_condition|unknown`',
    `severity` STRING COMMENT 'Risk-based severity rating of the finding indicating the potential impact on health, safety, environment, or regulatory compliance. Drives prioritization of corrective actions and escalation protocols.. Valid values are `critical|high|medium|low|informational`',
    `status` STRING COMMENT 'Current lifecycle status of the audit finding, tracking its progression from identification through corrective action implementation to verified closure.. Valid values are `open|in_progress|pending_verification|closed|overdue|cancelled|deferred`',
    `title` STRING COMMENT 'Short, descriptive title summarizing the audit finding for display in dashboards, reports, and CAPA tracking lists.',
    `verified_date` DATE COMMENT 'Date on which the effectiveness of the corrective action was independently verified by the auditor or HSE manager, confirming the finding has been adequately addressed.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_hse_audit_finding PRIMARY KEY(`hse_audit_finding_id`)
) COMMENT 'Individual findings, observations, and nonconformities identified during HSE audits and regulatory inspections. Captures finding type (major nonconformity, minor nonconformity, observation, opportunity for improvement), finding description, applicable standard clause or regulation, severity, assigned facility and department, responsible owner, due date for resolution, and closure status. Links to CAPA records for corrective action tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`chemical_substance` (
    `chemical_substance_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each chemical substance or hazardous material record in the master registry.',
    `material_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.material_specification. Business justification: Chemical substances used in manufacturing must link to engineering material specifications for traceability. HSE needs material specs to verify chemical composition matches safety data sheets and regu',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Chemical substances are purchased from suppliers. HSE teams need supplier information for SDS management, REACH compliance, and chemical traceability. Used daily in chemical procurement and regulatory',
    `approved_usage_locations` STRING COMMENT 'Pipe-delimited list of facility codes or location identifiers where this substance is approved for use, storage, or production. Enforces chemical authorization controls and supports site-level REACH/RoHS compliance reporting.',
    `boiling_point_celsius` DECIMAL(18,2) COMMENT 'Boiling point of the substance in degrees Celsius at standard atmospheric pressure. Used for storage condition determination, ventilation design, and vapor pressure hazard assessment.',
    `cas_number` STRING COMMENT 'Globally unique CAS Registry Number assigned by the American Chemical Society to uniquely identify the chemical substance. Used as the primary chemical identity reference across regulatory databases.. Valid values are `^[0-9]{2,7}-[0-9]{2}-[0-9]$`',
    `common_name` STRING COMMENT 'Widely recognized common or generic name for the chemical substance (e.g., acetone, sulfuric acid). Used in day-to-day operational communication and shop floor documentation.',
    `dot_hazard_class` STRING COMMENT 'US DOT hazard class (1–9) assigned to the substance for domestic transportation compliance. Determines placarding, packaging, and shipping paper requirements.. Valid values are `1|2|3|4|5|6|7|8|9|none`',
    `ec_number` STRING COMMENT 'European Community inventory number (EINECS, ELINCS, or NLP list) assigned to substances registered in the EU. Required for REACH compliance and EU regulatory submissions.. Valid values are `^[0-9]{3}-[0-9]{3}-[0-9]$`',
    `effective_date` DATE COMMENT 'Date from which the chemical substance record is considered valid and active for operational use. Supports temporal validity tracking for regulatory compliance and change management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `environmental_hazard_category` STRING COMMENT 'GHS environmental hazard classification for the substance. Informs spill response procedures, waste disposal requirements, and environmental permit conditions under EPA and ISO 14001.. Valid values are `aquatic_acute|aquatic_chronic|ozone_depleting|persistent_bioaccumulative_toxic|none|multiple`',
    `expiry_date` DATE COMMENT 'Date after which the chemical substance record is no longer valid for operational use and must be reviewed or replaced. Drives compliance calendar alerts and substance phase-out planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `flash_point_celsius` DECIMAL(18,2) COMMENT 'Lowest temperature (in degrees Celsius) at which the substance produces sufficient vapor to ignite in air. Critical for flammable liquid storage classification, fire prevention, and emergency response planning.',
    `ghs_hazard_class` STRING COMMENT 'GHS hazard classification category for the substance (e.g., Flammable Liquid Cat. 2, Acute Toxicity Cat. 3). Drives labeling, SDS authoring, and PPE requirements. Multiple classes may be pipe-delimited.',
    `ghs_pictogram_codes` STRING COMMENT 'Pipe-delimited list of GHS pictogram codes applicable to the substance (e.g., GHS01|GHS02|GHS06). Used for label generation and visual hazard communication on SDS and packaging.',
    `ghs_signal_word` STRING COMMENT 'GHS signal word (Danger or Warning) assigned to the substance based on its hazard classification severity. Printed on labels and SDS to communicate hazard level to handlers.. Valid values are `Danger|Warning|None`',
    `hazard_statement_codes` STRING COMMENT 'Pipe-delimited list of GHS H-statement codes assigned to the substance (e.g., H225|H302|H315). Standardized phrases describing the nature and degree of hazard for SDS Section 2 and labeling.',
    `health_hazard_category` STRING COMMENT 'Primary GHS health hazard category assigned to the substance. Used for medical surveillance program design, PPE selection, and occupational exposure limit (OEL) management.. Valid values are `acute_toxicity|skin_corrosion|eye_damage|respiratory_sensitizer|skin_sensitizer|carcinogen|mutagen|reproductive_toxin|target_organ_toxin|aspiration_hazard|none|multiple`',
    `iupac_name` STRING COMMENT 'Systematic chemical name assigned according to IUPAC nomenclature rules. Provides the authoritative scientific identity of the substance for regulatory submissions and SDS documentation.',
    `occupational_exposure_limit_mgm3` DECIMAL(18,2) COMMENT 'Permissible occupational exposure limit for the substance expressed in milligrams per cubic meter (mg/m³) as an 8-hour TWA. Complementary to ppm-based OEL for substances without a defined ppm value.',
    `occupational_exposure_limit_ppm` DECIMAL(18,2) COMMENT 'Permissible occupational exposure limit for the substance expressed in parts per million (ppm) as an 8-hour time-weighted average (TWA). Used for industrial hygiene monitoring and ventilation design.',
    `physical_hazard_category` STRING COMMENT 'Primary GHS physical hazard category assigned to the substance. Drives fire prevention measures, storage segregation rules, and emergency response planning.. Valid values are `flammable|explosive|oxidizer|self_reactive|pyrophoric|self_heating|water_reactive|organic_peroxide|corrosive_to_metals|none|multiple`',
    `physical_state` STRING COMMENT 'Physical state of the chemical substance at standard conditions (25°C, 1 atm). Drives storage requirements, handling procedures, and emergency response planning.. Valid values are `solid|liquid|gas|aerosol|paste|powder|granule|unknown`',
    `precautionary_statement_codes` STRING COMMENT 'Pipe-delimited list of GHS P-statement codes assigned to the substance (e.g., P210|P260|P280). Standardized phrases describing measures to minimize or prevent adverse effects for SDS and labeling.',
    `prop65_listed` BOOLEAN COMMENT 'Indicates whether the substance is listed under California Proposition 65 (Safe Drinking Water and Toxic Enforcement Act) as known to cause cancer, birth defects, or reproductive harm. Relevant for products sold in California.. Valid values are `true|false`',
    `reach_registration_number` STRING COMMENT 'ECHA-assigned registration number for substances registered under REACH (format: 01-XXXXXXXXXX-CC-XXXX). Required for supply chain communication and regulatory compliance verification.. Valid values are `^01-[0-9]{10}-[0-9]{2}-[0-9]{4}$`',
    `reach_registration_status` STRING COMMENT 'Current REACH registration status of the substance under EU Regulation (EC) No 1907/2006. Determines whether the substance can be legally manufactured or imported into the EU above threshold tonnages.. Valid values are `registered|pre-registered|exempt|not_required|pending|unknown`',
    `regulatory_list_membership` STRING COMMENT 'Pipe-delimited list of regulatory inventories or restricted substance lists on which this substance appears (e.g., SVHC|Prop65|TSCA_Active|SARA_313|CERCLA). Supports multi-regulation compliance screening and reporting.',
    `rohs_exemption_code` STRING COMMENT 'RoHS Annex III or IV exemption code applicable to this substance if it is restricted but an exemption has been granted for specific applications (e.g., exemption 6(c) for lead in solders). Null if not restricted or no exemption applies.',
    `rohs_restricted` BOOLEAN COMMENT 'Indicates whether the substance is restricted under EU RoHS Directive 2011/65/EU for use in electrical and electronic equipment. Critical for product compliance in EEE manufacturing.. Valid values are `true|false`',
    `sara_313_reportable` BOOLEAN COMMENT 'Indicates whether the substance is subject to annual Toxic Release Inventory (TRI) reporting under SARA Title III Section 313. Triggers annual EPA Form R submission obligations.. Valid values are `true|false`',
    `sds_document_number` STRING COMMENT 'Internal document control number referencing the current Safety Data Sheet (SDS) for this substance. Links to the document management system for retrieval of the full 16-section SDS per GHS/OSHA requirements.',
    `sds_expiry_date` DATE COMMENT 'Date by which the Safety Data Sheet must be reviewed and reissued to remain current. Drives SDS review workflow scheduling and compliance calendar management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sds_issue_date` DATE COMMENT 'Date on which the current version of the Safety Data Sheet was issued or last revised. Used to verify SDS currency and trigger review workflows when regulatory updates occur.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sds_version` STRING COMMENT 'Version number of the current Safety Data Sheet on file for this substance. Ensures workers and emergency responders are using the most current hazard information.',
    `status` STRING COMMENT 'Current lifecycle status of the chemical substance record in the master registry. Controls whether the substance can be requisitioned, used in production, or must be substituted with an approved alternative.. Valid values are `active|inactive|under_review|restricted|phased_out|pending_approval`',
    `storage_temperature_max_celsius` DECIMAL(18,2) COMMENT 'Maximum allowable storage temperature in degrees Celsius for the substance. Drives warehouse storage zone assignment, refrigeration requirements, and temperature monitoring alert thresholds.',
    `substance_type` STRING COMMENT 'Classification of the chemical entry as a pure substance, mixture, article, or intermediate as defined under REACH. Determines applicable regulatory obligations and SDS requirements.. Valid values are `substance|mixture|article|intermediate|polymer|monomer|unknown`',
    `svhc_listed` BOOLEAN COMMENT 'Indicates whether the substance appears on the ECHA SVHC Candidate List under REACH. SVHC listing triggers mandatory communication obligations in the supply chain and may require authorization for use.. Valid values are `true|false`',
    `svhc_listing_date` DATE COMMENT 'Date on which the substance was added to the ECHA SVHC Candidate List. Used to track compliance timelines and trigger downstream supply chain notifications.. Valid values are `^d{4}-d{2}-d{2}$`',
    `trade_name` STRING COMMENT 'Proprietary or brand name under which the chemical substance or mixture is commercially sold by the supplier. Used for procurement matching and supplier SDS cross-referencing.',
    `tsca_status` STRING COMMENT 'Status of the substance on the US EPA TSCA Chemical Substance Inventory. Determines whether the substance can be manufactured, imported, or processed in the United States.. Valid values are `active|inactive|exempt|new_chemical|pmn_pending|not_listed|unknown`',
    `un_number` STRING COMMENT 'UN four-digit number assigned to the substance for transport classification under the UN Model Regulations for dangerous goods. Required for shipping labels, placards, and transport documentation.. Valid values are `^UN[0-9]{4}$`',
    CONSTRAINT pk_chemical_substance PRIMARY KEY(`chemical_substance_id`)
) COMMENT 'Master registry of all chemical substances and hazardous materials used, stored, or produced across manufacturing facilities. Captures CAS number, chemical name, trade name, substance classification (GHS/CLP), REACH registration status, RoHS restriction status, SDS (Safety Data Sheet) reference, physical and health hazard categories, regulatory lists membership (SVHC, Prop 65, TSCA), and approved usage locations. SSOT for chemical identity supporting REACH/RoHS compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` (
    `chemical_inventory_id` BIGINT COMMENT 'Unique surrogate identifier for each chemical inventory record at the facility-storage location level. Serves as the primary key for the chemical_inventory data product in the HSE domain.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: chemical_inventory records facility-level stock of chemicals that are defined in the chemical_substance master registry. chemical_name, iupac_name, cas_number, ec_number, and un_number in chemical_inv',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Chemical inventory receipts are traced to delivery orders for regulatory tracking, batch traceability, and supplier accountability. EHS teams reconcile chemical deliveries against purchase documentati',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Chemical inventory tracks where hazardous substances are stored by plant location. Required for emergency response, Tier II reporting, and location-specific exposure assessments.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Chemical inventory is tracked by production plant for regulatory compliance. HSE must know quantities and locations of hazardous substances at each facility for OSHA, EPA reporting.',
    `sds_id` BIGINT COMMENT 'Foreign key linking to hse.sds. Business justification: Each chemical inventory record must be associated with a current Safety Data Sheet for the stored substance. sds_number in chemical_inventory is a denormalized string reference that should be replaced',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Hazardous chemical storage must be tracked to specific warehouse locations for regulatory compliance, emergency response planning, and ensuring proper segregation. Required for OSHA and EPA reporting.',
    `chemical_category` STRING COMMENT 'Primary hazard classification category of the chemical substance per GHS/OSHA HazCom standards. Drives storage segregation rules, PPE requirements, emergency response procedures, and regulatory reporting thresholds.. Valid values are `flammable_liquid|flammable_solid|oxidizer|corrosive|toxic|explosive|compressed_gas|reactive|carcinogen|environmental_hazard|other`',
    `containment_type` STRING COMMENT 'Type of container or containment system used to store the chemical substance (e.g., drum, IBC tote, fixed tank, cylinder). Informs spill response planning, secondary containment sizing, and inspection requirements.. Valid values are `drum|ibc_tote|tank|cylinder|bag|bottle|pipeline|bulk_storage|other`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the facility is located. Determines applicable regulatory framework (e.g., OSHA/EPA for USA, REACH/RoHS for EU member states, local HSE regulations for other countries).. Valid values are `^[A-Z]{3}$`',
    `disposal_method` STRING COMMENT 'Approved method for disposing of the chemical substance when it is expired, excess, or no longer needed. Must comply with EPA RCRA hazardous waste regulations and local environmental permits.. Valid values are `licensed_waste_contractor|incineration|neutralization|recycling|solvent_recovery|landfill_approved|drain_permitted|return_to_supplier|other`',
    `expiration_date` DATE COMMENT 'Expiration or shelf-life date of the chemical substance batch currently in inventory. Expired chemicals may degrade, become unstable, or lose efficacy, requiring disposal or replacement per SDS guidance.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `facility_code` STRING COMMENT 'Alphanumeric code identifying the manufacturing plant or facility where the chemical is stored. Aligns with SAP S/4HANA plant code and supports multi-site regulatory reporting.',
    `facility_name` STRING COMMENT 'Full legal or operational name of the manufacturing facility or plant where the chemical inventory is maintained. Used in EPA Tier II submissions and emergency response documentation.',
    `ghs_pictogram_codes` STRING COMMENT 'Comma-separated list of GHS hazard pictogram codes applicable to the chemical (e.g., GHS01-Explosive, GHS02-Flammable, GHS06-Toxic). Supports label generation, SDS alignment, and HazCom training.',
    `last_physical_count_date` DATE COMMENT 'Date of the most recent physical inventory count or verification of the chemical quantity at the storage location. Required for inventory accuracy, audit compliance, and Tier II reporting data integrity.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `lot_number` STRING COMMENT 'Supplier-assigned lot or batch number for the chemical substance. Enables traceability for quality incidents, product recalls, and regulatory investigations. Corresponds to SAP S/4HANA MM batch number.',
    `max_authorized_quantity` DECIMAL(18,2) COMMENT 'Maximum quantity of the chemical substance authorized to be stored at this location, as approved by facility management, fire marshal, or regulatory permit. Enforces storage limits and triggers compliance alerts when approached.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `next_count_due_date` DATE COMMENT 'Scheduled date for the next mandatory physical inventory count of the chemical substance. Drives work order generation in Maximo EAM and compliance calendar management.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `nfpa_flammability_rating` STRING COMMENT 'NFPA 704 flammability hazard rating (0-4) for the chemical substance. Drives fire suppression system design, storage segregation requirements, and hot work permit conditions.. Valid values are `0|1|2|3|4`',
    `nfpa_health_rating` STRING COMMENT 'NFPA 704 health hazard rating (0-4) for the chemical substance, indicating the degree of health hazard. Used for facility placarding, emergency response planning, and PPE selection.. Valid values are `0|1|2|3|4`',
    `nfpa_reactivity_rating` STRING COMMENT 'NFPA 704 reactivity/instability hazard rating (0-4) for the chemical substance. Informs incompatibility assessments, storage segregation, and emergency response procedures.. Valid values are `0|1|2|3|4`',
    `physical_state` STRING COMMENT 'Physical state of the chemical substance at standard conditions (solid, liquid, gas, or mixture). Determines storage requirements, containment design, spill response procedures, and emission monitoring obligations.. Valid values are `solid|liquid|gas|mixture`',
    `psm_covered` BOOLEAN COMMENT 'Indicates whether this chemical inventory record is subject to OSHA Process Safety Management (PSM) regulations, based on the chemical being listed in 29 CFR 1910.119 Appendix A and the quantity exceeding the PSM threshold.. Valid values are `true|false`',
    `quantity_on_hand` DECIMAL(18,2) COMMENT 'Current quantity of the chemical substance physically present at the storage location, expressed in the designated unit of measure. Core field for EPA Tier II threshold determination, OSHA PSM applicability, and inventory management.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `reach_registered` BOOLEAN COMMENT 'Indicates whether the chemical substance has been registered under the EU REACH regulation (EC) No 1907/2006. Required for substances manufactured or imported into the EU above 1 tonne per year.. Valid values are `true|false`',
    `receipt_date` DATE COMMENT 'Date the chemical substance was received at the facility from the supplier, as recorded in the Goods Receipt Note (GRN) in SAP S/4HANA MM. Establishes the start of the storage period for shelf-life and regulatory tracking.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `record_number` STRING COMMENT 'Human-readable business identifier for the chemical inventory record, used in regulatory submissions, audit trails, and cross-system references (e.g., SAP MM material document, Tier II reports).. Valid values are `^CHEM-INV-[A-Z0-9]{4,20}$`',
    `reporting_year` STRING COMMENT 'Calendar year for which this chemical inventory record is applicable for regulatory reporting purposes (e.g., EPA Tier II annual report, REACH annual tonnage update). Enables year-over-year compliance tracking.. Valid values are `^[0-9]{4}$`',
    `rmp_covered` BOOLEAN COMMENT 'Indicates whether this chemical inventory is subject to EPA Risk Management Program (RMP) requirements under the Clean Air Act Section 112(r), based on regulated substance thresholds.. Valid values are `true|false`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the chemical substance complies with EU RoHS Directive 2011/65/EU restricting the use of hazardous substances in electrical and electronic equipment. Critical for product compliance in electrification and automation product lines.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current lifecycle status of the chemical inventory record. Drives workflow actions such as disposal initiation, replenishment orders, regulatory reporting inclusion/exclusion, and emergency response plan updates.. Valid values are `active|expired|depleted|quarantined|pending_disposal|disposed|recalled`',
    `storage_condition_notes` STRING COMMENT 'Free-text description of special storage conditions required for the chemical, such as ventilation requirements, segregation from incompatible materials, humidity controls, light sensitivity, or secondary containment requirements.',
    `storage_location_code` STRING COMMENT 'Code identifying the specific storage location within the facility (e.g., warehouse bin, tank farm, chemical storage room). Corresponds to SAP S/4HANA WM storage location and Infor WMS location code.',
    `storage_location_name` STRING COMMENT 'Descriptive name of the storage location within the facility, such as Tank Farm A, Chemical Warehouse Bay 3, or Hazmat Storage Room 101. Supports emergency response planning and site maps.',
    `storage_temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum allowable storage temperature for the chemical substance in degrees Celsius, as specified in the SDS. Triggers alerts when ambient temperature monitoring exceeds this threshold.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `storage_temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum allowable storage temperature for the chemical substance in degrees Celsius, as specified in the SDS. Drives environmental monitoring requirements and storage facility design specifications.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `supplier_name` STRING COMMENT 'Name of the supplier or manufacturer who provided the chemical substance. Used for SDS sourcing, supplier qualification, REACH supply chain communication, and procurement traceability via SAP Ariba.',
    `tier2_reportable` BOOLEAN COMMENT 'Indicates whether the current quantity on hand meets or exceeds the EPCRA Tier II reporting threshold, requiring inclusion in the annual EPA Tier II hazardous chemical inventory report submitted to state and local emergency planning committees.. Valid values are `true|false`',
    `tier2_threshold_quantity` DECIMAL(18,2) COMMENT 'Regulatory threshold quantity (in pounds) above which the chemical must be reported on the EPA Tier II annual inventory report under EPCRA Section 312. Populated from EPAs list of hazardous chemicals and extremely hazardous substances (EHS).. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure in which the chemical quantity is tracked and reported (e.g., kg, lb, liter, gallon). Must align with EPA Tier II reporting units and SAP S/4HANA MM base unit of measure.. Valid values are `kg|lb|g|ton|metric_ton|liter|gallon|cubic_meter|cubic_foot|unit|cylinder`',
    `waste_code` STRING COMMENT 'EPA RCRA hazardous waste code(s) applicable to this chemical when it becomes waste (e.g., F001, D001, U002). Required for hazardous waste manifests, disposal tracking, and EPA biennial reporting.',
    CONSTRAINT pk_chemical_inventory PRIMARY KEY(`chemical_inventory_id`)
) COMMENT 'Facility-level inventory records of hazardous chemicals and substances maintained at each manufacturing plant and storage location. Captures chemical substance reference, facility and storage location, current quantity on hand, unit of measure, maximum authorized quantity, Tier II reporting threshold status (EPCRA), storage conditions, last physical count date, and disposal method. Supports EPA Tier II reporting, OSHA PSM, and emergency response planning.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`sds` (
    `sds_id` BIGINT COMMENT 'Unique system-generated identifier for each Safety Data Sheet master record in the HSE data product.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: An SDS is the regulatory document for a specific chemical substance. chemical_name, cas_number, ec_number, and un_number in sds are denormalized copies of master data held in chemical_substance. Addin',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Safety Data Sheets are provided by chemical suppliers. HSE requires supplier tracking for SDS updates, regulatory compliance, and emergency contact. Critical for chemical management programs.',
    `acgih_tlv` STRING COMMENT 'American Conference of Governmental Industrial Hygienists (ACGIH) Threshold Limit Value (TLV) for the chemical, expressed as TWA or STEL with units. Widely used as a benchmark for occupational exposure assessment alongside OSHA PEL.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country for which this SDS version is applicable. Supports country-specific regulatory requirements and multi-country SDS management.. Valid values are `^[A-Z]{3}$`',
    `disposal_methods` STRING COMMENT 'Recommended methods for safe disposal of the chemical and contaminated packaging as specified in SDS Section 13. Supports waste management compliance with EPA and local environmental regulations.',
    `document_url` STRING COMMENT 'URL or file path to the official SDS document (PDF or equivalent) stored in the document management system (e.g., Siemens Teamcenter PLM). Enables direct access to the full SDS for workers and compliance officers.. Valid values are `^https?://[^s]+$`',
    `firefighting_measures` STRING COMMENT 'Suitable extinguishing media, special firefighting procedures, and protective equipment for firefighters as specified in SDS Section 5. Used for emergency response planning and fire safety programs.',
    `first_aid_measures` STRING COMMENT 'Summary of first aid procedures for exposure routes including inhalation, skin contact, eye contact, and ingestion as specified in SDS Section 4. Used for emergency response planning and worker training.',
    `flash_point_c` DECIMAL(18,2) COMMENT 'Lowest temperature in degrees Celsius at which the chemical produces sufficient vapor to ignite. Critical for flammability classification, storage segregation, and fire risk assessment per SDS Section 9.. Valid values are `^-?[0-9]{1,4}(.[0-9]{1,2})?$`',
    `ghs_environmental_hazard_class` STRING COMMENT 'GHS environmental hazard classification(s) for the chemical, such as hazardous to the aquatic environment (acute or chronic) or ozone layer hazard. Pipe-delimited if multiple classes apply.',
    `ghs_health_hazard_class` STRING COMMENT 'GHS health hazard classification(s) for the chemical, such as acute toxicity, skin corrosion/irritation, serious eye damage, respiratory sensitization, carcinogenicity, reproductive toxicity, STOT, or aspiration hazard. Pipe-delimited if multiple classes apply.',
    `ghs_physical_hazard_class` STRING COMMENT 'GHS physical hazard classification(s) for the chemical, such as flammable liquid, explosive, oxidizer, compressed gas, self-reactive, or pyrophoric. Pipe-delimited if multiple classes apply.',
    `ghs_revision` STRING COMMENT 'Version of the Globally Harmonized System (GHS) standard to which this SDS conforms (e.g., GHS Rev.7, GHS Rev.9). Different countries implement different GHS revisions, affecting classification criteria and label requirements.. Valid values are `^GHS Rev.[0-9]+$`',
    `handling_precautions` STRING COMMENT 'Safe handling instructions for the chemical including precautions to prevent exposure, ignition, or incompatible contact as specified in SDS Section 7. Informs SOPs and operator training.',
    `hazard_statement_codes` STRING COMMENT 'Pipe-delimited list of GHS H-codes (e.g., H225|H302|H315) assigned to the chemical based on its hazard classification. Used for label generation, risk assessment, and regulatory reporting.. Valid values are `^H[0-9]{3}(|H[0-9]{3})*$`',
    `is_reach_svhc` BOOLEAN COMMENT 'Indicates whether the chemical is listed as a Substance of Very High Concern (SVHC) on the ECHA Candidate List under REACH. Triggers mandatory communication obligations in the supply chain and article declarations.. Valid values are `true|false`',
    `is_rohs_restricted` BOOLEAN COMMENT 'Indicates whether the chemical contains substances restricted under the RoHS Directive (e.g., lead, mercury, cadmium, hexavalent chromium, PBB, PBDE). Critical for product compliance in EU markets.. Valid values are `true|false`',
    `issue_date` DATE COMMENT 'Date on which the Safety Data Sheet was originally issued by the supplier or manufacturer. Required field per GHS and OSHA HazCom for worker right-to-know compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `language_code` STRING COMMENT 'ISO 639-1 language code (optionally with ISO 3166-1 country code) of the Safety Data Sheet document (e.g., en-US, de-DE, fr-FR). Supports multinational operations where local-language SDS are legally required.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the Safety Data Sheet to ensure continued accuracy and regulatory compliance. Typically set at 3-year intervals per industry practice.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Business-assigned document number uniquely identifying the SDS record, used for cross-referencing in chemical management systems and regulatory submissions.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `osha_pel` STRING COMMENT 'OSHA Permissible Exposure Limit (PEL) for the chemical substance, expressed as TWA (time-weighted average), STEL (short-term exposure limit), or ceiling value with units (e.g., ppm, mg/m3). Required for Section 8 of the SDS.',
    `physical_state` STRING COMMENT 'Physical state of the chemical substance at standard conditions (solid, liquid, gas, etc.) as specified in SDS Section 9. Determines handling, storage, and transport requirements.. Valid values are `solid|liquid|gas|aerosol|paste|powder|granule`',
    `ppe_requirements` STRING COMMENT 'Description of required Personal Protective Equipment (PPE) for handling the chemical, including respiratory protection, gloves, eye/face protection, and body protection as specified in SDS Section 8. Drives PPE procurement and worker training.',
    `precautionary_statement_codes` STRING COMMENT 'Pipe-delimited list of GHS P-codes (e.g., P210|P233|P264) specifying precautionary measures for safe handling, storage, disposal, and emergency response. Required on SDS and label.. Valid values are `^P[0-9]{3}(|P[0-9]{3})*$`',
    `reach_registration_number` STRING COMMENT 'REACH registration number assigned by ECHA to substances manufactured or imported into the EU in quantities ≥1 tonne/year. Required for EU operations compliance and SDS Section 1 under REACH.. Valid values are `^01-[0-9]{13}-[0-9]{2}-[0-9]{4}$`',
    `regulatory_compliance_notes` STRING COMMENT 'Free-text notes capturing additional regulatory compliance information from SDS Section 15, including applicable national regulations, inventory listings (TSCA, DSL, AICS), and specific compliance obligations beyond REACH and RoHS.',
    `revision_date` DATE COMMENT 'Date on which the Safety Data Sheet was most recently revised. Triggers re-training and re-distribution obligations under OSHA HazCom when hazard information changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `signal_word` STRING COMMENT 'GHS signal word (Danger or Warning) indicating the relative severity of the hazard. Danger is used for more severe hazard categories; Warning for less severe. Required on SDS and label.. Valid values are `Danger|Warning|Not classified`',
    `status` STRING COMMENT 'Current lifecycle status of the Safety Data Sheet record, indicating whether it is in active use, superseded by a newer version, archived, under regulatory review, or in draft.. Valid values are `active|superseded|archived|under_review|draft`',
    `storage_requirements` STRING COMMENT 'Conditions for safe storage of the chemical including temperature range, incompatible materials, ventilation requirements, and container specifications as specified in SDS Section 7. Drives warehouse and inventory management controls.',
    `substance_type` STRING COMMENT 'Classification of the chemical as a pure substance, mixture of substances, or article as defined under GHS and REACH. Determines the applicable regulatory obligations and SDS format requirements.. Valid values are `substance|mixture|article`',
    `supplier_emergency_phone` STRING COMMENT '24-hour emergency telephone number provided by the supplier or manufacturer on the SDS for use in chemical emergency response situations. Mandatory per OSHA HazCom Section 1.. Valid values are `^+?[0-9s-()]{7,20}$`',
    `trade_name` STRING COMMENT 'Commercial or trade name of the chemical product as marketed by the supplier. May differ from the chemical name and is used for procurement and inventory identification.',
    `version_number` STRING COMMENT 'Version identifier of the Safety Data Sheet, incremented each time the document is revised to reflect updated hazard information, regulatory changes, or supplier updates.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    CONSTRAINT pk_sds PRIMARY KEY(`sds_id`)
) COMMENT 'Safety Data Sheet master records for all chemical substances used across manufacturing operations. Captures SDS version number, issue date, revision date, supplier/manufacturer, GHS hazard classifications (health, physical, environmental), first aid measures, firefighting measures, handling and storage requirements, PPE requirements, exposure limits (OSHA PEL, ACGIH TLV), and regulatory compliance sections. Supports worker right-to-know and OSHA HazCom compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`environmental_permit` (
    `environmental_permit_id` BIGINT COMMENT 'Unique system-generated identifier for each environmental permit record. Serves as the primary key for the environmental_permit data product.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Environmental permits for manufacturing operations at customer-owned facilities or joint ventures must reference the customer account for regulatory compliance, permit transfers, and liability trackin',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: Environmental permits are issued to specific legal entities. Required for regulatory compliance tracking and audit trails. Each manufacturing facility operates under a legal entity with specific permi',
    `regulatory_filing_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_filing. Business justification: Environmental permits require regulatory filings tracked in compliance system. Environmental coordinators reference filing records for permit renewal deadlines and authority correspondence.',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to hse.regulatory_obligation. Business justification: Environmental permits are issued to fulfill specific regulatory obligations (e.g., Clean Air Act permit fulfills an EPA regulatory obligation). Linking environmental_permit to regulatory_obligation es',
    `employee_id` BIGINT COMMENT 'Employee identifier of the internal manager or environmental compliance officer accountable for this permit. Used for workflow assignment, escalation routing, and compliance accountability reporting.',
    `amendment_date` DATE COMMENT 'Date on which the most recent permit amendment or modification was issued by the regulatory authority. Used to track permit revision history and ensure compliance with updated permit conditions.. Valid values are `d{4}-d{2}-d{2}`',
    `amendment_number` STRING COMMENT 'Identifier for the most recent amendment or modification to the original permit. Tracks permit revisions resulting from facility changes, regulatory updates, or voluntary modifications. Null if no amendments have been issued.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the environmental permit record was first created in the system. Supports data lineage, audit trail, and record management requirements.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `effective_date` DATE COMMENT 'Date on which the environmental permit becomes operationally effective and compliance obligations commence. May differ from the issue date if a grace period or administrative review period applies.. Valid values are `d{4}-d{2}-d{2}`',
    `emission_limit_description` STRING COMMENT 'Narrative description of the key emission, discharge, or operational limits specified in the permit conditions. Includes pollutant thresholds, discharge concentration limits, noise decibel limits, or waste quantity limits as applicable to the permit type.',
    `expiration_date` DATE COMMENT 'Date on which the environmental permit expires and must be renewed to maintain legal authorization for permitted activities. Critical for renewal workflow triggers and compliance risk management.. Valid values are `d{4}-d{2}-d{2}`',
    `facility_code` STRING COMMENT 'Internal code identifying the manufacturing facility to which this environmental permit applies. Enables facility-level compliance tracking and multi-site regulatory reporting.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility covered by this permit. Supports multi-national regulatory compliance tracking and jurisdiction-specific reporting.. Valid values are `[A-Z]{3}`',
    `facility_name` STRING COMMENT 'Legal or operational name of the manufacturing facility covered by this environmental permit, as registered with the issuing regulatory authority.',
    `facility_state_province` STRING COMMENT 'State, province, or regional administrative division where the permitted facility is located. Required for jurisdiction-specific regulatory compliance and state-level permit program management.',
    `insurance_bond_required_flag` BOOLEAN COMMENT 'Indicates whether the permit requires the facility to maintain financial assurance instruments such as insurance policies, surety bonds, or closure cost estimates as a condition of permit issuance (common for RCRA hazardous waste permits).. Valid values are `true|false`',
    `issue_date` DATE COMMENT 'Date on which the environmental permit was officially issued by the regulatory authority. Marks the start of the permits legal validity and triggers compliance obligation timelines.. Valid values are `d{4}-d{2}-d{2}`',
    `issuing_authority_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the regulatory authority that issued the permit. Supports multi-national regulatory compliance management and jurisdiction identification.. Valid values are `[A-Z]{3}`',
    `issuing_authority_name` STRING COMMENT 'Name of the government agency or regulatory body that issued the environmental permit (e.g., U.S. EPA Region 5, California Air Resources Board, Environment Agency UK, German Federal Environment Agency).',
    `last_inspection_date` DATE COMMENT 'Date of the most recent regulatory inspection or compliance evaluation conducted by the issuing authority or third-party auditor for this permit. Supports inspection history tracking and compliance assurance.. Valid values are `d{4}-d{2}-d{2}`',
    `last_inspection_outcome` STRING COMMENT 'Result of the most recent regulatory inspection or compliance audit for this permit. Indicates whether the facility was found in compliance or if violations were identified, driving corrective action workflows.. Valid values are `compliant|minor_violation|major_violation|notice_of_violation|pending_review|not_inspected`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the environmental permit record. Supports change tracking, data lineage, and audit trail requirements for regulatory compliance documentation.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `major_source_flag` BOOLEAN COMMENT 'Indicates whether the facility is classified as a major source under the applicable regulatory program (e.g., major source under Title V of the Clean Air Act with potential to emit ≥100 tons/year of regulated pollutants). Major source designation triggers more stringent permit requirements.. Valid values are `true|false`',
    `monitoring_requirements_description` STRING COMMENT 'Description of the monitoring, measurement, and reporting requirements mandated by the permit, including monitoring frequency, measurement methods, and required instrumentation (e.g., continuous emissions monitoring systems, effluent sampling schedules).',
    `next_report_due_date` DATE COMMENT 'Date by which the next compliance report must be submitted to the regulatory authority under this permit. Used to trigger reporting workflow tasks and prevent missed reporting deadlines.. Valid values are `d{4}-d{2}-d{2}`',
    `open_violation_flag` BOOLEAN COMMENT 'Indicates whether there is currently an unresolved permit violation, notice of violation (NOV), or enforcement action associated with this permit. Triggers escalation workflows and compliance risk alerts.. Valid values are `true|false`',
    `permit_conditions_summary` STRING COMMENT 'Summary of key operational conditions, restrictions, and requirements imposed by the permit, including production rate limits, operating hour restrictions, fuel type restrictions, and best available control technology (BACT) requirements.',
    `permit_document_reference` STRING COMMENT 'Reference path, URL, or document management system identifier pointing to the official permit document, amendments, and supporting attachments stored in the enterprise document management system (e.g., Siemens Teamcenter PLM).',
    `permit_fee_amount` DECIMAL(18,2) COMMENT 'Annual or periodic fee amount payable to the regulatory authority for maintaining this environmental permit. Used for environmental compliance cost tracking and OPEX budgeting.',
    `permit_fee_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the permit fee amount. Supports multi-currency financial reporting for multinational operations.. Valid values are `[A-Z]{3}`',
    `permit_number` STRING COMMENT 'Official permit number assigned by the issuing regulatory authority. Used for regulatory correspondence, compliance tracking, and audit purposes.',
    `permit_term_years` STRING COMMENT 'Duration of the environmental permit in years as specified by the issuing regulatory authority. Used for renewal planning and permit lifecycle management (e.g., Title V permits are typically issued for 5-year terms).',
    `permit_type` STRING COMMENT 'Classification of the environmental permit by regulatory program. Determines the applicable regulatory framework, monitoring requirements, and reporting obligations (e.g., Title V for major air emission sources, NPDES for wastewater discharge, RCRA for hazardous waste management).. Valid values are `air_emission_title_v|air_emission_nsr|wastewater_npdes|stormwater|hazardous_waste_rcra|solid_waste|noise|water_withdrawal|greenhouse_gas|other`',
    `permitted_activity_description` STRING COMMENT 'Detailed description of the industrial activity, process, or operation authorized under this environmental permit. Defines the scope of permitted operations and is used to assess compliance with permit conditions.',
    `public_notice_required_flag` BOOLEAN COMMENT 'Indicates whether the permit or its renewal requires a public notice period, public comment period, or public hearing as mandated by the applicable regulatory program. Relevant for Title V, NPDES, and RCRA permits.. Valid values are `true|false`',
    `regulatory_program_code` STRING COMMENT 'Code identifying the specific regulatory program or framework under which this permit is issued (e.g., Title V, NPDES, RCRA, EU-ETS, IED). Enables cross-program compliance reporting and regulatory program analytics.',
    `renewal_status` STRING COMMENT 'Current status of the permit renewal process. Tracks the renewal lifecycle from initial submission through regulatory review to approval or denial, enabling proactive compliance management.. Valid values are `not_required|pending_submission|submitted|under_review|approved|denied|not_applicable`',
    `renewal_submission_date` DATE COMMENT 'Date on which the permit renewal application was submitted to the issuing regulatory authority. Tracked to ensure timely renewal submissions and to demonstrate regulatory good faith during the administrative continuance period.. Valid values are `d{4}-d{2}-d{2}`',
    `reporting_frequency` STRING COMMENT 'Frequency at which compliance reports must be submitted to the issuing regulatory authority as specified in the permit conditions. Drives automated reporting schedule management and compliance calendar.. Valid values are `daily|weekly|monthly|quarterly|semi_annual|annual|event_based|not_required`',
    `responsible_manager_name` STRING COMMENT 'Name of the internal manager or environmental compliance officer accountable for maintaining compliance with this permit. Business reference for accountability and escalation; not a direct personal identifier in the PII sense.',
    `status` STRING COMMENT 'Current lifecycle status of the environmental permit. Drives compliance monitoring workflows, renewal alerts, and regulatory reporting. Active permits require ongoing compliance; expired or suspended permits may trigger operational restrictions.. Valid values are `active|expired|suspended|revoked|pending_issuance|pending_renewal|under_review|withdrawn|terminated`',
    `title` STRING COMMENT 'Descriptive title or name of the environmental permit as issued by the regulatory authority or assigned internally for identification and reporting purposes.',
    `violation_count` STRING COMMENT 'Total number of documented permit violations or notices of violation (NOV) recorded against this permit during its current term. Used for compliance risk scoring and regulatory relationship management.',
    CONSTRAINT pk_environmental_permit PRIMARY KEY(`environmental_permit_id`)
) COMMENT 'Master records for all environmental operating permits held by manufacturing facilities including air emission permits (Title V, NSR), wastewater discharge permits (NPDES), stormwater permits, hazardous waste permits (RCRA), and noise permits. Captures permit type, issuing regulatory authority, permit number, facility, permitted activity scope, emission/discharge limits, monitoring requirements, permit issuance date, expiration date, and renewal status. SSOT for environmental permit compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` (
    `emission_monitoring_id` BIGINT COMMENT 'Unique system-generated identifier for each emission monitoring record in the lakehouse silver layer.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: Emission monitoring tracks specific pollutants/chemicals released to air, water, or noise media. cas_number in emission_monitoring is a denormalized reference to the chemical substance master. Adding ',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Emissions are tracked by production area/cost center for carbon accounting and potential carbon tax allocation. Required for environmental cost management and regulatory reporting.',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to hse.environmental_permit. Business justification: Emission monitoring is conducted under the conditions and limits specified in environmental permits. permit_number in emission_monitoring is a denormalized string reference that should be replaced wit',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Emissions are monitored from specific equipment (stacks, vents, boilers). Links emission data to equipment for permit compliance, maintenance impact analysis, and regulatory reporting.',
    `instrument_equipment_id` BIGINT COMMENT 'Identifier of the CEMS analyzer, portable analyzer, or sampling equipment used for the measurement, linking to calibration and maintenance records.',
    `measurement_point_id` BIGINT COMMENT 'Identifier for the specific emission monitoring point, stack, vent, outfall, or measurement location within the facility (e.g., Stack-01, Outfall-03).',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Emission monitoring relies on OT systems (SCADA, DCS, sensors) for real-time data collection. Environmental compliance requires tracking which OT system provides each emission measurement for audit tr',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Emissions are monitored per production plant for environmental permits. Each facility has specific emission limits and monitoring requirements based on local regulations and permit conditions.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Air emissions monitoring is facility-specific for regulatory compliance. Each warehouse with operations generating emissions requires tracking for EPA Title V permits and state air quality reporting.',
    `averaging_period` STRING COMMENT 'Time period over which the emission measurement is averaged or integrated, as required by the applicable permit condition or regulatory standard (e.g., hourly average for CEMS, annual total for TRI).. Valid values are `instantaneous|hourly|daily|weekly|monthly|quarterly|annual|rolling_30_day|rolling_12_month`',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether a corrective action or CAPA (Corrective and Preventive Action) has been initiated in response to an exceedance or data quality issue identified in this monitoring record.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the emission monitoring record was first created in the system, supporting audit trail and data lineage requirements.',
    `data_substitution_method` STRING COMMENT 'Method used to substitute missing or invalid CEMS data as required by EPA 40 CFR Part 75, such as 90th percentile substitution, averaging, or conservative estimate. Null if data is valid.. Valid values are `none|90th_percentile|average|conservative_estimate|permit_limit|prior_period_average`',
    `data_validity_flag` STRING COMMENT 'Quality status of the monitoring data indicating whether the measurement is valid, invalid (instrument malfunction), substitute (calculated replacement), missing, estimated, or quality-assured per EPA QA/QC protocols.. Valid values are `valid|invalid|substitute|missing|estimated|quality_assured`',
    `deviation_report_reference` STRING COMMENT 'Reference number of the regulatory deviation report submitted to the EPA or competent authority for this exceedance, enabling traceability between monitoring records and regulatory submissions.',
    `deviation_reported_flag` BOOLEAN COMMENT 'Indicates whether a regulatory deviation report has been submitted to the applicable authority (EPA, state agency, EU competent authority) for this exceedance event.. Valid values are `true|false`',
    `emission_medium` STRING COMMENT 'Environmental medium into which the emission is released: air (atmospheric emissions), water (effluent discharge), noise (acoustic emissions), or soil.. Valid values are `air|water|noise|soil`',
    `emission_source_type` STRING COMMENT 'Classification of the emission source as defined by EPA regulatory categories: point source (identifiable stack/vent), fugitive (uncontrolled releases), area source, mobile source, or non-point source.. Valid values are `point_source|fugitive_source|area_source|mobile_source|non_point_source`',
    `exceedance_flag` BOOLEAN COMMENT 'Indicates whether the measured emission value exceeded the applicable permit limit or regulatory threshold. True = exceedance detected, requiring deviation reporting and corrective action.. Valid values are `true|false`',
    `exceedance_percentage` DECIMAL(18,2) COMMENT 'Percentage by which the measured emission value exceeded the permit limit, calculated as ((measurement_value - permit_limit_value) / permit_limit_value) * 100. Null if no exceedance.',
    `facility_code` STRING COMMENT 'Unique code identifying the manufacturing facility or plant where the emission monitoring was conducted.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the emission monitoring was performed, supporting multinational regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `iso_14001_objective_reference` STRING COMMENT 'Reference to the ISO 14001 environmental objective or target that this monitoring record supports, enabling environmental performance evaluation and management review reporting.',
    `last_calibration_date` DATE COMMENT 'Date of the most recent calibration or quality assurance test performed on the monitoring instrument, required for data validity assessment and regulatory QA/QC compliance.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the emission monitoring record, supporting audit trail, data lineage, and change management requirements.',
    `measurement_value` DECIMAL(18,2) COMMENT 'Actual measured or calculated emission concentration, flow rate, or level for the monitored pollutant or parameter at the time of measurement.',
    `monitoring_date` DATE COMMENT 'Calendar date on which the emission monitoring was conducted, used for daily aggregation, permit compliance tracking, and regulatory reporting period alignment.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `monitoring_method` STRING COMMENT 'Method used to measure the emission: Continuous Emission Monitoring System (CEMS), manual stack test, Predictive Emissions Monitoring System (PEMS), effluent sampling, ambient air monitoring, noise measurement, mass balance calculation, or emission factor estimation.. Valid values are `CEMS|manual_stack_test|predictive_emissions_monitoring|effluent_sampling|ambient_air_monitoring|noise_measurement|mass_balance|emission_factor`',
    `monitoring_method_reference` STRING COMMENT 'Specific regulatory or technical standard reference for the monitoring method applied (e.g., EPA Method 6C, ISO 11564, EN 14181, ASTM D6348).',
    `monitoring_point_name` STRING COMMENT 'Descriptive name of the emission monitoring point or source location (e.g., Main Boiler Stack, Wastewater Effluent Outfall 1).',
    `monitoring_record_number` STRING COMMENT 'Human-readable business reference number for the emission monitoring record, used in regulatory submissions and deviation reports.. Valid values are `^EM-[0-9]{4}-[0-9]{6}$`',
    `monitoring_timestamp` TIMESTAMP COMMENT 'Date and time when the emission measurement was taken or the monitoring period ended, in ISO 8601 format with timezone offset. Critical for CEMS data and regulatory reporting.',
    `operating_condition` STRING COMMENT 'Operating condition of the emission source at the time of monitoring: normal operations, startup, shutdown, malfunction, maintenance, or process upset. Affects regulatory applicability of emission limits.. Valid values are `normal|startup|shutdown|malfunction|maintenance|upset`',
    `permit_condition_reference` STRING COMMENT 'Specific permit condition number or section reference that mandates this monitoring requirement (e.g., Condition 4.2.1, Section III.B), enabling traceability to permit obligations.',
    `permit_limit_unit` STRING COMMENT 'Unit of measure for the permit limit value, which may differ from the measurement unit and requires conversion for compliance comparison (e.g., annual tonnes vs. hourly mg/Nm3).',
    `permit_limit_value` DECIMAL(18,2) COMMENT 'Maximum allowable emission level or concentration as specified in the facilitys operating permit or regulatory standard for this pollutant and monitoring point.',
    `pollutant_code` STRING COMMENT 'Standardized regulatory code identifying the pollutant or parameter being monitored (e.g., EPA CAS number, EEA pollutant code for NOx, SO2, PM2.5, COD, BOD).',
    `pollutant_name` STRING COMMENT 'Full descriptive name of the pollutant or environmental parameter being monitored (e.g., Nitrogen Oxides, Sulfur Dioxide, Particulate Matter 2.5, Chemical Oxygen Demand, Total Suspended Solids).',
    `production_rate` DECIMAL(18,2) COMMENT 'Production throughput rate of the associated manufacturing process at the time of monitoring, used for emission factor calculations and production-normalized emission intensity reporting.',
    `production_rate_unit` STRING COMMENT 'Unit of measure for the production rate value (e.g., tonnes/hr, units/hr, MW, kg/hr), enabling emission intensity normalization.',
    `regulatory_reporting_period` STRING COMMENT 'Regulatory reporting period to which this monitoring record belongs (e.g., Q1-2024, 2024-Annual, 2024-H1), used for aggregating data into EPA, EU, or other regulatory submissions.',
    `regulatory_standard_reference` STRING COMMENT 'Applicable regulatory standard or rule that establishes the emission limit for this pollutant and source (e.g., EPA NSPS 40 CFR Part 60, NESHAP 40 CFR Part 63, EU IED BAT-AEL).',
    `sampled_by` STRING COMMENT 'Name or identifier of the person, team, or third-party contractor who conducted the emission sampling or measurement.',
    `stack_flow_rate` DECIMAL(18,2) COMMENT 'Volumetric or mass flow rate of the exhaust gas stream at the monitoring point, required for converting concentration measurements to mass emission rates (e.g., Nm3/hr, kg/hr).',
    `stack_flow_rate_unit` STRING COMMENT 'Unit of measure for the stack flow rate (e.g., Nm3/hr, m3/min, ACFM), required for mass emission rate calculations.',
    `unit_of_measure` STRING COMMENT 'Unit of measurement for the emission value (e.g., mg/Nm3, ppm, kg/hr, dB(A), mg/L, tonnes/year, lb/mmBtu).',
    `verified_by` STRING COMMENT 'Name or identifier of the qualified person who reviewed and verified the emission monitoring data for accuracy and regulatory compliance before submission.',
    CONSTRAINT pk_emission_monitoring PRIMARY KEY(`emission_monitoring_id`)
) COMMENT 'Continuous and periodic emission monitoring records for air, water, and noise emissions from manufacturing facilities. Captures monitoring point, pollutant or parameter, monitoring method (CEMS, manual stack test, effluent sampling), measurement value, unit of measure, permit limit, exceedance flag, monitoring date and time, and regulatory reporting period. Supports EPA compliance reporting, Title V deviation reporting, and ISO 14001 environmental performance evaluation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`waste_record` (
    `waste_record_id` BIGINT COMMENT 'Unique system-generated identifier for each waste generation, storage, treatment, or disposal transaction record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Waste disposal costs are allocated to the generating cost center. Finance uses this for environmental cost accounting and departmental P&L. Standard practice in manufacturing cost management.',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to hse.environmental_permit. Business justification: Waste generation, storage, and disposal activities are governed by environmental permits (e.g., RCRA permits, state waste permits). environmental_permit_number in waste_record is a denormalized string',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Waste generation is tracked by plant location for waste minimization programs, location-specific waste manifests, and environmental cost allocation.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Waste disposal services are procured from licensed suppliers. HSE tracks waste haulers as suppliers for regulatory compliance, manifests, and environmental reporting. Required for EPA/environmental au',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Waste generation is tracked by production plant for environmental compliance. Facilities must report waste quantities, types, and disposal methods to regulatory agencies per plant location.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Hazardous waste disposal requires tracking shipment to licensed disposal facilities. Environmental compliance mandates cradle-to-grave tracking with shipment manifests for regulatory audits and EPA re',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Waste generation records must track originating warehouse for EPA manifests, facility-level waste reporting, and environmental permit compliance. Required for hazardous waste tracking and regulatory a',
    `container_count` STRING COMMENT 'Number of containers holding the waste for this record. Required on the hazardous waste manifest and for inventory tracking.. Valid values are `^[0-9]+$`',
    `container_type` STRING COMMENT 'Type of container used to store or transport the waste. Required for manifest preparation and DOT transportation compliance.. Valid values are `drum|tote|bulk_tank|roll_off|bag|box|cylinder|other`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the waste record was first created in the system. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Code of the department or cost center responsible for generating the waste, used for internal cost allocation and waste minimization reporting.',
    `disposal_cost` DECIMAL(18,2) COMMENT 'Total cost incurred for waste disposal, treatment, or recycling services charged by the licensed waste contractor. Used for environmental cost accounting and waste minimization ROI analysis.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `disposal_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the disposal cost amount, supporting multinational financial reporting.. Valid values are `^[A-Z]{3}$`',
    `disposal_date` DATE COMMENT 'Date on which the waste was confirmed as disposed, treated, or recycled at the receiving facility. Used for RCRA biennial reporting and ISO 14001 performance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `disposal_facility_epa_code` STRING COMMENT 'EPA identification number of the receiving treatment, storage, or disposal facility (TSDF). Required on the hazardous waste manifest for regulatory tracking.. Valid values are `^[A-Z]{3}[0-9]{9}$`',
    `disposal_facility_name` STRING COMMENT 'Name of the licensed treatment, storage, or disposal facility (TSDF) receiving the waste for final treatment or disposal.',
    `disposal_method` STRING COMMENT 'Method used for final disposal or treatment of the waste. Supports waste minimization reporting and ISO 14001 environmental performance tracking.. Valid values are `landfill|incineration|recycling|treatment|fuel_blending|land_application|deep_well_injection|composting|energy_recovery|other`',
    `epa_waste_code` STRING COMMENT 'EPA hazardous waste code (e.g., D001, F003, K051, P030, U002) assigned per RCRA classification. Required for hazardous waste manifests and regulatory reporting.. Valid values are `^[A-Z][0-9]{3}$`',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the waste was generated, supporting multinational regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `generation_date` DATE COMMENT 'Date on which the waste was generated at the facility. Used for regulatory reporting periods and storage time compliance calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `generation_source` STRING COMMENT 'The specific process, operation, or department that generated the waste (e.g., CNC machining, painting line, chemical lab, maintenance shop). Supports waste minimization analysis.',
    `generator_category` STRING COMMENT 'EPA generator category classification based on monthly waste generation volume (LQG, SQG, VSQG). Determines applicable RCRA regulatory requirements and accumulation time limits.. Valid values are `large_quantity_generator|small_quantity_generator|very_small_quantity_generator`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the waste record. Supports audit trail requirements and data quality monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `manifest_number` STRING COMMENT 'Uniform Hazardous Waste Manifest document number assigned to the waste shipment. Required by RCRA for tracking hazardous waste from cradle to grave.',
    `ncr_reference` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) associated with this waste record, linking waste generation events to quality non-conformances or process deviations.',
    `physical_state` STRING COMMENT 'Physical state of the waste material at the time of generation. Required for manifest preparation and transportation classification.. Valid values are `solid|liquid|gas|sludge|mixed`',
    `quantity_generated` DECIMAL(18,2) COMMENT 'Amount of waste generated in the specified unit of measure. Used for regulatory threshold calculations, manifest preparation, and waste minimization tracking.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `quantity_unit` STRING COMMENT 'Unit of measure for the waste quantity (e.g., kg, lb, liter, gallon). Must align with manifest and regulatory reporting requirements.. Valid values are `kg|lb|ton|metric_ton|liter|gallon|cubic_meter|cubic_foot|unit`',
    `reach_regulated` BOOLEAN COMMENT 'Indicates whether the waste contains substances subject to EU REACH (Registration, Evaluation, Authorization and Restriction of Chemicals) regulation, requiring specific handling and reporting.. Valid values are `true|false`',
    `record_number` STRING COMMENT 'Human-readable business identifier for the waste record, used for cross-referencing in regulatory submissions, manifests, and internal tracking.. Valid values are `^WR-[A-Z0-9]{4}-[0-9]{6}$`',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special handling instructions, regulatory observations, or contextual information relevant to the waste record.',
    `reporting_period` STRING COMMENT 'Regulatory reporting period to which this waste record belongs (e.g., 2024-BIENNIAL, 2024-Q1). Used for RCRA biennial reporting and EPA waste minimization submissions.. Valid values are `^[0-9]{4}-(Q[1-4]|H[12]|ANNUAL|BIENNIAL)$`',
    `rohs_restricted` BOOLEAN COMMENT 'Indicates whether the waste contains substances restricted under EU RoHS (Restriction of Hazardous Substances) Directive, applicable to e-waste and electronic component waste streams.. Valid values are `true|false`',
    `shipment_date` DATE COMMENT 'Date on which the waste was shipped from the generating facility to the disposal or treatment facility. Used for manifest tracking and storage duration compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `state_waste_code` STRING COMMENT 'State-specific waste code assigned by the applicable state environmental agency, which may be more stringent than federal EPA codes.',
    `status` STRING COMMENT 'Current lifecycle status of the waste record, tracking the waste from generation through final disposition.. Valid values are `generated|in_storage|awaiting_pickup|in_transit|disposed|treated|recycled|closed|void`',
    `storage_location` STRING COMMENT 'Designated storage area or container location within the facility where the waste is held pending disposal (e.g., satellite accumulation area, 90-day storage area, drum storage bay).',
    `storage_start_date` DATE COMMENT 'Date on which the waste was placed into storage. Used to calculate storage duration and ensure compliance with RCRA accumulation time limits.. Valid values are `^d{4}-d{2}-d{2}$`',
    `un_hazard_class` STRING COMMENT 'United Nations hazard class number for the waste material per DOT/IATA dangerous goods regulations (e.g., Class 3 Flammable Liquid, Class 8 Corrosive). Required for transportation.. Valid values are `^[1-9](.[1-9])?$`',
    `waste_contractor_license` STRING COMMENT 'Regulatory license or permit number of the waste management contractor, confirming authorization to handle and transport the specific waste type.',
    `waste_contractor_name` STRING COMMENT 'Name of the licensed waste management contractor or transporter responsible for collecting, transporting, and disposing of the waste.',
    `waste_description` STRING COMMENT 'Detailed description of the waste material including chemical composition, physical state, and origin process. Required on hazardous waste manifests.',
    `waste_minimization_category` STRING COMMENT 'EPA waste minimization hierarchy category applied to this waste record, used for tracking progress toward waste reduction goals and EPA waste minimization program reporting.. Valid values are `source_reduction|recycling|treatment|disposal|energy_recovery`',
    `waste_type` STRING COMMENT 'High-level classification of the waste stream per EPA and international regulatory frameworks. Determines applicable regulatory requirements and handling procedures.. Valid values are `hazardous|non_hazardous|universal|e_waste|radioactive|mixed`',
    CONSTRAINT pk_waste_record PRIMARY KEY(`waste_record_id`)
) COMMENT 'Transactional records tracking generation, storage, treatment, and disposal of industrial waste streams at manufacturing facilities. Captures waste type (hazardous, non-hazardous, universal, e-waste), waste code (EPA/state), generation source, quantity generated, storage location, disposal method, licensed waste contractor, manifest number, disposal facility, and regulatory reporting period. Supports RCRA biennial reporting, EPA waste minimization, and ISO 14001 waste management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`energy_consumption` (
    `energy_consumption_id` BIGINT COMMENT 'Unique system-generated identifier for each energy consumption record in the lakehouse silver layer.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Energy consumption is tracked and charged to specific cost centers for utility cost allocation. Finance uses this monthly for departmental cost allocation and variance analysis.',
    `equipment_id` BIGINT COMMENT 'Identifier of the specific equipment or asset consuming energy, linking to the asset management system (Maximo EAM) for equipment-level energy performance analysis.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Energy consumption tracked by plant area for cost allocation, location-based energy targets, and facility-level carbon footprint reporting.',
    `measurement_point_id` BIGINT COMMENT 'Unique identifier of the energy meter or sub-metering point from which the consumption reading was captured. Supports granular sub-metering analysis.',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Energy consumption data is captured by OT systems (energy management systems, smart meters, PLCs). Tracking the source OT system ensures data accuracy and supports ISO 50001 compliance verification.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Energy consumption is measured per production plant for sustainability reporting and ISO 50001 compliance. Plant-level tracking enables energy efficiency initiatives and carbon footprint calculation.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Energy consumption tracking is warehouse-specific for ISO 50001 compliance, carbon footprint reporting, and facility-level energy management. Operations teams monitor this monthly for sustainability r',
    `baseline_consumption_gj` DECIMAL(18,2) COMMENT 'Reference baseline energy consumption in GJ for the same period and facility/meter, established per ISO 50001 energy baseline methodology. Used to calculate energy performance improvement.',
    `baseline_year` STRING COMMENT 'The reference year used to establish the energy consumption baseline for performance comparison, as defined in the ISO 50001 energy management plan.. Valid values are `^d{4}$`',
    `billing_period_end_date` DATE COMMENT 'End date of the energy billing or measurement period for which consumption is recorded. Used for utility invoice reconciliation and period-over-period analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `billing_period_start_date` DATE COMMENT 'Start date of the energy billing or measurement period for which consumption is recorded. Used for utility invoice reconciliation and period-over-period analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `carbon_emission_factor` DECIMAL(18,2) COMMENT 'Emission factor applied to convert energy consumption to CO2 equivalent emissions, expressed in kg CO2e per unit of energy. Sourced from national grid emission factors or supplier-specific data.',
    `carbon_emission_factor_source` STRING COMMENT 'Source or authority from which the carbon emission factor was derived, ensuring traceability and auditability of GHG calculations for regulatory reporting.. Valid values are `epa_egrid|iea|defra|national_grid|supplier_specific|ipcc|custom`',
    `co2e_emissions_kg` DECIMAL(18,2) COMMENT 'Calculated CO2 equivalent emissions in kilograms resulting from the energy consumption, derived by multiplying consumption quantity (in GJ) by the carbon emission factor. Supports carbon footprint reporting and Scope 1/2 GHG inventory.',
    `consumption_quantity` DECIMAL(18,2) COMMENT 'Measured quantity of energy consumed during the billing or measurement period, expressed in the unit of measure specified in the uom field.',
    `consumption_quantity_gj` DECIMAL(18,2) COMMENT 'Energy consumption quantity normalized to Gigajoules (GJ) for cross-source comparability, carbon accounting, and ISO 50001 energy performance indicator reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the energy consumption record was first created in the system, supporting audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the energy cost amount, supporting multinational financial reporting (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `data_quality_flag` STRING COMMENT 'Quality classification of the consumption data indicating whether the value is an actual meter reading, an estimate, an interpolated value, a substituted value, or flagged as erroneous.. Valid values are `actual|estimated|interpolated|substituted|erroneous`',
    `department_code` STRING COMMENT 'Code of the department or cost center responsible for the energy consumption, enabling departmental OPEX energy cost allocation.',
    `energy_cost` DECIMAL(18,2) COMMENT 'Total monetary cost of energy consumed during the billing period, in the transaction currency. Supports OPEX energy cost tracking and budget variance analysis.',
    `energy_source_subtype` STRING COMMENT 'Further classification of the energy source, such as grid electricity, renewable electricity (on-site solar), or pipeline natural gas, enabling granular carbon accounting.',
    `energy_source_type` STRING COMMENT 'Type of energy source consumed, such as electricity, natural gas, compressed air, steam, or diesel. Drives carbon emission factor selection and cost allocation.. Valid values are `electricity|natural_gas|compressed_air|steam|diesel|lpg|fuel_oil|coal|biomass|solar|wind|chilled_water|hot_water|other`',
    `facility_code` STRING COMMENT 'Unique code identifying the manufacturing facility or plant where energy consumption was recorded. Aligns with SAP S/4HANA plant codes.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where energy consumption was recorded, supporting multinational regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `ghg_scope` STRING COMMENT 'GHG Protocol scope classification for the energy-related emissions: Scope 1 (direct combustion), Scope 2 location-based, Scope 2 market-based (using supplier-specific factors), or Scope 3.. Valid values are `scope_1|scope_2_location_based|scope_2_market_based|scope_3`',
    `invoice_reference` STRING COMMENT 'Reference number of the utility invoice associated with this energy consumption record, enabling financial reconciliation with SAP S/4HANA accounts payable.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the energy consumption record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `measurement_interval` STRING COMMENT 'Frequency or granularity of the energy measurement interval, such as 15-minute interval data from smart meters or monthly billing data from utility invoices.. Valid values are `15_min|30_min|hourly|daily|weekly|monthly|quarterly|annual`',
    `meter_name` STRING COMMENT 'Descriptive name or label of the energy meter or sub-metering point, such as Assembly Line 3 Main Feed or Compressor Room Sub-Meter.',
    `meter_type` STRING COMMENT 'Classification of the metering point indicating whether it is a main utility meter, a sub-meter for a specific area or equipment, a check meter for validation, or a virtual/calculated meter.. Valid values are `main_meter|sub_meter|check_meter|virtual_meter`',
    `reading_timestamp` TIMESTAMP COMMENT 'Exact date and time when the energy meter reading was captured, supporting interval-level analysis and IIoT integration via Siemens MindSphere.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `rec_certificate_number` STRING COMMENT 'Reference number of the Renewable Energy Certificate (REC) or Guarantee of Origin (GoO) associated with the renewable energy consumed, enabling market-based Scope 2 accounting.',
    `record_number` STRING COMMENT 'Human-readable business reference number for the energy consumption record, used for cross-system referencing and audit trails.. Valid values are `^EC-[0-9]{4}-[0-9]{6}$`',
    `relevant_variable` STRING COMMENT 'The primary relevant variable (e.g., production volume, operating hours, degree days) used to normalize energy consumption for EnPI calculation per ISO 50001, enabling fair period-over-period comparison.',
    `relevant_variable_uom` STRING COMMENT 'Unit of measure for the relevant variable value, such as units, hours, tonnes, or degree-days, ensuring dimensional consistency in EnPI calculations.',
    `relevant_variable_value` DECIMAL(18,2) COMMENT 'Numeric value of the relevant variable (e.g., units produced, operating hours) for the measurement period, used to normalize energy consumption and calculate the Energy Performance Indicator (EnPI).',
    `renewable_energy_flag` BOOLEAN COMMENT 'Indicates whether the energy consumed is sourced from renewable energy (e.g., backed by Renewable Energy Certificates or Power Purchase Agreements), supporting sustainability reporting.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current workflow status of the energy consumption record, tracking its progression from initial data capture through validation, approval, and archival.. Valid values are `draft|submitted|validated|approved|rejected|archived`',
    `unit_rate` DECIMAL(18,2) COMMENT 'Cost per unit of energy consumed (e.g., cost per kWh or cost per m3), used for tariff analysis, supplier benchmarking, and energy procurement decisions.',
    `uom` STRING COMMENT 'Unit of measure for the energy consumption quantity, such as kWh for electricity, m3 for natural gas, or kg for LPG. Ensures dimensional consistency across energy sources.. Valid values are `kWh|MWh|GJ|MJ|m3|Nm3|kg|MMBtu|therms|kVAh|ton`',
    `utility_account_number` STRING COMMENT 'Utility provider account number associated with the energy supply for the facility or meter point, used for invoice reconciliation and supplier management.',
    `utility_provider_name` STRING COMMENT 'Name of the energy utility provider or supplier for the metered point, supporting supplier performance tracking and procurement analysis.',
    `work_area` STRING COMMENT 'Specific work area, production zone, or building section within the facility where energy was consumed, such as Paint Shop, CNC Machining Bay, or Warehouse A.',
    CONSTRAINT pk_energy_consumption PRIMARY KEY(`energy_consumption_id`)
) COMMENT 'Facility and equipment-level energy consumption records tracking electricity, natural gas, compressed air, steam, and other energy sources across manufacturing plants. Captures energy source type, facility and sub-metering point, consumption quantity, unit of measure, billing period, cost, carbon emission factor, calculated CO2e emissions, and baseline comparison. Supports ISO 50001 energy management, carbon footprint reporting, and OPEX energy cost tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`energy_target` (
    `energy_target_id` BIGINT COMMENT 'Unique system-generated identifier for each ISO 50001 energy performance target or objective record.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the person accountable for achieving this energy performance target, used for HR system cross-referencing and accountability tracking.',
    `achievement_percentage` DECIMAL(18,2) COMMENT 'Most recently recorded percentage of the energy target achieved relative to the baseline, calculated at the last review date. Expressed as a percentage (e.g., 72.50 means 72.5% of target achieved). This is a point-in-time recorded value, not a real-time computed metric.',
    `action_plan_reference` STRING COMMENT 'Reference number or identifier of the energy management action plan (EAP) associated with this target, linking the target to specific improvement projects, initiatives, and resource allocations.',
    `approval_date` DATE COMMENT 'Date on which this energy performance target was formally approved by management, establishing the official start of the target commitment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Name of the management representative or energy management team leader who formally approved this energy performance target, as required by ISO 50001 top management commitment.',
    `baseline_period_end_date` DATE COMMENT 'End date of the energy baseline period. Together with baseline_period_start_date, defines the reference interval for energy performance comparison.. Valid values are `^d{4}-d{2}-d{2}$`',
    `baseline_period_start_date` DATE COMMENT 'Start date of the energy baseline period against which target performance is measured. The baseline establishes the reference energy consumption level for calculating improvement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `baseline_value` DECIMAL(18,2) COMMENT 'Measured energy consumption or intensity value during the baseline period, expressed in the same unit as target_unit. Serves as the reference point for calculating target achievement percentage.',
    `change_reason` STRING COMMENT 'Documented justification for any revision to this energy target, such as changes in production volume, facility scope, regulatory requirements, or management review decisions. Required for ISO 50001 documented information control.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this energy target record was first created in the system, used for audit trail, data lineage, and ISO 50001 documented information management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated_cost_savings and investment_amount fields, supporting multinational financial reporting (e.g., USD, EUR, GBP, CNY).. Valid values are `^[A-Z]{3}$`',
    `department_code` STRING COMMENT 'Code identifying the specific department or cost center responsible for the energy target, used for accountability assignment and departmental energy performance reporting.',
    `description` STRING COMMENT 'Detailed narrative describing the energy performance target, its rationale, scope, and expected outcomes in support of the energy policy.',
    `energy_source` STRING COMMENT 'Type of energy source to which this target applies, such as electricity, natural gas, diesel, steam, compressed air, chilled water, renewable electricity, biomass, or hydrogen. All indicates the target covers total energy consumption.. Valid values are `electricity|natural_gas|diesel|steam|compressed_air|chilled_water|renewable_electricity|biomass|hydrogen|all`',
    `enpi_name` STRING COMMENT 'Name of the Energy Performance Indicator (EnPI) used to measure and track progress toward this target, such as Specific Energy Consumption (SEC), Energy Intensity Ratio (EIR), or Total Site Energy Use.',
    `ensu_name` STRING COMMENT 'Name of the Energy-Significant Use (EnSU) to which this target applies, such as HVAC systems, compressed air, CNC machining centers, furnaces, or lighting, as identified in the energy review.',
    `estimated_cost_savings` DECIMAL(18,2) COMMENT 'Projected financial savings (in the reporting currency) expected to be realized upon full achievement of this energy target, used for business case justification and CAPEX/OPEX investment decisions.',
    `facility_code` STRING COMMENT 'Unique code identifying the manufacturing facility or site responsible for achieving this energy performance target, aligned with the organizational asset hierarchy.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the energy target applies, supporting multinational regulatory compliance and regional energy reporting.. Valid values are `^[A-Z]{3}$`',
    `investment_amount` DECIMAL(18,2) COMMENT 'Capital or operational expenditure (CAPEX/OPEX) budgeted or approved to implement the energy improvement actions required to achieve this target.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this energy target record, supporting change tracking, data governance, and ISO 50001 documented information control requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_review_date` DATE COMMENT 'Date on which the most recent formal progress review of this energy target was conducted, as part of the ISO 50001 management review or energy performance monitoring cycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `management_review_cycle` STRING COMMENT 'Reference to the ISO 50001 management review cycle (e.g., MR-2024-Q4) in which this energy target was last presented, supporting traceability of top management decisions and continual improvement inputs.',
    `measurement_boundary` STRING COMMENT 'Organizational or physical boundary within which energy consumption is measured and the target applies, such as a specific facility, production line, department, individual equipment, building, campus, or enterprise-wide scope.. Valid values are `facility|production_line|department|equipment|building|campus|enterprise|process`',
    `regulatory_requirement` STRING COMMENT 'Reference to any applicable regulatory or legal obligation driving this energy target, such as EU Energy Efficiency Directive, EPA Energy Star requirements, local carbon tax legislation, or national energy reduction mandates.',
    `relevant_variable` STRING COMMENT 'Key variable that significantly affects energy consumption for this target boundary, such as production volume (units/day), occupancy rate, operating hours, or ambient temperature. Used for energy performance indicator (EnPI) normalization.',
    `responsible_owner_name` STRING COMMENT 'Full name of the individual (energy manager, facility manager, or department head) accountable for achieving this energy performance target.',
    `review_frequency` STRING COMMENT 'Frequency at which progress toward this energy performance target is formally reviewed, supporting ISO 50001 management review requirements and continuous improvement cycles.. Valid values are `monthly|quarterly|semi_annual|annual`',
    `status` STRING COMMENT 'Current lifecycle and achievement status of the energy performance target. Drives management review inputs, escalation workflows, and ISO 50001 continual improvement reporting.. Valid values are `draft|active|on_track|at_risk|behind|achieved|not_achieved|cancelled|superseded`',
    `target_category` STRING COMMENT 'Business category of the energy target indicating whether it is a long-term strategic objective, operational improvement target, tactical short-term goal, regulatory compliance requirement, or voluntary commitment (e.g., RE100, Science Based Targets).. Valid values are `strategic|operational|tactical|regulatory|voluntary`',
    `target_end_date` DATE COMMENT 'Deadline by which the energy performance target must be achieved. Used for management review scheduling, action plan milestones, and ISO 50001 audit assessments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `target_number` STRING COMMENT 'Human-readable business reference number for the energy performance target, used in management reviews, action plans, and ISO 50001 audit documentation.. Valid values are `^ENT-[0-9]{4}-[0-9]{5}$`',
    `target_start_date` DATE COMMENT 'Start date of the period during which the energy performance target is active and energy performance is being tracked toward the goal.. Valid values are `^d{4}-d{2}-d{2}$`',
    `target_type` STRING COMMENT 'Classification of the energy performance target by its measurement approach: absolute reduction (fixed kWh/GJ reduction), intensity improvement (energy per unit of production), renewable energy increase, efficiency improvement, consumption cap, or carbon reduction.. Valid values are `absolute_reduction|intensity_improvement|renewable_increase|efficiency_improvement|consumption_cap|carbon_reduction`',
    `target_unit` STRING COMMENT 'Unit of measurement for the target value, such as kWh, MWh, GJ for absolute targets; kWh/unit or GJ/tonne for intensity targets; percent for improvement targets; or tCO2e for carbon-equivalent targets.. Valid values are `kWh|MWh|GWh|GJ|TJ|MJ|kWh/unit|GJ/tonne|kWh/m2|kWh/hour|percent|tCO2e|kgCO2e`',
    `target_value` DECIMAL(18,2) COMMENT 'Numeric value of the energy performance target to be achieved by the target end date. Interpretation depends on target_type: for absolute reduction, this is the reduction amount; for intensity improvement, this is the intensity ratio; for consumption cap, this is the maximum allowed consumption.',
    `title` STRING COMMENT 'Short descriptive title of the energy performance target or objective (e.g., Reduce compressed air energy intensity by 15% by 2026).',
    `version_number` STRING COMMENT 'Sequential version number of this energy target record, incremented when the target is revised due to scope changes, baseline adjustments, or management review outcomes. Supports audit trail and change history.. Valid values are `^[1-9][0-9]*$`',
    `voluntary_commitment` STRING COMMENT 'Reference to any voluntary sustainability commitment or initiative this target supports, such as Science Based Targets initiative (SBTi), RE100, CDP Climate Disclosure, or corporate net-zero pledge.',
    CONSTRAINT pk_energy_target PRIMARY KEY(`energy_target_id`)
) COMMENT 'ISO 50001 energy performance targets and objectives set for manufacturing facilities, production lines, and energy-significant uses (EnSUs). Captures target type (absolute reduction, intensity improvement), baseline period, target value, target unit, measurement boundary, responsible facility or department, target period start and end dates, and achievement status. Drives energy management action plans and ISO 50001 management review inputs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` (
    `regulatory_obligation_id` BIGINT COMMENT 'Unique system-generated identifier for each regulatory obligation record in the master registry.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: Regulatory obligations apply to specific legal entities with jurisdiction-specific requirements. Essential for compliance management and legal liability tracking across manufacturing operations.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: HSE obligations derive from master regulatory requirements managed by compliance. Compliance teams maintain single source of truth for regulatory text and updates across all domains.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the individual accountable for compliance with this obligation, used for system linkage to HR and workforce records.',
    `applicable_facility_scope` STRING COMMENT 'Defines whether this obligation applies to all manufacturing facilities globally, a specific facility, a type of facility, a specific process, or a specific product line.. Valid values are `ALL_FACILITIES|SPECIFIC_FACILITY|FACILITY_TYPE|PROCESS_SPECIFIC|PRODUCT_SPECIFIC`',
    `applicable_process_area` STRING COMMENT 'Specific manufacturing process, shop floor area, or operational activity to which this obligation applies, such as Chemical Storage, Welding Operations, or Wastewater Treatment.',
    `applicable_standard` STRING COMMENT 'The primary industry or regulatory standard to which this obligation is aligned, such as ISO 14001, ISO 45001, ISO 50001, OSHA, EPA, EU REACH, RoHS, or CE Marking.. Valid values are `ISO_9001|ISO_14001|ISO_45001|ISO_50001|IEC_61131|IEC_62443|OSHA|EPA|REACH|RoHS|CE_MARKING|UL|NIST|ANSI|GAAP|IFRS|OTHER`',
    `chemical_substance_flag` BOOLEAN COMMENT 'Indicates whether this regulatory obligation pertains to chemical substance management, including REACH registration, RoHS restricted substances, or hazardous chemical handling under OSHA HazCom.. Valid values are `true|false`',
    `compliance_frequency` STRING COMMENT 'How often the compliance activity (reporting, inspection, monitoring, training, etc.) must be performed to satisfy this regulatory obligation.. Valid values are `ONE_TIME|DAILY|WEEKLY|MONTHLY|QUARTERLY|SEMI_ANNUAL|ANNUAL|BIENNIAL|AS_REQUIRED|CONTINUOUS`',
    `compliance_requirement_summary` STRING COMMENT 'Concise summary of what the organization must do to comply with this obligation, including key actions, thresholds, frequencies, or documentation requirements.',
    `compliance_status` STRING COMMENT 'Current compliance posture of the organization against this regulatory obligation, as determined by the most recent compliance evaluation or audit.. Valid values are `COMPLIANT|NON_COMPLIANT|PARTIALLY_COMPLIANT|NOT_ASSESSED|IN_PROGRESS|WAIVED`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this regulatory obligation record was first created in the system, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed narrative describing the specific compliance requirement, legal obligation, or regulatory standard and what it mandates for manufacturing operations.',
    `expiry_date` DATE COMMENT 'The date on which this regulatory obligation expires, is scheduled for sunset, or is no longer applicable. Null if the obligation is ongoing with no defined end date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `facility_code` STRING COMMENT 'Site or facility identifier to which this regulatory obligation is specifically scoped, when the obligation applies to a particular manufacturing site rather than all facilities.',
    `issuing_authority` STRING COMMENT 'The regulatory body or authority that issued or enforces the obligation, such as OSHA, EPA, EU Commission, IEC, ISO, ANSI, or NIST.. Valid values are `OSHA|EPA|EU_COMMISSION|IEC|ISO|ANSI|NIST|UL|LOCAL_AUTHORITY|STATE_AGENCY|OTHER`',
    `jurisdiction_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary country where this regulatory obligation applies, e.g., USA, DEU, GBR, CHN.. Valid values are `^[A-Z]{3}$`',
    `jurisdiction_level` STRING COMMENT 'The level of governmental or regulatory jurisdiction applicable to this obligation — federal, state/provincial, local/municipal, supranational (e.g., EU), or international.. Valid values are `FEDERAL|STATE|LOCAL|SUPRANATIONAL|INTERNATIONAL`',
    `jurisdiction_state_province` STRING COMMENT 'State, province, or regional subdivision where the obligation applies, for obligations that are sub-national in scope (e.g., California OSHA, Texas TCEQ).',
    `last_compliance_date` DATE COMMENT 'The date on which the most recent compliance activity was completed or evaluated for this obligation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this regulatory obligation record, supporting change tracking and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_review_date` DATE COMMENT 'The date on which this regulatory obligation record was last reviewed for accuracy, currency, and continued applicability as part of the legal compliance evaluation process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `max_penalty_amount` DECIMAL(18,2) COMMENT 'Maximum monetary fine or penalty that can be levied by the regulatory authority for non-compliance with this obligation, expressed in the applicable currency.',
    `next_compliance_due_date` DATE COMMENT 'The upcoming deadline by which the next compliance action (report submission, inspection, renewal, training, etc.) must be completed for this obligation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this regulatory obligation to assess continued applicability, regulatory changes, and compliance posture.. Valid values are `^d{4}-d{2}-d{2}$`',
    `obligation_category` STRING COMMENT 'HSE domain category of the obligation, classifying it under occupational health and safety, environmental management, chemical hazard management, emissions, waste, energy, or product compliance.. Valid values are `OCCUPATIONAL_HEALTH_SAFETY|ENVIRONMENTAL|CHEMICAL_HAZARD|EMISSIONS|WASTE_MANAGEMENT|ENERGY|PRODUCT_COMPLIANCE|FIRE_SAFETY|PROCESS_SAFETY|ERGONOMICS|OTHER`',
    `obligation_number` STRING COMMENT 'Human-readable unique reference number assigned to the regulatory obligation for tracking and cross-referencing across HSE systems and compliance reports.. Valid values are `^REG-[A-Z]{2,6}-[0-9]{4}-[0-9]{4}$`',
    `obligation_type` STRING COMMENT 'Classification of the type of regulatory obligation, indicating whether it requires a permit, periodic reporting, employee training, inspection, record-keeping, labeling, substance registration, certification, or ongoing monitoring.. Valid values are `PERMIT|REPORTING|TRAINING|INSPECTION|RECORD_KEEPING|LABELING|REGISTRATION|CERTIFICATION|MONITORING|STANDARD_COMPLIANCE|OTHER`',
    `penalty_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the currency in which the maximum penalty amount is denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `penalty_for_non_compliance` STRING COMMENT 'Description of the legal, financial, or operational penalties that may be imposed for failure to comply with this obligation, including fines, permit revocation, or operational shutdown.',
    `permit_reference_number` STRING COMMENT 'Reference number of the environmental or operational permit associated with this regulatory obligation, when a permit is required for compliance.',
    `permit_required` BOOLEAN COMMENT 'Indicates whether compliance with this obligation requires obtaining and maintaining a regulatory permit, license, or authorization (e.g., air emission permit, wastewater discharge permit).. Valid values are `true|false`',
    `regulation_code` STRING COMMENT 'Official code or citation of the regulation, such as 29 CFR 1910.1200, 40 CFR Part 112, or EC No 1907/2006, used for precise legal referencing.',
    `regulation_name` STRING COMMENT 'Full official name of the regulation, directive, or standard from which this obligation derives, e.g., Occupational Safety and Health Act, EU RoHS Directive 2011/65/EU.',
    `reporting_required` BOOLEAN COMMENT 'Indicates whether this obligation requires periodic or event-triggered regulatory reporting submissions to the issuing authority (e.g., annual emissions report, OSHA 300 log submission).. Valid values are `true|false`',
    `responsible_department` STRING COMMENT 'Organizational department or business unit responsible for managing and maintaining compliance with this regulatory obligation (e.g., HSE, Legal, Engineering, Operations).',
    `source_system` STRING COMMENT 'Operational system of record from which this regulatory obligation data was sourced or ingested, supporting data lineage and traceability in the lakehouse.. Valid values are `SAP_S4HANA|MANUAL|REGULATORY_DATABASE|LEGAL_TRACKER|OTHER`',
    `standard_clause_reference` STRING COMMENT 'Specific clause, section, or article number within the applicable standard or regulation that this obligation corresponds to, e.g., ISO 14001:2015 Clause 6.1.3 or OSHA 29 CFR 1910.1200(h).',
    `status` STRING COMMENT 'Current lifecycle status of the regulatory obligation record, indicating whether it is actively enforced, under review for updates, superseded by a newer regulation, or pending an effective date.. Valid values are `ACTIVE|INACTIVE|UNDER_REVIEW|SUPERSEDED|PENDING_EFFECTIVE|EXPIRED`',
    `title` STRING COMMENT 'Short descriptive title of the regulatory obligation, such as OSHA Hazard Communication Standard or EU REACH Substance Registration.',
    `version_number` STRING COMMENT 'Version number of this regulatory obligation record, incremented when the regulation is updated, amended, or when the compliance requirement summary is revised.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_regulatory_obligation PRIMARY KEY(`regulatory_obligation_id`)
) COMMENT 'Master registry of all applicable HSE regulatory requirements, legal obligations, and compliance standards binding on manufacturing operations. Captures regulation name, issuing authority (OSHA, EPA, EU REACH, RoHS, CE), jurisdiction (federal, state, local, EU), applicable facility or process scope, compliance requirement summary, compliance due date or frequency, responsible owner, and current compliance status. Supports ISO 14001 and ISO 45001 legal compliance evaluation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` (
    `compliance_evaluation_id` BIGINT COMMENT 'Unique system-generated identifier for each compliance evaluation record within the HSE compliance management system.',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to hse.environmental_permit. Business justification: Compliance evaluations frequently assess adherence to conditions specified in environmental permits. permit_reference in compliance_evaluation is a denormalized string reference that should be replace',
    `employee_id` BIGINT COMMENT 'Employee identifier of the internal evaluator conducting the compliance evaluation, used for accountability tracking and workload reporting. Null if the evaluator is external.',
    `hse_capa_id` BIGINT COMMENT 'Foreign key linking to hse.capa. Business justification: When a compliance evaluation identifies non-conformances, a CAPA is initiated to address the gap. capa_reference_number in compliance_evaluation is a denormalized string reference that should be repla',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: HSE compliance evaluations assess conformance to obligations defined in compliance system. Auditors evaluate HSE performance against centrally-managed obligation requirements during assessments.',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to hse.regulatory_obligation. Business justification: Compliance evaluations assess adherence to specific regulatory obligations. regulatory_obligation_reference is a denormalized string reference that should be replaced with a proper FK regulatory_oblig',
    `applicable_standard_clause` STRING COMMENT 'Specific clause, section, or article of the applicable standard or regulation being evaluated (e.g., ISO 14001 Clause 9.1.2, ISO 45001 Clause 9.1.2, OSHA 1910.147).',
    `approval_date` DATE COMMENT 'Date on which the compliance evaluation record was formally reviewed and approved by the authorized HSE manager or compliance officer.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Full name of the HSE manager, compliance officer, or authorized person who reviewed and approved the compliance evaluation record and its findings.',
    `closure_date` DATE COMMENT 'Date on which the compliance evaluation record was formally closed, indicating that all findings have been addressed, follow-up actions completed, and the record is archived.. Valid values are `^d{4}-d{2}-d{2}$`',
    `compliance_status` STRING COMMENT 'Overall compliance determination resulting from the evaluation, indicating whether the facility or process is fully compliant, partially compliant, non-compliant, not applicable, or pending verification against the applicable regulatory obligation.. Valid values are `compliant|partially_compliant|non_compliant|not_applicable|pending_verification`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the compliance evaluation record was first created in the system, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Code identifying the specific department or organizational unit within the facility that is the subject of the compliance evaluation, enabling department-level compliance tracking.',
    `evaluation_date` DATE COMMENT 'The date on which the compliance evaluation was conducted or the evaluation period ended. Used for scheduling, trend analysis, and regulatory reporting timelines.. Valid values are `^d{4}-d{2}-d{2}$`',
    `evaluation_method` STRING COMMENT 'The methodology used to conduct the compliance evaluation, such as document review, physical site inspection, environmental or safety monitoring data review, personnel interviews, or a combination of methods.. Valid values are `document_review|site_inspection|monitoring_data_review|interview|sampling|combined`',
    `evaluation_number` STRING COMMENT 'Human-readable business reference number for the compliance evaluation, used for tracking and cross-referencing in reports and regulatory submissions.. Valid values are `^CE-[0-9]{4}-[0-9]{6}$`',
    `evaluation_period_end_date` DATE COMMENT 'End date of the compliance evaluation period or review window, defining the temporal scope of data and evidence reviewed during the evaluation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `evaluation_period_start_date` DATE COMMENT 'Start date of the compliance evaluation period or review window, defining the temporal scope of data and evidence reviewed during the evaluation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `evaluation_type` STRING COMMENT 'Classification of the evaluation by its trigger or frequency, distinguishing between scheduled periodic evaluations, event-triggered evaluations, initial assessments, follow-up reviews, and regulatory inspections.. Valid values are `periodic|triggered|initial|follow_up|regulatory_inspection`',
    `evaluator_name` STRING COMMENT 'Full name of the person or lead evaluator responsible for conducting the compliance evaluation. May be an internal HSE officer or an external regulatory inspector.',
    `evaluator_type` STRING COMMENT 'Indicates whether the compliance evaluation was conducted by an internal HSE team member, an external third-party auditor, or a regulatory authority inspector.. Valid values are `internal|external|regulatory_authority`',
    `evidence_reference` STRING COMMENT 'Reference to objective evidence reviewed during the evaluation, such as document numbers, permit IDs, monitoring records, inspection reports, or test certificates that substantiate the compliance determination.',
    `facility_code` STRING COMMENT 'Unique code identifying the manufacturing facility or site where the compliance evaluation was conducted, aligning with the enterprise facility master data.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the evaluated facility is located, supporting multi-national regulatory compliance tracking and jurisdiction-specific reporting.. Valid values are `^[A-Z]{3}$`',
    `facility_name` STRING COMMENT 'Name of the manufacturing facility or site where the compliance evaluation was conducted, used for reporting and communication purposes.',
    `findings_summary` STRING COMMENT 'Narrative summary of the key findings from the compliance evaluation, including observed gaps, areas of concern, and evidence reviewed. Mandatory under ISO 14001 and ISO 45001 compliance obligation evaluation requirements.',
    `follow_up_action_required` BOOLEAN COMMENT 'Indicates whether the compliance evaluation identified findings that require follow-up corrective or preventive actions. Drives CAPA initiation and management review inputs.. Valid values are `true|false`',
    `follow_up_due_date` DATE COMMENT 'Target date by which follow-up corrective actions or remediation activities identified during the compliance evaluation must be completed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `iso_standard_reference` STRING COMMENT 'Identifies the specific ISO or IEC management system standard under which this compliance evaluation is being conducted, enabling filtering and reporting by certification scope.. Valid values are `ISO_14001|ISO_45001|ISO_50001|ISO_9001|IEC_62443|OTHER`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the compliance evaluation record, supporting change tracking, audit trail requirements, and incremental data loading in the Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `management_review_input` BOOLEAN COMMENT 'Indicates whether the results of this compliance evaluation have been included as an input to the management review process, as required by ISO 14001 Clause 9.3 and ISO 45001 Clause 9.3.. Valid values are `true|false`',
    `next_evaluation_date` DATE COMMENT 'Scheduled date for the next periodic compliance evaluation of the same regulatory obligation and facility scope, supporting proactive compliance calendar management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `non_conformance_description` STRING COMMENT 'Detailed description of identified non-conformances or compliance gaps found during the evaluation, specifying the nature of the deviation from the regulatory obligation or standard requirement.',
    `obligation_category` STRING COMMENT 'High-level category of the regulatory obligation being evaluated, enabling grouping and trend analysis across HSE compliance domains such as environmental, occupational health and safety, energy management, or chemical hazard management.. Valid values are `environmental|occupational_health_safety|energy_management|chemical_hazard|emissions|waste_management|product_compliance|process_safety|fire_safety|electrical_safety|ergonomics|other`',
    `process_area` STRING COMMENT 'Specific process area, work area, or functional zone within the facility that is the subject of the compliance evaluation (e.g., paint shop, assembly line, chemical storage, wastewater treatment).',
    `regulatory_body` STRING COMMENT 'The governing body or standards organization that issued the regulatory obligation or legal requirement being evaluated, such as OSHA, EPA, ISO, IEC, or local regulatory authority.. Valid values are `OSHA|EPA|ISO|IEC|ANSI|EU_CE|REACH|RoHS|NIST|UL|LOCAL_AUTHORITY|OTHER`',
    `regulatory_notification_date` DATE COMMENT 'Date on which the regulatory authority was notified of compliance findings or non-conformances identified during the evaluation, as required by applicable regulations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulatory_notification_required` BOOLEAN COMMENT 'Indicates whether the compliance evaluation findings require mandatory notification to a regulatory authority (e.g., OSHA, EPA, local environmental agency) within a prescribed timeframe.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this compliance evaluation record originated, supporting data lineage and integration traceability in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|SIEMENS_OPCENTER|MAXIMO|MANUAL|OTHER`',
    `status` STRING COMMENT 'Current lifecycle status of the compliance evaluation record, indicating whether it is planned, actively being conducted, completed, cancelled, or overdue.. Valid values are `planned|in_progress|completed|cancelled|overdue`',
    `title` STRING COMMENT 'Descriptive title summarizing the scope and subject of the compliance evaluation, used for identification in reports and dashboards.',
    CONSTRAINT pk_compliance_evaluation PRIMARY KEY(`compliance_evaluation_id`)
) COMMENT 'Periodic compliance evaluation records assessing Manufacturings adherence to applicable HSE regulatory obligations and legal requirements. Captures evaluation date, regulatory obligation reference, facility scope, evaluation method (document review, site inspection, monitoring data review), compliance status (compliant, partially compliant, non-compliant), findings summary, and follow-up action requirements. Mandatory under ISO 14001 Clause 9.1.2 and ISO 45001 Clause 9.1.2.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`safety_training` (
    `safety_training_id` BIGINT COMMENT 'Unique system-generated identifier for each safety training record in the HSE training management system.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Training costs are allocated to the requesting cost centers budget. Finance uses this for departmental cost tracking and training ROI analysis.',
    `knowledge_article_id` BIGINT COMMENT 'Foreign key linking to service.knowledge_article. Business justification: Safety training content often references technical knowledge articles (lockout/tagout procedures, equipment-specific safety protocols) used by field technicians during service operations.',
    `incident_id` BIGINT COMMENT 'Foreign key linking to hse.incident. Business justification: Safety training is often triggered by workplace incidents as corrective action (e.g., retraining after an injury). linked_incident_number in safety_training is a denormalized string reference that sho',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to hse.regulatory_obligation. Business justification: Safety training programs are mandated by specific regulatory obligations (e.g., OSHA 29 CFR 1910.132 requires PPE training). regulatory_requirement_reference in safety_training is a denormalized strin',
    `employee_id` BIGINT COMMENT 'Employee identifier of the internal trainer who delivered the training. Null if training was delivered by an external provider.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `assessment_method` STRING COMMENT 'Method used to evaluate trainee competency upon completion of the training program.. Valid values are `written_test|practical_demonstration|observation|oral_examination|simulation|no_assessment|sign_off_only`',
    `attendee_count` STRING COMMENT 'Total number of employees and/or contractors who attended the training session. Used for compliance coverage reporting.. Valid values are `^[1-9][0-9]*$`',
    `certificate_expiry_date` DATE COMMENT 'Date on which the training certificate or competency qualification expires, triggering a refresher training requirement. Critical for OSHA and ISO 45001 compliance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `certificate_issued` BOOLEAN COMMENT 'Indicates whether a formal training completion certificate was issued to attendees upon successful completion.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the training record was first created in the system. Used for audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `delivery_method` STRING COMMENT 'Method by which the training was delivered to participants, used for effectiveness analysis and compliance documentation.. Valid values are `classroom|e_learning|on_the_job|virtual_instructor_led|blended|video|simulation|toolbox_talk|self_study|external_course`',
    `department_code` STRING COMMENT 'Code of the department or organizational unit whose employees attended the training. Used for department-level compliance gap analysis.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `duration_hours` DECIMAL(18,2) COMMENT 'Total planned duration of the training program in hours. Used for scheduling, compliance hour tracking, and workforce planning.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `external_provider_name` STRING COMMENT 'Name of the external organization or vendor that delivered the training, if applicable (e.g., OSHA Training Institute, NSC, Red Cross). Null for internal training.',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or site where the training was conducted. Enables facility-level compliance reporting.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where training was conducted. Supports multi-national regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `fail_count` STRING COMMENT 'Number of attendees who did not meet the minimum competency threshold and failed the training assessment. Triggers retraining workflow.. Valid values are `^[0-9]+$`',
    `includes_contractors` BOOLEAN COMMENT 'Indicates whether contractors (non-employees) were included as attendees in this training session. Relevant for contractor safety compliance management.. Valid values are `true|false`',
    `language` STRING COMMENT 'Language in which the training was delivered, using IETF BCP 47 language tag (e.g., en, de, fr, zh-CN). Supports multilingual workforce compliance in multinational operations.. Valid values are `^[a-z]{2,3}(-[A-Z]{2,3})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the training record. Supports change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `minimum_pass_score` DECIMAL(18,2) COMMENT 'Minimum percentage score required for a trainee to be deemed competent and pass the training assessment.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.d{1,2})?)$`',
    `osha_standard_code` STRING COMMENT 'Specific OSHA training standard code applicable to this training session (e.g., OSHA 10-Hour, OSHA 30-Hour, HAZWOPER). Used for OSHA compliance reporting and recordkeeping.. Valid values are `OSHA_10|OSHA_30|OSHA_10_CONSTRUCTION|OSHA_30_CONSTRUCTION|HAZWOPER_8HR|HAZWOPER_24HR|HAZWOPER_40HR|NOT_APPLICABLE`',
    `pass_count` STRING COMMENT 'Number of attendees who successfully passed the training assessment or competency evaluation.. Valid values are `^[0-9]+$`',
    `program_code` STRING COMMENT 'Standardized alphanumeric code identifying the training program, used for system lookups and regulatory compliance mapping.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `program_name` STRING COMMENT 'Official name of the HSE training program or course delivered (e.g., Lockout/Tagout Awareness, Confined Space Entry, HazCom GHS Orientation).',
    `retraining_required_date` DATE COMMENT 'Date by which retraining must be completed, either due to certificate expiry, regulatory change, incident trigger, or failed assessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Operational system of record from which this training record was sourced (e.g., SAP S/4HANA QM, Siemens Opcenter, Kronos, or external LMS). Supports data lineage in the lakehouse.. Valid values are `SAP_S4HANA|OPCENTER_MES|KRONOS|MANUAL|EXTERNAL_LMS|OTHER`',
    `status` STRING COMMENT 'Current lifecycle status of the training record, from scheduling through completion or cancellation.. Valid values are `scheduled|in_progress|completed|cancelled|postponed|pending_approval`',
    `target_audience` STRING COMMENT 'Intended audience group for the training program, used for compliance coverage planning and gap analysis.. Valid values are `all_employees|new_hires|contractors|supervisors|managers|maintenance_technicians|operators|emergency_response_team|specific_department`',
    `trainer_name` STRING COMMENT 'Full name of the individual who delivered the training session. May be an internal HSE officer, line supervisor, or external certified trainer.',
    `trainer_type` STRING COMMENT 'Indicates whether the training was delivered by an internal employee, external training provider, regulatory body, or online platform.. Valid values are `internal|external|regulatory_body|online_platform`',
    `training_category` STRING COMMENT 'Subject matter category of the training program, used for compliance tracking and gap analysis across HSE topic areas.. Valid values are `lockout_tagout|confined_space|hazcom|fire_safety|ppe|electrical_safety|fall_protection|ergonomics|emergency_response|environmental|chemical_handling|machine_guarding|forklift|first_aid|iso_45001_awareness|general_hse`',
    `training_date` DATE COMMENT 'Date on which the training session was conducted. Used as the primary date for compliance tracking and certificate validity calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `training_end_time` TIMESTAMP COMMENT 'Exact date and time when the training session concluded. Used with start time to calculate actual training duration.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `training_material_version` STRING COMMENT 'Version number of the training content or curriculum used in this session. Ensures traceability when regulatory updates require content revisions.. Valid values are `^v?d+(.d+){0,2}$`',
    `training_record_number` STRING COMMENT 'Human-readable business identifier for the training record, used for cross-referencing in compliance reports and OSHA documentation.. Valid values are `^TRN-[0-9]{4}-[0-9]{6}$`',
    `training_start_time` TIMESTAMP COMMENT 'Exact date and time when the training session commenced. Required for duration calculation and scheduling records.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `training_type` STRING COMMENT 'Classification of the training delivery type: initial onboarding training, periodic refresher, regulatory-mandated compliance training, toolbox talk, on-the-job instruction, emergency response drill, contractor induction, or management briefing.. Valid values are `initial|refresher|regulatory_mandated|toolbox_talk|on_the_job|emergency_response|contractor_induction|management_briefing`',
    `work_area` STRING COMMENT 'Specific work area, shop floor zone, or production line associated with the training content (e.g., Assembly Line 3, Paint Shop, Warehouse Zone B).',
    CONSTRAINT pk_safety_training PRIMARY KEY(`safety_training_id`)
) COMMENT 'Records of HSE training programs and courses delivered to manufacturing employees and contractors. Captures training program name, training type (initial, refresher, regulatory-mandated, toolbox talk), regulatory requirement linkage (OSHA 10/30, HazCom, lockout/tagout, confined space), delivery method, trainer identity, training date, facility and department, number of attendees, pass/fail status, and certificate expiry date. Supports OSHA training compliance and ISO 45001 competence management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`training_attendance` (
    `training_attendance_id` BIGINT COMMENT 'Unique surrogate identifier for each training attendance record in the HSE training management system. Serves as the primary key for the training_attendance data product.',
    `employee_id` BIGINT COMMENT 'Unique employee or contractor identifier of the person attending the training session. Used to link attendance records to workforce profiles for compliance tracking.',
    `safety_training_id` BIGINT COMMENT 'Foreign key linking to hse.safety_training. Business justification: training_attendance is a child record of safety_training — each attendance record documents an individuals participation in a specific training session. session_reference_number is a denormalized str',
    `absence_reason` STRING COMMENT 'Reason code explaining why the attendee was absent or excused from the training session. Required for compliance documentation when mandatory training is missed.. Valid values are `medical|operational_conflict|personal|travel|no_show|rescheduled|other`',
    `assessment_attempt_number` STRING COMMENT 'Sequential attempt number for the training assessment, starting at 1. Tracks whether the attendee required multiple attempts to achieve a passing score.. Valid values are `^[1-9][0-9]*$`',
    `assessment_result` STRING COMMENT 'Pass or fail outcome of the post-training competency assessment. Drives certificate issuance eligibility and determines whether remedial training is required.. Valid values are `pass|fail|not_assessed|pending|waived`',
    `assessment_score` DECIMAL(18,2) COMMENT 'Numeric score achieved by the attendee on the post-training assessment or competency evaluation, expressed as a percentage (0.00–100.00). Used to determine pass/fail outcome.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `attendance_number` STRING COMMENT 'Business-facing unique reference number for the training attendance record, used in compliance reports, certificates, and audit trails. Format: TA-YYYY-NNNNNN.. Valid values are `^TA-[0-9]{4}-[0-9]{6}$`',
    `attendance_status` STRING COMMENT 'Status indicating whether the attendee was present, absent, excused, or partially attended the training session. Core field for compliance gap identification.. Valid values are `attended|absent|excused|partial|late|cancelled`',
    `attendee_full_name` STRING COMMENT 'Full legal name of the employee or contractor who attended the training session. Required for certificate issuance and regulatory compliance records.',
    `attendee_type` STRING COMMENT 'Classification of the attendee as an employee, contractor, temporary worker, or other personnel category. Supports contractor compliance tracking and OSHA recordkeeping distinctions.. Valid values are `employee|contractor|temporary_worker|visitor|intern|subcontractor`',
    `certificate_expiry_date` DATE COMMENT 'Date on which the training certificate expires and recertification is required. Drives automated compliance alerts and recertification scheduling workflows.. Valid values are `^d{4}-d{2}-d{2}$`',
    `certificate_issue_date` DATE COMMENT 'Date on which the training completion certificate was issued to the attendee. Used to calculate certificate validity and schedule recertification.. Valid values are `^d{4}-d{2}-d{2}$`',
    `certificate_issued` BOOLEAN COMMENT 'Boolean flag indicating whether a training completion certificate has been issued to the attendee. True when the attendee passed the assessment and a certificate was generated.. Valid values are `true|false`',
    `certificate_number` STRING COMMENT 'Unique identifier of the training completion certificate issued to the attendee. Used for certificate verification, audit trails, and regulatory inspections.',
    `competency_verified` BOOLEAN COMMENT 'Indicates whether the attendees competency in the trained subject has been formally verified through practical demonstration or on-the-job assessment, beyond the written test score.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the training attendance record was first created in the system. Used for audit trail, data lineage, and compliance record retention.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Code of the organizational department to which the attendee belongs. Enables department-level training compliance reporting and gap analysis.',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or site where the attendee is based. Supports site-level compliance tracking and multi-site reporting.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the attendee is based. Supports country-specific regulatory compliance tracking (e.g., OSHA for USA, EU directives for European sites).. Valid values are `^[A-Z]{3}$`',
    `job_title` STRING COMMENT 'Job title or role of the attendee at the time of training. Used to validate that role-specific mandatory training requirements are met.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the training attendance record. Supports change tracking, audit trails, and data quality monitoring in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `mandatory_training_flag` BOOLEAN COMMENT 'Indicates whether this training was mandatory for the attendee based on their role, facility, or regulatory requirement. Mandatory training non-completion triggers compliance escalation.. Valid values are `true|false`',
    `passing_score_threshold` DECIMAL(18,2) COMMENT 'Minimum score required to pass the training assessment, expressed as a percentage. Enables automated pass/fail determination and is captured at the time of assessment for audit purposes.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `regulatory_requirement_reference` STRING COMMENT 'Reference to the specific regulatory standard, clause, or legal obligation that mandates this training (e.g., OSHA 29 CFR 1910.147, ISO 45001 Clause 7.2, REACH Article 35). Supports regulatory audit evidence.',
    `remedial_due_date` DATE COMMENT 'Deadline by which the attendee must complete remedial training following a failed assessment or missed mandatory session. Drives compliance escalation workflows.. Valid values are `^d{4}-d{2}-d{2}$`',
    `remedial_training_required` BOOLEAN COMMENT 'Indicates whether the attendee is required to undertake remedial or repeat training due to a failed assessment, partial attendance, or identified competence gap.. Valid values are `true|false`',
    `session_date` DATE COMMENT 'Calendar date on which the training session was conducted. Used for compliance deadline tracking, certificate validity calculation, and recertification scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Operational system of record from which this training attendance record was sourced (e.g., SAP S/4HANA QM, Siemens Opcenter MES, Kronos Workforce Central). Supports data lineage and reconciliation.. Valid values are `SAP_S4HANA|OPCENTER_MES|KRONOS|MAXIMO|MANUAL|OTHER`',
    `supervisor_acknowledgement` BOOLEAN COMMENT 'Indicates whether the attendees direct supervisor has acknowledged and confirmed the training attendance record. Supports management accountability requirements under ISO 45001.. Valid values are `true|false`',
    `trainer_name` STRING COMMENT 'Full name of the instructor or trainer who delivered the training session. Required for competence verification of training delivery personnel per ISO 45001.',
    `trainer_qualification` STRING COMMENT 'Qualification, certification, or credential held by the trainer that authorizes them to deliver this specific HSE training. Supports competence verification of training providers.',
    `training_duration_hours` DECIMAL(18,2) COMMENT 'Total number of hours the attendee participated in the training session. Used for workforce training hour reporting, ISO 45001 competence records, and OSHA compliance documentation.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `training_location` STRING COMMENT 'Physical location, room, or virtual platform where the training session was conducted. Used for logistics planning and audit documentation.',
    `training_provider` STRING COMMENT 'Name of the organization or entity that delivered the training, which may be an internal HSE team, an external training company, or a regulatory body. Used for vendor management and accreditation tracking.',
    CONSTRAINT pk_training_attendance PRIMARY KEY(`training_attendance_id`)
) COMMENT 'Individual attendance and completion records for HSE training sessions, linking employees and contractors to specific training deliveries. Captures attendee identity, training session reference, attendance status (attended, absent, excused), assessment score, pass/fail result, certificate issued flag, certificate number, and certificate expiry date. Enables per-person training compliance tracking and gap identification for OSHA and ISO 45001 competence requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` (
    `ppe_requirement_id` BIGINT COMMENT 'Unique system-generated identifier for each PPE requirement record within the manufacturing facility HSE management system.',
    `bop_operation_id` BIGINT COMMENT 'Foreign key linking to engineering.bop_operation. Business justification: PPE requirements are defined per manufacturing operation in the Bill of Process. HSE specifies required PPE (gloves, goggles, respirators) for each operation based on hazard exposure during that speci',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: PPE requirements vary by plant location/area (cleanroom, high-noise, chemical storage). Links requirements to locations for access control and worker safety compliance.',
    `hazard_assessment_id` BIGINT COMMENT 'Foreign key linking to hse.hazard_assessment. Business justification: PPE requirements are derived from and justified by formal hazard assessments. hazard_assessment_reference in ppe_requirement is a denormalized string reference that should be replaced with a proper FK',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: PPE requirements vary by storage location based on materials stored (chemicals, heavy items, temperature-controlled). Safety teams define location-specific PPE rules enforced during warehouse operatio',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: PPE requirements are defined per work center based on hazards present. Workers must wear specific protective equipment when operating in each production area per safety regulations.',
    `applicability_scope` STRING COMMENT 'Defines the primary scope to which this PPE requirement applies — whether it is tied to a specific work area, job role, task, hazard zone, manufacturing process, or piece of equipment.. Valid values are `work_area|job_role|task|hazard_zone|process|equipment`',
    `applicable_standard` STRING COMMENT 'Primary industry or regulatory standard that governs the PPE requirement, such as ANSI/ISEA Z87.1 for eye protection, NFPA 70E for arc flash PPE, or EN 166 for European eye protection standards.. Valid values are `ANSI|NFPA_70E|ISO_45001|EN_166|EN_397|EN_388|EN_374|OSHA_29_CFR|NIOSH|CE_Marking|AS_NZS|other`',
    `approval_date` DATE COMMENT 'Date on which this PPE requirement was formally approved by the designated authority, establishing the official authorization record for compliance documentation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the HSE manager, safety officer, or authorized person who approved this PPE requirement for enforcement, fulfilling ISO 45001 documented information control requirements.',
    `arc_flash_incident_energy_calcm2` DECIMAL(18,2) COMMENT 'Calculated arc flash incident energy level in calories per square centimeter (cal/cm²) that determines the required arc flash PPE category per NFPA 70E. Applicable only for electrical hazard PPE requirements.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `arc_flash_ppe_category` STRING COMMENT 'Arc flash PPE category per NFPA 70E Table 130.5(G), ranging from Category 1 (minimum 4 cal/cm²) to Category 4 (minimum 40 cal/cm²). Drives selection of arc-rated clothing and face protection.. Valid values are `category_1|category_2|category_3|category_4|not_applicable`',
    `contractor_applicable` BOOLEAN COMMENT 'Indicates whether this PPE requirement explicitly applies to contractors and third-party workers performing work in the designated area, supporting contractor safety management obligations.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this PPE requirement record was first created in the system, used for audit trail and data lineage tracking in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Code identifying the organizational department or cost center responsible for enforcing this PPE requirement, as defined in SAP S/4HANA organizational structure.',
    `description` STRING COMMENT 'Detailed narrative describing the PPE requirement, including the nature of the hazard, the work activity or task involved, and the rationale for the specified protective equipment.',
    `effective_date` DATE COMMENT 'Date from which this PPE requirement becomes enforceable on the shop floor. Used for compliance tracking and to manage transitions when requirements are updated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which this PPE requirement expires or must be reviewed and revalidated. Supports periodic review cycles mandated by ISO 45001 and OSHA PPE assessment requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `facility_code` STRING COMMENT 'Alphanumeric code identifying the manufacturing facility or plant where this PPE requirement applies. Aligns with SAP S/4HANA plant codes and Maximo EAM site identifiers.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the PPE requirement is enforced, supporting multinational regulatory compliance tracking (OSHA, EU-OSHA, local labor laws).. Valid values are `^[A-Z]{3}$`',
    `fit_test_required` BOOLEAN COMMENT 'Indicates whether a formal fit test is required for the specified PPE, particularly applicable for tight-fitting respirators per OSHA respiratory protection standard.. Valid values are `true|false`',
    `hazard_basis_description` STRING COMMENT 'Narrative description of the specific hazard or risk that forms the basis for this PPE requirement, referencing hazard assessment findings, PFMEA results, or incident history.',
    `hazard_category` STRING COMMENT 'Primary hazard category that necessitates the PPE requirement, derived from the hazard assessment process. Used to link PPE requirements to the underlying risk basis.. Valid values are `electrical|chemical|mechanical|thermal|noise|radiation|biological|ergonomic|fall|dust|other`',
    `inspection_frequency` STRING COMMENT 'Required frequency for inspecting the specified PPE to ensure it remains in serviceable condition, as mandated by the applicable standard or manufacturers guidance.. Valid values are `before_each_use|daily|weekly|monthly|quarterly|annual|as_required`',
    `job_role` STRING COMMENT 'Specific job role, trade, or occupation for which this PPE requirement applies, such as Electrician, Welder, Chemical Operator, or Maintenance Technician.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this PPE requirement record, supporting change tracking and version control for ISO 45001 documented information management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this PPE requirement to ensure continued adequacy in light of changes to work processes, hazards, or applicable standards.. Valid values are `^d{4}-d{2}-d{2}$`',
    `noise_exposure_level_dba` DECIMAL(18,2) COMMENT 'Measured or assessed noise exposure level in decibels A-weighted (dBA) for the work area or task, used to determine the required noise reduction rating (NRR) for hearing protection.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `ppe_additional_types` STRING COMMENT 'Comma-separated list of additional PPE types required alongside the primary PPE type for this requirement, such as safety_glasses,gloves,safety_footwear for a combined protection scenario.',
    `ppe_specification` STRING COMMENT 'Detailed specification of the required PPE including minimum performance rating, class, or grade, such as ANSI Z87.1 High Impact, Class E Hard Hat, Arc Flash PPE Category 2 (8 cal/cm²), or N95 Respirator.',
    `ppe_type` STRING COMMENT 'Primary type of Personal Protective Equipment required. For requirements covering multiple PPE types, each type should be captured as a separate record or the primary type listed here with details in ppe_additional_types.. Valid values are `hard_hat|safety_glasses|face_shield|safety_goggles|gloves|chemical_resistant_gloves|cut_resistant_gloves|respirator|scba|hearing_protection|arc_flash_ppe|high_visibility_vest|safety_footwear|fall_arrest_harness|chemical_suit|welding_shield|knee_pads|other`',
    `requirement_number` STRING COMMENT 'Human-readable business identifier for the PPE requirement, used for cross-referencing in safety audits, OSHA compliance documentation, and ISO 45001 operational control records.. Valid values are `^PPE-[A-Z]{2,6}-[0-9]{4,8}$`',
    `requirement_type` STRING COMMENT 'Classification indicating whether the PPE is mandatory (must be worn at all times in the area/task), recommended (best practice), or conditional (required only under specific conditions such as chemical handling or elevated noise).. Valid values are `mandatory|recommended|conditional`',
    `respiratory_hazard_type` STRING COMMENT 'Classification of the respiratory hazard type that drives the respirator selection, such as particulate (dust, fumes), gas/vapor (chemical vapors), oxygen-deficient atmosphere, or combination hazards.. Valid values are `particulate|gas_vapor|oxygen_deficient|combination|not_applicable`',
    `review_frequency` STRING COMMENT 'Frequency at which this PPE requirement must be reviewed and revalidated, such as annually, biannually, or triggered by process changes or incident events.. Valid values are `annual|biannual|quarterly|on_change|on_incident|as_required`',
    `sop_reference` STRING COMMENT 'Reference number or identifier of the Standard Operating Procedure (SOP) or work instruction that incorporates this PPE requirement, ensuring alignment between procedural controls and PPE mandates.',
    `source_system` STRING COMMENT 'Operational system of record from which this PPE requirement record originates, such as SAP S/4HANA QM module, Maximo EAM, or Siemens Opcenter MES, supporting data lineage in the lakehouse.. Valid values are `SAP_S4HANA|Maximo_EAM|Siemens_Opcenter_MES|Manual|Other`',
    `standard_clause_reference` STRING COMMENT 'Specific clause, section, or article within the applicable standard that mandates or governs this PPE requirement, such as NFPA 70E Table 130.5(C) or OSHA 29 CFR 1910.133(a)(1).',
    `status` STRING COMMENT 'Current lifecycle status of the PPE requirement record. Active records are enforced on the shop floor; superseded records have been replaced by a newer version.. Valid values are `active|inactive|under_review|superseded|draft`',
    `task_description` STRING COMMENT 'Description of the specific work task or activity that triggers this PPE requirement, such as Arc flash work on energized panels above 50V or Handling of corrosive chemicals per SDS.',
    `title` STRING COMMENT 'Short descriptive title summarizing the PPE requirement, such as Arc Flash PPE – High Voltage Switchgear Area or Respiratory Protection – Chemical Mixing Zone.',
    `training_required` BOOLEAN COMMENT 'Indicates whether specific training is required for workers before using the specified PPE, such as respirator fit testing, arc flash safety training, or fall protection training.. Valid values are `true|false`',
    `version_number` STRING COMMENT 'Version number of this PPE requirement record, incremented each time the requirement is reviewed and updated. Supports document control and audit trail requirements.. Valid values are `^[0-9]+.[0-9]+$`',
    `visitor_applicable` BOOLEAN COMMENT 'Indicates whether this PPE requirement applies to visitors, contractors, and non-employees entering the designated work area or hazard zone, in addition to regular employees.. Valid values are `true|false`',
    CONSTRAINT pk_ppe_requirement PRIMARY KEY(`ppe_requirement_id`)
) COMMENT 'Master records defining Personal Protective Equipment (PPE) requirements for specific work areas, job roles, tasks, and hazard zones within manufacturing facilities. Captures work area or task description, required PPE types (hard hat, safety glasses, gloves, respirator, hearing protection, arc flash PPE), applicable standard (ANSI, NFPA 70E), hazard basis, mandatory vs. recommended classification, and effective date. Supports OSHA PPE compliance and ISO 45001 operational controls.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` (
    `hygiene_monitoring_id` BIGINT COMMENT 'Unique system-generated identifier for each occupational hygiene monitoring record in the manufacturing environment.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: Occupational hygiene monitoring measures worker exposure to specific chemical agents. cas_number in hygiene_monitoring is a denormalized reference to the chemical substance master. Adding chemical_sub',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Industrial hygiene monitoring (noise, dust, fumes) is conducted at specific plant locations. Required for exposure assessments, control verification, and OSHA compliance.',
    `hse_capa_id` BIGINT COMMENT 'Foreign key linking to hse.capa. Business justification: When hygiene monitoring identifies OEL exceedances or elevated exposure risk, a CAPA is initiated to implement engineering controls or administrative measures. capa_reference_number in hygiene_monitor',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Industrial hygiene monitoring (noise, air quality, temperature) uses OT sensors and monitoring systems. Linking to OT systems enables calibration tracking, maintenance scheduling, and data validation ',
    `employee_id` BIGINT COMMENT 'Employee identifier of the individual worker who wore the personal monitoring device or provided a biological specimen. Restricted PII as it directly identifies an individual and links to health exposure data.',
    `action_level_exceeded_flag` BOOLEAN COMMENT 'Indicates whether the measured exposure exceeded the regulatory action level (typically 50% of the OEL/PEL), which triggers mandatory medical surveillance enrollment, increased monitoring frequency, and worker notification requirements.. Valid values are `true|false`',
    `analytical_method` STRING COMMENT 'Laboratory or field analytical technique used to quantify the measured agent, such as NIOSH method number, OSHA method number, EPA method, or instrument-specific protocol (e.g., NIOSH 1501, OSHA 7, GC-MS, ICP-MS).',
    `below_detection_limit_flag` BOOLEAN COMMENT 'Indicates whether the measured result was below the analytical methods limit of detection (LOD), meaning the agent was not quantifiably detected. Non-detect results are still retained for statistical exposure assessment.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the hygiene monitoring record was first created in the system, providing an audit trail for data entry and regulatory record retention compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Organizational department or cost center code associated with the monitored work area, enabling department-level exposure trend analysis and resource allocation for controls.',
    `detection_limit` DECIMAL(18,2) COMMENT 'Minimum concentration or level that the analytical method can reliably detect, expressed in the same unit of measure as the measured value. Results below the LOD are reported as non-detects and handled per statistical convention.',
    `exposure_duration_minutes` STRING COMMENT 'Total duration in minutes during which the worker was exposed to the monitored agent during the sampling period. Used to normalize measurements to standard 8-hour TWA or 15-minute STEL reference periods.. Valid values are `^[0-9]+$`',
    `exposure_risk_band` STRING COMMENT 'Qualitative risk band assigned to the monitoring result based on the ratio of measured exposure to OEL, following AIHA or internal risk-banding methodology. Used for prioritizing engineering controls and health surveillance.. Valid values are `negligible|low|moderate|high|very_high`',
    `facility_code` STRING COMMENT 'Unique identifier for the manufacturing facility or plant where the hygiene monitoring was conducted, used for site-level compliance tracking and multi-site reporting.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the country where the monitored facility is located, supporting multinational regulatory compliance reporting across OSHA, EU-OSHA, and other jurisdictions.. Valid values are `^[A-Z]{3}$`',
    `hazard_category` STRING COMMENT 'Broad classification of the occupational health hazard being monitored, aligned with industrial hygiene taxonomy for chemical, physical, biological, or ergonomic agents.. Valid values are `chemical|physical|biological|ergonomic|radiation_ionizing|radiation_non_ionizing|thermal`',
    `industrial_hygienist_name` STRING COMMENT 'Full name of the Certified Industrial Hygienist (CIH) or qualified occupational hygienist who designed, conducted, or supervised the monitoring event. Used for professional accountability and regulatory audit trails.',
    `job_title` STRING COMMENT 'Job title or similar exposure group (SEG) classification of the worker(s) monitored, used to extrapolate exposure findings to all workers in the same job category without individual monitoring of each person.',
    `laboratory_name` STRING COMMENT 'Name of the accredited analytical laboratory that performed the sample analysis. Accreditation status (e.g., AIHA-LAP, ISO/IEC 17025) is critical for regulatory defensibility of results.',
    `laboratory_sample_number` STRING COMMENT 'Unique sample identification number assigned by the analytical laboratory, used for chain-of-custody tracking and cross-referencing laboratory certificates of analysis with field monitoring records.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the hygiene monitoring record, supporting data lineage, audit trail requirements, and change management for regulatory compliance documentation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `measured_value` DECIMAL(18,2) COMMENT 'Quantitative result of the hygiene monitoring measurement representing the concentration or level of the monitored agent as determined by laboratory analysis or direct-reading instrument. Interpreted in conjunction with unit_of_measure.',
    `monitored_agent` STRING COMMENT 'Specific chemical substance, physical agent, or biological agent being measured, such as a chemical compound name, noise level, ionizing radiation type, or biological marker. For chemical agents, this aligns with the substance name in the chemical substance registry.',
    `monitoring_date` DATE COMMENT 'Calendar date on which the hygiene monitoring or sampling event was conducted in the workplace.. Valid values are `^d{4}-d{2}-d{2}$`',
    `monitoring_number` STRING COMMENT 'Human-readable business reference number for the monitoring record, used for tracking and cross-referencing in compliance reports and OSHA documentation.. Valid values are `^HYG-[0-9]{4}-[0-9]{6}$`',
    `monitoring_purpose` STRING COMMENT 'Business reason or trigger for conducting the hygiene monitoring event, distinguishing between routine surveillance, regulatory compliance sampling, post-control verification, or incident-driven investigation.. Valid values are `baseline|routine_surveillance|complaint_investigation|post_control_verification|regulatory_compliance|exposure_assessment|health_surveillance`',
    `monitoring_type` STRING COMMENT 'Classification of the industrial hygiene monitoring method used to assess worker exposure, such as air sampling for chemical agents, noise dosimetry for hearing conservation, or biological monitoring for internal dose assessment.. Valid values are `air_sampling|noise_dosimetry|radiation_monitoring|biological_monitoring|skin_exposure|heat_stress|vibration|illumination|ergonomic`',
    `next_monitoring_due_date` DATE COMMENT 'Scheduled date for the next required monitoring event for this agent, work area, and exposure group, determined by regulatory requirements (e.g., OSHA annual monitoring) or risk-based monitoring frequency following this result.. Valid values are `^d{4}-d{2}-d{2}$`',
    `oel_ceiling_value` DECIMAL(18,2) COMMENT 'Instantaneous ceiling concentration that must never be exceeded at any time during the work shift, per the applicable OEL authority. Null if no ceiling limit is established for the monitored agent.',
    `oel_exceedance_flag` BOOLEAN COMMENT 'Indicates whether the measured exposure (TWA or STEL) exceeded the applicable occupational exposure limit (OEL), triggering mandatory corrective action, engineering controls review, and regulatory notification obligations.. Valid values are `true|false`',
    `oel_stel_value` DECIMAL(18,2) COMMENT 'Numeric value of the applicable short-term exposure limit (STEL) for the 15-minute reference period, recorded at the time of monitoring. Null if no STEL is established for the monitored agent.',
    `oel_twa_value` DECIMAL(18,2) COMMENT 'Numeric value of the applicable occupational exposure limit for the 8-hour time-weighted average (TWA) reference period, recorded at the time of monitoring for compliance comparison and audit trail purposes.',
    `oel_type` STRING COMMENT 'Regulatory or advisory body that established the applicable occupational exposure limit (OEL) used as the compliance benchmark, such as OSHA Permissible Exposure Limit (PEL), ACGIH Threshold Limit Value (TLV), or NIOSH Recommended Exposure Limit (REL).. Valid values are `OSHA_PEL|ACGIH_TLV|NIOSH_REL|EU_OEL|WEEL|internal_limit|none`',
    `percent_of_oel` DECIMAL(18,2) COMMENT 'Measured TWA exposure expressed as a percentage of the applicable OEL TWA value, enabling risk-banding and prioritization of controls. Values above 100% indicate OEL exceedance; values between 50-100% indicate action level concern.',
    `recommended_control_description` STRING COMMENT 'Detailed narrative description of the specific engineering, administrative, or PPE control measures recommended to reduce worker exposure to acceptable levels based on monitoring results.',
    `recommended_control_type` STRING COMMENT 'Highest-priority control measure recommended based on the hierarchy of controls following OEL exceedance or elevated exposure risk, ranging from elimination/substitution to engineering controls, administrative controls, or PPE.. Valid values are `elimination|substitution|engineering_control|administrative_control|ppe|no_action_required`',
    `sample_end_timestamp` TIMESTAMP COMMENT 'Precise date and time when the sampling or monitoring period ended, used in conjunction with sample start timestamp to compute actual exposure duration.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `sample_start_timestamp` TIMESTAMP COMMENT 'Precise date and time when the sampling or monitoring period began, required for calculating time-weighted average (TWA) exposures and validating sampling duration against OEL reference periods.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `sampling_media` STRING COMMENT 'Physical collection medium or instrument used during sampling, such as charcoal tube for organic vapors, filter cassette for particulates, dosimeter badge for noise or radiation, or biological specimen type for biological monitoring.. Valid values are `charcoal_tube|silica_gel|filter_cassette|impinger|dosimeter_badge|direct_reading_instrument|blood|urine|exhaled_breath|swab`',
    `sampling_method` STRING COMMENT 'Analytical or collection method used to obtain the exposure measurement, distinguishing between personal breathing zone sampling, area monitoring, grab sampling, or biological specimen collection per NIOSH or OSHA methodology.. Valid values are `personal_breathing_zone|area_sample|grab_sample|integrated_sample|wipe_sample|biological_specimen|direct_reading|passive_dosimeter|active_dosimeter`',
    `status` STRING COMMENT 'Current lifecycle status of the hygiene monitoring record, from planning through laboratory analysis to final completion or cancellation.. Valid values are `planned|in_progress|sampled|lab_analysis|completed|cancelled|voided`',
    `stel_result` DECIMAL(18,2) COMMENT 'Calculated 15-minute short-term exposure level (STEL) result for comparison against applicable STEL limits (ACGIH TLV-STEL, OSHA STEL, NIOSH STEL). Applicable when short-duration peak exposures are of concern.',
    `twa_result` DECIMAL(18,2) COMMENT 'Calculated 8-hour time-weighted average (TWA) exposure value normalized to the standard workday reference period, used for direct comparison against OEL TWA limits (OSHA PEL-TWA, ACGIH TLV-TWA, NIOSH REL-TWA).',
    `unit_of_measure` STRING COMMENT 'Unit of measurement for the measured exposure value, such as parts per million (ppm) for gases/vapors, milligrams per cubic meter (mg/m3) for particulates, decibels A-weighted (dBA) for noise, or millisieverts (mSv) for radiation.. Valid values are `ppm|mg/m3|f/cc|dBA|dBC|mSv|mSv/hr|µg/m3|µg/L|µg/g|lux|m/s2|°C|%LEL|cfu/m3`',
    `work_area` STRING COMMENT 'Specific work area, production zone, or shop floor location within the facility where monitoring was conducted, such as welding bay, paint booth, assembly line, or chemical storage area.',
    CONSTRAINT pk_hygiene_monitoring PRIMARY KEY(`hygiene_monitoring_id`)
) COMMENT 'Occupational health and industrial hygiene monitoring records capturing worker exposure measurements for chemical, physical, and biological hazards in manufacturing environments. Captures monitoring type (air sampling, noise dosimetry, radiation, biological monitoring), monitored agent, sampling method, exposure duration, measured concentration or level, applicable OEL (OSHA PEL, ACGIH TLV, NIOSH REL), exceedance flag, monitoring date, and recommended controls. Supports OSHA compliance and ISO 45001 health surveillance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` (
    `emergency_response_plan_id` BIGINT COMMENT 'Unique system-generated identifier for each emergency response plan record in the lakehouse silver layer.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the primary emergency coordinator, used to link to HR records and ensure accountability in regulatory submissions.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Emergency response plans are location-specific (fire zones, evacuation routes, muster points). Links plan to location for drill execution and emergency preparedness.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Emergency response plans are facility-specific. Each production plant requires tailored emergency procedures based on its layout, processes, hazards, and local emergency services coordination.',
    `service_territory_id` BIGINT COMMENT 'Foreign key linking to service.service_territory. Business justification: Emergency response plans for field service operations are territory-specific, covering local emergency contacts, hospital locations, and regional hazard protocols for technicians working in that area.',
    `alternate_coordinator_name` STRING COMMENT 'Full name of the backup or alternate emergency coordinator who assumes responsibility when the primary coordinator is unavailable.',
    `approval_date` DATE COMMENT 'Date on which the current version of the emergency response plan was formally approved by the designated management authority.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Full name of the management representative or HSE director who formally approved this version of the emergency response plan.',
    `assembly_point_description` STRING COMMENT 'Description of designated muster or assembly points where personnel must gather following an evacuation, including primary and alternate locations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the emergency response plan record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `drill_frequency` STRING COMMENT 'Required frequency for conducting emergency drills and exercises to test the effectiveness of this emergency response plan.. Valid values are `annual|semi_annual|quarterly|monthly|as_needed`',
    `effective_date` DATE COMMENT 'Date on which this version of the emergency response plan became officially effective and operationally active at the facility.. Valid values are `^d{4}-d{2}-d{2}$`',
    `emergency_coordinator_name` STRING COMMENT 'Full name of the primary emergency coordinator or Emergency Response Team (ERT) leader responsible for executing this plan during an emergency event.',
    `emergency_coordinator_phone` STRING COMMENT 'Direct contact phone number for the primary emergency coordinator, used for immediate notification during an emergency event.',
    `emergency_scenario` STRING COMMENT 'Primary emergency scenario or hazard event type that this plan is designed to address, such as fire, chemical spill, explosion, or natural disaster.. Valid values are `fire|chemical_spill|explosion|medical_emergency|natural_disaster|hazmat_release|power_outage|structural_failure|active_threat|flood|earthquake|evacuation_general`',
    `employee_training_required` BOOLEAN COMMENT 'Indicates whether employees covered by this plan are required to complete formal emergency response training as a condition of regulatory compliance.. Valid values are `true|false`',
    `epa_regional_contact` STRING COMMENT 'Contact information for the relevant EPA regional office responsible for environmental emergency notifications and RMP compliance oversight for this facility.',
    `epa_rmp_compliant` BOOLEAN COMMENT 'Indicates whether this plan satisfies EPA Risk Management Program (RMP) emergency response requirements under 40 CFR Part 68 for facilities handling regulated substances above threshold quantities.. Valid values are `true|false`',
    `epcra_compliant` BOOLEAN COMMENT 'Indicates whether this plan meets Emergency Planning and Community Right-to-Know Act (EPCRA) requirements, including coordination with the Local Emergency Planning Committee (LEPC).. Valid values are `true|false`',
    `evacuation_procedure_description` STRING COMMENT 'Description of the evacuation procedures including alarm signals, designated evacuation routes, personnel accountability methods, and special procedures for mobility-impaired employees.',
    `evacuation_route_document_reference` STRING COMMENT 'Reference identifier or URL to the evacuation route maps and floor plans associated with this emergency response plan, stored in the document management system.',
    `facility_code` STRING COMMENT 'Unique code identifying the facility or plant to which this emergency response plan applies, aligned with the enterprise facility master.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility location, used for multi-national regulatory compliance routing and jurisdiction determination.. Valid values are `^[A-Z]{3}$`',
    `facility_state_province` STRING COMMENT 'State or province where the facility is located, required for state-level emergency planning regulations such as EPCRA Local Emergency Planning Committee (LEPC) notifications.',
    `fire_department_contact` STRING COMMENT 'Name and phone number of the local fire department or fire brigade designated as the primary external emergency responder for fire-related incidents at this facility.',
    `hazmat_team_contact` STRING COMMENT 'Name and contact information for the external HAZMAT (Hazardous Materials) response team designated to support chemical spill or hazardous release emergencies at this facility.',
    `last_drill_date` DATE COMMENT 'Date of the most recently conducted emergency drill or tabletop exercise used to test and validate this emergency response plan.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the emergency response plan record, supporting change tracking and compliance audit requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_review_date` DATE COMMENT 'Date on which the emergency response plan was most recently reviewed and validated by the responsible coordinator and management, as required by regulatory review cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `local_emergency_planning_committee` STRING COMMENT 'Name and contact information for the Local Emergency Planning Committee (LEPC) responsible for community emergency planning coordination under EPCRA for this facilitys jurisdiction.',
    `next_drill_date` DATE COMMENT 'Date by which the next emergency drill or exercise must be conducted to maintain regulatory compliance and operational readiness.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_review_date` DATE COMMENT 'Date by which the next mandatory review of the emergency response plan must be completed, based on regulatory requirements or internal review frequency policy.. Valid values are `^d{4}-d{2}-d{2}$`',
    `osha_eap_compliant` BOOLEAN COMMENT 'Indicates whether this plan has been verified as compliant with OSHA 29 CFR 1910.38 Emergency Action Plan requirements.. Valid values are `true|false`',
    `plan_document_reference` STRING COMMENT 'Document management system reference number or URL pointing to the full emergency response plan document, stored in Siemens Teamcenter PLM or equivalent document repository.',
    `plan_number` STRING COMMENT 'Human-readable business identifier for the emergency response plan, used for cross-referencing in audits, regulatory submissions, and operational communications.. Valid values are `^ERP-[A-Z0-9]{3,10}-[0-9]{4,8}$`',
    `plan_type` STRING COMMENT 'Classification of the plan type indicating the primary regulatory framework and scope, such as a facility-level Emergency Response Plan (ERP), HAZMAT plan, or Fire Prevention Plan.. Valid values are `facility_erp|hazmat_erp|fire_prevention_plan|spill_prevention_plan|business_continuity_plan|pandemic_response_plan|security_emergency_plan`',
    `regulatory_basis` STRING COMMENT 'Primary regulatory standard or legal requirement that mandates or governs this emergency response plan, such as OSHA Emergency Action Plan (EAP) 29 CFR 1910.38 or EPA Risk Management Program (RMP) 40 CFR Part 68.. Valid values are `OSHA_EAP_1910_38|EPA_RMP_40CFR68|EPCRA|ISO_45001|NFPA_1600|EPA_SPCC|OSHA_PSM_1910_119|local_regulation|multiple`',
    `response_procedures_summary` STRING COMMENT 'High-level narrative summary of the emergency response procedures, including initial notification steps, containment actions, evacuation triggers, and escalation protocols.',
    `review_frequency` STRING COMMENT 'Scheduled frequency at which the emergency response plan must be reviewed and updated, such as annually or following a triggering event (incident, process change, regulatory update).. Valid values are `annual|biennial|triennial|event_triggered|quarterly|as_needed`',
    `status` STRING COMMENT 'Current lifecycle status of the emergency response plan, controlling whether it is operationally active, under revision, or retired.. Valid values are `draft|under_review|approved|active|superseded|archived|expired`',
    `superseded_plan_reference` STRING COMMENT 'Plan number of the previous version of this emergency response plan that was superseded upon approval of the current version, supporting version lineage and audit trail.',
    `title` STRING COMMENT 'Descriptive title of the emergency response plan, summarizing the facility scope and primary emergency scenario covered (e.g., Plant A Chemical Spill Emergency Response Plan).',
    `version_number` STRING COMMENT 'Version identifier of the emergency response plan document, incremented upon each formal review, revision, or regulatory update cycle.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_emergency_response_plan PRIMARY KEY(`emergency_response_plan_id`)
) COMMENT 'Master records for facility-level emergency response and preparedness plans covering fire, chemical spill, explosion, medical emergency, natural disaster, and evacuation scenarios. Captures plan type, facility scope, emergency scenario covered, response procedures summary, emergency coordinator roles, external agency contacts (fire department, HAZMAT, EPA), evacuation routes, assembly points, last review date, next review date, and regulatory basis (OSHA EAP, EPA RMP, EPCRA). Supports OSHA 29 CFR 1910.38 and EPA RMP compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`emergency_drill` (
    `emergency_drill_id` BIGINT COMMENT 'Unique system-generated identifier for each emergency drill record in the manufacturing facility.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the drill coordinator, used for accountability tracking and linking to workforce records in Kronos or SAP HR.',
    `emergency_response_plan_id` BIGINT COMMENT 'Foreign key linking to hse.emergency_response_plan. Business justification: Emergency drills are conducted to test and validate specific emergency response plans. emergency_plan_reference in emergency_drill is a denormalized string reference that should be replaced with a pro',
    `hse_capa_id` BIGINT COMMENT 'Foreign key linking to hse.capa. Business justification: Emergency drills that identify deficiencies or failures generate CAPAs to address gaps in emergency preparedness. capa_reference_number in emergency_drill is a denormalized string reference that shoul',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Emergency drills are executed at specific production plants. HSE conducts facility-level evacuation and response drills to ensure workforce preparedness and validate emergency procedures.',
    `actual_date` DATE COMMENT 'Actual calendar date on which the emergency drill was conducted. May differ from scheduled date due to postponements or rescheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_date` DATE COMMENT 'Date on which the completed emergency drill report was formally reviewed and approved by the responsible HSE authority.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Full name of the HSE manager or facility safety officer who reviewed and approved the completed drill report.',
    `building_area` STRING COMMENT 'Specific building, zone, or work area within the facility where the drill was conducted or that was covered by the drill scope.',
    `capa_initiated` BOOLEAN COMMENT 'Indicates whether a formal Corrective and Preventive Action (CAPA) has been initiated in the HSE management system to address deficiencies identified during this drill.. Valid values are `true|false`',
    `corrective_actions_required` STRING COMMENT 'Summary description of corrective actions identified as necessary to address deficiencies found during the drill. Detailed CAPA tracking is managed in the hse.capa product.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the emergency drill record was first created in the system, supporting audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `deficiencies_identified` STRING COMMENT 'Narrative description of gaps, failures, or weaknesses observed during the drill, such as blocked evacuation routes, missing personnel accountability, equipment failures, or inadequate response times.',
    `deficiency_count` STRING COMMENT 'Total number of distinct deficiencies or non-conformances identified during the emergency drill, used for trending and benchmarking drill performance over time.. Valid values are `^[0-9]+$`',
    `drill_category` STRING COMMENT 'Operational category of the drill indicating whether participants were pre-notified and the scope of the exercise (tabletop discussion vs. full physical execution).. Valid values are `announced|unannounced|tabletop|functional|full_scale`',
    `drill_coordinator_name` STRING COMMENT 'Full name of the HSE professional or safety officer responsible for planning, coordinating, and executing the emergency drill.',
    `drill_duration_minutes` STRING COMMENT 'Total elapsed time in minutes from drill start to drill end. Used for benchmarking drill efficiency and comparing against target duration objectives.. Valid values are `^[0-9]+$`',
    `drill_frequency_requirement` STRING COMMENT 'Mandated frequency at which this type of emergency drill must be conducted per applicable regulatory requirements or internal HSE program standards.. Valid values are `monthly|quarterly|semi_annual|annual|biennial|as_required`',
    `drill_number` STRING COMMENT 'Human-readable business reference number for the emergency drill, used for tracking and cross-referencing in reports and OSHA compliance documentation.. Valid values are `^DRILL-[0-9]{4}-[0-9]{5}$`',
    `drill_type` STRING COMMENT 'Classification of the emergency drill scenario type conducted at the facility. Determines applicable regulatory requirements and evaluation criteria.. Valid values are `fire_evacuation|chemical_spill|hazmat_response|lockdown|medical_emergency|earthquake|flood|power_outage|active_shooter|confined_space_rescue|gas_leak|explosion|cyber_incident|tabletop_exercise|full_scale_exercise`',
    `effectiveness_rating` STRING COMMENT 'Overall qualitative rating of the emergency drill effectiveness based on evaluation of participant response, adherence to procedures, and achievement of drill objectives.. Valid values are `excellent|satisfactory|needs_improvement|unsatisfactory`',
    `effectiveness_score` DECIMAL(18,2) COMMENT 'Numeric score (0-100) representing the quantitative assessment of drill effectiveness based on a standardized evaluation checklist, enabling trend analysis and benchmarking across facilities.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `end_timestamp` TIMESTAMP COMMENT 'Precise date and time when the emergency drill exercise concluded, used in conjunction with start timestamp to calculate total drill duration.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `evacuation_time_minutes` DECIMAL(18,2) COMMENT 'Measured time in minutes from alarm activation to full evacuation of all personnel to designated muster points. Key performance metric for fire and emergency evacuation drills.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `external_agency_involved` BOOLEAN COMMENT 'Indicates whether external agencies (e.g., local fire department, HAZMAT team, emergency medical services, civil defense) participated in the drill exercise.. Valid values are `true|false`',
    `external_agency_names` STRING COMMENT 'Names of external agencies or organizations that participated in the drill (e.g., City Fire Department, County HAZMAT Team). Populated when external_agency_involved is true.',
    `facility_code` STRING COMMENT 'Unique code identifying the manufacturing facility where the emergency drill was conducted. Aligns with SAP S/4HANA plant code.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the drill was conducted, supporting multinational regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `facility_name` STRING COMMENT 'Full name of the manufacturing facility or plant where the emergency drill was conducted.',
    `facility_state_province` STRING COMMENT 'State or province of the facility, required for jurisdiction-specific regulatory compliance reporting (e.g., OSHA state plan states, EPA regional requirements).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the emergency drill record, used for change tracking and data governance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `lessons_learned` STRING COMMENT 'Key insights, best practices, and improvement opportunities identified from the drill debrief session, to be shared across facilities for continuous improvement of emergency preparedness.',
    `next_drill_due_date` DATE COMMENT 'Calculated or manually set date by which the next drill of this type must be conducted at this facility to maintain regulatory compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `participant_count` STRING COMMENT 'Total number of personnel who participated in the emergency drill, including employees, contractors, and visitors present during the exercise.. Valid values are `^[0-9]+$`',
    `regulatory_requirement` STRING COMMENT 'Primary regulatory or standard requirement that mandates this drill, such as OSHA Emergency Action Plan (EAP), OSHA Process Safety Management (PSM), EPA Risk Management Program (RMP), or ISO 45001.. Valid values are `osha_eap|osha_psm|epa_rmp|iso_45001|local_fire_code|eu_seveso|other`',
    `scenario_description` STRING COMMENT 'Detailed narrative of the emergency scenario simulated during the drill, including trigger conditions, scope, and objectives of the exercise.',
    `scheduled_date` DATE COMMENT 'Planned calendar date on which the emergency drill was originally scheduled to be conducted.. Valid values are `^d{4}-d{2}-d{2}$`',
    `start_timestamp` TIMESTAMP COMMENT 'Precise date and time when the emergency drill exercise commenced, used for calculating drill duration and evacuation response times.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the emergency drill record, from scheduling through completion and review closure.. Valid values are `scheduled|in_progress|completed|cancelled|postponed|pending_review`',
    `target_evacuation_time_minutes` DECIMAL(18,2) COMMENT 'Pre-defined target evacuation time in minutes that the facility aims to achieve, used to assess whether actual evacuation performance meets safety objectives.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `title` STRING COMMENT 'Short descriptive title of the emergency drill exercise (e.g., Q2 Fire Evacuation Drill - Building A, Annual HAZMAT Spill Response Exercise).',
    `total_personnel_on_site` STRING COMMENT 'Total number of personnel present at the facility at the time of the drill, used to calculate participation rate and identify any personnel not accounted for during evacuation.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_emergency_drill PRIMARY KEY(`emergency_drill_id`)
) COMMENT 'Records of emergency preparedness drills and exercises conducted at manufacturing facilities including fire evacuation drills, chemical spill response drills, lockdown drills, and HAZMAT exercises. Captures drill type, facility, scenario description, scheduled and actual date, number of participants, drill duration, evacuation time achieved, deficiencies identified, corrective actions required, and drill effectiveness rating. Supports OSHA EAP compliance and ISO 45001 emergency preparedness testing.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` (
    `environmental_aspect_id` BIGINT COMMENT 'Unique system-generated identifier for each environmental aspect record as required by ISO 14001 environmental management system.',
    `bop_operation_id` BIGINT COMMENT 'Foreign key linking to engineering.bop_operation. Business justification: Environmental aspects (emissions, waste, energy use) are assessed per manufacturing operation. HSE links aspects to specific BOP operations to track environmental impacts of welding, painting, machini',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to hse.environmental_permit. Business justification: Environmental aspects that are significant are typically controlled through environmental permits (e.g., air emissions aspect linked to air quality permit). linked_permit_number in environmental_aspec',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Environmental aspects (emissions, waste, spills) are identified for specific equipment in ISO 14001 systems. Links aspect to equipment for impact assessment and control measures.',
    `activity_category` STRING COMMENT 'High-level category of the business activity generating the environmental aspect, enabling aggregated reporting across activity types for ISO 14001 environmental management planning.. Valid values are `production|maintenance|logistics|facility_operations|r_and_d|waste_management|procurement|construction|decommissioning|emergency_response|other`',
    `activity_process_name` STRING COMMENT 'Name of the manufacturing activity, process, product, or service that generates or is associated with this environmental aspect (e.g., CNC machining, surface coating, assembly, packaging).',
    `additional_controls_required` BOOLEAN COMMENT 'Indicates whether additional control measures are required beyond those currently in place to adequately manage this environmental aspect, triggering action planning.. Valid values are `true|false`',
    `applicable_legal_requirement` STRING COMMENT 'Description of the specific legal, regulatory, or permit requirement applicable to this environmental aspect, such as EPA emission limits, REACH substance restrictions, or local discharge permits.',
    `approval_date` DATE COMMENT 'Date on which the environmental aspect record was formally approved by the responsible manager or environmental management representative.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Name of the manager or environmental management representative who formally approved this environmental aspect record and its significance determination.',
    `aspect_number` STRING COMMENT 'Human-readable business reference number uniquely identifying the environmental aspect record, used for cross-referencing in audits, permits, and compliance reports.. Valid values are `^EA-[0-9]{4}-[0-9]{5}$`',
    `aspect_type` STRING COMMENT 'Classification of the type of environmental aspect, categorizing the nature of the interaction between the activity and the environment (e.g., air emission, wastewater discharge, solid waste, energy use).. Valid values are `air_emission|wastewater_discharge|solid_waste|hazardous_waste|energy_use|water_consumption|raw_material_consumption|noise|vibration|land_contamination|greenhouse_gas_emission|stormwater_runoff|other`',
    `assessment_date` DATE COMMENT 'Date on which the environmental aspect and its associated impact were formally assessed and the significance determination was made.. Valid values are `^d{4}-d{2}-d{2}$`',
    `associated_impact` STRING COMMENT 'Description of the actual or potential change to the environment resulting from this aspect, such as air quality degradation, water pollution, resource depletion, or climate change contribution.',
    `control_effectiveness` STRING COMMENT 'Assessment of how effectively the existing control measures are managing the environmental aspect and reducing the associated impact, informing decisions on additional controls or objectives.. Valid values are `effective|partially_effective|ineffective|not_assessed`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the environmental aspect record was first created in the system, providing an audit trail for document control and ISO 14001 records management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Code identifying the organizational department or cost center responsible for the activity generating this environmental aspect, enabling departmental environmental performance tracking.',
    `description` STRING COMMENT 'Detailed narrative describing the environmental aspect, including the nature of the activity, product, or service element that interacts with the environment.',
    `emission_medium` STRING COMMENT 'Environmental medium (air, water, land) into which the aspect releases or impacts, used for routing to the appropriate regulatory reporting program and permit condition.. Valid values are `air|water|land|multiple|not_applicable`',
    `existing_controls` STRING COMMENT 'Description of the current operational controls, engineering controls, administrative procedures, or monitoring measures in place to manage or mitigate this environmental aspect.',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or site where the activity generating this environmental aspect occurs, enabling site-level environmental management and regulatory reporting.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where this environmental aspect is registered, supporting multi-national regulatory compliance and country-level environmental reporting.. Valid values are `^[A-Z]{3}$`',
    `ghg_emission_flag` BOOLEAN COMMENT 'Indicates whether this environmental aspect involves greenhouse gas emissions, triggering GHG inventory inclusion and climate-related regulatory reporting obligations.. Valid values are `true|false`',
    `ghg_scope` STRING COMMENT 'GHG Protocol scope classification for greenhouse gas emissions associated with this aspect: Scope 1 (direct), Scope 2 (indirect energy), or Scope 3 (value chain), used for GHG inventory and climate disclosure.. Valid values are `scope_1|scope_2|scope_3|not_applicable`',
    `impact_category` STRING COMMENT 'Standardized classification of the environmental impact associated with this aspect, used for aggregated reporting and trend analysis across the environmental management system.. Valid values are `air_quality|water_quality|soil_contamination|climate_change|resource_depletion|biodiversity|human_health|noise_pollution|waste_generation|other`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the environmental aspect record, supporting version control and audit trail requirements under ISO 14001 document management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this environmental aspect record to ensure it remains current, reflecting any changes in activities, regulations, or environmental conditions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `operating_condition` STRING COMMENT 'Indicates whether the environmental aspect occurs under normal, abnormal (startup/shutdown/maintenance), or emergency operating conditions, as required by ISO 14001 for comprehensive aspect identification.. Valid values are `normal|abnormal|emergency`',
    `probability_rating` STRING COMMENT 'Likelihood rating (1–5 scale) that the environmental aspect will result in an environmental impact, used as an input to the significance scoring matrix.. Valid values are `^[1-5]$`',
    `quantification_unit` STRING COMMENT 'Unit of measure for the quantification value (e.g., tonnes CO2e, kg, MWh, m3, dB), ensuring consistent interpretation of the aspect magnitude across facilities and reporting periods.',
    `quantification_value` DECIMAL(18,2) COMMENT 'Measured or estimated quantity of the environmental aspect (e.g., annual emission volume, energy consumption, waste generated), providing a baseline for target-setting and performance monitoring.',
    `regulatory_program_code` STRING COMMENT 'Code identifying the specific regulatory program or standard governing this environmental aspect (e.g., CAA, CWA, RCRA, REACH, RoHS, ISO 14001, ISO 50001), enabling compliance tracking and reporting.',
    `responsible_owner_name` STRING COMMENT 'Name of the individual or role accountable for managing this environmental aspect, implementing controls, and ensuring compliance with applicable requirements.',
    `scale_rating` STRING COMMENT 'Scale rating (1–5 scale) reflecting the geographic extent or magnitude of the potential environmental impact (e.g., local, site-wide, regional, global), used in significance scoring.. Valid values are `^[1-5]$`',
    `severity_rating` STRING COMMENT 'Severity rating (1–5 scale) of the potential environmental impact if the aspect results in an incident, used as an input to the significance scoring matrix.. Valid values are `^[1-5]$`',
    `significance_criteria` STRING COMMENT 'Description of the criteria and methodology used to determine whether this environmental aspect is significant, including factors such as scale, severity, probability, duration, and regulatory sensitivity.',
    `significance_rating` STRING COMMENT 'Determination of whether this environmental aspect is classified as significant based on the organizations significance criteria. Significant aspects require objectives, targets, and operational controls under ISO 14001.. Valid values are `significant|not_significant`',
    `significance_score` STRING COMMENT 'Numerical score derived from the significance evaluation matrix (e.g., probability × severity × scale), used to rank aspects and prioritize environmental management actions.. Valid values are `^[1-9][0-9]?$|^100$`',
    `status` STRING COMMENT 'Current lifecycle status of the environmental aspect record, controlling whether it is active in the environmental management system or has been superseded by a revised version.. Valid values are `draft|active|under_review|superseded|retired`',
    `title` STRING COMMENT 'Short descriptive title summarizing the environmental aspect, such as Solvent Vapor Emissions from Paint Booth Operations.',
    `version_number` STRING COMMENT 'Version number of the environmental aspect record, incremented each time the record is formally revised, supporting document control and audit trail requirements.. Valid values are `^[0-9]+.[0-9]+$`',
    `work_area` STRING COMMENT 'Specific work area, production line, or shop floor zone where the environmental aspect-generating activity takes place (e.g., Paint Shop, Welding Bay, CNC Cell).',
    CONSTRAINT pk_environmental_aspect PRIMARY KEY(`environmental_aspect_id`)
) COMMENT 'Master records identifying environmental aspects and associated impacts of manufacturing activities, products, and services as required by ISO 14001. Captures activity or process generating the aspect, aspect type (air emission, wastewater discharge, solid waste, energy use, raw material consumption, noise), associated environmental impact, significance determination criteria, significance rating, applicable legal requirement, and existing control measures. Core input to ISO 14001 environmental management planning.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` (
    `hse_reach_substance_declaration_id` BIGINT COMMENT 'Unique system-generated identifier for each REACH/RoHS substance declaration record in the lakehouse silver layer.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: REACH declarations must specify which products contain substances of very high concern (SVHC). Mandatory for EU product compliance and customer substance disclosure requirements.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: REACH/RoHS substance declarations are made for specific chemical substances in the master registry. substance_name, cas_number, and ec_number in reach_substance_declaration are denormalized copies of ',
    `article_category` STRING COMMENT 'Product or material category classification (e.g., electrical component, mechanical assembly, raw material, semi-finished good) used for grouping compliance obligations.',
    `article_name` STRING COMMENT 'Descriptive name of the article, component, or material for which the substance declaration is made, supporting human-readable compliance reporting.',
    `article_number` STRING COMMENT 'Internal part number, material number, or article identifier (as defined under REACH Article 3) for the manufactured product or component subject to this substance declaration. Corresponds to SAP MM material number.',
    `compliance_status` STRING COMMENT 'Regulatory compliance determination for this substance in the article: compliant (below threshold or exempted), non-compliant (exceeds threshold without valid exemption), exempted (covered by an approved RoHS or REACH exemption), under assessment, or not applicable.. Valid values are `compliant|non_compliant|exempted|under_assessment|not_applicable`',
    `concentration_percent` DECIMAL(18,2) COMMENT 'Measured or declared concentration of the substance in the article or homogeneous material, expressed as percentage by weight (% w/w). Compared against REACH 0.1% SVHC threshold or RoHS maximum concentration values to determine compliance.. Valid values are `^[0-9]{1,4}.[0-9]{1,6}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this substance declaration record was first created in the system, supporting audit trail and data lineage requirements.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}[+-][0-9]{2}:[0-9]{2}$`',
    `customer_notification_date` DATE COMMENT 'Date on which the customer was notified of the presence of an SVHC above the 0.1% w/w threshold in the supplied article, fulfilling REACH Article 33 obligations.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `customer_notification_required` BOOLEAN COMMENT 'Indicates whether a customer notification obligation exists under REACH Article 33, triggered when an SVHC is present above 0.1% w/w in an article supplied to a downstream user or consumer.. Valid values are `true|false`',
    `declaration_date` DATE COMMENT 'Date on which this substance declaration was formally issued or confirmed, establishing the point-in-time compliance assessment for the article.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `declaration_number` STRING COMMENT 'Human-readable business reference number uniquely identifying this substance declaration record, used for cross-referencing in compliance reports and supplier communications.. Valid values are `^RSDECL-[0-9]{4}-[0-9]{6}$`',
    `declaration_type` STRING COMMENT 'Classifies the regulatory framework governing this substance declaration: REACH Substances of Very High Concern (SVHC) candidate list, RoHS restricted substances, REACH Annex XIV authorization list, REACH Annex XVII restriction list, or dual REACH/RoHS applicability.. Valid values are `REACH_SVHC|RoHS_Restricted|REACH_Annex_XIV|REACH_Annex_XVII|Dual_REACH_RoHS`',
    `declared_by_name` STRING COMMENT 'Name of the responsible person or role who issued or approved this substance declaration on behalf of the organization.',
    `facility_code` STRING COMMENT 'Internal code identifying the manufacturing facility or site where the article containing the declared substance is produced or assembled, supporting site-level compliance reporting.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the manufacturing facility, used to determine applicable regional regulatory requirements (EU REACH/RoHS, China RoHS, etc.).. Valid values are `^[A-Z]{3}$`',
    `homogeneous_material_flag` BOOLEAN COMMENT 'Indicates whether the concentration measurement was performed at the homogeneous material level as required by RoHS Directive, rather than at the component or article level, ensuring correct threshold comparison.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this substance declaration record, enabling change detection and compliance audit trail maintenance.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}[+-][0-9]{2}:[0-9]{2}$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this substance declaration to account for SVHC candidate list updates, RoHS exemption renewals, or changes in article composition.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `product_line` STRING COMMENT 'Business product line or product family to which the article belongs (e.g., automation systems, electrification solutions, smart infrastructure), enabling product-level compliance aggregation and reporting.',
    `reach_annex_reference` STRING COMMENT 'Identifies which REACH regulatory list or annex the declared substance appears on: SVHC Candidate List (Article 59), Annex XIV Authorization List, Annex XVII Restriction List, or not currently listed.. Valid values are `Candidate_List|Annex_XIV|Annex_XVII|Not_Listed`',
    `rohs_exemption_code` STRING COMMENT 'RoHS Annex III or Annex IV exemption code applicable to this substance in the article, permitting concentration above the maximum concentration value under specific technical or scientific conditions.',
    `rohs_exemption_expiry_date` DATE COMMENT 'Expiry date of the applicable RoHS exemption, after which the substance must comply with standard maximum concentration values or a new exemption must be obtained.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `rohs_restricted` BOOLEAN COMMENT 'Indicates whether the declared substance is restricted under EU RoHS Directive 2011/65/EU Annex II, requiring concentration to remain below the applicable maximum concentration value.. Valid values are `true|false`',
    `scip_notification_reference` STRING COMMENT 'ECHA-assigned reference number for the SCIP database notification submitted for this article containing an SVHC above the 0.1% w/w threshold.',
    `scip_notification_required` BOOLEAN COMMENT 'Indicates whether a SCIP database notification to ECHA is required under the EU Waste Framework Directive for articles containing SVHCs above 0.1% w/w, applicable to articles placed on the EU market.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Operational system of record from which this substance declaration record originated (e.g., SAP S/4HANA, Siemens Teamcenter PLM, supplier portal), supporting data lineage and silver layer traceability.. Valid values are `SAP_S4HANA|Teamcenter_PLM|Manual|Supplier_Portal|Other`',
    `status` STRING COMMENT 'Current lifecycle status of the substance declaration record, driving compliance workflow actions and customer notification obligations.. Valid values are `draft|submitted|under_review|compliant|non_compliant|exempted|superseded|withdrawn`',
    `superseded_by_declaration_number` STRING COMMENT 'Declaration number of the newer record that supersedes this declaration, enabling version chain traceability for compliance audit purposes.',
    `supplier_declaration_date` DATE COMMENT 'Date on which the supplier issued or last updated their substance declaration document, used to assess currency and validity of supplier-provided compliance data.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `supplier_declaration_reference` STRING COMMENT 'Supplier-issued document reference number for the substance declaration (e.g., supplier REACH/RoHS declaration document ID), enabling traceability back to the original supplier compliance documentation.',
    `supplier_name` STRING COMMENT 'Name of the supplier or manufacturer who provided the substance declaration or material/component containing the declared substance.',
    `svhc_listed` BOOLEAN COMMENT 'Indicates whether the declared substance is included on the ECHA SVHC Candidate List, triggering REACH Article 33 customer notification obligations when concentration exceeds 0.1% w/w.. Valid values are `true|false`',
    `svhc_listing_date` DATE COMMENT 'Date on which the substance was added to the ECHA SVHC Candidate List, used to determine when Article 33 notification obligations became applicable.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `test_method` STRING COMMENT 'Analytical or assessment method used to determine the substance concentration in the article or homogeneous material (e.g., IEC 62321 series for RoHS, XRF screening, ICP-MS, supplier declaration, or calculation-based approach).. Valid values are `IEC_62321|XRF_Screening|ICP-MS|ICP-OES|GC-MS|Supplier_Declaration|Calculation|Other`',
    `test_report_reference` STRING COMMENT 'Reference number or document identifier for the laboratory test report or analytical certificate supporting the declared substance concentration value.',
    `threshold_exceeded` BOOLEAN COMMENT 'Indicates whether the declared substance concentration exceeds the applicable regulatory threshold, directly determining compliance status and triggering notification or remediation obligations.. Valid values are `true|false`',
    `threshold_percent` DECIMAL(18,2) COMMENT 'Applicable regulatory maximum concentration threshold for the substance in the article or homogeneous material (e.g., 0.1% w/w for REACH SVHC; 0.01% for RoHS cadmium; 0.1% for RoHS lead, mercury, hexavalent chromium, PBB, PBDE).. Valid values are `^[0-9]{1,4}.[0-9]{1,6}$`',
    `version_number` STRING COMMENT 'Sequential version number of this substance declaration record, incremented when the declaration is revised due to composition changes, SVHC list updates, or new test results.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_hse_reach_substance_declaration PRIMARY KEY(`hse_reach_substance_declaration_id`)
) COMMENT 'REACH and RoHS substance declaration records for materials and components used in manufactured products. Captures article or material reference, declared substance (SVHC or restricted substance), CAS number, concentration (% by weight), threshold comparison against REACH 0.1% SVHC limit or RoHS maximum concentration values, declaration date, supplier declaration reference, and compliance status. Supports EU REACH Article 33 customer notification obligations and RoHS product compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`objective` (
    `objective_id` BIGINT COMMENT 'Unique system-generated identifier for each HSE strategic objective record within the enterprise management system.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the individual accountable for achieving this HSE objective, enabling integration with HR systems for accountability tracking and performance management.',
    `action_plan_reference` STRING COMMENT 'Reference number or document identifier for the detailed action plan associated with this HSE objective, linking to the specific initiatives, tasks, and resources required for achievement.',
    `actual_achievement_date` DATE COMMENT 'Date on which the HSE objective was confirmed as achieved, recorded upon formal verification and management approval of objective closure.. Valid values are `^d{4}-d{2}-d{2}$`',
    `applicable_standard` STRING COMMENT 'Primary regulatory or management system standard that this HSE objective supports, enabling traceability to compliance obligations and certification requirements.. Valid values are `ISO_14001|ISO_45001|ISO_50001|OSHA|EPA|REACH|RoHS|ISO_9001|CE_Marking|NIST|multiple`',
    `approval_date` DATE COMMENT 'Date on which this HSE objective was formally approved by senior management, establishing the official start of the objective planning and execution cycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Full name of the senior manager or HSE leader who formally approved this objective as part of the management system planning process.',
    `baseline_period_end_date` DATE COMMENT 'End date of the reference period used to establish the baseline value for this HSE objective.. Valid values are `^d{4}-d{2}-d{2}$`',
    `baseline_period_start_date` DATE COMMENT 'Start date of the reference period used to establish the baseline value for this HSE objective, ensuring comparability of performance data across planning cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `baseline_value` DECIMAL(18,2) COMMENT 'Reference baseline measurement value from which progress toward the HSE objective target is calculated, established at the start of the objective planning cycle.',
    `category` STRING COMMENT 'Specific operational category of the HSE objective providing finer classification for analytics, benchmarking, and management review reporting across the enterprise.. Valid values are `incident_reduction|emissions_reduction|waste_reduction|energy_efficiency|water_conservation|chemical_hazard_reduction|training_compliance|audit_compliance|ergonomics|contractor_safety|emergency_preparedness|regulatory_compliance`',
    `change_reason` STRING COMMENT 'Documented justification for any revision to this HSE objective (e.g., target adjustment due to regulatory change, scope modification, resource reallocation), required for management system document control.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this HSE objective record was first created in the system, providing an audit trail for management system document control and compliance purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated cost savings and investment amounts associated with this HSE objective, supporting multi-currency enterprise financial reporting.. Valid values are `^[A-Z]{3}$`',
    `current_value` DECIMAL(18,2) COMMENT 'Most recently recorded actual performance value for this HSE objective, updated at each progress review cycle to reflect real-time achievement status.',
    `department_code` STRING COMMENT 'Code of the organizational department or function responsible for achieving this HSE objective, used for accountability assignment and departmental performance reporting.',
    `description` STRING COMMENT 'Detailed narrative describing the HSE objective, its business rationale, scope, and expected outcomes aligned with the organizations HSE policy and strategic direction.',
    `estimated_cost_savings` DECIMAL(18,2) COMMENT 'Projected financial savings expected from achieving this HSE objective (e.g., energy cost reduction, waste disposal cost avoidance, insurance premium reduction), used for ROI justification and CAPEX/OPEX planning.',
    `facility_code` STRING COMMENT 'Unique code identifying the manufacturing facility or site to which this HSE objective is assigned. Use enterprise-wide facility code for objectives spanning multiple sites.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where this HSE objective applies, supporting multi-national regulatory compliance tracking and regional performance benchmarking.. Valid values are `^[A-Z]{3}$`',
    `investment_amount` DECIMAL(18,2) COMMENT 'Capital or operational expenditure (CAPEX/OPEX) budgeted or committed to achieve this HSE objective, used for financial planning and ROI analysis.',
    `kpi_name` STRING COMMENT 'Name of the Key Performance Indicator (KPI) used to measure progress toward this HSE objective (e.g., Total Recordable Incident Rate, GHG Emissions Intensity, Energy Consumption per Unit Output).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this HSE objective record, used for change tracking, data freshness monitoring, and management system audit trail compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_review_date` DATE COMMENT 'Date of the most recent formal progress review for this HSE objective, used to identify overdue reviews and ensure management system compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `management_review_cycle` STRING COMMENT 'Management review cycle in which this HSE objective is formally presented to senior leadership, supporting ISO 14001 and ISO 45001 management review input requirements.. Valid values are `Q1|Q2|Q3|Q4|H1|H2|annual|ad_hoc`',
    `measurement_unit` STRING COMMENT 'Unit of measure for the target, baseline, and current values (e.g., %, tCO2e, kWh, incidents per 200,000 hours, ppm, m3, tonnes). Ensures consistent interpretation of objective metrics.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal progress review of this HSE objective, calculated based on review frequency and last review date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Human-readable business reference number for the HSE objective, used for cross-referencing in management review reports, audit findings, and CAPA records.. Valid values are `^HSE-OBJ-[0-9]{4}-[0-9]{5}$`',
    `regulatory_requirement` STRING COMMENT 'Specific regulatory requirement, legal obligation, or compliance mandate that this HSE objective addresses (e.g., OSHA 29 CFR 1910.119, EPA 40 CFR Part 60, EU ETS Directive 2003/87/EC).',
    `responsible_owner_name` STRING COMMENT 'Full name of the individual (manager or function leader) accountable for driving achievement of this HSE objective, as assigned during management system planning.',
    `review_frequency` STRING COMMENT 'Frequency at which progress against this HSE objective is formally reviewed and updated, driving the management review calendar and performance reporting cadence.. Valid values are `weekly|monthly|quarterly|semi_annual|annual`',
    `status` STRING COMMENT 'Current lifecycle and achievement status of the HSE objective, used to drive management review agenda items, escalation workflows, and performance reporting.. Valid values are `draft|active|on_track|at_risk|behind|achieved|not_achieved|cancelled|superseded`',
    `target_achievement_date` DATE COMMENT 'Planned date by which the HSE objective is expected to be fully achieved, used for progress tracking, management review scheduling, and escalation triggers.. Valid values are `^d{4}-d{2}-d{2}$`',
    `target_direction` STRING COMMENT 'Indicates whether the objective requires reducing, increasing, or maintaining the measured value, or achieving a binary outcome. Used to correctly calculate progress percentage and achievement status.. Valid values are `reduce|increase|maintain|achieve`',
    `target_start_date` DATE COMMENT 'Date on which active pursuit of this HSE objective commences, marking the beginning of the performance measurement period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `target_value` DECIMAL(18,2) COMMENT 'Quantitative measurable target value that defines successful achievement of this HSE objective (e.g., reduce incident rate to 0.5, reduce CO2 emissions by 15%). Must be paired with measurement_unit.',
    `title` STRING COMMENT 'Short, descriptive title of the HSE objective that clearly communicates the strategic intent, used in dashboards, management review presentations, and reporting.',
    `type` STRING COMMENT 'Classification of the HSE objective by primary domain: safety (ISO 45001), environmental (ISO 14001), energy (ISO 50001), occupational health, regulatory compliance, sustainability, or process improvement.. Valid values are `safety|environmental|energy|occupational_health|compliance|sustainability|process_improvement`',
    `version_number` STRING COMMENT 'Sequential version number of this HSE objective record, incremented when the objective is revised or updated, supporting change history and audit trail requirements.. Valid values are `^[1-9][0-9]*$`',
    `voluntary_commitment` BOOLEAN COMMENT 'Indicates whether this HSE objective is driven by a voluntary commitment (e.g., Science Based Targets initiative, CDP reporting, UN SDGs) rather than a mandatory regulatory obligation.. Valid values are `true|false`',
    CONSTRAINT pk_objective PRIMARY KEY(`objective_id`)
) COMMENT 'HSE strategic objectives and performance targets established for manufacturing facilities and the enterprise as part of ISO 14001 and ISO 45001 management system planning. Captures objective type (safety, environmental, energy), objective description, measurable target value, baseline value, measurement unit, responsible facility or function, target achievement date, progress tracking frequency, and current achievement status. Drives HSE management programs and management review reporting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`management_of_change` (
    `management_of_change_id` BIGINT COMMENT 'Unique system-generated identifier for each Management of Change record in the HSE domain.',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: Management of Change (MOC) processes must link to product engineering changes to assess HSE impacts of design modifications, material substitutions, or process changes before implementation.',
    `ecn_id` BIGINT COMMENT 'Foreign key linking to engineering.ecn. Business justification: Engineering Change Notices trigger HSE Management of Change reviews when changes affect safety-critical systems, hazardous materials, or environmental controls. HSE tracks which ECNs require safety re',
    `eco_id` BIGINT COMMENT 'Foreign key linking to engineering.eco. Business justification: HSE Management of Change process must evaluate engineering change orders for safety/environmental impacts. Every ECO affecting processes, materials, or equipment requires HSE MOC review before impleme',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: MOC process evaluates safety/environmental impacts of equipment changes. Links MOC to equipment for change tracking, PSM compliance, and pre-startup safety reviews.',
    `hazard_assessment_id` BIGINT COMMENT 'Foreign key linking to hse.hazard_assessment. Business justification: Management of Change requires a formal HSE risk assessment before approving changes to processes, equipment, or materials. hse_risk_assessment_reference in management_of_change is a denormalized strin',
    `hse_capa_id` BIGINT COMMENT 'Foreign key linking to hse.capa. Business justification: Management of Change processes can generate CAPAs when post-change reviews identify issues or when the change itself is a corrective action. capa_reference_number in management_of_change is a denormal',
    `employee_id` BIGINT COMMENT 'Employee identifier of the person who initiated the MOC, used for accountability tracking and workflow routing.',
    `line_id` BIGINT COMMENT 'Foreign key linking to production.production_line. Business justification: Management of Change reviews are required when modifying production lines. HSE evaluates safety and environmental impacts of line changes before implementation to prevent new hazards.',
    `order_configuration_id` BIGINT COMMENT 'Foreign key linking to order.order_configuration. Business justification: Management of Change processes are triggered when custom order configurations require production line modifications, new tooling, or process changes. Safety reviews gate production start.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: R&D projects introducing new materials, processes, or equipment trigger Management of Change protocols. HSE evaluates safety impacts before implementing innovations from research into production envir',
    `technology_change_request_id` BIGINT COMMENT 'Foreign key linking to technology.change_request. Business justification: Management of Change (MOC) processes for safety-critical systems require IT change requests for OT/ICS modifications. HSE reviews IT change requests to assess safety impacts before implementation in p',
    `affected_chemicals` STRING COMMENT 'Names or CAS numbers of chemical substances involved in or affected by the proposed change, relevant for REACH, RoHS, and PSM chemical inventory compliance.',
    `change_category` STRING COMMENT 'Indicates whether the change is permanent, temporary (with defined end date), emergency (expedited review), or a like-for-like replacement that may have reduced review requirements.. Valid values are `permanent|temporary|emergency|like_for_like_replacement`',
    `closure_date` DATE COMMENT 'Date on which the MOC record was formally closed after all implementation, training, documentation, and post-change review requirements were satisfied.. Valid values are `^d{4}-d{2}-d{2}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the MOC record was first created in the system, used for audit trail and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Code of the department or organizational unit initiating or primarily affected by the proposed change.',
    `description` STRING COMMENT 'Detailed narrative describing the nature, scope, and rationale of the proposed change to process, equipment, chemical, facility, or organizational structure.',
    `document_update_required` BOOLEAN COMMENT 'Indicates whether process documentation, SOPs, P&IDs, or safety data sheets must be updated as part of the change implementation.. Valid values are `true|false`',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or site where the proposed change will be implemented.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the change is to be implemented, supporting multi-national regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `final_approval_date` DATE COMMENT 'Date on which the final authorization decision was made for the MOC, marking the point from which implementation may proceed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `final_approval_status` STRING COMMENT 'Overall final approval status of the MOC after all required approvers have reviewed, representing the consolidated authorization decision.. Valid values are `pending|approved|rejected|conditionally_approved|withdrawn`',
    `final_approver_name` STRING COMMENT 'Name of the authority (e.g., Plant Manager or EHS Director) who granted or denied final authorization for the change.',
    `hse_approval_date` DATE COMMENT 'Date on which the HSE function formally approved or rejected the proposed change.. Valid values are `^d{4}-d{2}-d{2}$`',
    `hse_approval_status` STRING COMMENT 'Approval status from the HSE function specifically, indicating whether the HSE team has cleared the change from a health, safety, and environmental perspective.. Valid values are `pending|approved|rejected|conditionally_approved`',
    `hse_approver_name` STRING COMMENT 'Name of the HSE representative who reviewed and approved or rejected the MOC from an HSE perspective.',
    `implementation_date` DATE COMMENT 'Actual date on which the approved change was implemented in the facility or process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `initiator_name` STRING COMMENT 'Full name of the employee who initiated and submitted the MOC request.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the MOC record, supporting data lineage, audit trail, and change history tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `moc_number` STRING COMMENT 'Human-readable, business-facing reference number for the MOC record, used in communications, approvals, and audit trails.. Valid values are `^MOC-[0-9]{4}-[0-9]{5}$`',
    `post_change_review_date` DATE COMMENT 'Scheduled or actual date for the post-implementation review to verify the change was implemented as approved and that no new HSE hazards were introduced.. Valid values are `^d{4}-d{2}-d{2}$`',
    `post_change_review_outcome` STRING COMMENT 'Result of the post-implementation review, indicating whether the change was implemented correctly and no new HSE risks were identified.. Valid values are `satisfactory|unsatisfactory|pending|not_required`',
    `priority` STRING COMMENT 'Business priority level assigned to the MOC, influencing review turnaround time and resource allocation.. Valid values are `critical|high|medium|low`',
    `process_description` STRING COMMENT 'Description of the manufacturing process, equipment, or system affected by the proposed change, providing context for HSE risk assessment.',
    `proposed_change_date` DATE COMMENT 'Target date on which the change is proposed to be implemented, used for scheduling HSE reviews and approvals.. Valid values are `^d{4}-d{2}-d{2}$`',
    `psm_covered_process` BOOLEAN COMMENT 'Indicates whether the change involves a PSM-covered process under OSHA 29 CFR 1910.119, triggering mandatory PSM MOC compliance requirements.. Valid values are `true|false`',
    `reason_for_change` STRING COMMENT 'Business justification and technical rationale for the proposed change, including safety, regulatory, operational, or efficiency drivers.',
    `regulatory_requirement` STRING COMMENT 'Specific regulatory standard, clause, or permit condition that mandates or governs the MOC review process for this change (e.g., OSHA PSM, EPA RMP, ISO 45001).',
    `required_approvers` STRING COMMENT 'Comma-separated list of roles or names required to approve the MOC before implementation (e.g., HSE Manager, Process Engineer, Plant Manager, EHS Director).',
    `risk_level` STRING COMMENT 'Overall HSE risk level determined from the risk assessment associated with the proposed change, used to determine approval authority and required controls.. Valid values are `critical|high|medium|low|negligible`',
    `source_system` STRING COMMENT 'Operational system of record from which the MOC data was originated or extracted (e.g., SAP S/4HANA QM, Siemens Opcenter MES).. Valid values are `SAP_S4HANA|Siemens_Opcenter|Maximo|Manual|Other`',
    `status` STRING COMMENT 'Current lifecycle status of the MOC record, tracking progression from initiation through implementation and post-change review closure.. Valid values are `draft|submitted|under_review|pending_approval|approved|rejected|implemented|post_change_review|closed|cancelled`',
    `temporary_change_end_date` DATE COMMENT 'For temporary changes, the date by which the change must be reversed or converted to a permanent change. Null for permanent changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `title` STRING COMMENT 'Short descriptive title summarizing the proposed change subject, used for identification and reporting.',
    `training_completion_date` DATE COMMENT 'Date by which all required training related to the change must be completed before or after implementation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `training_required` BOOLEAN COMMENT 'Indicates whether employee training is required prior to or following implementation of the change, as mandated by OSHA PSM and ISO 45001 operational planning.. Valid values are `true|false`',
    `work_area` STRING COMMENT 'Specific work area, production line, or zone within the facility where the change will be applied.',
    CONSTRAINT pk_management_of_change PRIMARY KEY(`management_of_change_id`)
) COMMENT 'Management of Change (MOC) records governing HSE review and approval of proposed changes to manufacturing processes, equipment, chemicals, facilities, and organizational structures. Captures change description, change type (process, equipment, chemical, organizational), initiating facility and department, proposed change date, HSE risk assessment reference, required approvals, approval status, implementation date, and post-change review date. Supports OSHA PSM MOC requirements and ISO 45001 operational planning for change.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` (
    `contractor_qualification_id` BIGINT COMMENT 'Unique system-generated identifier for each contractor qualification record in the HSE pre-qualification and ongoing compliance registry.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Manufacturing facilities must qualify contractor accounts for HSE compliance before allowing site access. Procurement and HSE departments verify contractor safety certifications against account record',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Service contractors must meet HSE qualification requirements before contract execution. HSE tracks contractor certifications, safety records, and compliance tied to specific service contracts.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Contractors are suppliers of services. HSE qualifies contractors for safety compliance before procurement engages them. Joint responsibility between HSE and procurement for contractor management.',
    `third_party_risk_id` BIGINT COMMENT 'Foreign key linking to compliance.third_party_risk. Business justification: Contractor safety qualifications link to enterprise third-party risk assessments. Procurement and HSE teams jointly evaluate contractor risks using compliance-managed risk profiles.',
    `approval_date` DATE COMMENT 'Date on which the contractor qualification was formally approved by the authorized HSE manager.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by_name` STRING COMMENT 'Name of the HSE manager or authorized approver who formally approved the contractor qualification decision.',
    `confined_space_certified` BOOLEAN COMMENT 'Indicates whether the contractor holds valid confined space entry and rescue certification, required for work in permit-required confined spaces at manufacturing facilities.. Valid values are `true|false`',
    `contractor_company_code` STRING COMMENT 'Internal business code assigned to the contractor company, typically aligned with the vendor/supplier master in SAP Ariba or SAP S/4HANA MM.',
    `contractor_company_name` STRING COMMENT 'Legal registered name of the contractor or service provider organization undergoing HSE pre-qualification.',
    `contractor_type` STRING COMMENT 'Classification of the contractor by the nature of services provided at the manufacturing facility, used to determine applicable HSE requirements.. Valid values are `construction|electrical|mechanical|civil|it_services|cleaning|security|logistics|maintenance|engineering|inspection|other`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the contractor qualification record was first created in the system, supporting audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `dart_rate` DECIMAL(18,2) COMMENT 'Contractors DART rate per 200,000 work hours, measuring the frequency of incidents resulting in days away from work, restricted duty, or job transfer.',
    `disqualification_reason` STRING COMMENT 'Documented reason for contractor disqualification or suspension, such as unacceptable TRIR, lapsed certifications, insurance non-compliance, or serious safety violations.',
    `evaluated_by_name` STRING COMMENT 'Name of the internal HSE professional or team responsible for conducting the contractor HSE pre-qualification evaluation.',
    `facility_code` STRING COMMENT 'Code identifying the manufacturing facility or site for which this contractor qualification is applicable.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the contractor is qualified to work, supporting multi-national regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `fall_protection_certified` BOOLEAN COMMENT 'Indicates whether the contractor holds valid fall protection certification for work at heights at manufacturing facilities.. Valid values are `true|false`',
    `general_liability_coverage_amount` DECIMAL(18,2) COMMENT 'Verified general liability insurance coverage amount in the specified currency, confirming the contractor meets minimum financial protection requirements.',
    `general_liability_insured` BOOLEAN COMMENT 'Indicates whether the contractors general liability insurance coverage has been verified and meets the minimum required limits for site access.. Valid values are `true|false`',
    `hot_work_certified` BOOLEAN COMMENT 'Indicates whether the contractor holds valid hot work (welding, cutting, grinding) safety certification required for performing hot work operations at the facility.. Valid values are `true|false`',
    `hse_contact_email` STRING COMMENT 'Email address of the contractors designated HSE contact, used for qualification correspondence, audit notifications, and compliance communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `hse_contact_name` STRING COMMENT 'Name of the designated HSE representative or safety officer at the contractor organization responsible for HSE compliance and communication.',
    `hse_program_rating` STRING COMMENT 'Qualitative rating derived from the HSE program evaluation score, used for quick risk-tiering of contractors.. Valid values are `excellent|satisfactory|marginal|unsatisfactory`',
    `hse_program_score` DECIMAL(18,2) COMMENT 'Numeric score (0–100) assigned to the contractors HSE program based on evaluation of their safety management system, policies, procedures, and performance history.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `incident_rate_reference_period` STRING COMMENT 'The time period over which the TRIR and DART rate figures are calculated (e.g., most recent 1-year, 3-year average, 5-year average).. Valid values are `1_year|3_year_average|5_year_average`',
    `insurance_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the general liability insurance coverage amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `insurance_expiry_date` DATE COMMENT 'Date on which the contractors verified insurance coverage expires, triggering renewal verification workflows to maintain site access eligibility.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the contractor qualification record, used for change tracking and data governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lockout_tagout_certified` BOOLEAN COMMENT 'Indicates whether the contractor holds valid Lockout/Tagout certification for control of hazardous energy during equipment maintenance and servicing.. Valid values are `true|false`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the contractors HSE qualification status, certifications, and incident rate performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `osha_10_certified` BOOLEAN COMMENT 'Indicates whether the contractor holds valid OSHA 10-hour general industry or construction safety certification for their workforce.. Valid values are `true|false`',
    `osha_30_certified` BOOLEAN COMMENT 'Indicates whether the contractor holds valid OSHA 30-hour supervisory safety certification for their workforce.. Valid values are `true|false`',
    `qualification_date` DATE COMMENT 'Date on which the contractor was formally qualified or approved following successful completion of the HSE pre-qualification evaluation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `qualification_expiry_date` DATE COMMENT 'Date on which the contractors HSE qualification expires, after which re-qualification is required before the contractor may continue working at the facility.. Valid values are `^d{4}-d{2}-d{2}$`',
    `qualification_number` STRING COMMENT 'Human-readable business reference number assigned to the contractor qualification record, used for tracking and correspondence.. Valid values are `^CQ-[0-9]{4}-[0-9]{6}$`',
    `qualification_status` STRING COMMENT 'Current HSE pre-qualification status of the contractor, indicating whether they are approved to perform work at manufacturing facilities.. Valid values are `pending_review|qualified|conditionally_qualified|disqualified|suspended|expired|under_renewal`',
    `qualification_type` STRING COMMENT 'Type of qualification process applied — initial pre-qualification, annual renewal, periodic review, project-specific, or emergency approval.. Valid values are `pre_qualification|annual_renewal|periodic_review|project_specific|emergency_approval`',
    `risk_tier` STRING COMMENT 'Risk classification tier assigned to the contractor based on the nature of work, HSE program score, incident rate history, and site hazard exposure level.. Valid values are `high|medium|low`',
    `site_hse_orientation_completed` BOOLEAN COMMENT 'Indicates whether the contractors personnel have completed the mandatory site-specific HSE orientation program required before commencing work at the facility.. Valid values are `true|false`',
    `site_orientation_date` DATE COMMENT 'Date on which the contractors personnel completed the site-specific HSE orientation program.. Valid values are `^d{4}-d{2}-d{2}$`',
    `trir` DECIMAL(18,2) COMMENT 'Contractors Total Recordable Incident Rate calculated per 200,000 work hours, representing the frequency of OSHA-recordable injuries and illnesses over the most recent reporting period.',
    `work_scope_description` STRING COMMENT 'Description of the specific scope of work the contractor is qualified to perform at the facility, including applicable processes, equipment, and work areas.',
    `workers_comp_insured` BOOLEAN COMMENT 'Indicates whether the contractors workers compensation insurance has been verified as current and compliant with applicable state/national requirements.. Valid values are `true|false`',
    CONSTRAINT pk_contractor_qualification PRIMARY KEY(`contractor_qualification_id`)
) COMMENT 'HSE pre-qualification and ongoing compliance records for contractors and service providers working at manufacturing facilities. Captures contractor identity, qualification status, HSE program evaluation score, required certifications held (OSHA 10/30, confined space, hot work), incident rate history (TRIR, DART), insurance coverage verification, site-specific HSE orientation completion, and qualification expiry date. Supports contractor safety management per ISO 45001 Clause 8.1.4 and OSHA contractor requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`ghg_emission` (
    `ghg_emission_id` BIGINT COMMENT 'Unique system-generated identifier for each greenhouse gas emission record in the lakehouse silver layer.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: GHG emissions tracked by cost center for carbon accounting and potential carbon pricing allocation. Critical for sustainability reporting and environmental cost management.',
    `environmental_permit_id` BIGINT COMMENT 'FK to hse.environmental_permit',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: GHG emissions are calculated from specific equipment (boilers, generators, process units). Required for Scope 1 reporting, carbon accounting, and emissions reduction initiatives.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Greenhouse gas emissions are calculated per production plant for carbon reporting. Facilities must track Scope 1 and 2 emissions for regulatory compliance and corporate sustainability goals.',
    `activity_data_quantity` DECIMAL(18,2) COMMENT 'Measured or estimated quantity of the activity that drives the emission (e.g., volume of fuel consumed, kWh of electricity purchased, kilometers traveled, tonnes of waste generated). The primary input to the emission calculation.',
    `activity_data_uom` STRING COMMENT 'Unit of measure for the activity data quantity (e.g., GJ for energy, litres for fuel, kWh for electricity, tonnes for materials, km for distance). Required for correct emission factor application.. Valid values are `GJ|MWh|kWh|L|m3|kg|t|km|tonne-km|passenger-km|USD|unit`',
    `baseline_year` STRING COMMENT 'Reference year against which emission reductions are measured for Science Based Targets (SBTi) and corporate carbon reduction commitments. Enables year-over-year reduction tracking and recalculation when significant changes occur.. Valid values are `^(19|20)d{2}$`',
    `biogenic_co2_tonnes` DECIMAL(18,2) COMMENT 'CO2 emissions from biogenic sources (e.g., biomass combustion) reported separately from fossil-based CO2e in accordance with GHG Protocol requirements. Biogenic CO2 is excluded from the primary Scope 1 total but must be disclosed separately.',
    `calculation_methodology` STRING COMMENT 'GHG Protocol-aligned methodology used to calculate the emission quantity (e.g., Activity-Based using emission factors, Spend-Based for Scope 3 Cat 1, Supplier-Specific for high-materiality suppliers, Direct Measurement for continuous monitoring). Drives data quality tier classification.. Valid values are `Spend-Based|Activity-Based|Supplier-Specific|Hybrid|Direct Measurement|Mass Balance|Fuel Analysis|Engineering Estimate`',
    `cdp_disclosure_year` STRING COMMENT 'CDP reporting year in which this emission record is included for corporate climate change disclosure. Enables filtering and aggregation of emission data for annual CDP Climate Change questionnaire submissions.. Valid values are `^(20)d{2}$`',
    `co2e_quantity_tonnes` DECIMAL(18,2) COMMENT 'Calculated total greenhouse gas emission expressed in metric tonnes of CO2 equivalent (tCO2e), derived by multiplying activity data quantity by the emission factor. Primary metric for carbon reporting, CDP disclosure, and SBTi target tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the GHG emission record was first created in the system, used for audit trail, data lineage, and compliance record-keeping.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `data_quality_tier` STRING COMMENT 'Data quality classification indicating the reliability of the activity data: Tier 1 (primary metered/measured data), Tier 2 (secondary data from invoices/bills), Tier 3 (estimated or modeled data). Used for uncertainty analysis and data improvement prioritization.. Valid values are `Tier 1 Primary|Tier 2 Secondary|Tier 3 Estimated`',
    `data_source` STRING COMMENT 'Originating system or method from which the activity data was obtained (e.g., SAP S/4HANA energy module, Siemens MindSphere IIoT sensor, utility invoice, manual entry). Supports data lineage, audit trail, and data quality assessment.. Valid values are `SAP S/4HANA|Siemens MindSphere|Utility Invoice|Manual Entry|Meter Reading|ERP Integration|IoT Sensor|Supplier Data|Other`',
    `department_code` STRING COMMENT 'Code of the organizational department or cost center responsible for the emission source, enabling departmental carbon accountability and internal carbon pricing allocation.',
    `emission_factor_source` STRING COMMENT 'Authoritative source or database from which the emission factor was obtained (e.g., EPA eGRID, IEA, IPCC AR6, DEFRA, supplier-specific). Critical for audit trail and methodology transparency in CDP and SBTi disclosures.. Valid values are `EPA eGRID|IEA|IPCC AR6|IPCC AR5|DEFRA|GHG Protocol|Ecoinvent|Supplier-Specific|Utility-Specific|National Inventory|Other`',
    `emission_factor_uom` STRING COMMENT 'Unit of measure for the emission factor (e.g., kg CO2e/GJ, kg CO2e/kWh, kg CO2e/tonne), ensuring dimensional consistency in the emission calculation.',
    `emission_factor_value` DECIMAL(18,2) COMMENT 'Emission factor applied to convert activity data into GHG emissions, expressed as mass of GHG per unit of activity (e.g., kg CO2e per GJ, kg CO2e per kWh). Sourced from regulatory databases or supplier-specific data.',
    `emission_factor_year` STRING COMMENT 'Calendar year of the emission factor used in the calculation, ensuring temporal alignment between activity data and the most current or applicable emission factor vintage.. Valid values are `^(19|20)d{2}$`',
    `emission_source_name` STRING COMMENT 'Descriptive name of the specific emission source (e.g., Boiler B-101, CNC Machining Line 3 Compressed Air, Fleet Vehicle Pool – North Region), enabling source-level tracking and operational attribution.',
    `emission_source_type` STRING COMMENT 'Classification of the emission source generating the GHG, such as stationary combustion (boilers, furnaces), mobile combustion (fleet vehicles), process emissions (chemical reactions), or fugitive emissions (refrigerant leaks). Drives emission factor selection and methodology.. Valid values are `Stationary Combustion|Mobile Combustion|Process Emission|Fugitive Emission|Purchased Electricity|Purchased Heat|Purchased Steam|Purchased Cooling|Upstream Transportation|Downstream Transportation|Business Travel|Employee Commuting|Waste|Purchased Goods and Services|Capital Goods|Other`',
    `energy_source_type` STRING COMMENT 'Type of energy carrier or fuel associated with the emission source (e.g., Natural Gas for boiler combustion, Grid Electricity for Scope 2, Diesel for mobile combustion). Supports energy management reporting under ISO 50001 and fuel-type segmentation.. Valid values are `Natural Gas|Diesel|Gasoline|LPG|Coal|Biomass|Grid Electricity|Renewable Electricity|Steam|Chilled Water|Hot Water|Hydrogen|Fuel Oil|Other`',
    `eu_ets_installation_code` STRING COMMENT 'EU ETS installation identifier assigned by the competent national authority for facilities covered under the EU Emissions Trading System. Required for EU ETS compliance reporting and allowance surrender obligations.',
    `facility_code` STRING COMMENT 'Unique code identifying the manufacturing facility or site where the GHG emission was generated, aligned with the corporate facility master.',
    `facility_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the emission occurred, used for jurisdictional regulatory reporting and geographic segmentation.. Valid values are `^[A-Z]{3}$`',
    `ghg_scope` STRING COMMENT 'GHG Protocol emission scope classification: Scope 1 (direct combustion/process emissions), Scope 2 Location-Based or Market-Based (purchased energy), or Scope 3 (value chain indirect emissions). Scope 2 dual reporting is required per GHG Protocol Scope 2 Guidance.. Valid values are `Scope 1|Scope 2 Location-Based|Scope 2 Market-Based|Scope 3`',
    `ghg_type` STRING COMMENT 'Type of greenhouse gas emitted as defined by the Kyoto Protocol and GHG Protocol: CO2 (carbon dioxide), CH4 (methane), N2O (nitrous oxide), HFCs (hydrofluorocarbons), PFCs (perfluorocarbons), SF6 (sulfur hexafluoride), NF3 (nitrogen trifluoride), or CO2e (carbon dioxide equivalent aggregate).. Valid values are `CO2|CH4|N2O|HFCs|PFCs|SF6|NF3|CO2e`',
    `gwp_assessment_report` STRING COMMENT 'IPCC Assessment Report version used as the source for the Global Warming Potential values applied in the CO2e calculation (AR4, AR5, or AR6). Ensures methodological consistency and comparability across reporting periods.. Valid values are `IPCC AR4|IPCC AR5|IPCC AR6`',
    `gwp_value` DECIMAL(18,2) COMMENT 'Global Warming Potential multiplier applied to convert the specific GHG type to CO2 equivalent, sourced from the applicable IPCC Assessment Report (e.g., CH4 GWP = 27.9 per IPCC AR6). Required for transparency in CO2e calculation methodology.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the GHG emission record, supporting audit trail requirements and change tracking for regulatory compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `rec_certificate_number` STRING COMMENT 'Reference number of the Renewable Energy Certificate (REC) or Guarantee of Origin (GO) certificate used to support a market-based Scope 2 zero-emission claim. Required for GHG Protocol Scope 2 market-based accounting.',
    `record_number` STRING COMMENT 'Human-readable business reference number for the GHG emission record, used in reporting, audits, and cross-system referencing.. Valid values are `^GHG-[0-9]{4}-[0-9]{6}$`',
    `regulatory_reportable_flag` BOOLEAN COMMENT 'Indicates whether this emission record meets the threshold for mandatory regulatory reporting (True) under programs such as EPA GHGRP (40 CFR Part 98), EU ETS, or national GHG registries. Drives compliance workflow triggering.. Valid values are `true|false`',
    `renewable_energy_flag` BOOLEAN COMMENT 'Indicates whether the energy source associated with this emission record is from a renewable source (True) or non-renewable (False). Relevant for Scope 2 market-based accounting and RE100 renewable energy commitments.. Valid values are `true|false`',
    `reporting_period_end_date` DATE COMMENT 'End date of the reporting period to which this GHG emission record belongs, used for annual carbon disclosure and SBTi tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reporting_period_start_date` DATE COMMENT 'Start date of the reporting period (typically calendar year or fiscal year) to which this GHG emission record belongs, used for annual carbon disclosure and SBTi tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sbti_target_reference` STRING COMMENT 'Reference identifier of the Science Based Target (SBTi) to which this emission record contributes, enabling tracking of progress against committed near-term and long-term science-based emission reduction targets.',
    `scope3_category` STRING COMMENT 'GHG Protocol Scope 3 category classification (Categories 1–15) applicable when ghg_scope is Scope 3. Set to N/A for Scope 1 and Scope 2 records.. Valid values are `Cat 1 Purchased Goods and Services|Cat 2 Capital Goods|Cat 3 Fuel and Energy|Cat 4 Upstream Transportation|Cat 5 Waste in Operations|Cat 6 Business Travel|Cat 7 Employee Commuting|Cat 8 Upstream Leased Assets|Cat 9 Downstream Transportation|Cat 10 Processing of Sold Products|Cat 11 Use of Sold Products|Cat 12 End of Life Treatment|Cat 13 Downstream Leased Assets|Cat 14 Franchises|Cat 15 Investments|N/A`',
    `status` STRING COMMENT 'Lifecycle status of the GHG emission record within the data management workflow: Draft (data entry in progress), Submitted (submitted for review), Under Review (being reviewed by HSE team), Approved (validated and approved for reporting), Rejected (returned for correction), Archived (historical record).. Valid values are `Draft|Submitted|Under Review|Approved|Rejected|Archived`',
    `verification_date` DATE COMMENT 'Date on which the GHG emission record or the inventory containing this record was verified or assured by the internal reviewer or third-party verifier.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verification_status` STRING COMMENT 'Current verification or assurance status of the emission record: Not Verified (raw data), Internal Review (reviewed by HSE team), Third-Party Verified (independent verifier), Limited Assurance, or Reasonable Assurance. Required for CDP disclosure and investor-grade reporting.. Valid values are `Not Verified|Internal Review|Third-Party Verified|Limited Assurance|Reasonable Assurance`',
    `verifier_name` STRING COMMENT 'Name of the accredited third-party verification body that conducted the GHG emission verification or assurance engagement (e.g., Bureau Veritas, SGS, DNV). Populated when verification_status is Third-Party Verified, Limited Assurance, or Reasonable Assurance.',
    CONSTRAINT pk_ghg_emission PRIMARY KEY(`ghg_emission_id`)
) COMMENT 'Greenhouse gas emission records tracking Scope 1 (direct), Scope 2 (purchased energy), and Scope 3 (value chain) GHG emissions from manufacturing operations. Captures emission source type, GHG type (CO2, CH4, N2O, HFCs, PFCs, SF6), activity data quantity and unit, emission factor applied, calculated CO2e quantity, reporting period, facility, GHG Protocol methodology applied, and verification status. Supports corporate carbon reporting, CDP disclosure, and Science Based Targets (SBTi) tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` (
    `chemical_regulatory_compliance_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each chemical-regulation compliance record',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to the chemical substance subject to regulatory compliance',
    `employee_id` BIGINT COMMENT 'Employee ID of the compliance officer responsible for managing this specific chemical-regulation compliance relationship.',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to the regulatory obligation applicable to the chemical',
    `applicable_threshold_quantity` DECIMAL(18,2) COMMENT 'The quantity threshold at which this regulatory obligation becomes applicable to this specific chemical substance (e.g., REACH tonnage bands, OSHA PEL limits). Threshold varies by chemical-regulation combination.',
    `compliance_status` STRING COMMENT 'Current compliance status of this specific chemical substance against this specific regulatory obligation. Tracks whether the substance meets the requirements of this regulation.',
    `effective_date` DATE COMMENT 'Date on which this regulatory obligation became applicable to this chemical substance. May differ from the regulations general effective date based on substance-specific phase-in schedules (e.g., REACH registration deadlines by tonnage band).',
    `exemption_code` STRING COMMENT 'Regulatory exemption code applicable to this specific chemical-regulation combination (e.g., RoHS Annex III exemption, REACH exemption for R&D use). Exemptions are substance and regulation specific.',
    `expiry_date` DATE COMMENT 'Date on which this regulatory obligation ceases to apply to this chemical substance (e.g., sunset date for exemptions, end of authorization period).',
    `jurisdiction_specific_limit` STRING COMMENT 'Jurisdiction-specific regulatory limit or requirement for this chemical under this regulation (e.g., California Prop 65 safe harbor level, EU REACH concentration limit). Varies by chemical-regulation-jurisdiction combination.',
    `last_assessment_date` DATE COMMENT 'Date on which compliance with this specific chemical-regulation pairing was last assessed or audited.',
    `next_assessment_due_date` DATE COMMENT 'Scheduled date for the next compliance assessment of this chemical against this regulatory obligation.',
    `notes` STRING COMMENT 'Free-text notes documenting compliance actions, exemption justifications, or special considerations for this chemical-regulation pairing.',
    `reporting_required_flag` BOOLEAN COMMENT 'Indicates whether regulatory reporting is required for this chemical-regulation pairing based on usage volumes, hazard classification, or jurisdiction-specific rules.',
    `threshold_unit_of_measure` STRING COMMENT 'Unit of measure for the applicable threshold quantity (kg, tonnes, ppm, mg/m3, etc.)',
    CONSTRAINT pk_chemical_regulatory_compliance PRIMARY KEY(`chemical_regulatory_compliance_id`)
) COMMENT 'This association product represents the compliance relationship between chemical substances and regulatory obligations in HSE operations. It captures the specific applicability, thresholds, and compliance status for each chemical-regulation pairing. Each record links one chemical substance to one regulatory obligation with jurisdiction-specific limits, reporting requirements, and exemption codes that exist only in the context of this compliance relationship.. Existence Justification: In industrial manufacturing HSE operations, chemical regulatory compliance is managed as an explicit many-to-many relationship. A single chemical substance (e.g., toluene) is simultaneously subject to multiple regulations (OSHA PEL, EPA TSCA, EU REACH, RoHS, Prop 65), each with different thresholds, reporting requirements, and exemption codes. Conversely, a single regulation (e.g., REACH) applies to thousands of chemical substances, each with substance-specific tonnage bands, registration deadlines, and SVHC listing status. EHS compliance teams actively manage this intersection using Chemical Regulatory Compliance Matrices, tracking which substances trigger which obligations at what thresholds.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`hse`.`audit_coverage` (
    `audit_coverage_id` BIGINT COMMENT 'Unique system-generated identifier for each audit coverage record linking a safety audit to a regulatory obligation',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to the regulatory obligation that was evaluated during this audit',
    `safety_audit_id` BIGINT COMMENT 'Foreign key linking to the safety audit that evaluated this regulatory obligation',
    `auditor_notes` STRING COMMENT 'Free-text notes recorded by the audit team regarding the evaluation of this specific regulatory obligation, including context, observations, or recommendations.',
    `clause_reference` STRING COMMENT 'Specific clause, section, or subsection of the regulatory obligation that was evaluated during this audit (e.g., 1910.1200(h) for OSHA HazCom training requirements).',
    `conformance_status` STRING COMMENT 'The compliance status determined for this specific regulatory obligation during this audit. Indicates whether the organization was found conformant, had non-conformances of varying severity, or had observations for improvement.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this audit coverage record was created in the HSE management system.',
    `evaluation_date` DATE COMMENT 'The specific date during the audit period when this regulatory obligation was evaluated, which may differ from the overall audit start/end dates.',
    `evidence_reviewed` STRING COMMENT 'Description of the evidence, documentation, or records reviewed by the audit team to evaluate compliance with this specific regulatory obligation (e.g., Training records, SDS library, labeling samples).',
    `finding_count` STRING COMMENT 'Number of audit findings (non-conformances, observations, or positive findings) specifically related to this regulatory obligation during this audit.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this audit coverage record was last updated.',
    `scope_inclusion_flag` BOOLEAN COMMENT 'Indicates whether this regulatory obligation was explicitly included in the scope of this specific audit (true) or was out of scope (false). Corresponds to audit_scope_inclusion_flag from detection data.',
    CONSTRAINT pk_audit_coverage PRIMARY KEY(`audit_coverage_id`)
) COMMENT 'This association product represents the operational coverage relationship between safety audits and regulatory obligations in HSE management. It captures which specific regulatory obligations are evaluated during each safety audit, with conformance results, findings, and evidence tracking. Each record links one safety audit to one regulatory obligation with attributes that exist only in the context of this audit-obligation evaluation.. Existence Justification: In industrial manufacturing HSE operations, safety audits routinely evaluate multiple regulatory obligations (OSHA, EPA, ISO standards), and each regulatory obligation is evaluated across multiple audits over time (annual audits, third-party certifications, regulatory inspections). HSE managers actively maintain an Audit Coverage Matrix to track which obligations are covered by which audits, with what conformance results, and to ensure all obligations receive periodic evaluation. This is an operational management tool, not an analytical correlation.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ADD CONSTRAINT `fk_hse_incident_investigation_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ADD CONSTRAINT `fk_hse_hse_audit_finding_safety_audit_id` FOREIGN KEY (`safety_audit_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_audit`(`safety_audit_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ADD CONSTRAINT `fk_hse_chemical_inventory_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ADD CONSTRAINT `fk_hse_chemical_inventory_sds_id` FOREIGN KEY (`sds_id`) REFERENCES `manufacturing_ecm`.`hse`.`sds`(`sds_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ADD CONSTRAINT `fk_hse_sds_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ADD CONSTRAINT `fk_hse_environmental_permit_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ADD CONSTRAINT `fk_hse_waste_record_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ADD CONSTRAINT `fk_hse_compliance_evaluation_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ADD CONSTRAINT `fk_hse_compliance_evaluation_hse_capa_id` FOREIGN KEY (`hse_capa_id`) REFERENCES `manufacturing_ecm`.`hse`.`hse_capa`(`hse_capa_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ADD CONSTRAINT `fk_hse_compliance_evaluation_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ADD CONSTRAINT `fk_hse_safety_training_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ADD CONSTRAINT `fk_hse_safety_training_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ADD CONSTRAINT `fk_hse_training_attendance_safety_training_id` FOREIGN KEY (`safety_training_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_training`(`safety_training_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ADD CONSTRAINT `fk_hse_ppe_requirement_hazard_assessment_id` FOREIGN KEY (`hazard_assessment_id`) REFERENCES `manufacturing_ecm`.`hse`.`hazard_assessment`(`hazard_assessment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ADD CONSTRAINT `fk_hse_hygiene_monitoring_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ADD CONSTRAINT `fk_hse_hygiene_monitoring_hse_capa_id` FOREIGN KEY (`hse_capa_id`) REFERENCES `manufacturing_ecm`.`hse`.`hse_capa`(`hse_capa_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ADD CONSTRAINT `fk_hse_emergency_drill_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `manufacturing_ecm`.`hse`.`emergency_response_plan`(`emergency_response_plan_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ADD CONSTRAINT `fk_hse_emergency_drill_hse_capa_id` FOREIGN KEY (`hse_capa_id`) REFERENCES `manufacturing_ecm`.`hse`.`hse_capa`(`hse_capa_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ADD CONSTRAINT `fk_hse_environmental_aspect_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ADD CONSTRAINT `fk_hse_hse_reach_substance_declaration_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_hazard_assessment_id` FOREIGN KEY (`hazard_assessment_id`) REFERENCES `manufacturing_ecm`.`hse`.`hazard_assessment`(`hazard_assessment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_hse_capa_id` FOREIGN KEY (`hse_capa_id`) REFERENCES `manufacturing_ecm`.`hse`.`hse_capa`(`hse_capa_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ADD CONSTRAINT `fk_hse_ghg_emission_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ADD CONSTRAINT `fk_hse_chemical_regulatory_compliance_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ADD CONSTRAINT `fk_hse_chemical_regulatory_compliance_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ADD CONSTRAINT `fk_hse_audit_coverage_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ADD CONSTRAINT `fk_hse_audit_coverage_safety_audit_id` FOREIGN KEY (`safety_audit_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_audit`(`safety_audit_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`hse` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`hse` SET TAGS ('dbx_domain' = 'hse');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Affected Person Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Product Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `lab_resource_id` SET TAGS ('dbx_business_glossary_term' = 'Lab Resource Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `procurement_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `tooling_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `affected_person_name` SET TAGS ('dbx_business_glossary_term' = 'Affected Person Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `affected_person_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `affected_person_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `affected_person_type` SET TAGS ('dbx_business_glossary_term' = 'Affected Person Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `affected_person_type` SET TAGS ('dbx_value_regex' = 'employee|contractor|temporary_worker|visitor|customer|third_party|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `body_part_affected` SET TAGS ('dbx_business_glossary_term' = 'Body Part Affected');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `body_part_affected` SET TAGS ('dbx_value_regex' = 'head|neck|eye|ear|back|shoulder|arm|hand|finger|leg|knee|foot|toe|trunk|multiple|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `chemical_name` SET TAGS ('dbx_business_glossary_term' = 'Chemical Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident Closed Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `contributing_factors` SET TAGS ('dbx_business_glossary_term' = 'Contributing Factors');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `days_away_from_work` SET TAGS ('dbx_business_glossary_term' = 'Days Away From Work');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `days_away_from_work` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `days_on_restricted_duty` SET TAGS ('dbx_business_glossary_term' = 'Days on Restricted Duty');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `days_on_restricted_duty` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Department');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Incident Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `environmental_media_affected` SET TAGS ('dbx_business_glossary_term' = 'Environmental Media Affected');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `environmental_media_affected` SET TAGS ('dbx_value_regex' = 'air|water|soil|groundwater|multiple|none|unknown');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Incident Cost');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `first_aid_provided` SET TAGS ('dbx_business_glossary_term' = 'First Aid Provided Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `first_aid_provided` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `hazard_category` SET TAGS ('dbx_business_glossary_term' = 'Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `hazard_category` SET TAGS ('dbx_value_regex' = 'chemical|biological|physical|ergonomic|electrical|mechanical|thermal|radiation|psychosocial|environmental|fire_explosion|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `immediate_cause` SET TAGS ('dbx_business_glossary_term' = 'Immediate Cause');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `injury_nature` SET TAGS ('dbx_business_glossary_term' = 'Injury Nature');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `injury_nature` SET TAGS ('dbx_value_regex' = 'laceration|fracture|burn|strain_sprain|contusion|amputation|chemical_exposure|inhalation|electric_shock|eye_injury|hearing_loss|repetitive_stress|fatality|illness|no_injury|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `investigation_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Completion Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `investigation_lead` SET TAGS ('dbx_business_glossary_term' = 'Investigation Lead');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `is_epa_reportable` SET TAGS ('dbx_business_glossary_term' = 'EPA Reportable Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `is_epa_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `is_osha_recordable` SET TAGS ('dbx_business_glossary_term' = 'OSHA Recordable Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `is_osha_recordable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `is_osha_reportable` SET TAGS ('dbx_business_glossary_term' = 'OSHA Reportable Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `is_osha_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `medical_treatment_required` SET TAGS ('dbx_business_glossary_term' = 'Medical Treatment Required Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `medical_treatment_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `medical_treatment_required` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `medical_treatment_required` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Incident Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^INC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `occurred_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident Occurred Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `regulatory_notification_deadline` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Deadline');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `regulatory_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `reported_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident Reported Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'unsafe_act|unsafe_condition|equipment_failure|procedural_non_compliance|inadequate_training|design_deficiency|environmental_factor|management_system_failure|human_error|unknown|pending_investigation');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Incident Severity');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|major|moderate|minor|negligible');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `shift` SET TAGS ('dbx_business_glossary_term' = 'Work Shift');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `shift` SET TAGS ('dbx_value_regex' = 'day|afternoon|night|weekend|rotating|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'sap_s4hana|siemens_opcenter_mes|maximo_eam|salesforce_crm|manual_entry|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Incident Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'reported|under_investigation|capa_in_progress|pending_closure|closed|voided');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Incident Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'injury|illness|near_miss|property_damage|environmental_spill|fire|explosion|chemical_release|equipment_failure|security|utility_disruption|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `incident_investigation_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Investigation ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `capa_record_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Investigator Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Actual Completion Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `capa_initiated` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Initiated');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `capa_initiated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Closure Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `contributing_factors` SET TAGS ('dbx_business_glossary_term' = 'Contributing Factors');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `corrective_action_summary` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Summary');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `immediate_cause` SET TAGS ('dbx_business_glossary_term' = 'Immediate Cause');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `incident_date` SET TAGS ('dbx_business_glossary_term' = 'Incident Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `investigation_findings` SET TAGS ('dbx_business_glossary_term' = 'Investigation Findings');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `investigation_number` SET TAGS ('dbx_business_glossary_term' = 'Investigation Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `investigation_number` SET TAGS ('dbx_value_regex' = '^INV-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `investigation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `investigation_team_members` SET TAGS ('dbx_business_glossary_term' = 'Investigation Team Members');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `investigation_type` SET TAGS ('dbx_business_glossary_term' = 'Investigation Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `investigation_type` SET TAGS ('dbx_value_regex' = 'incident|near_miss|hazard_observation|occupational_illness|environmental_release|property_damage|process_safety|security');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `iso_45001_nonconformity_type` SET TAGS ('dbx_business_glossary_term' = 'ISO 45001 Nonconformity Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `iso_45001_nonconformity_type` SET TAGS ('dbx_value_regex' = 'nonconformity|potential_nonconformity|observation|opportunity_for_improvement');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `lead_investigator_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Investigator Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `lead_investigator_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `lessons_learned` SET TAGS ('dbx_business_glossary_term' = 'Lessons Learned');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `osha_recordable` SET TAGS ('dbx_business_glossary_term' = 'OSHA Recordable Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `osha_recordable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `osha_reportable` SET TAGS ('dbx_business_glossary_term' = 'OSHA Reportable Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `osha_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `rca_methodology` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis (RCA) Methodology');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `rca_methodology` SET TAGS ('dbx_value_regex' = '5_why|fishbone_ishikawa|fault_tree_analysis|bow_tie|taproot|apollo|combination|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `recurrence_prevention_measures` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Prevention Measures');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `regulatory_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `regulatory_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Required Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `regulatory_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'human_factors|equipment_failure|process_procedure|environmental|management_system|training_competency|design_engineering|maintenance|material|organizational|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Investigation Severity Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|major|moderate|minor|low');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Investigation Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|open|in_progress|pending_review|pending_approval|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `systemic_cause` SET TAGS ('dbx_business_glossary_term' = 'Systemic Cause');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `target_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Target Completion Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Investigation Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ALTER COLUMN `work_area` SET TAGS ('dbx_business_glossary_term' = 'Work Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `hse_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Owner Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `eco_id` SET TAGS ('dbx_business_glossary_term' = 'Eco Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Originating Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `report_id` SET TAGS ('dbx_business_glossary_term' = 'Service Report Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Action Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standard');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_value_regex' = 'ISO_45001|ISO_14001|ISO_9001|ISO_50001|OSHA|EPA|REACH|RoHS|CE_marking|IEC_62443|NIST_CSF|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `assigned_department` SET TAGS ('dbx_business_glossary_term' = 'Assigned Department');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `assigned_owner_name` SET TAGS ('dbx_business_glossary_term' = 'Assigned Owner Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `assigned_owner_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Closure Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `closure_notes` SET TAGS ('dbx_business_glossary_term' = 'Closure Notes');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `effectiveness_review_date` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `effectiveness_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `effectiveness_review_outcome` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Review Outcome');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `effectiveness_review_outcome` SET TAGS ('dbx_value_regex' = 'sustained|recurrence_observed|inconclusive|pending');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `hse_domain_category` SET TAGS ('dbx_business_glossary_term' = 'Health, Safety, and Environment (HSE) Domain Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `hse_domain_category` SET TAGS ('dbx_value_regex' = 'occupational_health|occupational_safety|environmental|process_safety|chemical_hazard|fire_safety|ergonomics|radiation|noise|energy_management');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `immediate_containment_action` SET TAGS ('dbx_business_glossary_term' = 'Immediate Containment Action');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Implementation Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `implementation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `initiation_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Initiation Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `initiation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^CAPA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `originating_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Originating Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `originating_source_type` SET TAGS ('dbx_business_glossary_term' = 'Originating Source Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `originating_source_type` SET TAGS ('dbx_value_regex' = 'hse_incident|safety_audit|hazard_assessment|regulatory_inspection|environmental_monitoring|internal_audit|customer_complaint|management_review|near_miss|ncr');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Priority');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `regulatory_obligation_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `regulatory_obligation_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `related_capa_number` SET TAGS ('dbx_business_glossary_term' = 'Related Corrective and Preventive Action (CAPA) Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `related_capa_number` SET TAGS ('dbx_value_regex' = '^CAPA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `revised_due_date` SET TAGS ('dbx_business_glossary_term' = 'Revised Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `revised_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `root_cause_analysis_method` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis (RCA) Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `root_cause_analysis_method` SET TAGS ('dbx_value_regex' = 'five_why|fishbone|fmea|fault_tree|8d|pareto|brainstorming|other|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'human_error|process_failure|equipment_failure|material_defect|environmental_condition|management_system_gap|training_deficiency|design_deficiency|supplier_failure|unknown');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'sap_s4hana_qm|siemens_opcenter_mes|maximo_eam|salesforce_service|manual|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|open|in_progress|pending_verification|verified|closed|cancelled|overdue');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'corrective|preventive|improvement');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `verification_method` SET TAGS ('dbx_business_glossary_term' = 'Verification Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `verification_method` SET TAGS ('dbx_value_regex' = 'audit|inspection|testing|document_review|observation|measurement|management_review|third_party_review|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `verification_result` SET TAGS ('dbx_business_glossary_term' = 'Verification Result');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ALTER COLUMN `verification_result` SET TAGS ('dbx_value_regex' = 'effective|partially_effective|not_effective|pending');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `hazard_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Product Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `order_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Order Configuration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `additional_controls_required` SET TAGS ('dbx_business_glossary_term' = 'Additional Controls Required');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `affected_personnel_groups` SET TAGS ('dbx_business_glossary_term' = 'Affected Personnel Groups');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `approved_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_value_regex' = '^HA-[A-Z]{2,6}-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Methodology Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'HAZOP|FMEA|JSA|PFMEA|DFMEA|What-If|Checklist|Bow-Tie|LOPA|PHA|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Assessor Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `assessor_qualification` SET TAGS ('dbx_business_glossary_term' = 'Assessor Qualification / Certification');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Change Reason / Revision Basis');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `control_hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Control Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `control_hierarchy_level` SET TAGS ('dbx_value_regex' = 'Elimination|Substitution|Engineering Control|Administrative Control|PPE');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `existing_controls` SET TAGS ('dbx_business_glossary_term' = 'Existing Controls Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `hazard_category` SET TAGS ('dbx_business_glossary_term' = 'Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `hazard_category` SET TAGS ('dbx_value_regex' = 'Physical|Chemical|Biological|Ergonomic|Psychosocial|Electrical|Mechanical|Thermal|Radiation|Environmental|Fire|Explosion|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `hazard_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Hazard Subcategory');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `inherent_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Inherent Risk Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `inherent_risk_level` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low|Negligible');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `inherent_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Inherent Risk Score');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `inherent_risk_score` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-2][0-9]|25)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `likelihood_rating` SET TAGS ('dbx_business_glossary_term' = 'Likelihood Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `likelihood_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `pfmea_reference` SET TAGS ('dbx_business_glossary_term' = 'Process Failure Mode and Effects Analysis (PFMEA) Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `process_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Process Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulatory Requirement');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_likelihood_rating` SET TAGS ('dbx_business_glossary_term' = 'Residual Likelihood Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_likelihood_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Residual Risk Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_risk_level` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low|Negligible');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Residual Risk Score');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_risk_score` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-2][0-9]|25)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Residual Severity Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `residual_severity_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'Monthly|Quarterly|Semi-Annual|Annual|Biennial|Event-Triggered|As-Required');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `risk_acceptable` SET TAGS ('dbx_business_glossary_term' = 'Risk Acceptable Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `risk_acceptable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Severity Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `severity_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Draft|Under Review|Approved|Active|Superseded|Archived|Cancelled');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `work_activity` SET TAGS ('dbx_business_glossary_term' = 'Associated Work Activity');
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ALTER COLUMN `work_area` SET TAGS ('dbx_business_glossary_term' = 'Work Area / Zone');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `safety_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Audit ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Audited Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Audit End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Audit Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_category` SET TAGS ('dbx_business_glossary_term' = 'Audit Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_category` SET TAGS ('dbx_value_regex' = 'occupational_health_safety|environmental|energy_management|quality_hse|fire_safety|chemical_hazard|process_safety|ergonomics|emergency_preparedness|combined');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_criteria` SET TAGS ('dbx_business_glossary_term' = 'Audit Criteria');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_business_glossary_term' = 'Safety Audit Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^HSE-AUD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_program_reference` SET TAGS ('dbx_business_glossary_term' = 'Audit Program Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_scope` SET TAGS ('dbx_business_glossary_term' = 'Audit Scope');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_team_members` SET TAGS ('dbx_business_glossary_term' = 'Audit Team Members');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_business_glossary_term' = 'Audit Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'internal|third_party|regulatory|management_system|supplier|customer|surveillance|certification|pre_audit');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `auditee_representative` SET TAGS ('dbx_business_glossary_term' = 'Auditee Representative');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `capa_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `capa_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `certifying_body` SET TAGS ('dbx_business_glossary_term' = 'Certifying Body');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `checklist_items_total` SET TAGS ('dbx_business_glossary_term' = 'Total Audit Checklist Items');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `checklist_items_total` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Closure Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `conformance_score` SET TAGS ('dbx_business_glossary_term' = 'Audit Conformance Score');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `conformance_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `department_name` SET TAGS ('dbx_business_glossary_term' = 'Department Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `facility_site_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Site Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_critical_count` SET TAGS ('dbx_business_glossary_term' = 'Critical Findings Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_critical_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_major_count` SET TAGS ('dbx_business_glossary_term' = 'Major Non-Conformance Findings Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_major_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_minor_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Non-Conformance Findings Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_minor_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_observation_count` SET TAGS ('dbx_business_glossary_term' = 'Audit Observations Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `findings_observation_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `follow_up_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Audit Scheduled Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `follow_up_audit_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Audit Required');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `lead_auditor_certification` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Certification');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `lead_auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `management_review_input` SET TAGS ('dbx_business_glossary_term' = 'Management Review Input Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `management_review_input` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `overall_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Audit Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `overall_rating` SET TAGS ('dbx_value_regex' = 'satisfactory|minor_nonconformance|major_nonconformance|critical|observation_only|not_rated');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `positive_findings_count` SET TAGS ('dbx_business_glossary_term' = 'Positive Findings Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `positive_findings_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `previous_audit_reference` SET TAGS ('dbx_business_glossary_term' = 'Previous Audit Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_value_regex' = 'ISO_45001|ISO_14001|ISO_50001|ISO_9001|OSHA_29CFR1910|OSHA_29CFR1926|EPA|REACH|RoHS|CE_Marking|IEC_62443|NFPA|local_regulation|multiple');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Audit Remarks');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `report_issued_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Report Issued Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `report_issued_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `report_reference` SET TAGS ('dbx_business_glossary_term' = 'Audit Report Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `scheduled_end_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Audit End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `scheduled_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `scheduled_start_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Audit Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `scheduled_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Audit Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|on_hold|pending_review|closed');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Audit Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `hse_audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `capa_record_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `safety_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `applicable_standard_clause` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standard Clause');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `audit_standard` SET TAGS ('dbx_business_glossary_term' = 'Audit Standard');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `audit_standard` SET TAGS ('dbx_value_regex' = 'ISO_9001|ISO_14001|ISO_45001|ISO_50001|IEC_62443|OSHA|EPA|REACH|RoHS|CE_Marking|UL|NIST|ANSI|INTERNAL');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `audit_type` SET TAGS ('dbx_business_glossary_term' = 'Audit Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'internal_audit|external_audit|regulatory_inspection|supplier_audit|certification_audit|surveillance_audit|follow_up_audit');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Auditor Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `auditor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `auditor_organization` SET TAGS ('dbx_business_glossary_term' = 'Auditor Organization');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `chemical_substance_involved` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Involved Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `chemical_substance_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Finding Closed Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `closed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_category` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_category` SET TAGS ('dbx_value_regex' = 'safety|environmental|quality|regulatory_compliance|process|documentation|training|equipment|chemical_hazard|waste_management|energy|emergency_preparedness');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_number` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_number` SET TAGS ('dbx_value_regex' = '^HSE-AF-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_source` SET TAGS ('dbx_business_glossary_term' = 'Finding Source');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_source` SET TAGS ('dbx_value_regex' = 'planned_audit|unplanned_audit|regulatory_inspection|incident_investigation|management_review|customer_complaint|supplier_feedback|self_assessment');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_type` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `finding_type` SET TAGS ('dbx_value_regex' = 'major_nonconformity|minor_nonconformity|observation|opportunity_for_improvement|positive_finding');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `identified_date` SET TAGS ('dbx_business_glossary_term' = 'Finding Identified Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `identified_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `immediate_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Immediate Containment Action');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `objective_evidence` SET TAGS ('dbx_business_glossary_term' = 'Objective Evidence');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `previous_finding_reference` SET TAGS ('dbx_business_glossary_term' = 'Previous Finding Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `process_area` SET TAGS ('dbx_business_glossary_term' = 'Process Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reportable Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `regulatory_reported_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reported Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `regulatory_reported_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `repeat_finding` SET TAGS ('dbx_business_glossary_term' = 'Repeat Finding Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `repeat_finding` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `responsible_owner` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `responsible_owner` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `responsible_owner_email` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner Email Address');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `responsible_owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `responsible_owner_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `responsible_owner_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `revised_due_date` SET TAGS ('dbx_business_glossary_term' = 'Revised Corrective Action Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `revised_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'extreme|high|medium|low|negligible');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'human_error|process_failure|equipment_failure|training_deficiency|documentation_gap|management_system|supplier_issue|design_deficiency|environmental_condition|unknown');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Finding Severity');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|informational');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|pending_verification|closed|overdue|cancelled|deferred');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `verified_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Verified Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ALTER COLUMN `verified_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` SET TAGS ('dbx_subdomain' = 'chemical_management');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `material_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Material Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `approved_usage_locations` SET TAGS ('dbx_business_glossary_term' = 'Approved Usage Locations');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `boiling_point_celsius` SET TAGS ('dbx_business_glossary_term' = 'Boiling Point Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `cas_number` SET TAGS ('dbx_business_glossary_term' = 'Chemical Abstracts Service (CAS) Registry Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `cas_number` SET TAGS ('dbx_value_regex' = '^[0-9]{2,7}-[0-9]{2}-[0-9]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `common_name` SET TAGS ('dbx_business_glossary_term' = 'Chemical Common Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `dot_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'US Department of Transportation (DOT) Hazard Class');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `dot_hazard_class` SET TAGS ('dbx_value_regex' = '1|2|3|4|5|6|7|8|9|none');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `ec_number` SET TAGS ('dbx_business_glossary_term' = 'European Community (EC) Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `ec_number` SET TAGS ('dbx_value_regex' = '^[0-9]{3}-[0-9]{3}-[0-9]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Record Effective Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `environmental_hazard_category` SET TAGS ('dbx_business_glossary_term' = 'GHS Environmental Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `environmental_hazard_category` SET TAGS ('dbx_value_regex' = 'aquatic_acute|aquatic_chronic|ozone_depleting|persistent_bioaccumulative_toxic|none|multiple');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Record Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `flash_point_celsius` SET TAGS ('dbx_business_glossary_term' = 'Flash Point Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `ghs_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'Globally Harmonized System (GHS) Hazard Class');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `ghs_pictogram_codes` SET TAGS ('dbx_business_glossary_term' = 'Globally Harmonized System (GHS) Pictogram Codes');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `ghs_signal_word` SET TAGS ('dbx_business_glossary_term' = 'Globally Harmonized System (GHS) Signal Word');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `ghs_signal_word` SET TAGS ('dbx_value_regex' = 'Danger|Warning|None');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `hazard_statement_codes` SET TAGS ('dbx_business_glossary_term' = 'GHS Hazard Statement (H-Code) Codes');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `health_hazard_category` SET TAGS ('dbx_business_glossary_term' = 'GHS Health Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `health_hazard_category` SET TAGS ('dbx_value_regex' = 'acute_toxicity|skin_corrosion|eye_damage|respiratory_sensitizer|skin_sensitizer|carcinogen|mutagen|reproductive_toxin|target_organ_toxin|aspiration_hazard|none|multiple');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `iupac_name` SET TAGS ('dbx_business_glossary_term' = 'International Union of Pure and Applied Chemistry (IUPAC) Chemical Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `occupational_exposure_limit_mgm3` SET TAGS ('dbx_business_glossary_term' = 'Occupational Exposure Limit (OEL) in Milligrams per Cubic Meter (mg/m³)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `occupational_exposure_limit_ppm` SET TAGS ('dbx_business_glossary_term' = 'Occupational Exposure Limit (OEL) in Parts Per Million (PPM)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `physical_hazard_category` SET TAGS ('dbx_business_glossary_term' = 'GHS Physical Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `physical_hazard_category` SET TAGS ('dbx_value_regex' = 'flammable|explosive|oxidizer|self_reactive|pyrophoric|self_heating|water_reactive|organic_peroxide|corrosive_to_metals|none|multiple');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `physical_state` SET TAGS ('dbx_business_glossary_term' = 'Physical State');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `physical_state` SET TAGS ('dbx_value_regex' = 'solid|liquid|gas|aerosol|paste|powder|granule|unknown');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `precautionary_statement_codes` SET TAGS ('dbx_business_glossary_term' = 'GHS Precautionary Statement (P-Code) Codes');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `prop65_listed` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 Listed Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `prop65_listed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `reach_registration_number` SET TAGS ('dbx_business_glossary_term' = 'REACH Registration Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `reach_registration_number` SET TAGS ('dbx_value_regex' = '^01-[0-9]{10}-[0-9]{2}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `reach_registration_status` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Registration Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `reach_registration_status` SET TAGS ('dbx_value_regex' = 'registered|pre-registered|exempt|not_required|pending|unknown');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `regulatory_list_membership` SET TAGS ('dbx_business_glossary_term' = 'Regulatory List Membership');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `rohs_exemption_code` SET TAGS ('dbx_business_glossary_term' = 'RoHS Exemption Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `rohs_restricted` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Restricted Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `rohs_restricted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sara_313_reportable` SET TAGS ('dbx_business_glossary_term' = 'Superfund Amendments and Reauthorization Act (SARA) Title III Section 313 Reportable Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sara_313_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sds_document_number` SET TAGS ('dbx_business_glossary_term' = 'Safety Data Sheet (SDS) Document Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sds_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Safety Data Sheet (SDS) Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sds_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sds_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Safety Data Sheet (SDS) Issue Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sds_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `sds_version` SET TAGS ('dbx_business_glossary_term' = 'Safety Data Sheet (SDS) Version');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Record Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|restricted|phased_out|pending_approval');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `storage_temperature_max_celsius` SET TAGS ('dbx_business_glossary_term' = 'Maximum Storage Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `substance_type` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `substance_type` SET TAGS ('dbx_value_regex' = 'substance|mixture|article|intermediate|polymer|monomer|unknown');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `svhc_listed` SET TAGS ('dbx_business_glossary_term' = 'Substance of Very High Concern (SVHC) Listed Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `svhc_listed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `svhc_listing_date` SET TAGS ('dbx_business_glossary_term' = 'SVHC Candidate List Inclusion Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `svhc_listing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `trade_name` SET TAGS ('dbx_business_glossary_term' = 'Chemical Trade Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `tsca_status` SET TAGS ('dbx_business_glossary_term' = 'Toxic Substances Control Act (TSCA) Inventory Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `tsca_status` SET TAGS ('dbx_value_regex' = 'active|inactive|exempt|new_chemical|pmn_pending|not_listed|unknown');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Dangerous Goods Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` SET TAGS ('dbx_subdomain' = 'chemical_management');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `chemical_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Inventory ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `sds_id` SET TAGS ('dbx_business_glossary_term' = 'Sds Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `chemical_category` SET TAGS ('dbx_business_glossary_term' = 'Chemical Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `chemical_category` SET TAGS ('dbx_value_regex' = 'flammable_liquid|flammable_solid|oxidizer|corrosive|toxic|explosive|compressed_gas|reactive|carcinogen|environmental_hazard|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `containment_type` SET TAGS ('dbx_business_glossary_term' = 'Containment Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `containment_type` SET TAGS ('dbx_value_regex' = 'drum|ibc_tote|tank|cylinder|bag|bottle|pipeline|bulk_storage|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Chemical Disposal Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `disposal_method` SET TAGS ('dbx_value_regex' = 'licensed_waste_contractor|incineration|neutralization|recycling|solvent_recovery|landfill_approved|drain_permitted|return_to_supplier|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Chemical Expiration Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `expiration_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `ghs_pictogram_codes` SET TAGS ('dbx_business_glossary_term' = 'Globally Harmonized System (GHS) Pictogram Codes');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `last_physical_count_date` SET TAGS ('dbx_business_glossary_term' = 'Last Physical Count Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `last_physical_count_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Chemical Lot Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `max_authorized_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Authorized Quantity');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `max_authorized_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `next_count_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Physical Count Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `next_count_due_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `nfpa_flammability_rating` SET TAGS ('dbx_business_glossary_term' = 'National Fire Protection Association (NFPA) 704 Flammability Hazard Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `nfpa_flammability_rating` SET TAGS ('dbx_value_regex' = '0|1|2|3|4');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `nfpa_health_rating` SET TAGS ('dbx_business_glossary_term' = 'National Fire Protection Association (NFPA) 704 Health Hazard Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `nfpa_health_rating` SET TAGS ('dbx_value_regex' = '0|1|2|3|4');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `nfpa_reactivity_rating` SET TAGS ('dbx_business_glossary_term' = 'National Fire Protection Association (NFPA) 704 Reactivity Hazard Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `nfpa_reactivity_rating` SET TAGS ('dbx_value_regex' = '0|1|2|3|4');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `physical_state` SET TAGS ('dbx_business_glossary_term' = 'Physical State');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `physical_state` SET TAGS ('dbx_value_regex' = 'solid|liquid|gas|mixture');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `psm_covered` SET TAGS ('dbx_business_glossary_term' = 'Process Safety Management (PSM) Covered Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `psm_covered` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_business_glossary_term' = 'Quantity On Hand');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `reach_registered` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Registered Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `reach_registered` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Chemical Receipt Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `receipt_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'Chemical Inventory Record Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `record_number` SET TAGS ('dbx_value_regex' = '^CHEM-INV-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `reporting_year` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Year');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `reporting_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `rmp_covered` SET TAGS ('dbx_business_glossary_term' = 'Risk Management Program (RMP) Covered Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `rmp_covered` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Chemical Inventory Record Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|expired|depleted|quarantined|pending_disposal|disposed|recalled');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_condition_notes` SET TAGS ('dbx_business_glossary_term' = 'Storage Condition Notes');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_location_name` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Storage Temperature (Celsius)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_temperature_max_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Storage Temperature (Celsius)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `storage_temperature_min_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Chemical Supplier Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `tier2_reportable` SET TAGS ('dbx_business_glossary_term' = 'Tier II Reportable Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `tier2_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `tier2_threshold_quantity` SET TAGS ('dbx_business_glossary_term' = 'Emergency Planning and Community Right-to-Know Act (EPCRA) Tier II Reporting Threshold Quantity');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `tier2_threshold_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'kg|lb|g|ton|metric_ton|liter|gallon|cubic_meter|cubic_foot|unit|cylinder');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ALTER COLUMN `waste_code` SET TAGS ('dbx_business_glossary_term' = 'EPA Hazardous Waste Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` SET TAGS ('dbx_subdomain' = 'chemical_management');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `sds_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Data Sheet (SDS) ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `acgih_tlv` SET TAGS ('dbx_business_glossary_term' = 'ACGIH Threshold Limit Value (TLV)');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Applicable Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `disposal_methods` SET TAGS ('dbx_business_glossary_term' = 'Waste Disposal Methods');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `document_url` SET TAGS ('dbx_business_glossary_term' = 'SDS Document URL');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `document_url` SET TAGS ('dbx_value_regex' = '^https?://[^s]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `firefighting_measures` SET TAGS ('dbx_business_glossary_term' = 'Firefighting Measures');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `first_aid_measures` SET TAGS ('dbx_business_glossary_term' = 'First Aid Measures');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `flash_point_c` SET TAGS ('dbx_business_glossary_term' = 'Flash Point (°C)');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `flash_point_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,4}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `ghs_environmental_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'GHS Environmental Hazard Classification');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `ghs_health_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'GHS Health Hazard Classification');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `ghs_physical_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'GHS Physical Hazard Classification');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `ghs_revision` SET TAGS ('dbx_business_glossary_term' = 'GHS Revision Version');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `ghs_revision` SET TAGS ('dbx_value_regex' = '^GHS Rev.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `handling_precautions` SET TAGS ('dbx_business_glossary_term' = 'Handling Precautions');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `hazard_statement_codes` SET TAGS ('dbx_business_glossary_term' = 'GHS Hazard Statement Codes (H-Codes)');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `hazard_statement_codes` SET TAGS ('dbx_value_regex' = '^H[0-9]{3}(|H[0-9]{3})*$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `is_reach_svhc` SET TAGS ('dbx_business_glossary_term' = 'REACH Substance of Very High Concern (SVHC) Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `is_reach_svhc` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `is_rohs_restricted` SET TAGS ('dbx_business_glossary_term' = 'RoHS Restricted Substance Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `is_rohs_restricted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'SDS Issue Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'SDS Language Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'SDS Next Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Safety Data Sheet (SDS) Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `osha_pel` SET TAGS ('dbx_business_glossary_term' = 'OSHA Permissible Exposure Limit (PEL)');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `physical_state` SET TAGS ('dbx_business_glossary_term' = 'Physical State');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `physical_state` SET TAGS ('dbx_value_regex' = 'solid|liquid|gas|aerosol|paste|powder|granule');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `ppe_requirements` SET TAGS ('dbx_business_glossary_term' = 'Personal Protective Equipment (PPE) Requirements');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `precautionary_statement_codes` SET TAGS ('dbx_business_glossary_term' = 'GHS Precautionary Statement Codes (P-Codes)');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `precautionary_statement_codes` SET TAGS ('dbx_value_regex' = '^P[0-9]{3}(|P[0-9]{3})*$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `reach_registration_number` SET TAGS ('dbx_business_glossary_term' = 'REACH Registration Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `reach_registration_number` SET TAGS ('dbx_value_regex' = '^01-[0-9]{13}-[0-9]{2}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `regulatory_compliance_notes` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Notes');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `revision_date` SET TAGS ('dbx_business_glossary_term' = 'SDS Revision Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `revision_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `signal_word` SET TAGS ('dbx_business_glossary_term' = 'GHS Signal Word');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `signal_word` SET TAGS ('dbx_value_regex' = 'Danger|Warning|Not classified');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'SDS Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|superseded|archived|under_review|draft');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `storage_requirements` SET TAGS ('dbx_business_glossary_term' = 'Storage Requirements');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `substance_type` SET TAGS ('dbx_business_glossary_term' = 'Substance Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `substance_type` SET TAGS ('dbx_value_regex' = 'substance|mixture|article');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `supplier_emergency_phone` SET TAGS ('dbx_business_glossary_term' = 'Supplier Emergency Contact Phone Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `supplier_emergency_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-()]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `supplier_emergency_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `supplier_emergency_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `trade_name` SET TAGS ('dbx_business_glossary_term' = 'Chemical Trade Name / Product Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'SDS Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `regulatory_filing_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Permit Responsible Manager Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `amendment_date` SET TAGS ('dbx_business_glossary_term' = 'Permit Amendment Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `amendment_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `amendment_number` SET TAGS ('dbx_business_glossary_term' = 'Permit Amendment Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Permit Effective Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `emission_limit_description` SET TAGS ('dbx_business_glossary_term' = 'Emission and Discharge Limit Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Permit Expiration Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `expiration_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `facility_state_province` SET TAGS ('dbx_business_glossary_term' = 'Facility State or Province');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `insurance_bond_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Insurance or Financial Bond Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `insurance_bond_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Permit Issue Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `issuing_authority_country_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `issuing_authority_country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `issuing_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Regulatory Authority Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Regulatory Inspection Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `last_inspection_outcome` SET TAGS ('dbx_business_glossary_term' = 'Last Regulatory Inspection Outcome');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `last_inspection_outcome` SET TAGS ('dbx_value_regex' = 'compliant|minor_violation|major_violation|notice_of_violation|pending_review|not_inspected');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `major_source_flag` SET TAGS ('dbx_business_glossary_term' = 'Major Source Designation Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `major_source_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `monitoring_requirements_description` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Requirements Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `next_report_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Regulatory Report Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `next_report_due_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `open_violation_flag` SET TAGS ('dbx_business_glossary_term' = 'Open Permit Violation Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `open_violation_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_conditions_summary` SET TAGS ('dbx_business_glossary_term' = 'Permit Conditions Summary');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Permit Document Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Permit Fee Amount');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_fee_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_fee_currency` SET TAGS ('dbx_business_glossary_term' = 'Permit Fee Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_fee_currency` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_number` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_term_years` SET TAGS ('dbx_business_glossary_term' = 'Permit Term Duration (Years)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_type` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permit_type` SET TAGS ('dbx_value_regex' = 'air_emission_title_v|air_emission_nsr|wastewater_npdes|stormwater|hazardous_waste_rcra|solid_waste|noise|water_withdrawal|greenhouse_gas|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `permitted_activity_description` SET TAGS ('dbx_business_glossary_term' = 'Permitted Activity Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `public_notice_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Public Notice Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `public_notice_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `regulatory_program_code` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Program Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `renewal_status` SET TAGS ('dbx_business_glossary_term' = 'Permit Renewal Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `renewal_status` SET TAGS ('dbx_value_regex' = 'not_required|pending_submission|submitted|under_review|approved|denied|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `renewal_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Permit Renewal Submission Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `renewal_submission_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|semi_annual|annual|event_based|not_required');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `responsible_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Permit Responsible Manager Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|revoked|pending_issuance|pending_renewal|under_review|withdrawn|terminated');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ALTER COLUMN `violation_count` SET TAGS ('dbx_business_glossary_term' = 'Permit Violation Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `emission_monitoring_id` SET TAGS ('dbx_business_glossary_term' = 'Emission Monitoring ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `instrument_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Instrument ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Point ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `averaging_period` SET TAGS ('dbx_business_glossary_term' = 'Emission Averaging Period');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `averaging_period` SET TAGS ('dbx_value_regex' = 'instantaneous|hourly|daily|weekly|monthly|quarterly|annual|rolling_30_day|rolling_12_month');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `data_substitution_method` SET TAGS ('dbx_business_glossary_term' = 'Data Substitution Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `data_substitution_method` SET TAGS ('dbx_value_regex' = 'none|90th_percentile|average|conservative_estimate|permit_limit|prior_period_average');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `data_validity_flag` SET TAGS ('dbx_business_glossary_term' = 'Data Validity Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `data_validity_flag` SET TAGS ('dbx_value_regex' = 'valid|invalid|substitute|missing|estimated|quality_assured');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `deviation_report_reference` SET TAGS ('dbx_business_glossary_term' = 'Deviation Report Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `deviation_reported_flag` SET TAGS ('dbx_business_glossary_term' = 'Deviation Reported Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `deviation_reported_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `emission_medium` SET TAGS ('dbx_business_glossary_term' = 'Emission Medium');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `emission_medium` SET TAGS ('dbx_value_regex' = 'air|water|noise|soil');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `emission_source_type` SET TAGS ('dbx_business_glossary_term' = 'Emission Source Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `emission_source_type` SET TAGS ('dbx_value_regex' = 'point_source|fugitive_source|area_source|mobile_source|non_point_source');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `exceedance_flag` SET TAGS ('dbx_business_glossary_term' = 'Permit Limit Exceedance Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `exceedance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `exceedance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Exceedance Percentage');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `iso_14001_objective_reference` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Environmental Objective Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Instrument Calibration Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `measurement_value` SET TAGS ('dbx_business_glossary_term' = 'Emission Measurement Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_date` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_method` SET TAGS ('dbx_value_regex' = 'CEMS|manual_stack_test|predictive_emissions_monitoring|effluent_sampling|ambient_air_monitoring|noise_measurement|mass_balance|emission_factor');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_method_reference` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Method Reference Standard');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_point_name` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Point Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_record_number` SET TAGS ('dbx_business_glossary_term' = 'Emission Monitoring Record Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_record_number` SET TAGS ('dbx_value_regex' = '^EM-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `monitoring_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `operating_condition` SET TAGS ('dbx_business_glossary_term' = 'Operating Condition');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `operating_condition` SET TAGS ('dbx_value_regex' = 'normal|startup|shutdown|malfunction|maintenance|upset');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `permit_condition_reference` SET TAGS ('dbx_business_glossary_term' = 'Permit Condition Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `permit_limit_unit` SET TAGS ('dbx_business_glossary_term' = 'Permit Limit Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `permit_limit_value` SET TAGS ('dbx_business_glossary_term' = 'Permit Limit Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `pollutant_code` SET TAGS ('dbx_business_glossary_term' = 'Pollutant Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `pollutant_name` SET TAGS ('dbx_business_glossary_term' = 'Pollutant Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `production_rate` SET TAGS ('dbx_business_glossary_term' = 'Production Rate');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `production_rate_unit` SET TAGS ('dbx_business_glossary_term' = 'Production Rate Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `regulatory_reporting_period` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Period');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `regulatory_standard_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `sampled_by` SET TAGS ('dbx_business_glossary_term' = 'Sampled By');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `stack_flow_rate` SET TAGS ('dbx_business_glossary_term' = 'Stack Flow Rate');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `stack_flow_rate_unit` SET TAGS ('dbx_business_glossary_term' = 'Stack Flow Rate Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_record_id` SET TAGS ('dbx_business_glossary_term' = 'Waste Record ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Source Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `container_count` SET TAGS ('dbx_business_glossary_term' = 'Container Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `container_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Waste Container Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `container_type` SET TAGS ('dbx_value_regex' = 'drum|tote|bulk_tank|roll_off|bag|box|cylinder|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_cost` SET TAGS ('dbx_business_glossary_term' = 'Waste Disposal Cost');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Disposal Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_date` SET TAGS ('dbx_business_glossary_term' = 'Waste Disposal Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_facility_epa_code` SET TAGS ('dbx_business_glossary_term' = 'Disposal Facility EPA ID Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_facility_epa_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}[0-9]{9}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Disposal Facility Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Waste Disposal Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `disposal_method` SET TAGS ('dbx_value_regex' = 'landfill|incineration|recycling|treatment|fuel_blending|land_application|deep_well_injection|composting|energy_recovery|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `epa_waste_code` SET TAGS ('dbx_business_glossary_term' = 'EPA Waste Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `epa_waste_code` SET TAGS ('dbx_value_regex' = '^[A-Z][0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `generation_date` SET TAGS ('dbx_business_glossary_term' = 'Waste Generation Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `generation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `generation_source` SET TAGS ('dbx_business_glossary_term' = 'Waste Generation Source');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `generator_category` SET TAGS ('dbx_business_glossary_term' = 'Generator Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `generator_category` SET TAGS ('dbx_value_regex' = 'large_quantity_generator|small_quantity_generator|very_small_quantity_generator');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `manifest_number` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Waste Manifest Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `ncr_reference` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `physical_state` SET TAGS ('dbx_business_glossary_term' = 'Waste Physical State');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `physical_state` SET TAGS ('dbx_value_regex' = 'solid|liquid|gas|sludge|mixed');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `quantity_generated` SET TAGS ('dbx_business_glossary_term' = 'Quantity Generated');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `quantity_generated` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_value_regex' = 'kg|lb|ton|metric_ton|liter|gallon|cubic_meter|cubic_foot|unit');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `reach_regulated` SET TAGS ('dbx_business_glossary_term' = 'REACH Regulated Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `reach_regulated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'Waste Record Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `record_number` SET TAGS ('dbx_value_regex' = '^WR-[A-Z0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Waste Record Remarks');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `reporting_period` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Period');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `reporting_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-(Q[1-4]|H[12]|ANNUAL|BIENNIAL)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `rohs_restricted` SET TAGS ('dbx_business_glossary_term' = 'RoHS Restricted Substances Indicator');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `rohs_restricted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `shipment_date` SET TAGS ('dbx_business_glossary_term' = 'Waste Shipment Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `shipment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `state_waste_code` SET TAGS ('dbx_business_glossary_term' = 'State Waste Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Waste Record Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'generated|in_storage|awaiting_pickup|in_transit|disposed|treated|recycled|closed|void');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Waste Storage Location');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `storage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Storage Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `storage_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `un_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'UN Hazard Class');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `un_hazard_class` SET TAGS ('dbx_value_regex' = '^[1-9](.[1-9])?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_contractor_license` SET TAGS ('dbx_business_glossary_term' = 'Waste Contractor License Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_contractor_name` SET TAGS ('dbx_business_glossary_term' = 'Licensed Waste Contractor Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_contractor_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_contractor_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_description` SET TAGS ('dbx_business_glossary_term' = 'Waste Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_minimization_category` SET TAGS ('dbx_business_glossary_term' = 'Waste Minimization Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_minimization_category` SET TAGS ('dbx_value_regex' = 'source_reduction|recycling|treatment|disposal|energy_recovery');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_type` SET TAGS ('dbx_business_glossary_term' = 'Waste Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ALTER COLUMN `waste_type` SET TAGS ('dbx_value_regex' = 'hazardous|non_hazardous|universal|e_waste|radioactive|mixed');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `energy_consumption_id` SET TAGS ('dbx_business_glossary_term' = 'Energy Consumption Record ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Energy Meter ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `baseline_consumption_gj` SET TAGS ('dbx_business_glossary_term' = 'Baseline Energy Consumption in Gigajoules (GJ)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `baseline_year` SET TAGS ('dbx_business_glossary_term' = 'Baseline Year');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `baseline_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `billing_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `billing_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `billing_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `billing_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `carbon_emission_factor` SET TAGS ('dbx_business_glossary_term' = 'Carbon Emission Factor');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `carbon_emission_factor_source` SET TAGS ('dbx_business_glossary_term' = 'Carbon Emission Factor Source');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `carbon_emission_factor_source` SET TAGS ('dbx_value_regex' = 'epa_egrid|iea|defra|national_grid|supplier_specific|ipcc|custom');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `co2e_emissions_kg` SET TAGS ('dbx_business_glossary_term' = 'CO2 Equivalent (CO2e) Emissions in Kilograms');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `consumption_quantity` SET TAGS ('dbx_business_glossary_term' = 'Energy Consumption Quantity');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `consumption_quantity_gj` SET TAGS ('dbx_business_glossary_term' = 'Energy Consumption Quantity in Gigajoules (GJ)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_business_glossary_term' = 'Data Quality Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_value_regex' = 'actual|estimated|interpolated|substituted|erroneous');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `energy_cost` SET TAGS ('dbx_business_glossary_term' = 'Energy Cost');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `energy_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `energy_source_subtype` SET TAGS ('dbx_business_glossary_term' = 'Energy Source Subtype');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `energy_source_type` SET TAGS ('dbx_business_glossary_term' = 'Energy Source Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `energy_source_type` SET TAGS ('dbx_value_regex' = 'electricity|natural_gas|compressed_air|steam|diesel|lpg|fuel_oil|coal|biomass|solar|wind|chilled_water|hot_water|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `ghg_scope` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Scope');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `ghg_scope` SET TAGS ('dbx_value_regex' = 'scope_1|scope_2_location_based|scope_2_market_based|scope_3');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `invoice_reference` SET TAGS ('dbx_business_glossary_term' = 'Utility Invoice Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `measurement_interval` SET TAGS ('dbx_business_glossary_term' = 'Measurement Interval');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `measurement_interval` SET TAGS ('dbx_value_regex' = '15_min|30_min|hourly|daily|weekly|monthly|quarterly|annual');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `meter_name` SET TAGS ('dbx_business_glossary_term' = 'Energy Meter Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `meter_type` SET TAGS ('dbx_business_glossary_term' = 'Energy Meter Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `meter_type` SET TAGS ('dbx_value_regex' = 'main_meter|sub_meter|check_meter|virtual_meter');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `reading_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Meter Reading Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `reading_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `rec_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Renewable Energy Certificate (REC) Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'Energy Consumption Record Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `record_number` SET TAGS ('dbx_value_regex' = '^EC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `relevant_variable` SET TAGS ('dbx_business_glossary_term' = 'Energy Relevant Variable');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `relevant_variable_uom` SET TAGS ('dbx_business_glossary_term' = 'Relevant Variable Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `relevant_variable_value` SET TAGS ('dbx_business_glossary_term' = 'Relevant Variable Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `renewable_energy_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewable Energy Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `renewable_energy_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Record Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|validated|approved|rejected|archived');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `unit_rate` SET TAGS ('dbx_business_glossary_term' = 'Energy Unit Rate');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `unit_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `uom` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `uom` SET TAGS ('dbx_value_regex' = 'kWh|MWh|GJ|MJ|m3|Nm3|kg|MMBtu|therms|kVAh|ton');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `utility_account_number` SET TAGS ('dbx_business_glossary_term' = 'Utility Account Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `utility_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `utility_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `utility_provider_name` SET TAGS ('dbx_business_glossary_term' = 'Utility Provider Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ALTER COLUMN `work_area` SET TAGS ('dbx_business_glossary_term' = 'Work Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `energy_target_id` SET TAGS ('dbx_business_glossary_term' = 'Energy Target ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `achievement_percentage` SET TAGS ('dbx_business_glossary_term' = 'Target Achievement Percentage');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `action_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'Energy Action Plan Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `baseline_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Period End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `baseline_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `baseline_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Period Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `baseline_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `baseline_value` SET TAGS ('dbx_business_glossary_term' = 'Energy Baseline Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Target Change Reason');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `energy_source` SET TAGS ('dbx_business_glossary_term' = 'Energy Source');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `energy_source` SET TAGS ('dbx_value_regex' = 'electricity|natural_gas|diesel|steam|compressed_air|chilled_water|renewable_electricity|biomass|hydrogen|all');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `enpi_name` SET TAGS ('dbx_business_glossary_term' = 'Energy Performance Indicator (EnPI) Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `ensu_name` SET TAGS ('dbx_business_glossary_term' = 'Energy-Significant Use (EnSU) Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `estimated_cost_savings` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost Savings');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `estimated_cost_savings` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `investment_amount` SET TAGS ('dbx_business_glossary_term' = 'Investment Amount');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `investment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `management_review_cycle` SET TAGS ('dbx_business_glossary_term' = 'Management Review Cycle Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `measurement_boundary` SET TAGS ('dbx_business_glossary_term' = 'Energy Measurement Boundary');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `measurement_boundary` SET TAGS ('dbx_value_regex' = 'facility|production_line|department|equipment|building|campus|enterprise|process');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `relevant_variable` SET TAGS ('dbx_business_glossary_term' = 'Relevant Variable');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `responsible_owner_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Target Review Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|on_track|at_risk|behind|achieved|not_achieved|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_category` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_category` SET TAGS ('dbx_value_regex' = 'strategic|operational|tactical|regulatory|voluntary');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_end_date` SET TAGS ('dbx_business_glossary_term' = 'Target Period End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_number` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_number` SET TAGS ('dbx_value_regex' = '^ENT-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_start_date` SET TAGS ('dbx_business_glossary_term' = 'Target Period Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_type` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_type` SET TAGS ('dbx_value_regex' = 'absolute_reduction|intensity_improvement|renewable_increase|efficiency_improvement|consumption_cap|carbon_reduction');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_unit` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Unit');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_unit` SET TAGS ('dbx_value_regex' = 'kWh|MWh|GWh|GJ|TJ|MJ|kWh/unit|GJ/tonne|kWh/m2|kWh/hour|percent|tCO2e|kgCO2e');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Energy Target Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Target Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ALTER COLUMN `voluntary_commitment` SET TAGS ('dbx_business_glossary_term' = 'Voluntary Commitment Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `applicable_facility_scope` SET TAGS ('dbx_business_glossary_term' = 'Applicable Facility Scope');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `applicable_facility_scope` SET TAGS ('dbx_value_regex' = 'ALL_FACILITIES|SPECIFIC_FACILITY|FACILITY_TYPE|PROCESS_SPECIFIC|PRODUCT_SPECIFIC');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `applicable_process_area` SET TAGS ('dbx_business_glossary_term' = 'Applicable Process Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standard');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_value_regex' = 'ISO_9001|ISO_14001|ISO_45001|ISO_50001|IEC_61131|IEC_62443|OSHA|EPA|REACH|RoHS|CE_MARKING|UL|NIST|ANSI|GAAP|IFRS|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `chemical_substance_flag` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `chemical_substance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `compliance_frequency` SET TAGS ('dbx_business_glossary_term' = 'Compliance Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `compliance_frequency` SET TAGS ('dbx_value_regex' = 'ONE_TIME|DAILY|WEEKLY|MONTHLY|QUARTERLY|SEMI_ANNUAL|ANNUAL|BIENNIAL|AS_REQUIRED|CONTINUOUS');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `compliance_requirement_summary` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirement Summary');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'COMPLIANT|NON_COMPLIANT|PARTIALLY_COMPLIANT|NOT_ASSESSED|IN_PROGRESS|WAIVED');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_value_regex' = 'OSHA|EPA|EU_COMMISSION|IEC|ISO|ANSI|NIST|UL|LOCAL_AUTHORITY|STATE_AGENCY|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `jurisdiction_country_code` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `jurisdiction_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `jurisdiction_level` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `jurisdiction_level` SET TAGS ('dbx_value_regex' = 'FEDERAL|STATE|LOCAL|SUPRANATIONAL|INTERNATIONAL');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `jurisdiction_state_province` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction State or Province');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `last_compliance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Compliance Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `last_compliance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `max_penalty_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Penalty Amount');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `max_penalty_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `next_compliance_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Compliance Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `next_compliance_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `obligation_category` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `obligation_category` SET TAGS ('dbx_value_regex' = 'OCCUPATIONAL_HEALTH_SAFETY|ENVIRONMENTAL|CHEMICAL_HAZARD|EMISSIONS|WASTE_MANAGEMENT|ENERGY|PRODUCT_COMPLIANCE|FIRE_SAFETY|PROCESS_SAFETY|ERGONOMICS|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `obligation_number` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `obligation_number` SET TAGS ('dbx_value_regex' = '^REG-[A-Z]{2,6}-[0-9]{4}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `obligation_type` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `obligation_type` SET TAGS ('dbx_value_regex' = 'PERMIT|REPORTING|TRAINING|INSPECTION|RECORD_KEEPING|LABELING|REGISTRATION|CERTIFICATION|MONITORING|STANDARD_COMPLIANCE|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Penalty Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `penalty_for_non_compliance` SET TAGS ('dbx_business_glossary_term' = 'Penalty for Non-Compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `permit_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Permit Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `permit_required` SET TAGS ('dbx_business_glossary_term' = 'Permit Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `permit_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `regulation_code` SET TAGS ('dbx_business_glossary_term' = 'Regulation Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `regulation_name` SET TAGS ('dbx_business_glossary_term' = 'Regulation Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `reporting_required` SET TAGS ('dbx_business_glossary_term' = 'Reporting Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `reporting_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|REGULATORY_DATABASE|LEGAL_TRACKER|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `standard_clause_reference` SET TAGS ('dbx_business_glossary_term' = 'Standard Clause Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'ACTIVE|INACTIVE|UNDER_REVIEW|SUPERSEDED|PENDING_EFFECTIVE|EXPIRED');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `compliance_evaluation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluator Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `hse_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `applicable_standard_clause` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standard Clause');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation Closure Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|partially_compliant|non_compliant|not_applicable|pending_verification');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_value_regex' = 'document_review|site_inspection|monitoring_data_review|interview|sampling|combined');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_number` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_number` SET TAGS ('dbx_value_regex' = '^CE-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_type` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluation_type` SET TAGS ('dbx_value_regex' = 'periodic|triggered|initial|follow_up|regulatory_inspection');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluator_name` SET TAGS ('dbx_business_glossary_term' = 'Evaluator Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluator_type` SET TAGS ('dbx_business_glossary_term' = 'Evaluator Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evaluator_type` SET TAGS ('dbx_value_regex' = 'internal|external|regulatory_authority');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `evidence_reference` SET TAGS ('dbx_business_glossary_term' = 'Evidence Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Compliance Findings Summary');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `follow_up_action_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `follow_up_action_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `follow_up_due_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `follow_up_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `iso_standard_reference` SET TAGS ('dbx_business_glossary_term' = 'ISO Standard Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `iso_standard_reference` SET TAGS ('dbx_value_regex' = 'ISO_14001|ISO_45001|ISO_50001|ISO_9001|IEC_62443|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `management_review_input` SET TAGS ('dbx_business_glossary_term' = 'Management Review Input Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `management_review_input` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `next_evaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Next Compliance Evaluation Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `next_evaluation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `non_conformance_description` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `obligation_category` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `obligation_category` SET TAGS ('dbx_value_regex' = 'environmental|occupational_health_safety|energy_management|chemical_hazard|emissions|waste_management|product_compliance|process_safety|fire_safety|electrical_safety|ergonomics|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `process_area` SET TAGS ('dbx_business_glossary_term' = 'Process Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_value_regex' = 'OSHA|EPA|ISO|IEC|ANSI|EU_CE|REACH|RoHS|NIST|UL|LOCAL_AUTHORITY|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `regulatory_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `regulatory_notification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `regulatory_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `regulatory_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SIEMENS_OPCENTER|MAXIMO|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|overdue');
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evaluation Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `safety_training_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Training ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `knowledge_article_id` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `incident_id` SET TAGS ('dbx_business_glossary_term' = 'Linked Incident Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Trainer Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `employee_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `assessment_method` SET TAGS ('dbx_business_glossary_term' = 'Assessment Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `assessment_method` SET TAGS ('dbx_value_regex' = 'written_test|practical_demonstration|observation|oral_examination|simulation|no_assessment|sign_off_only');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `attendee_count` SET TAGS ('dbx_business_glossary_term' = 'Number of Attendees');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `attendee_count` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `certificate_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `certificate_issued` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issued Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `certificate_issued` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Training Delivery Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'classroom|e_learning|on_the_job|virtual_instructor_led|blended|video|simulation|toolbox_talk|self_study|external_course');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `department_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Training Duration (Hours)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `duration_hours` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `external_provider_name` SET TAGS ('dbx_business_glossary_term' = 'External Training Provider Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `facility_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `fail_count` SET TAGS ('dbx_business_glossary_term' = 'Fail Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `fail_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `includes_contractors` SET TAGS ('dbx_business_glossary_term' = 'Includes Contractors Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `includes_contractors` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `language` SET TAGS ('dbx_business_glossary_term' = 'Training Language');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `language` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}(-[A-Z]{2,3})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `minimum_pass_score` SET TAGS ('dbx_business_glossary_term' = 'Minimum Pass Score (Percent)');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `minimum_pass_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `osha_standard_code` SET TAGS ('dbx_business_glossary_term' = 'Occupational Safety and Health Administration (OSHA) Standard Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `osha_standard_code` SET TAGS ('dbx_value_regex' = 'OSHA_10|OSHA_30|OSHA_10_CONSTRUCTION|OSHA_30_CONSTRUCTION|HAZWOPER_8HR|HAZWOPER_24HR|HAZWOPER_40HR|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `pass_count` SET TAGS ('dbx_business_glossary_term' = 'Pass Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `pass_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Training Program Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Training Program Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `retraining_required_date` SET TAGS ('dbx_business_glossary_term' = 'Retraining Required Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `retraining_required_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|OPCENTER_MES|KRONOS|MANUAL|EXTERNAL_LMS|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Training Record Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|postponed|pending_approval');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `target_audience` SET TAGS ('dbx_business_glossary_term' = 'Target Audience');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `target_audience` SET TAGS ('dbx_value_regex' = 'all_employees|new_hires|contractors|supervisors|managers|maintenance_technicians|operators|emergency_response_team|specific_department');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `trainer_name` SET TAGS ('dbx_business_glossary_term' = 'Trainer Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `trainer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `trainer_type` SET TAGS ('dbx_business_glossary_term' = 'Trainer Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `trainer_type` SET TAGS ('dbx_value_regex' = 'internal|external|regulatory_body|online_platform');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_category` SET TAGS ('dbx_business_glossary_term' = 'Training Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_category` SET TAGS ('dbx_value_regex' = 'lockout_tagout|confined_space|hazcom|fire_safety|ppe|electrical_safety|fall_protection|ergonomics|emergency_response|environmental|chemical_handling|machine_guarding|forklift|first_aid|iso_45001_awareness|general_hse');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_date` SET TAGS ('dbx_business_glossary_term' = 'Training Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_end_time` SET TAGS ('dbx_business_glossary_term' = 'Training End Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_end_time` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_material_version` SET TAGS ('dbx_business_glossary_term' = 'Training Material Version');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_material_version` SET TAGS ('dbx_value_regex' = '^v?d+(.d+){0,2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_record_number` SET TAGS ('dbx_business_glossary_term' = 'Training Record Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_record_number` SET TAGS ('dbx_value_regex' = '^TRN-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_start_time` SET TAGS ('dbx_business_glossary_term' = 'Training Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_start_time` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_type` SET TAGS ('dbx_business_glossary_term' = 'Training Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `training_type` SET TAGS ('dbx_value_regex' = 'initial|refresher|regulatory_mandated|toolbox_talk|on_the_job|emergency_response|contractor_induction|management_briefing');
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ALTER COLUMN `work_area` SET TAGS ('dbx_business_glossary_term' = 'Work Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `training_attendance_id` SET TAGS ('dbx_business_glossary_term' = 'Training Attendance ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Attendee Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `safety_training_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Training Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `absence_reason` SET TAGS ('dbx_business_glossary_term' = 'Absence Reason');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `absence_reason` SET TAGS ('dbx_value_regex' = 'medical|operational_conflict|personal|travel|no_show|rescheduled|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `assessment_attempt_number` SET TAGS ('dbx_business_glossary_term' = 'Assessment Attempt Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `assessment_attempt_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `assessment_result` SET TAGS ('dbx_business_glossary_term' = 'Assessment Result');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `assessment_result` SET TAGS ('dbx_value_regex' = 'pass|fail|not_assessed|pending|waived');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `assessment_score` SET TAGS ('dbx_business_glossary_term' = 'Assessment Score');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `assessment_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendance_number` SET TAGS ('dbx_business_glossary_term' = 'Training Attendance Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendance_number` SET TAGS ('dbx_value_regex' = '^TA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendance_status` SET TAGS ('dbx_business_glossary_term' = 'Attendance Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendance_status` SET TAGS ('dbx_value_regex' = 'attended|absent|excused|partial|late|cancelled');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendee_full_name` SET TAGS ('dbx_business_glossary_term' = 'Attendee Full Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendee_full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendee_full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendee_type` SET TAGS ('dbx_business_glossary_term' = 'Attendee Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `attendee_type` SET TAGS ('dbx_value_regex' = 'employee|contractor|temporary_worker|visitor|intern|subcontractor');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `certificate_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `certificate_issued` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issued Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `certificate_issued` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Training Certificate Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `competency_verified` SET TAGS ('dbx_business_glossary_term' = 'Competency Verified Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `competency_verified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `job_title` SET TAGS ('dbx_business_glossary_term' = 'Attendee Job Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `mandatory_training_flag` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Training Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `mandatory_training_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `passing_score_threshold` SET TAGS ('dbx_business_glossary_term' = 'Passing Score Threshold');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `passing_score_threshold` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `regulatory_requirement_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `remedial_due_date` SET TAGS ('dbx_business_glossary_term' = 'Remedial Training Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `remedial_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `remedial_training_required` SET TAGS ('dbx_business_glossary_term' = 'Remedial Training Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `remedial_training_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `session_date` SET TAGS ('dbx_business_glossary_term' = 'Training Session Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `session_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|OPCENTER_MES|KRONOS|MAXIMO|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `supervisor_acknowledgement` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Acknowledgement Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `supervisor_acknowledgement` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `trainer_name` SET TAGS ('dbx_business_glossary_term' = 'Trainer Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `trainer_qualification` SET TAGS ('dbx_business_glossary_term' = 'Trainer Qualification');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `training_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Training Duration Hours');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `training_duration_hours` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `training_location` SET TAGS ('dbx_business_glossary_term' = 'Training Location');
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ALTER COLUMN `training_provider` SET TAGS ('dbx_business_glossary_term' = 'Training Provider');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `ppe_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Personal Protective Equipment (PPE) Requirement ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `bop_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Bop Operation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `hazard_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_business_glossary_term' = 'PPE Applicability Scope');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_value_regex' = 'work_area|job_role|task|hazard_zone|process|equipment');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standard');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_value_regex' = 'ANSI|NFPA_70E|ISO_45001|EN_166|EN_397|EN_388|EN_374|OSHA_29_CFR|NIOSH|CE_Marking|AS_NZS|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `arc_flash_incident_energy_calcm2` SET TAGS ('dbx_business_glossary_term' = 'Arc Flash Incident Energy (cal/cm²)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `arc_flash_incident_energy_calcm2` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `arc_flash_ppe_category` SET TAGS ('dbx_business_glossary_term' = 'Arc Flash PPE Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `arc_flash_ppe_category` SET TAGS ('dbx_value_regex' = 'category_1|category_2|category_3|category_4|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `contractor_applicable` SET TAGS ('dbx_business_glossary_term' = 'Contractor Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `contractor_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'PPE Requirement Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `fit_test_required` SET TAGS ('dbx_business_glossary_term' = 'Fit Test Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `fit_test_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `hazard_basis_description` SET TAGS ('dbx_business_glossary_term' = 'Hazard Basis Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `hazard_category` SET TAGS ('dbx_business_glossary_term' = 'Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `hazard_category` SET TAGS ('dbx_value_regex' = 'electrical|chemical|mechanical|thermal|noise|radiation|biological|ergonomic|fall|dust|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `inspection_frequency` SET TAGS ('dbx_business_glossary_term' = 'PPE Inspection Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `inspection_frequency` SET TAGS ('dbx_value_regex' = 'before_each_use|daily|weekly|monthly|quarterly|annual|as_required');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `job_role` SET TAGS ('dbx_business_glossary_term' = 'Job Role');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `noise_exposure_level_dba` SET TAGS ('dbx_business_glossary_term' = 'Noise Exposure Level (dBA)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `noise_exposure_level_dba` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `ppe_additional_types` SET TAGS ('dbx_business_glossary_term' = 'PPE Additional Types');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `ppe_specification` SET TAGS ('dbx_business_glossary_term' = 'PPE Specification');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `ppe_type` SET TAGS ('dbx_business_glossary_term' = 'PPE Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `ppe_type` SET TAGS ('dbx_value_regex' = 'hard_hat|safety_glasses|face_shield|safety_goggles|gloves|chemical_resistant_gloves|cut_resistant_gloves|respirator|scba|hearing_protection|arc_flash_ppe|high_visibility_vest|safety_footwear|fall_arrest_harness|chemical_suit|welding_shield|knee_pa...');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `requirement_number` SET TAGS ('dbx_business_glossary_term' = 'PPE Requirement Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `requirement_number` SET TAGS ('dbx_value_regex' = '^PPE-[A-Z]{2,6}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `requirement_type` SET TAGS ('dbx_business_glossary_term' = 'PPE Requirement Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `requirement_type` SET TAGS ('dbx_value_regex' = 'mandatory|recommended|conditional');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `respiratory_hazard_type` SET TAGS ('dbx_business_glossary_term' = 'Respiratory Hazard Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `respiratory_hazard_type` SET TAGS ('dbx_value_regex' = 'particulate|gas_vapor|oxygen_deficient|combination|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'annual|biannual|quarterly|on_change|on_incident|as_required');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `sop_reference` SET TAGS ('dbx_business_glossary_term' = 'Standard Operating Procedure (SOP) Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Maximo_EAM|Siemens_Opcenter_MES|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `standard_clause_reference` SET TAGS ('dbx_business_glossary_term' = 'Standard Clause Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'PPE Requirement Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|superseded|draft');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `task_description` SET TAGS ('dbx_business_glossary_term' = 'Task Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'PPE Requirement Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `training_required` SET TAGS ('dbx_business_glossary_term' = 'Training Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `training_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `visitor_applicable` SET TAGS ('dbx_business_glossary_term' = 'Visitor Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ALTER COLUMN `visitor_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` SET TAGS ('dbx_original_name' = 'industrial_hygiene_monitoring');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `hygiene_monitoring_id` SET TAGS ('dbx_business_glossary_term' = 'Hygiene Monitoring ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `hse_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Monitored Worker Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `action_level_exceeded_flag` SET TAGS ('dbx_business_glossary_term' = 'Action Level Exceeded Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `action_level_exceeded_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `analytical_method` SET TAGS ('dbx_business_glossary_term' = 'Analytical Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `below_detection_limit_flag` SET TAGS ('dbx_business_glossary_term' = 'Below Detection Limit Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `below_detection_limit_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `detection_limit` SET TAGS ('dbx_business_glossary_term' = 'Limit of Detection (LOD)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `exposure_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Exposure Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `exposure_duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `exposure_risk_band` SET TAGS ('dbx_business_glossary_term' = 'Exposure Risk Band');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `exposure_risk_band` SET TAGS ('dbx_value_regex' = 'negligible|low|moderate|high|very_high');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `hazard_category` SET TAGS ('dbx_business_glossary_term' = 'Hazard Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `hazard_category` SET TAGS ('dbx_value_regex' = 'chemical|physical|biological|ergonomic|radiation_ionizing|radiation_non_ionizing|thermal');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `industrial_hygienist_name` SET TAGS ('dbx_business_glossary_term' = 'Industrial Hygienist Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `job_title` SET TAGS ('dbx_business_glossary_term' = 'Job Title / Similar Exposure Group');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `laboratory_name` SET TAGS ('dbx_business_glossary_term' = 'Analytical Laboratory Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `laboratory_sample_number` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Sample ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `measured_value` SET TAGS ('dbx_business_glossary_term' = 'Measured Exposure Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitored_agent` SET TAGS ('dbx_business_glossary_term' = 'Monitored Agent');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_date` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_number` SET TAGS ('dbx_business_glossary_term' = 'Hygiene Monitoring Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_number` SET TAGS ('dbx_value_regex' = '^HYG-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_purpose` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Purpose');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_purpose` SET TAGS ('dbx_value_regex' = 'baseline|routine_surveillance|complaint_investigation|post_control_verification|regulatory_compliance|exposure_assessment|health_surveillance');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_type` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `monitoring_type` SET TAGS ('dbx_value_regex' = 'air_sampling|noise_dosimetry|radiation_monitoring|biological_monitoring|skin_exposure|heat_stress|vibration|illumination|ergonomic');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `next_monitoring_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Monitoring Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `next_monitoring_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `oel_ceiling_value` SET TAGS ('dbx_business_glossary_term' = 'Occupational Exposure Limit (OEL) Ceiling Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `oel_exceedance_flag` SET TAGS ('dbx_business_glossary_term' = 'OEL Exceedance Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `oel_exceedance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `oel_stel_value` SET TAGS ('dbx_business_glossary_term' = 'Occupational Exposure Limit (OEL) STEL Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `oel_twa_value` SET TAGS ('dbx_business_glossary_term' = 'Occupational Exposure Limit (OEL) TWA Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `oel_type` SET TAGS ('dbx_business_glossary_term' = 'Occupational Exposure Limit (OEL) Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `oel_type` SET TAGS ('dbx_value_regex' = 'OSHA_PEL|ACGIH_TLV|NIOSH_REL|EU_OEL|WEEL|internal_limit|none');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `percent_of_oel` SET TAGS ('dbx_business_glossary_term' = 'Percent of OEL (%)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `recommended_control_description` SET TAGS ('dbx_business_glossary_term' = 'Recommended Control Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `recommended_control_type` SET TAGS ('dbx_business_glossary_term' = 'Recommended Control Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `recommended_control_type` SET TAGS ('dbx_value_regex' = 'elimination|substitution|engineering_control|administrative_control|ppe|no_action_required');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sample_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Sample End Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sample_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sample_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Sample Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sample_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sampling_media` SET TAGS ('dbx_business_glossary_term' = 'Sampling Media');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sampling_media` SET TAGS ('dbx_value_regex' = 'charcoal_tube|silica_gel|filter_cassette|impinger|dosimeter_badge|direct_reading_instrument|blood|urine|exhaled_breath|swab');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sampling_method` SET TAGS ('dbx_business_glossary_term' = 'Sampling Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `sampling_method` SET TAGS ('dbx_value_regex' = 'personal_breathing_zone|area_sample|grab_sample|integrated_sample|wipe_sample|biological_specimen|direct_reading|passive_dosimeter|active_dosimeter');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Record Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|sampled|lab_analysis|completed|cancelled|voided');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `stel_result` SET TAGS ('dbx_business_glossary_term' = 'Short-Term Exposure Limit (STEL) Result');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `twa_result` SET TAGS ('dbx_business_glossary_term' = 'Time-Weighted Average (TWA) Result');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'ppm|mg/m3|f/cc|dBA|dBC|mSv|mSv/hr|µg/m3|µg/L|µg/g|lux|m/s2|°C|%LEL|cfu/m3');
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ALTER COLUMN `work_area` SET TAGS ('dbx_business_glossary_term' = 'Work Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `emergency_response_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Emergency Coordinator Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `service_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `alternate_coordinator_name` SET TAGS ('dbx_business_glossary_term' = 'Alternate Emergency Coordinator Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `assembly_point_description` SET TAGS ('dbx_business_glossary_term' = 'Assembly Point Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `drill_frequency` SET TAGS ('dbx_business_glossary_term' = 'Emergency Drill Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `drill_frequency` SET TAGS ('dbx_value_regex' = 'annual|semi_annual|quarterly|monthly|as_needed');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Effective Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `emergency_coordinator_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Coordinator Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `emergency_coordinator_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Coordinator Phone Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `emergency_coordinator_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `emergency_coordinator_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `emergency_scenario` SET TAGS ('dbx_business_glossary_term' = 'Emergency Scenario Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `emergency_scenario` SET TAGS ('dbx_value_regex' = 'fire|chemical_spill|explosion|medical_emergency|natural_disaster|hazmat_release|power_outage|structural_failure|active_threat|flood|earthquake|evacuation_general');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `employee_training_required` SET TAGS ('dbx_business_glossary_term' = 'Employee Training Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `employee_training_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `epa_regional_contact` SET TAGS ('dbx_business_glossary_term' = 'EPA Regional Contact');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `epa_rmp_compliant` SET TAGS ('dbx_business_glossary_term' = 'EPA Risk Management Program (RMP) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `epa_rmp_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `epcra_compliant` SET TAGS ('dbx_business_glossary_term' = 'Emergency Planning and Community Right-to-Know Act (EPCRA) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `epcra_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `evacuation_procedure_description` SET TAGS ('dbx_business_glossary_term' = 'Evacuation Procedure Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `evacuation_route_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Evacuation Route Document Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `facility_state_province` SET TAGS ('dbx_business_glossary_term' = 'Facility State or Province');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `fire_department_contact` SET TAGS ('dbx_business_glossary_term' = 'Fire Department Contact');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `hazmat_team_contact` SET TAGS ('dbx_business_glossary_term' = 'HAZMAT Team Contact');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `last_drill_date` SET TAGS ('dbx_business_glossary_term' = 'Last Emergency Drill Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `last_drill_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `local_emergency_planning_committee` SET TAGS ('dbx_business_glossary_term' = 'Local Emergency Planning Committee (LEPC)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `next_drill_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Drill Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `next_drill_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `osha_eap_compliant` SET TAGS ('dbx_business_glossary_term' = 'OSHA Emergency Action Plan (EAP) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `osha_eap_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `plan_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Plan Document Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^ERP-[A-Z0-9]{3,10}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'facility_erp|hazmat_erp|fire_prevention_plan|spill_prevention_plan|business_continuity_plan|pandemic_response_plan|security_emergency_plan');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `regulatory_basis` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Basis');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `regulatory_basis` SET TAGS ('dbx_value_regex' = 'OSHA_EAP_1910_38|EPA_RMP_40CFR68|EPCRA|ISO_45001|NFPA_1600|EPA_SPCC|OSHA_PSM_1910_119|local_regulation|multiple');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `response_procedures_summary` SET TAGS ('dbx_business_glossary_term' = 'Response Procedures Summary');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'annual|biennial|triennial|event_triggered|quarterly|as_needed');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|active|superseded|archived|expired');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `superseded_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'Superseded Plan Reference Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Plan Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `emergency_drill_id` SET TAGS ('dbx_business_glossary_term' = 'Emergency Drill ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Drill Coordinator Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `emergency_response_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `hse_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `actual_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Drill Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `actual_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Drill Report Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `building_area` SET TAGS ('dbx_business_glossary_term' = 'Building or Work Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `capa_initiated` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Initiated Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `capa_initiated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `corrective_actions_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Actions Required');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `deficiencies_identified` SET TAGS ('dbx_business_glossary_term' = 'Deficiencies Identified');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `deficiency_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_category` SET TAGS ('dbx_business_glossary_term' = 'Emergency Drill Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_category` SET TAGS ('dbx_value_regex' = 'announced|unannounced|tabletop|functional|full_scale');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_coordinator_name` SET TAGS ('dbx_business_glossary_term' = 'Drill Coordinator Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Drill Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_frequency_requirement` SET TAGS ('dbx_business_glossary_term' = 'Drill Frequency Requirement');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_frequency_requirement` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|biennial|as_required');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_number` SET TAGS ('dbx_business_glossary_term' = 'Emergency Drill Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_number` SET TAGS ('dbx_value_regex' = '^DRILL-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_type` SET TAGS ('dbx_business_glossary_term' = 'Emergency Drill Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `drill_type` SET TAGS ('dbx_value_regex' = 'fire_evacuation|chemical_spill|hazmat_response|lockdown|medical_emergency|earthquake|flood|power_outage|active_shooter|confined_space_rescue|gas_leak|explosion|cyber_incident|tabletop_exercise|full_scale_exercise');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_business_glossary_term' = 'Drill Effectiveness Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_value_regex' = 'excellent|satisfactory|needs_improvement|unsatisfactory');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `effectiveness_score` SET TAGS ('dbx_business_glossary_term' = 'Drill Effectiveness Score');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `effectiveness_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Drill End Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `evacuation_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Evacuation Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `evacuation_time_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `external_agency_involved` SET TAGS ('dbx_business_glossary_term' = 'External Agency Involved Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `external_agency_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `external_agency_names` SET TAGS ('dbx_business_glossary_term' = 'External Agency Names');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `facility_state_province` SET TAGS ('dbx_business_glossary_term' = 'Facility State or Province');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `lessons_learned` SET TAGS ('dbx_business_glossary_term' = 'Lessons Learned');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `next_drill_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Drill Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `next_drill_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `participant_count` SET TAGS ('dbx_business_glossary_term' = 'Participant Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `participant_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_value_regex' = 'osha_eap|osha_psm|epa_rmp|iso_45001|local_fire_code|eu_seveso|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `scenario_description` SET TAGS ('dbx_business_glossary_term' = 'Drill Scenario Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Drill Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Drill Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Drill Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|postponed|pending_review');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `target_evacuation_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Target Evacuation Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `target_evacuation_time_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Drill Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `total_personnel_on_site` SET TAGS ('dbx_business_glossary_term' = 'Total Personnel On Site');
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ALTER COLUMN `total_personnel_on_site` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `environmental_aspect_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `bop_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Bop Operation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `activity_category` SET TAGS ('dbx_business_glossary_term' = 'Activity Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `activity_category` SET TAGS ('dbx_value_regex' = 'production|maintenance|logistics|facility_operations|r_and_d|waste_management|procurement|construction|decommissioning|emergency_response|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `activity_process_name` SET TAGS ('dbx_business_glossary_term' = 'Activity or Process Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `additional_controls_required` SET TAGS ('dbx_business_glossary_term' = 'Additional Controls Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `additional_controls_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `applicable_legal_requirement` SET TAGS ('dbx_business_glossary_term' = 'Applicable Legal Requirement');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `aspect_number` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `aspect_number` SET TAGS ('dbx_value_regex' = '^EA-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `aspect_type` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `aspect_type` SET TAGS ('dbx_value_regex' = 'air_emission|wastewater_discharge|solid_waste|hazardous_waste|energy_use|water_consumption|raw_material_consumption|noise|vibration|land_contamination|greenhouse_gas_emission|stormwater_runoff|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `associated_impact` SET TAGS ('dbx_business_glossary_term' = 'Associated Environmental Impact');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `control_effectiveness` SET TAGS ('dbx_business_glossary_term' = 'Control Effectiveness');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `control_effectiveness` SET TAGS ('dbx_value_regex' = 'effective|partially_effective|ineffective|not_assessed');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `emission_medium` SET TAGS ('dbx_business_glossary_term' = 'Emission Medium');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `emission_medium` SET TAGS ('dbx_value_regex' = 'air|water|land|multiple|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `existing_controls` SET TAGS ('dbx_business_glossary_term' = 'Existing Control Measures');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `ghg_emission_flag` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Emission Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `ghg_emission_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `ghg_scope` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Scope');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `ghg_scope` SET TAGS ('dbx_value_regex' = 'scope_1|scope_2|scope_3|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `impact_category` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `impact_category` SET TAGS ('dbx_value_regex' = 'air_quality|water_quality|soil_contamination|climate_change|resource_depletion|biodiversity|human_health|noise_pollution|waste_generation|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `operating_condition` SET TAGS ('dbx_business_glossary_term' = 'Operating Condition');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `operating_condition` SET TAGS ('dbx_value_regex' = 'normal|abnormal|emergency');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `probability_rating` SET TAGS ('dbx_business_glossary_term' = 'Probability Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `probability_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `quantification_unit` SET TAGS ('dbx_business_glossary_term' = 'Aspect Quantification Unit');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `quantification_value` SET TAGS ('dbx_business_glossary_term' = 'Aspect Quantification Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `regulatory_program_code` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Program Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `responsible_owner_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `scale_rating` SET TAGS ('dbx_business_glossary_term' = 'Scale Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `scale_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Severity Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `severity_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `significance_criteria` SET TAGS ('dbx_business_glossary_term' = 'Significance Determination Criteria');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `significance_rating` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect Significance Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `significance_rating` SET TAGS ('dbx_value_regex' = 'significant|not_significant');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `significance_score` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect Significance Score');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `significance_score` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]?$|^100$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|under_review|superseded|retired');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Environmental Aspect Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ALTER COLUMN `work_area` SET TAGS ('dbx_business_glossary_term' = 'Work Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` SET TAGS ('dbx_subdomain' = 'chemical_management');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `hse_reach_substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Substance Declaration ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Product Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `article_category` SET TAGS ('dbx_business_glossary_term' = 'Article Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `article_name` SET TAGS ('dbx_business_glossary_term' = 'Article or Material Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `article_number` SET TAGS ('dbx_business_glossary_term' = 'Article or Material Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Substance Compliance Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|exempted|under_assessment|not_applicable');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `concentration_percent` SET TAGS ('dbx_business_glossary_term' = 'Substance Concentration (% by Weight)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `concentration_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}.[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}[+-][0-9]{2}:[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `customer_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `customer_notification_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `declaration_date` SET TAGS ('dbx_business_glossary_term' = 'Declaration Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `declaration_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Substance Declaration Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_value_regex' = '^RSDECL-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `declaration_type` SET TAGS ('dbx_business_glossary_term' = 'Declaration Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `declaration_type` SET TAGS ('dbx_value_regex' = 'REACH_SVHC|RoHS_Restricted|REACH_Annex_XIV|REACH_Annex_XVII|Dual_REACH_RoHS');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `declared_by_name` SET TAGS ('dbx_business_glossary_term' = 'Declared By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `homogeneous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Homogeneous Material Assessment Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `homogeneous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}[+-][0-9]{2}:[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `reach_annex_reference` SET TAGS ('dbx_business_glossary_term' = 'REACH Annex Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `reach_annex_reference` SET TAGS ('dbx_value_regex' = 'Candidate_List|Annex_XIV|Annex_XVII|Not_Listed');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `rohs_exemption_code` SET TAGS ('dbx_business_glossary_term' = 'RoHS Exemption Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `rohs_exemption_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'RoHS Exemption Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `rohs_exemption_expiry_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `rohs_restricted` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Restricted Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `rohs_restricted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `scip_notification_reference` SET TAGS ('dbx_business_glossary_term' = 'SCIP Notification Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `scip_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Substances of Concern In articles as such or in complex objects (SCIP) Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `scip_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Teamcenter_PLM|Manual|Supplier_Portal|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Declaration Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|compliant|non_compliant|exempted|superseded|withdrawn');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `superseded_by_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Declaration Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `supplier_declaration_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Declaration Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `supplier_declaration_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `supplier_declaration_reference` SET TAGS ('dbx_business_glossary_term' = 'Supplier Declaration Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `svhc_listed` SET TAGS ('dbx_business_glossary_term' = 'Substance of Very High Concern (SVHC) Listed Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `svhc_listed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `svhc_listing_date` SET TAGS ('dbx_business_glossary_term' = 'Substance of Very High Concern (SVHC) Listing Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `svhc_listing_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `test_method` SET TAGS ('dbx_business_glossary_term' = 'Substance Test Method');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `test_method` SET TAGS ('dbx_value_regex' = 'IEC_62321|XRF_Screening|ICP-MS|ICP-OES|GC-MS|Supplier_Declaration|Calculation|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `test_report_reference` SET TAGS ('dbx_business_glossary_term' = 'Test Report Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `threshold_exceeded` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Threshold Exceeded Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `threshold_exceeded` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `threshold_percent` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Threshold Concentration (% by Weight)');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `threshold_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}.[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Declaration Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` SET TAGS ('dbx_original_name' = 'hse_objective');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `objective_id` SET TAGS ('dbx_business_glossary_term' = 'Health Safety and Environment (HSE) Objective ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `action_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'Action Plan Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `actual_achievement_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Achievement Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `actual_achievement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulatory Standard');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `applicable_standard` SET TAGS ('dbx_value_regex' = 'ISO_14001|ISO_45001|ISO_50001|OSHA|EPA|REACH|RoHS|ISO_9001|CE_Marking|NIST|multiple');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `baseline_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Period End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `baseline_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `baseline_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Period Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `baseline_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `baseline_value` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Baseline Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'incident_reduction|emissions_reduction|waste_reduction|energy_efficiency|water_conservation|chemical_hazard_reduction|training_compliance|audit_compliance|ergonomics|contractor_safety|emergency_preparedness|regulatory_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Change Reason');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `current_value` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Current Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `estimated_cost_savings` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost Savings');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `investment_amount` SET TAGS ('dbx_business_glossary_term' = 'Investment Amount');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `kpi_name` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `management_review_cycle` SET TAGS ('dbx_business_glossary_term' = 'Management Review Cycle');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `management_review_cycle` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4|H1|H2|annual|ad_hoc');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^HSE-OBJ-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `responsible_owner_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Progress Review Frequency');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly|semi_annual|annual');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|on_track|at_risk|behind|achieved|not_achieved|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `target_achievement_date` SET TAGS ('dbx_business_glossary_term' = 'Target Achievement Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `target_achievement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `target_direction` SET TAGS ('dbx_business_glossary_term' = 'Target Direction');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `target_direction` SET TAGS ('dbx_value_regex' = 'reduce|increase|maintain|achieve');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `target_start_date` SET TAGS ('dbx_business_glossary_term' = 'Target Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `target_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Target Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'HSE Objective Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'safety|environmental|energy|occupational_health|compliance|sustainability|process_improvement');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `voluntary_commitment` SET TAGS ('dbx_business_glossary_term' = 'Voluntary Commitment Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ALTER COLUMN `voluntary_commitment` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `management_of_change_id` SET TAGS ('dbx_business_glossary_term' = 'Management of Change (MOC) ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `ecn_id` SET TAGS ('dbx_business_glossary_term' = 'Ecn Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `eco_id` SET TAGS ('dbx_business_glossary_term' = 'Eco Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `hazard_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `hse_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'MOC Initiator Employee ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `order_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Order Configuration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `technology_change_request_id` SET TAGS ('dbx_business_glossary_term' = 'Change Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `affected_chemicals` SET TAGS ('dbx_business_glossary_term' = 'Affected Chemical Substances');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `change_category` SET TAGS ('dbx_business_glossary_term' = 'Change Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `change_category` SET TAGS ('dbx_value_regex' = 'permanent|temporary|emergency|like_for_like_replacement');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'MOC Closure Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Change Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `document_update_required` SET TAGS ('dbx_business_glossary_term' = 'Document Update Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `document_update_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `final_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Final Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `final_approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `final_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Final MOC Approval Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `final_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|conditionally_approved|withdrawn');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `final_approver_name` SET TAGS ('dbx_business_glossary_term' = 'Final Approver Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `hse_approval_date` SET TAGS ('dbx_business_glossary_term' = 'HSE Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `hse_approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `hse_approval_status` SET TAGS ('dbx_business_glossary_term' = 'HSE Approval Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `hse_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|conditionally_approved');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `hse_approver_name` SET TAGS ('dbx_business_glossary_term' = 'HSE Approver Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Change Implementation Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `implementation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `initiator_name` SET TAGS ('dbx_business_glossary_term' = 'MOC Initiator Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `moc_number` SET TAGS ('dbx_business_glossary_term' = 'Management of Change (MOC) Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `moc_number` SET TAGS ('dbx_value_regex' = '^MOC-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `post_change_review_date` SET TAGS ('dbx_business_glossary_term' = 'Post-Change Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `post_change_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `post_change_review_outcome` SET TAGS ('dbx_business_glossary_term' = 'Post-Change Review Outcome');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `post_change_review_outcome` SET TAGS ('dbx_value_regex' = 'satisfactory|unsatisfactory|pending|not_required');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'MOC Priority');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `process_description` SET TAGS ('dbx_business_glossary_term' = 'Affected Process Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `proposed_change_date` SET TAGS ('dbx_business_glossary_term' = 'Proposed Change Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `proposed_change_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `psm_covered_process` SET TAGS ('dbx_business_glossary_term' = 'Process Safety Management (PSM) Covered Process Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `psm_covered_process` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `reason_for_change` SET TAGS ('dbx_business_glossary_term' = 'Reason for Change');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `regulatory_requirement` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulatory Requirement');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `required_approvers` SET TAGS ('dbx_business_glossary_term' = 'Required Approvers');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'MOC Risk Level');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Siemens_Opcenter|Maximo|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'MOC Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|pending_approval|approved|rejected|implemented|post_change_review|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `temporary_change_end_date` SET TAGS ('dbx_business_glossary_term' = 'Temporary Change End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `temporary_change_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'MOC Title');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `training_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Training Completion Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `training_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `training_required` SET TAGS ('dbx_business_glossary_term' = 'Training Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `training_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ALTER COLUMN `work_area` SET TAGS ('dbx_business_glossary_term' = 'Work Area');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` SET TAGS ('dbx_subdomain' = 'safety_operations');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` SET TAGS ('dbx_original_name' = 'contractor_hse_qualification');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `contractor_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Qualification ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `third_party_risk_id` SET TAGS ('dbx_business_glossary_term' = 'Third Party Risk Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Approval Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `confined_space_certified` SET TAGS ('dbx_business_glossary_term' = 'Confined Space Entry Certification Held');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `confined_space_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `contractor_company_code` SET TAGS ('dbx_business_glossary_term' = 'Contractor Company Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `contractor_company_name` SET TAGS ('dbx_business_glossary_term' = 'Contractor Company Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `contractor_company_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `contractor_type` SET TAGS ('dbx_business_glossary_term' = 'Contractor Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `contractor_type` SET TAGS ('dbx_value_regex' = 'construction|electrical|mechanical|civil|it_services|cleaning|security|logistics|maintenance|engineering|inspection|other');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `dart_rate` SET TAGS ('dbx_business_glossary_term' = 'Days Away Restricted or Transferred (DART) Rate');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `disqualification_reason` SET TAGS ('dbx_business_glossary_term' = 'Disqualification Reason');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `evaluated_by_name` SET TAGS ('dbx_business_glossary_term' = 'Evaluated By Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `fall_protection_certified` SET TAGS ('dbx_business_glossary_term' = 'Fall Protection Certification Held');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `fall_protection_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `general_liability_coverage_amount` SET TAGS ('dbx_business_glossary_term' = 'General Liability Insurance Coverage Amount');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `general_liability_coverage_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `general_liability_insured` SET TAGS ('dbx_business_glossary_term' = 'General Liability Insurance Verified');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `general_liability_insured` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hot_work_certified` SET TAGS ('dbx_business_glossary_term' = 'Hot Work Certification Held');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hot_work_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contractor Health Safety and Environment (HSE) Contact Email');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Contractor Health Safety and Environment (HSE) Contact Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_program_rating` SET TAGS ('dbx_business_glossary_term' = 'Health Safety and Environment (HSE) Program Rating');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_program_rating` SET TAGS ('dbx_value_regex' = 'excellent|satisfactory|marginal|unsatisfactory');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_program_score` SET TAGS ('dbx_business_glossary_term' = 'Health Safety and Environment (HSE) Program Evaluation Score');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `hse_program_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `incident_rate_reference_period` SET TAGS ('dbx_business_glossary_term' = 'Incident Rate Reference Period');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `incident_rate_reference_period` SET TAGS ('dbx_value_regex' = '1_year|3_year_average|5_year_average');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `insurance_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Insurance Currency Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `insurance_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Insurance Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `lockout_tagout_certified` SET TAGS ('dbx_business_glossary_term' = 'Lockout/Tagout (LOTO) Certification Held');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `lockout_tagout_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Qualification Review Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `osha_10_certified` SET TAGS ('dbx_business_glossary_term' = 'Occupational Safety and Health Administration (OSHA) 10-Hour Certification Held');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `osha_10_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `osha_30_certified` SET TAGS ('dbx_business_glossary_term' = 'Occupational Safety and Health Administration (OSHA) 30-Hour Certification Held');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `osha_30_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_number` SET TAGS ('dbx_business_glossary_term' = 'Contractor Qualification Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_number` SET TAGS ('dbx_value_regex' = '^CQ-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_status` SET TAGS ('dbx_business_glossary_term' = 'Qualification Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_status` SET TAGS ('dbx_value_regex' = 'pending_review|qualified|conditionally_qualified|disqualified|suspended|expired|under_renewal');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_type` SET TAGS ('dbx_business_glossary_term' = 'Qualification Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `qualification_type` SET TAGS ('dbx_value_regex' = 'pre_qualification|annual_renewal|periodic_review|project_specific|emergency_approval');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `risk_tier` SET TAGS ('dbx_business_glossary_term' = 'Contractor HSE Risk Tier');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `risk_tier` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `site_hse_orientation_completed` SET TAGS ('dbx_business_glossary_term' = 'Site-Specific Health Safety and Environment (HSE) Orientation Completed');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `site_hse_orientation_completed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `site_orientation_date` SET TAGS ('dbx_business_glossary_term' = 'Site Health Safety and Environment (HSE) Orientation Completion Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `site_orientation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `trir` SET TAGS ('dbx_business_glossary_term' = 'Total Recordable Incident Rate (TRIR)');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `work_scope_description` SET TAGS ('dbx_business_glossary_term' = 'Contractor Work Scope Description');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `workers_comp_insured` SET TAGS ('dbx_business_glossary_term' = 'Workers Compensation Insurance Verified');
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ALTER COLUMN `workers_comp_insured` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `ghg_emission_id` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Emission Record ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `activity_data_quantity` SET TAGS ('dbx_business_glossary_term' = 'Activity Data Quantity');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `activity_data_uom` SET TAGS ('dbx_business_glossary_term' = 'Activity Data Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `activity_data_uom` SET TAGS ('dbx_value_regex' = 'GJ|MWh|kWh|L|m3|kg|t|km|tonne-km|passenger-km|USD|unit');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `baseline_year` SET TAGS ('dbx_business_glossary_term' = 'GHG Baseline Year');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `baseline_year` SET TAGS ('dbx_value_regex' = '^(19|20)d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `biogenic_co2_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Biogenic CO2 Emissions in Tonnes');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `calculation_methodology` SET TAGS ('dbx_business_glossary_term' = 'GHG Calculation Methodology');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `calculation_methodology` SET TAGS ('dbx_value_regex' = 'Spend-Based|Activity-Based|Supplier-Specific|Hybrid|Direct Measurement|Mass Balance|Fuel Analysis|Engineering Estimate');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `cdp_disclosure_year` SET TAGS ('dbx_business_glossary_term' = 'Carbon Disclosure Project (CDP) Disclosure Year');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `cdp_disclosure_year` SET TAGS ('dbx_value_regex' = '^(20)d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `co2e_quantity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Carbon Dioxide Equivalent (CO2e) Quantity in Tonnes');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `data_quality_tier` SET TAGS ('dbx_business_glossary_term' = 'Data Quality Tier');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `data_quality_tier` SET TAGS ('dbx_value_regex' = 'Tier 1 Primary|Tier 2 Secondary|Tier 3 Estimated');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `data_source` SET TAGS ('dbx_business_glossary_term' = 'Data Source');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `data_source` SET TAGS ('dbx_value_regex' = 'SAP S/4HANA|Siemens MindSphere|Utility Invoice|Manual Entry|Meter Reading|ERP Integration|IoT Sensor|Supplier Data|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_factor_source` SET TAGS ('dbx_business_glossary_term' = 'Emission Factor Source');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_factor_source` SET TAGS ('dbx_value_regex' = 'EPA eGRID|IEA|IPCC AR6|IPCC AR5|DEFRA|GHG Protocol|Ecoinvent|Supplier-Specific|Utility-Specific|National Inventory|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_factor_uom` SET TAGS ('dbx_business_glossary_term' = 'Emission Factor Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_factor_value` SET TAGS ('dbx_business_glossary_term' = 'Emission Factor Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_factor_year` SET TAGS ('dbx_business_glossary_term' = 'Emission Factor Reference Year');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_factor_year` SET TAGS ('dbx_value_regex' = '^(19|20)d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_source_name` SET TAGS ('dbx_business_glossary_term' = 'Emission Source Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_source_type` SET TAGS ('dbx_business_glossary_term' = 'Emission Source Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `emission_source_type` SET TAGS ('dbx_value_regex' = 'Stationary Combustion|Mobile Combustion|Process Emission|Fugitive Emission|Purchased Electricity|Purchased Heat|Purchased Steam|Purchased Cooling|Upstream Transportation|Downstream Transportation|Business Travel|Employee Commuting|Waste|Purchased ...');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `energy_source_type` SET TAGS ('dbx_business_glossary_term' = 'Energy Source Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `energy_source_type` SET TAGS ('dbx_value_regex' = 'Natural Gas|Diesel|Gasoline|LPG|Coal|Biomass|Grid Electricity|Renewable Electricity|Steam|Chilled Water|Hot Water|Hydrogen|Fuel Oil|Other');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `eu_ets_installation_code` SET TAGS ('dbx_business_glossary_term' = 'European Union Emissions Trading System (EU ETS) Installation ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Country Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `facility_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `ghg_scope` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Scope');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `ghg_scope` SET TAGS ('dbx_value_regex' = 'Scope 1|Scope 2 Location-Based|Scope 2 Market-Based|Scope 3');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `ghg_type` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Type');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `ghg_type` SET TAGS ('dbx_value_regex' = 'CO2|CH4|N2O|HFCs|PFCs|SF6|NF3|CO2e');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `gwp_assessment_report` SET TAGS ('dbx_business_glossary_term' = 'Global Warming Potential (GWP) Assessment Report');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `gwp_assessment_report` SET TAGS ('dbx_value_regex' = 'IPCC AR4|IPCC AR5|IPCC AR6');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `gwp_value` SET TAGS ('dbx_business_glossary_term' = 'Global Warming Potential (GWP) Value');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `rec_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Renewable Energy Certificate (REC) / Guarantee of Origin (GO) Certificate Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'GHG Emission Record Number');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `record_number` SET TAGS ('dbx_value_regex' = '^GHG-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `regulatory_reportable_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reportable Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `regulatory_reportable_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `renewable_energy_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewable Energy Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `renewable_energy_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `reporting_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Reporting Period End Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `reporting_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `reporting_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Reporting Period Start Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `reporting_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `sbti_target_reference` SET TAGS ('dbx_business_glossary_term' = 'Science Based Targets initiative (SBTi) Target Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `scope3_category` SET TAGS ('dbx_business_glossary_term' = 'Scope 3 Category');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `scope3_category` SET TAGS ('dbx_value_regex' = 'Cat 1 Purchased Goods and Services|Cat 2 Capital Goods|Cat 3 Fuel and Energy|Cat 4 Upstream Transportation|Cat 5 Waste in Operations|Cat 6 Business Travel|Cat 7 Employee Commuting|Cat 8 Upstream Leased Assets|Cat 9 Downstream Transportation|Cat 10...');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'GHG Emission Record Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Draft|Submitted|Under Review|Approved|Rejected|Archived');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `verification_status` SET TAGS ('dbx_business_glossary_term' = 'Verification Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'Not Verified|Internal Review|Third-Party Verified|Limited Assurance|Reasonable Assurance');
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ALTER COLUMN `verifier_name` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Verifier Name');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` SET TAGS ('dbx_subdomain' = 'chemical_management');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` SET TAGS ('dbx_association_edges' = 'hse.chemical_substance,hse.regulatory_obligation');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `chemical_regulatory_compliance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Regulatory Compliance ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Regulatory Compliance - Chemical Substance Id');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Compliance Officer ID');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Regulatory Compliance - Regulatory Obligation Id');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `applicable_threshold_quantity` SET TAGS ('dbx_business_glossary_term' = 'Applicable Threshold Quantity');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `exemption_code` SET TAGS ('dbx_business_glossary_term' = 'Exemption Code');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `jurisdiction_specific_limit` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Specific Limit');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `last_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Assessment Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `next_assessment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Assessment Due Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `reporting_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Reporting Required Flag');
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ALTER COLUMN `threshold_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Threshold Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` SET TAGS ('dbx_subdomain' = 'environmental_compliance');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` SET TAGS ('dbx_association_edges' = 'hse.safety_audit,hse.regulatory_obligation');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `audit_coverage_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Coverage Identifier');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Coverage - Regulatory Obligation Id');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `safety_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Coverage - Safety Audit Id');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `auditor_notes` SET TAGS ('dbx_business_glossary_term' = 'Auditor Notes');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `clause_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulation Clause Reference');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `conformance_status` SET TAGS ('dbx_business_glossary_term' = 'Conformance Status');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `evaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Date');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `evidence_reviewed` SET TAGS ('dbx_business_glossary_term' = 'Evidence Reviewed');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `finding_count` SET TAGS ('dbx_business_glossary_term' = 'Finding Count');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`hse`.`audit_coverage` ALTER COLUMN `scope_inclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Audit Scope Inclusion Flag');
