-- Schema for Domain: finance | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:27

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`finance` COMMENT 'Manages general ledger, financial accounting (FI), controlling (CO), cost centres, budgeting, CAPEX/OPEX tracking, financial reporting, EBITDA analysis, accounts payable, and corporate financial planning. Integrates with SAP S/4HANA FI/CO modules for statutory and management reporting. SSOT for corporate financial data and management accounting.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` (
    `gl_account_id` BIGINT COMMENT 'Unique identifier for the general ledger account. Primary key.',
    `company_code_id` BIGINT COMMENT 'FK to finance.company_code',
    `account_category` STRING COMMENT 'The primary financial statement category to which this account belongs: balance sheet (B/S), profit and loss (P&L), cost element (CO), clearing, or statistical.. Valid values are `balance_sheet|profit_and_loss|cost_element|clearing|statistical`',
    `account_group` STRING COMMENT 'The hierarchical grouping or classification code used to organize accounts into logical segments for reporting and analysis (e.g., current assets, fixed assets, operating expenses).',
    `account_name` STRING COMMENT 'The full descriptive name of the general ledger account as it appears in financial reports and statements.',
    `account_number` STRING COMMENT 'The unique account code used in financial postings and reporting. This is the externally-known identifier used across all financial transactions and statutory reports.. Valid values are `^[0-9]{4,10}$`',
    `account_short_name` STRING COMMENT 'Abbreviated name or label for the account used in condensed reports and system displays.',
    `account_status` STRING COMMENT 'The current lifecycle status of the account: active (in use), inactive (not currently used but available), blocked (posting prohibited), or archived (historical only).. Valid values are `active|inactive|blocked|archived`',
    `account_type` STRING COMMENT 'The fundamental classification of the account indicating its role in the financial statements: asset, liability, equity, revenue, or expense.. Valid values are `asset|liability|equity|revenue|expense`',
    `alternative_account_number` STRING COMMENT 'An alternative or legacy account number used for mapping, migration, or integration purposes with external systems or previous chart of accounts structures.',
    `balance_sheet_classification` STRING COMMENT 'For balance sheet accounts, indicates whether the account is classified as current (short-term, within 12 months) or non-current (long-term, beyond 12 months).. Valid values are `current|non_current|not_applicable`',
    `chart_of_accounts` STRING COMMENT 'The chart of accounts code to which this account belongs. Defines the account structure and numbering scheme used by the organization.. Valid values are `^[A-Z0-9]{4}$`',
    `consolidation_account` STRING COMMENT 'The account number in the group consolidation chart of accounts to which this account maps for corporate consolidation and group reporting purposes.',
    `cost_center_required_flag` BOOLEAN COMMENT 'Indicates whether a cost center assignment is mandatory when posting to this account. True if cost center is required, false otherwise.',
    `cost_element_category` STRING COMMENT 'Indicates whether the account is a primary cost element (direct posting from FI), secondary cost element (internal allocations in CO), or not applicable for cost accounting purposes.. Valid values are `primary|secondary|not_applicable`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this account master record was first created in the system.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which this account is maintained (e.g., USD, EUR, GBP). For multi-currency environments, this defines the account currency.. Valid values are `^[A-Z]{3}$`',
    `field_status_group` STRING COMMENT 'The field status variant code that controls which fields are required, optional, or suppressed when posting to this account.',
    `financial_statement_item` STRING COMMENT 'The line item code on the financial statement (balance sheet or income statement) to which this account maps for statutory and management reporting.',
    `functional_area_required_flag` BOOLEAN COMMENT 'Indicates whether a functional area (e.g., operations, administration, sales) must be specified when posting to this account for segment reporting purposes.',
    `house_bank_required_flag` BOOLEAN COMMENT 'Indicates whether a house bank (company bank account) must be specified when posting to this account, typically for cash and bank accounts.',
    `inflation_key` STRING COMMENT 'The key used for inflation accounting adjustments in hyperinflationary economies, as required by IAS 29.',
    `interest_calculation_indicator` STRING COMMENT 'Indicates whether interest should be calculated on balances in this account for interest on arrears, interest on deposits, or other interest calculation purposes.. Valid values are `calculate|do_not_calculate`',
    `last_modified_by` STRING COMMENT 'The user ID or name of the person who last modified this account master record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this account master record was last modified.',
    `line_item_display_flag` BOOLEAN COMMENT 'Indicates whether individual line item details are stored and can be displayed for this account. True if line item management is active, false if only totals are maintained.',
    `open_item_management_flag` BOOLEAN COMMENT 'Indicates whether open item management is active for this account, requiring postings to be cleared (e.g., for clearing accounts, receivables, payables).',
    `planning_blocked_flag` BOOLEAN COMMENT 'Indicates whether planning and budgeting activities are blocked for this account. True if planning is not allowed, false if planning is permitted.',
    `posting_blocked_flag` BOOLEAN COMMENT 'Indicates whether direct postings to this account are currently blocked. True if posting is not allowed, false if posting is permitted.',
    `profit_center_required_flag` BOOLEAN COMMENT 'Indicates whether a profit center assignment is mandatory when posting to this account. True if profit center is required, false otherwise.',
    `reconciliation_account_flag` BOOLEAN COMMENT 'Indicates whether this is a reconciliation account (subledger control account) that summarizes detailed transactions from subsidiary ledgers such as accounts receivable or accounts payable.',
    `segment_required_flag` BOOLEAN COMMENT 'Indicates whether a segment assignment is mandatory when posting to this account for segment reporting under IFRS 8 or management reporting requirements.',
    `sort_key` STRING COMMENT 'The default sort field used for organizing and displaying line items within this account (e.g., posting date, document number, reference).',
    `tax_category` STRING COMMENT 'The tax treatment category for this account: input tax (VAT/GST on purchases), output tax (VAT/GST on sales), non-taxable, exempt, or not applicable.. Valid values are `input_tax|output_tax|non_taxable|exempt|not_applicable`',
    `tolerance_group` STRING COMMENT 'The tolerance group code that defines permissible payment differences, exchange rate differences, and cash discount limits for this account.',
    `trading_partner_required_flag` BOOLEAN COMMENT 'Indicates whether a trading partner (intercompany counterparty) must be specified when posting to this account for intercompany elimination and consolidation purposes.',
    `valid_from_date` DATE COMMENT 'The date from which this account definition becomes effective and available for posting.',
    `valid_to_date` DATE COMMENT 'The date until which this account definition remains effective. Null indicates the account is valid indefinitely.',
    `valuation_group` STRING COMMENT 'The grouping code used for asset valuation, inventory valuation, or other valuation purposes in financial and management accounting.',
    `created_by` STRING COMMENT 'The user ID or name of the person who created this account master record in the system.',
    CONSTRAINT pk_gl_account PRIMARY KEY(`gl_account_id`)
) COMMENT 'General Ledger (GL) chart of accounts master for the port authority. Defines every account code used in financial accounting (FI) including P&L accounts, balance sheet accounts, cost accounts, and clearing accounts. Sourced from SAP S/4HANA FI module. SSOT for account structure used across all financial postings, statutory reporting, and management accounting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` (
    `cost_centre_id` BIGINT COMMENT 'Unique identifier for the cost centre. Primary key for the cost centre master data entity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every cost centre belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can remai',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Cost centers map to organizational units for budget ownership, headcount planning, management reporting, and organizational hierarchy navigation — fundamental finance-HR integration for port terminal ',
    `parent_cost_centre_id` BIGINT COMMENT 'Reference to the parent cost centre in the organizational hierarchy. Enables roll-up reporting from operational teams to divisional and corporate levels for consolidated management accounting.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Port cost centres are tied to physical locations (berths, terminals, yards) for operational cost tracking, location-based P&L reporting, and terminal profitability analysis. Essential for berth-level ',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Security zones incur direct operational costs (personnel wages, equipment maintenance, utilities) that must be allocated to cost centres for budget tracking, variance analysis, and departmental P&L re',
    `activity_type` STRING COMMENT 'The primary activity type or service output produced by this cost centre for activity-based costing. Examples include TEU handled, vessel movements, maintenance hours, or administrative transactions.',
    `annual_budget_amount` DECIMAL(18,2) COMMENT 'The approved annual operating expenditure (OPEX) budget allocated to this cost centre for the current fiscal year. Used for budget vs. actual variance analysis and cost control.',
    `budget_version` STRING COMMENT 'Version identifier for the budget (e.g., original budget, revised budget, forecast). Enables tracking of budget changes and multiple planning scenarios throughout the fiscal year.. Valid values are `^[A-Z0-9]{1,3}$`',
    `business_area_code` STRING COMMENT 'Business area code for cross-company code reporting and segment analysis. Enables financial reporting by business segment (e.g., container terminal, bulk cargo, cruise operations) independent of legal entity structure.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_centre_category` STRING COMMENT 'Functional category grouping cost centres by business domain. Aligns with port operational divisions including terminal operations, marine services (pilotage, towage), infrastructure maintenance, port security (ISPS compliance), administration, commercial and tariffs, finance, human resources, information technology, and safety and environment management. [ENUM-REF-CANDIDATE: terminal_operations|marine_services|infrastructure_maintenance|port_security|administration|commercial|finance|hr|it|safety_environment — 10 candidates stripped; promote to reference product]',
    `cost_centre_code` STRING COMMENT 'The externally-known unique alphanumeric code identifying the cost centre in financial systems and reports. Used as the business identifier across SAP FI/CO modules and management accounting reports.. Valid values are `^[A-Z0-9]{4,10}$`',
    `controlling_area_code` STRING COMMENT 'The SAP Controlling (CO) area code to which this cost centre belongs. Controlling area represents the highest organizational unit in management accounting, typically aligned with the legal entity or port authority.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_allocation_method` STRING COMMENT 'The method used to allocate overhead costs to or from this cost centre. Direct allocation assigns costs directly, activity-based uses cost drivers, proportional uses percentage splits, fixed percentage uses predetermined rates, and driver-based uses volume or activity metrics.. Valid values are `direct|activity_based|proportional|fixed_percentage|driver_based`',
    `cost_centre_status` STRING COMMENT 'Current lifecycle status of the cost centre. Active centres accept cost postings, inactive centres are closed but retain historical data, blocked centres temporarily cannot accept postings, and planned centres are approved but not yet operational.. Valid values are `active|inactive|blocked|planned`',
    `cost_centre_type` STRING COMMENT 'Classification of the cost centre by its primary business function. Operational centres directly support port operations (terminal, marine services), administrative centres support corporate functions, service centres provide internal services, infrastructure centres manage assets, revenue centres generate income, and support centres provide enabling functions.. Valid values are `operational|administrative|service|infrastructure|revenue|support`',
    `cost_element_group` STRING COMMENT 'Primary cost element group or category associated with this cost centres typical expenditure pattern (e.g., personnel costs, equipment maintenance, utilities, contracted services). Used for cost structure analysis.',
    `created_by_user` STRING COMMENT 'User ID or username of the person who created this cost centre record. Used for audit trail and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this cost centre record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the cost centres operating currency. Used for budget planning, cost allocation, and financial reporting in the cost centres functional currency.. Valid values are `^[A-Z]{3}$`',
    `department_code` STRING COMMENT 'Department code representing the organizational unit within the port authority structure. Used for grouping cost centres by functional department for reporting and analysis.. Valid values are `^[A-Z0-9]{3,6}$`',
    `cost_centre_description` STRING COMMENT 'Extended textual description of the cost centres purpose, scope of operations, and key responsibilities. Provides additional context beyond the cost centre name for reporting and analysis.',
    `external_reference_code` STRING COMMENT 'External system identifier or reference code for integration with other financial or operational systems (e.g., NAVIS N4 billing module, Maximo asset management). Enables cross-system reconciliation and data lineage.',
    `fiscal_year` STRING COMMENT 'The fiscal year for which the cost centre budget and planning data applies. Typically a four-digit year (e.g., 2024) aligned with the port authoritys financial calendar.',
    `hierarchy_level` STRING COMMENT 'The level of this cost centre in the organizational hierarchy. Level 1 represents corporate/port authority level, level 2 represents divisions, level 3 represents departments, and deeper levels represent teams or operational units.',
    `is_overhead_centre` BOOLEAN COMMENT 'Boolean flag indicating whether this cost centre is an overhead or support centre that allocates costs to other operational cost centres. True for administrative, IT, HR, and other support functions that do not directly generate revenue.',
    `is_revenue_generating` BOOLEAN COMMENT 'Boolean flag indicating whether this cost centre directly generates revenue through billable services or operations. True for terminal operations, marine services, and other revenue-producing activities.',
    `last_modified_by_user` STRING COMMENT 'User ID or username of the person who last modified this cost centre record. Used for audit trail and accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this cost centre record was last updated. Used for change tracking and audit trail.',
    `lock_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether the cost centre is locked for cost postings. True prevents new transactions from being posted, typically used during period-end closing or when restructuring the cost centre hierarchy.',
    `cost_centre_name` STRING COMMENT 'The full descriptive name of the cost centre representing the organisational unit or functional area (e.g., Container Terminal Operations, Marine Pilotage Services, Port Security Division).',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special instructions related to the cost centre. Used for documenting organizational changes, budget adjustments, or operational context.',
    `profit_centre_code` STRING COMMENT 'The profit centre to which this cost centre is assigned for internal profitability analysis. Profit centres represent revenue-generating or cost-responsible units for management reporting and EBITDA analysis.. Valid values are `^[A-Z0-9]{4,10}$`',
    `statistical_cost_centre` BOOLEAN COMMENT 'Boolean flag indicating whether this is a statistical cost centre used only for reporting and analysis purposes without accepting actual cost postings. True for virtual or analytical groupings.',
    `valid_from_date` DATE COMMENT 'The date from which this cost centre record becomes effective and can accept cost postings. Used for time-dependent organizational changes and cost centre lifecycle management.',
    `valid_to_date` DATE COMMENT 'The date until which this cost centre record is valid. After this date, the cost centre cannot accept new cost postings. Null value indicates the cost centre is open-ended and currently active.',
    CONSTRAINT pk_cost_centre PRIMARY KEY(`cost_centre_id`)
) COMMENT 'Controlling (CO) cost centre master representing organisational units to which costs are assigned and tracked. Covers terminal operations, marine services, infrastructure maintenance, port security, administration, and corporate functions. Enables OPEX tracking, budget vs. actual variance analysis, overhead allocation, and management reporting by organisational unit. Hierarchy supports roll-up from operational teams to divisional and corporate levels. Sourced from SAP CO module. SSOT for cost centre structure used across all management accounting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` (
    `profit_centre_id` BIGINT COMMENT 'Unique identifier for the profit centre. Primary key for the profit centre master data entity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every profit centre belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can rem',
    `cost_centre_id` BIGINT COMMENT 'Reference to the default cost centre associated with this profit centre for overhead allocation and cost tracking purposes.',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Profit centers align with operational org units (terminal divisions, business lines, service verticals) for P&L accountability, resource allocation, and performance management in maritime business uni',
    `parent_profit_centre_id` BIGINT COMMENT 'Reference to the parent profit centre in the hierarchy for roll-up reporting and consolidation. Null for top-level profit centres.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Profit centres in ports are structured by terminal/berth location for revenue and margin analysis. Required for terminal P&L statements, location-based performance reporting, and investment decisions ',
    `activation_date` DATE COMMENT 'The date when this profit centre was first activated and became operational for financial postings.',
    `analysis_period` STRING COMMENT 'The fiscal period for which this profit centre configuration is valid, in format YYYY.PPP (e.g., 2024.001 for period 1 of fiscal year 2024). Supports period-dependent profit centre attributes.. Valid values are `^[0-9]{4}.[0-9]{3}$`',
    `budget_profile` STRING COMMENT 'The budget profile or planning template assigned to this profit centre, defining the budgeting methodology and approval workflow for CAPEX and OPEX planning.',
    `business_unit` STRING COMMENT 'The higher-level business unit or division to which this profit centre is assigned within the organizational hierarchy.',
    `profit_centre_code` STRING COMMENT 'The externally-known unique alphanumeric code identifying the profit centre in SAP CO module and management reports. Used as the business identifier for segment reporting and EBITDA analysis.. Valid values are `^[A-Z0-9]{4,10}$`',
    `consolidation_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this profit centre participates in group consolidation and elimination processes. True if consolidated, False if standalone reporting only.',
    `controlling_area` STRING COMMENT 'The SAP Controlling (CO) area code representing the organizational unit for which cost accounting and profitability analysis is performed. Typically aligned with legal entity or geographic region.. Valid values are `^[A-Z0-9]{4}$`',
    `country_code` STRING COMMENT 'The three-letter ISO 3166-1 alpha-3 country code where this profit centre is domiciled for regulatory and tax reporting purposes.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this profit centre master record was first created in the system, in ISO 8601 format.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which this profit centres financial results are reported (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `deactivation_date` DATE COMMENT 'The date when this profit centre was deactivated or closed. Null for currently active profit centres.',
    `department_code` STRING COMMENT 'The department or operational unit code associated with this profit centre for organizational reporting and workforce allocation.',
    `profit_centre_description` STRING COMMENT 'Detailed textual description of the profit centres business scope, services provided, and operational responsibilities for documentation and reporting purposes.',
    `ebitda_reporting_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this profit centre is included in EBITDA analysis and segment reporting. True if included in EBITDA calculations, False if excluded.',
    `functional_area` STRING COMMENT 'The functional classification of the profit centre (e.g., Operations, Sales, Administration, Maintenance) used for functional cost analysis and reporting.',
    `geographic_region` STRING COMMENT 'The geographic region or territory in which this profit centre operates (e.g., Asia Pacific, Europe, Americas) for regional performance analysis.',
    `hierarchy_level` STRING COMMENT 'The level of this profit centre within the organizational hierarchy (e.g., 1 for top-level, 2 for sub-level), used for hierarchical reporting and drill-down analysis.',
    `intercompany_trading_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this profit centre engages in intercompany transactions requiring transfer pricing and elimination entries. True if intercompany trading is enabled.',
    `last_modified_by` STRING COMMENT 'The username or employee ID of the user who last modified this profit centre master record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this profit centre master record was last modified, in ISO 8601 format. Used for change tracking and audit purposes.',
    `lock_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this profit centre is locked for new postings. True if locked (no new transactions allowed), False if open for postings.',
    `profit_centre_name` STRING COMMENT 'The full business name of the profit centre (e.g., Container Terminal Operations, Bulk Cargo Services, Marine Pilotage Services, Property and Leasing).',
    `planning_level` STRING COMMENT 'The planning granularity level for this profit centre: strategic (long-term corporate planning), tactical (annual budgeting), or operational (monthly/quarterly forecasting).. Valid values are `strategic|tactical|operational`',
    `profit_centre_group` STRING COMMENT 'The profit centre group or hierarchy node to which this profit centre belongs, enabling roll-up reporting and consolidated EBITDA analysis across multiple profit centres.',
    `profit_centre_status` STRING COMMENT 'Current lifecycle status of the profit centre: active (operational and posting-enabled), inactive (closed but retained for historical reporting), blocked (temporarily suspended), or planned (future profit centre not yet operational).. Valid values are `active|inactive|blocked|planned`',
    `profit_centre_type` STRING COMMENT 'Classification of the profit centre by its business function: operating (revenue-generating business units), service (internal service providers), administrative (overhead functions), investment (capital projects), holding (consolidation entities), or dummy (technical/system entities).. Valid values are `operating|service|administrative|investment|holding|dummy`',
    `responsible_person_email` STRING COMMENT 'The email address of the profit centre manager for financial reporting and performance review communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `responsible_person_name` STRING COMMENT 'The name of the manager or executive accountable for the financial performance and operational results of this profit centre.',
    `segment_code` STRING COMMENT 'The business segment or service line code to which this profit centre belongs (e.g., CONT for container terminal, BULK for bulk cargo, MARINE for marine services, PROP for property). Used for segment reporting under IFRS 8.. Valid values are `^[A-Z0-9]{2,6}$`',
    `short_name` STRING COMMENT 'Abbreviated name or acronym for the profit centre used in reports and dashboards for space-constrained displays.',
    `source_system_code` STRING COMMENT 'The unique identifier of this profit centre in the source system, used for data lineage and reconciliation with upstream systems.',
    `tax_jurisdiction` STRING COMMENT 'The tax jurisdiction or authority under which this profit centre operates for corporate income tax and indirect tax reporting purposes.',
    `valid_from_date` DATE COMMENT 'The date from which this profit centre becomes effective and can be used for financial postings and reporting. Supports time-dependent profit centre master data.',
    `valid_to_date` DATE COMMENT 'The date until which this profit centre remains valid. Null for open-ended profit centres. Used to manage profit centre lifecycle and historical reporting.',
    `created_by` STRING COMMENT 'The username or employee ID of the user who created this profit centre master record in the system.',
    CONSTRAINT pk_profit_centre PRIMARY KEY(`profit_centre_id`)
) COMMENT 'SAP CO profit centre master representing business segments or service lines (e.g., container terminal, bulk cargo, marine services, property) for which profitability is measured independently. Enables EBITDA analysis by business unit, segment reporting, and management P&L. SSOT for profit centre hierarchy used in management accounting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` (
    `internal_order_id` BIGINT COMMENT 'Unique identifier for the internal order record. Primary key for the internal order entity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every internal order belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can re',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Internal orders are owned by organizational units for budget control, project portfolio management, resource planning, and organizational performance tracking in port capital and operational projects.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Internal orders for maintenance, repairs, or operational projects are tied to specific port locations. Required for maintenance cost tracking by berth/terminal and work order management by facility.',
    `profit_centre_id` BIGINT COMMENT 'Identifier of the profit centre responsible for this internal order. Used for management accounting and profitability analysis by operational unit or service line.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Port internal orders (equipment maintenance, dredging, terminal upgrades) trigger procurement. Tracks PO commitments against internal order budgets for capital project cost control and variance analys',
    `purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: Requisitions for internal orders (maintenance campaigns, special projects) require internal order reference for cost tracking. Enables internal order procurement initiation and budget control workflow',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Internal orders (capex projects, maintenance work, operational initiatives) are initiated by specific employees; tracking requestor is essential for approval workflow, budget accountability, and proje',
    `cost_centre_id` BIGINT COMMENT 'Identifier of the cost centre responsible for managing and controlling costs for this internal order. Links to the organizational unit accountable for budget execution.',
    `actual_cost_amount` DECIMAL(18,2) COMMENT 'Total actual costs posted to the internal order from invoices, time sheets, material issues, and other cost postings. Represents realized expenditure to date.',
    `actual_end_date` DATE COMMENT 'Actual date when work was completed under this internal order. Captures real project completion for schedule variance analysis and closeout.',
    `actual_start_date` DATE COMMENT 'Actual date when work commenced under this internal order. Captures real project start for schedule variance analysis.',
    `approval_authority` STRING COMMENT 'Name or title of the executive or governance body that approved the internal order budget (e.g., CFO, Board of Directors, CAPEX Committee). Captures accountability for investment decision.',
    `approval_date` DATE COMMENT 'Date when the internal order budget was formally approved by the designated authority. Marks the start of authorized spending.',
    `approved_budget_amount` DECIMAL(18,2) COMMENT 'Formally approved budget amount for the internal order following Capital Appropriation Request (CAR) or budget approval process. Represents authorized spending limit.',
    `asset_class` STRING COMMENT 'SAP asset class code for CAPEX orders that will be capitalized. Defines the type of fixed asset being created (e.g., Buildings, Machinery, IT Equipment) and controls depreciation rules.',
    `business_area` STRING COMMENT 'SAP business area code for segment reporting, representing the line of business or operational division (e.g., Container Terminal, Bulk Cargo, Marine Services). Enables EBITDA analysis by business segment.',
    `car_number` STRING COMMENT 'Unique identifier for the Capital Appropriation Request document associated with this internal order. Links the order to the formal CAPEX approval process for governance and audit trail.. Valid values are `^CAR-[0-9]{6,10}$`',
    `committed_amount` DECIMAL(18,2) COMMENT 'Total amount committed through purchase orders, contracts, or reservations against this internal order. Represents obligations not yet invoiced.',
    `controlling_area` STRING COMMENT 'SAP Controlling Area code representing the organizational unit for cost accounting. Typically aligns with the legal entity or business unit managing the internal order.. Valid values are `^[A-Z0-9]{4}$`',
    `created_by_user` STRING COMMENT 'User ID or name of the person who created this internal order record in the system. Audit trail for accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this internal order record was first created in the system. Audit trail for order initiation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this internal order (e.g., USD, EUR, GBP). All budget, commitment, and actual amounts are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `environmental_impact_flag` BOOLEAN COMMENT 'Indicates whether this internal order involves activities with potential environmental impact requiring Environmental Management System (EMS) oversight, permits, or MARPOL compliance. True if environmental assessment is required.',
    `final_closure_date` DATE COMMENT 'Date when the internal order was fully closed in SAP CO, preventing any further transactions. Marks administrative and financial closure of the order.',
    `functional_area` STRING COMMENT 'SAP functional area code for cost-of-sales accounting, classifying costs by business function (e.g., Operations, Administration, Sales, Maintenance). Supports functional P&L reporting.',
    `investment_program` STRING COMMENT 'Name or code of the strategic investment program or portfolio to which this internal order belongs (e.g., Terminal Expansion 2024, Green Port Initiative, Digital Transformation). Groups related CAPEX projects for executive reporting.',
    `last_modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this internal order record. Audit trail for change accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this internal order record was last modified. Audit trail for change tracking.',
    `long_description` STRING COMMENT 'Detailed business description of the internal order scope, objectives, and deliverables. Provides comprehensive context for cost tracking and project governance.',
    `order_category` STRING COMMENT 'Business classification of the internal order by investment or activity category: infrastructure for port facilities, equipment for handling machinery, technology for IT/OT systems, dredging for channel maintenance, environmental for compliance projects, safety for OHS initiatives, administrative for overhead. [ENUM-REF-CANDIDATE: infrastructure|equipment|technology|dredging|environmental|safety|administrative — 7 candidates stripped; promote to reference product]',
    `order_number` STRING COMMENT 'Business identifier for the internal order, typically assigned by SAP CO module. Used for cost tracking and budget control across port infrastructure projects, equipment procurement, and operational campaigns.. Valid values are `^[A-Z0-9]{8,12}$`',
    `order_status` STRING COMMENT 'Current lifecycle status of the internal order. Created indicates initial setup, released allows cost posting, technically completed stops new postings but allows settlement, closed finalizes the order, locked prevents any changes.. Valid values are `created|released|technically_completed|closed|locked`',
    `order_type` STRING COMMENT 'Classification of the internal order by purpose: capital for CAPEX investments, operational for short-term activities, maintenance for asset upkeep campaigns, project for specific initiatives, campaign for time-bound programmes, overhead for administrative costs.. Valid values are `capital|operational|maintenance|project|campaign|overhead`',
    `planned_end_date` DATE COMMENT 'Planned date for completion of work or activities under this internal order. Used for project scheduling and milestone tracking.',
    `planned_start_date` DATE COMMENT 'Planned date for commencement of work or activities under this internal order. Used for project scheduling and resource planning.',
    `planning_budget_amount` DECIMAL(18,2) COMMENT 'Initial budget amount allocated to the internal order during planning phase, before formal approval. Represents preliminary cost estimate for the project or activity.',
    `priority_level` STRING COMMENT 'Business priority classification for this internal order: critical for safety/regulatory/revenue-critical projects, high for strategic initiatives, medium for planned improvements, low for discretionary activities. Influences resource allocation and approval speed.. Valid values are `critical|high|medium|low`',
    `project_phase` STRING COMMENT 'Current phase of the project lifecycle for this internal order. Tracks progression through planning, design, procurement, construction, commissioning, and closeout stages for infrastructure and equipment projects.. Valid values are `planning|design|procurement|construction|commissioning|closeout`',
    `requesting_department` STRING COMMENT 'Name or code of the business department that initiated the internal order request (e.g., Terminal Operations, Marine Services, Infrastructure Development).',
    `responsible_person_email` STRING COMMENT 'Email address of the individual responsible for this internal order. Used for notifications, approvals, and budget alerts.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `responsible_person_name` STRING COMMENT 'Name of the individual responsible for managing and controlling this internal order (project manager, cost centre manager, or activity owner). Accountable for budget execution and deliverables.',
    `risk_category` STRING COMMENT 'Risk assessment classification for this internal order based on complexity, value, technical uncertainty, and business impact. Determines governance oversight and approval thresholds.. Valid values are `low|medium|high|very_high`',
    `safety_critical_flag` BOOLEAN COMMENT 'Indicates whether this internal order involves safety-critical infrastructure, equipment, or activities requiring Occupational Health and Safety (OHS) oversight and SOLAS compliance. True if safety assessment is required.',
    `settlement_profile` STRING COMMENT 'SAP CO settlement profile code defining how costs accumulated on this internal order are settled to receiving cost objects (assets, cost centres, GL accounts). Controls period-end cost allocation rules.',
    `settlement_receiver_reference` STRING COMMENT 'Identifier of the specific cost object (asset number, cost centre code, GL account, WBS element) that receives settled costs from this internal order. Used for period-end cost allocation.',
    `settlement_receiver_type` STRING COMMENT 'Type of cost object that receives settled costs from this internal order: asset for capitalization, cost_centre for expense allocation, gl_account for direct posting, wbs_element for project integration.. Valid values are `asset|cost_centre|gl_account|wbs_element`',
    `short_description` STRING COMMENT 'Brief business description of the internal order purpose, typically 40-60 characters summarizing the project or activity (e.g., Berth 5 Crane Replacement, Q2 Dredging Campaign).',
    `technical_completion_date` DATE COMMENT 'Date when the internal order was technically completed in SAP CO, preventing new cost postings but allowing settlement and final adjustments. Marks operational closure of the order.',
    CONSTRAINT pk_internal_order PRIMARY KEY(`internal_order_id`)
) COMMENT 'SAP CO internal order and capital appropriation request (CAR) record used to track costs, budgets, and approvals for specific projects, CAPEX initiatives, maintenance campaigns, or short-term activities. Captures budget approval details (approval authority, approved amount, project phase), commitments, actual costs, settlement rules, and responsible cost centre. Covers port infrastructure projects, equipment procurement, dredging campaigns, technology investments, and special operational programmes. SSOT for CAPEX governance, investment decision tracking, and project cost control below WBS granularity.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` (
    `wbs_element_id` BIGINT COMMENT 'Unique identifier for the WBS element within SAP PS/CO. Primary key for capital project financial tracking.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every WBS element belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can remai',
    `cost_centre_id` BIGINT COMMENT 'Foreign key to the cost center accountable for managing and executing this WBS element (e.g., Engineering Department, Marine Operations).',
    `equipment_class_id` BIGINT COMMENT 'Foreign key to the asset class for capitalization and depreciation purposes (e.g., Buildings, Quay Cranes, Dredging, IT Infrastructure). Determines useful life and depreciation method.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: The wbs_element product has an internal_order_number STRING field. In SAP PS/CO, WBS elements can be linked to internal orders for integrated cost tracking (e.g., a CAPEX project WBS element linked to',
    `investment_program_id` BIGINT COMMENT 'Foreign key to the multi-year investment program or capital plan under which this WBS element is funded (e.g., 5-Year Infrastructure Development Plan).',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: WBS elements (capex projects like berth expansion, crane procurement, terminal automation) are owned by org units for investment planning, execution accountability, and organizational capital allocati',
    `parent_wbs_element_id` BIGINT COMMENT 'Foreign key reference to the parent WBS element, enabling hierarchical project structure (e.g., a sub-phase under a major phase). Null for top-level WBS elements.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Capital projects (WBS elements) are location-specific: berth upgrades, crane installations, yard expansions. Essential for capex tracking by facility, project cost allocation to terminals, and asset c',
    `employee_id` BIGINT COMMENT 'Foreign key to the employee responsible for delivering this WBS element. Accountable for scope, schedule, and budget performance.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key to the profit center for internal P&L reporting. Used to allocate CAPEX spend and depreciation to business segments (e.g., Container Terminal, Bulk Terminal).',
    `purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: Capital project requisitions reference WBS elements for budget availability checking. Port project managers requisition against approved WBS budgets. Enables project procurement authorization and comm',
    `tertiary_wbs_last_modified_by_employee_id` BIGINT COMMENT 'Foreign key to the user who last modified this WBS element record. Used for audit trail and accountability in project financial management.',
    `actual_cost` DECIMAL(18,2) COMMENT 'The total actual expenditure posted to this WBS element to date, including invoiced costs, internal labor, and overhead allocations. Used for budget variance analysis.',
    `actual_end_date` DATE COMMENT 'The actual date when work was completed on this WBS element. Used for schedule performance reporting and lessons learned analysis.',
    `actual_start_date` DATE COMMENT 'The actual date when work commenced on this WBS element. Used for schedule variance analysis and project performance measurement.',
    `approval_date` DATE COMMENT 'The date when the WBS element budget and scope were formally approved by the investment committee or board. Establishes the baseline for change control.',
    `approval_status` STRING COMMENT 'The current approval state of the WBS element budget and scope. Controls whether expenditure can be committed and posted.. Valid values are `draft|pending_approval|approved|rejected|on_hold`',
    `baseline_completion_date` DATE COMMENT 'The original approved completion date at project sanction. Used as the reference point for schedule variance reporting and change control.',
    `budget_variance` DECIMAL(18,2) COMMENT 'The difference between planned CAPEX budget and forecast final cost (positive = under budget, negative = over budget). Key performance indicator for project financial control.',
    `capitalization_date` DATE COMMENT 'The date when the asset created by this WBS element was placed in service and capitalized to the fixed asset register. Triggers depreciation commencement.',
    `wbs_element_code` STRING COMMENT 'The externally-known alphanumeric code identifying the WBS element in SAP (e.g., P-12345-001). Used in project documentation, purchase orders, and financial reports.. Valid values are `^[A-Z0-9]{1,24}$`',
    `committed_cost` DECIMAL(18,2) COMMENT 'The total value of purchase orders and contracts committed against this WBS element but not yet invoiced. Used for funds availability checking and cash flow forecasting.',
    `controlling_area` STRING COMMENT 'SAP controlling area for management accounting and cost control. Defines the organizational unit for internal reporting and profitability analysis.. Valid values are `^[A-Z0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this WBS element record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this WBS element (e.g., USD, EUR, GBP). Determines exchange rate handling for multi-currency projects.. Valid values are `^[A-Z]{3}$`',
    `wbs_element_description` STRING COMMENT 'Full business description of the WBS element, detailing the scope of work (e.g., Berth 7 Quay Wall Extension - Foundation Works).',
    `eia_approval_date` DATE COMMENT 'The date when the environmental impact assessment was approved by the relevant regulatory authority. Prerequisite for construction commencement on environmentally sensitive projects.',
    `environmental_impact_assessment_required` BOOLEAN COMMENT 'Flag indicating whether this WBS element requires a formal environmental impact assessment under local or international regulations (e.g., dredging, land reclamation).',
    `expected_annual_revenue` DECIMAL(18,2) COMMENT 'The projected annual revenue increment from this WBS element once operational. Used for business case validation and payback period calculation.',
    `forecast_final_cost` DECIMAL(18,2) COMMENT 'The estimated cost at completion (EAC) for this WBS element, combining actual spend to date with forecast remaining costs. Used for budget overrun alerts and re-forecasting.',
    `funding_source` STRING COMMENT 'The primary source of capital funding for this WBS element. Used for cash flow planning and financial reporting to stakeholders and lenders.. Valid values are `internal_cash|bank_loan|government_grant|bond_issuance|public_private_partnership`',
    `grant_reference_number` STRING COMMENT 'The external reference number for government or international development grants funding this WBS element. Used for grant compliance reporting and audit.',
    `is_revenue_generating` BOOLEAN COMMENT 'Flag indicating whether this WBS element will create or enhance revenue-generating assets (e.g., new berth, additional crane capacity). Used for investment appraisal and return on investment (ROI) analysis.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this WBS element record was last updated. Used for change tracking and data quality monitoring.',
    `network_code` BIGINT COMMENT 'Foreign key to the project network (activity schedule) associated with this WBS element. Links financial tracking to detailed project scheduling and resource planning.',
    `planned_capex_budget` DECIMAL(18,2) COMMENT 'The approved capital budget allocated to this WBS element in the base currency. Represents the total authorized spend for this scope of work.',
    `planned_end_date` DATE COMMENT 'The scheduled date for completion of work on this WBS element. Used for milestone tracking and project performance reporting.',
    `planned_start_date` DATE COMMENT 'The scheduled date for commencement of work on this WBS element. Used for project scheduling and resource planning.',
    `priority_ranking` STRING COMMENT 'The relative priority of this WBS element within the investment portfolio (1 = highest priority). Used for capital allocation decisions and resource prioritization.',
    `project_id` BIGINT COMMENT 'Foreign key reference to the parent project definition under which this WBS element is organized. Links to the overall CAPEX programme (e.g., Terminal Expansion Phase 2).',
    `project_phase` STRING COMMENT 'The current phase of the project lifecycle for this WBS element. Used for stage-gate governance and phase-specific reporting.. Valid values are `feasibility|design|procurement|construction|commissioning|closeout`',
    `risk_category` STRING COMMENT 'The overall risk rating for this WBS element, considering schedule, cost, technical, and external risks. Used for risk-based portfolio management and escalation.. Valid values are `low|medium|high|critical`',
    `settlement_receiver_reference` BIGINT COMMENT 'Foreign key to the target object (asset, cost center, or GL account) that will receive settled costs from this WBS element upon project completion.',
    `settlement_rule` STRING COMMENT 'The method by which costs accumulated on this WBS element are settled to fixed assets or cost centers at project closure (full transfer, percentage allocation, or equivalence number distribution).. Valid values are `full|percentage|equivalence`',
    `strategic_objective` STRING COMMENT 'The high-level business objective or strategic goal that this WBS element supports (e.g., Increase container throughput capacity by 20%, Achieve ISPS Code compliance).',
    `wbs_element_type` STRING COMMENT 'Classification of the WBS element by its functional role in the project lifecycle: planning (budget holder), execution (work package), billing (revenue recognition), or milestone (phase gate).. Valid values are `planning|execution|billing|milestone`',
    `wbs_level` STRING COMMENT 'Hierarchical level of the WBS element within the project structure (1 = top level, 2 = second level, etc.). Used for rollup reporting and project organization.',
    `wbs_status` STRING COMMENT 'Current lifecycle status of the WBS element. Controls whether costs can be posted and whether the element is active for project execution.. Valid values are `created|released|in_progress|completed|closed|cancelled`',
    CONSTRAINT pk_wbs_element PRIMARY KEY(`wbs_element_id`)
) COMMENT 'Work Breakdown Structure (WBS) element within SAP PS/CO for managing CAPEX projects such as berth construction, quay crane procurement, dredging programmes, and terminal expansion. Tracks planned vs. actual CAPEX spend, milestones, and project phases. SSOT for capital project financial tracking aligned to port infrastructure development programmes.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` (
    `journal_entry_id` BIGINT COMMENT 'Unique identifier for the journal entry record. Primary key for the journal entry entity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every journal entry belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can rem',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Journal entries can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_centre STRING column can remain ',
    `gang_id` BIGINT COMMENT 'Foreign key linking to workforce.gang. Business justification: Journal entries recording gang payroll accruals, overtime provisions, gang cost corrections, or gang-specific adjustments require gang dimension for operational reporting, gang P&L analysis, and steve',
    `gl_account_id` BIGINT COMMENT 'add column gl_account_id (BIGINT) with FK to finance.gl_account.gl_account_id - journal entry headers should reference the primary GL account for posting validation',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Journal entries can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_centre STRING col',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Journal entries can be allocated to WBS elements for project cost tracking. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element STRING column can r',
    `accounting_principle` STRING COMMENT 'The accounting standard or principle under which this entry is recorded (e.g., IFRS, GAAP, local GAAP). Used for parallel accounting and multi-standard reporting.',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when the journal entry was approved. Used for audit trail and approval turnaround time analysis.',
    `approver_user_name` STRING COMMENT 'The username of the person who approved the journal entry for posting. Populated only when workflow approval is required. Used for audit trail and compliance reporting.',
    `assignment_reference` STRING COMMENT 'Free-text assignment field used for additional sorting and grouping in reports. Often contains vessel names, container numbers, or customer references for maritime-specific tracking.',
    `baseline_payment_date` DATE COMMENT 'The baseline date from which payment terms are calculated for vendor invoices and customer receivables. Used for cash flow forecasting and aging analysis.',
    `batch_input_session` STRING COMMENT 'The batch input session name if this entry was created via batch processing or interface. Used for mass upload tracking and error resolution.',
    `business_area` STRING COMMENT 'The business area or division for segment reporting (e.g., container terminal, bulk cargo, marine services). Used for divisional profitability analysis and segment reporting under IFRS 8.',
    `clearing_date` DATE COMMENT 'The date on which this journal entry was cleared or settled. Used for days sales outstanding (DSO) and days payable outstanding (DPO) calculations.',
    `clearing_document_number` STRING COMMENT 'The document number of the clearing entry that settled this journal entry (e.g., payment document that cleared an invoice). Used for reconciliation and cash application tracking.',
    `company_code` STRING COMMENT 'The organizational unit representing the legal entity within the enterprise structure. Used for statutory reporting and legal consolidation. Maps to SAP company code structure.',
    `cost_centre` STRING COMMENT 'The cost centre to which costs or revenues are allocated. Used for operational cost control, OPEX tracking, and departmental budgeting.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which the journal entry amounts are denominated (e.g., AUD, USD, EUR). All line items within the entry share this currency.. Valid values are `^[A-Z]{3}$`',
    `document_date` DATE COMMENT 'The date on the source document (invoice date, receipt date, contract date). May differ from posting date and is used for aging analysis and payment terms calculation.',
    `document_header_text` STRING COMMENT 'Free-text description at the journal entry header level providing context about the overall transaction. Used for manual journals, accruals, and adjustments to explain the business purpose.',
    `document_number` STRING COMMENT 'The externally-known unique document number assigned by the financial accounting system. This is the business identifier used in SAP FI for referencing the journal entry across all financial reports and audit trails.',
    `document_type` STRING COMMENT 'Classification of the journal entry by business transaction type (e.g., SA=GL account document, DR=customer invoice, KR=vendor invoice, AB=asset posting, DZ=payment document). Controls number ranges and posting rules.',
    `entry_date` DATE COMMENT 'The date when the journal entry was created in the system. Used for audit trail and document lifecycle tracking.',
    `entry_timestamp` TIMESTAMP COMMENT 'The precise date and time when the journal entry was created in the system. Used for audit trail, process timing analysis, and regulatory compliance.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The exchange rate applied to convert document currency amounts to local currency. Used when document currency differs from local currency.',
    `exchange_rate_type` STRING COMMENT 'The type of exchange rate used for currency conversion (e.g., M=average rate, B=bank buying rate, G=bank selling rate). Determines which rate table is applied.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or special period) within the fiscal year when the entry was posted. Supports monthly financial close and period-based reporting.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the journal entry is posted. Used for period-based financial reporting and year-end closing processes.',
    `functional_area` STRING COMMENT 'The functional area classification for cost-of-sales accounting (e.g., operations, administration, sales, maintenance). Used for P&L reporting by function under IFRS.',
    `intercompany_indicator` BOOLEAN COMMENT 'Flag indicating whether this journal entry involves intercompany transactions between different company codes within the enterprise. Used for intercompany reconciliation and elimination.',
    `internal_order` STRING COMMENT 'The internal order number for tracking specific cost objects such as maintenance campaigns, marketing initiatives, or temporary projects. Used for short-term cost collection and analysis.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the journal entry was last modified. Used for change tracking and audit trail in accordance with SOLAS and ISPS documentation requirements.',
    `ledger_group` STRING COMMENT 'The ledger or ledger group to which this entry is posted (e.g., 0L=leading ledger, 2L=IFRS ledger, 3L=management ledger). Supports parallel accounting for different reporting standards.',
    `local_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code of the company codes local currency used for statutory reporting. Typically AUD for Australian port operations.. Valid values are `^[A-Z]{3}$`',
    `payment_block_indicator` BOOLEAN COMMENT 'Flag indicating whether payment for this entry is blocked pending review or dispute resolution. Used for payment control and exception management.',
    `payment_block_reason` STRING COMMENT 'Code or text explaining why payment is blocked (e.g., A=dispute, B=missing documentation, C=quality issue). Populated only when payment_block_indicator is true.',
    `payment_method` STRING COMMENT 'The method by which payment is made or received (e.g., T=bank transfer, C=cheque, E=electronic funds transfer, D=direct debit). Used for payment processing and cash management.',
    `payment_terms` STRING COMMENT 'The payment terms code defining the due date calculation and cash discount conditions (e.g., 0001=payable immediately, Z030=net 30 days). Used for accounts payable and receivable management.',
    `posting_date` DATE COMMENT 'The date on which the journal entry was posted to the general ledger. This is the principal business event timestamp that determines the fiscal period and affects financial statement balances.',
    `posting_status` STRING COMMENT 'Current lifecycle status of the journal entry. Draft entries are not yet posted to the ledger; parked entries await approval; posted entries are final; cleared entries have been reconciled; reversed entries have been negated; cancelled entries are voided.. Valid values are `draft|posted|parked|cleared|reversed|cancelled`',
    `profit_centre` STRING COMMENT 'The profit centre responsible for the financial result of this entry. Used for management accounting, EBITDA analysis, and internal performance measurement.',
    `reference_document_number` STRING COMMENT 'External reference number linking this journal entry to source documents such as invoice numbers, purchase order numbers, Bill of Lading (BOL) numbers, or customs declaration numbers. Critical for audit trail and reconciliation.',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this journal entry is a reversal of a previous entry. Used for accrual reversals and error corrections.',
    `reversal_reason_code` STRING COMMENT 'Code indicating the reason for reversing the original entry (e.g., 01=error correction, 02=accrual reversal, 03=period adjustment). Used for audit and control reporting.',
    `reversed_document_number` STRING COMMENT 'The document number of the original journal entry that this entry reverses. Populated only when reversal_indicator is true.',
    `tax_reporting_date` DATE COMMENT 'The date used for tax reporting purposes, which may differ from posting date. Used for GST/VAT returns, Business Activity Statement (BAS) reporting, and withholding tax compliance.',
    `trading_partner_company_code` STRING COMMENT 'The company code of the intercompany trading partner when intercompany_indicator is true. Used for intercompany reconciliation and consolidation.',
    `transaction_code` STRING COMMENT 'The SAP transaction code used to create or post the journal entry (e.g., FB01=post document, FB50=GL posting, F-02=general posting). Used for audit trail and process analysis.',
    `user_name` STRING COMMENT 'The username of the person who created or posted the journal entry. Used for audit trail and segregation of duties monitoring.',
    `wbs_element` STRING COMMENT 'The project work breakdown structure element for CAPEX tracking and project accounting. Used for capital expenditure management, port infrastructure development, and project-based financial reporting.',
    `workflow_approval_status` STRING COMMENT 'The approval status of the journal entry within the workflow process. Used for manual journal approval controls and segregation of duties enforcement.. Valid values are `pending|approved|rejected|not_required`',
    CONSTRAINT pk_journal_entry PRIMARY KEY(`journal_entry_id`)
) COMMENT 'General ledger journal entry representing all financial postings including header metadata and detailed line items. Covers manual journals, system-generated postings (billing, payroll, asset accounting), intercompany entries, accruals, and tax-relevant postings (GST/VAT, withholding tax, port levies). Each entry contains document type, posting date, fiscal period, company code, and individual lines with debit/credit amounts, GL account, cost centre, profit centre, WBS element, tax code, tax amount, and assignment references. SSOT for all financial accounting transactions underpinning statutory reporting, management accounting, BAS/VAT returns, tax compliance, and audit trail. Sourced from SAP S/4HANA FI module.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` (
    `journal_entry_line_id` BIGINT COMMENT 'Unique identifier for the journal entry line item. Primary key for granular financial transaction line tracking.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Journal entry lines can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_centre_code STRING column ca',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Journal entry lines record employee-related transactions (travel advances, expense reimbursements, payroll corrections) requiring direct employee linkage for audit trail, reconciliation, and employee ',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: The journal_entry_line product has asset_number and asset_subnumber STRING fields. Journal entry lines frequently post to fixed assets (acquisitions, depreciation, disposals). This FK links the journa',
    `gang_id` BIGINT COMMENT 'Foreign key linking to workforce.gang. Business justification: Port operations post gang-specific costs (stevedoring labor, overtime, equipment usage, gang allowances) to GL requiring direct gang linkage for operational cost analysis, productivity measurement, an',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Every journal entry line posts to a GL account - this is the core financial posting relationship. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Journal entry lines can be allocated to internal orders for cost tracking. New FK column internal_order_id will be created to link to the internal order master. The existing internal_order_number STRI',
    `journal_entry_id` BIGINT COMMENT 'Reference to the parent journal entry header. Links this line item to the overall journal entry document.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Journal entry lines can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_centre_code S',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.service_code. Business justification: Journal entries for port revenue/expense reference specific services (pilotage, towage, wharfage). Essential for revenue recognition by service line, service profitability analysis, and regulatory rep',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Journal entry lines can be allocated to WBS elements for project cost tracking. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element_code STRING col',
    `assignment_reference` STRING COMMENT 'Free-text assignment field for additional reference information such as invoice numbers, payment references, or internal tracking codes.',
    `baseline_date` DATE COMMENT 'The baseline date for payment terms calculation. Used to determine due dates for accounts payable and receivable.',
    `business_area_code` STRING COMMENT 'The business area code for cross-company code reporting. Represents a distinct business segment or division for consolidated financial reporting.. Valid values are `^[A-Z0-9]{2,4}$`',
    `clearing_date` DATE COMMENT 'The date on which this line item was cleared through payment or offset. Null for open items.',
    `clearing_document_number` STRING COMMENT 'The document number of the clearing entry that settled this open item. Populated when the line item is cleared through payment or offset.. Valid values are `^[0-9]{10}$`',
    `created_by_user` STRING COMMENT 'The user ID of the person who created this journal entry line item record.. Valid values are `^[A-Z0-9]{6,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this journal entry line item record was first created in the system.',
    `credit_amount` DECIMAL(18,2) COMMENT 'The credit amount posted to the general ledger account in the functional currency. Represents decreases to asset and expense accounts or increases to liability, equity, and revenue accounts.',
    `debit_amount` DECIMAL(18,2) COMMENT 'The debit amount posted to the general ledger account in the functional currency. Represents increases to asset and expense accounts or decreases to liability, equity, and revenue accounts.',
    `dunning_block_code` STRING COMMENT 'The dunning block indicator preventing automatic dunning notice generation for this line item.. Valid values are `^[A-Z]{1}$`',
    `dunning_level` STRING COMMENT 'The dunning level indicating the escalation stage for overdue receivables. Higher numbers represent more severe collection actions.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate used to convert the transaction currency amount to the functional currency amount.',
    `functional_area_code` STRING COMMENT 'The functional area code for cost-of-sales accounting. Classifies the line item by business function such as production, administration, sales, or distribution.. Valid values are `^[A-Z0-9]{2,4}$`',
    `functional_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code representing the functional currency in which the debit and credit amounts are recorded.. Valid values are `^[A-Z]{3}$`',
    `line_item_text` STRING COMMENT 'Descriptive text providing additional context or explanation for this journal entry line item.',
    `line_number` STRING COMMENT 'Sequential line number within the journal entry. Determines the ordering and position of this line item in the entry.',
    `material_number` STRING COMMENT 'The material or inventory item number when this line item relates to goods movement or inventory valuation.. Valid values are `^[A-Z0-9]{6,18}$`',
    `modified_by_user` STRING COMMENT 'The user ID of the person who last modified this journal entry line item record.. Valid values are `^[A-Z0-9]{6,12}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this journal entry line item record was last modified.',
    `partner_profit_centre_code` STRING COMMENT 'The partner profit centre code for internal transfer pricing and intercompany profit elimination.. Valid values are `^[A-Z0-9]{4,10}$`',
    `payment_block_code` STRING COMMENT 'The payment block indicator preventing automatic payment processing. Used for items requiring manual review or approval.. Valid values are `^[A-Z]{1}$`',
    `payment_terms_code` STRING COMMENT 'The payment terms code defining the payment conditions and discount terms for this line item.. Valid values are `^[A-Z0-9]{2,4}$`',
    `posting_key` STRING COMMENT 'The two-digit posting key that controls the posting characteristics such as debit/credit indicator, account type, and field status.. Valid values are `^[0-9]{2}$`',
    `quantity` DECIMAL(18,2) COMMENT 'The quantity of goods or services associated with this line item for inventory or cost allocation purposes.',
    `reversal_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this line item is a reversal of a previous entry. True if this is a reversal transaction.',
    `reversed_document_number` STRING COMMENT 'The document number of the original entry that this line item reverses. Populated only when reversal_indicator is true.. Valid values are `^[0-9]{10}$`',
    `segment_code` STRING COMMENT 'The segment code for IFRS segment reporting. Represents an operating segment for external financial reporting purposes.. Valid values are `^[A-Z0-9]{2,6}$`',
    `special_gl_indicator` STRING COMMENT 'The special GL indicator for alternative reconciliation accounts such as down payments, bills of exchange, or guarantees.. Valid values are `^[A-Z]{1}$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The calculated tax amount associated with this line item in the functional currency.',
    `tax_code` STRING COMMENT 'The tax code that determines the tax calculation procedure and tax rates applicable to this line item.. Valid values are `^[A-Z0-9]{2,4}$`',
    `trading_partner_code` STRING COMMENT 'The trading partner code for intercompany transactions. Identifies the counterparty company code in consolidated group reporting.. Valid values are `^[A-Z0-9]{4,10}$`',
    `transaction_amount` DECIMAL(18,2) COMMENT 'The original transaction amount in the transaction currency before conversion to functional currency.',
    `transaction_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code representing the original transaction currency before conversion to functional currency.. Valid values are `^[A-Z]{3}$`',
    `unit_of_measure` STRING COMMENT 'The unit of measure for the quantity field such as TEU, FEU, MT (metric tons), or CBM (cubic meters).. Valid values are `^[A-Z]{2,3}$`',
    `value_date` DATE COMMENT 'The value date for cash management and liquidity planning. Represents the effective date for financial value calculation.',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'The calculated withholding tax amount deducted from the payment in the functional currency.',
    `withholding_tax_type` STRING COMMENT 'The withholding tax type code for statutory tax withholding requirements on payments to vendors or employees.. Valid values are `^[A-Z0-9]{2,4}$`',
    CONSTRAINT pk_journal_entry_line PRIMARY KEY(`journal_entry_line_id`)
) COMMENT 'Individual line items within a general ledger journal entry capturing debit/credit amounts, GL account, cost centre, profit centre, WBS element, tax code, and assignment reference. Sourced from SAP FI line item table. Enables granular financial analysis, cost allocation tracing, and reconciliation between management and statutory accounts.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` (
    `ap_invoice_id` BIGINT COMMENT 'Unique identifier for the accounts payable invoice record. Primary key for the AP invoice entity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every AP invoice belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can remain',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: AP invoices can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_center STRING column can remain as a',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Accounts payable invoices for customs duties, VAT, and import fees reference the originating customs declaration for duty payment reconciliation, financial reporting, and audit trail in import cost ac',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or manager who approved this invoice for payment. Used for audit trails and approval workflow tracking.',
    `gang_id` BIGINT COMMENT 'Foreign key linking to workforce.gang. Business justification: Invoices for gang-specific services (casual labor hire, gang equipment rental, gang allowances, gang training) require gang linkage for cost allocation, billing verification, and gang-level cost analy',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: AP invoices post to GL accounts for financial accounting. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account STRING column can remain as a denormaliz',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: AP invoices can be charged to internal orders for CAPEX/project cost tracking. New FK column internal_order_id will be created to link invoices to internal orders for budget tracking and cost allocati',
    `billing_run_id` BIGINT COMMENT 'Identifier of the payment run batch in which this invoice was included for payment processing. Used to group invoices paid together in a single payment cycle.',
    `security_equipment_id` BIGINT COMMENT 'Foreign key linking to security.security_equipment. Business justification: Vendor invoices for security equipment purchases must be matched to equipment records for three-way matching (PO-GR-IR), asset capitalization decisions, and warranty tracking in procurement-to-pay pro',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor or supplier who issued this invoice. Links to the vendor master data for stevedoring subcontractors, equipment suppliers, marine fuel providers, pilotage services, dredging contractors, and infrastructure works contractors.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: AP invoices can be charged to WBS elements for project cost tracking in SAP PS/CO. New FK column wbs_element_id will be created to link invoices to project work breakdown structures for CAPEX tracking',
    `approval_date` DATE COMMENT 'The date the invoice was approved for payment by the authorized approver. Marks the transition from pending to approved status.',
    `bank_account_number` STRING COMMENT 'Identifier of the vendor bank account to which payment should be made. Links to vendor banking details for electronic payment execution.',
    `baseline_date` DATE COMMENT 'The baseline date used for calculating payment due dates based on payment terms. Typically the invoice date or posting date depending on configuration.',
    `clearing_date` DATE COMMENT 'The date the invoice was cleared in the financial system, indicating the payment has been fully reconciled and the payable obligation is closed.',
    `clearing_document_number` STRING COMMENT 'The financial document number generated during the clearing process that links the invoice to its payment transaction.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this invoice record was first created in the financial system. Used for audit trails and record lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the invoice (e.g., USD, EUR, GBP). All monetary amounts on this invoice are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'The total discount amount applied to the invoice, including early payment discounts, volume discounts, or negotiated rebates.',
    `document_date` DATE COMMENT 'The document date recorded in the financial system, typically matching the invoice date but may differ for backdated or forward-dated entries.',
    `due_date` DATE COMMENT 'The date by which payment is due to the vendor based on payment terms. Used for cash flow planning and to avoid late payment penalties.',
    `dunning_level` STRING COMMENT 'The dunning level or escalation stage for overdue invoices, indicating how many payment reminders have been sent. Used in collections management.',
    `expense_category` STRING COMMENT 'High-level classification of the expense type for this invoice, distinguishing between operational expenditure (OPEX), capital expenditure (CAPEX), and specific operational categories. [ENUM-REF-CANDIDATE: opex|capex|maintenance|fuel|contractor_services|equipment_parts|dredging|pilotage|stevedoring|utilities|professional_services — 11 candidates stripped; promote to reference product]',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year in which this invoice is recorded, used for monthly financial closing and reporting.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which this invoice is recorded for financial reporting purposes, based on the posting date.',
    `goods_receipt_number` STRING COMMENT 'The goods receipt document number confirming physical receipt of goods or completion of services. Used in three-way matching to validate invoice against delivery.',
    `gross_amount` DECIMAL(18,2) COMMENT 'The total gross amount of the invoice before any taxes, discounts, or adjustments. Represents the base value of goods or services provided by the vendor.',
    `invoice_date` DATE COMMENT 'The date the vendor issued the invoice. This is the principal business event timestamp for the invoice and is used for aging analysis and payment term calculations.',
    `invoice_description` STRING COMMENT 'Free-text description of the invoice content, services rendered, or goods supplied. Provides business context for the payable obligation.',
    `invoice_number` STRING COMMENT 'The vendor-issued invoice number as printed on the invoice document. This is the external business identifier used for vendor communication and payment reconciliation.',
    `invoice_status` STRING COMMENT 'Current lifecycle status of the AP invoice indicating its position in the payable workflow from receipt through payment and clearing. [ENUM-REF-CANDIDATE: draft|posted|approved|pending_payment|partially_paid|paid|cleared|cancelled|disputed|on_hold — 10 candidates stripped; promote to reference product]',
    `invoice_type` STRING COMMENT 'Classification of the invoice document type indicating the nature of the vendor obligation (standard invoice, credit memo for returns, debit memo for additional charges, etc.). [ENUM-REF-CANDIDATE: standard|credit_memo|debit_memo|prepayment|down_payment|recurring|adjustment — 7 candidates stripped; promote to reference product]',
    `is_recurring` BOOLEAN COMMENT 'Flag indicating whether this is a recurring invoice that is generated automatically on a regular schedule (e.g., monthly lease payments, annual maintenance contracts).',
    `modified_by` STRING COMMENT 'Username or identifier of the system user who last modified this invoice record.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this invoice record was last modified in the financial system. Used for audit trails and change tracking.',
    `net_amount` DECIMAL(18,2) COMMENT 'The final net amount payable to the vendor after applying taxes, discounts, and all adjustments. This is the amount that will be paid.',
    `outstanding_amount` DECIMAL(18,2) COMMENT 'The remaining unpaid balance on the invoice. Calculated as net_amount minus paid_amount. Used for AP aging and cash flow forecasting.',
    `paid_amount` DECIMAL(18,2) COMMENT 'The cumulative amount that has been paid against this invoice to date. Used to track partial payments and calculate outstanding balance.',
    `payment_block` STRING COMMENT 'A code indicating if payment is blocked for this invoice and the reason (e.g., pending approval, dispute, quality issue, missing documentation). Empty if no block exists.',
    `payment_date` DATE COMMENT 'The date the payment was executed or the check was issued to the vendor. Used for cash flow reporting and payment performance analysis.',
    `payment_method` STRING COMMENT 'The payment instrument or mechanism used to settle this invoice (Electronic Funds Transfer, wire transfer, check, ACH, SWIFT, SEPA, etc.). [ENUM-REF-CANDIDATE: eft|wire_transfer|check|ach|swift|sepa|cash|credit_card|letter_of_credit — 9 candidates stripped; promote to reference product]',
    `payment_reference` STRING COMMENT 'The external payment reference number or transaction ID from the bank or payment system (e.g., SWIFT reference, EFT confirmation number, check number).',
    `payment_terms` STRING COMMENT 'The agreed payment terms with the vendor (e.g., Net 30, Net 60, 2/10 Net 30). Defines the payment schedule and any early payment discounts available.',
    `posting_date` DATE COMMENT 'The date the invoice was posted to the general ledger in the financial accounting system. Used for period closing and financial reporting.',
    `purchase_order_number` STRING COMMENT 'The purchase order number against which this invoice is being processed. Used for three-way matching (PO, goods receipt, invoice) in procurement workflows.',
    `reference_document_number` STRING COMMENT 'External reference document number such as delivery note, contract number, or work order that this invoice relates to. Used for cross-referencing and audit trails.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The total tax amount charged on the invoice, including VAT, GST, or other applicable sales taxes based on jurisdiction and tax codes.',
    `tax_code` STRING COMMENT 'The tax code applied to this invoice indicating the tax rate and tax type (VAT, GST, sales tax) based on jurisdiction and transaction nature.',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'The amount of withholding tax deducted from the payment to the vendor as required by tax regulations. This amount is remitted directly to tax authorities.',
    `created_by` STRING COMMENT 'Username or identifier of the system user who created this invoice record in the financial system.',
    CONSTRAINT pk_ap_invoice PRIMARY KEY(`ap_invoice_id`)
) COMMENT 'Accounts Payable (AP) record representing the complete vendor payable lifecycle from invoice receipt through payment execution and clearing. Covers all vendor obligations including stevedoring subcontractors, equipment spare parts, marine fuel, pilotage services, dredging contractors, and infrastructure works. Captures invoice header (vendor, dates, payment terms, amounts), line items, payment execution details (payment method, bank clearing, EFT/SWIFT references, payment run ID), and clearing status. Tracks cash outflows for port operational expenditure and CAPEX payments. Sourced from SAP FI-AP module. SSOT for all vendor payment obligations, disbursement tracking, and AP aging analysis.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` (
    `ap_payment_id` BIGINT COMMENT 'Unique identifier for the accounts payable payment transaction. Primary key.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every AP payment belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can remain',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: AP payments can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_center STRING column can remain as a',
    `gang_id` BIGINT COMMENT 'Foreign key linking to workforce.gang. Business justification: Payments for gang-related expenses (casual labor payments, gang equipment hire, gang allowances) need gang tracking for cost center posting, operational expense analysis, and gang productivity costing',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: AP payments post to GL accounts for financial accounting. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can remain as a denor',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: AP payments can be allocated to internal orders for cost tracking. New FK column internal_order_id will be created to link payments to internal orders for budget and commitment tracking.',
    `billing_run_id` BIGINT COMMENT 'Identifier of the payment run batch that generated this payment. Links multiple payments processed together in a single execution.',
    `employee_id` BIGINT COMMENT 'The user ID of the person or system account that created the payment record. Used for audit trail and accountability.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: AP payments can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_center STRING column ',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor (supplier, contractor, service provider) receiving this payment. Links to vendor master data.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: AP payments can be allocated to WBS elements for project cost tracking. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element STRING column can remai',
    `bank_charges` DECIMAL(18,2) COMMENT 'Bank fees and charges incurred for processing the payment (wire fees, SWIFT charges, intermediary bank fees). May be borne by company or vendor.',
    `bank_clearing_date` DATE COMMENT 'The date on which the payment cleared through the banking system and funds were credited to the vendor account. Used for reconciliation.',
    `company_code` STRING COMMENT 'The legal entity company code making the payment. Represents the organizational unit in SAP FI for statutory reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center` STRING COMMENT 'The cost center to which this payment is charged for management accounting and controlling purposes. Links to SAP CO cost center master.. Valid values are `^[A-Z0-9]{6,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the payment record was first created in the system. Used for audit trail and data lineage.',
    `discount_amount` DECIMAL(18,2) COMMENT 'The total early payment discount amount taken on invoices cleared by this payment. Reduces the payment amount and is posted to a discount account.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert payment_amount to local_currency_amount. Expressed as units of local currency per unit of payment currency.',
    `exchange_rate_date` DATE COMMENT 'The date on which the exchange rate was determined. Typically the payment date or value date depending on company policy.',
    `expenditure_type` STRING COMMENT 'Classification of the payment as operational expenditure (OPEX) or capital expenditure (CAPEX) for financial analysis and EBITDA calculation.. Valid values are `OPEX|CAPEX`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year in which the payment was posted. Used for period-end closing and reporting.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the payment was posted. Derived from posting_date based on company fiscal calendar.',
    `house_bank_account_number` STRING COMMENT 'The company bank account number from which funds were debited. May be IBAN format for international payments.. Valid values are `^[A-Z0-9]{8,34}$`',
    `house_bank_code` STRING COMMENT 'Identifier of the company house bank account from which the payment was made. Links to bank master data.. Valid values are `^[A-Z0-9]{4,10}$`',
    `invoice_count` STRING COMMENT 'The number of vendor invoices cleared by this payment. Used for payment run analysis and vendor statement reconciliation.',
    `local_currency_amount` DECIMAL(18,2) COMMENT 'The payment amount converted to the company code local currency for statutory financial reporting and general ledger posting.',
    `local_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code of the company code local currency used for statutory reporting.. Valid values are `^[A-Z]{3}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when the payment record was last modified. Used for audit trail and change tracking.',
    `net_payment_amount` DECIMAL(18,2) COMMENT 'The net amount actually disbursed to the vendor after deducting discounts, withholding tax, and bank charges. Equals payment_amount minus all deductions.',
    `payment_advice_sent_flag` BOOLEAN COMMENT 'Indicates whether remittance advice was sent to the vendor. True if sent, False if not sent or pending.',
    `payment_advice_sent_timestamp` TIMESTAMP COMMENT 'The date and time when remittance advice was transmitted to the vendor via email, EDI, or portal.',
    `payment_amount` DECIMAL(18,2) COMMENT 'The total gross amount disbursed to the vendor in the payment currency. Represents the sum of all invoice amounts cleared by this payment.',
    `payment_block_code` STRING COMMENT 'Code indicating if payment was blocked for manual review. Blank if no block. Common values: A (payment block), R (manual review required).. Valid values are `^[A-Z]{1,2}$`',
    `payment_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which the payment was made (e.g., USD, EUR, GBP, SGD). May differ from invoice currency if foreign exchange conversion occurred.. Valid values are `^[A-Z]{3}$`',
    `payment_date` DATE COMMENT 'The business date on which the payment was executed or scheduled to be executed. Used for cash flow reporting and aging analysis.',
    `payment_document_number` STRING COMMENT 'The externally-known unique payment document number generated by SAP FI-AP payment program. Used for reconciliation and audit trail.. Valid values are `^[A-Z0-9]{8,20}$`',
    `payment_method` STRING COMMENT 'The payment instrument or mechanism used to disburse funds. EFT (Electronic Funds Transfer), CHEQUE (paper cheque), SWIFT (international wire), WIRE_TRANSFER (domestic wire), ACH (Automated Clearing House), RTGS (Real-Time Gross Settlement), BACS (UK clearing), SEPA (EU clearing), CASH (petty cash). [ENUM-REF-CANDIDATE: EFT|CHEQUE|SWIFT|WIRE_TRANSFER|ACH|RTGS|BACS|SEPA|CASH — 9 candidates stripped; promote to reference product]',
    `payment_notes` STRING COMMENT 'Free-text notes or comments about the payment. Used for special instructions, exceptions, or audit trail documentation.',
    `payment_priority` STRING COMMENT 'The priority level assigned to this payment for processing sequence. URGENT (same-day), HIGH (next-day), NORMAL (standard cycle), LOW (deferred).. Valid values are `URGENT|HIGH|NORMAL|LOW`',
    `payment_proposal_number` STRING COMMENT 'The payment proposal run identifier that selected this payment for processing. Used to trace payment run execution history.. Valid values are `^[A-Z0-9]{8,15}$`',
    `payment_reference_number` STRING COMMENT 'The unique reference number transmitted to the bank and appearing on bank statements. Used for reconciliation and vendor communication.. Valid values are `^[A-Z0-9-/]{6,35}$`',
    `payment_status` STRING COMMENT 'Current lifecycle status of the payment transaction. DRAFT (created but not submitted), PENDING_APPROVAL (awaiting authorization), APPROVED (authorized for processing), SENT (transmitted to bank), CLEARED (funds debited from account), RECONCILED (matched to bank statement), FAILED (rejected by bank), CANCELLED (voided before processing), REVERSED (reversed after clearing). [ENUM-REF-CANDIDATE: DRAFT|PENDING_APPROVAL|APPROVED|SENT|CLEARED|RECONCILED|FAILED|CANCELLED|REVERSED — 9 candidates stripped; promote to reference product]',
    `payment_terms_code` STRING COMMENT 'The payment terms code applied to determine due date and discount eligibility. Links to payment terms master data.. Valid values are `^[A-Z0-9]{4,10}$`',
    `posting_date` DATE COMMENT 'The accounting period date on which the payment was posted to the general ledger. Determines the fiscal period for financial reporting.',
    `profit_center` STRING COMMENT 'The profit center responsible for this expenditure. Used for segment reporting and profitability analysis.. Valid values are `^[A-Z0-9]{6,10}$`',
    `remittance_advice_number` STRING COMMENT 'The unique identifier of the remittance advice document sent to the vendor detailing which invoices were cleared by this payment.. Valid values are `^[A-Z0-9]{8,20}$`',
    `reversal_document_number` STRING COMMENT 'The document number of the reversal transaction if this payment was reversed. Null if not reversed.. Valid values are `^[A-Z0-9]{8,20}$`',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this payment has been reversed. True if reversed, False if active.',
    `reversal_reason_code` STRING COMMENT 'Code indicating the reason for payment reversal (e.g., duplicate payment, incorrect amount, vendor request). Null if not reversed.. Valid values are `^[A-Z0-9]{2,4}$`',
    `value_date` DATE COMMENT 'The date on which funds are actually debited from the company bank account. May differ from payment_date due to bank processing delays.',
    `vendor_account_number` STRING COMMENT 'The vendor account number in the accounts payable sub-ledger. Used for vendor reconciliation and statement generation.. Valid values are `^[A-Z0-9]{6,18}$`',
    `vendor_bank_account_number` STRING COMMENT 'The vendor bank account number to which funds were credited. May be IBAN format for international payments.. Valid values are `^[A-Z0-9]{8,34}$`',
    `vendor_bank_swift_code` STRING COMMENT 'The SWIFT/BIC code of the vendor bank for international wire transfers. 8 or 11 character ISO 9362 format.. Valid values are `^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`',
    `wbs_element` STRING COMMENT 'The project WBS element for CAPEX payments related to port infrastructure development or capital projects. Links to SAP PS project structure.. Valid values are `^[A-Z0-9.-]{6,24}$`',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'The total withholding tax amount deducted from the payment and remitted to tax authorities. Reduces the net amount paid to vendor.',
    CONSTRAINT pk_ap_payment PRIMARY KEY(`ap_payment_id`)
) COMMENT 'Accounts Payable payment transaction recording disbursements made to vendors including payment run details, payment method (EFT, cheque, SWIFT), bank clearing date, payment amount, currency, exchange rate, and cleared invoice references. Sourced from SAP FI-AP payment programme. Tracks cash outflows for port operational expenditure and CAPEX payments.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` (
    `receivable_id` BIGINT COMMENT 'Primary key for receivable',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Receivables can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_center_code STRING column can remain',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Receivables post to GL accounts for financial accounting. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can remain as a denor',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice document from the billing domain that generated this receivable posting. Links AR posting to the originating billing transaction.',
    `participant_account_id` BIGINT COMMENT 'Reference to the customer or port community participant account that owes this receivable. Identifies the debtor party.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Receivables can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_center_code STRING co',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.service_code. Business justification: Receivables are generated from specific port services rendered. Required for revenue analysis by service type, aging analysis by service category, and dispute resolution tied to service delivery.',
    `aging_bucket` STRING COMMENT 'Classification of the receivable based on days overdue from due date. Used for aging analysis and credit risk assessment.. Valid values are `current|1_30_days|31_60_days|61_90_days|over_90_days|over_180_days`',
    `baseline_date` DATE COMMENT 'The reference date from which payment terms are calculated. Typically the invoice date or goods receipt date.',
    `business_area_code` STRING COMMENT 'The business area classification for statutory reporting and segment disclosure. May represent terminal, service line, or geographic segment.',
    `cash_discount_amount` DECIMAL(18,2) COMMENT 'The early payment discount amount available if payment is made within the discount period per payment terms.',
    `cash_discount_date` DATE COMMENT 'The last date by which payment must be received to qualify for the cash discount. Null if no discount offered.',
    `clearing_date` DATE COMMENT 'The date when the receivable was fully cleared through payment or other settlement. Null if still open.',
    `clearing_document_number` STRING COMMENT 'The financial document number of the payment or clearing transaction that settled this receivable. Null if still open.',
    `clearing_status` STRING COMMENT 'Current payment clearing status of the receivable. Indicates whether the customer has paid the outstanding amount.. Valid values are `open|partially_cleared|fully_cleared|written_off`',
    `cost_center_code` STRING COMMENT 'The cost center code associated with the revenue-generating activity. Used for management accounting and profitability analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this AR posting record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the posting amount (e.g., USD, EUR, GBP). Identifies the transaction currency.. Valid values are `^[A-Z]{3}$`',
    `days_overdue` STRING COMMENT 'Number of days past the due date for open receivables. Calculated as current date minus due date. Zero or negative if not yet due.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether this receivable is currently under dispute by the customer. True if disputed, false otherwise.',
    `dispute_reason` STRING COMMENT 'Free-text description of the reason for dispute if dispute_flag is true. Null if not disputed.',
    `document_date` DATE COMMENT 'The date on the source invoice or billing document. May differ from posting date due to timing of document processing.',
    `document_number` STRING COMMENT 'The externally-known financial document number assigned by SAP FI for this AR posting. Used for audit trail and reconciliation.',
    `due_date` DATE COMMENT 'The date by which payment is expected from the customer based on payment terms. Used for aging analysis and dunning.',
    `dunning_level` STRING COMMENT 'The current dunning level for overdue receivables. Indicates escalation stage in the collections process (0=no dunning, 1-9=escalation levels).',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert document currency to local currency at the time of posting.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year to which this posting is assigned. Typically 1-12 for monthly periods.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this posting is assigned based on posting date. Used for period-based financial reporting.',
    `last_dunning_date` DATE COMMENT 'The date when the most recent dunning notice was sent to the customer for this overdue receivable. Null if never dunned.',
    `local_currency_amount` DECIMAL(18,2) COMMENT 'The posting amount converted to the ports local reporting currency. Used for consolidated financial reporting.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this AR posting record was last modified. Audit trail for record updates.',
    `net_amount` DECIMAL(18,2) COMMENT 'The net receivable amount excluding tax. Represents the base service charge before tax application.',
    `outstanding_amount` DECIMAL(18,2) COMMENT 'The remaining unpaid balance on this receivable after partial payments or adjustments. Zero when fully cleared.',
    `payment_terms_code` STRING COMMENT 'The payment terms code applied to this receivable (e.g., NET30, NET60, 2/10NET30). Defines the payment deadline and discount conditions.',
    `posting_amount` DECIMAL(18,2) COMMENT 'The gross receivable amount posted in the document currency. Represents the total amount owed by the customer for this transaction.',
    `posting_date` DATE COMMENT 'The date when this accounts receivable entry was posted to the general ledger. Represents the accounting period assignment date.',
    `posting_text` STRING COMMENT 'Free-text description or memo field providing additional context about this AR posting. May include service details or special notes.',
    `profit_center_code` STRING COMMENT 'The profit center code for internal segment reporting. Enables EBITDA analysis by business unit or terminal.',
    `reference_key_1` STRING COMMENT 'First reference field for additional business context. May contain vessel visit ID, container number, or other operational reference.',
    `reference_key_2` STRING COMMENT 'Second reference field for additional business context. May contain bill of lading number, booking reference, or service order number.',
    `reference_key_3` STRING COMMENT 'Third reference field for additional business context. May contain terminal code, berth number, or other operational identifier.',
    `revenue_recognition_date` DATE COMMENT 'The date when revenue was recognized for this receivable posting, following accrual accounting principles and revenue recognition standards.',
    `reversal_document_number` STRING COMMENT 'The financial document number of the reversal transaction if this posting was reversed. Null if not reversed.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this posting has been reversed or cancelled. True if reversed, false if active.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax component included in the posting amount. Separated for tax reporting and reconciliation purposes.',
    `write_off_date` DATE COMMENT 'The date when this receivable was written off. Null if not written off.',
    `write_off_flag` BOOLEAN COMMENT 'Indicates whether this receivable has been written off as uncollectible bad debt. True if written off, false otherwise.',
    `write_off_reason` STRING COMMENT 'The business reason for writing off this receivable (e.g., bankruptcy, uncollectible, customer dispute settlement). Null if not written off.',
    CONSTRAINT pk_receivable PRIMARY KEY(`receivable_id`)
) COMMENT 'Accounts Receivable (AR) financial posting recording revenue recognised from port services including THC, wharfage (WHR), pilotage fees, demurrage (DMG), detention (DET), berthage, and other tariff charges. Captures customer account, invoice reference from billing domain, posting date, amount, currency, clearing status, and aging bucket. Sourced from SAP FI-AR module. Complements the billing domain (which owns invoice generation) by recording the FI accounting entry and receivable balance. SSOT for AR subledger balances and customer payment tracking within finance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` (
    `budget_plan_id` BIGINT COMMENT 'Unique identifier for the budget plan record. Primary key for the budget plan entity.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Budget plans can be associated with cost centres. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_center_code STRING column can remain as a denormaliz',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Budget plans can be associated with GL accounts. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can remain as a denormalized c',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Budget plans are prepared at org unit level for headcount planning, opex budgeting, and resource allocation — core finance-HR planning integration for port operational and capital budgeting cycles.',
    `procurement_plan_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_plan. Business justification: Annual budget planning drives procurement planning. Port procurement plans (bunker fuel, spare parts, services) align with approved budgets. Enables budget-to-procurement plan reconciliation and commi',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or manager responsible for this budget plan. Typically a department head or cost center manager.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Budget plans can be associated with profit centres. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_center_code STRING column can remain as a de',
    `tertiary_budget_modified_by_employee_id` BIGINT COMMENT 'Identifier of the user who last modified the budget plan record. Provides accountability for changes.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Budget plans can be associated with WBS elements. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element_code STRING column can remain as a denormaliz',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'Percentage of total budget allocated to this line item. Used for proportional distribution and variance analysis (0.00 to 100.00).',
    `approval_date` DATE COMMENT 'Date when the budget plan was formally approved by authorized signatory. Marks transition to active budget status.',
    `approval_status` STRING COMMENT 'Current approval workflow status of the budget plan. Tracks progression from draft through approval to locked final state.. Valid values are `DRAFT|SUBMITTED|UNDER_REVIEW|APPROVED|REJECTED|LOCKED`',
    `baseline_version_flag` BOOLEAN COMMENT 'Indicates whether this is the baseline/original approved budget version (True) or a subsequent revision (False). Used for variance analysis.',
    `budget_category` STRING COMMENT 'High-level classification of budget expenditure type. Groups similar expense types for management reporting and analysis.. Valid values are `PERSONNEL|EQUIPMENT|MAINTENANCE|UTILITIES|SERVICES|MATERIALS`',
    `budget_line_description` STRING COMMENT 'Detailed textual description of the budget line item explaining the purpose and scope of the planned expenditure or investment.',
    `budget_type` STRING COMMENT 'Classification of budget as Operational Expenditure (OPEX), Capital Expenditure (CAPEX), or Mixed. Determines accounting treatment and reporting category.. Valid values are `OPEX|CAPEX|MIXED`',
    `budget_version_code` STRING COMMENT 'Version identifier for the budget plan (e.g., ORIGINAL, REVISED_Q1, FORECAST_Q2). Distinguishes between original budget, revised budgets, and rolling forecasts.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `business_justification` STRING COMMENT 'Business case or rationale for the budgeted amount. Explains strategic alignment, expected benefits, or operational necessity.',
    `commitment_status` STRING COMMENT 'Status indicating whether budget has been committed through purchase orders or contracts. Tracks budget consumption lifecycle.. Valid values are `UNCOMMITTED|COMMITTED|PARTIALLY_SPENT|FULLY_SPENT`',
    `contingency_percentage` DECIMAL(18,2) COMMENT 'Contingency reserve as percentage of planned amount (e.g., 5.00 for 5%). Provides buffer for risk and uncertainty in budget estimates.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the budget plan record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the planned amount (e.g., USD, EUR, GBP). Supports multi-currency budget planning.. Valid values are `^[A-Z]{3}$`',
    `fiscal_period` STRING COMMENT 'Fiscal period number within the fiscal year (1-12 for monthly, 1-4 for quarterly). Enables period-level budget allocation and variance tracking.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this budget plan applies (e.g., 2024, 2025). Represents the annual planning period.',
    `funding_source` STRING COMMENT 'Source of funding for the budget (internal reserves, government grant, loan, bond issuance, or public-private partnership). Critical for CAPEX planning.. Valid values are `INTERNAL|GOVERNMENT_GRANT|LOAN|BOND|PPP`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the budget plan record was last updated. Tracks most recent change for audit and version control.',
    `lock_date` DATE COMMENT 'Date when the budget plan was locked to prevent further changes. Establishes baseline for variance reporting.',
    `multi_year_flag` BOOLEAN COMMENT 'Indicates whether this budget plan spans multiple fiscal years (True) or is single-year (False). Used for long-term CAPEX projects.',
    `notes` STRING COMMENT 'Free-text field for additional comments, assumptions, or special instructions related to the budget plan. Captures planning context.',
    `planned_amount` DECIMAL(18,2) COMMENT 'Budgeted monetary amount for this line item in the base currency. Represents the approved spending or investment allocation.',
    `planning_scenario` STRING COMMENT 'Scenario type for budget planning (base case, optimistic, pessimistic, or reforecast). Supports scenario-based planning and sensitivity analysis.. Valid values are `BASE|OPTIMISTIC|PESSIMISTIC|REFORECAST`',
    `quarterly_distribution_q1` DECIMAL(18,2) COMMENT 'Planned budget amount allocated to first quarter (Q1). Supports quarterly phasing and cash flow planning.',
    `quarterly_distribution_q2` DECIMAL(18,2) COMMENT 'Planned budget amount allocated to second quarter (Q2). Supports quarterly phasing and cash flow planning.',
    `quarterly_distribution_q3` DECIMAL(18,2) COMMENT 'Planned budget amount allocated to third quarter (Q3). Supports quarterly phasing and cash flow planning.',
    `quarterly_distribution_q4` DECIMAL(18,2) COMMENT 'Planned budget amount allocated to fourth quarter (Q4). Supports quarterly phasing and cash flow planning.',
    `reforecast_cycle` STRING COMMENT 'Identifies the reforecast cycle when budget was revised (quarterly or mid-year/year-end). Supports rolling forecast process.. Valid values are `Q1|Q2|Q3|Q4|MID_YEAR|YEAR_END`',
    `strategic_initiative_code` STRING COMMENT 'Code linking budget to corporate strategic initiative or transformation program. Enables strategic portfolio tracking and reporting.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `submission_date` DATE COMMENT 'Date when the budget plan was submitted for approval. Tracks budget planning cycle timeline.',
    `variance_threshold_percentage` DECIMAL(18,2) COMMENT 'Acceptable variance threshold for budget vs. actual comparison (e.g., 10.00 means ±10%). Triggers alerts when exceeded.',
    CONSTRAINT pk_budget_plan PRIMARY KEY(`budget_plan_id`)
) COMMENT 'Annual and multi-year budget record for the port authority covering OPEX and CAPEX budgets with full line-item detail. Includes plan header (version, fiscal year, approval status, budget owner) and detailed line items by GL account, cost centre, profit centre, WBS element, and fiscal period with planned amounts. Supports original budget, revised budget, and rolling forecast versions. Enables granular budget vs. actual variance analysis, CAPEX/OPEX split tracking, quarterly reforecast, and management reporting drill-down. Sourced from SAP CO planning. SSOT for approved financial budgets and budget line allocations.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` (
    `budget_line_id` BIGINT COMMENT 'Unique identifier for the budget line item. Primary key.',
    `budget_plan_id` BIGINT COMMENT 'Reference to the parent budget plan that contains this line item. Links to the budget plan header.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Budget lines are planned for cost centres. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_centre_code STRING column can remain as a denormalized code',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Budget lines are planned for GL accounts. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can remain as a denormalized code.',
    `material_group_id` BIGINT COMMENT 'Foreign key linking to procurement.material_group. Business justification: Budget lines structured by material group (fuel, spare parts, services) for procurement category spend control. Enables category-based budget planning, spend analysis, and procurement category managem',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Budget lines roll up to org units for detailed budget tracking, variance analysis, and organizational performance measurement in port financial planning and control processes.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Budget lines are planned for profit centres. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_centre_code STRING column can remain as a denormali',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Budget lines are planned for WBS elements. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element_code STRING column can remain as a denormalized code',
    `actual_amount` DECIMAL(18,2) COMMENT 'Actual amount spent against this budget line to date. Updated from posted financial transactions for budget vs. actual variance analysis.',
    `approval_status` STRING COMMENT 'Approval workflow status for this budget line. Tracks the approval process through management hierarchy.. Valid values are `pending|approved|rejected|revision_required`',
    `approved_by` STRING COMMENT 'User ID or name of the person who approved this budget line. Tracks accountability for budget approvals.',
    `approved_date` DATE COMMENT 'Date when this budget line was approved. Used for audit trail and compliance reporting.',
    `asset_class_code` STRING COMMENT 'Asset class code for CAPEX budget lines linked to fixed asset acquisitions (e.g., cranes, terminal equipment, infrastructure).. Valid values are `^[A-Z0-9]{4,8}$`',
    `available_budget` DECIMAL(18,2) COMMENT 'Available budget amount calculated as planned amount minus commitment amount minus actual amount. Represents remaining funds available for spending.',
    `budget_category` STRING COMMENT 'High-level budget category distinguishing capital expenditure from operational expenditure for financial planning and reporting.. Valid values are `CAPEX|OPEX`',
    `budget_owner` STRING COMMENT 'User ID or name of the budget owner responsible for managing and monitoring this budget line. Typically the cost centre manager or project manager.',
    `budget_status` STRING COMMENT 'Current lifecycle status of the budget line item. Controls whether the line can be modified or used for budget checking. [ENUM-REF-CANDIDATE: draft|submitted|approved|active|frozen|closed|cancelled — 7 candidates stripped; promote to reference product]',
    `budget_type` STRING COMMENT 'Detailed budget type classification for granular expense categorization and analysis. [ENUM-REF-CANDIDATE: personnel|materials|services|equipment|infrastructure|maintenance|utilities|overhead|other — 9 candidates stripped; promote to reference product]',
    `budget_version` STRING COMMENT 'Budget version identifier distinguishing original budget from reforecasts and revisions (e.g., V0 for original, V1 for Q1 reforecast, V2 for Q2 reforecast).. Valid values are `^[A-Z0-9]{1,3}$`',
    `business_unit_code` STRING COMMENT 'Business unit or division code for consolidated reporting and multi-entity budget management.. Valid values are `^[A-Z0-9]{2,6}$`',
    `commitment_amount` DECIMAL(18,2) COMMENT 'Committed amount against this budget line from purchase orders or contracts. Tracks funds encumbered but not yet spent.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this budget line record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the planned amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `external_reference_code` STRING COMMENT 'External reference identifier linking this budget line to source system records or third-party planning tools.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year for this budget line. Typically 1-12 for monthly periods or 1-4 for quarterly periods.',
    `fiscal_year` STRING COMMENT 'Fiscal year for which this budget line is planned. Four-digit year representation.',
    `functional_area_code` STRING COMMENT 'Functional area code for cross-organizational cost allocation and reporting (e.g., operations, administration, sales, marine services).. Valid values are `^[A-Z0-9]{2,6}$`',
    `fund_code` STRING COMMENT 'Fund or grant code for tracking restricted or designated funds, particularly for government-funded port infrastructure projects.. Valid values are `^[A-Z0-9]{2,10}$`',
    `investment_program_code` STRING COMMENT 'Investment program or portfolio code for grouping related CAPEX projects and infrastructure development initiatives.. Valid values are `^[A-Z0-9]{4,12}$`',
    `is_carry_forward` BOOLEAN COMMENT 'Boolean flag indicating whether unused budget from this line should be carried forward to the next fiscal period or year.',
    `is_locked` BOOLEAN COMMENT 'Boolean flag indicating whether this budget line is locked from further modifications. Used during budget freeze periods or after final approval.',
    `line_number` STRING COMMENT 'Sequential line number within the budget plan for ordering and reference purposes.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this budget line record. Audit trail for change accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this budget line record was last modified. Audit trail for tracking changes.',
    `notes` STRING COMMENT 'Free-text notes or comments providing additional context, justification, or assumptions for this budget line item.',
    `planned_amount` DECIMAL(18,2) COMMENT 'Planned budget amount for this line item in the budget plan currency. Represents the approved spending allocation for the fiscal period.',
    `quantity` DECIMAL(18,2) COMMENT 'Planned quantity or volume associated with this budget line (e.g., number of units, hours, TEU throughput). Optional field for quantity-based budgeting.',
    `strategic_initiative_code` STRING COMMENT 'Strategic initiative or corporate objective code linking budget allocation to strategic planning and KPI targets.. Valid values are `^[A-Z0-9]{4,12}$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the budget quantity (e.g., TEU, FEU, HOURS, UNITS, MT for metric tons). Follows ISO or industry-standard UOM codes.. Valid values are `^[A-Z]{2,6}$`',
    `unit_price` DECIMAL(18,2) COMMENT 'Planned unit price or rate used to calculate the planned amount. Derived from quantity multiplied by unit price.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Variance amount calculated as planned amount minus actual amount. Positive variance indicates under-spend, negative indicates over-spend.',
    `variance_percentage` DECIMAL(18,2) COMMENT 'Variance percentage calculated as (variance amount / planned amount) * 100. Provides relative measure of budget performance.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this budget line record. Audit trail for accountability.',
    CONSTRAINT pk_budget_line PRIMARY KEY(`budget_line_id`)
) COMMENT 'Individual budget line item within a budget plan capturing planned amounts by GL account, cost centre, profit centre, WBS element, and fiscal period. Enables granular budget vs. actual variance analysis at account and cost object level. Supports CAPEX/OPEX split tracking, quarterly reforecast updates, and management reporting drill-down.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` (
    `cost_allocation_id` BIGINT COMMENT 'Unique identifier for the cost allocation record. Primary key for the cost allocation transaction.',
    `allocation_cycle_id` BIGINT COMMENT 'Unique identifier for the allocation cycle or rule set in SAP CO. Groups multiple allocation transactions executed together in a single assessment or distribution run.',
    `gl_account_id` BIGINT COMMENT 'Cost element (primary or secondary) to which the allocated cost is posted. Secondary cost elements are typically used for internal allocations and do not correspond to general ledger accounts.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Cost allocation runs (overhead distribution, service charge-backs, intercompany recharges) require audit trail of who executed the allocation for financial control, dispute resolution, and SOX complia',
    `org_unit_id` BIGINT COMMENT 'Foreign key linking to workforce.org_unit. Business justification: Cost allocations often target org units as receivers for overhead distribution, shared service charge-backs, and intercompany recharges in maritime multi-terminal and business unit cost management.',
    `cost_centre_id` BIGINT COMMENT 'Cost centre from which costs are being allocated. Typically represents shared service departments such as finance, HR, IT, facilities, or shared equipment pools.',
    `profit_centre_id` BIGINT COMMENT 'Profit centre receiving the allocated costs. Used when allocation targets a profit centre directly for segment reporting and profitability analysis.',
    `wbs_element_id` BIGINT COMMENT 'WBS element receiving the allocated costs. Used when allocation targets a capital project or infrastructure development initiative tracked in SAP PS.',
    `reversed_allocation_cost_allocation_id` BIGINT COMMENT 'Reference to the original cost allocation record that this transaction reverses. Populated only when reversal_indicator is True.',
    `allocated_amount` DECIMAL(18,2) COMMENT 'Monetary amount allocated from sender to receiver in the base currency. Represents the share of sender costs attributed to the receiver based on the allocation basis.',
    `allocation_basis_quantity` DECIMAL(18,2) COMMENT 'Quantity of the allocation basis driver consumed by the receiver. For example, number of TEUs handled, number of vessel calls, square metres of floor space, or kilowatt-hours of power consumed.',
    `allocation_basis_type` STRING COMMENT 'Statistical key figure or driver used to allocate costs from sender to receiver. TEU/FEU throughput allocates based on container volume handled; vessel calls allocate based on number of ship visits; berth-metres allocate based on berth occupancy; headcount allocates based on employee count; floor area allocates based on square metres occupied; equipment hours allocate based on crane or machinery usage; utility consumption allocates based on power or water usage; fixed percentage or amount allocates based on predetermined rates. [ENUM-REF-CANDIDATE: teu_throughput|feu_throughput|vessel_calls|berth_metres|headcount|floor_area_sqm|equipment_hours|power_consumption_kwh|water_consumption_m3|fixed_percentage|fixed_amount — 11 candidates stripped; promote to reference product]',
    `allocation_basis_unit` STRING COMMENT 'Unit of measure for the allocation basis quantity. TEU = Twenty-foot Equivalent Unit; FEU = Forty-foot Equivalent Unit; CALLS = vessel calls; METRES = berth-metres; HEADCOUNT = number of employees; SQM = square metres; HOURS = equipment operating hours; KWH = kilowatt-hours; M3 = cubic metres; PERCENT = percentage; AMOUNT = fixed monetary amount. [ENUM-REF-CANDIDATE: TEU|FEU|CALLS|METRES|HEADCOUNT|SQM|HOURS|KWH|M3|PERCENT|AMOUNT — 11 candidates stripped; promote to reference product]',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'Percentage of sender costs allocated to this receiver. Used when allocation is based on fixed percentage splits rather than statistical key figures. Value between 0.00 and 100.00.',
    `allocation_rule_description` STRING COMMENT 'Detailed description of the allocation rule or methodology applied. Explains the business logic, allocation basis, and rationale for the cost distribution.',
    `allocation_run_timestamp` TIMESTAMP COMMENT 'Date and time when the allocation cycle was executed in SAP CO. Used for audit trail and to distinguish between multiple runs in the same period.',
    `allocation_status` STRING COMMENT 'Current status of the cost allocation record. Draft = allocation prepared but not yet posted; Posted = allocation successfully posted to CO; Reversed = allocation has been reversed; Error = allocation failed during posting.. Valid values are `draft|posted|reversed|error`',
    `allocation_type` STRING COMMENT 'Type of cost allocation method applied. Assessment allocates costs based on statistical key figures; distribution allocates based on percentage or fixed amounts; periodic reposting transfers costs between cost centers; settlement closes internal orders or projects to receivers; overhead allocation applies indirect cost rates.. Valid values are `assessment|distribution|periodic_reposting|settlement|overhead_allocation`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the allocation was approved for posting. Used for audit trail and workflow tracking.',
    `approved_by_user` STRING COMMENT 'SAP user ID of the person who approved the allocation for posting. Used for segregation of duties and approval workflow tracking.. Valid values are `^[A-Z0-9]{6,12}$`',
    `business_area` STRING COMMENT 'Business area for cross-company code reporting. Represents a business segment or division that may span multiple legal entities.. Valid values are `^[A-Z0-9]{4}$`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity to which this allocation belongs. Used for statutory reporting and legal entity consolidation.. Valid values are `^[A-Z0-9]{4}$`',
    `controlling_area` STRING COMMENT 'SAP controlling area in which the allocation is executed. Represents the organizational unit for management accounting and cost controlling.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_element_code` STRING COMMENT 'Business code of the cost element. Human-readable identifier used in management accounting and cost reporting.. Valid values are `^[0-9]{6,10}$`',
    `created_by_user` STRING COMMENT 'SAP user ID of the person or system account that created or executed the allocation cycle. Used for audit trail and accountability.. Valid values are `^[A-Z0-9]{6,12}$`',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the allocated amount. Typically the controlling area currency or company code currency in SAP.. Valid values are `^[A-Z]{3}$`',
    `document_header_text` STRING COMMENT 'Free-text description or reference entered at the document header level. Provides context for the allocation run, such as Q1 2024 Corporate Overhead Allocation or Monthly Utilities Distribution - March 2024.',
    `document_number` STRING COMMENT 'Unique SAP CO document number generated for the allocation posting. Used for audit trail and drill-down to source transaction details.. Valid values are `^[0-9]{10}$`',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year in which the cost allocation is posted. Typically 1-12 for regular periods, 13-16 for special/adjustment periods.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the cost allocation is posted. Four-digit year (e.g., 2024).',
    `notes` STRING COMMENT 'Additional free-text notes or comments related to the allocation. May include explanations for adjustments, special circumstances, or references to supporting documentation.',
    `posting_date` DATE COMMENT 'Date on which the cost allocation transaction was posted to the controlling area. Determines the fiscal period and year for financial reporting.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Date and time when this cost allocation record was first created in the data warehouse. Used for data lineage and audit trail.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this cost allocation record was last updated in the data warehouse. Used for change tracking and data freshness monitoring.',
    `reversal_indicator` BOOLEAN COMMENT 'Indicates whether this allocation record is a reversal of a previous allocation. True if this is a reversal transaction; False if this is an original allocation.',
    `sender_original_cost_amount` DECIMAL(18,2) COMMENT 'Total original cost amount in the sender cost centre before allocation. Provides context for the allocation and enables reconciliation of sender balances.',
    `terminal_code` STRING COMMENT 'Code identifying the port terminal or facility to which this allocation relates. Used for terminal-level profitability analysis and operational cost tracking.. Valid values are `^[A-Z0-9]{3,6}$`',
    CONSTRAINT pk_cost_allocation PRIMARY KEY(`cost_allocation_id`)
) COMMENT 'Periodic cost allocation, assessment, and distribution cycle record capturing the redistribution of shared overhead costs from sender cost centres to receiver cost centres, profit centres, or WBS elements. Covers corporate overhead (finance, HR, IT), shared utilities (power, water), common-use infrastructure costs, and shared equipment pools. Records allocation rule/cycle ID, sender, receiver, allocation basis (TEU throughput, vessel calls, headcount, berth-metres, floor area), allocated amount, fiscal period, and posting reference. Sourced from SAP CO assessment/distribution cycles. Critical for accurate profit centre P&L and terminal-level profitability analysis.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` (
    `fixed_asset_id` BIGINT COMMENT 'Unique identifier for the fixed asset record in the FI-AA subledger. Primary key for the fixed asset financial register.',
    `company_code_id` BIGINT COMMENT 'FK to finance.company_code',
    `cost_centre_id` BIGINT COMMENT 'FK to finance.cost_centre',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Fixed assets are categorized by equipment type (STS cranes, RTGs, reach stackers) for depreciation schedules, maintenance budgeting, and replacement planning. Required for fleet management and capex p',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Port fixed assets (cranes, forklifts, buildings) are physically located at specific berths/terminals/yards. Essential for asset register by location, depreciation allocation, insurance valuation, and ',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Asset acquisitions (cranes, reach stackers, terminal tractors) link PO to asset master for capitalization tracking. Enables asset acquisition audit trail and work-in-progress to fixed asset transfer.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Every port fixed asset (cranes, RTGs, terminal equipment) requires assigned custodian for maintenance accountability, insurance claims, and asset verification audits. Replaces denormalized responsible',
    `vendor_id` BIGINT COMMENT 'FK to procurement.vendor',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation expense recognized to date since acquisition. Contra-asset account reducing the gross book value to net book value.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'Original purchase price or construction cost of the asset including all costs necessary to bring the asset to working condition (purchase price, freight, installation, commissioning).',
    `acquisition_date` DATE COMMENT 'Date the asset was acquired or placed in service. Marks the start of the depreciation schedule for financial reporting.',
    `asset_category` STRING COMMENT 'High-level grouping of the asset for reporting and analysis. Aligns with port operational divisions and CAPEX planning categories. [ENUM-REF-CANDIDATE: cargo_handling_equipment|berth_infrastructure|buildings|vessels|it_systems|vehicles|land|other — 8 candidates stripped; promote to reference product]',
    `asset_class_code` STRING COMMENT 'Classification code defining the asset category (e.g., STS crane, RTG, building, vessel, IT equipment). Determines depreciation rules and financial treatment.. Valid values are `^[A-Z0-9]{4,8}$`',
    `asset_description` STRING COMMENT 'Detailed business description of the fixed asset including make, model, capacity, and location (e.g., Ship-to-Shore Quay Crane - Berth 5 - 65T SWL).',
    `asset_number` STRING COMMENT 'External business identifier for the asset. Unique asset tag or registration number used across the organization for asset identification (e.g., crane serial number, building code).. Valid values are `^[A-Z0-9]{8,12}$`',
    `asset_status` STRING COMMENT 'Current lifecycle status of the asset in the financial register. Active assets are in service and depreciating; under construction assets are capitalizing costs; retired/disposed assets are no longer on the balance sheet.. Valid values are `active|under_construction|retired|disposed|transferred|impaired`',
    `asset_sub_number` STRING COMMENT 'Sub-asset identifier for components or modules of a main asset (e.g., crane boom, spreader, trolley). Allows component-level depreciation and maintenance tracking.. Valid values are `^[A-Z0-9]{1,4}$`',
    `business_area_code` STRING COMMENT 'Business segment or division code for management reporting (e.g., container terminal, bulk terminal, marine services). Enables segment-level balance sheet and P&L.. Valid values are `^[A-Z0-9]{4}$`',
    `capitalization_date` DATE COMMENT 'Date when the asset under construction (AUC) was capitalized and transferred to the fixed asset register. Marks the transition from CAPEX accumulation to depreciation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the fixed asset record was first created in the financial system. Audit trail for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts (acquisition cost, NBV, depreciation). Port authorities may hold assets in multiple currencies for international operations.. Valid values are `^[A-Z]{3}$`',
    `depreciation_method` STRING COMMENT 'Accounting method used to allocate the cost of the asset over its useful life. Straight-line is most common for port infrastructure; units of production may be used for mobile equipment based on TEU handled.. Valid values are `straight_line|declining_balance|units_of_production|sum_of_years_digits`',
    `depreciation_start_date` DATE COMMENT 'Date when depreciation posting begins. Typically the first day of the month following acquisition or capitalization.',
    `disposal_proceeds` DECIMAL(18,2) COMMENT 'Cash or fair value received from the sale or disposal of the asset. Used to calculate gain or loss on disposal for P&L reporting.',
    `funding_source` STRING COMMENT 'Source of capital used to finance the asset acquisition (e.g., internal CAPEX budget, government infrastructure grant, loan, PPP arrangement). Important for financial planning and grant compliance.. Valid values are `internal_capex|government_grant|loan_financing|public_private_partnership|lease`',
    `grant_amount` DECIMAL(18,2) COMMENT 'Amount of government or public funding received for the asset acquisition. Recognized as deferred income and amortized over the assets useful life per IAS 20.',
    `impairment_amount` DECIMAL(18,2) COMMENT 'Total impairment loss recognized when the recoverable amount of the asset falls below its carrying value. Recorded as a write-down in the P&L.',
    `insurance_policy_number` STRING COMMENT 'Policy number covering the asset under the port authoritys property and equipment insurance. Required for risk management and claims processing.. Valid values are `^[A-Z0-9]{8,15}$`',
    `insured_value` DECIMAL(18,2) COMMENT 'Declared value of the asset for insurance purposes. May differ from net book value; typically based on replacement cost.',
    `is_leased` BOOLEAN COMMENT 'Indicates whether the asset is held under a lease arrangement (finance lease or operating lease under IFRS 16). True if leased, false if owned outright.',
    `last_depreciation_date` DATE COMMENT 'Date of the most recent depreciation posting. Used to track depreciation run status and ensure monthly postings are complete.',
    `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified the asset record. Required for audit trail and change management.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the fixed asset record. Tracks changes for audit and reconciliation purposes.',
    `last_revaluation_date` DATE COMMENT 'Date of the most recent fair value revaluation. Port authorities may revalue land, berths, and specialized infrastructure periodically.',
    `lease_contract_number` STRING COMMENT 'Reference number of the lease agreement if the asset is leased. Links to the contract management system for lease terms and payment schedules.. Valid values are `^[A-Z0-9]{8,15}$`',
    `net_book_value` DECIMAL(18,2) COMMENT 'Current carrying value of the asset on the balance sheet. Calculated as acquisition cost plus subsequent capital additions minus accumulated depreciation and impairments.',
    `notes` STRING COMMENT 'Free-text field for additional financial or operational notes about the asset (e.g., special depreciation treatment, pending disposal, revaluation justification).',
    `residual_value` DECIMAL(18,2) COMMENT 'Estimated salvage or scrap value of the asset at the end of its useful life. Depreciation is calculated on acquisition cost minus residual value.',
    `retirement_date` DATE COMMENT 'Date the asset was retired from service or disposed. Triggers final depreciation calculation and removal from the active asset register.',
    `revaluation_reserve` DECIMAL(18,2) COMMENT 'Cumulative revaluation surplus recognized in equity when the asset is revalued to fair value under the revaluation model. Common for land and specialized port infrastructure.',
    `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer. Used for warranty claims, spare parts ordering, and equipment traceability.',
    `tax_depreciation_method` STRING COMMENT 'Depreciation method used for tax reporting purposes. May differ from book depreciation method to optimize tax deductions within regulatory limits.. Valid values are `straight_line|declining_balance|accelerated|none`',
    `tax_useful_life_years` DECIMAL(18,2) COMMENT 'Useful life prescribed by tax regulations for depreciation deductions. Often differs from accounting useful life.',
    `useful_life_years` DECIMAL(18,2) COMMENT 'Expected economic life of the asset in years over which depreciation is calculated. Determined by asset class and operational usage patterns.',
    `warranty_expiry_date` DATE COMMENT 'Date when the manufacturer or vendor warranty expires. Critical for maintenance planning and cost forecasting.',
    CONSTRAINT pk_fixed_asset PRIMARY KEY(`fixed_asset_id`)
) COMMENT 'Fixed asset financial register representing the FI-AA subledger view of port authority capital assets including all asset financial transactions. Covers quay cranes (STS/QC), RTGs, ASCs, MHCs, berth infrastructure, buildings, vessels, and IT systems. Captures asset master data (class, acquisition date/cost, useful life, depreciation method, net book value, location) AND all financial movements (acquisitions, retirements, transfers, write-downs, revaluations, periodic depreciation postings) with transaction type, posting date, amount, and originating document. SSOT for financial asset valuation, depreciation schedules, and statutory asset reporting. Note: physical/operational asset lifecycle (maintenance, condition, SWL, work orders) owned by asset domain.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` (
    `asset_transaction_id` BIGINT COMMENT 'Unique identifier for the fixed asset financial transaction record in SAP FI-AA. Primary key for asset transaction tracking.',
    `cost_centre_id` BIGINT COMMENT 'Reference to the cost center responsible for the asset or receiving the depreciation expense. Links to SAP CO controlling structure for OPEX tracking.',
    `fixed_asset_id` BIGINT COMMENT 'Reference to the fixed asset (port infrastructure, equipment, facility) that this transaction applies to. Links to the master asset register.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Asset transactions post to GL accounts for financial accounting. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can remain as ',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Asset transactions can be charged to internal orders for cost tracking. New FK column internal_order_id will be created to link to the internal order master for budget and commitment tracking.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Asset transactions (acquisitions, transfers, disposals) occur at specific port locations. Required for asset movement tracking, location-based capex reporting, and intercompany transfer pricing betwee',
    `profit_centre_id` BIGINT COMMENT 'Reference to the profit center for internal management reporting and performance measurement. Links asset costs to revenue-generating business units.',
    `project_id` BIGINT COMMENT 'Reference to the capital project or infrastructure development program associated with the asset transaction. Links CAPEX spending to strategic port development initiatives.',
    `reversed_transaction_asset_transaction_id` BIGINT COMMENT 'Reference to the original asset transaction that this entry reverses. Null for original postings. Maintains audit trail for corrections.',
    `security_equipment_id` BIGINT COMMENT 'Foreign key linking to security.security_equipment. Business justification: Acquisitions, disposals, impairments, and revaluations of security equipment generate asset transactions that must be linked to equipment records for audit trail, gain/loss calculation, and fixed asse',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor/supplier for asset acquisitions or service providers for asset-related transactions. Null for internal transactions.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Asset transactions can be allocated to WBS elements for project cost tracking. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element STRING column ca',
    `approval_date` DATE COMMENT 'Date when the asset transaction was approved in the workflow. Null for transactions not requiring approval.',
    `approved_by_user` STRING COMMENT 'SAP user ID of the approver for transactions requiring workflow approval (large acquisitions, write-downs, disposals). Null for auto-approved transactions.',
    `asset_class` STRING COMMENT 'Classification of the asset for accounting and reporting purposes (buildings, machinery, vehicles, IT equipment, infrastructure). Determines depreciation rules and financial statement presentation.',
    `asset_value_date` DATE COMMENT 'Date from which the asset transaction affects asset valuation and depreciation calculation. May differ from posting date for backdated transactions.',
    `business_area` STRING COMMENT 'SAP FI business area for segment reporting (container terminal, bulk cargo, RoRo operations, marine services). Enables profitability analysis by port business line.',
    `capex_opex_indicator` STRING COMMENT 'Indicates whether the transaction represents capital expenditure (asset acquisition, major improvement) or operational expenditure (maintenance, repair). Critical for financial analysis and EBITDA calculation.. Valid values are `CAPEX|OPEX`',
    `company_code_amount` DECIMAL(18,2) COMMENT 'Transaction amount converted to the company code currency for consolidated financial reporting. Used when transaction currency differs from reporting currency.',
    `company_code_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the company code reporting currency.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the asset transaction record was first created in SAP FI-AA. Audit field for data lineage and compliance.',
    `depreciation_area` STRING COMMENT 'SAP FI-AA depreciation area code indicating the valuation view (book depreciation, tax depreciation, IFRS, group reporting). Enables parallel asset valuation for different reporting requirements.',
    `depreciation_method` STRING COMMENT 'Depreciation calculation method applied to the asset (straight-line, declining balance, units of production). Determines how asset value is allocated over useful life.. Valid values are `straight_line|declining_balance|units_of_production|sum_of_years_digits`',
    `document_date` DATE COMMENT 'Date on the originating source document (invoice, purchase order, transfer order) that triggered this asset transaction.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year when the transaction was posted. Used for monthly financial close and management reporting.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the asset transaction is recorded for financial reporting and statutory compliance.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the asset transaction record was last modified. Tracks changes for audit and data quality monitoring.',
    `originating_document_number` STRING COMMENT 'Reference number of the source document that triggered the asset transaction (purchase order, invoice, work order, transfer document). Provides audit trail to originating business event.',
    `originating_document_type` STRING COMMENT 'Type of source document that initiated the asset transaction. Indicates the business process context (procurement, maintenance, internal transfer, manual adjustment). [ENUM-REF-CANDIDATE: purchase_order|invoice|work_order|transfer_order|journal_entry|disposal_document|revaluation_document — 7 candidates stripped; promote to reference product]',
    `posted_by_user` STRING COMMENT 'SAP user ID of the person who posted the asset transaction. Provides accountability and audit trail.',
    `posting_date` DATE COMMENT 'Date when the asset transaction was posted to the general ledger and became effective for financial reporting. Key date for period assignment and financial statement inclusion.',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of assets involved in the transaction for bulk asset movements or units-of-production depreciation. Null for single-asset transactions.',
    `reference_key` STRING COMMENT 'Additional reference field for external system integration or cross-reference to non-SAP documents (contract numbers, regulatory filing references).',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this transaction is a reversal of a previously posted transaction. True for correction entries.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount calculated on the asset transaction. Relevant for asset acquisitions subject to VAT/GST.',
    `tax_code` STRING COMMENT 'Tax code applied to the asset transaction for VAT, GST, or other applicable taxes on asset acquisitions or disposals.',
    `transaction_amount` DECIMAL(18,2) COMMENT 'Monetary value of the asset transaction in the company currency. Represents acquisition cost, depreciation amount, write-down value, or disposal proceeds depending on transaction type.',
    `transaction_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the transaction amount. Typically local port operating currency or USD for international transactions.. Valid values are `^[A-Z]{3}$`',
    `transaction_number` STRING COMMENT 'Business identifier for the asset transaction as recorded in SAP FI-AA. Externally visible transaction reference number.',
    `transaction_status` STRING COMMENT 'Current lifecycle status of the asset transaction in the financial system workflow.. Valid values are `draft|posted|reversed|cancelled|pending_approval|approved`',
    `transaction_text` STRING COMMENT 'Free-text description or notes about the asset transaction. Provides business context, justification, or additional details for audit and reporting.',
    `transaction_type` STRING COMMENT 'Type of asset financial transaction: acquisition (new asset purchase), retirement (asset removal), transfer (asset movement between cost centers), write-down (value reduction), depreciation (periodic value allocation), revaluation (fair value adjustment), impairment (loss recognition), disposal (sale), or capitalization (WIP to asset). [ENUM-REF-CANDIDATE: acquisition|retirement|transfer|write_down|depreciation|revaluation|impairment|disposal|capitalization — 9 candidates stripped; promote to reference product]',
    `unit_of_measure` STRING COMMENT 'Unit of measure for quantity field (each, TEU, meters, hours). Relevant for assets tracked by quantity or usage-based depreciation.',
    `useful_life_years` DECIMAL(18,2) COMMENT 'Estimated useful life of the asset in years at the time of transaction. Used for depreciation calculation and asset lifecycle planning. Relevant for acquisition and revaluation transactions.',
    `wbs_element` STRING COMMENT 'SAP PS work breakdown structure element for detailed project cost tracking. Enables granular CAPEX allocation to specific project phases or deliverables.',
    CONSTRAINT pk_asset_transaction PRIMARY KEY(`asset_transaction_id`)
) COMMENT 'Fixed asset financial transaction recording all asset movements in SAP FI-AA including acquisitions, retirements, transfers, write-downs, and depreciation postings. Captures transaction type, posting date, amount, asset value date, and originating document. Enables CAPEX tracking, asset lifecycle financial management, and statutory asset reporting for port infrastructure.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` (
    `intercompany_transaction_id` BIGINT COMMENT 'Unique identifier for the intercompany transaction record. Primary key.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Intercompany transactions can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_center_code STRING col',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Intercompany transactions post to GL accounts for financial accounting. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can rem',
    `agreement_id` BIGINT COMMENT 'Reference to the master netting agreement governing the offsetting of intercompany balances between the two legal entities.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Intercompany transactions can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_center_',
    `reversed_transaction_intercompany_transaction_id` BIGINT COMMENT 'Reference to the original intercompany transaction that this record reverses, establishing audit trail for corrections.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Intercompany transactions link two legal entities - this FK represents the sending company. New FK column sending_company_code_id will be created to properly link to the company_code master. The exist',
    `business_area_code` STRING COMMENT 'Business area classification for cross-company code segment reporting (e.g., container terminal operations, marine services, property management).. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center_code` STRING COMMENT 'Controlling (CO) cost center code for management accounting allocation of the intercompany transaction in the sending entity.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the intercompany transaction record was first created in the financial system.',
    `document_date` DATE COMMENT 'The date on the source business document (invoice, credit note, transfer order) that triggered the intercompany transaction.',
    `due_date` DATE COMMENT 'The contractual date by which the intercompany payable must be settled by the receiving entity.',
    `elimination_flag` BOOLEAN COMMENT 'Indicates whether this transaction must be eliminated in consolidated financial statements to avoid double-counting revenue and expenses within the group.',
    `elimination_status` STRING COMMENT 'Current state of the consolidation elimination process: pending elimination, successfully eliminated, requiring reconciliation, or flagged as exception.. Valid values are `pending|eliminated|reconciliation_required|exception`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied to convert transaction currency to local/group reporting currency at the transaction date.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or quarter) within the fiscal year when the transaction was posted, typically 1-12 for monthly periods.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the intercompany transaction was posted, used for period-based financial reporting and consolidation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the intercompany transaction record was last updated, supporting audit trail and change tracking.',
    `local_currency_amount` DECIMAL(18,2) COMMENT 'Transaction amount converted to the group reporting currency (typically the parent companys functional currency) for consolidated financial reporting.',
    `net_amount` DECIMAL(18,2) COMMENT 'The net payable/receivable amount after tax adjustments and any contractual deductions, representing the actual intercompany settlement obligation.',
    `netting_flag` BOOLEAN COMMENT 'Indicates whether this transaction is subject to intercompany netting arrangements where offsetting payables and receivables are settled on a net basis.',
    `payment_terms_code` STRING COMMENT 'Standard payment terms code defining the due date calculation and cash discount conditions for intercompany settlement (e.g., NET30, NET60).. Valid values are `^[A-Z0-9]{4}$`',
    `posting_date` DATE COMMENT 'The accounting period date when the intercompany transaction was posted to the general ledger in both sending and receiving entities.',
    `posting_text` STRING COMMENT 'Free-text field providing additional context or explanation for the intercompany transaction, visible in GL line item reports.',
    `profit_center_code` STRING COMMENT 'Profit center code for segment reporting and profitability analysis of the intercompany transaction.. Valid values are `^[A-Z0-9]{4,10}$`',
    `receiving_company_code` STRING COMMENT 'SAP company code of the legal entity receiving the intercompany transaction (e.g., stevedoring subsidiary, property holding entity, joint venture partner).. Valid values are `^[A-Z0-9]{4}$`',
    `reconciliation_status` STRING COMMENT 'Status of the intercompany balance reconciliation between sending and receiving entities: matched (both sides agree), unmatched, disputed, under review, or resolved.. Valid values are `matched|unmatched|disputed|under_review|resolved`',
    `reconciliation_variance_amount` DECIMAL(18,2) COMMENT 'The monetary difference between the sending entitys recorded payable and the receiving entitys recorded receivable, requiring investigation and resolution.',
    `reference_document_number` STRING COMMENT 'External reference to the originating business document: invoice number, purchase order, service agreement, or asset transfer document.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this transaction is a reversal or correction of a previously posted intercompany transaction.',
    `sending_company_code` STRING COMMENT 'SAP company code of the legal entity initiating the intercompany transaction (e.g., port authority headquarters, terminal operating subsidiary).. Valid values are `^[A-Z0-9]{4}$`',
    `service_description` STRING COMMENT 'Narrative description of the intercompany service rendered, goods transferred, or financial arrangement (e.g., shared IT services, terminal handling recharge, management consulting).',
    `settlement_date` DATE COMMENT 'The date when the intercompany obligation was fully settled through payment, netting, or other clearing mechanism.',
    `settlement_status` STRING COMMENT 'Current state of the intercompany payable/receivable: open (unpaid), partially settled, fully settled, netted against offsetting transactions, or cancelled.. Valid values are `open|partially_settled|fully_settled|netted|cancelled`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Value-added tax (VAT), goods and services tax (GST), or other applicable indirect taxes on the intercompany transaction, if jurisdictionally required.',
    `transaction_amount` DECIMAL(18,2) COMMENT 'The gross monetary value of the intercompany transaction before any adjustments, taxes, or netting, in the transaction currency.',
    `transaction_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the intercompany transaction was originally denominated (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `transaction_date` DATE COMMENT 'The actual business event date when the intercompany service was rendered, goods transferred, or financial obligation incurred.',
    `transaction_number` STRING COMMENT 'Business document number for the intercompany transaction, externally visible and used for reconciliation and audit trails.. Valid values are `^IC-[0-9]{10}$`',
    `transaction_type` STRING COMMENT 'Classification of the intercompany transaction nature: service charges between entities, management fees, cost center allocations, asset transfers, intercompany loans, dividend distributions, royalty payments, or expense recharges. [ENUM-REF-CANDIDATE: service_charge|management_fee|cost_allocation|asset_transfer|loan|dividend|royalty|recharge — 8 candidates stripped; promote to reference product]',
    `transfer_pricing_documentation_ref` STRING COMMENT 'Reference to the supporting transfer pricing study, master file, or local file documentation justifying the transaction pricing for tax authority compliance.',
    `transfer_pricing_method` STRING COMMENT 'The arms length pricing methodology applied to determine the intercompany transaction value for tax compliance (cost-plus, market price, negotiated rate, comparable uncontrolled price, resale-minus).. Valid values are `cost_plus|market_price|negotiated|comparable_uncontrolled|resale_minus`',
    CONSTRAINT pk_intercompany_transaction PRIMARY KEY(`intercompany_transaction_id`)
) COMMENT 'Intercompany financial transaction recording cross-entity postings between port authority legal entities, subsidiaries, or joint ventures (e.g., terminal operating companies, stevedoring subsidiaries, property holding entities). Captures sending company code, receiving company code, transaction type, amount, currency, netting status, and elimination flag for consolidated reporting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` (
    `company_code_id` BIGINT COMMENT 'Unique identifier for the company code entity. Primary key. Role: MASTER_RESOURCE (legal entity master).',
    `employee_id` BIGINT COMMENT 'User ID of the person who last modified this company code record. Used for audit trail and accountability in master data governance.',
    `activation_date` DATE COMMENT 'Date when the company code was activated in the ERP system and became available for financial postings. Determines the earliest valid posting date.',
    `business_area_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether business area assignment is mandatory for all financial postings. Used for cross-company code segment reporting and divisional analysis.',
    `business_registration_number` STRING COMMENT 'Official registration number assigned by the corporate registry or chamber of commerce. Used for legal entity verification, trade documentation, and regulatory filings.',
    `chart_of_accounts_code` STRING COMMENT 'Four-character code identifying the chart of accounts assigned to this company code. Determines the general ledger (GL) account structure and financial statement mapping.. Valid values are `^[A-Z0-9]{4}$`',
    `company_code` STRING COMMENT 'Four-character alphanumeric code uniquely identifying the legal entity within the corporate group. Used as the primary business identifier in SAP FI/CO and all financial transactions. Examples: PAUS (Port Authority US), TCSG (Terminal Container Singapore).. Valid values are `^[A-Z0-9]{4}$`',
    `consolidation_group_code` STRING COMMENT 'Code identifying the consolidation group or reporting segment to which this entity belongs. Used for segment reporting under IFRS 8 and management consolidation.. Valid values are `^[A-Z0-9]{4}$`',
    `controlling_area_code` STRING COMMENT 'Four-character code identifying the controlling area for management accounting. Links company code to cost centers, profit centers, and internal orders for OPEX and CAPEX tracking.. Valid values are `^[A-Z0-9]{4}$`',
    `country_of_incorporation` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the jurisdiction where the legal entity is incorporated. Determines applicable tax law, statutory reporting requirements, and regulatory oversight.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this company code record was first created in the system. Used for audit trail and data lineage tracking.',
    `credit_control_area` STRING COMMENT 'Four-character code identifying the credit control area for accounts receivable (AR) management. Determines credit limit checking, dunning procedures, and payment terms enforcement.. Valid values are `^[A-Z0-9]{4}$`',
    `deactivation_date` DATE COMMENT 'Date when the company code was deactivated or closed in the ERP system. Null for active entities. Used for historical reporting and audit trail.',
    `entity_status` STRING COMMENT 'Current operational status of the legal entity. Active entities participate in financial consolidation; inactive entities are excluded from operational reporting but retained for historical analysis.. Valid values are `active|inactive|dormant|liquidation|merged`',
    `entity_type` STRING COMMENT 'Classification of the legal entity by its primary business function within the port authority corporate group. Determines consolidation treatment and reporting hierarchy.. Valid values are `operating_company|terminal_subsidiary|stevedoring_entity|property_holding|marine_services|joint_venture`',
    `financial_statement_version` STRING COMMENT 'Four-character code identifying the financial statement version used for statutory reporting. Defines the mapping of GL accounts to balance sheet and income statement line items.. Valid values are `^[A-Z0-9]{4}$`',
    `fiscal_year_start_month` STRING COMMENT 'Numeric month (1-12) when the fiscal year begins. Used for period calculations, budget planning cycles, and year-end close procedures.',
    `fiscal_year_variant` STRING COMMENT 'Two-character code defining the fiscal year structure (calendar year, April-March, July-June, etc.) and number of posting periods. Determines period-end close schedules and financial reporting cycles.. Valid values are `^[A-Z0-9]{2}$`',
    `functional_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the primary economic environment in which the entity operates. Used for local currency accounting and translation to group reporting currency.. Valid values are `^[A-Z]{3}$`',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code used for consolidated financial statements at the corporate group level. All entity results are translated into this currency for consolidation.. Valid values are `^[A-Z]{3}$`',
    `incorporation_date` DATE COMMENT 'Date when the legal entity was officially incorporated or registered with the national corporate registry. Used for entity age calculations and historical analysis.',
    `intercompany_clearing_account` STRING COMMENT 'Ten-digit GL account number used for intercompany receivables and payables. Used in consolidation eliminations and intercompany reconciliation processes.. Valid values are `^[0-9]{10}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this company code record was last updated. Used for change tracking, audit trail, and data quality monitoring.',
    `legal_entity_identifier` STRING COMMENT '20-character ISO 17442 Legal Entity Identifier used for global financial reporting, regulatory compliance, and counterparty identification in financial transactions.. Valid values are `^[A-Z0-9]{20}$`',
    `legal_name` STRING COMMENT 'Full legal name of the company as registered with the national corporate registry. Used in statutory financial statements, tax filings, and legal contracts.',
    `notes` STRING COMMENT 'Free-text field for additional notes, special instructions, or historical context about the legal entity. Used for audit documentation and knowledge transfer.',
    `ownership_percentage` DECIMAL(18,2) COMMENT 'Percentage of equity ownership held by the parent entity. Determines consolidation method (full consolidation for >50%, equity method for 20-50%, cost method for <20%).',
    `parent_company_code` STRING COMMENT 'Company code of the immediate parent entity in the corporate hierarchy. Used for consolidation rollup, intercompany eliminations, and management reporting structures. Null for the ultimate parent entity.. Valid values are `^[A-Z0-9]{4}$`',
    `profit_center_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether profit center assignment is mandatory for all financial postings in this company code. True enforces profit center-based segment reporting.',
    `registered_address_line1` STRING COMMENT 'First line of the legal registered address as filed with the corporate registry. Used for statutory correspondence, legal notices, and regulatory filings.',
    `registered_address_line2` STRING COMMENT 'Second line of the legal registered address (suite, floor, building name). Optional field for additional address detail.',
    `registered_city` STRING COMMENT 'City or municipality of the legal registered address. Used for jurisdiction determination and tax domicile classification.',
    `registered_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the legal registered address. May differ from country of incorporation for entities with cross-border registrations.. Valid values are `^[A-Z]{3}$`',
    `registered_postal_code` STRING COMMENT 'Postal or ZIP code of the legal registered address. Used for mail delivery and geographic classification.',
    `registered_state_province` STRING COMMENT 'State, province, or administrative region of the legal registered address. Used for sub-national tax reporting and regulatory compliance.',
    `retained_earnings_account` STRING COMMENT 'Ten-digit GL account number for retained earnings. Used in year-end close procedures to carry forward profit or loss to equity.. Valid values are `^[0-9]{10}$`',
    `short_name` STRING COMMENT 'Abbreviated name or trading name used in operational reports, internal communications, and management dashboards.',
    `tax_registration_number` STRING COMMENT 'Primary tax identification number issued by the national tax authority. Used for corporate income tax filings, VAT/GST reporting, and withholding tax compliance.',
    `valuation_area` STRING COMMENT 'Four-character code defining the valuation area for asset accounting and inventory valuation. Determines depreciation methods, useful life, and asset capitalization thresholds.. Valid values are `^[A-Z0-9]{4}$`',
    `vat_registration_number` STRING COMMENT 'VAT or GST registration number issued by the tax authority. Required for VAT invoicing, input tax credit claims, and periodic VAT returns.',
    CONSTRAINT pk_company_code PRIMARY KEY(`company_code_id`)
) COMMENT 'Legal entity master representing each company within the port authority corporate group. Covers the port operating company, terminal operating subsidiaries (container terminal JVs), stevedoring entities, property holding companies, and marine services subsidiaries. Captures legal name, country of incorporation, functional currency, fiscal year variant, chart of accounts assignment, tax registration numbers, and registered address. SSOT for legal entity structure used in statutory reporting, intercompany eliminations, consolidated financial statements, and multi-entity transaction processing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` (
    `accrual_id` BIGINT COMMENT 'Unique identifier for the financial accrual record. Primary key for the accrual entity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every accrual belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can remain as',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Accruals can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_center_code STRING column can remain as',
    `employee_id` BIGINT COMMENT 'Foreign key reference to the employee or user who approved the accrual entry. Nullable if approval is not yet completed.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Accruals post to GL accounts for financial accounting. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can remain as a denormal',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Goods received not invoiced (GRNI) accruals link to goods receipts. Port finance accrues for received materials pending vendor invoice. Enables period-end GRNI accrual calculation and reconciliation.',
    `invoice_id` BIGINT COMMENT 'Foreign key reference to the invoice that this accrual is related to or will be settled against. Nullable for accruals not yet invoiced.',
    `participant_account_id` BIGINT COMMENT 'Foreign key reference to the port community participant account associated with this accrual. Links the accrual to the customer, vendor, or partner entity.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Accruals can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_center_code STRING colum',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.service_code. Business justification: Accruals for unbilled revenue or deferred costs are tied to specific port services. Required for period-end revenue recognition by service, matching principle compliance, and service-level margin anal',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Accruals can be allocated to WBS elements for project cost tracking. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element_code STRING column can rem',
    `accrual_date` DATE COMMENT 'The date on which the accrual is recognized for accounting purposes. Represents the business event date when the revenue or expense is deemed to have occurred.',
    `accrual_type` STRING COMMENT 'Classification of the accrual entry indicating whether it represents revenue accrual, expense accrual, prepayment, deferred revenue, provision, or reversal.. Valid values are `revenue|expense|prepayment|deferred_revenue|provision|reversal`',
    `amount` DECIMAL(18,2) COMMENT 'The monetary value of the accrual entry in the transaction currency. Represents the gross amount before any adjustments or allocations.',
    `approval_date` DATE COMMENT 'The date on which the accrual entry was approved by the authorized approver. Nullable if approval is pending or not required.',
    `approval_status` STRING COMMENT 'Approval workflow status indicating whether the accrual entry has been reviewed and approved by the authorized financial controller or manager.. Valid values are `pending|approved|rejected`',
    `business_area_code` STRING COMMENT 'The business area code representing the line of business or operational division to which this accrual belongs. Used for cross-company code reporting.. Valid values are `^[A-Z0-9]{4,10}$`',
    `accrual_category` STRING COMMENT 'Business category of the accrual such as port service revenue, demurrage (DMG), wharfage (WHR), terminal handling charge (THC), vendor services, employee entitlements, or other operational categories.',
    `created_by_user` STRING COMMENT 'The username or identifier of the user who created the accrual record in the source system. Used for audit trail and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the accrual record was first created in the source system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code representing the currency in which the accrual amount is denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `document_number` STRING COMMENT 'Unique business document number assigned to the accrual entry in the financial system. Used for audit trail and reference purposes.. Valid values are `^[A-Z0-9]{8,20}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the transaction currency amount to the local currency amount. Nullable if transaction and local currencies are the same.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year to which this accrual is assigned. Typically ranges from 1 to 12 for monthly periods.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this accrual belongs, used for annual financial reporting and budgeting alignment.',
    `last_modified_by_user` STRING COMMENT 'The username or identifier of the user who last modified the accrual record. Used for audit trail and change tracking.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the accrual record was last modified in the source system. Used for audit trail and change tracking.',
    `local_currency_amount` DECIMAL(18,2) COMMENT 'The accrual amount converted to the local reporting currency of the company code. Used for consolidated financial reporting.',
    `notes` STRING COMMENT 'Additional free-form notes or comments providing supplementary information about the accrual entry for audit, review, or operational purposes.',
    `posting_date` DATE COMMENT 'The date on which the accrual entry was posted to the general ledger. Used for period-end closing and financial reporting.',
    `posting_status` STRING COMMENT 'Current lifecycle status of the accrual entry indicating whether it is in draft, posted to the general ledger, reversed, or cancelled.. Valid values are `draft|posted|reversed|cancelled`',
    `posting_text` STRING COMMENT 'Free-text description providing additional context and explanation for the accrual entry. Used for audit trail and user reference.',
    `reason` STRING COMMENT 'Business justification or reason for creating the accrual, such as service rendered but not invoiced, goods received but not invoiced, or period-end matching requirement.',
    `reference_document_number` STRING COMMENT 'External reference document number such as a purchase order, delivery order (D/O), bill of lading (BOL), or service request number that provides business context for the accrual.',
    `reference_key_1` STRING COMMENT 'First flexible reference field for capturing additional business identifiers such as vessel visit number, container number, or booking reference.',
    `reference_key_2` STRING COMMENT 'Second flexible reference field for capturing supplementary business identifiers or cross-reference keys.',
    `reference_key_3` STRING COMMENT 'Third flexible reference field for capturing tertiary business identifiers or cross-reference keys.',
    `reversal_date` DATE COMMENT 'The date on which the accrual entry is scheduled to be automatically reversed in the subsequent accounting period. Nullable for accruals that do not require automatic reversal.',
    `reversal_period` STRING COMMENT 'The fiscal period in which the accrual is scheduled to be reversed. Used in conjunction with reversal_date for period-end automation.',
    `settlement_date` DATE COMMENT 'The date on which the accrual was fully settled or cleared against an actual transaction. Nullable for open accruals.',
    `settlement_status` STRING COMMENT 'Indicates whether the accrual has been settled against an actual invoice or payment. Used to track the lifecycle from accrual to final settlement.. Valid values are `open|partially_settled|fully_settled`',
    `variance_amount` DECIMAL(18,2) COMMENT 'The difference between the accrued amount and the actual invoiced or settled amount. Used for variance analysis and accrual accuracy assessment.',
    CONSTRAINT pk_accrual PRIMARY KEY(`accrual_id`)
) COMMENT 'Financial accrual record capturing period-end accruals and prepayments posted to ensure accurate matching of revenues and expenses within the correct fiscal period. Covers accruals for port service revenues not yet invoiced, vendor services received but not invoiced, demurrage (DMG) accruals, and employee entitlement provisions. Records accrual type, amount, GL account, cost centre, accrual period, and reversal date.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` (
    `lease_liability_id` BIGINT COMMENT 'Unique identifier for the lease liability record. Primary key for IFRS 16 lease accounting entries.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every lease liability belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can r',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Lease liabilities can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_center_code STRING column can ',
    `fixed_asset_id` BIGINT COMMENT 'add column fixed_asset_id (BIGINT) with FK to finance.fixed_asset.fixed_asset_id - IFRS 16 lease liabilities correspond to right-of-use assets tracked as fixed assets',
    `modified_lease_liability_id` BIGINT COMMENT 'Self-referencing FK on lease_liability (modified_lease_liability_id)',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Lease liabilities can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_center_code STR',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Lease contracts (equipment leases, facility leases) require designated employee ownership for renewal tracking, payment authorization, compliance monitoring, and vendor relationship management in port',
    `vendor_id` BIGINT COMMENT 'Reference to the lessor party in the master vendor or participant registry.',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation charged against the right-of-use asset from commencement date to the reporting date.',
    `accumulated_interest_expense` DECIMAL(18,2) COMMENT 'Total interest expense accrued on the lease liability from commencement to the reporting date. Interest is calculated on the outstanding liability balance each period.',
    `asset_description` STRING COMMENT 'Detailed description of the right-of-use asset under lease. Examples include terminal land parcels, Rubber Tyred Gantry (RTG) cranes, Ship-to-Shore (STS) cranes, warehouse buildings, or administrative offices.',
    `asset_location` STRING COMMENT 'Physical location or terminal where the leased asset is situated. Critical for port operations spanning multiple terminals and berths.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this lease liability record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for lease payments and liability amounts. Port authorities may hold leases in multiple currencies depending on lessor jurisdiction.. Valid values are `^[A-Z]{3}$`',
    `current_lease_liability` DECIMAL(18,2) COMMENT 'Outstanding lease liability balance as of the reporting date. Reduced by lease payments and increased by interest accretion each period.',
    `current_rou_asset_value` DECIMAL(18,2) COMMENT 'Current carrying amount of the right-of-use asset after accumulated depreciation and any impairment losses. Updated monthly as part of the depreciation schedule.',
    `depreciation_method` STRING COMMENT 'Method used to depreciate the right-of-use asset. Typically straight-line over the shorter of the lease term or the useful life of the asset.. Valid values are `straight_line|diminishing_balance|units_of_production`',
    `discount_rate` DECIMAL(18,2) COMMENT 'Interest rate used to discount lease payments to present value. Represents the rate the lessee would pay to borrow funds to purchase a similar asset in a similar economic environment. Expressed as a decimal (e.g., 0.0450 for 4.50%).',
    `extension_option_flag` BOOLEAN COMMENT 'Indicates whether the lease contract includes an option to extend the lease term beyond the initial period.',
    `extension_option_years` STRING COMMENT 'Number of years available under the extension option if exercised. Nullable if no extension option exists.',
    `gl_account_liability` STRING COMMENT 'General ledger account number where the lease liability balance is recorded. Separate accounts typically maintained for current and non-current portions.',
    `gl_account_rou_asset` STRING COMMENT 'General ledger account number where the right-of-use asset is capitalized. Typically classified under property, plant, and equipment or a separate ROU asset category.',
    `impairment_indicator` BOOLEAN COMMENT 'Indicates whether there are indicators that the right-of-use asset may be impaired and requires impairment testing under IAS 36.',
    `impairment_loss` DECIMAL(18,2) COMMENT 'Cumulative impairment loss recognized against the right-of-use asset. Nullable if no impairment has been identified.',
    `initial_lease_liability` DECIMAL(18,2) COMMENT 'Present value of lease payments at lease commencement, discounted using the incremental borrowing rate. Represents the initial obligation to make lease payments.',
    `initial_rou_asset_value` DECIMAL(18,2) COMMENT 'Initial measurement of the right-of-use asset at lease commencement. Equals the initial lease liability plus any initial direct costs, lease payments made at or before commencement, and estimated restoration costs.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this lease liability record was most recently updated. Tracks modifications to liability balances, asset values, or lease terms.',
    `last_remeasurement_date` DATE COMMENT 'Date when the lease liability was last remeasured due to a change in lease term, discount rate, or lease payments.',
    `lease_commencement_date` DATE COMMENT 'Date when the lessor makes the underlying asset available for use by the lessee. This is the effective start date for IFRS 16 lease accounting recognition.',
    `lease_contract_number` STRING COMMENT 'External business identifier for the lease agreement. Used for cross-referencing with legal documents and vendor communications.',
    `lease_end_date` DATE COMMENT 'Contractual end date of the lease term. For port land leases, this may extend 25-99 years. Nullable for perpetual or indefinite concession arrangements.',
    `lease_status` STRING COMMENT 'Current lifecycle status of the lease liability. Tracks whether the lease is currently in force, has been modified, or has ended.. Valid values are `active|terminated|modified|expired|pending_activation|suspended`',
    `lease_term_months` STRING COMMENT 'Total duration of the lease agreement expressed in months. Includes non-cancellable period plus any extension options reasonably certain to be exercised.',
    `lease_type` STRING COMMENT 'Classification of the lease arrangement. Port authorities commonly hold land leases from government entities, equipment leases for terminal machinery, and building leases for administrative facilities.. Valid values are `land_lease|equipment_lease|building_lease|concession_arrangement|infrastructure_lease|vehicle_lease`',
    `lessor_name` STRING COMMENT 'Name of the entity providing the leased asset. For port authorities, commonly government entities, port land authorities, or equipment vendors.',
    `long_term_liability_portion` DECIMAL(18,2) COMMENT 'Portion of the lease liability due beyond 12 months. Classified as non-current liability on the balance sheet.',
    `modification_date` DATE COMMENT 'Date when the most recent lease modification became effective. Nullable if no modifications have occurred.',
    `modification_description` STRING COMMENT 'Description of the lease modification, including changes to payment terms, lease scope, or extension/termination of the lease term.',
    `modification_flag` BOOLEAN COMMENT 'Indicates whether the lease has been modified after initial recognition. Modifications include changes to scope, consideration, or term.',
    `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this lease liability record. Critical for audit trail and change management.',
    `monthly_lease_payment` DECIMAL(18,2) COMMENT 'Fixed monthly payment amount due to the lessor. Excludes variable lease payments based on usage or performance.',
    `next_payment_due_date` DATE COMMENT 'Date when the next lease payment is due to the lessor. Used for cash flow planning and accounts payable scheduling.',
    `payment_frequency` STRING COMMENT 'Frequency at which lease payments are made to the lessor.. Valid values are `monthly|quarterly|semi_annually|annually`',
    `purchase_option_flag` BOOLEAN COMMENT 'Indicates whether the lease includes an option for the lessee to purchase the underlying asset at the end of the lease term.',
    `remeasurement_trigger` STRING COMMENT 'Event that triggered remeasurement of the lease liability. Examples include change in lease term, change in assessment of purchase option, or change in amounts expected under residual value guarantee.',
    `short_term_liability_portion` DECIMAL(18,2) COMMENT 'Portion of the lease liability due within the next 12 months. Classified as current liability on the balance sheet.',
    `termination_option_flag` BOOLEAN COMMENT 'Indicates whether the lessee has the right to terminate the lease before the end of the contractual term.',
    `variable_payment_basis` STRING COMMENT 'Description of the basis for variable lease payments. Examples include TEU throughput, revenue percentage, or inflation index adjustments.',
    `variable_payment_flag` BOOLEAN COMMENT 'Indicates whether the lease includes variable payments that depend on an index, rate, or usage metric (e.g., throughput-based concession fees).',
    CONSTRAINT pk_lease_liability PRIMARY KEY(`lease_liability_id`)
) COMMENT 'IFRS 16 lease accounting record for port authority right-of-use assets including land leases, equipment leases, concession arrangements, and building leases. Captures lease term, discount rate, right-of-use asset value, lease liability balance, monthly amortisation schedule, and modification history. Critical for port authorities who hold extensive long-term land and infrastructure leases from government entities. SSOT for lease accounting compliance and balance sheet reporting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`provision` (
    `provision_id` BIGINT COMMENT 'Unique identifier for the financial provision record. Primary key.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Every provision belongs to a legal entity (company code). New FK column company_code_id will be created to properly link to the company_code master. The existing company_code STRING column can remain ',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: Financial provisions for pending compliance violation penalties, fines, and legal settlements reference the underlying violation for provision measurement, disclosure requirements, and financial state',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Provisions can be allocated to cost centres for cost accounting. New FK column cost_centre_id will be created to link to the cost centre master. The existing cost_centre_code STRING column can remain ',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: The provision product has an asset_number STRING field. Provisions are often related to specific fixed assets (e.g., decommissioning provisions for port infrastructure, asset retirement obligations). ',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Provisions post to GL accounts for financial accounting. New FK column gl_account_id will be created to link to the GL account master. The existing gl_account_code STRING column can remain as a denorm',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Provisions can be allocated to profit centres for profitability analysis. New FK column profit_centre_id will be created to link to the profit centre master. The existing profit_centre_code STRING col',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Provisions (environmental remediation, decommissioning, legal claims, warranty obligations) require designated employee ownership for estimation review, approval authority, ongoing reassessment, and a',
    `revised_provision_id` BIGINT COMMENT 'Self-referencing FK on provision (revised_provision_id)',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Material security incidents (cargo theft, vessel damage, personal injury claims) trigger provisions for probable legal liabilities, remediation costs, or regulatory penalties under IAS 37, requiring i',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Provisions can be allocated to WBS elements for project cost tracking. New FK column wbs_element_id will be created to link to the WBS element master. The existing wbs_element_code STRING column can r',
    `business_area_code` STRING COMMENT 'Business area for cross-company code reporting and consolidation. Represents operational segments such as container terminal, bulk cargo, or marine services.. Valid values are `^[A-Z0-9]{4}$`',
    `provision_category` STRING COMMENT 'Balance sheet classification indicating whether the provision is expected to be settled within 12 months (current) or beyond 12 months (non-current).. Valid values are `current|non_current`',
    `contingent_liability_flag` BOOLEAN COMMENT 'Indicates whether this record also represents a contingent liability requiring disclosure. True when probability is possible but not probable, or when amount cannot be reliably measured.',
    `created_by_user` STRING COMMENT 'User ID of the person who created the provision record in the system. Used for audit trail and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the provision record was first created. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the provision amounts. Typically the functional currency of the company code.. Valid values are `^[A-Z]{3}$`',
    `current_provision_amount` DECIMAL(18,2) COMMENT 'Current carrying amount of the provision after remeasurements, discount unwinding, and partial settlements. Represents the best estimate of expenditure required to settle the present obligation at the reporting date.',
    `disclosure_required_flag` BOOLEAN COMMENT 'Indicates whether this provision requires specific disclosure in the financial statement notes. Material provisions and contingent liabilities require detailed disclosure.',
    `discount_rate_percentage` DECIMAL(18,2) COMMENT 'Pre-tax discount rate applied to future cash flows to calculate present value of the provision. Should reflect current market assessments of the time value of money and risks specific to the liability. Expressed as decimal (e.g., 0.0525 for 5.25%).',
    `discount_unwinding_amount` DECIMAL(18,2) COMMENT 'Cumulative amount of discount unwinding (accretion expense) recognized as the provision approaches settlement date. Represents the increase in provision due to passage of time.',
    `document_number` STRING COMMENT 'SAP financial document number for the journal entry that created or last modified the provision. Links to the general ledger posting.. Valid values are `^[0-9]{10}$`',
    `estimation_method` STRING COMMENT 'Method used to estimate the provision amount. Single best estimate for individual obligations; expected value (probability-weighted) for large populations; range midpoint when no single outcome is more likely; expert valuation for complex obligations.. Valid values are `single_best_estimate|expected_value|range_midpoint|expert_valuation`',
    `expected_settlement_date` DATE COMMENT 'Best estimate of the date when the obligation is expected to be settled or discharged. Used for discounting calculations and current/non-current classification.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year. Used for monthly financial reporting and variance analysis.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the provision was recognized or is being reported. Used for period-based reporting and analysis.',
    `functional_area_code` STRING COMMENT 'Functional area classification for cost-of-sales accounting and functional expense reporting. Examples: operations, administration, maintenance.. Valid values are `^[A-Z0-9]{4,6}$`',
    `last_modified_by_user` STRING COMMENT 'User ID of the person who last modified the provision record. Used for audit trail and change tracking.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the provision record was last modified. Used for audit trail and change tracking.',
    `last_reassessment_date` DATE COMMENT 'Date of the most recent formal reassessment of the provision amount, timing, and probability. Used to track compliance with reassessment requirements.',
    `legal_basis` STRING COMMENT 'Legal or regulatory basis for the provision. References to legislation, regulations, contracts, or constructive obligations that create the liability. Examples: MARPOL requirements, lease agreements, employment contracts.',
    `maximum_estimate_amount` DECIMAL(18,2) COMMENT 'Upper bound of the estimated range of possible outcomes. Used for sensitivity analysis and risk assessment.',
    `measurement_date` DATE COMMENT 'Date of the most recent measurement or remeasurement of the provision amount. Provisions must be reviewed at each reporting date and adjusted to reflect current best estimate.',
    `minimum_estimate_amount` DECIMAL(18,2) COMMENT 'Lower bound of the estimated range of possible outcomes. Used when there is significant uncertainty in the provision measurement.',
    `next_reassessment_date` DATE COMMENT 'Scheduled date for the next formal reassessment. Typically aligned with annual reporting cycle or significant project milestones.',
    `notes` STRING COMMENT 'Additional free-text notes, comments, or supporting documentation references for the provision. Used for audit trail and management commentary.',
    `obligation_description` STRING COMMENT 'Detailed narrative description of the nature of the obligation, the circumstances that gave rise to it, and the expected method of settlement. Critical for audit trail and disclosure notes.',
    `original_provision_amount` DECIMAL(18,2) COMMENT 'Initial provision amount recognized at inception, before any remeasurements, settlements, or unwinding of discount. Recorded in functional currency.',
    `outstanding_amount` DECIMAL(18,2) COMMENT 'Remaining provision balance after settlements. Calculated as current provision amount minus settled amount.',
    `probability_assessment` STRING COMMENT 'Assessment of the likelihood that an outflow of resources will be required to settle the obligation. Probable (>50%) triggers recognition; possible (5-50%) requires disclosure only; remote (<5%) requires no action.. Valid values are `probable|possible|remote`',
    `provision_number` STRING COMMENT 'Business-facing unique provision reference number used for tracking and reporting. Format: PRV-YYYYNNNN.. Valid values are `^PRV-[0-9]{8}$`',
    `provision_status` STRING COMMENT 'Current lifecycle status of the provision. Recognized when initially recorded; remeasured after annual reassessment; partially settled when payments made; fully settled when obligation discharged; reversed when no longer required; written off when obligation extinguished.. Valid values are `recognized|remeasured|partially_settled|fully_settled|reversed|written_off`',
    `provision_type` STRING COMMENT 'Classification of the provision based on the nature of the obligation. Environmental remediation includes dredge spoil disposal and contaminated land cleanup; employee entitlement covers long service leave and redundancy; legal claim provisions for litigation; asset decommissioning for infrastructure removal obligations.. Valid values are `environmental_remediation|employee_entitlement|legal_claim|asset_decommissioning|warranty|restructuring`',
    `reassessment_frequency` STRING COMMENT 'Scheduled frequency for reviewing and remeasuring the provision. Annual reassessment is mandatory; more frequent reviews may be required for volatile or material provisions.. Valid values are `annual|semi_annual|quarterly|event_driven`',
    `recognition_date` DATE COMMENT 'Date when the provision was initially recognized in the financial statements. Represents the point when a present obligation arose from a past event and reliable estimate could be made.',
    `reimbursement_amount` DECIMAL(18,2) COMMENT 'Expected reimbursement amount from third parties. Recognized as a separate asset when virtually certain, but cannot exceed the provision amount.',
    `reimbursement_expected_flag` BOOLEAN COMMENT 'Indicates whether the entity expects to receive reimbursement from a third party (e.g., insurance, indemnity, government grant) for some or all of the expenditure required to settle the provision.',
    `reimbursement_source` STRING COMMENT 'Description of the third party or mechanism from which reimbursement is expected. Examples: insurance policy number, government grant program, contractual indemnity clause.',
    `reversal_date` DATE COMMENT 'Date when the provision was reversed. Populated only when reversal indicator is true.',
    `reversal_indicator` BOOLEAN COMMENT 'Indicates whether this provision has been reversed because the obligation no longer exists or is no longer probable. Reversed provisions are written back to income.',
    `reversal_reason` STRING COMMENT 'Explanation for why the provision was reversed. Examples: obligation no longer exists, settlement for less than provided amount, probability assessment changed to remote.',
    `settled_amount` DECIMAL(18,2) COMMENT 'Total amount paid or applied against the provision to date. Represents actual expenditures incurred in settling the obligation.',
    `terminal_code` STRING COMMENT 'Port terminal or facility code where the provision obligation is located. Relevant for environmental remediation and asset decommissioning provisions tied to specific terminal infrastructure.. Valid values are `^[A-Z]{3,6}$`',
    `undiscounted_amount` DECIMAL(18,2) COMMENT 'Estimated future cash outflows required to settle the obligation without applying any discount rate. Used for disclosure and comparison with discounted carrying amount.',
    CONSTRAINT pk_provision PRIMARY KEY(`provision_id`)
) COMMENT 'Financial provision and contingent liability record capturing obligations where timing or amount is uncertain. Covers environmental remediation provisions (dredge spoil disposal, contaminated land), employee entitlement provisions (long service leave, redundancy), legal claim provisions, and asset decommissioning obligations. Records provision type, estimated amount, discount rate, expected settlement date, and annual reassessment. Required for statutory reporting and AASB 137/IAS 37 compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` (
    `internal_order_gang_assignment_id` BIGINT COMMENT 'Unique surrogate identifier for this internal order gang assignment record. Primary key for the association.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to the internal order (project, maintenance campaign, or CAPEX initiative) to which the gang is assigned for cost tracking and budget control.',
    `employee_id` BIGINT COMMENT 'Reference to the employee record of the gang supervisor responsible for this specific assignment. May differ from the gangs default supervisor if a different supervisor is assigned for this internal order work.',
    `gang_id` BIGINT COMMENT 'Foreign key linking to the stevedore gang deployed to perform work under this internal order assignment.',
    `actual_hours` DECIMAL(18,2) COMMENT 'The actual number of labour hours worked by this gang on this internal order. Posted from time sheets or gang deployment records. Used for cost actuals and variance analysis.',
    `assignment_date` DATE COMMENT 'The date on which this gang was assigned to this internal order. Used for tracking assignment history and effective dating of cost allocations.',
    `assignment_end_date` DATE COMMENT 'The planned or actual end date for this gangs work on this internal order. Used for scheduling, resource planning, and assignment closure.',
    `assignment_start_date` DATE COMMENT 'The planned or actual start date for this gangs work on this internal order. Used for scheduling and resource planning.',
    `assignment_status` STRING COMMENT 'Current lifecycle status of this gang assignment. Planned indicates future scheduled assignment, Active indicates gang is currently deployed, Completed indicates work finished, Cancelled indicates assignment was cancelled before completion.',
    `cost_centre_code` STRING COMMENT 'SAP Controlling (CO) cost centre code to which labour costs for this assignment are allocated. May differ from the gangs default cost centre depending on the internal orders cost allocation rules.',
    `cost_rate` DECIMAL(18,2) COMMENT 'The labour cost rate per hour applicable to this specific gang assignment. May vary by internal order type, work type, shift pattern, or labour agreement. Used for calculating actual costs posted to the internal order.',
    `created_by_user` STRING COMMENT 'User ID or username of the person who created this assignment record. Used for audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this assignment record was created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the cost rate and any monetary amounts in this assignment record. Typically matches the internal order currency.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this assignment record was last modified. Used for audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text notes or comments about this specific gang assignment. May include special instructions, safety requirements, or operational notes specific to this internal order work.',
    `planned_hours` DECIMAL(18,2) COMMENT 'The planned or budgeted number of labour hours for this gang assignment to this internal order. Used for resource planning and budget forecasting.',
    `work_type` STRING COMMENT 'Classification of the type of work performed by this gang under this internal order assignment. Examples: crane maintenance, berth repair, dredging support, equipment installation, lashing operations. Used for cost classification and activity-based costing.',
    CONSTRAINT pk_internal_order_gang_assignment PRIMARY KEY(`internal_order_gang_assignment_id`)
) COMMENT 'This association product represents the assignment of stevedore gangs to internal orders for cost tracking and resource planning. It captures the operational deployment of labour gangs against specific internal orders (maintenance campaigns, operational projects, CAPEX initiatives) with assignment-specific attributes including planned and actual hours, work type classification, cost rates, and assignment status. Each record links one internal order to one gang deployment with attributes that exist only in the context of this assignment relationship. SSOT for gang cost allocation to internal orders and labour resource utilization tracking.. Existence Justification: In maritime port operations, internal orders (representing maintenance campaigns, operational projects, or CAPEX initiatives) routinely require multiple stevedore gangs for execution, and stevedore gangs are deployed across multiple internal orders throughout their operational lifecycle. The business actively manages these assignments as operational records, tracking planned versus actual hours, work type classification, assignment-specific cost rates, and assignment status for both resource planning and cost control purposes.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` (
    `project_gang_assignment_id` BIGINT COMMENT 'Unique surrogate identifier for the project gang assignment record. Primary key for the association.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to the WBS element (capital project component) to which the gang is assigned',
    `gang_id` BIGINT COMMENT 'Foreign key linking to the stevedore gang assigned to perform work on the capital project',
    `actual_hours` DECIMAL(18,2) COMMENT 'The actual number of labour hours worked by this gang on the WBS element. Used for project cost tracking, variance analysis, and gang utilization reporting.',
    `assignment_date` DATE COMMENT 'The date on which the stevedore gang was assigned to the WBS element. Used for tracking assignment history and labour deployment planning.',
    `assignment_end_date` DATE COMMENT 'The date when the gang completed or is scheduled to complete work on this WBS element. Used for labour planning and gang availability forecasting.',
    `assignment_notes` STRING COMMENT 'Free-text notes capturing specific requirements, constraints, or observations about this gang assignment (e.g., special safety requirements, equipment dependencies, weather delays).',
    `assignment_start_date` DATE COMMENT 'The date when the gang commenced work on this WBS element. Used for tracking actual deployment timing and schedule variance analysis.',
    `assignment_status` STRING COMMENT 'Current lifecycle status of the gang assignment. Planned = scheduled but not started, Active = gang currently deployed, Completed = work finished, Cancelled = assignment cancelled before completion.',
    `cost_allocation_percentage` DECIMAL(18,2) COMMENT 'The percentage of the gangs labour costs to be allocated to this WBS element when the gang is working across multiple projects concurrently. Used for accurate project cost allocation and gang cost apportionment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this assignment record was created in the system. Used for audit trail and data lineage.',
    `labour_cost_actual` DECIMAL(18,2) COMMENT 'The actual labour cost incurred for this gang assignment to the WBS element, calculated from actual hours and gang pay rates. Posted to SAP CO for project cost tracking.',
    `labour_cost_planned` DECIMAL(18,2) COMMENT 'The planned or budgeted labour cost for this gang assignment, calculated from planned hours and standard gang rates. Used for project budget tracking and variance analysis.',
    `last_deployment_date` DATE COMMENT 'The date of the most recent vessel operation deployment for this gang. Used for gang activity monitoring, standby management, and workforce utilisation reporting. [Moved from gang: This attribute currently in gang represents the most recent deployment date, which should be derived from the assignment association rather than stored redundantly in the gang master record. The assignment association is the SSOT for deployment history.]',
    `planned_hours` DECIMAL(18,2) COMMENT 'The planned or budgeted number of labour hours for this gang assignment to the WBS element. Used for project labour planning and cost estimation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this assignment record was last updated. Used for audit trail and change tracking.',
    `work_phase` STRING COMMENT 'The specific phase of the capital project during which this gang assignment occurs (e.g., Foundation, Structural, Installation, Commissioning). Aligns with project_phase in WBS element for phase-based labour tracking.',
    CONSTRAINT pk_project_gang_assignment PRIMARY KEY(`project_gang_assignment_id`)
) COMMENT 'This association product represents the assignment of stevedore gangs to capital project WBS elements for infrastructure construction and installation work. It captures the deployment of labour gangs to CAPEX projects such as berth construction, crane installation, and terminal expansion, tracking planned versus actual labour hours, assignment dates, work phases, and cost allocation for project labour costing and gang utilization analysis. Each record links one WBS element to one gang with attributes that exist only in the context of this project assignment.. Existence Justification: In maritime port capital projects, stevedore gangs are deployed to multiple WBS elements (project components) over the project lifecycle - a gang may work on berth construction, then crane installation, then terminal paving. Simultaneously, each WBS element requires multiple gangs with different specializations (hatch gangs for confined space work, crane gangs for heavy lifting, lashing gangs for securing). The business actively manages these assignments with planned vs actual hours, cost allocation percentages when gangs split time across projects, work phases, and assignment status tracking.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` (
    `allocation_cycle_id` BIGINT COMMENT 'Primary key for allocation_cycle',
    `allocation_reversal_cycle_id` BIGINT COMMENT 'Reference to another allocation cycle that reverses the allocations made in this cycle, if applicable.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: The allocation_cycle product has a company_code STRING field but no FK to company_code master. Cost allocation cycles operate within a specific legal entity (company code). Adding this FK normalizes t',
    `cost_centre_id` BIGINT COMMENT 'Reference to the primary source cost center from which costs are being allocated in this cycle.',
    `primary_prior_allocation_cycle_id` BIGINT COMMENT 'Self-referencing FK on allocation_cycle (prior_allocation_cycle_id)',
    `actual_execution_date` DATE COMMENT 'The actual date when the allocation cycle was executed and cost allocations were processed.',
    `allocation_basis` STRING COMMENT 'The primary basis or driver used for allocating costs in this cycle (e.g., headcount, square footage, revenue, vessel calls, container volume).',
    `allocation_method` STRING COMMENT 'The methodology used for cost allocation in this cycle (direct, step-down, reciprocal, activity-based, proportional, driver-based).',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'The default or standard percentage used for cost allocation in this cycle, expressed as a decimal (e.g., 25.50 for 25.5%).',
    `allocation_run_sequence` STRING COMMENT 'The sequence number indicating the order in which this allocation cycle should be executed relative to other cycles in the same period.',
    `approval_date` DATE COMMENT 'The date when this allocation cycle was formally approved for execution.',
    `approval_required` BOOLEAN COMMENT 'Boolean flag indicating whether this allocation cycle requires formal approval before execution (true) or can be executed automatically (false).',
    `approved_by` STRING COMMENT 'The name or identifier of the user who approved this allocation cycle for execution.',
    `business_area` STRING COMMENT 'The business area or segment within the port operations (e.g., container terminal, bulk cargo, vessel services) to which this allocation cycle applies.',
    `completion_date` DATE COMMENT 'The date when the allocation cycle was fully completed, validated, and closed.',
    `controlling_area` STRING COMMENT 'The SAP controlling area code to which this allocation cycle belongs, representing the organizational unit for cost accounting.',
    `cost_element_category` STRING COMMENT 'The category of cost elements being allocated in this cycle (primary, secondary, revenue, overhead, direct, indirect).',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this allocation cycle record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the allocated amounts in this cycle (e.g., USD, EUR, GBP).',
    `cycle_code` STRING COMMENT 'Business identifier code for the allocation cycle, used for external reference and reporting.',
    `cycle_name` STRING COMMENT 'Descriptive name of the allocation cycle for business user identification and reporting purposes.',
    `cycle_type` STRING COMMENT 'Classification of the allocation cycle based on frequency and purpose (monthly, quarterly, annual, ad-hoc, project-based, interim).',
    `end_date` DATE COMMENT 'The effective end date when this allocation cycle concludes and stops processing allocations.',
    `fiscal_period` STRING COMMENT 'The fiscal period number within the fiscal year (1-12 for monthly, 1-4 for quarterly) to which this allocation cycle applies.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this allocation cycle applies, represented as a four-digit year.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this allocation cycle is currently active (true) or inactive/archived (false).',
    `is_recurring` BOOLEAN COMMENT 'Boolean flag indicating whether this allocation cycle is recurring (true) or one-time (false).',
    `modified_by` STRING COMMENT 'The username or identifier of the user who last modified this allocation cycle record.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this allocation cycle record was last modified in the system.',
    `notes` STRING COMMENT 'Free-text notes or comments providing additional context, instructions, or documentation about this allocation cycle.',
    `planned_execution_date` DATE COMMENT 'The scheduled date when the allocation cycle is planned to be executed and cost allocations processed.',
    `recurrence_pattern` STRING COMMENT 'The pattern defining how frequently this allocation cycle recurs (monthly, quarterly, semi-annual, annual, custom).',
    `reversal_allowed` BOOLEAN COMMENT 'Boolean flag indicating whether allocations made in this cycle can be reversed (true) or are final (false).',
    `start_date` DATE COMMENT 'The effective start date when this allocation cycle becomes active and begins processing allocations.',
    `allocation_cycle_status` STRING COMMENT 'Current lifecycle status of the allocation cycle (draft, active, in-progress, completed, closed, cancelled).',
    `target_cost_center_group` STRING COMMENT 'The group or category of target cost centers that will receive allocated costs in this cycle.',
    `total_allocated_amount` DECIMAL(18,2) COMMENT 'The total monetary amount allocated across all cost centers during this allocation cycle.',
    `created_by` STRING COMMENT 'The username or identifier of the user who created this allocation cycle record.',
    CONSTRAINT pk_allocation_cycle PRIMARY KEY(`allocation_cycle_id`)
) COMMENT 'Master reference table for allocation_cycle. Referenced by allocation_cycle_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` (
    `investment_program_id` BIGINT COMMENT 'Primary key for investment_program',
    `cost_centre_id` BIGINT COMMENT 'Reference to the cost center in the financial controlling (CO) module that will bear the costs of this investment program.',
    `gl_account_id` BIGINT COMMENT 'Reference to the general ledger account in the financial accounting (FI) module used for posting investment program transactions.',
    `employee_id` BIGINT COMMENT 'Reference to the employee or party responsible for managing and overseeing the execution of this investment program.',
    `investment_sponsor_employee_id` BIGINT COMMENT 'Reference to the executive or senior leader who sponsors and provides strategic oversight for this investment program.',
    `org_unit_id` BIGINT COMMENT 'Reference to the business unit or division responsible for sponsoring and executing this investment program.',
    `parent_investment_program_id` BIGINT COMMENT 'Self-referencing FK on investment_program (parent_investment_program_id)',
    `actual_completion_date` DATE COMMENT 'Actual date when this investment program was completed and assets were placed into service or program was closed.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Total amount actually spent and posted to the general ledger for this investment program to date, representing realized expenditures.',
    `actual_start_date` DATE COMMENT 'Actual date when execution of this investment program commenced, used for schedule variance analysis.',
    `approval_authority` STRING COMMENT 'Name or title of the governance body or individual who provided formal approval for this investment program (e.g., Board of Directors, CFO, Investment Committee).',
    `approval_date` DATE COMMENT 'Date when this investment program received formal approval from the board of directors or authorized governance body.',
    `approved_budget_amount` DECIMAL(18,2) COMMENT 'Total budget amount approved by the board or authorized approvers for this investment program, representing the financial ceiling for expenditures.',
    `business_justification` STRING COMMENT 'Documented business case and rationale for this investment program, including strategic alignment, expected benefits, and alternatives considered.',
    `capitalization_method` STRING COMMENT 'Accounting treatment method for investment program expenditures: full capitalization to balance sheet, partial capitalization with some expensing, or expense as incurred.',
    `committed_amount` DECIMAL(18,2) COMMENT 'Total amount committed through purchase orders, contracts, or other binding obligations against this investment program budget.',
    `compliance_requirement_flag` BOOLEAN COMMENT 'Indicates whether this investment program is driven by regulatory compliance requirements (True) or is discretionary (False).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this investment program record was first created in the system, used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this investment program (e.g., USD, EUR, GBP).',
    `depreciation_method` STRING COMMENT 'Method to be used for depreciating capitalized assets resulting from this investment program over their useful life.',
    `investment_program_description` STRING COMMENT 'Detailed narrative description of the investment program scope, objectives, deliverables, and expected business outcomes.',
    `environmental_impact_assessment_flag` BOOLEAN COMMENT 'Indicates whether this investment program requires environmental impact assessment and approval under maritime environmental regulations (True/False).',
    `expected_roi_percentage` DECIMAL(18,2) COMMENT 'Projected return on investment percentage for this investment program, calculated during business case development and used for investment prioritization.',
    `forecast_amount` DECIMAL(18,2) COMMENT 'Projected total expenditure amount for this investment program based on current execution plans and estimates to completion.',
    `funding_source` STRING COMMENT 'Primary source of funding for this investment program: internal cash reserves, debt financing, equity, government grant, lease arrangement, or mixed sources.',
    `internal_rate_of_return_percentage` DECIMAL(18,2) COMMENT 'Calculated internal rate of return percentage for this investment program, representing the discount rate at which NPV equals zero.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this investment program record is currently active (True) or has been logically deleted or archived (False).',
    `last_review_date` DATE COMMENT 'Date of the most recent formal review or gate review of this investment program by management or governance body.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this investment program record was last modified in the system, used for audit trail and change tracking.',
    `net_present_value_amount` DECIMAL(18,2) COMMENT 'Calculated net present value of expected future cash flows from this investment program, discounted to present value using the corporate discount rate.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal review or gate review of this investment program by management or governance body.',
    `notes` STRING COMMENT 'Additional notes, comments, or supplementary information about this investment program for management reference.',
    `payback_period_months` STRING COMMENT 'Expected number of months required to recover the investment through generated cash flows or cost savings.',
    `planned_completion_date` DATE COMMENT 'Planned date when this investment program is scheduled to be completed and assets placed into service, as defined in the program charter.',
    `planned_start_date` DATE COMMENT 'Planned date when execution of this investment program is scheduled to begin, as defined in the program charter.',
    `priority_level` STRING COMMENT 'Strategic priority ranking assigned to the investment program by executive management for resource allocation and scheduling decisions.',
    `program_category` STRING COMMENT 'Business category of the investment program aligned with maritime logistics asset classes: infrastructure, equipment, technology systems, facility upgrades, vessel acquisitions, or terminal development.',
    `program_code` STRING COMMENT 'Externally-known unique business identifier code for the investment program, used in financial reporting and project tracking systems.',
    `program_name` STRING COMMENT 'Full descriptive name of the investment program as recognized by stakeholders and management.',
    `program_type` STRING COMMENT 'Classification of the investment program by expenditure category: capital expenditure (CAPEX), operational expenditure (OPEX), maintenance, expansion, modernization, or regulatory compliance.',
    `risk_rating` STRING COMMENT 'Overall risk assessment rating for this investment program based on execution complexity, market conditions, regulatory factors, and technical challenges.',
    `investment_program_status` STRING COMMENT 'Current lifecycle status of the investment program indicating its stage in the approval and execution workflow.',
    `strategic_objective` STRING COMMENT 'High-level strategic business objective or goal that this investment program is designed to achieve, aligned with corporate strategy.',
    `useful_life_years` STRING COMMENT 'Expected useful economic life in years for assets acquired or developed under this investment program, used for depreciation calculations.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between approved budget and forecast amount, indicating budget overrun (positive) or underrun (negative) for management reporting.',
    CONSTRAINT pk_investment_program PRIMARY KEY(`investment_program_id`)
) COMMENT 'Master reference table for investment_program. Referenced by investment_program_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ADD CONSTRAINT `fk_finance_gl_account_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ADD CONSTRAINT `fk_finance_cost_centre_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ADD CONSTRAINT `fk_finance_cost_centre_parent_cost_centre_id` FOREIGN KEY (`parent_cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ADD CONSTRAINT `fk_finance_profit_centre_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ADD CONSTRAINT `fk_finance_profit_centre_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ADD CONSTRAINT `fk_finance_profit_centre_parent_profit_centre_id` FOREIGN KEY (`parent_profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_investment_program_id` FOREIGN KEY (`investment_program_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`investment_program`(`investment_program_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_parent_wbs_element_id` FOREIGN KEY (`parent_wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_budget_plan_id` FOREIGN KEY (`budget_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`budget_plan`(`budget_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_allocation_cycle_id` FOREIGN KEY (`allocation_cycle_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`allocation_cycle`(`allocation_cycle_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_reversed_allocation_cost_allocation_id` FOREIGN KEY (`reversed_allocation_cost_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_reversed_transaction_asset_transaction_id` FOREIGN KEY (`reversed_transaction_asset_transaction_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`asset_transaction`(`asset_transaction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_reversed_transaction_intercompany_transaction_id` FOREIGN KEY (`reversed_transaction_intercompany_transaction_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction`(`intercompany_transaction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ADD CONSTRAINT `fk_finance_lease_liability_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ADD CONSTRAINT `fk_finance_lease_liability_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ADD CONSTRAINT `fk_finance_lease_liability_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ADD CONSTRAINT `fk_finance_lease_liability_modified_lease_liability_id` FOREIGN KEY (`modified_lease_liability_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`lease_liability`(`lease_liability_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ADD CONSTRAINT `fk_finance_lease_liability_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_revised_provision_id` FOREIGN KEY (`revised_provision_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`provision`(`provision_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ADD CONSTRAINT `fk_finance_internal_order_gang_assignment_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ADD CONSTRAINT `fk_finance_project_gang_assignment_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ADD CONSTRAINT `fk_finance_allocation_cycle_allocation_reversal_cycle_id` FOREIGN KEY (`allocation_reversal_cycle_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`allocation_cycle`(`allocation_cycle_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ADD CONSTRAINT `fk_finance_allocation_cycle_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ADD CONSTRAINT `fk_finance_allocation_cycle_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ADD CONSTRAINT `fk_finance_allocation_cycle_primary_prior_allocation_cycle_id` FOREIGN KEY (`primary_prior_allocation_cycle_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`allocation_cycle`(`allocation_cycle_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ADD CONSTRAINT `fk_finance_investment_program_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ADD CONSTRAINT `fk_finance_investment_program_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ADD CONSTRAINT `fk_finance_investment_program_parent_investment_program_id` FOREIGN KEY (`parent_investment_program_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`investment_program`(`investment_program_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`finance` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_shipping_ports_v1`.`finance` SET TAGS ('dbx_domain' = 'finance');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` SET TAGS ('dbx_subdomain' = 'ledger_control');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `company_code_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_category` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_category` SET TAGS ('dbx_value_regex' = 'balance_sheet|profit_and_loss|cost_element|clearing|statistical');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_group` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_name` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_number` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_number` SET TAGS ('dbx_value_regex' = '^[0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_short_name` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Short Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_status` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|archived');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'asset|liability|equity|revenue|expense');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `alternative_account_number` SET TAGS ('dbx_business_glossary_term' = 'Alternative General Ledger (GL) Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `alternative_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `alternative_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `balance_sheet_classification` SET TAGS ('dbx_business_glossary_term' = 'Balance Sheet Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `balance_sheet_classification` SET TAGS ('dbx_value_regex' = 'current|non_current|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `chart_of_accounts` SET TAGS ('dbx_business_glossary_term' = 'Chart of Accounts (COA) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `chart_of_accounts` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `consolidation_account` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `cost_center_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `cost_element_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `cost_element_category` SET TAGS ('dbx_value_regex' = 'primary|secondary|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `field_status_group` SET TAGS ('dbx_business_glossary_term' = 'Field Status Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `financial_statement_item` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Item Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `functional_area_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Functional Area Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `house_bank_required_flag` SET TAGS ('dbx_business_glossary_term' = 'House Bank Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `inflation_key` SET TAGS ('dbx_business_glossary_term' = 'Inflation Adjustment Key');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `interest_calculation_indicator` SET TAGS ('dbx_business_glossary_term' = 'Interest Calculation Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `interest_calculation_indicator` SET TAGS ('dbx_value_regex' = 'calculate|do_not_calculate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `line_item_display_flag` SET TAGS ('dbx_business_glossary_term' = 'Line Item Display Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `open_item_management_flag` SET TAGS ('dbx_business_glossary_term' = 'Open Item Management Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `planning_blocked_flag` SET TAGS ('dbx_business_glossary_term' = 'Planning Blocked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `posting_blocked_flag` SET TAGS ('dbx_business_glossary_term' = 'Posting Blocked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `profit_center_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `reconciliation_account_flag` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Account Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `segment_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Segment Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `sort_key` SET TAGS ('dbx_business_glossary_term' = 'Sort Key');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `tax_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `tax_category` SET TAGS ('dbx_value_regex' = 'input_tax|output_tax|non_taxable|exempt|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `tolerance_group` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `trading_partner_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Trading Partner Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `valuation_group` SET TAGS ('dbx_business_glossary_term' = 'Valuation Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`gl_account` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` SET TAGS ('dbx_subdomain' = 'ledger_control');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `parent_cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Cost Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `activity_type` SET TAGS ('dbx_business_glossary_term' = 'Activity Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `annual_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Annual Budget Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `annual_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `budget_version` SET TAGS ('dbx_business_glossary_term' = 'Budget Version');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `budget_version` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `business_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `controlling_area_code` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `controlling_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_allocation_method` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_allocation_method` SET TAGS ('dbx_value_regex' = 'direct|activity_based|proportional|fixed_percentage|driver_based');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_status` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|planned');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_type` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_type` SET TAGS ('dbx_value_regex' = 'operational|administrative|service|infrastructure|revenue|support');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_element_group` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `department_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_description` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External Reference ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `is_overhead_centre` SET TAGS ('dbx_business_glossary_term' = 'Is Overhead Centre Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `is_revenue_generating` SET TAGS ('dbx_business_glossary_term' = 'Is Revenue Generating Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `lock_indicator` SET TAGS ('dbx_business_glossary_term' = 'Lock Indicator Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `cost_centre_name` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `profit_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `profit_centre_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `statistical_cost_centre` SET TAGS ('dbx_business_glossary_term' = 'Statistical Cost Centre Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` SET TAGS ('dbx_subdomain' = 'ledger_control');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `parent_profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Profit Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `activation_date` SET TAGS ('dbx_business_glossary_term' = 'Activation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `analysis_period` SET TAGS ('dbx_business_glossary_term' = 'Analysis Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `analysis_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}.[0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `budget_profile` SET TAGS ('dbx_business_glossary_term' = 'Budget Profile');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `consolidation_flag` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `controlling_area` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area (CO)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `controlling_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `deactivation_date` SET TAGS ('dbx_business_glossary_term' = 'Deactivation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_description` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `ebitda_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'EBITDA (Earnings Before Interest Taxes Depreciation and Amortization) Reporting Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `geographic_region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `intercompany_trading_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Trading Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `lock_indicator` SET TAGS ('dbx_business_glossary_term' = 'Lock Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_name` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `planning_level` SET TAGS ('dbx_business_glossary_term' = 'Planning Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `planning_level` SET TAGS ('dbx_value_regex' = 'strategic|tactical|operational');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_group` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_status` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|planned');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_type` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `profit_centre_type` SET TAGS ('dbx_value_regex' = 'operating|service|administrative|investment|holding|dummy');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `responsible_person_email` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Email');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `responsible_person_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `responsible_person_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `responsible_person_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `responsible_person_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `responsible_person_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `segment_code` SET TAGS ('dbx_business_glossary_term' = 'Segment Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `segment_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `short_name` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Short Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `tax_jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` SET TAGS ('dbx_subdomain' = 'ledger_control');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Cost Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `actual_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Cost Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `approved_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Budget Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `asset_class` SET TAGS ('dbx_business_glossary_term' = 'Asset Class');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `car_number` SET TAGS ('dbx_business_glossary_term' = 'Capital Appropriation Request (CAR) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `car_number` SET TAGS ('dbx_value_regex' = '^CAR-[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `committed_amount` SET TAGS ('dbx_business_glossary_term' = 'Committed Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `controlling_area` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area (CO)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `controlling_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `environmental_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `final_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Final Closure Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `investment_program` SET TAGS ('dbx_business_glossary_term' = 'Investment Program');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `long_description` SET TAGS ('dbx_business_glossary_term' = 'Order Long Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `order_category` SET TAGS ('dbx_business_glossary_term' = 'Order Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'created|released|technically_completed|closed|locked');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'capital|operational|maintenance|project|campaign|overhead');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `planning_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Planning Budget Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `project_phase` SET TAGS ('dbx_business_glossary_term' = 'Project Phase');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `project_phase` SET TAGS ('dbx_value_regex' = 'planning|design|procurement|construction|commissioning|closeout');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `requesting_department` SET TAGS ('dbx_business_glossary_term' = 'Requesting Department');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `responsible_person_email` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Email');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `responsible_person_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `responsible_person_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `responsible_person_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `responsible_person_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `responsible_person_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `responsible_person_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `risk_category` SET TAGS ('dbx_business_glossary_term' = 'Risk Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `risk_category` SET TAGS ('dbx_value_regex' = 'low|medium|high|very_high');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `settlement_profile` SET TAGS ('dbx_business_glossary_term' = 'Settlement Profile');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `settlement_receiver_reference` SET TAGS ('dbx_business_glossary_term' = 'Settlement Receiver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `settlement_receiver_type` SET TAGS ('dbx_business_glossary_term' = 'Settlement Receiver Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `settlement_receiver_type` SET TAGS ('dbx_value_regex' = 'asset|cost_centre|gl_account|wbs_element');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `short_description` SET TAGS ('dbx_business_glossary_term' = 'Order Short Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ALTER COLUMN `technical_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Technical Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` SET TAGS ('dbx_subdomain' = 'ledger_control');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Cost Center ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Class ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `investment_program_id` SET TAGS ('dbx_business_glossary_term' = 'Investment Program ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `parent_wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Work Breakdown Structure (WBS) Element ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Project Manager ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `tertiary_wbs_last_modified_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `tertiary_wbs_last_modified_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `tertiary_wbs_last_modified_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `actual_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|rejected|on_hold');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `baseline_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `budget_variance` SET TAGS ('dbx_business_glossary_term' = 'Budget Variance');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `capitalization_date` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_code` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,24}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `committed_cost` SET TAGS ('dbx_business_glossary_term' = 'Committed Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `controlling_area` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area (CO)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `controlling_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_description` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `eia_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Assessment (EIA) Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `environmental_impact_assessment_required` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Assessment (EIA) Required');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `expected_annual_revenue` SET TAGS ('dbx_business_glossary_term' = 'Expected Annual Revenue');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `forecast_final_cost` SET TAGS ('dbx_business_glossary_term' = 'Forecast Final Cost (EAC)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'Funding Source');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `funding_source` SET TAGS ('dbx_value_regex' = 'internal_cash|bank_loan|government_grant|bond_issuance|public_private_partnership');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `grant_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Grant Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `is_revenue_generating` SET TAGS ('dbx_business_glossary_term' = 'Is Revenue Generating');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `network_code` SET TAGS ('dbx_business_glossary_term' = 'Network ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `planned_capex_budget` SET TAGS ('dbx_business_glossary_term' = 'Planned Capital Expenditure (CAPEX) Budget');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `priority_ranking` SET TAGS ('dbx_business_glossary_term' = 'Priority Ranking');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Project Definition ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `project_phase` SET TAGS ('dbx_business_glossary_term' = 'Project Phase');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `project_phase` SET TAGS ('dbx_value_regex' = 'feasibility|design|procurement|construction|commissioning|closeout');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `risk_category` SET TAGS ('dbx_business_glossary_term' = 'Risk Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `risk_category` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `settlement_receiver_reference` SET TAGS ('dbx_business_glossary_term' = 'Settlement Receiver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `settlement_rule` SET TAGS ('dbx_business_glossary_term' = 'Settlement Rule');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `settlement_rule` SET TAGS ('dbx_value_regex' = 'full|percentage|equivalence');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `strategic_objective` SET TAGS ('dbx_business_glossary_term' = 'Strategic Objective');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_type` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_type` SET TAGS ('dbx_value_regex' = 'planning|execution|billing|milestone');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_level` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_status` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_status` SET TAGS ('dbx_value_regex' = 'created|released|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `accounting_principle` SET TAGS ('dbx_business_glossary_term' = 'Accounting Principle');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `approver_user_name` SET TAGS ('dbx_business_glossary_term' = 'Approver User Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `approver_user_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `assignment_reference` SET TAGS ('dbx_business_glossary_term' = 'Assignment Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `baseline_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `batch_input_session` SET TAGS ('dbx_business_glossary_term' = 'Batch Input Session');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `cost_centre` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Document Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `document_header_text` SET TAGS ('dbx_business_glossary_term' = 'Document Header Text');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `entry_date` SET TAGS ('dbx_business_glossary_term' = 'Entry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `entry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Entry Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `intercompany_indicator` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `internal_order` SET TAGS ('dbx_business_glossary_term' = 'Internal Order');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `ledger_group` SET TAGS ('dbx_business_glossary_term' = 'Ledger Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `payment_block_indicator` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `payment_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_status` SET TAGS ('dbx_business_glossary_term' = 'Posting Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_status` SET TAGS ('dbx_value_regex' = 'draft|posted|parked|cleared|reversed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `profit_centre` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `reversed_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversed Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `tax_reporting_date` SET TAGS ('dbx_business_glossary_term' = 'Tax Reporting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `trading_partner_company_code` SET TAGS ('dbx_business_glossary_term' = 'Trading Partner Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `transaction_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `user_name` SET TAGS ('dbx_business_glossary_term' = 'User Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `user_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `workflow_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Workflow Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ALTER COLUMN `workflow_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|not_required');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_line_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Service Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `assignment_reference` SET TAGS ('dbx_business_glossary_term' = 'Assignment Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `baseline_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `business_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `created_by_user` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `debit_amount` SET TAGS ('dbx_business_glossary_term' = 'Debit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `dunning_block_code` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `dunning_block_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{1}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `functional_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `functional_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `line_item_text` SET TAGS ('dbx_business_glossary_term' = 'Line Item Text');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,18}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `partner_profit_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Profit Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `partner_profit_centre_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `payment_block_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `payment_block_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{1}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `posting_key` SET TAGS ('dbx_business_glossary_term' = 'Posting Key');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `posting_key` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reversed_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversed Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reversed_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `segment_code` SET TAGS ('dbx_business_glossary_term' = 'Segment Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `segment_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `special_gl_indicator` SET TAGS ('dbx_business_glossary_term' = 'Special General Ledger (GL) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `special_gl_indicator` SET TAGS ('dbx_value_regex' = '^[A-Z]{1}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `trading_partner_code` SET TAGS ('dbx_business_glossary_term' = 'Trading Partner Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `trading_partner_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `transaction_amount` SET TAGS ('dbx_business_glossary_term' = 'Transaction Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `transaction_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `transaction_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `value_date` SET TAGS ('dbx_business_glossary_term' = 'Value Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `withholding_tax_type` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ALTER COLUMN `withholding_tax_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Payable (AP) Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `billing_run_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Run ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `security_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Security Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `baseline_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `expense_category` SET TAGS ('dbx_business_glossary_term' = 'Expense Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `goods_receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `invoice_description` SET TAGS ('dbx_business_glossary_term' = 'Invoice Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `is_recurring` SET TAGS ('dbx_business_glossary_term' = 'Is Recurring Invoice');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `outstanding_amount` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Paid Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_block` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Payable (AP) Payment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `billing_run_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Run ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `bank_charges` SET TAGS ('dbx_business_glossary_term' = 'Bank Charges');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `bank_clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Bank Clearing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `exchange_rate_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `expenditure_type` SET TAGS ('dbx_business_glossary_term' = 'Expenditure Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `expenditure_type` SET TAGS ('dbx_value_regex' = 'OPEX|CAPEX');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `house_bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'House Bank Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `house_bank_account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,34}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `house_bank_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `house_bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `house_bank_code` SET TAGS ('dbx_business_glossary_term' = 'House Bank ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `house_bank_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `invoice_count` SET TAGS ('dbx_business_glossary_term' = 'Invoice Count');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `local_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `net_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Payment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_advice_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Payment Advice Sent Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_advice_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Advice Sent Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Payment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_block_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_block_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_document_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_notes` SET TAGS ('dbx_business_glossary_term' = 'Payment Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_priority` SET TAGS ('dbx_business_glossary_term' = 'Payment Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_priority` SET TAGS ('dbx_value_regex' = 'URGENT|HIGH|NORMAL|LOW');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_proposal_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Proposal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_proposal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-/]{6,35}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `remittance_advice_number` SET TAGS ('dbx_business_glossary_term' = 'Remittance Advice Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `remittance_advice_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `value_date` SET TAGS ('dbx_business_glossary_term' = 'Value Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_account_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,18}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Bank Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,34}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_swift_code` SET TAGS ('dbx_business_glossary_term' = 'Vendor Bank SWIFT Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_swift_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_swift_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_bank_swift_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `wbs_element` SET TAGS ('dbx_value_regex' = '^[A-Z0-9.-]{6,24}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `receivable_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Service Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_value_regex' = 'current|1_30_days|31_60_days|61_90_days|over_90_days|over_180_days');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `baseline_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `cash_discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `cash_discount_date` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `clearing_status` SET TAGS ('dbx_business_glossary_term' = 'Clearing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `clearing_status` SET TAGS ('dbx_value_regex' = 'open|partially_cleared|fully_cleared|written_off');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `days_overdue` SET TAGS ('dbx_business_glossary_term' = 'Days Overdue');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `last_dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dunning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `local_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `outstanding_amount` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `posting_amount` SET TAGS ('dbx_business_glossary_term' = 'Posting Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `posting_text` SET TAGS ('dbx_business_glossary_term' = 'Posting Text');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `reference_key_1` SET TAGS ('dbx_business_glossary_term' = 'Reference Key 1');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `reference_key_2` SET TAGS ('dbx_business_glossary_term' = 'Reference Key 2');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `reference_key_3` SET TAGS ('dbx_business_glossary_term' = 'Reference Key 3');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `write_off_date` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `write_off_flag` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ALTER COLUMN `write_off_reason` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` SET TAGS ('dbx_subdomain' = 'budget_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `procurement_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Owner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `tertiary_budget_modified_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `tertiary_budget_modified_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `tertiary_budget_modified_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'DRAFT|SUBMITTED|UNDER_REVIEW|APPROVED|REJECTED|LOCKED');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `baseline_version_flag` SET TAGS ('dbx_business_glossary_term' = 'Baseline Version Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_category` SET TAGS ('dbx_business_glossary_term' = 'Budget Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_category` SET TAGS ('dbx_value_regex' = 'PERSONNEL|EQUIPMENT|MAINTENANCE|UTILITIES|SERVICES|MATERIALS');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_line_description` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_type` SET TAGS ('dbx_business_glossary_term' = 'Budget Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_type` SET TAGS ('dbx_value_regex' = 'OPEX|CAPEX|MIXED');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_version_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Version Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_version_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `business_justification` SET TAGS ('dbx_business_glossary_term' = 'Business Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `commitment_status` SET TAGS ('dbx_business_glossary_term' = 'Commitment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `commitment_status` SET TAGS ('dbx_value_regex' = 'UNCOMMITTED|COMMITTED|PARTIALLY_SPENT|FULLY_SPENT');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `contingency_percentage` SET TAGS ('dbx_business_glossary_term' = 'Contingency Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'Funding Source');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `funding_source` SET TAGS ('dbx_value_regex' = 'INTERNAL|GOVERNMENT_GRANT|LOAN|BOND|PPP');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `lock_date` SET TAGS ('dbx_business_glossary_term' = 'Lock Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `multi_year_flag` SET TAGS ('dbx_business_glossary_term' = 'Multi-Year Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `planned_amount` SET TAGS ('dbx_business_glossary_term' = 'Planned Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_business_glossary_term' = 'Planning Scenario');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_value_regex' = 'BASE|OPTIMISTIC|PESSIMISTIC|REFORECAST');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `quarterly_distribution_q1` SET TAGS ('dbx_business_glossary_term' = 'Quarterly Distribution Q1');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `quarterly_distribution_q2` SET TAGS ('dbx_business_glossary_term' = 'Quarterly Distribution Q2');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `quarterly_distribution_q3` SET TAGS ('dbx_business_glossary_term' = 'Quarterly Distribution Q3');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `quarterly_distribution_q4` SET TAGS ('dbx_business_glossary_term' = 'Quarterly Distribution Q4');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `reforecast_cycle` SET TAGS ('dbx_business_glossary_term' = 'Reforecast Cycle');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `reforecast_cycle` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4|MID_YEAR|YEAR_END');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `strategic_initiative_code` SET TAGS ('dbx_business_glossary_term' = 'Strategic Initiative Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `strategic_initiative_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ALTER COLUMN `variance_threshold_percentage` SET TAGS ('dbx_business_glossary_term' = 'Variance Threshold Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` SET TAGS ('dbx_subdomain' = 'budget_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_line_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `actual_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Spend Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Budget Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|revision_required');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `available_budget` SET TAGS ('dbx_business_glossary_term' = 'Available Budget Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_category` SET TAGS ('dbx_business_glossary_term' = 'Budget Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_category` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_owner` SET TAGS ('dbx_business_glossary_term' = 'Budget Owner');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_status` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_type` SET TAGS ('dbx_business_glossary_term' = 'Budget Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_version` SET TAGS ('dbx_business_glossary_term' = 'Budget Version');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `budget_version` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `business_unit_code` SET TAGS ('dbx_business_glossary_term' = 'Business Unit Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `business_unit_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `commitment_amount` SET TAGS ('dbx_business_glossary_term' = 'Commitment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External Reference ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `fund_code` SET TAGS ('dbx_business_glossary_term' = 'Fund Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `fund_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `investment_program_code` SET TAGS ('dbx_business_glossary_term' = 'Investment Program Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `investment_program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `is_carry_forward` SET TAGS ('dbx_business_glossary_term' = 'Carry Forward Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `is_locked` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Locked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `planned_amount` SET TAGS ('dbx_business_glossary_term' = 'Planned Budget Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Budget Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `strategic_initiative_code` SET TAGS ('dbx_business_glossary_term' = 'Strategic Initiative Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `strategic_initiative_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Budget Unit Price');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Variance Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `variance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Budget Variance Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_cycle_id` SET TAGS ('dbx_business_glossary_term' = 'Allocation Cycle ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Element ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Initiated By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Org Unit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Sender Cost Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Receiver Profit Centre ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Receiver Work Breakdown Structure (WBS) Element ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `reversed_allocation_cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Reversed Cost Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_basis_quantity` SET TAGS ('dbx_business_glossary_term' = 'Allocation Basis Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_basis_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Basis Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_basis_unit` SET TAGS ('dbx_business_glossary_term' = 'Allocation Basis Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_run_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Allocation Run Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_value_regex' = 'draft|posted|reversed|error');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_value_regex' = 'assessment|distribution|periodic_reposting|settlement|overhead_allocation');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `approved_by_user` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `approved_by_user` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `business_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `controlling_area` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `controlling_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `created_by_user` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `document_header_text` SET TAGS ('dbx_business_glossary_term' = 'Document Header Text');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Controlling Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `sender_original_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Sender Original Cost Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ALTER COLUMN `terminal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` SET TAGS ('dbx_subdomain' = 'asset_reporting');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `company_code_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `vendor_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Depreciation');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_description` SET TAGS ('dbx_business_glossary_term' = 'Asset Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_status` SET TAGS ('dbx_business_glossary_term' = 'Asset Financial Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_status` SET TAGS ('dbx_value_regex' = 'active|under_construction|retired|disposed|transferred|impaired');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_sub_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Sub-Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `asset_sub_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `business_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `capitalization_date` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `disposal_proceeds` SET TAGS ('dbx_business_glossary_term' = 'Disposal Proceeds');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'Funding Source');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `funding_source` SET TAGS ('dbx_value_regex' = 'internal_capex|government_grant|loan_financing|public_private_partnership|lease');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `grant_amount` SET TAGS ('dbx_business_glossary_term' = 'Government Grant Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `impairment_amount` SET TAGS ('dbx_business_glossary_term' = 'Impairment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `insured_value` SET TAGS ('dbx_business_glossary_term' = 'Insured Value');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `is_leased` SET TAGS ('dbx_business_glossary_term' = 'Leased Asset Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `last_depreciation_date` SET TAGS ('dbx_business_glossary_term' = 'Last Depreciation Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `last_revaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Last Revaluation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `lease_contract_number` SET TAGS ('dbx_business_glossary_term' = 'Lease Contract Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `lease_contract_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `net_book_value` SET TAGS ('dbx_business_glossary_term' = 'Net Book Value (NBV)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Asset Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `residual_value` SET TAGS ('dbx_business_glossary_term' = 'Residual Value');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `retirement_date` SET TAGS ('dbx_business_glossary_term' = 'Retirement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `revaluation_reserve` SET TAGS ('dbx_business_glossary_term' = 'Revaluation Reserve');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `tax_depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Tax Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `tax_depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|accelerated|none');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `tax_useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Tax Useful Life (Years)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` SET TAGS ('dbx_subdomain' = 'asset_reporting');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `asset_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Transaction ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Project ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `reversed_transaction_asset_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Reversed Transaction ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `security_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Security Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `approved_by_user` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `asset_class` SET TAGS ('dbx_business_glossary_term' = 'Asset Class');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `asset_value_date` SET TAGS ('dbx_business_glossary_term' = 'Asset Value Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `company_code_amount` SET TAGS ('dbx_business_glossary_term' = 'Company Code Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_business_glossary_term' = 'Company Code Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `depreciation_area` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `originating_document_number` SET TAGS ('dbx_business_glossary_term' = 'Originating Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `originating_document_type` SET TAGS ('dbx_business_glossary_term' = 'Originating Document Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `posted_by_user` SET TAGS ('dbx_business_glossary_term' = 'Posted By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `reference_key` SET TAGS ('dbx_business_glossary_term' = 'Reference Key');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_amount` SET TAGS ('dbx_business_glossary_term' = 'Transaction Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Transaction Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_value_regex' = 'draft|posted|reversed|cancelled|pending_approval|approved');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_text` SET TAGS ('dbx_business_glossary_term' = 'Transaction Text');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Transaction Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life Years');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `intercompany_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Netting Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `reversed_transaction_intercompany_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Reversed Transaction ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Sending Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `business_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `elimination_flag` SET TAGS ('dbx_business_glossary_term' = 'Elimination Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `elimination_status` SET TAGS ('dbx_business_glossary_term' = 'Elimination Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `elimination_status` SET TAGS ('dbx_value_regex' = 'pending|eliminated|reconciliation_required|exception');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `local_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `netting_flag` SET TAGS ('dbx_business_glossary_term' = 'Netting Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `posting_text` SET TAGS ('dbx_business_glossary_term' = 'Posting Text');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `receiving_company_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `receiving_company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'matched|unmatched|disputed|under_review|resolved');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `reconciliation_variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Variance Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `sending_company_code` SET TAGS ('dbx_business_glossary_term' = 'Sending Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `sending_company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `service_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'open|partially_settled|fully_settled|netted|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_amount` SET TAGS ('dbx_business_glossary_term' = 'Transaction Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_date` SET TAGS ('dbx_business_glossary_term' = 'Transaction Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_value_regex' = '^IC-[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transfer_pricing_documentation_ref` SET TAGS ('dbx_business_glossary_term' = 'Transfer Pricing Documentation Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transfer_pricing_method` SET TAGS ('dbx_business_glossary_term' = 'Transfer Pricing Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ALTER COLUMN `transfer_pricing_method` SET TAGS ('dbx_value_regex' = 'cost_plus|market_price|negotiated|comparable_uncontrolled|resale_minus');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` SET TAGS ('dbx_subdomain' = 'ledger_control');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `activation_date` SET TAGS ('dbx_business_glossary_term' = 'Company Code Activation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `business_area_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Business Area Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `business_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Business Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `chart_of_accounts_code` SET TAGS ('dbx_business_glossary_term' = 'Chart of Accounts (COA) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `chart_of_accounts_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `consolidation_group_code` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Group Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `consolidation_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `controlling_area_code` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area (CO) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `controlling_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `country_of_incorporation` SET TAGS ('dbx_business_glossary_term' = 'Country of Incorporation');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `country_of_incorporation` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_business_glossary_term' = 'Credit Control Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `deactivation_date` SET TAGS ('dbx_business_glossary_term' = 'Company Code Deactivation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `entity_status` SET TAGS ('dbx_business_glossary_term' = 'Entity Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `entity_status` SET TAGS ('dbx_value_regex' = 'active|inactive|dormant|liquidation|merged');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `entity_type` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `entity_type` SET TAGS ('dbx_value_regex' = 'operating_company|terminal_subsidiary|stevedoring_entity|property_holding|marine_services|joint_venture');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `financial_statement_version` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Version');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `financial_statement_version` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `fiscal_year_start_month` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year Start Month');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `functional_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `functional_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Reporting Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `incorporation_date` SET TAGS ('dbx_business_glossary_term' = 'Date of Incorporation');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `intercompany_clearing_account` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Clearing General Ledger (GL) Account');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `intercompany_clearing_account` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `legal_entity_identifier` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Identifier (LEI)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `legal_entity_identifier` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `legal_name` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Company Code Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `ownership_percentage` SET TAGS ('dbx_business_glossary_term' = 'Ownership Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `parent_company_code` SET TAGS ('dbx_business_glossary_term' = 'Parent Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `parent_company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `profit_center_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Registered Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Registered Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_city` SET TAGS ('dbx_business_glossary_term' = 'Registered City');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_country_code` SET TAGS ('dbx_business_glossary_term' = 'Registered Address Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Registered Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_state_province` SET TAGS ('dbx_business_glossary_term' = 'Registered State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `registered_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `retained_earnings_account` SET TAGS ('dbx_business_glossary_term' = 'Retained Earnings General Ledger (GL) Account');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `retained_earnings_account` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `short_name` SET TAGS ('dbx_business_glossary_term' = 'Company Short Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `tax_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `tax_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `valuation_area` SET TAGS ('dbx_business_glossary_term' = 'Valuation Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `valuation_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `vat_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Value Added Tax (VAT) Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ALTER COLUMN `vat_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` SET TAGS ('dbx_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `accrual_id` SET TAGS ('dbx_business_glossary_term' = 'Accrual Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Service Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `accrual_date` SET TAGS ('dbx_business_glossary_term' = 'Accrual Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `accrual_type` SET TAGS ('dbx_business_glossary_term' = 'Accrual Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `accrual_type` SET TAGS ('dbx_value_regex' = 'revenue|expense|prepayment|deferred_revenue|provision|reversal');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Accrual Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `business_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `accrual_category` SET TAGS ('dbx_business_glossary_term' = 'Accrual Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Accrual Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `local_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `posting_status` SET TAGS ('dbx_business_glossary_term' = 'Posting Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `posting_status` SET TAGS ('dbx_value_regex' = 'draft|posted|reversed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `posting_text` SET TAGS ('dbx_business_glossary_term' = 'Posting Text');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `reason` SET TAGS ('dbx_business_glossary_term' = 'Accrual Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `reference_key_1` SET TAGS ('dbx_business_glossary_term' = 'Reference Key 1');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `reference_key_2` SET TAGS ('dbx_business_glossary_term' = 'Reference Key 2');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `reference_key_3` SET TAGS ('dbx_business_glossary_term' = 'Reference Key 3');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `reversal_period` SET TAGS ('dbx_business_glossary_term' = 'Reversal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'open|partially_settled|fully_settled');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Variance Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` SET TAGS ('dbx_subdomain' = 'asset_reporting');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_liability_id` SET TAGS ('dbx_business_glossary_term' = 'Lease Liability Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `modified_lease_liability_id` SET TAGS ('dbx_business_glossary_term' = 'Modified Lease Liability Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `modified_lease_liability_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Lessor Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Depreciation on Right-of-Use (ROU) Asset');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `accumulated_interest_expense` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Interest Expense on Lease Liability');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `asset_description` SET TAGS ('dbx_business_glossary_term' = 'Leased Asset Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `asset_location` SET TAGS ('dbx_business_glossary_term' = 'Asset Location');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `current_lease_liability` SET TAGS ('dbx_business_glossary_term' = 'Current Lease Liability Balance');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `current_rou_asset_value` SET TAGS ('dbx_business_glossary_term' = 'Current Right-of-Use (ROU) Asset Value');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|diminishing_balance|units_of_production');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `discount_rate` SET TAGS ('dbx_business_glossary_term' = 'Incremental Borrowing Rate (IBR) Discount Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `extension_option_flag` SET TAGS ('dbx_business_glossary_term' = 'Extension Option Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `extension_option_years` SET TAGS ('dbx_business_glossary_term' = 'Extension Option Years');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `gl_account_liability` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account for Lease Liability');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `gl_account_rou_asset` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account for Right-of-Use (ROU) Asset');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `impairment_indicator` SET TAGS ('dbx_business_glossary_term' = 'Impairment Indicator Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `impairment_loss` SET TAGS ('dbx_business_glossary_term' = 'Impairment Loss on Right-of-Use (ROU) Asset');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `initial_lease_liability` SET TAGS ('dbx_business_glossary_term' = 'Initial Lease Liability');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `initial_rou_asset_value` SET TAGS ('dbx_business_glossary_term' = 'Initial Right-of-Use (ROU) Asset Value');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `last_remeasurement_date` SET TAGS ('dbx_business_glossary_term' = 'Last Remeasurement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_commencement_date` SET TAGS ('dbx_business_glossary_term' = 'Lease Commencement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_contract_number` SET TAGS ('dbx_business_glossary_term' = 'Lease Contract Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_end_date` SET TAGS ('dbx_business_glossary_term' = 'Lease End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_status` SET TAGS ('dbx_business_glossary_term' = 'Lease Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_status` SET TAGS ('dbx_value_regex' = 'active|terminated|modified|expired|pending_activation|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_term_months` SET TAGS ('dbx_business_glossary_term' = 'Lease Term in Months');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_type` SET TAGS ('dbx_business_glossary_term' = 'Lease Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lease_type` SET TAGS ('dbx_value_regex' = 'land_lease|equipment_lease|building_lease|concession_arrangement|infrastructure_lease|vehicle_lease');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `lessor_name` SET TAGS ('dbx_business_glossary_term' = 'Lessor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `long_term_liability_portion` SET TAGS ('dbx_business_glossary_term' = 'Long-Term Lease Liability Portion');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `modification_date` SET TAGS ('dbx_business_glossary_term' = 'Lease Modification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `modification_description` SET TAGS ('dbx_business_glossary_term' = 'Lease Modification Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `modification_flag` SET TAGS ('dbx_business_glossary_term' = 'Lease Modification Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `monthly_lease_payment` SET TAGS ('dbx_business_glossary_term' = 'Monthly Lease Payment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `next_payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `payment_frequency` SET TAGS ('dbx_business_glossary_term' = 'Lease Payment Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `payment_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annually|annually');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `purchase_option_flag` SET TAGS ('dbx_business_glossary_term' = 'Purchase Option Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `remeasurement_trigger` SET TAGS ('dbx_business_glossary_term' = 'Lease Liability Remeasurement Trigger');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `short_term_liability_portion` SET TAGS ('dbx_business_glossary_term' = 'Short-Term Lease Liability Portion');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `termination_option_flag` SET TAGS ('dbx_business_glossary_term' = 'Termination Option Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `variable_payment_basis` SET TAGS ('dbx_business_glossary_term' = 'Variable Payment Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ALTER COLUMN `variable_payment_flag` SET TAGS ('dbx_business_glossary_term' = 'Variable Payment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` SET TAGS ('dbx_subdomain' = 'asset_reporting');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_id` SET TAGS ('dbx_business_glossary_term' = 'Provision Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `revised_provision_id` SET TAGS ('dbx_business_glossary_term' = 'Revised Provision Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `revised_provision_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `business_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_category` SET TAGS ('dbx_business_glossary_term' = 'Provision Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_category` SET TAGS ('dbx_value_regex' = 'current|non_current');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `contingent_liability_flag` SET TAGS ('dbx_business_glossary_term' = 'Contingent Liability Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `current_provision_amount` SET TAGS ('dbx_business_glossary_term' = 'Current Provision Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `disclosure_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Disclosure Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `discount_rate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Rate Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `discount_unwinding_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Unwinding Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `estimation_method` SET TAGS ('dbx_business_glossary_term' = 'Estimation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `estimation_method` SET TAGS ('dbx_value_regex' = 'single_best_estimate|expected_value|range_midpoint|expert_valuation');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `expected_settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Settlement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Area Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `last_reassessment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reassessment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `legal_basis` SET TAGS ('dbx_business_glossary_term' = 'Legal Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `maximum_estimate_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Estimate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `measurement_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `minimum_estimate_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Estimate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `next_reassessment_date` SET TAGS ('dbx_business_glossary_term' = 'Next Reassessment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `obligation_description` SET TAGS ('dbx_business_glossary_term' = 'Obligation Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `original_provision_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Provision Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `outstanding_amount` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `probability_assessment` SET TAGS ('dbx_business_glossary_term' = 'Probability Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `probability_assessment` SET TAGS ('dbx_value_regex' = 'probable|possible|remote');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_number` SET TAGS ('dbx_business_glossary_term' = 'Provision Number');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_number` SET TAGS ('dbx_value_regex' = '^PRV-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_status` SET TAGS ('dbx_business_glossary_term' = 'Provision Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_status` SET TAGS ('dbx_value_regex' = 'recognized|remeasured|partially_settled|fully_settled|reversed|written_off');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_type` SET TAGS ('dbx_business_glossary_term' = 'Provision Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `provision_type` SET TAGS ('dbx_value_regex' = 'environmental_remediation|employee_entitlement|legal_claim|asset_decommissioning|warranty|restructuring');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reassessment_frequency` SET TAGS ('dbx_business_glossary_term' = 'Reassessment Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reassessment_frequency` SET TAGS ('dbx_value_regex' = 'annual|semi_annual|quarterly|event_driven');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Recognition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reimbursement_amount` SET TAGS ('dbx_business_glossary_term' = 'Reimbursement Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reimbursement_expected_flag` SET TAGS ('dbx_business_glossary_term' = 'Reimbursement Expected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reimbursement_source` SET TAGS ('dbx_business_glossary_term' = 'Reimbursement Source');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `settled_amount` SET TAGS ('dbx_business_glossary_term' = 'Settled Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `terminal_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ALTER COLUMN `undiscounted_amount` SET TAGS ('dbx_business_glossary_term' = 'Undiscounted Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` SET TAGS ('dbx_subdomain' = 'budget_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` SET TAGS ('dbx_association_edges' = 'finance.internal_order,workforce.gang');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `internal_order_gang_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Gang Assignment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Gang Assignment - Internal Order Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Gang Assignment - Workforce Stevedore Gang Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `actual_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `assignment_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `assignment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `assignment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `cost_centre_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `cost_rate` SET TAGS ('dbx_business_glossary_term' = 'Cost Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Assignment Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `planned_hours` SET TAGS ('dbx_business_glossary_term' = 'Planned Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ALTER COLUMN `work_type` SET TAGS ('dbx_business_glossary_term' = 'Work Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` SET TAGS ('dbx_subdomain' = 'budget_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` SET TAGS ('dbx_association_edges' = 'finance.wbs_element,workforce.gang');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `project_gang_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Project Gang Assignment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Project Gang Assignment - Wbs Element Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Project Gang Assignment - Workforce Stevedore Gang Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `actual_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Labour Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `assignment_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `assignment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `assignment_notes` SET TAGS ('dbx_business_glossary_term' = 'Assignment Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `assignment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `cost_allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `labour_cost_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Labour Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `labour_cost_planned` SET TAGS ('dbx_business_glossary_term' = 'Planned Labour Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `last_deployment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Deployment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `planned_hours` SET TAGS ('dbx_business_glossary_term' = 'Planned Labour Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ALTER COLUMN `work_phase` SET TAGS ('dbx_business_glossary_term' = 'Work Phase');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` SET TAGS ('dbx_subdomain' = 'ledger_control');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_id` SET TAGS ('dbx_business_glossary_term' = 'Allocation Cycle Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_reversal_cycle_id` SET TAGS ('dbx_business_glossary_term' = 'Reversal Cycle Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `primary_prior_allocation_cycle_id` SET TAGS ('dbx_business_glossary_term' = 'Prior Allocation Cycle Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `primary_prior_allocation_cycle_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `actual_execution_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Execution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_basis` SET TAGS ('dbx_business_glossary_term' = 'Allocation Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_method` SET TAGS ('dbx_business_glossary_term' = 'Allocation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_run_sequence` SET TAGS ('dbx_business_glossary_term' = 'Allocation Run Sequence');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `approval_required` SET TAGS ('dbx_business_glossary_term' = 'Approval Required');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `approved_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `controlling_area` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `cost_element_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `cycle_code` SET TAGS ('dbx_business_glossary_term' = 'Cycle Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `cycle_name` SET TAGS ('dbx_business_glossary_term' = 'Cycle Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `cycle_type` SET TAGS ('dbx_business_glossary_term' = 'Cycle Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `is_recurring` SET TAGS ('dbx_business_glossary_term' = 'Is Recurring');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `planned_execution_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Execution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `recurrence_pattern` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `reversal_allowed` SET TAGS ('dbx_business_glossary_term' = 'Reversal Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `target_cost_center_group` SET TAGS ('dbx_business_glossary_term' = 'Target Cost Center Group');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `total_allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Allocated Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`allocation_cycle` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` SET TAGS ('dbx_subdomain' = 'budget_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `investment_program_id` SET TAGS ('dbx_business_glossary_term' = 'Investment Program Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'General Ledger Account Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `investment_sponsor_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Sponsor Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `investment_sponsor_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `investment_sponsor_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Business Unit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `parent_investment_program_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Investment Program Id');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `parent_investment_program_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `actual_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Spend Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `approved_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Budget Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `business_justification` SET TAGS ('dbx_business_glossary_term' = 'Business Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `capitalization_method` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `committed_amount` SET TAGS ('dbx_business_glossary_term' = 'Committed Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `compliance_requirement_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirement Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `investment_program_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `environmental_impact_assessment_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Assessment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `expected_roi_percentage` SET TAGS ('dbx_business_glossary_term' = 'Expected Roi Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `forecast_amount` SET TAGS ('dbx_business_glossary_term' = 'Forecast Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'Funding Source');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `internal_rate_of_return_percentage` SET TAGS ('dbx_business_glossary_term' = 'Internal Rate Of Return Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `net_present_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Present Value Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `payback_period_months` SET TAGS ('dbx_business_glossary_term' = 'Payback Period Months');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `program_category` SET TAGS ('dbx_business_glossary_term' = 'Program Category');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Program Code');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Program Name');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `program_type` SET TAGS ('dbx_business_glossary_term' = 'Program Type');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `investment_program_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `strategic_objective` SET TAGS ('dbx_business_glossary_term' = 'Strategic Objective');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life Years');
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Variance Amount');
