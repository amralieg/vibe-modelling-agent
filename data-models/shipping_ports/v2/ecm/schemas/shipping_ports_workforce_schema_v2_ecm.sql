-- Schema for Domain: workforce | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:33

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`workforce` COMMENT 'Manages all port workforce data including stevedore gangs, equipment operators, marine pilots, security personnel, and administrative staff. Covers employee records, shift scheduling, payroll, MLC (Maritime Labour Convention) compliance, competency certification, training, talent management, and time and attendance. Integrates with Oracle HCM Cloud and SAP HR. SSOT for human resources and workforce data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` (
    `employee_id` BIGINT COMMENT 'Unique identifier for the port workforce employee. Primary key for all human resources identity and talent data across the port.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Employee belongs to an organizational unit (department). Currently denormalized with department_code. Adding org_unit_id FK enables proper normalization and removes redundant code attribute.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Employees are assigned to specific port locations (berths, yards, gates) for shift planning, access control, and workforce deployment. Replaces denormalized work_location_code with proper FK for locat',
    `position_id` BIGINT COMMENT 'Foreign key linking to workforce.position. Business justification: employee should have a FK to their current position. This is a fundamental HR relationship linking employee to the authorised position they occupy. Currently employee has job_title (STRING) and job_cl',
    `shift_pattern_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_pattern. Business justification: Employee is associated with a shift pattern. Currently denormalized with shift_pattern (STRING). Adding shift_pattern_id FK enables proper normalization and removes redundant string attribute.',
    `career_aspirations` STRING COMMENT 'Free-text description of the employees career goals, desired roles, and professional development interests. Used for talent development planning and internal mobility programs.',
    `competency_certifications` STRING COMMENT 'Comma-separated list of competency certifications held by the employee. Examples include STCW (Standards of Training, Certification and Watchkeeping), crane operator license, dangerous goods handling, first aid, forklift license. Used for workforce capability planning and compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the employee record was first created in the system. Used for data lineage and audit trail.',
    `date_of_birth` DATE COMMENT 'Date of birth of the employee. Used for age verification, retirement planning, and MLC compliance.',
    `development_goals` STRING COMMENT 'Structured list of individual development goals and objectives for the employee. Includes skill development targets, certification goals, performance improvement areas, and leadership competencies. Used for performance management and talent development.',
    `email_address` STRING COMMENT 'Primary corporate email address for the employee used for official port communications and system access.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `emergency_contact_name` STRING COMMENT 'Full name of the employees designated emergency contact person. Used for emergency notifications and incident response.',
    `emergency_contact_phone` STRING COMMENT 'Phone number of the employees designated emergency contact person. Used for emergency notifications and incident response.',
    `emergency_contact_relationship` STRING COMMENT 'Relationship of the emergency contact person to the employee. Used for emergency notification prioritization. [ENUM-REF-CANDIDATE: spouse|parent|sibling|child|partner|friend|other — 7 candidates stripped; promote to reference product]',
    `employment_status` STRING COMMENT 'Current lifecycle status of the employee within the port workforce. Active indicates currently employed and working; inactive indicates on leave or temporarily not working; suspended indicates disciplinary suspension; terminated indicates employment ended; retired indicates retirement; deceased indicates employee has passed away.. Valid values are `active|inactive|suspended|terminated|retired|deceased`',
    `employment_type` STRING COMMENT 'Classification of employment arrangement. Permanent indicates full-time ongoing employment; casual indicates irregular shift-based work; contract indicates fixed-term contract; temporary indicates short-term assignment; seasonal indicates recurring seasonal work; apprentice indicates training program participant.. Valid values are `permanent|casual|contract|temporary|seasonal|apprentice`',
    `first_name` STRING COMMENT 'Legal first name of the employee as recorded in official employment documents.',
    `high_potential_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the employee is identified as high-potential talent for accelerated development and leadership roles. True indicates high-potential; False indicates standard talent management track.',
    `hire_date` DATE COMMENT 'Date the employee was first hired or commenced employment with the port. Used for seniority calculations, benefits eligibility, and service awards.',
    `isps_clearance_expiry_date` DATE COMMENT 'Expiration date of the employees ISPS security clearance. Used for access control and compliance monitoring.',
    `isps_clearance_level` STRING COMMENT 'Security clearance level for the employee under ISPS Code requirements. None indicates no clearance; restricted indicates basic port access; confidential indicates access to sensitive areas; secret indicates access to critical infrastructure and security operations.. Valid values are `none|restricted|confidential|secret`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the employee record was last updated or modified. Used for data lineage, audit trail, and change tracking.',
    `last_name` STRING COMMENT 'Legal last name or surname of the employee as recorded in official employment documents.',
    `last_performance_review_date` DATE COMMENT 'Date of the most recent formal performance review or appraisal for the employee. Used for performance management cycle tracking.',
    `last_training_date` DATE COMMENT 'Date of the most recent training course or certification update completed by the employee. Used for training compliance monitoring and recertification scheduling.',
    `middle_name` STRING COMMENT 'Middle name or initial of the employee. Nullable for employees without middle names.',
    `mlc_compliant_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the employee meets all Maritime Labour Convention 2006 compliance requirements including minimum age, medical fitness, training certification, and working conditions. True indicates compliant; False indicates non-compliant or compliance review required.',
    `mobile_number` STRING COMMENT 'Mobile phone number for the employee. Used for shift notifications, emergency alerts, and field operations coordination.',
    `mobility_preference` STRING COMMENT 'Employees willingness and preference for geographic relocation or transfer. Local_only indicates no relocation; regional indicates willing to relocate within region; national indicates willing to relocate within country; international indicates willing to relocate globally. Used for succession planning and talent deployment.. Valid values are `local_only|regional|national|international`',
    `national_id_number` STRING COMMENT 'Government-issued national identification number for the employee. Used for tax reporting, social security, and legal compliance.',
    `nationality` STRING COMMENT 'Nationality of the employee represented as ISO 3166-1 alpha-3 country code. Critical for MLC compliance, visa management, and seafarer documentation.. Valid values are `^[A-Z]{3}$`',
    `next_training_due_date` DATE COMMENT 'Date by which the employee must complete their next mandatory training or recertification. Used for proactive training scheduling and compliance management.',
    `oracle_hcm_employee_number` STRING COMMENT 'Employee number assigned by Oracle HCM Cloud system. System of record identifier for workforce management, payroll, talent management, and time and attendance.. Valid values are `^[A-Z0-9]{6,12}$`',
    `passport_number` STRING COMMENT 'Passport number for the employee. Required for international travel, seafarer documentation, and border clearance.',
    `performance_rating` STRING COMMENT 'Most recent performance appraisal rating for the employee. Unsatisfactory indicates below acceptable performance; needs_improvement indicates performance gaps; meets_expectations indicates satisfactory performance; exceeds_expectations indicates above-average performance; outstanding indicates exceptional performance.. Valid values are `unsatisfactory|needs_improvement|meets_expectations|exceeds_expectations|outstanding`',
    `phone_number` STRING COMMENT 'Primary contact phone number for the employee. Used for emergency contact and operational communications.',
    `preferred_name` STRING COMMENT 'Preferred or commonly used name for the employee in workplace communications and systems.',
    `readiness_level_for_next_role` STRING COMMENT 'Assessment of the employees readiness for promotion or lateral move to next target role. Not_ready indicates significant development needed; developing indicates progressing toward readiness; ready_with_support indicates ready with mentoring; fully_ready indicates ready for immediate transition; exceeds_requirements indicates overqualified for next role.. Valid values are `not_ready|developing|ready_with_support|fully_ready|exceeds_requirements`',
    `sap_hr_personnel_number` STRING COMMENT 'Personnel number assigned by SAP S/4HANA HR module. Legacy system identifier for human resources management.. Valid values are `^[0-9]{8}$`',
    `sid_number` STRING COMMENT 'Seafarer Identity Document number issued under ILO Convention 185. Required for marine pilots, seafarers, and maritime personnel working in ISPS-regulated port areas.. Valid values are `^[A-Z]{3}[0-9]{7}$`',
    `skills_inventory` STRING COMMENT 'Structured list of skills, competencies, and capabilities possessed by the employee. Includes technical skills (equipment operation, software proficiency), soft skills (leadership, communication), and specialized knowledge (customs procedures, hazardous cargo handling). Used for talent management, succession planning, and workforce optimization.',
    `succession_planning_designation` STRING COMMENT 'Employees status in succession planning for critical roles. Not_identified indicates not in succession pool; identified indicates potential successor; ready_now indicates ready for immediate promotion; ready_1_year indicates ready within one year; ready_2_years indicates ready within two years.. Valid values are `not_identified|identified|ready_now|ready_1_year|ready_2_years`',
    `termination_date` DATE COMMENT 'Date the employees employment ended. Nullable for active employees. Used for offboarding, final pay calculations, and workforce analytics.',
    `termination_reason` STRING COMMENT 'Reason for employment termination. Resignation indicates voluntary departure; retirement indicates age-based retirement; redundancy indicates position elimination; dismissal indicates termination for cause; contract_end indicates fixed-term contract completion; deceased indicates employee death; other indicates miscellaneous reasons. [ENUM-REF-CANDIDATE: resignation|retirement|redundancy|dismissal|contract_end|deceased|other — 7 candidates stripped; promote to reference product]',
    `union_code` STRING COMMENT 'Code identifying the specific labor union or collective bargaining unit to which the employee belongs. Nullable for non-union employees. Used for labor relations and payroll processing.. Valid values are `^[A-Z0-9]{2,10}$`',
    `union_membership_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the employee is a member of a labor union or collective bargaining unit. True indicates union member; False indicates non-union. Used for payroll deductions, labor relations, and collective agreement compliance.',
    CONSTRAINT pk_employee PRIMARY KEY(`employee_id`)
) COMMENT 'Core master record for all port workforce personnel including stevedores, equipment operators, marine pilots, security officers, administrative staff, and management. Stores personal details, employment status, job classification, employment type (permanent, casual, contract), Oracle HCM Cloud employee number, SAP HR personnel number, MLC (Maritime Labour Convention) compliance flags, nationality, seafarer identity document (SID) references, employment history metadata, and talent profile data (skills inventory, career aspirations, mobility preferences, succession planning designation, high-potential flag, development goals, readiness level for next role). SSOT for all human resources identity and talent data across the port.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`position` (
    `position_id` BIGINT COMMENT 'Unique identifier for the authorised position within the port organisational structure. Primary key.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: position should belong to an organizational unit. This FK links authorised positions to the org structure, enabling headcount planning, budget allocation, and organizational design. Currently position',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Positions are location-specific (berth supervisor, yard controller). FK enables organizational design by location, headcount planning per operational area, and competency requirements tied to physical',
    `reports_to_position_id` BIGINT COMMENT 'Identifier of the supervisory position to which this position reports in the organisational hierarchy. Null for top-level executive positions.',
    `position_code` STRING COMMENT 'Business identifier for the position, used across HR systems and organisational charts. Typically alphanumeric code assigned by HR.. Valid values are `^[A-Z0-9]{4,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the position record was first created in the HR system.',
    `position_description` STRING COMMENT 'Detailed narrative description of the positions purpose, key responsibilities, accountabilities, and scope within the port organisation.',
    `effective_end_date` DATE COMMENT 'Date on which this position definition ceased to be active. Null for currently active positions.',
    `effective_start_date` DATE COMMENT 'Date from which this position definition became active and available for assignment within the organisational structure.',
    `employment_type` STRING COMMENT 'Nature of employment contract associated with the position, determining tenure and entitlements.. Valid values are `permanent|fixed_term|casual|contractor|seasonal`',
    `full_time_equivalent` DECIMAL(18,2) COMMENT 'Proportion of full-time hours allocated to this position, expressed as a decimal (e.g., 1.00 for full-time, 0.50 for half-time). Used for headcount budgeting and workforce capacity planning.',
    `grade_band` STRING COMMENT 'Compensation and seniority level assigned to the position within the ports grading structure (e.g., G1, G2, M1, E1).. Valid values are `^[A-Z0-9]{1,4}$`',
    `headcount_budget` STRING COMMENT 'Number of authorised incumbents for this position. Typically 1 for individual positions; may be greater than 1 for pooled positions (e.g., casual stevedore gang members).',
    `is_isps_designated` BOOLEAN COMMENT 'Indicates whether the position requires ISPS security clearance and background checks due to access to restricted port areas or sensitive maritime security functions.',
    `is_management_position` BOOLEAN COMMENT 'Indicates whether the position has direct supervisory or managerial responsibilities over other employees.',
    `is_operational_position` BOOLEAN COMMENT 'Indicates whether the position is directly involved in core port operations (vessel handling, cargo operations, equipment operation) as opposed to administrative or support functions.',
    `is_safety_critical` BOOLEAN COMMENT 'Indicates whether the position is designated as safety-critical under International Ship and Port Facility Security (ISPS) Code or Safety of Life at Sea (SOLAS) regulations, requiring enhanced screening, certification, and oversight.',
    `job_category` STRING COMMENT 'Detailed classification within the job family, specifying the functional area (e.g., Container Handling, Vessel Operations, Port Security, Terminal Planning).',
    `job_family` STRING COMMENT 'Broad occupational category grouping similar roles together for workforce planning and talent management purposes. [ENUM-REF-CANDIDATE: operations|marine_services|engineering|security|administration|commercial|safety_environment|it_technology — 8 candidates stripped; promote to reference product]',
    `key_performance_indicators` STRING COMMENT 'Comma-separated list of measurable performance metrics used to evaluate success in the position (e.g., Crane Moves per Hour, Vessel Turnaround Time, Safety Incident Rate).',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the position record was most recently modified in the HR system.',
    `minimum_education_level` STRING COMMENT 'Minimum formal education qualification required for the position (e.g., secondary school, diploma, bachelors degree).. Valid values are `none|secondary|diploma|bachelor|master|doctorate`',
    `minimum_experience_years` STRING COMMENT 'Minimum number of years of relevant industry or functional experience required to qualify for the position.',
    `position_status` STRING COMMENT 'Current lifecycle state of the position within the organisational structure. Active positions are available for assignment; frozen positions are temporarily suspended; abolished positions are closed.. Valid values are `active|frozen|abolished|pending_approval`',
    `requires_medical_clearance` BOOLEAN COMMENT 'Indicates whether the position requires periodic medical fitness assessments due to safety-critical duties or physical demands (e.g., crane operators, marine pilots).',
    `requires_security_clearance` BOOLEAN COMMENT 'Indicates whether the position requires background security vetting and clearance due to access to restricted areas or sensitive information.',
    `salary_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for salary and compensation amounts (e.g., USD, EUR, AUD).. Valid values are `^[A-Z]{3}$`',
    `salary_range_maximum` DECIMAL(18,2) COMMENT 'Maximum annual salary or wage rate for the position in the ports base currency, as defined by the compensation structure.',
    `salary_range_minimum` DECIMAL(18,2) COMMENT 'Minimum annual salary or wage rate for the position in the ports base currency, as defined by the compensation structure.',
    `shift_pattern` STRING COMMENT 'Standard working schedule pattern for the position, reflecting operational requirements of port operations (e.g., 24/7 vessel operations, day-shift administration).. Valid values are `day_shift|night_shift|rotating_shift|on_call|fixed_hours|24_7_roster`',
    `title` STRING COMMENT 'Official job title for the position as it appears in organisational documentation and employment contracts (e.g., Quay Crane Operator, Marine Pilot, Berth Gang Supervisor).',
    `union_classification` STRING COMMENT 'Union or collective bargaining agreement classification applicable to the position, if covered by maritime labour agreements.',
    CONSTRAINT pk_position PRIMARY KEY(`position_id`)
) COMMENT 'Defines all authorised positions within the port organisational structure including berth gang supervisor, quay crane (QC) operator, rubber tyred gantry (RTG) operator, marine pilot, mooring master, port security officer, and terminal planner. Captures position code, job family, grade band, required certifications, headcount budget, and whether the position is safety-critical under ISPS or SOLAS requirements. Sourced from Oracle HCM Cloud Position Management and SAP HR Organisational Management (OM).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` (
    `org_unit_id` BIGINT COMMENT 'Unique identifier for the organisational unit. Primary key.',
    `parent_unit_org_unit_id` BIGINT COMMENT 'Reference to the parent organisational unit in the hierarchy. Enables traversal of the organisational tree structure from terminals down to gangs and sections. Null for top-level units.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Org units map to terminal areas and operational zones. FK supports cost center allocation by location, safety zone management, operational reporting, and ISPS security level enforcement per physical a',
    `actual_headcount` STRING COMMENT 'Current actual number of employees assigned to this organisational unit. Updated from Oracle HCM Cloud workforce data.',
    `attrition_count` STRING COMMENT 'Number of employees who left this organisational unit in the current planning period (voluntary and involuntary separations). Used for turnover analysis.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for labour budget amounts (e.g., USD, EUR, AUD). Enables multi-currency workforce planning for international port operations.. Valid values are `^[A-Z]{3}$`',
    `budgeted_headcount` STRING COMMENT 'Approved workforce headcount budget for this organisational unit in the current planning period. Used for workforce capacity planning and variance analysis.',
    `capex_labour_budget` DECIMAL(18,2) COMMENT 'Capital expenditure budget allocated for labour costs in this organisational unit for the current fiscal period. Includes project-based labour for infrastructure development and major initiatives.',
    `casual_headcount` STRING COMMENT 'Number of casual or temporary employees in this organisational unit. Common in port operations for stevedore gangs and peak-period labour.',
    `competency_framework` STRING COMMENT 'Name or code of the competency framework applicable to this organisational unit (e.g., Marine Pilot Competency Framework, Crane Operator Certification Framework). Links to training and certification requirements.',
    `contract_headcount` STRING COMMENT 'Number of contract or third-party employees assigned to this organisational unit. Used for contingent workforce management.',
    `cost_centre_code` STRING COMMENT 'SAP Controlling (CO) cost centre code linked to this organisational unit for financial accounting, budget tracking, and OPEX/CAPEX allocation.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this organisational unit record was first created in the system. Used for audit trail and data lineage.',
    `org_unit_description` STRING COMMENT 'Detailed description of the organisational units purpose, responsibilities, and scope of operations. Provides business context for workforce planning and reporting.',
    `effective_from_date` DATE COMMENT 'Date when this organisational unit became or will become operational. Used for time-dependent organisational structure reporting.',
    `effective_to_date` DATE COMMENT 'Date when this organisational unit ceased or will cease operations. Null for currently active units. Used for historical organisational structure analysis.',
    `headcount_variance` STRING COMMENT 'Difference between budgeted and actual headcount (budgeted minus actual). Positive variance indicates understaffing; negative indicates overstaffing. Key KPI for workforce planning.',
    `isps_security_level` STRING COMMENT 'ISPS Code security level applicable to this organisational unit. Level 1 = normal operations; Level 2 = heightened risk; Level 3 = imminent threat; Not Applicable = non-ISPS units. Determines workforce security clearance requirements.. Valid values are `level_1|level_2|level_3|not_applicable`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this organisational unit record was last updated. Used for change tracking and audit compliance.',
    `mlc_compliance_required` BOOLEAN COMMENT 'Indicates whether this organisational unit must comply with ILO Maritime Labour Convention 2006 standards. True for marine-facing units (pilots, towage, vessel services); False for landside operations.',
    `operational_area` STRING COMMENT 'Geographic or functional operational area within the port (e.g., Quayside Operations, Yard Operations, Gate Operations, Marine Services, Administration). Used for capacity planning and resource allocation.',
    `opex_labour_budget` DECIMAL(18,2) COMMENT 'Operational expenditure budget allocated for labour costs in this organisational unit for the current fiscal period. Includes salaries, wages, and benefits for ongoing operations.',
    `org_unit_status` STRING COMMENT 'Current lifecycle status of the organisational unit. Active = operational; Inactive = temporarily non-operational; Suspended = on hold; Planned = future unit not yet operational; Closed = permanently decommissioned.. Valid values are `active|inactive|suspended|planned|closed`',
    `permanent_headcount` STRING COMMENT 'Number of permanent (full-time equivalent) employees in this organisational unit. Part of employment category breakdown for workforce composition analysis.',
    `planning_period` STRING COMMENT 'Time period for workforce planning data (e.g., 2024-Q1, 2024-M03, 2024-FY). Enables time-series workforce capacity analysis and trend reporting.. Valid values are `^[0-9]{4}-(Q[1-4]|M(0[1-9]|1[0-2])|FY)$`',
    `safety_critical_unit` BOOLEAN COMMENT 'Indicates whether this organisational unit performs safety-critical operations requiring enhanced OHS (Occupational Health and Safety) protocols, competency certification, and incident reporting. True for crane operations, marine pilotage, hazardous cargo handling.',
    `shift_pattern` STRING COMMENT 'Standard shift pattern or roster schedule for this organisational unit (e.g., 24/7 continuous, 3-shift rotation, day shift only). Used for workforce scheduling and capacity planning.',
    `union_representation` BOOLEAN COMMENT 'Indicates whether employees in this organisational unit are represented by a labour union or collective bargaining agreement. Impacts workforce relations and MLC compliance.',
    `unit_code` STRING COMMENT 'Business identifier code for the organisational unit used across SAP HR and Oracle HCM systems. Unique alphanumeric code for external reference.. Valid values are `^[A-Z0-9]{3,12}$`',
    `unit_name` STRING COMMENT 'Full name of the organisational unit (e.g., Container Terminal 1, Marine Operations Department, Stevedore Gang Alpha).',
    `unit_type` STRING COMMENT 'Classification of the organisational unit indicating its role in the port hierarchy. Terminal = marine terminal facility; Department = functional business unit; Division = strategic business division; Section = operational sub-unit; Gang = stevedore work crew; Cost Centre = financial accounting unit; Operational Area = geographic or functional zone. [ENUM-REF-CANDIDATE: terminal|department|division|section|gang|cost_centre|operational_area — 7 candidates stripped; promote to reference product]',
    `vacancy_count` STRING COMMENT 'Number of open positions (budgeted headcount minus actual headcount) in this organisational unit. Used for recruitment planning and workforce gap analysis.',
    CONSTRAINT pk_org_unit PRIMARY KEY(`org_unit_id`)
) COMMENT 'Hierarchical organisational unit structure covering divisions, departments, terminals, and operational sections within the port. Includes unit code, unit type (terminal, department, gang, section), parent unit reference for hierarchy traversal, cost centre linkage for SAP CO controlling, and responsible manager. Also contains workforce planning and headcount data: budgeted headcount by planning period, actual headcount, vacancy count, attrition count, headcount variance by employment category (permanent, casual, contract), and CAPEX/OPEX labour budget allocations. Enables workforce reporting by terminal, department, and operational area, supports capacity planning for terminal throughput, and provides the organisational foundation for position management. Sourced from SAP HR Organisational Management (OM), Oracle HCM Cloud, and Oracle HCM Cloud Workforce Planning. SSOT for organisational structure and workforce headcount planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` (
    `gang_id` BIGINT COMMENT 'Primary key for gang',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Gangs are qualified for specific equipment types (STS cranes, RTGs, reach stackers). FK enables competency verification before deployment, equipment assignment validation, safety compliance, and produ',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Gangs are based in specific zones for deployment optimization, equipment access, and shift planning. Critical for labor allocation algorithms and travel time calculations. Removes denormalized home_be',
    `labour_agreement_id` BIGINT COMMENT 'Code referencing the port labour agreement or enterprise bargaining agreement (EBA) under which this gang operates. Governs pay rates, overtime entitlements, rest periods, and minimum complement requirements.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: gang should belong to an organizational unit within the port structure. This FK links stevedore gangs to the org hierarchy for workforce planning, cost allocation, and management reporting. gang has t',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Stevedore gangs have home berth assignments for dispatch optimization and productivity tracking. FK enables gang-to-berth allocation, travel time calculation, equipment pre-positioning, and location-b',
    `shift_pattern_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_pattern. Business justification: Gang is associated with a shift pattern. Currently denormalized with shift_pattern (STRING). Adding shift_pattern_id FK enables proper normalization and removes redundant string attribute.',
    `employee_id` BIGINT COMMENT 'Reference to the employee record of the designated gang supervisor responsible for leading the gang during vessel operations, ensuring safety compliance, and reporting productivity to the terminal superintendent.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Gangs specialize in vessel types (container, bulk, ro-ro) for competency matching and productivity standards. FK enables gang dispatch validation, equipment allocation, and performance benchmarking by',
    `average_experience_years` DECIMAL(18,2) COMMENT 'Average number of years of stevedoring experience across all current members of the gang. Used for gang capability assessment, productivity benchmarking, and workforce planning analytics.',
    `cargo_type_specialisation` STRING COMMENT 'The primary cargo type this gang is trained and certified to handle. Determines eligibility for assignment to specific vessel calls and berth operations. [ENUM-REF-CANDIDATE: container|bulk|breakbulk|roro|liquid_bulk|project_cargo|general — promote to reference product]',
    `gang_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying the stevedore gang across operational systems including NAVIS N4 and SAP HR. Used for gang assignment to vessel operations and labour deployment scheduling.. Valid values are `^[A-Z0-9]{2,10}$`',
    `competency_review_date` DATE COMMENT 'The date of the next scheduled competency review for this gang, covering skills assessment, certification renewals, and operational performance evaluation as required by port training standards.',
    `cost_centre_code` STRING COMMENT 'SAP Controlling (CO) cost centre code to which labour costs for this gang are allocated. Used for financial reporting, OPEX tracking, and terminal profitability analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this gang master record was first created in the workforce data product. Provides audit trail for record provenance and data lineage tracking.',
    `gang_description` STRING COMMENT 'Free-text description of the stevedore gangs operational scope, specialisations, and any specific deployment conditions or restrictions not captured by structured fields.',
    `disbandment_date` DATE COMMENT 'The date on which this stevedore gang was officially disbanded or decommissioned. Null for active gangs. Used for workforce planning, historical reporting, and MLC compliance audits.',
    `effective_from_date` DATE COMMENT 'The date from which the current gang configuration (complement, type, supervisor, terminal assignment) is effective. Supports temporal versioning of gang master data for historical reporting and audit.',
    `effective_to_date` DATE COMMENT 'The date until which the current gang configuration is effective. Null for currently active configurations. Enables temporal versioning and historical gang composition tracking.',
    `formation_date` DATE COMMENT 'The date on which this stevedore gang was officially formed and registered in the workforce management system. Marks the start of the gangs operational lifecycle.',
    `gang_status` STRING COMMENT 'Current lifecycle status of the stevedore gang. Active gangs are available for vessel call deployment; standby gangs are formed but not currently assigned; suspended gangs are temporarily unavailable; disbanded gangs are permanently decommissioned.. Valid values are `active|inactive|suspended|disbanded|standby`',
    `gang_type` STRING COMMENT 'Classification of the stevedore gang by operational function. Hatch gangs work in vessel holds; crane gangs operate ship-to-shore (STS) or mobile harbour cranes (MHC); lashing gangs secure containers; RoRo gangs handle roll-on roll-off cargo; mooring gangs handle vessel mooring lines. [ENUM-REF-CANDIDATE: hatch_gang|crane_gang|lashing_gang|roro_gang|general_gang|mooring_gang — promote to reference product]. Valid values are `hatch_gang|crane_gang|lashing_gang|roro_gang|general_gang|mooring_gang`',
    `imdg_certified` BOOLEAN COMMENT 'Indicates whether this gang holds valid International Maritime Dangerous Goods (IMDG) Code certification, authorising them to handle hazardous cargo during vessel loading and discharge operations.',
    `is_multi_skilled` BOOLEAN COMMENT 'Indicates whether this gang is certified and qualified to perform multiple operation types (e.g., both crane operations and lashing), enabling flexible deployment across different vessel operation requirements.',
    `is_permanent` BOOLEAN COMMENT 'Indicates whether this is a permanent standing gang with a fixed composition (True) or a casual/ad-hoc gang assembled for specific vessel calls (False). Permanent gangs have fixed supervisor and core member assignments.',
    `isps_cleared` BOOLEAN COMMENT 'Indicates whether all members of this gang have current ISPS Code security clearance, permitting access to restricted port security zones and vessel operations areas.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to this gang master record. Used for change tracking, data synchronisation with NAVIS N4 and SAP HR, and audit compliance.',
    `max_complement` STRING COMMENT 'Maximum number of workers permitted in the stevedore gang for a single deployment, as defined by operational capacity, equipment constraints, and port labour agreements.',
    `max_continuous_work_hours` DECIMAL(18,2) COMMENT 'Maximum number of continuous hours this gang may work without a mandatory rest break, as prescribed by the applicable labour agreement and MLC 2006 rest hour requirements.',
    `min_complement` STRING COMMENT 'Minimum number of workers required to constitute a legally and operationally compliant stevedore gang for deployment. Defined by port labour agreements, union contracts, and safety regulations under MLC 2006 and OHS standards.',
    `mlc_compliance_status` STRING COMMENT 'Current MLC 2006 compliance status of this gang, reflecting whether rest hour requirements, minimum complement, pay conditions, and certification requirements are fully met under the Maritime Labour Convention.. Valid values are `compliant|non_compliant|under_review|exempt`',
    `gang_name` STRING COMMENT 'Human-readable descriptive name of the stevedore gang used for display in operational reports, shift schedules, and terminal operating system interfaces.',
    `navis_gang_code` STRING COMMENT 'The native gang identifier as recorded in the NAVIS N4 Terminal Operating System. Used for cross-system reconciliation between the workforce data product and NAVIS N4 gang assignment records.',
    `operation_type` STRING COMMENT 'The vessel cargo operation type this gang is configured to perform: loading (LoLo outbound), discharge (LoLo inbound), combined loading and discharge, lashing/securing of cargo, or container shifting within the vessel.. Valid values are `loading|discharge|loading_discharge|lashing|shifting`',
    `pay_grade_code` STRING COMMENT 'The pay grade classification code applicable to this gang type, used in SAP HR payroll processing to determine base wage rates, allowances, and overtime multipliers under the applicable labour agreement.',
    `productivity_target_moves_per_hour` DECIMAL(18,2) COMMENT 'The target number of container moves per hour (MPH) expected from this gang during vessel operations. Used as the KPI benchmark for gang performance measurement and SLA compliance reporting.',
    `rest_period_hours` DECIMAL(18,2) COMMENT 'Minimum mandatory rest period in hours required between consecutive deployments for this gang, as mandated by MLC 2006 and the applicable port labour agreement.',
    `safety_induction_current` BOOLEAN COMMENT 'Indicates whether all current members of this gang have completed and hold valid safety induction certification as required by OHS regulations and port safety management systems.',
    `sap_hr_gang_code` STRING COMMENT 'The gang or work group identifier as recorded in SAP S/4HANA HR module. Used for payroll processing, labour cost allocation, and time and attendance integration.',
    `standard_complement` STRING COMMENT 'The standard or nominal number of workers typically deployed in this gang for routine vessel operations. Used as the default headcount for shift planning and labour cost estimation in SAP HR.',
    `terminal_code` STRING COMMENT 'Code identifying the marine terminal to which this stevedore gang is permanently assigned. Aligns with terminal master data in NAVIS N4 and the Port Management Information System (PMIS).. Valid values are `^[A-Z0-9]{2,10}$`',
    `union_affiliation_code` STRING COMMENT 'Code identifying the maritime trade union or labour organisation to which this gangs members are affiliated. Determines applicable enterprise bargaining agreement, dispute resolution procedures, and industrial relations obligations.',
    CONSTRAINT pk_gang PRIMARY KEY(`gang_id`)
) COMMENT 'Defines the composition and configuration of stevedore gangs deployed for vessel cargo operations including loading, discharge, and lashing. Captures gang code, gang type (hatch gang, crane gang, lashing gang, RoRo gang), minimum complement, maximum complement, gang supervisor, terminal assignment, and operational status. A gang is a distinct operational unit in maritime terminal operations and is the primary labour deployment unit for vessel calls. Integrates with NAVIS N4 for gang assignment to vessel operations. SSOT for gang master data.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` (
    `gang_assignment_id` BIGINT COMMENT 'Primary key for gang_assignment',
    `berth_id` BIGINT COMMENT 'Reference to the berth or wharf position where the vessel is moored and the gang is deployed. Used for berth productivity analysis and resource allocation planning.',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Each gang deployment uses specific equipment types. FK enables type-level productivity analysis (moves per hour by equipment type), competency matching, maintenance coordination, and operational repor',
    `gang_id` BIGINT COMMENT 'Reference to the stevedore gang master record being deployed. Identifies the specific gang unit (foreman, complement, and skill classification) assigned to this operation.',
    `port_asset_id` BIGINT COMMENT 'Reference to the primary crane (STS, MHC, or QC) assigned to support this gang deployment. A gang typically works in conjunction with a specific crane for container or breakbulk operations. STS = Ship-to-Shore; MHC = Mobile Harbour Crane; QC = Quay Crane.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the gang foreman (leading hand) responsible for supervising this deployment. The foreman is accountable for safety, productivity, and sign-off of the gangs work record.',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Stevedore gangs handle rail wagon loading/unloading operations at intermodal terminals. Gang deployment to rail visits is operationally parallel to vessel operations, required for labor costing, produ',
    `shift_pattern_id` BIGINT COMMENT 'Reference to the shift schedule record during which this gang deployment occurs. Determines the shift window, shift type (day/night/swing), and associated shift allowances.',
    `tertiary_gang_approved_by_employee_id` BIGINT COMMENT 'Employee identifier of the operations supervisor or terminal manager who approved this gang deployment. Required for audit trail, payroll authorisation, and MLC compliance documentation.',
    `call_id` BIGINT COMMENT 'Reference to the vessel call (port visit) record for which this gang is deployed. Links the gang deployment to the specific vessel visit and associated cargo operations.',
    `work_order_id` BIGINT COMMENT 'Reference to the stevedoring work order or cargo operation instruction that triggered this gang deployment. Links to the operational work order in the Terminal Operating System.',
    `actual_finish_time` TIMESTAMP COMMENT 'Actual timestamp when the gang completed work and was signed off the vessel operation. Used for hours-worked calculation, overtime determination, and productivity reporting.',
    `actual_start_time` TIMESTAMP COMMENT 'Actual timestamp when the gang commenced work on the vessel operation. Captured from TOS dispatch records or foreman sign-on. Used for productivity measurement and payroll calculation.',
    `cancellation_reason` STRING COMMENT 'Free-text description of the reason for cancellation when deployment_status = cancelled. Captures operational context such as vessel departure, cargo plan change, or industrial action. Populated only for cancelled deployments.',
    `cargo_type` STRING COMMENT 'Classification of cargo being handled by the gang. Determines applicable safety protocols, equipment type, and productivity benchmarks. RoRo = Roll-on Roll-off; LoLo = Lift-on Lift-off handled under container.. Valid values are `container|bulk|breakbulk|roro|liquid_bulk|project_cargo`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this gang deployment record was first created in the system. Audit trail field for data lineage and compliance purposes.',
    `deployment_date` DATE COMMENT 'Calendar date of the gang deployment. Used as the primary date dimension for daily productivity reporting, payroll date alignment, and operational KPI dashboards.',
    `deployment_number` STRING COMMENT 'Externally-known business identifier for this gang deployment, used in operational communications, payroll references, and TOS dispatch records. Format: GD-YYYY-NNNNNN.. Valid values are `^GD-[0-9]{4}-[0-9]{6}$`',
    `deployment_status` STRING COMMENT 'Current lifecycle state of the gang deployment. assigned = gang allocated but not yet started; active = gang currently working; completed = work finished and signed off; cancelled = deployment cancelled before commencement; suspended = work temporarily halted (e.g., weather, safety hold).. Valid values are `assigned|active|completed|cancelled|suspended`',
    `deployment_timestamp` TIMESTAMP COMMENT 'The principal real-world event timestamp when the gang was formally deployed and dispatched to the vessel operation. Distinct from the scheduled start time and the actual work commencement time.',
    `gang_size_actual` STRING COMMENT 'Actual number of workers who reported and worked during this deployment. May differ from planned due to absenteeism, late arrivals, or safety stand-downs. Used for productivity normalisation and payroll.',
    `gang_size_planned` STRING COMMENT 'Number of workers planned/allocated to the gang for this deployment as per the gang complement schedule. Used for labour cost estimation and MLC compliance planning.',
    `gang_type` STRING COMMENT 'Classification of the gang by their primary function and skill set for this deployment. Determines applicable award rates, safety certifications required, and productivity benchmarks. [ENUM-REF-CANDIDATE: stevedore|lashing|hatch|crane_operator|tally|forklift|general|rigging — promote to reference product]',
    `gross_hours_worked` DECIMAL(18,2) COMMENT 'Total elapsed hours from actual start to actual finish for this gang deployment, including meal breaks and stoppages. Used as the denominator for gross productivity rate calculations.',
    `hatch_number` STRING COMMENT 'Identifier of the vessel hatch or hold to which the gang is assigned. Used for BAPLIE stowage plan alignment, hatch-level productivity tracking, and multi-gang coordination on a single vessel.. Valid values are `^[A-Z0-9]{1,6}$`',
    `imdg_cargo_flag` BOOLEAN COMMENT 'Indicates whether the gang deployment involves handling of dangerous goods classified under the IMDG Code. Triggers mandatory dangerous goods handling protocols, additional safety briefings, and competency verification. IMDG = International Maritime Dangerous Goods.',
    `is_overtime_approved` BOOLEAN COMMENT 'Indicates whether overtime worked during this deployment has been formally approved by the operations supervisor. Required for payroll processing and MLC 2006 working hours compliance audit.',
    `is_safety_incident` BOOLEAN COMMENT 'Indicates whether a safety incident (injury, near-miss, or dangerous occurrence) was recorded during this gang deployment. Triggers mandatory incident reporting under ISO 45001 and OHS regulations.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this gang deployment record was last modified. Used for incremental data loading, change data capture, and audit trail in the Silver Layer lakehouse.',
    `moves_completed` STRING COMMENT 'Total number of cargo moves (container lifts, unit moves, or equivalent) completed by the gang during this deployment. Primary raw productivity metric used to calculate moves per hour (MPH) KPI.',
    `moves_per_hour` DECIMAL(18,2) COMMENT 'Gross productivity rate expressed as cargo moves per gross gang hour for this deployment. Calculated as moves_completed divided by gross_hours_worked. Stored as a captured operational metric from the TOS, not a derived aggregate — represents the TOS-recorded productivity figure for this specific deployment event.',
    `net_hours_worked` DECIMAL(18,2) COMMENT 'Productive working hours excluding meal breaks, safety stoppages, and non-productive time. Used as the denominator for net productivity rate (moves per net gang hour) calculations and MLC compliance reporting.',
    `operation_type` STRING COMMENT 'Classification of the cargo operation the gang is performing. Determines applicable productivity benchmarks, equipment requirements, and tariff rates. [ENUM-REF-CANDIDATE: discharge|load|shifting|lashing|unlashing|hatch_opening|hatch_closing|restow|survey — promote to reference product]',
    `overtime_hours` DECIMAL(18,2) COMMENT 'Number of overtime hours worked by the gang beyond the standard shift duration. Drives overtime pay calculations in SAP Payroll and is monitored for MLC 2006 maximum working hours compliance.',
    `payroll_period_ref` STRING COMMENT 'Payroll period identifier (YYYY-MM) to which this gang deployments hours and earnings are allocated. Used for payroll batch processing in SAP S/4HANA HR and Oracle HCM Cloud payroll runs.. Valid values are `^[0-9]{4}-[0-9]{2}$`',
    `safety_incident_ref` STRING COMMENT 'Reference number of the safety incident report raised during this deployment, if applicable. Links to the safety incident management system for investigation and regulatory reporting. Populated only when is_safety_incident = TRUE.. Valid values are `^SI-[0-9]{4}-[0-9]{6}$`',
    `scheduled_finish_time` TIMESTAMP COMMENT 'Planned finish timestamp for the gang deployment based on the vessel operation schedule. Used for variance analysis and shift planning.',
    `scheduled_start_time` TIMESTAMP COMMENT 'Planned start timestamp for the gang deployment as per the vessel operation schedule and berth plan. Used for variance analysis against actual start time.',
    `shift_type` STRING COMMENT 'Classification of the shift period during which the gang is deployed. Determines applicable shift penalty rates, allowances, and MLC rest period compliance checks. Day/afternoon/night/swing shifts attract different award rates.. Valid values are `day|afternoon|night|swing`',
    `stoppage_hours` DECIMAL(18,2) COMMENT 'Total hours of non-productive stoppage during the deployment (e.g., weather delays, equipment breakdown, safety holds, industrial action). Used for demurrage claims, productivity analysis, and vessel delay reporting.',
    `stoppage_reason_code` STRING COMMENT 'Standardised code identifying the primary reason for any work stoppage during this deployment (e.g., WEATHER, EQUIP_BREAKDOWN, SAFETY_HOLD, INDUSTRIAL). Used for delay analysis and demurrage dispute resolution.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `teu_handled` DECIMAL(18,2) COMMENT 'Total TEU (Twenty-foot Equivalent Units) handled by the gang during this deployment. FEU containers count as 2 TEU. Core metric for container terminal productivity benchmarking and billing. TEU = Twenty-foot Equivalent Unit.',
    `teu_per_gang_hour` DECIMAL(18,2) COMMENT 'Container productivity rate expressed as TEU handled per net gang hour. Captured from TOS dispatch records as the operational productivity figure for this deployment. TEU = Twenty-foot Equivalent Unit.',
    `tos_dispatch_ref` STRING COMMENT 'Source system dispatch reference number from NAVIS N4 or TOPS Expert TOS. Used for data lineage, reconciliation with the TOS, and audit trail back to the operational system of record. TOS = Terminal Operating System.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `work_area_code` STRING COMMENT 'Code identifying the specific work area or zone on the terminal or vessel where the gang is deployed (e.g., quayside, hold, deck, CFS area). Used for spatial productivity analysis and safety zone management.. Valid values are `^[A-Z0-9_]{2,20}$`',
    CONSTRAINT pk_gang_assignment PRIMARY KEY(`gang_assignment_id`)
) COMMENT 'Transactional record of a stevedore gang being deployed to a specific vessel operation, shift, or work order. Captures deployment date and time, vessel call reference, berth, hatch or work area, gang complement at deployment, actual start and finish times, overtime hours, productivity metrics (moves per hour, TEU per gang hour), and deployment status (assigned, active, completed, cancelled). Links gang master data to actual operational execution and is the primary record for stevedoring productivity analysis. Sourced from NAVIS N4 gang assignment and TOS dispatch records.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` (
    `shift_pattern_id` BIGINT COMMENT 'Primary key for shift_pattern',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Shift patterns are location-specific (berth operations differ from yard operations in timing and fatigue risk). FK supports MLC rest hour compliance by location, fatigue management, and shift planning',
    `applicable_department` STRING COMMENT 'Name or code of the port department or operational division to which this shift pattern applies (e.g., Terminal Operations, Marine Services, Security, Yard Operations, Gate Operations, Administration). Supports department-level workforce planning and reporting.',
    `approval_status` STRING COMMENT 'Workflow approval status of the shift pattern, particularly relevant for new or modified shift patterns requiring HR, union, or MLC compliance sign-off before activation. Supports governance and change management processes.. Valid values are `pending|approved|rejected|escalated`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the HR manager or authorised officer who approved this shift pattern for operational use. Supports audit trail requirements for MLC compliance and enterprise governance.',
    `approved_date` DATE COMMENT 'Date on which this shift pattern received final approval for operational use. Supports audit trail and MLC compliance documentation requirements.',
    `break_count` STRING COMMENT 'Number of discrete break periods scheduled within the shift pattern. Supports detailed roster planning and MLC rest hour compliance verification where minimum break frequency is mandated.',
    `break_duration_minutes` STRING COMMENT 'Total scheduled break entitlement in minutes for the shift pattern. Includes all meal and rest breaks. Distinguishing paid vs unpaid breaks is captured in is_break_paid flag. Used for MLC rest hour compliance and payroll deduction calculations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this shift pattern record was first created in the data platform. Supports data lineage, audit trail, and Silver Layer ingestion tracking. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `days_of_week` STRING COMMENT 'Comma-separated list of days on which this shift pattern is scheduled (e.g., MON,TUE,WED,THU,FRI for weekdays; SAT,SUN for weekends; MON,TUE,WED,THU,FRI,SAT,SUN for 7-day operations). Supports roster generation and weekend/public holiday penalty rate identification.',
    `duration_minutes` STRING COMMENT 'Total scheduled duration of the shift in minutes, inclusive of paid breaks but exclusive of unpaid breaks. Represents the principal quantitative fact of the shift pattern. Used for payroll hours calculation, MLC maximum hours of work compliance, and workforce capacity planning.',
    `effective_from` DATE COMMENT 'Date from which this shift pattern is valid and available for roster assignment. Supports temporal versioning of shift patterns to accommodate enterprise award changes, MLC updates, or operational restructuring.',
    `effective_until` DATE COMMENT 'Date after which this shift pattern is no longer valid for new roster assignments. Null indicates the shift pattern is open-ended and currently active. Supports temporal versioning and historical roster analysis.',
    `end_time` TIMESTAMP COMMENT 'Scheduled end time of the shift in HH:MM (24-hour) format, independent of date. For overnight shifts where end_time is earlier than start_time, the shift is understood to span midnight. Used in roster generation, time-attendance validation, and overtime calculation.',
    `enterprise_award_code` STRING COMMENT 'Code referencing the enterprise bargaining agreement or industrial award under which this shift pattern is defined (e.g., MUA-EBA-2023, AMOU-AWARD-2022). Ensures payroll and rostering compliance with applicable industrial instruments for maritime and port workers.',
    `fatigue_risk_index` DECIMAL(18,2) COMMENT 'Numeric fatigue risk score assigned to this shift pattern based on shift timing, duration, and rotation frequency. Higher values indicate greater fatigue risk. Used in MLC compliance monitoring, OHS risk management, and roster optimisation to minimise fatigue-related incidents in safety-critical port operations.',
    `hcm_work_schedule_code` STRING COMMENT 'Source system identifier for the corresponding Work Schedule record in Oracle HCM Cloud. Enables bi-directional traceability between the Silver Layer data product and the operational system of record for reconciliation and change management.',
    `is_break_paid` BOOLEAN COMMENT 'Indicates whether the scheduled break entitlement for this shift pattern is paid (True) or unpaid (False). Determines whether break_duration_minutes is deducted from paid_hours in payroll processing.',
    `is_overnight` BOOLEAN COMMENT 'Indicates whether the shift pattern spans midnight (True) or is contained within a single calendar day (False). Used in roster date calculations, night shift penalty rate application, and MLC rest hour tracking across calendar day boundaries.',
    `is_public_holiday_applicable` BOOLEAN COMMENT 'Indicates whether this shift pattern is scheduled to operate on public holidays (True) or is suspended on public holidays (False). Drives public holiday penalty rate application in payroll and supports port operational continuity planning for 24/7 terminal operations.',
    `job_family` STRING COMMENT 'Workforce job family or occupational group for which this shift pattern is designed (e.g., Stevedore Gang, Equipment Operator, Marine Pilot, Security Officer, Crane Operator, Administrative). Supports targeted roster assignment and competency-based scheduling.',
    `max_crew_size` STRING COMMENT 'Maximum number of personnel that can be rostered under this shift pattern, constrained by equipment capacity, berth space, or operational safety limits. Used in workforce scheduling to prevent over-allocation and manage OPEX.',
    `min_crew_size` STRING COMMENT 'Minimum number of personnel required to be rostered under this shift pattern to meet safe operational standards and SLA commitments. Used in workforce capacity planning, gang allocation for stevedore operations, and OHS compliance validation.',
    `mlc_compliant` BOOLEAN COMMENT 'Indicates whether this shift pattern has been validated as compliant with all applicable Maritime Labour Convention (MLC) 2006 rest hour and maximum hours of work requirements (True) or has identified non-compliance issues (False). Supports MLC audit readiness and Port State Control (PSC) inspection preparation.',
    `mlc_max_hours_work_per_day` DECIMAL(18,2) COMMENT 'Maximum hours of work permitted per 24-hour period under the Maritime Labour Convention (MLC) 2006 for this shift pattern. Standard MLC limit is 14 hours. Used in compliance validation to ensure shift assignments do not breach MLC rest hour requirements.',
    `mlc_max_hours_work_per_week` DECIMAL(18,2) COMMENT 'Maximum hours of work permitted per 7-day period under the Maritime Labour Convention (MLC) 2006 for this shift pattern. Standard MLC limit is 72 hours. Used in weekly compliance reporting and roster validation.',
    `mlc_min_rest_hours_per_day` DECIMAL(18,2) COMMENT 'Minimum hours of rest required per 24-hour period under the Maritime Labour Convention (MLC) 2006 for this shift pattern. Standard MLC minimum is 10 hours. Used in compliance validation to ensure adequate rest between consecutive shift assignments.',
    `mlc_min_rest_hours_per_week` DECIMAL(18,2) COMMENT 'Minimum hours of rest required per 7-day period under the Maritime Labour Convention (MLC) 2006 for this shift pattern. Standard MLC minimum is 77 hours. Used in weekly MLC compliance reporting submitted to Port State Control (PSC) authorities.',
    `ohs_risk_level` STRING COMMENT 'Occupational Health and Safety (OHS) risk classification assigned to this shift pattern based on time-of-day, operational environment, and task type. Drives mandatory safety briefing requirements, PPE specifications, and incident reporting thresholds. Aligns with ISO 45001 risk assessment framework.. Valid values are `low|medium|high|critical`',
    `overtime_threshold_hours` DECIMAL(18,2) COMMENT 'Number of hours worked within this shift pattern beyond which overtime rates apply. Used in payroll processing to automatically trigger overtime rate calculations in Oracle HCM Cloud and SAP S/4HANA HR.',
    `paid_hours` DECIMAL(18,2) COMMENT 'Number of hours for which the employee is remunerated under this shift pattern, after deducting unpaid break entitlements from total duration. Used as the basis for payroll processing in SAP S/4HANA HR and Oracle HCM Cloud Payroll.',
    `penalty_rate_code` STRING COMMENT 'Payroll penalty rate code applicable to this shift pattern, referencing the enterprise pay rate schedule in SAP S/4HANA HR (e.g., NIGHT-1.5X, WKND-2X, PH-2.5X, STD-1X). Drives automated payroll calculation for shift-based penalty loadings.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `required_certification_codes` STRING COMMENT 'Comma-separated list of competency certification codes required for personnel assigned to this shift pattern (e.g., STCW,ISPS,RTG-OPS,STS-CRANE). Used in competency-based scheduling to ensure only qualified personnel are rostered. References the workforce competency certification register.',
    `rotation_cycle_days` STRING COMMENT 'Number of calendar days in the full rotation cycle for rotating shift patterns (e.g., 7 for weekly rotation, 14 for fortnightly, 28 for 4-week cycle). Null for non-rotating shift types. Used in roster generation and long-term workforce planning.',
    `rotation_sequence` STRING COMMENT 'Ordinal position of this shift pattern within a rotation cycle (e.g., 1 = first leg, 2 = second leg). Used to sequence multiple shift_pattern records that together form a complete rotating roster cycle. Null for non-rotating shift types.',
    `sap_work_schedule_variant` STRING COMMENT 'SAP S/4HANA HR work schedule variant code corresponding to this shift pattern, used for payroll time evaluation and absence/attendance management. Enables cross-system alignment between Oracle HCM Cloud roster data and SAP payroll processing.. Valid values are `^[A-Z0-9]{1,8}$`',
    `shift_category` STRING COMMENT 'Broad time-of-day category of the shift pattern used for workforce planning, penalty rate determination, and MLC rest hour compliance reporting. day typically covers 06:00–18:00; afternoon covers 14:00–22:00; night covers 22:00–06:00; early_morning covers 04:00–12:00; rotating covers patterns that cycle across categories.. Valid values are `day|afternoon|night|early_morning|rotating`',
    `shift_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying the shift pattern (e.g., DAY-01, NIGHT-03, STBY-AM). Used as the business key across Oracle HCM Cloud, SAP HR, and NAVIS N4 for cross-system referencing.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `shift_description` STRING COMMENT 'Free-text description providing additional context about the shift pattern, including operational purpose, special conditions, applicable vessel operations, or notes on MLC compliance exceptions. Supports business user understanding and documentation.',
    `shift_name` STRING COMMENT 'Human-readable name of the shift pattern (e.g., Day Shift, Night Shift, Afternoon Rotating, Marine Pilot Standby). Used in rosters, payroll reports, and workforce scheduling displays.',
    `shift_status` STRING COMMENT 'Current lifecycle status of the shift pattern record. active indicates available for roster assignment; inactive indicates temporarily suspended; draft indicates pending approval; under_review indicates subject to MLC or award compliance review; retired indicates permanently decommissioned.. Valid values are `active|inactive|draft|under_review|retired`',
    `shift_type` STRING COMMENT 'Classification of the shift pattern by operational nature. regular covers standard scheduled shifts; overtime covers extended hours beyond standard; standby covers on-call availability; call_out covers unplanned emergency activation; rotating covers cyclically alternating shifts; split covers shifts with a significant mid-shift break. Drives payroll rate application and MLC rest hour compliance checks.. Valid values are `regular|overtime|standby|call_out|rotating|split`',
    `standby_activation_notice_minutes` STRING COMMENT 'Minimum notice period in minutes required to activate an employee from standby to active duty under this shift pattern. Applicable only to standby and call-out shift types. Used in operational planning for vessel arrival response and emergency port operations.',
    `start_time` TIMESTAMP COMMENT 'Scheduled start time of the shift in HH:MM (24-hour) format, independent of date. Used in roster generation, time-attendance validation, and overtime calculation. For rotating shifts, represents the start time of the primary rotation leg.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this shift pattern record was last modified in the data platform. Supports change tracking, data quality monitoring, and audit trail requirements. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    CONSTRAINT pk_shift_pattern PRIMARY KEY(`shift_pattern_id`)
) COMMENT 'Defines shift patterns and schedules used across port operations including day, afternoon, night, and rotating shifts for terminal, marine, and security operations. Captures shift code, shift name, start time, end time, duration, break entitlements, shift type (regular, overtime, standby, call-out), applicable terminal or department, and MLC rest hour compliance parameters. Reference entity used by roster and time-attendance records. Sourced from Oracle HCM Cloud Work Schedules.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` (
    `roster_id` BIGINT COMMENT 'Unique system-generated identifier for each roster record in the workforce scheduling system. Primary key for the roster data product.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Rosters assign personnel to specific berths for vessel operations; fundamental to labor planning, berth-specific competency requirements, and shift coordination. Removes denormalized berth_area_code.',
    `employee_id` BIGINT COMMENT 'Reference to the employee assigned to this roster entry. Links to the employee master record in Oracle HCM Cloud.',
    `gang_id` BIGINT COMMENT 'Reference to the stevedore gang or labour gang to which the employee is assigned for this roster period. Supports vessel call labour planning in NAVIS N4.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Roster assignments specify work location for labor readiness reporting, access control, and location-based attendance tracking. FK enables SLA compliance (labor readiness by berth), security audit tra',
    `position_id` BIGINT COMMENT 'The job position or role code assigned to the employee for this roster entry, such as stevedore, quay crane operator, marine pilot, security officer, or yard supervisor. Sourced from Oracle HCM Cloud position master.',
    `shift_pattern_id` BIGINT COMMENT 'Reference to the shift definition record that specifies the shift pattern, start/end times, and break entitlements assigned in this roster entry.',
    `call_id` BIGINT COMMENT 'Reference to the vessel call or port call for which this labour roster assignment has been planned. Links workforce scheduling to vessel operations for advance labour deployment aligned to ETA/ETB.',
    `advance_notice_days` STRING COMMENT 'The number of calendar days in advance that this roster assignment was published to the employee prior to the assignment date. Used to measure compliance with enterprise agreement advance notice obligations.',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time at which the roster assignment was formally approved by the authorised supervisor or manager. Distinct from published and confirmed timestamps in the roster lifecycle.',
    `approved_by_user` STRING COMMENT 'The username or employee identifier of the supervisor or manager who approved this roster assignment. Required for MLC compliance documentation and operational governance.',
    `assignment_date` DATE COMMENT 'The specific calendar date on which the employee is assigned to work the designated shift. The principal business event date for this roster entry.',
    `break_entitlement_minutes` STRING COMMENT 'Total scheduled break time in minutes to which the employee is entitled during this shift, as defined by the applicable enterprise agreement or MLC rest provisions.',
    `change_notes` STRING COMMENT 'Free-text notes providing additional context for roster changes, amendments, or special instructions related to this assignment. Supports operational communication between planners and supervisors.',
    `change_reason` STRING COMMENT 'Reason code explaining why a roster assignment was created, modified, or cancelled. Supports audit trail requirements and workforce planning analytics. [ENUM-REF-CANDIDATE: vessel_schedule_change|employee_unavailability|operational_requirement|mlc_compliance|gang_reallocation|other — promote to reference product]. Valid values are `vessel_schedule_change|employee_unavailability|operational_requirement|mlc_compliance|gang_reallocation|other`',
    `competency_verified` BOOLEAN COMMENT 'Indicates whether the employees required competency certifications and qualifications have been verified as current and valid for the assigned position and shift type at the time of roster creation.',
    `confirmed_timestamp` TIMESTAMP COMMENT 'The date and time at which the roster assignment was confirmed, either by the employee or by a supervisor on their behalf. Supports workforce commitment tracking.',
    `cost_centre_code` STRING COMMENT 'SAP cost centre code to which the labour cost for this roster assignment is allocated. Enables operational expenditure (OPEX) tracking and financial reporting by terminal, department, or vessel call.',
    `created_by_user` STRING COMMENT 'The username or employee identifier of the workforce planner or system user who created this roster record. Supports audit trail and accountability for roster planning decisions.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this roster record was first created in the system. Provides the audit trail creation timestamp for data lineage and compliance purposes.',
    `department_code` STRING COMMENT 'Organisational department code to which the roster assignment belongs, such as stevedoring operations, marine services, security, or administration. Sourced from SAP S/4HANA HR organisational structure.',
    `equipment_type_assigned` STRING COMMENT 'The type of port equipment the employee is assigned to operate during this shift, such as Ship-to-Shore (STS) crane, Rubber Tyred Gantry (RTG), Automated Stacking Crane (ASC), Automated Guided Vehicle (AGV), or Mobile Harbour Crane (MHC). Sourced from NAVIS N4 equipment dispatch.',
    `isps_clearance_required` BOOLEAN COMMENT 'Indicates whether the employee assigned to this roster entry requires ISPS security clearance for the designated work area or berth. True if ISPS clearance is mandatory for the assignment.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time at which this roster record was most recently modified. Supports change tracking, audit trail requirements, and incremental data loading in the Databricks Silver Layer.',
    `mlc_min_rest_hours` DECIMAL(18,2) COMMENT 'The minimum number of rest hours required between consecutive shifts for this employee as mandated by MLC 2006 Regulation 2.3. Standard minimum is 10 hours in any 24-hour period and 77 hours in any 7-day period.',
    `mlc_rest_hours_compliant` BOOLEAN COMMENT 'Indicates whether this roster assignment satisfies the minimum rest hour requirements prescribed by the Maritime Labour Convention (MLC) 2006 Regulation 2.3. True if compliant; False if a potential violation is detected requiring review.',
    `navis_work_queue_code` STRING COMMENT 'The NAVIS N4 Terminal Operating System work queue identifier associated with this roster assignment, linking the labour plan to specific container handling or vessel operations tasks in the TOS.',
    `overtime_rate_multiplier` DECIMAL(18,2) COMMENT 'The pay rate multiplier applied to overtime shift assignments (e.g., 1.5 for time-and-a-half, 2.0 for double time). Used in payroll calculation for overtime and call-out shifts. Classified as confidential.',
    `pay_grade_code` STRING COMMENT 'The pay grade or salary band code applicable to the employee for this roster assignment, determining the base pay rate for payroll processing. Classified as confidential business data.',
    `period_end_date` DATE COMMENT 'The last calendar date of the roster planning period for which this assignment is valid. Together with roster_period_start_date, defines the scheduling window.',
    `period_start_date` DATE COMMENT 'The first calendar date of the roster planning period for which this assignment is valid. Used to define the scheduling window for advance labour planning aligned to vessel call schedules.',
    `planned_duration_hours` DECIMAL(18,2) COMMENT 'The total planned working duration of the shift in decimal hours, excluding break entitlements. Used for payroll calculation, MLC maximum hours of work compliance, and labour cost forecasting.',
    `planned_end_time` TIMESTAMP COMMENT 'The planned date and time at which the employees shift is scheduled to conclude. Used together with planned_start_time for MLC rest hour compliance and shift duration calculations.',
    `planned_start_time` TIMESTAMP COMMENT 'The planned date and time at which the employees shift is scheduled to commence. Used for MLC rest hour compliance calculations and labour deployment planning.',
    `preceding_rest_hours` DECIMAL(18,2) COMMENT 'The actual number of rest hours recorded between the previous shift end and this shifts planned start time. Used to validate MLC minimum rest hour compliance before publishing the roster.',
    `published_timestamp` TIMESTAMP COMMENT 'The date and time at which the roster was published and made available to employees. Supports advance notice compliance requirements under enterprise agreements and MLC provisions.',
    `roster_number` STRING COMMENT 'Externally-known business identifier for the roster record, used in workforce planning communications, MLC compliance reporting, and integration with Oracle HCM Cloud and SAP HR. Format: RST-YYYY-NNNNNN.. Valid values are `^RST-[0-9]{4}-[0-9]{6}$`',
    `roster_status` STRING COMMENT 'Current lifecycle state of the roster assignment. Draft indicates initial planning; published indicates the roster has been released to employees; confirmed indicates employee acknowledgement; cancelled indicates the assignment was withdrawn; superseded indicates replaced by a revised roster.. Valid values are `draft|published|confirmed|cancelled|superseded`',
    `shift_type` STRING COMMENT 'Classification of the shift assignment type. Regular denotes standard scheduled work; overtime denotes hours beyond standard; standby denotes on-call availability; call_out denotes unplanned emergency activation; training denotes scheduled training shifts; rest denotes mandatory MLC rest periods. [ENUM-REF-CANDIDATE: regular|overtime|standby|call_out|training|rest — promote to reference product]. Valid values are `regular|overtime|standby|call_out|training|rest`',
    `sla_labour_readiness_minutes` STRING COMMENT 'The contracted or target number of minutes within which the assigned employee or gang must be ready and deployed at the designated work location after shift commencement. Supports Key Performance Indicator (KPI) measurement for vessel turnaround SLA compliance.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record from which this roster record originated. Supports data lineage tracking in the Databricks Silver Layer. Values: ORACLE_HCM (Oracle HCM Cloud), NAVIS_N4 (NAVIS N4 Labour Planning), SAP_HR (SAP S/4HANA HR), MANUAL (manually entered).. Valid values are `ORACLE_HCM|NAVIS_N4|SAP_HR|MANUAL`',
    `source_system_record_code` STRING COMMENT 'The native record identifier from the originating operational system (Oracle HCM Cloud, NAVIS N4, or SAP HR) for this roster entry. Enables reconciliation and traceability back to the system of record.',
    `work_order_reference` STRING COMMENT 'Reference number linking this roster assignment to a specific operational work order in NAVIS N4 or Maximo, such as a cargo loading/discharge operation or equipment maintenance task.',
    CONSTRAINT pk_roster PRIMARY KEY(`roster_id`)
) COMMENT 'Workforce rostering and shift management covering shift pattern definitions and planned employee assignments. Shift configuration: shift codes, names, start/end times, duration, break entitlements, shift types (regular, overtime, standby, call-out), applicable terminal or department, and MLC rest hour compliance parameters. Roster assignments: roster period (start and end dates), employee assignment to shift, position, terminal or berth area, gang assignment, roster status (draft, published, confirmed), and roster change reasons. Supports advance planning for vessel call labour requirements, ensures MLC minimum rest hour compliance, and provides the scheduling foundation for time and attendance recording. Sourced from Oracle HCM Cloud Scheduling, Work Schedules, and NAVIS N4 labour planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` (
    `time_attendance_id` BIGINT COMMENT 'Unique surrogate identifier for each time and attendance record in the port workforce management system. Primary key for this entity.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Time tracking at berth level enables accurate costing per berth, productivity measurement, and labor cost allocation to vessel calls. Essential for berth utilization analysis and operational KPIs.',
    `call_id` BIGINT COMMENT 'Reference to the vessel operation or port call to which the employees shift labour was allocated. Applicable for stevedores, marine pilots, mooring gangs, and other vessel-facing roles. Enables vessel-level labour cost attribution.',
    `gang_id` BIGINT COMMENT 'Reference to the stevedore gang or work crew to which the employee was assigned during this shift. Applicable for stevedores, equipment operators, and dock workers performing cargo handling operations. Used for gang-level productivity and labour cost analysis.',
    `leave_request_id` BIGINT COMMENT 'Foreign key linking to workforce.leave_request. Business justification: When an employee is absent, the time_attendance record can reference the approved leave_request. This is an optional (nullable) relationship - not all absences have formal leave requests. Enables link',
    `payroll_run_id` BIGINT COMMENT 'Reference to the SAP HR payroll run in which this attendance record was processed. Populated once payroll_processed = True. Enables traceability between attendance records and payroll outputs.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Attendance is recorded at specific locations (gate entry, berth, yard) for time tracking, payroll cost allocation by location, and ISPS security compliance. FK enables location-based labor cost report',
    `position_id` BIGINT COMMENT 'Code identifying the employees job role or position during this shift (e.g., STEVEDORE, QC-OPERATOR, MARINE-PILOT, SECURITY-OFFICER, ADMIN). Used for role-based pay rate application and workforce composition reporting.',
    `employee_id` BIGINT COMMENT 'Reference to the employee whose time and attendance is being recorded. Links to the workforce employee master record in Oracle HCM Cloud.',
    `roster_id` BIGINT COMMENT 'Foreign key linking to workforce.roster. Business justification: time_attendance records actual attendance for a rostered shift. The roster is the plan, time_attendance is the actuals. This FK links actual time worked to the planned roster entry, enabling plan vs. ',
    `shift_pattern_id` BIGINT COMMENT 'Reference to the scheduled shift assignment for which this attendance record applies. Links to the shift scheduling master.',
    `terminal_zone_id` BIGINT COMMENT 'Reference to the port terminal or facility where the employee worked during this shift. Supports multi-terminal port operations where employees may be deployed across different terminals.',
    `absence_type` STRING COMMENT 'Classification of the reason for employee absence when attendance_status is absent. Drives leave balance deduction and payroll treatment in Oracle HCM Cloud and SAP HR. [ENUM-REF-CANDIDATE: annual_leave|sick_leave|unpaid_leave|public_holiday|maternity_paternity|training|compassionate|jury_duty|medical_appointment|suspension — promote to reference product]. Valid values are `annual_leave|sick_leave|unpaid_leave|public_holiday|maternity_paternity|training`',
    `amendment_reason` STRING COMMENT 'Free-text description of the reason for any manual amendment or correction to this attendance record (e.g., system outage, RFID reader failure, missed clock-out). Required when entry_method is manual or supervisor_entry for audit trail purposes.',
    `approval_status` STRING COMMENT 'Workflow approval status of the time and attendance record. Records must be approved by a supervisor before being submitted to payroll. Pending = awaiting review; Approved = confirmed for payroll; Rejected = returned for correction; Disputed = under formal dispute.. Valid values are `pending|approved|rejected|disputed`',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when the supervisor approved or rejected this attendance record. Part of the payroll audit trail and MLC compliance documentation.',
    `attendance_date` DATE COMMENT 'The calendar date for which this time and attendance record applies. Used for daily payroll calculation, MLC rest hour compliance monitoring, and workforce reporting.',
    `attendance_status` STRING COMMENT 'Current attendance status of the employee for the shift. Indicates whether the employee was present, absent, arrived late, departed early, or partially attended. Critical for payroll deduction and MLC compliance reporting.. Valid values are `present|absent|late|early_departure|partial`',
    `biometric_verified` BOOLEAN COMMENT 'Indicates whether the employees identity was verified via biometric authentication (fingerprint, facial recognition) at clock-in or gate entry. True = biometric verification completed; False = RFID-only or manual entry. Supports ISPS security compliance and payroll fraud prevention.',
    `break_duration_minutes` STRING COMMENT 'Total break time in minutes taken by the employee during the shift. Captured from RFID or biometric break-room scan data. Used to compute net hours worked for payroll and MLC rest hour compliance.',
    `break_end_timestamp` TIMESTAMP COMMENT 'The timestamp when the employee returned from their scheduled break period. Used together with break_start_timestamp to calculate total break duration and net productive hours.',
    `break_start_timestamp` TIMESTAMP COMMENT 'The timestamp when the employee commenced their scheduled break period during the shift. Used to calculate net working hours and verify MLC minimum rest period compliance.',
    `clock_in_timestamp` TIMESTAMP COMMENT 'The exact date and time the employee clocked in at the start of their shift, captured via RFID badge scan or biometric verification at the terminal gate or facility entry point. Principal business event timestamp for this record.',
    `clock_out_timestamp` TIMESTAMP COMMENT 'The exact date and time the employee clocked out at the end of their shift, captured via RFID badge scan or biometric verification. Used to calculate total hours worked and overtime.',
    `cost_center_code` STRING COMMENT 'SAP CO cost center code to which the employees worked hours are charged for financial accounting and OPEX allocation. Enables labour cost attribution by terminal operation, department, or project.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this time and attendance record was first created in the system. Audit trail field for data governance and compliance purposes.',
    `early_departure_minutes` STRING COMMENT 'Number of minutes the employee departed before the scheduled shift end time. Zero if departed on time or later. Used for attendance discipline tracking and payroll deduction calculation.',
    `entry_method` STRING COMMENT 'The method by which the clock-in/clock-out time was captured. RFID scan = automated badge reader; Biometric = fingerprint/facial recognition; Manual = supervisor or HR manual entry; Mobile app = employee self-service; Supervisor entry = entered by line manager.. Valid values are `rfid_scan|biometric|manual|mobile_app|supervisor_entry`',
    `gate_entry_timestamp` TIMESTAMP COMMENT 'The timestamp when the employee physically entered the port terminal through the security gate, captured from NAVIS N4 Gate Operations or ISPS-compliant access control system. May differ from clock_in_timestamp if the employee entered the terminal before clocking in.',
    `gate_exit_timestamp` TIMESTAMP COMMENT 'The timestamp when the employee physically exited the port terminal through the security gate. Used for ISPS security compliance, access duration tracking, and cross-referencing with clock-out data.',
    `hours_worked` DECIMAL(18,2) COMMENT 'Total net hours worked by the employee during the shift, calculated as (clock_out - clock_in) minus break_duration_minutes. Expressed in decimal hours. Feeds SAP HR payroll calculation and MLC rest hour compliance monitoring.',
    `is_public_holiday` BOOLEAN COMMENT 'Indicates whether the attendance date falls on a public holiday. True = public holiday; False = regular working day. Drives public holiday pay rate multiplier application in SAP HR payroll.',
    `late_arrival_minutes` STRING COMMENT 'Number of minutes the employee arrived late relative to the scheduled shift start time. Zero if on time or early. Used for attendance discipline tracking, payroll deduction calculation, and KPI reporting on workforce punctuality.',
    `mlc_rest_hours_compliant` BOOLEAN COMMENT 'Indicates whether the employees rest hours between this shift and the previous shift meet the MLC 2006 minimum rest period requirements (minimum 10 hours rest in any 24-hour period; minimum 77 hours rest in any 7-day period). True = compliant; False = potential MLC violation requiring review.',
    `overtime_hours` DECIMAL(18,2) COMMENT 'Number of hours worked beyond the standard shift duration, expressed in decimal hours. Used for overtime pay calculation in SAP HR payroll and for MLC maximum hours of work compliance monitoring.',
    `pay_period_code` STRING COMMENT 'Identifier for the payroll period (e.g., 2024-W23, 2024-M06) to which this attendance record belongs. Used to group attendance records for payroll run processing in SAP HR.',
    `payroll_processed` BOOLEAN COMMENT 'Indicates whether this attendance record has been included in a payroll run and processed in SAP HR. True = included in payroll; False = pending payroll processing. Prevents double-counting in payroll runs.',
    `rest_hours_before_shift` DECIMAL(18,2) COMMENT 'Number of hours of rest the employee had between the end of their previous shift and the start of this shift. Critical for MLC 2006 Regulation 2.3 compliance monitoring — minimum 10 hours rest required in any 24-hour period.',
    `rfid_badge_number` STRING COMMENT 'The unique RFID badge identifier used by the employee to clock in/out and access the terminal. Captured from RFID reader scan events. Used to verify identity and link physical access events to attendance records.',
    `scheduled_end_time` TIMESTAMP COMMENT 'The planned end time of the employees shift as per the shift schedule. Used to calculate early departure and compare against actual clock-out time.',
    `scheduled_start_time` TIMESTAMP COMMENT 'The planned start time of the employees shift as per the shift schedule. Used to calculate lateness and compare against actual clock-in time for attendance compliance.',
    `shift_type` STRING COMMENT 'Classification of the shift pattern worked by the employee. Port operations run 24/7 across day, afternoon, and night shifts. Used for shift differential pay calculation and MLC rest hour compliance monitoring.. Valid values are `day|afternoon|night|rotating|on_call|split`',
    `source_record_code` STRING COMMENT 'The native record identifier from the originating source system (Oracle HCM Cloud, SAP HR, or NAVIS N4). Used for data lineage tracing, reconciliation, and deduplication in the Databricks Silver Layer.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this time and attendance record was last modified. Used to track amendments, corrections, and approval workflow updates for audit trail purposes.',
    CONSTRAINT pk_time_attendance PRIMARY KEY(`time_attendance_id`)
) COMMENT 'Actual time and attendance records for each employee per shift including clock-in, clock-out, break times, total hours worked, overtime hours, absence type if applicable, and attendance status (present, absent, late, early departure). Captures RFID badge scan data, biometric verification flag, and terminal gate entry/exit timestamps. Feeds SAP HR payroll and Oracle HCM Cloud Time and Attendance modules. Critical for MLC rest hour compliance monitoring and payroll calculation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` (
    `leave_request_id` BIGINT COMMENT 'Unique system-generated identifier for each employee leave request record in the workforce management system. Primary key for the leave_request data product.',
    `employee_id` BIGINT COMMENT 'Reference to the manager or supervisor responsible for approving or rejecting this leave request. Populated once the approval workflow reaches the approver step.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Leave request is associated with an organizational unit (department). Currently denormalized with department_code. Adding org_unit_id FK enables proper normalization.',
    `position_id` BIGINT COMMENT 'Foreign key linking to workforce.position. Business justification: Leave request should capture the position at time of request (point-in-time snapshot). While employee has position_id, this ensures historical accuracy if employee changes positions. Removes redundant',
    `primary_leave_employee_id` BIGINT COMMENT 'Reference to the employee submitting the leave request. Links to the employee master record in Oracle HCM Cloud and SAP HR.',
    `actual_return_date` DATE COMMENT 'The date the employee actually returned to work from leave. May differ from approved_end_date in cases of early return, extended sick leave, or compassionate leave extensions. Used for attendance reconciliation and payroll.',
    `approval_status` STRING COMMENT 'Current workflow state of the leave request through the approval lifecycle: draft (saved but not submitted), pending (awaiting approver action), approved, rejected, cancelled (by admin), or withdrawn (by employee).. Valid values are `draft|pending|approved|rejected|cancelled|withdrawn`',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when the approver made the final approval or rejection decision. Null if the request is still pending. Used for SLA compliance tracking of approval turnaround time.',
    `approved_days` DECIMAL(18,2) COMMENT 'Total number of working days approved, which may differ from requested_days if the approver modified the leave period. Used for payroll deduction and leave balance updates in SAP HR.',
    `approved_end_date` DATE COMMENT 'The actual approved end date of the leave, which may differ from the requested end date if the approver modified the dates to accommodate operational requirements.',
    `approved_start_date` DATE COMMENT 'The actual approved start date of the leave, which may differ from the requested start date if the approver modified the dates to accommodate operational requirements such as minimum gang complement.',
    `approver_comments` STRING COMMENT 'Free-text comments entered by the approving manager when approving, rejecting, or modifying the leave request. Provides audit trail for approval decisions and communicates conditions or deferrals to the employee.',
    `cost_centre_code` STRING COMMENT 'SAP S/4HANA cost centre to which the employees leave cost (paid leave) is charged. Enables financial reporting of leave liability and OPEX allocation across port operational divisions.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the leave request record was first created in the source system (Oracle HCM Cloud). May differ from submission_timestamp if the employee saved a draft before submitting.',
    `employee_comments` STRING COMMENT 'Free-text comments provided by the employee when submitting the leave request, providing additional context such as travel plans, medical circumstances, or operational handover notes.',
    `gang_complement_affected` BOOLEAN COMMENT 'Specific flag indicating whether approving this leave would reduce the stevedore gang complement below the minimum safe working level required for cargo operations. Critical for vessel scheduling and STS/RTG crane operations.',
    `half_day_flag` BOOLEAN COMMENT 'Indicates whether the leave request is for a half-day (morning or afternoon session) rather than a full working day. Supports flexible leave management for port workers on rotating shift patterns.',
    `half_day_session` STRING COMMENT 'Specifies whether the half-day leave applies to the morning or afternoon session. Only populated when half_day_flag is true. Relevant for shift scheduling and gang complement planning.. Valid values are `morning|afternoon`',
    `handover_completed_flag` BOOLEAN COMMENT 'Indicates whether the employee has completed the required operational handover to their substitute or team before commencing leave. Particularly important for marine pilots, crane operators, and security personnel.',
    `leave_balance_at_request` DECIMAL(18,2) COMMENT 'The employees available leave balance (in days) for the requested leave type at the time the request was submitted. Captured as a snapshot to support audit and dispute resolution.',
    `leave_category` STRING COMMENT 'Indicates whether the leave is fully paid, unpaid, or partially paid, which drives payroll processing in SAP S/4HANA HR and determines the financial impact on the employees earnings.. Valid values are `paid|unpaid|partially_paid`',
    `leave_loading_applicable` BOOLEAN COMMENT 'Indicates whether the employee is entitled to leave loading (an additional payment percentage on top of base pay during annual leave) as per the applicable enterprise agreement or MLC provisions.',
    `leave_type` STRING COMMENT 'Classification of the leave being requested. Shore leave is a Maritime Labour Convention (MLC) 2006-mandated entitlement for seafarers and port workers. [ENUM-REF-CANDIDATE: annual|sick|maternity|paternity|compassionate|shore_leave|unpaid|study — promote to reference product]',
    `leave_year` STRING COMMENT 'The leave entitlement year (e.g., 2024) against which this leave request is charged. Used for annual leave balance management, MLC compliance reporting, and year-end leave liability calculations in SAP HR.',
    `medical_certificate_received` BOOLEAN COMMENT 'Indicates whether the required medical certificate has been received and verified by HR. Relevant for sick leave compliance and MLC health-related absence management. Null when medical_certificate_required is false.',
    `medical_certificate_required` BOOLEAN COMMENT 'Indicates whether a medical certificate is required to support this leave request (typically for sick leave exceeding the threshold number of days defined in the enterprise leave policy or MLC requirements).',
    `mlc_shore_leave_flag` BOOLEAN COMMENT 'Indicates whether this leave request is an MLC 2006 Regulation 2.4-mandated shore leave entitlement for seafarers or port workers. MLC shore leave requests carry special compliance obligations and cannot be unreasonably denied.',
    `operational_impact_flag` BOOLEAN COMMENT 'Indicates whether this leave request has been flagged as having an operational impact on port operations, such as reducing a stevedore gang below the minimum complement required for vessel operations or crane operations.',
    `payroll_period` STRING COMMENT 'The payroll processing period (YYYY-MM) in which this leave is processed for pay deduction or leave loading payment in SAP S/4HANA HR. Ensures correct financial period allocation for leave costs.. Valid values are `^[0-9]{4}-[0-9]{2}$`',
    `reason_code` STRING COMMENT 'Standardized reason code for the leave request as defined in Oracle HCM Cloud Absence Management (e.g., ANNUAL_PLAN, MEDICAL_CERT, BEREAVEMENT, MLC_SHORE). Supports absence analytics and MLC compliance reporting. [ENUM-REF-CANDIDATE: promote to reference product]',
    `rejection_reason` STRING COMMENT 'Structured reason for rejection when approval_status is rejected. Captures the business justification such as insufficient staffing, minimum gang complement not met, or peak operational period. Supports MLC compliance and grievance management.',
    `request_number` STRING COMMENT 'Externally visible, human-readable reference number for the leave request, used in correspondence, approval workflows, and payroll integration. Format: LR-YYYY-NNNNNN.. Valid values are `^LR-[0-9]{4}-[0-9]{6}$`',
    `requested_days` DECIMAL(18,2) COMMENT 'Total number of working days requested by the employee, calculated from requested_start_date to requested_end_date excluding weekends and public holidays. Supports half-day precision.',
    `requested_end_date` DATE COMMENT 'The last calendar date of the leave period as requested by the employee. Combined with requested_start_date to determine the total requested leave duration.',
    `requested_start_date` DATE COMMENT 'The first calendar date of the leave period as requested by the employee. Used for scheduling, gang complement planning, and operational impact assessment.',
    `shift_pattern` STRING COMMENT 'The employees assigned shift pattern at the time of the leave request. Determines which operational shifts will be affected and informs gang complement impact assessment.. Valid values are `day|night|rotating|swing`',
    `source_system_ref` STRING COMMENT 'The native record identifier from the source system (Oracle HCM Cloud Absence Management transaction ID or SAP HR absence record key). Enables traceability and reconciliation back to the system of record.',
    `submission_timestamp` TIMESTAMP COMMENT 'The date and time when the employee formally submitted the leave request into the Oracle HCM Cloud Absence Management system. Represents the principal business event timestamp for this transaction.',
    `terminal_code` STRING COMMENT 'The port terminal or operational area to which the employee is assigned (e.g., CT1, CT2, RoRo Terminal). Used to assess operational impact on terminal staffing levels and gang complement planning.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to the leave request record, including status changes, date amendments, or comment additions. Supports data lineage and audit trail requirements.',
    CONSTRAINT pk_leave_request PRIMARY KEY(`leave_request_id`)
) COMMENT 'Employee leave applications and approvals covering annual leave, sick leave, maternity/paternity leave, compassionate leave, and MLC-mandated shore leave for seafarers. Captures leave type, requested start and end dates, approved dates, leave balance at time of request, approval workflow status, approver, and any operational impact flag (e.g., affects minimum gang complement). Sourced from Oracle HCM Cloud Absence Management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` (
    `payroll_run_id` BIGINT COMMENT 'Unique surrogate identifier for each payroll run record in the Databricks Silver layer. Primary key for the payroll_run data product.',
    `org_unit_id` BIGINT COMMENT 'add column org_unit_id (BIGINT) with FK to workforce.org_unit.org_unit_id - payroll runs are executed per organizational unit for cost allocation',
    `employee_id` BIGINT COMMENT 'SAP employee ID of the payroll manager or HR director who formally approved this payroll run for posting. Supports audit trail and segregation of duties compliance.',
    `reversed_run_payroll_run_id` BIGINT COMMENT 'Reference to the original payroll_run_id that this run reverses or corrects. Populated only for correction or reversal run types, enabling audit chain traceability.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when the payroll run was formally approved by the authorised payroll manager or HR director, enabling progression to the posting stage.',
    `bank_file_reference` STRING COMMENT 'Reference number of the bank payment file (e.g., ABA, BACS, SEPA file) generated for this payroll run and submitted to the ports banking institution for net pay disbursement.',
    `bank_submission_timestamp` TIMESTAMP COMMENT 'The date and time when the bank payment file was submitted to the financial institution for processing. Used for payment traceability and treasury reconciliation.',
    `cost_centre_code` STRING COMMENT 'SAP CO cost centre code to which the aggregate payroll costs for this run are posted. Enables labour cost allocation by port operational division (e.g., terminal operations, marine services, administration).',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this payroll run record was first created in the system. Supports audit trail and data lineage tracking in the Databricks Silver layer.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this payroll run (e.g., AUD, USD, SGD). All gross pay, deductions, and net pay figures are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `fiscal_period` STRING COMMENT 'The fiscal accounting period (month number 1–12 or 1–16 for special periods) within the fiscal year to which payroll costs are posted in SAP FI/CO.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this payroll run belongs, used for financial reporting, SAP CO cost allocation, and year-to-date payroll reconciliation.',
    `gl_account_code` STRING COMMENT 'SAP FI general ledger account code used for posting payroll expenses in this run. Supports financial reconciliation between HR payroll and the ports financial accounts.',
    `gross_pay_total` DECIMAL(18,2) COMMENT 'Total gross earnings for all employees processed in this payroll run before any deductions. Includes base pay, allowances, overtime, and all other earnings components. Used for financial reconciliation and SAP FI/CO posting.',
    `headcount_errors` STRING COMMENT 'Number of employee records that encountered processing errors during the payroll run and were excluded from the final payroll results. Used for quality control and exception management.',
    `headcount_processed` STRING COMMENT 'Total number of employee records included and processed in this payroll run. Used for payroll reconciliation, workforce reporting, and KPI tracking.',
    `mlc_compliant` BOOLEAN COMMENT 'Indicates whether this payroll run meets all Maritime Labour Convention (MLC) 2006 wage payment requirements, including minimum wage, timely payment, and wage statement provision. Critical for port state control inspections and flag state compliance.',
    `net_pay_total` DECIMAL(18,2) COMMENT 'Total net pay disbursed to all employees in this payroll run after all deductions. This is the total bank transfer amount and is used for treasury cash management and bank file reconciliation.',
    `oracle_hcm_batch_code` STRING COMMENT 'Reference identifier from Oracle HCM Cloud for the corresponding workforce management batch that feeds time and attendance data into this SAP payroll run. Supports cross-system reconciliation between Oracle HCM and SAP HR.',
    `pay_frequency` STRING COMMENT 'The frequency at which this payroll run is executed, determining the pay cycle length. Maritime port workforces may have weekly cycles for casual stevedores and monthly cycles for salaried staff.. Valid values are `weekly|fortnightly|monthly|bi-monthly`',
    `pay_group_code` STRING COMMENT 'Code identifying the employee pay group processed in this run, used to segment workforce populations such as permanent, casual, maritime, or shore-based employees.',
    `pay_group_description` STRING COMMENT 'Descriptive label for the pay group, e.g., Permanent Waterfront, Casual Stevedore, Marine Pilot, Port Security Officer.',
    `payment_date` DATE COMMENT 'The scheduled date on which net pay is disbursed to employees bank accounts via bank transfer or other payment method. Must comply with MLC 2006 Regulation 2.2 wage payment timeliness requirements.',
    `payroll_area_code` STRING COMMENT 'SAP HR payroll area code that defines the grouping of employees processed together in this payroll run (e.g., stevedores, marine pilots, administrative staff). Corresponds to the SAP Payroll Area (Abrechnungskreis) configuration object.',
    `payroll_area_description` STRING COMMENT 'Human-readable description of the SAP payroll area, such as Stevedore Gang - Waterfront, Marine Pilots, Port Security, or Administrative Staff.',
    `payroll_period_code` STRING COMMENT 'SAP payroll period identifier combining the period number and fiscal year (e.g., 01/2024, 26/2024 for fortnightly). Uniquely identifies the pay cycle within the payroll area.',
    `payslips_generated` BOOLEAN COMMENT 'Indicates whether individual employee payslips (wage statements) have been generated and made available for this payroll run. MLC 2006 Regulation 2.2 requires seafarers and maritime workers to receive a written wage statement.',
    `period_end_date` DATE COMMENT 'The last calendar date of the payroll period covered by this run. Defines the end of the pay cycle for time and attendance aggregation.',
    `period_start_date` DATE COMMENT 'The first calendar date of the payroll period covered by this run. Defines the start of the pay cycle for time and attendance aggregation.',
    `posted_timestamp` TIMESTAMP COMMENT 'The date and time when payroll results were posted to the SAP FI/CO general ledger and cost centres, completing the financial integration of the payroll run.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this payroll run has been reversed. A reversed run requires a correction run to be executed. Used for audit trail and financial reconciliation.',
    `run_execution_timestamp` TIMESTAMP COMMENT 'The date and time when the payroll calculation was initiated and executed in SAP HR Payroll. This is the principal business event timestamp for the payroll run lifecycle.',
    `run_notes` STRING COMMENT 'Free-text notes entered by the payroll administrator documenting any exceptions, special processing instructions, or explanations for this payroll run (e.g., vessel arrival delays affecting overtime, industrial action adjustments).',
    `run_status` STRING COMMENT 'Current lifecycle status of the payroll run. Draft: initial setup; In Progress: payroll calculation executing; Completed: calculation finished pending approval; Approved: authorised by payroll manager; Posted: payroll results posted to SAP FI/CO general ledger; Reversed: run has been reversed and reprocessed.. Valid values are `draft|in_progress|completed|approved|posted|reversed`',
    `run_type` STRING COMMENT 'Classifies the nature of the payroll run. Regular runs are standard scheduled cycles; off-cycle runs handle terminations or corrections; supplemental runs process bonuses or back-pay; correction runs fix errors from prior periods; final runs close out a payroll year.. Valid values are `regular|off-cycle|supplemental|correction|final`',
    `total_allowances` DECIMAL(18,2) COMMENT 'Aggregate of all allowance payments across the payroll run, including shift allowances, danger allowances, meal allowances, and maritime-specific allowances such as port operations and hazardous cargo allowances.',
    `total_base_pay` DECIMAL(18,2) COMMENT 'Aggregate base salary or wage component across all employees in this payroll run, excluding allowances and overtime. Used for compensation benchmarking and cost analysis.',
    `total_deductions` DECIMAL(18,2) COMMENT 'Total of all employee deductions across the payroll run, including income tax (PAYG/PAYE), pension/superannuation contributions, union dues, and other statutory or voluntary deductions.',
    `total_employer_contributions` DECIMAL(18,2) COMMENT 'Total employer-side payroll contributions for this run, including employer pension/superannuation contributions, workers compensation levies, and other statutory employer obligations. Represents the full employment cost beyond gross pay.',
    `total_overtime_pay` DECIMAL(18,2) COMMENT 'Aggregate overtime earnings across all employees in this payroll run. Overtime is common in port operations due to vessel scheduling, tidal windows, and 24/7 terminal operations.',
    `total_pension_deductions` DECIMAL(18,2) COMMENT 'Aggregate employee pension or superannuation contributions deducted across all employees in this payroll run. Supports pension fund remittance and MLC 2006 social security compliance.',
    `total_tax_withheld` DECIMAL(18,2) COMMENT 'Aggregate income tax withheld from all employee pay in this payroll run. Used for statutory tax remittance reporting to national tax authorities.',
    `total_union_dues` DECIMAL(18,2) COMMENT 'Aggregate union membership dues deducted from employee pay in this payroll run. Waterfront and maritime workers are typically represented by maritime unions; dues are remitted to the relevant union body.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this payroll run record was last modified in the system. Used for incremental data loading, change tracking, and audit compliance in the Databricks Silver layer.',
    CONSTRAINT pk_payroll_run PRIMARY KEY(`payroll_run_id`)
) COMMENT 'Payroll processing records covering payroll run execution and individual employee pay details (payslips). Header level: payroll period, pay group, total headcount processed, gross pay total, net pay total, total deductions, employer contributions, payroll status (draft, approved, posted), and SAP HR payroll area reference. Line level (payslip): individual employee gross earnings, base pay, allowances (shift, danger, meal), overtime pay, deductions (tax, pension, union dues), net pay, year-to-date totals, payment date, payment method, and bank account reference. Each run represents a complete payroll cycle for a defined employee group with full detail down to individual pay records. Sourced from SAP HR Payroll (PY) module. SSOT for payroll execution, individual employee compensation records (payslips), financial reconciliation, and MLC wage statement compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` (
    `payslip_id` BIGINT COMMENT 'Unique surrogate identifier for each individual payslip record in the Databricks Silver Layer. Primary key for the payslip data product. Role: TRANSACTION_HEADER.',
    `employee_id` BIGINT COMMENT 'Reference to the employee for whom this payslip is generated. Links to the workforce employee master record in Oracle HCM Cloud / SAP HR. PARTY_REFERENCE category per TRANSACTION_HEADER role.',
    `payroll_run_id` BIGINT COMMENT 'Reference to the payroll run batch that generated this payslip. Links to the payroll run control record in SAP HR Payroll (PY). Enables traceability of payslip to its originating payroll processing cycle.',
    `position_id` BIGINT COMMENT 'Foreign key linking to workforce.position. Business justification: Payslip should capture the position at time of payment (point-in-time snapshot). While employee has position_id, the employees position may change over time. Payslip needs its own position_id for his',
    `bank_account_reference` STRING COMMENT 'Masked or tokenised reference to the employees nominated bank account for net pay disbursement. Full account details are stored in the secure payroll system (SAP HR Infotype 0009). Only the last 4 digits or a token is stored here for audit trail purposes.',
    `base_pay` DECIMAL(18,2) COMMENT 'Gross base salary or wage earned by the employee for the pay period before any allowances, overtime, or deductions. Calculated from the employees pay grade and contracted hours. MONETARY_TRIPLET gross-base component per TRANSACTION_HEADER role.',
    `cost_centre_code` STRING COMMENT 'SAP Controlling (CO) cost centre to which the employees payroll costs are allocated for the pay period. Enables financial reporting, OPEX tracking, and departmental cost management. May differ from department_code for cross-charged employees.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this payslip record was first created in the data platform (Databricks Silver Layer). RECORD_AUDIT_CREATED category per TRANSACTION_HEADER role. Used for data lineage and audit trail.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary amounts on this payslip are denominated (e.g., USD, AUD, SGD, EUR). Required for multi-currency port operations and MLC wage statement compliance.. Valid values are `^[A-Z]{3}$`',
    `danger_allowance` DECIMAL(18,2) COMMENT 'Hazard or danger allowance paid to employees working in high-risk port environments such as IMDG cargo handling, confined space operations, or heavy lift operations. Mandated under OHS regulations and enterprise agreements.',
    `department_code` STRING COMMENT 'Organisational department code to which the employee is assigned during the pay period (e.g., Terminal Operations, Marine Services, Port Security, Finance). Used for cost allocation and workforce analytics.',
    `employee_full_name` STRING COMMENT 'Full legal name of the employee as printed on the payslip. Required for MLC wage statement compliance and employee identification. Sourced from SAP HR Infotype 0002 / Oracle HCM Cloud Person record.',
    `employer_pension_contribution` DECIMAL(18,2) COMMENT 'Employers superannuation or pension contribution for the employee for the pay period, calculated as a percentage of ordinary time earnings. Shown on payslip for MLC social security transparency. Not deducted from employee pay.',
    `employment_type` STRING COMMENT 'Classification of the employees employment arrangement. Port workforces typically include permanent staff, casual stevedore gangs, contracted marine pilots, and fixed-term project staff. Affects entitlements, allowances, and MLC applicability.. Valid values are `permanent|casual|contract|fixed-term|apprentice`',
    `gross_pay` DECIMAL(18,2) COMMENT 'Total gross earnings for the pay period before any deductions, comprising base pay plus all allowances and overtime pay. MONETARY_TRIPLET gross-base amount per TRANSACTION_HEADER role. Printed on MLC wage statement.',
    `income_tax_deduction` DECIMAL(18,2) COMMENT 'Amount of income tax withheld from the employees gross pay for the pay period in accordance with applicable national tax legislation. Calculated based on the employees tax code, residency status, and gross earnings.',
    `is_mlc_compliant` BOOLEAN COMMENT 'Indicates whether this payslip meets all Maritime Labour Convention 2006 wage statement requirements, including minimum wage, deduction limits, and payment method compliance. Set by the payroll compliance validation process. Critical for Port State Control (PSC) inspections.',
    `issue_timestamp` TIMESTAMP COMMENT 'Date and time when the payslip was formally issued and made available to the employee (via employee self-service portal, email, or physical distribution). BUSINESS_EVENT_TIMESTAMP (precise issuance time) per TRANSACTION_HEADER role.',
    `leave_hours_taken` DECIMAL(18,2) COMMENT 'Total hours of approved leave (annual leave, sick leave, personal leave) taken by the employee during the pay period. Used to reconcile leave balances and verify leave pay calculations.',
    `leave_loading_pay` DECIMAL(18,2) COMMENT 'Additional leave loading payment (typically 17.5% of base pay) paid when the employee takes annual leave, as mandated by enterprise agreements common in Australian and Asia-Pacific port operations. Zero if no leave was taken in the period.',
    `meal_allowance` DECIMAL(18,2) COMMENT 'Meal or subsistence allowance paid to employees for extended shifts, overtime, or remote port assignments. Typically defined in enterprise agreements for stevedore gangs and marine service personnel.',
    `national_id_number` STRING COMMENT 'Government-issued national identification number (e.g., national ID, tax file number, social security number) of the employee. Required for tax authority reporting, payroll tax calculations, and regulatory compliance. Stored in encrypted form.',
    `net_pay` DECIMAL(18,2) COMMENT 'Final amount payable to the employee after all deductions have been applied (gross_pay minus total_deductions). MONETARY_TRIPLET net total per TRANSACTION_HEADER role. The amount actually disbursed to the employees bank account.',
    `ordinary_hours_worked` DECIMAL(18,2) COMMENT 'Total ordinary (non-overtime) hours worked by the employee during the pay period. Used to verify base pay calculations, monitor MLC rest hour compliance, and support workforce productivity analytics. Sourced from Oracle HCM Cloud Time and Attendance.',
    `other_deductions` DECIMAL(18,2) COMMENT 'Aggregate of all other authorised deductions not separately itemised (e.g., salary advance repayments, equipment damage levies, voluntary savings). MLC 2006 restricts deductions to those authorised by law or collective agreement.',
    `overtime_hours` DECIMAL(18,2) COMMENT 'Total number of overtime hours worked by the employee during the pay period. Used to verify overtime pay calculations, monitor MLC rest hour compliance, and support workforce planning analytics.',
    `overtime_pay` DECIMAL(18,2) COMMENT 'Total overtime earnings for the pay period, calculated from overtime hours worked multiplied by the applicable overtime rate. Critical for port operations where vessel turnaround requirements drive significant overtime for stevedore and crane operator workforces.',
    `pay_frequency` STRING COMMENT 'Frequency at which the employee is paid, determining the pay period cycle. Port workforce may include weekly-paid stevedore gangs, fortnightly-paid equipment operators, and monthly-paid administrative staff.. Valid values are `weekly|fortnightly|monthly|bi-monthly`',
    `pay_grade` STRING COMMENT 'Salary grade or pay band assigned to the employees position, determining the base pay range. Sourced from SAP HR Infotype 0008 (Basic Pay). Confidential as it reveals compensation structure.',
    `pay_period_end_date` DATE COMMENT 'Last calendar date of the pay period covered by this payslip. Defines the end boundary of the earnings and deductions calculation window. Together with pay_period_start_date, fully identifies the pay period.',
    `pay_period_start_date` DATE COMMENT 'First calendar date of the pay period covered by this payslip. Defines the start boundary of the earnings and deductions calculation window. BUSINESS_EVENT_TIMESTAMP category (date precision) per TRANSACTION_HEADER role.',
    `payment_date` DATE COMMENT 'Actual date on which net pay was or is scheduled to be disbursed to the employees nominated bank account or via the designated payment method. Critical for MLC wage payment timeliness compliance and cash flow management.',
    `payment_method` STRING COMMENT 'Method by which net pay is disbursed to the employee. Bank transfer is the predominant method for port workforces; cash may apply for casual stevedore gangs in some jurisdictions. MLC 2006 requires payment in legal tender or by bank transfer.. Valid values are `bank_transfer|cheque|cash|digital_wallet`',
    `payroll_area` STRING COMMENT 'SAP HR Payroll area code grouping employees processed together in the same payroll run cycle (e.g., stevedores, marine pilots, administrative staff, security). Determines pay frequency and payroll calendar. [ENUM-REF-CANDIDATE: promote to reference product as payroll areas vary by port organisation]',
    `payslip_number` STRING COMMENT 'Externally-known unique business identifier for the payslip, formatted as PS-YYYY-MM-EMPREF. Used for employee reference, MLC wage statement compliance, and audit trail. BUSINESS_IDENTIFIER category per TRANSACTION_HEADER role.. Valid values are `^PS-[0-9]{4}-[0-9]{2}-[A-Z0-9]{6,12}$`',
    `payslip_status` STRING COMMENT 'Current lifecycle state of the payslip document. draft indicates payroll is being processed; generated means the payslip has been computed; issued means it has been delivered to the employee; cancelled means it was voided; reissued means a corrected version was produced. LIFECYCLE_STATUS category per TRANSACTION_HEADER role.. Valid values are `draft|generated|issued|cancelled|reissued`',
    `pension_deduction` DECIMAL(18,2) COMMENT 'Employee contribution to pension, superannuation, or provident fund deducted from gross pay for the pay period. Mandatory under national pension legislation and MLC 2006 social security provisions.',
    `shift_allowance` DECIMAL(18,2) COMMENT 'Additional allowance paid to employees working non-standard shifts (night shifts, weekend shifts, rotating shifts) in port terminal operations. Common for stevedore gangs, crane operators, and vessel traffic service staff operating 24/7.',
    `tax_code` STRING COMMENT 'Employees tax withholding code or tax category assigned by the national tax authority, determining the applicable income tax rate and withholding calculation method. Sourced from SAP HR Infotype 0161 / Oracle HCM Cloud Tax Card.',
    `total_deductions` DECIMAL(18,2) COMMENT 'Sum of all deductions applied in the pay period (income tax + pension + union dues + other deductions). MONETARY_TRIPLET adjustment component per TRANSACTION_HEADER role. Printed on MLC wage statement for transparency.',
    `union_dues_deduction` DECIMAL(18,2) COMMENT 'Trade union membership dues deducted from the employees pay per authorisation. Relevant for port workforces with high union membership rates (e.g., International Longshoremens Association, maritime unions). Requires employee written authorisation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this payslip record was last modified in the data platform (e.g., following a payroll correction or reissue). RECORD_AUDIT_UPDATED category per TRANSACTION_HEADER role. Used for change tracking and data lineage.',
    `ytd_gross_pay` DECIMAL(18,2) COMMENT 'Cumulative gross pay earned by the employee from the start of the financial/tax year to the end of the current pay period. Required for annual tax reporting, payment summaries, and MLC wage record compliance.',
    `ytd_net_pay` DECIMAL(18,2) COMMENT 'Cumulative net pay disbursed to the employee from the start of the financial/tax year to the end of the current pay period. Supports annual earnings verification, MLC wage record compliance, and employee financial planning.',
    `ytd_tax_deduction` DECIMAL(18,2) COMMENT 'Cumulative income tax withheld from the employee from the start of the financial/tax year to the end of the current pay period. Required for annual tax reconciliation and payment summary generation.',
    CONSTRAINT pk_payslip PRIMARY KEY(`payslip_id`)
) COMMENT 'Individual employee payslip record for a given pay period including gross earnings, base pay, allowances (shift allowance, danger allowance, meal allowance), overtime pay, deductions (tax, pension, union dues), net pay, and year-to-date totals. Captures pay period, payment date, payment method, and bank account reference. Sourced from SAP HR Payroll (PY). SSOT for individual employee compensation records and MLC wage statement compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` (
    `competency_id` BIGINT COMMENT 'Unique surrogate identifier for each competency record in the master catalogue. Primary key for the competency data product.',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Competencies authorize operation of specific equipment types (crane operator, RTG driver). FK enables competency-equipment matching for deployment, certification tracking, workforce capability plannin',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Dangerous goods competencies are IMDG class-specific (Class 1 explosives, Class 2 gases). FK enables DG handling authorization, gang assignment validation for hazmat cargo, and IMDG Code compliance tr',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Competencies apply to vessel types (STCW endorsements, pilot licenses for specific vessel classes). FK enables crew qualification verification, pilot dispatch validation, and maritime training complia',
    `applicable_job_family` STRING COMMENT 'Port workforce job family or occupational group for which this competency is relevant (e.g., Marine Pilot, Stevedore, Equipment Operator, Port Security Officer, Harbour Master). Supports role-based competency gap analysis and workforce planning. [ENUM-REF-CANDIDATE: marine_pilot|stevedore|equipment_operator|port_security_officer|harbour_master|customs_officer|maintenance_technician|administrative — promote to reference product]',
    `approved_training_provider` STRING COMMENT 'Name of the approved training institution or provider authorised by the issuing authority to deliver training for this competency (e.g., Australian Maritime College, Port Authority Training Centre). Ensures workforce training is conducted through recognised providers.',
    `assessment_method` STRING COMMENT 'Primary method used to assess and award this competency. Determines the training and assessment pathway required for workforce members to obtain the qualification. [ENUM-REF-CANDIDATE: written_exam|practical_assessment|simulator|on_the_job|portfolio|medical_examination|observation|combined — 8 candidates stripped; promote to reference product]',
    `competency_category` STRING COMMENT 'Functional grouping of the competency for workforce planning and reporting purposes (e.g., Marine Operations, Container Handling Equipment, Security, Health and Safety, Trade Compliance, Leadership). [ENUM-REF-CANDIDATE: marine_operations|container_handling|security|health_safety|trade_compliance|leadership|environmental|administrative — promote to reference product]',
    `competency_code` STRING COMMENT 'Externally-known alphanumeric code uniquely identifying the competency within the port authority and Oracle HCM Cloud competency catalogue. Used for cross-system referencing and EDI exchanges.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `competency_status` STRING COMMENT 'Current lifecycle status of the competency record in the master catalogue. active indicates the competency is currently in use; superseded indicates it has been replaced by a newer version; draft indicates it is pending approval for inclusion.. Valid values are `active|inactive|superseded|draft|under_review`',
    `competency_type` STRING COMMENT 'Classification of the competency into its primary category: operational_licence (equipment or vessel operating licence), safety_certification (safety-related training certificate), regulatory_certificate (mandatory regulatory compliance certificate), trade_qualification (vocational or trade qualification), medical_certificate (seafarer or port worker medical fitness certificate).. Valid values are `operational_licence|safety_certification|regulatory_certificate|trade_qualification|medical_certificate`',
    `cost_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the cost_to_obtain amount (e.g., AUD, USD, SGD). Supports multi-currency port operations and SAP FI financial reporting.. Valid values are `^[A-Z]{3}$`',
    `cost_to_obtain` DECIMAL(18,2) COMMENT 'Standard cost (in local currency) for a workforce member to obtain this competency through the approved training and assessment pathway. Used for workforce training budget planning and OPEX forecasting in SAP CO.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this competency record was first created in the master catalogue. Supports data lineage, audit trail, and Oracle HCM Cloud synchronisation tracking.',
    `competency_description` STRING COMMENT 'Detailed narrative description of the competency, including the knowledge, skills, and abilities it certifies, the scope of work it authorises, and any specific conditions or limitations on its application in port operations.',
    `digital_certificate_supported` BOOLEAN COMMENT 'Indicates whether the issuing authority supports digital or electronic certificates for this competency, enabling integration with port access control systems and ISPS security checks via RFID or digital verification.',
    `effective_from_date` DATE COMMENT 'Date from which this competency definition became or becomes effective in the master catalogue. Used to manage competency version transitions and ensure workforce records reference the correct version.',
    `effective_to_date` DATE COMMENT 'Date on which this competency definition ceases to be effective (nullable for open-ended active competencies). When populated, indicates the competency has been superseded or retired from the catalogue.',
    `external_reference_number` STRING COMMENT 'Official reference number or code assigned by the issuing authority (e.g., IMO Model Course number, STCW regulation reference such as STCW Reg VI/1, national certificate code). Enables direct cross-referencing with regulatory documentation.',
    `imo_model_course_number` STRING COMMENT 'IMO Model Course number associated with the training programme for this competency (e.g., 1.21 for Personal Safety and Social Responsibilities, 3.12 for Ship Security Officer). Used to align port training programmes with IMO-approved curricula.. Valid values are `^[0-9]{1,2}.[0-9]{2}$`',
    `is_mandatory_isps` BOOLEAN COMMENT 'Indicates whether this competency is mandatory under the ISPS Code for port facility security personnel, Port Facility Security Officers (PFSOs), and security-designated roles.',
    `is_mandatory_mlc` BOOLEAN COMMENT 'Indicates whether this competency is mandatory under the ILO Maritime Labour Convention (MLC 2006) for seafarers and port workers covered by the conventions scope.',
    `is_mandatory_stcw` BOOLEAN COMMENT 'Indicates whether this competency is mandatory under the IMO Standards of Training, Certification and Watchkeeping (STCW) Convention. True for all STCW-mandated certificates required for seafarers and port workers with shipboard duties.',
    `is_renewable` BOOLEAN COMMENT 'Indicates whether the competency requires periodic renewal upon expiry. True for time-limited certificates (e.g., STCW refresher, medical fitness); False for lifetime qualifications (e.g., trade certificates).',
    `issuing_authority_name` STRING COMMENT 'Name of the body responsible for issuing or recognising this competency (e.g., International Maritime Organization (IMO), Australian Maritime Safety Authority (AMSA), Port Authority, National Maritime Safety Authority). Determines the regulatory weight and mutual recognition applicability.',
    `issuing_authority_type` STRING COMMENT 'Classification of the issuing authority to support regulatory hierarchy and mutual recognition logic. imo for IMO-mandated certificates, national_maritime_authority for flag/port state certificates, port_authority for port-specific licences, industry_body for industry association qualifications, vocational_body for trade/vocational qualifications, internal for port-issued internal certifications.. Valid values are `imo|national_maritime_authority|port_authority|industry_body|vocational_body|internal`',
    `issuing_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction under which the competency is issued or recognised (e.g., AUS, SGP, GBR). Used for Port State Control (PSC) compliance checks and mutual recognition assessments.. Valid values are `^[A-Z]{3}$`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this competency record was most recently modified in the master catalogue. Used for change data capture (CDC) in the Databricks Silver Layer ingestion pipeline and audit compliance.',
    `level_descriptor` STRING COMMENT 'STCW-aligned functional level descriptor indicating the operational tier at which this competency applies: management_level (officer in charge), operational_level (watchkeeping officer), support_level (rating), awareness_level (general port worker). Aligns with STCW Table A-II/1 through A-VI/6.. Valid values are `management_level|operational_level|support_level|awareness_level`',
    `medical_standard_ref` STRING COMMENT 'Reference to the applicable medical fitness standard required for this competency (e.g., ILO/IMO Guidelines on Medical Examinations, ENG1 Medical Standard, ML5 Medical Standard). Applicable to competencies with a medical fitness prerequisite under MLC 2006.',
    `minimum_proficiency_level` STRING COMMENT 'The minimum proficiency level required for a workforce member to be considered competent for role assignment. Expressed in terms of the competencys proficiency scale (e.g., 3 for a 1-5 scale, working for a maturity scale, pass for pass/fail).',
    `mutual_recognition_flag` BOOLEAN COMMENT 'Indicates whether this competency is subject to international mutual recognition agreements between maritime administrations, allowing certificates issued in one jurisdiction to be accepted in another without re-examination.',
    `competency_name` STRING COMMENT 'Full human-readable name of the competency, qualification, or certification as recognised by the issuing authority (e.g., Basic Safety Training, ISPS Port Facility Security Officer, Quay Crane Operator Licence).',
    `prerequisite_competency_codes` STRING COMMENT 'Comma-separated list of competency codes that must be held by a workforce member before they can undertake training or assessment for this competency. Supports competency pathway sequencing in Oracle HCM Cloud learning plans.',
    `proficiency_scale` STRING COMMENT 'Proficiency measurement scale applied to this competency. pass_fail for binary certification outcomes; level_1_5 for graded proficiency levels; awareness, working, practitioner, expert for capability maturity levels used in Oracle HCM Cloud competency profiles.. Valid values are `pass_fail|level_1_5|awareness|working|practitioner|expert`',
    `psc_recognised` BOOLEAN COMMENT 'Indicates whether this competency certificate is recognised and accepted by Port State Control (PSC) authorities during vessel and port facility inspections. Critical for compliance with PSC detention avoidance.',
    `regulatory_framework` STRING COMMENT 'Primary regulatory or compliance framework under which this competency is mandated or recognised. STCW (Standards of Training, Certification and Watchkeeping), ISPS (International Ship and Port Facility Security), MLC (Maritime Labour Convention), SOLAS (Safety of Life at Sea), MARPOL (Marine Pollution Convention), IMDG (International Maritime Dangerous Goods Code), ISO standards, national legislation, or internal port policy. [ENUM-REF-CANDIDATE: stcw|isps|mlc|solas|marpol|imdg|iso_45001|iso_14001|national|internal — 10 candidates stripped; promote to reference product]',
    `renewal_notice_days` STRING COMMENT 'Number of days before expiry that a renewal notification should be triggered for workforce planning and compliance management. Enables proactive scheduling of refresher training or re-certification before the competency lapses.',
    `renewal_requirements` STRING COMMENT 'Textual description of the conditions and prerequisites required to renew this competency, including refresher training hours, re-examination requirements, sea service evidence, or medical fitness re-assessment as mandated by the issuing authority.',
    `revalidation_sea_service_days` STRING COMMENT 'Minimum number of days of approved sea service or port operational service required as evidence for revalidation of this competency under STCW or national maritime authority requirements.',
    `source_system_code` STRING COMMENT 'Identifies the operational system of record from which this competency definition was sourced (e.g., oracle_hcm for Oracle HCM Cloud, sap_hr for SAP S/4HANA HR module, manual for port authority-defined competencies not originating from a system).. Valid values are `oracle_hcm|sap_hr|manual|navis_n4`',
    `stcw_regulation_ref` STRING COMMENT 'Specific STCW Convention regulation reference applicable to this competency (e.g., Regulation II/1, Regulation VI/1). Populated only for STCW-mandated competencies to support PSC inspection compliance documentation.',
    `training_duration_hours` DECIMAL(18,2) COMMENT 'Minimum number of training hours required to attain this competency, as specified by the issuing authority or port training standards. Used for workforce training planning, scheduling, and cost estimation.',
    `validity_period_months` STRING COMMENT 'Duration in months for which the competency certificate or qualification remains valid from the date of issue before renewal is required. Null or zero indicates the competency does not expire (e.g., trade qualifications). Used to calculate expiry dates on employee certification records.',
    `version` STRING COMMENT 'Version number of the competency definition, incremented when the competency requirements, assessment criteria, or regulatory basis are updated. Supports version-controlled competency management and audit trails.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_competency PRIMARY KEY(`competency_id`)
) COMMENT 'Master catalogue of competencies, qualifications, and certifications required for port workforce roles. Includes competency code, competency name, competency type (operational licence, safety certification, regulatory certificate, trade qualification), issuing authority (IMO, national maritime authority, port authority), validity period in months, renewal requirements, and whether the competency is mandatory under STCW, ISPS, or MLC. Reference entity used by employee certification and training records.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` (
    `employee_certification_id` BIGINT COMMENT 'Unique identifier for the employee certification record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Pilots and terminal operators require berth-specific qualifications for LOA/draft/cargo type restrictions. Tracks which employees are certified to work at which berths; critical for safe vessel operat',
    `competency_id` BIGINT COMMENT 'Standardized code identifying the specific competency, qualification, licence, or certification type from the master competency catalogue.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who holds this certification. Links to the employee master record.',
    `assessment_result` STRING COMMENT 'Qualitative outcome of the certification assessment: pass, fail, distinction, credit, competent, or not yet competent.. Valid values are `pass|fail|distinction|credit|competent|not_yet_competent`',
    `assessment_score` DECIMAL(18,2) COMMENT 'Numerical score or grade achieved in the certification assessment or examination (e.g., percentage, grade point). Null if not applicable.',
    `authorised_vessel_types` STRING COMMENT 'Comma-separated list of vessel types the pilot is authorised to handle (e.g., container, tanker, bulk carrier, RoRo, cruise). Null for non-pilot certifications.',
    `certificate_number` STRING COMMENT 'Unique certificate or licence number issued by the certifying authority. Used for verification and audit purposes.. Valid values are `^[A-Z0-9-/]{6,30}$`',
    `certification_name` STRING COMMENT 'Full descriptive name of the certification, qualification, or licence (e.g., STCW Basic Safety Training, Quay Crane Operator Licence Class A, IMDG Dangerous Goods Handling).',
    `certification_status` STRING COMMENT 'Current lifecycle status of the certification: valid (active and current), expired (past expiry date), suspended (temporarily invalid), pending renewal (in renewal process), revoked (permanently cancelled), or pending verification (awaiting authority confirmation).. Valid values are `valid|expired|suspended|pending_renewal|revoked|pending_verification`',
    `certification_type` STRING COMMENT 'Classification of the certification into operational licence, safety certification, regulatory certificate, trade qualification, medical fitness, or security clearance.. Valid values are `operational_licence|safety_certification|regulatory_certificate|trade_qualification|medical_fitness|security_clearance`',
    `comments` STRING COMMENT 'Free-text field for additional notes, special conditions, or contextual information about this certification record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was first created in the system.',
    `deployment_eligible_flag` BOOLEAN COMMENT 'Indicates whether the employee is currently eligible for deployment to roles requiring this certification, based on certification status and validity. True if eligible.',
    `document_reference` STRING COMMENT 'Reference identifier or file path to the scanned certificate document stored in the document management system.',
    `examining_physician_name` STRING COMMENT 'Name of the medical practitioner who conducted the fitness examination. Confidential. Null for non-medical certifications.',
    `expiry_date` DATE COMMENT 'Date on which the certification, qualification, or licence expires and is no longer valid. Null for certifications with no expiry.',
    `fitness_outcome` STRING COMMENT 'Result of the medical fitness assessment: fit for duty (no restrictions), fit with restrictions (conditional fitness), temporarily unfit (short-term limitation), or permanently unfit (cannot perform role). Confidential. Null for non-medical certifications.. Valid values are `fit_for_duty|fit_with_restrictions|temporarily_unfit|permanently_unfit`',
    `fitness_restrictions` STRING COMMENT 'Description of any work restrictions or limitations imposed by the medical assessment (e.g., no night shifts, no heavy lifting, hearing protection required). Confidential. Null if no restrictions or non-medical certification.',
    `isps_compliant_flag` BOOLEAN COMMENT 'Indicates whether this certification meets ISPS Code security requirements. True if ISPS-compliant.',
    `issue_date` DATE COMMENT 'Date on which the certification, qualification, or licence was originally issued to the employee.',
    `issuing_authority` STRING COMMENT 'Name of the organization or body that issued the certification (e.g., IMO, National Maritime Authority, Port Authority, Accredited Training Provider).',
    `issuing_authority_code` STRING COMMENT 'Standardized code identifying the issuing authority for system integration and reporting purposes.. Valid values are `^[A-Z0-9]{2,10}$`',
    `last_renewal_date` DATE COMMENT 'Date of the most recent renewal or revalidation of this certification. Null if never renewed.',
    `mandatory_flag` BOOLEAN COMMENT 'Indicates whether this certification is mandatory for the employees current role and deployment eligibility. True if required, False if optional or supplementary.',
    `maximum_dwt_tonnes` DECIMAL(18,2) COMMENT 'Maximum vessel deadweight tonnage (DWT) in tonnes that the pilot is authorised to handle. Null for non-pilot certifications.',
    `maximum_loa_metres` DECIMAL(18,2) COMMENT 'Maximum vessel length overall (LOA) in metres that the pilot is authorised to handle. Null for non-pilot certifications.',
    `medical_examination_date` DATE COMMENT 'Date of the most recent medical fitness examination. Null for non-medical certifications.',
    `medical_fitness_standard` STRING COMMENT 'The medical fitness standard or protocol applied for this medical certification (e.g., MLC ENG1 for seafarers, ISO 45001 OHS, national occupational health standard). Null for non-medical certifications.. Valid values are `MLC_ENG1|ISO_45001|national_OHS|port_authority_standard`',
    `mlc_compliant_flag` BOOLEAN COMMENT 'Indicates whether this certification meets ILO Maritime Labour Convention 2006 requirements. True if MLC-compliant.',
    `next_medical_due_date` DATE COMMENT 'Date by which the next medical fitness examination is required. Null for non-medical certifications.',
    `next_renewal_due_date` DATE COMMENT 'Date by which the certification must be renewed to maintain continuous validity. Used for proactive renewal scheduling.',
    `pilot_licence_class` STRING COMMENT 'Classification of marine pilot licence (e.g., Class A, Class B, Class 1, Class 2) indicating the level of pilotage authority. Null for non-pilot certifications.. Valid values are `^[A-Z0-9]{1,5}$`',
    `pilotage_area_code` STRING COMMENT 'Code identifying the specific port area or waterway the pilot is authorised to operate in. Null for non-pilot certifications.. Valid values are `^[A-Z0-9]{2,10}$`',
    `renewal_notification_date` DATE COMMENT 'Date on which the renewal reminder notification was sent to the employee. Null if not yet sent.',
    `renewal_notification_sent_flag` BOOLEAN COMMENT 'Indicates whether a renewal reminder notification has been sent to the employee for this certification. True if notification sent.',
    `stcw_compliant_flag` BOOLEAN COMMENT 'Indicates whether this certification meets IMO STCW Convention requirements for seafarers and marine personnel. True if STCW-compliant.',
    `training_completion_date` DATE COMMENT 'Date on which the employee completed the training course or assessment leading to this certification.',
    `training_provider` STRING COMMENT 'Name of the accredited training organization or institution that delivered the training leading to this certification.',
    `updated_by` STRING COMMENT 'Identifier of the user or system process that last updated this certification record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was last modified in the system.',
    `verification_date` DATE COMMENT 'Date on which the certification was last verified with the issuing authority. Critical for PSC inspection readiness.',
    `verification_status` STRING COMMENT 'Status of third-party verification with the issuing authority: verified (confirmed authentic), unverified (not yet checked), verification failed (could not confirm), or verification pending (check in progress).. Valid values are `verified|unverified|verification_failed|verification_pending`',
    `verified_by` STRING COMMENT 'Name or identifier of the person or system that performed the verification check.',
    CONSTRAINT pk_employee_certification PRIMARY KEY(`employee_certification_id`)
) COMMENT 'Comprehensive certification, competency, and licence management for all port workforce personnel. Includes: (1) Master competency catalogue — all qualifications, licences, and certifications required for port roles with competency codes, types (operational licence, safety certification, regulatory certificate, trade qualification, medical fitness), issuing authorities (IMO, national maritime authority, port authority), validity periods, renewal requirements, and mandatory flags (STCW, ISPS, MLC). (2) Individual employee certification records — certificate number, issuing authority, issue date, expiry date, status (valid, expired, suspended, pending renewal), verification status, and document reference. (3) Marine pilot licences — licence class, authorised vessel types, maximum LOA/DWT limits, port-specific pilotage authorisation area. (4) Medical fitness records — examination date, examining physician, fitness standard (MLC ENG1, national OHS), fitness outcome, restrictions, next examination due, confidentiality classification. Covers STCW certificates, crane operator licences, dangerous goods (IMDG) handling, ISPS security awareness, first aid, and all regulatory certifications. Critical for deployment eligibility, VTS/pilotage scheduling, PSC inspection readiness, and OHS compliance. SSOT for all workforce competency, certification, and licence data.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` (
    `training_course_id` BIGINT COMMENT 'Unique identifier for the training course record. Primary key for the training course entity.',
    `competency_id` BIGINT COMMENT 'Code of the workforce competency that this training course develops or renews. Successful completion of the course contributes to the employees competency profile and certification status.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee responsible for the design, maintenance, and quality assurance of the training course content. Typically a training manager or subject matter expert.',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Training courses certify equipment operation (STS crane course, RTG operator training). FK enables training program management, competency gap analysis, equipment-specific certification tracking, and ',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: DG training is IMDG class-specific (Class 1 explosives handling, Class 7 radioactive materials). FK enables regulatory compliance tracking per IMDG Code requirements, competency verification for hazma',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Training courses are delivered at specific facilities within port infrastructure (training center, simulator facility). FK supports training logistics, venue scheduling, location-based training record',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Training venues often use port warehouses for practical cargo handling and IMDG training. Tracks facility utilization, scheduling conflicts, and logistics. Removes denormalized default_venue_name.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Training courses cover vessel-specific operations (container vessel handling, tanker operations). FK supports maritime training compliance (STCW requirements by vessel type), crew development, and pil',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether employee enrolment in this course requires manager or department head approval before registration is confirmed. True if approval is required; false if enrolment is open.',
    `assessment_method` STRING COMMENT 'Method used to assess participant competency and determine course completion: written exam, practical test, on-the-job observation, simulator assessment, project submission, or none if no formal assessment is required.. Valid values are `written_exam|practical_test|observation|simulation|project|none`',
    `certificate_validity_months` STRING COMMENT 'Number of months that the certificate issued upon course completion remains valid before renewal or recertification is required. Null if the certificate does not expire or if no certificate is issued.',
    `certification_issued_flag` BOOLEAN COMMENT 'Indicates whether successful completion of this course results in the issuance of a formal certificate or credential. True if a certificate is issued; false if only a completion record is maintained.',
    `compliance_framework` STRING COMMENT 'The regulatory or safety framework that mandates this training course: MLC (Maritime Labour Convention), ISPS (International Ship and Port Facility Security), SOLAS (Safety of Life at Sea), OHS (Occupational Health and Safety), IMDG (International Maritime Dangerous Goods), PSC (Port State Control), or none for non-mandatory courses. [ENUM-REF-CANDIDATE: MLC|ISPS|SOLAS|OHS|IMDG|PSC|none — 7 candidates stripped; promote to reference product]',
    `course_code` STRING COMMENT 'Unique business identifier for the training course in the learning management system catalogue. Used for course registration and scheduling.. Valid values are `^[A-Z0-9]{4,12}$`',
    `course_cost_amount` DECIMAL(18,2) COMMENT 'Total cost per participant for delivering the training course, including instructor fees, materials, venue rental, and equipment usage. Used for training budget planning and cost allocation.',
    `course_language` STRING COMMENT 'Primary language in which the training course is delivered, using ISO 639-2 three-letter language codes (e.g., ENG for English, SPA for Spanish, FRA for French).. Valid values are `^[A-Z]{3}$`',
    `course_materials_provided_flag` BOOLEAN COMMENT 'Indicates whether training materials (manuals, handouts, digital resources) are provided to participants as part of the course. True if materials are provided; false if participants must source their own materials.',
    `course_objectives` STRING COMMENT 'Detailed description of the learning objectives and outcomes that participants will achieve upon successful completion of the training course.',
    `course_status` STRING COMMENT 'Current lifecycle status of the training course in the catalogue. Active courses are available for enrolment; inactive courses are temporarily unavailable; under review courses are being updated; retired courses are no longer offered; draft courses are in development.. Valid values are `active|inactive|under_review|retired|draft`',
    `course_title` STRING COMMENT 'Full descriptive title of the training course as displayed in the learning catalogue and on certificates.',
    `course_type` STRING COMMENT 'Classification of the training course by its primary purpose: induction (new hire orientation), safety (OHS and emergency response), technical (equipment and operational skills), leadership (management development), regulatory (MLC, ISPS, SOLAS), or compliance (mandatory certifications).. Valid values are `induction|safety|technical|leadership|regulatory|compliance`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the training course record was first created in the learning management system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the course cost amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `delivery_mode` STRING COMMENT 'Method by which the training course is delivered: classroom (instructor-led in-person), e-learning (online self-paced), on-the-job (practical workplace training), simulator (equipment or vessel simulator), or blended (combination of methods).. Valid values are `classroom|e-learning|on-the-job|simulator|blended`',
    `duration_hours` DECIMAL(18,2) COMMENT 'Total duration of the training course measured in hours, including instruction time, practical exercises, and assessments. Used for scheduling and resource planning.',
    `effective_end_date` DATE COMMENT 'Date after which the training course is no longer available for new enrolments or scheduling. Null if the course has no planned end date and remains active indefinitely.',
    `effective_start_date` DATE COMMENT 'Date from which the training course becomes available in the learning catalogue and can be scheduled for delivery. Courses cannot be scheduled before this date.',
    `last_review_date` DATE COMMENT 'Date when the training course content and objectives were last reviewed and validated for accuracy, relevance, and compliance with current regulations and operational requirements.',
    `mandatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the training course is mandatory for regulatory compliance (MLC, ISPS, SOLAS, OHS) or operational certification. True if the course is required by law or port policy; false if the course is optional or developmental.',
    `maximum_enrolment` STRING COMMENT 'Maximum number of participants that can be enrolled in a single delivery session of the course, constrained by venue capacity, instructor ratio, or equipment availability.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next review and update of the training course content to ensure continued relevance and compliance.',
    `passing_score_percentage` DECIMAL(18,2) COMMENT 'Minimum score percentage required to pass the course assessment and achieve completion status. Null if no formal assessment or passing threshold is defined.',
    `provider_name` STRING COMMENT 'Name of the organization or department providing the training course. For internal courses, this is the port department; for external courses, this is the vendor or training institution name.',
    `provider_type` STRING COMMENT 'Classification of the training provider: internal (delivered by port staff), external (third-party training organization), vendor (equipment manufacturer training), or industry_body (IAPH, IMO, or maritime association).. Valid values are `internal|external|vendor|industry_body`',
    `refresher_course_flag` BOOLEAN COMMENT 'Indicates whether this course is a refresher or recertification course designed to renew an existing competency or certification. True if this is a refresher course; false if this is initial training.',
    `target_audience` STRING COMMENT 'Description of the intended audience for the training course, such as job roles, departments, or employee categories (e.g., stevedore gangs, equipment operators, marine pilots, security personnel, administrative staff).',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when the training course record was last modified, including changes to course details, status, or configuration.',
    `venue_type` STRING COMMENT 'Type of location where the training course is delivered: on-site (port training facility), off-site (external training center), online (virtual platform), field (operational work area), or simulator facility (equipment or vessel simulator).. Valid values are `on_site|off_site|online|field|simulator_facility`',
    CONSTRAINT pk_training_course PRIMARY KEY(`training_course_id`)
) COMMENT 'Training course catalogue and employee enrolment records covering the full training lifecycle. Catalogue level: course code, title, type (induction, safety, technical, leadership, regulatory), delivery mode (classroom, e-learning, on-the-job, simulator), duration, maximum enrolment, provider (internal or external), linked competency, mandatory compliance flag (MLC, ISPS, OHS), and course status. Enrolment level: individual employee enrolment date, scheduled training date, completion date, assessment result (pass, fail, incomplete), score, trainer/facilitator, venue/platform, and whether the training satisfies a mandatory compliance requirement. Successful completion feeds employee certification records for competency renewal. Sourced from Oracle HCM Cloud Learning Management. SSOT for all workforce training catalogue and development activity.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` (
    `training_enrolment_id` BIGINT COMMENT 'Unique identifier for the training enrolment record. Primary key.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee who approved this training enrolment request. Typically the direct manager or training coordinator.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Training enrolment is associated with an organizational unit (department). Currently denormalized with department_code. Adding org_unit_id FK enables proper normalization.',
    `position_id` BIGINT COMMENT 'Code representing the employees job role at the time of enrolment, such as stevedore, equipment operator, marine pilot, or security personnel. Used to track role-specific training requirements.',
    `primary_training_employee_id` BIGINT COMMENT 'Unique identifier of the employee enrolled in the training course. Links to the employee master record.',
    `training_course_id` BIGINT COMMENT 'Unique identifier of the training course in which the employee is enrolled. Links to the training course catalog.',
    `actual_start_date` DATE COMMENT 'Actual date on which the employee commenced participation in the training course. May differ from scheduled start date due to deferrals or late joins.',
    `approval_date` DATE COMMENT 'Date on which the training enrolment request was approved by the designated approver.',
    `assessment_result` STRING COMMENT 'Final assessment outcome indicating whether the employee passed, failed, or has an incomplete assessment for the training course.. Valid values are `pass|fail|incomplete|not_assessed|pending`',
    `assessment_score` DECIMAL(18,2) COMMENT 'Numeric score achieved by the employee in the training course assessment, typically expressed as a percentage or points out of maximum possible score.',
    `attendance_percentage` DECIMAL(18,2) COMMENT 'Percentage of scheduled training sessions or hours that the employee attended. Used to determine eligibility for assessment and completion.',
    `certification_expiry_date` DATE COMMENT 'Date on which the certification issued for this training enrolment expires and requires renewal. Null for certifications without expiry.',
    `certification_issued_flag` BOOLEAN COMMENT 'Indicates whether a formal certification or credential was issued to the employee upon successful completion of this training enrolment.',
    `certification_number` STRING COMMENT 'Unique reference number of the certification or credential issued upon successful completion of the training course. Null if no certification was issued.',
    `competency_code` STRING COMMENT 'Code representing the specific competency or skill area that this training enrolment is designed to develop or certify, aligned with the port workforce competency framework.',
    `completion_date` DATE COMMENT 'Date on which the employee successfully completed all requirements of the training course. Null if training is not yet completed.',
    `cost_centre_code` STRING COMMENT 'Financial cost centre code to which the training costs for this enrolment are allocated. Used for budgeting and financial reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this training enrolment record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the training cost amount is denominated.. Valid values are `^[A-Z]{3}$`',
    `employee_comments` STRING COMMENT 'Free-text comments or notes provided by the employee regarding their training enrolment, learning objectives, or feedback.',
    `enrolment_date` DATE COMMENT 'Date on which the employee was officially enrolled in the training course. Represents the business event timestamp for enrolment initiation.',
    `enrolment_number` STRING COMMENT 'Business-facing unique enrolment reference number generated by the Learning Management System for tracking and reporting purposes.',
    `enrolment_source` STRING COMMENT 'Origin or trigger that initiated this training enrolment, such as employee self-service request, manager nomination, mandatory compliance requirement, or talent development program.. Valid values are `employee_request|manager_nomination|mandatory_compliance|talent_development|succession_planning|performance_improvement`',
    `enrolment_status` STRING COMMENT 'Current lifecycle status of the training enrolment indicating whether the employee is enrolled, actively participating, has completed, withdrawn, or failed the course. [ENUM-REF-CANDIDATE: enrolled|in_progress|completed|withdrawn|failed|deferred|cancelled — 7 candidates stripped; promote to reference product]',
    `isps_compliant` BOOLEAN COMMENT 'Indicates whether this training enrolment satisfies International Ship and Port Facility Security Code requirements for security awareness and training.',
    `mandatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this training enrolment satisfies a mandatory compliance requirement such as Maritime Labour Convention (MLC), International Ship and Port Facility Security (ISPS), or Occupational Health and Safety (OHS) regulations.',
    `mlc_compliant` BOOLEAN COMMENT 'Indicates whether this training enrolment meets the requirements of the Maritime Labour Convention for seafarer and port worker training and certification.',
    `passing_score_threshold` DECIMAL(18,2) COMMENT 'Minimum score required to achieve a pass result for this training course enrolment. Used to determine pass/fail outcome.',
    `recertification_required_flag` BOOLEAN COMMENT 'Indicates whether this training course requires periodic recertification or refresher training to maintain competency and compliance.',
    `scheduled_end_date` DATE COMMENT 'Planned date on which the training course is scheduled to conclude for this enrolment.',
    `scheduled_start_date` DATE COMMENT 'Planned date on which the training course is scheduled to commence for this enrolment.',
    `source_system_code` STRING COMMENT 'Unique identifier of this training enrolment record in the source operational system. Used for data reconciliation and lineage tracking.',
    `terminal_code` STRING COMMENT 'Code representing the port terminal or facility where the employee is assigned and where the training may be relevant. Used for location-based training compliance reporting.',
    `trainer_feedback` STRING COMMENT 'Free-text feedback provided by the trainer or facilitator regarding the employees performance, participation, and areas for improvement during the training.',
    `training_cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred for this training enrolment, including course fees, materials, trainer costs, and venue expenses.',
    `training_delivery_method` STRING COMMENT 'Method by which the training course was delivered to the employee, such as classroom-based, online e-learning, blended learning, or on-the-job training.. Valid values are `classroom|online|blended|on_the_job|workshop|webinar`',
    `training_hours` DECIMAL(18,2) COMMENT 'Total number of hours the employee spent in training activities for this enrolment, including classroom time, online modules, and assessments.',
    `training_platform` STRING COMMENT 'Name of the digital learning platform or system used to deliver online or blended training content (e.g., Oracle Learn, Moodle, Cornerstone).',
    `training_venue` STRING COMMENT 'Physical location or facility where the training was conducted. For online training, may indicate the platform or virtual environment used.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this training enrolment record was last modified in the system. Used for audit trail and change tracking.',
    `withdrawal_date` DATE COMMENT 'Date on which the employee withdrew from the training course prior to completion. Null if not withdrawn.',
    `withdrawal_reason` STRING COMMENT 'Explanation or reason code for why the employee withdrew from the training course prior to completion. Null if not withdrawn.',
    CONSTRAINT pk_training_enrolment PRIMARY KEY(`training_enrolment_id`)
) COMMENT 'Transactional record of an employees enrolment in and completion of a training course. Captures enrolment date, scheduled training date, completion date, assessment result (pass, fail, incomplete), score, trainer or facilitator, training venue or platform, and whether the training satisfies a mandatory compliance requirement. Feeds employee certification records upon successful completion. Sourced from Oracle HCM Cloud Learning Management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` (
    `performance_review_id` BIGINT COMMENT 'Primary key for performance_review',
    `calibration_session_id` BIGINT COMMENT 'Identifier of the calibration session where this performance review was discussed and validated with peer managers to ensure rating consistency and fairness across the organization.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Performance review is associated with an organizational unit (department). Currently denormalized with department_code. Adding org_unit_id FK enables proper normalization.',
    `position_id` BIGINT COMMENT 'Code representing the employees job role at the time of the performance review. Captures the position being evaluated, important for role-specific performance standards and competency frameworks.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee being reviewed. Links to the employee master record in Oracle HCM Cloud.',
    `reviewer_employee_id` BIGINT COMMENT 'Unique identifier of the employee conducting the performance review, typically the direct supervisor or manager.',
    `acknowledgement_status` STRING COMMENT 'Status of the employees acknowledgement of the performance review. Pending indicates the employee has not yet reviewed, acknowledged indicates acceptance, disputed indicates disagreement requiring resolution, and escalated indicates formal dispute process initiated.. Valid values are `pending|acknowledged|disputed|escalated`',
    `acknowledgement_timestamp` TIMESTAMP COMMENT 'The date and time when the employee formally acknowledged receipt and review of their performance assessment. Records when the employee confirmed they have read and understood the review.',
    `bonus_eligibility_flag` BOOLEAN COMMENT 'Indicator of whether the employee is eligible for performance-based bonus or incentive payment based on review outcome. True indicates eligibility for variable compensation. Classified as confidential business information.',
    `compensation_adjustment_percentage` DECIMAL(18,2) COMMENT 'Recommended percentage increase in base compensation based on performance review outcome. Used for merit increase planning and budget allocation. Classified as confidential business information.',
    `compensation_adjustment_recommended` BOOLEAN COMMENT 'Indicator of whether a salary increase, bonus, or other compensation adjustment is recommended based on performance. True indicates a compensation change is recommended. Classified as confidential business information.',
    `competency_rating` STRING COMMENT 'Assessment of the employees demonstration of core competencies required for their role, including technical skills, behavioral competencies, and role-specific capabilities. Evaluates how well the employee applies required knowledge and skills in their work.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding`',
    `cost_centre_code` STRING COMMENT 'Financial cost center code associated with the employees assignment during the review period. Links performance data to financial reporting structures.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this performance review record was first created in the system. Audit field tracking initial record creation.',
    `development_plan_summary` STRING COMMENT 'Summary of the agreed-upon development plan for the employee, including training needs, skill development objectives, career progression goals, and specific actions to address performance gaps or enhance capabilities.',
    `dispute_reason` STRING COMMENT 'Explanation provided by the employee if they dispute the performance review ratings or feedback. Documents the basis for disagreement and triggers formal review or appeal process.',
    `employee_comments` STRING COMMENT 'Additional comments or feedback provided by the employee in response to the performance review. May include agreement, clarification, or concerns regarding the assessment.',
    `employee_self_assessment` STRING COMMENT 'The employees own evaluation of their performance during the review period, including accomplishments, challenges, and self-identified development needs. Provides employee perspective and promotes self-reflection.',
    `goal_achievement_rating` STRING COMMENT 'Assessment of the employees success in achieving individual goals and objectives set at the beginning of the review period. Measures performance against specific, measurable targets aligned with business objectives.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding`',
    `high_potential_flag` BOOLEAN COMMENT 'Indicator of whether the employee is identified as high-potential talent with capability for significant future contribution and advancement. True indicates high-potential status for succession planning and talent development programs.',
    `leadership_rating` STRING COMMENT 'Assessment of the employees leadership capabilities, including team management, decision-making, mentoring, and influence. Not applicable for non-supervisory roles. Evaluates ability to guide, motivate, and develop others.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding|not_applicable`',
    `mlc_compliance_rating` STRING COMMENT 'Assessment of the employees adherence to Maritime Labour Convention standards, including rest hours, working conditions, and seafarer rights. Applicable primarily to marine pilots, stevedore gangs, and vessel operations personnel. Ensures compliance with international maritime labor standards.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding|not_applicable`',
    `next_review_due_date` DATE COMMENT 'The scheduled date for the next performance review. Ensures timely and consistent performance management cycles.',
    `operational_efficiency_rating` STRING COMMENT 'Assessment of the employees contribution to operational efficiency, including productivity, quality of work, resource utilization, and process improvement. Measures effectiveness in executing core job responsibilities and contributing to terminal operations performance.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding`',
    `oracle_hcm_review_code` STRING COMMENT 'The unique identifier for this performance review record in the source Oracle HCM Cloud Performance Management system. Enables traceability and reconciliation with the system of record.',
    `overall_performance_rating` STRING COMMENT 'The comprehensive performance rating assigned to the employee for the review period. Outstanding indicates exceptional performance beyond all expectations, exceeds expectations indicates performance above standard requirements, meets expectations indicates satisfactory performance meeting all requirements, needs improvement indicates performance below standards requiring development, and unsatisfactory indicates performance significantly below acceptable levels.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding`',
    `overall_rating_score` DECIMAL(18,2) COMMENT 'Numerical score representing the overall performance rating, typically on a scale such as 1.0 to 5.0. Enables quantitative analysis and comparison of performance across employees and time periods.',
    `pay_grade_code` STRING COMMENT 'Code representing the employees pay grade or salary band at the time of review. Used for compensation planning and promotion decisions. Classified as confidential business information.',
    `performance_improvement_plan_flag` BOOLEAN COMMENT 'Indicator of whether the employee has been placed on a formal Performance Improvement Plan due to unsatisfactory performance. True indicates active PIP status requiring structured improvement actions and monitoring.',
    `promotion_readiness_flag` BOOLEAN COMMENT 'Indicator of whether the employee is considered ready for promotion to a higher role or responsibility level based on current performance and demonstrated capabilities. True indicates readiness for advancement, false indicates not yet ready.',
    `review_completion_date` DATE COMMENT 'The date when the performance review was finalized and completed by the reviewer. Represents the official completion of the assessment process.',
    `review_number` STRING COMMENT 'Business identifier for the performance review, typically generated by Oracle HCM Cloud Performance Management module. Used for tracking and reference purposes.',
    `review_period_end_date` DATE COMMENT 'The ending date of the performance period being evaluated. Defines the conclusion of the timeframe for which employee performance is assessed.',
    `review_period_start_date` DATE COMMENT 'The beginning date of the performance period being evaluated. Defines the start of the timeframe for which employee performance is assessed.',
    `review_status` STRING COMMENT 'Current lifecycle state of the performance review. Draft indicates the review is being prepared, submitted means it has been sent to the employee, under review indicates active discussion, completed means finalized by reviewer, acknowledged means employee has accepted, disputed indicates employee disagreement, and archived means the review is closed and stored for historical reference. [ENUM-REF-CANDIDATE: draft|submitted|under_review|completed|acknowledged|disputed|archived — 7 candidates stripped; promote to reference product]',
    `review_type` STRING COMMENT 'Classification of the performance review based on its purpose and timing. Annual reviews are comprehensive yearly assessments, mid-year reviews are interim checkpoints, probationary reviews assess new hires, post-incident reviews follow safety or operational incidents, project completion reviews assess performance on specific assignments, and promotion reviews support advancement decisions.. Valid values are `annual|mid_year|probationary|post_incident|project_completion|promotion`',
    `reviewer_comments` STRING COMMENT 'Detailed narrative feedback provided by the reviewer summarizing the employees performance, strengths, areas for improvement, and specific examples supporting the ratings. Provides qualitative context for quantitative ratings.',
    `safety_compliance_rating` STRING COMMENT 'Assessment of the employees adherence to port safety protocols, ISPS (International Ship and Port Facility Security) requirements, OHS (Occupational Health and Safety) standards, and incident prevention practices. Critical for maritime operations where safety is paramount.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding`',
    `succession_candidate_flag` BOOLEAN COMMENT 'Indicator of whether the employee is identified as a candidate for succession planning for critical roles within the organization. True indicates inclusion in succession planning initiatives.',
    `teamwork_collaboration_rating` STRING COMMENT 'Assessment of the employees ability to work effectively with colleagues, cross-functional teams, and external stakeholders. Evaluates communication, cooperation, and contribution to team success in the port environment.. Valid values are `exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding`',
    `terminal_code` STRING COMMENT 'Code identifying the port terminal where the employee primarily worked during the review period. Relevant for terminal operations staff, stevedore gangs, and equipment operators.',
    `training_recommendations` STRING COMMENT 'Specific training courses, certifications, or development programs recommended for the employee based on performance gaps, career aspirations, or business needs. May include technical training, safety certifications, leadership development, or competency enhancement programs.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this performance review record was last modified. Audit field tracking the most recent change to any field in the record.',
    CONSTRAINT pk_performance_review PRIMARY KEY(`performance_review_id`)
) COMMENT 'Formal employee performance appraisal records capturing review period, review type (annual, mid-year, probationary, post-incident), overall performance rating, individual goal ratings, competency ratings, development plan summary, reviewer, review date, and employee acknowledgement status. Supports talent management, promotion decisions, and identification of high-potential employees. Sourced from Oracle HCM Cloud Performance Management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` (
    `disciplinary_case_id` BIGINT COMMENT 'Unique identifier for the disciplinary or grievance case record. Primary key.',
    `employee_id` BIGINT COMMENT 'User identifier of the HR or management person who created the case record.',
    `disciplinary_last_updated_by_user_employee_id` BIGINT COMMENT 'User identifier of the person who last updated the case record.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Disciplinary case is associated with an organizational unit (department). Currently denormalized with department_code. Adding org_unit_id FK enables proper normalization.',
    `position_id` BIGINT COMMENT 'add column position_id (BIGINT) with FK to workforce.position.position_id - disciplinary cases should reference the position held at time of incident for HR reporting',
    `primary_disciplinary_employee_id` BIGINT COMMENT 'Identifier of the employee who is the subject of the disciplinary action or the initiator of the grievance.',
    `tertiary_disciplinary_hearing_officer_employee_id` BIGINT COMMENT 'Identifier of the management or HR representative who presided over the hearing.',
    `allegation_category` STRING COMMENT 'Primary category of the allegation or complaint being addressed in the case. [ENUM-REF-CANDIDATE: misconduct|safety_violation|isps_security_breach|mlc_non_compliance|pay_dispute|roster_fairness|workplace_bullying|working_conditions|other — 9 candidates stripped; promote to reference product]',
    `allegation_details` STRING COMMENT 'Detailed description of the misconduct allegation or grievance complaint including circumstances, witnesses, and evidence summary.',
    `appeal_decision_date` DATE COMMENT 'Date when the appeal decision was formally communicated.',
    `appeal_filed_date` DATE COMMENT 'Date when the employee formally filed an appeal.',
    `appeal_filed_flag` BOOLEAN COMMENT 'Indicates whether the employee has filed an appeal against the disciplinary decision.',
    `appeal_outcome` STRING COMMENT 'Result of the appeal process indicating whether the original decision was upheld, overturned, or modified.. Valid values are `upheld|overturned|modified|pending`',
    `case_closure_date` DATE COMMENT 'Date when the case was officially closed and all administrative actions completed.',
    `case_opened_date` DATE COMMENT 'Date when the formal case was officially opened and recorded in the system.',
    `case_reference_number` STRING COMMENT 'Externally-known unique reference number assigned to the case for tracking and reporting purposes.. Valid values are `^[A-Z]{2,4}-[0-9]{4,8}$`',
    `case_status` STRING COMMENT 'Current lifecycle status of the case indicating its progression through the employee relations process. [ENUM-REF-CANDIDATE: open|under_investigation|hearing_scheduled|pending_decision|closed|appealed|escalated — 7 candidates stripped; promote to reference product]',
    `case_type` STRING COMMENT 'Classification of the case as either employer-initiated disciplinary action or employee-initiated grievance.. Valid values are `disciplinary|grievance`',
    `confidentiality_level` STRING COMMENT 'Classification of the confidentiality level required for this case record based on sensitivity of allegations and parties involved.. Valid values are `standard|high|restricted`',
    `cost_centre_code` STRING COMMENT 'Financial cost centre code associated with the employee or incident location for reporting purposes.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the case record was first created in the system.',
    `employee_representation_type` STRING COMMENT 'Type of representation the employee had during the hearing process.. Valid values are `none|union_representative|legal_counsel|colleague|other`',
    `escalated_to_tribunal_flag` BOOLEAN COMMENT 'Indicates whether the case has been escalated to an external labour tribunal or arbitration body.',
    `hearing_conducted_date` DATE COMMENT 'Actual date when the hearing was conducted.',
    `hearing_scheduled_date` DATE COMMENT 'Date when the formal disciplinary or grievance hearing is scheduled to take place.',
    `incident_date` DATE COMMENT 'Date when the alleged misconduct, safety violation, or grievable event occurred.',
    `initiator_type` STRING COMMENT 'Indicates whether the case was initiated by the employer (disciplinary) or the employee (grievance).. Valid values are `employer|employee`',
    `investigation_completion_date` DATE COMMENT 'Date when the investigation was formally concluded and findings documented.',
    `investigation_start_date` DATE COMMENT 'Date when the formal investigation commenced.',
    `investigation_status` STRING COMMENT 'Current status of the formal investigation into the allegations or grievance.. Valid values are `not_started|in_progress|completed|suspended`',
    `isps_security_related_flag` BOOLEAN COMMENT 'Indicates whether the case involves a breach of ISPS Code security requirements.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the case record was last modified.',
    `mlc_compliance_flag` BOOLEAN COMMENT 'Indicates whether the case handling and outcome comply with MLC 2006 Title 5 requirements for fair treatment and dispute resolution.',
    `outcome_decision` STRING COMMENT 'Final decision or action taken as a result of the disciplinary case or grievance resolution. [ENUM-REF-CANDIDATE: verbal_warning|written_warning|final_warning|suspension|dismissal|no_action|mediation|resolution|other — 9 candidates stripped; promote to reference product]',
    `outcome_details` STRING COMMENT 'Detailed explanation of the outcome decision including rationale, conditions, and any corrective actions required.',
    `representative_name` STRING COMMENT 'Name of the union representative, legal counsel, or colleague who represented the employee.',
    `resolution_date` DATE COMMENT 'Date when the case was formally resolved through mediation, settlement, or final decision.',
    `safety_incident_related_flag` BOOLEAN COMMENT 'Indicates whether the case is related to a workplace safety violation or occupational health and safety incident.',
    `severity_level` STRING COMMENT 'Assessment of the severity of the misconduct or grievance based on impact to operations, safety, or employee wellbeing.. Valid values are `minor|moderate|serious|critical`',
    `suspension_end_date` DATE COMMENT 'End date of the suspension period when the employee is eligible to return to work.',
    `suspension_paid_flag` BOOLEAN COMMENT 'Indicates whether the suspension period is paid or unpaid.',
    `suspension_start_date` DATE COMMENT 'Start date of any suspension period imposed as part of the disciplinary outcome.',
    `terminal_code` STRING COMMENT 'Code identifying the port terminal where the employee is assigned or where the incident occurred.',
    `tribunal_reference_number` STRING COMMENT 'External reference number assigned by the labour tribunal or arbitration body.',
    `warning_expiry_date` DATE COMMENT 'Date when a verbal, written, or final warning expires and is removed from the employee record.',
    CONSTRAINT pk_disciplinary_case PRIMARY KEY(`disciplinary_case_id`)
) COMMENT 'Records of all formal employee relations cases including employer-initiated disciplinary proceedings and employee-initiated grievances. Covers misconduct, safety violations, ISPS security breaches, MLC non-compliance, pay disputes, roster fairness complaints, workplace bullying, and working condition complaints. Captures case reference, case type (disciplinary or grievance), initiator (employer or employee), incident date, allegation or complaint details, investigation status, hearing date, outcome (verbal warning, written warning, final warning, suspension, dismissal, no action, mediation, resolution), appeal status, escalation to labour tribunal flag, resolution date, and case closure date. Maintains confidential HR records required for labour law compliance, MLC 2006 Title 5 compliance, ILO reporting, port authority reporting, and enterprise bargaining agreement dispute resolution. SSOT for all employee relations case management including grievances and disciplinary actions.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` (
    `grievance_case_id` BIGINT COMMENT 'Unique identifier for the grievance case record. Primary key.',
    `gang_id` BIGINT COMMENT 'Identifier of the stevedore gang to which the employee belonged at the time of the grievance, if applicable. Null for non-gang employees.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Grievance case is associated with an organizational unit (department). Currently denormalized with department_code. Adding org_unit_id FK enables proper normalization.',
    `position_id` BIGINT COMMENT 'Foreign key linking to workforce.position. Business justification: Grievance case is associated with a position (job role). Currently denormalized with job_role_code. Adding position_id FK enables proper normalization.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who lodged the grievance. Links to the employee master record in Oracle HCM Cloud.',
    `tertiary_grievance_union_representative_employee_id` BIGINT COMMENT 'Identifier of the union representative assisting the employee with the grievance, if applicable. Null if no union representation.',
    `tertiary_quinary_grievance_corrective_action_owner_employee_id` BIGINT COMMENT 'Identifier of the employee or manager responsible for implementing corrective actions.',
    `assigned_investigator_name` STRING COMMENT 'Full name of the investigator assigned to the case. Denormalized for reporting purposes.',
    `case_number` STRING COMMENT 'Externally-known unique business identifier for the grievance case, formatted as GRV-YYYY-NNNNNN.. Valid values are `^GRV-[0-9]{4}-[0-9]{6}$`',
    `case_status` STRING COMMENT 'Current lifecycle status of the grievance case in the resolution workflow. [ENUM-REF-CANDIDATE: lodged|under_investigation|pending_response|resolved|closed|escalated|withdrawn — 7 candidates stripped; promote to reference product]',
    `closed_date` DATE COMMENT 'Date when the grievance case was administratively closed in the system.',
    `corrective_action_description` STRING COMMENT 'Description of corrective actions to be taken to address systemic issues identified through the grievance.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which corrective actions must be completed.',
    `corrective_action_required` BOOLEAN COMMENT 'Boolean flag indicating whether corrective actions were identified as necessary to prevent recurrence.',
    `created_by_user` STRING COMMENT 'Username or identifier of the system user who created the grievance case record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the grievance case record was first created in the system. Audit trail field.',
    `employee_satisfaction_rating` STRING COMMENT 'Optional satisfaction rating provided by the employee after resolution, on a scale of 1 to 5, where 5 is highly satisfied.',
    `escalated_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the grievance was escalated to a labour tribunal, external arbitrator, or higher authority.',
    `escalation_body` STRING COMMENT 'Name of the external body or authority to which the grievance was escalated (e.g., Labour Tribunal, Fair Work Commission, Arbitrator).',
    `escalation_date` DATE COMMENT 'Date when the grievance was escalated to an external body or higher authority. Null if not escalated.',
    `escalation_reference_number` STRING COMMENT 'External reference number or case number assigned by the escalation body.',
    `finding_outcome` STRING COMMENT 'Categorical outcome of the investigation findings.. Valid values are `substantiated|partially_substantiated|unsubstantiated|inconclusive`',
    `grievance_category` STRING COMMENT 'Categorization of the grievance by scope and formality level. Individual grievances affect one employee; collective grievances affect multiple employees or a gang.. Valid values are `individual|collective|formal|informal`',
    `grievance_description` STRING COMMENT 'Detailed narrative description of the grievance as provided by the employee. Captures the nature of the complaint, circumstances, and requested remedy.',
    `grievance_type` STRING COMMENT 'Classification of the grievance by subject matter. Categorizes the nature of the complaint raised by the employee. [ENUM-REF-CANDIDATE: pay_dispute|working_conditions|roster_fairness|mlc_entitlement|workplace_conduct|discrimination|harassment|safety_concern|other — 9 candidates stripped; promote to reference product]',
    `incident_date` DATE COMMENT 'Date when the incident or issue that led to the grievance occurred. May predate the lodged date.',
    `incident_location` STRING COMMENT 'Physical location or work area where the incident or issue occurred (e.g., berth number, yard area, office, vessel).',
    `investigation_completion_date` DATE COMMENT 'Date when the investigation was completed and findings were documented.',
    `investigation_findings` STRING COMMENT 'Summary of the investigation findings, including whether the grievance was substantiated, partially substantiated, or unsubstantiated.',
    `investigation_start_date` DATE COMMENT 'Date when the formal investigation of the grievance commenced.',
    `lodged_date` DATE COMMENT 'Date when the grievance was formally lodged by the employee. Principal business event timestamp for the grievance lifecycle.',
    `lodged_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the grievance was submitted into the system.',
    `mlc_compliance_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the grievance relates to MLC 2006 Title 5 compliance requirements (on-board complaint procedures for seafarers and port workers).',
    `mlc_standard_reference` STRING COMMENT 'Specific MLC 2006 standard or regulation reference that the grievance relates to, if applicable.',
    `priority_level` STRING COMMENT 'Priority assigned to the grievance case based on severity, urgency, and potential operational or legal impact.. Valid values are `low|medium|high|critical`',
    `resolution_date` DATE COMMENT 'Date when the grievance was formally resolved and communicated to the employee.',
    `resolution_description` STRING COMMENT 'Detailed description of the resolution actions taken, remedies provided, or reasons for dismissal.',
    `resolution_outcome` STRING COMMENT 'Final outcome of the grievance case after investigation and resolution process.. Valid values are `upheld|partially_upheld|dismissed|withdrawn|settled`',
    `respondent_name` STRING COMMENT 'Full name of the individual who is the subject of the grievance, if applicable. Null if grievance is not against an individual.',
    `terminal_code` STRING COMMENT 'Code of the port terminal where the employee was assigned at the time of the grievance.',
    `union_representative_name` STRING COMMENT 'Full name of the union representative assisting the employee, if applicable.',
    `updated_by_user` STRING COMMENT 'Username or identifier of the system user who last updated the grievance case record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the grievance case record was last updated. Audit trail field.',
    `witness_names` STRING COMMENT 'Comma-separated list of names of witnesses to the incident or issue, if any were identified by the employee.',
    CONSTRAINT pk_grievance_case PRIMARY KEY(`grievance_case_id`)
) COMMENT 'Formal employee grievance records capturing complaints raised by port workers regarding working conditions, pay disputes, roster fairness, MLC entitlements, or workplace conduct. Captures grievance type, date lodged, parties involved, investigation findings, resolution outcome, resolution date, and whether the grievance was escalated to a labour tribunal. Distinct from disciplinary cases as it is employee-initiated. Required for MLC 2006 Title 5 compliance and ILO reporting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` (
    `mlc_compliance_record_id` BIGINT COMMENT 'Unique identifier for the MLC compliance record. Primary key.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the employee subject to MLC compliance tracking. Links to the employee master record in Oracle HCM Cloud.',
    `vessel_id` BIGINT COMMENT 'add column vessel_id (BIGINT) with FK to vessel.vessel.vessel_id - MLC compliance records apply to specific vessels under the Maritime Labour Convention',
    `accommodation_standard_met` BOOLEAN COMMENT 'Boolean flag indicating whether accommodation provided to the seafarer meets MLC 2006 Title 3 standards for size, ventilation, heating, lighting, and sanitary facilities. Applicable to seafarers with onboard accommodation.',
    `certificate_expiry_date` DATE COMMENT 'Date the MLC-related certificate or document expires. Critical for proactive renewal management and maintaining continuous compliance status.',
    `certificate_issue_date` DATE COMMENT 'Date the MLC-related certificate or document was issued. Used to calculate validity periods and renewal schedules.',
    `certificate_number` STRING COMMENT 'Reference number of the MLC-related certificate or document evidencing compliance (e.g., Medical Fitness Certificate, STCW Certificate, Seafarers Employment Agreement number). Nullable for compliance areas that do not require specific certification.',
    `complaint_lodged` BOOLEAN COMMENT 'Boolean flag indicating whether this compliance record originated from or is related to a seafarer complaint lodged through the onboard complaint procedure as required by MLC 2006 Standard A5.1.5.',
    `complaint_reference` STRING COMMENT 'Reference number of the related seafarer complaint if this compliance record was triggered by a complaint. Links to the complaint management system. Nullable when no complaint is associated.',
    `compliance_area` STRING COMMENT 'Specific compliance area or regulation within the MLC title being tracked (e.g., Minimum Age, Medical Certification, Seafarers Employment Agreement, Hours of Work and Rest, Repatriation, Accommodation Standards, Food and Catering, Medical Care, Social Security).',
    `compliance_record_number` STRING COMMENT 'Business identifier for the MLC compliance record, formatted as MLC-YYYYMMDD-NNNN for external reference and audit trail.. Valid values are `^MLC-[0-9]{8}-[0-9]{4}$`',
    `compliance_status` STRING COMMENT 'Current compliance status of the employee against the specified MLC requirement. Compliant indicates full adherence, non-compliant indicates violation requiring corrective action, pending review indicates assessment in progress, under corrective action indicates remediation underway, exempted indicates formal exemption granted, not applicable indicates requirement does not apply to this employee role.. Valid values are `compliant|non-compliant|pending review|under corrective action|exempted|not applicable`',
    `corrective_action_completed_date` DATE COMMENT 'Actual date the corrective action was completed and verified. Used to track remediation effectiveness and close out non-conformances. Nullable until corrective action is completed.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which corrective action must be completed to restore MLC compliance. Set based on non-conformance severity and regulatory requirements. Nullable when no corrective action is required.',
    `corrective_action_required` STRING COMMENT 'Description of the corrective action required to achieve MLC compliance. Includes specific steps, responsible parties, and resources needed. Nullable when compliance status is compliant.',
    `corrective_action_verified_by` STRING COMMENT 'Name or identifier of the person or authority who verified completion of the corrective action and restoration of MLC compliance (e.g., Port Safety Officer, MLC Compliance Manager, External Auditor).',
    `declaration_of_mlc_compliance_ref` STRING COMMENT 'Reference number of the Declaration of Maritime Labour Compliance (DMLC) Part I and Part II under which this compliance record is tracked. The DMLC is the primary MLC certification document.',
    `flag_state_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 code of the flag state under whose jurisdiction the MLC compliance is regulated. Relevant for seafarers working on vessels or in port operations subject to specific flag state MLC implementation.. Valid values are `^[A-Z]{3}$`',
    `inspection_type` STRING COMMENT 'Type of inspection or assessment that generated this compliance record. Determines inspection scope, frequency, and regulatory implications. [ENUM-REF-CANDIDATE: initial certification|renewal inspection|intermediate inspection|PSC inspection|internal audit|complaint investigation|follow-up inspection — 7 candidates stripped; promote to reference product]',
    `inspector_name` STRING COMMENT 'Name of the inspector or auditor who conducted the MLC compliance assessment (internal compliance officer, PSC inspector, or third-party auditor).',
    `inspector_organization` STRING COMMENT 'Organization or authority the inspector represents (e.g., Port State Control Authority, Flag State Administration, Classification Society, Internal Audit Team).',
    `issuing_authority` STRING COMMENT 'Name of the competent authority, medical practitioner, or recognized organization that issued the MLC compliance certificate or document (e.g., Flag State Maritime Authority, Approved Medical Examiner, Classification Society).',
    `last_inspection_date` DATE COMMENT 'Date of the most recent MLC compliance inspection or assessment for this employee and compliance area. Used to track inspection frequency and compliance verification cycles.',
    `medical_care_access_confirmed` BOOLEAN COMMENT 'Boolean flag indicating whether the seafarer has confirmed access to medical care as required by MLC 2006 Title 4, including medical facilities, qualified medical personnel, and medical supplies.',
    `mlc_title` STRING COMMENT 'The specific MLC 2006 title under which this compliance record is categorized. MLC 2006 is structured into five titles covering minimum requirements, employment conditions, accommodation, health protection, and compliance enforcement.. Valid values are `Title 1 - Minimum Requirements for Seafarers to Work on a Ship|Title 2 - Conditions of Employment|Title 3 - Accommodation, Recreational Facilities, Food and Catering|Title 4 - Health Protection, Medical Care, Welfare and Social Security Protection|Title 5 - Compliance and Enforcement`',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next MLC compliance inspection or review. Critical for proactive compliance management and avoiding PSC (Port State Control) deficiencies.',
    `non_conformance_description` STRING COMMENT 'Detailed description of the MLC non-conformance or deficiency identified during inspection or assessment. Includes nature of violation, specific regulation breached, and circumstances. Nullable when compliance status is compliant.',
    `non_conformance_severity` STRING COMMENT 'Severity classification of the MLC non-conformance. Critical indicates immediate risk to seafarer safety or rights requiring urgent action, major indicates significant breach requiring corrective action before next PSC inspection, minor indicates administrative or documentation issue requiring correction within defined timeframe.. Valid values are `critical|major|minor`',
    `notes` STRING COMMENT 'Free-text field for additional notes, observations, or context related to this MLC compliance record. Used to capture inspector comments, special circumstances, or follow-up actions.',
    `psc_inspection_reference` STRING COMMENT 'Reference number of the PSC inspection during which this MLC compliance issue was identified or verified. Links to external PSC inspection records and deficiency databases. Nullable for internal compliance assessments.',
    `record_created_by` STRING COMMENT 'Username or identifier of the system user who created this MLC compliance record. Audit trail for data governance and accountability.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this MLC compliance record was first created in the system. Audit trail for compliance tracking and reporting.',
    `record_updated_by` STRING COMMENT 'Username or identifier of the system user who last updated this MLC compliance record. Audit trail for data governance and accountability.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this MLC compliance record was last updated. Tracks changes to compliance status, corrective actions, or inspection results.',
    `repatriation_security_held` BOOLEAN COMMENT 'Boolean flag indicating whether financial security for repatriation is in place for this seafarer as required by MLC 2006 Standard A2.5. Typically satisfied through P&I (Protection and Indemnity) club coverage or bank guarantee.',
    `responsible_officer_email` STRING COMMENT 'Email address of the responsible officer for MLC compliance follow-up and communication. Business-confidential contact information.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `responsible_officer_name` STRING COMMENT 'Name of the port or vessel officer responsible for ensuring MLC compliance for this employee (e.g., MLC Compliance Officer, Human Resources Manager, Master of Vessel).',
    `rest_hours_compliant` BOOLEAN COMMENT 'Boolean flag indicating whether the employee is compliant with MLC 2006 Standard A2.3 rest hours requirements (minimum 10 hours rest in any 24-hour period and 77 hours in any 7-day period). Critical for seafarer welfare and PSC inspection.',
    `seafarer_employment_agreement_ref` STRING COMMENT 'Reference number of the Seafarers Employment Agreement under which this employee is engaged. Required for MLC Title 2 compliance tracking. Nullable for shore-based port employees not classified as seafarers.',
    `social_security_coverage` STRING COMMENT 'Level of social security coverage provided to the seafarer in accordance with MLC 2006 Standard A4.5, covering medical care, sickness benefit, employment injury benefit, and other social security branches.. Valid values are `full coverage|partial coverage|no coverage|exempted`',
    CONSTRAINT pk_mlc_compliance_record PRIMARY KEY(`mlc_compliance_record_id`)
) COMMENT 'Maritime Labour Convention (MLC 2006) compliance tracking records for individual employees covering the five MLC titles: minimum requirements for seafarers, conditions of employment, accommodation and recreational facilities, health protection and medical care, and social security. Captures compliance area, compliance status, last inspection date, next due date, non-conformance details, corrective action, and flag state authority reference. Mandatory for port operators employing seafarers and for PSC (Port State Control) inspections.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` (
    `labour_agreement_id` BIGINT COMMENT 'Unique identifier for the labour agreement record. Primary key.',
    `org_unit_id` BIGINT COMMENT 'add column org_unit_id (BIGINT) with FK to workforce.org_unit.org_unit_id - labour agreements apply to specific organizational units (stevedore divisions, etc.)',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Labor agreements apply to specific terminals/locations (different agreements for different port areas). FK enables agreement enforcement by location, payroll rule application, industrial relations man',
    `superseded_agreement_labour_agreement_id` BIGINT COMMENT 'Reference to the previous labour agreement that this agreement replaces or supersedes, enabling historical tracking of agreement evolution.',
    `agreement_name` STRING COMMENT 'Full legal or business name of the labour agreement, typically including the parties involved and the scope of coverage.',
    `agreement_number` STRING COMMENT 'Externally-known unique reference number or code assigned to the labour agreement for identification and tracking purposes.',
    `agreement_status` STRING COMMENT 'Current lifecycle status of the labour agreement indicating its operational state and validity. [ENUM-REF-CANDIDATE: draft|pending_ratification|ratified|active|expired|terminated|superseded|under_renegotiation — 8 candidates stripped; promote to reference product]',
    `agreement_type` STRING COMMENT 'Classification of the labour agreement indicating the nature and scope of the employment arrangement. EBA (Enterprise Bargaining Agreement), CLA (Collective Labour Agreement), casual hire agreement, greenfields agreement, or other types.. Valid values are `enterprise_bargaining_agreement|collective_labour_agreement|casual_hire_agreement|greenfields_agreement|individual_flexibility_arrangement|other`',
    `annual_leave_entitlement_days` STRING COMMENT 'Number of paid annual leave days per year that employees are entitled to under the agreement.',
    `applicable_job_families` STRING COMMENT 'Comma-separated list or description of job families, roles, or classifications covered by this agreement (e.g., stevedores, crane operators, marine pilots, security personnel).',
    `coverage_scope` STRING COMMENT 'Description of the workforce segments, job roles, terminals, or operational areas covered by this labour agreement (e.g., stevedore gangs, equipment operators, marine pilots, security personnel).',
    `created_by_user` STRING COMMENT 'Username or identifier of the system user who created this labour agreement record, supporting accountability and audit requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this labour agreement record was first created in the system, supporting audit trail and data lineage.',
    `dispute_resolution_process` STRING COMMENT 'Description of the agreed process for resolving disputes between employer and employees, including escalation steps, mediation, and arbitration procedures.',
    `document_reference_url` STRING COMMENT 'URL or file path reference to the full legal document or PDF of the labour agreement for detailed review and audit purposes.',
    `effective_date` DATE COMMENT 'Date from which the labour agreement becomes legally binding and operational, governing employment terms and conditions.',
    `employer_party_name` STRING COMMENT 'Legal name of the employer or port authority entity that is a party to the labour agreement.',
    `expiry_date` DATE COMMENT 'Date on which the labour agreement ceases to be in force, triggering renegotiation or renewal processes. Nullable for open-ended agreements.',
    `fair_work_commission_approval_number` STRING COMMENT 'Official approval or registration number issued by the Fair Work Commission (or equivalent regulatory body) for the labour agreement.',
    `fatigue_management_rules` STRING COMMENT 'Summary of fatigue management provisions including maximum consecutive work hours, mandatory rest periods, and shift rotation constraints to ensure MLC (Maritime Labour Convention) compliance.',
    `gang_complement_minimum` STRING COMMENT 'Minimum number of workers required to constitute a stevedore gang or work crew under the terms of the agreement, ensuring safe and efficient operations.',
    `key_terms_summary` STRING COMMENT 'High-level summary of the key employment terms and conditions covered by the agreement, including wage rates, overtime provisions, penalty rates, gang complement requirements, and fatigue management rules.',
    `long_service_leave_threshold_years` STRING COMMENT 'Number of years of continuous service required before an employee becomes eligible for long service leave under the agreement.',
    `minimum_wage_rate` DECIMAL(18,2) COMMENT 'Minimum hourly or daily wage rate stipulated in the agreement for covered employees, serving as the baseline for payroll calculations.',
    `mlc_rest_hours_minimum` STRING COMMENT 'Minimum number of rest hours required between shifts as mandated by the Maritime Labour Convention to prevent fatigue and ensure worker safety.',
    `overtime_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the base wage rate for overtime hours worked (e.g., 1.5 for time-and-a-half, 2.0 for double-time).',
    `payroll_integration_flag` BOOLEAN COMMENT 'Indicates whether the terms of this agreement have been integrated into the payroll system calculation rules and roster constraints. True if integrated, False otherwise.',
    `penalty_rate_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the base wage rate for work performed during penalty periods such as weekends, public holidays, or night shifts.',
    `ratification_date` DATE COMMENT 'Date on which the labour agreement was formally ratified or approved by the relevant parties, including union members and employer representatives.',
    `ratification_method` STRING COMMENT 'Method by which the agreement was ratified, such as member ballot, delegate vote, Fair Work Commission approval, or management approval.. Valid values are `member_ballot|delegate_vote|fair_work_commission_approval|management_approval|other`',
    `redundancy_payment_formula` STRING COMMENT 'Formula or calculation method for determining redundancy payments based on years of service, as stipulated in the agreement.',
    `renegotiation_notice_days` STRING COMMENT 'Number of days advance notice required before commencing renegotiation of the agreement, as stipulated in the agreement terms.',
    `renegotiation_trigger_date` DATE COMMENT 'Date on which renegotiation of the agreement is scheduled to commence, typically set in advance of the expiry date to allow sufficient time for bargaining.',
    `sick_leave_entitlement_days` STRING COMMENT 'Number of paid sick leave days per year that employees are entitled to under the agreement.',
    `union_dues_percentage` DECIMAL(18,2) COMMENT 'Percentage of gross wages to be deducted as union dues or membership fees, as agreed between the parties.',
    `union_party_name` STRING COMMENT 'Name of the union, labour body, or employee representative organization that is a party to the agreement (e.g., MUA - Maritime Union of Australia, ITF affiliate).',
    `updated_by_user` STRING COMMENT 'Username or identifier of the system user who last modified this labour agreement record, supporting accountability and audit requirements.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this labour agreement record was last modified, supporting audit trail and change tracking.',
    `wage_rate_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the wage rates and monetary terms specified in the agreement.. Valid values are `^[A-Z]{3}$`',
    CONSTRAINT pk_labour_agreement PRIMARY KEY(`labour_agreement_id`)
) COMMENT 'Enterprise bargaining agreements (EBAs), collective labour agreements (CLAs), and union agreements governing port workforce employment conditions. Captures agreement reference, union or labour body party (e.g., MUA, ITF affiliate), agreement type (EBA, CLA, casual hire agreement, greenfields agreement), effective date, expiry date, key terms summary (minimum wage rates, overtime multipliers, penalty rates, gang complement minimums, fatigue management rules), ratification status, and renegotiation trigger dates. Distinct from commercial contracts in the contract domain — this is the SSOT for workforce labour terms that drive payroll calculation rules and roster constraints.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` (
    `headcount_plan_id` BIGINT COMMENT 'Primary key for headcount_plan',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Headcount plan is defined for an organizational unit. Currently denormalized with code and name. Adding org_unit_id FK enables proper normalization and removes redundant attributes.',
    `port_location_id` BIGINT COMMENT 'add column port_location_id (BIGINT) with FK to masterdata.port_location.port_location_id - headcount plans must specify which port location requires the headcount',
    `position_id` BIGINT COMMENT 'add column position_id (BIGINT) with FK to workforce.position.position_id - headcount plans are built around positions to be filled',
    `employee_id` BIGINT COMMENT 'Employee identifier of the manager or executive who approved this headcount plan. Establishes accountability for workforce planning decisions.',
    `actual_headcount` DECIMAL(18,2) COMMENT 'Actual headcount at the snapshot date. Represents the realized workforce level. May include fractional FTE values for part-time and casual workers.',
    `actual_labour_cost` DECIMAL(18,2) COMMENT 'Actual labor cost incurred during the planning period. Enables variance analysis against budget for financial control.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the headcount plan was formally approved. Marks the transition from draft to authorized status.',
    `attrition_count` STRING COMMENT 'Number of employees who left the organization during the planning period. Used for turnover analysis and retention strategy.',
    `budgeted_headcount` DECIMAL(18,2) COMMENT 'Authorized headcount for the planning period as approved in the workforce budget. Represents the planned workforce capacity. May include fractional FTE (Full-Time Equivalent) values.',
    `budgeted_labour_cost` DECIMAL(18,2) COMMENT 'Total budgeted labor cost for the planning period including base pay, allowances, and employer contributions. Used for OPEX and CAPEX labor budgeting.',
    `cost_centre_code` STRING COMMENT 'Financial cost centre to which workforce costs for this plan are allocated. Links workforce planning to financial budgeting and OPEX tracking.. Valid values are `^[A-Z0-9]{6,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this headcount plan record was first created in the system. Audit trail for data lifecycle.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record. Enables multi-currency workforce planning for international port operations.. Valid values are `^[A-Z]{3}$`',
    `employment_category` STRING COMMENT 'Category of employment relationship. Distinguishes between permanent staff, casual labor, contractors, and temporary workers for workforce flexibility planning.. Valid values are `permanent|casual|contract|temporary|seasonal`',
    `employment_type` STRING COMMENT 'Type of employment arrangement based on working hours and schedule. Impacts capacity planning and labor cost calculations.. Valid values are `full_time|part_time|shift_based|on_call`',
    `fiscal_period` STRING COMMENT 'Fiscal period within the year (01-12 for monthly, Q1-Q4 for quarterly). Enables sub-annual workforce planning granularity.. Valid values are `^[0-9]{2}$`',
    `fiscal_year` STRING COMMENT 'Fiscal year to which this headcount plan applies. Used for financial planning and budget alignment.',
    `isps_clearance_required` BOOLEAN COMMENT 'Indicates whether positions in this plan require ISPS security clearance. Critical for security-sensitive roles in port operations.',
    `job_family` STRING COMMENT 'Broader job family grouping for the position. Used for talent management and career path planning.',
    `mlc_compliant` BOOLEAN COMMENT 'Indicates whether the headcount plan meets Maritime Labour Convention 2006 requirements for crew welfare, working hours, and rest periods.',
    `new_hire_count` STRING COMMENT 'Number of new employees hired during the planning period. Tracks recruitment effectiveness and workforce growth.',
    `plan_notes` STRING COMMENT 'Free-text notes and comments about the headcount plan. Captures business context, assumptions, and special considerations.',
    `plan_number` STRING COMMENT 'Business identifier for the headcount plan, used for external reference and reporting. Format: HCP-XXXXXX.. Valid values are `^HCP-[0-9]{6}$`',
    `plan_status` STRING COMMENT 'Current lifecycle status of the headcount plan. Tracks progression from draft through approval to active deployment and eventual closure.. Valid values are `draft|submitted|approved|active|closed|cancelled`',
    `plan_version` STRING COMMENT 'Version number of the headcount plan. Increments with each revision to track plan evolution and approval cycles.',
    `planned_throughput_teu` STRING COMMENT 'Planned container throughput in TEU for the planning period. Links workforce capacity planning to operational volume targets.',
    `planning_period_end_date` DATE COMMENT 'End date of the planning period covered by this headcount plan. Defines the temporal scope of workforce planning.',
    `planning_period_start_date` DATE COMMENT 'Start date of the planning period covered by this headcount plan. Typically aligns with fiscal year or quarter boundaries.',
    `position_type` STRING COMMENT 'Classification of the workforce position type. Reflects the functional role category within port operations. [ENUM-REF-CANDIDATE: stevedore|equipment_operator|marine_pilot|security_personnel|administrative|management|technical|support — 8 candidates stripped; promote to reference product]',
    `productivity_target_teu_per_gang_hour` DECIMAL(18,2) COMMENT 'Target productivity rate in TEU per gang hour. Used to calculate required stevedore gang capacity based on throughput forecasts.',
    `revision_reason` STRING COMMENT 'Explanation for why the plan was revised. Documents the business drivers for headcount plan changes.',
    `snapshot_date` DATE COMMENT 'Point-in-time date when the actual headcount was captured. Used for comparing planned versus actual workforce levels at specific moments.',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the headcount plan was submitted for approval. Tracks the planning workflow timeline.',
    `terminal_code` STRING COMMENT 'Code identifying the port terminal to which this headcount plan applies. Critical for operational capacity planning at terminal level.. Valid values are `^[A-Z]{3,6}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this headcount plan record was last modified. Tracks the most recent change for audit and synchronization purposes.',
    `vacancy_count` STRING COMMENT 'Number of open positions (approved but unfilled) at the snapshot date. Critical for recruitment planning and operational risk assessment.',
    `variance_headcount` DECIMAL(18,2) COMMENT 'Difference between budgeted and actual headcount (actual minus budgeted). Positive values indicate overstaffing, negative values indicate understaffing.',
    CONSTRAINT pk_headcount_plan PRIMARY KEY(`headcount_plan_id`)
) COMMENT 'Periodic authorised headcount plan and actual headcount snapshot by organisational unit, position type, and employment category (permanent, casual, contract). Captures planning period, budgeted headcount, actual headcount, variance, vacancy count, and attrition count. Used for workforce planning, CAPEX/OPEX labour budgeting, and operational capacity planning for terminal throughput. Sourced from Oracle HCM Cloud Workforce Planning and SAP HR.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` (
    `pilot_licence_id` BIGINT COMMENT 'Unique identifier for the marine pilot licence record. Primary key for the pilot licence entity.',
    `pilot_id` BIGINT COMMENT 'Reference to the marine pilot employee who holds this licence. Links to the pilot master record in the marine services domain.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Pilot licenses specify authorized berths/pilotage areas. FK enables pilotage area management, dispatch validation (pilot authorized for requested berth), and regulatory compliance tracking. Replaces d',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Pilot licenses authorize specific vessel types (container, tanker, cruise). FK enables precise authorization checking before pilotage dispatch, regulatory compliance verification, and pilot qualificat',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this licence record was first created in the system. Used for audit trail and data lineage tracking.',
    `cruise_ship_endorsement` BOOLEAN COMMENT 'Indicates whether the pilot is authorised to pilot cruise ships. Cruise vessels may require additional certification due to passenger safety considerations and vessel size.',
    `dangerous_goods_endorsement` BOOLEAN COMMENT 'Indicates whether the pilot is certified to pilot vessels carrying dangerous goods under the IMDG Code. Required for piloting tankers, chemical carriers, and vessels with hazardous cargo.',
    `endorsement_notes` STRING COMMENT 'Free-text field for additional endorsements, restrictions, or special conditions attached to the licence. May include specific berth restrictions, tug assistance requirements, or weather limitations.',
    `expiry_date` DATE COMMENT 'Date on which the pilotage licence expires and is no longer valid for pilotage operations. Pilots must renew before this date to maintain active status.',
    `imdg_classes_authorised` STRING COMMENT 'Comma-separated list of IMDG hazard classes the pilot is authorised to handle (e.g., Class 1 Explosives, Class 2 Gases, Class 3 Flammable Liquids, Class 7 Radioactive Materials). Blank if no dangerous goods endorsement.',
    `issue_date` DATE COMMENT 'Date on which the pilotage licence was originally issued by the maritime authority. Used to calculate licence seniority and experience.',
    `issuing_authority_code` STRING COMMENT 'Standardized code identifying the issuing authority. Used for regulatory reporting and international recognition of pilotage credentials.',
    `issuing_authority_name` STRING COMMENT 'Name of the national maritime authority or port authority that issued this pilotage licence. Typically the national maritime safety regulator or designated port authority with licensing powers.',
    `issuing_country_code` STRING COMMENT 'Three-letter ISO country code of the country whose maritime authority issued this licence. Critical for international mutual recognition agreements.. Valid values are `^[A-Z]{3}$`',
    `last_renewal_date` DATE COMMENT 'Date of the most recent licence renewal. Used to track renewal history and compliance with periodic revalidation requirements.',
    `licence_class` STRING COMMENT 'Classification of the pilotage licence indicating the level of authority and vessel size restrictions. Class 1 typically represents the highest authority for largest vessels, while restricted classes have specific limitations.. Valid values are `class_1|class_2|class_3|master|unlimited|restricted`',
    `licence_number` STRING COMMENT 'Unique licence number issued by the national maritime authority. This is the official external identifier for the pilotage licence and must be displayed on all pilotage documentation.',
    `licence_status` STRING COMMENT 'Current lifecycle status of the pilot licence. Active licences are valid for pilotage operations. Suspended licences are temporarily invalid pending investigation or medical review. Expired licences require renewal. Revoked licences are permanently cancelled.. Valid values are `active|suspended|expired|revoked|pending|inactive`',
    `lng_carrier_endorsement` BOOLEAN COMMENT 'Indicates whether the pilot holds specific endorsement to pilot LNG carriers. LNG vessels require specialized training due to cargo hazards and vessel handling characteristics.',
    `maximum_dwt_tonnes` DECIMAL(18,2) COMMENT 'Maximum vessel Deadweight Tonnage in metric tonnes that the pilot is authorised to pilot. DWT is the total weight a vessel can safely carry including cargo, fuel, crew, provisions. Key limitation for pilotage operations.',
    `maximum_grt_tonnes` DECIMAL(18,2) COMMENT 'Maximum vessel Gross Registered Tonnage that the pilot is authorised to pilot. GRT is a measure of the overall internal volume of a vessel. Used in some jurisdictions as an alternative to DWT for licence restrictions.',
    `maximum_loa_metres` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall in metres that the pilot is authorised to pilot. LOA is the maximum length of the vessel measured from the foremost point to the aftermost point. Critical safety parameter for pilotage authorisation.',
    `medical_certificate_expiry_date` DATE COMMENT 'Expiry date of the pilots current medical fitness certificate. Licence is invalid if medical certificate expires before licence expiry. Typically renewed annually or biennially depending on age and jurisdiction.',
    `medical_certificate_reference` STRING COMMENT 'Reference number of the current valid medical fitness certificate required for pilotage operations. Pilots must maintain medical fitness standards equivalent to or exceeding merchant marine officer requirements.',
    `next_renewal_due_date` DATE COMMENT 'Date by which the pilot must initiate the licence renewal process. Typically set several months before expiry_date to allow time for medical examinations and administrative processing.',
    `night_pilotage_authorised` BOOLEAN COMMENT 'Indicates whether the pilot is authorised to conduct pilotage operations during night hours. Some jurisdictions restrict night pilotage to experienced pilots or specific vessel types.',
    `pilotage_area_code` STRING COMMENT 'Code identifying the specific port or pilotage district where this licence is valid. Pilotage licences are typically port-specific due to local knowledge requirements of channels, berths, tides, and hazards.',
    `pilotage_area_description` STRING COMMENT 'Detailed description of the geographic pilotage area covered by this licence, including specific berths, anchorages, channels, and navigational limits. May include multiple terminals or port zones.',
    `restricted_visibility_authorised` BOOLEAN COMMENT 'Indicates whether the pilot is authorised to conduct pilotage operations in restricted visibility conditions (fog, heavy rain, snow). Requires additional experience and may require radar endorsement.',
    `revocation_date` DATE COMMENT 'Date on which the licence was permanently revoked by the issuing authority. Revocation is typically due to serious safety violations, loss of medical fitness, or disciplinary action.',
    `revocation_reason` STRING COMMENT 'Detailed reason for permanent licence revocation. Confidential personnel and regulatory information. May reference incident reports or disciplinary proceedings.',
    `stcw_certificate_number` STRING COMMENT 'Certificate number of the pilots STCW endorsement if applicable. Used for international verification and Port State Control inspections.',
    `stcw_endorsement_flag` BOOLEAN COMMENT 'Indicates whether the pilot holds valid STCW certification endorsement. STCW is the International Maritime Organization convention setting qualification standards for seafarers. Required for pilots operating on international voyages.',
    `suspension_end_date` DATE COMMENT 'Date on which the licence suspension is scheduled to end or was lifted. Null if suspension is indefinite pending investigation outcome.',
    `suspension_reason` STRING COMMENT 'Reason for licence suspension if status is suspended. May include medical unfitness, pending investigation of incident, administrative non-compliance, or disciplinary action. Confidential personnel information.',
    `suspension_start_date` DATE COMMENT 'Date on which the licence suspension became effective. Pilot may not conduct pilotage operations from this date until suspension is lifted.',
    `total_pilotage_acts` STRING COMMENT 'Cumulative count of pilotage acts (vessel movements) completed by this pilot under this licence. Used to track experience and for performance analysis. Incremented with each completed pilotage assignment.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this licence record was last modified. Updated on any change to licence status, endorsements, or expiry dates. Critical for change tracking and audit compliance.',
    `vtms_integration_enabled` BOOLEAN COMMENT 'Indicates whether this licence record is integrated with the Vessel Traffic Management System for automated pilotage scheduling and dispatch. Required for VTS and pilotage scheduling integration.',
    CONSTRAINT pk_pilot_licence PRIMARY KEY(`pilot_licence_id`)
) COMMENT 'Marine pilot licence and authorisation records for port pilots including licence number, issuing authority (national maritime authority), licence class, authorised vessel types, maximum LOA (Length Overall) and DWT (Deadweight Tonnage) limits, port-specific pilotage authorisation area, issue date, expiry date, medical fitness certificate reference, and licence status. Distinct from general employee certifications due to the highly regulated and port-specific nature of pilotage authorisation. Required for VTS and pilotage scheduling integration.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` (
    `medical_fitness_id` BIGINT COMMENT 'Unique identifier for the medical fitness examination record. Primary key.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the port employee undergoing medical fitness examination. Links to the employee master record in Oracle HCM Cloud.',
    `position_id` BIGINT COMMENT 'Foreign key linking to workforce.position. Business justification: Medical examinations assess fitness for specific positions with role-specific standards (crane operator vs. stevedore). Links medical clearance to position requirements for deployment eligibility and ',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the OHS manager approved the medical fitness outcome for workforce deployment.',
    `approved_by_ohs_manager` BOOLEAN COMMENT 'Indicates whether the medical fitness outcome has been reviewed and approved by the port OHS manager for workforce deployment decisions. True if approved, False otherwise.',
    `cardiovascular_assessment` STRING COMMENT 'Assessment of cardiovascular health including blood pressure, heart rate, and cardiac function. Critical for high-stress roles such as crane operators and marine pilots.. Valid values are `normal|abnormal-minor|abnormal-significant|not-assessed`',
    `certificate_expiry_date` DATE COMMENT 'Date when the medical fitness certificate expires and a new examination is required. Critical for compliance tracking and workforce planning.',
    `certificate_issue_date` DATE COMMENT 'Date when the medical fitness certificate was formally issued.',
    `certificate_issued` BOOLEAN COMMENT 'Indicates whether a formal medical fitness certificate was issued to the employee following the examination. True if certificate issued, False otherwise.',
    `certificate_number` STRING COMMENT 'Unique reference number of the medical fitness certificate issued by the examining physician or occupational health authority.',
    `confidentiality_classification` STRING COMMENT 'Data classification level for this medical fitness record. All medical fitness records are classified as restricted or confidential due to health information privacy requirements under GDPR, HIPAA-equivalent national laws, and MLC 2006.. Valid values are `restricted|confidential`',
    `cost_centre_code` STRING COMMENT 'Financial cost centre code to which the medical examination cost is allocated. Links to SAP S/4HANA CO (Controlling) module.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this medical fitness examination record was first created in the system. Audit trail field.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the examination cost (e.g., USD, EUR, GBP, AUD).. Valid values are `^[A-Z]{3}$`',
    `drug_screening_conducted` BOOLEAN COMMENT 'Indicates whether drug and alcohol screening was conducted as part of the medical examination. True if screening performed, False otherwise.',
    `drug_screening_result` STRING COMMENT 'Outcome of drug and alcohol screening test. Negative indicates no substances detected, positive indicates presence of prohibited substances, inconclusive requires retest.. Valid values are `negative|positive|inconclusive|not-tested`',
    `examination_cost` DECIMAL(18,2) COMMENT 'Total cost of the medical fitness examination charged by the occupational health provider. Used for workforce health budget tracking and cost allocation.',
    `examination_date` DATE COMMENT 'Date when the medical fitness examination was conducted. Critical for MLC 2006 compliance and OHS audit trails.',
    `examination_duration_minutes` STRING COMMENT 'Total duration of the medical examination in minutes, used for occupational health service capacity planning and billing.',
    `examination_number` STRING COMMENT 'Externally-known unique reference number for the medical fitness examination, typically generated by the occupational health provider or port medical services department.. Valid values are `^MED-[0-9]{8}$`',
    `examination_status` STRING COMMENT 'Current lifecycle status of the medical fitness examination record.. Valid values are `scheduled|in-progress|completed|cancelled|expired`',
    `examination_type` STRING COMMENT 'Category of medical examination conducted: pre-employment screening, periodic health surveillance, return-to-work assessment, fitness-for-duty evaluation, post-incident medical review, or random health check.. Valid values are `pre-employment|periodic|return-to-work|fitness-for-duty|post-incident|random`',
    `examining_physician_license_number` STRING COMMENT 'Professional registration or license number of the examining physician, issued by the relevant medical council or maritime health authority.',
    `examining_physician_name` STRING COMMENT 'Full name of the registered medical practitioner or occupational health physician who conducted the examination. Must be a licensed practitioner recognized by the national maritime or occupational health authority.',
    `fitness_outcome` STRING COMMENT 'The medical fitness determination outcome: fit for duty without restrictions, fit with specified restrictions, temporarily unfit (with expected return date), permanently unfit for the role, or pending further medical review. Classified as restricted due to health information sensitivity.. Valid values are `fit|fit-with-restrictions|temporarily-unfit|permanently-unfit|pending-review`',
    `follow_up_details` STRING COMMENT 'Description of required follow-up actions, specialist referrals, or additional medical assessments needed.',
    `follow_up_required` BOOLEAN COMMENT 'Indicates whether follow-up medical consultation, specialist referral, or additional testing is required. True if follow-up needed, False otherwise.',
    `hearing_test_result` STRING COMMENT 'Outcome of audiometric hearing assessment. Critical for roles requiring radio communication, alarm response, and hazardous area work.. Valid values are `pass|fail|corrected-pass|not-tested`',
    `isps_clearance_granted` BOOLEAN COMMENT 'Indicates whether the medical fitness examination supports ISPS security clearance for port security personnel. True if clearance granted, False otherwise.',
    `medical_facility_name` STRING COMMENT 'Name of the clinic, hospital, or occupational health center where the examination was conducted.',
    `medical_standard_applied` STRING COMMENT 'The medical fitness standard or certification framework applied during the examination. MLC ENG1/ENG2/ENG3 for seafarers and marine pilots, national OHS standards for stevedores and crane operators, ISPS security standards for port security personnel. [ENUM-REF-CANDIDATE: MLC-ENG1|MLC-ENG2|MLC-ENG3|national-OHS|ISPS-security|crane-operator|pilot-medical|stevedore-fitness — 8 candidates stripped; promote to reference product]',
    `mlc_compliant` BOOLEAN COMMENT 'Indicates whether the medical examination meets the requirements of MLC 2006 Regulation 1.2 for seafarers and marine-related port workers. True if compliant, False otherwise.',
    `musculoskeletal_assessment` STRING COMMENT 'Assessment of musculoskeletal health, joint mobility, and physical capability. Critical for stevedores and manual handling roles.. Valid values are `normal|abnormal-minor|abnormal-significant|not-assessed`',
    `next_examination_due_date` DATE COMMENT 'Scheduled date for the next periodic medical fitness examination. Typically 12-24 months from current examination depending on role and age of employee.',
    `physical_fitness_assessment` STRING COMMENT 'Overall assessment of physical fitness and capability to perform the physical demands of the safety-critical role (e.g., climbing, lifting, endurance).. Valid values are `excellent|good|satisfactory|below-standard|not-assessed`',
    `physician_comments` STRING COMMENT 'Additional clinical notes, observations, or recommendations provided by the examining physician. Classified as restricted due to medical confidentiality.',
    `psychological_assessment_conducted` BOOLEAN COMMENT 'Indicates whether psychological or mental health assessment was conducted. Typically required for high-stress safety-critical roles such as marine pilots and crane operators.',
    `psychological_assessment_result` STRING COMMENT 'Outcome of psychological fitness assessment. Fit indicates mental health suitable for role, fit-with-support indicates fitness with counseling or support services, unfit indicates psychological concerns preclude role performance.. Valid values are `fit|fit-with-support|unfit|not-assessed`',
    `record_retention_years` STRING COMMENT 'Number of years this medical fitness record must be retained per regulatory requirements. Typically 5-7 years for MLC compliance and occupational health regulations.',
    `respiratory_assessment` STRING COMMENT 'Assessment of respiratory function and lung capacity. Critical for roles involving dust exposure, confined spaces, or respiratory protection equipment use.. Valid values are `normal|abnormal-minor|abnormal-significant|not-assessed`',
    `restriction_details` STRING COMMENT 'Detailed description of any work restrictions or accommodations required (e.g., no night shifts, no heavy lifting over 20kg, hearing protection mandatory, restricted to ground-level operations). Classified as restricted due to health information sensitivity.',
    `restriction_end_date` DATE COMMENT 'Date when the medical restrictions expire or are scheduled for review. Null for permanent restrictions.',
    `restriction_start_date` DATE COMMENT 'Date from which the medical restrictions become effective. Applicable only when fitness outcome is fit-with-restrictions or temporarily-unfit.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this medical fitness examination record was last modified. Audit trail field.',
    `vision_test_result` STRING COMMENT 'Outcome of visual acuity testing. Critical for crane operators, marine pilots, and equipment operators. Pass indicates uncorrected vision meets standard, corrected-pass indicates vision meets standard with corrective lenses.. Valid values are `pass|fail|corrected-pass|not-tested`',
    CONSTRAINT pk_medical_fitness PRIMARY KEY(`medical_fitness_id`)
) COMMENT 'Employee medical fitness examination records required for safety-critical port roles including crane operators, marine pilots, stevedores, and security personnel. Captures examination date, examining physician, medical fitness standard applied (MLC ENG1, national OHS standard), fitness outcome (fit, fit with restrictions, unfit), restriction details, next examination due date, and confidentiality classification. Mandatory for MLC 2006 Regulation 1.2 and OHS compliance. Separate from general employee certification due to medical confidentiality requirements.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` (
    `talent_profile_id` BIGINT COMMENT 'Unique identifier for the employee talent profile record. Primary key for the talent profile entity.',
    `org_unit_id` BIGINT COMMENT 'add column org_unit_id (BIGINT) with FK to workforce.org_unit.org_unit_id - talent profiles need organizational context for succession planning',
    `employee_id` BIGINT COMMENT 'Reference to the HR business partner or talent manager responsible for maintaining and updating this talent profile.',
    `primary_talent_employee_id` BIGINT COMMENT 'Reference to the employee master record in the workforce domain. Links this talent profile to the core employee entity.',
    `career_aspiration` STRING COMMENT 'Employees stated career goals and desired future roles within the organization. Captured during talent review conversations and career development discussions.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this talent profile record was first created in Oracle HCM Cloud Talent Management module.',
    `critical_experience_gaps` STRING COMMENT 'Identified gaps in experience or exposure that must be addressed before the employee is ready for the target succession role (e.g., vessel operations experience, P&L management, multi-terminal oversight).',
    `development_goals` STRING COMMENT 'Specific learning and development objectives agreed between the employee and manager to close skill gaps and prepare for future roles.',
    `development_priority` STRING COMMENT 'Priority level assigned for investing in this employees development based on talent segment, performance, potential, and business needs.. Valid values are `high|medium|low`',
    `education_level` STRING COMMENT 'Highest level of formal education attained by the employee (e.g., Bachelors Degree in Maritime Studies, Masters in Logistics, Maritime Academy Diploma).',
    `impact_of_loss` STRING COMMENT 'Assessment of the business impact if this employee were to leave, considering role criticality, specialized skills, and knowledge concentration.. Valid values are `critical|high|medium|low`',
    `isps_clearance_level` STRING COMMENT 'Security clearance level for employees in security-sensitive roles under ISPS Code requirements. Relevant for succession into port security and operations management roles.. Valid values are `level_1|level_2|level_3|not_applicable`',
    `key_skills` STRING COMMENT 'Comma-separated list of the employees core competencies and technical skills relevant to maritime logistics operations (e.g., NAVIS N4, crane operations, vessel planning, ISPS compliance).',
    `languages_spoken` STRING COMMENT 'Comma-separated list of languages the employee is proficient in. Critical for international port operations and vessel communication.',
    `last_talent_review_date` DATE COMMENT 'Date of the most recent formal talent review or calibration session where this employees profile was assessed and updated.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this talent profile record. Tracks currency of talent data for decision-making.',
    `leadership_competencies` STRING COMMENT 'Assessment of leadership capabilities including people management, strategic thinking, decision-making, and change management. Critical for succession into management roles.',
    `mentoring_status` STRING COMMENT 'Current status of the formal mentoring relationship indicating whether the employee is actively being mentored.. Valid values are `active|completed|on_hold|not_assigned`',
    `mlc_compliance_status` STRING COMMENT 'Indicates whether the employees talent profile and development plan comply with MLC requirements for seafarer career development and training standards.. Valid values are `compliant|non_compliant|not_applicable`',
    `mobility_preference` STRING COMMENT 'Employees willingness and preference for geographic relocation or remote work arrangements. Critical for succession planning across multiple port terminals.. Valid values are `willing_to_relocate|local_only|regional|international|remote`',
    `next_talent_review_date` DATE COMMENT 'Scheduled date for the next formal talent review or calibration session for this employee.',
    `performance_rating` STRING COMMENT 'Most recent performance appraisal rating from the annual or periodic performance review cycle. Influences talent segmentation and development planning.. Valid values are `exceptional|exceeds|meets|needs_improvement|unsatisfactory`',
    `potential_rating` STRING COMMENT 'Assessment of the employees future growth potential and ability to take on roles of greater scope and complexity. Key input to the 9-box talent matrix.. Valid values are `high|medium|low|not_assessed`',
    `preferred_location` STRING COMMENT 'Specific geographic location or terminal where the employee prefers to work if relocation is required. Supports internal mobility and succession planning.',
    `preferred_next_role` STRING COMMENT 'Specific job role or position that the employee aspires to move into as their next career step. Used for succession planning and internal mobility.',
    `profile_notes` STRING COMMENT 'Confidential notes and observations from talent review discussions, calibration sessions, and development conversations. Restricted to HR and senior leadership.',
    `profile_number` STRING COMMENT 'Human-readable business identifier for the talent profile, typically generated by Oracle HCM Cloud Talent Management module.',
    `profile_status` STRING COMMENT 'Current lifecycle status of the talent profile indicating whether it is actively maintained and used for succession planning and talent reviews.. Valid values are `active|inactive|under_review|archived`',
    `risk_of_loss` STRING COMMENT 'Assessment of the likelihood that the employee may leave the organization voluntarily. Used for retention planning and intervention strategies.. Valid values are `high|medium|low|none`',
    `stcw_certification_level` STRING COMMENT 'Highest STCW certification level held by the employee if applicable to marine operations roles (e.g., Officer of the Watch, Master Mariner, Marine Pilot).',
    `succession_plan_role` STRING COMMENT 'Target role or position for which this employee is identified as a potential successor. Links to the organizations formal succession planning process.',
    `succession_rank` STRING COMMENT 'Ranking of this employee among multiple successors for the same target role (1 = primary successor, 2 = backup, etc.). Used for succession depth analysis.',
    `succession_readiness_level` STRING COMMENT 'Assessment of the employees readiness to assume the next role or target position in the succession plan. Critical for workforce continuity planning.. Valid values are `ready_now|ready_1_year|ready_2_3_years|not_ready|under_assessment`',
    `talent_segment` STRING COMMENT 'Strategic talent classification indicating the employees designation in the organizations talent matrix (9-box grid). Used for succession planning and development prioritization.. Valid values are `key_talent|high_potential|successor|emerging_talent|core_performer|development_needed`',
    `technical_competencies` STRING COMMENT 'Specialized technical skills and certifications relevant to port operations (e.g., STCW certifications, TOS expertise, equipment operation, marine pilotage, IMDG handling).',
    `training_plan` STRING COMMENT 'Structured training and development activities planned for the employee including courses, certifications, on-the-job training, and stretch assignments.',
    `years_in_industry` STRING COMMENT 'Total years of experience in the maritime logistics industry. Used for assessing depth of industry knowledge and readiness for senior roles.',
    `years_in_organization` STRING COMMENT 'Total years of service with Shipping Ports. Indicates organizational knowledge and cultural fit for leadership succession.',
    CONSTRAINT pk_talent_profile PRIMARY KEY(`talent_profile_id`)
) COMMENT 'Employee talent and career development profile capturing skills inventory, career aspirations, mobility preferences, succession planning designation (key talent, high potential, successor), mentoring relationships, development goals, and readiness level for next role. Sourced from Oracle HCM Cloud Talent Management. Distinct from the core employee master record — this captures forward-looking talent intelligence used by HR for succession planning and workforce capability development.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` (
    `position_competency_requirement_id` BIGINT COMMENT 'Unique surrogate identifier for each position-competency requirement record',
    `competency_id` BIGINT COMMENT 'Foreign key linking to the competency, qualification, or certification required for the position',
    `position_id` BIGINT COMMENT 'Foreign key linking to the authorised position that has this competency requirement',
    `assessment_frequency` STRING COMMENT 'Frequency at which position holders must be assessed or revalidated for this competency. Drives compliance monitoring and training scheduling.',
    `effective_date` DATE COMMENT 'Date from which this competency requirement became effective for the position. Supports requirement change management and compliance tracking.',
    `expiry_date` DATE COMMENT 'Date on which this competency requirement ceases to be applicable for the position. Null for ongoing requirements. Supports requirement lifecycle management.',
    `mandatory_flag` BOOLEAN COMMENT 'Indicates whether this competency is mandatory (must-have) or recommended (nice-to-have) for the position. Mandatory competencies block position assignment if not held.',
    `minimum_proficiency_level` STRING COMMENT 'The minimum proficiency level required for this competency in the context of this specific position. Determines assessment thresholds and training targets.',
    `notes` STRING COMMENT 'Free-text notes providing additional context about this specific requirement, such as special conditions, exemptions, or implementation guidance.',
    `required_certifications` STRING COMMENT 'Comma-separated list of mandatory certifications, licences, or competency credentials required to hold this position (e.g., Marine Pilot Licence, Quay Crane Operator Certificate, ISPS Security Training, Dangerous Goods Handling Certificate). [Moved from position: This comma-separated string in position is a denormalized representation of the M:N relationship. Moving to the association table enables structured queries, individual requirement tracking, and proper relationship data (mandatory_flag, proficiency_level, effective_date) for each position-competency pair.]',
    `required_competencies` STRING COMMENT 'Comma-separated list of skills, knowledge areas, and behavioural competencies required for successful performance in the position (e.g., Vessel Traffic Management, Container Stacking Algorithms, Crisis Management, NAVIS N4 System Proficiency). [Moved from position: This comma-separated string in position is a denormalized representation of the M:N relationship. Moving to the association table enables structured queries, gap analysis, and proper relationship data management for each position-competency requirement.]',
    `requirement_source` STRING COMMENT 'The source or driver for this competency requirement (e.g., regulatory mandate, operational necessity, safety policy). Supports compliance reporting and requirement justification.',
    `revalidation_required` BOOLEAN COMMENT 'Indicates whether position holders must undergo periodic revalidation or refresher training for this competency, beyond the competencys own renewal requirements.',
    CONSTRAINT pk_position_competency_requirement PRIMARY KEY(`position_competency_requirement_id`)
) COMMENT 'This association product represents the competency requirements defined for each authorised position within the port organisational structure. It captures the mandatory and recommended competencies, certifications, and qualifications that must be held by any employee occupying a specific position. Each record links one position to one competency with attributes that define the requirement level, proficiency expectations, and compliance tracking. This is actively managed by HR and operations teams during organisational design, recruitment, compliance audits, and workforce planning.. Existence Justification: Position competency requirements represent a genuine operational M:N relationship actively managed by HR and operations teams. A position requires multiple competencies (e.g., a Quay Crane Operator position requires ISPS clearance, crane operator licence, safety induction, and medical fitness), and a competency is required by multiple positions (e.g., ISPS security clearance is required by Port Security Officer, Berth Gang Supervisor, and Marine Pilot positions). This relationship is managed during organisational design, recruitment, compliance audits, training planning, and competency change management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` (
    `calibration_session_id` BIGINT COMMENT 'Primary key for calibration_session',
    `employee_id` BIGINT COMMENT 'Employee identifier of the senior leader or HR executive who approved the calibration session outcomes.',
    `calibration_created_by_employee_id` BIGINT COMMENT 'Employee identifier of the user who created this calibration session record.',
    `calibration_department_org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Calibration session is associated with a department (org_unit). Normalizing department_id (BIGINT) to proper FK. Using department_org_unit_id to distinguish from business_unit_org_unit_id.',
    `calibration_facilitator_employee_id` BIGINT COMMENT 'Employee identifier of the HR professional or manager facilitating the calibration session.',
    `calibration_modified_by_employee_id` BIGINT COMMENT 'Employee identifier of the user who last modified this calibration session record.',
    `asset_location_id` BIGINT COMMENT 'Identifier of the port or facility location where the calibration session is held.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the business unit scope for this calibration session.',
    `prior_calibration_session_id` BIGINT COMMENT 'Self-referencing FK on calibration_session (prior_calibration_session_id)',
    `action_items` STRING COMMENT 'List of follow-up action items and responsibilities assigned as a result of the calibration session.',
    `actual_end_time` TIMESTAMP COMMENT 'Actual timestamp when the calibration session concluded.',
    `actual_start_time` TIMESTAMP COMMENT 'Actual timestamp when the calibration session began, may differ from scheduled time.',
    `approval_status` STRING COMMENT 'Approval status of the calibration session outcomes by senior management or HR leadership.',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the calibration session outcomes were officially approved.',
    `calibration_methodology` STRING COMMENT 'The methodology or framework used to calibrate employee assessments during the session.',
    `confidentiality_level` STRING COMMENT 'Data classification level for the calibration session information, determining access controls and handling requirements.',
    `consensus_achieved` BOOLEAN COMMENT 'Indicates whether consensus was achieved among participants on all employee assessments during the session.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this calibration session record was first created in the system.',
    `decisions_made` STRING COMMENT 'Summary of key decisions made during the calibration session regarding employee ratings, promotions, or development plans.',
    `escalation_required` BOOLEAN COMMENT 'Indicates whether any calibration decisions require escalation to senior leadership for final approval.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which this calibration session applies, used for annual performance and compensation cycles.',
    `hcm_system_reference` STRING COMMENT 'Reference identifier linking this calibration session to the corresponding record in Oracle HCM Cloud or SAP HR system.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this calibration session record is currently active in the system.',
    `meeting_location` STRING COMMENT 'Physical location or virtual meeting platform where the calibration session is conducted (e.g., conference room name, Teams link).',
    `meeting_mode` STRING COMMENT 'Mode of conducting the calibration session, indicating whether participants meet physically, virtually, or in a hybrid format.',
    `mlc_compliance_verified` BOOLEAN COMMENT 'Indicates whether MLC compliance requirements were verified during the calibration session for maritime workforce.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this calibration session record was last modified.',
    `rating_scale_used` STRING COMMENT 'Description of the rating scale applied during calibration (e.g., 1-5 scale, exceeds/meets/below expectations).',
    `recording_storage_location` STRING COMMENT 'Secure storage location or system path where the session recording is stored, if available.',
    `review_cycle` STRING COMMENT 'The review cycle period this calibration session is part of within the fiscal year.',
    `review_period_end_date` DATE COMMENT 'End date of the performance or assessment period being calibrated in this session.',
    `review_period_start_date` DATE COMMENT 'Start date of the performance or assessment period being calibrated in this session.',
    `scheduled_date` DATE COMMENT 'Date when the calibration session is scheduled to occur.',
    `scheduled_end_time` TIMESTAMP COMMENT 'Precise timestamp when the calibration session is scheduled to end.',
    `scheduled_start_time` TIMESTAMP COMMENT 'Precise timestamp when the calibration session is scheduled to begin.',
    `session_agenda` STRING COMMENT 'Agenda outlining the topics, discussion points, and structure of the calibration session.',
    `session_notes` STRING COMMENT 'Confidential notes and key discussion points captured during the calibration session.',
    `session_number` STRING COMMENT 'Business identifier for the calibration session, formatted as CAL-YYYY-NNNNNN for external reference and tracking.',
    `session_objectives` STRING COMMENT 'Detailed objectives and goals for the calibration session, outlining what the session aims to achieve.',
    `session_recording_available` BOOLEAN COMMENT 'Indicates whether an audio or video recording of the calibration session is available for reference.',
    `session_status` STRING COMMENT 'Current lifecycle status of the calibration session.',
    `session_type` STRING COMMENT 'Type of calibration session being conducted, determining the focus and outcomes of the session.',
    `target_distribution_applied` BOOLEAN COMMENT 'Indicates whether a target performance distribution curve was applied during calibration to normalize ratings.',
    `total_employees_reviewed` STRING COMMENT 'Total number of employees whose performance or competencies are being calibrated in this session.',
    `total_participants` STRING COMMENT 'Total number of participants (managers, HR representatives) attending the calibration session.',
    CONSTRAINT pk_calibration_session PRIMARY KEY(`calibration_session_id`)
) COMMENT 'Master reference table for calibration_session. Referenced by calibration_session_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_reports_to_position_id` FOREIGN KEY (`reports_to_position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_parent_unit_org_unit_id` FOREIGN KEY (`parent_unit_org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_labour_agreement_id` FOREIGN KEY (`labour_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`labour_agreement`(`labour_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_tertiary_gang_approved_by_employee_id` FOREIGN KEY (`tertiary_gang_approved_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ADD CONSTRAINT `fk_workforce_roster_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ADD CONSTRAINT `fk_workforce_roster_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ADD CONSTRAINT `fk_workforce_roster_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ADD CONSTRAINT `fk_workforce_roster_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_leave_request_id` FOREIGN KEY (`leave_request_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`leave_request`(`leave_request_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_payroll_run_id` FOREIGN KEY (`payroll_run_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`payroll_run`(`payroll_run_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_roster_id` FOREIGN KEY (`roster_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`roster`(`roster_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_primary_leave_employee_id` FOREIGN KEY (`primary_leave_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ADD CONSTRAINT `fk_workforce_payroll_run_reversed_run_payroll_run_id` FOREIGN KEY (`reversed_run_payroll_run_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`payroll_run`(`payroll_run_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ADD CONSTRAINT `fk_workforce_payslip_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ADD CONSTRAINT `fk_workforce_payslip_payroll_run_id` FOREIGN KEY (`payroll_run_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`payroll_run`(`payroll_run_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ADD CONSTRAINT `fk_workforce_payslip_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ADD CONSTRAINT `fk_workforce_employee_certification_competency_id` FOREIGN KEY (`competency_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`competency`(`competency_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ADD CONSTRAINT `fk_workforce_employee_certification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_competency_id` FOREIGN KEY (`competency_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`competency`(`competency_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ADD CONSTRAINT `fk_workforce_training_enrolment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ADD CONSTRAINT `fk_workforce_training_enrolment_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ADD CONSTRAINT `fk_workforce_training_enrolment_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ADD CONSTRAINT `fk_workforce_training_enrolment_primary_training_employee_id` FOREIGN KEY (`primary_training_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ADD CONSTRAINT `fk_workforce_training_enrolment_training_course_id` FOREIGN KEY (`training_course_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`training_course`(`training_course_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_calibration_session_id` FOREIGN KEY (`calibration_session_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`calibration_session`(`calibration_session_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_reviewer_employee_id` FOREIGN KEY (`reviewer_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ADD CONSTRAINT `fk_workforce_disciplinary_case_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ADD CONSTRAINT `fk_workforce_disciplinary_case_disciplinary_last_updated_by_user_employee_id` FOREIGN KEY (`disciplinary_last_updated_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ADD CONSTRAINT `fk_workforce_disciplinary_case_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ADD CONSTRAINT `fk_workforce_disciplinary_case_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ADD CONSTRAINT `fk_workforce_disciplinary_case_primary_disciplinary_employee_id` FOREIGN KEY (`primary_disciplinary_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ADD CONSTRAINT `fk_workforce_disciplinary_case_tertiary_disciplinary_hearing_officer_employee_id` FOREIGN KEY (`tertiary_disciplinary_hearing_officer_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ADD CONSTRAINT `fk_workforce_grievance_case_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ADD CONSTRAINT `fk_workforce_grievance_case_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ADD CONSTRAINT `fk_workforce_grievance_case_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ADD CONSTRAINT `fk_workforce_grievance_case_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ADD CONSTRAINT `fk_workforce_grievance_case_tertiary_grievance_union_representative_employee_id` FOREIGN KEY (`tertiary_grievance_union_representative_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ADD CONSTRAINT `fk_workforce_grievance_case_tertiary_quinary_grievance_corrective_action_owner_employee_id` FOREIGN KEY (`tertiary_quinary_grievance_corrective_action_owner_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ADD CONSTRAINT `fk_workforce_mlc_compliance_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ADD CONSTRAINT `fk_workforce_labour_agreement_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ADD CONSTRAINT `fk_workforce_labour_agreement_superseded_agreement_labour_agreement_id` FOREIGN KEY (`superseded_agreement_labour_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`labour_agreement`(`labour_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ADD CONSTRAINT `fk_workforce_headcount_plan_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ADD CONSTRAINT `fk_workforce_headcount_plan_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ADD CONSTRAINT `fk_workforce_headcount_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ADD CONSTRAINT `fk_workforce_medical_fitness_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ADD CONSTRAINT `fk_workforce_medical_fitness_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ADD CONSTRAINT `fk_workforce_talent_profile_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ADD CONSTRAINT `fk_workforce_talent_profile_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ADD CONSTRAINT `fk_workforce_talent_profile_primary_talent_employee_id` FOREIGN KEY (`primary_talent_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ADD CONSTRAINT `fk_workforce_position_competency_requirement_competency_id` FOREIGN KEY (`competency_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`competency`(`competency_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ADD CONSTRAINT `fk_workforce_position_competency_requirement_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_calibration_created_by_employee_id` FOREIGN KEY (`calibration_created_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_calibration_department_org_unit_id` FOREIGN KEY (`calibration_department_org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_calibration_facilitator_employee_id` FOREIGN KEY (`calibration_facilitator_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_calibration_modified_by_employee_id` FOREIGN KEY (`calibration_modified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_prior_calibration_session_id` FOREIGN KEY (`prior_calibration_session_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`calibration_session`(`calibration_session_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`workforce` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_shipping_ports_v1`.`workforce` SET TAGS ('dbx_domain' = 'workforce');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` SET TAGS ('dbx_subdomain' = 'personnel_records');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Work Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `career_aspirations` SET TAGS ('dbx_business_glossary_term' = 'Career Aspirations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `competency_certifications` SET TAGS ('dbx_business_glossary_term' = 'Competency Certifications');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Employee Date of Birth');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_dob' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `development_goals` SET TAGS ('dbx_business_glossary_term' = 'Development Goals');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Employee Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `emergency_contact_relationship` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Relationship');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `employment_status` SET TAGS ('dbx_business_glossary_term' = 'Employment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `employment_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|terminated|retired|deceased');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'permanent|casual|contract|temporary|seasonal|apprentice');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Employee First Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `high_potential_flag` SET TAGS ('dbx_business_glossary_term' = 'High Potential Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Hire Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `isps_clearance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Clearance Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Clearance Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_value_regex' = 'none|restricted|confidential|secret');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Employee Last Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `last_performance_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Performance Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `last_training_date` SET TAGS ('dbx_business_glossary_term' = 'Last Training Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `middle_name` SET TAGS ('dbx_business_glossary_term' = 'Employee Middle Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `middle_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `middle_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `mlc_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'MLC (Maritime Labour Convention) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `mobile_number` SET TAGS ('dbx_business_glossary_term' = 'Employee Mobile Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `mobile_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `mobile_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `mobility_preference` SET TAGS ('dbx_business_glossary_term' = 'Mobility Preference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `mobility_preference` SET TAGS ('dbx_value_regex' = 'local_only|regional|national|international');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `national_id_number` SET TAGS ('dbx_business_glossary_term' = 'National Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `national_id_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `national_id_number` SET TAGS ('dbx_pii_national_id' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `nationality` SET TAGS ('dbx_business_glossary_term' = 'Employee Nationality');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `nationality` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `nationality` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `nationality` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `next_training_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Training Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `oracle_hcm_employee_number` SET TAGS ('dbx_business_glossary_term' = 'Oracle HCM (Human Capital Management) Cloud Employee Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `oracle_hcm_employee_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `passport_number` SET TAGS ('dbx_business_glossary_term' = 'Passport Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `passport_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `passport_number` SET TAGS ('dbx_pii_passport' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `performance_rating` SET TAGS ('dbx_value_regex' = 'unsatisfactory|needs_improvement|meets_expectations|exceeds_expectations|outstanding');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Employee Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `preferred_name` SET TAGS ('dbx_business_glossary_term' = 'Employee Preferred Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `preferred_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `preferred_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `readiness_level_for_next_role` SET TAGS ('dbx_business_glossary_term' = 'Readiness Level for Next Role');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `readiness_level_for_next_role` SET TAGS ('dbx_value_regex' = 'not_ready|developing|ready_with_support|fully_ready|exceeds_requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `sap_hr_personnel_number` SET TAGS ('dbx_business_glossary_term' = 'SAP HR (Human Resources) Personnel Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `sap_hr_personnel_number` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `sid_number` SET TAGS ('dbx_business_glossary_term' = 'SID (Seafarer Identity Document) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `sid_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `sid_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `sid_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `skills_inventory` SET TAGS ('dbx_business_glossary_term' = 'Skills Inventory');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `succession_planning_designation` SET TAGS ('dbx_business_glossary_term' = 'Succession Planning Designation');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `succession_planning_designation` SET TAGS ('dbx_value_regex' = 'not_identified|identified|ready_now|ready_1_year|ready_2_years');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `union_code` SET TAGS ('dbx_business_glossary_term' = 'Union Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `union_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ALTER COLUMN `union_membership_flag` SET TAGS ('dbx_business_glossary_term' = 'Union Membership Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` SET TAGS ('dbx_subdomain' = 'personnel_records');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `reports_to_position_id` SET TAGS ('dbx_business_glossary_term' = 'Reports To Position Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `position_code` SET TAGS ('dbx_business_glossary_term' = 'Position Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `position_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `position_description` SET TAGS ('dbx_business_glossary_term' = 'Position Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'permanent|fixed_term|casual|contractor|seasonal');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `full_time_equivalent` SET TAGS ('dbx_business_glossary_term' = 'Full-Time Equivalent (FTE)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `grade_band` SET TAGS ('dbx_business_glossary_term' = 'Grade Band');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `grade_band` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `headcount_budget` SET TAGS ('dbx_business_glossary_term' = 'Headcount Budget');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `is_isps_designated` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Designated Position Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `is_management_position` SET TAGS ('dbx_business_glossary_term' = 'Management Position Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `is_operational_position` SET TAGS ('dbx_business_glossary_term' = 'Operational Position Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `is_safety_critical` SET TAGS ('dbx_business_glossary_term' = 'Safety-Critical Position Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `job_category` SET TAGS ('dbx_business_glossary_term' = 'Job Category');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `job_family` SET TAGS ('dbx_business_glossary_term' = 'Job Family');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `key_performance_indicators` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicators (KPIs)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `minimum_education_level` SET TAGS ('dbx_business_glossary_term' = 'Minimum Education Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `minimum_education_level` SET TAGS ('dbx_value_regex' = 'none|secondary|diploma|bachelor|master|doctorate');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `minimum_experience_years` SET TAGS ('dbx_business_glossary_term' = 'Minimum Experience Years');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `position_status` SET TAGS ('dbx_business_glossary_term' = 'Position Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `position_status` SET TAGS ('dbx_value_regex' = 'active|frozen|abolished|pending_approval');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `requires_medical_clearance` SET TAGS ('dbx_business_glossary_term' = 'Medical Clearance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `requires_medical_clearance` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `requires_medical_clearance` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `requires_security_clearance` SET TAGS ('dbx_business_glossary_term' = 'Security Clearance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Salary Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_currency_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_currency_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_range_maximum` SET TAGS ('dbx_business_glossary_term' = 'Salary Range Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_range_maximum` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_range_minimum` SET TAGS ('dbx_business_glossary_term' = 'Salary Range Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `salary_range_minimum` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_value_regex' = 'day_shift|night_shift|rotating_shift|on_call|fixed_hours|24_7_roster');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Position Title');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ALTER COLUMN `union_classification` SET TAGS ('dbx_business_glossary_term' = 'Union Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` SET TAGS ('dbx_subdomain' = 'personnel_records');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Organisational Unit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `parent_unit_org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Organisational Unit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `actual_headcount` SET TAGS ('dbx_business_glossary_term' = 'Actual Headcount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `attrition_count` SET TAGS ('dbx_business_glossary_term' = 'Attrition Count');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `budgeted_headcount` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Headcount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `capex_labour_budget` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Labour Budget');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `capex_labour_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `casual_headcount` SET TAGS ('dbx_business_glossary_term' = 'Casual Employee Headcount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `competency_framework` SET TAGS ('dbx_business_glossary_term' = 'Competency Framework');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `contract_headcount` SET TAGS ('dbx_business_glossary_term' = 'Contract Employee Headcount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_description` SET TAGS ('dbx_business_glossary_term' = 'Organisational Unit Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `headcount_variance` SET TAGS ('dbx_business_glossary_term' = 'Headcount Variance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `mlc_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Required');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `operational_area` SET TAGS ('dbx_business_glossary_term' = 'Operational Area');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `opex_labour_budget` SET TAGS ('dbx_business_glossary_term' = 'Operational Expenditure (OPEX) Labour Budget');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `opex_labour_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_status` SET TAGS ('dbx_business_glossary_term' = 'Organisational Unit Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `org_unit_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|planned|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `permanent_headcount` SET TAGS ('dbx_business_glossary_term' = 'Permanent Employee Headcount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `planning_period` SET TAGS ('dbx_business_glossary_term' = 'Workforce Planning Period');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `planning_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-(Q[1-4]|M(0[1-9]|1[0-2])|FY)$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `safety_critical_unit` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `union_representation` SET TAGS ('dbx_business_glossary_term' = 'Union Representation');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `unit_code` SET TAGS ('dbx_business_glossary_term' = 'Organisational Unit Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `unit_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `unit_name` SET TAGS ('dbx_business_glossary_term' = 'Organisational Unit Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `unit_type` SET TAGS ('dbx_business_glossary_term' = 'Organisational Unit Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ALTER COLUMN `vacancy_count` SET TAGS ('dbx_business_glossary_term' = 'Vacancy Count');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` SET TAGS ('dbx_subdomain' = 'stevedore_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Home Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `labour_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Labour Agreement Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Home Berth Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Supervisor Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `average_experience_years` SET TAGS ('dbx_business_glossary_term' = 'Average Gang Member Experience Years');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `cargo_type_specialisation` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Specialisation');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_code` SET TAGS ('dbx_business_glossary_term' = 'Gang Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `competency_review_date` SET TAGS ('dbx_business_glossary_term' = 'Gang Competency Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_description` SET TAGS ('dbx_business_glossary_term' = 'Gang Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `disbandment_date` SET TAGS ('dbx_business_glossary_term' = 'Gang Disbandment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Gang Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Gang Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `formation_date` SET TAGS ('dbx_business_glossary_term' = 'Gang Formation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_status` SET TAGS ('dbx_business_glossary_term' = 'Gang Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|disbanded|standby');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_type` SET TAGS ('dbx_business_glossary_term' = 'Gang Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_type` SET TAGS ('dbx_value_regex' = 'hatch_gang|crane_gang|lashing_gang|roro_gang|general_gang|mooring_gang');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `imdg_certified` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `is_multi_skilled` SET TAGS ('dbx_business_glossary_term' = 'Multi-Skilled Gang Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `is_permanent` SET TAGS ('dbx_business_glossary_term' = 'Permanent Gang Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `isps_cleared` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Cleared');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `max_complement` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gang Complement');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `max_continuous_work_hours` SET TAGS ('dbx_business_glossary_term' = 'Maximum Continuous Work Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `min_complement` SET TAGS ('dbx_business_glossary_term' = 'Minimum Gang Complement');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `mlc_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `mlc_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|under_review|exempt');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `gang_name` SET TAGS ('dbx_business_glossary_term' = 'Gang Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `navis_gang_code` SET TAGS ('dbx_business_glossary_term' = 'NAVIS N4 Gang Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Gang Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `operation_type` SET TAGS ('dbx_value_regex' = 'loading|discharge|loading_discharge|lashing|shifting');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `pay_grade_code` SET TAGS ('dbx_business_glossary_term' = 'Gang Pay Grade Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `pay_grade_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `productivity_target_moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Gang Productivity Target Moves Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `rest_period_hours` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Rest Period Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `safety_induction_current` SET TAGS ('dbx_business_glossary_term' = 'Safety Induction Current Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `sap_hr_gang_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Human Resources (HR) Gang Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `standard_complement` SET TAGS ('dbx_business_glossary_term' = 'Standard Gang Complement');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `terminal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ALTER COLUMN `union_affiliation_code` SET TAGS ('dbx_business_glossary_term' = 'Union Affiliation Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` SET TAGS ('dbx_subdomain' = 'stevedore_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `gang_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Assignment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Crane ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Foreman Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `tertiary_gang_approved_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Deployment Approved By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `tertiary_gang_approved_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `actual_finish_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Gang Finish Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `actual_start_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Gang Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Deployment Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'container|bulk|breakbulk|roro|liquid_bulk|project_cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `deployment_date` SET TAGS ('dbx_business_glossary_term' = 'Gang Deployment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `deployment_number` SET TAGS ('dbx_business_glossary_term' = 'Gang Deployment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `deployment_number` SET TAGS ('dbx_value_regex' = '^GD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `deployment_status` SET TAGS ('dbx_business_glossary_term' = 'Gang Deployment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `deployment_status` SET TAGS ('dbx_value_regex' = 'assigned|active|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `deployment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gang Deployment Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `gang_size_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Gang Complement Size');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `gang_size_planned` SET TAGS ('dbx_business_glossary_term' = 'Planned Gang Complement Size');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `gang_type` SET TAGS ('dbx_business_glossary_term' = 'Gang Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `gross_hours_worked` SET TAGS ('dbx_business_glossary_term' = 'Gross Hours Worked');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `hatch_number` SET TAGS ('dbx_business_glossary_term' = 'Vessel Hatch Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `hatch_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `imdg_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `is_overtime_approved` SET TAGS ('dbx_business_glossary_term' = 'Overtime Approved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `is_safety_incident` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `moves_completed` SET TAGS ('dbx_business_glossary_term' = 'Cargo Moves Completed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Moves Per Hour (MPH) Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `net_hours_worked` SET TAGS ('dbx_business_glossary_term' = 'Net Hours Worked');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Stevedoring Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `overtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Overtime Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `payroll_period_ref` SET TAGS ('dbx_business_glossary_term' = 'Payroll Period Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `payroll_period_ref` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `safety_incident_ref` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `safety_incident_ref` SET TAGS ('dbx_value_regex' = '^SI-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `scheduled_finish_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Gang Finish Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Gang Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `shift_type` SET TAGS ('dbx_business_glossary_term' = 'Shift Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `shift_type` SET TAGS ('dbx_value_regex' = 'day|afternoon|night|swing');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `stoppage_hours` SET TAGS ('dbx_business_glossary_term' = 'Stoppage Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `stoppage_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Stoppage Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `stoppage_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `teu_handled` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Units (TEU) Handled');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `teu_per_gang_hour` SET TAGS ('dbx_business_glossary_term' = 'TEU Per Gang Hour Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `tos_dispatch_ref` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operating System (TOS) Dispatch Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `tos_dispatch_ref` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `work_area_code` SET TAGS ('dbx_business_glossary_term' = 'Work Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ALTER COLUMN `work_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` SET TAGS ('dbx_subdomain' = 'stevedore_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `applicable_department` SET TAGS ('dbx_business_glossary_term' = 'Applicable Department');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `break_count` SET TAGS ('dbx_business_glossary_term' = 'Break Count');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `break_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Break Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `days_of_week` SET TAGS ('dbx_business_glossary_term' = 'Days of Week');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Shift Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `end_time` SET TAGS ('dbx_business_glossary_term' = 'Shift End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `enterprise_award_code` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Award Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `fatigue_risk_index` SET TAGS ('dbx_business_glossary_term' = 'Fatigue Risk Index');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `hcm_work_schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Oracle Human Capital Management (HCM) Work Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `is_break_paid` SET TAGS ('dbx_business_glossary_term' = 'Is Break Paid');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `is_overnight` SET TAGS ('dbx_business_glossary_term' = 'Is Overnight Shift');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `is_public_holiday_applicable` SET TAGS ('dbx_business_glossary_term' = 'Is Public Holiday Applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `job_family` SET TAGS ('dbx_business_glossary_term' = 'Job Family');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `max_crew_size` SET TAGS ('dbx_business_glossary_term' = 'Maximum Crew Size');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `min_crew_size` SET TAGS ('dbx_business_glossary_term' = 'Minimum Crew Size');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `mlc_compliant` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `mlc_max_hours_work_per_day` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Maximum Hours of Work Per Day');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `mlc_max_hours_work_per_week` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Maximum Hours of Work Per Week');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `mlc_min_rest_hours_per_day` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Minimum Rest Hours Per Day');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `mlc_min_rest_hours_per_week` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Minimum Rest Hours Per Week');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `ohs_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Occupational Health and Safety (OHS) Risk Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `ohs_risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `overtime_threshold_hours` SET TAGS ('dbx_business_glossary_term' = 'Overtime Threshold Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `paid_hours` SET TAGS ('dbx_business_glossary_term' = 'Paid Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `penalty_rate_code` SET TAGS ('dbx_business_glossary_term' = 'Penalty Rate Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `penalty_rate_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `required_certification_codes` SET TAGS ('dbx_business_glossary_term' = 'Required Certification Codes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `rotation_cycle_days` SET TAGS ('dbx_business_glossary_term' = 'Rotation Cycle (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `rotation_sequence` SET TAGS ('dbx_business_glossary_term' = 'Rotation Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `sap_work_schedule_variant` SET TAGS ('dbx_business_glossary_term' = 'SAP Work Schedule Variant');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `sap_work_schedule_variant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_category` SET TAGS ('dbx_business_glossary_term' = 'Shift Category');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_category` SET TAGS ('dbx_value_regex' = 'day|afternoon|night|early_morning|rotating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_code` SET TAGS ('dbx_business_glossary_term' = 'Shift Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_description` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_name` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_status` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|under_review|retired');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_type` SET TAGS ('dbx_business_glossary_term' = 'Shift Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `shift_type` SET TAGS ('dbx_value_regex' = 'regular|overtime|standby|call_out|rotating|split');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `standby_activation_notice_minutes` SET TAGS ('dbx_business_glossary_term' = 'Standby Activation Notice (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `start_time` SET TAGS ('dbx_business_glossary_term' = 'Shift Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` SET TAGS ('dbx_subdomain' = 'stevedore_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `roster_id` SET TAGS ('dbx_business_glossary_term' = 'Roster ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `advance_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Advance Notice Days');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Roster Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `approved_by_user` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `assignment_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `break_entitlement_minutes` SET TAGS ('dbx_business_glossary_term' = 'Break Entitlement (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `change_notes` SET TAGS ('dbx_business_glossary_term' = 'Roster Change Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Roster Change Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `change_reason` SET TAGS ('dbx_value_regex' = 'vessel_schedule_change|employee_unavailability|operational_requirement|mlc_compliance|gang_reallocation|other');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `competency_verified` SET TAGS ('dbx_business_glossary_term' = 'Competency Verified');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Roster Confirmed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `equipment_type_assigned` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Assigned');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `isps_clearance_required` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Clearance Required');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `mlc_min_rest_hours` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Minimum Rest Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `mlc_rest_hours_compliant` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Rest Hours Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `navis_work_queue_code` SET TAGS ('dbx_business_glossary_term' = 'NAVIS Work Queue ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `overtime_rate_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Overtime Rate Multiplier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `overtime_rate_multiplier` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `pay_grade_code` SET TAGS ('dbx_business_glossary_term' = 'Pay Grade Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `pay_grade_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Roster Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Roster Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `planned_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Planned Shift Duration (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `planned_end_time` SET TAGS ('dbx_business_glossary_term' = 'Planned Shift End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `planned_start_time` SET TAGS ('dbx_business_glossary_term' = 'Planned Shift Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `preceding_rest_hours` SET TAGS ('dbx_business_glossary_term' = 'Preceding Rest Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `published_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Roster Published Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `roster_number` SET TAGS ('dbx_business_glossary_term' = 'Roster Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `roster_number` SET TAGS ('dbx_value_regex' = '^RST-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `roster_status` SET TAGS ('dbx_business_glossary_term' = 'Roster Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `roster_status` SET TAGS ('dbx_value_regex' = 'draft|published|confirmed|cancelled|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `shift_type` SET TAGS ('dbx_business_glossary_term' = 'Shift Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `shift_type` SET TAGS ('dbx_value_regex' = 'regular|overtime|standby|call_out|training|rest');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `sla_labour_readiness_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Labour Readiness (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'ORACLE_HCM|NAVIS_N4|SAP_HR|MANUAL');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `source_system_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ALTER COLUMN `work_order_reference` SET TAGS ('dbx_business_glossary_term' = 'Work Order Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` SET TAGS ('dbx_subdomain' = 'stevedore_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `time_attendance_id` SET TAGS ('dbx_business_glossary_term' = 'Time and Attendance Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Operation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Stevedore Gang ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `leave_request_id` SET TAGS ('dbx_business_glossary_term' = 'Leave Request Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `payroll_run_id` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Job Role Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `roster_id` SET TAGS ('dbx_business_glossary_term' = 'Roster Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `absence_type` SET TAGS ('dbx_business_glossary_term' = 'Absence Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `absence_type` SET TAGS ('dbx_value_regex' = 'annual_leave|sick_leave|unpaid_leave|public_holiday|maternity_paternity|training');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `amendment_reason` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Attendance Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|disputed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `attendance_date` SET TAGS ('dbx_business_glossary_term' = 'Attendance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `attendance_status` SET TAGS ('dbx_business_glossary_term' = 'Attendance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `attendance_status` SET TAGS ('dbx_value_regex' = 'present|absent|late|early_departure|partial');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `biometric_verified` SET TAGS ('dbx_business_glossary_term' = 'Biometric Verification Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `biometric_verified` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `biometric_verified` SET TAGS ('dbx_pii_biometric' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `break_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Break Duration (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `break_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Break End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `break_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Break Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `clock_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Clock-In Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `clock_out_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Clock-Out Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `early_departure_minutes` SET TAGS ('dbx_business_glossary_term' = 'Early Departure (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `entry_method` SET TAGS ('dbx_business_glossary_term' = 'Time Entry Method');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `entry_method` SET TAGS ('dbx_value_regex' = 'rfid_scan|biometric|manual|mobile_app|supervisor_entry');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `gate_entry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Terminal Gate Entry Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `gate_exit_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Terminal Gate Exit Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `hours_worked` SET TAGS ('dbx_business_glossary_term' = 'Total Hours Worked');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `is_public_holiday` SET TAGS ('dbx_business_glossary_term' = 'Public Holiday Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `late_arrival_minutes` SET TAGS ('dbx_business_glossary_term' = 'Late Arrival (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `mlc_rest_hours_compliant` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Rest Hours Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `overtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Overtime Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `pay_period_code` SET TAGS ('dbx_business_glossary_term' = 'Pay Period Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `payroll_processed` SET TAGS ('dbx_business_glossary_term' = 'Payroll Processed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `rest_hours_before_shift` SET TAGS ('dbx_business_glossary_term' = 'Rest Hours Before Shift');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `rfid_badge_number` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Badge Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `rfid_badge_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `rfid_badge_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `scheduled_end_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Shift End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Shift Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `shift_type` SET TAGS ('dbx_business_glossary_term' = 'Shift Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `shift_type` SET TAGS ('dbx_value_regex' = 'day|afternoon|night|rotating|on_call|split');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `source_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` SET TAGS ('dbx_subdomain' = 'stevedore_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `leave_request_id` SET TAGS ('dbx_business_glossary_term' = 'Leave Request ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `primary_leave_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `primary_leave_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `primary_leave_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `actual_return_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Return Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Leave Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending|approved|rejected|cancelled|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Leave Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `approved_days` SET TAGS ('dbx_business_glossary_term' = 'Approved Leave Days');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `approved_end_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Leave End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `approved_start_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Leave Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `approver_comments` SET TAGS ('dbx_business_glossary_term' = 'Approver Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `employee_comments` SET TAGS ('dbx_business_glossary_term' = 'Employee Leave Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `gang_complement_affected` SET TAGS ('dbx_business_glossary_term' = 'Gang Complement Affected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `half_day_flag` SET TAGS ('dbx_business_glossary_term' = 'Half Day Leave Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `half_day_session` SET TAGS ('dbx_business_glossary_term' = 'Half Day Session');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `half_day_session` SET TAGS ('dbx_value_regex' = 'morning|afternoon');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `handover_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Handover Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `leave_balance_at_request` SET TAGS ('dbx_business_glossary_term' = 'Leave Balance at Time of Request');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `leave_category` SET TAGS ('dbx_business_glossary_term' = 'Leave Category');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `leave_category` SET TAGS ('dbx_value_regex' = 'paid|unpaid|partially_paid');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `leave_loading_applicable` SET TAGS ('dbx_business_glossary_term' = 'Leave Loading Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `leave_type` SET TAGS ('dbx_business_glossary_term' = 'Leave Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `leave_year` SET TAGS ('dbx_business_glossary_term' = 'Leave Year');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `medical_certificate_received` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Received Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `medical_certificate_received` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `medical_certificate_received` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `medical_certificate_required` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `medical_certificate_required` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `medical_certificate_required` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `mlc_shore_leave_flag` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Shore Leave Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `operational_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `payroll_period` SET TAGS ('dbx_business_glossary_term' = 'Payroll Period');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `payroll_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Leave Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Leave Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `request_number` SET TAGS ('dbx_business_glossary_term' = 'Leave Request Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `request_number` SET TAGS ('dbx_value_regex' = '^LR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `requested_days` SET TAGS ('dbx_business_glossary_term' = 'Requested Leave Days');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `requested_end_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Leave End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `requested_start_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Leave Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_value_regex' = 'day|night|rotating|swing');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `source_system_ref` SET TAGS ('dbx_business_glossary_term' = 'Source System Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Leave Request Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`leave_request` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `payroll_run_id` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `reversed_run_payroll_run_id` SET TAGS ('dbx_business_glossary_term' = 'Reversed Payroll Run ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payroll Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `bank_file_reference` SET TAGS ('dbx_business_glossary_term' = 'Bank Payment File Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `bank_submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Bank Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `gross_pay_total` SET TAGS ('dbx_business_glossary_term' = 'Gross Pay Total');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `gross_pay_total` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `headcount_errors` SET TAGS ('dbx_business_glossary_term' = 'Headcount Errors');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `headcount_processed` SET TAGS ('dbx_business_glossary_term' = 'Headcount Processed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `mlc_compliant` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `net_pay_total` SET TAGS ('dbx_business_glossary_term' = 'Net Pay Total');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `net_pay_total` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `oracle_hcm_batch_code` SET TAGS ('dbx_business_glossary_term' = 'Oracle HCM Cloud Batch ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_business_glossary_term' = 'Pay Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_value_regex' = 'weekly|fortnightly|monthly|bi-monthly');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `pay_group_code` SET TAGS ('dbx_business_glossary_term' = 'Pay Group Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `pay_group_description` SET TAGS ('dbx_business_glossary_term' = 'Pay Group Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `payroll_area_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Payroll Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `payroll_area_description` SET TAGS ('dbx_business_glossary_term' = 'Payroll Area Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `payroll_period_code` SET TAGS ('dbx_business_glossary_term' = 'Payroll Period Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `payslips_generated` SET TAGS ('dbx_business_glossary_term' = 'Payslips Generated Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Payroll Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Payroll Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `posted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payroll Posted Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Reversal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `run_execution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Execution Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `run_notes` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `run_status` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `run_status` SET TAGS ('dbx_value_regex' = 'draft|in_progress|completed|approved|posted|reversed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `run_type` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `run_type` SET TAGS ('dbx_value_regex' = 'regular|off-cycle|supplemental|correction|final');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_allowances` SET TAGS ('dbx_business_glossary_term' = 'Total Allowances');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_allowances` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_base_pay` SET TAGS ('dbx_business_glossary_term' = 'Total Base Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_base_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_deductions` SET TAGS ('dbx_business_glossary_term' = 'Total Deductions');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_deductions` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_employer_contributions` SET TAGS ('dbx_business_glossary_term' = 'Total Employer Contributions');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_employer_contributions` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_overtime_pay` SET TAGS ('dbx_business_glossary_term' = 'Total Overtime Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_overtime_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_pension_deductions` SET TAGS ('dbx_business_glossary_term' = 'Total Pension Deductions');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_pension_deductions` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_tax_withheld` SET TAGS ('dbx_business_glossary_term' = 'Total Tax Withheld');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_tax_withheld` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_union_dues` SET TAGS ('dbx_business_glossary_term' = 'Total Union Dues');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `total_union_dues` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payroll_run` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payslip_id` SET TAGS ('dbx_business_glossary_term' = 'Payslip ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payroll_run_id` SET TAGS ('dbx_business_glossary_term' = 'Payroll Run ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `bank_account_reference` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `bank_account_reference` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `bank_account_reference` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `base_pay` SET TAGS ('dbx_business_glossary_term' = 'Base Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `base_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `base_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `danger_allowance` SET TAGS ('dbx_business_glossary_term' = 'Danger Allowance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `danger_allowance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `danger_allowance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employee_full_name` SET TAGS ('dbx_business_glossary_term' = 'Employee Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employee_full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employee_full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employer_pension_contribution` SET TAGS ('dbx_business_glossary_term' = 'Employer Pension Contribution');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employer_pension_contribution` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'permanent|casual|contract|fixed-term|apprentice');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `gross_pay` SET TAGS ('dbx_business_glossary_term' = 'Gross Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `gross_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `gross_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `income_tax_deduction` SET TAGS ('dbx_business_glossary_term' = 'Income Tax Deduction');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `income_tax_deduction` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `income_tax_deduction` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `is_mlc_compliant` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `issue_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payslip Issue Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `leave_hours_taken` SET TAGS ('dbx_business_glossary_term' = 'Leave Hours Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `leave_loading_pay` SET TAGS ('dbx_business_glossary_term' = 'Leave Loading Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `leave_loading_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `leave_loading_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `meal_allowance` SET TAGS ('dbx_business_glossary_term' = 'Meal Allowance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `meal_allowance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `meal_allowance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `national_id_number` SET TAGS ('dbx_business_glossary_term' = 'National Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `national_id_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `national_id_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `net_pay` SET TAGS ('dbx_business_glossary_term' = 'Net Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `net_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `net_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ordinary_hours_worked` SET TAGS ('dbx_business_glossary_term' = 'Ordinary Hours Worked');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `other_deductions` SET TAGS ('dbx_business_glossary_term' = 'Other Deductions');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `other_deductions` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `other_deductions` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `overtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Overtime Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `overtime_pay` SET TAGS ('dbx_business_glossary_term' = 'Overtime Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `overtime_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `overtime_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_business_glossary_term' = 'Pay Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pay_frequency` SET TAGS ('dbx_value_regex' = 'weekly|fortnightly|monthly|bi-monthly');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pay_grade` SET TAGS ('dbx_business_glossary_term' = 'Pay Grade');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pay_grade` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pay_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Pay Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pay_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Pay Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|cheque|cash|digital_wallet');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payroll_area` SET TAGS ('dbx_business_glossary_term' = 'Payroll Area');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payslip_number` SET TAGS ('dbx_business_glossary_term' = 'Payslip Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payslip_number` SET TAGS ('dbx_value_regex' = '^PS-[0-9]{4}-[0-9]{2}-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payslip_status` SET TAGS ('dbx_business_glossary_term' = 'Payslip Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `payslip_status` SET TAGS ('dbx_value_regex' = 'draft|generated|issued|cancelled|reissued');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pension_deduction` SET TAGS ('dbx_business_glossary_term' = 'Pension / Superannuation Deduction');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pension_deduction` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `pension_deduction` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `shift_allowance` SET TAGS ('dbx_business_glossary_term' = 'Shift Allowance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `shift_allowance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `shift_allowance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `tax_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `total_deductions` SET TAGS ('dbx_business_glossary_term' = 'Total Deductions');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `total_deductions` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `total_deductions` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `union_dues_deduction` SET TAGS ('dbx_business_glossary_term' = 'Union Dues Deduction');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `union_dues_deduction` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `union_dues_deduction` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_gross_pay` SET TAGS ('dbx_business_glossary_term' = 'Year-to-Date Gross Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_gross_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_gross_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_net_pay` SET TAGS ('dbx_business_glossary_term' = 'Year-to-Date Net Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_net_pay` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_net_pay` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_tax_deduction` SET TAGS ('dbx_business_glossary_term' = 'Year-to-Date Tax Deduction');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_tax_deduction` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`payslip` ALTER COLUMN `ytd_tax_deduction` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_id` SET TAGS ('dbx_business_glossary_term' = 'Competency ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `applicable_job_family` SET TAGS ('dbx_business_glossary_term' = 'Applicable Job Family');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `approved_training_provider` SET TAGS ('dbx_business_glossary_term' = 'Approved Training Provider');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `assessment_method` SET TAGS ('dbx_business_glossary_term' = 'Assessment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_category` SET TAGS ('dbx_business_glossary_term' = 'Competency Category');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_code` SET TAGS ('dbx_business_glossary_term' = 'Competency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_status` SET TAGS ('dbx_business_glossary_term' = 'Competency Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_status` SET TAGS ('dbx_value_regex' = 'active|inactive|superseded|draft|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_type` SET TAGS ('dbx_business_glossary_term' = 'Competency Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_type` SET TAGS ('dbx_value_regex' = 'operational_licence|safety_certification|regulatory_certificate|trade_qualification|medical_certificate');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `cost_to_obtain` SET TAGS ('dbx_business_glossary_term' = 'Cost to Obtain');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `cost_to_obtain` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_description` SET TAGS ('dbx_business_glossary_term' = 'Competency Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `digital_certificate_supported` SET TAGS ('dbx_business_glossary_term' = 'Digital Certificate Supported');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `external_reference_number` SET TAGS ('dbx_business_glossary_term' = 'External Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `imo_model_course_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Model Course Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `imo_model_course_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}.[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `is_mandatory_isps` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory under International Ship and Port Facility Security (ISPS) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `is_mandatory_mlc` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory under Maritime Labour Convention (MLC)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `is_mandatory_stcw` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory under Standards of Training Certification and Watchkeeping (STCW)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `is_renewable` SET TAGS ('dbx_business_glossary_term' = 'Is Renewable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `issuing_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `issuing_authority_type` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `issuing_authority_type` SET TAGS ('dbx_value_regex' = 'imo|national_maritime_authority|port_authority|industry_body|vocational_body|internal');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `level_descriptor` SET TAGS ('dbx_business_glossary_term' = 'Competency Level Descriptor');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `level_descriptor` SET TAGS ('dbx_value_regex' = 'management_level|operational_level|support_level|awareness_level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `medical_standard_ref` SET TAGS ('dbx_business_glossary_term' = 'Medical Standard Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `medical_standard_ref` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `medical_standard_ref` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `minimum_proficiency_level` SET TAGS ('dbx_business_glossary_term' = 'Minimum Proficiency Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `mutual_recognition_flag` SET TAGS ('dbx_business_glossary_term' = 'Mutual Recognition Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `competency_name` SET TAGS ('dbx_business_glossary_term' = 'Competency Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `prerequisite_competency_codes` SET TAGS ('dbx_business_glossary_term' = 'Prerequisite Competency Codes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `proficiency_scale` SET TAGS ('dbx_business_glossary_term' = 'Proficiency Scale');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `proficiency_scale` SET TAGS ('dbx_value_regex' = 'pass_fail|level_1_5|awareness|working|practitioner|expert');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `psc_recognised` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Recognised');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Framework');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `renewal_requirements` SET TAGS ('dbx_business_glossary_term' = 'Renewal Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `revalidation_sea_service_days` SET TAGS ('dbx_business_glossary_term' = 'Revalidation Sea Service Requirement (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'oracle_hcm|sap_hr|manual|navis_n4');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `stcw_regulation_ref` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training Certification and Watchkeeping (STCW) Regulation Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `training_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Training Duration (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `validity_period_months` SET TAGS ('dbx_business_glossary_term' = 'Validity Period (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Competency Version');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `employee_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Certification ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Qualification Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `competency_id` SET TAGS ('dbx_business_glossary_term' = 'Competency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `assessment_result` SET TAGS ('dbx_business_glossary_term' = 'Assessment Result');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `assessment_result` SET TAGS ('dbx_value_regex' = 'pass|fail|distinction|credit|competent|not_yet_competent');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `assessment_score` SET TAGS ('dbx_business_glossary_term' = 'Assessment Score');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `authorised_vessel_types` SET TAGS ('dbx_business_glossary_term' = 'Authorised Vessel Types');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `certificate_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-/]{6,30}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `certification_name` SET TAGS ('dbx_business_glossary_term' = 'Certification Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'valid|expired|suspended|pending_renewal|revoked|pending_verification');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_business_glossary_term' = 'Certification Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_value_regex' = 'operational_licence|safety_certification|regulatory_certificate|trade_qualification|medical_fitness|security_clearance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `deployment_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Deployment Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `examining_physician_name` SET TAGS ('dbx_business_glossary_term' = 'Examining Physician Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `examining_physician_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `fitness_outcome` SET TAGS ('dbx_business_glossary_term' = 'Fitness Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `fitness_outcome` SET TAGS ('dbx_value_regex' = 'fit_for_duty|fit_with_restrictions|temporarily_unfit|permanently_unfit');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `fitness_outcome` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `fitness_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Fitness Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `fitness_restrictions` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `isps_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `last_renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Last Renewal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `mandatory_flag` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `maximum_dwt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum DWT (Deadweight Tonnage) Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `maximum_loa_metres` SET TAGS ('dbx_business_glossary_term' = 'Maximum LOA (Length Overall) Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `medical_examination_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Examination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `medical_examination_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `medical_examination_date` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `medical_fitness_standard` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `medical_fitness_standard` SET TAGS ('dbx_value_regex' = 'MLC_ENG1|ISO_45001|national_OHS|port_authority_standard');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `medical_fitness_standard` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `medical_fitness_standard` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `mlc_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'MLC (Maritime Labour Convention) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `next_medical_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Medical Examination Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `next_medical_due_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `next_medical_due_date` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `next_renewal_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Renewal Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `pilot_licence_class` SET TAGS ('dbx_business_glossary_term' = 'Pilot Licence Class');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `pilot_licence_class` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `pilotage_area_code` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `pilotage_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `renewal_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `renewal_notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notification Sent Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `stcw_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'STCW (Standards of Training, Certification and Watchkeeping) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `training_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Training Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `training_provider` SET TAGS ('dbx_business_glossary_term' = 'Training Provider');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `verification_status` SET TAGS ('dbx_business_glossary_term' = 'Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'verified|unverified|verification_failed|verification_pending');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `training_course_id` SET TAGS ('dbx_business_glossary_term' = 'Training Course ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `competency_id` SET TAGS ('dbx_business_glossary_term' = 'Linked Competency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Course Owner Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Venue Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Training Facility Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `assessment_method` SET TAGS ('dbx_business_glossary_term' = 'Assessment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `assessment_method` SET TAGS ('dbx_value_regex' = 'written_exam|practical_test|observation|simulation|project|none');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `certificate_validity_months` SET TAGS ('dbx_business_glossary_term' = 'Certificate Validity Months');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `certification_issued_flag` SET TAGS ('dbx_business_glossary_term' = 'Certification Issued Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `compliance_framework` SET TAGS ('dbx_business_glossary_term' = 'Compliance Framework');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_code` SET TAGS ('dbx_business_glossary_term' = 'Course Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Course Cost Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_language` SET TAGS ('dbx_business_glossary_term' = 'Course Language');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_language` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_materials_provided_flag` SET TAGS ('dbx_business_glossary_term' = 'Course Materials Provided Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_objectives` SET TAGS ('dbx_business_glossary_term' = 'Course Objectives');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_status` SET TAGS ('dbx_business_glossary_term' = 'Course Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|retired|draft');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_title` SET TAGS ('dbx_business_glossary_term' = 'Course Title');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_type` SET TAGS ('dbx_business_glossary_term' = 'Course Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `course_type` SET TAGS ('dbx_value_regex' = 'induction|safety|technical|leadership|regulatory|compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `delivery_mode` SET TAGS ('dbx_business_glossary_term' = 'Delivery Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `delivery_mode` SET TAGS ('dbx_value_regex' = 'classroom|e-learning|on-the-job|simulator|blended');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Duration Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `mandatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `maximum_enrolment` SET TAGS ('dbx_business_glossary_term' = 'Maximum Enrolment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `passing_score_percentage` SET TAGS ('dbx_business_glossary_term' = 'Passing Score Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `provider_name` SET TAGS ('dbx_business_glossary_term' = 'Provider Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `provider_type` SET TAGS ('dbx_business_glossary_term' = 'Provider Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `provider_type` SET TAGS ('dbx_value_regex' = 'internal|external|vendor|industry_body');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `refresher_course_flag` SET TAGS ('dbx_business_glossary_term' = 'Refresher Course Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `target_audience` SET TAGS ('dbx_business_glossary_term' = 'Target Audience');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `venue_type` SET TAGS ('dbx_business_glossary_term' = 'Venue Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ALTER COLUMN `venue_type` SET TAGS ('dbx_value_regex' = 'on_site|off_site|online|field|simulator_facility');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_enrolment_id` SET TAGS ('dbx_business_glossary_term' = 'Training Enrolment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Job Role Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `primary_training_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `primary_training_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `primary_training_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_course_id` SET TAGS ('dbx_business_glossary_term' = 'Training Course ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `assessment_result` SET TAGS ('dbx_business_glossary_term' = 'Assessment Result');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `assessment_result` SET TAGS ('dbx_value_regex' = 'pass|fail|incomplete|not_assessed|pending');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `assessment_score` SET TAGS ('dbx_business_glossary_term' = 'Assessment Score');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `attendance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Attendance Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `certification_issued_flag` SET TAGS ('dbx_business_glossary_term' = 'Certification Issued Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `competency_code` SET TAGS ('dbx_business_glossary_term' = 'Competency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `employee_comments` SET TAGS ('dbx_business_glossary_term' = 'Employee Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `enrolment_date` SET TAGS ('dbx_business_glossary_term' = 'Enrolment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `enrolment_number` SET TAGS ('dbx_business_glossary_term' = 'Enrolment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `enrolment_source` SET TAGS ('dbx_business_glossary_term' = 'Enrolment Source');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `enrolment_source` SET TAGS ('dbx_value_regex' = 'employee_request|manager_nomination|mandatory_compliance|talent_development|succession_planning|performance_improvement');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `enrolment_status` SET TAGS ('dbx_business_glossary_term' = 'Enrolment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `mandatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `mlc_compliant` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `passing_score_threshold` SET TAGS ('dbx_business_glossary_term' = 'Passing Score Threshold');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `recertification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Recertification Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `scheduled_end_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `scheduled_start_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `trainer_feedback` SET TAGS ('dbx_business_glossary_term' = 'Trainer Feedback');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Training Cost Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Training Delivery Method');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_delivery_method` SET TAGS ('dbx_value_regex' = 'classroom|online|blended|on_the_job|workshop|webinar');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_hours` SET TAGS ('dbx_business_glossary_term' = 'Training Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_platform` SET TAGS ('dbx_business_glossary_term' = 'Training Platform');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `training_venue` SET TAGS ('dbx_business_glossary_term' = 'Training Venue');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `withdrawal_date` SET TAGS ('dbx_business_glossary_term' = 'Withdrawal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_enrolment` ALTER COLUMN `withdrawal_reason` SET TAGS ('dbx_business_glossary_term' = 'Withdrawal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `performance_review_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `calibration_session_id` SET TAGS ('dbx_business_glossary_term' = 'Calibration Session ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Job Role Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewer Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `acknowledgement_status` SET TAGS ('dbx_business_glossary_term' = 'Employee Acknowledgement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `acknowledgement_status` SET TAGS ('dbx_value_regex' = 'pending|acknowledged|disputed|escalated');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `acknowledgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Employee Acknowledgement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `bonus_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Bonus Eligibility Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `bonus_eligibility_flag` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `compensation_adjustment_percentage` SET TAGS ('dbx_business_glossary_term' = 'Compensation Adjustment Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `compensation_adjustment_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `compensation_adjustment_recommended` SET TAGS ('dbx_business_glossary_term' = 'Compensation Adjustment Recommended Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `compensation_adjustment_recommended` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `competency_rating` SET TAGS ('dbx_business_glossary_term' = 'Competency Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `competency_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `development_plan_summary` SET TAGS ('dbx_business_glossary_term' = 'Development Plan Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_comments` SET TAGS ('dbx_business_glossary_term' = 'Employee Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `employee_self_assessment` SET TAGS ('dbx_business_glossary_term' = 'Employee Self Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `goal_achievement_rating` SET TAGS ('dbx_business_glossary_term' = 'Goal Achievement Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `goal_achievement_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `high_potential_flag` SET TAGS ('dbx_business_glossary_term' = 'High Potential Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `leadership_rating` SET TAGS ('dbx_business_glossary_term' = 'Leadership Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `leadership_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `mlc_compliance_rating` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `mlc_compliance_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `next_review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `operational_efficiency_rating` SET TAGS ('dbx_business_glossary_term' = 'Operational Efficiency Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `operational_efficiency_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `oracle_hcm_review_code` SET TAGS ('dbx_business_glossary_term' = 'Oracle HCM (Human Capital Management) Cloud Review ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `overall_performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `overall_performance_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `overall_rating_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Rating Score');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `pay_grade_code` SET TAGS ('dbx_business_glossary_term' = 'Pay Grade Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `pay_grade_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `performance_improvement_plan_flag` SET TAGS ('dbx_business_glossary_term' = 'Performance Improvement Plan (PIP) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `promotion_readiness_flag` SET TAGS ('dbx_business_glossary_term' = 'Promotion Readiness Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `review_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Review Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `review_number` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `review_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Review Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `review_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Review Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `review_status` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `review_type` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `review_type` SET TAGS ('dbx_value_regex' = 'annual|mid_year|probationary|post_incident|project_completion|promotion');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `reviewer_comments` SET TAGS ('dbx_business_glossary_term' = 'Reviewer Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `safety_compliance_rating` SET TAGS ('dbx_business_glossary_term' = 'Safety Compliance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `safety_compliance_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `succession_candidate_flag` SET TAGS ('dbx_business_glossary_term' = 'Succession Candidate Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `teamwork_collaboration_rating` SET TAGS ('dbx_business_glossary_term' = 'Teamwork and Collaboration Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `teamwork_collaboration_rating` SET TAGS ('dbx_value_regex' = 'exceeds_expectations|meets_expectations|needs_improvement|unsatisfactory|outstanding');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `training_recommendations` SET TAGS ('dbx_business_glossary_term' = 'Training Recommendations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`performance_review` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` SET TAGS ('dbx_subdomain' = 'employee_relations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `disciplinary_case_id` SET TAGS ('dbx_business_glossary_term' = 'Disciplinary Case ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `disciplinary_last_updated_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Last Updated By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `disciplinary_last_updated_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `disciplinary_last_updated_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `primary_disciplinary_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `primary_disciplinary_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `primary_disciplinary_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `tertiary_disciplinary_hearing_officer_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Hearing Officer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `tertiary_disciplinary_hearing_officer_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `tertiary_disciplinary_hearing_officer_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `allegation_category` SET TAGS ('dbx_business_glossary_term' = 'Allegation Category');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `allegation_details` SET TAGS ('dbx_business_glossary_term' = 'Allegation Details');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `allegation_details` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `appeal_decision_date` SET TAGS ('dbx_business_glossary_term' = 'Appeal Decision Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `appeal_filed_date` SET TAGS ('dbx_business_glossary_term' = 'Appeal Filed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `appeal_filed_flag` SET TAGS ('dbx_business_glossary_term' = 'Appeal Filed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `appeal_outcome` SET TAGS ('dbx_business_glossary_term' = 'Appeal Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `appeal_outcome` SET TAGS ('dbx_value_regex' = 'upheld|overturned|modified|pending');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `case_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Case Closure Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `case_opened_date` SET TAGS ('dbx_business_glossary_term' = 'Case Opened Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `case_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Case Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `case_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[0-9]{4,8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `case_status` SET TAGS ('dbx_business_glossary_term' = 'Case Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `case_type` SET TAGS ('dbx_business_glossary_term' = 'Case Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `case_type` SET TAGS ('dbx_value_regex' = 'disciplinary|grievance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'standard|high|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `employee_representation_type` SET TAGS ('dbx_business_glossary_term' = 'Employee Representation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `employee_representation_type` SET TAGS ('dbx_value_regex' = 'none|union_representative|legal_counsel|colleague|other');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `escalated_to_tribunal_flag` SET TAGS ('dbx_business_glossary_term' = 'Escalated to Tribunal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `hearing_conducted_date` SET TAGS ('dbx_business_glossary_term' = 'Hearing Conducted Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `hearing_scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Hearing Scheduled Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `incident_date` SET TAGS ('dbx_business_glossary_term' = 'Incident Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `initiator_type` SET TAGS ('dbx_business_glossary_term' = 'Initiator Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `initiator_type` SET TAGS ('dbx_value_regex' = 'employer|employee');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `investigation_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `investigation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `investigation_status` SET TAGS ('dbx_business_glossary_term' = 'Investigation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `investigation_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `isps_security_related_flag` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Related Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `mlc_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `outcome_decision` SET TAGS ('dbx_business_glossary_term' = 'Outcome Decision');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `outcome_details` SET TAGS ('dbx_business_glossary_term' = 'Outcome Details');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `outcome_details` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `representative_name` SET TAGS ('dbx_business_glossary_term' = 'Representative Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `representative_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `safety_incident_related_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Related Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Severity Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'minor|moderate|serious|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `suspension_end_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `suspension_paid_flag` SET TAGS ('dbx_business_glossary_term' = 'Suspension Paid Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `suspension_start_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `tribunal_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Tribunal Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`disciplinary_case` ALTER COLUMN `warning_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warning Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` SET TAGS ('dbx_subdomain' = 'employee_relations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `grievance_case_id` SET TAGS ('dbx_business_glossary_term' = 'Grievance Case Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `tertiary_grievance_union_representative_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Union Representative Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `tertiary_grievance_union_representative_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `tertiary_grievance_union_representative_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `tertiary_quinary_grievance_corrective_action_owner_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Owner Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `tertiary_quinary_grievance_corrective_action_owner_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `tertiary_quinary_grievance_corrective_action_owner_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `assigned_investigator_name` SET TAGS ('dbx_business_glossary_term' = 'Assigned Investigator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `case_number` SET TAGS ('dbx_business_glossary_term' = 'Grievance Case Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `case_number` SET TAGS ('dbx_value_regex' = '^GRV-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `case_status` SET TAGS ('dbx_business_glossary_term' = 'Grievance Case Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Case Closed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `employee_satisfaction_rating` SET TAGS ('dbx_business_glossary_term' = 'Employee Satisfaction Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `escalated_flag` SET TAGS ('dbx_business_glossary_term' = 'Escalated Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `escalation_body` SET TAGS ('dbx_business_glossary_term' = 'Escalation Body');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `escalation_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Escalation Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `finding_outcome` SET TAGS ('dbx_business_glossary_term' = 'Finding Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `finding_outcome` SET TAGS ('dbx_value_regex' = 'substantiated|partially_substantiated|unsubstantiated|inconclusive');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `grievance_category` SET TAGS ('dbx_business_glossary_term' = 'Grievance Category');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `grievance_category` SET TAGS ('dbx_value_regex' = 'individual|collective|formal|informal');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `grievance_description` SET TAGS ('dbx_business_glossary_term' = 'Grievance Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `grievance_type` SET TAGS ('dbx_business_glossary_term' = 'Grievance Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `incident_date` SET TAGS ('dbx_business_glossary_term' = 'Incident Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `incident_location` SET TAGS ('dbx_business_glossary_term' = 'Incident Location');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `investigation_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `investigation_findings` SET TAGS ('dbx_business_glossary_term' = 'Investigation Findings');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `investigation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Investigation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `lodged_date` SET TAGS ('dbx_business_glossary_term' = 'Grievance Lodged Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `lodged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Grievance Lodged Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `mlc_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `mlc_standard_reference` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Standard Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Grievance Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `resolution_description` SET TAGS ('dbx_business_glossary_term' = 'Resolution Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `resolution_outcome` SET TAGS ('dbx_business_glossary_term' = 'Resolution Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `resolution_outcome` SET TAGS ('dbx_value_regex' = 'upheld|partially_upheld|dismissed|withdrawn|settled');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `respondent_name` SET TAGS ('dbx_business_glossary_term' = 'Respondent Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `respondent_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `respondent_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `union_representative_name` SET TAGS ('dbx_business_glossary_term' = 'Union Representative Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `union_representative_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `union_representative_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `witness_names` SET TAGS ('dbx_business_glossary_term' = 'Witness Names');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `witness_names` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`grievance_case` ALTER COLUMN `witness_names` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` SET TAGS ('dbx_subdomain' = 'employee_relations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `mlc_compliance_record_id` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `accommodation_standard_met` SET TAGS ('dbx_business_glossary_term' = 'Accommodation Standard Met');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `complaint_lodged` SET TAGS ('dbx_business_glossary_term' = 'Complaint Lodged');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `complaint_reference` SET TAGS ('dbx_business_glossary_term' = 'Complaint Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `compliance_area` SET TAGS ('dbx_business_glossary_term' = 'Compliance Area');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `compliance_record_number` SET TAGS ('dbx_business_glossary_term' = 'MLC Compliance Record Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `compliance_record_number` SET TAGS ('dbx_value_regex' = '^MLC-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non-compliant|pending review|under corrective action|exempted|not applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `corrective_action_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Completed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `corrective_action_verified_by` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Verified By');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `declaration_of_mlc_compliance_ref` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Maritime Labour Convention (MLC) Compliance Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `flag_state_code` SET TAGS ('dbx_business_glossary_term' = 'Flag State Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `flag_state_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `inspector_name` SET TAGS ('dbx_business_glossary_term' = 'Inspector Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `inspector_organization` SET TAGS ('dbx_business_glossary_term' = 'Inspector Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `medical_care_access_confirmed` SET TAGS ('dbx_business_glossary_term' = 'Medical Care Access Confirmed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `medical_care_access_confirmed` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `medical_care_access_confirmed` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `mlc_title` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Title');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `mlc_title` SET TAGS ('dbx_value_regex' = 'Title 1 - Minimum Requirements for Seafarers to Work on a Ship|Title 2 - Conditions of Employment|Title 3 - Accommodation, Recreational Facilities, Food and Catering|Title 4 - Health Protection, Medical Care, Welfare and Social Security Protection...');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `non_conformance_description` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `non_conformance_severity` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Severity');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `non_conformance_severity` SET TAGS ('dbx_value_regex' = 'critical|major|minor');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `psc_inspection_reference` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `record_created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `repatriation_security_held` SET TAGS ('dbx_business_glossary_term' = 'Repatriation Security Held');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `responsible_officer_email` SET TAGS ('dbx_business_glossary_term' = 'Responsible Officer Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `responsible_officer_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `responsible_officer_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `responsible_officer_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible Officer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `rest_hours_compliant` SET TAGS ('dbx_business_glossary_term' = 'Rest Hours Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `seafarer_employment_agreement_ref` SET TAGS ('dbx_business_glossary_term' = 'Seafarers Employment Agreement (SEA) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `social_security_coverage` SET TAGS ('dbx_business_glossary_term' = 'Social Security Coverage');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `social_security_coverage` SET TAGS ('dbx_value_regex' = 'full coverage|partial coverage|no coverage|exempted');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `social_security_coverage` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ALTER COLUMN `social_security_coverage` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` SET TAGS ('dbx_subdomain' = 'employee_relations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `labour_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Labour Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `superseded_agreement_labour_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `agreement_name` SET TAGS ('dbx_business_glossary_term' = 'Agreement Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Agreement Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'enterprise_bargaining_agreement|collective_labour_agreement|casual_hire_agreement|greenfields_agreement|individual_flexibility_arrangement|other');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `annual_leave_entitlement_days` SET TAGS ('dbx_business_glossary_term' = 'Annual Leave Entitlement Days');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `applicable_job_families` SET TAGS ('dbx_business_glossary_term' = 'Applicable Job Families');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `coverage_scope` SET TAGS ('dbx_business_glossary_term' = 'Coverage Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `dispute_resolution_process` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Process');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `document_reference_url` SET TAGS ('dbx_business_glossary_term' = 'Document Reference URL');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `employer_party_name` SET TAGS ('dbx_business_glossary_term' = 'Employer Party Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `fair_work_commission_approval_number` SET TAGS ('dbx_business_glossary_term' = 'Fair Work Commission Approval Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `fatigue_management_rules` SET TAGS ('dbx_business_glossary_term' = 'Fatigue Management Rules');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `gang_complement_minimum` SET TAGS ('dbx_business_glossary_term' = 'Gang Complement Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `key_terms_summary` SET TAGS ('dbx_business_glossary_term' = 'Key Terms Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `long_service_leave_threshold_years` SET TAGS ('dbx_business_glossary_term' = 'Long Service Leave Threshold Years');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `minimum_wage_rate` SET TAGS ('dbx_business_glossary_term' = 'Minimum Wage Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `minimum_wage_rate` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `minimum_wage_rate` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `mlc_rest_hours_minimum` SET TAGS ('dbx_business_glossary_term' = 'MLC (Maritime Labour Convention) Rest Hours Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `overtime_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Overtime Multiplier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `payroll_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Payroll Integration Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `penalty_rate_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Penalty Rate Multiplier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `ratification_date` SET TAGS ('dbx_business_glossary_term' = 'Ratification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `ratification_method` SET TAGS ('dbx_business_glossary_term' = 'Ratification Method');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `ratification_method` SET TAGS ('dbx_value_regex' = 'member_ballot|delegate_vote|fair_work_commission_approval|management_approval|other');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `redundancy_payment_formula` SET TAGS ('dbx_business_glossary_term' = 'Redundancy Payment Formula');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `renegotiation_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renegotiation Notice Days');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `renegotiation_trigger_date` SET TAGS ('dbx_business_glossary_term' = 'Renegotiation Trigger Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `sick_leave_entitlement_days` SET TAGS ('dbx_business_glossary_term' = 'Sick Leave Entitlement Days');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `union_dues_percentage` SET TAGS ('dbx_business_glossary_term' = 'Union Dues Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `union_party_name` SET TAGS ('dbx_business_glossary_term' = 'Union Party Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `wage_rate_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Wage Rate Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `wage_rate_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `wage_rate_currency_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ALTER COLUMN `wage_rate_currency_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` SET TAGS ('dbx_subdomain' = 'payroll_benefits');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `headcount_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `actual_headcount` SET TAGS ('dbx_business_glossary_term' = 'Actual Headcount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `actual_labour_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Labour Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `actual_labour_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `attrition_count` SET TAGS ('dbx_business_glossary_term' = 'Attrition Count');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `budgeted_headcount` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Headcount');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `budgeted_labour_cost` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Labour Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `budgeted_labour_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `employment_category` SET TAGS ('dbx_business_glossary_term' = 'Employment Category');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `employment_category` SET TAGS ('dbx_value_regex' = 'permanent|casual|contract|temporary|seasonal');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `employment_type` SET TAGS ('dbx_business_glossary_term' = 'Employment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `employment_type` SET TAGS ('dbx_value_regex' = 'full_time|part_time|shift_based|on_call');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `isps_clearance_required` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Clearance Required');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `job_family` SET TAGS ('dbx_business_glossary_term' = 'Job Family');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `mlc_compliant` SET TAGS ('dbx_business_glossary_term' = 'MLC (Maritime Labour Convention) Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `new_hire_count` SET TAGS ('dbx_business_glossary_term' = 'New Hire Count');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_notes` SET TAGS ('dbx_business_glossary_term' = 'Plan Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^HCP-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Headcount Plan Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|active|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `planned_throughput_teu` SET TAGS ('dbx_business_glossary_term' = 'Planned Throughput TEU (Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `planning_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `planning_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `position_type` SET TAGS ('dbx_business_glossary_term' = 'Position Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `productivity_target_teu_per_gang_hour` SET TAGS ('dbx_business_glossary_term' = 'Productivity Target TEU (Twenty-foot Equivalent Unit) per Gang Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `revision_reason` SET TAGS ('dbx_business_glossary_term' = 'Revision Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `snapshot_date` SET TAGS ('dbx_business_glossary_term' = 'Headcount Snapshot Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `terminal_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `vacancy_count` SET TAGS ('dbx_business_glossary_term' = 'Vacancy Count');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ALTER COLUMN `variance_headcount` SET TAGS ('dbx_business_glossary_term' = 'Headcount Variance');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` SET TAGS ('dbx_subdomain' = 'personnel_records');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `pilot_licence_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Licence ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `cruise_ship_endorsement` SET TAGS ('dbx_business_glossary_term' = 'Cruise Ship Endorsement');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `dangerous_goods_endorsement` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Endorsement');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `endorsement_notes` SET TAGS ('dbx_business_glossary_term' = 'Endorsement Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `imdg_classes_authorised` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Classes Authorised');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `issuing_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `last_renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Last Renewal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `licence_class` SET TAGS ('dbx_business_glossary_term' = 'Licence Class');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `licence_class` SET TAGS ('dbx_value_regex' = 'class_1|class_2|class_3|master|unlimited|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `licence_number` SET TAGS ('dbx_business_glossary_term' = 'Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `licence_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `licence_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `licence_status` SET TAGS ('dbx_business_glossary_term' = 'Licence Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `licence_status` SET TAGS ('dbx_value_regex' = 'active|suspended|expired|revoked|pending|inactive');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `lng_carrier_endorsement` SET TAGS ('dbx_business_glossary_term' = 'Liquefied Natural Gas (LNG) Carrier Endorsement');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `maximum_dwt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Deadweight Tonnage (DWT) Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `maximum_grt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gross Registered Tonnage (GRT) Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `maximum_loa_metres` SET TAGS ('dbx_business_glossary_term' = 'Maximum Length Overall (LOA) Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `medical_certificate_expiry_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `medical_certificate_reference` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `medical_certificate_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `next_renewal_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Renewal Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `night_pilotage_authorised` SET TAGS ('dbx_business_glossary_term' = 'Night Pilotage Authorised');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `pilotage_area_code` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `pilotage_area_description` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Area Description');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `restricted_visibility_authorised` SET TAGS ('dbx_business_glossary_term' = 'Restricted Visibility Authorised');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `revocation_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `stcw_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `stcw_endorsement_flag` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Endorsement Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `suspension_end_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `suspension_end_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `suspension_start_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `suspension_start_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `total_pilotage_acts` SET TAGS ('dbx_business_glossary_term' = 'Total Pilotage Acts');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ALTER COLUMN `vtms_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Management System (VTMS) Integration Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` SET TAGS ('dbx_subdomain' = 'personnel_records');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_fitness_id` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_fitness_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_fitness_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'OHS Manager Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `approved_by_ohs_manager` SET TAGS ('dbx_business_glossary_term' = 'Approved by Occupational Health and Safety (OHS) Manager Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `cardiovascular_assessment` SET TAGS ('dbx_business_glossary_term' = 'Cardiovascular Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `cardiovascular_assessment` SET TAGS ('dbx_value_regex' = 'normal|abnormal-minor|abnormal-significant|not-assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `cardiovascular_assessment` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `cardiovascular_assessment` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `certificate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `certificate_issued` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Issued Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Medical Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `certificate_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `confidentiality_classification` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `confidentiality_classification` SET TAGS ('dbx_value_regex' = 'restricted|confidential');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `drug_screening_conducted` SET TAGS ('dbx_business_glossary_term' = 'Drug Screening Conducted Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `drug_screening_result` SET TAGS ('dbx_business_glossary_term' = 'Drug Screening Result');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `drug_screening_result` SET TAGS ('dbx_value_regex' = 'negative|positive|inconclusive|not-tested');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `drug_screening_result` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `drug_screening_result` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_cost` SET TAGS ('dbx_business_glossary_term' = 'Medical Examination Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Examination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Examination Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_number` SET TAGS ('dbx_business_glossary_term' = 'Medical Examination Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_number` SET TAGS ('dbx_value_regex' = '^MED-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_status` SET TAGS ('dbx_business_glossary_term' = 'Medical Examination Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_status` SET TAGS ('dbx_value_regex' = 'scheduled|in-progress|completed|cancelled|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_type` SET TAGS ('dbx_business_glossary_term' = 'Medical Examination Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examination_type` SET TAGS ('dbx_value_regex' = 'pre-employment|periodic|return-to-work|fitness-for-duty|post-incident|random');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examining_physician_license_number` SET TAGS ('dbx_business_glossary_term' = 'Examining Physician License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examining_physician_license_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examining_physician_name` SET TAGS ('dbx_business_glossary_term' = 'Examining Physician Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `examining_physician_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `fitness_outcome` SET TAGS ('dbx_business_glossary_term' = 'Medical Fitness Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `fitness_outcome` SET TAGS ('dbx_value_regex' = 'fit|fit-with-restrictions|temporarily-unfit|permanently-unfit|pending-review');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `fitness_outcome` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `fitness_outcome` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `follow_up_details` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Details');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `follow_up_details` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `follow_up_details` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `hearing_test_result` SET TAGS ('dbx_business_glossary_term' = 'Hearing Test Result');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `hearing_test_result` SET TAGS ('dbx_value_regex' = 'pass|fail|corrected-pass|not-tested');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `hearing_test_result` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `hearing_test_result` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `isps_clearance_granted` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Clearance Granted Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Medical Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_facility_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_facility_name` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_standard_applied` SET TAGS ('dbx_business_glossary_term' = 'Medical Standard Applied');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_standard_applied` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `medical_standard_applied` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `mlc_compliant` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `musculoskeletal_assessment` SET TAGS ('dbx_business_glossary_term' = 'Musculoskeletal Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `musculoskeletal_assessment` SET TAGS ('dbx_value_regex' = 'normal|abnormal-minor|abnormal-significant|not-assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `musculoskeletal_assessment` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `musculoskeletal_assessment` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `next_examination_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Medical Examination Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `physical_fitness_assessment` SET TAGS ('dbx_business_glossary_term' = 'Physical Fitness Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `physical_fitness_assessment` SET TAGS ('dbx_value_regex' = 'excellent|good|satisfactory|below-standard|not-assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `physical_fitness_assessment` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `physical_fitness_assessment` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `physician_comments` SET TAGS ('dbx_business_glossary_term' = 'Physician Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `physician_comments` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `physician_comments` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `psychological_assessment_conducted` SET TAGS ('dbx_business_glossary_term' = 'Psychological Assessment Conducted Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `psychological_assessment_result` SET TAGS ('dbx_business_glossary_term' = 'Psychological Assessment Result');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `psychological_assessment_result` SET TAGS ('dbx_value_regex' = 'fit|fit-with-support|unfit|not-assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `psychological_assessment_result` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `psychological_assessment_result` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `record_retention_years` SET TAGS ('dbx_business_glossary_term' = 'Record Retention Years');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `respiratory_assessment` SET TAGS ('dbx_business_glossary_term' = 'Respiratory Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `respiratory_assessment` SET TAGS ('dbx_value_regex' = 'normal|abnormal-minor|abnormal-significant|not-assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `respiratory_assessment` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `respiratory_assessment` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_details` SET TAGS ('dbx_business_glossary_term' = 'Medical Restriction Details');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_details` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_details` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_end_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Restriction End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_end_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_end_date` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_start_date` SET TAGS ('dbx_business_glossary_term' = 'Medical Restriction Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_start_date` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `restriction_start_date` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `vision_test_result` SET TAGS ('dbx_business_glossary_term' = 'Vision Test Result');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `vision_test_result` SET TAGS ('dbx_value_regex' = 'pass|fail|corrected-pass|not-tested');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `vision_test_result` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`medical_fitness` ALTER COLUMN `vision_test_result` SET TAGS ('dbx_pii_health' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `talent_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Talent Profile ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Owner Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `primary_talent_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `primary_talent_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `primary_talent_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `career_aspiration` SET TAGS ('dbx_business_glossary_term' = 'Career Aspiration');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `critical_experience_gaps` SET TAGS ('dbx_business_glossary_term' = 'Critical Experience Gaps');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `development_goals` SET TAGS ('dbx_business_glossary_term' = 'Development Goals');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `development_priority` SET TAGS ('dbx_business_glossary_term' = 'Development Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `development_priority` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `education_level` SET TAGS ('dbx_business_glossary_term' = 'Education Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `impact_of_loss` SET TAGS ('dbx_business_glossary_term' = 'Impact of Loss');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `impact_of_loss` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Clearance Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `key_skills` SET TAGS ('dbx_business_glossary_term' = 'Key Skills');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `languages_spoken` SET TAGS ('dbx_business_glossary_term' = 'Languages Spoken');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `last_talent_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Talent Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `leadership_competencies` SET TAGS ('dbx_business_glossary_term' = 'Leadership Competencies');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `mentoring_status` SET TAGS ('dbx_business_glossary_term' = 'Mentoring Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `mentoring_status` SET TAGS ('dbx_value_regex' = 'active|completed|on_hold|not_assigned');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `mlc_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Compliance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `mlc_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `mobility_preference` SET TAGS ('dbx_business_glossary_term' = 'Mobility Preference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `mobility_preference` SET TAGS ('dbx_value_regex' = 'willing_to_relocate|local_only|regional|international|remote');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `next_talent_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Talent Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `performance_rating` SET TAGS ('dbx_value_regex' = 'exceptional|exceeds|meets|needs_improvement|unsatisfactory');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `potential_rating` SET TAGS ('dbx_business_glossary_term' = 'Potential Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `potential_rating` SET TAGS ('dbx_value_regex' = 'high|medium|low|not_assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `preferred_location` SET TAGS ('dbx_business_glossary_term' = 'Preferred Location');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `preferred_next_role` SET TAGS ('dbx_business_glossary_term' = 'Preferred Next Role');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `profile_notes` SET TAGS ('dbx_business_glossary_term' = 'Talent Profile Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `profile_notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `profile_number` SET TAGS ('dbx_business_glossary_term' = 'Talent Profile Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `profile_status` SET TAGS ('dbx_business_glossary_term' = 'Talent Profile Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `profile_status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|archived');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `risk_of_loss` SET TAGS ('dbx_business_glossary_term' = 'Risk of Loss');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `risk_of_loss` SET TAGS ('dbx_value_regex' = 'high|medium|low|none');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `stcw_certification_level` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Certification Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `succession_plan_role` SET TAGS ('dbx_business_glossary_term' = 'Succession Plan Role');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `succession_rank` SET TAGS ('dbx_business_glossary_term' = 'Succession Rank');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `succession_readiness_level` SET TAGS ('dbx_business_glossary_term' = 'Succession Readiness Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `succession_readiness_level` SET TAGS ('dbx_value_regex' = 'ready_now|ready_1_year|ready_2_3_years|not_ready|under_assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `talent_segment` SET TAGS ('dbx_business_glossary_term' = 'Talent Segment');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `talent_segment` SET TAGS ('dbx_value_regex' = 'key_talent|high_potential|successor|emerging_talent|core_performer|development_needed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `technical_competencies` SET TAGS ('dbx_business_glossary_term' = 'Technical Competencies');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `training_plan` SET TAGS ('dbx_business_glossary_term' = 'Training Plan');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `years_in_industry` SET TAGS ('dbx_business_glossary_term' = 'Years in Industry');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`talent_profile` ALTER COLUMN `years_in_organization` SET TAGS ('dbx_business_glossary_term' = 'Years in Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` SET TAGS ('dbx_subdomain' = 'talent_development');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` SET TAGS ('dbx_association_edges' = 'workforce.position,workforce.competency');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `position_competency_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Position Competency Requirement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `competency_id` SET TAGS ('dbx_business_glossary_term' = 'Position Competency Requirement - Competency Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `position_id` SET TAGS ('dbx_business_glossary_term' = 'Position Competency Requirement - Position Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `assessment_frequency` SET TAGS ('dbx_business_glossary_term' = 'Assessment Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Requirement Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Requirement Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `mandatory_flag` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `minimum_proficiency_level` SET TAGS ('dbx_business_glossary_term' = 'Minimum Proficiency Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Requirement Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `required_certifications` SET TAGS ('dbx_business_glossary_term' = 'Required Certifications');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `required_competencies` SET TAGS ('dbx_business_glossary_term' = 'Required Competencies');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `requirement_source` SET TAGS ('dbx_business_glossary_term' = 'Requirement Source');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position_competency_requirement` ALTER COLUMN `revalidation_required` SET TAGS ('dbx_business_glossary_term' = 'Revalidation Required');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` SET TAGS ('dbx_subdomain' = 'employee_relations');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_session_id` SET TAGS ('dbx_business_glossary_term' = 'Calibration Session Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_created_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_created_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_created_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_department_org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Department Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_facilitator_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Facilitator Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_facilitator_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_facilitator_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_modified_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_modified_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_modified_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `asset_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Business Unit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `prior_calibration_session_id` SET TAGS ('dbx_business_glossary_term' = 'Prior Calibration Session Id');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `prior_calibration_session_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `action_items` SET TAGS ('dbx_business_glossary_term' = 'Action Items');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `actual_end_time` SET TAGS ('dbx_business_glossary_term' = 'Actual End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `actual_start_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `calibration_methodology` SET TAGS ('dbx_business_glossary_term' = 'Calibration Methodology');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `consensus_achieved` SET TAGS ('dbx_business_glossary_term' = 'Consensus Achieved');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `decisions_made` SET TAGS ('dbx_business_glossary_term' = 'Decisions Made');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `decisions_made` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `escalation_required` SET TAGS ('dbx_business_glossary_term' = 'Escalation Required');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `hcm_system_reference` SET TAGS ('dbx_business_glossary_term' = 'Hcm System Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `meeting_location` SET TAGS ('dbx_business_glossary_term' = 'Meeting Location');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `meeting_mode` SET TAGS ('dbx_business_glossary_term' = 'Meeting Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `mlc_compliance_verified` SET TAGS ('dbx_business_glossary_term' = 'Mlc Compliance Verified');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `rating_scale_used` SET TAGS ('dbx_business_glossary_term' = 'Rating Scale Used');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `recording_storage_location` SET TAGS ('dbx_business_glossary_term' = 'Recording Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `recording_storage_location` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `review_cycle` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `review_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Review Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `review_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Review Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Date');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `scheduled_end_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_agenda` SET TAGS ('dbx_business_glossary_term' = 'Session Agenda');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_notes` SET TAGS ('dbx_business_glossary_term' = 'Session Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_number` SET TAGS ('dbx_business_glossary_term' = 'Session Number');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_objectives` SET TAGS ('dbx_business_glossary_term' = 'Session Objectives');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_recording_available` SET TAGS ('dbx_business_glossary_term' = 'Session Recording Available');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_status` SET TAGS ('dbx_business_glossary_term' = 'Session Status');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `session_type` SET TAGS ('dbx_business_glossary_term' = 'Session Type');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `target_distribution_applied` SET TAGS ('dbx_business_glossary_term' = 'Target Distribution Applied');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `total_employees_reviewed` SET TAGS ('dbx_business_glossary_term' = 'Total Employees Reviewed');
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ALTER COLUMN `total_participants` SET TAGS ('dbx_business_glossary_term' = 'Total Participants');
