-- Schema for Domain: workforce | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:25

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`workforce` COMMENT 'Human capital management including employee records, organizational structure, talent acquisition, performance management, compensation, benefits, and payroll. Manages workforce planning, shift scheduling for manufacturing operations, union labor agreements, skills inventory, and IATF-required competency records. Tracks headcount, turnover, training completion, and safety certifications. Integrates with SAP SuccessFactors for end-to-end HR processes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`employee` (
    `employee_id` BIGINT COMMENT 'System-generated unique identifier for each employee record.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: HR tracks which dealership each employee works at for payroll, compliance, and regional performance reporting.',
    `functional_location_id` BIGINT COMMENT 'Reference to the primary plant or office where the employee works.',
    `job_classification_id` BIGINT COMMENT 'Foreign key linking to workforce.job_classification. Business justification: Standardize job classification reference; employee now references job_classification via employee.job_classification_id, removing redundant string code.',
    `labor_agreement_id` BIGINT COMMENT 'Foreign key linking to workforce.labor_agreement. Business justification: Capture the specific collective bargaining agreement applicable to each employee for compliance and payroll calculations.',
    `manager_employee_id` BIGINT COMMENT 'Employee identifier of the direct manager or supervisor.',
    `plant_id` BIGINT COMMENT 'Reference to the primary plant or office where the employee works.',
    `department_id` BIGINT COMMENT 'Reference to the department to which the employee belongs.',
    `address_line1` STRING COMMENT 'First line of the employees residential address.',
    `address_line2` STRING COMMENT 'Second line of the employees residential address (optional).',
    `benefits_enrollment_status` STRING COMMENT 'Current enrollment state for employee benefit programs.. Valid values are `enrolled|not_enrolled|pending`',
    `certification_status` STRING COMMENT 'Current status of any mandatory certifications (e.g., safety, quality).. Valid values are `certified|expired|pending|not_applicable`',
    `city` STRING COMMENT 'City component of the employees residential address.',
    `compliance_training_completed_date` DATE COMMENT 'Date when the employee completed required compliance training.',
    `country_code` STRING COMMENT 'ISO‑3166‑1 alpha‑3 code of the employees country of residence.. Valid values are `USA|CAN|MEX|DEU|FRA|GBR`',
    `currency_code` STRING COMMENT 'ISO 4217 currency code for the salary amount.. Valid values are `USD|CAD|EUR|GBP|JPY|CNY`',
    `date_of_birth` DATE COMMENT 'Birth date of the employee, used for age verification and benefits eligibility.',
    `disability_accommodation_flag` BOOLEAN COMMENT 'Indicates if the employee has approved disability accommodations.',
    `eeo_category` STRING COMMENT 'Equal Employment Opportunity classification for reporting and compliance. [ENUM-REF-CANDIDATE: protected_veteran|disability|gender|race|ethnicity|age|other — 7 candidates stripped; promote to reference product]',
    `email` STRING COMMENT 'Primary work email address for the employee.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `emergency_contact_name` STRING COMMENT 'Name of the person to contact in case of an emergency.',
    `emergency_contact_phone` STRING COMMENT 'Phone number of the emergency contact.',
    `employment_status` STRING COMMENT 'Current lifecycle status of the employee within the organization.. Valid values are `active|inactive|terminated|on_leave|retired|contract`',
    `employment_type` STRING COMMENT 'Classification of the employment relationship.. Valid values are `full_time|part_time|contract|temporary|intern|consultant`',
    `first_name` STRING COMMENT 'Given name of the employee.',
    `full_name` STRING COMMENT 'Complete legal name of the employee as used for official records.',
    `hire_date` DATE COMMENT 'Date the employee officially started employment with Automotive.',
    `iatf_competency_status` STRING COMMENT 'Employees competency status required by IATF 16949 quality standards.. Valid values are `competent|not_competent|pending|exempt`',
    `job_title` STRING COMMENT 'Official title of the employees position.',
    `last_name` STRING COMMENT 'Family name of the employee.',
    `last_performance_review_date` DATE COMMENT 'Date of the most recent performance evaluation.',
    `national_id_number` STRING COMMENT 'Government‑issued personal identifier (e.g., SSN, SIN) for the employee.',
    `overtime_eligible` BOOLEAN COMMENT 'Indicates if the employee is eligible for overtime compensation.',
    `pay_grade` STRING COMMENT 'Compensation band assigned to the employee.',
    `performance_rating` STRING COMMENT 'Overall rating from the latest performance review.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory`',
    `phone_number` STRING COMMENT 'Primary contact telephone number for the employee.',
    `postal_code` STRING COMMENT 'Postal/ZIP code of the employees residential address.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the employee record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the employee record.',
    `retirement_plan_code` STRING COMMENT 'Code representing the employees selected retirement savings plan.',
    `salary_amount` DECIMAL(18,2) COMMENT 'Annual base salary for the employee, before bonuses or allowances.',
    `state` STRING COMMENT 'State or province component of the employees residential address.',
    `tax_withholding_code` STRING COMMENT 'Code indicating the employees tax withholding classification.',
    `termination_date` DATE COMMENT 'Date the employees employment ended, if applicable.',
    `training_completion_flag` BOOLEAN COMMENT 'Indicates whether required training courses have been completed.',
    `union_member_flag` BOOLEAN COMMENT 'Indicates whether the employee is a member of a labor union.',
    `veteran_status` STRING COMMENT 'Veteran classification for EEO reporting.. Valid values are `veteran|non_veteran|unknown`',
    CONSTRAINT pk_employee PRIMARY KEY(`employee_id`)
) COMMENT 'Master record for every individual employed by Automotive, sourced from SAP SuccessFactors. Captures employee identity, personal details, employment type (full-time, part-time, contract, CKD-site), hire date, termination date, employment status, home plant or office assignment, job classification, pay grade, union membership flag, IATF competency status, and EEO category. Serves as the SSOT for workforce identity across all HR sub-domains.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`position` (
    `position_id` BIGINT COMMENT 'Unique system-generated identifier for the authorized headcount position.',
    `department_id` BIGINT COMMENT 'Identifier of the department or functional area that owns the position.',
    `employee_id` BIGINT COMMENT 'Identifier of the manager responsible for hiring into this position.',
    `job_classification_id` BIGINT COMMENT 'Foreign key linking to workforce.job_classification. Business justification: Standardize position classification by linking each position to its job classification; enables consistent reporting and removes need to store job_family and level redundantly.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the top‑level organization (e.g., corporate entity) to which the position belongs.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or facility where the position is located.',
    `primary_position_department_org_unit_id` BIGINT COMMENT 'Identifier of the department or functional area that owns the position.',
    `primary_position_employee_id` BIGINT COMMENT 'Identifier of the manager responsible for hiring into this position.',
    `bonus_eligible` BOOLEAN COMMENT 'Indicates if the position is eligible for performance‑based bonuses.',
    `budget` DECIMAL(18,2) COMMENT 'Annual budget allocated for total compensation and related costs.',
    `position_category` STRING COMMENT 'Business domain to which the position belongs.. Valid values are `production|engineering|administration|sales|service|support`',
    `position_code` STRING COMMENT 'Internal alphanumeric code uniquely identifying the position within the organization.',
    `compensation_grade` STRING COMMENT 'Internal grade used for compensation benchmarking.',
    `compliance_iatf_required` BOOLEAN COMMENT 'Indicates if the role must meet IATF 16949 competency requirements.',
    `compliance_training_completed` BOOLEAN COMMENT 'Indicates whether mandatory compliance training has been completed for the role.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the position record was first created in the system.',
    `criticality` STRING COMMENT 'Business criticality rating indicating impact of vacancy on operations.. Valid values are `low|medium|high|critical`',
    `position_description` STRING COMMENT 'Narrative description of the role, duties, and expectations.',
    `effective_end_date` DATE COMMENT 'Date on which the position is scheduled to be retired or become inactive (nullable).',
    `effective_start_date` DATE COMMENT 'Date on which the position becomes active in the organization.',
    `flsa_status` STRING COMMENT 'Fair Labor Standards Act classification indicating exempt or non‑exempt status.. Valid values are `exempt|non_exempt`',
    `is_filled` BOOLEAN COMMENT 'Indicates whether the position is currently occupied by an employee.',
    `job_family` STRING COMMENT 'Broad classification grouping similar roles (e.g., Engineering, Manufacturing, Administration).',
    `job_level` STRING COMMENT 'Hierarchical level of the role within the job family (e.g., L1, L2, L3).',
    `last_filled_date` DATE COMMENT 'Date when the position was most recently occupied.',
    `location` STRING COMMENT 'Standard location code (e.g., plant‑area‑line) where the role is based.',
    `overtime_eligible` BOOLEAN COMMENT 'Indicates if overtime compensation applies to this position.',
    `position_status` STRING COMMENT 'Current lifecycle status of the position.. Valid values are `active|inactive|closed|vacant|pending`',
    `position_type` STRING COMMENT 'Nature of the employment relationship for the position.. Valid values are `permanent|temporary|contract|intern|consultant`',
    `remote_allowed` BOOLEAN COMMENT 'Indicates if the position can be performed remotely.',
    `required_certifications` STRING COMMENT 'Comma‑separated list of certifications mandatory for incumbents (e.g., OSHA, IATF).',
    `required_skills` STRING COMMENT 'Comma‑separated list of core skills needed to perform the role.',
    `responsibilities` STRING COMMENT 'Detailed list of primary responsibilities and accountabilities.',
    `risk_level` STRING COMMENT 'Risk classification based on safety, compliance, or operational impact.. Valid values are `low|medium|high`',
    `salary_range_max` DECIMAL(18,2) COMMENT 'Maximum annual salary for the position.',
    `salary_range_min` DECIMAL(18,2) COMMENT 'Minimum annual salary for the position.',
    `shift_eligibility` STRING COMMENT 'Shift patterns for which the position is eligible.. Valid values are `day|swing|night|flex|off|on_call`',
    `status_reason` STRING COMMENT 'Explanation for the current status, such as reason for vacancy or closure.',
    `target_headcount` STRING COMMENT 'Budgeted number of full‑time equivalents (FTE) allocated to this position.',
    `title` STRING COMMENT 'Official title of the position as used in job postings and internal records.',
    `travel_required` BOOLEAN COMMENT 'Indicates whether the role requires regular travel.',
    `union_classification_code` STRING COMMENT 'Code representing the union or collective bargaining classification applicable to the position.',
    `updated_by` STRING COMMENT 'User identifier of the person who last updated the position record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the position record.',
    `vacancy_reason` STRING COMMENT 'Reason why the position is currently vacant.. Valid values are `retirement|resignation|termination|reorganization|new_role|budget_cut`',
    `created_by` STRING COMMENT 'User identifier of the person who created the position record.',
    CONSTRAINT pk_position PRIMARY KEY(`position_id`)
) COMMENT 'Authorized headcount position within the organizational structure, representing a budgeted role independent of the person filling it. Captures position title, job family, job level, plant or department assignment, shift eligibility, union classification code, FLSA status, target headcount, and whether the position is currently filled or vacant. Supports workforce planning and headcount reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`org_unit` (
    `org_unit_id` BIGINT COMMENT 'System-generated unique identifier for the organizational unit.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Each org unit is assigned to a cost center for budgeting; cost_center_id links the two.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Needed for associating each org unit/plant with its regulatory jurisdiction for environmental permit reporting and audit compliance.',
    `labor_agreement_id` BIGINT COMMENT 'Foreign key linking to workforce.labor_agreement. Business justification: Org unit should reference the governing labor agreement entity; replace string code with FK.',
    `parent_org_unit_id` BIGINT COMMENT 'Identifier of the immediate parent unit in the hierarchy.',
    `address_line1` STRING COMMENT 'Primary street address of the unit.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, floor, etc.).',
    `budget_amount` DECIMAL(18,2) COMMENT 'Annual budget allocated to the unit (currency defined by currency_code).',
    `city` STRING COMMENT 'City where the unit is located.',
    `compliance_status` STRING COMMENT 'Overall compliance posture of the unit with applicable automotive regulations.. Valid values are `compliant|non_compliant|under_review`',
    `country_code` STRING COMMENT 'Three‑letter country code of the units location. [ENUM-REF-CANDIDATE: USA|CAN|MEX|DEU|FRA|GBR|JPN|CHN|KOR|IND — promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the organizational unit record was first created.',
    `currency_code` STRING COMMENT 'Currency in which monetary values for the unit are expressed.. Valid values are `USD|EUR|JPY|CNY|GBP`',
    `org_unit_description` STRING COMMENT 'Free‑form description of the units purpose or responsibilities.',
    `division_code` STRING COMMENT 'Code representing the higher‑level division to which the unit belongs.',
    `effective_end_date` DATE COMMENT 'Date when the unit ceased operation (null if still active).',
    `effective_start_date` DATE COMMENT 'Date when the unit became operational.',
    `email` STRING COMMENT 'Primary contact email for the unit.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `full_time_equivalent` DECIMAL(18,2) COMMENT 'Aggregated FTE value for the unit, reflecting part‑time staffing.',
    `headcount` STRING COMMENT 'Number of employees assigned to the unit (full‑time equivalents counted as 1).',
    `is_unionized` BOOLEAN COMMENT 'Indicates whether the units workforce is covered by a labor union.',
    `last_audit_date` DATE COMMENT 'Date of the most recent internal or external audit of the unit.',
    `org_unit_name` STRING COMMENT 'Human‑readable name of the organizational unit (e.g., "Engine Plant 1").',
    `org_code` STRING COMMENT 'Business identifier or code used in ERP and reporting (e.g., "PLNT001").',
    `org_unit_status` STRING COMMENT 'Current lifecycle status of the unit.. Valid values are `active|inactive|planned|closed`',
    `org_unit_type` STRING COMMENT 'Category of the unit within the enterprise hierarchy.. Valid values are `plant|department|division|business_unit|cost_center`',
    `phone_number` STRING COMMENT 'Primary contact telephone number for the unit.',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant (if type=plant).',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the units address.',
    `region` STRING COMMENT 'Broad geographic region where the unit is located.. Valid values are `NA|EU|APAC|LATAM|MEA`',
    `safety_certification_status` STRING COMMENT 'Current status of safety certifications required for the unit.. Valid values are `certified|pending|expired`',
    `updated_by` STRING COMMENT 'User identifier of the person who performed the latest update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the unit record.',
    `created_by` STRING COMMENT 'User identifier of the person who created the record.',
    CONSTRAINT pk_org_unit PRIMARY KEY(`org_unit_id`)
) COMMENT 'Organizational unit hierarchy node representing departments, cost centers, plants, divisions, and business units within Automotive. Captures org unit name, type (plant, department, division), parent org unit, cost center code, plant code, region, and effective dates. Enables hierarchical rollup of headcount, labor cost, and performance data across the enterprise.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`job_classification` (
    `job_classification_id` BIGINT COMMENT 'System-generated unique identifier for each job classification record.',
    `org_unit_id` BIGINT COMMENT 'add column org_unit_id (BIGINT) with FK to workforce.org_unit.org_unit_id - job classifications are defined within organizational units',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the job classification record was first created in the system.',
    `effective_end_date` DATE COMMENT 'Date when the job classification is retired or superseded (null if still active).',
    `effective_start_date` DATE COMMENT 'Date when the job classification becomes active for use in workforce planning.',
    `flsa_exempt_status` STRING COMMENT 'Classification of the job for overtime eligibility under the Fair Labor Standards Act.. Valid values are `exempt|non_exempt`',
    `iatf_competency_required` STRING COMMENT 'Indicates whether the job classification must meet IATF 16949 competency standards.. Valid values are `required|not_required`',
    `is_managerial` BOOLEAN COMMENT 'Flag indicating whether the job classification includes managerial responsibilities.',
    `job_classification_status` STRING COMMENT 'Current lifecycle status of the job classification.. Valid values are `active|inactive|deprecated`',
    `job_code` STRING COMMENT 'Unique alphanumeric code used to reference the job classification across systems.',
    `job_description` STRING COMMENT 'Detailed description of duties, responsibilities, and scope for the job classification.',
    `job_family` STRING COMMENT 'Broad functional family to which the job belongs (e.g., Production, Engineering).. Valid values are `production|engineering|quality|logistics|administration|management`',
    `job_level_band` STRING COMMENT 'Standardized level band indicating seniority and responsibility (e.g., L1 = entry, L5 = senior).. Valid values are `L1|L2|L3|L4|L5`',
    `job_title` STRING COMMENT 'Human‑readable name of the job classification (e.g., "Assembly Line Technician").',
    `pay_grade_max` DECIMAL(18,2) COMMENT 'Upper bound of the salary range associated with the job classification.',
    `pay_grade_min` DECIMAL(18,2) COMMENT 'Lower bound of the salary range associated with the job classification.',
    `requires_certification` STRING COMMENT 'Indicates if the job classification requires a specific professional certification.. Valid values are `yes|no`',
    `union_trade_classification` STRING COMMENT 'Union‑defined trade category for the job (used for labor agreements).. Valid values are `craft|maintenance|administrative|management|other`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the job classification record.',
    `created_by` STRING COMMENT 'User identifier of the person who initially created the job classification record.',
    CONSTRAINT pk_job_classification PRIMARY KEY(`job_classification_id`)
) COMMENT 'Reference master for standardized job classifications used across Automotives workforce. Captures job code, job title, job family, job level band, IATF competency requirements, union trade classification, FLSA exemption status, and applicable pay grade range. Used to standardize position definitions and link to compensation structures and competency requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` (
    `employment_contract_id` BIGINT COMMENT 'System-generated unique identifier for the employment contract record.',
    `department_id` BIGINT COMMENT 'Organizational department responsible for the employee.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the direct manager or supervisor.',
    `org_unit_id` BIGINT COMMENT 'Organizational department responsible for the employee.',
    `position_id` BIGINT COMMENT 'Reference to the job position held under the contract.',
    `primary_employment_employee_id` BIGINT COMMENT 'Unique identifier of the employee to whom the contract applies.',
    `amendment_effective_date` DATE COMMENT 'Date when the latest amendment takes effect.',
    `amendment_number` STRING COMMENT 'Sequential number of the most recent amendment.',
    `amendment_reason` STRING COMMENT 'Reason for the most recent contract amendment.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the contract was approved.',
    `approved_by` BIGINT COMMENT 'Identifier of the HR or manager who approved the contract.',
    `benefits_description` STRING COMMENT 'Summary of benefits (health, retirement, etc.) provided under the contract.',
    `collective_bargaining_agreement` STRING COMMENT 'Identifier of the CBA governing the contract terms.',
    `compensation_type` STRING COMMENT 'Structure of the compensation package.. Valid values are `base|base_plus_bonus|commission|hourly`',
    `compliance_training_completed` BOOLEAN COMMENT 'Flag showing if the employee completed mandatory compliance training before contract start.',
    `confidentiality_clause` BOOLEAN COMMENT 'Indicates whether a confidentiality clause is present in the contract.',
    `contract_number` STRING COMMENT 'External contract reference number assigned by HR for tracking and legal purposes.',
    `contract_status_reason` STRING COMMENT 'Free‑text explanation for the current status (e.g., probation, on‑hold).',
    `contract_type` STRING COMMENT 'Category of employment contract indicating the nature of the employment relationship.. Valid values are `permanent|fixed_term|apprenticeship|ckd_expatriate`',
    `contract_version` STRING COMMENT 'Version number of the contract document after amendments.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the contract record was first created in the system.',
    `data_protection_clause` BOOLEAN COMMENT 'Indicates whether a data‑protection clause (e.g., GDPR) is included.',
    `employment_contract_status` STRING COMMENT 'Current lifecycle state of the contract.. Valid values are `active|inactive|terminated|pending|draft`',
    `end_date` DATE COMMENT 'Date when the employment contract terminates or expires; null for open‑ended contracts.',
    `is_apprenticeship` BOOLEAN COMMENT 'Flag indicating if the contract is for an apprenticeship program.',
    `is_expatriate` BOOLEAN COMMENT 'Flag indicating if the employee is an expatriate (e.g., CKD expatriate).',
    `is_fixed_term` BOOLEAN COMMENT 'Flag indicating if the contract has a predefined end date.',
    `is_permanent` BOOLEAN COMMENT 'Flag indicating if the contract is for a permanent employee.',
    `last_modified_by` BIGINT COMMENT 'Identifier of the user who last modified the contract record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification.',
    `non_compete_clause` BOOLEAN COMMENT 'Indicates whether a non‑compete clause is included.',
    `notice_period_days` STRING COMMENT 'Number of days required for notice of termination by either party.',
    `probation_end_date` DATE COMMENT 'Date when the probation period ends, if applicable.',
    `probation_period_days` STRING COMMENT 'Length of the probation period in days.',
    `salary_amount` DECIMAL(18,2) COMMENT 'Base monetary compensation agreed in the contract.',
    `salary_currency` STRING COMMENT 'ISO 4217 three‑letter currency code for the salary amount.. Valid values are `[A-Z]{3}`',
    `salary_frequency` STRING COMMENT 'How often salary is paid to the employee.. Valid values are `monthly|biweekly|weekly|annual`',
    `start_date` DATE COMMENT 'Date when the employment contract becomes effective.',
    `termination_date` DATE COMMENT 'Date on which the contract was terminated, if applicable.',
    `termination_reason` STRING COMMENT 'Reason for contract termination (e.g., resignation, layoff).',
    `union_agreement_reference` STRING COMMENT 'Reference code or identifier for the applicable union agreement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the contract record.',
    `weekly_hours` DECIMAL(18,2) COMMENT 'Total number of hours the employee is contracted to work each week.',
    `work_location` STRING COMMENT 'Primary site or plant where the employee will perform duties.',
    `work_shift` STRING COMMENT 'Designated shift schedule for the employee.. Valid values are `day|night|flex`',
    CONSTRAINT pk_employment_contract PRIMARY KEY(`employment_contract_id`)
) COMMENT 'Formal employment contract record for each employee, capturing contract type (permanent, fixed-term, apprenticeship, CKD expatriate), contract start and end dates, probation period, notice period, governing collective bargaining agreement (CBA) reference, work location, contracted hours per week, and contract status. Tracks the legal employment relationship between Automotive and the employee.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` (
    `shift_schedule_id` BIGINT COMMENT 'Unique identifier for the shift schedule record.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee assigned to the shift.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where the shift occurs.',
    `production_line_id` BIGINT COMMENT 'Identifier of the production line associated with the shift.',
    `work_center_id` BIGINT COMMENT 'Identifier of the work center or station within the line.',
    `break_duration_minutes` STRING COMMENT 'Planned break duration within the shift, expressed in minutes.',
    `break_included` BOOLEAN COMMENT 'Indicates whether a break is scheduled for the shift.',
    `certification_required` STRING COMMENT 'Specific certification needed for the shift (e.g., forklift, safety).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shift schedule record was created.',
    `effective_end_date` DATE COMMENT 'Date when the shift schedule ends; null if open‑ended.',
    `effective_start_date` DATE COMMENT 'Date when the shift schedule becomes effective.',
    `notes` STRING COMMENT 'Free‑form notes or comments about the shift schedule.',
    `overtime_eligible` BOOLEAN COMMENT 'Indicates whether the employee may accrue overtime during this shift.',
    `overtime_rate_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the base pay rate for overtime hours.',
    `schedule_code` STRING COMMENT 'Business identifier code for the shift schedule, used for reference in planning and reporting.. Valid values are `^SCH-d{6}$`',
    `schedule_name` STRING COMMENT 'Human‑readable name or label for the shift schedule.',
    `schedule_source_system` STRING COMMENT 'Source system that originated the schedule record.. Valid values are `SuccessFactors|SAP|Custom`',
    `schedule_version` STRING COMMENT 'Version number of the schedule record for change tracking.',
    `scheduled_hours` DECIMAL(18,2) COMMENT 'Total number of work hours scheduled for the shift.',
    `shift_currency` STRING COMMENT 'Currency code for the shift pay rate.. Valid values are `USD|EUR|CAD|GBP|JPY|CHF`',
    `shift_end_time` TIMESTAMP COMMENT 'Exact timestamp when the shift ends.',
    `shift_pattern` STRING COMMENT 'Pattern defining the time of day for the shift.. Valid values are `day|afternoon|night|rotating`',
    `shift_pay_rate` DECIMAL(18,2) COMMENT 'Base hourly pay rate applicable to the shift (currency defined by shift_currency).',
    `shift_start_time` TIMESTAMP COMMENT 'Exact timestamp when the shift starts.',
    `shift_status` STRING COMMENT 'Current lifecycle status of the shift schedule.. Valid values are `planned|active|completed|cancelled`',
    `shift_type` STRING COMMENT 'Classification of the shift (e.g., regular, overtime, holiday).. Valid values are `regular|overtime|holiday`',
    `skill_required` STRING COMMENT 'Skill or competency required for the shift (e.g., welding, assembly).',
    `union_flag` BOOLEAN COMMENT 'True if the shift is covered by a union labor agreement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the shift schedule record.',
    CONSTRAINT pk_shift_schedule PRIMARY KEY(`shift_schedule_id`)
) COMMENT 'Planned shift schedule assignment for production and non-production employees at each plant. Captures employee assignment to a shift pattern (day, afternoon, night, rotating), effective date range, plant, production line, work center, scheduled hours, and overtime eligibility. Integrates with manufacturing.shift reference data and MES shop floor scheduling to ensure adequate staffing for SOP targets.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`time_entry` (
    `time_entry_id` BIGINT COMMENT 'Unique identifier for the time entry record.',
    `department_id` BIGINT COMMENT 'Identifier of the organizational department responsible for the work.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who logged the time.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the organizational department responsible for the work.',
    `pay_period_id` BIGINT COMMENT 'Identifier of the pay period to which this entry belongs.',
    `production_order_id` BIGINT COMMENT 'Identifier of the manufacturing work order linked to the labor entry.',
    `absence_type` STRING COMMENT 'Category of absence if the entry represents time off.. Valid values are `vacation|sick|personal|unpaid|other`',
    `approval_status` STRING COMMENT 'Current approval state of the time entry.. Valid values are `pending|approved|rejected`',
    `clock_in_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the employee clocked in.',
    `clock_out_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the employee clocked out.',
    `compliance_flag` BOOLEAN COMMENT 'True when the employee meets required competency records for the task.',
    `cost_center_code` STRING COMMENT 'Accounting cost center to which labor cost is allocated.',
    `entry_status` STRING COMMENT 'Operational status of the time entry record.. Valid values are `active|void|deleted`',
    `is_overtime_approved` BOOLEAN COMMENT 'Indicates whether the overtime portion has been approved.',
    `is_shift_differential` BOOLEAN COMMENT 'True if shift‑differential premium applies to this entry.',
    `job_role` STRING COMMENT 'Specific role or title of the employee for this entry (e.g., assembler, technician).',
    `labor_category` STRING COMMENT 'Broad classification of the work performed.. Valid values are `production|maintenance|admin|engineering|sales|support`',
    `labor_grade` STRING COMMENT 'Grade or level of the employees labor classification (e.g., G1, G2).',
    `labor_rate_amount` DECIMAL(18,2) COMMENT 'Hourly labor rate applicable to the employee for this entry.',
    `notes` STRING COMMENT 'Free‑text field for additional remarks or explanations.',
    `overtime_hours` DECIMAL(18,2) COMMENT 'Number of overtime hours logged for the entry.',
    `overtime_multiplier` DECIMAL(18,2) COMMENT 'Factor applied to regular rate to calculate overtime pay (e.g., 1.5).',
    `project_code` STRING COMMENT 'Code of the internal project or initiative to which labor is charged.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the time entry record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the time entry record.',
    `record_version` STRING COMMENT 'Version number for optimistic concurrency control.',
    `regular_hours` DECIMAL(18,2) COMMENT 'Number of regular (non‑overtime) hours worked in the entry.',
    `safety_certification_status` STRING COMMENT 'Current status of the employees safety certification.. Valid values are `valid|expired|none`',
    `shift_code` STRING COMMENT 'Code representing the scheduled shift (e.g., A, B, C).',
    `shift_differential_hours` DECIMAL(18,2) COMMENT 'Hours worked that qualify for a shift‑differential premium.',
    `source` STRING COMMENT 'Origin of the entry creation request.. Valid values are `self_service|manager|hr`',
    `time_entry_type` STRING COMMENT 'Method by which the time was recorded.. Valid values are `clock|manual|adjustment`',
    `training_completed` BOOLEAN COMMENT 'Indicates whether required training for the job role has been completed.',
    `union_code` STRING COMMENT 'Identifier of the union representing the employee, if applicable.',
    `work_date` DATE COMMENT 'Calendar date on which the work was performed.',
    CONSTRAINT pk_time_entry PRIMARY KEY(`time_entry_id`)
) COMMENT 'Transactional record of actual hours worked, absence, and overtime for each employee per pay period. Captures clock-in/clock-out timestamps, regular hours, overtime hours, shift differential hours, absence type, approval status, and cost center allocation. Source of truth for payroll calculation and labor cost reporting. Integrates with SAP SuccessFactors Time Tracking and SAP S/4HANA CO for labor cost posting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`absence_record` (
    `absence_record_id` BIGINT COMMENT 'Unique identifier for the absence record.',
    `employee_id` BIGINT COMMENT 'Identifier of the manager or HR representative who approved/rejected the request.',
    `approver_employee_id` BIGINT COMMENT 'Identifier of the manager or HR representative who approved/rejected the request.',
    `primary_absence_employee_id` BIGINT COMMENT 'Identifier of the employee to whom the absence applies.',
    `absence_category` STRING COMMENT 'Indicates whether the absence is paid or unpaid.. Valid values are `paid|unpaid`',
    `absence_number` STRING COMMENT 'Human‑readable reference number for the absence transaction.',
    `absence_record_status` STRING COMMENT 'Current lifecycle status of the absence request.. Valid values are `pending|approved|rejected|cancelled`',
    `absence_type` STRING COMMENT 'Category of the absence (e.g., vacation, sick, FMLA, parental, union, bereavement, other). [ENUM-REF-CANDIDATE: vacation|sick|fmla|parental|union|bereavement|other — promote to reference product]',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the absence was approved or rejected.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the absence record was first created in the system.',
    `duration_days` DECIMAL(18,2) COMMENT 'Total duration of the absence expressed in working days.',
    `duration_hours` DECIMAL(18,2) COMMENT 'Total duration of the absence expressed in hours.',
    `end_date` DATE COMMENT 'Last calendar date of the absence period.',
    `medical_certificate_number` STRING COMMENT 'Reference number of the attached medical certificate document.',
    `medical_certification_flag` BOOLEAN COMMENT 'Indicates whether a medical certificate was provided for the absence.',
    `notes` STRING COMMENT 'Additional notes or comments entered by the employee or approver.',
    `reason_description` STRING COMMENT 'Free‑text description of the reason for the absence.',
    `request_timestamp` TIMESTAMP COMMENT 'Date and time when the absence request was submitted.',
    `return_to_work_date` DATE COMMENT 'Scheduled date for the employee to return to work after the absence.',
    `shift_coverage_required` BOOLEAN COMMENT 'Indicates whether temporary coverage is required for the affected shifts.',
    `shift_impact_flag` BOOLEAN COMMENT 'Indicates whether the absence impacts scheduled production shifts.',
    `start_date` DATE COMMENT 'First calendar date of the absence period.',
    `union_leave_flag` BOOLEAN COMMENT 'Indicates if the absence is covered under a union agreement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the absence record.',
    CONSTRAINT pk_absence_record PRIMARY KEY(`absence_record_id`)
) COMMENT 'Transactional record capturing planned and unplanned employee absences including vacation, sick leave, FMLA, parental leave, union leave, and bereavement. Captures absence type, start date, end date, duration in hours/days, approval status, medical certification flag, and return-to-work date. Supports absenteeism tracking, IATF compliance, and production staffing gap analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` (
    `payroll_result_id` BIGINT COMMENT 'System-generated unique identifier for the payroll result record.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee to whom this payroll result applies.',
    `bank_account_number` STRING COMMENT 'Employees bank account number for direct deposit.',
    `bank_routing_number` STRING COMMENT 'Bank routing number associated with the employees direct deposit account.',
    `base_salary` DECIMAL(18,2) COMMENT 'Regular salary component for the pay period.',
    `benefit_deduction` DECIMAL(18,2) COMMENT 'Employee contributions to benefits (health, retirement, etc.).',
    `bonus_amount` DECIMAL(18,2) COMMENT 'Any discretionary or performance‑based bonus paid in the period.',
    `cost_center_code` STRING COMMENT 'Internal cost center associated with the employees labor cost.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payroll result record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary values.. Valid values are `USD|EUR|GBP|CAD|JPY`',
    `department_code` STRING COMMENT 'Organizational department to which the employee belongs.',
    `employee_ssn` STRING COMMENT 'Government‑issued identifier used for tax reporting.',
    `employee_type` STRING COMMENT 'Employment relationship type of the worker.. Valid values are `regular|contract|temp|intern`',
    `employer_contribution` DECIMAL(18,2) COMMENT 'Employer‑paid amounts such as pension or insurance contributions.',
    `fiscal_period` STRING COMMENT 'Quarter of the fiscal year for reporting purposes.. Valid values are `Q1|Q2|Q3|Q4`',
    `garnishment_amount` DECIMAL(18,2) COMMENT 'Court‑ordered wage garnishments deducted from pay.',
    `gross_pay` DECIMAL(18,2) COMMENT 'Total earnings before any deductions for the pay period.',
    `is_garnishment` BOOLEAN COMMENT 'Indicates whether a garnishment was applied to this payroll.',
    `is_union_member` BOOLEAN COMMENT 'Indicates whether the employee is a union member.',
    `job_code` STRING COMMENT 'Job classification or role code for the employee.',
    `net_pay` DECIMAL(18,2) COMMENT 'Final amount paid to the employee after all deductions and contributions.',
    `overtime_hours` DECIMAL(18,2) COMMENT 'Total overtime hours worked in the pay period.',
    `overtime_pay` DECIMAL(18,2) COMMENT 'Compensation for overtime hours worked during the pay period.',
    `pay_period_end_date` DATE COMMENT 'Last calendar date of the pay period covered by this payroll.',
    `pay_period_start_date` DATE COMMENT 'First calendar date of the pay period covered by this payroll.',
    `pay_rate` DECIMAL(18,2) COMMENT 'Hourly or salary rate applied to calculate base earnings.',
    `pay_rate_type` STRING COMMENT 'Classification of the pay rate (hourly, salary, commission).. Valid values are `hourly|salary|commission`',
    `payment_method` STRING COMMENT 'Method used to deliver net pay to the employee.. Valid values are `direct_deposit|check|cash`',
    `payroll_group` STRING COMMENT 'Frequency group defining the payroll cycle for the employee.. Valid values are `weekly|biweekly|monthly`',
    `payroll_number` STRING COMMENT 'Business identifier assigned to the payroll transaction for reporting and audit.',
    `payroll_result_status` STRING COMMENT 'Current lifecycle status of the payroll record.. Valid values are `pending|processed|error|void`',
    `payroll_run_timestamp` TIMESTAMP COMMENT 'Exact date‑time when the payroll was processed and posted.',
    `shift_differential` DECIMAL(18,2) COMMENT 'Additional pay for working non‑standard shifts (e.g., night, weekend).',
    `shift_hours` DECIMAL(18,2) COMMENT 'Total regular shift hours worked in the pay period.',
    `tax_deduction` DECIMAL(18,2) COMMENT 'Statutory tax withholdings deducted from gross pay.',
    `tax_withholding_code` STRING COMMENT 'Code representing the employees tax withholding status.',
    `tax_year` STRING COMMENT 'Fiscal year to which the payroll tax withholdings apply.',
    `union_dues` DECIMAL(18,2) COMMENT 'Dues deducted for union membership, if applicable.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the payroll result record.',
    CONSTRAINT pk_payroll_result PRIMARY KEY(`payroll_result_id`)
) COMMENT 'Payroll processing result record for each employee per pay period, capturing gross pay, net pay, base salary, overtime pay, shift differentials, bonuses, deductions (tax, benefits, union dues, garnishments), employer contributions, and pay period dates. Sourced from SAP SuccessFactors Payroll and SAP S/4HANA FI payroll posting. Serves as the authoritative payroll ledger for workforce cost reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` (
    `compensation_plan_id` BIGINT COMMENT 'System-generated unique identifier for the compensation plan record.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who approved the compensation plan.',
    `compensation_employee_id` BIGINT COMMENT 'Identifier of the employee who approved the compensation plan.',
    `job_classification_id` BIGINT COMMENT 'Foreign key linking to workforce.job_classification. Business justification: Link compensation plan to job classification for consistent classification reference; remove redundant code column.',
    `primary_compensation_employee_id` BIGINT COMMENT 'Identifier of the individual employee to whom the plan applies (if plan is employee‑specific).',
    `base_salary_max` DECIMAL(18,2) COMMENT 'Maximum annual base salary amount defined by the plan.',
    `base_salary_min` DECIMAL(18,2) COMMENT 'Minimum annual base salary amount defined by the plan.',
    `bonus_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the bonus target based on performance rating.',
    `bonus_plan_type` STRING COMMENT 'Type of bonus structure (e.g., annual performance, quarterly incentive).. Valid values are `annual|quarterly|monthly|none`',
    `bonus_target_amount` DECIMAL(18,2) COMMENT 'Target monetary amount for bonus eligibility.',
    `classification` STRING COMMENT 'High‑level classification used for reporting and analytics.. Valid values are `salary|incentive|benefit|allowance`',
    `compensation_plan_status` STRING COMMENT 'Current lifecycle status of the plan.. Valid values are `active|inactive|pending|suspended`',
    `compliance_notes` STRING COMMENT 'Additional remarks related to regulatory or union compliance.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code where the plan is applicable.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the compensation plan record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary values in the plan.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date on which the compensation plan expires or is superseded; null for open‑ended.',
    `effective_start_date` DATE COMMENT 'Date on which the compensation plan becomes effective.',
    `eligibility_criteria` STRING COMMENT 'Textual description of the criteria employees must meet to be eligible for the plan.',
    `eligibility_end_date` DATE COMMENT 'Date when eligibility for the plan ends, if applicable.',
    `eligibility_start_date` DATE COMMENT 'Date when an employee becomes eligible for the plan.',
    `last_review_date` DATE COMMENT 'Date of the most recent compensation review for the plan.',
    `legal_entity_code` STRING COMMENT 'Identifier of the legal entity (subsidiary, division) that owns the plan.',
    `merit_increase_percent` DECIMAL(18,2) COMMENT 'Standard merit increase percentage applied annually under the plan.',
    `notes` STRING COMMENT 'Free‑form notes or comments about the plan.',
    `overtime_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to base hourly rate for overtime hours.',
    `pay_equity_analysis_flag` BOOLEAN COMMENT 'Flag indicating the plan has been reviewed for pay equity compliance.',
    `pay_grade` STRING COMMENT 'Internal pay‑grade identifier associated with the plan.',
    `payroll_frequency` STRING COMMENT 'How often payroll is processed for this plan.. Valid values are `monthly|biweekly|weekly|quarterly`',
    `plan_code` STRING COMMENT 'External business identifier or code for the compensation plan, used in HR and payroll systems.',
    `plan_name` STRING COMMENT 'Human‑readable name of the compensation plan.',
    `plan_type` STRING COMMENT 'Category of the plan indicating the primary compensation component.. Valid values are `base_salary|bonus|commission|equity|shift_differential`',
    `review_cycle` STRING COMMENT 'Frequency of formal compensation review (e.g., annual, biennial).',
    `shift_differential_rate` DECIMAL(18,2) COMMENT 'Additional hourly rate applied for non‑standard shifts (e.g., night, weekend).',
    `tax_withholding_rate` DECIMAL(18,2) COMMENT 'Statutory tax withholding percentage applied to compensation.',
    `union_cba_compliant` BOOLEAN COMMENT 'Indicates whether the plan complies with applicable union collective bargaining agreements.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the compensation plan record.',
    `version_number` STRING COMMENT 'Incremental version of the plan for change management.',
    CONSTRAINT pk_compensation_plan PRIMARY KEY(`compensation_plan_id`)
) COMMENT 'Master record defining the compensation structure for a job classification or individual employee, including base salary range, merit increase eligibility, bonus plan type, shift differential rates, overtime multipliers, and effective date. Supports annual compensation review cycles, union CBA compliance, and pay equity analysis across Automotives global manufacturing workforce.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` (
    `benefit_enrollment_id` BIGINT COMMENT 'System-generated unique identifier for each benefit enrollment record.',
    `benefit_plan_id` BIGINT COMMENT 'Unique identifier of the benefit plan to which the employee is enrolled.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee who is enrolled in the benefit.',
    `auto_enroll_eligibility_date` DATE COMMENT 'Date the employee became eligible for auto‑enrollment.',
    `benefit_category` STRING COMMENT 'High‑level category of the benefit (e.g., health, dental).. Valid values are `health|dental|vision|life|disability|retirement`',
    `coverage_end_date` DATE COMMENT 'Date when the coverage period ends.',
    `coverage_limit_amount` DECIMAL(18,2) COMMENT 'Maximum monetary amount covered per period.',
    `coverage_limit_units` STRING COMMENT 'Units for the coverage limit (e.g., per year, per incident).',
    `coverage_start_date` DATE COMMENT 'Date when the coverage period begins.',
    `coverage_type` STRING COMMENT 'Type of coverage selected (individual, family, employee + spouse).. Valid values are `individual|family|employee_spouse`',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `dependent_birth_date` DATE COMMENT 'Birth date of the covered dependent.',
    `dependent_coverage_flag` BOOLEAN COMMENT 'Indicates whether dependents are covered under the plan.',
    `dependent_name` STRING COMMENT 'Legal name of the covered dependent.',
    `dependent_relationship` STRING COMMENT 'Relationship of the covered dependent to the employee.. Valid values are `spouse|child|parent|other`',
    `effective_date` DATE COMMENT 'Date the benefit coverage becomes effective.',
    `eligibility_criteria` STRING COMMENT 'Textual description of eligibility conditions.',
    `eligibility_date` DATE COMMENT 'Date the employee became eligible for the benefit.',
    `employee_contribution_amount` DECIMAL(18,2) COMMENT 'Amount the employee contributes per pay period.',
    `employer_contribution_amount` DECIMAL(18,2) COMMENT 'Amount the employer contributes per pay period.',
    `enrollment_date` DATE COMMENT 'Date the enrollment request was submitted.',
    `enrollment_number` STRING COMMENT 'Business-visible enrollment reference used in HR communications and reporting.',
    `enrollment_source` STRING COMMENT 'Origin of the enrollment request.. Valid values are `HR portal|admin|self-service`',
    `enrollment_status` STRING COMMENT 'Current lifecycle status of the enrollment.. Valid values are `active|pending|terminated|cancelled`',
    `is_auto_enrolled` BOOLEAN COMMENT 'Indicates if the employee was auto‑enrolled.',
    `is_waived` BOOLEAN COMMENT 'Indicates if the employee has waived the benefit.',
    `payroll_cycle` STRING COMMENT 'Frequency of payroll deductions for the benefit.. Valid values are `monthly|biweekly|weekly`',
    `payroll_deduction_code` STRING COMMENT 'Code used in payroll system to map the deduction.',
    `plan_annual_maximum` DECIMAL(18,2) COMMENT 'Maximum total benefit amount payable in a calendar year.',
    `plan_change_allowed` BOOLEAN COMMENT 'Indicates whether the employee may change the plan during the year.',
    `plan_change_deadline` DATE COMMENT 'Last date to request a plan change.',
    `plan_cost_share_amount` DECIMAL(18,2) COMMENT 'Monetary amount of the employees cost‑share per period.',
    `plan_cost_share_percent` DECIMAL(18,2) COMMENT 'Percentage of the premium cost shared by the employee.',
    `plan_enrollment_window_end` DATE COMMENT 'End date of the open enrollment period for the plan.',
    `plan_enrollment_window_start` DATE COMMENT 'Start date of the open enrollment period for the plan.',
    `plan_group_number` STRING COMMENT 'Group number assigned to the plan for reporting.',
    `plan_renewal_date` DATE COMMENT 'Date the plan is scheduled for renewal.',
    `plan_renewal_status` STRING COMMENT 'Current status of the plan renewal.. Valid values are `renewed|pending|expired`',
    `plan_type` STRING COMMENT 'Tax treatment of the benefit (pre‑tax or post‑tax).. Valid values are `pre-tax|post-tax`',
    `plan_vendor` STRING COMMENT 'External provider of the benefit plan.',
    `plan_wait_period_days` STRING COMMENT 'Number of days after eligibility before benefits become payable.',
    `termination_date` DATE COMMENT 'Date the benefit coverage ends, if applicable.',
    `total_premium_amount` DECIMAL(18,2) COMMENT 'Combined employee and employer premium for the coverage period.',
    `waiver_reason` STRING COMMENT 'Reason provided for waiving the benefit.',
    CONSTRAINT pk_benefit_enrollment PRIMARY KEY(`benefit_enrollment_id`)
) COMMENT 'Employee benefit enrollment record capturing active enrollments in health insurance, dental, vision, life insurance, disability, 401(k)/pension, employee stock purchase plan (ESPP), and wellness programs. Tracks plan type, coverage tier, enrollment date, effective date, employee contribution amount, employer contribution amount, and enrollment status. Sourced from SuccessFactors Benefits.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` (
    `talent_requisition_id` BIGINT COMMENT 'System-generated unique identifier for the talent requisition record.',
    `department_id` BIGINT COMMENT 'Identifier of the department requesting the hire.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the department requesting the hire.',
    `employee_id` BIGINT COMMENT 'Identifier of the manager who owns the requisition.',
    `talent_approved_by_employee_id` BIGINT COMMENT 'Identifier of the approver who authorized the requisition.',
    `talent_employee_id` BIGINT COMMENT 'Identifier of the manager who owns the requisition.',
    `tertiary_talent_filled_by_employee_id` BIGINT COMMENT 'Identifier of the employee hired for the position.',
    `approval_status` STRING COMMENT 'Current status of the requisitions approval workflow.. Valid values are `pending|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date‑time when the requisition was approved.',
    `budgeted_salary` DECIMAL(18,2) COMMENT 'Maximum salary budget allocated for the position.',
    `closing_date` DATE COMMENT 'Date after which the requisition will no longer accept applications.',
    `compensation_grade` STRING COMMENT 'Internal compensation grade assigned to the role.. Valid values are `grade1|grade2|grade3|grade4|grade5`',
    `competency_requirements` STRING COMMENT 'Key competencies and skills needed for successful performance.',
    `compliance_iatf_required` BOOLEAN COMMENT 'Indicates if the position must meet IATF 16949 competency requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the requisition was initially created in the system.',
    `filled_date` DATE COMMENT 'Date the position was filled.',
    `headcount_quantity` STRING COMMENT 'Number of individual positions requested in this requisition.',
    `headcount_type` STRING COMMENT 'Indicates whether the requisition creates new headcount or replaces an existing role.. Valid values are `new|replacement`',
    `interview_stage` STRING COMMENT 'Current stage of the interview process.. Valid values are `phone|onsite|virtual|final|offer|rejected`',
    `is_internal_requisition` BOOLEAN COMMENT 'Flag indicating the role is for an internal transfer or promotion.',
    `job_code` STRING COMMENT 'Internal code used to classify the job family or role.',
    `language_requirements` STRING COMMENT 'Languages and proficiency levels needed for the position.',
    `notes` STRING COMMENT 'Free‑form notes or comments added by recruiters or managers.',
    `position_title` STRING COMMENT 'Official title of the job vacancy.',
    `posting_date` DATE COMMENT 'Date the requisition was posted to internal/external job boards.',
    `priority` STRING COMMENT 'Business priority assigned to the requisition.. Valid values are `low|medium|high|critical`',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp of when the record was first captured for audit purposes.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record for audit purposes.',
    `recruitment_budget` DECIMAL(18,2) COMMENT 'Total budget allocated for recruitment activities (advertising, agency fees, etc.).',
    `relocation_assistance` BOOLEAN COMMENT 'Flag indicating if relocation support is offered.',
    `remote_option` BOOLEAN COMMENT 'Indicates whether the role can be performed remotely.',
    `required_certifications` STRING COMMENT 'Comma‑separated list of mandatory professional certifications.',
    `required_education_level` STRING COMMENT 'Minimum education qualification required for the role.. Valid values are `high_school|associate|bachelor|master|doctorate`',
    `required_experience_years` STRING COMMENT 'Minimum years of relevant experience required.',
    `required_skills` STRING COMMENT 'List of technical and soft skills required for the role.',
    `requisition_number` STRING COMMENT 'Human‑readable business identifier assigned to the requisition.',
    `requisition_status` STRING COMMENT 'Current lifecycle state of the requisition.. Valid values are `open|in_progress|filled|cancelled`',
    `salary_range_max` DECIMAL(18,2) COMMENT 'Upper bound of the salary range offered.',
    `salary_range_min` DECIMAL(18,2) COMMENT 'Lower bound of the salary range offered.',
    `sourcing_channel` STRING COMMENT 'Channel through which candidates are sourced.. Valid values are `internal|external|referral|agency|social_media|employee_referral`',
    `target_start_date` DATE COMMENT 'Planned date for the new employee to begin work.',
    `travel_requirement` STRING COMMENT 'Extent of travel expected for the role.. Valid values are `none|occasional|frequent|required`',
    CONSTRAINT pk_talent_requisition PRIMARY KEY(`talent_requisition_id`)
) COMMENT 'Recruitment requisition record initiated when a position vacancy is approved for hiring. Captures requisition number, position, job classification, hiring manager, target start date, requisition status (open, in-progress, filled, cancelled), sourcing channel, headcount type (replacement, new headcount), and approval workflow status. Integrates with SuccessFactors Recruiting Management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`job_application` (
    `job_application_id` BIGINT COMMENT 'Unique identifier for the job application record.',
    `employee_id` BIGINT COMMENT 'Identifier of the manager responsible for the hiring decision.',
    `position_id` BIGINT COMMENT 'Identifier of the job position the candidate applied for.',
    `primary_job_employee_id` BIGINT COMMENT 'Identifier of the manager responsible for the hiring decision.',
    `talent_requisition_id` BIGINT COMMENT 'Identifier of the talent requisition linked to this application.',
    `applicant_name` STRING COMMENT 'Legal full name of the candidate applying for the position.',
    `application_date` DATE COMMENT 'Date when the candidate submitted the application.',
    `assessment_score` DECIMAL(18,2) COMMENT 'Score from any pre-employment assessments or tests.',
    `background_check_completed_timestamp` TIMESTAMP COMMENT 'Timestamp when background check was completed.',
    `background_check_status` STRING COMMENT 'Result of the candidates background verification.. Valid values are `pending|cleared|failed|exempt`',
    `candidate_external_code` STRING COMMENT 'Identifier used by external recruiting agencies or job boards.',
    `candidate_status` STRING COMMENT 'Overall status of the candidate record.. Valid values are `active|inactive|on_hold|withdrawn`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the application record was created in the system.',
    `current_stage` STRING COMMENT 'Current stage of the candidate in the hiring funnel.. Valid values are `screening|interview|offer|hired|rejected|withdrawn`',
    `disability_accommodation_needed` BOOLEAN COMMENT 'Indicates if candidate requires workplace accommodations.',
    `disposition_reason` STRING COMMENT 'Reason for final disposition of the application (e.g., not qualified, accepted).',
    `education_level` STRING COMMENT 'Highest education attainment of the candidate.. Valid values are `high_school|associate|bachelor|master|doctorate|other`',
    `email_address` STRING COMMENT 'Primary email address for candidate communication.. Valid values are `^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$`',
    `employment_type` STRING COMMENT 'Nature of employment for the position.. Valid values are `full_time|part_time|contract|temporary|internship`',
    `interview_score` DECIMAL(18,2) COMMENT 'Aggregated numeric score from interview evaluations.',
    `last_stage_change_timestamp` TIMESTAMP COMMENT 'Timestamp when the application last moved to a new stage.',
    `last_updated_by` STRING COMMENT 'User identifier who performed the most recent update.',
    `notes` STRING COMMENT 'Free-text notes entered by recruiters or hiring managers.',
    `offer_acceptance_date` DATE COMMENT 'Date when candidate accepted the job offer.',
    `offer_currency` STRING COMMENT 'Currency of the offered salary.. Valid values are `USD|EUR|GBP|JPY|CAD|AUD`',
    `offer_extended` BOOLEAN COMMENT 'Indicates whether a job offer has been extended to the candidate.',
    `offer_salary` DECIMAL(18,2) COMMENT 'Salary amount offered to the candidate.',
    `onboarding_start_date` DATE COMMENT 'Scheduled start date for the new hire onboarding.',
    `phone_number` STRING COMMENT 'Contact telephone number of the candidate.',
    `resume_reference` BIGINT COMMENT 'Identifier of the stored resume document.',
    `salary_expectation` DECIMAL(18,2) COMMENT 'Candidates expected salary.',
    `source_channel` STRING COMMENT 'Origin channel through which the candidate applied.. Valid values are `internal|external|referral|campus|recruiter`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the application record.',
    `visa_status` STRING COMMENT 'Immigration status of the candidate relevant for employment eligibility.. Valid values are `citizen|permanent_resident|work_visa|student_visa|none`',
    `years_of_experience` STRING COMMENT 'Total years of relevant professional experience reported by candidate.',
    CONSTRAINT pk_job_application PRIMARY KEY(`job_application_id`)
) COMMENT 'Candidate application record linked to a talent requisition. Captures applicant name, source channel (internal, external, referral, campus), application date, current stage in the hiring funnel (screening, interview, offer, hired, rejected), interview scores, background check status, offer details, and disposition reason. Supports time-to-fill and source effectiveness reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`performance_review` (
    `performance_review_id` BIGINT COMMENT 'System-generated unique identifier for the performance review record.',
    `employee_id` BIGINT COMMENT 'Identifier of the manager or calibration board member who performed the final review.',
    `primary_performance_employee_id` BIGINT COMMENT 'Unique identifier of the employee being reviewed.',
    `reviewer_employee_id` BIGINT COMMENT 'Identifier of the manager or calibration board member who performed the final review.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the review was formally approved by the authorized manager or calibration board.',
    `calibration_group` STRING COMMENT 'Name of the calibration group or panel that reviewed the rating.',
    `calibration_score` DECIMAL(18,2) COMMENT 'Aggregated score resulting from the calibration process.',
    `calibration_status` STRING COMMENT 'Status of the calibration process that aligns ratings across the organization.. Valid values are `pending|completed|approved`',
    `communication_rating` DECIMAL(18,2) COMMENT 'Rating of the employee’s communication effectiveness.',
    `competency_summary` STRING COMMENT 'Narrative summary of competency strengths and development areas.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the performance review record was first created in the system.',
    `employee_comments` STRING COMMENT 'Free‑text comments entered by the employee (self‑assessment or feedback).',
    `final_approved_rating` DECIMAL(18,2) COMMENT 'Rating that is locked after calibration and managerial approval.',
    `goal_achievement_score` DECIMAL(18,2) COMMENT 'Score reflecting the employee’s achievement of pre‑set goals for the review period.',
    `innovation_rating` DECIMAL(18,2) COMMENT 'Rating of the employee’s contribution to innovative ideas and improvements.',
    `leadership_rating` DECIMAL(18,2) COMMENT 'Rating of the employee’s leadership competencies.',
    `manager_comments` STRING COMMENT 'Free‑text comments entered by the manager during the review.',
    `merit_increase_percent` DECIMAL(18,2) COMMENT 'Percentage increase in base salary tied to the review outcome.',
    `overall_rating` DECIMAL(18,2) COMMENT 'Aggregated overall performance rating on the organization’s rating scale.',
    `promotion_recommendation` STRING COMMENT 'Recommendation on whether the employee should be considered for promotion.. Valid values are `yes|no|maybe`',
    `review_cycle` STRING COMMENT 'The periodicity of the review (e.g., annual, mid-year, quarterly).. Valid values are `annual|mid_year|quarterly`',
    `review_date` TIMESTAMP COMMENT 'Timestamp when the review meeting took place or was recorded.',
    `review_end_date` DATE COMMENT 'Planned end date of the review period.',
    `review_location` STRING COMMENT 'Physical or virtual location where the review was conducted.',
    `review_number` STRING COMMENT 'Business-visible identifier for the review, often used in HR reporting and audit trails.',
    `review_period_quarter` STRING COMMENT 'Fiscal quarter of the review period.. Valid values are `Q1|Q2|Q3|Q4`',
    `review_period_year` STRING COMMENT 'Fiscal year to which the review belongs.',
    `review_start_date` DATE COMMENT 'Planned start date of the review period.',
    `review_status` STRING COMMENT 'Current lifecycle state of the performance review.. Valid values are `draft|in_progress|completed|approved|rejected`',
    `review_type` STRING COMMENT 'Methodology of the review: self-assessment, manager assessment, or 360-degree feedback.. Valid values are `self|manager|360`',
    `reviewer_name` STRING COMMENT 'Full name of the reviewer for reporting purposes.',
    `teamwork_rating` DECIMAL(18,2) COMMENT 'Rating of the employee’s collaboration and teamwork abilities.',
    `technical_rating` DECIMAL(18,2) COMMENT 'Rating of the employee’s technical or functional expertise.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the performance review record.',
    CONSTRAINT pk_performance_review PRIMARY KEY(`performance_review_id`)
) COMMENT 'Annual or mid-year performance review record for an employee, capturing review cycle, overall rating, goal achievement score, competency ratings, manager comments, calibration status, and final approved rating. Supports merit increase decisions, succession planning, and IATF-required competency evaluation documentation. Sourced from SuccessFactors Performance & Goals.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`training_record` (
    `training_record_id` BIGINT COMMENT 'Unique identifier for the training record.',
    `employee_id` BIGINT COMMENT 'Unique identifier for the employee who took the training.',
    `training_course_id` BIGINT COMMENT 'Unique identifier for the training course.',
    `training_employee_id` BIGINT COMMENT 'Identifier of the trainer or instructor.',
    `business_identifier` STRING COMMENT 'External reference number for the training record (e.g., LMS transaction ID).',
    `certification_expiry_date` DATE COMMENT 'Date when the certification expires, if applicable.',
    `certification_issue_date` DATE COMMENT 'Date the certification was issued.',
    `certification_number` STRING COMMENT 'Official certification number issued upon successful completion.',
    `competency_category` STRING COMMENT 'High-level competency area the training addresses.',
    `competency_code` STRING COMMENT 'Standard code for the competency (e.g., IATF competency code).',
    `completion_date` DATE COMMENT 'Date the employee completed the training.',
    `compliance_status` STRING COMMENT 'Compliance status of the training with regulatory requirements.. Valid values are `compliant|non_compliant|pending|exempt`',
    `course_type` STRING COMMENT 'Classification of the training course.. Valid values are `iatf_competency|safety_certification|ev_adas_technical|leadership|compliance|other`',
    `credit_hours` DECIMAL(18,2) COMMENT 'Accredited credit hours awarded for the training.',
    `delivery_method` STRING COMMENT 'Method used to deliver the training.. Valid values are `classroom|e_learning|on_the_job|virtual|blended`',
    `enrollment_date` DATE COMMENT 'Date the employee was enrolled in the training.',
    `iatf_competency_flag` BOOLEAN COMMENT 'Indicates if the training satisfies an IATF competency requirement.',
    `max_score` DECIMAL(18,2) COMMENT 'Maximum possible score for the course.',
    `notes` STRING COMMENT 'Free-text notes related to the training record.',
    `pass_fail_status` STRING COMMENT 'Result of the training assessment.. Valid values are `pass|fail|not_applicable`',
    `quantitative_result` DECIMAL(18,2) COMMENT 'Primary measured outcome of the training (e.g., score percentage).',
    `recertification_due_date` DATE COMMENT 'Due date for required recertification.',
    `recertification_required_flag` BOOLEAN COMMENT 'Indicates if periodic recertification is required.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the training record was created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the training record.',
    `safety_certification_flag` BOOLEAN COMMENT 'Indicates if the training provides a safety certification.',
    `score` DECIMAL(18,2) COMMENT 'Numeric score achieved by the employee.',
    `trainer_name` STRING COMMENT 'Name of the trainer or instructor.',
    `training_event_timestamp` TIMESTAMP COMMENT 'Timestamp of the actual training event (e.g., when the session occurred).',
    `training_hours` DECIMAL(18,2) COMMENT 'Total hours of training delivered.',
    `training_location` STRING COMMENT 'Physical or virtual location where training was delivered.',
    `training_provider` STRING COMMENT 'Organization or vendor delivering the training.',
    `training_record_status` STRING COMMENT 'Current status of the training record.. Valid values are `enrolled|in_progress|completed|failed|cancelled|withdrawn`',
    CONSTRAINT pk_training_record PRIMARY KEY(`training_record_id`)
) COMMENT 'Transactional record of employee training completions and enrollments, capturing course name, course type (IATF competency, safety certification, EV/ADAS technical, leadership, compliance), delivery method (classroom, e-learning, OJT), completion date, pass/fail status, score, certification expiry date, and training provider. Critical for IATF 16949 competency compliance and OSHA safety certification tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`competency` (
    `competency_id` BIGINT COMMENT 'Unique surrogate key for each competency record.',
    `job_classification_id` BIGINT COMMENT 'add column job_classification_id (BIGINT) with FK to workforce.job_classification.job_classification_id - competencies are required for specific job classifications',
    `applicable_job_family` STRING COMMENT 'Comma‑separated list of job families or roles for which the competency is relevant. [ENUM-REF-CANDIDATE: engineering|manufacturing|quality|sales|service|management|supply_chain|R&D|finance|HR] — promote to reference product',
    `competency_category` STRING COMMENT 'Higher‑level grouping of competencies (e.g., Technical Skills, Leadership Skills).',
    `competency_code` STRING COMMENT 'Business identifier code used to reference the competency across systems.',
    `competency_status` STRING COMMENT 'Current lifecycle status of the competency.. Valid values are `active|inactive|deprecated|pending`',
    `competency_type` STRING COMMENT 'Category that defines the nature of the competency.. Valid values are `technical|behavioral|leadership|safety|iatf_required`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the competency record was first created in the system.',
    `competency_description` STRING COMMENT 'Detailed description of the competency, including scope and expectations.',
    `effective_date` DATE COMMENT 'Date when the competency becomes effective for use.',
    `expiration_date` DATE COMMENT 'Date when the competency is retired or no longer valid; null if indefinite.',
    `iatf_required_flag` BOOLEAN COMMENT 'Indicates whether the competency is mandated by IATF 16949 standards.',
    `is_core_competency` BOOLEAN COMMENT 'True if the competency is considered core to the organization’s strategic capabilities.',
    `last_review_date` DATE COMMENT 'Date when the competency was last reviewed for relevance or revision.',
    `competency_name` STRING COMMENT 'Human‑readable name of the competency.',
    `owner` STRING COMMENT 'Name or identifier of the person or role responsible for maintaining the competency definition.',
    `proficiency_levels` STRING COMMENT 'Standardized proficiency scale associated with the competency.. Valid values are `level_1|level_2|level_3|level_4|level_5`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the competency record.',
    `version_number` STRING COMMENT 'Incremental version of the competency definition.',
    `weight` DECIMAL(18,2) COMMENT 'Weight assigned to the competency for scoring purposes in assessments.',
    CONSTRAINT pk_competency PRIMARY KEY(`competency_id`)
) COMMENT 'Reference master defining the standardized competency framework used across Automotives workforce. Captures competency name, competency type (technical, behavioral, leadership, safety, IATF-required), proficiency levels, applicable job families, and regulatory requirement flag. Provides the taxonomy for IATF 16949 competency records, performance reviews, and skills gap analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` (
    `skills_inventory_id` BIGINT COMMENT 'Unique identifier for the skill inventory record.',
    `competency_id` BIGINT COMMENT 'Foreign key linking to workforce.competency. Business justification: Skills inventory should reference the canonical competency master; remove duplicated descriptive columns.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee to whom the skill record belongs.',
    `skills_employee_id` BIGINT COMMENT 'Identifier of the person who performed the assessment.',
    `assessment_date` DATE COMMENT 'Date when the skill proficiency was assessed.',
    `certification_expiry_date` DATE COMMENT 'Date when the skill certification expires.',
    `certification_status` STRING COMMENT 'Current certification state of the skill.. Valid values are `certified|not_certified|pending|expired`',
    `iatf_competency_required` BOOLEAN COMMENT 'Indicates if the skill is required per IATF 16949 competency standards.',
    `is_core_skill` BOOLEAN COMMENT 'Flag indicating if the skill is a core competency.',
    `is_critical_skill` BOOLEAN COMMENT 'Flag indicating if the skill is critical for operations.',
    `last_assessed_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent skill assessment.',
    `last_training_date` DATE COMMENT 'Date of the most recent training session for the skill.',
    `proficiency_level` STRING COMMENT 'Assessed proficiency tier for the skill.. Valid values are `novice|intermediate|advanced|expert|master`',
    `proficiency_score` DECIMAL(18,2) COMMENT 'Numeric rating of skill proficiency on a 0-5 scale.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the skill record was created.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the skill record.',
    `skill_assessment_method` STRING COMMENT 'Method used to assess the skill.. Valid values are `test|practical|simulation|observation`',
    `skill_certification_body` STRING COMMENT 'Organization that issued the skill certification.',
    `skill_certification_issue_date` DATE COMMENT 'Date the certification was issued.',
    `skill_certification_number` STRING COMMENT 'Identifier of the certification record.',
    `skill_description` STRING COMMENT 'Detailed description of the skill.',
    `skill_last_reviewed_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent skill review.',
    `skill_last_used_date` DATE COMMENT 'Date when the skill was last applied on the shop floor.',
    `skill_last_used_location` STRING COMMENT 'Plant or location where the skill was last utilized.',
    `skill_notes` STRING COMMENT 'Additional free-text notes about the skill.',
    `skill_owner_department` STRING COMMENT 'Department responsible for the skill.',
    `skill_review_cycle_months` STRING COMMENT 'Number of months between skill reviews.',
    `skill_source` STRING COMMENT 'Origin of the skill information.. Valid values are `self_assessment|manager_assessment|external_certification`',
    `skill_status` STRING COMMENT 'Current lifecycle status of the skill record.. Valid values are `active|inactive|deprecated`',
    `skill_training_completion_date` DATE COMMENT 'Date when training was completed.',
    `skill_training_completion_status` STRING COMMENT 'Status of training completion.. Valid values are `completed|in_progress|not_started`',
    `skill_training_program_code` STRING COMMENT 'Code of the training program.',
    `skill_training_provider` STRING COMMENT 'Entity providing the training for the skill.',
    `skill_validity_end_date` DATE COMMENT 'Date until which the skill is considered valid.',
    `skill_validity_start_date` DATE COMMENT 'Date from which the skill is considered valid.',
    `skill_version` STRING COMMENT 'Version identifier for the skill definition.',
    `training_hours_completed` STRING COMMENT 'Total hours of training completed for the skill.',
    CONSTRAINT pk_skills_inventory PRIMARY KEY(`skills_inventory_id`)
) COMMENT 'Employee skills profile record capturing assessed proficiency levels for each competency or technical skill. Tracks skill name, skill category (welding, robotics, EV battery assembly, ADAS calibration, quality inspection, forklift operation), assessed proficiency level, assessment date, assessor, and certification status. Enables skills gap analysis, cross-training planning, and JIT workforce deployment on the shop floor.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` (
    `succession_plan_id` BIGINT COMMENT 'Unique identifier for the succession plan record.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the current incumbent.',
    `succession_employee_id` BIGINT COMMENT 'Employee identifier of the person responsible for the plan.',
    `position_id` BIGINT COMMENT 'Identifier of the key position for which succession is planned.',
    `tertiary_succession_employee_id` BIGINT COMMENT 'Employee identifier of the person responsible for the plan.',
    `approval_date` DATE COMMENT 'Date when the succession plan was approved.',
    `approval_status` STRING COMMENT 'Current approval state of the succession plan.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Identifier of the user who approved the plan.',
    `competency_gap_score` DECIMAL(18,2) COMMENT 'Numeric score quantifying competency gaps between incumbent and successor.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the succession plan record was created.',
    `development_actions` STRING COMMENT 'Planned development activities to prepare the successor.',
    `effective_from` DATE COMMENT 'Date when the succession plan becomes effective.',
    `effective_until` DATE COMMENT 'Date when the succession plan expires or is superseded (nullable).',
    `is_critical` BOOLEAN COMMENT 'Flag indicating whether the target position is a critical role for business continuity.',
    `last_assessment_date` DATE COMMENT 'Date of the most recent assessment of the succession plan.',
    `next_assessment_due` DATE COMMENT 'Planned date for the next assessment of the succession plan.',
    `notes` STRING COMMENT 'Free‑form notes or comments about the succession plan.',
    `plan_code` STRING COMMENT 'Business code used to reference the succession plan.',
    `plan_name` STRING COMMENT 'Descriptive name of the succession plan.',
    `plan_review_date` DATE COMMENT 'Date when the succession plan is scheduled for review.',
    `plan_type` STRING COMMENT 'Category of the succession plan (e.g., leadership, technical).. Valid values are `leadership|technical|operational|support`',
    `priority` STRING COMMENT 'Business priority of the succession plan.. Valid values are `high|medium|low`',
    `readiness_level` STRING COMMENT 'Readiness assessment of the successor (e.g., ready now, 1-2 years, 3-5 years).. Valid values are `ready_now|1-2_years|3-5_years`',
    `risk_level` STRING COMMENT 'Risk rating associated with the succession plan.. Valid values are `low|medium|high`',
    `succession_plan_status` STRING COMMENT 'Current lifecycle status of the plan.. Valid values are `active|inactive|archived`',
    `succession_priority` STRING COMMENT 'Numeric ranking to prioritize succession actions.',
    `updated_by` STRING COMMENT 'Identifier of the user who last updated the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the succession plan record.',
    `version_number` STRING COMMENT 'Version number for change tracking of the plan.',
    `created_by` STRING COMMENT 'Identifier of the user who created the record.',
    CONSTRAINT pk_succession_plan PRIMARY KEY(`succession_plan_id`)
) COMMENT 'Succession planning record identifying key positions and their designated successors within Automotives leadership and critical technical roles. Captures target position, incumbent employee, successor employee, readiness level (ready now, 1-2 years, 3-5 years), development actions, and plan review date. Supports talent pipeline management and business continuity for plant leadership and engineering roles.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` (
    `labor_agreement_id` BIGINT COMMENT 'Unique surrogate key for the labor agreement record.',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - labor agreements are plant-specific in automotive manufacturing',
    `agreement_number` STRING COMMENT 'Official reference number assigned to the labor agreement.',
    `agreement_title` STRING COMMENT 'Descriptive title of the labor agreement.',
    `agreement_type` STRING COMMENT 'Category of the labor agreement.. Valid values are `cba|union_contract|management_agreement`',
    `amendment_history` STRING COMMENT 'Free-text log of amendments made to the agreement over time.',
    `benefit_coverage_description` STRING COMMENT 'Summary of health, retirement, and other benefits provided.',
    `covered_department_codes` STRING COMMENT 'Comma-separated list of department codes covered by the agreement.',
    `covered_plant_codes` STRING COMMENT 'Comma-separated list of plant codes where the agreement applies.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the agreement record was created in the system.',
    `effective_from` DATE COMMENT 'Date when the agreement becomes binding.',
    `effective_until` DATE COMMENT 'Date when the agreement expires or ends.',
    `grievance_procedure` STRING COMMENT 'Process for handling employee grievances under the agreement.',
    `is_collective_bargaining` BOOLEAN COMMENT 'Flag indicating if the agreement is a collective bargaining agreement.',
    `is_unionized` BOOLEAN COMMENT 'Indicates whether the agreement applies to unionized employees.',
    `jurisdiction` STRING COMMENT 'Geographic or legal jurisdiction governing the agreement.',
    `labor_agreement_status` STRING COMMENT 'Current lifecycle status of the agreement.. Valid values are `active|inactive|pending|terminated|draft`',
    `notes` STRING COMMENT 'Additional remarks or comments regarding the agreement.',
    `overtime_rule_description` STRING COMMENT 'Details of overtime eligibility and rates.',
    `payroll_rule_configuration` STRING COMMENT 'Configuration details for payroll processing derived from the agreement.',
    `ratification_date` DATE COMMENT 'Date when the agreement was ratified by both parties.',
    `regulatory_compliance_status` STRING COMMENT 'Status of compliance with labor regulations and standards.. Valid values are `compliant|non_compliant|pending_audit`',
    `seniority_rule_description` STRING COMMENT 'Rules governing seniority for promotions, layoffs, etc.',
    `union_local_number` STRING COMMENT 'Identifier for the specific local chapter of the union.',
    `union_name` STRING COMMENT 'Name of the labor union party to the agreement.',
    `updated_by` STRING COMMENT 'User identifier who last updated the agreement record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the agreement record.',
    `wage_scale_description` STRING COMMENT 'Description of wage scales and grades defined in the agreement.',
    `created_by` STRING COMMENT 'User identifier who created the agreement record.',
    CONSTRAINT pk_labor_agreement PRIMARY KEY(`labor_agreement_id`)
) COMMENT 'Master record for collective bargaining agreements (CBAs) and union labor contracts governing Automotives unionized workforce. Captures union name, agreement effective date, expiration date, covered plant(s), wage scale provisions, overtime rules, grievance procedures, seniority rules, and ratification status. Serves as the authoritative reference for union labor compliance and payroll rule configuration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`grievance` (
    `grievance_id` BIGINT COMMENT 'Unique system-generated identifier for each grievance record.',
    `department_id` BIGINT COMMENT 'Identifier of the department or cost center where the employee works.',
    `employee_id` BIGINT COMMENT 'Identifier of the union representative assigned to the grievance.',
    `labor_agreement_id` BIGINT COMMENT 'Foreign key linking to workforce.labor_agreement. Business justification: Grievance should reference the labor agreement entity for proper contract linkage; replace string code with FK.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the department or cost center where the employee works.',
    `primary_grievance_employee_id` BIGINT COMMENT 'Unique identifier of the employee who submitted the grievance.',
    `audit_notes` STRING COMMENT 'Free‑form notes entered by auditors during compliance reviews.',
    `grievance_category` STRING COMMENT 'Indicates whether the grievance concerns an individual employee, a group of employees, or the union as a whole.. Valid values are `individual|group|union`',
    `compliance_flag` BOOLEAN COMMENT 'True if the grievance handling complies with the applicable CBA provisions.',
    `confidentiality_flag` BOOLEAN COMMENT 'True when the grievance must be handled confidentially under the collective bargaining agreement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the grievance record was first created in the data lake.',
    `deadline_date` DATE COMMENT 'Date by which the current step must be completed.',
    `grievance_description` STRING COMMENT 'Full text description provided by the employee outlining the grievance.',
    `effective_date` DATE COMMENT 'Date when the settlement or corrective action becomes effective.',
    `escalation_level` STRING COMMENT 'Numeric level indicating how many times the grievance has been escalated.',
    `filing_date` TIMESTAMP COMMENT 'Exact timestamp when the grievance was entered into the system.',
    `grievance_number` STRING COMMENT 'Human‑readable grievance number assigned at filing, used for external reference and reporting.',
    `grievance_status` STRING COMMENT 'Overall status of the grievance within the grievance procedure.. Valid values are `open|under_review|resolved|closed|rejected`',
    `grievance_type` STRING COMMENT 'Category of the grievance based on the underlying issue.. Valid values are `wage|discipline|harassment|safety|benefits`',
    `iatf_compliance_flag` BOOLEAN COMMENT 'True when the grievance process meets IATF 16949 competency requirements.',
    `last_action_timestamp` TIMESTAMP COMMENT 'Timestamp of the latest workflow action taken on the grievance.',
    `location` STRING COMMENT 'Identifier of the manufacturing plant or site associated with the grievance.',
    `outcome` STRING COMMENT 'Resulting action taken after grievance resolution.. Valid values are `reinstatement|compensation|no_action|policy_change`',
    `priority` STRING COMMENT 'Priority level used for scheduling and resource allocation.. Valid values are `low|medium|high|critical`',
    `resolution_date` DATE COMMENT 'Calendar date on which the grievance was formally resolved.',
    `resolution_status` STRING COMMENT 'Indicates whether the grievance has been settled, remains open, or was withdrawn.. Valid values are `settled|unsettled|withdrawn`',
    `settlement_amount` DECIMAL(18,2) COMMENT 'Financial amount paid or adjusted as part of the grievance settlement.',
    `settlement_currency` STRING COMMENT 'Three‑letter currency code (e.g., USD, EUR) for the settlement amount.. Valid values are `^[A-Z]{3}$`',
    `settlement_notes` STRING COMMENT 'Narrative details describing the terms of the settlement.',
    `source` STRING COMMENT 'Origin of the grievance filing, indicating who initiated it.. Valid values are `employee|union|manager|hr`',
    `step_in_process` STRING COMMENT 'Specific stage of the grievance workflow the record is currently in.. Valid values are `filing|investigation|mediation|arbitration|decision`',
    `supporting_documents_flag` BOOLEAN COMMENT 'True if the grievance includes attached evidence or documents.',
    `target_resolution_date` DATE COMMENT 'Planned date by which the grievance should be resolved.',
    `updated_by` BIGINT COMMENT 'Identifier of the system user who performed the most recent update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the grievance record.',
    `created_by` BIGINT COMMENT 'Identifier of the system user who entered the grievance.',
    CONSTRAINT pk_grievance PRIMARY KEY(`grievance_id`)
) COMMENT 'Transactional record for formal employee or union grievances filed against Automotive under a collective bargaining agreement or company policy. Captures grievance number, filing date, grievant employee, union steward, grievance type, description, step in the grievance procedure, resolution status, resolution date, and outcome. Supports labor relations management and CBA compliance tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` (
    `safety_incident_id` BIGINT COMMENT 'Unique surrogate key for the safety incident record.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee directly involved in the incident.',
    `safety_employee_id` BIGINT COMMENT 'Employee responsible for leading the incident investigation.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of equipment involved, if any.',
    `safety_equipment_registry_id` BIGINT COMMENT 'Identifier of equipment involved, if any.',
    `body_part_affected` STRING COMMENT 'Anatomical body part injured or impacted, if applicable.',
    `corrective_action` STRING COMMENT 'Planned or executed corrective action to prevent recurrence.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the incident record was first created in the system.',
    `days_away_from_work` STRING COMMENT 'Number of workdays the employee was unable to work due to the incident.',
    `equipment_type` STRING COMMENT 'Category of equipment implicated in the incident.. Valid values are `machine|tool|vehicle|fixture`',
    `incident_category` STRING COMMENT 'Higher‑level category grouping the incident for reporting.. Valid values are `safety|health|environment|security`',
    `incident_number` STRING COMMENT 'Business identifier assigned to the incident for tracking and reporting.',
    `incident_status` STRING COMMENT 'Current lifecycle status of the incident record.. Valid values are `open|investigating|closed|reopened`',
    `incident_timestamp` TIMESTAMP COMMENT 'Date and time when the safety incident occurred at the plant.',
    `incident_type` STRING COMMENT 'Classification of the incident (e.g., injury, near‑miss, property damage, environmental).. Valid values are `injury|near_miss|property_damage|environmental`',
    `injury_description` STRING COMMENT 'Narrative description of the injury or impact.',
    `injury_severity` STRING COMMENT 'Severity level of the injury as defined by OSHA guidelines.. Valid values are `minor|moderate|severe|fatal`',
    `investigation_end_date` DATE COMMENT 'Date when the investigation was concluded.',
    `investigation_start_date` DATE COMMENT 'Date when the formal investigation of the incident began.',
    `lost_time_indicator` BOOLEAN COMMENT 'True if the incident resulted in lost work time.',
    `osha_300_log_reference` STRING COMMENT 'Reference number linking to the OSHA 300 Log entry.',
    `osha_recordable_flag` BOOLEAN COMMENT 'Indicates whether the incident meets OSHA recordable criteria.',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant where the incident took place.',
    `risk_rating` STRING COMMENT 'Risk rating assigned during incident assessment.. Valid values are `low|medium|high|critical`',
    `root_cause` STRING COMMENT 'Root cause analysis result for the incident.',
    `safety_training_completed_flag` BOOLEAN COMMENT 'Indicates whether the employee had completed required safety training prior to the incident.',
    `safety_training_date` DATE COMMENT 'Date when the employee completed the most recent safety training.',
    `shift` STRING COMMENT 'Work shift during which the incident occurred.. Valid values are `day|swing|night`',
    `updated_by` STRING COMMENT 'User identifier of the person who last modified the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the incident record.',
    `work_center_code` STRING COMMENT 'Code of the work center or production line involved in the incident.',
    `created_by` STRING COMMENT 'User identifier of the person who created the record.',
    CONSTRAINT pk_safety_incident PRIMARY KEY(`safety_incident_id`)
) COMMENT 'Transactional record capturing workplace safety incidents, near-misses, and OSHA recordable events at Automotives manufacturing plants. Captures incident date/time, plant, work center, employee involved, incident type (injury, near-miss, property damage, environmental), body part affected, root cause, corrective action, OSHA recordable flag, days away from work, and OSHA 300 log reference. Supports OSHA compliance and IATF 16949 safety reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` (
    `headcount_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the headcount planning record.',
    `org_unit_id` BIGINT COMMENT 'Reference to the organizational unit (e.g., division, department) the plan applies to.',
    `plant_id` BIGINT COMMENT 'Reference to the manufacturing plant the headcount plan supports.',
    `actual_headcount` STRING COMMENT 'Recorded number of employees actually employed during the period.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date‑time when the plan was approved.',
    `approved_by` BIGINT COMMENT 'Identifier of the employee who approved the plan.',
    `attrition_rate` DECIMAL(18,2) COMMENT 'Assumed annual attrition percentage used for forecasting.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Financial budget allocated to support the planned headcount.',
    `capacity_factor` DECIMAL(18,2) COMMENT 'Planned production capacity factor influencing headcount needs.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the plan record was first created.',
    `currency_code` STRING COMMENT 'Currency of the budget amount.. Valid values are `USD|EUR|JPY|GBP|CAD|AUD`',
    `end_date` DATE COMMENT 'Date when the headcount plan expires or is superseded.',
    `fiscal_year` STRING COMMENT 'Fiscal year (e.g., FY2025) for budgeting alignment.',
    `forecast_method` STRING COMMENT 'Methodology used to generate the headcount forecast.. Valid values are `historical|trend|manager_input`',
    `headcount_category` STRING COMMENT 'Classification of headcount by employment type.. Valid values are `full_time|contract|temp|intern`',
    `headcount_plan_status` STRING COMMENT 'Current lifecycle status of the plan.. Valid values are `draft|submitted|approved|rejected|active|closed`',
    `iatf_competency_required` BOOLEAN COMMENT 'Indicates whether IATF 16949 competency certification is required for the roles covered.',
    `job_family_code` STRING COMMENT 'Code representing the job family or classification targeted by the plan.',
    `labor_agreement_code` STRING COMMENT 'Reference to the collective bargaining agreement governing labor terms.',
    `last_review_date` DATE COMMENT 'Date of the most recent formal review of the plan.',
    `model_year` STRING COMMENT 'Vehicle model year associated with the production volume driving the headcount plan.',
    `new_hire_plan` STRING COMMENT 'Number of new hires projected for the period.',
    `notes` STRING COMMENT 'Free‑form comments or rationale for the plan.',
    `period_type` STRING COMMENT 'Granularity of the planning period.. Valid values are `month|quarter|year`',
    `period_value` STRING COMMENT 'Numeric value of the period (e.g., month number 1‑12, quarter 1‑4).',
    `plan_code` STRING COMMENT 'Business identifier code for the headcount plan, used in reporting and approvals.',
    `plan_name` STRING COMMENT 'Descriptive name of the headcount plan (e.g., "2025 Model Year Plant A Ramp-Up").',
    `plan_type` STRING COMMENT 'Classification of the plan frequency or purpose.. Valid values are `annual|quarterly|monthly|ad_hoc`',
    `planned_headcount` STRING COMMENT 'Target number of employees planned for the period.',
    `review_cycle` STRING COMMENT 'Frequency at which the plan is reviewed and updated.. Valid values are `monthly|quarterly|annual`',
    `safety_certification_status` STRING COMMENT 'Status of required safety certifications for the workforce segment.. Valid values are `certified|not_certified|pending`',
    `start_date` DATE COMMENT 'Date when the headcount plan becomes effective.',
    `unionized_flag` BOOLEAN COMMENT 'True if the workforce segment is covered by a union agreement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the plan.',
    `variance_headcount` STRING COMMENT 'Difference between planned and actual headcount (planned minus actual).',
    `version_number` STRING COMMENT 'Incremental version of the plan for change tracking.',
    `created_by` BIGINT COMMENT 'Identifier of the employee who created the plan.',
    CONSTRAINT pk_headcount_plan PRIMARY KEY(`headcount_plan_id`)
) COMMENT 'Workforce planning record capturing planned headcount targets by org unit, job family, plant, and time period (monthly/quarterly/annual). Captures planned headcount, actual headcount, variance, attrition assumption, new hire plan, and approval status. Supports SOP (Start of Production) ramp-up planning, capacity planning for new model launches, and annual HR budgeting aligned with CapEx and production volume plans.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` (
    `disciplinary_action_id` BIGINT COMMENT 'System-generated unique identifier for the disciplinary action record.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the manager who authorized or recorded the disciplinary action.',
    `primary_disciplinary_employee_id` BIGINT COMMENT 'Unique identifier of the employee who is the subject of the disciplinary action.',
    `acknowledgment_status` STRING COMMENT 'Indicates whether the employee has formally acknowledged receipt of the action.. Valid values are `acknowledged|not_acknowledged`',
    `action_date` DATE COMMENT 'Date on which the disciplinary action was formally issued.',
    `action_number` STRING COMMENT 'Human‑readable business identifier assigned to the disciplinary action, e.g., DA-000123.. Valid values are `^DA-d{6}$`',
    `action_type` STRING COMMENT 'Category of the disciplinary action taken against the employee.. Valid values are `verbal_warning|written_warning|suspension|termination`',
    `appeal_status` STRING COMMENT 'Current status of any appeal filed against the disciplinary action.. Valid values are `pending|approved|rejected`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the disciplinary action record was first created in the system.',
    `disciplinary_action_description` STRING COMMENT 'Narrative description of the incident and the disciplinary action taken.',
    `disciplinary_action_status` STRING COMMENT 'Current lifecycle state of the disciplinary action.. Valid values are `open|closed|appealed|revoked`',
    `expiry_date` DATE COMMENT 'Date when the disciplinary action expires or is no longer enforceable (e.g., for temporary suspensions).',
    `policy_violated_code` STRING COMMENT 'Code of the internal policy, regulation, or collective‑bargaining agreement that was breached.',
    `severity_level` STRING COMMENT 'Severity rating of the disciplinary action based on policy impact.. Valid values are `low|medium|high|critical`',
    `union_rep_flag` BOOLEAN COMMENT 'True if the employee was represented by a union during the disciplinary process.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the disciplinary action record.',
    CONSTRAINT pk_disciplinary_action PRIMARY KEY(`disciplinary_action_id`)
) COMMENT 'Transactional record of formal disciplinary actions taken against employees, including verbal warnings, written warnings, suspensions, and terminations. Captures action type, incident description, policy violated, action date, issuing manager, employee acknowledgment status, union representation flag, appeal status, and expiry date of the action. Supports progressive discipline management and labor relations compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` (
    `employee_transfer_id` BIGINT COMMENT 'System-generated unique identifier for each employee transfer record.',
    `employee_id` BIGINT COMMENT 'Identifier of the HR or manager who approved the transfer.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the source organizational unit (plant, department, cost center) from which the employee is moving.',
    `position_id` BIGINT COMMENT 'Identifier of the employees current position before the transfer.',
    `primary_employee_id` BIGINT COMMENT 'Unique identifier of the employee being transferred.',
    `to_org_unit_id` BIGINT COMMENT 'Identifier of the destination organizational unit to which the employee is moving.',
    `to_position_id` BIGINT COMMENT 'Identifier of the new position the employee will occupy after the transfer.',
    `approval_status` STRING COMMENT 'Current status of the transfer approval workflow.. Valid values are `pending|approved|rejected`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date‑time when the transfer was approved or rejected.',
    `comments` STRING COMMENT 'Additional free‑form notes entered by HR or the employee regarding the transfer.',
    `compensation_change_flag` BOOLEAN COMMENT 'Indicates whether the transfer results in a change to base salary or compensation package.',
    `compliance_status` STRING COMMENT 'Overall compliance status of the transfer with IATF 16949 and other regulatory requirements.. Valid values are `compliant|non_compliant|pending`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the transfer record was initially created in the system.',
    `effective_date` DATE COMMENT 'Date on which the transfer becomes effective for payroll, benefits, and reporting.',
    `employee_transfer_status` STRING COMMENT 'Overall lifecycle status of the transfer record.. Valid values are `active|closed|cancelled`',
    `from_job_classification_code` STRING COMMENT 'Code representing the employees job classification in the source org unit.',
    `new_pay_grade` STRING COMMENT 'Pay grade assigned to the employee after the transfer, if applicable.',
    `new_salary_amount` DECIMAL(18,2) COMMENT 'Base salary amount effective after the transfer.',
    `new_salary_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the new salary amount.',
    `relocation_flag` BOOLEAN COMMENT 'Indicates whether the transfer requires employee relocation to a different geographic site.',
    `safety_certification_status` STRING COMMENT 'Status of required safety certifications for the employee in the new role.. Valid values are `required|exempt|not_applicable`',
    `seniority_date` DATE COMMENT 'Date used to calculate employee seniority after the transfer, often the original hire date or last promotion date.',
    `temporary_end_date` DATE COMMENT 'Scheduled end date for a temporary transfer, if applicable.',
    `temporary_transfer_flag` BOOLEAN COMMENT 'True if the transfer is for a limited period (e.g., project assignment).',
    `to_job_classification_code` STRING COMMENT 'Code representing the employees job classification in the destination org unit.',
    `training_completion_flag` BOOLEAN COMMENT 'True if mandatory training for the new position has been completed.',
    `transfer_number` STRING COMMENT 'Business identifier assigned to the transfer event, used for tracking and reference in HR processes.',
    `transfer_reason` STRING COMMENT 'Free‑text description of why the transfer is being performed (e.g., business need, employee request, succession planning).',
    `transfer_source_record_reference` STRING COMMENT 'Original identifier of the transfer record in the source system.',
    `transfer_source_system` STRING COMMENT 'Name of the source HR system (e.g., SuccessFactors, Workday) that originated the transfer record.',
    `transfer_type` STRING COMMENT 'Categorizes the nature of the transfer (e.g., promotion, demotion, lateral move, plant relocation, department change).. Valid values are `promotion|demotion|lateral|plant|department`',
    `union_transfer_flag` BOOLEAN COMMENT 'Indicates whether the transfer is subject to a collective bargaining agreement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the transfer record.',
    CONSTRAINT pk_employee_transfer PRIMARY KEY(`employee_transfer_id`)
) COMMENT 'Transactional record capturing internal employee movement events including plant transfers, department transfers, promotions, demotions, and lateral moves. Captures from/to org unit, from/to position, from/to job classification, effective date, transfer reason, relocation flag, and approval chain. Supports workforce mobility tracking, seniority management, and headcount reconciliation across plants.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` (
    `onboarding_task_id` BIGINT COMMENT 'Unique surrogate key for each onboarding task record.',
    `employee_id` BIGINT COMMENT 'Identifier of the HR or functional owner responsible for completing the task.',
    `primary_onboarding_employee_id` BIGINT COMMENT 'Identifier of the newly hired or transferred employee the task belongs to.',
    `actual_effort_hours` DECIMAL(18,2) COMMENT 'Recorded effort spent on the task, expressed in hours.',
    `badge_issued_flag` BOOLEAN COMMENT 'True when the employee badge has been printed and assigned.',
    `benefits_enrollment_status` STRING COMMENT 'Current status of the employees benefits enrollment process.. Valid values are `not_started|in_progress|completed`',
    `completion_date` DATE COMMENT 'Actual date the task was marked completed.',
    `completion_duration_minutes` STRING COMMENT 'Total elapsed minutes from task start to completion.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the onboarding task record was first created in the system.',
    `due_date` DATE COMMENT 'Planned date by which the task should be finished.',
    `effort_estimate_hours` DECIMAL(18,2) COMMENT 'Estimated effort required to complete the task, expressed in hours.',
    `iatf_training_required` BOOLEAN COMMENT 'Indicates whether the task includes mandatory IATF 16949 competency training.',
    `notes` STRING COMMENT 'Free‑form notes captured by the owner or employee.',
    `onboarding_task_status` STRING COMMENT 'Current lifecycle state of the onboarding task.. Valid values are `pending|in_progress|completed|blocked|cancelled`',
    `plant_access_granted_flag` BOOLEAN COMMENT 'True when the employee has been granted physical access to the manufacturing plant.',
    `priority` STRING COMMENT 'Business priority used to sequence work across new hires.. Valid values are `low|medium|high|critical`',
    `task_category` STRING COMMENT 'Category that groups the onboarding activity for reporting and compliance.. Valid values are `it_setup|safety_orientation|iatf_training|badge_issuance|plant_access|benefits_enrollment`',
    `task_code` STRING COMMENT 'Human‑readable identifier used by HR to reference the onboarding task.',
    `task_description` STRING COMMENT 'Detailed description of what the task entails.',
    `task_name` STRING COMMENT 'Descriptive name of the onboarding activity (e.g., "IT System Setup").',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the onboarding task record.',
    CONSTRAINT pk_onboarding_task PRIMARY KEY(`onboarding_task_id`)
) COMMENT 'Transactional record tracking the completion of onboarding activities for newly hired or transferred employees. Captures task name, task category (IT setup, safety orientation, IATF training, badge issuance, plant access, benefits enrollment), assigned owner, due date, completion date, and status. Ensures new hires are production-ready and compliant with IATF 16949 competency requirements before shop floor assignment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` (
    `workforce_certification_id` BIGINT COMMENT 'System-generated unique identifier for each certification record.',
    `compliance_document_id` BIGINT COMMENT 'Internal reference to the scanned or digital verification document.',
    `compliance_emissions_certification_id` BIGINT COMMENT 'SSOT reference to compliance.compliance_emissions_certification (cross-domain duplicate reconciliation; compliance designated SSOT owner for certification).',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee who holds the certification.',
    `certification_code` STRING COMMENT 'Standardized code or number assigned by the issuing body.',
    `certification_level` STRING COMMENT 'Level or grade of the certification (e.g., Level 1, Advanced).',
    `certification_name` STRING COMMENT 'Human‑readable name of the certification (e.g., Forklift Operator, IATF Internal Auditor).',
    `certification_type` STRING COMMENT 'Category of the certification indicating its primary focus.. Valid values are `safety|quality|technical|regulatory|voluntary`',
    `competency_area` STRING COMMENT 'Business or regulatory domain the certification applies to (e.g., IATF, OSHA, EPA).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the certification record was first created in the system.',
    `expiry_date` DATE COMMENT 'Date the certification expires or must be renewed.',
    `is_current` BOOLEAN COMMENT 'True if the certification is currently valid; false if expired or revoked.',
    `is_mandatory` BOOLEAN COMMENT 'True if the certification is required by law or internal policy for the employees role.',
    `is_voluntary` BOOLEAN COMMENT 'True if the certification is optional but encouraged.',
    `issue_date` DATE COMMENT 'Date the certification was originally granted.',
    `issuing_organization` STRING COMMENT 'Name of the authority or body that issued the certification.',
    `last_verified_timestamp` TIMESTAMP COMMENT 'Date‑time when the certification was last validated by HR or compliance.',
    `next_renewal_due_date` DATE COMMENT 'Calculated date by which the certification must be renewed to remain valid.',
    `notes` STRING COMMENT 'Free‑form comments or remarks about the certification.',
    `renewal_status` STRING COMMENT 'Indicates whether renewal is mandatory, optional, or not applicable.. Valid values are `required|optional|not_applicable`',
    `required_job_code` STRING COMMENT 'Job classification code that mandates this certification.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the certification record.',
    `validity_period_days` STRING COMMENT 'Number of days between issue_date and expiry_date.',
    `verification_document_url` STRING COMMENT 'Link to the stored verification document in the document management system.',
    `workforce_certification_status` STRING COMMENT 'Overall lifecycle state of the certification.. Valid values are `active|expired|revoked|suspended|pending`',
    CONSTRAINT pk_workforce_certification PRIMARY KEY(`workforce_certification_id`)
) COMMENT 'Master record tracking mandatory and voluntary certifications held by employees, including safety certifications (forklift, crane, lockout/tagout), quality certifications (IATF internal auditor, SPC, APQP), technical certifications (EV high-voltage safety, ADAS calibration), and regulatory certifications (OSHA 10/30, EPA). Captures certification type, issuing body, issue date, expiry date, renewal status, and verification document reference.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` (
    `labor_cost_allocation_id` BIGINT COMMENT 'System‑generated unique identifier for each labor cost allocation line.',
    `department_id` BIGINT COMMENT 'Identifier of the department to which the employee belongs.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the department to which the employee belongs.',
    `plant_id` BIGINT COMMENT 'Manufacturing plant where the labor was performed.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee whose labor is being allocated.',
    `production_order_id` BIGINT COMMENT 'Identifier of the manufacturing production order linked to the labor effort.',
    `storage_location_id` BIGINT COMMENT 'Identifier of the specific location or work cell where labor was performed.',
    `activity_code` STRING COMMENT 'Code representing the specific shop‑floor activity or operation.',
    `allocated_cost` DECIMAL(18,2) COMMENT 'Total labor cost (hours × rate) allocated to the cost object.',
    `allocated_hours` DECIMAL(18,2) COMMENT 'Total labor hours assigned to the cost object.',
    `allocation_batch_number` BIGINT COMMENT 'Identifier of the allocation batch or header record to which this line belongs.',
    `allocation_date` DATE COMMENT 'Calendar date on which the labor cost allocation was posted.',
    `allocation_method` STRING COMMENT 'Business rule used to allocate the labor cost (e.g., direct, absorption, activity‑based).. Valid values are `direct|absorption|activity_based|standard|other`',
    `approval_status` STRING COMMENT 'Current status of the allocations approval process.. Valid values are `pending|approved|rejected`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date‑time when the allocation was approved.',
    `cost_allocation_type` STRING COMMENT 'Business purpose of the allocation (e.g., production, maintenance, R&D).. Valid values are `production|maintenance|research|admin|other`',
    `cost_center_code` STRING COMMENT 'Internal cost‑center identifier to which the labor cost is charged.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the allocation line was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the allocated cost.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date after which the allocation is no longer valid; null for open‑ended.',
    `effective_start_date` DATE COMMENT 'Date from which the allocation becomes effective; null if immediate.',
    `fiscal_period` STRING COMMENT 'Fiscal quarter or period label for reporting.. Valid values are `Q[1-4]`',
    `fiscal_year` STRING COMMENT 'Four‑digit fiscal year associated with the allocation.',
    `iatf_competency_flag` BOOLEAN COMMENT 'True if the employee meets the IATF competency requirement for the activity.',
    `is_manual_allocation` BOOLEAN COMMENT 'True when the allocation line was entered manually rather than by system run.',
    `job_classification_code` STRING COMMENT 'Code linking to the employees job classification (e.g., skill level, trade).',
    `labor_category` STRING COMMENT 'Classification of labor as direct production or indirect support.. Valid values are `direct|indirect`',
    `labor_cost_allocation_status` STRING COMMENT 'Processing state of the allocation record.. Valid values are `pending|allocated|reversed|closed`',
    `labor_rate` DECIMAL(18,2) COMMENT 'Hourly compensation rate for the employee at the time of allocation.',
    `line_number` STRING COMMENT 'Ordinal position of the allocation line within the batch.',
    `notes` STRING COMMENT 'Optional remarks or business justification for the allocation.',
    `overtime_flag` BOOLEAN COMMENT 'True if the allocated hours include overtime premium.',
    `pay_period_end_date` DATE COMMENT 'Last day of the payroll period in which the labor was earned.',
    `pay_period_start_date` DATE COMMENT 'First day of the payroll period in which the labor was earned.',
    `shift_code` STRING COMMENT 'Code of the work shift during which the labor was performed.',
    `union_cba_code` STRING COMMENT 'Identifier of the union contract governing the employees labor terms.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the allocation line.',
    `version_number` STRING COMMENT 'Incremental version used for record concurrency control.',
    `wbs_element_code` STRING COMMENT 'Project or work‑breakdown‑structure element that receives the labor cost.',
    CONSTRAINT pk_labor_cost_allocation PRIMARY KEY(`labor_cost_allocation_id`)
) COMMENT 'Transactional record capturing the allocation of employee labor costs to cost centers, production orders, projects, and plant activities. Captures employee, pay period, hours allocated, cost center, WBS element or production order reference, labor rate, total allocated cost, and allocation method. Integrates with SAP S/4HANA CO-PA for product costing and manufacturing overhead absorption.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`department` (
    `department_id` BIGINT COMMENT 'Primary key for department',
    `employee_id` BIGINT COMMENT 'Employee identifier of the manager responsible for the department.',
    `parent_department_id` BIGINT COMMENT 'Identifier of the immediate parent department in the organizational hierarchy.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Annual budget allocated to the department, expressed in US dollars.',
    `department_code` STRING COMMENT 'Unique alphanumeric code used to reference the department in HR and finance systems.',
    `cost_center_code` STRING COMMENT 'Financial cost‑center identifier associated with the department.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the department record was first created in the system.',
    `department_type` STRING COMMENT 'Classification of the department (e.g., functional, regional, project, cost center).',
    `department_description` STRING COMMENT 'Free‑form description of the departments purpose and responsibilities.',
    `effective_from` DATE COMMENT 'Date when the department became operational.',
    `effective_until` DATE COMMENT 'Date when the department is scheduled to be retired or restructured (null if open‑ended).',
    `email` STRING COMMENT 'Primary contact email address for the department.',
    `has_safety_certification` BOOLEAN COMMENT 'True if the department holds required safety certifications for automotive manufacturing.',
    `headcount` BIGINT COMMENT 'Current number of employees assigned to the department.',
    `is_unionized` BOOLEAN COMMENT 'Indicates whether the department’s workforce is covered by a labor union.',
    `location_code` STRING COMMENT 'Code of the primary physical location or plant where the department operates.',
    `department_name` STRING COMMENT 'Human‑readable name of the department.',
    `operating_hours_per_week` STRING COMMENT 'Typical number of work hours per week for the department.',
    `phone` STRING COMMENT 'Primary contact telephone number for the department office.',
    `shift_pattern` STRING COMMENT 'Standard shift schedule used by the department.',
    `department_status` STRING COMMENT 'Current lifecycle status of the department.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the department record.',
    CONSTRAINT pk_department PRIMARY KEY(`department_id`)
) COMMENT 'Master reference table for department. Referenced by department_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` (
    `benefit_plan_id` BIGINT COMMENT 'Primary key for benefit_plan',
    `superseded_benefit_plan_id` BIGINT COMMENT 'Self-referencing FK on benefit_plan (superseded_benefit_plan_id)',
    `contribution_amount` DECIMAL(18,2) COMMENT 'Amount contributed by the employer toward the employees premium.',
    `contribution_frequency` STRING COMMENT 'How often the employer contribution is applied.',
    `coverage_details` STRING COMMENT 'Summary of benefits, limits, and covered services provided by the plan.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the benefit plan record was first created.',
    `effective_from` DATE COMMENT 'Date when the benefit plan becomes binding for eligible employees.',
    `effective_until` DATE COMMENT 'Date when the benefit plan ends or is superseded (null for open‑ended).',
    `eligibility_age_max` STRING COMMENT 'Oldest employee age allowed to enroll.',
    `eligibility_age_min` STRING COMMENT 'Youngest employee age allowed to enroll.',
    `eligibility_criteria` STRING COMMENT 'Business rules defining which employees qualify for the plan.',
    `eligibility_employment_status` STRING COMMENT 'Employment status required for eligibility.',
    `eligibility_location` STRING COMMENT 'Geographic location(s) where employees are eligible (e.g., country code).',
    `enrollment_end_date` DATE COMMENT 'Last date employees may enroll in the benefit plan.',
    `enrollment_start_date` DATE COMMENT 'First date employees may enroll in the benefit plan.',
    `is_mandatory` BOOLEAN COMMENT 'True if employee participation in the plan is mandatory.',
    `last_review_date` DATE COMMENT 'Date when the plan was last reviewed for compliance or updates.',
    `next_review_date` DATE COMMENT 'Planned date for the next formal review of the plan.',
    `plan_category` STRING COMMENT 'Higher‑level grouping of the plan (e.g., core, supplemental, voluntary).',
    `plan_code` STRING COMMENT 'Business identifier or code assigned to the benefit plan (e.g., HR catalog number).',
    `plan_coinsurance_percent` DECIMAL(18,2) COMMENT 'Percentage of costs the employee shares after deductible is met.',
    `plan_coverage_limit` DECIMAL(18,2) COMMENT 'Maximum monetary amount the plan will pay for covered services.',
    `plan_deductible_amount` DECIMAL(18,2) COMMENT 'Amount the employee must pay before the plan begins to cover expenses.',
    `plan_name` STRING COMMENT 'Descriptive name of the benefit plan as used in HR communications.',
    `plan_notes` STRING COMMENT 'Free‑form notes or comments about the benefit plan.',
    `plan_out_of_pocket_max` DECIMAL(18,2) COMMENT 'Maximum total amount an employee will pay in a benefit year.',
    `plan_type` STRING COMMENT 'Category of the benefit plan indicating the type of coverage offered.',
    `plan_version` STRING COMMENT 'Version identifier for the plan (e.g., v2024.1).',
    `premium_amount` DECIMAL(18,2) COMMENT 'Amount the employee (or employer) pays for the plan per payment cycle.',
    `premium_currency` STRING COMMENT 'ISO 4217 currency code for the premium amount (e.g., USD).',
    `provider_email` STRING COMMENT 'Primary email contact for the benefit provider.',
    `provider_name` STRING COMMENT 'Name of the external vendor or insurer offering the benefit.',
    `provider_phone` STRING COMMENT 'Primary telephone contact for the benefit provider.',
    `benefit_plan_status` STRING COMMENT 'Current lifecycle status of the benefit plan.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Tax rate applied to the premium when taxability_flag is true.',
    `taxability_flag` BOOLEAN COMMENT 'Indicates whether the plan premiums are subject to payroll tax.',
    `termination_reason` STRING COMMENT 'Reason why the benefit plan was terminated or discontinued.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the benefit plan record.',
    CONSTRAINT pk_benefit_plan PRIMARY KEY(`benefit_plan_id`)
) COMMENT 'Master reference table for benefit_plan. Referenced by plan_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`pay_period` (
    `pay_period_id` BIGINT COMMENT 'Primary key for pay_period',
    `previous_pay_period_id` BIGINT COMMENT 'Self-referencing FK on pay_period (previous_pay_period_id)',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the pay period record was first created in the system.',
    `cut_off_date` DATE COMMENT 'Latest date employees may submit time entries for the period.',
    `pay_period_description` STRING COMMENT 'Free‑form text describing special characteristics of the period.',
    `end_date` DATE COMMENT 'Last calendar date of the pay period.',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter designation for the period.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the pay period belongs.',
    `holiday_indicator` STRING COMMENT 'Degree to which holidays are covered within the period.',
    `is_holiday_period` BOOLEAN COMMENT 'True if the period includes a recognized holiday that affects payroll.',
    `is_overtime_eligible` BOOLEAN COMMENT 'Indicates whether overtime rules apply during this period.',
    `pay_cycle_days` STRING COMMENT 'Number of calendar days covered by the pay period.',
    `pay_rate_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to base rates for this period (e.g., 1.5 for overtime weeks).',
    `payroll_run_date` DATE COMMENT 'Date on which payroll for the period is processed.',
    `period_code` STRING COMMENT 'Standardized code used in payroll systems to reference the period (e.g., "2023-09").',
    `period_name` STRING COMMENT 'Human‑readable name of the pay period (e.g., "September 2023").',
    `period_type` STRING COMMENT 'Classification of the pay period frequency.',
    `start_date` DATE COMMENT 'First calendar date of the pay period.',
    `pay_period_status` STRING COMMENT 'Current lifecycle state of the pay period.',
    `time_zone` STRING COMMENT 'Time zone context for the periods timestamps.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the pay period record.',
    CONSTRAINT pk_pay_period PRIMARY KEY(`pay_period_id`)
) COMMENT 'Master reference table for pay_period. Referenced by pay_period_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`workforce`.`training_course` (
    `training_course_id` BIGINT COMMENT 'Primary key for training_course',
    `competency_id` BIGINT COMMENT 'Reference to the competency framework element that the course addresses.',
    `primary_prerequisite_training_course_id` BIGINT COMMENT 'Self-referencing FK on training_course (prerequisite_training_course_id)',
    `training_prerequisite_course_id` BIGINT COMMENT 'Identifier of a prerequisite course that must be completed before enrolling.',
    `accreditation_body` STRING COMMENT 'External organization that accredits the course, if any.',
    `assessment_method` STRING COMMENT 'Specific approach used for assessment (e.g., multiple‑choice, practical demo).',
    `assessment_type` STRING COMMENT 'Method used to evaluate learner competence.',
    `training_course_category` STRING COMMENT 'Classification of the course by business domain or competency area.',
    `certification_required` BOOLEAN COMMENT 'Indicates whether successful completion grants a formal certification.',
    `training_course_code` STRING COMMENT 'Business identifier or catalogue code used to reference the course.',
    `compliance_requirements` STRING COMMENT 'Regulatory or internal standards the course satisfies (e.g., IATF 16949, OSHA).',
    `cost` DECIMAL(18,2) COMMENT 'Monetary cost to the organization for delivering the course.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the course record was first created in the system.',
    `credit_hours` DECIMAL(18,2) COMMENT 'Number of credit hours awarded upon successful completion.',
    `currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the course cost.',
    `delivery_method` STRING COMMENT 'Primary method used to deliver the training (online, in‑person, or blended).',
    `department` STRING COMMENT 'Organizational department that owns or sponsors the course.',
    `training_course_description` STRING COMMENT 'Detailed narrative describing the objectives, content, and outcomes of the course.',
    `duration_hours` DECIMAL(18,2) COMMENT 'Total instructional time allocated to the course, expressed in hours.',
    `effective_end_date` DATE COMMENT 'Date after which the course is no longer offered (null if open‑ended).',
    `effective_start_date` DATE COMMENT 'Date when the course becomes available for enrollment.',
    `enrollment_deadline` DATE COMMENT 'Last date on which employees may register for the course.',
    `equipment_needed` STRING COMMENT 'List of equipment or tools required for participants.',
    `evaluation_score` DECIMAL(18,2) COMMENT 'Average score recorded for the course across all participants.',
    `feedback_required` BOOLEAN COMMENT 'Indicates whether participants must submit feedback after completion.',
    `instructor_email` STRING COMMENT 'Contact email of the primary instructor.',
    `instructor_name` STRING COMMENT 'Legal name of the primary instructor delivering the course.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the course is required for the target audience.',
    `language` STRING COMMENT 'Two‑letter ISO code of the language in which the course is delivered.',
    `last_review_date` DATE COMMENT 'Date when the course content was last reviewed for relevance and compliance.',
    `location` STRING COMMENT 'Physical site or facility where in‑person sessions are held.',
    `max_participants` STRING COMMENT 'Maximum number of learners allowed to enroll in a single session.',
    `training_course_name` STRING COMMENT 'Human‑readable title of the training course.',
    `pass_score` DECIMAL(18,2) COMMENT 'Minimum score (percentage) required to pass the assessment.',
    `room_number` STRING COMMENT 'Specific room or hall identifier for the in‑person session.',
    `skill_tags` STRING COMMENT 'Comma‑separated list of skill keywords associated with the course.',
    `training_course_status` STRING COMMENT 'Current lifecycle status of the course.',
    `target_audience` STRING COMMENT 'Primary employee group(s) for which the course is intended.',
    `training_materials_url` STRING COMMENT 'Web address where course materials (slides, docs) are stored.',
    `training_provider` STRING COMMENT 'Entity (internal department or external vendor) that delivers the course.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the course record.',
    `version_number` STRING COMMENT 'Version identifier for the course content (e.g., v1.2).',
    `video_url` STRING COMMENT 'Link to any video content associated with the course.',
    CONSTRAINT pk_training_course PRIMARY KEY(`training_course_id`)
) COMMENT 'Master reference table for training_course. Referenced by course_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_job_classification_id` FOREIGN KEY (`job_classification_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`job_classification`(`job_classification_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_labor_agreement_id` FOREIGN KEY (`labor_agreement_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`labor_agreement`(`labor_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_manager_employee_id` FOREIGN KEY (`manager_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_job_classification_id` FOREIGN KEY (`job_classification_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`job_classification`(`job_classification_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_primary_position_department_org_unit_id` FOREIGN KEY (`primary_position_department_org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_primary_position_employee_id` FOREIGN KEY (`primary_position_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_labor_agreement_id` FOREIGN KEY (`labor_agreement_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`labor_agreement`(`labor_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_parent_org_unit_id` FOREIGN KEY (`parent_org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ADD CONSTRAINT `fk_workforce_job_classification_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ADD CONSTRAINT `fk_workforce_employment_contract_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ADD CONSTRAINT `fk_workforce_employment_contract_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ADD CONSTRAINT `fk_workforce_employment_contract_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ADD CONSTRAINT `fk_workforce_employment_contract_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ADD CONSTRAINT `fk_workforce_employment_contract_primary_employment_employee_id` FOREIGN KEY (`primary_employment_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_pay_period_id` FOREIGN KEY (`pay_period_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`pay_period`(`pay_period_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ADD CONSTRAINT `fk_workforce_absence_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ADD CONSTRAINT `fk_workforce_absence_record_approver_employee_id` FOREIGN KEY (`approver_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ADD CONSTRAINT `fk_workforce_absence_record_primary_absence_employee_id` FOREIGN KEY (`primary_absence_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ADD CONSTRAINT `fk_workforce_payroll_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ADD CONSTRAINT `fk_workforce_compensation_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ADD CONSTRAINT `fk_workforce_compensation_plan_compensation_employee_id` FOREIGN KEY (`compensation_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ADD CONSTRAINT `fk_workforce_compensation_plan_job_classification_id` FOREIGN KEY (`job_classification_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`job_classification`(`job_classification_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ADD CONSTRAINT `fk_workforce_compensation_plan_primary_compensation_employee_id` FOREIGN KEY (`primary_compensation_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ADD CONSTRAINT `fk_workforce_benefit_enrollment_benefit_plan_id` FOREIGN KEY (`benefit_plan_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`benefit_plan`(`benefit_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ADD CONSTRAINT `fk_workforce_benefit_enrollment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ADD CONSTRAINT `fk_workforce_talent_requisition_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ADD CONSTRAINT `fk_workforce_talent_requisition_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ADD CONSTRAINT `fk_workforce_talent_requisition_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ADD CONSTRAINT `fk_workforce_talent_requisition_talent_approved_by_employee_id` FOREIGN KEY (`talent_approved_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ADD CONSTRAINT `fk_workforce_talent_requisition_talent_employee_id` FOREIGN KEY (`talent_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ADD CONSTRAINT `fk_workforce_talent_requisition_tertiary_talent_filled_by_employee_id` FOREIGN KEY (`tertiary_talent_filled_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_primary_job_employee_id` FOREIGN KEY (`primary_job_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_talent_requisition_id` FOREIGN KEY (`talent_requisition_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`talent_requisition`(`talent_requisition_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_primary_performance_employee_id` FOREIGN KEY (`primary_performance_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_reviewer_employee_id` FOREIGN KEY (`reviewer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ADD CONSTRAINT `fk_workforce_training_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ADD CONSTRAINT `fk_workforce_training_record_training_course_id` FOREIGN KEY (`training_course_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`training_course`(`training_course_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ADD CONSTRAINT `fk_workforce_training_record_training_employee_id` FOREIGN KEY (`training_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ADD CONSTRAINT `fk_workforce_competency_job_classification_id` FOREIGN KEY (`job_classification_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`job_classification`(`job_classification_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ADD CONSTRAINT `fk_workforce_skills_inventory_competency_id` FOREIGN KEY (`competency_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`competency`(`competency_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ADD CONSTRAINT `fk_workforce_skills_inventory_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ADD CONSTRAINT `fk_workforce_skills_inventory_skills_employee_id` FOREIGN KEY (`skills_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ADD CONSTRAINT `fk_workforce_succession_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ADD CONSTRAINT `fk_workforce_succession_plan_succession_employee_id` FOREIGN KEY (`succession_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ADD CONSTRAINT `fk_workforce_succession_plan_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ADD CONSTRAINT `fk_workforce_succession_plan_tertiary_succession_employee_id` FOREIGN KEY (`tertiary_succession_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_labor_agreement_id` FOREIGN KEY (`labor_agreement_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`labor_agreement`(`labor_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_primary_grievance_employee_id` FOREIGN KEY (`primary_grievance_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_safety_employee_id` FOREIGN KEY (`safety_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ADD CONSTRAINT `fk_workforce_headcount_plan_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ADD CONSTRAINT `fk_workforce_disciplinary_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ADD CONSTRAINT `fk_workforce_disciplinary_action_primary_disciplinary_employee_id` FOREIGN KEY (`primary_disciplinary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ADD CONSTRAINT `fk_workforce_employee_transfer_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ADD CONSTRAINT `fk_workforce_employee_transfer_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ADD CONSTRAINT `fk_workforce_employee_transfer_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ADD CONSTRAINT `fk_workforce_employee_transfer_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ADD CONSTRAINT `fk_workforce_employee_transfer_to_org_unit_id` FOREIGN KEY (`to_org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ADD CONSTRAINT `fk_workforce_employee_transfer_to_position_id` FOREIGN KEY (`to_position_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ADD CONSTRAINT `fk_workforce_onboarding_task_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ADD CONSTRAINT `fk_workforce_onboarding_task_primary_onboarding_employee_id` FOREIGN KEY (`primary_onboarding_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ADD CONSTRAINT `fk_workforce_workforce_certification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ADD CONSTRAINT `fk_workforce_department_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ADD CONSTRAINT `fk_workforce_department_parent_department_id` FOREIGN KEY (`parent_department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ADD CONSTRAINT `fk_workforce_benefit_plan_superseded_benefit_plan_id` FOREIGN KEY (`superseded_benefit_plan_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`benefit_plan`(`benefit_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ADD CONSTRAINT `fk_workforce_pay_period_previous_pay_period_id` FOREIGN KEY (`previous_pay_period_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`pay_period`(`pay_period_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_competency_id` FOREIGN KEY (`competency_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`competency`(`competency_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_primary_prerequisite_training_course_id` FOREIGN KEY (`primary_prerequisite_training_course_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`training_course`(`training_course_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_training_prerequisite_course_id` FOREIGN KEY (`training_prerequisite_course_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`training_course`(`training_course_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`workforce` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_automotive_v1`.`workforce` SET TAGS ('dbx_domain' = 'workforce');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` SET TAGS ('dbx_subdomain' = 'employee_administration');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Work Location Identifier (LOC_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `job_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Job Classification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `labor_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Labor Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `manager_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Manager Employee Identifier (MGR_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `manager_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `manager_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Work Location Identifier (LOC_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Identifier (DEPT_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1 (ADDR_LINE1)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2 (ADDR_LINE2)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `address_line2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `benefits_enrollment_status` SET TAGS ('dbx_business_glossary_term' = 'Benefits Enrollment Status (BENEFITS_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `benefits_enrollment_status` SET TAGS ('dbx_value_regex' = 'enrolled|not_enrolled|pending');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status (CERT_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'certified|expired|pending|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City (CITY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `city` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `compliance_training_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Training Completion Date (COMP_TRAIN_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (COUNTRY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = 'USA|CAN|MEX|DEU|FRA|GBR');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `country_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURR)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|CAD|EUR|GBP|JPY|CNY');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Employee Date of Birth (DOB)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `disability_accommodation_flag` SET TAGS ('dbx_business_glossary_term' = 'Disability Accommodation Flag (DISABILITY_ACC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `disability_accommodation_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `disability_accommodation_flag` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `eeo_category` SET TAGS ('dbx_business_glossary_term' = 'EEO Category (EEO_CAT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Employee Email Address (EMAIL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Name (EMERG_NAME)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone (EMERG_PHONE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `employment_status` SET TAGS ('dbx_business_glossary_term' = 'Employment Status (EMP_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `employment_status` SET TAGS ('dbx_value_regex' = 'active|inactive|terminated|on_leave|retired|contract');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type (EMP_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'full_time|part_time|contract|temporary|intern|consultant');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Employee First Name (FIRST_NAME)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Employee Full Name (FULL_NAME)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Hire Date (HIRE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `iatf_competency_status` SET TAGS ('dbx_business_glossary_term' = 'IATF Competency Status (IATF_COMP)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `iatf_competency_status` SET TAGS ('dbx_value_regex' = 'competent|not_competent|pending|exempt');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `job_title` SET TAGS ('dbx_business_glossary_term' = 'Job Title (JOB_TITLE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Employee Last Name (LAST_NAME)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `last_performance_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Performance Review Date (PERF_REVIEW_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `national_id_number` SET TAGS ('dbx_business_glossary_term' = 'National Identifier (NATIONAL_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `national_id_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `national_id_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `overtime_eligible` SET TAGS ('dbx_business_glossary_term' = 'Overtime Eligibility Flag (OT_ELIGIBLE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `pay_grade` SET TAGS ('dbx_business_glossary_term' = 'Pay Grade (PAY_GRADE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating (PERF_RATING)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `performance_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Employee Phone Number (PHONE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code (POSTAL_CODE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `retirement_plan_code` SET TAGS ('dbx_business_glossary_term' = 'Retirement Plan Code (RET_PLAN)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `salary_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Salary Amount (SALARY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `salary_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `salary_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `state` SET TAGS ('dbx_business_glossary_term' = 'State/Province (STATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `state` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `tax_withholding_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Withholding Code (TAX_CODE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date (TERM_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `training_completion_flag` SET TAGS ('dbx_business_glossary_term' = 'Training Completion Flag (TRAINING_DONE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `union_member_flag` SET TAGS ('dbx_business_glossary_term' = 'Union Membership Flag (UNION_MEMBER)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `veteran_status` SET TAGS ('dbx_business_glossary_term' = 'Veteran Status (VET_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ALTER COLUMN `veteran_status` SET TAGS ('dbx_value_regex' = 'veteran|non_veteran|unknown');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` SET TAGS ('dbx_subdomain' = 'employee_administration');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Identifier (POSITION_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Identifier (DEPT_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Hiring Manager Identifier (HMGR_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `job_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Job Classification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Organization Identifier (ORG_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_role' = 'position_org_unit');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier (PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `primary_position_department_org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department Identifier (DEPT_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `primary_position_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Hiring Manager Identifier (HMGR_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `primary_position_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `primary_position_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `bonus_eligible` SET TAGS ('dbx_business_glossary_term' = 'Bonus Eligibility Flag (BONUS_ELIG)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `budget` SET TAGS ('dbx_business_glossary_term' = 'Position Budget (POS_BUDGET)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `budget` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_category` SET TAGS ('dbx_business_glossary_term' = 'Position Category (POS_CAT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_category` SET TAGS ('dbx_value_regex' = 'production|engineering|administration|sales|service|support');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_code` SET TAGS ('dbx_business_glossary_term' = 'Position Code (POS_CD)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `compensation_grade` SET TAGS ('dbx_business_glossary_term' = 'Compensation Grade (COMP_GRADE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `compensation_grade` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `compensation_grade` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `compliance_iatf_required` SET TAGS ('dbx_business_glossary_term' = 'IATF Compliance Required Flag (IATF_REQ)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `compliance_training_completed` SET TAGS ('dbx_business_glossary_term' = 'Compliance Training Completed Flag (COMP_TRAINED)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `criticality` SET TAGS ('dbx_business_glossary_term' = 'Position Criticality (CRIT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `criticality` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_description` SET TAGS ('dbx_business_glossary_term' = 'Position Description (POS_DESC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EFF_END)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (EFF_START)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `flsa_status` SET TAGS ('dbx_business_glossary_term' = 'FLSA Status (FLSA)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `flsa_status` SET TAGS ('dbx_value_regex' = 'exempt|non_exempt');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `is_filled` SET TAGS ('dbx_business_glossary_term' = 'Is Filled Flag (FILLED_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `job_family` SET TAGS ('dbx_business_glossary_term' = 'Job Family (JOB_FAMILY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `job_level` SET TAGS ('dbx_business_glossary_term' = 'Job Level (JOB_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `last_filled_date` SET TAGS ('dbx_business_glossary_term' = 'Last Filled Date (LAST_FILLED)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Position Location Code (POS_LOC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `overtime_eligible` SET TAGS ('dbx_business_glossary_term' = 'Overtime Eligibility Flag (OT_ELIG)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_status` SET TAGS ('dbx_business_glossary_term' = 'Position Status (POS_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_status` SET TAGS ('dbx_value_regex' = 'active|inactive|closed|vacant|pending');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_type` SET TAGS ('dbx_business_glossary_term' = 'Position Type (POS_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `position_type` SET TAGS ('dbx_value_regex' = 'permanent|temporary|contract|intern|consultant');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `remote_allowed` SET TAGS ('dbx_business_glossary_term' = 'Remote Work Allowed Flag (REMOTE_OK)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `required_certifications` SET TAGS ('dbx_business_glossary_term' = 'Required Certifications (REQ_CERT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `required_skills` SET TAGS ('dbx_business_glossary_term' = 'Required Skills (REQ_SKILLS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `responsibilities` SET TAGS ('dbx_business_glossary_term' = 'Position Responsibilities (POS_RESP)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Position Risk Level (RISK_LVL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `salary_range_max` SET TAGS ('dbx_business_glossary_term' = 'Salary Range Maximum (SAL_MAX)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `salary_range_max` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `salary_range_max` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `salary_range_min` SET TAGS ('dbx_business_glossary_term' = 'Salary Range Minimum (SAL_MIN)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `salary_range_min` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `salary_range_min` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `shift_eligibility` SET TAGS ('dbx_business_glossary_term' = 'Shift Eligibility (SHIFT_ELIG)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `shift_eligibility` SET TAGS ('dbx_value_regex' = 'day|swing|night|flex|off|on_call');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `status_reason` SET TAGS ('dbx_business_glossary_term' = 'Status Reason (STATUS_REASON)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `target_headcount` SET TAGS ('dbx_business_glossary_term' = 'Target Headcount (TARGET_HC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Position Title (TITLE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `travel_required` SET TAGS ('dbx_business_glossary_term' = 'Travel Required Flag (TRAVEL_REQ)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `union_classification_code` SET TAGS ('dbx_business_glossary_term' = 'Union Classification Code (UNION_CD)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By User (UPDATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `updated_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `vacancy_reason` SET TAGS ('dbx_business_glossary_term' = 'Vacancy Reason (VAC_REASON)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `vacancy_reason` SET TAGS ('dbx_value_regex' = 'retirement|resignation|termination|reorganization|new_role|budget_cut');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User (CREATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `created_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` SET TAGS ('dbx_subdomain' = 'employee_administration');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `labor_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Labor Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `parent_org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Organizational Unit Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|under_review');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_description` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `full_time_equivalent` SET TAGS ('dbx_business_glossary_term' = 'Full‑Time Equivalent (FTE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `headcount` SET TAGS ('dbx_business_glossary_term' = 'Headcount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `is_unionized` SET TAGS ('dbx_business_glossary_term' = 'Unionized Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_name` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_code` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_status` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_status` SET TAGS ('dbx_value_regex' = 'active|inactive|planned|closed');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_type` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_type` SET TAGS ('dbx_value_regex' = 'plant|department|division|business_unit|cost_center');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `region` SET TAGS ('dbx_value_regex' = 'NA|EU|APAC|LATAM|MEA');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'certified|pending|expired');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` SET TAGS ('dbx_subdomain' = 'employee_administration');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Job Classification Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `flsa_exempt_status` SET TAGS ('dbx_business_glossary_term' = 'FLSA Exempt Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `flsa_exempt_status` SET TAGS ('dbx_value_regex' = 'exempt|non_exempt');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `iatf_competency_required` SET TAGS ('dbx_business_glossary_term' = 'IATF Competency Requirement');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `iatf_competency_required` SET TAGS ('dbx_value_regex' = 'required|not_required');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `is_managerial` SET TAGS ('dbx_business_glossary_term' = 'Managerial Role Indicator');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_classification_status` SET TAGS ('dbx_business_glossary_term' = 'Job Classification Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_classification_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_code` SET TAGS ('dbx_business_glossary_term' = 'Job Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_description` SET TAGS ('dbx_business_glossary_term' = 'Job Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_family` SET TAGS ('dbx_business_glossary_term' = 'Job Family');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_family` SET TAGS ('dbx_value_regex' = 'production|engineering|quality|logistics|administration|management');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_level_band` SET TAGS ('dbx_business_glossary_term' = 'Job Level Band');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_level_band` SET TAGS ('dbx_value_regex' = 'L1|L2|L3|L4|L5');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `job_title` SET TAGS ('dbx_business_glossary_term' = 'Job Title');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `pay_grade_max` SET TAGS ('dbx_business_glossary_term' = 'Maximum Pay Grade');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `pay_grade_max` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `pay_grade_min` SET TAGS ('dbx_business_glossary_term' = 'Minimum Pay Grade');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `pay_grade_min` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `requires_certification` SET TAGS ('dbx_business_glossary_term' = 'Certification Requirement');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `requires_certification` SET TAGS ('dbx_value_regex' = 'yes|no');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `union_trade_classification` SET TAGS ('dbx_business_glossary_term' = 'Union Trade Classification');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `union_trade_classification` SET TAGS ('dbx_value_regex' = 'craft|maintenance|administrative|management|other');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_classification` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` SET TAGS ('dbx_subdomain' = 'employee_administration');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `employment_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Employment Contract ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Manager ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `primary_employment_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `primary_employment_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `primary_employment_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `amendment_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Amendment Effective Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `amendment_number` SET TAGS ('dbx_business_glossary_term' = 'Amendment Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `amendment_reason` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `benefits_description` SET TAGS ('dbx_business_glossary_term' = 'Benefits Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `benefits_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `collective_bargaining_agreement` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `compensation_type` SET TAGS ('dbx_business_glossary_term' = 'Compensation Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `compensation_type` SET TAGS ('dbx_value_regex' = 'base|base_plus_bonus|commission|hourly');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `compensation_type` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `compensation_type` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `compliance_training_completed` SET TAGS ('dbx_business_glossary_term' = 'Compliance Training Completed');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `confidentiality_clause` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Clause');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `contract_status_reason` SET TAGS ('dbx_business_glossary_term' = 'Contract Status Reason');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'permanent|fixed_term|apprenticeship|ckd_expatriate');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `contract_version` SET TAGS ('dbx_business_glossary_term' = 'Contract Version');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `data_protection_clause` SET TAGS ('dbx_business_glossary_term' = 'Data Protection Clause');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `employment_contract_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `employment_contract_status` SET TAGS ('dbx_value_regex' = 'active|inactive|terminated|pending|draft');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `is_apprenticeship` SET TAGS ('dbx_business_glossary_term' = 'Is Apprenticeship');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `is_expatriate` SET TAGS ('dbx_business_glossary_term' = 'Is Expatriate');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `is_fixed_term` SET TAGS ('dbx_business_glossary_term' = 'Is Fixed‑Term');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `is_permanent` SET TAGS ('dbx_business_glossary_term' = 'Is Permanent');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `non_compete_clause` SET TAGS ('dbx_business_glossary_term' = 'Non‑Compete Clause');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Notice Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `probation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Probation End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `probation_period_days` SET TAGS ('dbx_business_glossary_term' = 'Probation Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_amount` SET TAGS ('dbx_business_glossary_term' = 'Salary Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_currency` SET TAGS ('dbx_business_glossary_term' = 'Salary Currency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_currency` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_currency` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_frequency` SET TAGS ('dbx_business_glossary_term' = 'Salary Frequency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_frequency` SET TAGS ('dbx_value_regex' = 'monthly|biweekly|weekly|annual');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_frequency` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `salary_frequency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `union_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Union Agreement Reference');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `weekly_hours` SET TAGS ('dbx_business_glossary_term' = 'Weekly Contracted Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `work_location` SET TAGS ('dbx_business_glossary_term' = 'Work Location');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `work_location` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `work_location` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `work_shift` SET TAGS ('dbx_business_glossary_term' = 'Work Shift');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employment_contract` ALTER COLUMN `work_shift` SET TAGS ('dbx_value_regex' = 'day|night|flex');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` SET TAGS ('dbx_subdomain' = 'employee_administration');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Schedule ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `break_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Break Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `break_included` SET TAGS ('dbx_business_glossary_term' = 'Break Included Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `certification_required` SET TAGS ('dbx_business_glossary_term' = 'Required Certification');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Schedule Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `overtime_eligible` SET TAGS ('dbx_business_glossary_term' = 'Overtime Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `overtime_rate_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Overtime Rate Multiplier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Schedule Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_value_regex' = '^SCH-d{6}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_name` SET TAGS ('dbx_business_glossary_term' = 'Schedule Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_source_system` SET TAGS ('dbx_business_glossary_term' = 'Schedule Source System');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_source_system` SET TAGS ('dbx_value_regex' = 'SuccessFactors|SAP|Custom');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_version` SET TAGS ('dbx_business_glossary_term' = 'Schedule Version');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `scheduled_hours` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_currency` SET TAGS ('dbx_business_glossary_term' = 'Shift Currency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|CAD|GBP|JPY|CHF');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_end_time` SET TAGS ('dbx_business_glossary_term' = 'Shift End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern (Day/Afternoon/Night/Rotating)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_value_regex' = 'day|afternoon|night|rotating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_pay_rate` SET TAGS ('dbx_business_glossary_term' = 'Shift Pay Rate');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_start_time` SET TAGS ('dbx_business_glossary_term' = 'Shift Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_status` SET TAGS ('dbx_business_glossary_term' = 'Shift Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_status` SET TAGS ('dbx_value_regex' = 'planned|active|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_type` SET TAGS ('dbx_business_glossary_term' = 'Shift Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_type` SET TAGS ('dbx_value_regex' = 'regular|overtime|holiday');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `skill_required` SET TAGS ('dbx_business_glossary_term' = 'Required Skill');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `union_flag` SET TAGS ('dbx_business_glossary_term' = 'Union Labor Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `time_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Time Entry ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `pay_period_id` SET TAGS ('dbx_business_glossary_term' = 'Pay Period ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `absence_type` SET TAGS ('dbx_business_glossary_term' = 'Absence Type (VACATION, SICK, PERSONAL, UNPAID, OTHER)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `absence_type` SET TAGS ('dbx_value_regex' = 'vacation|sick|personal|unpaid|other');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status (PENDING, APPROVED, REJECTED)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `clock_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Clock-In Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `clock_out_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Clock-Out Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Flag (IATF Competency Met)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `entry_status` SET TAGS ('dbx_business_glossary_term' = 'Entry Status (ACTIVE, VOID, DELETED)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `entry_status` SET TAGS ('dbx_value_regex' = 'active|void|deleted');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `is_overtime_approved` SET TAGS ('dbx_business_glossary_term' = 'Overtime Approved Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `is_shift_differential` SET TAGS ('dbx_business_glossary_term' = 'Shift Differential Applied Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `job_role` SET TAGS ('dbx_business_glossary_term' = 'Job Role');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `labor_category` SET TAGS ('dbx_business_glossary_term' = 'Labor Category (PRODUCTION, MAINTENANCE, ADMIN, ENGINEERING, SALES, SUPPORT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `labor_category` SET TAGS ('dbx_value_regex' = 'production|maintenance|admin|engineering|sales|support');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `labor_grade` SET TAGS ('dbx_business_glossary_term' = 'Labor Grade');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `labor_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate Amount (Currency per Hour)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes or Comments');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `overtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Overtime Hours Worked');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `overtime_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Overtime Multiplier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `project_code` SET TAGS ('dbx_business_glossary_term' = 'Project Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `record_version` SET TAGS ('dbx_business_glossary_term' = 'Record Version Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `regular_hours` SET TAGS ('dbx_business_glossary_term' = 'Regular Hours Worked');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status (VALID, EXPIRED, NONE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'valid|expired|none');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `shift_code` SET TAGS ('dbx_business_glossary_term' = 'Shift Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `shift_differential_hours` SET TAGS ('dbx_business_glossary_term' = 'Shift Differential Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `source` SET TAGS ('dbx_business_glossary_term' = 'Time Entry Source (SELF_SERVICE, MANAGER, HR)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `source` SET TAGS ('dbx_value_regex' = 'self_service|manager|hr');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `time_entry_type` SET TAGS ('dbx_business_glossary_term' = 'Time Entry Type (CLOCK, MANUAL, ADJUSTMENT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `time_entry_type` SET TAGS ('dbx_value_regex' = 'clock|manual|adjustment');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `training_completed` SET TAGS ('dbx_business_glossary_term' = 'Training Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `union_code` SET TAGS ('dbx_business_glossary_term' = 'Union Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ALTER COLUMN `work_date` SET TAGS ('dbx_business_glossary_term' = 'Work Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `absence_record_id` SET TAGS ('dbx_business_glossary_term' = 'Absence Record ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `approver_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `approver_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `approver_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `primary_absence_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `primary_absence_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `primary_absence_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `absence_category` SET TAGS ('dbx_business_glossary_term' = 'Absence Pay Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `absence_category` SET TAGS ('dbx_value_regex' = 'paid|unpaid');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `absence_number` SET TAGS ('dbx_business_glossary_term' = 'Absence Record Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `absence_record_status` SET TAGS ('dbx_business_glossary_term' = 'Absence Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `absence_record_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|cancelled');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `absence_type` SET TAGS ('dbx_business_glossary_term' = 'Absence Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Absence Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `duration_days` SET TAGS ('dbx_business_glossary_term' = 'Absence Duration (Days)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Absence Duration (Hours)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Absence End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `medical_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `medical_certificate_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `medical_certificate_number` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `medical_certification_flag` SET TAGS ('dbx_business_glossary_term' = 'Medical Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `medical_certification_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `medical_certification_flag` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Absence Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Absence Reason Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `request_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Absence Request Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `return_to_work_date` SET TAGS ('dbx_business_glossary_term' = 'Return‑to‑Work Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `shift_coverage_required` SET TAGS ('dbx_business_glossary_term' = 'Shift Coverage Required');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `shift_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Shift Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Absence Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `union_leave_flag` SET TAGS ('dbx_business_glossary_term' = 'Union Leave Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`absence_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payroll_result_id` SET TAGS ('dbx_business_glossary_term' = 'Payroll Result ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID (EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `bank_routing_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Routing Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `bank_routing_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `bank_routing_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `base_salary` SET TAGS ('dbx_business_glossary_term' = 'Base Salary Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `base_salary` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `base_salary` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `benefit_deduction` SET TAGS ('dbx_business_glossary_term' = 'Benefit Deduction Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `bonus_amount` SET TAGS ('dbx_business_glossary_term' = 'Bonus Pay Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|GBP|CAD|JPY');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_ssn` SET TAGS ('dbx_business_glossary_term' = 'Employee Social Security Number (SSN)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_ssn` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_ssn` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_type` SET TAGS ('dbx_business_glossary_term' = 'Employee Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employee_type` SET TAGS ('dbx_value_regex' = 'regular|contract|temp|intern');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `employer_contribution` SET TAGS ('dbx_business_glossary_term' = 'Employer Contribution Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `garnishment_amount` SET TAGS ('dbx_business_glossary_term' = 'Garnishment Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `gross_pay` SET TAGS ('dbx_business_glossary_term' = 'Gross Pay Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `gross_pay` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `gross_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `is_garnishment` SET TAGS ('dbx_business_glossary_term' = 'Garnishment Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `is_union_member` SET TAGS ('dbx_business_glossary_term' = 'Union Membership Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `job_code` SET TAGS ('dbx_business_glossary_term' = 'Job Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `net_pay` SET TAGS ('dbx_business_glossary_term' = 'Net Pay Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `net_pay` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `net_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `overtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Overtime Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `overtime_pay` SET TAGS ('dbx_business_glossary_term' = 'Overtime Pay Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `pay_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Pay Period End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `pay_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Pay Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `pay_rate` SET TAGS ('dbx_business_glossary_term' = 'Pay Rate Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `pay_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Pay Rate Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `pay_rate_type` SET TAGS ('dbx_value_regex' = 'hourly|salary|commission');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'direct_deposit|check|cash');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payroll_group` SET TAGS ('dbx_business_glossary_term' = 'Payroll Group');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payroll_group` SET TAGS ('dbx_value_regex' = 'weekly|biweekly|monthly');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payroll_number` SET TAGS ('dbx_business_glossary_term' = 'Payroll Number (PAYROLL_NO)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payroll_result_status` SET TAGS ('dbx_business_glossary_term' = 'Payroll Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payroll_result_status` SET TAGS ('dbx_value_regex' = 'pending|processed|error|void');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `payroll_run_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `shift_differential` SET TAGS ('dbx_business_glossary_term' = 'Shift Differential Pay Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `shift_hours` SET TAGS ('dbx_business_glossary_term' = 'Shift Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `tax_deduction` SET TAGS ('dbx_business_glossary_term' = 'Tax Deduction Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `tax_withholding_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Withholding Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `tax_year` SET TAGS ('dbx_business_glossary_term' = 'Tax Year');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `union_dues` SET TAGS ('dbx_business_glossary_term' = 'Union Dues Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`payroll_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_plan_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_plan_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `job_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Job Classification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `primary_compensation_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `primary_compensation_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `primary_compensation_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `base_salary_max` SET TAGS ('dbx_business_glossary_term' = 'Base Salary Maximum');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `base_salary_max` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `base_salary_max` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `base_salary_min` SET TAGS ('dbx_business_glossary_term' = 'Base Salary Minimum');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `base_salary_min` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `base_salary_min` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `bonus_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Bonus Multiplier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `bonus_plan_type` SET TAGS ('dbx_business_glossary_term' = 'Bonus Plan Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `bonus_plan_type` SET TAGS ('dbx_value_regex' = 'annual|quarterly|monthly|none');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `bonus_target_amount` SET TAGS ('dbx_business_glossary_term' = 'Bonus Target Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `classification` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan Classification');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `classification` SET TAGS ('dbx_value_regex' = 'salary|incentive|benefit|allowance');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_plan_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|suspended');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_plan_status` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compensation_plan_status` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `compliance_notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Criteria');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `eligibility_end_date` SET TAGS ('dbx_business_glossary_term' = 'Eligibility End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `eligibility_start_date` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `legal_entity_code` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `merit_increase_percent` SET TAGS ('dbx_business_glossary_term' = 'Merit Increase Percentage');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `overtime_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Overtime Multiplier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `pay_equity_analysis_flag` SET TAGS ('dbx_business_glossary_term' = 'Pay Equity Analysis Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `pay_grade` SET TAGS ('dbx_business_glossary_term' = 'Pay Grade');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `payroll_frequency` SET TAGS ('dbx_business_glossary_term' = 'Payroll Frequency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `payroll_frequency` SET TAGS ('dbx_value_regex' = 'monthly|biweekly|weekly|quarterly');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'base_salary|bonus|commission|equity|shift_differential');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `review_cycle` SET TAGS ('dbx_business_glossary_term' = 'Compensation Review Cycle');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `shift_differential_rate` SET TAGS ('dbx_business_glossary_term' = 'Shift Differential Rate');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `tax_withholding_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Withholding Rate');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `union_cba_compliant` SET TAGS ('dbx_business_glossary_term' = 'Union CBA Compliant Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`compensation_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Compensation Plan Version Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `benefit_enrollment_id` SET TAGS ('dbx_business_glossary_term' = 'Benefit Enrollment ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `benefit_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Benefit Plan Identifier (PLAN_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Identifier (EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `auto_enroll_eligibility_date` SET TAGS ('dbx_business_glossary_term' = 'Auto‑Enrollment Eligibility Date (AUTO_ENROLL_ELIG_DT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `benefit_category` SET TAGS ('dbx_business_glossary_term' = 'Benefit Category (BENEFIT_CAT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `benefit_category` SET TAGS ('dbx_value_regex' = 'health|dental|vision|life|disability|retirement');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `coverage_end_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage End Date (COV_END_DT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `coverage_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Coverage Limit Amount (COV_LIMIT_AMT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `coverage_limit_units` SET TAGS ('dbx_business_glossary_term' = 'Coverage Limit Units (COV_LIMIT_UNITS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `coverage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage Start Date (COV_START_DT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `coverage_type` SET TAGS ('dbx_business_glossary_term' = 'Coverage Type (COV_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `coverage_type` SET TAGS ('dbx_value_regex' = 'individual|family|employee_spouse');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURR_CODE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_birth_date` SET TAGS ('dbx_business_glossary_term' = 'Dependent Birth Date (DEP_BIRTH_DT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_birth_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_birth_date` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_coverage_flag` SET TAGS ('dbx_business_glossary_term' = 'Dependent Coverage Flag (DEP_COV_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_name` SET TAGS ('dbx_business_glossary_term' = 'Dependent Full Name (DEP_NAME)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_relationship` SET TAGS ('dbx_business_glossary_term' = 'Dependent Relationship (DEP_REL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `dependent_relationship` SET TAGS ('dbx_value_regex' = 'spouse|child|parent|other');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date (EFF_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Criteria (ELIG_CRIT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `eligibility_date` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Date (ELIG_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `employee_contribution_amount` SET TAGS ('dbx_business_glossary_term' = 'Employee Contribution Amount (EMP_CONTR_AMT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `employer_contribution_amount` SET TAGS ('dbx_business_glossary_term' = 'Employer Contribution Amount (EMPLOYER_CONTR_AMT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_date` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Date (ENROLL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_number` SET TAGS ('dbx_business_glossary_term' = 'Benefit Enrollment Number (ENROLL_NUM)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_source` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Source (ENROLL_SRC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_source` SET TAGS ('dbx_value_regex' = 'HR portal|admin|self-service');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_status` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Status (ENROLL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_status` SET TAGS ('dbx_value_regex' = 'active|pending|terminated|cancelled');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `is_auto_enrolled` SET TAGS ('dbx_business_glossary_term' = 'Auto‑Enrollment Flag (AUTO_ENROLL_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `is_waived` SET TAGS ('dbx_business_glossary_term' = 'Waiver Flag (WAIVER_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `payroll_cycle` SET TAGS ('dbx_business_glossary_term' = 'Payroll Cycle (PAY_CYCLE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `payroll_cycle` SET TAGS ('dbx_value_regex' = 'monthly|biweekly|weekly');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `payroll_deduction_code` SET TAGS ('dbx_business_glossary_term' = 'Payroll Deduction Code (PAY_DD_CODE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_annual_maximum` SET TAGS ('dbx_business_glossary_term' = 'Plan Annual Maximum (PLAN_ANNUAL_MAX)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_change_allowed` SET TAGS ('dbx_business_glossary_term' = 'Plan Change Allowed Flag (PLAN_CHANGE_ALLOWED)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_change_deadline` SET TAGS ('dbx_business_glossary_term' = 'Plan Change Deadline (PLAN_CHANGE_DEADLINE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_cost_share_amount` SET TAGS ('dbx_business_glossary_term' = 'Plan Cost‑Share Amount (COST_SHARE_AMT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_cost_share_percent` SET TAGS ('dbx_business_glossary_term' = 'Plan Cost‑Share Percent (COST_SHARE_PCT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_enrollment_window_end` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Window End Date (ENROLL_WIN_END)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_enrollment_window_start` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Window Start Date (ENROLL_WIN_START)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_group_number` SET TAGS ('dbx_business_glossary_term' = 'Plan Group Number (PLAN_GROUP_NO)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Renewal Date (PLAN_RENEWAL_DT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_renewal_status` SET TAGS ('dbx_business_glossary_term' = 'Plan Renewal Status (PLAN_RENEWAL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_renewal_status` SET TAGS ('dbx_value_regex' = 'renewed|pending|expired');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Plan Type (PLAN_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'pre-tax|post-tax');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_vendor` SET TAGS ('dbx_business_glossary_term' = 'Plan Vendor (PLAN_VENDOR)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_wait_period_days` SET TAGS ('dbx_business_glossary_term' = 'Plan Wait Period (PLAN_WAIT_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date (TERM_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `total_premium_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Premium Amount (TOTAL_PREM_AMT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_business_glossary_term' = 'Waiver Reason (WAIVER_REASON)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `talent_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Talent Requisition ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Hiring Manager ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `talent_approved_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `talent_approved_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `talent_approved_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `talent_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Hiring Manager ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `talent_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `talent_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `tertiary_talent_filled_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Filled By Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `tertiary_talent_filled_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `tertiary_talent_filled_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `budgeted_salary` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Salary');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `budgeted_salary` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `budgeted_salary` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `closing_date` SET TAGS ('dbx_business_glossary_term' = 'Closing Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `compensation_grade` SET TAGS ('dbx_business_glossary_term' = 'Compensation Grade');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `compensation_grade` SET TAGS ('dbx_value_regex' = 'grade1|grade2|grade3|grade4|grade5');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `compensation_grade` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `compensation_grade` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `competency_requirements` SET TAGS ('dbx_business_glossary_term' = 'Competency Requirements');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `compliance_iatf_required` SET TAGS ('dbx_business_glossary_term' = 'IATF Compliance Required');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `filled_date` SET TAGS ('dbx_business_glossary_term' = 'Filled Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `headcount_quantity` SET TAGS ('dbx_business_glossary_term' = 'Headcount Quantity');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `headcount_type` SET TAGS ('dbx_business_glossary_term' = 'Headcount Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `headcount_type` SET TAGS ('dbx_value_regex' = 'new|replacement');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `interview_stage` SET TAGS ('dbx_business_glossary_term' = 'Interview Stage');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `interview_stage` SET TAGS ('dbx_value_regex' = 'phone|onsite|virtual|final|offer|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `is_internal_requisition` SET TAGS ('dbx_business_glossary_term' = 'Is Internal Requisition');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `job_code` SET TAGS ('dbx_business_glossary_term' = 'Job Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `language_requirements` SET TAGS ('dbx_business_glossary_term' = 'Language Requirements');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Requisition Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `position_title` SET TAGS ('dbx_business_glossary_term' = 'Position Title');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Requisition Priority');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `recruitment_budget` SET TAGS ('dbx_business_glossary_term' = 'Recruitment Budget');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `recruitment_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `recruitment_budget` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `relocation_assistance` SET TAGS ('dbx_business_glossary_term' = 'Relocation Assistance');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `remote_option` SET TAGS ('dbx_business_glossary_term' = 'Remote Work Option');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `required_certifications` SET TAGS ('dbx_business_glossary_term' = 'Required Certifications');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `required_education_level` SET TAGS ('dbx_business_glossary_term' = 'Required Education Level');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `required_education_level` SET TAGS ('dbx_value_regex' = 'high_school|associate|bachelor|master|doctorate');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `required_experience_years` SET TAGS ('dbx_business_glossary_term' = 'Required Experience (Years)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `required_skills` SET TAGS ('dbx_business_glossary_term' = 'Required Skills');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Requisition Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `requisition_status` SET TAGS ('dbx_business_glossary_term' = 'Requisition Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `requisition_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|filled|cancelled');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `salary_range_max` SET TAGS ('dbx_business_glossary_term' = 'Salary Range Maximum');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `salary_range_max` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `salary_range_max` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `salary_range_min` SET TAGS ('dbx_business_glossary_term' = 'Salary Range Minimum');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `salary_range_min` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `salary_range_min` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `sourcing_channel` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Channel');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `sourcing_channel` SET TAGS ('dbx_value_regex' = 'internal|external|referral|agency|social_media|employee_referral');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `target_start_date` SET TAGS ('dbx_business_glossary_term' = 'Target Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `travel_requirement` SET TAGS ('dbx_business_glossary_term' = 'Travel Requirement');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`talent_requisition` ALTER COLUMN `travel_requirement` SET TAGS ('dbx_value_regex' = 'none|occasional|frequent|required');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `job_application_id` SET TAGS ('dbx_business_glossary_term' = 'Job Application ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Hiring Manager ID (HM_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position ID (POS_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `primary_job_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Hiring Manager ID (HM_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `primary_job_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `primary_job_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `talent_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Talent Requisition ID (REQ_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `applicant_name` SET TAGS ('dbx_business_glossary_term' = 'Applicant Full Name (NAME)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `applicant_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `applicant_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `application_date` SET TAGS ('dbx_business_glossary_term' = 'Application Date (APP_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `assessment_score` SET TAGS ('dbx_business_glossary_term' = 'Pre-Employment Assessment Score (ASSESS_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `background_check_completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Background Check Completion Timestamp (BG_COMPLETE_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `background_check_status` SET TAGS ('dbx_business_glossary_term' = 'Background Check Status (BG_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `background_check_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|failed|exempt');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `candidate_external_code` SET TAGS ('dbx_business_glossary_term' = 'External Candidate Identifier (EXT_CAND_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `candidate_status` SET TAGS ('dbx_business_glossary_term' = 'Candidate Status (CAND_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `candidate_status` SET TAGS ('dbx_value_regex' = 'active|inactive|on_hold|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `current_stage` SET TAGS ('dbx_business_glossary_term' = 'Application Current Stage (STAGE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `current_stage` SET TAGS ('dbx_value_regex' = 'screening|interview|offer|hired|rejected|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `disability_accommodation_needed` SET TAGS ('dbx_business_glossary_term' = 'Disability Accommodation Needed (DISAB_ACCOM)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `disability_accommodation_needed` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `disability_accommodation_needed` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `disposition_reason` SET TAGS ('dbx_business_glossary_term' = 'Application Disposition Reason (DISP_REASON)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `education_level` SET TAGS ('dbx_business_glossary_term' = 'Education Level (EDU_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `education_level` SET TAGS ('dbx_value_regex' = 'high_school|associate|bachelor|master|doctorate|other');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Applicant Email Address (EMAIL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type (EMP_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'full_time|part_time|contract|temporary|internship');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `interview_score` SET TAGS ('dbx_business_glossary_term' = 'Interview Score (INT_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `last_stage_change_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Stage Change Timestamp (STAGE_CHANGE_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `last_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Last Updated By (UPDATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Application Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `offer_acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Offer Acceptance Date (OFFER_ACCEPT_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `offer_currency` SET TAGS ('dbx_business_glossary_term' = 'Offer Currency (CURR)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `offer_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|GBP|JPY|CAD|AUD');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `offer_extended` SET TAGS ('dbx_business_glossary_term' = 'Offer Extended Flag (OFFER_EXT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `offer_salary` SET TAGS ('dbx_business_glossary_term' = 'Offered Salary Amount (OFFER_SAL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `offer_salary` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `offer_salary` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `onboarding_start_date` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Start Date (ONBOARD_START)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Applicant Phone Number (PHONE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `resume_reference` SET TAGS ('dbx_business_glossary_term' = 'Resume Document ID (RES_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `salary_expectation` SET TAGS ('dbx_business_glossary_term' = 'Salary Expectation (SAL_EXP)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `salary_expectation` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `salary_expectation` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `source_channel` SET TAGS ('dbx_business_glossary_term' = 'Application Source Channel (SRC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `source_channel` SET TAGS ('dbx_value_regex' = 'internal|external|referral|campus|recruiter');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `visa_status` SET TAGS ('dbx_business_glossary_term' = 'Visa Status (VISA_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `visa_status` SET TAGS ('dbx_value_regex' = 'citizen|permanent_resident|work_visa|student_visa|none');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`job_application` ALTER COLUMN `years_of_experience` SET TAGS ('dbx_business_glossary_term' = 'Years of Professional Experience (EXP_YRS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `performance_review_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Review ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewer ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `primary_performance_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `primary_performance_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `primary_performance_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewer ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Review Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `calibration_group` SET TAGS ('dbx_business_glossary_term' = 'Calibration Group');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `calibration_score` SET TAGS ('dbx_business_glossary_term' = 'Calibration Score');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `calibration_status` SET TAGS ('dbx_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `calibration_status` SET TAGS ('dbx_value_regex' = 'pending|completed|approved');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `communication_rating` SET TAGS ('dbx_business_glossary_term' = 'Communication Rating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `competency_summary` SET TAGS ('dbx_business_glossary_term' = 'Competency Summary');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_comments` SET TAGS ('dbx_business_glossary_term' = 'Employee Comments');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `final_approved_rating` SET TAGS ('dbx_business_glossary_term' = 'Final Approved Rating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `goal_achievement_score` SET TAGS ('dbx_business_glossary_term' = 'Goal Achievement Score');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `innovation_rating` SET TAGS ('dbx_business_glossary_term' = 'Innovation Rating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `leadership_rating` SET TAGS ('dbx_business_glossary_term' = 'Leadership Rating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `manager_comments` SET TAGS ('dbx_business_glossary_term' = 'Manager Comments');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `merit_increase_percent` SET TAGS ('dbx_business_glossary_term' = 'Merit Increase Percent');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `overall_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Rating (Overall Rating)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `promotion_recommendation` SET TAGS ('dbx_business_glossary_term' = 'Promotion Recommendation');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `promotion_recommendation` SET TAGS ('dbx_value_regex' = 'yes|no|maybe');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_cycle` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_cycle` SET TAGS ('dbx_value_regex' = 'annual|mid_year|quarterly');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Review Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_end_date` SET TAGS ('dbx_business_glossary_term' = 'Review End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_location` SET TAGS ('dbx_business_glossary_term' = 'Review Location');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_number` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_period_quarter` SET TAGS ('dbx_business_glossary_term' = 'Review Period Quarter');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_period_quarter` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_period_year` SET TAGS ('dbx_business_glossary_term' = 'Review Period Year');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_start_date` SET TAGS ('dbx_business_glossary_term' = 'Review Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_status` SET TAGS ('dbx_business_glossary_term' = 'Review Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_status` SET TAGS ('dbx_value_regex' = 'draft|in_progress|completed|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_type` SET TAGS ('dbx_business_glossary_term' = 'Review Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `review_type` SET TAGS ('dbx_value_regex' = 'self|manager|360');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Reviewer Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `teamwork_rating` SET TAGS ('dbx_business_glossary_term' = 'Teamwork Rating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `technical_rating` SET TAGS ('dbx_business_glossary_term' = 'Technical Rating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`performance_review` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_record_id` SET TAGS ('dbx_business_glossary_term' = 'Training Record ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_course_id` SET TAGS ('dbx_business_glossary_term' = 'Course ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Trainer ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `business_identifier` SET TAGS ('dbx_business_glossary_term' = 'Business Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `certification_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Issue Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `certification_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `certification_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `competency_category` SET TAGS ('dbx_business_glossary_term' = 'Competency Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `competency_code` SET TAGS ('dbx_business_glossary_term' = 'Competency Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending|exempt');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `course_type` SET TAGS ('dbx_business_glossary_term' = 'Course Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `course_type` SET TAGS ('dbx_value_regex' = 'iatf_competency|safety_certification|ev_adas_technical|leadership|compliance|other');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `credit_hours` SET TAGS ('dbx_business_glossary_term' = 'Credit Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Delivery Method');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'classroom|e_learning|on_the_job|virtual|blended');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `enrollment_date` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `iatf_competency_flag` SET TAGS ('dbx_business_glossary_term' = 'IATF Competency Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `max_score` SET TAGS ('dbx_business_glossary_term' = 'Maximum Score');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_business_glossary_term' = 'Pass/Fail Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_value_regex' = 'pass|fail|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `quantitative_result` SET TAGS ('dbx_business_glossary_term' = 'Quantitative Result');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `recertification_due_date` SET TAGS ('dbx_business_glossary_term' = 'Recertification Due Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `recertification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Recertification Required Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `safety_certification_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `score` SET TAGS ('dbx_business_glossary_term' = 'Score');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `trainer_name` SET TAGS ('dbx_business_glossary_term' = 'Trainer Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Training Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_hours` SET TAGS ('dbx_business_glossary_term' = 'Training Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_location` SET TAGS ('dbx_business_glossary_term' = 'Training Location');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_provider` SET TAGS ('dbx_business_glossary_term' = 'Training Provider');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_record_status` SET TAGS ('dbx_business_glossary_term' = 'Training Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_record` ALTER COLUMN `training_record_status` SET TAGS ('dbx_value_regex' = 'enrolled|in_progress|completed|failed|cancelled|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_id` SET TAGS ('dbx_business_glossary_term' = 'Competency ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `applicable_job_family` SET TAGS ('dbx_business_glossary_term' = 'Applicable Job Family (Competency)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_category` SET TAGS ('dbx_business_glossary_term' = 'Competency Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_code` SET TAGS ('dbx_business_glossary_term' = 'Competency Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_status` SET TAGS ('dbx_business_glossary_term' = 'Competency Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|pending');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_type` SET TAGS ('dbx_business_glossary_term' = 'Competency Type (Technical/Behavioral/Leadership/Safety/IATF‑Required)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_type` SET TAGS ('dbx_value_regex' = 'technical|behavioral|leadership|safety|iatf_required');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_description` SET TAGS ('dbx_business_glossary_term' = 'Competency Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date (Competency)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date (Competency)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `iatf_required_flag` SET TAGS ('dbx_business_glossary_term' = 'IATF Required Flag (Competency)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `is_core_competency` SET TAGS ('dbx_business_glossary_term' = 'Core Competency Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date (Competency)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `competency_name` SET TAGS ('dbx_business_glossary_term' = 'Competency Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `owner` SET TAGS ('dbx_business_glossary_term' = 'Competency Owner');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `proficiency_levels` SET TAGS ('dbx_business_glossary_term' = 'Proficiency Levels (Competency)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `proficiency_levels` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|level_4|level_5');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number (Competency)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`competency` ALTER COLUMN `weight` SET TAGS ('dbx_business_glossary_term' = 'Competency Weight (Score)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skills_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Skills Inventory Record ID (SKI_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `competency_id` SET TAGS ('dbx_business_glossary_term' = 'Competency Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Identifier (EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skills_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assessor Identifier (ASSESSOR_ID)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skills_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skills_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date (ASSESS_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date (CERT_EXPIRY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status (CERT_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'certified|not_certified|pending|expired');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `iatf_competency_required` SET TAGS ('dbx_business_glossary_term' = 'IATF Competency Required (IATF_COMP_REQ)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `is_core_skill` SET TAGS ('dbx_business_glossary_term' = 'Core Skill Indicator (CORE_SKILL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `is_critical_skill` SET TAGS ('dbx_business_glossary_term' = 'Critical Skill Indicator (CRITICAL_SKILL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `last_assessed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Assessed Timestamp (LAST_ASSESS_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `last_training_date` SET TAGS ('dbx_business_glossary_term' = 'Last Training Date (LAST_TRAIN_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `proficiency_level` SET TAGS ('dbx_business_glossary_term' = 'Proficiency Level (PROF_LVL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `proficiency_level` SET TAGS ('dbx_value_regex' = 'novice|intermediate|advanced|expert|master');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `proficiency_score` SET TAGS ('dbx_business_glossary_term' = 'Proficiency Score (PROF_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp (REC_CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp (REC_UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_assessment_method` SET TAGS ('dbx_business_glossary_term' = 'Skill Assessment Method (ASSESS_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_assessment_method` SET TAGS ('dbx_value_regex' = 'test|practical|simulation|observation');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_certification_body` SET TAGS ('dbx_business_glossary_term' = 'Skill Certification Body (CERT_BODY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_certification_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Skill Certification Issue Date (CERT_ISSUE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Skill Certification Number (CERT_NUM)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_description` SET TAGS ('dbx_business_glossary_term' = 'Skill Description (SKILL_DESC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_last_reviewed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Skill Last Reviewed Timestamp (LAST_REVIEW_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_last_used_date` SET TAGS ('dbx_business_glossary_term' = 'Skill Last Used Date (LAST_USED_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_last_used_location` SET TAGS ('dbx_business_glossary_term' = 'Skill Last Used Location (LAST_USED_LOC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_notes` SET TAGS ('dbx_business_glossary_term' = 'Skill Notes (SKILL_NOTES)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_owner_department` SET TAGS ('dbx_business_glossary_term' = 'Skill Owner Department (OWNER_DEPT)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_review_cycle_months` SET TAGS ('dbx_business_glossary_term' = 'Skill Review Cycle (REVIEW_CYCLE_MTH)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_source` SET TAGS ('dbx_business_glossary_term' = 'Skill Source (SKILL_SRC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_source` SET TAGS ('dbx_value_regex' = 'self_assessment|manager_assessment|external_certification');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_status` SET TAGS ('dbx_business_glossary_term' = 'Skill Status (SKILL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_training_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Skill Training Completion Date (TRAIN_COMP_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_training_completion_status` SET TAGS ('dbx_business_glossary_term' = 'Skill Training Completion Status (TRAIN_COMP_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_training_completion_status` SET TAGS ('dbx_value_regex' = 'completed|in_progress|not_started');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_training_program_code` SET TAGS ('dbx_business_glossary_term' = 'Skill Training Program Code (TRAIN_PROG_CODE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_training_provider` SET TAGS ('dbx_business_glossary_term' = 'Skill Training Provider (TRAIN_PROVIDER)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Skill Validity End Date (VALID_TO)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Skill Validity Start Date (VALID_FROM)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `skill_version` SET TAGS ('dbx_business_glossary_term' = 'Skill Version (SKILL_VER)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`skills_inventory` ALTER COLUMN `training_hours_completed` SET TAGS ('dbx_business_glossary_term' = 'Training Hours Completed (TRAIN_HRS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `succession_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Incumbent Employee Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `succession_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `succession_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `succession_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Target Position Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `position_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `position_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `tertiary_succession_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `tertiary_succession_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `tertiary_succession_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Approval Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Approval Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Approved By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `competency_gap_score` SET TAGS ('dbx_business_glossary_term' = 'Competency Gap Score');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `development_actions` SET TAGS ('dbx_business_glossary_term' = 'Development Actions');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Role Indicator');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `last_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Succession Assessment Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `next_assessment_due` SET TAGS ('dbx_business_glossary_term' = 'Next Succession Assessment Due Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Code (SPC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `plan_review_date` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Review Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'leadership|technical|operational|support');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Priority');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `readiness_level` SET TAGS ('dbx_business_glossary_term' = 'Successor Readiness Level');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `readiness_level` SET TAGS ('dbx_value_regex' = 'ready_now|1-2_years|3-5_years');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Risk Level');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `succession_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `succession_plan_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `succession_priority` SET TAGS ('dbx_business_glossary_term' = 'Succession Priority Ranking');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `updated_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Version Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`succession_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` SET TAGS ('dbx_subdomain' = 'relations_safety');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `labor_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Labor Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Agreement Number (AGMT_NO)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `agreement_title` SET TAGS ('dbx_business_glossary_term' = 'Agreement Title (AGMT_TITLE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Type (AGMT_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'cba|union_contract|management_agreement');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `amendment_history` SET TAGS ('dbx_business_glossary_term' = 'Amendment History (AMEND_HIST)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `benefit_coverage_description` SET TAGS ('dbx_business_glossary_term' = 'Benefit Coverage Description (BENEFIT_COV)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `benefit_coverage_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `covered_department_codes` SET TAGS ('dbx_business_glossary_term' = 'Covered Department Codes (DEPT_CODES)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `covered_plant_codes` SET TAGS ('dbx_business_glossary_term' = 'Covered Plant Codes (PLANT_CODES)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (EFF_START)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EFF_END)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `grievance_procedure` SET TAGS ('dbx_business_glossary_term' = 'Grievance Procedure (GRIEV_PROCEDURE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `is_collective_bargaining` SET TAGS ('dbx_business_glossary_term' = 'Is Collective Bargaining (IS_CBA)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `is_unionized` SET TAGS ('dbx_business_glossary_term' = 'Is Unionized (IS_UNIONIZED)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction (JURISDICTION)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `labor_agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status (AGMT_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `labor_agreement_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|terminated|draft');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `overtime_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Overtime Rule Description (OT_RULE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `overtime_rule_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `payroll_rule_configuration` SET TAGS ('dbx_business_glossary_term' = 'Payroll Rule Configuration (PAYROLL_RULE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `payroll_rule_configuration` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `ratification_date` SET TAGS ('dbx_business_glossary_term' = 'Ratification Date (RAT_DATE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Status (REG_COMP_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_audit');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `seniority_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Seniority Rule Description (SENIORITY_RULE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `seniority_rule_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `union_local_number` SET TAGS ('dbx_business_glossary_term' = 'Union Local Number (UNION_LOCAL)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `union_name` SET TAGS ('dbx_business_glossary_term' = 'Union Name (UNION)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By (UPDATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `wage_scale_description` SET TAGS ('dbx_business_glossary_term' = 'Wage Scale Description (WAGE_SCALE)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `wage_scale_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By (CREATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` SET TAGS ('dbx_subdomain' = 'relations_safety');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_id` SET TAGS ('dbx_business_glossary_term' = 'Grievance Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Union Steward Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `labor_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Labor Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `primary_grievance_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Grievant Employee Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `primary_grievance_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `primary_grievance_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `audit_notes` SET TAGS ('dbx_business_glossary_term' = 'Audit Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_category` SET TAGS ('dbx_business_glossary_term' = 'Grievance Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_category` SET TAGS ('dbx_value_regex' = 'individual|group|union');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'CBA Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `confidentiality_flag` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Action Deadline Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_description` SET TAGS ('dbx_business_glossary_term' = 'Grievance Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Grievance Effective Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `filing_date` SET TAGS ('dbx_business_glossary_term' = 'Grievance Filing Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_number` SET TAGS ('dbx_business_glossary_term' = 'Grievance Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_status` SET TAGS ('dbx_business_glossary_term' = 'Grievance Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_status` SET TAGS ('dbx_value_regex' = 'open|under_review|resolved|closed|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_type` SET TAGS ('dbx_business_glossary_term' = 'Grievance Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `grievance_type` SET TAGS ('dbx_value_regex' = 'wage|discipline|harassment|safety|benefits');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `iatf_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'IATF Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `last_action_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Action Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Grievance Location Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `outcome` SET TAGS ('dbx_business_glossary_term' = 'Grievance Outcome');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `outcome` SET TAGS ('dbx_value_regex' = 'reinstatement|compensation|no_action|policy_change');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Grievance Priority');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `resolution_status` SET TAGS ('dbx_business_glossary_term' = 'Resolution Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `resolution_status` SET TAGS ('dbx_value_regex' = 'settled|unsettled|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_business_glossary_term' = 'Settlement Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `settlement_currency` SET TAGS ('dbx_business_glossary_term' = 'Settlement Currency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `settlement_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `settlement_notes` SET TAGS ('dbx_business_glossary_term' = 'Settlement Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `source` SET TAGS ('dbx_business_glossary_term' = 'Grievance Source');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `source` SET TAGS ('dbx_value_regex' = 'employee|union|manager|hr');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `step_in_process` SET TAGS ('dbx_business_glossary_term' = 'Grievance Process Step');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `step_in_process` SET TAGS ('dbx_value_regex' = 'filing|investigation|mediation|arbitration|decision');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `supporting_documents_flag` SET TAGS ('dbx_business_glossary_term' = 'Supporting Documents Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Target Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Grievance Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`grievance` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Grievance Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` SET TAGS ('dbx_subdomain' = 'relations_safety');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `safety_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `safety_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Investigation Owner ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `safety_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `safety_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `safety_equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `body_part_affected` SET TAGS ('dbx_business_glossary_term' = 'Body Part Affected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `corrective_action` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `days_away_from_work` SET TAGS ('dbx_business_glossary_term' = 'Days Away From Work');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `equipment_type` SET TAGS ('dbx_value_regex' = 'machine|tool|vehicle|fixture');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_category` SET TAGS ('dbx_business_glossary_term' = 'Incident Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_category` SET TAGS ('dbx_value_regex' = 'safety|health|environment|security');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_number` SET TAGS ('dbx_business_glossary_term' = 'Incident Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_status` SET TAGS ('dbx_business_glossary_term' = 'Incident Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_status` SET TAGS ('dbx_value_regex' = 'open|investigating|closed|reopened');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Incident Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_business_glossary_term' = 'Incident Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `incident_type` SET TAGS ('dbx_value_regex' = 'injury|near_miss|property_damage|environmental');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `injury_description` SET TAGS ('dbx_business_glossary_term' = 'Injury Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `injury_severity` SET TAGS ('dbx_business_glossary_term' = 'Injury Severity');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `injury_severity` SET TAGS ('dbx_value_regex' = 'minor|moderate|severe|fatal');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `investigation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `investigation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `lost_time_indicator` SET TAGS ('dbx_business_glossary_term' = 'Lost Time Indicator');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `osha_300_log_reference` SET TAGS ('dbx_business_glossary_term' = 'OSHA 300 Log Reference');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `osha_recordable_flag` SET TAGS ('dbx_business_glossary_term' = 'OSHA Recordable Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `safety_training_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Training Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `safety_training_date` SET TAGS ('dbx_business_glossary_term' = 'Safety Training Completion Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `shift` SET TAGS ('dbx_business_glossary_term' = 'Shift');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `shift` SET TAGS ('dbx_value_regex' = 'day|swing|night');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `headcount_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `actual_headcount` SET TAGS ('dbx_business_glossary_term' = 'Actual Headcount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `attrition_rate` SET TAGS ('dbx_business_glossary_term' = 'Attrition Rate (Percent)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Headcount Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `capacity_factor` SET TAGS ('dbx_business_glossary_term' = 'Capacity Factor (Percent)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `capacity_factor` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CAD|AUD');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `forecast_method` SET TAGS ('dbx_business_glossary_term' = 'Forecast Method');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `forecast_method` SET TAGS ('dbx_value_regex' = 'historical|trend|manager_input');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `headcount_category` SET TAGS ('dbx_business_glossary_term' = 'Headcount Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `headcount_category` SET TAGS ('dbx_value_regex' = 'full_time|contract|temp|intern');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `headcount_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `headcount_plan_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|rejected|active|closed');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `iatf_competency_required` SET TAGS ('dbx_business_glossary_term' = 'IATF Competency Required Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `job_family_code` SET TAGS ('dbx_business_glossary_term' = 'Job Family Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `labor_agreement_code` SET TAGS ('dbx_business_glossary_term' = 'Labor Agreement Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `new_hire_plan` SET TAGS ('dbx_business_glossary_term' = 'New Hire Plan');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Plan Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `period_type` SET TAGS ('dbx_business_glossary_term' = 'Planning Period Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `period_type` SET TAGS ('dbx_value_regex' = 'month|quarter|year');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `period_value` SET TAGS ('dbx_business_glossary_term' = 'Planning Period Value');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'annual|quarterly|monthly|ad_hoc');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `planned_headcount` SET TAGS ('dbx_business_glossary_term' = 'Planned Headcount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `review_cycle` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `review_cycle` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|annual');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'certified|not_certified|pending');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `unionized_flag` SET TAGS ('dbx_business_glossary_term' = 'Unionized Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `variance_headcount` SET TAGS ('dbx_business_glossary_term' = 'Headcount Variance');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Plan Version Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` SET TAGS ('dbx_subdomain' = 'relations_safety');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `disciplinary_action_id` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Issuing Manager ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `primary_disciplinary_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `primary_disciplinary_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `primary_disciplinary_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `acknowledgment_status` SET TAGS ('dbx_business_glossary_term' = 'Employee Acknowledgment Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `acknowledgment_status` SET TAGS ('dbx_value_regex' = 'acknowledged|not_acknowledged');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `action_date` SET TAGS ('dbx_business_glossary_term' = 'Action Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `action_number` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Number (DA)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `action_number` SET TAGS ('dbx_value_regex' = '^DA-d{6}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `action_type` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `action_type` SET TAGS ('dbx_value_regex' = 'verbal_warning|written_warning|suspension|termination');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `appeal_status` SET TAGS ('dbx_business_glossary_term' = 'Appeal Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `appeal_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `disciplinary_action_description` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `disciplinary_action_status` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `disciplinary_action_status` SET TAGS ('dbx_value_regex' = 'open|closed|appealed|revoked');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Action Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `policy_violated_code` SET TAGS ('dbx_business_glossary_term' = 'Policy Violated Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Action Severity Level');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `union_rep_flag` SET TAGS ('dbx_business_glossary_term' = 'Union Representation Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`disciplinary_action` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` SET TAGS ('dbx_subdomain' = 'relations_safety');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `employee_transfer_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Transfer ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'From Organization Unit ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'From Position ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `to_org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'To Organization Unit ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `to_position_id` SET TAGS ('dbx_business_glossary_term' = 'To Position ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `compensation_change_flag` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `compensation_change_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `compensation_change_flag` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `employee_transfer_status` SET TAGS ('dbx_business_glossary_term' = 'Transfer Record Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `employee_transfer_status` SET TAGS ('dbx_value_regex' = 'active|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `from_job_classification_code` SET TAGS ('dbx_business_glossary_term' = 'From Job Classification Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `new_pay_grade` SET TAGS ('dbx_business_glossary_term' = 'New Pay Grade');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `new_salary_amount` SET TAGS ('dbx_business_glossary_term' = 'New Salary Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `new_salary_amount` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `new_salary_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `new_salary_currency` SET TAGS ('dbx_business_glossary_term' = 'New Salary Currency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `new_salary_currency` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `new_salary_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `relocation_flag` SET TAGS ('dbx_business_glossary_term' = 'Relocation Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'required|exempt|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `seniority_date` SET TAGS ('dbx_business_glossary_term' = 'Seniority Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `temporary_end_date` SET TAGS ('dbx_business_glossary_term' = 'Temporary Transfer End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `temporary_transfer_flag` SET TAGS ('dbx_business_glossary_term' = 'Temporary Transfer Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `to_job_classification_code` SET TAGS ('dbx_business_glossary_term' = 'To Job Classification Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `training_completion_flag` SET TAGS ('dbx_business_glossary_term' = 'Training Completion Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `transfer_number` SET TAGS ('dbx_business_glossary_term' = 'Transfer Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `transfer_reason` SET TAGS ('dbx_business_glossary_term' = 'Transfer Reason');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `transfer_source_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Transfer Source Record ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `transfer_source_system` SET TAGS ('dbx_business_glossary_term' = 'Transfer Source System');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `transfer_type` SET TAGS ('dbx_business_glossary_term' = 'Transfer Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `transfer_type` SET TAGS ('dbx_value_regex' = 'promotion|demotion|lateral|plant|department');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `union_transfer_flag` SET TAGS ('dbx_business_glossary_term' = 'Union Transfer Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee_transfer` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `onboarding_task_id` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Owner ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `primary_onboarding_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `primary_onboarding_employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `primary_onboarding_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `actual_effort_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Effort (Hours)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `badge_issued_flag` SET TAGS ('dbx_business_glossary_term' = 'Badge Issued Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `benefits_enrollment_status` SET TAGS ('dbx_business_glossary_term' = 'Benefits Enrollment Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `benefits_enrollment_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Completion Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `completion_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Completion Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Due Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `effort_estimate_hours` SET TAGS ('dbx_business_glossary_term' = 'Effort Estimate (Hours)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `iatf_training_required` SET TAGS ('dbx_business_glossary_term' = 'IATF Training Required Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `onboarding_task_status` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `onboarding_task_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|blocked|cancelled');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `plant_access_granted_flag` SET TAGS ('dbx_business_glossary_term' = 'Plant Access Granted Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Priority');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `task_category` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `task_category` SET TAGS ('dbx_value_regex' = 'it_setup|safety_orientation|iatf_training|badge_issuance|plant_access|benefits_enrollment');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `task_code` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Code (OTC)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `task_description` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `task_name` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`onboarding_task` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Task Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `workforce_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Workforce Certification ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Verification Document ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `certification_code` SET TAGS ('dbx_business_glossary_term' = 'Certification Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `certification_level` SET TAGS ('dbx_business_glossary_term' = 'Certification Level');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `certification_name` SET TAGS ('dbx_business_glossary_term' = 'Certification Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_business_glossary_term' = 'Certification Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_value_regex' = 'safety|quality|technical|regulatory|voluntary');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `competency_area` SET TAGS ('dbx_business_glossary_term' = 'Competency Area');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `is_current` SET TAGS ('dbx_business_glossary_term' = 'Is Current');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `is_voluntary` SET TAGS ('dbx_business_glossary_term' = 'Is Voluntary');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `issuing_organization` SET TAGS ('dbx_business_glossary_term' = 'Issuing Organization');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `last_verified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Verified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `next_renewal_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Renewal Due Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `renewal_status` SET TAGS ('dbx_business_glossary_term' = 'Renewal Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `renewal_status` SET TAGS ('dbx_value_regex' = 'required|optional|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `required_job_code` SET TAGS ('dbx_business_glossary_term' = 'Required Job Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `validity_period_days` SET TAGS ('dbx_business_glossary_term' = 'Validity Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `verification_document_url` SET TAGS ('dbx_business_glossary_term' = 'Verification Document URL');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `workforce_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ALTER COLUMN `workforce_certification_status` SET TAGS ('dbx_value_regex' = 'active|expired|revoked|suspended|pending');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `labor_cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Labor Cost Allocation ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `activity_code` SET TAGS ('dbx_business_glossary_term' = 'Activity Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `allocated_cost` SET TAGS ('dbx_business_glossary_term' = 'Allocated Cost');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `allocated_hours` SET TAGS ('dbx_business_glossary_term' = 'Allocated Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `allocation_batch_number` SET TAGS ('dbx_business_glossary_term' = 'Allocation Batch ID');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_business_glossary_term' = 'Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_value_regex' = 'direct|absorption|activity_based|standard|other');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `cost_allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `cost_allocation_type` SET TAGS ('dbx_value_regex' = 'production|maintenance|research|admin|other');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = 'Q[1-4]');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `iatf_competency_flag` SET TAGS ('dbx_business_glossary_term' = 'IATF Competency Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `is_manual_allocation` SET TAGS ('dbx_business_glossary_term' = 'Manual Allocation Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `job_classification_code` SET TAGS ('dbx_business_glossary_term' = 'Job Classification Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `labor_category` SET TAGS ('dbx_business_glossary_term' = 'Labor Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `labor_category` SET TAGS ('dbx_value_regex' = 'direct|indirect');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `labor_cost_allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `labor_cost_allocation_status` SET TAGS ('dbx_value_regex' = 'pending|allocated|reversed|closed');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `labor_rate` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate (per hour)');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `overtime_flag` SET TAGS ('dbx_business_glossary_term' = 'Overtime Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `pay_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Pay Period End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `pay_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Pay Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `shift_code` SET TAGS ('dbx_business_glossary_term' = 'Shift Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `union_cba_code` SET TAGS ('dbx_business_glossary_term' = 'Union CBA Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ALTER COLUMN `wbs_element_code` SET TAGS ('dbx_business_glossary_term' = 'WBS Element Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` SET TAGS ('dbx_subdomain' = 'employee_administration');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Manager Employee Id');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `parent_department_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Department Id');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `department_type` SET TAGS ('dbx_business_glossary_term' = 'Department Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `department_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Department Email');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `has_safety_certification` SET TAGS ('dbx_business_glossary_term' = 'Has Safety Certification');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `headcount` SET TAGS ('dbx_business_glossary_term' = 'Headcount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `is_unionized` SET TAGS ('dbx_business_glossary_term' = 'Is Unionized');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Location Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `department_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `operating_hours_per_week` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Per Week');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `phone` SET TAGS ('dbx_business_glossary_term' = 'Department Phone');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `department_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`department` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `benefit_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Benefit Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `superseded_benefit_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Benefit Plan Id');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `superseded_benefit_plan_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `contribution_amount` SET TAGS ('dbx_business_glossary_term' = 'Contribution Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `contribution_frequency` SET TAGS ('dbx_business_glossary_term' = 'Contribution Frequency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `coverage_details` SET TAGS ('dbx_business_glossary_term' = 'Coverage Details');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `eligibility_age_max` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Age Max');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `eligibility_age_min` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Age Min');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Criteria');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `eligibility_employment_status` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Employment Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `eligibility_location` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Location');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `enrollment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Enrollment End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `enrollment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_category` SET TAGS ('dbx_business_glossary_term' = 'Plan Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Plan Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_coinsurance_percent` SET TAGS ('dbx_business_glossary_term' = 'Plan Coinsurance Percent');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_coverage_limit` SET TAGS ('dbx_business_glossary_term' = 'Plan Coverage Limit');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_deductible_amount` SET TAGS ('dbx_business_glossary_term' = 'Plan Deductible Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Plan Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_notes` SET TAGS ('dbx_business_glossary_term' = 'Plan Notes');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_out_of_pocket_max` SET TAGS ('dbx_business_glossary_term' = 'Plan Out Of Pocket Max');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Plan Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `premium_amount` SET TAGS ('dbx_business_glossary_term' = 'Premium Amount');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `premium_currency` SET TAGS ('dbx_business_glossary_term' = 'Premium Currency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `provider_email` SET TAGS ('dbx_business_glossary_term' = 'Provider Email');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `provider_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `provider_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `provider_name` SET TAGS ('dbx_business_glossary_term' = 'Provider Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `provider_phone` SET TAGS ('dbx_business_glossary_term' = 'Provider Phone');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `provider_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `provider_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `benefit_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `taxability_flag` SET TAGS ('dbx_business_glossary_term' = 'Taxability Flag');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`benefit_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` SET TAGS ('dbx_subdomain' = 'compensation_operations');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `pay_period_id` SET TAGS ('dbx_business_glossary_term' = 'Pay Period Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `previous_pay_period_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Pay Period Id');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `previous_pay_period_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `cut_off_date` SET TAGS ('dbx_business_glossary_term' = 'Cut Off Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `pay_period_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `holiday_indicator` SET TAGS ('dbx_business_glossary_term' = 'Holiday Indicator');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `is_holiday_period` SET TAGS ('dbx_business_glossary_term' = 'Is Holiday Period');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `is_overtime_eligible` SET TAGS ('dbx_business_glossary_term' = 'Is Overtime Eligible');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `pay_cycle_days` SET TAGS ('dbx_business_glossary_term' = 'Pay Cycle Days');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `pay_rate_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Pay Rate Multiplier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `payroll_run_date` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `period_code` SET TAGS ('dbx_business_glossary_term' = 'Period Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `period_name` SET TAGS ('dbx_business_glossary_term' = 'Period Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `period_type` SET TAGS ('dbx_business_glossary_term' = 'Period Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `pay_period_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`pay_period` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_course_id` SET TAGS ('dbx_business_glossary_term' = 'Training Course Identifier');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `competency_id` SET TAGS ('dbx_business_glossary_term' = 'Competency Id');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `primary_prerequisite_training_course_id` SET TAGS ('dbx_business_glossary_term' = 'Prerequisite Training Course Id');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `primary_prerequisite_training_course_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_prerequisite_course_id` SET TAGS ('dbx_business_glossary_term' = 'Prerequisite Course Id');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_prerequisite_course_id` SET TAGS ('dbx_self_ref_role' = 'prerequisite');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `accreditation_body` SET TAGS ('dbx_business_glossary_term' = 'Accreditation Body');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `assessment_method` SET TAGS ('dbx_business_glossary_term' = 'Assessment Method');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Assessment Type');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_course_category` SET TAGS ('dbx_business_glossary_term' = 'Category');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `certification_required` SET TAGS ('dbx_business_glossary_term' = 'Certification Required');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_course_code` SET TAGS ('dbx_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirements');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `cost` SET TAGS ('dbx_business_glossary_term' = 'Cost');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `credit_hours` SET TAGS ('dbx_business_glossary_term' = 'Credit Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `currency` SET TAGS ('dbx_business_glossary_term' = 'Currency');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Delivery Method');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Department');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_course_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Duration Hours');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `enrollment_deadline` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Deadline');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `equipment_needed` SET TAGS ('dbx_business_glossary_term' = 'Equipment Needed');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `evaluation_score` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Score');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `feedback_required` SET TAGS ('dbx_business_glossary_term' = 'Feedback Required');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `instructor_email` SET TAGS ('dbx_business_glossary_term' = 'Instructor Email');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `instructor_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `instructor_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `instructor_name` SET TAGS ('dbx_business_glossary_term' = 'Instructor Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `instructor_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `instructor_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `language` SET TAGS ('dbx_business_glossary_term' = 'Language');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Location');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `max_participants` SET TAGS ('dbx_business_glossary_term' = 'Max Participants');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_course_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `pass_score` SET TAGS ('dbx_business_glossary_term' = 'Pass Score');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `room_number` SET TAGS ('dbx_business_glossary_term' = 'Room Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `skill_tags` SET TAGS ('dbx_business_glossary_term' = 'Skill Tags');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_course_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `target_audience` SET TAGS ('dbx_business_glossary_term' = 'Target Audience');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_materials_url` SET TAGS ('dbx_business_glossary_term' = 'Training Materials Url');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `training_provider` SET TAGS ('dbx_business_glossary_term' = 'Training Provider');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`workforce`.`training_course` ALTER COLUMN `video_url` SET TAGS ('dbx_business_glossary_term' = 'Video Url');
