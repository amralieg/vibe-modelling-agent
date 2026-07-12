-- Schema for Domain: workforce | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:27

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`workforce` COMMENT 'Manages retail workforce including store associates, distribution center staff, and corporate employees. Owns employee master records, scheduling, time and attendance, payroll, benefits, talent acquisition, performance management, training programs, labor cost allocation, OSHA compliance records, and headcount planning. Integrates with Workday HCM for unified human capital management across all retail locations.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`associate` (
    `associate_id` BIGINT COMMENT 'Unique identifier for the retail workforce member. Primary key for the associate entity.',
    `collective_bargaining_agreement_id` BIGINT COMMENT 'Identifier of the collective bargaining agreement governing the associates terms and conditions of employment. Null for non-union associates. Used for contract compliance and labor cost modeling.',
    `dc_facility_id` BIGINT COMMENT 'Identifier of the distribution center where the associate is primarily assigned. Null for store and corporate associates. Used for DC labor reporting and capacity planning.',
    `location_id` BIGINT COMMENT 'Identifier of the store where the associate is primarily assigned. Null for DC and corporate associates. Used for store-level labor reporting and scheduling.',
    `manager_associate_id` BIGINT COMMENT 'Associate ID of the direct manager or supervisor. Used for organizational hierarchy reporting, approval workflows, and performance management.',
    `badge_number` STRING COMMENT 'Physical badge or access card number used for facility access, time clock punches, and POS system login.',
    `cost_center_code` STRING COMMENT 'Financial accounting code for labor cost allocation. Maps to the organizational unit (store, DC, department) responsible for the associates compensation expenses.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this associate record was first created in the system. Used for data lineage, audit trails, and record lifecycle tracking.',
    `email_address` STRING COMMENT 'Corporate email address assigned to the associate for business communications, system access, and internal collaboration.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `emergency_contact_name` STRING COMMENT 'Name of the person to contact in case of workplace emergency or injury. Required for OSHA compliance and duty of care.',
    `emergency_contact_phone` STRING COMMENT 'Phone number of the emergency contact person. Required for OSHA compliance and duty of care.',
    `employment_status` STRING COMMENT 'Current lifecycle status of the associates employment. Active indicates currently working, leave-of-absence for approved absences (medical, parental, personal), suspended for disciplinary actions, terminated for ended employment.. Valid values are `active|leave-of-absence|suspended|terminated`',
    `employment_type` STRING COMMENT 'Classification of employment relationship defining work schedule expectations, benefits eligibility, and labor cost allocation. Full-time typically 35+ hours/week, part-time under 35 hours/week, seasonal for peak periods (holidays, back-to-school), temporary for fixed-duration assignments.. Valid values are `full-time|part-time|seasonal|temporary|contractor|intern`',
    `flsa_status` STRING COMMENT 'Classification determining overtime eligibility under FLSA. Exempt employees are salaried and not eligible for overtime; non-exempt employees are eligible for overtime pay at 1.5x regular rate for hours over 40/week.. Valid values are `exempt|non-exempt`',
    `hire_date` DATE COMMENT 'Date the associate was originally hired by the organization. Used for seniority calculations, benefits vesting, anniversary recognition, and tenure reporting.',
    `hr_business_partner_name` STRING COMMENT 'Name of the HR business partner assigned to support this associate. Used for HR case routing, employee relations, and policy guidance.',
    `i9_document_type` STRING COMMENT 'Type of documentation provided for I-9 verification. Examples: US Passport (List A), Drivers License + Social Security Card (List B+C), Permanent Resident Card (List A).',
    `i9_verification_date` DATE COMMENT 'Date the employer completed Section 2 of Form I-9 verifying the associates identity and employment authorization. Required within 3 business days of hire date.',
    `job_code` STRING COMMENT 'Standardized code representing the job classification for compensation, workforce planning, and labor reporting. Maps to pay grade and FLSA status.',
    `job_title` STRING COMMENT 'Official job title reflecting the associates role and responsibilities. Examples: Sales Associate, Department Manager, Distribution Center Picker, Merchandising Coordinator, Store Manager.',
    `last_performance_review_date` DATE COMMENT 'Date of the most recent formal performance review or appraisal. Used for performance management cycle tracking and development planning.',
    `last_training_completion_date` DATE COMMENT 'Date the associate most recently completed a required training program. Used for compliance tracking (safety, harassment prevention, food safety) and skills development monitoring.',
    `legal_first_name` STRING COMMENT 'Legal first name as recorded on government-issued identification and payroll records. Used for tax reporting, benefits administration, and compliance documentation.',
    `legal_last_name` STRING COMMENT 'Legal last name (surname) as recorded on government-issued identification and payroll records. Used for tax reporting, benefits administration, and compliance documentation.',
    `legal_middle_name` STRING COMMENT 'Legal middle name or initial as recorded on government-issued identification. Optional field used for formal documentation.',
    `pay_grade` STRING COMMENT 'Compensation band or level within the organizations pay structure. Determines salary range or hourly rate range for the position.',
    `pay_type` STRING COMMENT 'Compensation structure indicating whether the associate is paid based on hours worked (hourly) or a fixed annual salary (salaried).. Valid values are `hourly|salaried`',
    `phone_number` STRING COMMENT 'Primary work phone number for the associate. May be a direct line, extension, or mobile number depending on role and location.',
    `preferred_name` STRING COMMENT 'Name the associate prefers to be called in day-to-day work interactions. Used for name badges, internal communications, and scheduling displays.',
    `primary_work_location_type` STRING COMMENT 'Classification of the associates primary work location. Used for labor cost allocation, workforce planning, and facility capacity management.. Valid values are `store|distribution-center|corporate-office|regional-office|remote`',
    `rehire_eligible_flag` BOOLEAN COMMENT 'Indicator of whether the associate is eligible for rehire based on their employment history and termination circumstances. True indicates eligible, False indicates not eligible.',
    `standard_hours_per_week` DECIMAL(18,2) COMMENT 'Expected number of hours the associate is scheduled to work per week under normal conditions. Used for labor planning, benefits eligibility determination, and FTE calculations.',
    `termination_date` DATE COMMENT 'Date the associates employment ended. Null for active employees. Used for turnover analysis, final payroll processing, and benefits termination.',
    `termination_reason` STRING COMMENT 'Classification of the reason for employment termination. Used for turnover analysis, unemployment claims, and rehire eligibility determination.. Valid values are `voluntary|involuntary|retirement|layoff|end-of-season|end-of-contract`',
    `union_local_code` STRING COMMENT 'Identifier of the local union chapter to which the associate belongs. Null for non-union associates. Used for dues deduction, grievance processing, and contract administration.',
    `union_membership_flag` BOOLEAN COMMENT 'Indicator of whether the associate is a member of a labor union. True indicates union member, False indicates non-union. Used for collective bargaining compliance and labor relations reporting.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this associate record was last modified. Used for change tracking, data quality monitoring, and audit trails.',
    `work_authorization_expiration_date` DATE COMMENT 'Expiration date of work authorization documentation for non-citizens. Null for citizens and permanent residents. Used to trigger reverification requirements.',
    `work_authorization_status` STRING COMMENT 'Legal authorization status for employment in the jurisdiction. Used for I-9 compliance verification and work eligibility tracking.. Valid values are `citizen|permanent-resident|work-visa|employment-authorization`',
    `workday_worker_code` STRING COMMENT 'External unique identifier from Workday HCM system. Golden record reference for workforce data integration.',
    CONSTRAINT pk_associate PRIMARY KEY(`associate_id`)
) COMMENT 'Master record for all retail workforce members including store associates, DC staff, and corporate employees. Sourced from Workday HCM as the golden record. Captures employee ID, legal name, preferred name, employment type (full-time, part-time, seasonal, temporary), job classification, FLSA status (exempt/non-exempt), hire date, termination date, rehire eligibility, work authorization status (I-9 verification date, document type, expiration date), primary work location (store, DC, corporate), cost center, pay grade, pay type (hourly/salaried), standard hours per week, manager employee ID, HR business partner, union membership flag, union local code, collective bargaining agreement identifier, badge number, Workday worker ID, and multi-location assignment history including temporary transfers, cross-training assignments, and seasonal redeployments between stores and DCs.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`job_profile` (
    `job_profile_id` BIGINT COMMENT 'Unique identifier for the job profile. Primary key for the job profile reference catalog. Sourced from Workday HCM job catalog.',
    `org_unit_id` BIGINT COMMENT 'add column org_unit_id (BIGINT) with FK to workforce.org_unit.org_unit_id - job profiles are defined within organizational units for headcount planning',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this job profile record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the pay range (e.g., USD, CAD, MXN). Used for multi-currency compensation management in global retail operations.. Valid values are `^[A-Z]{3}$`',
    `department` STRING COMMENT 'Primary department or functional area where this job profile is typically assigned (e.g., Store Operations, Distribution Center, Merchandising, Finance, Human Resources).',
    `division` STRING COMMENT 'Higher-level organizational division or business unit where this job profile resides (e.g., Retail Operations, Corporate, Supply Chain, E-Commerce).',
    `eeoc_job_category` STRING COMMENT 'Standard EEOC job category classification for this profile (e.g., Executive/Senior Level Officials and Managers, Professionals, Sales Workers, Service Workers). Used for EEO-1 reporting and compliance.',
    `effective_end_date` DATE COMMENT 'Date when this job profile was retired or became inactive. Null for currently active profiles. Used for historical tracking and organizational change management.',
    `effective_start_date` DATE COMMENT 'Date when this job profile became active and available for use in the organization. Used for historical tracking and organizational change management.',
    `employment_type` STRING COMMENT 'Standard employment classification indicating whether the role is full-time, part-time, seasonal, temporary, or contractor. Used for benefits eligibility and workforce planning.. Valid values are `full-time|part-time|seasonal|temporary|contractor`',
    `flsa_classification` STRING COMMENT 'Classification under the Fair Labor Standards Act indicating whether the role is exempt or non-exempt from overtime pay requirements. Critical for payroll and labor cost compliance.. Valid values are `exempt|non-exempt`',
    `is_bonus_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether this role is eligible for performance-based bonuses or incentive compensation. Used for total compensation planning and performance management.',
    `is_commission_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether this role is eligible for sales commission or variable compensation based on sales performance. Used for sales compensation planning.',
    `is_corporate` BOOLEAN COMMENT 'Boolean flag indicating whether this role is a corporate or headquarters position. Used for organizational structure reporting and overhead cost allocation.',
    `is_customer_facing` BOOLEAN COMMENT 'Boolean flag indicating whether this role involves direct interaction with customers (e.g., sales associates, customer service representatives). Used for customer experience planning and training programs.',
    `is_dc_facing` BOOLEAN COMMENT 'Boolean flag indicating whether this role is primarily assigned to distribution center or warehouse locations. Used for supply chain workforce planning.',
    `is_leadership_role` BOOLEAN COMMENT 'Boolean flag indicating whether this job profile is a leadership or management position with direct reports. Used for leadership development programs and organizational structure analysis.',
    `is_overtime_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether this role is eligible for overtime pay. Typically aligns with FLSA non-exempt classification. Used for payroll and labor cost forecasting.',
    `is_store_facing` BOOLEAN COMMENT 'Boolean flag indicating whether this role is primarily assigned to retail store locations. Used for store headcount planning and labor cost allocation.',
    `is_union_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether this job profile is eligible for union membership or collective bargaining representation. Used for labor relations and compliance reporting.',
    `job_code` STRING COMMENT 'Unique alphanumeric code assigned to the job profile for system identification and reporting. Used in payroll, headcount planning, and compensation benchmarking.. Valid values are `^[A-Z0-9]{4,12}$`',
    `job_description` STRING COMMENT 'Detailed narrative description of the job profile including responsibilities, duties, and expectations. Used for job postings, performance management, and organizational documentation.',
    `job_family` STRING COMMENT 'Broad occupational grouping that categorizes similar roles together (e.g., Retail Operations, Supply Chain, Finance, Technology, Merchandising). Used for career pathing and talent development.',
    `job_level` STRING COMMENT 'Hierarchical level or grade of the job within the organization (e.g., Entry Level, Mid-Level, Senior, Manager, Director, Executive). Used for compensation planning and organizational structure.',
    `job_profile_status` STRING COMMENT 'Current lifecycle status of the job profile. Active profiles are available for hiring and assignment; inactive profiles are no longer used but retained for historical reporting.. Valid values are `active|inactive|pending|obsolete`',
    `job_title` STRING COMMENT 'Official job title as displayed on employee records, offer letters, and organizational charts. Human-readable name for the job profile.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this job profile record was last updated. Used for audit trail and change tracking.',
    `last_reviewed_date` DATE COMMENT 'Date when this job profile was last reviewed for accuracy and relevance by Human Resources. Used for job profile maintenance and compliance audits.',
    `location_type` STRING COMMENT 'Indicates the primary work location type for this job profile. Used for workforce planning, real estate allocation, and operational reporting.. Valid values are `store|distribution-center|corporate-office|remote|field`',
    `maximum_pay_range` DECIMAL(18,2) COMMENT 'Maximum annual or hourly compensation for this job profile. Used for compensation benchmarking, offer generation, and pay equity analysis.',
    `minimum_pay_range` DECIMAL(18,2) COMMENT 'Minimum annual or hourly compensation for this job profile. Used for compensation benchmarking, offer generation, and pay equity analysis.',
    `minimum_years_experience` STRING COMMENT 'Minimum number of years of relevant work experience required for this job profile. Used for talent acquisition and career progression planning.',
    `onet_code` STRING COMMENT 'Standard occupational classification code from the O*NET database maintained by the U.S. Department of Labor. Used for labor market analysis, compensation benchmarking, and skills mapping.. Valid values are `^[0-9]{2}-[0-9]{4}.[0-9]{2}$`',
    `pay_frequency` STRING COMMENT 'Indicates whether compensation for this role is calculated on an hourly, salary, or commission basis. Used for payroll processing and labor cost modeling.. Valid values are `hourly|salary|commission`',
    `physical_requirements` STRING COMMENT 'Description of physical demands and requirements for this job profile (e.g., ability to lift 50 lbs, prolonged standing, repetitive motion). Used for OSHA compliance, ADA accommodations, and safety planning.',
    `required_certifications` STRING COMMENT 'List of professional certifications, licenses, or credentials required for this job profile (e.g., forklift operator license, pharmacy technician license, food safety certification). Used for talent acquisition and compliance tracking.',
    `required_education_level` STRING COMMENT 'Minimum education level required for this job profile. Used for talent acquisition screening and workforce development planning.. Valid values are `high-school|associate|bachelor|master|doctorate|none`',
    `span_of_control_max` STRING COMMENT 'Maximum number of direct reports typically managed by this role. Used for organizational design and management capacity planning. Null for individual contributor roles.',
    `span_of_control_min` STRING COMMENT 'Minimum number of direct reports typically managed by this role. Used for organizational design and management capacity planning. Null for individual contributor roles.',
    `standard_hours_per_week` DECIMAL(18,2) COMMENT 'Expected number of hours per week for this job profile. Used for scheduling, labor cost allocation, and full-time equivalency (FTE) calculations.',
    `succession_planning_tier` STRING COMMENT 'Classification indicating the importance of this role for succession planning and talent pipeline development. Critical roles require active succession plans and talent bench strength.. Valid values are `critical|high|medium|low|not-applicable`',
    `travel_requirement_percentage` DECIMAL(18,2) COMMENT 'Expected percentage of time this role requires business travel. Used for expense planning and candidate expectations management.',
    CONSTRAINT pk_job_profile PRIMARY KEY(`job_profile_id`)
) COMMENT 'Reference catalog of all job profiles and roles defined across the retail organization. Captures job code, job title, job family, job level, FLSA classification, minimum and maximum pay range, standard hours, required certifications, physical requirements, department, division, and whether the role is store-facing, DC-facing, or corporate. Sourced from Workday HCM job catalog. Used for headcount planning, compensation benchmarking, and talent acquisition.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` (
    `shift_schedule_id` BIGINT COMMENT 'Unique identifier for the shift schedule record. Primary key for the shift schedule entity.',
    `coverage_request_id` BIGINT COMMENT 'Identifier of the coverage request if this schedule was created to fill an open shift posted by a manager or another associate. Null if the shift was not a coverage assignment.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC associates require shift scheduling at their assigned distribution center. Workforce planning, labor cost allocation, and operational scheduling depend on facility-specific shift management. Essent',
    `department_id` BIGINT COMMENT 'Identifier of the department or functional area within the location where the associate is scheduled to work (e.g., grocery, apparel, checkout, receiving).',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Shifts are scheduled for specific job roles. Workforce scheduling systems need to ensure shifts are staffed with appropriate job classifications (cannot schedule a cashier shift with a stocker). The s',
    `location_id` BIGINT COMMENT 'Identifier of the store, distribution center, or corporate office where the shift is scheduled. Links to the location master.',
    `associate_id` BIGINT COMMENT 'Unique identifier of the associate or employee assigned to this shift. Links to the employee master record in Workday HCM.',
    `shift_associate_id` BIGINT COMMENT 'The user ID or system account that last modified the shift schedule record. Used for audit trail and accountability.',
    `shift_swap_request_id` BIGINT COMMENT 'Identifier of the shift swap request if this schedule resulted from an approved swap between two associates. Null if the shift was not swapped.',
    `break_duration_minutes` STRING COMMENT 'Total duration of unpaid breaks in minutes scheduled during the shift. Required for compliance with state labor laws regarding meal and rest breaks.',
    `cancellation_reason` STRING COMMENT 'The reason why the shift schedule was cancelled. Low traffic indicates reduced customer demand, weather indicates store closure or reduced operations, employee absence indicates the associate called out, operational change indicates business need adjustment, employee request indicates the associate requested cancellation, and other captures miscellaneous reasons.. Valid values are `low_traffic|weather|employee_absence|operational_change|employee_request|other`',
    `cancelled_timestamp` TIMESTAMP COMMENT 'The date and time when the shift schedule was cancelled. Used to track last-minute cancellations and compliance with predictive scheduling laws that require reporting pay for cancelled shifts.',
    `confirmed_timestamp` TIMESTAMP COMMENT 'The date and time when the associate acknowledged or confirmed receipt of the shift schedule in Workday HCM.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the shift schedule record was first created in the system. Used for audit trail and data lineage tracking.',
    `employee_availability_match` STRING COMMENT 'Indicates how well the scheduled shift aligns with the associates stated availability preferences in Workday HCM. Full match means the shift is within preferred hours, partial match means some overlap, no match means the shift conflicts with availability, and not specified means no preference was recorded.. Valid values are `full_match|partial_match|no_match|not_specified`',
    `estimated_labor_cost` DECIMAL(18,2) COMMENT 'The estimated total labor cost for this shift in USD, including base pay, overtime premium, holiday premium, and benefits allocation. Used for labor budget planning and variance analysis.',
    `is_holiday_shift` BOOLEAN COMMENT 'Indicates whether the shift falls on a company-recognized holiday, which may qualify for premium pay or special scheduling rules.',
    `is_overtime_eligible` BOOLEAN COMMENT 'Indicates whether this shift qualifies for overtime pay based on the associates weekly hours and FLSA classification. True if the shift pushes the associate over 40 hours per week or is explicitly designated as overtime.',
    `labor_cost_allocation_code` STRING COMMENT 'The cost center or general ledger account code to which the labor cost for this shift should be allocated. Used for financial planning and P&L reporting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the shift schedule record was last updated. Used for audit trail and change tracking.',
    `paid_break_duration_minutes` STRING COMMENT 'Total duration of paid rest breaks in minutes scheduled during the shift. Separate from unpaid meal breaks.',
    `published_timestamp` TIMESTAMP COMMENT 'The date and time when the shift schedule was published and made visible to the associate. Used to track compliance with advance notice requirements under predictive scheduling laws.',
    `schedule_notes` STRING COMMENT 'Free-text notes or special instructions related to the shift schedule. May include information about special tasks, training requirements, or operational considerations.',
    `schedule_source` STRING COMMENT 'Indicates how the shift schedule was created. Auto-generated schedules are created by Workday HCM scheduling algorithms, manager-assigned schedules are manually created by supervisors, employee-requested schedules honor associate preferences, shift-swap schedules result from approved swaps, and coverage-request schedules fill open shifts.. Valid values are `auto_generated|manager_assigned|employee_requested|shift_swap|coverage_request`',
    `schedule_status` STRING COMMENT 'Current lifecycle status of the shift schedule. Draft schedules are being prepared, published schedules are visible to associates, confirmed schedules are acknowledged by the associate, cancelled schedules are voided, and completed schedules have been worked.. Valid values are `draft|published|confirmed|cancelled|completed`',
    `schedule_week_start_date` DATE COMMENT 'The start date of the scheduling week for which this shift is planned. Typically Monday in a Monday-Sunday scheduling cycle.',
    `scheduled_end_time` TIMESTAMP COMMENT 'The planned end date and time for the shift, including time zone information.',
    `scheduled_hours` DECIMAL(18,2) COMMENT 'Total number of hours the associate is scheduled to work during this shift, excluding breaks. Used for labor cost planning and compliance with labor laws.',
    `scheduled_start_time` TIMESTAMP COMMENT 'The planned start date and time for the shift, including time zone information.',
    `shift_date` DATE COMMENT 'The calendar date on which the shift is scheduled to occur.',
    `shift_priority` STRING COMMENT 'Business priority level of the shift. Critical shifts are essential for operations (e.g., opening manager, security), high priority shifts support peak traffic, normal shifts are standard coverage, and low priority shifts are optional or training.. Valid values are `critical|high|normal|low`',
    `shift_type` STRING COMMENT 'Classification of the shift based on time of day and operational role. Opening shifts start early morning, mid shifts cover midday, closing shifts end at store close, overnight shifts cover restocking and maintenance, split shifts have a break in the middle, and on-call shifts are standby assignments.. Valid values are `opening|mid|closing|overnight|split|on_call`',
    CONSTRAINT pk_shift_schedule PRIMARY KEY(`shift_schedule_id`)
) COMMENT 'Planned work schedules for store associates and DC staff generated through Workday HCM workforce scheduling. Captures schedule week start date, store or DC location, department, shift type (opening, mid, closing, overnight), scheduled start time, scheduled end time, scheduled hours, break duration, assigned associate, scheduling status (draft, published, confirmed), schedule source (auto-generated, manager-assigned), and employee availability/preference indicators. Also encompasses shift swap requests, coverage requests, and open shift postings including swap request status, requesting associate, covering associate, and manager approval. Supports labor cost planning, SLA compliance for store coverage, and associate schedule flexibility.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`time_entry` (
    `time_entry_id` BIGINT COMMENT 'Unique identifier for the time entry record. Primary key for the time entry data product.',
    `cost_center_id` BIGINT COMMENT 'Identifier for the cost center to which labor costs for this time entry should be allocated. Used for financial reporting and P&L analysis.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC workers clock in/out at specific facilities for payroll processing and labor cost allocation. Time and attendance systems require facility-level tracking for accurate labor costing and compliance r',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Time entries capture work performed in a specific job role. Labor cost allocation requires knowing which job profile the work was performed under (especially for associates who work multiple roles or',
    `pay_period_id` BIGINT COMMENT 'Identifier for the pay period to which this time entry belongs. Used for payroll processing and labor cost allocation.',
    `associate_id` BIGINT COMMENT 'Unique identifier for the employee who recorded this time entry. Links to the employee master record in Workday HCM.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Each worked shift must allocate labor cost to the store/channel profit center for accurate store P&L. Critical for retail store-level profitability tracking, labor cost percentage analysis, and operat',
    `shift_schedule_id` BIGINT COMMENT 'Identifier for the scheduled shift assignment associated with this time entry. Links to workforce scheduling system.',
    `time_associate_id` BIGINT COMMENT 'Identifier for the user (employee or manager) who last modified this time entry record. Used for audit trail and accountability.',
    `location_id` BIGINT COMMENT 'Identifier for the physical location where the work was performed (store, distribution center, corporate office). Used for labor cost allocation by location.',
    `actual_hours_worked` DECIMAL(18,2) COMMENT 'Total number of hours actually worked during this time entry, calculated from clock-in and clock-out timestamps minus break time. Used for payroll calculation.',
    `approval_status` STRING COMMENT 'Current approval status of the time entry. Time entries must be approved before payroll processing.. Valid values are `pending|approved|rejected|auto_approved|under_review`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the time entry was approved by the manager. Nullable if not yet approved.',
    `break_time_minutes` STRING COMMENT 'Total minutes of unpaid break time taken during this shift. Deducted from total time to calculate actual hours worked.',
    `clock_in_timestamp` TIMESTAMP COMMENT 'Exact date and time when the employee clocked in to start their work shift. Captured from POS-integrated time clock, mobile app, or Workday HCM.',
    `clock_out_timestamp` TIMESTAMP COMMENT 'Exact date and time when the employee clocked out to end their work shift. Nullable for in-progress shifts.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this time entry record was first created in the system. Used for audit trail and data lineage.',
    `department_code` STRING COMMENT 'Code representing the department where the work was performed. Used for departmental labor reporting and cost allocation.',
    `double_time_hours` DECIMAL(18,2) COMMENT 'Number of hours worked that qualify for double-time pay (typically 2x regular rate). Applicable in certain states or under specific conditions (e.g., working on holidays).',
    `exception_flag` BOOLEAN COMMENT 'Indicates whether this time entry has any exceptions that require manager review (e.g., missed punch, early departure, unscheduled overtime).',
    `exception_notes` STRING COMMENT 'Free-text notes explaining the time entry exception. Captured by manager or employee during exception resolution.',
    `exception_type` STRING COMMENT 'Type of time entry exception that occurred. Used for compliance monitoring and manager follow-up.. Valid values are `missed_punch|early_departure|late_arrival|unscheduled_overtime|no_break_taken|extended_break`',
    `geolocation_latitude` DECIMAL(18,2) COMMENT 'Latitude coordinate where the time entry was recorded (for mobile app entries). Used for location verification and compliance.',
    `geolocation_longitude` DECIMAL(18,2) COMMENT 'Longitude coordinate where the time entry was recorded (for mobile app entries). Used for location verification and compliance.',
    `is_holiday_work` BOOLEAN COMMENT 'Indicates whether this time entry was performed on a company-recognized holiday. May qualify for premium pay.',
    `labor_cost_amount` DECIMAL(18,2) COMMENT 'Total labor cost for this time entry, calculated as hours worked multiplied by applicable pay rates (including overtime and differentials). Used for financial reporting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this time entry record was last updated. Used for audit trail and change tracking.',
    `meal_break_minutes` STRING COMMENT 'Total minutes of meal break time taken during this shift. Typically unpaid and required by state labor laws for shifts exceeding certain durations.',
    `overtime_hours` DECIMAL(18,2) COMMENT 'Number of hours worked beyond regular hours that qualify for overtime pay (typically 1.5x regular rate). Calculated based on FLSA rules and state labor laws.',
    `paid_break_minutes` STRING COMMENT 'Total minutes of paid rest breaks taken during this shift. Typically required for shifts of certain lengths and included in hours worked.',
    `pay_rate` DECIMAL(18,2) COMMENT 'Hourly pay rate applicable to this time entry. Used for payroll calculation. Confidential compensation data.',
    `payroll_batch_code` STRING COMMENT 'Identifier for the payroll batch in which this time entry was processed. Used for payroll reconciliation and audit.',
    `payroll_processed_flag` BOOLEAN COMMENT 'Indicates whether this time entry has been processed in payroll. Used to prevent duplicate payment and ensure audit trail.',
    `regular_hours` DECIMAL(18,2) COMMENT 'Number of hours worked at regular pay rate (typically up to 40 hours per week for non-exempt employees). Used for payroll processing.',
    `shift_differential_eligible` BOOLEAN COMMENT 'Indicates whether this time entry qualifies for shift differential pay (e.g., night shift, weekend shift premium). Used for payroll calculation.',
    `shift_differential_rate` DECIMAL(18,2) COMMENT 'Additional pay rate (as a percentage or dollar amount) applied for shift differential. Used in payroll calculation.',
    `shift_differential_type` STRING COMMENT 'Type of shift differential applicable to this time entry. Determines the premium pay rate to be applied.. Valid values are `night_shift|weekend|holiday|closing_shift|opening_shift`',
    `source` STRING COMMENT 'The system or method used to capture this time entry. Indicates data quality and audit trail for time tracking.. Valid values are `time_clock|mobile_app|manual_entry|workday_hcm|pos_terminal|biometric_scanner`',
    `time_clock_device_code` STRING COMMENT 'Identifier for the physical time clock or terminal where the employee clocked in/out. Used for audit trail and device management.',
    `time_entry_type` STRING COMMENT 'Classification of the time entry indicating the nature of work or absence. Used for payroll processing and labor analytics. [ENUM-REF-CANDIDATE: regular_shift|overtime|holiday|sick_leave|vacation|bereavement|jury_duty|training — 8 candidates stripped; promote to reference product]',
    `work_date` DATE COMMENT 'The calendar date on which the work was performed. Used for daily labor reporting and scheduling compliance.',
    CONSTRAINT pk_time_entry PRIMARY KEY(`time_entry_id`)
) COMMENT 'Actual time and attendance records for all hourly and salaried non-exempt retail associates captured via POS-integrated time clocks, mobile apps, or Workday HCM. Captures clock-in timestamp, clock-out timestamp, actual hours worked, break time taken, overtime hours, shift differential eligibility, time entry source (time clock, manual, mobile), approval status, approving manager, pay period, and any time entry exceptions (missed punch, early departure, unscheduled overtime). Foundation for payroll processing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`payroll_record` (
    `payroll_record_id` BIGINT COMMENT 'Unique identifier for the payroll record. Primary key for this entity.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Payroll journal entries post labor costs to specific GL accounts (salary expense, tax liability, benefits accrual). Required for automated payroll accounting integration and labor cost financial repor',
    `payroll_run_id` BIGINT COMMENT 'Unique identifier for the payroll processing batch run. Groups all payroll records processed together in a single payroll cycle.',
    `associate_id` BIGINT COMMENT 'Unique identifier for the employee receiving this payroll payment. Links to the employee master record in the workforce domain.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Store-level P&L reporting requires payroll costs allocated to profit centers (store/channel). Essential for retail store profitability analysis, district manager reporting, and segment performance eva',
    `shift_schedule_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_schedule. Business justification: Payroll records capture actual hours worked and pay amounts; shift_schedule defines planned hours and labor cost estimates. Linking enables variance analysis (scheduled vs actual hours), labor cost re',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll record was approved for payment. Critical audit timestamp for payroll controls.',
    `bank_account_last_four_digits` STRING COMMENT 'Last four digits of the employees bank account number for direct deposit verification. Masked for security and PCI compliance.. Valid values are `^[0-9]{4}$`',
    `bonus_pay_amount` DECIMAL(18,2) COMMENT 'Discretionary or performance-based bonus compensation included in this pay period. Includes incentive bonuses, retention bonuses, and other one-time payments.',
    `commission_pay_amount` DECIMAL(18,2) COMMENT 'Sales commission earnings for the pay period. Variable compensation based on sales performance or revenue generation.',
    `cost_center_code` STRING COMMENT 'Financial cost center to which this payroll expense is allocated. Used for labor cost accounting and P&L reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll record was first created in the system. Initial record creation audit timestamp.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this payroll record. Typically USD for US retail operations.. Valid values are `^[A-Z]{3}$`',
    `department_code` STRING COMMENT 'Organizational department code for the employee during this pay period. Used for workforce analytics and labor distribution.',
    `federal_tax_withheld_amount` DECIMAL(18,2) COMMENT 'Federal income tax withheld from gross pay based on employee W-4 elections and IRS withholding tables.',
    `fica_medicare_withheld_amount` DECIMAL(18,2) COMMENT 'Medicare tax withheld under Federal Insurance Contributions Act (FICA). Employee portion of Medicare hospital insurance tax.',
    `fica_social_security_withheld_amount` DECIMAL(18,2) COMMENT 'Social Security tax withheld under Federal Insurance Contributions Act (FICA). Employee portion of OASDI tax.',
    `garnishment_amount` DECIMAL(18,2) COMMENT 'Court-ordered wage garnishments deducted from pay. Includes child support, tax levies, creditor garnishments, and other legal withholdings.',
    `gross_pay_amount` DECIMAL(18,2) COMMENT 'Total compensation before any deductions. Sum of regular pay, overtime pay, shift differential, bonuses, commissions, and other earnings.',
    `health_insurance_deduction_amount` DECIMAL(18,2) COMMENT 'Employee contribution toward health insurance premiums deducted from gross pay. May be pre-tax or post-tax depending on plan type.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll record was last updated. Tracks any adjustments or corrections made after initial processing.',
    `local_tax_withheld_amount` DECIMAL(18,2) COMMENT 'Local or municipal income tax withheld from gross pay where applicable. Includes city, county, or district taxes.',
    `location_code` STRING COMMENT 'Work location code where the employee performed work during this pay period. Store number, DC code, or corporate office identifier.',
    `net_pay_amount` DECIMAL(18,2) COMMENT 'Take-home pay after all deductions. The actual amount disbursed to the employee via direct deposit or check.',
    `other_benefits_deduction_amount` DECIMAL(18,2) COMMENT 'Total deductions for other voluntary benefits such as dental insurance, vision insurance, life insurance, disability insurance, and flexible spending accounts.',
    `overtime_hours_worked` DECIMAL(18,2) COMMENT 'Total number of overtime hours worked during the pay period. Hours exceeding standard work week threshold requiring premium pay.',
    `overtime_pay_amount` DECIMAL(18,2) COMMENT 'Gross compensation for overtime hours worked, typically calculated at time-and-a-half or double-time premium rates.',
    `pay_date` DATE COMMENT 'The date on which payment is issued or deposited to the employee. The actual disbursement date for compensation.',
    `pay_frequency` STRING COMMENT 'The frequency with which the employee is paid. Defines the payroll cycle cadence for this employee.. Valid values are `weekly|biweekly|semimonthly|monthly`',
    `pay_period_end_date` DATE COMMENT 'The last date of the pay period covered by this payroll record. Defines the end of the work period for which compensation is calculated.',
    `pay_period_start_date` DATE COMMENT 'The first date of the pay period covered by this payroll record. Defines the beginning of the work period for which compensation is calculated.',
    `payment_method` STRING COMMENT 'Method by which net pay is disbursed to the employee. Indicates the payment instrument used for compensation delivery.. Valid values are `direct_deposit|paper_check|paycard|cash`',
    `payroll_status` STRING COMMENT 'Current processing status of the payroll record in the payroll workflow lifecycle. Tracks progression from calculation through final payment.. Valid values are `calculated|approved|paid|voided|pending|error`',
    `processed_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll record was calculated and processed by the payroll system. Represents the payroll run execution time.',
    `regular_hours_worked` DECIMAL(18,2) COMMENT 'Total number of regular hours worked during the pay period, excluding overtime. Standard work hours at base pay rate.',
    `regular_pay_amount` DECIMAL(18,2) COMMENT 'Gross compensation for regular hours worked at the employees base pay rate. Does not include overtime, bonuses, or other supplemental pay.',
    `retirement_contribution_amount` DECIMAL(18,2) COMMENT 'Employee contribution to retirement savings plan such as 401(k) or 403(b). Pre-tax deferral reducing taxable income.',
    `shift_differential_pay_amount` DECIMAL(18,2) COMMENT 'Additional compensation paid for working non-standard shifts such as evening, night, or weekend shifts. Premium pay for less desirable work hours.',
    `state_tax_withheld_amount` DECIMAL(18,2) COMMENT 'State income tax withheld from gross pay based on state withholding requirements and employee elections.',
    `total_deductions_amount` DECIMAL(18,2) COMMENT 'Sum of all deductions from gross pay including taxes, benefits, garnishments, and other withholdings.',
    `year_to_date_federal_tax_withheld_amount` DECIMAL(18,2) COMMENT 'Cumulative federal income tax withheld from the beginning of the calendar year through this pay period. Used for W-2 Box 2 reporting.',
    `year_to_date_gross_pay_amount` DECIMAL(18,2) COMMENT 'Cumulative gross pay for the employee from the beginning of the calendar year through this pay period. Used for tax reporting and W-2 preparation.',
    CONSTRAINT pk_payroll_record PRIMARY KEY(`payroll_record_id`)
) COMMENT 'Payroll processing records for each associate per pay period sourced from Workday HCM Payroll. Captures gross pay, net pay, regular pay, overtime pay, shift differential pay, bonus pay, commission pay, total deductions, federal tax withheld, state tax withheld, FICA withheld, benefits deductions, garnishments, pay period start and end dates, pay date, payment method (direct deposit, check), bank account last four digits, payroll run ID, and payroll status (calculated, approved, paid, voided).';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`leave_request` (
    `leave_request_id` BIGINT COMMENT 'Unique identifier for the leave request record. Primary key for the leave request entity.',
    `cost_center_id` BIGINT COMMENT 'Unique identifier of the cost center to which the employees labor costs are allocated. Used for financial reporting, labor cost forecasting, and budget variance analysis during leave periods.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC associates request leave tied to their facility for workforce planning and coverage management. Supervisors need facility-level leave visibility to ensure adequate staffing for warehouse operations',
    `org_unit_id` BIGINT COMMENT 'Unique identifier of the employees department at the time of leave request. Used for labor cost allocation, departmental absence reporting, and workforce analytics.',
    `associate_id` BIGINT COMMENT 'Unique identifier of the employee submitting the leave request. Links to the employee master record in Workday HCM.',
    `shift_schedule_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_schedule. Business justification: Leave requests impact scheduled shifts and require coverage planning. When an associate requests leave, workforce scheduling systems need to identify which specific shifts are affected to trigger cove',
    `tertiary_leave_hr_reviewer_associate_id` BIGINT COMMENT 'Unique identifier of the HR representative who reviewed the leave request. Links to the employee master record. Used for compliance audit trail and case management.',
    `location_id` BIGINT COMMENT 'Unique identifier of the employees primary work location (store, distribution center, or corporate office) at the time of leave request. Used for workforce planning, coverage scheduling, and regional compliance reporting.',
    `actual_return_date` DATE COMMENT 'The actual date the employee returned to work, as recorded in time and attendance systems. May differ from scheduled return to work date if leave was extended or employee returned early. Used for compliance tracking and leave reconciliation.',
    `approval_comments` STRING COMMENT 'Free-text comments or notes entered by the approving manager or HR during the approval process. May include reasons for denial, conditions of approval, or special instructions.',
    `approval_date` DATE COMMENT 'Date when the leave request was approved or denied by the manager or HR. Used for SLA tracking and audit purposes.',
    `approval_status` STRING COMMENT 'Current approval state of the leave request in the workflow. Pending indicates awaiting manager or HR review, Approved indicates authorization granted, Denied indicates rejection, Cancelled indicates revoked after approval, Withdrawn indicates employee retracted the request.. Valid values are `Pending|Approved|Denied|Cancelled|Withdrawn`',
    `approved_end_date` DATE COMMENT 'The last date of absence as approved by the manager or HR. May differ from requested end date if the request was modified during approval process. May be null for open-ended or intermittent leave.',
    `approved_start_date` DATE COMMENT 'The first date of absence as approved by the manager or HR. May differ from requested start date if the request was modified during approval process.',
    `fmla_designation_status` STRING COMMENT 'Indicates whether the leave has been officially designated as FMLA-qualifying by HR. Not Applicable for non-FMLA leave types, Pending for under review, Designated for confirmed FMLA protection, Not Designated for ineligible requests.. Valid values are `Not Applicable|Pending|Designated|Not Designated`',
    `fmla_eligible_flag` BOOLEAN COMMENT 'Indicates whether the employee is eligible for FMLA protection for this leave request. True if the employee meets FMLA eligibility criteria (12 months tenure, 1250 hours worked, employer size). Used for compliance reporting and employee rights protection.',
    `hr_review_date` DATE COMMENT 'Date when the HR review was completed. Used for compliance tracking and SLA monitoring.',
    `hr_review_notes` STRING COMMENT 'Confidential notes entered by HR during the review process. May include compliance assessments, accommodation considerations, or legal consultation notes. Restricted access for HR personnel only.',
    `hr_review_status` STRING COMMENT 'Indicates whether HR review is required and the current state of that review. Not Required for standard leave, Pending for awaiting HR input, Reviewed for completed HR assessment, Escalated for complex cases requiring senior HR intervention.. Valid values are `Not Required|Pending|Reviewed|Escalated`',
    `intermittent_leave_flag` BOOLEAN COMMENT 'Indicates whether this is an intermittent leave request (sporadic absences rather than continuous block). True for intermittent FMLA, chronic condition management, or flexible leave arrangements. Affects scheduling and leave balance tracking.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the leave request record was last updated. Captures any changes to dates, status, or other attributes. Used for audit trail and change tracking.',
    `leave_balance_after` DECIMAL(18,2) COMMENT 'Employees projected leave balance (in hours or days) after this leave request is approved and processed. Calculated as balance before minus approved hours/days. Used for employee self-service visibility and planning.',
    `leave_balance_before` DECIMAL(18,2) COMMENT 'Employees available leave balance (in hours or days) before this leave request is processed. Used for validation that sufficient balance exists and for audit trail of balance changes.',
    `leave_reason` STRING COMMENT 'Free-text explanation or justification for the leave request provided by the employee. May contain sensitive personal or medical information. Used for HR review and compliance documentation.',
    `leave_request_number` STRING COMMENT 'Human-readable business identifier for the leave request, typically generated by Workday HCM Absence Management module. Used for tracking and reference in HR communications.',
    `leave_subtype` STRING COMMENT 'Detailed classification within the leave type. For example, FMLA may have subtypes like Birth/Adoption, Serious Health Condition, Military Caregiver. Provides granular categorization for compliance and reporting.',
    `leave_type` STRING COMMENT 'Category of leave being requested. PTO (Paid Time Off) for vacation, Sick for illness, FMLA (Family and Medical Leave Act) for qualifying medical/family reasons, Bereavement for family death, Jury Duty for court service, Military for service obligations, Personal for other approved absences. [ENUM-REF-CANDIDATE: PTO|Sick|FMLA|Bereavement|Jury Duty|Military|Personal — 7 candidates stripped; promote to reference product]',
    `medical_certification_due_date` DATE COMMENT 'Deadline by which medical certification must be submitted to HR. Typically 15 calendar days from leave request submission per FMLA regulations. Used for compliance tracking and employee notification.',
    `medical_certification_received_flag` BOOLEAN COMMENT 'Indicates whether required medical certification has been received and validated by HR. True when documentation is on file and approved. Used for compliance audit trail and approval workflow gating.',
    `medical_certification_required_flag` BOOLEAN COMMENT 'Indicates whether medical certification documentation is required for this leave request. True for FMLA, medical leave, or extended sick leave requiring physician documentation. Used for compliance enforcement and case management.',
    `paid_leave_flag` BOOLEAN COMMENT 'Indicates whether the leave is paid (using accrued PTO balance or paid leave benefits) or unpaid. True for paid leave, False for unpaid leave. Affects payroll processing and leave balance deductions.',
    `reduced_schedule_flag` BOOLEAN COMMENT 'Indicates whether this leave involves a reduced work schedule (working fewer hours per day or days per week) rather than full absence. True for part-time return-to-work arrangements or phased leave. Used for scheduling and labor cost allocation.',
    `request_submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the leave request was originally submitted by the employee through Workday HCM self-service. Used for SLA tracking, audit trail, and advance notice compliance.',
    `requested_end_date` DATE COMMENT 'The last date of absence requested by the employee. Represents the end of the leave period as initially submitted. May be null for open-ended or intermittent leave.',
    `requested_start_date` DATE COMMENT 'The first date of absence requested by the employee. Represents the beginning of the leave period as initially submitted.',
    `return_to_work_date` DATE COMMENT 'The date the employee is scheduled to return to work following the leave. May be the day after approved end date or a later date for extended leave. Used for workforce planning and scheduling.',
    `source_system_record_code` STRING COMMENT 'Unique identifier of this leave request in the source system (Workday HCM). Used for data reconciliation, audit trail, and bidirectional integration with operational systems.',
    `total_days_approved` DECIMAL(18,2) COMMENT 'Total number of calendar or business days approved by the manager or HR for this leave. May differ from total days requested if the request was partially approved or modified. May include partial days for intermittent leave.',
    `total_days_requested` DECIMAL(18,2) COMMENT 'Total number of calendar or business days requested by the employee for this leave. Calculated based on requested start and end dates, accounting for work schedule and holidays. May include partial days for intermittent leave.',
    `total_hours_approved` DECIMAL(18,2) COMMENT 'Total number of work hours approved for this leave. Used for leave balance deduction and payroll processing. May differ from total hours requested if the request was modified during approval.',
    `total_hours_requested` DECIMAL(18,2) COMMENT 'Total number of work hours requested for this leave. Used for precise leave balance calculations and labor cost forecasting. Particularly important for part-time employees and intermittent leave.',
    CONSTRAINT pk_leave_request PRIMARY KEY(`leave_request_id`)
) COMMENT 'Employee leave and absence management records processed through Workday HCM Absence Management. Captures leave type (FMLA, PTO, sick, bereavement, jury duty, military, personal), requested start date, requested end date, approved start date, approved end date, total days requested, total days approved, leave reason, FMLA eligibility flag, intermittent leave flag, approval status, approving manager, HR review status, return-to-work date, and any leave balance impact. Supports FMLA compliance and labor cost forecasting.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` (
    `benefit_enrollment_id` BIGINT COMMENT 'Unique identifier for the benefit enrollment record. Primary key for the benefit enrollment entity.',
    `associate_id` BIGINT COMMENT 'Unique identifier for the employee who enrolled in the benefit. Links to the employee master record in Workday HCM.',
    `financial_period_id` BIGINT COMMENT 'add column financial_period_id (BIGINT) with FK to finance.financial_period.financial_period_id - benefit enrollments have effective periods that align to financial periods for cost accrual',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Benefit eligibility rules and plan offerings vary by job classification (full-time vs part-time, executive vs hourly, union vs non-union). Linking benefit_enrollment to job_profile enables benefits ad',
    `aca_1095c_offer_code` STRING COMMENT 'The IRS code indicating the type of health coverage offered to the employee for ACA reporting. Examples: 1A (qualifying offer), 1B (employee only), 1C (employee and dependents), 1E (no offer). Required for annual 1095-C filing.. Valid values are `^1[A-J]$|^$`',
    `aca_1095c_safe_harbor_code` STRING COMMENT 'The IRS code indicating the safe harbor method used to determine ACA affordability. Examples: 2A (W-2 wages), 2B (rate of pay), 2C (federal poverty line). Used to avoid employer shared responsibility penalties.. Valid values are `^2[A-H]$|^$`',
    `aca_eligible_flag` BOOLEAN COMMENT 'Indicates whether the employee is eligible for ACA-compliant health coverage based on full-time equivalent (FTE) hours worked during the measurement period. True if employee averaged 30+ hours per week. Used for 1095-C reporting.',
    `aca_measurement_period_end` DATE COMMENT 'The end date of the measurement period used to determine ACA eligibility. Follows the start date by 12 months for standard measurement periods.',
    `aca_measurement_period_start` DATE COMMENT 'The start date of the measurement period used to determine ACA eligibility. Typically a 12-month lookback period (e.g., October 1 to September 30) used to calculate average hours worked.',
    `aca_stability_period_end` DATE COMMENT 'The end date of the stability period during which the employees ACA eligibility determination remains in effect. Typically December 31 of the plan year.',
    `aca_stability_period_start` DATE COMMENT 'The start date of the stability period during which the employees ACA eligibility determination remains in effect. Typically follows the measurement period and aligns with the plan year (e.g., January 1).',
    `annual_election_amount` DECIMAL(18,2) COMMENT 'For benefits with annual election limits (FSA, HSA, 401k), this is the total amount the employee elected to contribute for the plan year. Subject to IRS annual limits. Nullable for benefits without annual elections.',
    `beneficiary_name` STRING COMMENT 'The full legal name of the primary beneficiary designated for life insurance or retirement benefits. Nullable for benefits without beneficiary designations (e.g., health insurance). Contains personally identifiable information.',
    `beneficiary_relationship` STRING COMMENT 'The relationship of the designated beneficiary to the employee. Used for life insurance and retirement plan beneficiary designations. Not applicable for health benefits. [ENUM-REF-CANDIDATE: spouse|child|parent|sibling|domestic_partner|other|not_applicable — 7 candidates stripped; promote to reference product]',
    `benefit_type` STRING COMMENT 'Category of benefit plan enrolled. Includes medical, dental, vision, 401k retirement, FSA (Flexible Spending Account), HSA (Health Savings Account), life insurance, disability, ESPP (Employee Stock Purchase Plan), and commuter benefits. [ENUM-REF-CANDIDATE: medical|dental|vision|life_insurance|disability|401k|fsa|hsa|espp|commuter|other — 11 candidates stripped; promote to reference product]',
    `carrier_policy_number` STRING COMMENT 'The policy or group number assigned by the insurance carrier or benefit provider. Used for claims processing and coordination of benefits. Nullable for self-insured plans or benefits without external carriers.',
    `cobra_eligible_flag` BOOLEAN COMMENT 'Indicates whether the employee is eligible for COBRA continuation coverage upon termination of employment or loss of coverage. True if the employee was enrolled in a group health plan and experienced a qualifying event.',
    `coverage_tier` STRING COMMENT 'The level of coverage elected by the employee. Determines premium rates and dependent coverage. Not applicable for non-health benefits like 401k or FSA.. Valid values are `employee_only|employee_spouse|employee_children|employee_family|not_applicable`',
    `employee_contribution_amount` DECIMAL(18,2) COMMENT 'The per-pay-period amount deducted from the employees paycheck for this benefit. For percentage-based contributions (e.g., 401k), this is the dollar amount per pay period, not the percentage. Currency is USD unless otherwise specified in organizational standards.',
    `employee_contribution_frequency` STRING COMMENT 'The frequency at which employee contributions are deducted from payroll. Aligns with the organizations payroll schedule. Per pay period is the most common for retail associates with varying schedules.. Valid values are `weekly|biweekly|semimonthly|monthly|annual|per_pay_period`',
    `employer_contribution_amount` DECIMAL(18,2) COMMENT 'The per-pay-period amount contributed by the employer toward this benefit. For 401k, this may include employer match. For health insurance, this is the employer subsidy. Currency is USD unless otherwise specified.',
    `employer_contribution_frequency` STRING COMMENT 'The frequency at which employer contributions are made toward this benefit. Typically aligns with payroll frequency.. Valid values are `weekly|biweekly|semimonthly|monthly|annual|per_pay_period`',
    `enrollment_confirmation_number` STRING COMMENT 'A unique confirmation or transaction number generated when the employee completes the enrollment process. Used for audit trail and employee inquiries. May be system-generated or carrier-provided.',
    `enrollment_effective_date` DATE COMMENT 'The date on which the benefit coverage begins. For new hires, typically the hire date or first of the month following hire. For open enrollment, typically January 1st of the plan year.',
    `enrollment_method` STRING COMMENT 'The channel or method through which the employee completed the benefit enrollment. Online self-service is the most common for retail employees. Auto-enrollment applies to default 401k enrollments under safe harbor provisions.. Valid values are `online_self_service|paper_form|phone|hr_representative|auto_enrollment|default`',
    `enrollment_source` STRING COMMENT 'The event or process that triggered this benefit enrollment. Open enrollment is the annual election period. Qualifying life event (QLE) includes marriage, birth, adoption, loss of other coverage. New hire is initial enrollment upon employment. Administrative correction is a system adjustment. COBRA is continuation coverage after termination.. Valid values are `open_enrollment|new_hire|qualifying_life_event|administrative_correction|rehire|cobra`',
    `enrollment_status` STRING COMMENT 'Current lifecycle status of the benefit enrollment. Active indicates coverage is in force. Terminated indicates coverage has ended. Pending indicates enrollment is awaiting approval. Waived indicates employee declined coverage. Suspended indicates temporary hold. Cancelled indicates enrollment was voided.. Valid values are `active|terminated|pending|waived|suspended|cancelled`',
    `enrollment_termination_date` DATE COMMENT 'The date on which the benefit coverage ends. Nullable for active enrollments. Populated upon employee termination, plan change, or voluntary cancellation. For COBRA purposes, typically the last day of the month of termination.',
    `enrollment_timestamp` TIMESTAMP COMMENT 'The date and time when the employee submitted the benefit enrollment election. Used for audit trail and to validate enrollment within the allowed election window (e.g., 30 days from hire or QLE).',
    `last_modified_by` STRING COMMENT 'The user ID or name of the person who last modified this enrollment record. May be the employee (self-service), an HR representative, or a system administrator. Used for audit trail and compliance.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this enrollment record was last updated. Captures changes to coverage tier, contribution amounts, status, or administrative corrections. Used for audit trail and data lineage.',
    `plan_name` STRING COMMENT 'The full name of the benefit plan as presented to employees during enrollment. Examples: PPO Gold Plan, HDHP Silver Plan, Basic Life Insurance, 401k Traditional.',
    `plan_year` STRING COMMENT 'The calendar year for which this benefit enrollment is effective. Typically aligns with open enrollment periods and ACA measurement periods.. Valid values are `^d{4}$`',
    `qualifying_life_event_date` DATE COMMENT 'The date on which the qualifying life event occurred. Used to validate the 30-day or 60-day election window for mid-year changes. Nullable if not applicable.',
    `qualifying_life_event_type` STRING COMMENT 'The specific type of qualifying life event that permitted mid-year enrollment change. Only populated when enrollment_source is qualifying_life_event. Examples include marriage, divorce, birth of child, adoption, death of dependent, loss of other coverage, or change in employment status. [ENUM-REF-CANDIDATE: marriage|divorce|birth|adoption|death|loss_of_coverage|employment_change|other|not_applicable — 9 candidates stripped; promote to reference product]',
    `source_system_record_code` STRING COMMENT 'The unique identifier for this enrollment record in the source system (e.g., Workday HCM). Used for reconciliation, data lineage, and troubleshooting. Enables traceability back to the operational system.',
    `total_premium_amount` DECIMAL(18,2) COMMENT 'The total per-pay-period cost of the benefit, combining employee and employer contributions. Used for ACA affordability calculations and financial reporting. Currency is USD unless otherwise specified.',
    `waiver_reason` STRING COMMENT 'The reason provided by the employee for waiving or declining benefit coverage. Only populated when enrollment_status is waived. Common reasons include coverage through spouse, parent, Medicare, Medicaid, or cost concerns. [ENUM-REF-CANDIDATE: covered_by_spouse|covered_by_parent|medicare|medicaid|other_coverage|cost|not_needed|other|not_applicable — 9 candidates stripped; promote to reference product]',
    CONSTRAINT pk_benefit_enrollment PRIMARY KEY(`benefit_enrollment_id`)
) COMMENT 'Employee benefits enrollment records capturing active and historical benefit elections per associate per plan year. Sourced from Workday HCM Benefits. Captures benefit plan type (medical, dental, vision, 401k, FSA, HSA, life insurance, disability, ESPP), plan name, coverage tier (employee only, employee + spouse, family), enrollment effective date, termination date, employee contribution amount, employer contribution amount, enrollment source (open enrollment, qualifying life event, new hire), enrollment status, ACA eligibility determination (full-time equivalent hours tracking, measurement period, stability period), and ACA reporting indicators (1095-C offer code, safe harbor code). Supports benefits administration, open enrollment processing, qualifying life event management, and Affordable Care Act compliance reporting.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`performance_review` (
    `performance_review_id` BIGINT COMMENT 'Unique identifier for the performance review or disciplinary action record. Primary key for the performance management system.',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Performance evaluation criteria, competency frameworks, and rating scales vary by job_profile. Store associates are evaluated on customer service metrics; DC staff on productivity and safety; managers',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Performance management KPIs (review completion rate, rating distribution, calibration compliance) are calculated from performance review records. HR analytics dashboards measure these metrics per revi',
    `associate_id` BIGINT COMMENT 'Unique identifier of the retail associate, manager, or corporate employee being reviewed or subject to disciplinary action.',
    `tertiary_performance_hr_reviewer_associate_id` BIGINT COMMENT 'Unique identifier of the HR business partner or HR manager who reviewed and approved the disciplinary action for compliance and consistency.',
    `acknowledgment_date` DATE COMMENT 'Date the employee signed or electronically acknowledged the performance review or disciplinary action document.',
    `action_type` STRING COMMENT 'Discriminator indicating whether this record is a performance review or a disciplinary/corrective action (verbal warning, written warning, final written warning, suspension, termination).. Valid values are `performance_review|verbal_warning|written_warning|final_warning|suspension|termination`',
    `appeal_filed_flag` BOOLEAN COMMENT 'Boolean indicator of whether the employee has filed a formal appeal or grievance challenging the performance review rating or disciplinary action.',
    `appeal_outcome` STRING COMMENT 'Outcome of the employees appeal or grievance: upheld (original decision stands), overturned (decision reversed), modified (decision adjusted), or pending review.. Valid values are `upheld|overturned|modified|pending`',
    `calibration_date` DATE COMMENT 'Date the performance rating was calibrated and approved by senior leadership during the talent review process.',
    `calibration_status` STRING COMMENT 'Status of the talent calibration process where ratings are reviewed and normalized across the organization to ensure fairness and consistency.. Valid values are `pending|calibrated|approved|rejected`',
    `competency_rating` STRING COMMENT 'Rating of the employees demonstration of core competencies (e.g., customer service, teamwork, leadership, communication) during the review period.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the performance review or disciplinary action record was first created in the Workday HCM system.',
    `employee_acknowledgment_flag` BOOLEAN COMMENT 'Boolean indicator of whether the employee has acknowledged receipt and understanding of the performance review or disciplinary action.',
    `expiration_date` DATE COMMENT 'Date the disciplinary action expires and is removed from the employees active record per the progressive discipline policy (typically 6-12 months for warnings).',
    `goal_achievement_rating` STRING COMMENT 'Rating of the employees achievement of performance goals and objectives set at the beginning of the review period.. Valid values are `exceeded|achieved|partially_achieved|not_achieved`',
    `hr_review_status` STRING COMMENT 'Status of HR review and approval of the disciplinary action to ensure compliance with labor laws and company policy.. Valid values are `pending|approved|rejected|under_review`',
    `incident_description` STRING COMMENT 'Detailed narrative description of the incident or behavior that led to the disciplinary action, including date, time, location, and witnesses.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the performance review or disciplinary action record was last updated or modified in the Workday HCM system.',
    `manager_comments` STRING COMMENT 'Detailed narrative comments from the manager regarding the employees performance, strengths, areas for improvement, and development recommendations.',
    `merit_increase_eligible_flag` BOOLEAN COMMENT 'Boolean indicator of whether the employee is eligible for a merit-based salary increase based on their performance rating.',
    `merit_increase_percentage` DECIMAL(18,2) COMMENT 'Percentage salary increase awarded to the employee based on their performance rating (e.g., 3.50 for 3.5% increase).',
    `overall_rating` STRING COMMENT 'Overall performance rating assigned to the employee for the review period: exceeds expectations, meets expectations, needs improvement, or unsatisfactory.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory`',
    `overall_rating_score` DECIMAL(18,2) COMMENT 'Numeric score corresponding to the overall rating (e.g., 1.00 to 5.00 scale) used for merit increase calculations and talent calibration.',
    `performance_review_status` STRING COMMENT 'Current workflow status of the performance review or disciplinary action record: draft, submitted for approval, approved, completed, or cancelled.. Valid values are `draft|submitted|approved|completed|cancelled`',
    `pip_end_date` DATE COMMENT 'Target end date of the Performance Improvement Plan by which the employee must demonstrate improvement.',
    `pip_flag` BOOLEAN COMMENT 'Boolean indicator of whether the employee has been placed on a Performance Improvement Plan due to unsatisfactory performance.',
    `pip_start_date` DATE COMMENT 'Start date of the Performance Improvement Plan if the employee has been placed on a PIP.',
    `policy_violation_category` STRING COMMENT 'Category of policy violation that triggered the disciplinary action: attendance, conduct, safety (OSHA), theft/shrinkage, harassment, or insubordination.. Valid values are `attendance|conduct|safety|theft|harassment|insubordination`',
    `prior_actions_count` STRING COMMENT 'Count of prior disciplinary actions taken against this employee within the progressive discipline sequence (used to determine escalation level).',
    `progressive_discipline_sequence` STRING COMMENT 'Sequence number in the progressive discipline process (1=first warning, 2=second warning, etc.) used to track escalation toward termination.',
    `promotion_recommended_flag` BOOLEAN COMMENT 'Boolean indicator of whether the manager recommends the employee for promotion based on their performance and readiness for increased responsibility.',
    `review_date` DATE COMMENT 'Date the performance review or disciplinary action was conducted and documented.',
    `review_period_end_date` DATE COMMENT 'End date of the performance period being evaluated (e.g., December 31 for annual reviews).',
    `review_period_start_date` DATE COMMENT 'Start date of the performance period being evaluated (e.g., January 1 for annual reviews).',
    `review_type` STRING COMMENT 'Type of performance review cycle: annual review, mid-year check-in, probationary review, 90-day new hire review, project-based review, or Performance Improvement Plan (PIP).. Valid values are `annual|mid_year|probationary|90_day|project_based|pip`',
    `self_assessment_comments` STRING COMMENT 'Employees self-assessment narrative describing their accomplishments, challenges, and development goals for the review period.',
    `termination_recommended_flag` BOOLEAN COMMENT 'Boolean indicator of whether the manager or HR recommends termination of employment based on the severity of the incident or failure to improve performance.',
    CONSTRAINT pk_performance_review PRIMARY KEY(`performance_review_id`)
) COMMENT 'Comprehensive performance management and progressive discipline records for retail associates and managers, serving as the single source of truth for all formal evaluations and corrective actions. For performance reviews: captures review cycle (annual, mid-year, probationary, 90-day), review period, overall performance rating, goal ratings, competency ratings, manager comments, self-assessment, calibration status, merit increase eligibility, and promotion recommendation. For disciplinary and corrective actions: captures action type (verbal warning, written warning, final written warning, suspension, termination), action date, policy violation category, incident description, prior actions count, progressive discipline sequence, action issued by manager, HR review status, associate acknowledgment flag, acknowledgment date, appeal filed flag, appeal outcome, and expiration date. Processed through Workday HCM Performance Management. Supports talent calibration, merit increase processing, PIP tracking, progressive discipline documentation, termination defense, and labor relations compliance.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` (
    `training_enrollment_id` BIGINT COMMENT 'Unique identifier for the training enrollment record. Primary key.',
    `associate_id` BIGINT COMMENT 'Unique identifier of the employee enrolled in the training program. Links to the employee master record in Workday HCM.',
    `certification_id` BIGINT COMMENT 'Unique identifier of the certification or license earned upon successful completion of this training. Null if no certification is associated with this training.',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Training requirements are job-profile-specific: forklift certification for DC operators, food handler permits for deli associates, leadership training for managers. The training_enrollment table has m',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Training effectiveness KPIs (completion rate, time-to-certify, pass rate) are measured from training enrollment records. Compliance and L&D analytics track these metrics per enrollment for regulatory',
    `training_program_id` BIGINT COMMENT 'Unique identifier of the training program or course in which the employee is enrolled.',
    `actual_completion_date` DATE COMMENT 'Actual date when the employee completed the training program. Null if training is not yet completed.',
    `actual_start_date` DATE COMMENT 'Actual date when the employee began the training program. May differ from scheduled start date due to operational constraints or employee availability.',
    `attempt_number` STRING COMMENT 'Number of times the employee has attempted this training program. Increments with each failed attempt and re-enrollment.',
    `certification_earned_flag` BOOLEAN COMMENT 'Indicates whether successful completion of this training results in a professional certification or license (True = certification earned, False = no certification).',
    `completion_status` STRING COMMENT 'Current lifecycle status of the training enrollment (enrolled, in-progress, completed, failed, withdrawn, expired, waived). Tracks progression through the training lifecycle. [ENUM-REF-CANDIDATE: enrolled|in_progress|completed|failed|withdrawn|expired|waived — 7 candidates stripped; promote to reference product]',
    `compliance_training_flag` BOOLEAN COMMENT 'Indicates whether this training is required for regulatory compliance (True = compliance training, False = non-compliance training). Used for OSHA, FDA, and other regulatory audit trails.',
    `cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred for this training enrollment, including instructor fees, materials, facility costs, and employee time. Expressed in the companys reporting currency (USD).',
    `cost_center_code` STRING COMMENT 'Cost center to which the training expense is allocated. Used for financial planning and labor cost management.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was first created in the system. Used for audit trail and data lineage tracking.',
    `delivery_method` STRING COMMENT 'Method by which the training is delivered to the associate (in-store, e-learning, classroom, on-the-job, virtual instructor-led, blended).. Valid values are `in_store|e_learning|classroom|on_the_job|virtual_instructor_led|blended`',
    `due_date` DATE COMMENT 'Hard deadline by which the training must be completed to maintain compliance or role eligibility. Used for escalation and reminder workflows.',
    `enrollment_date` DATE COMMENT 'Date when the employee was enrolled in the training program. Represents the business event timestamp for this enrollment transaction.',
    `enrollment_source` STRING COMMENT 'Indicates how the employee was enrolled in the training (manager-assigned, self-enrolled, HR-assigned, system-triggered based on role change, onboarding workflow).. Valid values are `manager_assigned|self_enrolled|hr_assigned|system_triggered|onboarding_workflow`',
    `feedback_comments` STRING COMMENT 'Free-text comments provided by the employee about their training experience. Used for qualitative analysis and program improvement.',
    `feedback_rating` STRING COMMENT 'Employees satisfaction rating for the training program, typically on a scale of 1 to 5. Used for training program quality improvement.',
    `instructor_name` STRING COMMENT 'Name of the instructor or facilitator who delivered the training. Null for self-paced e-learning programs.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was last updated. Used for audit trail and change tracking.',
    `mandatory_training_flag` BOOLEAN COMMENT 'Indicates whether this training is mandatory for the employee based on their role, location, or regulatory requirements (True = mandatory, False = optional).',
    `overdue_flag` BOOLEAN COMMENT 'Indicates whether the training is past its due date and not yet completed (True = overdue, False = on time or completed).',
    `pass_fail_indicator` STRING COMMENT 'Indicates whether the employee passed or failed the training program. Not applicable for non-assessed training.. Valid values are `pass|fail|not_applicable`',
    `passing_score_threshold` DECIMAL(18,2) COMMENT 'Minimum score required to pass the training program, expressed as a percentage (0.00 to 100.00). Used to determine pass/fail status.',
    `scheduled_completion_date` DATE COMMENT 'Target date by which the employee is expected to complete the training program. Used for compliance tracking and onboarding milestone monitoring.',
    `scheduled_start_date` DATE COMMENT 'Planned date when the employee is expected to begin the training program.',
    `score` DECIMAL(18,2) COMMENT 'Numeric score achieved by the employee on the training assessment, typically expressed as a percentage (0.00 to 100.00). Null if training is not scored.',
    `training_duration_hours` DECIMAL(18,2) COMMENT 'Total duration of the training program in hours. Used for labor cost allocation and compliance reporting.',
    `training_location` STRING COMMENT 'Physical or virtual location where the training was conducted (e.g., store number, distribution center, corporate training facility, online platform).',
    `training_type` STRING COMMENT 'Category of training program indicating its primary purpose (onboarding, compliance, product knowledge, safety, leadership, POS operations, customer service, technical skills, soft skills). [ENUM-REF-CANDIDATE: onboarding|compliance|product_knowledge|safety|leadership|pos_operations|customer_service|technical_skills|soft_skills — 9 candidates stripped; promote to reference product]',
    `waiver_approval_date` DATE COMMENT 'Date when the training waiver was approved. Null if not waived.',
    `waiver_approved_by` STRING COMMENT 'Name or employee ID of the manager or HR representative who approved the training waiver. Null if not waived.',
    `waiver_reason` STRING COMMENT 'Explanation for why the training requirement was waived for this employee (e.g., prior certification, equivalent experience, role exemption). Null if not waived.',
    CONSTRAINT pk_training_enrollment PRIMARY KEY(`training_enrollment_id`)
) COMMENT 'Single source of truth for associate learning activity, training program enrollment, completion tracking, and professional certification/license management across the retail organization. For training activity: captures training program name, training type (onboarding, compliance, product knowledge, safety, leadership, POS operations), delivery method (in-store, e-learning, classroom, on-the-job), enrollment date, scheduled completion date, actual completion date, completion status (enrolled, in-progress, completed, failed, expired), pass/fail score, and mandatory training flag. For certifications and licenses: captures certification type, issuing authority, certification number, issue date, expiration date, renewal required flag, renewal reminder date, certification status (active, expired, suspended), and verification method. Covers all retail-specific credentials including food handler, forklift operator, pharmacy technician, hazmat handling, and first aid/CPR certifications. Supports OSHA compliance, regulatory audits, role eligibility gating, onboarding completion tracking, and associate development planning.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`requisition` (
    `requisition_id` BIGINT COMMENT 'Unique identifier for the job requisition record. Primary key.',
    `cost_center_id` BIGINT COMMENT 'Reference to the financial cost center that will absorb the labor cost for this position. Links to labor budget and headcount planning.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC hiring requisitions target specific facilities for headcount planning and recruitment. Facility managers create requisitions for warehouse roles; HR and finance track facility-level hiring against',
    `location_id` BIGINT COMMENT 'Reference to the physical location where the hired employee will be assigned (store, distribution center, corporate office, regional hub).',
    `job_profile_id` BIGINT COMMENT 'Reference to the standardized job profile defining role responsibilities, competencies, and requirements for this requisition.',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Recruiting KPIs (time-to-fill, cost-per-hire, offer acceptance rate) are calculated from requisition lifecycle data. Talent acquisition analytics measure these metrics per requisition for hiring effic',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Requisitions are opened for specific organizational units (stores, DCs, corporate departments). Talent acquisition needs to track open positions by org unit for headcount planning and budget allocatio',
    `associate_id` BIGINT COMMENT 'Reference to the employee who is the hiring manager responsible for this requisition, including interview participation and final hiring decision.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Store hiring requisitions require profit center assignment for headcount planning and labor cost impact forecasting. Critical for retail store expansion planning, new store opening budgets, and season',
    `approved_headcount` STRING COMMENT 'Number of positions approved to be filled under this requisition. Typically 1 for individual roles, may be higher for bulk seasonal hiring or store opening events.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this requisition was approved by the appropriate authority (hiring manager, HR, finance) and authorized to proceed to active recruiting. Used for approval cycle time analytics.',
    `budgeted_salary_max` DECIMAL(18,2) COMMENT 'Maximum approved salary or hourly rate for this position based on compensation band and market benchmarking. Used for offer negotiation and budget compliance.',
    `budgeted_salary_min` DECIMAL(18,2) COMMENT 'Minimum approved salary or hourly rate for this position based on compensation band and market benchmarking. Used for offer negotiation and budget compliance.',
    `close_date` DATE COMMENT 'Date when the requisition was closed (filled, cancelled, or withdrawn). Used to calculate time-to-fill and requisition lifecycle analytics.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this requisition record was first created in the system. Used for audit trail and requisition lifecycle analytics.',
    `eeo_job_category` STRING COMMENT 'EEO-1 Component 1 job category classification required for federal diversity and equal opportunity reporting to EEOC and OFCCP (e.g., Executive/Senior Officials, Professionals, Sales Workers, Service Workers).',
    `employment_type` STRING COMMENT 'Classification of the employment arrangement for this position (full-time, part-time, seasonal, temporary, contractor) impacting benefits eligibility and labor cost modeling.. Valid values are `full_time|part_time|seasonal|temporary|contractor`',
    `flsa_status` STRING COMMENT 'Classification under FLSA determining overtime eligibility. Exempt positions are salaried and not eligible for overtime; non-exempt positions are eligible for overtime pay per FLSA regulations.. Valid values are `exempt|non_exempt`',
    `hiring_location_type` STRING COMMENT 'Classification of the hiring location to support location-specific recruiting strategies and labor market analysis.. Valid values are `store|distribution_center|corporate_office|regional_hub|fulfillment_center`',
    `is_remote_eligible` BOOLEAN COMMENT 'Indicates whether this position is eligible for remote or hybrid work arrangements. Used for candidate attraction and workspace planning.',
    `job_description` STRING COMMENT 'Detailed description of the role responsibilities, required qualifications, preferred skills, and working conditions. Used for job postings and candidate screening.',
    `job_family` STRING COMMENT 'Broad occupational category grouping similar roles for career pathing and compensation benchmarking (e.g., Retail Operations, Supply Chain, Merchandising, Finance, Technology).',
    `job_level` STRING COMMENT 'Hierarchical level of the position within the organization structure, used for compensation banding and reporting line determination. [ENUM-REF-CANDIDATE: entry|intermediate|senior|lead|manager|director|executive — 7 candidates stripped; promote to reference product]',
    `job_title` STRING COMMENT 'The official job title for the open position (e.g., Store Associate, Distribution Center Manager, Merchandise Planner).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this requisition record was last updated. Used for audit trail and change tracking.',
    `minimum_education_level` STRING COMMENT 'Minimum educational attainment required for this position (e.g., high school diploma, bachelors degree, masters degree). Used for candidate screening and compliance reporting.. Valid values are `none|high_school|associate|bachelor|master|doctorate`',
    `minimum_experience_years` STRING COMMENT 'Minimum number of years of relevant work experience required for this position. Used for candidate screening and job level determination.',
    `open_date` DATE COMMENT 'Date when the requisition was officially opened and active recruiting began. Used to calculate time-to-fill metrics.',
    `pay_frequency` STRING COMMENT 'Frequency at which the employee will be paid (hourly rate, weekly, biweekly, semimonthly, monthly, annual salary) aligning with payroll cycles and employment type.. Valid values are `hourly|weekly|biweekly|semimonthly|monthly|annual`',
    `positions_filled` STRING COMMENT 'Count of positions that have been successfully filled and closed under this requisition. Used to track progress toward approved headcount target.',
    `posting_title` STRING COMMENT 'External-facing job title used in job postings and career site listings, may differ from internal job title for candidate attraction and SEO optimization.',
    `priority_level` STRING COMMENT 'Business priority classification for this requisition indicating urgency and resource allocation (e.g., critical for store opening, high for key leadership role, medium for backfill, low for future pipeline building).. Valid values are `low|medium|high|critical`',
    `requires_background_check` BOOLEAN COMMENT 'Indicates whether this position requires a pre-employment background check per company policy or regulatory requirements (e.g., roles with financial access, management positions).',
    `requires_drug_screening` BOOLEAN COMMENT 'Indicates whether this position requires pre-employment drug screening per company policy or safety-sensitive role designation (e.g., distribution center equipment operators, drivers).',
    `requisition_number` STRING COMMENT 'Externally-known business identifier for the job requisition, typically formatted as REQ- followed by numeric sequence. Used for tracking and communication with hiring managers and candidates.. Valid values are `^REQ-[0-9]{6,10}$`',
    `requisition_status` STRING COMMENT 'Current lifecycle state of the requisition in the talent acquisition workflow. Tracks progression from draft through approval, active recruiting, and final disposition. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|open|on_hold|filled|cancelled|closed — 8 candidates stripped; promote to reference product]',
    `requisition_type` STRING COMMENT 'Classification of the requisition indicating whether it is filling a vacated position (backfill), adding new headcount, seasonal hiring, temporary assignment, contractor engagement, or internship program.. Valid values are `backfill|new_headcount|seasonal|temporary|contractor|intern`',
    `salary_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the budgeted salary range (e.g., USD, CAD, MXN) supporting multi-country retail operations.. Valid values are `^[A-Z]{3}$`',
    `sourcing_channels` STRING COMMENT 'Comma-separated list of authorized recruiting channels for this requisition (e.g., internal job board, LinkedIn, Indeed, campus recruiting, employee referral, staffing agency). Used for source-of-hire analytics.',
    `target_start_date` DATE COMMENT 'Desired or planned start date for the new hire to begin employment. Used for workforce planning and onboarding preparation.',
    `time_to_fill_sla_days` STRING COMMENT 'Target number of days to fill this requisition from open date to offer acceptance, based on role complexity and labor market conditions. Used for recruiter performance tracking.',
    `travel_requirement_pct` STRING COMMENT 'Expected percentage of time the role requires business travel (0-100). Used for candidate expectation setting and travel budget planning.',
    CONSTRAINT pk_requisition PRIMARY KEY(`requisition_id`)
) COMMENT 'Talent acquisition and open position requisition records managed through Workday HCM Recruiting. Captures requisition number, job profile, hiring location (store, DC, corporate), requisition type (backfill, new headcount, seasonal), target start date, approved headcount count, requisition status (draft, approved, open, on-hold, filled, cancelled), hiring manager, recruiter assigned, sourcing channels authorized, budgeted salary range, time-to-fill SLA target, and EEO job category for diversity reporting. Links to labor_budget for headcount planning alignment and supports OFCCP/EEO compliance tracking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`job_application` (
    `job_application_id` BIGINT COMMENT 'Unique identifier for the job application record. Primary key for the job application entity.',
    `candidate_id` BIGINT COMMENT 'Reference to the candidate master record who submitted this application. A single candidate may have multiple applications over time.',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Applications are for specific job profiles. While job_application links to requisition and requisition links to job_profile, direct linking from application to job_profile enables recruiting analytics',
    `location_id` BIGINT COMMENT 'Reference to the store, distribution center, or corporate office location where the position is based. Used for geographic hiring analytics and headcount planning.',
    `org_unit_id` BIGINT COMMENT 'Reference to the department or functional area for the position (e.g., Store Operations, Supply Chain, Merchandising, Finance). Supports departmental hiring metrics.',
    `associate_id` BIGINT COMMENT 'Reference to the HR recruiter or talent acquisition specialist assigned to manage this application and coordinate the hiring process.',
    `requisition_id` BIGINT COMMENT 'Reference to the open job requisition for which this application was submitted. Links to the job posting and hiring requirements.',
    `tertiary_job_modified_by_user_associate_id` BIGINT COMMENT 'User ID of the recruiter or system user who last modified the application record. Used for audit trail and accountability.',
    `application_date` DATE COMMENT 'The date when the candidate submitted the application. Used to calculate time-to-hire and track recruiting funnel velocity.',
    `application_notes` STRING COMMENT 'Free-text notes and comments from recruiters, hiring managers, and interviewers regarding the candidate and application. Used to document interview feedback and hiring decisions.',
    `application_number` STRING COMMENT 'Human-readable business identifier for the application, typically displayed to candidates and hiring managers. Format: APP-########.. Valid values are `^APP-[0-9]{8}$`',
    `application_status` STRING COMMENT 'Current lifecycle status of the application in the recruiting workflow. Tracks progression from initial submission through final disposition. [ENUM-REF-CANDIDATE: applied|screening|phone_screen|interview|offer|hired|rejected|withdrawn — 8 candidates stripped; promote to reference product]',
    `background_check_date` DATE COMMENT 'Date when the background check was completed. Used to track pre-employment screening cycle time and ensure timely onboarding.',
    `background_check_status` STRING COMMENT 'Current status of the pre-employment background check. Required for most retail positions to ensure workplace safety and regulatory compliance.. Valid values are `not_started|in_progress|clear|flagged|failed`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the application record was first created in the system. Used for audit trail and data lineage tracking.',
    `disability_status` STRING COMMENT 'Self-reported disability status of the candidate. Collected voluntarily for OFCCP compliance reporting and diversity analytics. Kept confidential from hiring managers.. Valid values are `not_disclosed|yes|no`',
    `drug_screen_date` DATE COMMENT 'Date when the drug screening test was completed. Used to track pre-employment screening compliance and onboarding readiness.',
    `drug_screen_status` STRING COMMENT 'Current status of the pre-employment drug screening test. Required for safety-sensitive positions such as distribution center equipment operators and drivers.. Valid values are `not_required|scheduled|completed|passed|failed`',
    `hire_date` DATE COMMENT 'The official start date when the candidate becomes an active employee. Marks the completion of the recruiting process and beginning of onboarding.',
    `interview_count` STRING COMMENT 'Total number of interviews conducted for this application. Used to analyze interview process efficiency and candidate experience.',
    `interview_stage` STRING COMMENT 'Current interview stage or round (e.g., Phone Screen, First Interview, Panel Interview, Final Interview). Tracks candidate progression through multi-stage interview processes.',
    `is_internal_candidate` BOOLEAN COMMENT 'Indicates whether the candidate is a current employee applying for an internal transfer or promotion. True for internal candidates, False for external candidates.',
    `is_rehire` BOOLEAN COMMENT 'Indicates whether the candidate is a former employee applying to return to the company. True for rehire candidates, False otherwise.',
    `last_interview_date` DATE COMMENT 'Date of the most recent interview conducted with the candidate. Used to track time between interview stages and overall process velocity.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the application record was last updated. Used for audit trail, change tracking, and incremental data processing.',
    `offer_acceptance_date` DATE COMMENT 'Date when the candidate formally accepted the job offer. Used to calculate offer-to-acceptance time and plan onboarding.',
    `offer_accepted_flag` BOOLEAN COMMENT 'Indicates whether the candidate accepted the job offer. True if accepted, False if declined or pending.',
    `offer_amount` DECIMAL(18,2) COMMENT 'The total compensation amount offered to the candidate, typically annual salary for salaried positions or hourly rate for hourly positions. Used for compensation benchmarking and budget planning.',
    `offer_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the offer amount (e.g., USD, CAD, MXN). Supports multi-country recruiting operations.. Valid values are `^[A-Z]{3}$`',
    `offer_date` DATE COMMENT 'Date when the job offer was formally extended to the candidate. Used to calculate time-to-offer and offer acceptance cycle time.',
    `offer_extended_flag` BOOLEAN COMMENT 'Indicates whether a formal job offer has been extended to the candidate. True if offer was made, False otherwise.',
    `rejection_date` DATE COMMENT 'Date when the application was formally rejected or withdrawn. Used to calculate time-to-rejection and maintain candidate communication SLAs.',
    `rejection_reason` STRING COMMENT 'Reason code or description for why the application was rejected (e.g., qualifications not met, failed interview, position filled, candidate withdrew). Used for recruiting process improvement and candidate experience analysis.',
    `source_channel` STRING COMMENT 'The channel or medium through which the candidate discovered and applied for the position. Used to calculate CAC (Candidate Acquisition Cost) by channel and optimize recruiting spend.. Valid values are `career_site|referral|job_board|agency|walk_in|social_media`',
    `source_detail` STRING COMMENT 'Additional detail about the application source, such as specific job board name (Indeed, LinkedIn), referrer employee ID, or agency name. Enables granular source attribution analysis.',
    `time_to_hire_days` STRING COMMENT 'Number of calendar days from application submission to hire date. Key recruiting efficiency KPI used to optimize talent acquisition processes and reduce vacancy costs.',
    `veteran_status` STRING COMMENT 'Self-reported veteran status of the candidate. Collected for OFCCP compliance reporting and veteran hiring program tracking.. Valid values are `not_disclosed|veteran|non_veteran|protected_veteran`',
    CONSTRAINT pk_job_application PRIMARY KEY(`job_application_id`)
) COMMENT 'Candidate application records for open requisitions tracked through Workday HCM Recruiting. Captures applicant name, application date, source channel (career site, referral, job board, agency, walk-in), application status (applied, screening, phone screen, interview, offer, hired, rejected, withdrawn), interview stage, offer extended flag, offer accepted flag, offer amount, background check status, drug screen status, and time-to-hire days. Supports CAC (Candidate Acquisition Cost) and recruiting funnel analytics.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`labor_budget` (
    `labor_budget_id` BIGINT COMMENT 'Unique identifier for the labor budget record. Primary key for the labor budget entity.',
    `cost_center_id` BIGINT COMMENT 'Reference to the cost center responsible for this labor budget. Used for financial allocation and variance analysis.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC labor budgets are facility-specific for financial planning and cost control. Finance and operations track planned vs. actual labor costs by facility to manage warehouse operating expenses and produ',
    `financial_period_id` BIGINT COMMENT 'Reference to the fiscal period for which this labor budget applies. Links to the financial calendar structure.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Labor budget planning maps to GL salary/wage expense accounts for budget vs actual variance reporting. Required for departmental budget planning, labor cost forecasting, and financial planning integra',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Labor budgets are planned by job profile (FTE counts and labor costs by role). Workforce planning requires budgeting headcount separately for store managers, cashiers, stockers, DC operators, etc. Lin',
    `location_id` BIGINT COMMENT 'Reference to the store, distribution center (DC), or corporate office location for which this labor budget is planned. Enables location-level workforce capacity planning.',
    `org_unit_id` BIGINT COMMENT 'Reference to the department or functional area for which this labor budget is planned. Supports departmental workforce planning and staffing models.',
    `associate_id` BIGINT COMMENT 'Reference to the employee responsible for creating and maintaining this labor budget plan. Establishes accountability for workforce planning.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Store/channel labor budgets require profit center assignment for P&L planning and labor cost percentage targets. Essential for retail store budget planning, district-level labor planning, and profitab',
    `tertiary_labor_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the user who last modified this labor budget record. Provides accountability for data changes.',
    `approval_date` DATE COMMENT 'Date when this labor budget version was formally approved. Establishes the effective authorization for workforce planning and requisitions.',
    `attrition_assumption_percent` DECIMAL(18,2) COMMENT 'Assumed employee attrition rate as a percentage for the planning period. Used to calculate net new hire targets and workforce replacement needs.',
    `budget_notes` STRING COMMENT 'Free-text notes and comments regarding this labor budget. Captures planning assumptions, business justifications, and special considerations.',
    `budget_status` STRING COMMENT 'Current lifecycle status of the labor budget. Tracks progression through the approval workflow and activation state. [ENUM-REF-CANDIDATE: draft|submitted|under_review|approved|rejected|active|closed — 7 candidates stripped; promote to reference product]',
    `budget_version_code` STRING COMMENT 'Version status of the labor budget indicating the stage in the planning cycle. Tracks progression from baseline through final approved budget.. Valid values are `baseline|initial|revised|approved|final`',
    `budgeted_labor_cost_amount` DECIMAL(18,2) COMMENT 'Total budgeted labor cost in dollars for the planning period. Includes wages, overtime premiums, and shift differentials. Used for financial planning and variance analysis.',
    `budgeted_labor_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the budgeted labor cost amount. Supports multi-currency financial planning for international operations.. Valid values are `^[A-Z]{3}$`',
    `budgeted_labor_cost_percent_of_sales` DECIMAL(18,2) COMMENT 'Budgeted labor cost expressed as a percentage of forecasted sales revenue. Key performance indicator (KPI) for labor productivity and operational efficiency.',
    `budgeted_overtime_hours` DECIMAL(18,2) COMMENT 'Total planned overtime hours for the planning period. Used for labor cost variance analysis and operational efficiency monitoring.',
    `budgeted_regular_hours` DECIMAL(18,2) COMMENT 'Total planned regular work hours for the planning period. Excludes overtime and forms the basis for labor cost calculations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this labor budget record was first created in the system. Provides audit trail for data lineage.',
    `internal_transfer_assumption` STRING COMMENT 'Assumed number of internal employee transfers into or out of this location or department during the planning period. Supports workforce mobility planning.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this labor budget record was last updated. Supports change tracking and audit compliance.',
    `net_new_hire_target` STRING COMMENT 'Target number of net new hires required for the planning period after accounting for attrition. Drives talent acquisition planning and requisition authorization.',
    `planned_fte_count` DECIMAL(18,2) COMMENT 'Planned full-time equivalent headcount for the planning period. Represents the total workforce capacity normalized to full-time hours.',
    `planned_full_time_headcount` STRING COMMENT 'Number of planned full-time employees for the planning period. Used for headcount capacity planning and requisition authorization.',
    `planned_part_time_headcount` STRING COMMENT 'Number of planned part-time employees for the planning period. Supports flexible staffing models and labor cost optimization.',
    `planned_seasonal_headcount` STRING COMMENT 'Number of planned seasonal or temporary employees for the planning period. Critical for seasonal workforce ramp planning during peak periods.',
    `planning_period_end_date` DATE COMMENT 'Last date of the planning period covered by this labor budget. Defines the effective end of the workforce plan.',
    `planning_period_start_date` DATE COMMENT 'First date of the planning period covered by this labor budget. Defines the effective start of the workforce plan.',
    `planning_period_type` STRING COMMENT 'Granularity of the planning period for this labor budget entry. Determines the time horizon for workforce capacity planning.. Valid values are `week|month|quarter|fiscal_year`',
    `source_system_code` STRING COMMENT 'Code identifying the source system from which this labor budget record originated. Supports data lineage and integration traceability.',
    CONSTRAINT pk_labor_budget PRIMARY KEY(`labor_budget_id`)
) COMMENT 'Single source of truth for unified workforce planning encompassing headcount capacity plans, FTE forecasts, and labor cost budgets by store, DC, department, or cost center for each fiscal period. Captures planning period (week, month, quarter, fiscal year), location or cost center, department, planned FTE count, planned headcount by employment type (full-time, part-time, seasonal), budgeted regular hours, budgeted overtime hours, budgeted labor cost dollars, budgeted labor cost as percentage of sales, attrition assumption percentage, net new hire target, internal transfer assumption, budget version (baseline, initial, revised, approved, final), plan owner, and forward-looking headcount targets by role and location. Used for labor cost variance analysis against actuals, store operations staffing models, DC throughput capacity planning, seasonal workforce ramp planning, requisition authorization, and supports Financial Planning and Revenue Management processes.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`compensation_change` (
    `compensation_change_id` BIGINT COMMENT 'Unique identifier for the compensation change event. Primary key for the compensation change data product.',
    `cost_center_id` BIGINT COMMENT 'Unique identifier of the cost center to which this compensation change is allocated. Used for labor cost tracking and budget management.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC compensation changes tied to facility location for cost center allocation and budget impact analysis. Finance tracks facility-level labor cost changes for P&L reporting and variance analysis agains',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Merit increases, promotions, and bonuses post to specific GL expense accounts. Required for compensation accrual accounting, merit cycle financial impact analysis, and salary expense forecasting in re',
    `job_profile_id` BIGINT COMMENT 'Unique identifier of the job profile (role definition) that the employee holds after this compensation change. Links to the job profile master for job title, FLSA classification, and standard pay ranges.',
    `location_id` BIGINT COMMENT 'Unique identifier of the work location (store, distribution center, or corporate office) where the employee is assigned at the time of the compensation change.',
    `merit_cycle_id` BIGINT COMMENT 'Unique identifier of the annual merit review cycle during which this compensation change was processed. Null for off-cycle changes such as promotions or market adjustments.',
    `org_unit_id` BIGINT COMMENT 'Unique identifier of the department in which the employee works at the time of the compensation change. Used for organizational reporting and headcount planning.',
    `performance_review_id` BIGINT COMMENT 'Foreign key linking to workforce.performance_review. Business justification: Merit increases are tied to performance review outcomes. The compensation_change table has performance_rating and merit_cycle_id attributes; linking to performance_review creates an audit trail from p',
    `associate_id` BIGINT COMMENT 'Unique identifier of the employee receiving the compensation change. Links to the employee master record in Workday HCM.',
    `tertiary_compensation_hr_approver_associate_id` BIGINT COMMENT 'Unique identifier of the HR business partner or compensation analyst who reviewed and approved this compensation change.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when the compensation change received final HR approval and was committed for payroll processing. Null if still pending or rejected.',
    `budget_impact_amount` DECIMAL(18,2) COMMENT 'The annualized financial impact of this compensation change on the department or cost center budget. Calculated based on the pay rate change and the employees standard hours per year.',
    `change_effective_date` DATE COMMENT 'The date on which the compensation change becomes effective and is reflected in payroll processing. This is the business event date for the compensation adjustment.',
    `change_reason` STRING COMMENT 'Detailed business justification for the compensation change. Provides context beyond the change type, such as specific performance achievements, market benchmarking results, or organizational restructuring rationale.',
    `change_type` STRING COMMENT 'The category of compensation change event. Merit: annual performance-based increase. Promotion: increase due to role advancement. Equity: adjustment to address internal pay equity. Market Adjustment: correction based on external market data. COLA: Cost of Living Adjustment. Demotion: decrease due to role change.. Valid values are `merit|promotion|equity|market_adjustment|cola|demotion`',
    `compa_ratio_after` DECIMAL(18,2) COMMENT 'The employees compensation ratio (actual pay divided by pay grade midpoint) after this change takes effect. Used to ensure the new pay rate is within acceptable range for the grade.',
    `compa_ratio_before` DECIMAL(18,2) COMMENT 'The employees compensation ratio (actual pay divided by pay grade midpoint) before this change. A compa-ratio of 1.00 means the employee is paid at the midpoint of their grade. Used to assess pay equity and positioning within grade.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this compensation change record was first created in the data lakehouse. Part of the audit trail for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the pay rates and budget impact are denominated. Supports multi-currency compensation for international retail operations.. Valid values are `^[A-Z]{3}$`',
    `hr_approval_status` STRING COMMENT 'Current approval status of the compensation change in the HR workflow. Pending: awaiting HR review. Approved: HR has approved and change will be processed. Rejected: HR denied the change. Cancelled: change request was withdrawn.. Valid values are `pending|approved|rejected|cancelled`',
    `is_lump_sum` BOOLEAN COMMENT 'Indicates whether this compensation change includes a one-time lump sum payment in addition to or instead of a base pay rate increase. True if lump sum is included, False if only base pay rate change.',
    `is_retroactive` BOOLEAN COMMENT 'Indicates whether this compensation change includes retroactive pay for a period prior to the change effective date. True if retroactive pay is owed, False otherwise.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this compensation change record was most recently updated in the data lakehouse. Used for change tracking and data quality monitoring.',
    `lump_sum_amount` DECIMAL(18,2) COMMENT 'The one-time lump sum payment amount awarded as part of this compensation change. Null if no lump sum is included. Used for merit bonuses or retention payments that do not increase base pay.',
    `new_pay_grade` STRING COMMENT 'The employees pay grade or salary band after this compensation change takes effect. Used to track career progression and ensure pay equity within grade ranges.',
    `new_pay_rate` DECIMAL(18,2) COMMENT 'The employees base pay rate after this compensation change event takes effect. Expressed in the currency and frequency defined in the employees job profile.',
    `notes` STRING COMMENT 'Free-form text field for additional context, special circumstances, or instructions related to this compensation change. Used for audit trail and future reference.',
    `pay_frequency` STRING COMMENT 'The frequency at which the employee is paid, defining the time unit for the pay rate. Hourly: rate per hour. Weekly: rate per week. Biweekly: rate per two weeks. Semimonthly: rate per half month. Monthly: rate per month. Annual: rate per year.. Valid values are `hourly|weekly|biweekly|semimonthly|monthly|annual`',
    `pay_rate_change_amount` DECIMAL(18,2) COMMENT 'The absolute monetary difference between the new pay rate and the previous pay rate. Calculated as new_pay_rate minus previous_pay_rate. May be negative for demotions.',
    `pay_rate_change_percentage` DECIMAL(18,2) COMMENT 'The percentage change in pay rate, calculated as (pay_rate_change_amount / previous_pay_rate) * 100. Used for merit budget tracking and compensation analysis.',
    `performance_rating` STRING COMMENT 'The employees performance rating from the most recent performance review that influenced this compensation change. Used to correlate merit increases with performance outcomes.',
    `previous_pay_grade` STRING COMMENT 'The employees pay grade or salary band immediately prior to this compensation change. Pay grades define the compensation range for a given job level.',
    `previous_pay_rate` DECIMAL(18,2) COMMENT 'The employees base pay rate immediately prior to this compensation change event. Expressed in the currency and frequency defined in the employees job profile.',
    `processed_timestamp` TIMESTAMP COMMENT 'The date and time when the compensation change was successfully processed into the payroll system and reflected in the employees pay record.',
    `rejection_reason` STRING COMMENT 'Detailed explanation provided by HR or approving manager if the compensation change request was rejected. Null if the change was approved or is still pending.',
    `retroactive_amount` DECIMAL(18,2) COMMENT 'The total retroactive pay amount owed to the employee for the period between the retroactive start date and the change effective date. Null if the change is not retroactive.',
    `retroactive_start_date` DATE COMMENT 'The start date of the period for which retroactive pay is calculated. Null if the change is not retroactive. Used to calculate back pay owed to the employee.',
    `submitted_timestamp` TIMESTAMP COMMENT 'The date and time when the compensation change request was initially submitted into the Workday HCM system for approval workflow.',
    CONSTRAINT pk_compensation_change PRIMARY KEY(`compensation_change_id`)
) COMMENT 'History of all compensation change events for associates including merit increases, promotions, equity adjustments, and market corrections processed through Workday HCM Compensation. Captures change effective date, change type (merit, promotion, equity, market adjustment, COLA, demotion), previous pay rate, new pay rate, pay rate change amount, pay rate change percentage, previous pay grade, new pay grade, change reason, approving manager, HR approval status, and budget impact amount. Provides full compensation history audit trail.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`org_unit` (
    `org_unit_id` BIGINT COMMENT 'Unique identifier for the organizational unit. Primary key for the org_unit entity.',
    `location_id` BIGINT COMMENT 'Reference to the physical location (store, DC, office) associated with this organizational unit. Links org structure to physical footprint.',
    `parent_org_unit_id` BIGINT COMMENT 'Reference to the parent organizational unit in the hierarchy. Enables navigation of the org chart from department to store to district to region to division to company.',
    `associate_id` BIGINT COMMENT 'Reference to the employee who manages this organizational unit (store manager, regional director, department head, DC operations manager).',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Org units are core dimensional entities in workforce analytics semantic layers. BI platforms expose org_unit hierarchy as a certified dimension for all workforce reporting, enabling drill-down from di',
    `business_unit` STRING COMMENT 'High-level business unit classification (e.g., Retail Operations, E-Commerce, Supply Chain, Corporate). Used for strategic reporting and resource allocation.',
    `org_unit_code` STRING COMMENT 'Business identifier code for the organizational unit. Used in operational systems, reporting, and integrations. Unique within org unit type.. Valid values are `^[A-Z0-9]{3,20}$`',
    `cost_center_code` STRING COMMENT 'Financial cost center code for labor cost allocation and P&L reporting. Maps to SAP FI/CO cost center master for expense tracking and budgeting.. Valid values are `^[A-Z0-9]{4,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this organizational unit record was first created in the system. Supports audit trail and data lineage.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for financial amounts associated with this organizational unit (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `department_category` STRING COMMENT 'Merchandising category for department-level org units (e.g., Grocery, Apparel, Electronics, Home & Garden). Null for non-department org units.',
    `district_name` STRING COMMENT 'District name for store-level organizational units. Districts roll up to regions and are managed by district managers.',
    `division_name` STRING COMMENT 'Name of the division this organizational unit belongs to (e.g., Grocery, Apparel, Electronics, Home Goods). Supports merchandising and category-based reporting.',
    `effective_end_date` DATE COMMENT 'Date when this organizational unit ceased or will cease operations. Null for currently active units. Supports historical reporting and org structure changes.',
    `effective_start_date` DATE COMMENT 'Date when this organizational unit became or will become operational. Supports temporal queries and historical org chart reconstruction.',
    `external_system_code` STRING COMMENT 'Identifier for this organizational unit in external systems (e.g., legacy HR system, payroll provider, third-party scheduling tool). Supports data integration and reconciliation.',
    `gl_company_code` STRING COMMENT 'SAP company code for general ledger posting and financial consolidation. Represents the legal entity for financial reporting purposes.. Valid values are `^[A-Z0-9]{4}$`',
    `hierarchy_path` STRING COMMENT 'Materialized path representation of the org unit hierarchy (e.g., /company/division/region/district/store). Enables efficient ancestor and descendant queries.',
    `is_customer_facing` BOOLEAN COMMENT 'Indicates whether this organizational unit has direct customer interaction (stores, customer service) or is back-office (finance, HR, DC operations).',
    `is_revenue_generating` BOOLEAN COMMENT 'Indicates whether this organizational unit directly generates revenue (stores, e-commerce) or is a support function (corporate, DC). Used for P&L classification.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this organizational unit record was last updated. Supports change tracking and audit trail.',
    `org_unit_level` STRING COMMENT 'Numeric level in the organizational hierarchy (1=company, 2=division, 3=region, etc.). Supports depth-based queries and rollup calculations.',
    `org_unit_name` STRING COMMENT 'Full business name of the organizational unit (e.g., Northeast Region, Store 1234 - Manhattan, Apparel Department, Distribution Center Operations).',
    `notes` STRING COMMENT 'Free-text notes and comments about this organizational unit. Used for special instructions, historical context, or operational details.',
    `org_unit_status` STRING COMMENT 'Current operational status of the organizational unit. Active units are operational and incur costs; inactive units are historical; pending units are planned but not yet operational.. Valid values are `active|inactive|pending|closed|suspended`',
    `org_unit_type` STRING COMMENT 'Classification of the organizational unit within the enterprise hierarchy. Determines the level and function of the unit in reporting and cost allocation structures. [ENUM-REF-CANDIDATE: company|division|region|district|store|department|cost_center|distribution_center|fulfillment_node|corporate_function — 10 candidates stripped; promote to reference product]',
    `osha_establishment_number` STRING COMMENT 'OSHA establishment identifier for workplace safety reporting. Required for locations with 10+ employees. Null for small or non-physical org units.',
    `profit_center_code` STRING COMMENT 'Profit center code for revenue and margin reporting. Used for P&L analysis at store, region, or division level.. Valid values are `^[A-Z0-9]{4,12}$`',
    `region_name` STRING COMMENT 'Geographic region name for this organizational unit (e.g., Northeast, Southwest, Midwest). Supports regional performance analysis and territory management.',
    `safety_committee_required` BOOLEAN COMMENT 'Indicates whether OSHA regulations require a safety committee for this organizational unit based on headcount and hazard classification.',
    `sort_order` STRING COMMENT 'Numeric sort order for displaying organizational units within the same parent and level. Used for consistent reporting presentation.',
    `store_format` STRING COMMENT 'Store format classification for retail locations. Determines assortment depth, pricing strategy, and operational model. Null for non-store org units.. Valid values are `hypermarket|superstore|discount_store|neighborhood_market|express|online_only`',
    `time_zone` STRING COMMENT 'IANA time zone identifier for this organizational unit (e.g., America/New_York, America/Los_Angeles). Used for scheduling and time-based reporting.',
    `union_local_code` STRING COMMENT 'Union local chapter code for represented employees in this organizational unit. Null for non-union org units.',
    `union_representation` STRING COMMENT 'Indicates whether employees in this organizational unit are represented by a labor union. Affects labor relations, scheduling rules, and compliance requirements.. Valid values are `none|represented|mixed`',
    CONSTRAINT pk_org_unit PRIMARY KEY(`org_unit_id`)
) COMMENT 'Organizational unit hierarchy master for the retail enterprise including divisions, regions, districts, stores, departments, and DC functional areas. Captures org unit code, org unit name, org unit type (company, division, region, district, store, department, cost center), parent org unit, effective start date, effective end date, org unit manager, cost center code, GL company code, and active status. Supports org chart navigation, reporting hierarchies, and labor cost rollup from store/department to region/division.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`wf_certification` (
    `wf_certification_id` BIGINT COMMENT 'Unique identifier for the workforce certification record. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: DC certifications (forklift, hazmat, powered industrial truck) are facility-specific for compliance and safety management. Operations and safety teams track facility-level certification coverage to en',
    `job_profile_id` BIGINT COMMENT 'Foreign key linking to workforce.job_profile. Business justification: Certifications are often job eligibility requirements (wf_certification has job_eligibility_flag attribute). Pharmacy technicians need state licenses; forklift operators need OSHA certification; food',
    `org_unit_id` BIGINT COMMENT 'Identifier of the department or functional area where the certification is required or utilized.',
    `associate_id` BIGINT COMMENT 'Identifier of the associate who holds this certification. Links to the associate master record in Workday HCM.',
    `renewed_from_wf_certification_id` BIGINT COMMENT 'Self-referencing FK on wf_certification (renewed_from_wf_certification_id)',
    `tertiary_wf_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the user or system process that last modified this certification record.',
    `training_program_id` BIGINT COMMENT 'Identifier of the internal training program that led to this certification, if applicable. Links to training enrollment records.',
    `location_id` BIGINT COMMENT 'Identifier of the store, distribution center, or corporate office where the certification is primarily utilized.',
    `attachment_url` STRING COMMENT 'URL or file path to the digital copy of the certification document stored in the document management system.',
    `certification_name` STRING COMMENT 'Full official name of the certification or credential as issued by the certifying body.',
    `certification_number` STRING COMMENT 'Unique credential or license number assigned by the issuing authority. Used for verification and compliance audits.',
    `certification_status` STRING COMMENT 'Current lifecycle status of the certification. Determines whether the associate is authorized to perform related job functions.. Valid values are `active|expired|suspended|revoked|pending_renewal|in_progress`',
    `certification_type` STRING COMMENT 'Category of certification held by the associate. Determines compliance requirements and job eligibility.. Valid values are `food_handler|forklift_operator|pharmacy_technician|management_training|safety_certification|first_aid_cpr`',
    `continuing_education_hours_completed` DECIMAL(18,2) COMMENT 'Number of continuing education hours the associate has completed toward renewal requirements.',
    `continuing_education_hours_required` DECIMAL(18,2) COMMENT 'Number of continuing education or professional development hours required to maintain or renew the certification.',
    `cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred to obtain or renew the certification, including exam fees, training fees, and materials.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was first created in the data platform.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the certification cost amount.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date from which the certification becomes valid and the associate is authorized to perform related duties.',
    `expiration_date` DATE COMMENT 'Date the certification expires and requires renewal. Null for certifications with no expiration.',
    `is_compliance_required` BOOLEAN COMMENT 'Indicates whether this certification is required to meet regulatory or legal compliance obligations (e.g., OSHA, FDA, state licensing).',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this certification is required for the associates current job role. True if mandatory for compliance or job performance.',
    `issue_date` DATE COMMENT 'Date the certification was originally issued to the associate.',
    `issuing_authority_type` STRING COMMENT 'Classification of the certifying organization to distinguish regulatory vs. professional vs. internal credentials.. Valid values are `government|professional_association|internal_training|third_party_vendor|educational_institution|industry_body`',
    `issuing_body` STRING COMMENT 'Name of the organization, agency, or institution that issued the certification (e.g., State Health Department, OSHA, National Pharmacy Board).',
    `job_eligibility_flag` BOOLEAN COMMENT 'Indicates whether this certification qualifies the associate for specific job roles or assignments (e.g., forklift operator, pharmacy technician).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was last updated in the data platform.',
    `notes` STRING COMMENT 'Free-text field for additional information, special conditions, or comments related to the certification.',
    `reimbursement_amount` DECIMAL(18,2) COMMENT 'Amount reimbursed to the associate for certification costs, if applicable.',
    `reimbursement_eligible_flag` BOOLEAN COMMENT 'Indicates whether the associate is eligible for reimbursement of certification costs under company policy.',
    `renewal_due_date` DATE COMMENT 'Target date by which the associate must complete renewal requirements to maintain active certification status.',
    `source_system_record_code` STRING COMMENT 'Unique identifier of this certification record in the source system, used for reconciliation and traceability.',
    `verification_date` DATE COMMENT 'Date the certification was last verified with the issuing authority.',
    `verification_status` STRING COMMENT 'Indicates whether the certification has been validated with the issuing authority. Required for regulatory compliance.. Valid values are `verified|pending_verification|failed_verification|not_verified`',
    CONSTRAINT pk_wf_certification PRIMARY KEY(`wf_certification_id`)
) COMMENT 'Tracks individual associate certifications and professional credentials including food handler permits, forklift operator licenses, pharmacy technician certifications, and management training completions. Captures certification type, issue date, expiry date, and issuing body.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` (
    `staffing_plan_id` BIGINT COMMENT 'Unique identifier for this staffing plan allocation record. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the employee (typically HR Director or Finance Manager) who approved this staffing allocation.',
    `dc_facility_id` BIGINT COMMENT 'add column dc_facility_id (BIGINT) with FK to supplychain.dc_facility.dc_facility_id - staffing plans are also created for DC facilities',
    `financial_period_id` BIGINT COMMENT 'add column financial_period_id (BIGINT) with FK to finance.financial_period.financial_period_id - staffing plans align to financial periods for budget integration',
    `job_profile_id` BIGINT COMMENT 'Foreign key to job_profile. Identifies which job role is being allocated to the org unit.',
    `org_unit_id` BIGINT COMMENT 'Foreign key to org_unit. Identifies which organizational unit this staffing allocation applies to.',
    `location_id` BIGINT COMMENT 'add column store_location_id (BIGINT) with FK to store.location.location_id - staffing plans are created for specific store locations',
    `actual_headcount` DECIMAL(18,2) COMMENT 'Current actual FTE headcount for this job profile within this organizational unit. Updated as employees are hired, transferred, or terminated.',
    `annual_labor_budget` DECIMAL(18,2) COMMENT 'Annual labor cost budget allocated to this organizational unit in local currency. Used for variance analysis and cost control. [Moved from org_unit: Labor budget is allocated by job profile within each org unit, not as a single lump sum. The total labor budget for an org unit is the SUM of staffing_plan.annual_labor_cost_budget across all job profile allocations. This should be removed from org_unit and calculated from the association.]',
    `annual_labor_cost_budget` DECIMAL(18,2) COMMENT 'Total annual labor cost budget for this job profile allocation within this org unit. Calculated from FTE count and pay range.',
    `approved_date` DATE COMMENT 'Date when this staffing allocation was formally approved through the workforce planning approval workflow.',
    `budgeted_fte_count` DECIMAL(18,2) COMMENT 'Budgeted full-time equivalent count for this job profile in this org unit. Used for labor budget planning and variance analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this staffing plan record was created in the system.',
    `effective_end_date` DATE COMMENT 'Date when this staffing allocation ceases or ceased to be effective. Null for current active allocations.',
    `effective_start_date` DATE COMMENT 'Date when this staffing allocation becomes or became effective. Supports historical tracking of staffing plan changes across planning cycles.',
    `headcount_actual` STRING COMMENT 'Current actual full-time equivalent (FTE) headcount assigned to this organizational unit. Updated from active employee assignments. [Moved from org_unit: Similar to headcount_planned, actual headcount is tracked at the org_unit × job_profile level in workforce planning systems. The actual headcount for an org unit is the SUM of staffing_plan.actual_headcount across all job profiles. This should be a derived metric, not stored on org_unit.]',
    `headcount_allocated` DECIMAL(18,2) COMMENT 'Planned or budgeted FTE headcount for this job profile within this organizational unit. This is the approved staffing level from the workforce planning cycle.',
    `headcount_planned` STRING COMMENT 'Planned full-time equivalent (FTE) headcount for this organizational unit. Used for workforce planning and budget allocation. [Moved from org_unit: This attribute represents planned headcount at the org unit level, but in reality, headcount planning is done at the org_unit × job_profile granularity. The planned headcount for a store or department is the SUM of staffing_plan.headcount_allocated across all job profiles for that org unit. This attribute should be removed from org_unit and calculated from the association.]',
    `notes` STRING COMMENT 'Free-text notes explaining the rationale for this staffing allocation, special circumstances, or planning assumptions.',
    `planning_cycle` STRING COMMENT 'Identifier for the workforce planning cycle this allocation belongs to (e.g., FY2024-Q1, Annual-2024). Links staffing decisions to budget cycles.',
    `staffing_plan_status` STRING COMMENT 'Lifecycle status of this staffing allocation. Tracks workflow state from draft through approval to active deployment. Values: draft, pending_approval, approved, active, historical, cancelled.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this staffing plan record was last modified.',
    `variance_fte` DECIMAL(18,2) COMMENT 'Variance between budgeted and actual FTE count (actual minus budgeted). Used for workforce planning variance reporting.',
    CONSTRAINT pk_staffing_plan PRIMARY KEY(`staffing_plan_id`)
) COMMENT 'This association product represents the workforce allocation plan between organizational units and job profiles. It captures the planned and actual headcount allocation of standardized job roles to specific organizational units (stores, departments, distribution centers, corporate divisions). Each record links one org unit to one job profile with budgeted FTE counts, actual headcount, effective dates, and approval status. This is a core workforce planning entity managed jointly by HR and Finance through formal planning cycles and budget approval workflows.. Existence Justification: This is a genuine operational M:N relationship representing workforce staffing plans in retail. One organizational unit (store, department, DC) requires multiple job profiles to operate (cashiers, managers, stockers, etc.), and one job profile is allocated across multiple organizational units (e.g., Store Manager role exists in hundreds of stores). The business actively manages these allocations through formal workforce planning cycles with approval workflows, budget constraints, and variance tracking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` (
    `dashboard_access_id` BIGINT COMMENT 'Unique identifier for this dashboard access record. Primary key for the association.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to the retail workforce member who has access to the dashboard',
    `dashboard_config_id` BIGINT COMMENT 'Foreign key linking to the business intelligence dashboard configuration',
    `access_count` BIGINT COMMENT 'Cumulative number of times this associate has accessed this specific dashboard. Usage analytics metric for measuring dashboard adoption per user.',
    `access_granted_date` DATE COMMENT 'Date when access to this dashboard was provisioned for this associate. Explicitly identified in detection phase relationship data.',
    `access_level` STRING COMMENT 'Permission level granted to the associate for this dashboard: viewer (read-only), editor (can modify), admin (full control). Explicitly identified in detection phase relationship data.',
    `access_revoked_date` DATE COMMENT 'Date when access to this dashboard was revoked or expired for this associate. Null for active access. Used for access audit trails.',
    `access_status` STRING COMMENT 'Current lifecycle status of this access grant: active (currently valid), suspended (temporarily disabled), revoked (permanently removed), expired (time-limited access ended).',
    `custom_filter_settings` STRING COMMENT 'JSON structure storing this associates personalized filter preferences for this dashboard (e.g., default store selection, date range preferences). Explicitly identified in detection phase relationship data.',
    `favorite_flag` BOOLEAN COMMENT 'Boolean indicator of whether this associate has marked this dashboard as a favorite for quick access. User personalization setting. Explicitly identified in detection phase relationship data.',
    `last_accessed_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent time this associate accessed this specific dashboard. Used for usage analytics and stale access identification. Explicitly identified in detection phase relationship data.',
    CONSTRAINT pk_dashboard_access PRIMARY KEY(`dashboard_access_id`)
) COMMENT 'This association product represents the access relationship between retail associates and business intelligence dashboards. It captures user-level access provisioning, personalization settings, and usage analytics for each associate-dashboard combination. Each record links one associate to one dashboard with access metadata, usage tracking, and personalization preferences that exist only in the context of this relationship.. Existence Justification: In retail BI operations, associates access multiple dashboards based on their role and responsibilities (store managers access store operations dashboards, buyers access merchandising dashboards, DC supervisors access logistics dashboards), and each dashboard is accessed by multiple associates across the organization. The business actively manages dashboard access provisioning, tracks usage analytics per associate-dashboard pair, and maintains personalization settings (favorites, custom filters) that belong to the relationship, not to either the associate or the dashboard alone.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` (
    `workforce_kpi_target_id` BIGINT COMMENT 'Primary key for workforce_kpi_target',
    `analytics_kpi_target_id` BIGINT COMMENT 'Unique identifier for this KPI target assignment record. Primary key.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to the KPI definition that defines what is being measured',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to the organizational unit being measured and held accountable for this KPI target',
    `associate_id` BIGINT COMMENT 'Reference to the employee who set or approved this target for this org unit. Typically a regional VP, divisional leader, or performance management analyst.',
    `accountability_level` STRING COMMENT 'The level of accountability this org unit has for this KPI. Primary = directly accountable and performance-reviewed on this metric. Secondary = contributes but not primary owner. Informational = tracked for visibility but not performance-managed.',
    `effective_end_date` DATE COMMENT 'The date when this KPI target expires or is replaced for this org unit. Null indicates the target is currently active. Supports historical tracking of target changes over time.',
    `effective_start_date` DATE COMMENT 'The date when this KPI target becomes effective for this org unit. Supports fiscal year planning cycles, quarterly target resets, and mid-period target adjustments.',
    `is_stretch_target` BOOLEAN COMMENT 'Indicates whether this is a stretch target (aspirational, above normal expectations) versus a standard target. Used for performance review calibration.',
    `measurement_frequency` STRING COMMENT 'How often this specific org unit is measured against this KPI. May differ from the KPI definitions default reporting frequency based on org unit level (stores measured daily, regions measured weekly).',
    `notes` STRING COMMENT 'Free-text notes explaining the rationale for this specific target value, any special circumstances, or context for why this org unit has a different target than peer units.',
    `target_set_date` DATE COMMENT 'The date when this target was established in the system. Used for audit trail and understanding when targets were locked for a performance period.',
    `target_value` DECIMAL(18,2) COMMENT 'The specific target value set for this org unit for this KPI during this period. This is the goal the org unit is expected to achieve. The value is specific to the org unit-KPI combination and varies by org unit type, size, and strategic priorities.',
    `threshold_green` DECIMAL(18,2) COMMENT 'The performance threshold at or above which this org units KPI performance is considered green/on-target for this period. Used for dashboard color-coding.',
    `threshold_red` DECIMAL(18,2) COMMENT 'The performance threshold below which this org units KPI performance is considered red/critical for this period. Used for dashboard color-coding and alert triggering.',
    `threshold_yellow` DECIMAL(18,2) COMMENT 'The performance threshold below which this org units KPI performance is considered yellow/warning for this period. Used for dashboard color-coding.',
    `weight_percentage` DECIMAL(18,2) COMMENT 'The weight of this KPI in the org units overall performance scorecard (0-100%). Used for calculating composite performance scores and bonus calculations. Weights vary by org unit type and role.',
    `workforce_kpi_target_status` STRING COMMENT 'Current status of this KPI target assignment. Draft targets are being negotiated, approved targets are locked for the period, active targets are currently in measurement, suspended targets are temporarily paused, archived targets are historical.',
    CONSTRAINT pk_workforce_kpi_target PRIMARY KEY(`workforce_kpi_target_id`)
) COMMENT 'This association product represents the performance target assignment between organizational units and KPI definitions. It captures the specific target values, measurement frequencies, and accountability levels that exist only in the context of a specific org unit being measured against a specific KPI. Each record links one org unit to one KPI definition with the target parameters and effective dates for that accountability relationship.. Existence Justification: In retail performance management, organizational units (stores, regions, departments, DCs) are measured against multiple KPIs simultaneously (sales per labor hour, shrink rate, safety incidents, turnover rate, customer satisfaction), and each KPI is measured across multiple organizational units at different levels of the hierarchy. The business actively manages KPI target assignments as a distinct operational process, setting specific target values, accountability levels, and measurement frequencies for each org-unit-KPI combination during annual planning and quarterly reviews.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` (
    `org_unit_compliance_scope_id` BIGINT COMMENT 'Unique identifier for this org unit-compliance program scope assignment. Primary key.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key to compliance_program. Identifies which compliance program applies to this org unit.',
    `org_program_compliance_program_id` BIGINT COMMENT 'Foreign key linking to the compliance program that applies to this organizational unit',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to the organizational unit that is subject to this compliance program scope',
    `audit_frequency` STRING COMMENT 'Required or planned frequency of compliance audits for this program at this specific org unit. May differ from program-level audit_frequency based on org unit risk profile or operational characteristics.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this org unit-compliance program scope record was first created in the system.',
    `effective_date` DATE COMMENT 'Date when this compliance program became or will become applicable to this specific org unit. May differ from the program-level effective_date if rollout is phased by org unit.',
    `exemption_reason` STRING COMMENT 'Business justification if this org unit has been granted an exemption from this compliance program. Null if no exemption. Documents why the program does not apply despite general scope rules.',
    `expiration_date` DATE COMMENT 'Date when this compliance program scope ends for this org unit. Null if ongoing. Used when org units are removed from program scope due to restructuring or exemptions.',
    `incident_count_ytd` STRING COMMENT 'Number of compliance incidents, violations, or breaches recorded for this program at this specific org unit in the current year. Tracks compliance performance at the org unit level.',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit conducted for this program at this specific org unit. Tracks audit history at the org unit-program level.',
    `last_audit_result` STRING COMMENT 'Outcome of the most recent compliance audit for this program at this org unit. Passed: full compliance. Passed_with_observations: compliant but with minor findings. Failed: non-compliance identified. Not_audited: no audit conducted yet. In_progress: audit underway.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next compliance audit for this program at this specific org unit. Used for audit planning and scheduling.',
    `notes` STRING COMMENT 'Free-text field for additional context about this org unit-program scope assignment, including special conditions, implementation challenges, or historical context.',
    `responsible_party` STRING COMMENT 'Name or employee identifier of the individual responsible for compliance program implementation and monitoring at this specific org unit. Often the org unit manager or a designated compliance coordinator.',
    `risk_level` STRING COMMENT 'Assessed risk severity for this specific org unit-program combination. May differ from program-level risk based on org unit characteristics (e.g., food safety risk higher in fresh departments than apparel).',
    `scope_status` STRING COMMENT 'Current status of this compliance program scope for this specific org unit. Active: program is enforced. Suspended: temporarily not enforced. Pending: implementation in progress. Exempt: org unit has formal exemption. Under_review: scope applicability being reassessed.',
    `training_completion_rate` DECIMAL(18,2) COMMENT 'Percentage of required employees at this org unit who have completed mandatory training for this compliance program. Calculated as (completed_employees / required_employees) * 100.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this scope record was last modified. Tracks changes to scope status, responsible parties, or audit schedules.',
    CONSTRAINT pk_org_unit_compliance_scope PRIMARY KEY(`org_unit_compliance_scope_id`)
) COMMENT 'This association product represents the Scope Assignment between org_unit and compliance_program. It captures which compliance programs apply to which organizational units and tracks the program-specific implementation details at the org unit level. Each record links one org_unit to one compliance_program with attributes that exist only in the context of this scoping relationship, including responsible parties, audit schedules, and effective dates for that specific org unit-program combination.. Existence Justification: In retail operations, organizational units (stores, departments, distribution centers) are subject to multiple compliance programs simultaneously (FDA food safety, OSHA workplace safety, PCI payment security, environmental regulations), and each compliance program applies to multiple organizational units across the enterprise. The business actively manages these scope assignments, tracking which programs apply to which org units with program-specific implementation details including responsible parties, audit schedules, risk assessments, and compliance status at the org unit-program level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` (
    `collective_bargaining_agreement_id` BIGINT COMMENT 'Primary key for collective_bargaining_agreement',
    `bargaining_unit_id` BIGINT COMMENT 'Reference to the specific bargaining unit covered by this agreement, representing a group of employees with shared interests.',
    `superseded_collective_bargaining_agreement_id` BIGINT COMMENT 'Self-referencing FK on collective_bargaining_agreement (superseded_collective_bargaining_agreement_id)',
    `union_id` BIGINT COMMENT 'Reference to the labor union or employee organization that is party to this collective bargaining agreement.',
    `associate_id` BIGINT COMMENT 'Reference to the company employee who served as lead negotiator for management during bargaining.',
    `agreement_name` STRING COMMENT 'Human-readable name or title of the collective bargaining agreement, often including the union name and bargaining unit.',
    `agreement_number` STRING COMMENT 'Externally-known unique business identifier for the collective bargaining agreement, typically used in legal documents and union communications.',
    `agreement_type` STRING COMMENT 'Classification of the collective bargaining agreement based on scope and purpose. Master agreements cover multiple locations, local agreements are site-specific, supplemental agreements modify existing CBAs, interim agreements are temporary, memorandums of understanding document mutual understandings, and side letters address specific issues.',
    `arbitration_required_flag` BOOLEAN COMMENT 'Indicates whether binding arbitration is required for unresolved grievances under this agreement.',
    `covered_employee_count` STRING COMMENT 'Total number of employees covered under this collective bargaining agreement at the time of ratification or most recent count.',
    `covered_job_classifications` STRING COMMENT 'Description or list of job titles, roles, and classifications included in the bargaining unit covered by this agreement.',
    `covered_locations` STRING COMMENT 'Comma-separated list or description of specific retail locations, distribution centers, or facilities covered by this agreement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this collective bargaining agreement record was first created in the system.',
    `document_url` STRING COMMENT 'URL or file path to the full text of the signed collective bargaining agreement document stored in the document management system.',
    `dues_checkoff_authorized_flag` BOOLEAN COMMENT 'Indicates whether the employer is authorized to deduct union dues directly from employee paychecks.',
    `effective_date` DATE COMMENT 'Date when the collective bargaining agreement becomes legally binding and enforceable.',
    `expiration_date` DATE COMMENT 'Date when the collective bargaining agreement terminates unless renewed or extended. Nullable for open-ended agreements.',
    `geographic_scope` STRING COMMENT 'Geographic coverage area of the collective bargaining agreement, indicating whether it applies nationally, regionally, at state level, locally, or to a single site.',
    `grievance_procedure_steps` STRING COMMENT 'Number of formal steps in the grievance resolution process defined by the agreement before arbitration.',
    `healthcare_contribution_employer_percentage` DECIMAL(18,2) COMMENT 'Percentage of healthcare premium costs covered by the employer as negotiated in the agreement.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this collective bargaining agreement record was most recently updated in the system.',
    `lockout_clause` STRING COMMENT 'Type of lockout provision in the agreement. No-lockout prohibits employer lockouts during the term, conditional allows lockouts under specific circumstances, unrestricted preserves full lockout rights.',
    `management_rights_clause` STRING COMMENT 'Text or reference describing the scope of management rights reserved by the employer that are not subject to bargaining or grievance.',
    `minimum_wage_rate` DECIMAL(18,2) COMMENT 'Minimum hourly wage rate established by the collective bargaining agreement for covered employees, in local currency.',
    `negotiation_end_date` DATE COMMENT 'Date when formal bargaining negotiations for this agreement concluded with a tentative agreement.',
    `negotiation_start_date` DATE COMMENT 'Date when formal bargaining negotiations for this agreement commenced.',
    `notes` STRING COMMENT 'Free-text field for additional notes, special provisions, or context about the collective bargaining agreement not captured in structured fields.',
    `overtime_multiplier` DECIMAL(18,2) COMMENT 'Wage multiplier for overtime hours as negotiated in the agreement (e.g., 1.50 for time-and-a-half, 2.00 for double-time).',
    `paid_time_off_days_annual` STRING COMMENT 'Number of paid time off days per year guaranteed to covered employees under the agreement.',
    `pension_contribution_rate` DECIMAL(18,2) COMMENT 'Employer contribution rate to pension or retirement plans for covered employees, expressed as percentage of wages.',
    `probationary_period_days` STRING COMMENT 'Number of calendar days new employees must work before gaining full union membership and agreement protections.',
    `ratification_date` DATE COMMENT 'Date when union members voted to approve and ratify the collective bargaining agreement.',
    `reopener_clause` STRING COMMENT 'Description of conditions under which the agreement can be reopened for renegotiation before expiration (e.g., wage reopener, healthcare reopener).',
    `seniority_system_type` STRING COMMENT 'Method by which employee seniority is calculated and applied for purposes of layoffs, recalls, promotions, and shift bidding under the agreement.',
    `sick_leave_days_annual` STRING COMMENT 'Number of paid sick leave days per year guaranteed to covered employees under the agreement.',
    `collective_bargaining_agreement_status` STRING COMMENT 'Current lifecycle status of the collective bargaining agreement. Draft indicates initial preparation, under negotiation indicates active bargaining, ratified indicates union member approval, active indicates in force, expired indicates past end date, terminated indicates early cancellation, suspended indicates temporary hold.',
    `strike_clause` STRING COMMENT 'Type of strike provision in the agreement. No-strike prohibits strikes during the term, conditional allows strikes under specific circumstances, unrestricted preserves full strike rights.',
    `successor_clause_included_flag` BOOLEAN COMMENT 'Indicates whether the agreement includes a successor clause requiring a new owner to honor the agreement in case of business sale or transfer.',
    `union_representative_name` STRING COMMENT 'Name of the primary union representative or business agent who negotiated on behalf of the union.',
    `union_security_clause` STRING COMMENT 'Type of union membership requirement. Closed shop requires union membership before hiring, union shop requires membership after hiring, agency shop requires fee payment without membership, open shop has no requirement, right-to-work prohibits mandatory membership.',
    `wage_increase_percentage` DECIMAL(18,2) COMMENT 'Negotiated percentage wage increase for covered employees over the term of the agreement, expressed as a decimal (e.g., 3.50 for 3.5%).',
    CONSTRAINT pk_collective_bargaining_agreement PRIMARY KEY(`collective_bargaining_agreement_id`)
) COMMENT 'Master reference table for collective_bargaining_agreement. Referenced by collective_bargaining_agreement_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`merit_cycle` (
    `merit_cycle_id` BIGINT COMMENT 'Primary key for merit_cycle',
    `prior_merit_cycle_id` BIGINT COMMENT 'Self-referencing FK on merit_cycle (prior_merit_cycle_id)',
    `approval_deadline_date` DATE COMMENT 'The final date by which all merit recommendations must be approved by management.',
    `approval_workflow_required` BOOLEAN COMMENT 'Indicates whether a formal approval workflow is required for merit recommendations in this cycle (True/False).',
    `approved_by` STRING COMMENT 'Username or identifier of the executive or HR leader who approved the merit cycle.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the merit cycle was officially approved.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Total budget allocated for merit increases in this cycle. Expressed in the companys base currency (USD).',
    `budget_percentage` DECIMAL(18,2) COMMENT 'The overall merit budget expressed as a percentage of total eligible payroll (e.g., 3.5 represents 3.5%).',
    `calibration_required` BOOLEAN COMMENT 'Indicates whether calibration sessions are required to normalize merit recommendations across departments (True/False).',
    `closed_by` STRING COMMENT 'Username or identifier of the user who closed the merit cycle.',
    `closed_timestamp` TIMESTAMP COMMENT 'Timestamp when the merit cycle was officially closed.',
    `communication_date` DATE COMMENT 'The date when merit increase decisions are communicated to employees.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the merit cycle record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the merit budget (e.g., USD, CAD, GBP).',
    `cycle_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the merit cycle for external reference and reporting (e.g., MC-2024-01, FY24-MERIT).',
    `cycle_name` STRING COMMENT 'Human-readable name or title of the merit cycle (e.g., FY2024 Annual Merit Review, Q2 2024 Performance Cycle).',
    `cycle_type` STRING COMMENT 'Classification of the merit cycle based on frequency and purpose (annual, mid-year, quarterly, off-cycle, special).',
    `merit_cycle_description` STRING COMMENT 'Detailed description of the merit cycle, including objectives, scope, and any special considerations.',
    `effective_end_date` DATE COMMENT 'The date when the merit cycle period ends. Nullable for open-ended cycles.',
    `effective_start_date` DATE COMMENT 'The date when the merit cycle becomes effective and merit increases take effect.',
    `eligible_employee_count` STRING COMMENT 'The number of employees eligible to receive merit increases in this cycle.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this merit cycle applies (e.g., 2024).',
    `guideline_increase_percentage` DECIMAL(18,2) COMMENT 'The recommended or guideline merit increase percentage for standard performers (e.g., 3.0 represents 3%).',
    `is_active` BOOLEAN COMMENT 'Indicates whether the merit cycle is currently active (True) or inactive (False).',
    `maximum_increase_percentage` DECIMAL(18,2) COMMENT 'The maximum merit increase percentage allowed for any individual employee (e.g., 10.0 represents 10%).',
    `minimum_increase_percentage` DECIMAL(18,2) COMMENT 'The minimum merit increase percentage allowed for eligible employees (e.g., 0.0 for no minimum).',
    `modified_by` STRING COMMENT 'Username or identifier of the user who last modified the merit cycle record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the merit cycle record was last modified.',
    `notes` STRING COMMENT 'Additional notes or comments related to the merit cycle for internal reference.',
    `performance_period_end_date` DATE COMMENT 'The end date of the performance period being evaluated for this merit cycle.',
    `performance_period_start_date` DATE COMMENT 'The start date of the performance period being evaluated for this merit cycle.',
    `planning_start_date` DATE COMMENT 'The date when planning and preparation for the merit cycle begins.',
    `proration_method` STRING COMMENT 'Method used to prorate merit increases for employees hired mid-cycle (none, hire_date, service_months, custom).',
    `review_end_date` DATE COMMENT 'The date by which all performance reviews and merit recommendations must be completed.',
    `review_start_date` DATE COMMENT 'The date when performance reviews and merit recommendations begin.',
    `merit_cycle_status` STRING COMMENT 'Current lifecycle status of the merit cycle (draft, planned, active, in_review, approved, closed, cancelled).',
    `created_by` STRING COMMENT 'Username or identifier of the user who created the merit cycle record.',
    CONSTRAINT pk_merit_cycle PRIMARY KEY(`merit_cycle_id`)
) COMMENT 'Master reference table for merit_cycle. Referenced by merit_cycle_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`candidate` (
    `candidate_id` BIGINT COMMENT 'Primary key for candidate',
    `associate_id` BIGINT COMMENT 'Employee identifier of the internal employee who referred this candidate, used for referral bonus tracking.',
    `requisition_id` BIGINT COMMENT 'Reference to the job requisition or job posting that the candidate applied to.',
    `referred_by_candidate_id` BIGINT COMMENT 'Self-referencing FK on candidate (referred_by_candidate_id)',
    `address_line_1` STRING COMMENT 'First line of the candidates residential address, typically including street number and street name.',
    `address_line_2` STRING COMMENT 'Second line of the candidates residential address, typically including apartment, suite, or unit number.',
    `alternate_phone_number` STRING COMMENT 'Secondary or alternate contact phone number for the candidate, if provided.',
    `application_date` DATE COMMENT 'Date when the candidate submitted their application for the position.',
    `application_number` STRING COMMENT 'Unique business identifier assigned to the candidates application, used for tracking and reference throughout the recruitment process.',
    `availability_date` DATE COMMENT 'Date when the candidate is available to start employment if an offer is extended.',
    `background_check_completed_date` DATE COMMENT 'Date when the background check process was completed for the candidate.',
    `background_check_status` STRING COMMENT 'Current status of the candidates background verification and screening process.',
    `candidate_status` STRING COMMENT 'Current status of the candidate in the recruitment lifecycle, indicating their progression through the hiring process.',
    `city` STRING COMMENT 'City or municipality of the candidates residential address.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the candidates country of residence.',
    `cover_letter_file_path` STRING COMMENT 'Storage location or file path reference to the candidates uploaded cover letter document, if provided.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the candidate record was first created in the system.',
    `desired_salary` DECIMAL(18,2) COMMENT 'Salary expectation or desired compensation amount indicated by the candidate during the application process.',
    `email_address` STRING COMMENT 'Primary email address used for candidate communication and correspondence throughout the recruitment process.',
    `first_name` STRING COMMENT 'The first name or given name of the candidate as provided in the application.',
    `highest_education_level` STRING COMMENT 'Highest level of education completed by the candidate, used for qualification assessment.',
    `interview_completed_date` TIMESTAMP COMMENT 'Date and time when the candidates interview was completed.',
    `interview_scheduled_date` TIMESTAMP COMMENT 'Date and time when the candidates interview is scheduled to take place.',
    `is_eligible_for_rehire` BOOLEAN COMMENT 'Indicates whether the candidate is a former employee who is eligible for rehire based on previous employment records.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the candidate record was last updated or modified.',
    `last_name` STRING COMMENT 'The last name or family name of the candidate as provided in the application.',
    `location_preference` STRING COMMENT 'Preferred work location or store location indicated by the candidate.',
    `middle_name` STRING COMMENT 'The middle name or middle initial of the candidate, if provided.',
    `offer_accepted_date` DATE COMMENT 'Date when the candidate accepted the employment offer.',
    `offer_extended_date` DATE COMMENT 'Date when a formal employment offer was extended to the candidate.',
    `phone_number` STRING COMMENT 'Primary contact phone number for the candidate, used for interview scheduling and recruitment communication.',
    `position_applied_for` STRING COMMENT 'Job title or position name that the candidate has applied for.',
    `postal_code` STRING COMMENT 'Postal code or ZIP code of the candidates residential address.',
    `referral_source` STRING COMMENT 'Name or identifier of the employee or contact who referred the candidate, if applicable.',
    `rejection_date` DATE COMMENT 'Date when the candidate was notified of rejection or when the application was closed as unsuccessful.',
    `rejection_reason` STRING COMMENT 'Reason or category explaining why the candidate was not selected for the position.',
    `resume_file_path` STRING COMMENT 'Storage location or file path reference to the candidates uploaded resume or curriculum vitae document.',
    `salary_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the desired salary amount.',
    `screening_score` DECIMAL(18,2) COMMENT 'Numerical score assigned during initial candidate screening or assessment, used for ranking and filtering candidates.',
    `source` STRING COMMENT 'Channel or source through which the candidate was identified or applied, used for recruitment effectiveness analysis.',
    `state_province` STRING COMMENT 'State, province, or region of the candidates residential address.',
    `years_of_experience` STRING COMMENT 'Total number of years of relevant work experience reported by the candidate.',
    CONSTRAINT pk_candidate PRIMARY KEY(`candidate_id`)
) COMMENT 'Master reference table for candidate. Referenced by candidate_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`payroll_run` (
    `payroll_run_id` BIGINT COMMENT 'Primary key for payroll_run',
    `associate_id` BIGINT COMMENT 'Identifier of the user who approved this payroll run for processing.',
    `payroll_associate_id` BIGINT COMMENT 'Identifier of the user who initiated or created this payroll run.',
    `payroll_calendar_id` BIGINT COMMENT 'Reference to the payroll calendar that defines the schedule and timing for this payroll run.',
    `payroll_reversal_of_run_id` BIGINT COMMENT 'Reference to the original payroll run that this run reverses or corrects, if applicable.',
    `primary_reversal_payroll_run_id` BIGINT COMMENT 'Self-referencing FK on payroll_run (reversal_payroll_run_id)',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll run was approved for processing.',
    `check_date` DATE COMMENT 'The date printed on physical checks or used as the effective date for electronic payments.',
    `company_code` STRING COMMENT 'Identifier for the legal entity or company for which this payroll run is executed.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll run record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this payroll run.',
    `employee_count` STRING COMMENT 'Total number of employees included in this payroll run.',
    `employer_tax_amount` DECIMAL(18,2) COMMENT 'Total employer-paid payroll taxes including FICA, FUTA, SUTA, and other statutory employer contributions.',
    `frequency` STRING COMMENT 'The recurring schedule on which this payroll run is executed.',
    `gl_posting_date` DATE COMMENT 'The accounting date on which payroll transactions from this run are posted to the general ledger.',
    `gl_posting_status` STRING COMMENT 'Status indicating whether payroll transactions have been posted to the general ledger.',
    `gross_pay_amount` DECIMAL(18,2) COMMENT 'Total gross wages and salaries before any deductions for all employees in this payroll run.',
    `integration_batch_code` STRING COMMENT 'External batch identifier used for integration with Workday HCM or other payroll systems.',
    `is_final_run` BOOLEAN COMMENT 'Indicates whether this is a final payroll run for terminated employees or end-of-year processing.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll run record was last modified.',
    `net_pay_amount` DECIMAL(18,2) COMMENT 'Total net pay amount distributed to employees after all deductions for this payroll run.',
    `notes` STRING COMMENT 'Free-text notes or comments about this payroll run for documentation and audit purposes.',
    `pay_date` DATE COMMENT 'The date on which employees will receive payment for this payroll run.',
    `pay_period_end_date` DATE COMMENT 'The last date of the pay period covered by this payroll run.',
    `pay_period_start_date` DATE COMMENT 'The first date of the pay period covered by this payroll run.',
    `payment_method` STRING COMMENT 'Primary payment method used for disbursing funds to employees in this payroll run.',
    `processing_end_timestamp` TIMESTAMP COMMENT 'Date and time when payroll processing completed for this run.',
    `processing_start_timestamp` TIMESTAMP COMMENT 'Date and time when payroll processing began for this run.',
    `run_number` STRING COMMENT 'Business identifier for the payroll run, externally visible and used for reference in communications and reporting.',
    `run_type` STRING COMMENT 'Classification of the payroll run indicating the purpose and nature of the payroll processing cycle.',
    `payroll_run_status` STRING COMMENT 'Current lifecycle status of the payroll run indicating its position in the processing workflow.',
    `tax_filing_quarter` STRING COMMENT 'The calendar quarter for tax reporting purposes to which this payroll run belongs.',
    `tax_year` STRING COMMENT 'The calendar year for tax reporting purposes to which this payroll run belongs.',
    `total_cost_amount` DECIMAL(18,2) COMMENT 'Total cost to the employer including gross pay, employer taxes, and employer-paid benefits for this payroll run.',
    `total_deductions_amount` DECIMAL(18,2) COMMENT 'Sum of all deductions including taxes, benefits, garnishments, and other withholdings for this payroll run.',
    CONSTRAINT pk_payroll_run PRIMARY KEY(`payroll_run_id`)
) COMMENT 'Master reference table for payroll_run. Referenced by payroll_run_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` (
    `shift_swap_request_id` BIGINT COMMENT 'Primary key for shift_swap_request',
    `counterpart_shift_swap_request_id` BIGINT COMMENT 'Self-referencing FK on shift_swap_request (counterpart_shift_swap_request_id)',
    `department_id` BIGINT COMMENT 'The department within the store or facility where the shift swap is occurring (e.g., grocery, electronics, apparel).',
    `shift_schedule_id` BIGINT COMMENT 'The shift assignment that the requesting employee is willing to take in exchange. May be null for one-way swap requests.',
    `associate_id` BIGINT COMMENT 'The manager or supervisor who approved or rejected the shift swap request.',
    `shift_associate_id` BIGINT COMMENT 'The employee who is initiating the shift swap request and seeking to exchange their assigned shift.',
    `location_id` BIGINT COMMENT 'The retail store or distribution center location where the shift swap is taking place.',
    `target_employee_associate_id` BIGINT COMMENT 'The employee who is being asked to swap shifts with the requesting employee. May be null if request is open to any qualified employee.',
    `approval_notes` STRING COMMENT 'Comments or notes provided by the approving manager regarding their decision on the shift swap request.',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when the shift swap request was officially approved by the authorized manager or system.',
    `auto_approved` BOOLEAN COMMENT 'Indicates whether the shift swap request was automatically approved by the system without manual manager intervention.',
    `completion_timestamp` TIMESTAMP COMMENT 'The date and time when the shift swap was fully executed and the schedule was updated to reflect the swap.',
    `compliance_check_status` STRING COMMENT 'Status of automated compliance validation checking labor laws, overtime rules, rest period requirements, and qualification matching.',
    `compliance_violation_details` STRING COMMENT 'Detailed description of any labor law or policy violations detected during compliance checking of the shift swap request.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this shift swap request record was first created in the system.',
    `expiration_timestamp` TIMESTAMP COMMENT 'The date and time after which the shift swap request is no longer valid and will automatically expire if not acted upon.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this shift swap request record was most recently updated or modified.',
    `notification_sent` BOOLEAN COMMENT 'Indicates whether notification has been sent to the target employee or manager about this shift swap request.',
    `notification_timestamp` TIMESTAMP COMMENT 'The date and time when notification was sent to relevant parties about the shift swap request.',
    `priority_level` STRING COMMENT 'The urgency or priority assigned to the shift swap request, influencing processing order and approval speed.',
    `rejection_reason` STRING COMMENT 'Explanation provided when a shift swap request is rejected, detailing why the request could not be approved.',
    `request_number` STRING COMMENT 'Human-readable business identifier for the shift swap request, formatted as SSR-YYYYMMDD sequence.',
    `request_reason` STRING COMMENT 'Free-text explanation provided by the requesting employee for why they need to swap shifts.',
    `request_reason_category` STRING COMMENT 'Categorical classification of the reason for the shift swap request for reporting and analytics purposes.',
    `request_status` STRING COMMENT 'Current lifecycle status of the shift swap request in the approval workflow.',
    `request_type` STRING COMMENT 'Classification of the swap request: direct (specific employee targeted), open (any qualified employee), or partial (portion of shift).',
    `requires_manager_approval` BOOLEAN COMMENT 'Indicates whether this shift swap request requires explicit manager approval or can be auto-approved based on business rules.',
    `response_timestamp` TIMESTAMP COMMENT 'The date and time when the target employee or manager responded to the shift swap request.',
    `submitted_timestamp` TIMESTAMP COMMENT 'The date and time when the shift swap request was originally submitted by the requesting employee.',
    `swap_effective_date` DATE COMMENT 'The date on which the shift swap will take effect and the new schedule assignments become active.',
    CONSTRAINT pk_shift_swap_request PRIMARY KEY(`shift_swap_request_id`)
) COMMENT 'Master reference table for shift_swap_request. Referenced by shift_swap_request_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`coverage_request` (
    `coverage_request_id` BIGINT COMMENT 'Primary key for coverage_request',
    `associate_id` BIGINT COMMENT 'Identifier of the manager or supervisor who approved or rejected the coverage request.',
    `coverage_associate_id` BIGINT COMMENT 'Identifier of the employee who is requesting coverage or whose shift needs coverage.',
    `coverage_covering_employee_associate_id` BIGINT COMMENT 'Identifier of the employee who has been assigned or volunteered to provide coverage.',
    `coverage_requesting_employee_associate_id` BIGINT COMMENT 'Identifier of the employee who initiated the coverage request, if different from the employee needing coverage.',
    `department_id` BIGINT COMMENT 'Identifier of the department within the store where coverage is required.',
    `location_id` BIGINT COMMENT 'Identifier of the retail store location where coverage is needed.',
    `superseded_coverage_request_id` BIGINT COMMENT 'Self-referencing FK on coverage_request (superseded_coverage_request_id)',
    `shift_schedule_id` BIGINT COMMENT 'Identifier of the specific shift that requires coverage.',
    `approval_date` DATE COMMENT 'Date when the coverage request was approved or rejected by the manager.',
    `approval_notes` STRING COMMENT 'Comments or notes provided by the approver explaining the approval or rejection decision.',
    `approval_required` BOOLEAN COMMENT 'Indicates whether managerial approval is required before coverage can be assigned.',
    `approval_timestamp` TIMESTAMP COMMENT 'Precise date and time when the coverage request approval or rejection decision was recorded.',
    `cancellation_date` DATE COMMENT 'Date when the coverage request was cancelled by the requester or system.',
    `cancellation_reason` STRING COMMENT 'Explanation provided for why the coverage request was cancelled.',
    `coverage_date` DATE COMMENT 'Date for which coverage is being requested.',
    `coverage_end_time` TIMESTAMP COMMENT 'Scheduled end date and time of the shift or period requiring coverage.',
    `coverage_start_time` TIMESTAMP COMMENT 'Scheduled start date and time of the shift or period requiring coverage.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this coverage request record was first created in the data platform.',
    `duration_hours` DECIMAL(18,2) COMMENT 'Total number of hours for which coverage is needed, calculated from start and end times.',
    `expiration_date` DATE COMMENT 'Date after which the coverage request is no longer valid if not fulfilled.',
    `fulfillment_date` DATE COMMENT 'Date when a covering employee was successfully assigned to fulfill the coverage request.',
    `fulfillment_timestamp` TIMESTAMP COMMENT 'Precise date and time when the coverage request was marked as fulfilled.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this coverage request record is currently active in the system.',
    `labor_cost_center` STRING COMMENT 'Cost center code to which labor costs for this coverage will be allocated.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this coverage request record was last updated in the data platform.',
    `notification_sent` BOOLEAN COMMENT 'Indicates whether notification has been sent to eligible employees about this coverage opportunity.',
    `notification_timestamp` TIMESTAMP COMMENT 'Date and time when notification was sent to eligible employees.',
    `premium_pay_eligible` BOOLEAN COMMENT 'Indicates whether the covering employee is eligible for premium pay or incentive compensation for this coverage.',
    `premium_pay_rate` DECIMAL(18,2) COMMENT 'Multiplier applied to base pay rate for coverage shifts, such as 1.5 for time-and-a-half.',
    `priority` STRING COMMENT 'Business priority level assigned to the coverage request based on operational impact.',
    `reason_code` STRING COMMENT 'Standardized code indicating the reason why coverage is needed.',
    `reason_description` STRING COMMENT 'Detailed explanation provided by the employee or manager describing why coverage is needed.',
    `request_date` DATE COMMENT 'Date when the coverage request was submitted by the employee or manager.',
    `request_number` STRING COMMENT 'Business-facing unique identifier for the coverage request, typically displayed to employees and managers.',
    `request_timestamp` TIMESTAMP COMMENT 'Precise date and time when the coverage request was created in the system.',
    `request_type` STRING COMMENT 'Classification of the coverage request indicating the reason for coverage need.',
    `response_count` STRING COMMENT 'Number of employees who responded to the coverage request notification.',
    `source_system_code` STRING COMMENT 'Unique identifier of this coverage request in the originating source system.',
    `coverage_request_status` STRING COMMENT 'Current lifecycle status of the coverage request in the approval and fulfillment workflow.',
    CONSTRAINT pk_coverage_request PRIMARY KEY(`coverage_request_id`)
) COMMENT 'Master reference table for coverage_request. Referenced by coverage_request_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`pay_period` (
    `pay_period_id` BIGINT COMMENT 'Primary key for pay_period',
    `payroll_calendar_id` BIGINT COMMENT 'add column payroll_calendar_id (BIGINT) with FK to workforce.payroll_calendar.payroll_calendar_id - pay periods belong to a payroll calendar and this structural relationship is missing',
    `prior_pay_period_id` BIGINT COMMENT 'Self-referencing FK on pay_period (prior_pay_period_id)',
    `approval_deadline` TIMESTAMP COMMENT 'The date and time by which managers must approve timesheets and time entries for this pay period.',
    `calendar_month` STRING COMMENT 'The calendar month in which this pay period starts (1-12).',
    `calendar_year` STRING COMMENT 'The calendar year in which this pay period starts (e.g., 2024).',
    `closed_timestamp` TIMESTAMP COMMENT 'The date and time when this pay period was officially closed for time entry and moved to processing status.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this pay period record was first created in the system.',
    `end_date` DATE COMMENT 'The last calendar date included in this pay period. Effective-until date for the pay period.',
    `finalized_timestamp` TIMESTAMP COMMENT 'The date and time when payroll processing was completed and the pay period was finalized.',
    `fiscal_quarter` STRING COMMENT 'The fiscal quarter within the fiscal year to which this pay period belongs (1, 2, 3, or 4).',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this pay period belongs (e.g., 2024).',
    `is_adjustment_period` BOOLEAN COMMENT 'Indicates whether this pay period allows for payroll adjustments or corrections from prior periods.',
    `is_holiday_period` BOOLEAN COMMENT 'Indicates whether this pay period includes major holidays that may affect scheduling or payroll processing.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this pay period record was last updated or modified.',
    `notes` STRING COMMENT 'Additional notes or comments about this pay period, such as special processing instructions or exceptions.',
    `overtime_eligible` BOOLEAN COMMENT 'Indicates whether overtime hours can be recorded and compensated during this pay period.',
    `pay_date` DATE COMMENT 'The date on which employees are paid for work performed during this pay period.',
    `payroll_cycle_code` STRING COMMENT 'Code identifying the specific payroll cycle or schedule this pay period belongs to (e.g., RETAIL-HOURLY, CORPORATE-SALARY).',
    `payroll_processing_date` DATE COMMENT 'The date on which payroll calculations and processing are executed for this pay period.',
    `period_name` STRING COMMENT 'Human-readable name or label for the pay period (e.g., PP01-2024, January 2024 - Period 1).',
    `period_number` STRING COMMENT 'Sequential number of the pay period within the fiscal or calendar year (e.g., 1, 2, 3...26 for bi-weekly).',
    `period_type` STRING COMMENT 'Classification of the pay period frequency (weekly, bi-weekly, semi-monthly, monthly).',
    `start_date` DATE COMMENT 'The first calendar date included in this pay period. Effective-from date for the pay period.',
    `pay_period_status` STRING COMMENT 'Current lifecycle status of the pay period indicating whether it is open for time entry, closed for processing, finalized, or archived.',
    `time_entry_method` STRING COMMENT 'Primary method used for time and attendance tracking during this pay period.',
    `timesheet_submission_deadline` TIMESTAMP COMMENT 'The date and time by which employees must submit their timesheets for this pay period.',
    `total_days_count` STRING COMMENT 'The total number of calendar days in this pay period.',
    `working_days_count` STRING COMMENT 'The number of standard working days (excluding weekends and holidays) within this pay period.',
    CONSTRAINT pk_pay_period PRIMARY KEY(`pay_period_id`)
) COMMENT 'Master reference table for pay_period. Referenced by pay_period_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`union` (
    `union_id` BIGINT COMMENT 'Primary key for union',
    `parent_union_id` BIGINT COMMENT 'Self-referencing FK on union (parent_union_id)',
    `abbreviation` STRING COMMENT 'Commonly used abbreviation or acronym for the union name (e.g., UFCW, SEIU, Teamsters).',
    `affiliation` STRING COMMENT 'Parent federation or umbrella organization the union is affiliated with (e.g., AFL-CIO, Change to Win).',
    `bargaining_unit_description` STRING COMMENT 'Description of the employee group or job classifications covered by this union for collective bargaining purposes.',
    `certification_date` DATE COMMENT 'Date when the union was certified by the National Labor Relations Board or equivalent authority.',
    `union_code` STRING COMMENT 'Short alphanumeric code representing the union, used for external identification and reporting purposes.',
    `contact_email` STRING COMMENT 'Primary email address for union correspondence and official communications.',
    `contact_person_name` STRING COMMENT 'Full name of the primary union representative or business agent for communication and coordination.',
    `contact_phone` STRING COMMENT 'Primary telephone number for reaching the union representative or office.',
    `contract_effective_date` DATE COMMENT 'Date when the current collective bargaining agreement with this union became effective.',
    `contract_expiration_date` DATE COMMENT 'Date when the current collective bargaining agreement with this union expires.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this union record was first created in the system.',
    `decertification_date` DATE COMMENT 'Date when the union was decertified or lost its bargaining rights, if applicable.',
    `dues_amount` DECIMAL(18,2) COMMENT 'Standard union dues amount charged per payment period, in the organizations base currency.',
    `dues_calculation_method` STRING COMMENT 'Method used to calculate union dues for member employees.',
    `dues_frequency` STRING COMMENT 'Frequency at which union dues are collected from member employees.',
    `grievance_procedure_description` STRING COMMENT 'Summary of the formal grievance and dispute resolution process established in the collective bargaining agreement.',
    `initiation_fee_amount` DECIMAL(18,2) COMMENT 'One-time fee charged to new union members upon joining, in the organizations base currency.',
    `is_right_to_work_applicable` BOOLEAN COMMENT 'Indicates whether right-to-work laws apply to this unions jurisdiction, affecting mandatory membership requirements.',
    `jurisdiction` STRING COMMENT 'Geographic or operational scope of the unions authority (e.g., regional, national, store-specific).',
    `local_number` STRING COMMENT 'Identifier for the local chapter or branch of the union, if applicable.',
    `member_count` STRING COMMENT 'Current number of employees who are members of this union within the organization.',
    `union_name` STRING COMMENT 'Full legal name of the labor union or collective bargaining organization.',
    `national_union_name` STRING COMMENT 'Name of the national or international union body that the local union is part of.',
    `notes` STRING COMMENT 'Additional notes, comments, or special considerations related to this union relationship.',
    `office_address_line1` STRING COMMENT 'First line of the union office street address including building number and street name.',
    `office_address_line2` STRING COMMENT 'Second line of the union office address for suite, floor, or additional location details.',
    `office_city` STRING COMMENT 'City where the union office is located.',
    `office_country_code` STRING COMMENT 'Three-letter ISO country code for the union office location.',
    `office_postal_code` STRING COMMENT 'Postal or ZIP code for the union office location.',
    `office_state_province` STRING COMMENT 'State or province where the union office is located.',
    `recognition_date` DATE COMMENT 'Date when the union was officially recognized as the collective bargaining representative for employees.',
    `union_status` STRING COMMENT 'Current operational status of the union relationship with the organization.',
    `union_type` STRING COMMENT 'Classification of the union based on its organizational structure and membership scope.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this union record was last modified in the system.',
    `website_url` STRING COMMENT 'Official website address for the union organization.',
    CONSTRAINT pk_union PRIMARY KEY(`union_id`)
) COMMENT 'Master reference table for union. Referenced by union_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` (
    `bargaining_unit_id` BIGINT COMMENT 'Primary key for bargaining_unit',
    `parent_bargaining_unit_id` BIGINT COMMENT 'Self-referencing FK on bargaining_unit (parent_bargaining_unit_id)',
    `union_id` BIGINT COMMENT 'add column union_id (BIGINT) with FK to workforce.union.union_id - bargaining units are organized under unions and this relationship is fundamental to labor relations',
    `certification_date` DATE COMMENT 'Date when the bargaining unit was officially certified by the National Labor Relations Board or equivalent regulatory body.',
    `certification_number` STRING COMMENT 'Official certification or registration number issued by the labor relations board for this bargaining unit.',
    `contract_document_reference` STRING COMMENT 'Reference identifier or file path to the official collective bargaining agreement document.',
    `contract_effective_date` DATE COMMENT 'Date when the current collective bargaining agreement became effective for this bargaining unit.',
    `contract_expiration_date` DATE COMMENT 'Date when the current collective bargaining agreement expires and requires renegotiation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this bargaining unit record was first created in the system.',
    `dues_amount` DECIMAL(18,2) COMMENT 'Standard union dues amount deducted per pay period for members of this bargaining unit.',
    `dues_frequency` STRING COMMENT 'Frequency at which union dues are deducted from member paychecks.',
    `eligible_employee_count` STRING COMMENT 'Total number of employees eligible for membership in this bargaining unit based on job classification and location.',
    `geographic_scope` STRING COMMENT 'Geographic coverage area of the bargaining unit indicating whether it spans multiple locations or is site-specific.',
    `grievance_procedure_reference` STRING COMMENT 'Reference to the documented grievance and dispute resolution procedure applicable to this bargaining unit.',
    `health_benefits_plan_code` STRING COMMENT 'Code identifying the specific health insurance plan available to members of this bargaining unit.',
    `jurisdiction_state` STRING COMMENT 'Primary state or jurisdiction under which this bargaining unit operates and is regulated.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this bargaining unit record was most recently updated.',
    `last_negotiation_date` DATE COMMENT 'Date when the most recent collective bargaining negotiation session was completed for this unit.',
    `last_strike_date` DATE COMMENT 'Date of the most recent strike or work stoppage action by this bargaining unit.',
    `member_count` STRING COMMENT 'Current number of employees who are members of this bargaining unit.',
    `next_negotiation_scheduled_date` DATE COMMENT 'Scheduled date for the next collective bargaining negotiation session or contract renewal discussion.',
    `nlrb_region` STRING COMMENT 'NLRB regional office jurisdiction responsible for oversight of this bargaining unit.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, special conditions, or historical context related to this bargaining unit.',
    `overtime_rules_reference` STRING COMMENT 'Reference to the specific overtime calculation and eligibility rules applicable to this bargaining unit.',
    `pension_plan_code` STRING COMMENT 'Code identifying the pension or retirement plan applicable to members of this bargaining unit.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary union representative for official communications regarding this bargaining unit.',
    `primary_contact_name` STRING COMMENT 'Full name of the primary union representative or steward for this bargaining unit.',
    `primary_contact_phone` STRING COMMENT 'Phone number of the primary union representative for this bargaining unit.',
    `seniority_system_type` STRING COMMENT 'Type of seniority system used for this bargaining unit to determine benefits, layoffs, and promotions.',
    `shift_differential_applicable` BOOLEAN COMMENT 'Indicates whether shift differential pay applies to members of this bargaining unit for non-standard shifts.',
    `bargaining_unit_status` STRING COMMENT 'Current lifecycle status of the bargaining unit indicating whether it is actively recognized and operational.',
    `strike_history_flag` BOOLEAN COMMENT 'Indicates whether this bargaining unit has a history of strike actions or work stoppages.',
    `union_affiliation` STRING COMMENT 'Name of the labor union or labor organization representing this bargaining unit.',
    `union_local_number` STRING COMMENT 'Local chapter or branch number of the union representing this bargaining unit.',
    `unit_code` STRING COMMENT 'Short alphanumeric code used to identify the bargaining unit in operational systems and payroll processing.',
    `unit_description` STRING COMMENT 'Detailed description of the bargaining unit including scope, coverage, and purpose.',
    `unit_name` STRING COMMENT 'Full official name of the bargaining unit as recognized in collective bargaining agreements.',
    `unit_type` STRING COMMENT 'Classification of the bargaining unit based on the type of workforce or operational area it represents.',
    `wage_scale_reference` STRING COMMENT 'Reference identifier to the wage scale or pay grade structure defined in the collective bargaining agreement for this unit.',
    CONSTRAINT pk_bargaining_unit PRIMARY KEY(`bargaining_unit_id`)
) COMMENT 'Master reference table for bargaining_unit. Referenced by bargaining_unit_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` (
    `payroll_calendar_id` BIGINT COMMENT 'Primary key for payroll_calendar',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system account that created this payroll calendar record.',
    `org_unit_id` BIGINT COMMENT 'Reference to the business unit or division that uses this payroll calendar.',
    `last_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the user or system account that last modified this payroll calendar record.',
    `legal_entity_id` BIGINT COMMENT 'Reference to the legal entity that owns and operates this payroll calendar.',
    `prior_payroll_calendar_id` BIGINT COMMENT 'Self-referencing FK on payroll_calendar (prior_payroll_calendar_id)',
    `adjustment_period_flag` BOOLEAN COMMENT 'Indicates whether this period allows payroll adjustments or corrections from prior periods.',
    `approval_deadline` TIMESTAMP COMMENT 'Date and time by which payroll must be approved by authorized personnel before processing.',
    `calendar_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the payroll calendar in external systems and reports.',
    `calendar_month` STRING COMMENT 'Calendar month (1-12) to which this payroll calendar period primarily belongs.',
    `calendar_name` STRING COMMENT 'Business-friendly name of the payroll calendar (e.g., Bi-Weekly US Hourly, Monthly Salaried, Weekly Store Associates).',
    `calendar_type` STRING COMMENT 'Frequency type of the payroll calendar indicating how often payroll is processed.',
    `calendar_year` STRING COMMENT 'Calendar year to which this payroll calendar period belongs.',
    `check_date` DATE COMMENT 'Date printed on physical paychecks or used as the transaction date for direct deposits.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the country jurisdiction for this payroll calendar.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll calendar record was first created in the system.',
    `payroll_calendar_description` STRING COMMENT 'Detailed description of the payroll calendar including its purpose, coverage, and any special processing rules.',
    `effective_end_date` DATE COMMENT 'Date when this payroll calendar ceases to be effective. Null for open-ended calendars.',
    `effective_start_date` DATE COMMENT 'Date when this payroll calendar becomes effective and can be used for payroll processing.',
    `employee_group_code` STRING COMMENT 'Code identifying the employee group or classification that uses this payroll calendar (e.g., hourly, salaried, union, non-union).',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter (1-4) to which this payroll calendar period belongs.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which this payroll calendar period belongs.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this payroll calendar record was last updated or modified.',
    `notes` STRING COMMENT 'Additional notes or comments about this payroll calendar period, including any exceptions or special circumstances.',
    `off_cycle_flag` BOOLEAN COMMENT 'Indicates whether this is an off-cycle payroll run (true) or a regular scheduled payroll (false).',
    `pay_date` DATE COMMENT 'Date when employees are paid for the corresponding pay period.',
    `pay_period_end_date` DATE COMMENT 'Last day of the pay period covered by this payroll calendar entry.',
    `pay_period_start_date` DATE COMMENT 'First day of the pay period covered by this payroll calendar entry.',
    `payroll_processing_date` DATE COMMENT 'Date when payroll processing is scheduled to run for this pay period.',
    `period_number` STRING COMMENT 'Sequential number of the pay period within the fiscal or calendar year (e.g., 1-26 for bi-weekly, 1-12 for monthly).',
    `payroll_calendar_status` STRING COMMENT 'Current lifecycle status of the payroll calendar indicating whether it is actively used for payroll processing.',
    `timesheet_submission_deadline` TIMESTAMP COMMENT 'Date and time by which employees must submit timesheets for this pay period.',
    `total_days_count` STRING COMMENT 'Total number of calendar days in the pay period.',
    `workday_calendar_code` STRING COMMENT 'External identifier for this payroll calendar in Workday HCM system for integration and synchronization.',
    `working_days_count` STRING COMMENT 'Number of working days within the pay period, excluding weekends and holidays.',
    `year_end_flag` BOOLEAN COMMENT 'Indicates whether this is the final payroll period of the fiscal or calendar year requiring special year-end processing.',
    CONSTRAINT pk_payroll_calendar PRIMARY KEY(`payroll_calendar_id`)
) COMMENT 'Master reference table for payroll_calendar. Referenced by payroll_calendar_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ADD CONSTRAINT `fk_workforce_associate_collective_bargaining_agreement_id` FOREIGN KEY (`collective_bargaining_agreement_id`) REFERENCES `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement`(`collective_bargaining_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ADD CONSTRAINT `fk_workforce_associate_manager_associate_id` FOREIGN KEY (`manager_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ADD CONSTRAINT `fk_workforce_job_profile_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_coverage_request_id` FOREIGN KEY (`coverage_request_id`) REFERENCES `vibe_retail_v1`.`workforce`.`coverage_request`(`coverage_request_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_shift_associate_id` FOREIGN KEY (`shift_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_shift_swap_request_id` FOREIGN KEY (`shift_swap_request_id`) REFERENCES `vibe_retail_v1`.`workforce`.`shift_swap_request`(`shift_swap_request_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_pay_period_id` FOREIGN KEY (`pay_period_id`) REFERENCES `vibe_retail_v1`.`workforce`.`pay_period`(`pay_period_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_shift_schedule_id` FOREIGN KEY (`shift_schedule_id`) REFERENCES `vibe_retail_v1`.`workforce`.`shift_schedule`(`shift_schedule_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_time_associate_id` FOREIGN KEY (`time_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ADD CONSTRAINT `fk_workforce_payroll_record_payroll_run_id` FOREIGN KEY (`payroll_run_id`) REFERENCES `vibe_retail_v1`.`workforce`.`payroll_run`(`payroll_run_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ADD CONSTRAINT `fk_workforce_payroll_record_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ADD CONSTRAINT `fk_workforce_payroll_record_shift_schedule_id` FOREIGN KEY (`shift_schedule_id`) REFERENCES `vibe_retail_v1`.`workforce`.`shift_schedule`(`shift_schedule_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_shift_schedule_id` FOREIGN KEY (`shift_schedule_id`) REFERENCES `vibe_retail_v1`.`workforce`.`shift_schedule`(`shift_schedule_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_tertiary_leave_hr_reviewer_associate_id` FOREIGN KEY (`tertiary_leave_hr_reviewer_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ADD CONSTRAINT `fk_workforce_benefit_enrollment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ADD CONSTRAINT `fk_workforce_benefit_enrollment_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_tertiary_performance_hr_reviewer_associate_id` FOREIGN KEY (`tertiary_performance_hr_reviewer_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ADD CONSTRAINT `fk_workforce_training_enrollment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ADD CONSTRAINT `fk_workforce_training_enrollment_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_candidate_id` FOREIGN KEY (`candidate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`candidate`(`candidate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_requisition_id` FOREIGN KEY (`requisition_id`) REFERENCES `vibe_retail_v1`.`workforce`.`requisition`(`requisition_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_tertiary_job_modified_by_user_associate_id` FOREIGN KEY (`tertiary_job_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_tertiary_labor_modified_by_user_associate_id` FOREIGN KEY (`tertiary_labor_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_merit_cycle_id` FOREIGN KEY (`merit_cycle_id`) REFERENCES `vibe_retail_v1`.`workforce`.`merit_cycle`(`merit_cycle_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_performance_review_id` FOREIGN KEY (`performance_review_id`) REFERENCES `vibe_retail_v1`.`workforce`.`performance_review`(`performance_review_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_tertiary_compensation_hr_approver_associate_id` FOREIGN KEY (`tertiary_compensation_hr_approver_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_parent_org_unit_id` FOREIGN KEY (`parent_org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_renewed_from_wf_certification_id` FOREIGN KEY (`renewed_from_wf_certification_id`) REFERENCES `vibe_retail_v1`.`workforce`.`wf_certification`(`wf_certification_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_tertiary_wf_modified_by_user_associate_id` FOREIGN KEY (`tertiary_wf_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ADD CONSTRAINT `fk_workforce_staffing_plan_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ADD CONSTRAINT `fk_workforce_staffing_plan_job_profile_id` FOREIGN KEY (`job_profile_id`) REFERENCES `vibe_retail_v1`.`workforce`.`job_profile`(`job_profile_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ADD CONSTRAINT `fk_workforce_staffing_plan_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` ADD CONSTRAINT `fk_workforce_dashboard_access_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ADD CONSTRAINT `fk_workforce_workforce_kpi_target_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ADD CONSTRAINT `fk_workforce_workforce_kpi_target_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ADD CONSTRAINT `fk_workforce_org_unit_compliance_scope_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` ADD CONSTRAINT `fk_workforce_collective_bargaining_agreement_bargaining_unit_id` FOREIGN KEY (`bargaining_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`bargaining_unit`(`bargaining_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` ADD CONSTRAINT `fk_workforce_collective_bargaining_agreement_superseded_collective_bargaining_agreement_id` FOREIGN KEY (`superseded_collective_bargaining_agreement_id`) REFERENCES `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement`(`collective_bargaining_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` ADD CONSTRAINT `fk_workforce_collective_bargaining_agreement_union_id` FOREIGN KEY (`union_id`) REFERENCES `vibe_retail_v1`.`workforce`.`union`(`union_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` ADD CONSTRAINT `fk_workforce_collective_bargaining_agreement_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`merit_cycle` ADD CONSTRAINT `fk_workforce_merit_cycle_prior_merit_cycle_id` FOREIGN KEY (`prior_merit_cycle_id`) REFERENCES `vibe_retail_v1`.`workforce`.`merit_cycle`(`merit_cycle_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` ADD CONSTRAINT `fk_workforce_candidate_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` ADD CONSTRAINT `fk_workforce_candidate_requisition_id` FOREIGN KEY (`requisition_id`) REFERENCES `vibe_retail_v1`.`workforce`.`requisition`(`requisition_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` ADD CONSTRAINT `fk_workforce_candidate_referred_by_candidate_id` FOREIGN KEY (`referred_by_candidate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`candidate`(`candidate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_payroll_associate_id` FOREIGN KEY (`payroll_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_payroll_calendar_id` FOREIGN KEY (`payroll_calendar_id`) REFERENCES `vibe_retail_v1`.`workforce`.`payroll_calendar`(`payroll_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_payroll_reversal_of_run_id` FOREIGN KEY (`payroll_reversal_of_run_id`) REFERENCES `vibe_retail_v1`.`workforce`.`payroll_run`(`payroll_run_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_primary_reversal_payroll_run_id` FOREIGN KEY (`primary_reversal_payroll_run_id`) REFERENCES `vibe_retail_v1`.`workforce`.`payroll_run`(`payroll_run_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ADD CONSTRAINT `fk_workforce_shift_swap_request_counterpart_shift_swap_request_id` FOREIGN KEY (`counterpart_shift_swap_request_id`) REFERENCES `vibe_retail_v1`.`workforce`.`shift_swap_request`(`shift_swap_request_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ADD CONSTRAINT `fk_workforce_shift_swap_request_shift_schedule_id` FOREIGN KEY (`shift_schedule_id`) REFERENCES `vibe_retail_v1`.`workforce`.`shift_schedule`(`shift_schedule_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ADD CONSTRAINT `fk_workforce_shift_swap_request_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ADD CONSTRAINT `fk_workforce_shift_swap_request_shift_associate_id` FOREIGN KEY (`shift_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ADD CONSTRAINT `fk_workforce_shift_swap_request_target_employee_associate_id` FOREIGN KEY (`target_employee_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_coverage_associate_id` FOREIGN KEY (`coverage_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_coverage_covering_employee_associate_id` FOREIGN KEY (`coverage_covering_employee_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_coverage_requesting_employee_associate_id` FOREIGN KEY (`coverage_requesting_employee_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_superseded_coverage_request_id` FOREIGN KEY (`superseded_coverage_request_id`) REFERENCES `vibe_retail_v1`.`workforce`.`coverage_request`(`coverage_request_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_shift_schedule_id` FOREIGN KEY (`shift_schedule_id`) REFERENCES `vibe_retail_v1`.`workforce`.`shift_schedule`(`shift_schedule_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`pay_period` ADD CONSTRAINT `fk_workforce_pay_period_payroll_calendar_id` FOREIGN KEY (`payroll_calendar_id`) REFERENCES `vibe_retail_v1`.`workforce`.`payroll_calendar`(`payroll_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`pay_period` ADD CONSTRAINT `fk_workforce_pay_period_prior_pay_period_id` FOREIGN KEY (`prior_pay_period_id`) REFERENCES `vibe_retail_v1`.`workforce`.`pay_period`(`pay_period_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`union` ADD CONSTRAINT `fk_workforce_union_parent_union_id` FOREIGN KEY (`parent_union_id`) REFERENCES `vibe_retail_v1`.`workforce`.`union`(`union_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` ADD CONSTRAINT `fk_workforce_bargaining_unit_parent_bargaining_unit_id` FOREIGN KEY (`parent_bargaining_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`bargaining_unit`(`bargaining_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` ADD CONSTRAINT `fk_workforce_bargaining_unit_union_id` FOREIGN KEY (`union_id`) REFERENCES `vibe_retail_v1`.`workforce`.`union`(`union_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` ADD CONSTRAINT `fk_workforce_payroll_calendar_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` ADD CONSTRAINT `fk_workforce_payroll_calendar_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` ADD CONSTRAINT `fk_workforce_payroll_calendar_last_modified_by_user_associate_id` FOREIGN KEY (`last_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` ADD CONSTRAINT `fk_workforce_payroll_calendar_prior_payroll_calendar_id` FOREIGN KEY (`prior_payroll_calendar_id`) REFERENCES `vibe_retail_v1`.`workforce`.`payroll_calendar`(`payroll_calendar_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`workforce` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_retail_v1`.`workforce` SET TAGS ('dbx_domain' = 'workforce');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` SET TAGS ('dbx_subdomain' = 'employee_master');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Associate Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `collective_bargaining_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement (CBA) Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Distribution Center (DC) Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Store Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `manager_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Manager Associate Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `badge_number` SET TAGS ('dbx_business_glossary_term' = 'Employee Badge Number');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Work Email Address');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `employment_status` SET TAGS ('dbx_value_regex' = 'active|leave-of-absence|suspended|terminated');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'full-time|part-time|seasonal|temporary|contractor|intern');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `flsa_status` SET TAGS ('dbx_business_glossary_term' = 'Fair Labor Standards Act (FLSA) Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `flsa_status` SET TAGS ('dbx_value_regex' = 'exempt|non-exempt');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `hr_business_partner_name` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Business Partner Name');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `i9_document_type` SET TAGS ('dbx_business_glossary_term' = 'Form I-9 Document Type');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `i9_verification_date` SET TAGS ('dbx_business_glossary_term' = 'Form I-9 Verification Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `pay_type` SET TAGS ('dbx_value_regex' = 'hourly|salaried');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Work Phone Number');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `primary_work_location_type` SET TAGS ('dbx_value_regex' = 'store|distribution-center|corporate-office|regional-office|remote');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'voluntary|involuntary|retirement|layoff|end-of-season|end-of-contract');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `work_authorization_status` SET TAGS ('dbx_value_regex' = 'citizen|permanent-resident|work-visa|employment-authorization');
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ALTER COLUMN `workday_worker_code` SET TAGS ('dbx_business_glossary_term' = 'Workday Worker Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` SET TAGS ('dbx_subdomain' = 'employee_master');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `eeoc_job_category` SET TAGS ('dbx_business_glossary_term' = 'Equal Employment Opportunity Commission (EEOC) Job Category');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'full-time|part-time|seasonal|temporary|contractor');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `flsa_classification` SET TAGS ('dbx_business_glossary_term' = 'Fair Labor Standards Act (FLSA) Classification');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `flsa_classification` SET TAGS ('dbx_value_regex' = 'exempt|non-exempt');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `is_dc_facing` SET TAGS ('dbx_business_glossary_term' = 'Is Distribution Center (DC) Facing');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `job_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `job_profile_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|obsolete');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'store|distribution-center|corporate-office|remote|field');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `onet_code` SET TAGS ('dbx_business_glossary_term' = 'Occupational Information Network (O*NET) Code');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `onet_code` SET TAGS ('dbx_value_regex' = '^[0-9]{2}-[0-9]{4}.[0-9]{2}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_value_regex' = 'hourly|salary|commission');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `required_education_level` SET TAGS ('dbx_value_regex' = 'high-school|associate|bachelor|master|doctorate|none');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `span_of_control_max` SET TAGS ('dbx_business_glossary_term' = 'Span of Control Maximum');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `span_of_control_min` SET TAGS ('dbx_business_glossary_term' = 'Span of Control Minimum');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_profile` ALTER COLUMN `succession_planning_tier` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|not-applicable');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` SET TAGS ('dbx_subdomain' = 'scheduling_operations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_value_regex' = 'low_traffic|weather|employee_absence|operational_change|employee_request|other');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `employee_availability_match` SET TAGS ('dbx_value_regex' = 'full_match|partial_match|no_match|not_specified');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_source` SET TAGS ('dbx_value_regex' = 'auto_generated|manager_assigned|employee_requested|shift_swap|coverage_request');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_value_regex' = 'draft|published|confirmed|cancelled|completed');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_priority` SET TAGS ('dbx_value_regex' = 'critical|high|normal|low');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ALTER COLUMN `shift_type` SET TAGS ('dbx_value_regex' = 'opening|mid|closing|overnight|split|on_call');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` SET TAGS ('dbx_subdomain' = 'scheduling_operations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `shift_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `time_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|auto_approved|under_review');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `exception_type` SET TAGS ('dbx_value_regex' = 'missed_punch|early_departure|late_arrival|unscheduled_overtime|no_break_taken|extended_break');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `overtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Overtime (OT) Hours');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `payroll_batch_code` SET TAGS ('dbx_business_glossary_term' = 'Payroll Batch ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `shift_differential_type` SET TAGS ('dbx_value_regex' = 'night_shift|weekend|holiday|closing_shift|opening_shift');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `source` SET TAGS ('dbx_value_regex' = 'time_clock|mobile_app|manual_entry|workday_hcm|pos_terminal|biometric_scanner');
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ALTER COLUMN `time_clock_device_code` SET TAGS ('dbx_business_glossary_term' = 'Time Clock Device ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `shift_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Schedule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `bank_account_last_four_digits` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `overtime_hours_worked` SET TAGS ('dbx_business_glossary_term' = 'Overtime (OT) Hours Worked');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `overtime_pay_amount` SET TAGS ('dbx_business_glossary_term' = 'Overtime (OT) Pay Amount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_value_regex' = 'weekly|biweekly|semimonthly|monthly');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'direct_deposit|paper_check|paycard|cash');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `payroll_status` SET TAGS ('dbx_value_regex' = 'calculated|approved|paid|voided|pending|error');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `year_to_date_federal_tax_withheld_amount` SET TAGS ('dbx_business_glossary_term' = 'Year-to-Date (YTD) Federal Tax Withheld Amount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ALTER COLUMN `year_to_date_gross_pay_amount` SET TAGS ('dbx_business_glossary_term' = 'Year-to-Date (YTD) Gross Pay Amount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` SET TAGS ('dbx_subdomain' = 'scheduling_operations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `shift_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Schedule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `tertiary_leave_hr_reviewer_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Reviewer ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'Pending|Approved|Denied|Cancelled|Withdrawn');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `fmla_designation_status` SET TAGS ('dbx_business_glossary_term' = 'Family and Medical Leave Act (FMLA) Designation Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `fmla_designation_status` SET TAGS ('dbx_value_regex' = 'Not Applicable|Pending|Designated|Not Designated');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `fmla_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Family and Medical Leave Act (FMLA) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `hr_review_date` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Review Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `hr_review_notes` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Review Notes');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `hr_review_status` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Review Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `hr_review_status` SET TAGS ('dbx_value_regex' = 'Not Required|Pending|Reviewed|Escalated');
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ALTER COLUMN `source_system_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_1095c_offer_code` SET TAGS ('dbx_business_glossary_term' = 'Affordable Care Act (ACA) Form 1095-C Offer of Coverage Code');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_1095c_offer_code` SET TAGS ('dbx_value_regex' = '^1[A-J]$|^$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_1095c_safe_harbor_code` SET TAGS ('dbx_business_glossary_term' = 'Affordable Care Act (ACA) Form 1095-C Safe Harbor Code');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_1095c_safe_harbor_code` SET TAGS ('dbx_value_regex' = '^2[A-H]$|^$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Affordable Care Act (ACA) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_measurement_period_end` SET TAGS ('dbx_business_glossary_term' = 'Affordable Care Act (ACA) Measurement Period End Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_measurement_period_start` SET TAGS ('dbx_business_glossary_term' = 'Affordable Care Act (ACA) Measurement Period Start Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_stability_period_end` SET TAGS ('dbx_business_glossary_term' = 'Affordable Care Act (ACA) Stability Period End Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `aca_stability_period_start` SET TAGS ('dbx_business_glossary_term' = 'Affordable Care Act (ACA) Stability Period Start Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `cobra_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Consolidated Omnibus Budget Reconciliation Act (COBRA) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `coverage_tier` SET TAGS ('dbx_value_regex' = 'employee_only|employee_spouse|employee_children|employee_family|not_applicable');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `employee_contribution_frequency` SET TAGS ('dbx_value_regex' = 'weekly|biweekly|semimonthly|monthly|annual|per_pay_period');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `employer_contribution_frequency` SET TAGS ('dbx_value_regex' = 'weekly|biweekly|semimonthly|monthly|annual|per_pay_period');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_method` SET TAGS ('dbx_value_regex' = 'online_self_service|paper_form|phone|hr_representative|auto_enrollment|default');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_source` SET TAGS ('dbx_value_regex' = 'open_enrollment|new_hire|qualifying_life_event|administrative_correction|rehire|cobra');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `enrollment_status` SET TAGS ('dbx_value_regex' = 'active|terminated|pending|waived|suspended|cancelled');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Benefit Plan Name');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `plan_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `qualifying_life_event_date` SET TAGS ('dbx_business_glossary_term' = 'Qualifying Life Event (QLE) Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `qualifying_life_event_type` SET TAGS ('dbx_business_glossary_term' = 'Qualifying Life Event (QLE) Type');
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ALTER COLUMN `source_system_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` SET TAGS ('dbx_subdomain' = 'talent_acquisition');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `tertiary_performance_hr_reviewer_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Reviewer ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `action_type` SET TAGS ('dbx_value_regex' = 'performance_review|verbal_warning|written_warning|final_warning|suspension|termination');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `appeal_outcome` SET TAGS ('dbx_value_regex' = 'upheld|overturned|modified|pending');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `calibration_status` SET TAGS ('dbx_value_regex' = 'pending|calibrated|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `competency_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `goal_achievement_rating` SET TAGS ('dbx_value_regex' = 'exceeded|achieved|partially_achieved|not_achieved');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `hr_review_status` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Review Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `hr_review_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|under_review');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `overall_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Performance Rating');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `overall_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `performance_review_status` SET TAGS ('dbx_business_glossary_term' = 'Review Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `performance_review_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `pip_end_date` SET TAGS ('dbx_business_glossary_term' = 'Performance Improvement Plan (PIP) End Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `pip_flag` SET TAGS ('dbx_business_glossary_term' = 'Performance Improvement Plan (PIP) Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `pip_start_date` SET TAGS ('dbx_business_glossary_term' = 'Performance Improvement Plan (PIP) Start Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `policy_violation_category` SET TAGS ('dbx_value_regex' = 'attendance|conduct|safety|theft|harassment|insubordination');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `review_type` SET TAGS ('dbx_value_regex' = 'annual|mid_year|probationary|90_day|project_based|pip');
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ALTER COLUMN `self_assessment_comments` SET TAGS ('dbx_business_glossary_term' = 'Self-Assessment Comments');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` SET TAGS ('dbx_subdomain' = 'talent_acquisition');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Training Cost Amount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'in_store|e_learning|classroom|on_the_job|virtual_instructor_led|blended');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Training Due Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `enrollment_source` SET TAGS ('dbx_value_regex' = 'manager_assigned|self_enrolled|hr_assigned|system_triggered|onboarding_workflow');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `feedback_comments` SET TAGS ('dbx_business_glossary_term' = 'Training Feedback Comments');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `feedback_rating` SET TAGS ('dbx_business_glossary_term' = 'Training Feedback Rating');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `pass_fail_indicator` SET TAGS ('dbx_value_regex' = 'pass|fail|not_applicable');
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ALTER COLUMN `score` SET TAGS ('dbx_business_glossary_term' = 'Training Score');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` SET TAGS ('dbx_subdomain' = 'talent_acquisition');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Hiring Manager ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `budgeted_salary_max` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Salary Maximum');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `budgeted_salary_min` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Salary Minimum');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Requisition Close Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `eeo_job_category` SET TAGS ('dbx_business_glossary_term' = 'Equal Employment Opportunity (EEO) Job Category');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'full_time|part_time|seasonal|temporary|contractor');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `flsa_status` SET TAGS ('dbx_business_glossary_term' = 'Fair Labor Standards Act (FLSA) Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `flsa_status` SET TAGS ('dbx_value_regex' = 'exempt|non_exempt');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `hiring_location_type` SET TAGS ('dbx_value_regex' = 'store|distribution_center|corporate_office|regional_hub|fulfillment_center');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `minimum_education_level` SET TAGS ('dbx_value_regex' = 'none|high_school|associate|bachelor|master|doctorate');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Requisition Open Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_value_regex' = 'hourly|weekly|biweekly|semimonthly|monthly|annual');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_value_regex' = '^REQ-[0-9]{6,10}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `requisition_type` SET TAGS ('dbx_value_regex' = 'backfill|new_headcount|seasonal|temporary|contractor|intern');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `salary_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `time_to_fill_sla_days` SET TAGS ('dbx_business_glossary_term' = 'Time-to-Fill Service Level Agreement (SLA) Days');
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ALTER COLUMN `travel_requirement_pct` SET TAGS ('dbx_business_glossary_term' = 'Travel Requirement Percentage');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` SET TAGS ('dbx_subdomain' = 'talent_acquisition');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Recruiter ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `tertiary_job_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `application_number` SET TAGS ('dbx_value_regex' = '^APP-[0-9]{8}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `background_check_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|clear|flagged|failed');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `disability_status` SET TAGS ('dbx_value_regex' = 'not_disclosed|yes|no');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `drug_screen_status` SET TAGS ('dbx_value_regex' = 'not_required|scheduled|completed|passed|failed');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `is_internal_candidate` SET TAGS ('dbx_business_glossary_term' = 'Internal Candidate Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `is_rehire` SET TAGS ('dbx_business_glossary_term' = 'Rehire Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `offer_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `source_channel` SET TAGS ('dbx_value_regex' = 'career_site|referral|job_board|agency|walk_in|social_media');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `time_to_hire_days` SET TAGS ('dbx_business_glossary_term' = 'Time to Hire (Days)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ALTER COLUMN `veteran_status` SET TAGS ('dbx_value_regex' = 'not_disclosed|veteran|non_veteran|protected_veteran');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Owner Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `tertiary_labor_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `budget_version_code` SET TAGS ('dbx_value_regex' = 'baseline|initial|revised|approved|final');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `budgeted_labor_cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `budgeted_overtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Overtime (OT) Hours');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `planned_fte_count` SET TAGS ('dbx_business_glossary_term' = 'Planned Full-Time Equivalent (FTE) Count');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `planned_full_time_headcount` SET TAGS ('dbx_business_glossary_term' = 'Planned Full-Time Headcount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `planned_part_time_headcount` SET TAGS ('dbx_business_glossary_term' = 'Planned Part-Time Headcount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ALTER COLUMN `planning_period_type` SET TAGS ('dbx_value_regex' = 'week|month|quarter|fiscal_year');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `performance_review_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `tertiary_compensation_hr_approver_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Approver ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Approved Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Reason');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `change_type` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Type');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `change_type` SET TAGS ('dbx_value_regex' = 'merit|promotion|equity|market_adjustment|cola|demotion');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `compa_ratio_after` SET TAGS ('dbx_business_glossary_term' = 'Compa-Ratio After Change');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `compa_ratio_before` SET TAGS ('dbx_business_glossary_term' = 'Compa-Ratio Before Change');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `hr_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Human Resources (HR) Approval Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `hr_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|cancelled');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `is_lump_sum` SET TAGS ('dbx_business_glossary_term' = 'Is Lump Sum Payment');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `is_retroactive` SET TAGS ('dbx_business_glossary_term' = 'Is Retroactive Payment');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `lump_sum_amount` SET TAGS ('dbx_business_glossary_term' = 'Lump Sum Payment Amount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Notes');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_value_regex' = 'hourly|weekly|biweekly|semimonthly|monthly|annual');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `processed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Processed Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Rejection Reason');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `retroactive_amount` SET TAGS ('dbx_business_glossary_term' = 'Retroactive Payment Amount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `retroactive_start_date` SET TAGS ('dbx_business_glossary_term' = 'Retroactive Payment Start Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Compensation Change Submitted Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` SET TAGS ('dbx_subdomain' = 'employee_master');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Physical Location ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `parent_org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Organizational Unit ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Manager Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_code` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Code');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `external_system_code` SET TAGS ('dbx_business_glossary_term' = 'External System Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `gl_company_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Company Code');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `gl_company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `hierarchy_path` SET TAGS ('dbx_business_glossary_term' = 'Organizational Hierarchy Path');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `is_customer_facing` SET TAGS ('dbx_business_glossary_term' = 'Customer Facing Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `is_revenue_generating` SET TAGS ('dbx_business_glossary_term' = 'Revenue Generating Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_level` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Hierarchy Level');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_name` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Name');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Notes');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_status` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|closed|suspended');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_type` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Type');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `osha_establishment_number` SET TAGS ('dbx_business_glossary_term' = 'OSHA Establishment ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `region_name` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region Name');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `safety_committee_required` SET TAGS ('dbx_business_glossary_term' = 'Safety Committee Required Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `sort_order` SET TAGS ('dbx_business_glossary_term' = 'Display Sort Order');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `store_format` SET TAGS ('dbx_business_glossary_term' = 'Store Format Type');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `store_format` SET TAGS ('dbx_value_regex' = 'hypermarket|superstore|discount_store|neighborhood_market|express|online_only');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `union_representation` SET TAGS ('dbx_business_glossary_term' = 'Union Representation Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ALTER COLUMN `union_representation` SET TAGS ('dbx_value_regex' = 'none|represented|mixed');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` SET TAGS ('dbx_subdomain' = 'employee_master');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `wf_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Workforce Certification ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `tertiary_wf_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `attachment_url` SET TAGS ('dbx_business_glossary_term' = 'Attachment Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|revoked|pending_renewal|in_progress');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_value_regex' = 'food_handler|forklift_operator|pharmacy_technician|management_training|safety_certification|first_aid_cpr');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `is_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Is Compliance Required Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory Flag');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `issuing_authority_type` SET TAGS ('dbx_value_regex' = 'government|professional_association|internal_training|third_party_vendor|educational_institution|industry_body');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `source_system_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'verified|pending_verification|failed_verification|not_verified');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` SET TAGS ('dbx_subdomain' = 'scheduling_operations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` SET TAGS ('dbx_association_edges' = 'workforce.org_unit,workforce.job_profile');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `staffing_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Staffing Plan Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Associate ID');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `job_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Job Profile Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Organizational Unit Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `annual_labor_budget` SET TAGS ('dbx_business_glossary_term' = 'Annual Labor Budget Amount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `headcount_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Headcount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `headcount_allocated` SET TAGS ('dbx_business_glossary_term' = 'Allocated Headcount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `headcount_planned` SET TAGS ('dbx_business_glossary_term' = 'Planned Headcount');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Staffing Plan Notes');
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ALTER COLUMN `variance_fte` SET TAGS ('dbx_business_glossary_term' = 'FTE Variance');
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` SET TAGS ('dbx_subdomain' = 'labor_relations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` SET TAGS ('dbx_association_edges' = 'workforce.associate,analytics.dashboard_config');
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` ALTER COLUMN `dashboard_access_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Access Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Access - Associate Id');
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` ALTER COLUMN `dashboard_config_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Access - Dashboard Config Id');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` SET TAGS ('dbx_subdomain' = 'scheduling_operations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` SET TAGS ('dbx_association_edges' = 'workforce.org_unit,analytics.kpi_definition');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `workforce_kpi_target_id` SET TAGS ('dbx_business_glossary_term' = 'workforce_kpi_target Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `analytics_kpi_target_id` SET TAGS ('dbx_business_glossary_term' = 'KPI Target Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Target - Kpi Definition Id');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Target - Org Unit Id');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Target Setter Associate Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Target Effective End Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Target Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `is_stretch_target` SET TAGS ('dbx_business_glossary_term' = 'Stretch Target Indicator');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Target Notes');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `threshold_green` SET TAGS ('dbx_business_glossary_term' = 'Green Threshold Value');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `threshold_red` SET TAGS ('dbx_business_glossary_term' = 'Red Threshold Value');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `threshold_yellow` SET TAGS ('dbx_business_glossary_term' = 'Yellow Threshold Value');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `weight_percentage` SET TAGS ('dbx_business_glossary_term' = 'KPI Weight Percentage');
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ALTER COLUMN `workforce_kpi_target_status` SET TAGS ('dbx_business_glossary_term' = 'Target Status');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` SET TAGS ('dbx_subdomain' = 'labor_relations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` SET TAGS ('dbx_association_edges' = 'workforce.org_unit,compliance.compliance_program');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `org_unit_compliance_scope_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Compliance Scope Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `org_program_compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Compliance Scope - Compliance Program Id');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Compliance Scope - Org Unit Id');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Scope Effective Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Scope Expiration Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `incident_count_ytd` SET TAGS ('dbx_business_glossary_term' = 'Incident Count Year-to-Date');
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Scope Notes');
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` SET TAGS ('dbx_subdomain' = 'labor_relations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` ALTER COLUMN `collective_bargaining_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Collective Bargaining Agreement Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` ALTER COLUMN `wage_increase_percentage` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_retail_v1`.`workforce`.`collective_bargaining_agreement` ALTER COLUMN `wage_increase_percentage` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`workforce`.`merit_cycle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`merit_cycle` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`merit_cycle` ALTER COLUMN `merit_cycle_id` SET TAGS ('dbx_business_glossary_term' = 'Merit Cycle Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` SET TAGS ('dbx_subdomain' = 'employee_master');
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` ALTER COLUMN `candidate_id` SET TAGS ('dbx_business_glossary_term' = 'Candidate Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` ALTER COLUMN `salary_currency_code` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_retail_v1`.`workforce`.`candidate` ALTER COLUMN `salary_currency_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ALTER COLUMN `payroll_run_id` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ALTER COLUMN `gross_pay_amount` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ALTER COLUMN `gross_pay_amount` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ALTER COLUMN `net_pay_amount` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_run` ALTER COLUMN `net_pay_amount` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` SET TAGS ('dbx_subdomain' = 'scheduling_operations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ALTER COLUMN `shift_swap_request_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Swap Request Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` SET TAGS ('dbx_subdomain' = 'scheduling_operations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ALTER COLUMN `coverage_request_id` SET TAGS ('dbx_business_glossary_term' = 'Coverage Request Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`pay_period` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`pay_period` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`pay_period` ALTER COLUMN `pay_period_id` SET TAGS ('dbx_business_glossary_term' = 'Pay Period Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`union` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`union` SET TAGS ('dbx_subdomain' = 'labor_relations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`union` ALTER COLUMN `union_id` SET TAGS ('dbx_business_glossary_term' = 'Union Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` SET TAGS ('dbx_subdomain' = 'labor_relations');
ALTER TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` ALTER COLUMN `bargaining_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Bargaining Unit Identifier');
ALTER TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` ALTER COLUMN `wage_scale_reference` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_retail_v1`.`workforce`.`bargaining_unit` ALTER COLUMN `wage_scale_reference` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` ALTER COLUMN `payroll_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Payroll Calendar Identifier');
