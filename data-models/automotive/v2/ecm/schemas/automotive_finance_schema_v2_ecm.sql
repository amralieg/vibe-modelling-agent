-- Schema for Domain: finance | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:52

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`finance` COMMENT 'Core financial management including general ledger, accounts payable, accounts receivable, cost center accounting, and financial reporting. Manages CapEx (Capital Expenditure) tracking, budget planning, FY (Fiscal Year) close, EBITDA reporting, profitability analysis by vehicle line/plant/region, and intercompany settlements. Tracks manufacturing cost (material, labor, overhead), warranty reserves, and inventory valuation. Supports SOX compliance, IFRS/GAAP reporting. Integrates with SAP FI/CO.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`gl_account` (
    `gl_account_id` BIGINT COMMENT 'System-generated unique identifier for the GL account record.',
    `company_code_id` BIGINT COMMENT 'add column company_code_id (BIGINT) with FK to finance.company_code.company_code_id - GL accounts are defined within specific company codes per SAP FI',
    `balance_type` STRING COMMENT 'Indicates whether the account is reported on the balance sheet or the profit & loss statement.. Valid values are `profit_and_loss|balance_sheet`',
    `budget_amount` DECIMAL(18,2) COMMENT 'Approved budget amount allocated to the account for the fiscal year, expressed in the account currency.',
    `chart_of_accounts_version` STRING COMMENT 'Version identifier of the chart of accounts in which this account is defined.',
    `closing_balance` DECIMAL(18,2) COMMENT 'Balance of the account at the end of the fiscal year.',
    `gl_account_code` STRING COMMENT 'External business code used to identify the GL account in the chart of accounts.',
    `cost_center_code` STRING COMMENT 'Code of the cost center to which the account is assigned for internal cost allocation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the GL account record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code in which the account balances are expressed.',
    `gl_account_description` STRING COMMENT 'Free‑form description providing additional context about the account.',
    `effective_from` DATE COMMENT 'Date on which the GL account becomes active for posting.',
    `effective_to` DATE COMMENT 'Date on which the GL account is retired or becomes inactive; null if open‑ended.',
    `fiscal_year` STRING COMMENT 'Fiscal year (FY) to which the account is primarily associated for budgeting.',
    `group` STRING COMMENT 'Higher‑level grouping used for reporting and posting rules.',
    `is_budgeted` BOOLEAN COMMENT 'True if the account has an associated budget for the fiscal year.',
    `is_consolidation_account` BOOLEAN COMMENT 'Indicates whether the account participates in legal entity consolidation reporting.',
    `is_deprecated` BOOLEAN COMMENT 'True if the account is scheduled for phase‑out and should no longer be used for new postings.',
    `is_reconciliation_account` BOOLEAN COMMENT 'True if the account is used as a reconciliation (clearing) account for sub‑ledger postings.',
    `is_tax_relevant` BOOLEAN COMMENT 'Indicates whether the account participates in tax calculations.',
    `last_posting_date` DATE COMMENT 'Date of the most recent posting to this GL account.',
    `last_reconciliation_date` DATE COMMENT 'Date when the account was last reconciled with sub‑ledger balances.',
    `gl_account_name` STRING COMMENT 'Human‑readable name or title of the GL account.',
    `opening_balance` DECIMAL(18,2) COMMENT 'Balance of the account at the start of the fiscal year.',
    `profit_center_code` STRING COMMENT 'Code of the profit center linked to the account for profitability reporting.',
    `reporting_level` STRING COMMENT 'Level in the reporting hierarchy at which the account is aggregated.. Valid values are `company|division|plant|region|country`',
    `segment` STRING COMMENT 'Business segment to which the account belongs (e.g., OEM, Aftermarket, Service, R&D).. Valid values are `OEM|Aftermarket|Service|R&D`',
    `gl_account_status` STRING COMMENT 'Current lifecycle status of the account.. Valid values are `active|inactive|blocked|pending`',
    `tax_category` STRING COMMENT 'Category defining the tax treatment applied to postings in this account.. Valid values are `taxable|exempt|zero|reverse`',
    `gl_account_type` STRING COMMENT 'Classification of the account as asset, liability, equity, revenue, or expense.. Valid values are `asset|liability|equity|revenue|expense`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the GL account record.',
    CONSTRAINT pk_gl_account PRIMARY KEY(`gl_account_id`)
) COMMENT 'General Ledger (GL) account master record aligned with SAP FI chart of accounts. Defines each account in the corporate chart of accounts including account type (asset, liability, equity, revenue, expense), account group, P&L vs balance sheet classification, currency, tax category, and reconciliation account flags. SSOT for all GL account definitions used across FI/CO postings, IFRS/GAAP reporting, and SOX compliance controls.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`cost_center` (
    `cost_center_id` BIGINT COMMENT 'Unique surrogate key for the cost center master record.',
    `parent_cost_center_id` BIGINT COMMENT 'Identifier of the immediate parent cost center in the hierarchy (null for top‑level).',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant to which the cost center is assigned.',
    `actual_spend` DECIMAL(18,2) COMMENT 'Cumulative actual expenses posted to the cost center.',
    `allocation_method` STRING COMMENT 'Method used to allocate indirect costs to the cost center.. Valid values are `fixed|percentage|activity_based|none`',
    `approval_status` STRING COMMENT 'Current approval state of the cost centers budget.. Valid values are `pending|approved|rejected`',
    `budget_amount` DECIMAL(18,2) COMMENT 'Planned budget amount allocated to the cost center for the fiscal year.',
    `cost_center_category` STRING COMMENT 'Higher‑level classification of the cost center for reporting purposes.. Valid values are `cost_center|profit_center|investment_center`',
    `cost_center_code` STRING COMMENT 'External business code assigned to the cost center (e.g., SAP CO cost center code).',
    `country` STRING COMMENT 'Three‑letter ISO country code of the cost centers primary location.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the cost center record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three‑letter currency code used for budgeting and reporting.. Valid values are `^[A-Z]{3}$`',
    `cost_center_description` STRING COMMENT 'Free‑form description of the cost center purpose and scope.',
    `effective_from` DATE COMMENT 'Date when the cost center becomes valid for posting costs.',
    `effective_to` DATE COMMENT 'Date when the cost center is retired or no longer valid (nullable).',
    `fiscal_year` STRING COMMENT 'Fiscal year for which the budget is defined (e.g., FY2025).',
    `hierarchy_level` STRING COMMENT 'Depth of the cost center within the organizational hierarchy (1 = top level).',
    `last_review_date` DATE COMMENT 'Date when the cost centers budget and performance were last reviewed.',
    `cost_center_name` STRING COMMENT 'Human‑readable name of the cost center used in reports and UI.',
    `region` STRING COMMENT 'Business region (e.g., North America, Europe) where the cost center operates.',
    `reporting_level` STRING COMMENT 'Level at which the cost center is aggregated for financial reporting.. Valid values are `plant|division|global`',
    `cost_center_status` STRING COMMENT 'Current operational status of the cost center.. Valid values are `active|inactive|planned|closed`',
    `cost_center_type` STRING COMMENT 'Category of the cost center indicating its primary function within the organization.. Valid values are `production|administration|research|sales|service`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the cost center record.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between budgeted and actual spend (budget – actual).',
    CONSTRAINT pk_cost_center PRIMARY KEY(`cost_center_id`)
) COMMENT 'Cost center master record representing an organizational unit to which manufacturing costs, labor, overhead, and indirect expenses are assigned. Aligned with SAP CO cost center accounting (CCA). Captures cost center hierarchy, responsible manager, plant assignment, profit center linkage, valid-from/to dates, currency, and cost center category (production, administration, R&D, sales). Supports EBITDA reporting and profitability analysis by plant, vehicle line, and region.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`profit_center` (
    `profit_center_id` BIGINT COMMENT 'Unique surrogate key for the profit center record.',
    `employee_id` BIGINT COMMENT 'Surrogate key of the employee who owns the profit center.',
    `owner_id` BIGINT COMMENT 'Surrogate key of the employee who owns the profit center.',
    `parent_profit_center_id` BIGINT COMMENT 'Identifier of the immediate parent profit center in the hierarchy.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant associated with the profit center.',
    `primary_employee_id` BIGINT COMMENT 'Surrogate key of the employee responsible for the profit center.',
    `primary_profit_manager_employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `actual_amount` DECIMAL(18,2) COMMENT 'Actual realized amount for the profit center in the current period.',
    `audit_trail` STRING COMMENT 'JSON‑encoded log of significant changes to the profit center record.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Approved budget for the profit center for the fiscal year.',
    `profit_center_category` STRING COMMENT 'High‑level category such as Vehicle Line, Service, Parts, or Finance.',
    `closure_date` DATE COMMENT 'Date on which the profit center was officially closed.',
    `profit_center_code` STRING COMMENT 'Business identifier code used in SAP and external reports.',
    `company_code` STRING COMMENT 'SAP company code to which the profit center belongs.',
    `compliance_status` STRING COMMENT 'Current compliance status with internal and external regulatory requirements.. Valid values are `Compliant|NonCompliant|Pending`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the profit center record was first created.',
    `currency_code` STRING COMMENT 'Currency in which the profit center records its transactions.. Valid values are `^[A-Z]{3}$`',
    `profit_center_description` STRING COMMENT 'Free‑form description of the profit centers purpose and scope.',
    `ebitda_amount` DECIMAL(18,2) COMMENT 'Earnings before interest, taxes, depreciation, and amortization for the profit center.',
    `effective_from` DATE COMMENT 'Date when the profit center became operational.',
    `effective_to` DATE COMMENT 'Date when the profit center is scheduled to be retired (nullable for open‑ended).',
    `external_reference` STRING COMMENT 'Identifier used in external ERP or reporting systems to reference this profit center.',
    `group` STRING COMMENT 'Logical grouping used for internal reporting (e.g., Group A, Group B).',
    `hierarchy_path` STRING COMMENT 'Slash‑delimited path showing the profit centers position in the hierarchy (e.g., /1000/2000/3000).',
    `is_consolidated` BOOLEAN COMMENT 'Indicates whether the profit center is included in corporate consolidation.',
    `is_intercompany` BOOLEAN COMMENT 'True if the profit center participates in intercompany transactions.',
    `last_review_date` DATE COMMENT 'Date of the most recent financial or operational review.',
    `profit_center_level` STRING COMMENT 'Numeric depth of the profit center within the organizational hierarchy.',
    `margin_percent` DECIMAL(18,2) COMMENT 'Profit margin expressed as a percentage of revenue.',
    `profit_center_name` STRING COMMENT 'Human‑readable name of the profit center.',
    `notes` STRING COMMENT 'Additional free‑form notes or comments about the profit center.',
    `owner` STRING COMMENT 'Name of the business owner or sponsor of the profit center.',
    `plan_amount` DECIMAL(18,2) COMMENT 'Planned financial amount for the upcoming period.',
    `region_code` STRING COMMENT 'Three‑letter code representing the geographic region of the profit center.. Valid values are `NA|EU|APAC|LATAM|MEA`',
    `reporting_currency` STRING COMMENT 'Currency used for consolidated financial reporting of the profit center.. Valid values are `^[A-Z]{3}$`',
    `review_cycle` STRING COMMENT 'Frequency of scheduled reviews for the profit center.. Valid values are `Annual|Quarterly`',
    `risk_rating` STRING COMMENT 'Risk rating assigned to the profit center based on financial and operational exposure.. Valid values are `Low|Medium|High`',
    `segment` STRING COMMENT 'Segment classification of the profit center (e.g., electric vehicle, internal combustion, hybrid, commercial).. Valid values are `EV|ICE|HEV|PHEV|Commercial|Luxury`',
    `profit_center_status` STRING COMMENT 'Current lifecycle status of the profit center.. Valid values are `Active|Inactive|Planned|Closed`',
    `status_reason` STRING COMMENT 'Free‑text explanation for the current status of the profit center.',
    `profit_center_type` STRING COMMENT 'Category of profit center indicating its accounting purpose.. Valid values are `Legal|Operating|Reporting`',
    `updated_by` STRING COMMENT 'User identifier of the person who performed the last update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the profit center record.',
    `created_by` STRING COMMENT 'User identifier of the person who created the record.',
    CONSTRAINT pk_profit_center PRIMARY KEY(`profit_center_id`)
) COMMENT 'Profit center master record representing a management accounting unit used to analyze profitability by vehicle line, plant, region, or business segment. Aligned with SAP CO-PCA (Profit Center Accounting). Captures profit center hierarchy, responsible manager, company code assignment, segment classification (EV, ICE, HEV, commercial), and reporting currency. Enables contribution margin and EBITDA analysis at granular business unit level.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`company_code` (
    `company_code_id` BIGINT COMMENT 'Surrogate primary key uniquely identifying the company code record.',
    `intercompany_group_id` BIGINT COMMENT 'Identifier of the intercompany settlement group to which the entity belongs.',
    `address_line1` STRING COMMENT 'Primary street address of the legal entity.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, floor, etc.).',
    `business_line` STRING COMMENT 'Primary business line or functional area of the entity. [ENUM-REF-CANDIDATE: design_engineering|manufacturing|sales|after_sales|r&d|finance|procurement — 7 candidates stripped; promote to reference product]',
    `chart_of_accounts` STRING COMMENT 'Identifier of the chart of accounts used for financial posting.',
    `city` STRING COMMENT 'City where the legal entity is located.',
    `company_code` STRING COMMENT 'Alphanumeric identifier used in SAP FI to represent the legal entity (e.g., US01, DE02).',
    `consolidation_group` STRING COMMENT 'Group identifier used for legal consolidation of financial statements.',
    `cost_center_code` STRING COMMENT 'Cost center identifier for internal cost allocation.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code where the legal entity is incorporated.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the company code record was first created in the system.',
    `effective_end_date` DATE COMMENT 'Date on which the company code ceases to be effective (null if open‑ended).',
    `effective_start_date` DATE COMMENT 'Date on which the company code becomes effective for accounting.',
    `email_address` STRING COMMENT 'Primary email address for corporate communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `entity_type` STRING COMMENT 'Classification of the legal entity within the corporate structure.. Valid values are `legal_entity|joint_venture|subsidiary|branch|holding`',
    `fiscal_year_variant` STRING COMMENT 'SAP fiscal year variant code defining the fiscal calendar for the entity.. Valid values are `FY01|FY02|FY03|FY04|FY05|FY06`',
    `functional_currency` STRING COMMENT 'Currency in which the entitys internal transactions are recorded.. Valid values are `^[A-Z]{3}$`',
    `industry_sector` STRING COMMENT 'Broad industry segment in which the entity operates.. Valid values are `passenger_vehicles|commercial_vehicles|components|services|software`',
    `is_consolidated` BOOLEAN COMMENT 'Indicates whether the entity is included in group consolidation.',
    `legal_name` STRING COMMENT 'Full legal name of the company as registered with the jurisdiction.',
    `lifecycle_status` STRING COMMENT 'Lifecycle stage of the entity (e.g., active, suspended, terminated, draft).',
    `local_currency` STRING COMMENT 'ISO 4217 currency code of the entitys functional currency for local reporting.. Valid values are `^[A-Z]{3}$`',
    `phone_number` STRING COMMENT 'Primary contact telephone number for the legal entity.',
    `postal_code` STRING COMMENT 'Postal/ZIP code for the entitys address.. Valid values are `^[A-Z0-9]{3,10}$`',
    `profit_center_code` STRING COMMENT 'Code of the profit center to which the entity reports.',
    `registration_number` STRING COMMENT 'Official registration number assigned by the corporate registry.',
    `reporting_standard` STRING COMMENT 'Accounting framework used for statutory reporting (e.g., IFRS, US GAAP).. Valid values are `IFRS|GAAP|IFRS_FOR_SME|US_GAAP|EU_GAAP`',
    `segment` STRING COMMENT 'Segment (global, regional, local) used in management reporting.',
    `short_name` STRING COMMENT 'Abbreviated or commonly used name for the legal entity.',
    `state_province` STRING COMMENT 'State or province of the entitys address.',
    `company_code_status` STRING COMMENT 'Current operational status of the legal entity.. Valid values are `active|inactive|closed|pending`',
    `tax_id_number` STRING COMMENT 'Government‑issued tax identifier for the legal entity.',
    `tax_jurisdiction_code` STRING COMMENT 'Code representing the tax jurisdiction applicable to the entity.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the company code record.',
    `website_url` STRING COMMENT 'Public website URL of the legal entity.',
    CONSTRAINT pk_company_code PRIMARY KEY(`company_code_id`)
) COMMENT 'Legal entity and company code master record representing an independent accounting unit within the Automotive enterprise. Aligned with SAP FI company code configuration. Captures legal entity name, country of incorporation, fiscal year variant, chart of accounts assignment, local currency, functional currency, IFRS/GAAP reporting standard, tax jurisdiction, and intercompany settlement group. Supports multi-entity consolidation and intercompany eliminations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` (
    `fiscal_period_id` BIGINT COMMENT 'System-generated unique identifier for the fiscal period record.',
    `accrual_cutoff_date` DATE COMMENT 'Date after which accruals are no longer allowed for this period.',
    `company_code` STRING COMMENT 'Organizational code of the legal entity to which the period applies.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the fiscal period record was initially created in the system.',
    `fiscal_period_description` STRING COMMENT 'Optional free‑text notes describing special characteristics of the period.',
    `end_date` DATE COMMENT 'Last calendar date of the fiscal period.',
    `fiscal_year` STRING COMMENT 'Four‑digit calendar year to which the period belongs, e.g., 2024.',
    `fiscal_year_variant` STRING COMMENT 'Identifier for the fiscal year variant configuration (e.g., 12‑month, 4‑quarter, 13‑period).',
    `is_current_period` BOOLEAN COMMENT 'True if this period is the active period for ongoing postings.',
    `is_interim` BOOLEAN COMMENT 'Indicates whether the period is an interim reporting period (true) or a full fiscal period (false).',
    `lock_date` DATE COMMENT 'Date on which the period was locked for posting; null if not locked.',
    `fiscal_period_name` STRING COMMENT 'Human‑readable label for the period, e.g., "January", "Q1", "Special Adjustment".',
    `number` STRING COMMENT 'Sequential number of the period within the fiscal year (1‑12 for monthly, 1‑4 for quarterly).',
    `posting_deadline_date` DATE COMMENT 'Final date by which all transactions must be posted to this period.',
    `start_date` DATE COMMENT 'First calendar date of the fiscal period.',
    `fiscal_period_status` STRING COMMENT 'Current lifecycle status of the period used for posting: open, closed, or locked.. Valid values are `open|closed|locked`',
    `fiscal_period_type` STRING COMMENT 'Classification of the period: regular reporting, adjustment, or special period.. Valid values are `regular|adjustment|special`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the fiscal period record.',
    CONSTRAINT pk_fiscal_period PRIMARY KEY(`fiscal_period_id`)
) COMMENT 'Fiscal period and fiscal year (FY) calendar reference master defining the financial reporting periods used across the enterprise. Captures fiscal year, period number, period name, start date, end date, period status (open, closed, locked), period type (regular, special/adjustment), and company code applicability. Governs FY close processes, period-end accruals, and IFRS/GAAP reporting windows. Aligned with SAP FI fiscal year variant configuration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`journal_entry` (
    `journal_entry_id` BIGINT COMMENT 'Unique identifier for the journal entry record.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Replace string company_code with FK to company_code for proper relational integrity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Reference cost_center master instead of free‑text code.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Link journal entry to fiscal period master for consistent period handling.',
    `employee_id` BIGINT COMMENT 'Identifier of the user or system that performed the posting.',
    `party_id` BIGINT COMMENT 'Identifier of the business partner (vendor, customer, or other) associated with the entry.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the user or system that performed the posting.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Reference profit_center master for reporting consistency.',
    `amount` DECIMAL(18,2) COMMENT 'Total amount of the journal entry in the document currency.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the journal entry record was created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code of the amounts.',
    `debit_credit_indicator` STRING COMMENT 'Indicates whether the line is a debit or credit.. Valid values are `debit|credit`',
    `document_date` DATE COMMENT 'Date recorded on the accounting document (may differ from posting date).',
    `document_language` STRING COMMENT 'Language key of the document (e.g., EN, DE).',
    `document_number` STRING COMMENT 'External document number assigned by SAP FI for the journal entry.',
    `document_type` STRING COMMENT 'Type of accounting document (e.g., SA – General Ledger, KR – Vendor Invoice, AB – Customer Invoice).. Valid values are `SA|KR|AB|DR|CR`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Exchange rate used to convert foreign currency to local currency.',
    `exchange_rate_type` STRING COMMENT 'Type of exchange rate (e.g., M – average, G – spot).',
    `intercompany_indicator` BOOLEAN COMMENT 'True if the entry is part of an intercompany transaction.',
    `is_adjustment` BOOLEAN COMMENT 'Indicates whether the entry is an adjusting entry (e.g., accrual).',
    `is_consolidated` BOOLEAN COMMENT 'True if the entry is part of a consolidated financial statement.',
    `is_manual_entry` BOOLEAN COMMENT 'True if the entry was entered manually rather than by automated process.',
    `is_test_entry` BOOLEAN COMMENT 'True if the entry is a test or simulation record.',
    `ledger_group` STRING COMMENT 'Ledger group indicating IFRS or local GAAP ledger.',
    `line_item_count` STRING COMMENT 'Number of line items associated with this journal entry.',
    `plant` STRING COMMENT 'Plant code where the transaction originated.',
    `posting_category` STRING COMMENT 'High‑level category of the posting (e.g., GL, AP, AR).',
    `posting_key` STRING COMMENT 'SAP posting key defining the transaction type (e.g., 40 for debit).',
    `posting_period` STRING COMMENT 'Posting period identifier (e.g., 202401).',
    `posting_reference` STRING COMMENT 'External reference identifier (e.g., external system ID).',
    `posting_text` STRING COMMENT 'User‑defined text describing the posting.',
    `posting_timestamp` TIMESTAMP COMMENT 'Date and time when the entry was posted to the ledger.',
    `posting_user_role` STRING COMMENT 'Role of the user who posted the entry (e.g., accountant, system).',
    `reference_document_number` STRING COMMENT 'Reference number linking to related documents (e.g., invoice).',
    `reversal_document_number` STRING COMMENT 'Document number of the original entry being reversed.',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating if the entry is a reversal of a previous entry.',
    `segment` STRING COMMENT 'Segment identifier for internal reporting (e.g., automotive, powertrain).',
    `source_module` STRING COMMENT 'Specific module within the source system (e.g., FI‑GL).',
    `journal_entry_status` STRING COMMENT 'Current processing status of the journal entry.. Valid values are `posted|reversed|pending|error`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount calculated for the entry.',
    `tax_code` STRING COMMENT 'Tax code applied to the entry for tax determination.',
    `tax_jurisdiction` STRING COMMENT 'Tax jurisdiction code applicable to the entry.',
    `transaction_code` STRING COMMENT 'Code representing the business transaction (e.g., AP, AR).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the journal entry record.',
    CONSTRAINT pk_journal_entry PRIMARY KEY(`journal_entry_id`)
) COMMENT 'General ledger journal entry header record capturing all financial postings in the SAP FI ledger. Represents the primary transactional record for every accounting document including goods issue postings, vendor invoice postings, customer payments, accruals, depreciation runs, intercompany settlements, and manual adjustments. Captures document type, posting date, fiscal year/period, company code, reference document, posting user, reversal indicator, and ledger group (IFRS vs local GAAP). SSOT for all GL postings.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` (
    `journal_entry_line_id` BIGINT COMMENT 'System-generated unique identifier for the journal entry line record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Link line to cost_center master for cost allocation.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Replace string GL account code with FK to gl_account master.',
    `journal_entry_id` BIGINT COMMENT 'Identifier of the parent journal entry (header) to which this line belongs.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Link line to profit_center master for profitability reporting.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Reference WBS element master for project cost tracking.',
    `account_type` STRING COMMENT 'Classification of the GL account (e.g., balance sheet, profit & loss).',
    `amount_cc` DECIMAL(18,2) COMMENT 'Monetary amount posted on the line in the company code (local) currency.',
    `amount_tc` DECIMAL(18,2) COMMENT 'Monetary amount posted on the line in the transaction currency.',
    `assignment` STRING COMMENT 'User‑defined assignment field for additional categorisation (e.g., cost object).',
    `business_area` STRING COMMENT 'Business area classification for reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the journal entry line record was created in the system.',
    `currency_cc` STRING COMMENT 'Three‑letter ISO 4217 code of the company code (local) currency.. Valid values are `[A-Z]{3}`',
    `currency_tc` STRING COMMENT 'Three‑letter ISO 4217 code of the transaction currency.. Valid values are `[A-Z]{3}`',
    `debit_credit_indicator` STRING COMMENT 'Flag indicating whether the line is a debit (D) or credit (C).. Valid values are `D|C`',
    `document_date` DATE COMMENT 'Date printed on the accounting document.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Rate used to convert amount_tc to amount_cc.',
    `exchange_rate_type` STRING COMMENT 'Identifier of the exchange rate type (e.g., M for market, A for average).',
    `fiscal_period` STRING COMMENT 'Fiscal period (month or period code) of the posting.',
    `fiscal_year` STRING COMMENT 'Fiscal year of the posting (e.g., 2024).',
    `plant` STRING COMMENT 'Manufacturing plant or location code associated with the posting.',
    `posting_date` DATE COMMENT 'Date on which the line is posted to the ledger.',
    `posting_key` STRING COMMENT 'SAP posting key that determines the type of posting (e.g., debit/credit).',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity associated with the line (e.g., number of units, hours).',
    `reference_document_item` STRING COMMENT 'Item number of the referenced external document.',
    `reference_document_number` STRING COMMENT 'External document number referenced by this line (e.g., invoice).',
    `reversal_indicator` BOOLEAN COMMENT 'True if this line reverses a previous posting.',
    `segment` STRING COMMENT 'Segment code for profitability analysis.',
    `sequence` STRING COMMENT 'Sequential number of the line within the journal entry, used for ordering.',
    `tax_code` STRING COMMENT 'Tax code used for tax calculation on the line.',
    `text` STRING COMMENT 'Free‑form description of the line item.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the journal entry line record.',
    CONSTRAINT pk_journal_entry_line PRIMARY KEY(`journal_entry_line_id`)
) COMMENT 'Individual line item within a GL journal entry, representing a single debit or credit posting to a GL account. Captures GL account, debit/credit indicator, posting amount in transaction currency and company code currency, cost center, profit center, WBS element, plant, tax code, assignment field, and line item text. Supports detailed cost allocation, profitability analysis, and SOX audit trail requirements. Aligned with SAP FI line item table (BSEG).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` (
    `ap_invoice_id` BIGINT COMMENT 'System-generated unique identifier for the AP invoice record.',
    `trade_compliance_record_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_compliance_record. Business justification: AP invoices for imported parts must reference the trade compliance record to ensure customs duties and export‑control compliance.',
    `vendor_id` BIGINT COMMENT 'Unique identifier of the supplier that issued the invoice.',
    `cost_center_code` STRING COMMENT 'Cost center associated with the invoice for internal accounting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the invoice record was created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code of the invoice amount.. Valid values are `^[A-Z]{3}$`',
    `ap_invoice_date` DATE COMMENT 'Date the supplier issued the invoice.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Early payment or contractual discount applied to the invoice.',
    `due_date` DATE COMMENT 'Date by which payment must be made according to payment terms.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Rate used to convert invoice currency to the reporting currency.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the invoice belongs.. Valid values are `^[0-9]{4}$`',
    `goods_receipt_number` STRING COMMENT 'Reference to the goods receipt that triggered the invoice.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total invoice amount before taxes and discounts.',
    `is_credit_memo` BOOLEAN COMMENT 'True if the record represents a credit memo rather than a standard invoice.',
    `material_group` STRING COMMENT 'Group classification of materials purchased.',
    `net_amount` DECIMAL(18,2) COMMENT 'Invoice amount after tax and discounts.',
    `notes` STRING COMMENT 'Free-text notes entered on the invoice for additional context.',
    `number` STRING COMMENT 'Vendor-assigned invoice number used for reference and matching.',
    `payment_block_flag` BOOLEAN COMMENT 'Indicates whether payment of the invoice is blocked (true) or allowed (false).',
    `payment_date` DATE COMMENT 'Date the invoice was paid.',
    `payment_method` STRING COMMENT 'Method used for payment (e.g., ACH, Wire, Check).. Valid values are `ACH|Wire|Check|CreditCard|Cash`',
    `payment_reference` STRING COMMENT 'Reference number of the payment transaction.',
    `payment_terms` STRING COMMENT 'Standard payment terms code governing the invoice.. Valid values are `Net30|Net45|Net60|EOM|2%_10`',
    `plant_code` STRING COMMENT 'Manufacturing plant code related to the invoice.',
    `posting_date` DATE COMMENT 'Date the invoice was posted to the general ledger.',
    `ppap_status` STRING COMMENT 'Status of the Production Part Approval Process for the supplier.. Valid values are `NotStarted|InProgress|Approved|Rejected`',
    `purchase_order_number` STRING COMMENT 'Reference to the purchase order associated with the invoice.',
    `reporting_currency_code` STRING COMMENT 'Currency code used for financial reporting of the invoice.. Valid values are `^[A-Z]{3}$`',
    `ap_invoice_status` STRING COMMENT 'Current processing status of the invoice.. Valid values are `draft|open|approved|paid|rejected|cancelled`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount included in the invoice.',
    `tax_code` STRING COMMENT 'Tax code used for tax calculation on the invoice.. Valid values are `VAT|GST|SALES|NONE`',
    `three_way_match_flag` BOOLEAN COMMENT 'True when purchase order, goods receipt, and invoice are matched.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the last update to the invoice record.',
    `warranty_reserve_amount` DECIMAL(18,2) COMMENT 'Amount reserved for warranty liability related to the invoice.',
    CONSTRAINT pk_ap_invoice PRIMARY KEY(`ap_invoice_id`)
) COMMENT 'Accounts Payable (AP) vendor invoice record capturing supplier invoices received for direct materials (production parts, CKD/SKD kits), indirect materials (MRO, tooling), and services. Aligned with SAP FI-AP (Accounts Payable) module. Captures vendor ID, invoice date, posting date, payment terms, gross amount, tax amount, net amount, currency, payment block status, three-way match status (PO/GR/IR), due date, and payment method. Supports PPAP-related supplier payment tracking and cash flow management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`ap_payment` (
    `ap_payment_id` BIGINT COMMENT 'Unique identifier for the payment transaction.',
    `payment_run_id` BIGINT COMMENT 'Identifier of the batch run that processed this payment.',
    `payment_settlement_id` BIGINT COMMENT 'Identifier linking to settlement batch.',
    `vendor_id` BIGINT COMMENT 'Unique identifier of the supplier/vendor receiving the payment.',
    `amount_gross` DECIMAL(18,2) COMMENT 'Total payment amount before taxes and discounts.',
    `amount_net` DECIMAL(18,2) COMMENT 'Final amount after tax and discount.',
    `bank_account_number` STRING COMMENT 'Bank account number used for the payment (PCI-sensitive).',
    `channel` STRING COMMENT 'Channel through which the payment was initiated.. Valid values are `online|batch|manual`',
    `clearance_date` DATE COMMENT 'Date when the payment cleared the bank.',
    `comments` STRING COMMENT 'Additional comments or notes regarding the payment.',
    `cost_center` STRING COMMENT 'Cost center associated with the payment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment record was created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code of the payment.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `ap_payment_date` DATE COMMENT 'Calendar date of the payment (date part).',
    `ap_payment_description` STRING COMMENT 'Free-text description or memo for the payment.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Discount applied to the payment.',
    `document_number` STRING COMMENT 'Document number assigned to the payment in the ERP system.',
    `due_date` DATE COMMENT 'Original due date of the invoice(s) being paid.',
    `early_payment_discount_flag` BOOLEAN COMMENT 'Indicates if an early payment discount was applied.',
    `error_flag` BOOLEAN COMMENT 'Indicates if the payment encountered an error.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Exchange rate applied if payment currency differs from functional currency.',
    `exchange_rate_date` DATE COMMENT 'Date on which the exchange rate was determined.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month/quarter) of the payment.',
    `fiscal_year` STRING COMMENT 'Fiscal year of the payment.',
    `gl_account` STRING COMMENT 'General Ledger account code charged for the payment.',
    `house_bank_code` STRING COMMENT 'Code of the house bank handling the payment.',
    `is_automated` BOOLEAN COMMENT 'Flag indicating if the payment was processed automatically.',
    `method` STRING COMMENT 'Method used to make the payment (e.g., ACH, wire, check, EFT).. Valid values are `ach|wire|check|eft`',
    `original_amount` DECIMAL(18,2) COMMENT 'Payment amount in original invoice currency.',
    `original_currency` STRING COMMENT 'Currency of the original invoice amount.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `priority` STRING COMMENT 'Priority level assigned to the payment.. Valid values are `high|normal|low`',
    `reference` STRING COMMENT 'External reference number provided by the vendor or bank.',
    `settlement_date` DATE COMMENT 'Date of the settlement batch.',
    `ap_payment_status` STRING COMMENT 'Current processing status of the payment.. Valid values are `pending|processed|cleared|failed|reversed`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component of the payment.',
    `tax_code` STRING COMMENT 'Tax code applied to the payment.',
    `terms` STRING COMMENT 'Contractual payment terms (e.g., Net30).',
    `timestamp` TIMESTAMP COMMENT 'Exact date and time when the payment was executed.',
    `ap_payment_type` STRING COMMENT 'Indicates if the payment is outbound (to vendor) or inbound (refund).. Valid values are `outbound|inbound`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the payment record.',
    `vat_amount` DECIMAL(18,2) COMMENT 'Value-added tax amount included in the payment.',
    CONSTRAINT pk_ap_payment PRIMARY KEY(`ap_payment_id`)
) COMMENT 'Accounts Payable payment transaction record capturing outgoing payments made to suppliers and vendors. Captures payment run ID, payment date, vendor ID, bank account, payment method (ACH, wire, check), payment amount, currency, cleared invoice references, payment document number, house bank, and payment status. Supports supplier payment performance tracking, cash management, and working capital optimization aligned with JIT/JIS supply chain payment terms.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` (
    `ar_invoice_id` BIGINT COMMENT 'System-generated unique identifier for the AR invoice record.',
    `company_code_id` BIGINT COMMENT 'Identifier of the related legal entity in an intercompany invoice.',
    `primary_company_code_id` BIGINT COMMENT 'Identifier of the related legal entity in an intercompany invoice.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer or dealer billed on the invoice.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Accounts receivable invoices for vehicle sales must reference the VIN registry to validate warranty eligibility and tax reporting.',
    `accounting_date` DATE COMMENT 'Date used for accounting period posting.',
    `aging_bucket` STRING COMMENT 'Age category of the invoice based on days past due.. Valid values are `current|1_30|31_60|61_90|90_plus|unknown`',
    `billing_document_number` STRING COMMENT 'Reference number of the SAP billing document linked to this invoice.',
    `ar_invoice_category` STRING COMMENT 'Business segment or market category for the invoice.. Valid values are `domestic|export|internal|fleet|government|other`',
    `collection_status` STRING COMMENT 'Status of the invoice in the collections process.. Valid values are `on_time|late|defaulted|written_off|disputed|unknown`',
    `cost_center_code` STRING COMMENT 'Cost center responsible for the expense.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the invoice record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the invoice.',
    `ar_invoice_date` DATE COMMENT 'Date the invoice was issued to the customer.',
    `delivery_note_number` STRING COMMENT 'Delivery document associated with the shipped goods.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Monetary value of any discount applied to the invoice.',
    `discount_reason` STRING COMMENT 'Explanation or code for the discount granted.',
    `distribution_channel` STRING COMMENT 'Channel through which the product was sold (e.g., dealer, fleet, direct).',
    `due_date` DATE COMMENT 'Date by which payment is expected according to payment terms.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the invoice belongs (e.g., 2025).',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total amount before taxes, discounts, and adjustments.',
    `intercompany_flag` BOOLEAN COMMENT 'True if the invoice is part of an intercompany transaction.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount payable after taxes and discounts.',
    `number` STRING COMMENT 'External invoice identifier assigned by the billing system.',
    `payment_amount` DECIMAL(18,2) COMMENT 'Amount actually received from the customer.',
    `payment_method` STRING COMMENT 'Method used by the customer to settle the invoice.. Valid values are `credit_card|bank_transfer|cash|check|online|other`',
    `payment_received_date` DATE COMMENT 'Date on which payment was recorded.',
    `payment_status` STRING COMMENT 'Current status of the payment transaction.. Valid values are `pending|cleared|failed|reversed|partial|unknown`',
    `payment_terms` STRING COMMENT 'Standard payment condition applied to the invoice.. Valid values are `net_30|net_45|net_60|cod|prepaid|milestone`',
    `plant_code` STRING COMMENT 'Manufacturing plant where the vehicle or part was produced.',
    `posting_date` DATE COMMENT 'Date the invoice was posted to the general ledger.',
    `profit_center_code` STRING COMMENT 'Profit center attributing revenue from the invoice.',
    `purchase_order_number` STRING COMMENT 'Purchase order from the customer or dealer, if applicable.',
    `region_code` STRING COMMENT 'Geographic region code for reporting and tax purposes.',
    `revenue_recognition_date` DATE COMMENT 'Date on which revenue from this invoice is recognized per accounting policy.',
    `sales_order_number` STRING COMMENT 'Sales order that triggered the invoice.',
    `sales_org_code` STRING COMMENT 'Code of the sales organization responsible for the transaction.',
    `ar_invoice_status` STRING COMMENT 'Current processing state of the invoice.. Valid values are `draft|open|posted|cancelled|paid|reversed`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax calculated for the invoice.',
    `tax_code` STRING COMMENT 'Tax jurisdiction code used for tax calculation.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate percentage for the invoice.',
    `ar_invoice_type` STRING COMMENT 'High‑level classification of the invoice content.. Valid values are `vehicle_sale|parts|service|lease|subscription|other`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the invoice record.',
    `warranty_reserve_amount` DECIMAL(18,2) COMMENT 'Monetary amount set aside for future warranty claims related to this invoice.',
    `warranty_reserve_flag` BOOLEAN COMMENT 'Indicates whether a warranty reserve has been booked for this invoice.',
    CONSTRAINT pk_ar_invoice PRIMARY KEY(`ar_invoice_id`)
) COMMENT 'Accounts Receivable (AR) customer invoice record capturing outgoing invoices issued to dealers, fleet customers, and intercompany entities for vehicle sales, parts, and services. Aligned with SAP FI-AR and SD billing integration. Captures customer/dealer ID, invoice date, due date, payment terms, gross amount, tax amount, net amount, currency, billing document reference, vehicle line, MSRP vs net selling price, and collection status. Supports dealer billing reconciliation and revenue recognition.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`ar_payment` (
    `ar_payment_id` BIGINT COMMENT 'System-generated unique identifier for the AR payment record.',
    `employee_id` BIGINT COMMENT 'Identifier of the user who performed the posting operation.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the user who performed the posting operation.',
    `party_id` BIGINT COMMENT 'Identifier of the party (dealer, fleet account, or intercompany entity) that made the payment.',
    `bank_account_number` STRING COMMENT 'Bank account number where the payment was received.',
    `bank_name` STRING COMMENT 'Name of the bank that received the payment.',
    `cash_application_status` STRING COMMENT 'Status of cash application against the invoice(s).. Valid values are `unapplied|applied|partially_applied`',
    `channel` STRING COMMENT 'Channel through which the payment was submitted.. Valid values are `in_person|online_portal|mobile_app|batch|auto`',
    `clearance_date` DATE COMMENT 'Date the payment cleared the bank and was posted to the ledger.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code of the payment.',
    `ar_payment_date` DATE COMMENT 'Date the payment was received or processed.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Discounts applied to the payment, if any.',
    `due_date` DATE COMMENT 'Date by which the payment was expected according to terms.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency conversion rate applied when payment currency differs from functional currency.',
    `exchange_rate_date` DATE COMMENT 'Date on which the exchange rate was sourced.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total amount received before any deductions.',
    `invoice_number` STRING COMMENT 'Invoice identifier that this payment clears or partially clears.',
    `is_partial_payment` BOOLEAN COMMENT 'Flag indicating whether the payment covers the full invoice amount.',
    `method` STRING COMMENT 'Instrument used to make the payment.. Valid values are `cash|check|wire|credit_card|online|eft`',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount applied to the invoice after tax and discounts.',
    `notes` STRING COMMENT 'Free‑form text for any additional information about the payment.',
    `number` STRING COMMENT 'Unique payment reference assigned by the finance system.',
    `original_amount` DECIMAL(18,2) COMMENT 'Payment amount in the original foreign currency before conversion.',
    `posting_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment was posted to the general ledger.',
    `remittance_reference` STRING COMMENT 'Reference provided by the payer to reconcile the payment.',
    `source` STRING COMMENT 'Origin of the payment within the organization.. Valid values are `dealer|fleet|intercompany|direct_customer`',
    `ar_payment_status` STRING COMMENT 'Current lifecycle status of the payment.. Valid values are `pending|posted|cleared|rejected|void`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component deducted from the gross amount, if applicable.',
    `terms_code` STRING COMMENT 'Standard payment terms associated with the invoice.. Valid values are `NET30|NET45|NET60`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the payment record.',
    CONSTRAINT pk_ar_payment PRIMARY KEY(`ar_payment_id`)
) COMMENT 'Accounts Receivable incoming payment record capturing payments received from dealers, fleet accounts, and intercompany entities against AR invoices. Captures payment date, customer/dealer ID, payment method, amount received, currency, cleared invoice references, bank account, remittance advice reference, partial payment indicator, and cash application status. Supports dealer receivables management, DSO (Days Sales Outstanding) tracking, and cash flow forecasting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`capex_request` (
    `capex_request_id` BIGINT COMMENT 'Unique surrogate key for the CapEx request record.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who approved the CapEx request.',
    `capex_requested_by_employee_id` BIGINT COMMENT 'Identifier of the employee who created the CapEx request.',
    `capex_updated_by_user_employee_id` BIGINT COMMENT 'System user identifier who last modified the record.',
    `org_unit_id` BIGINT COMMENT 'Code of the department submitting the request.',
    `plant_id` BIGINT COMMENT 'Code of the manufacturing plant where the investment will be implemented.',
    `primary_capex_employee_id` BIGINT COMMENT 'Identifier of the employee who created the CapEx request.',
    `primary_employee_id` BIGINT COMMENT 'System user identifier who created the record.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Capex requests must be tied to the specific regulatory requirement they satisfy for compliance tracking and audit.',
    `vendor_id` BIGINT COMMENT 'Identifier of the external supplier for the investment, if applicable.',
    `actual_end_date` DATE COMMENT 'Date when the project was actually completed.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Cumulative amount actually spent to date on the project.',
    `approval_date` TIMESTAMP COMMENT 'Timestamp when the request received final approval.',
    `approved_budget_amount` DECIMAL(18,2) COMMENT 'Budget amount approved by the governance board.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Estimated total cost of the proposed investment.',
    `cost_center_code` STRING COMMENT 'Internal cost center responsible for the expenditure.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for the budget.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `capex_request_date` TIMESTAMP COMMENT 'Timestamp when the request was initially submitted.',
    `depreciation_method` STRING COMMENT 'Accounting method used to depreciate the capital asset.. Valid values are `straight_line|double_declining|units_of_production|sum_of_years_digits`',
    `depreciation_years` STRING COMMENT 'Number of years over which the asset will be depreciated.',
    `capex_request_description` STRING COMMENT 'Detailed narrative of the proposed capital investment, including objectives and scope.',
    `external_funding_amount` DECIMAL(18,2) COMMENT 'Monetary value of external funding contributions.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the request belongs (e.g., FY2024).. Valid values are `FYd{4}`',
    `funding_source` STRING COMMENT 'Name of the external entity providing funding (e.g., government grant, joint venture).',
    `has_external_funding` BOOLEAN COMMENT 'Indicates whether part of the investment is funded by external sources.',
    `investment_category` STRING COMMENT 'Classification of the investment type.. Valid values are `tooling|machinery|it|facility|ev_r&d|autonomous_r&d`',
    `irr` DECIMAL(18,2) COMMENT 'Internal rate of return percentage for the proposed investment.',
    `is_capitalized` BOOLEAN COMMENT 'Indicates whether the expense is capitalized (true) or expensed (false).',
    `is_compliant` BOOLEAN COMMENT 'Indicates whether the request complies with all applicable regulations.',
    `justification` STRING COMMENT 'Business case narrative explaining the need and expected benefits.',
    `npv` DECIMAL(18,2) COMMENT 'Net present value of the investment calculated in the request currency.',
    `number` STRING COMMENT 'Human‑readable identifier assigned to the request (e.g., CR‑2024‑001).',
    `payback_period_years` DECIMAL(18,2) COMMENT 'Estimated number of years to recover the investment.',
    `priority` STRING COMMENT 'Business priority assigned to the request.. Valid values are `low|medium|high|critical`',
    `procurement_method` STRING COMMENT 'Method used to acquire the goods or services.. Valid values are `direct|tender|rfq|framework|sole_source`',
    `project_end_date` DATE COMMENT 'Planned completion date of the capital project.',
    `project_start_date` DATE COMMENT 'Planned start date of the capital project.',
    `regulatory_approval_status` STRING COMMENT 'Status of any required regulatory approvals for the investment.. Valid values are `pending|approved|rejected`',
    `risk_rating` STRING COMMENT 'Risk assessment rating for the proposed investment.. Valid values are `low|moderate|high|critical`',
    `capex_request_status` STRING COMMENT 'Current lifecycle state of the request.. Valid values are `draft|submitted|under_review|approved|rejected|closed`',
    `supporting_document_url` STRING COMMENT 'Link to attached supporting documentation stored in the document management system.',
    `tax_implication` STRING COMMENT 'Notes on tax treatment or incentives related to the investment.',
    `title` STRING COMMENT 'Brief title describing the investment proposal.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the record.',
    `wbs_element` STRING COMMENT 'Hierarchical code linking the request to the project’s WBS.',
    CONSTRAINT pk_capex_request PRIMARY KEY(`capex_request_id`)
) COMMENT 'Capital Expenditure (CapEx) appropriation request record capturing investment proposals for manufacturing equipment, tooling, plant infrastructure, EV battery production lines, and R&D facilities. Captures project title, requesting plant/department, investment category (tooling, machinery, IT, facility, EV/autonomous R&D), estimated total cost, approved budget, actual spend to date, project start/end dates, approval workflow status, NPV/IRR justification, and WBS element linkage. Supports CapEx governance and FY budget planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`budget_plan` (
    `budget_plan_id` BIGINT COMMENT 'Unique identifier for the budget plan record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Budget plans must be signed off by a responsible employee; approved_by_employee_id captures the approver.',
    `finance_project_id` BIGINT COMMENT 'Identifier of the project linked to this budget plan, if applicable.',
    `allocation_method` STRING COMMENT 'Method used to allocate the budget across cost objects.. Valid values are `percentage|fixed|formula`',
    `approval_date` DATE COMMENT 'Date when the budget plan received formal approval.',
    `budget_category` STRING COMMENT 'High‑level business area the budget pertains to.. Valid values are `R&D|Manufacturing|Sales|Administration|Marketing`',
    `budget_plan_code` STRING COMMENT 'External code used to reference the budget plan in financial systems.',
    `cost_center_code` STRING COMMENT 'Code of the cost center responsible for the budget.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the budget plan record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the budget amounts.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `effective_end_date` DATE COMMENT 'Date when the budget plan expires or is superseded (nullable).',
    `effective_start_date` DATE COMMENT 'Date when the budget plan becomes effective.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the budget applies.',
    `gl_account` STRING COMMENT 'GL account to which the budgeted amounts are posted.',
    `is_forecast` BOOLEAN COMMENT 'Indicates whether the plan is a forecast rather than a firm budget.',
    `is_locked` BOOLEAN COMMENT 'True if the budget plan is locked from further edits.',
    `budget_plan_name` STRING COMMENT 'Descriptive name of the budget plan.',
    `notes` STRING COMMENT 'Free‑form comments or remarks about the budget plan.',
    `planned_amount` DECIMAL(18,2) COMMENT 'Original budgeted monetary amount.',
    `planning_period` STRING COMMENT 'Period covered by the budget (e.g., FY2025, Q1).. Valid values are `FY|Q1|Q2|Q3|Q4`',
    `profit_center_code` STRING COMMENT 'Code of the profit center linked to the budget.',
    `revised_amount` DECIMAL(18,2) COMMENT 'Updated budget amount after revisions.',
    `scenario` STRING COMMENT 'Analytical scenario applied to the budget (e.g., base, optimistic, pessimistic).. Valid values are `base|optimistic|pessimistic`',
    `budget_plan_status` STRING COMMENT 'Current lifecycle state of the budget plan.. Valid values are `draft|submitted|approved|rejected|closed`',
    `budget_plan_type` STRING COMMENT 'Category of the budget plan indicating its purpose.. Valid values are `operating|capital|headcount|forecast|revised`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the budget plan.',
    `version_number` STRING COMMENT 'Sequential version of the budget plan for change tracking.',
    CONSTRAINT pk_budget_plan PRIMARY KEY(`budget_plan_id`)
) COMMENT 'Annual and multi-year financial budget plan record capturing planned financial targets by cost center, profit center, GL account, and fiscal year. Supports FY budget planning, rolling forecast cycles, and variance analysis. Captures budget version (original, revised, forecast), budget type (opex, capex, headcount), planning period, planned amount, currency, approval status, and responsible controller. Aligned with SAP CO planning and SAP BPC (Business Planning and Consolidation) processes.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`budget_line` (
    `budget_line_id` BIGINT COMMENT 'Unique system-generated identifier for the budget line record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Reference cost_center master from budget line.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Replace GL account code with FK to gl_account for budget line consolidation.',
    `budget_plan_id` BIGINT COMMENT 'Identifier of the parent budget plan header to which this line belongs.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Reference profit_center master from budget line.',
    `allocation_method` STRING COMMENT 'Method used to allocate the budget amount across cost objects.. Valid values are `percentage|fixed|activity_based`',
    `amount_type` STRING COMMENT 'Indicates whether the amount reflects the original plan, a revision, or a committed figure.. Valid values are `planned|revised|committed`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date‑time when the budget line was approved by the finance authority.',
    `business_unit` STRING COMMENT 'Organizational unit (e.g., North America, Europe) responsible for the budget line.',
    `comments` STRING COMMENT 'Additional free‑form notes captured by the planner.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the budget line record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code (e.g., USD, EUR) for the monetary values.. Valid values are `^[A-Z]{3}$`',
    `budget_line_description` STRING COMMENT 'Free‑form text describing the purpose or nature of the budget line.',
    `effective_end_date` DATE COMMENT 'Calendar date when the budget line expires; null if open‑ended.',
    `effective_start_date` DATE COMMENT 'Calendar date when the budget line becomes effective.',
    `fiscal_period` STRING COMMENT 'Period within the fiscal year (e.g., month number or quarter) applicable to the budget line.',
    `fiscal_year` STRING COMMENT 'Four‑digit fiscal year (e.g., 2024) for which the budget line is planned.',
    `is_manual` BOOLEAN COMMENT 'True if the budget line was entered manually rather than generated by a planning run.',
    `justification` STRING COMMENT 'Narrative explanation for the budget amount, required for audit and approval.',
    `planned_amount` DECIMAL(18,2) COMMENT 'Original amount budgeted for this line, expressed in the specified currency.',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant associated with the budget line.',
    `product_line` STRING COMMENT 'Vehicle or product line (e.g., SUV, Truck) to which the budget amount applies.',
    `quantity` DECIMAL(18,2) COMMENT 'Number of units, hours, or other measure being budgeted.',
    `revised_amount` DECIMAL(18,2) COMMENT 'Updated amount after revisions; may differ from the original planned amount.',
    `sequence` STRING COMMENT 'Sequential order of the line within the budget header.',
    `budget_line_status` STRING COMMENT 'Current lifecycle status of the budget line.. Valid values are `active|inactive|closed|pending`',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the line_quantity (e.g., units, hours, liters).',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the budget line record.',
    `version_number` STRING COMMENT 'Incremental version for change‑tracking and concurrency control.',
    CONSTRAINT pk_budget_line PRIMARY KEY(`budget_line_id`)
) COMMENT 'Individual line item within a budget plan capturing the planned financial amount for a specific GL account, cost center, profit center, and fiscal period combination. Enables granular budget-vs-actual variance analysis at the account and cost object level. Captures budget plan reference, GL account, cost center, profit center, fiscal year, fiscal period, planned amount, revised amount, currency, and line item description. Supports monthly budget monitoring and FY close reconciliation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` (
    `manufacturing_cost_id` BIGINT COMMENT 'Surrogate primary key uniquely identifying each manufacturing cost record.',
    `cost_center_id` BIGINT COMMENT 'Identifier of the cost center responsible for the production order.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where the cost was incurred.',
    `production_order_id` BIGINT COMMENT 'SAP production order number linked to this cost record.',
    `actual_energy_cost` DECIMAL(18,2) COMMENT 'Energy cost actually incurred.',
    `actual_fixed_overhead_cost` DECIMAL(18,2) COMMENT 'Fixed overhead actually incurred.',
    `actual_labor_cost` DECIMAL(18,2) COMMENT 'Direct labor cost actually incurred.',
    `actual_material_cost` DECIMAL(18,2) COMMENT 'Real material cost incurred during production.',
    `actual_scrap_cost` DECIMAL(18,2) COMMENT 'Actual cost of scrap and rework.',
    `actual_tooling_amortization_cost` DECIMAL(18,2) COMMENT 'Actual tooling amortization recorded.',
    `actual_variable_overhead_cost` DECIMAL(18,2) COMMENT 'Variable overhead actually incurred.',
    `calculation_timestamp` TIMESTAMP COMMENT 'Date and time when the cost calculation was performed.',
    `costing_date` DATE COMMENT 'Date on which the costing run was executed.',
    `costing_version` STRING COMMENT 'Version identifier for the costing run (e.g., V1, V2).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the cost record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code used for cost amounts.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `is_variance_exceed_threshold` BOOLEAN COMMENT 'Indicates whether the cost variance exceeds a predefined tolerance.',
    `record_number` STRING COMMENT 'Business identifier assigned to the cost record, typically generated by SAP CO-PC.',
    `standard_energy_cost` DECIMAL(18,2) COMMENT 'Planned energy (electricity, gas) cost for production.',
    `standard_fixed_overhead_cost` DECIMAL(18,2) COMMENT 'Planned fixed overhead (e.g., depreciation, rent).',
    `standard_labor_cost` DECIMAL(18,2) COMMENT 'Planned direct labor cost based on standard rates.',
    `standard_material_cost` DECIMAL(18,2) COMMENT 'Planned material cost per SAP standard costing.',
    `standard_scrap_cost` DECIMAL(18,2) COMMENT 'Planned cost associated with scrap and rework.',
    `standard_tooling_amortization_cost` DECIMAL(18,2) COMMENT 'Planned amortization of tooling and fixtures.',
    `standard_variable_overhead_cost` DECIMAL(18,2) COMMENT 'Planned variable overhead (e.g., utilities, consumables).',
    `manufacturing_cost_status` STRING COMMENT 'Current lifecycle status of the cost record.. Valid values are `draft|posted|approved|rejected`',
    `total_actual_cost` DECIMAL(18,2) COMMENT 'Sum of all actual cost components.',
    `total_standard_cost` DECIMAL(18,2) COMMENT 'Sum of all standard cost components.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the cost record.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between actual and standard total cost (actual - standard).',
    `variance_percent` DECIMAL(18,2) COMMENT 'Cost variance expressed as a percentage of standard cost.',
    `variance_threshold_amount` DECIMAL(18,2) COMMENT 'Monetary threshold used to evaluate cost variance significance.',
    `vehicle_line` STRING COMMENT 'Product line (e.g., SUV, Sedan, Truck) of the vehicle.',
    `vehicle_model_code` STRING COMMENT 'Internal code representing the vehicle model.',
    `vehicle_model_year` STRING COMMENT 'Model year of the vehicle for which the cost is recorded.',
    CONSTRAINT pk_manufacturing_cost PRIMARY KEY(`manufacturing_cost_id`)
) COMMENT 'Standard and actual manufacturing cost record capturing the cost breakdown for vehicle production by plant, production order, vehicle line, and model year (MY). Captures material cost, direct labor cost, variable overhead, fixed overhead, tooling amortization, energy cost, scrap cost, and total standard cost vs actual cost variance. Aligned with SAP CO-PC (Product Cost Controlling) and production order settlement. Supports vehicle profitability analysis, EBITDA reporting, and cost reduction program tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` (
    `warranty_reserve_id` BIGINT COMMENT 'System-generated unique identifier for the warranty reserve record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Link warranty reserve to cost_center master for cost tracking.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Link warranty reserve to profit_center master for profitability analysis.',
    `vin_registry_id` BIGINT COMMENT 'Identifier of the vehicle (or vehicle model) to which the reserve is linked.',
    `accounting_period` STRING COMMENT 'Financial reporting period (quarter or full year) for the reserve.. Valid values are `Q1|Q2|Q3|Q4|FY`',
    `accrual_basis` STRING COMMENT 'Method used to calculate the reserve (e.g., based on units sold, a fixed percentage, or a fixed amount).. Valid values are `units_sold|percentage|fixed`',
    `actuarial_review_date` DATE COMMENT 'Date of the most recent actuarial assessment of reserve adequacy.',
    `adequacy_ratio` DECIMAL(18,2) COMMENT 'Ratio of reserve balance to estimated total warranty liability, expressed as a percentage.',
    `amount` DECIMAL(18,2) COMMENT 'Total accrued liability amount for the warranty reserve before any claims are charged.',
    `audit_trail_notes` STRING COMMENT 'Free‑text notes capturing audit comments or justification for reserve adjustments.',
    `balance` DECIMAL(18,2) COMMENT 'Remaining liability balance after claims have been deducted from the reserve.',
    `claims_charged` DECIMAL(18,2) COMMENT 'Cumulative amount of warranty claims that have been charged against the reserve.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the reserve record was initially created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the reserve amounts.. Valid values are `^[A-Z]{3}$`',
    `warranty_reserve_description` STRING COMMENT 'Narrative description of the reserve purpose, scope, or special conditions.',
    `effective_from` DATE COMMENT 'Date when the warranty reserve becomes effective.',
    `effective_until` DATE COMMENT 'Date when the warranty reserve is expected to be closed or expire (nullable).',
    `estimated_cost_per_unit` DECIMAL(18,2) COMMENT 'Estimated warranty cost per vehicle unit used in the accrual calculation.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the reserve amount is allocated.',
    `is_ifrs_compliant` BOOLEAN COMMENT 'True if the reserve calculation follows IFRS warranty liability standards.',
    `is_sox_controlled` BOOLEAN COMMENT 'Indicates whether the reserve is subject to Sarbanes‑Oxley internal control requirements.',
    `last_actuarial_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent actuarial model update affecting the reserve.',
    `market_region` STRING COMMENT 'Three‑letter ISO country code representing the market region of the reserve.. Valid values are `^[A-Z]{3}$`',
    `model_year` STRING COMMENT 'Model year of the vehicle for which the warranty reserve is calculated.',
    `number` STRING COMMENT 'External reference number assigned to the warranty reserve for tracking and reporting.',
    `regulatory_reporting_flag` BOOLEAN COMMENT 'Indicates whether the reserve must be disclosed in regulatory filings (e.g., SEC, IFRS).',
    `source` STRING COMMENT 'Origin of the reserve entry (initial accrual, subsequent adjustment, or reversal).. Valid values are `accrual|adjustment|reversal`',
    `warranty_reserve_status` STRING COMMENT 'Current lifecycle status of the reserve (e.g., active, closed, adjusted, pending review).. Valid values are `active|closed|adjusted|pending_review`',
    `units_sold` BIGINT COMMENT 'Number of vehicles sold in the relevant period that drive the accrual calculation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the reserve record.',
    `vehicle_line` STRING COMMENT 'Name of the vehicle model line to which the reserve applies.',
    `warranty_claims_amount` DECIMAL(18,2) COMMENT 'Total monetary amount of warranty claims charged to the reserve (duplicate of claims_charged for reporting granularity).',
    `warranty_claims_count` BIGINT COMMENT 'Number of warranty claims that have been processed against this reserve.',
    `warranty_type` STRING COMMENT 'Category of warranty coverage (e.g., basic, powertrain, EV battery, extended).. Valid values are `basic|powertrain|ev_battery|extended`',
    CONSTRAINT pk_warranty_reserve PRIMARY KEY(`warranty_reserve_id`)
) COMMENT 'Warranty financial reserve record capturing accrued warranty liability provisions by vehicle line, model year (MY), market region, and warranty type (basic, powertrain, EV battery). Captures reserve amount, currency, accrual basis (units sold × estimated cost per unit), actual warranty claims charged against reserve, reserve balance, reserve adequacy ratio, and actuarial review date. Supports IFRS/GAAP warranty liability disclosure, SOX controls, and after-sales financial planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` (
    `finance_inventory_valuation_id` BIGINT COMMENT 'Unique identifier for the finance_inventory_valuation data product (auto-inserted pre-linking).',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Reference cost_center master from inventory valuation for accurate valuation reporting.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Add FK to gl_account for inventory valuation accounting linkage.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Reference profit_center master from inventory valuation.',
    `asset_valuation_id` BIGINT COMMENT 'SSOT reference to asset.asset_valuation (resolves cross-domain duplicate of valuation).',
    CONSTRAINT pk_finance_inventory_valuation PRIMARY KEY(`finance_inventory_valuation_id`)
) COMMENT 'Inventory valuation record capturing the financial value of raw materials, WIP (Work in Progress), finished vehicles, and service parts inventory at plant and storage location level. Aligned with SAP MM-IM material valuation and FI-MM integration. Captures material number, plant, storage location, valuation class, valuation method (standard cost, moving average), quantity on hand, unit cost, total inventory value, currency, and period-end valuation date. Supports balance sheet inventory disclosure and IFRS/GAAP compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` (
    `fixed_asset_id` BIGINT COMMENT 'Unique system-generated identifier for the fixed asset record.',
    `employee_id` BIGINT COMMENT 'Identifier of the party that legally owns the asset.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the party that legally owns the asset.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where the asset is located.',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'Total depreciation expense recorded to date for the asset.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'Original cost incurred to acquire the asset, recorded in the functional currency.',
    `acquisition_date` DATE COMMENT 'Date the asset was acquired or placed into service.',
    `capitalized_flag` BOOLEAN COMMENT 'Indicates whether the cost has been capitalized (true) or expensed (false).',
    `class` STRING COMMENT 'Classification of the asset according to the companys asset class hierarchy (e.g., machinery, building, IT equipment).',
    `condition` STRING COMMENT 'Current physical condition of the asset.. Valid values are `new|good|fair|poor|scrapped`',
    `condition_rating` STRING COMMENT 'Numeric rating (1‑5) of the asset’s condition, where 5 is best.',
    `cost_center_code` STRING COMMENT 'Cost center to which the asset’s expenses are charged.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the asset record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for the acquisition cost.. Valid values are `^[A-Z]{3}$`',
    `depreciation_method` STRING COMMENT 'Method used to calculate depreciation (e.g., straight‑line, declining balance, units of production).. Valid values are `straight_line|declining_balance|units_of_production`',
    `depreciation_rate_percent` DECIMAL(18,2) COMMENT 'Annual depreciation rate expressed as a percentage.',
    `depreciation_start_date` DATE COMMENT 'Date when depreciation calculations begin for the asset.',
    `fixed_asset_description` STRING COMMENT 'Detailed description of the asset, including purpose and key characteristics.',
    `disposal_method` STRING COMMENT 'Method used to dispose of the asset (e.g., sale, scrap, donation).',
    `insurance_coverage_amount` DECIMAL(18,2) COMMENT 'Maximum monetary amount covered by the insurance policy.',
    `insurance_expiry_date` DATE COMMENT 'Date when the insurance coverage expires.',
    `insurance_policy_number` STRING COMMENT 'Policy number of the insurance covering the asset.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent inspection or audit of the asset.',
    `location_code` STRING COMMENT 'Code representing the specific physical location (e.g., warehouse, line, bay) of the asset.',
    `maintenance_schedule` STRING COMMENT 'Reference to the maintenance plan applicable to the asset.',
    `manufacturer` STRING COMMENT 'Name of the company that manufactured the asset.',
    `model` STRING COMMENT 'Model designation or number assigned by the manufacturer.',
    `fixed_asset_name` STRING COMMENT 'Human‑readable name or title of the asset.',
    `net_book_value` DECIMAL(18,2) COMMENT 'Current carrying amount of the asset (acquisition cost minus accumulated depreciation).',
    `next_inspection_date` DATE COMMENT 'Planned date for the next scheduled inspection.',
    `responsible_department` STRING COMMENT 'Department accountable for the asset’s operation and maintenance.',
    `retirement_date` DATE COMMENT 'Date the asset was officially retired from service.',
    `serial_number` STRING COMMENT 'Manufacturer‑assigned serial number uniquely identifying the physical unit.',
    `fixed_asset_status` STRING COMMENT 'Current operational status of the asset.. Valid values are `in_service|retired|under_maintenance|disposed|pending`',
    `tag` STRING COMMENT 'Internal asset tag or number used for tracking the asset within the organization.',
    `tax_depreciation_amount` DECIMAL(18,2) COMMENT 'Depreciation amount recognized for tax reporting purposes.',
    `fixed_asset_type` STRING COMMENT 'Specific type of asset within its class (e.g., stamping press, paint shop robot, battery assembly line).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the asset record.',
    `useful_life_years` STRING COMMENT 'Estimated economic life of the asset expressed in years for depreciation purposes.',
    `vin` STRING COMMENT 'Unique 17‑character identifier for vehicle assets, conforming to ISO 3779.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `warranty_end_date` DATE COMMENT 'Date when the asset warranty period expires.',
    `warranty_provider` STRING COMMENT 'Name of the party providing the warranty for the asset.',
    `warranty_start_date` DATE COMMENT 'Date when the asset warranty period begins.',
    CONSTRAINT pk_fixed_asset PRIMARY KEY(`fixed_asset_id`)
) COMMENT 'Fixed asset master record for all capitalized assets including manufacturing machinery, production tooling, dies, stamping presses, paint shop equipment, EV battery assembly lines, plant buildings, and IT infrastructure. Aligned with SAP FI-AA (Asset Accounting). Captures asset class, asset description, acquisition date, acquisition cost, useful life, depreciation method (straight-line, declining balance), accumulated depreciation, net book value, plant assignment, cost center, and retirement date. Supports CapEx tracking and IFRS/GAAP asset disclosure.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` (
    `depreciation_run_id` BIGINT COMMENT 'System-generated unique identifier for the depreciation run.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Depreciation runs are executed by a finance employee; creator employee ID required for control.',
    `gl_account_id` BIGINT COMMENT 'Identifier of the GL account to which depreciation is posted.',
    `company_code` STRING COMMENT 'Code of the legal entity/company for which the depreciation run is performed.',
    `cost_center_code` STRING COMMENT 'Cost center associated with the depreciation posting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the depreciation run record was first created in the data lake.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code of the posted depreciation amounts.. Valid values are `^[A-Z]{3}$`',
    `depreciation_area` STRING COMMENT 'Depreciation area indicating the accounting book (e.g., book, tax, IFRS, statutory).. Valid values are `book|tax|ifrs|statutory`',
    `depreciation_end_date` DATE COMMENT 'Latest asset acquisition date considered in the run.',
    `depreciation_method` STRING COMMENT 'Accounting method used for calculating depreciation in this run.. Valid values are `straight_line|declining_balance|sum_of_years|units_of_production`',
    `depreciation_start_date` DATE COMMENT 'Earliest asset acquisition date considered in the run.',
    `fiscal_period` STRING COMMENT 'Fiscal period (e.g., month or quarter) of the depreciation run.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the depreciation run belongs.',
    `is_test_run` BOOLEAN COMMENT 'Flag indicating whether the run was a test (true) or production (false).',
    `number` STRING COMMENT 'Business identifier assigned to the depreciation run (e.g., AFAB2023Q1).',
    `number_of_assets_processed` STRING COMMENT 'Count of fixed assets included in the depreciation run.',
    `posting_document_number` STRING COMMENT 'General Ledger document number generated by the depreciation posting.',
    `profit_center_code` STRING COMMENT 'Profit center linked to the depreciation run for profitability analysis.',
    `remarks` STRING COMMENT 'Optional free‑text comments or notes about the depreciation run.',
    `depreciation_run_status` STRING COMMENT 'Current lifecycle status of the depreciation run.. Valid values are `planned|in_progress|completed|failed|cancelled`',
    `status_detail` STRING COMMENT 'Free‑text field providing additional information about the run status (e.g., error messages).',
    `timestamp` TIMESTAMP COMMENT 'Date and time when the depreciation run was executed.',
    `total_depreciation_amount` DECIMAL(18,2) COMMENT 'Aggregate depreciation amount posted by the run.',
    `depreciation_run_type` STRING COMMENT 'Classification of the run (periodic, year‑end, or ad‑hoc).. Valid values are `periodic|year_end|ad_hoc`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the depreciation run record.',
    CONSTRAINT pk_depreciation_run PRIMARY KEY(`depreciation_run_id`)
) COMMENT 'Periodic depreciation run transaction record capturing the execution of planned depreciation for fixed assets within a fiscal period. Aligned with SAP FI-AA depreciation posting run (AFAB). Captures run date, fiscal year, fiscal period, company code, depreciation area (book, tax, IFRS), total depreciation posted, number of assets processed, run status, and GL posting document reference. Supports period-end close, asset accounting reconciliation, and EBITDA calculation (depreciation add-back).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` (
    `intercompany_settlement_id` BIGINT COMMENT 'System-generated unique identifier for the intercompany settlement record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Intercompany settlement approval is performed by a finance employee; link records that approver.',
    `cost_center_id` BIGINT COMMENT 'Cost center associated with the settlement for internal reporting.',
    `gl_account_id` BIGINT COMMENT 'GL account used for posting the settlement.',
    `intercompany_group_id` BIGINT COMMENT 'Identifier of the intercompany group for consolidation purposes.',
    `intercompany_loan_id` BIGINT COMMENT 'Identifier of an intercompany loan related to this settlement, if applicable.',
    `profit_center_id` BIGINT COMMENT 'Profit center linked to the settlement for profitability analysis.',
    `amount_gross` DECIMAL(18,2) COMMENT 'Total amount before taxes, fees, or adjustments.',
    `amount_net` DECIMAL(18,2) COMMENT 'Net amount after taxes and adjustments.',
    `amount_tax` DECIMAL(18,2) COMMENT 'Tax component associated with the settlement.',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the settlement was approved.',
    `clearing_document_number` STRING COMMENT 'Reference number of the clearing document generated for the settlement.',
    `comments` STRING COMMENT 'Additional comments or remarks entered by users.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the settlement record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the settlement amount.',
    `intercompany_settlement_description` STRING COMMENT 'Free‑text description or notes about the settlement.',
    `effective_from` DATE COMMENT 'Date from which the settlement terms become effective.',
    `effective_until` DATE COMMENT 'Date until which the settlement terms remain effective (nullable for open‑ended).',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency exchange rate applied when converting to the reporting currency.',
    `fiscal_period` STRING COMMENT 'Fiscal period (e.g., month or quarter) of the settlement.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the settlement belongs.',
    `is_approved` BOOLEAN COMMENT 'Indicates whether the settlement has been approved.',
    `netting_indicator` BOOLEAN COMMENT 'True if the settlement amount is netted against other intercompany balances.',
    `number` STRING COMMENT 'Business-visible settlement number assigned by the finance system.',
    `posting_date` DATE COMMENT 'Date the settlement was posted to the general ledger.',
    `receiving_company_code` STRING COMMENT 'Organizational code of the legal entity receiving the settlement amount.',
    `reconciliation_status` STRING COMMENT 'Status of the settlement reconciliation process.. Valid values are `pending|matched|unmatched|exception`',
    `sending_company_code` STRING COMMENT 'Organizational code of the legal entity sending the settlement amount.',
    `source_document_number` STRING COMMENT 'Reference number of the source document (e.g., invoice) that generated the settlement.',
    `intercompany_settlement_status` STRING COMMENT 'Current lifecycle status of the settlement (e.g., draft, posted, cleared).. Valid values are `draft|open|posted|cleared|cancelled`',
    `target_document_number` STRING COMMENT 'Reference number of the target document (e.g., receiving invoice) linked to the settlement.',
    `tax_code` STRING COMMENT 'Tax code used to determine tax treatment for the settlement.',
    `transaction_date` DATE COMMENT 'Date on which the intercompany transaction was recorded.',
    `transfer_price_basis` STRING COMMENT 'Methodology used to calculate the transfer price (cost, market, list, or custom).. Valid values are `cost|market|list|custom`',
    `intercompany_settlement_type` STRING COMMENT 'Classification of the settlement (e.g., transfer pricing, service charge, royalty).. Valid values are `transfer_pricing|service_charge|royalty|management_fee|intercompany_loan|other`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the settlement record.',
    CONSTRAINT pk_intercompany_settlement PRIMARY KEY(`intercompany_settlement_id`)
) COMMENT 'Intercompany settlement transaction record capturing financial transactions between legal entities within the Automotive group, including transfer pricing for CKD/SKD kits, shared service charges, royalty payments, management fee allocations, and intercompany loans. Captures sending company code, receiving company code, settlement type, settlement amount, currency, transfer price basis, netting indicator, clearing document reference, and reconciliation status. Supports intercompany elimination in group consolidation and IFRS/GAAP compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` (
    `cost_allocation_id` BIGINT COMMENT 'Unique surrogate key for each cost allocation transaction record.',
    `allocation_cycle_id` BIGINT COMMENT 'Identifier for the periodic allocation cycle (e.g., KSV5/KSU5 run ID).',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Cost allocation entries need creator employee for audit trail and compliance.',
    `activity_quantity` DECIMAL(18,2) COMMENT 'Quantity of the activity (e.g., machine hours, labor hours) used for activity‑based allocation.',
    `allocated_amount` DECIMAL(18,2) COMMENT 'Monetary amount that is allocated from sender to receiver.',
    `cost_element_code` STRING COMMENT 'Code identifying the type of cost (e.g., material, labor, overhead).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the allocation record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code of the allocated amount.. Valid values are `^[A-Z]{3}$`',
    `cost_allocation_date` DATE COMMENT 'Date on which the allocation was calculated.',
    `cost_allocation_description` STRING COMMENT 'Free‑form text describing the purpose or notes for the allocation.',
    `effective_from` DATE COMMENT 'Start date when the allocation becomes effective (used for future‑dated allocations).',
    `effective_until` DATE COMMENT 'End date when the allocation ceases to be effective; null for open‑ended allocations.',
    `fiscal_period` STRING COMMENT 'Period code within the fiscal year (e.g., Q1, Q2, M03).',
    `fiscal_year` STRING COMMENT 'Four‑digit fiscal year to which the allocation belongs.',
    `is_intercompany` BOOLEAN COMMENT 'True if the allocation crosses legal entity boundaries.',
    `method` STRING COMMENT 'Method used to calculate the allocation (fixed % , activity‑based, or statistical key figure).. Valid values are `fixed_percentage|activity_based|statistical_key_figure`',
    `percentage` DECIMAL(18,2) COMMENT 'Percentage applied when the allocation method is fixed_percentage.',
    `posting_date` DATE COMMENT 'Date the allocation was posted to the general ledger.',
    `profit_center_code` STRING COMMENT 'Profit center associated with the receiving cost center, if applicable.',
    `receiver_cost_center_code` STRING COMMENT 'Cost center that receives the allocated overhead cost.',
    `sender_cost_center_code` STRING COMMENT 'Cost center that provides the overhead cost to be allocated.',
    `statistical_key_value` DECIMAL(18,2) COMMENT 'Value of the statistical key figure (e.g., production volume) used for allocation.',
    `cost_allocation_status` STRING COMMENT 'Current lifecycle status of the allocation record.. Valid values are `pending|posted|reversed|cancelled`',
    `updated_by` STRING COMMENT 'User identifier of the person who last modified the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the allocation record.',
    CONSTRAINT pk_cost_allocation PRIMARY KEY(`cost_allocation_id`)
) COMMENT 'Cost allocation and assessment cycle transaction record capturing the periodic redistribution of overhead costs from service cost centers (maintenance, utilities, HR, IT) to production cost centers and profit centers. Aligned with SAP CO assessment and distribution cycles (KSV5/KSU5). Captures allocation cycle ID, fiscal period, sender cost center, receiver cost center/profit center, allocation method (fixed percentage, activity-based, statistical key figure), allocated amount, and currency. Supports accurate vehicle manufacturing cost calculation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`tax_posting` (
    `tax_posting_id` BIGINT COMMENT 'System-generated unique identifier for each tax posting record.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Replace string GL account reference with FK to gl_account for tax posting.',
    `journal_entry_id` BIGINT COMMENT 'Identifier of the parent financial transaction (invoice, credit memo, etc.) to which this tax posting belongs.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the tax posting record was initially created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the transaction (e.g., USD, EUR).. Valid values are `^[A-Z]{3}$`',
    `tax_posting_date` DATE COMMENT 'Date on which the tax posting was recorded in the ledger.',
    `tax_posting_description` STRING COMMENT 'Free‑form text describing the tax posting (e.g., reason, notes).',
    `fiscal_period` STRING COMMENT 'Period number within the fiscal year (e.g., 1‑12).',
    `fiscal_year` STRING COMMENT 'Four‑digit fiscal year to which the posting belongs.',
    `line_sequence` STRING COMMENT 'Sequential order of the tax posting line within the parent transaction.',
    `source_document_number` STRING COMMENT 'Identifier of the originating document (invoice, credit memo, etc.) that generated this tax posting.',
    `source_document_type` STRING COMMENT 'Type of the originating document.. Valid values are `invoice|credit_note|payment|adjustment`',
    `tax_posting_status` STRING COMMENT 'Current processing state of the tax posting.. Valid values are `posted|reversed|pending|cancelled`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Calculated tax amount for the posting.',
    `tax_base_amount` DECIMAL(18,2) COMMENT 'Monetary amount on which the tax is calculated.',
    `tax_code` STRING COMMENT 'Code representing the specific tax rule applied (e.g., VAT001, EXC002).',
    `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether the transaction is tax‑exempt (true) or taxable (false).',
    `tax_jurisdiction` STRING COMMENT 'Geographic or regulatory jurisdiction governing the tax (e.g., state, country, EU).',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate expressed as a percentage (e.g., 19.00).',
    `tax_rate_type` STRING COMMENT 'Classification of the tax rate applied (standard, reduced, zero, or special).. Valid values are `standard|reduced|zero|special`',
    `tax_reporting_period` STRING COMMENT 'Period identifier used for tax authority reporting (e.g., Q1‑2024).',
    `tax_return_reference` STRING COMMENT 'Reference number of the tax return or filing to which this posting contributes.',
    `tax_type` STRING COMMENT 'Classification of the tax (input VAT, output VAT, withholding tax, excise duty).. Valid values are `input_vat|output_vat|withholding|excise`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the tax posting record.',
    CONSTRAINT pk_tax_posting PRIMARY KEY(`tax_posting_id`)
) COMMENT 'Tax posting record capturing VAT, sales tax, withholding tax, and excise duty transactions associated with vendor invoices, customer invoices, and intercompany transactions. Captures tax code, tax type (input/output VAT, withholding, excise), tax base amount, tax amount, currency, tax jurisdiction, reporting period, tax return reference, and GL account. Supports indirect tax compliance, tax return preparation, and regulatory reporting to EPA/DOT/CARB for excise-related levies.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`accrual` (
    `accrual_id` BIGINT COMMENT 'Unique system-generated identifier for the accrual record.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer linked to the accrual (e.g., dealer incentive).',
    `accrual_related_dealership_id` BIGINT COMMENT 'Identifier of the dealer linked to the accrual (e.g., dealer incentive).',
    `cost_center_id` BIGINT COMMENT 'Identifier of the cost center bearing the accrual expense.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Accrual creation must be linked to the responsible employee for audit and SOX compliance.',
    `gl_account_id` BIGINT COMMENT 'Identifier of the GL account to which the accrual amount is posted.',
    `profit_center_id` BIGINT COMMENT 'Identifier of the profit center associated with the accrual.',
    `finance_project_id` BIGINT COMMENT 'Identifier of the project (e.g., R&D, tooling) linked to the accrual.',
    `vin_registry_id` BIGINT COMMENT 'Identifier of the vehicle (VIN) associated with the accrual, if any.',
    `amount` DECIMAL(18,2) COMMENT 'Monetary amount of the accrual in the transaction currency.',
    `audit_user` STRING COMMENT 'User identifier of the person who performed the last audit on the accrual.',
    `basis` STRING COMMENT 'Methodology used to calculate the accrual amount.. Valid values are `estimated|actual|forecast|adjustment`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the accrual record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the accrual amount.. Valid values are `^[A-Z]{3}$`',
    `accrual_date` DATE COMMENT 'Date the accrual is recognized for accounting purposes.',
    `accrual_description` STRING COMMENT 'Free‑text description providing context for the accrual.',
    `fiscal_period` STRING COMMENT 'Period identifier (e.g., Q1, M03) within the fiscal year.',
    `fiscal_year` STRING COMMENT 'Four‑digit fiscal year to which the accrual belongs.',
    `is_manual` BOOLEAN COMMENT 'Flag indicating whether the accrual was entered manually (true) or generated automatically (false).',
    `is_tax_relevant` BOOLEAN COMMENT 'Indicates if the accrual amount is subject to tax.',
    `notes` STRING COMMENT 'Free‑form notes or comments about the accrual.',
    `number` STRING COMMENT 'External business number or code assigned to the accrual.',
    `period_end_date` DATE COMMENT 'End date of the fiscal period for which the accrual is recorded.',
    `posting_date` DATE COMMENT 'Date the accrual is posted to the ledger.',
    `reversal_date` DATE COMMENT 'Date on which the accrual is reversed, if applicable.',
    `accrual_status` STRING COMMENT 'Current lifecycle status of the accrual.. Valid values are `pending|posted|reversed|cancelled`',
    `supporting_document_ref` STRING COMMENT 'Reference number of the supporting document (e.g., invoice, contract).',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component of the accrual, if applicable.',
    `tax_code` STRING COMMENT 'Tax code used to determine tax rate for the accrual.',
    `accrual_type` STRING COMMENT 'Category of the accrual representing the underlying financial obligation.. Valid values are `warranty|rebate|bonus|tooling|dealer_incentive|other`',
    `updated_by` STRING COMMENT 'User identifier of the person who last updated the accrual record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the accrual record.',
    CONSTRAINT pk_accrual PRIMARY KEY(`accrual_id`)
) COMMENT 'Period-end accrual and prepayment record capturing estimated financial obligations and deferred costs that must be recognized in the correct fiscal period per IFRS/GAAP matching principle. Includes warranty accruals, rebate accruals, bonus provisions, tooling amortization accruals, and dealer incentive accruals. Captures accrual type, accrual amount, currency, accrual basis, GL account, cost center, fiscal period, reversal date, and supporting documentation reference. Critical for accurate FY close and SOX compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`currency_rate` (
    `currency_rate_id` BIGINT COMMENT 'System-generated unique identifier for each currency rate record.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Currency rates are maintained per legal entity; linking to company_code provides context and eliminates the isolated lookup table.',
    `company_code` STRING COMMENT 'Organizational code of the legal entity to which the rate applies.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the currency rate record was first created in the system.',
    `currency_from` STRING COMMENT 'Three‑letter ISO 4217 code of the currency being converted from.. Valid values are `^[A-Z]{3}$`',
    `currency_to` STRING COMMENT 'Three‑letter ISO 4217 code of the currency being converted to.. Valid values are `^[A-Z]{3}$`',
    `currency_rate_date` DATE COMMENT 'Calendar date to which the exchange rate applies (e.g., daily rate).',
    `currency_rate_description` STRING COMMENT 'Free‑form text providing additional context or notes about the rate (e.g., special market conditions).',
    `fiscal_year` STRING COMMENT 'Four‑digit fiscal year (e.g., 2024) associated with the rate record for reporting purposes.. Valid values are `^d{4}$`',
    `is_historical` BOOLEAN COMMENT 'Indicates whether the rate is a historical record (true) or a current/forecast rate (false).',
    `period` STRING COMMENT 'Two‑digit period identifier (e.g., month) within the fiscal year.. Valid values are `^d{2}$`',
    `source` STRING COMMENT 'Origin of the rate data, such as European Central Bank, Bloomberg, or internal treasury.. Valid values are `ECB|Bloomberg|Internal_Treasury`',
    `currency_rate_type` STRING COMMENT 'Classification of the rate: spot, average, period‑end, or planning.. Valid values are `spot|average|period_end|planning`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the currency rate record.',
    `value` DECIMAL(18,2) COMMENT 'Numeric exchange rate value expressed as the amount of target currency per one unit of source currency.',
    `valid_from` DATE COMMENT 'Start date of the period during which the rate is valid.',
    `valid_to` DATE COMMENT 'End date of the period during which the rate is valid; null if open‑ended.',
    CONSTRAINT pk_currency_rate PRIMARY KEY(`currency_rate_id`)
) COMMENT 'Foreign exchange (FX) currency rate reference record capturing daily, monthly average, and period-end exchange rates used for multi-currency financial reporting and transaction conversion. Captures currency pair (from/to), rate type (spot, average, period-end, planning), valid date, exchange rate, rate source (ECB, Bloomberg, internal treasury), and company code applicability. Supports IFRS translation of foreign subsidiary financials, transaction currency conversion, and FX exposure reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`wbs_element` (
    `wbs_element_id` BIGINT COMMENT 'System-generated unique identifier for the WBS element.',
    `cost_center_id` BIGINT COMMENT 'Identifier of the cost center entity linked to this WBS element.',
    `parent_wbs_wbs_element_id` BIGINT COMMENT 'Identifier of the immediate parent WBS element, establishing the hierarchy.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant associated with the WBS element.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or manager accountable for this WBS element.',
    `profit_center_id` BIGINT COMMENT 'FK to finance.profit_center',
    `finance_project_id` BIGINT COMMENT 'Reference to the overarching project definition to which this WBS element belongs.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: WBS elements representing project work need a FK to the regulatory requirement they address for compliance reporting.',
    `wbs_responsible_person_employee_id` BIGINT COMMENT 'Identifier of the employee or manager accountable for this WBS element.',
    `accounting_status` STRING COMMENT 'Accounting posting status of the WBS element.. Valid values are `open|posted|reversed`',
    `actual_cost` DECIMAL(18,2) COMMENT 'Incurred cost amount recorded to date for the WBS element.',
    `approval_date` DATE COMMENT 'Date when the WBS element received final approval.',
    `approval_status` STRING COMMENT 'Current approval workflow status.. Valid values are `pending|approved|rejected`',
    `budget_amount` DECIMAL(18,2) COMMENT 'Approved budget amount for the WBS element, may differ from planned cost.',
    `committed_cost` DECIMAL(18,2) COMMENT 'Cost commitments (e.g., purchase orders) associated with the WBS element.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the WBS record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `end_date` DATE COMMENT 'Planned or actual completion date of the WBS element.',
    `external_reference` STRING COMMENT 'Reference to external systems (e.g., ERP document number).',
    `fiscal_period` STRING COMMENT 'Fiscal period code (e.g., Q1, Q2) for reporting.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the WBS elements financials are assigned.',
    `investment_program_code` STRING COMMENT 'Code linking the WBS element to a corporate investment program (e.g., new model launch, plant expansion).',
    `is_capex` BOOLEAN COMMENT 'True if the element captures capital expenditure, false otherwise.',
    `is_r_and_d` BOOLEAN COMMENT 'True if the element is part of research & development projects.',
    `milestone_flag` BOOLEAN COMMENT 'Indicates whether the WBS element represents a project milestone.',
    `notes` STRING COMMENT 'Free‑form comments or remarks about the WBS element.',
    `planned_cost` DECIMAL(18,2) COMMENT 'Budgeted cost amount originally planned for the WBS element.',
    `plant_location` STRING COMMENT 'Geographic location or site name of the plant.',
    `project_phase` STRING COMMENT 'Current phase of the overall project to which the WBS element belongs.. Valid values are `initiation|planning|execution|monitoring|closure`',
    `revision_number` STRING COMMENT 'Version number of the WBS element record.',
    `start_date` DATE COMMENT 'Effective start date when the WBS element becomes active.',
    `wbs_element_status` STRING COMMENT 'Current lifecycle status of the WBS element.. Valid values are `planned|active|completed|closed|cancelled`',
    `updated_by` STRING COMMENT 'User identifier of the person who last updated the WBS record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the WBS record.',
    `wbs_code` STRING COMMENT 'External business identifier for the WBS element, typically used in SAP PS and project documentation.',
    `wbs_hierarchy_path` STRING COMMENT 'Delimited path representing the full hierarchy (e.g., 1.2.3).',
    `wbs_level` STRING COMMENT 'Hierarchical level of the element within the WBS tree (1 = top level).',
    `wbs_name` STRING COMMENT 'Human‑readable name or title of the WBS element.',
    `wbs_type` STRING COMMENT 'Classification of the WBS element by business purpose.. Valid values are `capex|r_and_d|maintenance|operational`',
    `created_by` STRING COMMENT 'User identifier of the person who created the WBS record.',
    CONSTRAINT pk_wbs_element PRIMARY KEY(`wbs_element_id`)
) COMMENT 'Work Breakdown Structure (WBS) element master record used for project-based cost tracking including CapEx projects, new model launch programs (SOP/EOP), EV/autonomous R&D programs, and plant expansion projects. Aligned with SAP PS (Project System). Captures WBS code, project definition, WBS level, responsible cost center, planned cost, actual cost, committed cost, project status, start/end dates, and investment program linkage. Enables granular CapEx spend tracking and R&D capitalization under IFRS IAS 38.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` (
    `financial_period_close_id` BIGINT COMMENT 'System-generated unique identifier for each financial period close record.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who signed off the close task.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the employee who signed off the close task.',
    `actual_completion_date` DATE COMMENT 'Date the close task was actually completed.',
    `approver_name` STRING COMMENT 'Full name of the employee who approved the close task.',
    `blocking_issue_description` STRING COMMENT 'Text describing any issue that prevented the task from progressing.',
    `cost_center_code` STRING COMMENT 'Cost center associated with the task for internal cost allocation.',
    `created_timestamp` TIMESTAMP COMMENT 'When the financial period close record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for monetary values.',
    `event_timestamp` TIMESTAMP COMMENT 'Timestamp of the primary event that marks the execution of the close task.',
    `fiscal_period` STRING COMMENT 'Period identifier within the fiscal year (e.g., Q1, M03).',
    `fiscal_year` STRING COMMENT 'Four‑digit fiscal year to which the close task belongs.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total monetary amount before deductions for the close activity.',
    `is_audit_evidence` BOOLEAN COMMENT 'Indicates whether the record serves as evidence for SOX or other audits.',
    `lock_flag` BOOLEAN COMMENT 'True when the fiscal period is locked after successful close.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final monetary value after tax and other adjustments.',
    `notes` STRING COMMENT 'Additional free‑form comments or observations related to the close task.',
    `planned_completion_date` DATE COMMENT 'Target date by which the close task should be finished.',
    `profit_center_code` STRING COMMENT 'Profit center linked to the task for profitability reporting.',
    `responsible_team` STRING COMMENT 'Organizational team accountable for executing the close task.',
    `financial_period_close_status` STRING COMMENT 'Current lifecycle state of the close task.. Valid values are `pending|in_progress|completed|blocked`',
    `task_number` STRING COMMENT 'Human‑readable identifier for the close task, used in reporting and audit trails.',
    `task_type` STRING COMMENT 'Category of the period‑end activity (e.g., depreciation run, accrual posting, intercompany reconciliation).. Valid values are `depreciation|accrual|intercompany|inventory|fx|cost`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component associated with the gross amount, if applicable.',
    `updated_timestamp` TIMESTAMP COMMENT 'Most recent time the record was modified.',
    CONSTRAINT pk_financial_period_close PRIMARY KEY(`financial_period_close_id`)
) COMMENT 'Financial period-end close task and status record tracking the completion of all period-end close activities required before a fiscal period can be locked. Captures close task type (depreciation run, accrual posting, intercompany reconciliation, inventory valuation, FX revaluation, cost allocation), responsible team, planned completion date, actual completion date, status (pending, in-progress, completed, blocked), blocking issues, and sign-off approver. Supports FY close governance, SOX control evidence, and audit readiness.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` (
    `dealer_incentive_id` BIGINT COMMENT 'Unique surrogate key for the dealer incentive record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Dealer incentive programs are created by a finance employee; creator ID required for governance.',
    `dealership_id` BIGINT COMMENT 'Unique identifier of the dealer receiving the incentive.',
    `accounting_period` STRING COMMENT 'Fiscal period (e.g., FY2025) to which the incentive expense is allocated.',
    `accrual_basis` STRING COMMENT 'Accounting basis used for recognizing the incentive (cash or accrual).. Valid values are `cash|accrual`',
    `actual_payment_amount` DECIMAL(18,2) COMMENT 'Monetary amount that has been paid to the dealer for the incentive.',
    `actual_units_accrued` STRING COMMENT 'Number of units that have actually accrued incentive eligibility.',
    `amount_per_unit` DECIMAL(18,2) COMMENT 'Monetary amount awarded per eligible vehicle unit.',
    `audit_user` STRING COMMENT 'User who performed the most recent audit or approval of the incentive record.',
    `budget_version` STRING COMMENT 'Version identifier of the budget used for the incentive program.',
    `dealer_incentive_category` STRING COMMENT 'Higher‑level category of the incentive (e.g., new_vehicle, electric).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the incentive record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary amounts.',
    `dealer_incentive_description` STRING COMMENT 'Free‑form description of the incentive program purpose and rules.',
    `eligibility_criteria` STRING COMMENT 'Textual description of the criteria dealers must meet to qualify.',
    `end_date` DATE COMMENT 'Date when the incentive program expires or is terminated.',
    `gl_account_code` STRING COMMENT 'GL account to which the incentive expense is posted.',
    `is_taxable` BOOLEAN COMMENT 'Indicates whether the incentive amount is subject to tax.',
    `max_units` STRING COMMENT 'Maximum number of vehicle units for which the incentive can be applied.',
    `model_year` STRING COMMENT 'Model year of the vehicle eligible for the incentive.',
    `notes` STRING COMMENT 'Supplementary remarks or comments related to the incentive.',
    `payment_date` DATE COMMENT 'Scheduled date on which the incentive payment is made to the dealer.',
    `payment_method` STRING COMMENT 'Method used to remit the incentive payment to the dealer.. Valid values are `electronic|check|wire|direct_deposit`',
    `payment_reference` STRING COMMENT 'External reference number for the payment transaction.',
    `payment_status` STRING COMMENT 'Current status of the incentive payment.. Valid values are `pending|paid|failed|reversed`',
    `payment_trigger_threshold` DECIMAL(18,2) COMMENT 'Numeric threshold value for the payment trigger (units, percentage, or score).',
    `payment_trigger_type` STRING COMMENT 'Mechanism that triggers incentive payment (e.g., volume threshold).. Valid values are `volume_threshold|otd_performance|nps_score|time_based`',
    `program_code` STRING COMMENT 'Business identifier code for the incentive program.',
    `program_name` STRING COMMENT 'Descriptive name of the incentive program offered to dealers.',
    `program_type` STRING COMMENT 'Classification of the incentive program (e.g., volume bonus, holdback).. Valid values are `volume_bonus|holdback|floor_plan|marketing_coop|rebate|incentive`',
    `region_code` STRING COMMENT 'Three‑letter region code where the dealer operates.. Valid values are `^[A-Z]{3}$`',
    `start_date` DATE COMMENT 'Date when the incentive program becomes effective.',
    `dealer_incentive_status` STRING COMMENT 'Current lifecycle status of the incentive program.. Valid values are `active|inactive|closed|pending|suspended`',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate percentage when the incentive is taxable.',
    `total_budget` DECIMAL(18,2) COMMENT 'Maximum total monetary budget allocated for the program.',
    `updated_by` STRING COMMENT 'User identifier who last updated the incentive record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the incentive record.',
    `vehicle_line` STRING COMMENT 'Vehicle product line (e.g., sedan, SUV) to which the incentive applies.',
    CONSTRAINT pk_dealer_incentive PRIMARY KEY(`dealer_incentive_id`)
) COMMENT 'Dealer financial incentive and sales program record capturing monetary incentives, volume bonuses, holdback payments, floor plan assistance, and marketing co-op funds issued to dealers. Captures incentive program type, dealer ID, vehicle line, model year (MY), incentive amount per unit, total program budget, accrual basis, payment trigger (volume threshold, OTD performance, NPS score), payment date, and GL account. Supports dealer network profitability management, MSRP-to-net revenue reconciliation, and sales incentive cost accounting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` (
    `vehicle_profitability_id` BIGINT COMMENT 'System-generated unique identifier for each vehicle profitability record.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Regulatory cost allocation in vehicle profitability reports requires linking each vehicles profitability line to its homologation approval record.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Profitability analysis per model requires linking each profitability record to the vehicle model entity for aggregating costs and revenues by model.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer that sold the vehicle.',
    `party_id` BIGINT COMMENT 'Identifier of the end‑customer who purchased the vehicle.',
    `primary_vehicle_dealership_id` BIGINT COMMENT 'Identifier of the dealer that sold the vehicle.',
    `vehicle_customer_party_id` BIGINT COMMENT 'Identifier of the end‑customer who purchased the vehicle.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Profitability reports per vehicle need to associate each record with the VIN registry to pull vehicle details for compliance and warranty cost allocation.',
    `actual_manufacturing_cost` DECIMAL(18,2) COMMENT 'Real cost incurred for material, labor, and overhead.',
    `cost_center_code` STRING COMMENT 'Cost center responsible for manufacturing cost allocation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the profitability record was created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary values.. Valid values are `^[A-Z]{3}$`',
    `ebitda_contribution` DECIMAL(18,2) COMMENT 'Vehicle-level contribution to EBITDA after allocating fixed overhead.',
    `emission_rating` STRING COMMENT 'Regulatory emissions classification (e.g., EPA Tier 3).',
    `fiscal_period` STRING COMMENT 'Fiscal quarter or period identifier.. Valid values are `Q1|Q2|Q3|Q4`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the transaction is recorded.',
    `fuel_type` STRING COMMENT 'Primary propulsion technology of the vehicle.. Valid values are `EV|HEV|PHEV|ICE|Hybrid`',
    `gross_margin` DECIMAL(18,2) COMMENT 'Difference between gross revenue and standard manufacturing cost.',
    `gross_revenue_msrp` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price before any discounts or incentives.',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Monetary incentive provided to the dealer for this sale.',
    `is_eligible_for_subsidy` BOOLEAN COMMENT 'Indicates whether the vehicle qualifies for government subsidies.',
    `market_region` STRING COMMENT 'Geographic sales region (e.g., NA, EU, APAC).',
    `model_year` STRING COMMENT 'Calendar year in which the vehicle model was produced.',
    `net_contribution_margin` DECIMAL(18,2) COMMENT 'Net revenue minus all variable costs and warranty reserve.',
    `net_revenue` DECIMAL(18,2) COMMENT 'Revenue after dealer incentives, discounts, and taxes.',
    `plant_code` STRING COMMENT 'Identifier of the plant where the vehicle was assembled.',
    `profit_center_code` STRING COMMENT 'Profit center used for revenue attribution.',
    `sales_channel` STRING COMMENT 'Channel through which the vehicle was sold.. Valid values are `Dealer|Direct|Online|Fleet|Wholesale`',
    `selling_distribution_cost` DECIMAL(18,2) COMMENT 'Costs associated with sales, logistics, and dealer commissions.',
    `standard_manufacturing_cost` DECIMAL(18,2) COMMENT 'Planned cost based on standard BOM and routing.',
    `vehicle_profitability_status` STRING COMMENT 'Current lifecycle status of the profitability record.. Valid values are `active|closed|reversed|pending`',
    `subsidy_amount` DECIMAL(18,2) COMMENT 'Monetary value of any applicable subsidy.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Taxes applied to the net revenue.',
    `transaction_date` DATE COMMENT 'Date the vehicle sale and profitability calculation occurred.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `vehicle_category` STRING COMMENT 'Business segment classification of the vehicle.. Valid values are `Passenger|Commercial|Luxury|Performance`',
    `vehicle_height_mm` STRING COMMENT 'Overall height of the vehicle in millimetres.',
    `vehicle_length_mm` STRING COMMENT 'Overall length of the vehicle in millimetres.',
    `vehicle_line` STRING COMMENT 'Model line or family (e.g., SUV, Truck, Sedan).',
    `vehicle_weight_kg` DECIMAL(18,2) COMMENT 'Curb weight of the vehicle in kilograms.',
    `vehicle_width_mm` STRING COMMENT 'Overall width of the vehicle in millimetres.',
    `warranty_miles` STRING COMMENT 'Maximum mileage covered by the warranty.',
    `warranty_reserve_charge` DECIMAL(18,2) COMMENT 'Provision for future warranty claims allocated to this vehicle.',
    `warranty_years` STRING COMMENT 'Length of the standard warranty in years.',
    CONSTRAINT pk_vehicle_profitability PRIMARY KEY(`vehicle_profitability_id`)
) COMMENT 'Vehicle-level profitability record capturing the contribution margin and net profitability for each vehicle unit sold, by VIN, vehicle line, plant, market region, and sales channel. Captures gross revenue (MSRP), net revenue (after dealer incentives and discounts), standard manufacturing cost, actual manufacturing cost, gross margin, selling and distribution cost, warranty reserve charge, and net contribution margin. Supports EBITDA reporting by vehicle line/plant/region and management accounting for product portfolio decisions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`finance_project` (
    `finance_project_id` BIGINT COMMENT 'Primary key for local project reference',
    `engineering_project_id` BIGINT COMMENT 'FK reference to SSOT engineering.engineering_project',
    CONSTRAINT pk_finance_project PRIMARY KEY(`finance_project_id`)
) COMMENT 'Reference to SSOT owner engineering.engineering_project. Master reference table for project. Referenced by related_project_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` (
    `payment_settlement_id` BIGINT COMMENT 'Primary key for payment_settlement',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice that this settlement settles.',
    `party_id` BIGINT COMMENT 'Identifier of the external party (vendor, customer, partner) involved in the settlement.',
    `reversed_payment_settlement_id` BIGINT COMMENT 'Self-referencing FK on payment_settlement (reversed_payment_settlement_id)',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'Sum of taxes, fees, discounts, or other adjustments applied to the gross amount.',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the settlement was approved.',
    `approved_by` STRING COMMENT 'User identifier of the person who approved the settlement.',
    `batch_number` STRING COMMENT 'Identifier of the batch run that processed this settlement.',
    `batch_sequence` STRING COMMENT 'Sequence number of the settlement within its processing batch.',
    `payment_settlement_category` STRING COMMENT 'High‑level classification of the settlement purpose.',
    `channel` STRING COMMENT 'Interface or process through which the settlement was initiated.',
    `comment` STRING COMMENT 'Additional comments or notes entered by users.',
    `cost_center_code` STRING COMMENT 'Internal cost center to which the settlement expense is charged.',
    `counterparty_type` STRING COMMENT 'Classification of the counterparty involved in the settlement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the settlement record was first created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for the settlement.',
    `payment_settlement_description` STRING COMMENT 'Free‑form text describing the purpose or context of the settlement.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Discount component subtracted from the gross amount.',
    `due_date` DATE COMMENT 'Date by which the settlement is expected to be completed.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Rate used to convert from original currency to settlement currency, if applicable.',
    `external_reference` STRING COMMENT 'Reference identifier used by external parties (e.g., bank reference).',
    `fee_amount` DECIMAL(18,2) COMMENT 'Fee component included in the adjustment amount.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total amount before any adjustments, in the settlement currency.',
    `is_cross_border` BOOLEAN COMMENT 'Indicates whether the settlement involves parties in different countries.',
    `is_manual_settlement` BOOLEAN COMMENT 'True if the settlement was entered manually rather than via automated process.',
    `legal_entity_code` STRING COMMENT 'Code of the legal entity within the enterprise that owns the settlement.',
    `method` STRING COMMENT 'Payment instrument used for the settlement.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount transferred after adjustments, in the settlement currency.',
    `number` STRING COMMENT 'External business reference number assigned to the settlement.',
    `original_currency_code` STRING COMMENT 'Currency code of the original transaction before conversion.',
    `payment_reference` STRING COMMENT 'External reference supplied by the payer or payee for tracking.',
    `priority` STRING COMMENT 'Priority level for processing the settlement.',
    `processed_date` DATE COMMENT 'Date on which the settlement was actually processed.',
    `project_code` STRING COMMENT 'Project identifier linked to the settlement for project‑level accounting.',
    `reason_code` STRING COMMENT 'Code indicating the business reason for the settlement (e.g., invoice_payment, tax_refund).',
    `reconciliation_date` DATE COMMENT 'Date when the settlement was reconciled.',
    `reconciliation_status` STRING COMMENT 'Current status of the financial reconciliation for this settlement.',
    `payment_settlement_status` STRING COMMENT 'Current lifecycle status of the settlement.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component included in the adjustment amount.',
    `timestamp` TIMESTAMP COMMENT 'Date and time when the settlement was executed in the business process.',
    `payment_settlement_type` STRING COMMENT 'Direction of cash flow for the settlement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the settlement record.',
    `version` STRING COMMENT 'Version number for optimistic concurrency control.',
    `created_by` STRING COMMENT 'User identifier of the person who created the settlement record.',
    CONSTRAINT pk_payment_settlement PRIMARY KEY(`payment_settlement_id`)
) COMMENT 'Master reference table for payment_settlement. Referenced by payment_settlement_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` (
    `intercompany_group_id` BIGINT COMMENT 'Primary key for intercompany_group',
    `parent_intercompany_group_id` BIGINT COMMENT 'Self-referencing FK on intercompany_group (parent_intercompany_group_id)',
    `legal_entity_id` BIGINT COMMENT 'Identifier of the primary legal entity that owns the intercompany group.',
    `intercompany_group_code` STRING COMMENT 'External business code used to reference the intercompany group in finance systems.',
    `consolidation_method` STRING COMMENT 'Method used to consolidate financial results across entities in the group.',
    `cost_center_code` STRING COMMENT 'Cost center code associated with the intercompany group for internal cost allocation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the intercompany group record was first created in the system.',
    `intercompany_group_description` STRING COMMENT 'Free‑form text describing the purpose, scope, or notes about the intercompany group.',
    `effective_from` DATE COMMENT 'Date when the intercompany group becomes effective for accounting purposes.',
    `effective_until` DATE COMMENT 'Date when the intercompany group ceases to be effective; null if open‑ended.',
    `external_reference_number` STRING COMMENT 'Reference number from external systems (e.g., SAP, legacy ERP) linking to this group.',
    `intercompany_accounting_rule` STRING COMMENT 'Rule governing how intercompany transactions are accounted for within the group.',
    `is_cross_border` BOOLEAN COMMENT 'True if the intercompany group includes entities in multiple countries.',
    `is_taxable` BOOLEAN COMMENT 'True if the intercompany group is subject to corporate tax reporting.',
    `last_review_date` DATE COMMENT 'Date when the intercompany group was last reviewed for compliance or policy updates.',
    `intercompany_group_name` STRING COMMENT 'Descriptive name of the intercompany group for reporting and analysis.',
    `next_review_date` DATE COMMENT 'Planned date for the next review of the intercompany group.',
    `notes` STRING COMMENT 'Additional free‑form remarks or comments about the group.',
    `profit_center_code` STRING COMMENT 'Profit center code linked to the intercompany group for profitability analysis.',
    `region_code` STRING COMMENT 'Geographic region classification for the intercompany group.',
    `reporting_currency` STRING COMMENT 'ISO 4217 currency code used for reporting the groups financials.',
    `secondary_legal_entity_ids` STRING COMMENT 'Comma‑separated list of identifiers for additional legal entities participating in the group.',
    `intercompany_group_status` STRING COMMENT 'Current lifecycle state of the intercompany group.',
    `tax_regime` STRING COMMENT 'Tax treatment applicable to the intercompany group.',
    `intercompany_group_type` STRING COMMENT 'Category that defines the nature of the intercompany grouping.',
    `updated_by` STRING COMMENT 'User identifier of the person who last updated the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the intercompany group record.',
    `created_by` STRING COMMENT 'User identifier of the person who created the record.',
    CONSTRAINT pk_intercompany_group PRIMARY KEY(`intercompany_group_id`)
) COMMENT 'Master reference table for intercompany_group. Referenced by intercompany_group_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` (
    `allocation_cycle_id` BIGINT COMMENT 'Primary key for allocation_cycle',
    `previous_allocation_cycle_id` BIGINT COMMENT 'Self-referencing FK on allocation_cycle (previous_allocation_cycle_id)',
    `actual_amount` DECIMAL(18,2) COMMENT 'Total monetary amount actually allocated in the cycle.',
    `allocation_basis` STRING COMMENT 'Primary driver used for cost allocation calculations.',
    `allocation_method` STRING COMMENT 'Method used to allocate costs in this cycle.',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'Default percentage applied when the allocation method is proportional.',
    `approved_by` STRING COMMENT 'Identifier of the person or system that approved the allocation cycle.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the allocation cycle was approved for use.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Planned monetary amount to be allocated during the cycle.',
    `allocation_cycle_code` STRING COMMENT 'Human‑readable code used to reference the allocation cycle in financial systems.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the allocation cycle record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary values; may reference a currency reference table. [ENUM-REF-CANDIDATE: USD|EUR|JPY|GBP|CNY|CHF|CAD|AUD|... — promote to reference product]',
    `allocation_cycle_description` STRING COMMENT 'Free‑form text describing the purpose or special conditions of the cycle.',
    `end_date` DATE COMMENT 'Date on which the allocation cycle ends; null for open‑ended cycles.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the allocation cycle belongs.',
    `is_current` BOOLEAN COMMENT 'Indicates whether this cycle is the active one for ongoing allocations.',
    `allocation_cycle_name` STRING COMMENT 'Descriptive name of the allocation cycle (e.g., "FY2025 Q1 Allocation").',
    `period_number` STRING COMMENT 'Sequential number of the period within the fiscal year (e.g., 1 for Q1).',
    `start_date` DATE COMMENT 'Date on which the allocation cycle becomes effective.',
    `allocation_cycle_status` STRING COMMENT 'Current lifecycle state of the allocation cycle.',
    `allocation_cycle_type` STRING COMMENT 'Category of the allocation cycle defining its periodicity.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the allocation cycle record.',
    `version_number` STRING COMMENT 'Version of the allocation cycle definition for change management.',
    CONSTRAINT pk_allocation_cycle PRIMARY KEY(`allocation_cycle_id`)
) COMMENT 'Master reference table for allocation_cycle. Referenced by allocation_cycle_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` (
    `intercompany_loan_id` BIGINT COMMENT 'Primary key for intercompany_loan',
    `company_code_id` BIGINT COMMENT 'Identifier of the subsidiary or entity receiving the loan.',
    `primary_company_code_id` BIGINT COMMENT 'Identifier of the subsidiary or entity providing the loan.',
    `refinanced_intercompany_loan_id` BIGINT COMMENT 'Self-referencing FK on intercompany_loan (refinanced_intercompany_loan_id)',
    `accounting_code` STRING COMMENT 'Cost‑center or GL code used for accounting the loan.',
    `accrued_interest` DECIMAL(18,2) COMMENT 'Interest that has accumulated but not yet been paid.',
    `agreement_number` STRING COMMENT 'External reference number assigned to the loan agreement by the finance department.',
    `amortization_method` STRING COMMENT 'Method used to amortize the principal over the loan term.',
    `approval_date` DATE COMMENT 'Date when the loan was formally approved.',
    `approved_by` STRING COMMENT 'Name or identifier of the finance officer who approved the loan.',
    `intercompany_loan_category` STRING COMMENT 'High‑level classification of the loan relationship.',
    `collateral_type` STRING COMMENT 'Nature of any security pledged for the loan.',
    `collateral_value` DECIMAL(18,2) COMMENT 'Monetary value of the pledged collateral at loan inception.',
    `covenant_details` STRING COMMENT 'Financial covenants or conditions attached to the loan.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the loan record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three‑letter code of the currency used for the loan.',
    `default_date` DATE COMMENT 'Date on which the loan entered default status.',
    `default_flag` BOOLEAN COMMENT 'Indicates whether the loan is in default (true) or not (false).',
    `early_termination_fee` DECIMAL(18,2) COMMENT 'Fee charged if the loan is repaid before the scheduled maturity.',
    `effective_from` DATE COMMENT 'Date when the loan agreement becomes effective.',
    `effective_until` DATE COMMENT 'Maturity date when the loan is scheduled to be fully repaid; null for open‑ended agreements.',
    `exchange_rate_at_inception` DECIMAL(18,2) COMMENT 'Currency conversion rate applied when the loan was originated, if currencies differ.',
    `guarantee_type` STRING COMMENT 'Type of guarantee backing the loan.',
    `interest_accrual_method` STRING COMMENT 'Method used to calculate accrued interest.',
    `interest_cap` DECIMAL(18,2) COMMENT 'Maximum interest rate applicable if the loan has a variable component.',
    `interest_rate` DECIMAL(18,2) COMMENT 'Annual interest rate applied to the outstanding principal, expressed as a decimal (e.g., 0.0750 for 7.5%).',
    `interest_rate_type` STRING COMMENT 'Indicates whether the interest rate is fixed for the term or varies with a benchmark.',
    `internal_audit_status` STRING COMMENT 'Current status of internal audit review for the loan.',
    `is_cross_border` BOOLEAN COMMENT 'True if lender and borrower are in different legal jurisdictions.',
    `last_payment_date` DATE COMMENT 'Date when the most recent payment was received.',
    `legal_document_reference` STRING COMMENT 'Reference number of the legal contract governing the loan.',
    `next_payment_date` DATE COMMENT 'Date of the upcoming scheduled payment.',
    `notes` STRING COMMENT 'Free‑form comments or observations about the loan.',
    `payment_amount` DECIMAL(18,2) COMMENT 'Standard payment amount per repayment period.',
    `principal_amount` DECIMAL(18,2) COMMENT 'Original amount of money lent, before interest and fees.',
    `principal_outstanding` DECIMAL(18,2) COMMENT 'Remaining principal balance that has not yet been repaid.',
    `purpose` STRING COMMENT 'Business reason for the intercompany loan (e.g., working capital, asset acquisition).',
    `repayment_frequency` STRING COMMENT 'How often scheduled payments are due.',
    `restructuring_date` DATE COMMENT 'Date when the loan restructuring was executed.',
    `restructuring_flag` BOOLEAN COMMENT 'True if the loan terms have been restructured.',
    `intercompany_loan_status` STRING COMMENT 'Current lifecycle state of the loan.',
    `tax_implication` STRING COMMENT 'Indicates whether interest or fees are subject to tax.',
    `term_months` STRING COMMENT 'Duration of the loan in months.',
    `total_outstanding` DECIMAL(18,2) COMMENT 'Sum of principal outstanding and accrued interest.',
    `intercompany_loan_type` STRING COMMENT 'Category of the intercompany loan indicating its structure.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the loan record.',
    CONSTRAINT pk_intercompany_loan PRIMARY KEY(`intercompany_loan_id`)
) COMMENT 'Master reference table for intercompany_loan. Referenced by related_loan_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`legal_entity` (
    `legal_entity_id` BIGINT COMMENT 'Primary key for legal_entity',
    `jurisdiction_id` BIGINT COMMENT 'add column jurisdiction_id (BIGINT) with FK to compliance.jurisdiction.jurisdiction_id - legal entities are incorporated in specific jurisdictions',
    `parent_legal_entity_id` BIGINT COMMENT 'Identifier of the immediate parent entity in the corporate hierarchy.',
    `primary_ultimate_parent_legal_entity_id` BIGINT COMMENT 'Identifier of the top‑most parent entity in the corporate structure.',
    `address_line1` STRING COMMENT 'Primary street address of the entitys headquarters.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, floor, etc.).',
    `city` STRING COMMENT 'City component of the incorporation address.',
    `country_of_incorporation` STRING COMMENT 'Three‑letter ISO country code where the entity is legally incorporated.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the legal entity record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code used for financial reporting.',
    `data_privacy_classification` STRING COMMENT 'Internal classification indicating the sensitivity level of the entitys data.',
    `legal_entity_description` STRING COMMENT 'Free‑form textual description of the entitys business activities.',
    `effective_date` DATE COMMENT 'Date when the entity became legally active.',
    `email_address` STRING COMMENT 'Primary email address for official communications.',
    `fiscal_year_end_month` STRING COMMENT 'Numeric month (1‑12) indicating the end of the entitys fiscal year.',
    `industry_code` STRING COMMENT 'Standard industry code describing the entitys primary business activity.',
    `is_public_company` BOOLEAN COMMENT 'Indicates whether the entity is publicly listed (True) or privately held (False).',
    `legal_name` STRING COMMENT 'The full registered legal name of the entity.',
    `market_capitalization` DECIMAL(18,2) COMMENT 'Total market value of the entitys outstanding shares, expressed in reporting currency.',
    `number_of_employees` STRING COMMENT 'Total headcount employed by the entity.',
    `phone_number` STRING COMMENT 'Primary contact telephone number for the entity.',
    `postal_code` STRING COMMENT 'Postal/ZIP code for the headquarters address.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary contact.',
    `primary_contact_name` STRING COMMENT 'Name of the main point‑of‑contact for the entity.',
    `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact.',
    `registration_number` STRING COMMENT 'Official registration number assigned by the jurisdiction of incorporation.',
    `sox_control_owner` STRING COMMENT 'Name of the individual responsible for SOX compliance controls for this entity.',
    `state_province` STRING COMMENT 'State or province component of the incorporation address.',
    `legal_entity_status` STRING COMMENT 'Current operational status of the entity.',
    `status_change_date` DATE COMMENT 'Date when the entitys status last changed.',
    `tax_identification_number` STRING COMMENT 'Government‑issued tax identifier for the entity.',
    `tax_residency_country` STRING COMMENT 'ISO 3‑letter country code indicating the entitys tax residency.',
    `termination_date` DATE COMMENT 'Date when the entity ceased to exist or was dissolved.',
    `trade_name` STRING COMMENT 'Business name under which the entity operates publicly (Doing Business As).',
    `legal_entity_type` STRING COMMENT 'Classification of the entitys legal structure.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the legal entity record.',
    `website_url` STRING COMMENT 'Public website URL of the entity.',
    CONSTRAINT pk_legal_entity PRIMARY KEY(`legal_entity_id`)
) COMMENT 'Master reference table for legal_entity. Referenced by primary_legal_entity_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ADD CONSTRAINT `fk_finance_gl_account_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_parent_cost_center_id` FOREIGN KEY (`parent_cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_parent_profit_center_id` FOREIGN KEY (`parent_profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ADD CONSTRAINT `fk_finance_company_code_intercompany_group_id` FOREIGN KEY (`intercompany_group_id`) REFERENCES `vibe_automotive_v1`.`finance`.`intercompany_group`(`intercompany_group_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `vibe_automotive_v1`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_automotive_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_automotive_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_payment_settlement_id` FOREIGN KEY (`payment_settlement_id`) REFERENCES `vibe_automotive_v1`.`finance`.`payment_settlement`(`payment_settlement_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_primary_company_code_id` FOREIGN KEY (`primary_company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_finance_project_id` FOREIGN KEY (`finance_project_id`) REFERENCES `vibe_automotive_v1`.`finance`.`finance_project`(`finance_project_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_budget_plan_id` FOREIGN KEY (`budget_plan_id`) REFERENCES `vibe_automotive_v1`.`finance`.`budget_plan`(`budget_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ADD CONSTRAINT `fk_finance_manufacturing_cost_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ADD CONSTRAINT `fk_finance_warranty_reserve_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ADD CONSTRAINT `fk_finance_warranty_reserve_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` ADD CONSTRAINT `fk_finance_finance_inventory_valuation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` ADD CONSTRAINT `fk_finance_finance_inventory_valuation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` ADD CONSTRAINT `fk_finance_finance_inventory_valuation_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ADD CONSTRAINT `fk_finance_depreciation_run_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ADD CONSTRAINT `fk_finance_intercompany_settlement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ADD CONSTRAINT `fk_finance_intercompany_settlement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ADD CONSTRAINT `fk_finance_intercompany_settlement_intercompany_group_id` FOREIGN KEY (`intercompany_group_id`) REFERENCES `vibe_automotive_v1`.`finance`.`intercompany_group`(`intercompany_group_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ADD CONSTRAINT `fk_finance_intercompany_settlement_intercompany_loan_id` FOREIGN KEY (`intercompany_loan_id`) REFERENCES `vibe_automotive_v1`.`finance`.`intercompany_loan`(`intercompany_loan_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ADD CONSTRAINT `fk_finance_intercompany_settlement_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_allocation_cycle_id` FOREIGN KEY (`allocation_cycle_id`) REFERENCES `vibe_automotive_v1`.`finance`.`allocation_cycle`(`allocation_cycle_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ADD CONSTRAINT `fk_finance_tax_posting_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ADD CONSTRAINT `fk_finance_tax_posting_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_automotive_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_finance_project_id` FOREIGN KEY (`finance_project_id`) REFERENCES `vibe_automotive_v1`.`finance`.`finance_project`(`finance_project_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ADD CONSTRAINT `fk_finance_currency_rate_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_parent_wbs_wbs_element_id` FOREIGN KEY (`parent_wbs_wbs_element_id`) REFERENCES `vibe_automotive_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_finance_project_id` FOREIGN KEY (`finance_project_id`) REFERENCES `vibe_automotive_v1`.`finance`.`finance_project`(`finance_project_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ADD CONSTRAINT `fk_finance_payment_settlement_reversed_payment_settlement_id` FOREIGN KEY (`reversed_payment_settlement_id`) REFERENCES `vibe_automotive_v1`.`finance`.`payment_settlement`(`payment_settlement_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ADD CONSTRAINT `fk_finance_intercompany_group_parent_intercompany_group_id` FOREIGN KEY (`parent_intercompany_group_id`) REFERENCES `vibe_automotive_v1`.`finance`.`intercompany_group`(`intercompany_group_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ADD CONSTRAINT `fk_finance_intercompany_group_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `vibe_automotive_v1`.`finance`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ADD CONSTRAINT `fk_finance_allocation_cycle_previous_allocation_cycle_id` FOREIGN KEY (`previous_allocation_cycle_id`) REFERENCES `vibe_automotive_v1`.`finance`.`allocation_cycle`(`allocation_cycle_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ADD CONSTRAINT `fk_finance_intercompany_loan_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ADD CONSTRAINT `fk_finance_intercompany_loan_primary_company_code_id` FOREIGN KEY (`primary_company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ADD CONSTRAINT `fk_finance_intercompany_loan_refinanced_intercompany_loan_id` FOREIGN KEY (`refinanced_intercompany_loan_id`) REFERENCES `vibe_automotive_v1`.`finance`.`intercompany_loan`(`intercompany_loan_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ADD CONSTRAINT `fk_finance_legal_entity_parent_legal_entity_id` FOREIGN KEY (`parent_legal_entity_id`) REFERENCES `vibe_automotive_v1`.`finance`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ADD CONSTRAINT `fk_finance_legal_entity_primary_ultimate_parent_legal_entity_id` FOREIGN KEY (`primary_ultimate_parent_legal_entity_id`) REFERENCES `vibe_automotive_v1`.`finance`.`legal_entity`(`legal_entity_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`finance` SET TAGS ('dbx_pii_division' = 'corporate');
ALTER SCHEMA `vibe_automotive_v1`.`finance` SET TAGS ('dbx_pii_domain' = 'finance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger (GL) Account Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `balance_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Balance Sheet vs. Profit & Loss Classification');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `balance_type` SET TAGS ('dbx_pii_value_regex' = 'profit_and_loss|balance_sheet');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `chart_of_accounts_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Chart of Accounts Version');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `closing_balance` SET TAGS ('dbx_pii_business_glossary_term' = 'Closing Balance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_description` SET TAGS ('dbx_pii_business_glossary_term' = 'GL Account Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `effective_to` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `group` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger (GL) Account Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_budgeted` SET TAGS ('dbx_pii_business_glossary_term' = 'Budgeted Account Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_consolidation_account` SET TAGS ('dbx_pii_business_glossary_term' = 'Consolidation Account Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_deprecated` SET TAGS ('dbx_pii_business_glossary_term' = 'Deprecation Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_reconciliation_account` SET TAGS ('dbx_pii_business_glossary_term' = 'Reconciliation Account Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_tax_relevant` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Relevance Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `last_posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `last_reconciliation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Reconciliation Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_name` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger (GL) Account Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `opening_balance` SET TAGS ('dbx_pii_business_glossary_term' = 'Opening Balance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `reporting_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `reporting_level` SET TAGS ('dbx_pii_value_regex' = 'company|division|plant|region|country');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Business Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `segment` SET TAGS ('dbx_pii_value_regex' = 'OEM|Aftermarket|Service|R&D');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_status` SET TAGS ('dbx_pii_business_glossary_term' = 'GL Account Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|blocked|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `tax_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `tax_category` SET TAGS ('dbx_pii_value_regex' = 'taxable|exempt|zero|reverse');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_type` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger (GL) Account Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_type` SET TAGS ('dbx_pii_value_regex' = 'asset|liability|equity|revenue|expense');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `parent_cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Cost Center ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `actual_spend` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Spend');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_value_regex' = 'fixed|percentage|activity_based|none');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_category` SET TAGS ('dbx_pii_value_regex' = 'cost_center|profit_center|investment_center');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `country` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `country` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `effective_to` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Hierarchy Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `region` SET TAGS ('dbx_pii_business_glossary_term' = 'Geographic Region');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `reporting_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `reporting_level` SET TAGS ('dbx_pii_value_regex' = 'plant|division|global');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|planned|closed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_type` SET TAGS ('dbx_pii_value_regex' = 'production|administration|research|sales|service');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `variance_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Variance Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `owner_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `parent_profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Profit Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Manager Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `primary_profit_manager_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Profit Manager Employee Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `primary_profit_manager_employee_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `actual_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `audit_trail` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Trail Log');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `closure_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Closure Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'Compliant|NonCompliant|Pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `ebitda_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'EBITDA Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `effective_to` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `external_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'External System Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `group` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `hierarchy_path` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Hierarchy Path');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `is_consolidated` SET TAGS ('dbx_pii_business_glossary_term' = 'Consolidated Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Hierarchy Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `margin_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Margin Percentage');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `owner` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Owner Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `plan_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_value_regex' = 'NA|EU|APAC|LATAM|MEA');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `reporting_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `reporting_currency` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `review_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Cycle');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `review_cycle` SET TAGS ('dbx_pii_value_regex' = 'Annual|Quarterly');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `risk_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `risk_rating` SET TAGS ('dbx_pii_value_regex' = 'Low|Medium|High');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Segment (Segment)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `segment` SET TAGS ('dbx_pii_value_regex' = 'EV|ICE|HEV|PHEV|Commercial|Luxury');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_status` SET TAGS ('dbx_pii_value_regex' = 'Active|Inactive|Planned|Closed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `status_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Status Reason');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `profit_center_type` SET TAGS ('dbx_pii_value_regex' = 'Legal|Operating|Reporting');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `intercompany_group_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Group Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `business_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Business Line');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `chart_of_accounts` SET TAGS ('dbx_pii_business_glossary_term' = 'Chart of Accounts Assignment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code (SAP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `consolidation_group` SET TAGS ('dbx_pii_business_glossary_term' = 'Consolidation Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code (ISO 3166-1 alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `entity_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Entity Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `entity_type` SET TAGS ('dbx_pii_value_regex' = 'legal_entity|joint_venture|subsidiary|branch|holding');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_pii_value_regex' = 'FY01|FY02|FY03|FY04|FY05|FY06');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `functional_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `functional_currency` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `industry_sector` SET TAGS ('dbx_pii_business_glossary_term' = 'Industry Sector');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `industry_sector` SET TAGS ('dbx_pii_value_regex' = 'passenger_vehicles|commercial_vehicles|components|services|software');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `is_consolidated` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Consolidated Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `legal_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Legal Entity Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `local_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `local_currency` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Registration Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `reporting_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Financial Reporting Standard');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `reporting_standard` SET TAGS ('dbx_pii_value_regex' = 'IFRS|GAAP|IFRS_FOR_SME|US_GAAP|EU_GAAP');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `short_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Legal Entity Short Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Entity Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|closed|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_id_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Identification Number (TIN)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_id_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_id_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `website_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Website URL');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `accrual_cutoff_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Cutoff Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Period End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `is_current_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Period Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `is_interim` SET TAGS ('dbx_pii_business_glossary_term' = 'Interim Period Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `lock_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Lock Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `posting_deadline_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Deadline Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_status` SET TAGS ('dbx_pii_value_regex' = 'open|closed|locked');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_type` SET TAGS ('dbx_pii_value_regex' = 'regular|adjustment|special');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fiscal_period` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `company_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting User ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Business Partner ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting User ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (CUR)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Debit/Credit Indicator (DC)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_pii_value_regex' = 'debit|credit');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_language` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Language');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Journal Entry Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Type (DT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_type` SET TAGS ('dbx_pii_value_regex' = 'SA|KR|AB|DR|CR');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `intercompany_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_adjustment` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_consolidated` SET TAGS ('dbx_pii_business_glossary_term' = 'Consolidation Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_manual_entry` SET TAGS ('dbx_pii_business_glossary_term' = 'Manual Entry Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_test_entry` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Entry Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `ledger_group` SET TAGS ('dbx_pii_business_glossary_term' = 'Ledger Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `line_item_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Item Count');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `plant` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant (PLANT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_key` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Key');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_text` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Text');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_user_role` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting User Role');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `source_module` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Module');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Journal Entry Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_status` SET TAGS ('dbx_pii_value_regex' = 'posted|reversed|pending|error');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `tax_jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `transaction_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Journal Entry Line ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `account_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Account Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `amount_cc` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Amount (Company Code Currency)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `amount_tc` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Amount (Transaction Currency)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `assignment` SET TAGS ('dbx_pii_business_glossary_term' = 'Assignment Field');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `business_area` SET TAGS ('dbx_pii_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_cc` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_cc` SET TAGS ('dbx_pii_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_tc` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_tc` SET TAGS ('dbx_pii_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Debit/Credit Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_pii_value_regex' = 'D|C');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `document_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `plant` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `posting_key` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Key');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Quantity');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reference_document_item` SET TAGS ('dbx_pii_business_glossary_term' = 'Reference Document Item');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `text` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Item Text');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` SET TAGS ('dbx_pii_subdomain' = 'payables_receivables');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounts Payable Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `trade_compliance_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade Compliance Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `vendor_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `ap_invoice_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Due Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `goods_receipt_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Goods Receipt Number (GR_NO)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `is_credit_memo` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Credit Memo');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `material_group` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Number (INV_NO)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_block_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Block Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_value_regex' = 'ACH|Wire|Check|CreditCard|Cash');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Terms (PAY_TERM)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_pii_value_regex' = 'Net30|Net45|Net60|EOM|2%_10');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_business_glossary_term' = 'PPAP Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_value_regex' = 'NotStarted|InProgress|Approved|Rejected');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Purchase Order Number (PO_NO)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `reporting_currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `reporting_currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `ap_invoice_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `ap_invoice_status` SET TAGS ('dbx_pii_value_regex' = 'draft|open|approved|paid|rejected|cancelled');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_value_regex' = 'VAT|GST|SALES|NONE');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `three_way_match_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Three-Way Match Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ALTER COLUMN `warranty_reserve_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Reserve Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` SET TAGS ('dbx_pii_subdomain' = 'payables_receivables');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounts Payable Payment ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_run_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Run ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `payment_settlement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Settlement ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `amount_gross` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `amount_net` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bank Account Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Channel');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `channel` SET TAGS ('dbx_pii_value_regex' = 'online|batch|manual');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `clearance_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Clearance Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Comments');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `cost_center` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `early_payment_discount_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Early Payment Discount Applied');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `error_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Error Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `exchange_rate_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `gl_account` SET TAGS ('dbx_pii_business_glossary_term' = 'GL Account Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `house_bank_code` SET TAGS ('dbx_pii_business_glossary_term' = 'House Bank Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `is_automated` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Automated Payment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `method` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `method` SET TAGS ('dbx_pii_value_regex' = 'ach|wire|check|eft');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `original_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Original Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `original_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Original Currency');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `original_currency` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Priority');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'high|normal|low');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `reference` SET TAGS ('dbx_pii_business_glossary_term' = 'External Payment Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `settlement_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_status` SET TAGS ('dbx_pii_value_regex' = 'pending|processed|cleared|failed|reversed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `terms` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `ap_payment_type` SET TAGS ('dbx_pii_value_regex' = 'outbound|inbound');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ALTER COLUMN `vat_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'VAT Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` SET TAGS ('dbx_pii_subdomain' = 'payables_receivables');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounts Receivable Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `company_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Entity ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `primary_company_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Entity ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `accounting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_pii_business_glossary_term' = 'Aging Bucket');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_pii_value_regex' = 'current|1_30|31_60|61_90|90_plus|unknown');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `billing_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_category` SET TAGS ('dbx_pii_value_regex' = 'domestic|export|internal|fleet|government|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `collection_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Collection Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `collection_status` SET TAGS ('dbx_pii_value_regex' = 'on_time|late|defaulted|written_off|disputed|unknown');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `discount_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Reason');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Transaction Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_value_regex' = 'credit_card|bank_transfer|cash|check|online|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_received_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Received Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_pii_value_regex' = 'pending|cleared|failed|reversed|partial|unknown');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_pii_value_regex' = 'net_30|net_45|net_60|cod|prepaid|milestone');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Purchase Order Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `sales_org_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_status` SET TAGS ('dbx_pii_value_regex' = 'draft|open|posted|cancelled|paid|reversed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `tax_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_type` SET TAGS ('dbx_pii_value_regex' = 'vehicle_sale|parts|service|lease|subscription|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `warranty_reserve_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Reserve Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `warranty_reserve_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Reserve Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` SET TAGS ('dbx_pii_subdomain' = 'payables_receivables');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounts Receivable Payment ID (AR_PAYMENT_ID)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Posted By User Identifier (POSTED_BY_USER_ID)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Posted By User Identifier (POSTED_BY_USER_ID)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Payer Identifier (PAYER_ID)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bank Account Number (BANK_ACCOUNT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Bank Name (BANK_NAME)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `cash_application_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Cash Application Status (CASH_APPLICATION_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `cash_application_status` SET TAGS ('dbx_pii_value_regex' = 'unapplied|applied|partially_applied');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Channel (PAYMENT_CHANNEL)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `channel` SET TAGS ('dbx_pii_value_regex' = 'in_person|online_portal|mobile_app|batch|auto');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `clearance_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Clearance Date (CLEARANCE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CREATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217) (CURRENCY_CODE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Date (PAYMENT_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Amount Applied to Payment (DISCOUNT_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Due Date (DUE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate to Functional Currency (EXCHANGE_RATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `exchange_rate_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate Date (EXCHANGE_RATE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `gross_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Payment Amount (GROSS_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `invoice_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Cleared Invoice Number (INVOICE_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `is_partial_payment` SET TAGS ('dbx_pii_business_glossary_term' = 'Partial Payment Indicator (IS_PARTIAL_PAYMENT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `method` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Method (PAYMENT_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `method` SET TAGS ('dbx_pii_value_regex' = 'cash|check|wire|credit_card|online|eft');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Payment Amount (NET_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Reference Number (PAYMENT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `original_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Original Payment Amount in Foreign Currency (ORIGINAL_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `posting_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Timestamp (POSTING_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `remittance_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Remittance Advice Reference (REMITTANCE_REFERENCE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `source` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Source (PAYMENT_SOURCE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `source` SET TAGS ('dbx_pii_value_regex' = 'dealer|fleet|intercompany|direct_customer');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Status (PAYMENT_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_status` SET TAGS ('dbx_pii_value_regex' = 'pending|posted|cleared|rejected|void');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount Applied to Payment (TAX_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `terms_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Terms Code (PAYMENT_TERMS_CODE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `terms_code` SET TAGS ('dbx_pii_value_regex' = 'NET30|NET45|NET60');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` SET TAGS ('dbx_pii_subdomain' = 'asset_management');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_request_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Capital Expenditure Request ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_requested_by_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Requesting Employee ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_requested_by_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_requested_by_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_updated_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_updated_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_updated_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Department Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `primary_capex_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Requesting Employee ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `primary_capex_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `primary_capex_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `vendor_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Project End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `actual_spend_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Spend Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `actual_spend_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'CapEx Approval Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `approved_budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `approved_budget_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_request_date` SET TAGS ('dbx_pii_business_glossary_term' = 'CapEx Request Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_pii_value_regex' = 'straight_line|double_declining|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `depreciation_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Period (Years)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_request_description` SET TAGS ('dbx_pii_business_glossary_term' = 'CapEx Request Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `external_funding_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'External Funding Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `external_funding_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_value_regex' = 'FYd{4}');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `funding_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Funding Source');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `has_external_funding` SET TAGS ('dbx_pii_business_glossary_term' = 'External Funding Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `investment_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Investment Category (CAPEX)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `investment_category` SET TAGS ('dbx_pii_value_regex' = 'tooling|machinery|it|facility|ev_r&d|autonomous_r&d');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `irr` SET TAGS ('dbx_pii_business_glossary_term' = 'Internal Rate of Return (IRR)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `irr` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `is_capitalized` SET TAGS ('dbx_pii_business_glossary_term' = 'Capitalization Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `is_compliant` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `justification` SET TAGS ('dbx_pii_business_glossary_term' = 'Investment Justification');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `npv` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Present Value (NPV)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `npv` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'CapEx Request Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `payback_period_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Payback Period (Years)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `payback_period_years` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'CapEx Request Priority');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `procurement_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Procurement Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `procurement_method` SET TAGS ('dbx_pii_value_regex' = 'direct|tender|rfq|framework|sole_source');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `project_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Project End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `project_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Project Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `risk_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Rating (CAPEX)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `risk_rating` SET TAGS ('dbx_pii_value_regex' = 'low|moderate|high|critical');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_request_status` SET TAGS ('dbx_pii_business_glossary_term' = 'CapEx Request Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `capex_request_status` SET TAGS ('dbx_pii_value_regex' = 'draft|submitted|under_review|approved|rejected|closed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `supporting_document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Supporting Document URL');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `tax_implication` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Implication');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `title` SET TAGS ('dbx_pii_business_glossary_term' = 'CapEx Request Title');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ALTER COLUMN `wbs_element` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Plan ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `finance_project_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Project ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_value_regex' = 'percentage|fixed|formula');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_category` SET TAGS ('dbx_pii_value_regex' = 'R&D|Manufacturing|Sales|Administration|Marketing');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Plan Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `gl_account` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger Account');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `is_forecast` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Forecast');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `is_locked` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Locked');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Plan Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Plan Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `planned_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `planning_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Planning Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `planning_period` SET TAGS ('dbx_pii_value_regex' = 'FY|Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `revised_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Revised Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `scenario` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Scenario');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `scenario` SET TAGS ('dbx_pii_value_regex' = 'base|optimistic|pessimistic');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Plan Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_status` SET TAGS ('dbx_pii_value_regex' = 'draft|submitted|approved|rejected|closed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Plan Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `budget_plan_type` SET TAGS ('dbx_pii_value_regex' = 'operating|capital|headcount|forecast|revised');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Version Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `budget_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `budget_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Header Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_value_regex' = 'percentage|fixed|activity_based');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `amount_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `amount_type` SET TAGS ('dbx_pii_value_regex' = 'planned|revised|committed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Line Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `business_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Business Unit');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Line Comments');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `budget_line_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Line Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `is_manual` SET TAGS ('dbx_pii_business_glossary_term' = 'Manual Entry Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `justification` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Line Justification');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `planned_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `product_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Product Line');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Line Quantity');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `revised_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Revised Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `budget_line_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Line Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `budget_line_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|closed|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_line` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Version Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` SET TAGS ('dbx_pii_subdomain' = 'cost_profitability');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `manufacturing_cost_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Cost Record ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `actual_energy_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Energy Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `actual_fixed_overhead_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Fixed Overhead Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `actual_labor_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Labor Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `actual_material_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Material Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `actual_scrap_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Scrap Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `actual_tooling_amortization_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Tooling Amortization Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `actual_variable_overhead_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Variable Overhead Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `calculation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Calculation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `costing_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Costing Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `costing_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Costing Version');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `is_variance_exceed_threshold` SET TAGS ('dbx_pii_business_glossary_term' = 'Variance Exceeds Threshold Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `record_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Record Number (CRN)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `standard_energy_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Energy Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `standard_fixed_overhead_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Fixed Overhead Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `standard_labor_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Labor Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `standard_material_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Material Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `standard_scrap_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Scrap Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `standard_tooling_amortization_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Tooling Amortization Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `standard_variable_overhead_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Variable Overhead Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `manufacturing_cost_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Record Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `manufacturing_cost_status` SET TAGS ('dbx_pii_value_regex' = 'draft|posted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `total_actual_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Actual Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `total_standard_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Standard Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `variance_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Variance Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `variance_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Variance Percent');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `variance_threshold_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Variance Threshold Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `vehicle_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Line');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ALTER COLUMN `vehicle_model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` SET TAGS ('dbx_pii_subdomain' = 'cost_profitability');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_reserve_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Reserve Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `accounting_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounting Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `accounting_period` SET TAGS ('dbx_pii_value_regex' = 'Q1|Q2|Q3|Q4|FY');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `accrual_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Basis');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `accrual_basis` SET TAGS ('dbx_pii_value_regex' = 'units_sold|percentage|fixed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `actuarial_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actuarial Review Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `adequacy_ratio` SET TAGS ('dbx_pii_business_glossary_term' = 'Reserve Adequacy Ratio');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Reserve Amount (Gross)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `audit_trail_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Trail Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `balance` SET TAGS ('dbx_pii_business_glossary_term' = 'Reserve Balance (Net)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `claims_charged` SET TAGS ('dbx_pii_business_glossary_term' = 'Claims Charged Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_reserve_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Reserve Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `estimated_cost_per_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Cost Per Unit');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `is_ifrs_compliant` SET TAGS ('dbx_pii_business_glossary_term' = 'IFRS Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `is_sox_controlled` SET TAGS ('dbx_pii_business_glossary_term' = 'SOX Controlled Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `last_actuarial_update_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Actuarial Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Reserve Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `regulatory_reporting_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Reporting Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `source` SET TAGS ('dbx_pii_business_glossary_term' = 'Reserve Source');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `source` SET TAGS ('dbx_pii_value_regex' = 'accrual|adjustment|reversal');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_reserve_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Reserve Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_reserve_status` SET TAGS ('dbx_pii_value_regex' = 'active|closed|adjusted|pending_review');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `units_sold` SET TAGS ('dbx_pii_business_glossary_term' = 'Units Sold');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `vehicle_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Line (Model)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_claims_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Claims Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_claims_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Claims Count');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ALTER COLUMN `warranty_type` SET TAGS ('dbx_pii_value_regex' = 'basic|powertrain|ev_battery|extended');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` SET TAGS ('dbx_pii_subdomain' = 'cost_profitability');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` ALTER COLUMN `finance_inventory_valuation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for finance_inventory_valuation');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_inventory_valuation` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` SET TAGS ('dbx_pii_subdomain' = 'asset_management');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fixed Asset Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_pii_business_glossary_term' = 'Accumulated Depreciation');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `capitalized_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Capitalized Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `class` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Class');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `condition` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Condition');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `condition` SET TAGS ('dbx_pii_value_regex' = 'new|good|fair|poor|scrapped');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `condition_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Condition Rating');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_pii_value_regex' = 'straight_line|declining_balance|units_of_production');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `depreciation_rate_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `fixed_asset_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `disposal_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposal Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `insurance_coverage_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Insurance Coverage Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Insurance Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `maintenance_schedule` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Schedule');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `manufacturer` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `model` SET TAGS ('dbx_pii_business_glossary_term' = 'Model');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `fixed_asset_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `net_book_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Book Value');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `next_inspection_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `responsible_department` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `retirement_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Retirement Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `fixed_asset_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `fixed_asset_status` SET TAGS ('dbx_pii_value_regex' = 'in_service|retired|under_maintenance|disposed|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `tag` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `tax_depreciation_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Depreciation Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `fixed_asset_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `warranty_provider` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Provider');
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` SET TAGS ('dbx_pii_subdomain' = 'asset_management');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_run_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Run ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger Account ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_area` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Area');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_area` SET TAGS ('dbx_pii_value_regex' = 'book|tax|ifrs|statutory');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_pii_value_regex' = 'straight_line|declining_balance|sum_of_years|units_of_production');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `is_test_run` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Run Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Run Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `number_of_assets_processed` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Assets Processed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `posting_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'GL Posting Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `remarks` SET TAGS ('dbx_pii_business_glossary_term' = 'Run Remarks');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_run_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Run Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_run_status` SET TAGS ('dbx_pii_value_regex' = 'planned|in_progress|completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `status_detail` SET TAGS ('dbx_pii_business_glossary_term' = 'Run Status Detail');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Run Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `total_depreciation_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Depreciation Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_run_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Depreciation Run Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `depreciation_run_type` SET TAGS ('dbx_pii_value_regex' = 'periodic|year_end|ad_hoc');
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_settlement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Settlement ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger Account ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_group_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Group ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_loan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Intercompany Loan ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `amount_gross` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Settlement Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `amount_net` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Settlement Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `amount_tax` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Comments');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_settlement_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `is_approved` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `netting_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Netting Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Settlement Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `receiving_company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Receiving Company Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|matched|unmatched|exception');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `sending_company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Sending Company Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `source_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_settlement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_settlement_status` SET TAGS ('dbx_pii_value_regex' = 'draft|open|posted|cleared|cancelled');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `target_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `transaction_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Transaction Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `transfer_price_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Price Basis');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `transfer_price_basis` SET TAGS ('dbx_pii_value_regex' = 'cost|market|list|custom');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_settlement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `intercompany_settlement_type` SET TAGS ('dbx_pii_value_regex' = 'transfer_pricing|service_charge|royalty|management_fee|intercompany_loan|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Allocation Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocation_cycle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Cycle Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `activity_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Activity Quantity');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocated Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Element Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_allocation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_allocation_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Allocation Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `method` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `method` SET TAGS ('dbx_pii_value_regex' = 'fixed_percentage|activity_based|statistical_key_figure');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `receiver_cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Receiver Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `sender_cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Sender Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `statistical_key_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Key Figure Value');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_allocation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `cost_allocation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|posted|reversed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_posting_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Posting Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_posting_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Posting Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `line_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `source_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `source_document_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Document Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `source_document_type` SET TAGS ('dbx_pii_value_regex' = 'invoice|credit_note|payment|adjustment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_posting_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Posting Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_posting_status` SET TAGS ('dbx_pii_value_regex' = 'posted|reversed|pending|cancelled');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_base_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Base Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_exempt_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Exempt Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_rate_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Rate Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_rate_type` SET TAGS ('dbx_pii_value_regex' = 'standard|reduced|zero|special');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_reporting_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Reporting Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_return_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Return Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `tax_type` SET TAGS ('dbx_pii_value_regex' = 'input_vat|output_vat|withholding|excise');
ALTER TABLE `vibe_automotive_v1`.`finance`.`tax_posting` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_related_dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger (GL) Account Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `finance_project_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Project Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Vehicle Identifier (VIN)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Amount (Monetary Value)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `audit_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit User Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Basis (e.g., Estimated, Actual, Forecast, Adjustment)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `basis` SET TAGS ('dbx_pii_value_regex' = 'estimated|actual|forecast|adjustment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `is_manual` SET TAGS ('dbx_pii_business_glossary_term' = 'Manual Entry Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `is_tax_relevant` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Relevance Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `period_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Period End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `reversal_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Reversal Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_status` SET TAGS ('dbx_pii_value_regex' = 'pending|posted|reversed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `supporting_document_ref` SET TAGS ('dbx_pii_business_glossary_term' = 'Supporting Document Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `tax_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Type (e.g., Warranty, Rebate, Bonus, Tooling, Dealer Incentive, Other)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `accrual_type` SET TAGS ('dbx_pii_value_regex' = 'warranty|rebate|bonus|tooling|dealer_incentive|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_rate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Rate ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `company_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `company_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_from` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_to` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_to` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_rate_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Rate Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_rate_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Rate Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_value_regex' = '^d{4}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `is_historical` SET TAGS ('dbx_pii_business_glossary_term' = 'Historical Rate Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `period` SET TAGS ('dbx_pii_business_glossary_term' = 'Financial Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `period` SET TAGS ('dbx_pii_value_regex' = '^d{2}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `source` SET TAGS ('dbx_pii_business_glossary_term' = 'Rate Source');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `source` SET TAGS ('dbx_pii_value_regex' = 'ECB|Bloomberg|Internal_Treasury');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_rate_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `currency_rate_type` SET TAGS ('dbx_pii_value_regex' = 'spot|average|period_end|planning');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `value` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate Value');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `valid_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`currency_rate` ALTER COLUMN `valid_to` SET TAGS ('dbx_pii_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Breakdown Structure (WBS) Element ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `parent_wbs_wbs_element_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent WBS Element ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Person ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `finance_project_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Project Definition ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_responsible_person_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Person ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_responsible_person_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_responsible_person_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `accounting_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounting Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `accounting_status` SET TAGS ('dbx_pii_value_regex' = 'open|posted|reversed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `actual_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `committed_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Committed Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `external_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'External Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `investment_program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Investment Program Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `is_capex` SET TAGS ('dbx_pii_business_glossary_term' = 'Is CapEx');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `is_r_and_d` SET TAGS ('dbx_pii_business_glossary_term' = 'Is R&D');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `milestone_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `planned_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `plant_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Location');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `project_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Project Phase');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `project_phase` SET TAGS ('dbx_pii_value_regex' = 'initiation|planning|execution|monitoring|closure');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_status` SET TAGS ('dbx_pii_business_glossary_term' = 'WBS Element Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_element_status` SET TAGS ('dbx_pii_value_regex' = 'planned|active|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Breakdown Structure (WBS) Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_hierarchy_path` SET TAGS ('dbx_pii_business_glossary_term' = 'WBS Hierarchy Path');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Breakdown Structure (WBS) Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Breakdown Structure (WBS) Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_type` SET TAGS ('dbx_pii_business_glossary_term' = 'WBS Element Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `wbs_type` SET TAGS ('dbx_pii_value_regex' = 'capex|r_and_d|maintenance|operational');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `financial_period_close_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Financial Period Close ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `approver_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `blocking_issue_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Blocking Issue Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Close Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `gross_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `is_audit_evidence` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Evidence Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `lock_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Lock Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Completion Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `responsible_team` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Team');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `financial_period_close_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Close Task Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `financial_period_close_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|completed|blocked');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `task_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Close Task Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `task_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Close Task Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `task_type` SET TAGS ('dbx_pii_value_regex' = 'depreciation|accrual|intercompany|inventory|fx|cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` SET TAGS ('dbx_pii_subdomain' = 'cost_profitability');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `dealer_incentive_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Incentive ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Identifier (Dealer_ID)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `accounting_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounting Period Identifier (Accounting_Period)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `accrual_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrual Basis (Accrual_Basis)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `accrual_basis` SET TAGS ('dbx_pii_value_regex' = 'cash|accrual');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `actual_payment_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Payment Amount (Actual_Payment_Amount)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `actual_units_accrued` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Units Accrued (Actual_Units)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `amount_per_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Incentive Amount Per Unit (IAPU)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `audit_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit User Identifier (Audit_User)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `budget_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Version (Budget_Version)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `dealer_incentive_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Incentive Category (Incentive_Category)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (Created_Timestamp)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO_4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `dealer_incentive_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Description (Description)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Eligibility Criteria Description (Eligibility_Criteria)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Effective End Date (Effective_End_Date)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_pii_business_glossary_term' = 'General Ledger Account Code (GL_Account_Code)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `is_taxable` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Incentive Taxable (Is_Taxable)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `max_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Units Eligible (Max_Units)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes (Notes)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Date (Payment_Date)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Method (Payment_Method)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_value_regex' = 'electronic|check|wire|direct_deposit');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Reference Number (Payment_Reference)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Status (Payment_Status)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_status` SET TAGS ('dbx_pii_value_regex' = 'pending|paid|failed|reversed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_trigger_threshold` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Trigger Threshold (PTT_Threshold)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_trigger_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Trigger Type (PTT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `payment_trigger_type` SET TAGS ('dbx_pii_value_regex' = 'volume_threshold|otd_performance|nps_score|time_based');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Incentive Program Code (DIPC)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `program_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Incentive Program Name (DIPN)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `program_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Incentive Program Type (DIPT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `program_type` SET TAGS ('dbx_pii_value_regex' = 'volume_bonus|holdback|floor_plan|marketing_coop|rebate|incentive');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code (ISO_3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Effective Start Date (Effective_Start_Date)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `dealer_incentive_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Incentive Program Status (DIPS)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `dealer_incentive_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|closed|pending|suspended');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `tax_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Rate Percentage (Tax_Rate)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `total_budget` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Program Budget (TPB)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated By User (Updated_By)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp (Updated_Timestamp)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ALTER COLUMN `vehicle_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Line (Vehicle_Line)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` SET TAGS ('dbx_pii_subdomain' = 'cost_profitability');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_profitability_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Profitability Record ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `primary_vehicle_dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_customer_party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `actual_manufacturing_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Manufacturing Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `ebitda_contribution` SET TAGS ('dbx_pii_business_glossary_term' = 'EBITDA Contribution');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `emission_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Rating');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_pii_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_value_regex' = 'EV|HEV|PHEV|ICE|Hybrid');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `gross_margin` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Margin');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `gross_revenue_msrp` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Revenue (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `is_eligible_for_subsidy` SET TAGS ('dbx_pii_business_glossary_term' = 'Subsidy Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `net_contribution_margin` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Contribution Margin');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `net_revenue` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Revenue');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `sales_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `sales_channel` SET TAGS ('dbx_pii_value_regex' = 'Dealer|Direct|Online|Fleet|Wholesale');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `selling_distribution_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Selling & Distribution Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `standard_manufacturing_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Manufacturing Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_profitability_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_profitability_status` SET TAGS ('dbx_pii_value_regex' = 'active|closed|reversed|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `subsidy_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Subsidy Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `transaction_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_category` SET TAGS ('dbx_pii_value_regex' = 'Passenger|Commercial|Luxury|Performance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_height_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Height (mm)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_length_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Length (mm)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Line');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_width_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Width (mm)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `warranty_miles` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Mileage Limit');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `warranty_reserve_charge` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Reserve Charge');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `warranty_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Period (Years)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_project` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_project` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_project` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` SET TAGS ('dbx_pii_subdomain' = 'payables_receivables');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `payment_settlement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Settlement Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `invoice_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Counterparty Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `reversed_payment_settlement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversed Payment Settlement Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `reversed_payment_settlement_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `adjustment_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Approved By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `batch_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Batch Sequence');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `payment_settlement_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Channel');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `comment` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Comment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `counterparty_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Counterparty Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `payment_settlement_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Due Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `external_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement External Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `fee_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Fee Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `gross_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `is_cross_border` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Cross Border');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `is_manual_settlement` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Manual Settlement');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `legal_entity_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Legal Entity Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `method` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `original_currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Original Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `payment_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Priority');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `processed_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Processed Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `project_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Project Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Reason Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `reconciliation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Reconciliation Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `payment_settlement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `payment_settlement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Version');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Created By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `intercompany_group_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Group Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `parent_intercompany_group_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Intercompany Group Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `parent_intercompany_group_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Legal Entity Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `intercompany_group_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Group Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `consolidation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Consolidation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `intercompany_group_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `external_reference_number` SET TAGS ('dbx_pii_business_glossary_term' = 'External Reference Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `intercompany_accounting_rule` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Accounting Rule');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `is_cross_border` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Cross Border');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `is_taxable` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Taxable');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `intercompany_group_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Group Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `next_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `reporting_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Currency');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `secondary_legal_entity_ids` SET TAGS ('dbx_pii_business_glossary_term' = 'Secondary Legal Entity Ids');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `intercompany_group_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `tax_regime` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Regime');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `intercompany_group_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Group Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_group` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Cycle Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `previous_allocation_cycle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Previous Allocation Cycle Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `previous_allocation_cycle_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `actual_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Basis');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `is_current` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Current');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `period_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Period Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `allocation_cycle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`allocation_cycle` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `intercompany_loan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Intercompany Loan Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `company_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Borrower Company Company Code Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `primary_company_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Company Code Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `refinanced_intercompany_loan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Refinanced Intercompany Loan Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `refinanced_intercompany_loan_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `accounting_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounting Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `accrued_interest` SET TAGS ('dbx_pii_business_glossary_term' = 'Accrued Interest');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `agreement_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Loan Agreement Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `amortization_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Amortization Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `intercompany_loan_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Loan Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `collateral_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Collateral Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `collateral_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Collateral Value');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `covenant_details` SET TAGS ('dbx_pii_business_glossary_term' = 'Covenant Details');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `default_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Default Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `default_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Default Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `early_termination_fee` SET TAGS ('dbx_pii_business_glossary_term' = 'Early Termination Fee');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `exchange_rate_at_inception` SET TAGS ('dbx_pii_business_glossary_term' = 'Exchange Rate At Inception');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `guarantee_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Guarantee Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `interest_accrual_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Interest Accrual Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `interest_cap` SET TAGS ('dbx_pii_business_glossary_term' = 'Interest Cap');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `interest_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Interest Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `interest_rate_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Interest Rate Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `internal_audit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Internal Audit Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `is_cross_border` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Cross Border');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Payment Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `legal_document_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Legal Document Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `next_payment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Payment Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `payment_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `principal_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Principal Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `principal_outstanding` SET TAGS ('dbx_pii_business_glossary_term' = 'Principal Outstanding');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `purpose` SET TAGS ('dbx_pii_business_glossary_term' = 'Loan Purpose');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `repayment_frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Repayment Frequency');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `restructuring_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Restructuring Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `restructuring_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Restructuring Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `intercompany_loan_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Loan Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `tax_implication` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Implication');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `term_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Term Months');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `total_outstanding` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Outstanding');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `intercompany_loan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Loan Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_loan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` SET TAGS ('dbx_pii_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Legal Entity Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `parent_legal_entity_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Legal Entity Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_ultimate_parent_legal_entity_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Ultimate Parent Legal Entity Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `country_of_incorporation` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Of Incorporation');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `data_privacy_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Privacy Classification');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `legal_entity_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `fiscal_year_end_month` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year End Month');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `industry_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Industry Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `is_public_company` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Public Company');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `legal_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Legal Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `market_capitalization` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Capitalization');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `number_of_employees` SET TAGS ('dbx_pii_business_glossary_term' = 'Number Of Employees');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Contact Email');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_contact_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `sox_control_owner` SET TAGS ('dbx_pii_business_glossary_term' = 'Sox Control Owner');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_business_glossary_term' = 'State Province');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `legal_entity_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `status_change_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Status Change Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Id');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `tax_residency_country` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Residency Country');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `termination_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `trade_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `legal_entity_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Entity Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ALTER COLUMN `website_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Website Url');
