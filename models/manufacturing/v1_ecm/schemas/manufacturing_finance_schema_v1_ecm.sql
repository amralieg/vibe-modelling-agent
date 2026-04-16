-- Schema for Domain: finance | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:33

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`finance` COMMENT 'SSOT for all financial data including general ledger, cost centers, cost accounting, COGS, EBITDA reporting, CAPEX/OPEX tracking, accounts payable/receivable, budgeting, multi-currency consolidation, and statutory reporting. Supports IFRS and GAAP compliance across all legal entities and geographies.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` (
    `chart_of_accounts_id` BIGINT COMMENT 'Unique surrogate key identifying each general ledger account record in the chart of accounts master. Used as the primary key for all downstream joins and references within the finance domain.',
    `account_category` STRING COMMENT 'Indicates which primary financial statement the account feeds into: balance sheet (assets, liabilities, equity), income statement (revenue, expense), cash flow statement, or statistical (non-financial tracking). Supports automated financial statement generation.. Valid values are `balance_sheet|income_statement|cash_flow|statistical`',
    `account_group` STRING COMMENT 'The account group classification used to organize GL accounts into logical groupings for number range assignment, field selection, and reporting hierarchy. Corresponds to SAP field KTOKS defining account group.. Valid values are `^[A-Z0-9]{1,10}$`',
    `account_hierarchy_level` STRING COMMENT 'The numeric level of this account within the financial reporting hierarchy (e.g., level 1 = major category, level 2 = sub-category, level 3 = detailed account). Supports drill-down financial reporting and rollup aggregations.. Valid values are `^[1-9][0-9]?$`',
    `account_long_name` STRING COMMENT 'The full descriptive name or long text of the general ledger account providing complete context for the account purpose. Corresponds to SAP field TXT50 (long text).',
    `account_name` STRING COMMENT 'The short descriptive name of the general ledger account as defined in the chart of accounts. Used in financial reports, trial balances, and ERP display. Corresponds to SAP field TXT20 (short text).',
    `account_number` STRING COMMENT 'The alphanumeric code assigned to the general ledger account within the chart of accounts. This is the primary business identifier used in journal entries, financial statements, and ERP transactions. Corresponds to SAP GL account number (SAKNR).. Valid values are `^[A-Z0-9-]{1,20}$`',
    `account_type` STRING COMMENT 'The fundamental financial classification of the account indicating its role in the financial statements: asset, liability, equity, revenue, or expense. Drives debit/credit behavior and financial statement placement.. Valid values are `asset|liability|equity|revenue|expense`',
    `alternative_account_number` STRING COMMENT 'The alternative account number used for local statutory reporting, mapping the group chart of accounts entry to the country-specific statutory chart of accounts. Supports multi-chart configurations for local GAAP versus group IFRS reporting.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `balance_in_local_currency_only` BOOLEAN COMMENT 'Indicates whether the account balance is managed only in local (company code) currency, suppressing foreign currency balance tracking. Typically set for tax accounts and clearing accounts.. Valid values are `true|false`',
    `blocked_for_posting` BOOLEAN COMMENT 'Indicates whether this account is blocked from receiving new journal entry postings. Blocked accounts are typically inactive, under review, or retired accounts that should not accept new transactions.. Valid values are `true|false`',
    `capex_opex_indicator` STRING COMMENT 'Classifies the account as relating to capital expenditure (CAPEX - investment in long-term assets) or operational expenditure (OPEX - day-to-day operating costs). Critical for CAPEX/OPEX tracking, budgeting, and EBITDA reporting in Manufacturing.. Valid values are `capex|opex|not_applicable`',
    `code` STRING COMMENT 'The identifier of the chart of accounts plan to which this account belongs. Manufacturing may maintain multiple charts (e.g., group IFRS chart, local statutory chart per country). Corresponds to SAP field KTOPL.. Valid values are `^[A-Z0-9]{1,10}$`',
    `cogs_indicator` BOOLEAN COMMENT 'Indicates whether this account contributes to the Cost of Goods Sold (COGS) calculation. Used to identify and aggregate all manufacturing cost accounts for gross margin and COGS reporting in income statements.. Valid values are `true|false`',
    `consolidation_account` STRING COMMENT 'The group-level consolidation account number to which this local chart of accounts entry maps during intercompany elimination and group financial consolidation. Enables multi-entity consolidation across Manufacturing legal entities.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `consolidation_group` STRING COMMENT 'The consolidation group or reporting unit to which this account is assigned for group financial reporting. Supports multi-level consolidation hierarchies across Manufacturings global legal entity structure.',
    `cost_element_category` STRING COMMENT 'Indicates whether this GL account is linked to a primary cost element (direct costs posted from FI to CO), secondary cost element (internal allocations within CO), or not applicable. Critical for COGS, EBITDA, and cost center accounting in SAP Controlling.. Valid values are `primary|secondary|not_applicable`',
    `cost_element_type` STRING COMMENT 'The cost element type classification used in SAP Controlling to categorize the nature of costs or revenues flowing through this account. Supports COGS analysis, overhead allocation, and EBITDA reporting.. Valid values are `material_costs|personnel_costs|depreciation|external_services|overhead|revenue|statistical|not_applicable`',
    `created_date` DATE COMMENT 'The date on which this chart of accounts entry was originally created in the system. Provides audit trail for account master data governance and SOX compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `currency_code` STRING COMMENT 'The ISO 4217 currency code in which this account is managed. For accounts with a specific currency assignment, postings are restricted to that currency. Blank indicates the account accepts all currencies (company code currency applies).. Valid values are `^[A-Z]{3}$`',
    `ebitda_line` STRING COMMENT 'Maps this account to a specific line in the EBITDA bridge or management P&L reporting structure. Enables automated EBITDA calculation and management reporting for Manufacturings financial performance analysis.. Valid values are `revenue|cogs|gross_profit|operating_expense|ebitda|depreciation|amortization|interest|tax|not_applicable`',
    `field_status_group` STRING COMMENT 'The field status group assigned to this account that controls which fields are required, optional, or suppressed during document entry. Enforces data quality and completeness rules for postings to this account.. Valid values are `^[A-Z0-9]{1,4}$`',
    `financial_statement_item` STRING COMMENT 'The specific line item or caption on the published financial statement (e.g., Trade Receivables, Property Plant and Equipment, Cost of Goods Sold) to which this GL account maps. Enables automated financial statement population and IFRS/GAAP disclosure.',
    `functional_area` STRING COMMENT 'The functional area to which this account is assigned for cost-of-sales accounting and segment reporting. Enables income statement presentation by function of expense (e.g., manufacturing, R&D, G&A) as required under IFRS IAS 1.. Valid values are `manufacturing|sales_and_distribution|research_and_development|general_and_administrative|procurement|logistics|not_assigned`',
    `gaap_classification` STRING COMMENT 'The US GAAP ASC topic or classification code assigned to this account for entities reporting under US GAAP. Supports dual-reporting environments where Manufacturing entities must comply with both IFRS and US GAAP.',
    `ifrs_classification` STRING COMMENT 'The IFRS standard or taxonomy classification code assigned to this account for group consolidation and statutory reporting under IFRS (e.g., IAS 16 PP&E, IAS 2 Inventories, IFRS 15 Revenue). Supports IFRS taxonomy mapping for XBRL reporting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to this chart of accounts record. Supports change tracking, data lineage, and audit trail requirements for financial master data governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `line_item_display` BOOLEAN COMMENT 'Indicates whether individual line items posted to this account are stored and displayable for audit and reconciliation purposes. When enabled, all individual postings are retained for drill-down reporting.. Valid values are `true|false`',
    `normal_balance` STRING COMMENT 'Indicates whether the account normally carries a debit or credit balance. Assets and expenses normally carry debit balances; liabilities, equity, and revenue normally carry credit balances. Used for automated variance detection and trial balance validation.. Valid values are `debit|credit`',
    `open_item_management` BOOLEAN COMMENT 'Indicates whether open item management is activated for this account, requiring individual line items to be matched and cleared (e.g., GR/IR clearing accounts, bank clearing accounts). Supports accounts payable/receivable reconciliation.. Valid values are `true|false`',
    `posting_without_tax_allowed` BOOLEAN COMMENT 'Indicates whether journal entry postings to this account are permitted without a tax code. When false, a tax code is mandatory for all postings, enforcing tax compliance controls.. Valid values are `true|false`',
    `profit_loss_indicator` STRING COMMENT 'Indicates whether the account is a profit and loss account (income statement) or a balance sheet account. Determines year-end closing behavior — P&L accounts are closed to retained earnings; balance sheet accounts carry forward.. Valid values are `profit_and_loss|balance_sheet`',
    `reconciliation_account_type` STRING COMMENT 'Identifies if this GL account serves as a reconciliation account for a subledger (accounts receivable, accounts payable, fixed assets). Reconciliation accounts cannot be posted to directly; they are updated automatically from subledger transactions.. Valid values are `accounts_receivable|accounts_payable|fixed_assets|not_reconciliation`',
    `sort_key` STRING COMMENT 'The sort key code that determines which document field is automatically populated in the assignment field of line items posted to this account. Used for sorting and grouping line items in account statements and open item lists.. Valid values are `^[0-9]{3}$`',
    `status` STRING COMMENT 'The current lifecycle status of the chart of accounts entry. Active accounts are available for posting; inactive accounts are not in use; blocked accounts are temporarily restricted; retired accounts are permanently closed.. Valid values are `active|inactive|blocked|pending_approval|retired`',
    `tax_category` STRING COMMENT 'Specifies the tax relevance of the account: input tax (deductible VAT on purchases), output tax (VAT on sales), tax account (for posting tax amounts), or not relevant. Controls tax code entry requirements during document posting.. Valid values are `input_tax|output_tax|not_relevant|tax_account`',
    `valid_from_date` DATE COMMENT 'The date from which this account is valid and available for use in financial postings. Supports time-dependent account management and ensures accounts are only used within their authorized validity period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'The date until which this account is valid for financial postings. After this date, the account is automatically blocked for new postings. Supports account lifecycle management and controlled retirement of obsolete accounts.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_chart_of_accounts PRIMARY KEY(`chart_of_accounts_id`)
) COMMENT 'Authoritative master list of all general ledger account codes used across Manufacturing legal entities. Defines account number, account name, account type (asset, liability, equity, revenue, expense), financial statement line mapping, IFRS/GAAP classification, cost element linkage, and consolidation group assignment. Supports multi-chart configurations for local statutory versus group IFRS reporting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`controlling_area` (
    `controlling_area_id` BIGINT COMMENT 'Unique surrogate identifier for the controlling area record in the lakehouse silver layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: controlling_area.chart_of_accounts (STRING) is a denormalized reference to the chart_of_accounts master. A controlling area is configured with a specific chart of accounts for cost accounting. Adding ',
    `activity_type_active` BOOLEAN COMMENT 'Indicates whether activity type accounting is activated for this controlling area. When true, cost centers can record and allocate costs based on activity quantities (e.g., machine hours, labor hours), enabling activity-based costing and product cost calculation.. Valid values are `true|false`',
    `allocation_method` STRING COMMENT 'Default internal cost allocation method configured for this controlling area. Governs how overhead costs are distributed across cost centers, orders, and profit centers. Options include assessment (with secondary cost elements), distribution (with primary cost elements), indirect activity allocation, and template allocation.. Valid values are `assessment|distribution|indirect_activity_allocation|template_allocation`',
    `capex_budget_profile` STRING COMMENT 'Identifier of the CAPEX budget profile assigned to this controlling area, defining the rules for capital expenditure budgeting, availability control, and tolerance limits for investment orders and WBS elements. Supports CAPEX governance and IFRS IAS 16 compliance.',
    `co_version` STRING COMMENT 'Default controlling version used for plan/actual comparisons within this controlling area. Version 0 is the standard actual version; other versions (e.g., 1, 2) represent planning versions for budget scenarios, forecasts, or what-if analyses.. Valid values are `^[0-9]{1,3}$`',
    `code` STRING COMMENT 'Alphanumeric code uniquely identifying the controlling area within SAP CO. Typically a 1-4 character uppercase code (e.g., CO01, AMER). This is the business key used in all CO transactions and cost accounting documents.. Valid values are `^[A-Z0-9]{1,4}$`',
    `company_code_assignment_type` STRING COMMENT 'SAP assignment type governing how company codes are linked to the controlling area. Value 1 = controlling area and company codes use the same fiscal year variant and chart of accounts; Value 2 = company codes may have different fiscal year variants (cross-company code controlling).. Valid values are `1|2`',
    `copa_type` STRING COMMENT 'Type of Profitability Analysis configured for this controlling area. costing_based uses value fields for flexible margin analysis; account_based aligns with G/L accounts for IFRS-compliant segment reporting; both enables parallel CO-PA for comprehensive profitability management.. Valid values are `costing_based|account_based|both`',
    `cost_center_standard_hierarchy` STRING COMMENT 'Name or identifier of the standard hierarchy for cost centers within this controlling area. The standard hierarchy defines the top-level grouping structure for all cost centers, enabling hierarchical cost reporting, allocation cycles, and management reporting roll-ups.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code representing the primary country of the controlling area. Used for statutory reporting, regulatory compliance, and geographic segmentation in management reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the controlling area master record was first created in the source system (SAP CO). Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the controlling area currency used for all internal cost accounting, profitability analysis, and management reporting within this controlling area (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `currency_type` STRING COMMENT 'SAP currency type code defining the role of the controlling area currency in multi-currency accounting. Standard values: 10=Company Code Currency, 20=Controlling Area Currency, 30=Group Currency, 40=Hard Currency, 50=Index-Based Currency, 60=Global Company Currency. Governs how currency translation is applied in CO documents.. Valid values are `10|20|30|40|50|60`',
    `description` STRING COMMENT 'Extended free-text description of the controlling area, providing additional context about its organizational scope, geographic coverage, or business purpose beyond the short name field.',
    `fiscal_year_variant` STRING COMMENT 'SAP fiscal year variant code (e.g., K4 for calendar year, V3 for April-March) that defines the fiscal year structure — number of posting periods, special periods, and period-to-calendar-month mapping — applied across all company codes assigned to this controlling area.. Valid values are `^[A-Z0-9]{2}$`',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the corporate group reporting currency used in consolidated financial statements and group-level management reporting (e.g., USD for a US-headquartered multinational). Supports multi-currency consolidation under IFRS and GAAP.. Valid values are `^[A-Z]{3}$`',
    `language_key` STRING COMMENT 'ISO 639-1 two-letter language code representing the primary language used for text descriptions, reports, and correspondence within this controlling area (e.g., EN for English, DE for German, ZH for Chinese). Supports multi-language operations in multinational environments.. Valid values are `^[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the controlling area master record in the source system. Supports change detection, incremental data loading, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `local_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the local (functional) currency of the primary legal entity or region associated with this controlling area. Used for statutory reporting and local tax compliance.. Valid values are `^[A-Z]{3}$`',
    `name` STRING COMMENT 'Full descriptive name of the controlling area as configured in SAP CO. Used in reports, dashboards, and management accounting outputs to identify the organizational scope of cost accounting.',
    `number_of_posting_periods` STRING COMMENT 'Total number of regular posting periods defined for the fiscal year variant of this controlling area (typically 12 for calendar-year companies, 13 for 4-4-5 fiscal calendars). Determines the granularity of period-based cost reporting.. Valid values are `^(12|13|14|16)$`',
    `number_of_special_periods` STRING COMMENT 'Number of special (adjustment) posting periods beyond the regular periods, used for year-end closing adjustments, audit corrections, and statutory adjustments. Typically 1-4 special periods are configured.. Valid values are `^[0-4]$`',
    `order_management_active` BOOLEAN COMMENT 'Indicates whether internal order management (CO-OPA) is activated for this controlling area. When true, internal orders can be used to collect and settle costs for specific projects, campaigns, or capital expenditure requests.. Valid values are `true|false`',
    `plan_version` STRING COMMENT 'Primary planning version identifier used for budget and forecast postings within this controlling area. Enables separation of plan data from actuals and supports multi-scenario financial planning (e.g., base plan, revised forecast, stretch target).. Valid values are `^[0-9]{1,3}$`',
    `product_cost_controlling_active` BOOLEAN COMMENT 'Indicates whether Product Cost Controlling (CO-PC) is activated for this controlling area. When true, standard cost estimates, work-in-progress (WIP) calculations, and variance analysis for manufactured products are enabled.. Valid values are `true|false`',
    `profit_center_accounting_active` BOOLEAN COMMENT 'Indicates whether Profit Center Accounting (CO-PCA) is activated for this controlling area. When true, all CO postings are simultaneously updated in profit center ledgers, enabling segment-level P&L and balance sheet reporting.. Valid values are `true|false`',
    `profit_center_standard_hierarchy` STRING COMMENT 'Name or identifier of the standard hierarchy for profit centers within this controlling area. Defines the organizational structure for profit center accounting, enabling segment-level profitability reporting and internal P&L analysis.',
    `profitability_analysis_active` BOOLEAN COMMENT 'Indicates whether Profitability Analysis (CO-PA) is activated for this controlling area. When true, revenues and costs are analyzed by market segments (e.g., customer, product, region) to support EBITDA reporting and contribution margin analysis.. Valid values are `true|false`',
    `region_code` STRING COMMENT 'Internal organizational region code (e.g., AMER, EMEA, APAC) to which this controlling area belongs. Supports regional management reporting, cost allocation hierarchies, and geographic profitability analysis.',
    `settlement_profile` STRING COMMENT 'Default settlement profile for this controlling area, defining the rules for settling costs from internal orders, WBS elements, and production orders to receivers (cost centers, G/L accounts, assets, profitability segments). Critical for period-end closing.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this controlling area master data was sourced (e.g., SAP_S4HANA_PROD, SAP_S4HANA_EU). Supports multi-system data lineage and reconciliation in the lakehouse.',
    `status` STRING COMMENT 'Current operational status of the controlling area. active indicates the area is live and accepting CO postings; inactive indicates it is suspended; decommissioned indicates it has been retired from use.. Valid values are `active|inactive|under_review|decommissioned`',
    `time_zone` STRING COMMENT 'IANA time zone identifier (e.g., America/New_York, Europe/Berlin) for the controlling area, used to correctly interpret period-end closing timestamps, posting cutoff times, and scheduling of CO batch jobs across global operations.',
    `transfer_price_variant` STRING COMMENT 'Identifier of the transfer price variant configured for this controlling area, governing how intercompany and intra-company goods and service transfers are priced for internal cost accounting and profit center reporting. Supports arms-length pricing compliance.',
    `type` STRING COMMENT 'Indicates whether the controlling area spans multiple company codes (cross-company) or is assigned to a single company code (single-company). Cross-company controlling areas enable unified cost accounting across legal entities within a multinational group.. Valid values are `cross_company|single_company`',
    `valid_from_date` DATE COMMENT 'The date from which this controlling area configuration is effective and active for CO postings. Supports temporal validity tracking and historical configuration management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'The date until which this controlling area configuration remains effective. A null or maximum date (9999-12-31) indicates the configuration is open-ended and currently active.. Valid values are `^d{4}-d{2}-d{2}$`',
    `variance_key` STRING COMMENT 'Default variance key assigned to this controlling area, defining which variance categories (e.g., price variance, quantity variance, efficiency variance) are calculated during production order settlement and product cost variance analysis.',
    CONSTRAINT pk_controlling_area PRIMARY KEY(`controlling_area_id`)
) COMMENT 'Master configuration entity defining the controlling area scope within SAP CO, representing the organizational unit within which cost accounting is performed. Captures controlling area code, name, assigned company codes, fiscal year variant, currency type, cost center standard hierarchy, and CO version settings. Governs the boundaries for internal cost allocation, profitability analysis, and management reporting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`fiscal_period` (
    `fiscal_period_id` BIGINT COMMENT 'Unique surrogate key identifying a fiscal period record in the financial calendar master. Used as the primary reference for all financial postings, period-end close workflows, and reporting period assignments across legal entities.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: fiscal_period.controlling_area_code (STRING) is a denormalized reference to the controlling_area master. Fiscal periods are scoped to controlling areas in SAP. Adding controlling_area_id FK normalizes',
    `prior_period_fiscal_period_id` BIGINT COMMENT 'Reference to the immediately preceding fiscal period record. Enables period-over-period variance analysis, prior period comparisons in financial statements, and sequential period navigation in reporting tools without requiring complex date calculations.',
    `accounting_standard` STRING COMMENT 'The accounting standard framework under which this fiscal period is reported. IFRS for International Financial Reporting Standards, GAAP for US Generally Accepted Accounting Principles, IFRS_GAAP for dual-reporting entities, LOCAL_GAAP for local statutory reporting, STAT for statutory-only periods.. Valid values are `IFRS|GAAP|IFRS_GAAP|LOCAL_GAAP|STAT`',
    `ap_posting_allowed` BOOLEAN COMMENT 'Flag indicating whether accounts payable postings (vendor invoices, payments, credit memos) are permitted for this fiscal period. Independently controlled from GL postings via the SAP posting period variant by account type.. Valid values are `true|false`',
    `ar_posting_allowed` BOOLEAN COMMENT 'Flag indicating whether accounts receivable postings (customer invoices, payments, credit memos) are permitted for this fiscal period. Independently controlled from GL postings via the SAP posting period variant by account type.. Valid values are `true|false`',
    `asset_posting_allowed` BOOLEAN COMMENT 'Flag indicating whether fixed asset accounting postings (acquisitions, retirements, depreciation runs) are permitted for this fiscal period. Asset accounting periods may be closed independently from other sub-ledgers.. Valid values are `true|false`',
    `close_completed_timestamp` TIMESTAMP COMMENT 'Date and time when the period-end close process was fully completed and the period was officially closed for all postings. Used to measure close cycle time and track compliance with internal close calendar SLAs.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `close_initiated_timestamp` TIMESTAMP COMMENT 'Date and time when the period-end close process was formally initiated. Marks the start of the close workflow including sub-ledger reconciliation, accrual posting, and management review activities.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `close_target_date` DATE COMMENT 'The planned target date by which the fiscal period close should be completed, as defined in the financial close calendar. Used to monitor close cycle performance and identify delays against the internal close SLA.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the legal entitys country of incorporation. Used to apply country-specific fiscal calendar rules, statutory reporting requirements, and tax period definitions.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this fiscal period record was created in the system. Used for audit trail, data lineage tracking, and SOX compliance documentation of fiscal calendar master data changes.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the functional currency of the legal entity for this fiscal period. Used for multi-currency consolidation and foreign currency translation during period-end close.. Valid values are `^[A-Z]{3}$`',
    `end_date` DATE COMMENT 'Calendar date on which the fiscal period ends. Defines the upper boundary for financial transactions and journal entries that can be posted to this period. Used in period-end close cutoff enforcement.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `fiscal_year` STRING COMMENT 'The four-digit fiscal year to which this period belongs. May differ from the calendar year depending on the companys fiscal year-end configuration (e.g., fiscal year 2024 may span April 2023 to March 2024).. Valid values are `^[0-9]{4}$`',
    `fiscal_year_variant` STRING COMMENT 'Code identifying the fiscal year variant configuration that defines the fiscal calendar structure (e.g., K4 for calendar year with 4 special periods, V3 for April–March fiscal year). Determines how periods are mapped to calendar months and how special periods are handled.',
    `gl_posting_allowed` BOOLEAN COMMENT 'Flag indicating whether general ledger journal entry postings are currently permitted for this fiscal period. Controlled by the posting period variant and period status. When false, all GL postings to this period are blocked.. Valid values are `true|false`',
    `half_year_number` STRING COMMENT 'The fiscal half-year (1 or 2) to which this period belongs. Used for semi-annual financial reporting and interim statutory filings required in certain jurisdictions.. Valid values are `^[1-2]$`',
    `is_adjustment_period` BOOLEAN COMMENT 'Flag indicating whether this period is designated for audit adjustments and prior-period corrections. Adjustment periods allow authorized postings after the standard period close to accommodate external audit findings and statutory corrections.. Valid values are `true|false`',
    `is_special_period` BOOLEAN COMMENT 'Flag indicating whether this is a special adjustment period (periods 13–16 in SAP) used exclusively for year-end audit adjustments, closing entries, and statutory corrections. Special periods do not correspond to calendar months and are restricted to authorized finance users.. Valid values are `true|false`',
    `is_year_end_period` BOOLEAN COMMENT 'Flag indicating whether this period is the final closing period of the fiscal year. Triggers year-end close workflows including balance carryforward, retained earnings posting, and statutory financial statement preparation.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this fiscal period record was last updated. Tracks changes to period status, posting permissions, or calendar definitions. Essential for audit trail and SOX internal controls over financial reporting.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `ledger_code` STRING COMMENT 'Code identifying the accounting ledger (leading or non-leading) in SAP S/4HANA to which this fiscal period applies. Supports parallel accounting where multiple ledgers are maintained for different accounting standards (e.g., IFRS ledger 0L, local GAAP ledger L1).',
    `legal_entity_code` STRING COMMENT 'Code identifying the legal entity (company code in SAP) for which this fiscal period definition applies. Supports multi-entity and multinational operations where different legal entities may have different fiscal calendars or period statuses.',
    `mm_posting_allowed` BOOLEAN COMMENT 'Flag indicating whether materials management postings (goods receipts, goods issues, inventory movements) are permitted for this fiscal period. MM period close is managed separately from FI period close in SAP and must be aligned for COGS and inventory valuation accuracy.. Valid values are `true|false`',
    `period_name` STRING COMMENT 'Human-readable name of the fiscal period (e.g., January 2024, Q1 FY2024, Period 01 FY2024). Used in financial reports, dashboards, and period-end close communications.',
    `period_number` STRING COMMENT 'Sequential number of the period within the fiscal year. Standard periods are 1–12 (monthly) or 1–4 (quarterly). Periods 13–16 are reserved for special year-end adjustment periods used for audit corrections and closing entries.. Valid values are `^([1-9]|1[0-6])$`',
    `period_short_code` STRING COMMENT 'Abbreviated alphanumeric code for the fiscal period used in financial reports, dashboards, and system interfaces (e.g., JAN24, Q1FY24, P01.2024). Provides a compact, human-readable period identifier for display in Power BI reports and management dashboards.',
    `period_type` STRING COMMENT 'Classification of the fiscal period granularity. monthly for standard 12-period calendars, quarterly for 4-period calendars, semi_annual for 2-period calendars, annual for single-period fiscal years, and special for year-end adjustment periods (periods 13–16 in SAP).. Valid values are `monthly|quarterly|semi_annual|annual|special`',
    `posting_period_variant` STRING COMMENT 'SAP posting period variant code that controls which account types (assets, customers, vendors, general ledger) are open for posting in this period. Maps directly to the SAP FI posting period variant configuration (transaction OB52) and determines posting authorization by account type.',
    `quarter_number` STRING COMMENT 'The fiscal quarter (1–4) to which this period belongs. Derived from the period number based on the fiscal year variant. Used for quarterly financial reporting, EBITDA reporting, and regulatory filings.. Valid values are `^[1-4]$`',
    `reopen_reason` STRING COMMENT 'Business justification provided when a closed fiscal period is reopened for additional postings. Documents the reason for the exception (e.g., External audit adjustment, Prior period error correction per IAS 8). Required for audit trail and SOX compliance.',
    `reopen_timestamp` TIMESTAMP COMMENT 'Date and time when a previously closed fiscal period was reopened for additional postings. Populated only when a period has been reopened after closure, typically for audit adjustments or error corrections. Null if the period has never been reopened.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `reporting_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the group reporting (presentation) currency used for consolidated financial statements. Enables multi-currency consolidation where local functional currency differs from the group reporting currency.. Valid values are `^[A-Z]{3}$`',
    `start_date` DATE COMMENT 'Calendar date on which the fiscal period begins. Defines the lower boundary for financial transactions and journal entries that can be posted to this period.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `status` STRING COMMENT 'Current operational status of the fiscal period controlling whether journal entries and financial postings are permitted. open allows posting; closed prevents new postings; blocked temporarily restricts posting; in_closing indicates period-end close is in progress; reopened indicates a previously closed period that has been re-opened for corrections; archived indicates the period is fully closed and archived.. Valid values are `open|closed|blocked|in_closing|reopened|archived`',
    `tax_period_number` STRING COMMENT 'The tax reporting period number corresponding to this fiscal period, used for VAT/GST returns, withholding tax filings, and other statutory tax submissions. May differ from the financial posting period number in jurisdictions with different tax calendars.. Valid values are `^([1-9]|1[0-2])$`',
    `weeks_in_period` STRING COMMENT 'Number of calendar weeks contained within this fiscal period. Relevant for 4-4-5, 4-5-4, or 5-4-4 fiscal calendar configurations used in manufacturing and retail industries where periods are defined in weeks rather than calendar months.. Valid values are `^([1-9]|[1-4][0-9]|5[0-3])$`',
    `working_days_count` STRING COMMENT 'Number of business working days within this fiscal period, excluding weekends and public holidays. Used for production planning, labor cost accruals, depreciation calculations, and period-over-period performance normalization in manufacturing operations.. Valid values are `^[0-9]{1,2}$`',
    CONSTRAINT pk_fiscal_period PRIMARY KEY(`fiscal_period_id`)
) COMMENT 'Reference master defining the fiscal calendar periods used for financial posting and reporting across all legal entities. Captures fiscal year, period number, period name, calendar start and end dates, period status (open/closed), posting period variant, and special period indicators for year-end adjustments. Controls which periods are open for journal entry posting and drives period-end close workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`journal_entry` (
    `journal_entry_id` BIGINT COMMENT 'Unique surrogate identifier for each journal entry record in the silver layer lakehouse. Serves as the primary key for the journal_entry data product.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: journal_entry.controlling_area (STRING) is a denormalized reference to the controlling_area master. Adding controlling_area_id FK normalizes this organizational scoping relationship for management acc',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: journal_entry.cost_center (STRING) is a denormalized reference to the cost_center master. Adding cost_center_id FK normalizes this management accounting dimension, enabling proper cost center reportin',
    `employee_id` BIGINT COMMENT 'The SAP user ID of the person or batch job that posted the journal entry. Essential for audit trail, segregation of duties compliance, and SOX controls. Corresponds to USNAM in SAP BKPF.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: journal_entry uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master, enabling period-s',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: journal_entry.gl_account_number (STRING) is a denormalized reference to the gl_account master. Adding gl_account_id FK normalizes this core accounting relationship. gl_account_name is redundant as it ',
    `ledger_id` BIGINT COMMENT 'Identifier of the accounting ledger in which the journal entry is posted (e.g., 0L=Leading Ledger for IFRS, 1L=Non-Leading Ledger for local GAAP). Supports parallel accounting under multiple accounting standards. Corresponds to RLDNR in SAP BKPF.. Valid values are `^[A-Z0-9]{2}$`',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: journal_entry.company_code (STRING) is a denormalized reference to the legal_entity master. Adding legal_entity_id FK normalizes this entity scoping, enabling multi-entity consolidation queries and st',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: journal_entry.profit_center (STRING) is a denormalized reference to the profit_center master. Adding profit_center_id FK normalizes this profitability dimension, enabling proper profit center reportin',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: journal_entry.tax_code (STRING) is a denormalized reference to the tax_code master. Adding tax_code_id FK normalizes this tax reference, enabling proper tax reporting, VAT reconciliation, and complian',
    `amount_in_group_currency` DECIMAL(18,2) COMMENT 'The monetary amount of the journal entry line item translated into the group consolidation currency. Used for consolidated financial reporting and EBITDA/COGS analysis at the enterprise level.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `amount_in_local_currency` DECIMAL(18,2) COMMENT 'The monetary amount of the journal entry line item translated into the company code local (functional) currency. Used for statutory reporting in the country of incorporation. Corresponds to DMBTR in SAP BSEG.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `amount_in_transaction_currency` DECIMAL(18,2) COMMENT 'The monetary amount of the journal entry line item expressed in the transaction (document) currency. Positive for debits, negative for credits per SAP convention. Corresponds to WRBTR in SAP BSEG.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `assignment_number` STRING COMMENT 'Alphanumeric assignment field used for sorting and matching open items in accounts payable and accounts receivable (e.g., payment reference, check number, clearing document). Corresponds to ZUONR in SAP BSEG.',
    `business_area` STRING COMMENT 'SAP business area code used for cross-company-code segment reporting and internal balance sheet/P&L preparation by business division (e.g., Automation Systems, Electrification Solutions). Corresponds to GSBER in SAP BSEG.. Valid values are `^[A-Z0-9]{1,4}$`',
    `clearing_date` DATE COMMENT 'The date on which the open item was cleared (matched/settled) in accounts payable or accounts receivable. Used for aging analysis and cash flow reporting. Corresponds to AUGDT in SAP BSEG.. Valid values are `^d{4}-d{2}-d{2}$`',
    `clearing_document_number` STRING COMMENT 'The document number of the clearing document that settled this open item (e.g., payment document clearing an invoice). Populated when the line item has been cleared/matched. Corresponds to AUGBL in SAP BSEG.. Valid values are `^[0-9]{10}$`',
    `company_code` STRING COMMENT 'The SAP company code representing the legal entity for which the journal entry is posted. Enables multi-entity financial consolidation and statutory reporting across all Manufacturing legal entities globally.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center` STRING COMMENT 'The controlling cost center to which the journal entry is assigned for internal cost accounting and management reporting. Enables OPEX tracking by organizational unit (e.g., production plant, department). Corresponds to KOSTL in SAP BSEG.. Valid values are `^[A-Z0-9]{1,10}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the transaction currency in which the journal entry was originally recorded (e.g., USD, EUR, GBP, CNY). Supports multi-currency operations across all Manufacturing geographies. Corresponds to WAERS in SAP BKPF.. Valid values are `^[A-Z]{3}$`',
    `debit_credit_indicator` STRING COMMENT 'Indicates whether the journal entry line item is a debit (S=Soll/Debit) or credit (H=Haben/Credit) posting. Fundamental to double-entry bookkeeping integrity. Corresponds to SHKZG in SAP BSEG.. Valid values are `S|H`',
    `document_date` DATE COMMENT 'The date of the original source document (e.g., invoice date, goods receipt date) that triggered the journal entry. May differ from posting date. Corresponds to BLDAT in SAP BKPF.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_header_text` STRING COMMENT 'Free-text description at the document header level providing context for the journal entry (e.g., Monthly depreciation run, Accrual reversal Q3). Corresponds to BKTXT in SAP BKPF.',
    `document_number` STRING COMMENT 'The unique accounting document number assigned by SAP S/4HANA FI upon posting. Identifies the journal entry within a company code and fiscal year. Corresponds to BELNR in SAP BKPF.. Valid values are `^[0-9]{10}$`',
    `document_type` STRING COMMENT 'Two-character SAP document type code that classifies the nature of the journal entry (e.g., SA=General Ledger, KR=Vendor Invoice, DR=Customer Invoice, AB=Asset Posting, WA=Goods Issue, RE=Invoice Receipt). Controls number range assignment and account type permissibility. Corresponds to BLART in SAP BKPF.. Valid values are `^[A-Z0-9]{2}$`',
    `document_type_description` STRING COMMENT 'Human-readable description of the document type for reporting and analytics purposes (e.g., General Ledger Document, Vendor Invoice, Customer Invoice, Asset Posting).',
    `entry_timestamp` TIMESTAMP COMMENT 'The exact date and time when the journal entry was created in the source system (SAP S/4HANA). Supports audit trail requirements and intraday financial monitoring. Derived from CPUDT and CPUTM in SAP BKPF.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied to convert the transaction currency amount to the local currency at the time of posting. Corresponds to KURSF in SAP BKPF.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `exchange_rate_type` STRING COMMENT 'The exchange rate type used for currency translation (e.g., M=Standard translation at average rate, B=Bank buying rate, G=Bank selling rate). Controls which rate table is used for conversion. Corresponds to KURSF type in SAP.. Valid values are `^[A-Z0-9]{1,4}$`',
    `fiscal_period` STRING COMMENT 'The fiscal posting period (1–12 for regular periods; 13–16 for special closing periods) within the fiscal year. Drives period-end financial close and reporting cycles. Corresponds to MONAT in SAP BKPF.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the journal entry is recorded. Used for period-end closing, financial reporting, and year-over-year comparisons. Corresponds to GJAHR in SAP BKPF.. Valid values are `^[0-9]{4}$`',
    `functional_area` STRING COMMENT 'The functional area classification for cost-of-sales accounting (e.g., Manufacturing, Sales, Administration, R&D). Enables income statement presentation by function of expense as required under IFRS. Corresponds to FKBER in SAP BSEG.. Valid values are `^[A-Z0-9]{1,16}$`',
    `gl_account_number` STRING COMMENT 'The General Ledger (GL) account number to which the journal entry line item is posted. Determines the financial statement classification (P&L or Balance Sheet). Corresponds to HKONT in SAP BSEG.. Valid values are `^[0-9]{6,10}$`',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the group/consolidation currency used for consolidated financial reporting across all Manufacturing legal entities (typically USD or EUR for a multinational).. Valid values are `^[A-Z]{3}$`',
    `internal_order_number` STRING COMMENT 'SAP internal order number used to track costs for specific projects, CAPEX investments, or temporary cost collection objects (e.g., R&D projects, capital expenditure orders). Corresponds to AUFNR in SAP BSEG.. Valid values are `^[0-9]{1,12}$`',
    `line_item_text` STRING COMMENT 'Free-text description at the journal entry line item level providing additional context for the individual posting (e.g., Depreciation - CNC Machine Line 3, Accrual - Q4 Warranty Provision). Corresponds to SGTXT in SAP BSEG.',
    `local_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the company code local currency (functional currency) for the legal entity. Used for statutory reporting in the country of incorporation. Corresponds to the company code currency in SAP.. Valid values are `^[A-Z]{3}$`',
    `plant` STRING COMMENT 'The SAP plant code associated with the journal entry, representing a manufacturing facility or distribution center. Enables cost and revenue analysis by production site and supports plant-level COGS and OEE financial reporting.. Valid values are `^[A-Z0-9]{1,4}$`',
    `posting_date` DATE COMMENT 'The date on which the journal entry is posted to the general ledger and determines the fiscal period assignment. This is the authoritative date for financial reporting and period-end close. Corresponds to BUDAT in SAP BKPF.. Valid values are `^d{4}-d{2}-d{2}$`',
    `posting_key` STRING COMMENT 'Two-digit SAP posting key that determines the debit/credit indicator and account type for each line item (e.g., 40=Debit G/L, 50=Credit G/L, 01=Customer Invoice, 31=Vendor Invoice). Corresponds to BSCHL in SAP BSEG.. Valid values are `^[0-9]{2}$`',
    `posting_status` STRING COMMENT 'Current status of the journal entry in the financial system lifecycle. posted indicates a completed and active posting; reversed indicates the entry has been reversed; parked indicates a saved but not yet posted document; cleared indicates open items have been matched.. Valid values are `posted|reversed|parked|held|cleared|error`',
    `profit_center` STRING COMMENT 'The controlling profit center assigned to the journal entry for profitability analysis and segment reporting. Enables revenue and cost tracking by business unit or product line. Corresponds to PRCTR in SAP BSEG.. Valid values are `^[A-Z0-9]{1,10}$`',
    `reference_document_number` STRING COMMENT 'External reference number from the originating business transaction (e.g., vendor invoice number, purchase order number, delivery note number). Enables cross-referencing between financial postings and source documents. Corresponds to XBLNR in SAP BKPF.',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this journal entry is a reversal of a previously posted document. True if the document is a reversal entry; False otherwise. Critical for audit trail integrity and period-end close management. Corresponds to STBLG presence in SAP BKPF.. Valid values are `true|false`',
    `reversed_document_number` STRING COMMENT 'The document number of the original journal entry that this document reverses. Populated only when reversal_indicator is True. Enables complete audit trail linking of reversal pairs. Corresponds to STBLG in SAP BKPF.. Valid values are `^[0-9]{10}$`',
    `source_system` STRING COMMENT 'Identifier of the originating system that generated the journal entry (e.g., SAP_S4HANA for automated postings, MANUAL for manually entered documents, INTERFACE for postings from integrated systems like MES or WMS). Supports data lineage and audit trail requirements.. Valid values are `SAP_S4HANA|MANUAL|INTERFACE|LEGACY`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax amount (VAT, GST, or other applicable tax) associated with the journal entry line item in the transaction currency. Used for tax reporting and reconciliation. Corresponds to WMWST in SAP BSEG.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `tax_code` STRING COMMENT 'The tax code assigned to the journal entry line item determining the applicable tax rate and tax account (e.g., VAT, GST, sales tax). Supports multi-jurisdiction tax compliance across all Manufacturing geographies. Corresponds to MWSKZ in SAP BSEG.. Valid values are `^[A-Z0-9]{2}$`',
    `wbs_element` STRING COMMENT 'Work Breakdown Structure (WBS) element from SAP Project System (PS) used to assign journal entry costs to specific capital projects or engineering programs. Critical for CAPEX tracking and project cost accounting. Corresponds to PROJK in SAP BSEG.',
    CONSTRAINT pk_journal_entry PRIMARY KEY(`journal_entry_id`)
) COMMENT 'Core transactional record capturing every financial posting made to the general ledger across all Manufacturing legal entities. Records document number, document type, posting date, document date, fiscal year, fiscal period, reference document, posting key, reversal indicator, source system, currency, exchange rate, and posting user. The atomic unit of the double-entry bookkeeping system and the foundation for all financial statements. Sourced from SAP S/4HANA FI.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` (
    `journal_entry_line_id` BIGINT COMMENT 'Unique surrogate identifier for each individual journal entry line item in the silver layer lakehouse. Serves as the primary key for this entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: journal_entry_line.cost_center (STRING) is a denormalized reference to the cost_center master. Adding cost_center_id FK normalizes this management accounting dimension at the line-item level.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: journal_entry_line uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-le',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: journal_entry_line.gl_account (STRING) is a denormalized reference to the gl_account master. Adding gl_account_id FK normalizes this core accounting relationship. gl_account_name is redundant as it ca',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: journal_entry_line.document_number (STRING) is a denormalized reference to the parent journal_entry. Adding journal_entry_id FK creates the essential parent-child relationship between journal entry he',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: journal_entry_line.profit_center (STRING) is a denormalized reference to the profit_center master. Adding profit_center_id FK normalizes this profitability dimension at the line-item level.',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: journal_entry_line.tax_code (STRING) is a denormalized reference to the tax_code master. Adding tax_code_id FK normalizes tax reference at the line-item level for VAT/GST reporting.',
    `account_type` STRING COMMENT 'The type of account affected by the line item: A=Asset, D=Customer (Debtor), K=Vendor (Creditor), M=Material, S=General Ledger. Determines the subledger integration and reporting classification. Corresponds to KOART in SAP.. Valid values are `A|D|K|M|S`',
    `amount_group_currency` DECIMAL(18,2) COMMENT 'The monetary amount of the line item translated into the group (consolidation) currency for multinational financial consolidation and group-level EBITDA and COGS reporting. Corresponds to KURSF/group currency amount in SAP.',
    `amount_local_currency` DECIMAL(18,2) COMMENT 'The monetary amount of the line item translated into the local (company code) currency. Used for statutory reporting and local financial statements. Corresponds to DMBTR in SAP.',
    `amount_transaction_currency` DECIMAL(18,2) COMMENT 'The monetary amount of the line item expressed in the original transaction currency (e.g., the currency of the invoice or payment). Used for foreign currency analysis and reconciliation. Corresponds to WRBTR in SAP.',
    `assignment` STRING COMMENT 'Free-form assignment field used to link the line item to a reference document, payment run, or clearing transaction. Commonly populated with invoice numbers, payment references, or order numbers for account clearing and reconciliation. Corresponds to ZUONR in SAP.',
    `business_area` STRING COMMENT 'The SAP business area representing a distinct area of operations or responsibility within the enterprise. Used for cross-company-code segment reporting and internal financial statements. Corresponds to GSBER in SAP.. Valid values are `^[A-Z0-9]{1,4}$`',
    `clearing_date` DATE COMMENT 'The date on which the open item was cleared (matched against a payment or offsetting entry). Used for accounts receivable/payable aging analysis and cash flow reporting. Corresponds to AUGDT in SAP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `clearing_document` STRING COMMENT 'The document number of the clearing transaction that offset this open item (e.g., payment clearing an invoice). Populated when the line item has been cleared; blank for open items. Corresponds to AUGBL in SAP.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or organizational unit for which the financial posting is made. Enables multi-entity financial consolidation across the multinational enterprise. Corresponds to BUKRS in SAP.. Valid values are `^[A-Z0-9]{1,4}$`',
    `cost_center` STRING COMMENT 'The organizational unit (cost center) to which the cost or revenue is allocated. Enables cost accounting, departmental P&L analysis, and OPEX/CAPEX tracking. Corresponds to KOSTL in SAP CO module.. Valid values are `^[A-Z0-9]{1,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the journal entry line was created in the source system. Used for audit trail, SOX compliance, and data lineage tracking. Corresponds to CPUDT/CPUTM in SAP.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `debit_credit_indicator` STRING COMMENT 'Indicates whether the line item is a debit (D) or credit (C) posting. Fundamental to double-entry bookkeeping and ensures the journal entry balances. Corresponds to SHKZG in SAP.. Valid values are `D|C`',
    `document_date` DATE COMMENT 'The date of the original source document (invoice, receipt, contract) that triggered the journal entry. May differ from posting date and is used for audit trail and document matching. Corresponds to BLDAT in SAP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_type` STRING COMMENT 'SAP document type code classifying the nature of the journal entry (e.g., SA=General Ledger, KR=Vendor Invoice, DR=Customer Invoice, AB=Asset Posting, AA=Asset Accounting). Controls number ranges and account types. Corresponds to BLART in SAP.. Valid values are `^[A-Z0-9]{1,2}$`',
    `entry_date` DATE COMMENT 'The date on which the journal entry was entered into the system. Used for audit trail and to distinguish from posting date and document date. Corresponds to CPUDT in SAP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied to translate the transaction currency amount to the local currency at the time of posting. Critical for multi-currency reconciliation and FX gain/loss analysis. Corresponds to KURSF in SAP.',
    `fiscal_period` STRING COMMENT 'The fiscal posting period (1–12 for regular periods; 13–16 for special closing periods) within the fiscal year. Used for monthly and quarterly financial reporting and period-end close processes. Corresponds to MONAT in SAP.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the journal entry line is posted. Used for period-end closing, annual reporting, and year-over-year financial analysis. Corresponds to GJAHR in SAP.. Valid values are `^[0-9]{4}$`',
    `functional_area` STRING COMMENT 'The functional area classification (e.g., Production, Sales, Administration, R&D) used for cost-of-sales accounting and income statement presentation by function. Corresponds to FKBER in SAP.. Valid values are `^[A-Z0-9]{1,16}$`',
    `gl_account` STRING COMMENT 'The General Ledger (GL) account number to which this line item is posted. Represents the chart of accounts classification (e.g., revenue, expense, asset, liability). Corresponds to HKONT/SAKNR in SAP.. Valid values are `^[0-9]{1,10}$`',
    `group_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the corporate groups consolidation currency (e.g., USD or EUR). Used for consolidated financial statements and group-level reporting.. Valid values are `^[A-Z]{3}$`',
    `ledger_group` STRING COMMENT 'The ledger group to which this posting applies, supporting parallel accounting under multiple accounting standards (e.g., IFRS ledger, GAAP ledger, local GAAP ledger). Corresponds to LEDGER_GROUP in SAP New GL.',
    `line_item_number` STRING COMMENT 'Sequential line item number within the parent journal entry document, uniquely identifying this posting line within the document. Corresponds to BUZEI field in SAP BSEG table.. Valid values are `^[0-9]{1,6}$`',
    `line_item_text` STRING COMMENT 'Free-text description of the individual journal entry line item, providing narrative context for the posting. Used in account analysis, audit documentation, and financial reporting. Corresponds to SGTXT in SAP.',
    `local_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the company codes local (functional) currency. Used for statutory financial reporting in the entitys country of domicile. Corresponds to PSWSL in SAP.. Valid values are `^[A-Z]{3}$`',
    `posting_date` DATE COMMENT 'The date on which the journal entry line is posted to the general ledger. Determines the fiscal period assignment and is used for period-end cut-off and financial reporting. Corresponds to BUDAT in SAP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `posting_key` STRING COMMENT 'Two-digit SAP posting key that determines the account type, debit/credit side, and field status for the line item (e.g., 40=GL Debit, 50=GL Credit, 31=Vendor Credit, 01=Customer Debit). Corresponds to BSCHL in SAP.. Valid values are `^[0-9]{2}$`',
    `profit_center` STRING COMMENT 'The profit center to which the line item is assigned for internal profitability analysis and segment reporting. Supports EBITDA reporting by business unit or product line. Corresponds to PRCTR in SAP CO module.. Valid values are `^[A-Z0-9]{1,10}$`',
    `reference_document_number` STRING COMMENT 'External reference number from the source document (e.g., vendor invoice number, customer PO number, bank statement reference). Used for cross-system reconciliation and audit trail. Corresponds to XBLNR in SAP.',
    `reversal_document_number` STRING COMMENT 'The document number of the reversing or reversed journal entry document. Populated when this line item is part of a reversal pair, enabling traceability of corrections and adjustments. Corresponds to STBLG in SAP.',
    `reversal_indicator` BOOLEAN COMMENT 'Indicates whether this journal entry line is a reversal posting (True) or an original posting (False). Used to identify correcting entries and ensure accurate financial reporting by excluding reversed items from balances.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifier of the originating operational system that generated the journal entry line (e.g., SAP S/4HANA, Siemens Opcenter MES, Maximo EAM). Supports data lineage, audit trail, and multi-system reconciliation in the lakehouse.',
    `special_gl_indicator` STRING COMMENT 'Special General Ledger (GL) indicator for down payments, guarantees, bills of exchange, or other special transactions that are posted to alternative reconciliation accounts. Corresponds to UMSKZ in SAP.. Valid values are `^[A-Z0-9]?$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax amount (VAT, GST, or other indirect tax) associated with this line item in the transaction currency. Used for tax reporting, VAT returns, and indirect tax compliance. Corresponds to WMWST in SAP.',
    `tax_code` STRING COMMENT 'The tax code assigned to the line item, determining the applicable tax rate and tax account for VAT, GST, or other indirect taxes. Used for tax reporting and compliance. Corresponds to MWSKZ in SAP.. Valid values are `^[A-Z0-9]{1,2}$`',
    `transaction_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the original transaction (e.g., USD, EUR, CNY). Identifies the currency in which the business transaction was originally denominated. Corresponds to WAERS in SAP.. Valid values are `^[A-Z]{3}$`',
    `wbs_element` STRING COMMENT 'The Work Breakdown Structure (WBS) element identifying the project or capital expenditure (CAPEX) work package to which this posting is assigned. Enables project cost tracking and CAPEX vs. OPEX classification. Corresponds to PROJK/PS_PSP_PNR in SAP PS module.',
    CONSTRAINT pk_journal_entry_line PRIMARY KEY(`journal_entry_line_id`)
) COMMENT 'Individual line item within a journal entry document, representing a single debit or credit posting to a GL account. Captures line item number, GL account, debit/credit indicator, amount in transaction currency, amount in local currency, amount in group currency, cost center, profit center, WBS element, business area, tax code, assignment field, and line item text. Provides the granular detail required for account analysis, cost allocation, and audit trails.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`ap_invoice` (
    `ap_invoice_id` BIGINT COMMENT 'Unique surrogate identifier for each accounts payable invoice record in the silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: ap_invoice.cost_center (STRING) is a denormalized reference to the cost_center master. Adding cost_center_id FK normalizes cost center assignment on AP invoices for management accounting and cost cont',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: ap_invoice uses fiscal_year (STRING) and fiscal_period (STRING) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-leve',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: ap_invoice.gl_account (STRING) is a denormalized reference to the gl_account master. Adding gl_account_id FK normalizes the GL account assignment on AP invoices, enabling proper expense classification',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: Accounts payable invoices from IT vendors (software, hardware, cloud services) must reference the vendor master for payment processing, tax reporting, and spend analytics.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: ap_invoice.company_code (STRING) is a denormalized reference to the legal_entity master. Adding legal_entity_id FK normalizes entity scoping on AP invoices for multi-entity financial consolidation and',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: AP invoices must reference the supplier master for payment processing and vendor management. Finance uses supplier data for payment runs and 1099 reporting.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: ap_invoice.profit_center (STRING) is a denormalized reference to the profit_center master. Adding profit_center_id FK normalizes profit center assignment on AP invoices for profitability analysis.',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: ap_invoice.tax_code (STRING) is a denormalized reference to the tax_code master. Adding tax_code_id FK normalizes tax code assignment on AP invoices for input VAT recovery and tax compliance reporting',
    `amount_in_company_currency` DECIMAL(18,2) COMMENT 'Gross invoice amount translated into the company code local currency using the exchange rate at posting date. Used for local financial reporting and EBITDA calculation.',
    `baseline_date` DATE COMMENT 'The reference date used as the starting point for calculating payment due dates and cash discount periods based on the payment terms. May differ from invoice date.. Valid values are `d{4}-d{2}-d{2}`',
    `capex_opex_indicator` STRING COMMENT 'Classifies the invoice as either Capital Expenditure (CAPEX) for asset acquisition/improvement or Operational Expenditure (OPEX) for ongoing business operations. Critical for financial reporting and tax treatment.. Valid values are `CAPEX|OPEX`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or organizational unit for which the invoice is posted. Supports multi-entity financial consolidation and statutory reporting.. Valid values are `[A-Z0-9]{4}`',
    `company_code_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the local company code currency. Used for local statutory reporting and financial consolidation.. Valid values are `[A-Z]{3}`',
    `cost_center` STRING COMMENT 'SAP cost center to which the invoice expense is allocated for internal cost accounting and management reporting. Supports COGS, OPEX, and departmental budget tracking.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Monetary value of the early payment cash discount available if payment is made within the discount period specified in the payment terms.',
    `discount_due_date` DATE COMMENT 'The last date by which payment must be made to qualify for the early payment cash discount. Supports working capital optimization and discount capture reporting.. Valid values are `d{4}-d{2}-d{2}`',
    `document_number` STRING COMMENT 'Internal SAP financial document number assigned upon posting of the invoice in the general ledger. Uniquely identifies the accounting document within a company code and fiscal year.',
    `entry_date` DATE COMMENT 'The date on which the invoice document was entered into the SAP system. Supports audit trail and processing time analysis.. Valid values are `d{4}-d{2}-d{2}`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied at the time of invoice posting to translate the invoice currency amount to the company code currency. Supports FX gain/loss reporting.',
    `fiscal_period` STRING COMMENT 'The accounting period (month) within the fiscal year in which the invoice is posted. Supports period-end accruals and monthly financial close.. Valid values are `0[1-9]|1[0-6]`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the invoice is posted. Used for period-end closing, financial reporting, and EBITDA/COGS analysis.. Valid values are `d{4}`',
    `gl_account` STRING COMMENT 'The General Ledger account number to which the invoice amount is posted. Determines the financial statement line item and supports COGS, CAPEX, and OPEX classification.',
    `grn_number` STRING COMMENT 'The Goods Receipt Note number confirming physical receipt of goods or services against the referenced PO. Required for three-way match validation and invoice approval.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total gross amount of the invoice including all taxes and charges, expressed in the invoice currency. Represents the full liability to the vendor before any discounts.',
    `invoice_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the vendor invoice is denominated. Supports multi-currency AP processing and foreign exchange reporting.. Valid values are `[A-Z]{3}`',
    `invoice_date` DATE COMMENT 'The date printed on the vendor invoice document. Used as the baseline for payment term calculations and aging analysis.. Valid values are `d{4}-d{2}-d{2}`',
    `invoice_number` STRING COMMENT 'The external invoice number as printed on the vendor/supplier invoice document. Used for three-way match reconciliation and vendor communication.',
    `invoice_status` STRING COMMENT 'Current processing status of the AP invoice through its lifecycle from receipt to payment. Drives workflow routing, aging analysis, and cash flow forecasting.. Valid values are `RECEIVED|PARKED|POSTED|APPROVED|BLOCKED|IN_DISPUTE|PARTIALLY_PAID|PAID|CANCELLED|REVERSED`',
    `invoice_type` STRING COMMENT 'Classification of the invoice document type indicating whether it is a standard vendor invoice, credit memo, debit memo, recurring invoice, prepayment, intercompany, or self-billing document.. Valid values are `STANDARD|CREDIT_MEMO|DEBIT_MEMO|RECURRING|PREPAYMENT|INTERCOMPANY|SELF_BILLING`',
    `net_amount` DECIMAL(18,2) COMMENT 'Net amount of the invoice excluding tax, expressed in the invoice currency. Represents the base value for cost accounting, COGS, and CAPEX/OPEX classification.',
    `payment_block_indicator` STRING COMMENT 'SAP payment block key indicating whether the invoice is blocked from automatic payment processing and the reason for the block (e.g., R=Manual block, A=Blocked for payment, I=In dispute).. Valid values are `R|A|B|I|V|s`',
    `payment_due_date` DATE COMMENT 'The date by which payment must be made to the vendor to comply with agreed payment terms and avoid late payment penalties. Derived from invoice date and payment terms.. Valid values are `d{4}-d{2}-d{2}`',
    `payment_method` STRING COMMENT 'The method by which the invoice will be or was paid to the vendor (e.g., ACH, wire transfer, check, SEPA). Drives payment run configuration and bank communication.. Valid values are `ACH|WIRE|CHECK|SEPA|SWIFT|VIRTUAL_CARD|OTHER`',
    `payment_terms_code` STRING COMMENT 'Code identifying the agreed payment terms between the company and the vendor (e.g., Net 30, 2/10 Net 30). Drives due date calculation and early payment discount eligibility.',
    `po_number` STRING COMMENT 'The Purchase Order number referenced on the vendor invoice. Links the invoice to the originating procurement document for three-way match and CAPEX/OPEX classification.',
    `posting_date` DATE COMMENT 'The date on which the invoice was posted to the general ledger in SAP. Determines the fiscal period and accounting period for the transaction.. Valid values are `d{4}-d{2}-d{2}`',
    `profit_center` STRING COMMENT 'SAP profit center to which the invoice is assigned for profitability analysis and segment reporting. Supports EBITDA reporting by business unit or product line.',
    `purchasing_org` STRING COMMENT 'SAP purchasing organization responsible for procuring goods or services covered by the invoice. Supports procurement analytics and supplier spend reporting.',
    `source_system` STRING COMMENT 'Identifies the originating system from which the invoice was received or entered (e.g., SAP S/4HANA MM-FI integration, SAP Ariba, manual entry, EDI, OCR scanning). Supports data lineage and audit.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL|EDI|OCR`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount (e.g., VAT, GST, sales tax) included in the invoice, expressed in the invoice currency. Used for tax reporting and input tax recovery.',
    `tax_code` STRING COMMENT 'Tax determination code assigned to the invoice line identifying the applicable tax type, rate, and jurisdiction (e.g., V1=Input VAT 19%, I0=Zero-rated). Drives tax calculation and reporting.',
    `three_way_match_status` STRING COMMENT 'Result of the three-way matching process comparing the Purchase Order (PO), Goods Receipt Note (GRN), and vendor invoice. A matched status is required for invoice approval and payment release.. Valid values are `MATCHED|PARTIALLY_MATCHED|UNMATCHED|EXCEPTION|NOT_APPLICABLE`',
    `vendor_account_number` STRING COMMENT 'The SAP vendor master account number identifying the supplier from whom the invoice was received. Links to the vendor master record for payment and reconciliation.',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'Amount of withholding tax deducted from the invoice payment at source, as required by local tax regulations. Relevant for cross-border vendor payments.',
    `withholding_tax_code` STRING COMMENT 'Tax code identifying the applicable withholding tax type and rate for the invoice. Determines the withholding tax calculation method per jurisdiction.',
    CONSTRAINT pk_ap_invoice PRIMARY KEY(`ap_invoice_id`)
) COMMENT 'Transactional record for vendor/supplier invoices received and processed through the accounts payable function. Captures invoice number, vendor reference, invoice date, posting date, payment due date, gross amount, tax amount, net amount, payment terms, payment block indicator, discount terms, three-way match status (PO/GRN/invoice), withholding tax details, and payment method. Sourced from SAP S/4HANA MM-FI integration and SAP Ariba.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`ar_invoice` (
    `ar_invoice_id` BIGINT COMMENT 'Unique surrogate identifier for the AR invoice record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: ar_invoice.cost_center (STRING) is a denormalized reference to the cost_center master. Adding cost_center_id FK normalizes cost center assignment on AR invoices for revenue attribution in management a',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: AR invoice references customer account - normalize by replacing customer_account_number and customer_name with FK',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: AR invoice references delivery - normalize by replacing delivery_number text with FK',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: ar_invoice uses fiscal_year (STRING) and fiscal_period (STRING) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-leve',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: ar_invoice.gl_account_code (STRING) is a denormalized reference to the gl_account master. Adding gl_account_id FK normalizes the revenue GL account assignment on AR invoices for proper revenue recogni',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: ar_invoice.company_code (STRING) is a denormalized reference to the legal_entity master. Adding legal_entity_id FK normalizes entity scoping on AR invoices for multi-entity revenue consolidation and s',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: ar_invoice.profit_center (STRING) is a denormalized reference to the profit_center master. Adding profit_center_id FK normalizes profit center assignment on AR invoices for contribution margin and pro',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: AR invoices trace back to originating opportunities for revenue attribution and sales credit. Sales operations reconcile invoiced revenue to closed opportunities for commission calculation.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: AR invoice references sales order - normalize by replacing sales_order_number text with FK',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: ar_invoice.tax_jurisdiction_code (STRING) maps to tax_code.jurisdiction_code. Adding tax_code_id FK normalizes tax code assignment on AR invoices for output VAT reporting and tax compliance.',
    `amount_local_currency` DECIMAL(18,2) COMMENT 'Net invoice amount converted to the company code local currency using the exchange rate at posting date. Used for statutory reporting and local GAAP compliance.',
    `billing_document_number` STRING COMMENT 'Reference to the originating billing document in SAP S/4HANA SD module (transaction VF01/VF02). Links the AR open item to the billing generation process in billing.invoice.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `clearing_date` DATE COMMENT 'Date on which the invoice was fully cleared (paid) in SAP FI-AR. Populated only when clearing_status is fully_cleared. Used for Days Sales Outstanding (DSO) calculation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `clearing_document_number` STRING COMMENT 'SAP accounting document number of the clearing transaction (payment, credit memo, or write-off) that settled this invoice. Supports payment reconciliation and audit trail.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `clearing_status` STRING COMMENT 'Current payment clearing status of the AR invoice. open indicates no payment received; partially_cleared indicates partial payment; fully_cleared indicates full payment received; written_off indicates bad debt write-off.. Valid values are `open|partially_cleared|fully_cleared|written_off`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity that issued the invoice. Supports multi-entity consolidation, statutory reporting, and intercompany reconciliation across geographies.. Valid values are `^[A-Z0-9]{1,10}$`',
    `cost_center` STRING COMMENT 'SAP cost center associated with the invoice for COGS and overhead allocation. Used in management accounting and EBITDA reporting.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers billing address. Used for tax jurisdiction determination, regulatory reporting, and geographic revenue analysis.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the AR invoice record was first created in the source system (SAP S/4HANA). Supports audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the invoice was issued to the customer (transaction currency). Supports multi-currency AR management.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total trade or cash discount amount applied to the invoice in the transaction currency. Includes early payment discounts and contractual rebates.',
    `dispute_indicator` BOOLEAN COMMENT 'Indicates whether the customer has raised a formal dispute against this invoice (True = disputed). Triggers dispute management workflow and blocks automatic dunning.. Valid values are `true|false`',
    `dispute_reason_code` STRING COMMENT 'Standardized code identifying the reason for the customer dispute (e.g., pricing discrepancy, quantity mismatch, quality issue, delivery problem). Populated when dispute_indicator is True.. Valid values are `^[A-Z0-9]{1,10}$`',
    `due_date` DATE COMMENT 'Date by which payment must be received from the customer as per the agreed payment terms. Used for AR aging analysis, dunning triggers, and cash flow forecasting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `dunning_block` BOOLEAN COMMENT 'Indicates whether the invoice is blocked from the dunning program (True = blocked). Applied when a dispute is open or a payment arrangement is in place.. Valid values are `true|false`',
    `dunning_date` DATE COMMENT 'Date on which the most recent dunning notice was issued for this invoice. Used to track collection escalation timeline and customer communication history.. Valid values are `^d{4}-d{2}-d{2}$`',
    `dunning_level` STRING COMMENT 'Current dunning level (0-9) assigned to the invoice by the SAP dunning program. Level 0 indicates no dunning notice sent; higher levels indicate escalating collection actions.. Valid values are `^[0-9]$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied at posting date to convert the invoice transaction currency to the company code local currency. Supports FX gain/loss reporting.',
    `fiscal_period` STRING COMMENT 'Accounting period (month) within the fiscal year in which the invoice was posted. Supports monthly close, period-based revenue recognition, and COGS allocation.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the AR invoice was posted in the general ledger. Used for period-end closing, EBITDA reporting, and statutory financial reporting.. Valid values are `^[0-9]{4}$`',
    `gl_account_code` STRING COMMENT 'SAP general ledger account code to which the AR invoice is posted. Typically the trade receivables reconciliation account. Supports financial close and balance sheet reporting.. Valid values are `^[0-9]{1,10}$`',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total invoice amount before any deductions, in the invoice transaction currency. Represents the full billed value including taxes.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the delivery and risk transfer conditions for the goods invoiced. Impacts revenue recognition timing under IFRS 15.. Valid values are `^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$`',
    `invoice_date` DATE COMMENT 'Date on which the invoice was created and issued to the customer. Determines the start of payment terms calculation and revenue recognition trigger date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `invoice_number` STRING COMMENT 'Business-facing invoice number assigned by SAP S/4HANA SD-FI billing integration. This is the externally communicated reference printed on the invoice document sent to the customer.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `invoice_type` STRING COMMENT 'Classification of the invoice document type. Distinguishes standard customer invoices from credit memos, debit memos, intercompany invoices, and pro-forma invoices.. Valid values are `standard|credit_memo|debit_memo|pro_forma|intercompany|down_payment|cancellation`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the AR invoice record in the source system. Used for incremental data loading, change detection, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `local_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the company code local currency. Used for local statutory reporting and GAAP compliance.. Valid values are `^[A-Z]{3}$`',
    `net_amount` DECIMAL(18,2) COMMENT 'Invoice amount excluding taxes, in the invoice transaction currency. Represents the revenue-recognizable value of goods and services delivered.',
    `open_amount` DECIMAL(18,2) COMMENT 'Remaining unpaid amount on the invoice in the transaction currency. Calculated as gross amount minus payments received and credit memos applied. Drives AR aging and cash collection.',
    `payer_account_number` STRING COMMENT 'SAP account number of the payer party responsible for making payment, which may differ from the bill-to customer in complex customer hierarchies.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `payment_block` STRING COMMENT 'SAP payment block indicator applied to the invoice to prevent automatic payment processing (e.g., R for review, D for dispute). Blank indicates no block.. Valid values are `^[A-Z ]?$`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms key (e.g., NT30, NT60, 2/10NET30) defining the payment deadline and any applicable early payment discount conditions.. Valid values are `^[A-Z0-9]{1,10}$`',
    `payment_terms_description` STRING COMMENT 'Human-readable description of the payment terms (e.g., Net 30 Days, 2% 10 Net 30). Supports invoice presentation and customer communication.',
    `posting_date` DATE COMMENT 'Date on which the invoice was posted to the general ledger in SAP FI. Determines the accounting period for revenue and AR recognition.. Valid values are `^d{4}-d{2}-d{2}$`',
    `profit_center` STRING COMMENT 'SAP profit center to which the invoice revenue is assigned. Supports internal profitability reporting, EBITDA analysis, and management accounting.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `reference_document_number` STRING COMMENT 'External reference number provided by the customer (e.g., customer Purchase Order number) associated with this invoice. Supports customer payment matching and remittance reconciliation.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `revenue_recognition_status` STRING COMMENT 'Current status of revenue recognition for this invoice under IFRS 15 / ASC 606. Indicates whether revenue has been recognized, deferred, or is pending performance obligation fulfillment.. Valid values are `pending|recognized|deferred|partially_recognized|reversed`',
    `sales_organization` STRING COMMENT 'SAP sales organization responsible for the sale. Determines pricing, revenue assignment, and reporting hierarchy for the invoice.. Valid values are `^[A-Z0-9]{1,10}$`',
    `status` STRING COMMENT 'Lifecycle status of the AR invoice record. active indicates a valid open or cleared invoice; cancelled or reversed indicates the invoice has been voided; on_hold indicates a payment hold.. Valid values are `active|cancelled|reversed|on_hold`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount (VAT, GST, sales tax) charged on the invoice in the transaction currency. Supports tax reporting and compliance with local tax authorities.',
    `tax_jurisdiction_code` STRING COMMENT 'Tax jurisdiction code used to determine applicable tax rates and rules for the invoice. Supports multi-jurisdiction tax compliance (VAT, GST, sales tax).. Valid values are `^[A-Z0-9-]{1,20}$`',
    CONSTRAINT pk_ar_invoice PRIMARY KEY(`ar_invoice_id`)
) COMMENT 'Transactional record for customer invoices issued by Manufacturing for goods and services delivered. Captures invoice number, billing document reference, customer account, invoice date, due date, payment terms, gross amount, tax amount, net amount, revenue recognition status, dunning level, clearing status, and dispute indicator. Sourced from SAP S/4HANA SD-FI billing integration. Distinct from billing.invoice which manages the billing generation process; this record represents the AR open item and cash collection lifecycle.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`payment` (
    `payment_id` BIGINT COMMENT 'Unique surrogate identifier for each payment transaction record in the finance data product. Serves as the primary key for the payment entity in the Databricks Silver Layer.',
    `bank_account_id` BIGINT COMMENT 'Internal identifier of the companys house bank account used to execute or receive the payment. References the bank account master data in SAP, enabling bank statement reconciliation and liquidity management. Not a full account number (PCI-sensitive data is masked).. Valid values are `^[A-Z0-9_-]{1,35}$`',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: payment.cost_center (STRING) is a denormalized reference to the cost_center master. Adding cost_center_id FK normalizes cost center assignment on payments for management accounting cost tracking.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: payment uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-level cash fl',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: payment.gl_account (STRING) is a denormalized reference to the gl_account master. Adding gl_account_id FK normalizes the clearing GL account assignment on payments for proper cash and bank reconciliat',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: payment.company_code (STRING) is a denormalized reference to the legal_entity master. Adding legal_entity_id FK normalizes entity scoping on payments for multi-entity cash management and statutory rep',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Payments reference originating purchase orders for payment reconciliation and audit trail. AP teams match payments to POs during three-way match process.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Payments are made to suppliers with bank account and remittance details from supplier master. Treasury executes payment runs using supplier banking information.',
    `run_id` BIGINT COMMENT 'Identifier of the automated payment run (F110 in SAP) that generated this payment. Groups all payment documents produced in a single batch execution of the payment program, enabling run-level reconciliation and audit.. Valid values are `^[A-Z0-9_-]{1,30}$`',
    `amount` DECIMAL(18,2) COMMENT 'The gross payment amount in the transaction currency. For outgoing payments, this is the amount disbursed to the payee. For incoming payments, this is the amount received from the payer. Stored with 4 decimal places to support high-precision currencies.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    `amount_group_currency` DECIMAL(18,2) COMMENT 'The payment amount translated to the group (consolidation) currency for multinational consolidated financial reporting. Supports EBITDA, COGS, and group-level cash flow reporting under IFRS and GAAP.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    `amount_local` DECIMAL(18,2) COMMENT 'The payment amount converted to the local (company code) currency using the exchange rate at the time of posting. Used for statutory reporting, local GAAP compliance, and legal entity financial statements.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    `block` STRING COMMENT 'SAP payment block key indicating whether the payment is blocked from processing and the reason (e.g., R = manual block, A = blocked for payment, blank = not blocked). Used for payment approval workflows and dispute management.. Valid values are `^[A-Z0-9 ]{0,2}$`',
    `business_area` STRING COMMENT 'SAP business area associated with the payment, representing a distinct operational segment or division within the company code. Supports segment-level financial reporting and internal management accounting.. Valid values are `^[A-Z0-9]{1,6}$`',
    `clearing_date` DATE COMMENT 'The date on which the open item (invoice or credit memo) was cleared against this payment in the sub-ledger. Used for days payable outstanding (DPO), days sales outstanding (DSO), and aging analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `clearing_document_number` STRING COMMENT 'The SAP document number of the clearing document that offsets the open item (invoice or credit memo) against this payment. Used for AP/AR sub-ledger reconciliation and open item management.. Valid values are `^[A-Z0-9]{1,20}$`',
    `company_code` STRING COMMENT 'The SAP company code representing the legal entity that owns and posts the payment. Enables legal entity-level financial reporting, statutory compliance, and multi-entity consolidation across geographies.. Valid values are `^[A-Z0-9]{1,6}$`',
    `cost_center` STRING COMMENT 'The cost center to which the payment is attributed for internal cost accounting and OPEX/CAPEX tracking. Enables departmental cost allocation, budget variance analysis, and management reporting.. Valid values are `^[A-Z0-9]{1,10}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the legal entity or bank account country associated with the payment. Supports country-level regulatory reporting, REACH/RoHS compliance tracking, and multi-jurisdictional tax obligations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the payment record was first created in the source system (SAP S/4HANA FI). Used for audit trail, data lineage, and Silver Layer ingestion tracking. Formatted as yyyy-MM-ddTHH:mm:ss.SSSXXX.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the transaction currency in which the payment is denominated (e.g., USD, EUR, GBP, JPY). Supports multi-currency operations across global legal entities.. Valid values are `^[A-Z]{3}$`',
    `date` DATE COMMENT 'The value date on which the payment is executed and funds are transferred or received. Used for cash flow reporting, bank reconciliation, and period-close activities. Formatted as yyyy-MM-dd.. Valid values are `^d{4}-d{2}-d{2}$`',
    `direction` STRING COMMENT 'Indicates whether the payment is outgoing (disbursement to a supplier via AP) or incoming (cash receipt from a customer via AR). Drives cash flow classification and reporting.. Valid values are `outgoing|incoming`',
    `discount_amount` DECIMAL(18,2) COMMENT 'The early payment cash discount amount deducted from the gross invoice amount when payment is made within the discount period. Impacts net payment amount and is tracked for cash discount income/expense reporting.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    `document_date` DATE COMMENT 'The date of the original source document (e.g., check date, bank transfer initiation date) that triggered the payment. Used for document-level audit and aging analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_number` STRING COMMENT 'The financial document number assigned by SAP S/4HANA FI upon posting of the payment transaction. Used for audit trail, clearing, and reconciliation purposes across AP and AR processes.. Valid values are `^[A-Z0-9]{1,20}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied at the time of payment posting to convert the transaction currency amount to the local currency. Sourced from SAP exchange rate tables. Stored with 6 decimal places for precision.. Valid values are `^d{1,9}(.d{1,6})?$`',
    `exchange_rate_type` STRING COMMENT 'The SAP exchange rate type used for currency conversion (e.g., M = standard translation at average rate, B = bank buying rate, G = bank selling rate). Determines which rate table is applied for the conversion.. Valid values are `^[A-Z0-9]{1,4}$`',
    `fiscal_period` STRING COMMENT 'The fiscal posting period (1–16, including special periods) within the fiscal year to which the payment is assigned. Supports period-level financial reporting and month-end close reconciliation.. Valid values are `^(1[0-6]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which the payment posting belongs, as determined by the company code fiscal year variant in SAP. Used for period-close, statutory reporting, and EBITDA/COGS analysis.. Valid values are `^d{4}$`',
    `gl_account` STRING COMMENT 'The General Ledger (GL) account number to which the payment is posted in the chart of accounts. Determines the balance sheet or P&L line item impacted by the payment for financial statement preparation.. Valid values are `^[0-9]{1,10}$`',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the group consolidation currency (e.g., USD for a US-headquartered multinational). Used for consolidated financial reporting across all legal entities.. Valid values are `^[A-Z]{3}$`',
    `house_bank` STRING COMMENT 'The SAP house bank key identifying the bank institution through which the payment is processed. Used for bank-level cash position reporting, bank fee analysis, and treasury management.. Valid values are `^[A-Z0-9]{1,10}$`',
    `is_reversed` BOOLEAN COMMENT 'Boolean flag indicating whether this payment document has been reversed (cancelled) in the general ledger. A value of True means the payment has been voided and a reversal document exists. Used for audit trail and reconciliation.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to the payment record in the source system. Used for incremental data loading, change data capture (CDC), and audit trail in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `local_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the company codes local (functional) currency. Used for local statutory reporting and legal entity financial statements.. Valid values are `^[A-Z]{3}$`',
    `method` STRING COMMENT 'The instrument or mechanism used to execute the payment. Examples include bank transfer, check, ACH (Automated Clearing House), SEPA (Single Euro Payments Area) credit transfer, wire transfer, or direct debit. Sourced from SAP payment method configuration.. Valid values are `bank_transfer|check|ach|sepa|wire|direct_debit|other`',
    `method_supplement` STRING COMMENT 'Additional qualifier for the payment method, used in SAP to differentiate variants within a payment method (e.g., domestic vs. international wire, standard vs. express ACH). Supports bank-specific routing and format selection.',
    `posting_date` DATE COMMENT 'The accounting date on which the payment document is posted to the general ledger. Determines the fiscal period and year to which the transaction is assigned. May differ from payment_date due to bank processing lags.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reference` STRING COMMENT 'Free-text or structured reference transmitted with the payment to the bank or counterparty (e.g., remittance information, payment advice text, check memo line). Used for bank statement matching and counterparty reconciliation.',
    `reference_document_number` STRING COMMENT 'External reference number associated with the payment, such as the suppliers invoice number, customers remittance advice reference, or bank transaction reference. Supports cross-system reconciliation and audit.. Valid values are `^[A-Z0-9/-]{1,30}$`',
    `reversal_date` DATE COMMENT 'The date on which the payment reversal was posted to the general ledger. Populated only when is_reversed = True. Used for period-close adjustments and audit trail.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reversal_document_number` STRING COMMENT 'The SAP document number of the reversal (cancellation) document created when this payment is voided. Populated only when is_reversed = True. Enables complete audit trail for reversed payment transactions.. Valid values are `^[A-Z0-9]{1,20}$`',
    `status` STRING COMMENT 'Current lifecycle status of the payment transaction. Tracks progression from proposal through approval, bank processing, GL posting, clearing, and potential reversal or rejection. Critical for cash management and AP/AR reconciliation.. Valid values are `proposed|approved|in_process|posted|cleared|reversed|rejected|on_hold`',
    `type` STRING COMMENT 'Classifies the nature of the payment transaction: AP payment run to suppliers, AR cash receipt from customers, intercompany settlement, employee expense reimbursement, tax remittance, or other. Supports sub-ledger reconciliation and reporting.. Valid values are `ap_payment|ar_receipt|intercompany|employee_expense|tax_payment|other`',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'The amount of withholding tax (WHT) deducted from the payment at source, as required by local tax regulations. Relevant for cross-border supplier payments and statutory tax reporting obligations.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    CONSTRAINT pk_payment PRIMARY KEY(`payment_id`)
) COMMENT 'Transactional record capturing outgoing and incoming payment transactions processed through the finance function. Records payment document number, payment date, payment method (bank transfer, check, ACH, SEPA), payment amount, currency, exchange rate, bank account used, clearing document references, payment run identifier, and payment status. Covers both AP payment runs to suppliers and AR cash receipts from customers. Sourced from SAP S/4HANA FI payment program.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`bank_account` (
    `bank_account_id` BIGINT COMMENT 'Unique surrogate identifier for each corporate bank account record in the Manufacturing enterprise. Serves as the primary key for the bank_account data product in the finance domain silver layer.',
    `cash_pool_id` BIGINT COMMENT 'Identifier of the cash pooling structure to which this bank account belongs. Cash pooling (notional or physical) is used by Manufacturing treasury to optimize liquidity across legal entities and reduce external borrowing costs.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: bank_account.gl_account_code (STRING) is a denormalized reference to the gl_account master. Each bank account is mapped to a GL account for cash and bank reconciliation. Adding gl_account_id FK normal',
    `account_id` BIGINT COMMENT 'The SAP house bank account ID (sub-account key) within the house bank configuration in SAP S/4HANA. Together with house_bank_id, uniquely identifies the bank account in SAP payment programs and electronic bank statement processing.. Valid values are `^[A-Z0-9]{1,5}$`',
    `house_bank_id` BIGINT COMMENT 'The SAP house bank identifier assigned to the banking institution in SAP S/4HANA FI-TR. Used to link the bank account to the corresponding house bank configuration for payment program execution and bank statement processing.. Valid values are `^[A-Z0-9]{1,5}$`',
    `account_close_date` DATE COMMENT 'The date on which the bank account was or is scheduled to be closed. Null for active accounts. Used for account lifecycle management and treasury decommissioning processes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `account_currency` STRING COMMENT 'The ISO 4217 three-letter currency code in which the bank account is denominated (e.g., USD, EUR, GBP, JPY). Drives multi-currency consolidation and foreign exchange exposure reporting.. Valid values are `^[A-Z]{3}$`',
    `account_number` STRING COMMENT 'The domestic bank account number assigned by the banking institution to the corporate account. Used for domestic payment processing and cash positioning. May differ from IBAN in non-SEPA regions.. Valid values are `^[A-Z0-9]{1,34}$`',
    `account_open_date` DATE COMMENT 'The date on which the bank account was officially opened with the banking institution. Used for account lifecycle management, audit trails, and regulatory reporting of account tenure.. Valid values are `^d{4}-d{2}-d{2}$`',
    `account_purpose` STRING COMMENT 'The designated business purpose for which the bank account is used within Manufacturing treasury operations. Supports segregation of funds, internal controls, and cash flow categorization for CAPEX/OPEX tracking.. Valid values are `operating|payroll|tax|intercompany|vendor_payment|customer_collection|petty_cash|investment|escrow|regulatory_reserve`',
    `account_type` STRING COMMENT 'Classification of the bank account by its operational purpose. Current accounts are used for day-to-day operations; deposit accounts for term investments; payroll accounts for employee salary disbursements; zero balance accounts for cash concentration; notional pooling for treasury cash pooling structures.. Valid values are `current|savings|deposit|payroll|escrow|zero_balance|notional_pooling|overdraft`',
    `authorized_signatory_1` STRING COMMENT 'Full name of the primary authorized signatory for the bank account, as registered with the banking institution. Required for bank mandate documentation, internal controls, and audit compliance.',
    `authorized_signatory_2` STRING COMMENT 'Full name of the secondary authorized signatory for the bank account, as registered with the banking institution. Supports dual-control authorization requirements for high-value payment transactions.',
    `bank_branch_name` STRING COMMENT 'The name of the specific branch of the banking institution where the account is maintained. Relevant for domestic accounts where branch-level identification is required for payment routing.',
    `bank_city` STRING COMMENT 'The city where the banking institution or branch is located. Used for bank relationship management and payment routing documentation.',
    `bank_contact_email` STRING COMMENT 'Email address of the primary relationship manager or contact person at the banking institution. Used for treasury operations communication and bank relationship management.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `bank_contact_name` STRING COMMENT 'Name of the primary relationship manager or contact person at the banking institution responsible for this account. Used for bank relationship management and escalation during payment disputes or account issues.',
    `bank_country` STRING COMMENT 'The ISO 3166-1 alpha-3 country code of the country where the banking institution is domiciled. Used for multi-currency consolidation, regulatory reporting, and cross-border payment compliance.. Valid values are `^[A-Z]{3}$`',
    `bank_key` STRING COMMENT 'The country-specific bank identification key used in SAP S/4HANA to identify the bank (e.g., BLZ in Germany, BSB in Australia, IFSC in India). Complements SWIFT/BIC for domestic payment routing.',
    `bank_name` STRING COMMENT 'The full legal name of the banking institution where the corporate account is held (e.g., Deutsche Bank AG, JPMorgan Chase Bank N.A.). Used for treasury reporting and bank relationship management.',
    `bank_routing_number` STRING COMMENT 'The American Bankers Association (ABA) routing transit number for US-domiciled bank accounts. Used for ACH and domestic wire payment routing in the United States.. Valid values are `^[0-9]{9}$`',
    `bank_statement_format` STRING COMMENT 'The electronic bank statement format used for automated reconciliation in SAP S/4HANA FI. MT940 and CAMT.053 are SWIFT/ISO 20022 formats; BAI2 is the US standard; OFX is used for online banking integrations.. Valid values are `MT940|CAMT053|BAI2|OFX|CSV|MANUAL`',
    `blocked_reason` STRING COMMENT 'The reason code explaining why the bank account has been blocked or restricted from payment processing. Populated only when status is blocked or under_review. Supports internal controls and audit documentation.. Valid values are `regulatory_hold|fraud_investigation|dormancy|signatory_change|audit_hold|bank_request|other`',
    `cash_pool_role` STRING COMMENT 'The role of this bank account within the cash pooling structure. Header accounts aggregate balances from participant accounts; participant accounts contribute to or draw from the pool. Not applicable for accounts outside a pooling arrangement.. Valid values are `header|participant|not_applicable`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the bank account master record was first created in the Manufacturing data platform. Supports audit trail requirements and data lineage tracking for SOX compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Free-text description of the bank account providing additional context about its purpose, restrictions, or special characteristics. Used for treasury documentation and internal reporting.',
    `electronic_banking_enabled` BOOLEAN COMMENT 'Indicates whether electronic banking (e-banking) services are activated for this account, enabling automated bank statement downloads (MT940/CAMT.053) and electronic payment file submission in SAP S/4HANA FI.. Valid values are `true|false`',
    `iban` STRING COMMENT 'The International Bank Account Number (IBAN) assigned to the corporate bank account, used for cross-border payment processing and SEPA transactions. Mandatory for accounts in SEPA-participating countries.. Valid values are `^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$`',
    `intercompany_flag` BOOLEAN COMMENT 'Indicates whether this bank account is designated for intercompany transactions between Manufacturing legal entities. Intercompany accounts require special handling for consolidation elimination and transfer pricing compliance.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to the bank account master record. Used for change tracking, audit compliance, and incremental data pipeline processing in the Databricks silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reconciliation_date` DATE COMMENT 'The date of the most recent bank statement reconciliation performed for this account in SAP S/4HANA FI. Supports month-end close processes and audit compliance for accounts payable and receivable.. Valid values are `^d{4}-d{2}-d{2}$`',
    `overdraft_limit` DECIMAL(18,2) COMMENT 'The maximum overdraft facility amount authorized by the banking institution for this account, expressed in the account currency. Used for liquidity planning and credit facility monitoring in treasury operations.',
    `payment_method_allowed` STRING COMMENT 'Comma-separated list of payment methods authorized for use with this bank account (e.g., ACH, WIRE, CHECK, SEPA_CT, SEPA_DD, SWIFT). Drives payment program configuration in SAP S/4HANA FI-AP and FI-AR.',
    `payroll_account_flag` BOOLEAN COMMENT 'Indicates whether this bank account is designated exclusively for payroll disbursements. Payroll accounts are subject to additional internal controls, segregation of duties requirements, and labor law compliance.. Valid values are `true|false`',
    `signing_authority_type` STRING COMMENT 'The type of signing authority required to authorize transactions on this bank account. Single authority allows one signatory; dual authority requires two signatories; board resolution or power of attorney may be required for specific transaction types.. Valid values are `single|dual|board_resolution|power_of_attorney`',
    `sort_code` STRING COMMENT 'The six-digit sort code identifying the bank and branch for UK-domiciled accounts. Used for BACS, CHAPS, and Faster Payments routing in the United Kingdom.. Valid values are `^[0-9]{6}$`',
    `status` STRING COMMENT 'Current operational status of the bank account. Active accounts are available for payment processing; blocked accounts are temporarily restricted; pending_closure accounts are in the decommissioning process; closed accounts are permanently deactivated.. Valid values are `active|inactive|blocked|pending_closure|closed|under_review`',
    `swift_bic_code` STRING COMMENT 'The SWIFT/BIC code identifying the banking institution and branch for international wire transfers and correspondent banking. Consists of 8 or 11 alphanumeric characters per ISO 9362 standard.. Valid values are `^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$`',
    CONSTRAINT pk_bank_account PRIMARY KEY(`bank_account_id`)
) COMMENT 'Master record for all corporate bank accounts held by Manufacturing legal entities across global banking institutions. Captures bank account number, IBAN, SWIFT/BIC code, bank name, bank country, account currency, account type (current, deposit, payroll), house bank identifier, cash pool membership, signatory details, and account status. Used for payment processing, cash positioning, and treasury operations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`asset_transaction` (
    `asset_transaction_id` BIGINT COMMENT 'Unique surrogate identifier for each financial transaction record on a fixed asset within the lakehouse silver layer. Serves as the primary key for the asset_transaction data product.',
    `asset_register_id` BIGINT COMMENT 'Foreign key linking to finance.asset_register. Business justification: asset_transaction.asset_number (STRING) and asset_sub_number (STRING) are denormalized references to the asset_register master. Adding asset_register_id FK creates the essential parent-child relations',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: asset_transaction.cost_center (STRING) is a denormalized reference to the cost_center master. Adding cost_center_id FK normalizes cost center assignment on asset transactions for depreciation cost all',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: asset_transaction uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-lev',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: asset_transaction.gl_account_number (STRING) is a denormalized reference to the gl_account master. Adding gl_account_id FK normalizes the GL account assignment on asset transactions for proper financi',
    `it_asset_id` BIGINT COMMENT 'Foreign key linking to technology.it_asset. Business justification: Asset transactions (acquisitions, disposals, transfers, impairments) for IT equipment must reference the specific IT asset for audit trail and financial statement accuracy.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: asset_transaction.company_code (STRING) is a denormalized reference to the legal_entity master. Adding legal_entity_id FK normalizes entity scoping on asset transactions for multi-entity CAPEX reporti',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: asset_transaction.profit_center (STRING) is a denormalized reference to the profit_center master. Adding profit_center_id FK normalizes profit center assignment on asset transactions for profitability',
    `accumulated_depreciation` DECIMAL(18,2) COMMENT 'The total accumulated depreciation charged against the asset in local currency as of the transaction posting date. Used for balance sheet presentation and asset impairment analysis.',
    `amount_group_currency` DECIMAL(18,2) COMMENT 'The asset transaction amount translated into the group reporting currency for consolidated financial statements. Supports multi-currency consolidation and group-level CAPEX/EBITDA reporting.',
    `amount_local_currency` DECIMAL(18,2) COMMENT 'The asset transaction amount translated into the company code local (functional) currency. Used for statutory reporting and local GAAP financial statements of the legal entity.',
    `asset_class_code` STRING COMMENT 'The SAP FI-AA asset class code categorizing the fixed asset (e.g., machinery, buildings, vehicles, IT equipment, leasehold improvements). Drives depreciation method, useful life, and account determination for the transaction.. Valid values are `^[A-Z0-9]{4,8}$`',
    `asset_value_date` DATE COMMENT 'The date from which the asset transaction takes effect for asset valuation and depreciation calculation purposes. May differ from the posting date; used to determine the start of depreciation for acquisitions or the end date for retirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `capex_opex_indicator` STRING COMMENT 'Classifies the asset transaction as Capital Expenditure (CAPEX) or Operational Expenditure (OPEX) for financial reporting, budgeting, and tax purposes. Critical for EBITDA calculation and management reporting.. Valid values are `CAPEX|OPEX`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or organizational unit for which the asset transaction is posted. Enables multi-entity financial consolidation and statutory reporting across geographies.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center` STRING COMMENT 'The SAP Controlling (CO) cost center to which the asset and its depreciation charges are assigned. Enables cost accounting allocation of depreciation and asset-related costs to organizational units for management reporting.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the asset transaction record was created in the source system (SAP FI-AA). Provides the audit creation timestamp for data lineage, SOX compliance, and period-end close verification.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `depreciation_area` STRING COMMENT 'SAP FI-AA depreciation area code identifying the valuation view under which the transaction is posted (e.g., 01=Book depreciation/IFRS, 02=Tax depreciation, 15=GAAP local, 30=Cost accounting). Enables parallel valuation for multi-GAAP and tax reporting.. Valid values are `^[0-9]{2}$`',
    `depreciation_key` STRING COMMENT 'The SAP FI-AA depreciation key defining the depreciation method and calculation rules applied to the asset at the time of the transaction (e.g., LINR=Straight-line, DGRV=Declining balance). Relevant for depreciation postings and impairment testing.. Valid values are `^[A-Z0-9]{4}$`',
    `document_date` DATE COMMENT 'The date of the originating source document (e.g., vendor invoice date, transfer order date, retirement approval date) that triggered the asset transaction. Used for audit trail and document matching.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_number` STRING COMMENT 'The SAP FI accounting document number generated when the asset transaction is posted to the general ledger. Serves as the primary audit trail reference linking the asset transaction to the GL posting.. Valid values are `^[A-Z0-9]{10}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to translate the transaction currency amount into the local currency at the time of posting. Sourced from SAP exchange rate tables and used for audit and revaluation purposes.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month 1–12, or special periods 13–16) within the fiscal year in which the asset transaction is posted. Supports period-end close, monthly depreciation runs, and period-level CAPEX/OPEX reporting.. Valid values are `^([1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the asset transaction is recorded, as determined by the company code fiscal year variant. Used for annual CAPEX reporting, depreciation schedules, and statutory financial statements.. Valid values are `^d{4}$`',
    `gl_account_number` STRING COMMENT 'The general ledger account number to which the asset transaction is posted, as determined by SAP account determination rules. Links the asset transaction to the chart of accounts for financial statement preparation.. Valid values are `^[0-9]{6,10}$`',
    `group_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the group consolidation currency in which the group currency amount is expressed (e.g., USD for a US-headquartered multinational).. Valid values are `^[A-Z]{3}$`',
    `intercompany_flag` BOOLEAN COMMENT 'Indicates whether the asset transaction involves an intercompany transfer between two legal entities within the same corporate group. True for intercompany asset transfers requiring elimination in consolidated financial statements.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the asset transaction record was last modified in the source system. Supports incremental data loading in the Databricks lakehouse silver layer and audit trail for change tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `local_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the company code functional (local) currency in which the local currency amount is expressed. Enables statutory reporting in the entitys home currency.. Valid values are `^[A-Z]{3}$`',
    `net_book_value_after` DECIMAL(18,2) COMMENT 'The net book value (carrying amount) of the asset in local currency immediately after the transaction is applied. Provides the closing balance and is used for balance sheet reporting and impairment assessment.',
    `net_book_value_before` DECIMAL(18,2) COMMENT 'The net book value (carrying amount) of the asset in local currency immediately before the transaction is applied. Provides the opening balance for the transaction and is essential for impairment testing and audit compliance.',
    `posting_date` DATE COMMENT 'The date on which the asset transaction is posted to the general ledger. Determines the fiscal period and fiscal year assignment for financial reporting and period-end close processes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `posting_status` STRING COMMENT 'Current processing status of the asset transaction in the financial system. Indicates whether the transaction has been fully posted to the general ledger, reversed, parked for approval, blocked, or cleared.. Valid values are `posted|reversed|parked|blocked|cleared`',
    `profit_center` STRING COMMENT 'The SAP Controlling profit center associated with the asset transaction, enabling segment-level profitability analysis and EBITDA reporting by business unit or product line.. Valid values are `^[A-Z0-9]{4,10}$`',
    `reference_document_number` STRING COMMENT 'External or upstream reference document number associated with the asset transaction, such as a purchase order number, vendor invoice number, or internal transfer order number. Supports cross-system traceability and audit compliance.',
    `remaining_useful_life_years` DECIMAL(18,2) COMMENT 'The remaining useful life of the asset in years at the time of the transaction posting. Used for impairment testing, depreciation recalculation, and asset lifecycle reporting.',
    `reversal_document_number` STRING COMMENT 'The SAP FI document number of the original transaction that this record reverses, or the document number of the reversal document if this transaction was itself reversed. Enables complete audit trail for corrected postings.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this asset transaction is a reversal of a previously posted transaction. True if the transaction was created to reverse an erroneous or incorrect prior posting. Supports audit trail integrity and period-end correction processes.. Valid values are `true|false`',
    `transaction_amount` DECIMAL(18,2) COMMENT 'The gross financial amount of the asset transaction posted in the transaction currency. Represents the acquisition cost, retirement proceeds, write-down amount, or depreciation charge depending on the transaction type.',
    `transaction_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the currency in which the asset transaction amount is originally denominated (e.g., USD, EUR, GBP). Supports multi-currency asset accounting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `transaction_text` STRING COMMENT 'Free-text description or narrative entered at the time of posting the asset transaction, providing additional context about the nature of the financial movement (e.g., Acquisition of CNC machine line 3, Partial retirement due to component replacement).',
    `transaction_type_category` STRING COMMENT 'Business-level classification of the asset transaction category, grouping SAP transaction type codes into meaningful financial movement categories for CAPEX reporting, impairment testing, and audit compliance.. Valid values are `acquisition|retirement|transfer|write_down|write_up|depreciation|amortization|impairment|revaluation|capitalization|partial_retirement|scrapping`',
    `transaction_type_code` STRING COMMENT 'SAP FI-AA transaction type code identifying the nature of the financial movement on the asset (e.g., 100=External acquisition, 200=Retirement, 300=Transfer, 400=Write-down, 600=Depreciation posting). Drives posting logic and account determination.. Valid values are `^[A-Z0-9]{2,6}$`',
    `useful_life_years` DECIMAL(18,2) COMMENT 'The total expected useful life of the asset in years at the time of the transaction, used to calculate the depreciation charge. May be revised upon impairment testing or asset revaluation.',
    `wbs_element` STRING COMMENT 'The SAP Project System Work Breakdown Structure element associated with the asset transaction, used for capital project tracking and CAPEX settlement from projects to fixed assets.',
    CONSTRAINT pk_asset_transaction PRIMARY KEY(`asset_transaction_id`)
) COMMENT 'Transactional record capturing all financial movements on fixed assets including acquisitions, retirements, transfers, write-downs, and depreciation postings. Records transaction type, posting date, amount, depreciation area, document reference, and asset value date. Provides the complete financial history of each capitalized asset for CAPEX reporting, impairment testing, and audit compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`budget` (
    `budget_id` BIGINT COMMENT 'Unique system-generated identifier for each budget record within the Manufacturing enterprise financial planning system.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: budget.controlling_area (STRING) is a denormalized reference to the controlling_area master. Budgets are scoped to controlling areas in SAP CO. Adding controlling_area_id FK normalizes this organizati',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: budget.cost_center_code (STRING) is a denormalized reference to the cost_center master. Budgets are planned at the cost center level. Adding cost_center_id FK normalizes this planning dimension.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: budget uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-level budget v',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: budget.gl_account_number (STRING) is a denormalized reference to the gl_account master. Budgets are planned at the GL account level. Adding gl_account_id FK normalizes this financial dimension.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: budget.company_code (STRING) is a denormalized reference to the legal_entity master. Budgets are owned by specific legal entities. Adding legal_entity_id FK normalizes entity scoping for multi-entity ',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: budget.profit_center_code (STRING) is a denormalized reference to the profit_center master. Budgets are planned at the profit center level. Adding profit_center_id FK normalizes this planning dimensio',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Each budget (department, project) has an accountable manager. Manufacturing requires budget ownership for approval and variance analysis. Core financial control process.',
    `amount` DECIMAL(18,2) COMMENT 'The planned budget amount in the transaction currency for the specified fiscal year, period, cost center, and cost element combination. This is the primary financial value of the budget record.',
    `amount_group_currency` DECIMAL(18,2) COMMENT 'The budget amount converted to the group reporting currency (e.g., USD or EUR) for consolidated financial reporting and cross-entity variance analysis at the corporate level.',
    `amount_local_currency` DECIMAL(18,2) COMMENT 'The budget amount converted to the legal entitys functional (local) currency. Used for statutory reporting and local compliance purposes where the transaction currency differs from the functional currency.',
    `approval_date` DATE COMMENT 'The calendar date on which the budget record received final approval. Used for audit trail, compliance reporting, and determining the effective date of the approved budget.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `approval_status` STRING COMMENT 'Current workflow status of the budget record in the approval lifecycle. Draft indicates work-in-progress; submitted means sent for review; approved means authorized for use; locked means frozen for reporting and no further changes are permitted.. Valid values are `draft|submitted|under_review|approved|rejected|withdrawn|locked`',
    `approved_by` STRING COMMENT 'Username or employee ID of the individual who granted final approval for this budget record. Supports audit trail requirements and Sarbanes-Oxley (SOX) internal control documentation.',
    `availability_control_active` BOOLEAN COMMENT 'Indicates whether SAP S/4HANA budget availability control is active for this budget record. When true, the system enforces budget limits and prevents or warns on postings that would exceed the approved budget.. Valid values are `true|false`',
    `category` STRING COMMENT 'Classifies the budget planning horizon and purpose. Annual covers a single fiscal year; multi-year spans multiple years; supplemental is an approved addition to an existing budget; contingency is a reserve allocation; rolling forecast is a continuously updated projection.. Valid values are `annual|multi_year|supplemental|contingency|rolling_forecast`',
    `commitment_amount` DECIMAL(18,2) COMMENT 'The portion of the budget already committed through purchase orders, contracts, or reservations but not yet invoiced. Used for available budget calculation and funds management in SAP S/4HANA.',
    `company_code` STRING COMMENT 'SAP S/4HANA company code representing the legal entity for which this budget is defined. Aligns to the legal entity master and determines the applicable chart of accounts, fiscal year variant, and currency.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_element_code` STRING COMMENT 'SAP S/4HANA cost element (primary or secondary) associated with this budget line. Cost elements classify the nature of costs (e.g., raw materials, labor, depreciation) for management accounting purposes.. Valid values are `^[0-9]{6,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this budget record was first created in the system, recorded in ISO 8601 format with timezone offset. Supports audit trail and data lineage requirements.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `distribution_key` STRING COMMENT 'SAP S/4HANA distribution key that defines how the annual budget amount is spread across fiscal periods (e.g., equal monthly distribution, seasonal weighting, or manual allocation). Drives period-level budget availability.. Valid values are `^[A-Z0-9]{1,6}$`',
    `end_date` DATE COMMENT 'The last calendar date of the budget planning period. For annual budgets this is the fiscal year end date; for multi-year or project budgets this may span multiple years.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the budget amount from transaction currency to local and group currencies. Typically the planning exchange rate set at the beginning of the fiscal year for budget purposes.',
    `exchange_rate_type` STRING COMMENT 'SAP S/4HANA exchange rate type used for currency translation (e.g., M = standard rate, P = planning rate, B = bank buying rate). Determines which rate table is applied for budget currency conversion.. Valid values are `^[A-Z0-9]{1,4}$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year to which this budget line applies. Values 1–12 represent standard monthly periods; 13–16 are special closing periods used in SAP S/4HANA for year-end adjustments.. Valid values are `^(1[0-6]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this budget record applies, as defined by the legal entitys fiscal year variant in SAP S/4HANA. May differ from calendar year depending on the entitys fiscal year end configuration.. Valid values are `^[0-9]{4}$`',
    `functional_area` STRING COMMENT 'Classifies the budget by business function for segment and functional reporting. Supports IFRS 8 segment reporting and GAAP functional expense classification (e.g., cost of goods sold, selling, general and administrative).. Valid values are `production|sales|administration|research_development|procurement|logistics|quality|maintenance|finance|it`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this budget record was most recently updated, recorded in ISO 8601 format with timezone offset. Used for change tracking, incremental data loads, and audit compliance.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `notes` STRING COMMENT 'Free-text field for budget planners and approvers to document assumptions, justifications, revision rationale, or special instructions associated with this budget record.',
    `number` STRING COMMENT 'Human-readable business identifier for the budget record, used for cross-system reference and communication with finance stakeholders.. Valid values are `^BDG-[0-9]{4}-[A-Z0-9]{6,12}$`',
    `plan_version_number` STRING COMMENT 'Sequential version number of the budget plan within the same fiscal year and budget type. Increments each time a revised or updated version is created, enabling version history tracking and comparison.. Valid values are `^[0-9]+$`',
    `planning_method` STRING COMMENT 'The methodology used to derive the budget amounts. Top-down allocates from corporate targets; bottom-up aggregates from operational units; zero-based requires full justification from zero; activity-based links costs to activities; incremental adjusts prior year actuals; rolling continuously updates the forecast horizon.. Valid values are `top_down|bottom_up|zero_based|activity_based|incremental|rolling`',
    `source_system` STRING COMMENT 'Identifies the originating operational system from which this budget record was sourced or entered. Supports data lineage tracking in the Databricks Silver Layer and reconciliation with upstream systems.. Valid values are `SAP_S4HANA|POWER_BI|MANUAL|ARIBA|EXTERNAL`',
    `start_date` DATE COMMENT 'The first calendar date of the budget planning period. Used for multi-year and project budgets where the period may not align to a single fiscal year.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `submission_date` DATE COMMENT 'The calendar date on which the budget record was formally submitted for review and approval. Used to track planning cycle adherence and budget governance timelines.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `submitted_by` STRING COMMENT 'Username or employee ID of the individual who submitted the budget record for approval. Supports workflow tracking and accountability in the budget planning process.',
    `tolerance_percentage` DECIMAL(18,2) COMMENT 'The allowable percentage overspend relative to the approved budget amount before a budget exceeded warning or hard stop is triggered in SAP S/4HANA. Supports budget availability control configuration.',
    `transaction_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the budget amount was originally entered (e.g., USD, EUR, CNY, BRL). Supports multi-currency budget management across global Manufacturing entities.. Valid values are `^[A-Z]{3}$`',
    `type` STRING COMMENT 'Classifies the budget by financial nature. CAPEX (Capital Expenditure) covers long-term asset investments; OPEX (Operational Expenditure) covers recurring operational costs; revenue covers planned income; headcount covers workforce cost planning; project covers WBS-level project budgets.. Valid values are `CAPEX|OPEX|revenue|headcount|project`',
    `version` STRING COMMENT 'Indicates the planning iteration of the budget record. Original is the first approved plan; revised reflects mid-year adjustments; forecast reflects rolling re-projections; final is the locked year-end version.. Valid values are `original|revised|forecast|final|preliminary`',
    `wbs_element` STRING COMMENT 'SAP S/4HANA Work Breakdown Structure (WBS) element for project-based budgets. Used for CAPEX project tracking, R&D project budgets, and any budget allocated to a specific project deliverable.. Valid values are `^[A-Z0-9-.]{1,24}$`',
    CONSTRAINT pk_budget PRIMARY KEY(`budget_id`)
) COMMENT 'Annual and multi-year financial budget records for cost centers, profit centers, WBS elements, and GL accounts across all Manufacturing legal entities. Captures budget version (original, revised, forecast), budget period, budget amount by cost element, currency, approval status, approved-by user, approval date, and budget type (CAPEX, OPEX, revenue). Supports variance analysis against actuals and rolling forecast management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`budget_line` (
    `budget_line_id` BIGINT COMMENT 'Unique surrogate identifier for each budget line record in the silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `budget_id` BIGINT COMMENT 'Reference to the parent budget record that this line belongs to. Links the granular line-level detail back to the overarching budget document.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: budget_line.controlling_area (STRING) is a denormalized reference to the controlling_area master. Budget lines are scoped to controlling areas. Adding controlling_area_id FK normalizes this organizati',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: budget_line.cost_center (STRING) is a denormalized reference to the cost_center master. Budget lines are planned at the cost center level. Adding cost_center_id FK normalizes this planning dimension.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: budget_line uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for granular period-',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: budget_line.gl_account (STRING) is a denormalized reference to the gl_account master. Budget lines are planned at the GL account level. Adding gl_account_id FK normalizes this financial dimension.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Budget lines can be allocated to internal orders for project-specific budgeting. The internal_order string should be replaced with FK to internal_order product for proper cost tracking and budget cont',
    `it_budget_id` BIGINT COMMENT 'Foreign key linking to technology.it_budget. Business justification: IT budget lines (infrastructure, software, projects) roll up to the IT budget for variance analysis, forecasting, and executive reporting on technology spending.',
    `objective_id` BIGINT COMMENT 'Foreign key linking to hse.hse_objective. Business justification: HSE objectives require budget allocation for safety improvements, training, equipment. Finance tracks budget lines against HSE objectives for capital planning and performance measurement.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: Budget lines are allocated for specific compliance obligations like ISO certifications or environmental permits. Finance plans annual compliance spending by regulatory requirement for resource allocat',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Budget lines allocate funds by procurement spend category (direct materials, indirect, services). Finance and procurement jointly manage category budgets for spend control.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: budget_line.profit_center (STRING) is a denormalized reference to the profit_center master. Budget lines reference profit centers for profitability planning. Adding profit_center_id FK normalizes this',
    `project_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_project. Business justification: Budget lines allocate funds to specific engineering projects for capital planning. Finance tracks budget vs. actual spending by project for investment control and portfolio management.',
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.territory. Business justification: Revenue and expense budgets are allocated by sales territory for planning. Finance creates territory-level budgets that sales management uses for resource allocation and target setting.',
    `approval_status` STRING COMMENT 'Granular approval workflow status indicating whether the budget line has been reviewed and approved by the responsible budget owner or finance controller. Distinct from overall line status.. Valid values are `pending|approved|rejected|escalated`',
    `approved_by` STRING COMMENT 'User ID or name of the finance controller or budget owner who approved this budget line. Supports audit trail requirements and Sarbanes-Oxley (SOX) internal control documentation.',
    `approved_date` DATE COMMENT 'Calendar date on which this budget line was formally approved. Used for audit trail, budget governance reporting, and compliance with internal financial controls.. Valid values are `^d{4}-d{2}-d{2}$`',
    `budget_type` STRING COMMENT 'Classifies the nature of the budget line within the planning cycle, distinguishing between original annual budgets, mid-year revisions, supplemental approvals, rolling forecasts, and zero-based budget exercises.. Valid values are `original|revised|supplemental|rolling_forecast|zero_based`',
    `capex_opex_indicator` STRING COMMENT 'Classifies the budget line as Capital Expenditure (CAPEX) or Operational Expenditure (OPEX). Essential for balance sheet vs. income statement treatment, asset capitalization rules, and CAPEX/OPEX tracking under IFRS IAS 16 and IAS 38.. Valid values are `CAPEX|OPEX`',
    `company_code` STRING COMMENT 'SAP company code identifying the legal entity for which this budget line is planned. Aligns with the organizational unit used for statutory financial reporting.. Valid values are `^[A-Z0-9]{1,10}$`',
    `cost_element` STRING COMMENT 'SAP primary cost element (mapped to a GL account) that classifies the nature of the planned expenditure, such as labor, materials, depreciation, or overhead. Core dimension for cost accounting analysis.. Valid values are `^[0-9]{1,10}$`',
    `cost_element_category` STRING COMMENT 'Classification of the cost element indicating whether it represents primary costs (external), secondary costs (internal allocations), revenue, or statistical postings. Drives cost flow logic in controlling.. Valid values are `primary_costs|secondary_costs|revenue|statistical`',
    `cost_element_name` STRING COMMENT 'Human-readable description of the cost element, providing business users with a clear label for the type of cost being planned without requiring lookup of the cost element code.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this budget line record was first created in the source system or lakehouse. Supports audit trail, data lineage, and SOX internal control documentation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `distribution_key` STRING COMMENT 'SAP distribution key that defines how the annual budget amount is phased across fiscal periods (e.g., equal distribution, seasonal weighting, manual). Critical for budget phasing and period-level planning accuracy.. Valid values are `^[A-Z0-9]{1,10}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency exchange rate applied to translate the planned amount from transaction currency to controlling area or local currency. Supports multi-currency budget consolidation and FX variance analysis.',
    `exchange_rate_type` STRING COMMENT 'SAP exchange rate type used for currency translation (e.g., M for average rate, B for buying rate, P for planning rate). Determines which rate table is applied during budget currency conversion.. Valid values are `^[A-Z0-9]{1,4}$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year to which this budget line is assigned. Enables period-by-period budget phasing, monthly variance reporting, and month-end close analysis. SAP supports periods 1–16 including special periods.. Valid values are `^(1[0-6]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this budget line applies. Used for annual budget planning cycles, year-over-year comparisons, and statutory reporting alignment.. Valid values are `^[0-9]{4}$`',
    `functional_area` STRING COMMENT 'SAP functional area classifying the business function of the planned cost (e.g., Production, Sales, Administration, R&D). Supports cost-of-sales accounting and functional income statement reporting.. Valid values are `^[A-Z0-9]{1,16}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this budget line record. Used for incremental data loading, change detection, and audit trail maintenance in the silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `local_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the company codes functional/local currency in which planned_amount_local is expressed. Supports multi-entity, multi-currency consolidation.. Valid values are `^[A-Z]{3}$`',
    `plan_version` STRING COMMENT 'Identifies the planning version (e.g., original budget, revised forecast, rolling forecast) to which this budget line belongs. Allows comparison across multiple planning iterations within the same fiscal year.. Valid values are `^[A-Z0-9]{1,10}$`',
    `plan_version_description` STRING COMMENT 'Descriptive label for the plan version, such as Original Budget 2024, Q2 Revised Forecast, or Rolling Forecast R3. Provides business context for the planning iteration.',
    `planned_amount` DECIMAL(18,2) COMMENT 'The planned monetary value for this budget line in the controlling area currency. Core financial figure used for budget tracking, variance analysis, and EBITDA/COGS reporting.',
    `planned_amount_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the controlling area currency in which the planned amount is expressed (e.g., USD, EUR, GBP). Supports multi-currency consolidation.. Valid values are `^[A-Z]{3}$`',
    `planned_amount_local` DECIMAL(18,2) COMMENT 'The planned monetary value translated into the local (company code) currency. Required for statutory reporting in the legal entitys functional currency under IFRS IAS 21.',
    `planned_quantity` DECIMAL(18,2) COMMENT 'The planned quantity associated with this budget line, such as planned labor hours, machine hours, or material units. Enables unit-cost analysis and capacity-based budget planning.',
    `quantity_unit` STRING COMMENT 'Unit of measure for the planned quantity (e.g., HR for hours, KG for kilograms, EA for each). Aligns with SAP base unit of measure conventions.. Valid values are `^[A-Z]{1,10}$`',
    `segment` STRING COMMENT 'Business segment to which this budget line is attributed, supporting segment-level profitability planning and IFRS 8 / ASC 280 operating segment disclosures.',
    `source_system` STRING COMMENT 'Identifies the originating system from which this budget line was loaded into the lakehouse silver layer (e.g., SAP S/4HANA CO, manual upload, Excel template). Supports data lineage and reconciliation.. Valid values are `SAP_S4HANA|MANUAL|EXCEL_UPLOAD|POWER_BI|OTHER`',
    `status` STRING COMMENT 'Current workflow status of the budget line within the budget approval and lock cycle. Controls editability and determines whether the line is included in approved budget reporting.. Valid values are `draft|submitted|approved|rejected|locked|archived`',
    `valid_from_date` DATE COMMENT 'Start date from which this budget line is effective. Supports time-dependent budget planning and enables mid-year budget activations or revisions with precise effective dating.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'End date through which this budget line remains effective. Used to deactivate superseded budget lines during revision cycles without deleting historical records.. Valid values are `^d{4}-d{2}-d{2}$`',
    `wbs_element` STRING COMMENT 'SAP Work Breakdown Structure element linking this budget line to a specific project or capital investment. Required for project-based budgeting, CAPEX project tracking, and R&D cost capitalization.',
    CONSTRAINT pk_budget_line PRIMARY KEY(`budget_line_id`)
) COMMENT 'Granular line-level detail within a budget record, capturing the planned financial values at the intersection of cost element, period, and organizational unit. Records cost element, fiscal period, planned quantity, planned amount in controlling area currency, plan version, and distribution key. Enables detailed period-by-period budget tracking, phasing analysis, and month-end variance reporting against actual postings.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`cost_allocation` (
    `cost_allocation_id` BIGINT COMMENT 'Unique system-generated identifier for each cost allocation transaction record within the period-end close cycle.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: cost_allocation.controlling_area (STRING) is a denormalized reference to the controlling_area master. Cost allocations are executed within a controlling area scope. Adding controlling_area_id FK norma',
    `run_id` BIGINT COMMENT 'Unique identifier for a specific execution run of an allocation cycle, enabling traceability of individual cycle executions within the same fiscal period.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: cost_allocation uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-end a',
    `internal_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.internal_audit. Business justification: Audit costs are allocated to production or service cost centers based on audit scope. Finance distributes internal audit expenses to audited areas for full cost accounting.',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: IT service costs (ERP hosting, network services, helpdesk) are allocated to business units based on consumption for chargeback/showback and profitability analysis.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: cost_allocation.company_code (STRING) is a denormalized reference to the legal_entity master. Adding legal_entity_id FK normalizes entity scoping on cost allocations for multi-entity management accoun',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Cost allocations distribute overhead and indirect costs to production orders based on allocation keys. Cost accounting uses this for full absorption costing and production order settlement.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Cost allocations can be posted to internal orders as receivers. The receiver_order string should be replaced with FK to internal_order product to enable proper cost settlement and tracking.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: cost_allocation.receiver_profit_center (STRING) is a denormalized reference to the profit_center master for the receiving profit center. Adding receiver_profit_center_id FK normalizes this allocation ',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: cost_allocation.sender_cost_center (STRING) is a denormalized reference to the cost_center master for the sending cost center. Adding sender_cost_center_id FK normalizes the sender side of the allocat',
    `allocated_amount` DECIMAL(18,2) COMMENT 'The monetary amount allocated from the sender to the receiver in the transaction currency. Represents the cost portion distributed during the allocation cycle execution.',
    `allocated_amount_company_currency` DECIMAL(18,2) COMMENT 'The allocated amount converted to the company codes local currency. Used for statutory financial reporting and legal entity consolidation.',
    `allocated_amount_controlling_currency` DECIMAL(18,2) COMMENT 'The allocated amount expressed in the controlling area currency, used for management accounting and cross-company cost analysis.',
    `allocation_basis_quantity` DECIMAL(18,2) COMMENT 'The numeric quantity of the allocation basis used to determine the receivers share (e.g., headcount, floor area in m², machine hours, kilowatt-hours). Applicable when allocation method is statistical key figure or activity quantity.',
    `allocation_basis_unit` STRING COMMENT 'The unit of measure for the allocation basis quantity (e.g., EA for headcount, H for hours, M2 for square meters, KWH for kilowatt-hours). Provides context for interpreting the allocation basis quantity.',
    `allocation_date` DATE COMMENT 'The business date on which the cost allocation is executed and posted. Determines the period assignment for the allocation transaction.. Valid values are `^d{4}-d{2}-d{2}$`',
    `allocation_document_number` STRING COMMENT 'Business document number assigned by the controlling system (e.g., SAP CO) to uniquely identify the allocation posting document within a fiscal period.',
    `allocation_method` STRING COMMENT 'The specific method used to determine the allocation basis: percentage (fixed split), equivalence numbers (weighted ratios), statistical key figures (e.g., headcount, floor area), fixed amount, activity quantity, or plan values.. Valid values are `percentage|equivalence_numbers|statistical_key_figure|fixed_amount|activity_quantity|plan_values`',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'The percentage share of total sender costs allocated to this specific receiver. Applicable when allocation method is percentage-based. Values between 0 and 100.',
    `allocation_type` STRING COMMENT 'Classification of the cost allocation method used: distribution (reallocates primary cost elements), assessment (uses secondary cost elements), reposting (manual correction), overhead calculation (surcharge-based), activity allocation (quantity-based), or template allocation (formula-based).. Valid values are `distribution|assessment|reposting|overhead_calculation|activity_allocation|template_allocation`',
    `capex_opex_indicator` STRING COMMENT 'Indicates whether the allocated cost is classified as capital expenditure (CAPEX) or operational expenditure (OPEX). Critical for balance sheet vs. income statement treatment and IFRS IAS 16 compliance.. Valid values are `CAPEX|OPEX`',
    `company_code` STRING COMMENT 'The legal entity company code under which this cost allocation is posted. Enables multi-entity financial reporting and intercompany cost allocation tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this cost allocation record was first created in the source system. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `cycle_name` STRING COMMENT 'Name of the allocation or assessment cycle as defined in the controlling system (e.g., SAP CO cycle name). Identifies the configured rule set used to distribute costs during period-end close.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied to convert the transaction currency amount to the company code currency at the time of allocation posting.',
    `fiscal_period` STRING COMMENT 'The fiscal period (accounting period) within the fiscal year in which this allocation is posted. Typically 1-12 for monthly periods, with special periods 13-16 for year-end adjustments.. Valid values are `^(1[0-6]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which this cost allocation is recorded. Used for period-end close reporting and annual financial consolidation.. Valid values are `^[0-9]{4}$`',
    `functional_area` STRING COMMENT 'The functional area classification of the allocation (e.g., production, administration, sales, R&D). Used for cost-of-sales accounting and functional income statement reporting under IFRS.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to this cost allocation record in the source system. Supports incremental data loading and change data capture in the lakehouse silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `original_document_number` STRING COMMENT 'Reference to the original allocation document number that this record reverses or corrects. Populated only when reversal_flag is true, enabling audit trail linkage.',
    `plan_actual_indicator` STRING COMMENT 'Distinguishes whether this allocation record represents a planned allocation (budget/forecast), an actual posted allocation, or a commitment. Supports plan vs. actual variance analysis in management reporting.. Valid values are `plan|actual|commitment`',
    `posting_date` DATE COMMENT 'The date on which the allocation document is posted to the general ledger and controlling module. May differ from allocation_date in cases of retroactive adjustments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `receiver_cost_center` STRING COMMENT 'The cost center receiving the allocated costs. Represents the organizational unit absorbing the shared or overhead costs from the sender.',
    `receiver_wbs_element` STRING COMMENT 'Work Breakdown Structure element receiving the allocated costs, used for capital project cost absorption and CAPEX tracking.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this allocation record is a reversal of a previously posted allocation. True when the record represents a corrective reversal posting during period-end adjustment.. Valid values are `true|false`',
    `secondary_cost_element` STRING COMMENT 'The secondary cost element used to record the assessment or activity allocation posting on the receiver side. Secondary cost elements exist only in controlling and do not correspond to GL accounts.',
    `segment` STRING COMMENT 'The business segment to which the allocated costs are attributed, supporting segment reporting requirements under IFRS 8 Operating Segments.',
    `sender_cost_element` STRING COMMENT 'The cost element (GL account in controlling) from which costs are being sent. For assessments, this is typically a secondary cost element; for distributions, it is the original primary cost element.',
    `sender_cost_element_group` STRING COMMENT 'The cost element group defining the range of cost elements included in the sender pool for this allocation cycle segment. Used when multiple cost elements are allocated together.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this allocation record was extracted (e.g., SAP_S4HANA_PROD). Supports data lineage and audit traceability in the lakehouse.',
    `statistical_key_figure` STRING COMMENT 'The statistical key figure code used as the allocation tracing factor (e.g., HEADCOUNT, FLOORAREA, MACHHR). Statistical key figures are non-monetary quantities that drive cost distribution.',
    `transaction_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the currency in which the allocation amount is originally expressed.. Valid values are `^[A-Z]{3}$`',
    `version` STRING COMMENT 'The controlling version under which this allocation is recorded (e.g., version 0 for actuals, version 1 for plan). Enables parallel valuation and plan/actual comparisons in management accounting.',
    CONSTRAINT pk_cost_allocation PRIMARY KEY(`cost_allocation_id`)
) COMMENT 'Transactional record capturing internal cost allocation and assessment cycles executed during period-end close. Records allocation cycle name, sender cost center or cost element group, receiver cost center or profit center, allocation method (percentage, equivalence numbers, statistical key figures), allocated amount, allocation date, and fiscal period. Supports overhead absorption, shared service cost distribution, and management reporting accuracy.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` (
    `product_cost_estimate_id` BIGINT COMMENT 'Unique surrogate identifier for each product cost estimate record in the silver layer lakehouse. Serves as the primary key for all downstream joins and references.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Cost estimates are calculated for specific catalog items to determine standard costs, pricing floors, and margin analysis. Cost accounting teams create estimates for every manufactured product.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Product cost estimates calculate standard costs for engineered components. Finance uses engineering BOM and routing data to build material, labor, and overhead cost estimates for pricing and margin an',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: product_cost_estimate uses fiscal_year (STRING) and fiscal_period (STRING) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for ',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Standard cost estimates are calculated per SKU for inventory valuation and pricing decisions. Cost accounting maintains these for COGS calculation and margin analysis.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: product_cost_estimate.company_code (STRING) is a denormalized reference to the legal_entity master. Standard cost estimates are created per legal entity/plant combination. Adding legal_entity_id FK no',
    `version_id` BIGINT COMMENT 'Foreign key linking to production.production_version. Business justification: Product cost estimates are calculated for specific production versions (BOM/routing combinations) to determine standard costs. Cost accounting uses this for product costing and make-vs-buy decisions.',
    `base_quantity` DECIMAL(18,2) COMMENT 'The reference quantity for which the cost estimate is calculated (e.g., 1 unit, 100 units). All cost component values in this record are expressed per this base quantity.',
    `base_quantity_unit` STRING COMMENT 'Unit of measure for the base quantity (e.g., EA for each, KG for kilogram, M for meter). Ensures correct interpretation of per-unit cost values in downstream reporting.',
    `bom_alternative` STRING COMMENT 'Alternative BOM number used in the cost estimate when multiple BOM alternatives exist for a material. Relevant for products with multiple production configurations or regional variants.',
    `bom_number` STRING COMMENT 'Reference to the Bill of Materials (BOM) used as the basis for the material cost component of this cost estimate. Ensures traceability between the cost estimate and the product structure.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the cost estimate is created. Determines the currency, chart of accounts, and statutory reporting context.',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which all cost component values are expressed (e.g., USD, EUR, CNY). Corresponds to the company code currency for the legal entity.. Valid values are `^[A-Z]{3}$`',
    `costing_date` DATE COMMENT 'The reference date used to determine prices and rates during the cost estimate calculation (e.g., material prices, activity rates). Controls which price conditions are selected from the system.. Valid values are `^d{4}-d{2}-d{2}$`',
    `costing_run_number` STRING COMMENT 'Unique identifier of the costing run in SAP CO-PC that generated this cost estimate. Used to trace the estimate back to its originating batch costing execution.',
    `costing_status` STRING COMMENT 'Current processing status of the cost estimate in SAP CO-PC. Only estimates with status released are used for inventory valuation and standard cost rolls. Errors must be resolved before release.. Valid values are `created|in_process|completed|error|marked|released|cancelled`',
    `costing_type` STRING COMMENT 'Classification of the cost estimate by its business purpose. Standard cost estimates feed inventory valuation; simulation estimates support what-if analysis; sales order costing supports margin analysis.. Valid values are `standard|modified_standard|inventory_cost|sales_order|simulation|actual`',
    `costing_variant` STRING COMMENT 'SAP costing variant that controls the parameters of the cost estimate, including the valuation strategy, costing type, and date control. Common variants include PPC1 (standard cost estimate) and PPP1 (modified standard cost).',
    `costing_version` STRING COMMENT 'Version number of the cost estimate within a costing variant. Allows multiple parallel cost estimates (e.g., plan vs. simulation) to coexist for the same material and period.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the cost estimate record was originally created in the source system (SAP CO-PC). Used for audit trail, data lineage, and compliance with IFRS and GAAP record-keeping requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `error_indicator` BOOLEAN COMMENT 'Flag indicating whether the cost estimate contains errors or warnings that prevented successful completion. Estimates with errors cannot be released for inventory valuation until resolved.. Valid values are `true|false`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency exchange rate applied to translate the cost estimate from the company code currency to the group currency at the time of costing. Supports multi-currency consolidation and variance analysis.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year for which this cost estimate applies. Supports monthly cost reporting, period-end COGS calculation, and inventory valuation.. Valid values are `^(0[1-9]|1[0-2])$`',
    `fiscal_year` STRING COMMENT 'Fiscal year for which this cost estimate is created and valid. Used for period-end close, annual standard cost roll, and year-over-year cost variance reporting.. Valid values are `^d{4}$`',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the group reporting currency used in consolidated financial statements (e.g., USD, EUR).. Valid values are `^[A-Z]{3}$`',
    `group_currency_cost` DECIMAL(18,2) COMMENT 'Total standard cost translated into the group reporting currency (e.g., USD for a US-headquartered multinational). Supports consolidated COGS and inventory valuation reporting across legal entities.',
    `labor_cost` DECIMAL(18,2) COMMENT 'Planned direct labor cost for manufacturing the product per the base quantity. Calculated from routing operations, activity types, and planned labor rates in the work center.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the cost estimate record in the source system. Supports incremental data loading, change detection, and audit trail in the silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lot_size` DECIMAL(18,2) COMMENT 'Production lot size used in the cost estimate for calculating setup and fixed cost components. Lot-size-dependent costs (e.g., setup time) are spread over this quantity to derive per-unit costs.',
    `lot_size_unit` STRING COMMENT 'Unit of measure for the production lot size used in the cost estimate (e.g., EA, KG). Must align with the base quantity unit for consistent per-unit cost calculation.',
    `machine_cost` DECIMAL(18,2) COMMENT 'Planned machine activity cost for manufacturing the product per the base quantity. Derived from routing machine time and machine activity rates defined in the work center.',
    `make_buy_indicator` STRING COMMENT 'Indicates whether the product is manufactured in-house (Make to Stock, Make to Order, Engineer to Order, Assemble to Order) or procured externally (Buy). Influences the cost component structure and costing methodology.. Valid values are `make_to_stock|make_to_order|engineer_to_order|assemble_to_order|buy`',
    `material_cost` DECIMAL(18,2) COMMENT 'Planned cost of raw materials, components, and purchased parts consumed in manufacturing the product per the base quantity. Derived from the Bill of Materials (BOM) and material price conditions.',
    `material_description` STRING COMMENT 'Short descriptive name of the material or assembly being costed, as maintained in the SAP material master. Supports readability in cost reports and COGS analysis.',
    `overhead_cost` DECIMAL(18,2) COMMENT 'Planned manufacturing overhead cost allocated to the product per the base quantity. Includes fixed and variable overhead applied via overhead costing sheets or activity-based costing.',
    `overhead_key` STRING COMMENT 'SAP overhead costing sheet key applied to calculate manufacturing overhead in this cost estimate. Determines the overhead rates and absorption basis used for fixed and variable overhead allocation.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where the product is produced. Cost estimates are plant-specific as labor rates, overhead rates, and routing may differ by plant.',
    `price_control_indicator` STRING COMMENT 'SAP material master price control indicator. S (Standard Price) means inventory is valued at the released standard cost estimate; V (Moving Average Price) means inventory is valued at actual cost. Determines how this estimate is applied to inventory valuation.. Valid values are `S|V`',
    `product_category` STRING COMMENT 'Business classification of the manufactured product (e.g., automation systems, electrification components, smart infrastructure). Used for cost analysis by product line and segment reporting.',
    `release_date` DATE COMMENT 'Date on which the cost estimate was released and marked as the standard price for inventory valuation. Triggers the standard cost roll and updates the material master price field.. Valid values are `^d{4}-d{2}-d{2}$`',
    `routing_alternative` STRING COMMENT 'Alternative routing sequence used in the cost estimate when multiple production routings exist for a material. Supports costing of alternative manufacturing paths.',
    `routing_number` STRING COMMENT 'Reference to the production routing (task list) used to calculate labor, machine, and activity costs in this estimate. The routing defines the sequence of manufacturing operations and their standard times.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this cost estimate record was sourced (e.g., SAP_S4HANA_CO_PC). Supports data lineage tracking and audit in the lakehouse.',
    `subcontracting_cost` DECIMAL(18,2) COMMENT 'Planned cost for externally subcontracted manufacturing operations or services included in the product cost estimate. Relevant for products with outsourced processing steps.',
    `total_standard_cost` DECIMAL(18,2) COMMENT 'Total planned cost of goods manufactured (COGM) per the base quantity, representing the sum of all cost components (material, labor, machine, overhead, subcontracting). This value is used as the standard price for inventory valuation and COGS calculation.',
    `validity_end_date` DATE COMMENT 'Date until which this cost estimate is valid. After this date, a new cost estimate must be released for the material. Supports annual standard cost roll and period-end close processes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'Date from which this cost estimate is valid and can be used for inventory valuation and COGS calculation. Defines the start of the period during which the standard cost is active.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_product_cost_estimate PRIMARY KEY(`product_cost_estimate_id`)
) COMMENT 'Standard cost estimate records for manufactured products and assemblies, capturing the planned cost of goods manufactured (COGM) broken down by cost components (material, labor, machine, overhead). Records costing variant, costing version, base quantity, material cost, activity cost, overhead cost, total standard cost, costing status, and validity dates. Feeds standard cost rolls into inventory valuation and COGS calculation. Sourced from SAP S/4HANA CO-PC.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`production_order_cost` (
    `production_order_cost_id` BIGINT COMMENT 'Unique surrogate identifier for each production order cost record in the silver layer lakehouse. Serves as the primary key for this entity.',
    `bop_id` BIGINT COMMENT 'Foreign key linking to engineering.bop. Business justification: Production order costs include labor and machine costs from the bill of process (routing). Finance calculates operation costs and efficiency variances using BOP time standards and rates.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Production order costs track actual manufacturing costs per product for variance analysis and inventory valuation. Cost controllers reconcile actual vs. standard costs for each manufactured item.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Production orders for custom manufacturing or refurbishment work often linked to service contracts. Finance tracks actual production costs against service contract budgets.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: production_order_cost.controlling_area_code (STRING) is a denormalized reference to the controlling_area master. Production order costs are collected within a controlling area. Adding controlling_area',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: production_order_cost.cost_center_code (STRING) is a denormalized reference to the cost_center master. Production order costs are attributed to cost centers. Adding cost_center_id FK normalizes this c',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.bom. Business justification: Production order costs are calculated based on the engineering BOM structure. Finance uses the BOM to determine material costs and variances between standard and actual consumption.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: production_order_cost uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: production_order_cost.company_code (STRING) is a denormalized reference to the legal_entity master. Production order costs are scoped to legal entities. Adding legal_entity_id FK normalizes entity sco',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Production order costs include depreciation and operating costs of OT systems (PLCs, SCADA, MES) used in manufacturing for accurate product costing and margin analysis.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: production_order_cost.profit_center_code (STRING) is a denormalized reference to the profit_center master. Production order costs are attributed to profit centers for COGS and profitability analysis. ',
    `scrap_rework_transaction_id` BIGINT COMMENT 'Foreign key linking to quality.scrap_rework_transaction. Business justification: Production order variance analysis requires linking to quality scrap/rework transactions to explain manufacturing cost deviations and calculate actual production costs.',
    `actual_labor_cost` DECIMAL(18,2) COMMENT 'Actual direct labor cost charged to the production order based on confirmed activity quantities and labor rates. Supports labor efficiency variance analysis.. Valid values are `^-?d+(.d{1,6})?$`',
    `actual_machine_cost` DECIMAL(18,2) COMMENT 'Actual machine or equipment usage cost charged to the production order based on confirmed machine activity and machine rates. Supports machine efficiency variance analysis.. Valid values are `^-?d+(.d{1,6})?$`',
    `actual_material_cost` DECIMAL(18,2) COMMENT 'Actual cost of raw materials and components consumed in the production order, as posted via goods issues from inventory. Key component of COGS and material variance analysis.. Valid values are `^-?d+(.d{1,6})?$`',
    `actual_overhead_cost` DECIMAL(18,2) COMMENT 'Actual manufacturing overhead cost applied to the production order via overhead costing sheets or activity-based costing. Includes indirect costs such as utilities, depreciation, and facility costs.. Valid values are `^-?d+(.d{1,6})?$`',
    `actual_total_cost` DECIMAL(18,2) COMMENT 'Total actual cost incurred on the production order, representing the sum of actual material, labor, machine, and overhead costs. Primary input for COGS and production cost reporting.. Valid values are `^-?d+(.d{1,6})?$`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the production order cost is recorded. Enables multi-entity financial consolidation and statutory reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `company_code_currency` STRING COMMENT 'ISO 4217 currency code of the company code (local/functional currency). Used for local statutory reporting and currency translation of production order costs.. Valid values are `^[A-Z]{3}$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'Actual quantity of the material confirmed as produced and goods-receipted against the production order. Used to calculate actual unit cost and yield.. Valid values are `^d+(.d{1,4})?$`',
    `costing_variant` STRING COMMENT 'SAP CO-PC costing variant used to determine the valuation strategy for planned costs (e.g., standard cost, moving average price). Defines the cost estimate basis for variance calculation.. Valid values are `^[A-Z0-9]{1,4}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Exchange rate applied to convert production order costs from transaction currency to company code currency at the time of posting. Required for multi-currency financial consolidation.. Valid values are `^d+(.d{1,6})?$`',
    `fiscal_period` STRING COMMENT 'Fiscal posting period (1–12 for regular periods, 13–16 for special periods) within the fiscal year. Enables period-level cost variance and COGS reporting.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the production order cost record is posted. Used for annual financial reporting, COGS calculation, and year-over-year variance analysis.. Valid values are `^[0-9]{4}$`',
    `goods_receipt_date` DATE COMMENT 'Date on which the finished goods produced by the production order were received into inventory stock. Triggers the transfer of WIP to finished goods inventory valuation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `material_description` STRING COMMENT 'Short description of the material or product being manufactured, providing human-readable context for cost reporting and analysis.',
    `material_number` STRING COMMENT 'SAP material number of the finished good or semi-finished product being manufactured in this production order. Links cost records to the product being produced.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `order_currency` STRING COMMENT 'ISO 4217 currency code in which the production order costs are recorded (transaction currency). Supports multi-currency cost reporting and consolidation.. Valid values are `^[A-Z]{3}$`',
    `order_finish_date` DATE COMMENT 'Scheduled or actual finish date of the production order. Used to determine the cost collection period and support lead time analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `order_number` STRING COMMENT 'The unique business identifier of the manufacturing production order as assigned by SAP S/4HANA PP/CO. Used to link cost records back to the originating shop floor execution order.. Valid values are `^[A-Z0-9]{6,20}$`',
    `order_quantity` DECIMAL(18,2) COMMENT 'Total quantity of the material ordered for production. Used to calculate unit cost and cost per unit variance.. Valid values are `^d+(.d{1,4})?$`',
    `order_quantity_unit` STRING COMMENT 'Unit of measure for the production order quantity (e.g., EA, KG, L, M). Ensures correct unit cost calculations and cross-order comparisons.. Valid values are `^[A-Z]{2,3}$`',
    `order_start_date` DATE COMMENT 'Scheduled or actual start date of the production order. Used to align cost collection with the production execution timeline.. Valid values are `^d{4}-d{2}-d{2}$`',
    `order_status` STRING COMMENT 'Current system status of the production order (e.g., Created, Released, Technically Complete, Closed). Determines whether further cost postings or settlements are permitted.. Valid values are `CREATED|RELEASED|PARTIALLY_CONFIRMED|CONFIRMED|TECHNICALLY_COMPLETE|CLOSED|DELETED`',
    `order_type` STRING COMMENT 'SAP order type classifying the nature of the production order (e.g., standard production, process order, repetitive manufacturing, rework). Drives cost collection and settlement rules.. Valid values are `PP01|PP02|PP03|PP04|PI01|PI02|REM|PM01|PM02`',
    `planned_cost_amount` DECIMAL(18,2) COMMENT 'Total planned (standard) cost estimate for the production order as calculated by SAP CO-PC cost estimate. Represents the expected cost based on standard BOM and routing.. Valid values are `^-?d+(.d{1,6})?$`',
    `plant_code` STRING COMMENT 'Manufacturing plant or facility code where the production order was executed. Used for plant-level cost variance analysis and production efficiency reporting.. Valid values are `^[A-Z0-9]{1,4}$`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this production order cost record was first created in the lakehouse silver layer. Used for data lineage, audit trail, and incremental load tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this production order cost record was last updated in the lakehouse silver layer. Supports change tracking, incremental processing, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `rework_cost` DECIMAL(18,2) COMMENT 'Cost of rework activities performed on the production order to correct non-conformances. Supports quality cost analysis and Non-Conformance Report (NCR) cost tracking.. Valid values are `^-?d+(.d{1,6})?$`',
    `scrap_cost` DECIMAL(18,2) COMMENT 'Cost of scrapped materials and components charged to the production order. Supports scrap rate analysis, quality cost reporting, and CAPA initiatives.. Valid values are `^-?d+(.d{1,6})?$`',
    `settlement_date` DATE COMMENT 'Date on which the production order costs were settled to the receiving cost objects. Used for period-end close tracking and audit trail.. Valid values are `^d{4}-d{2}-d{2}$`',
    `settlement_status` STRING COMMENT 'Current settlement status of the production order cost object, indicating whether accumulated costs have been settled to the receiving cost objects (e.g., material stock, profitability segment, G/L account). Drives period-end close activities.. Valid values are `NOT_SETTLED|PARTIALLY_SETTLED|FULLY_SETTLED|SETTLEMENT_BLOCKED`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this production order cost record was sourced (e.g., SAP S/4HANA CO-PC-OBJ). Supports data lineage and audit traceability.. Valid values are `SAP_S4HANA|SAP_ECC|OPCENTER_MES|MANUAL`',
    `technical_completion_date` DATE COMMENT 'Date on which the production order was set to technically complete status in SAP, preventing further goods movements and activity confirmations. Marks the end of cost collection.. Valid values are `^d{4}-d{2}-d{2}$`',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between actual total cost and planned (standard) cost for the production order. Positive value indicates cost overrun; negative indicates favorable variance. Core metric for manufacturing cost variance analysis.. Valid values are `^-?d+(.d{1,6})?$`',
    `variance_category` STRING COMMENT 'SAP CO-PC variance category classifying the root cause of the cost variance (e.g., price variance, quantity variance, scrap variance, lot size variance). Enables targeted corrective action and CAPA processes.. Valid values are `PRICE|QUANTITY|RESOURCE_USAGE|SCRAP|LOT_SIZE|REMAINING|MIXED_PRICE|INPUT_PRICE|INPUT_QUANTITY|OUTPUT_PRICE|OUTPUT_QUANTITY`',
    `variance_key` STRING COMMENT 'SAP variance key assigned to the production order, controlling which variance categories are calculated during variance determination. Enables targeted variance reporting.. Valid values are `^[A-Z0-9]{1,6}$`',
    `wip_value` DECIMAL(18,2) COMMENT 'Value of Work In Progress (WIP) calculated for the production order at period-end. Represents costs accumulated on open orders not yet delivered to inventory. Required for balance sheet inventory valuation under IFRS IAS 2 and GAAP ASC 330.. Valid values are `^-?d+(.d{1,6})?$`',
    CONSTRAINT pk_production_order_cost PRIMARY KEY(`production_order_cost_id`)
) COMMENT 'Actual cost collection record for manufacturing production orders, capturing the real costs incurred during shop floor execution versus the standard cost estimate. Records planned cost, actual material cost, actual labor cost, actual machine cost, actual overhead cost, variance amount, variance category, settlement status, and WIP value. Enables manufacturing cost variance analysis, COGS accuracy, and production efficiency reporting. Sourced from SAP S/4HANA CO-PC-OBJ.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`profitability_segment` (
    `profitability_segment_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a profitability analysis (CO-PA) segment record in the silver layer lakehouse.',
    `category_id` BIGINT COMMENT 'Foreign key linking to product.product_category. Business justification: Profitability analysis segments revenue and costs by product categories for strategic decision-making. Finance teams analyze margin contribution by product line for portfolio management.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: profitability_segment.controlling_area_code (STRING) is a denormalized reference to the controlling_area master. CO-PA profitability segments are defined within a controlling area. Adding controlling_',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: profitability_segment.company_code (STRING) is a denormalized reference to the legal_entity master. Profitability segments are scoped to legal entities. Adding legal_entity_id FK normalizes entity sco',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: profitability_segment.profit_center_code (STRING) is a denormalized reference to the profit_center master. Profitability segments are associated with profit centers for contribution margin analysis. A',
    `business_area_code` STRING COMMENT 'SAP business area code representing an independent area of operations or responsibility within the enterprise, used for internal segment reporting and balance sheet preparation.. Valid values are `^[A-Z0-9]{1,4}$`',
    `capex_opex_indicator` STRING COMMENT 'Classifies the nature of expenditure associated with this profitability segment as capital expenditure (CAPEX), operational expenditure (OPEX), or a mix, supporting asset capitalization and P&L treatment decisions.. Valid values are `CAPEX|OPEX|MIXED|NOT_APPLICABLE`',
    `cogs_relevant_flag` BOOLEAN COMMENT 'Indicates whether cost of goods sold (COGS) postings are relevant for this profitability segment, controlling whether COGS flows into the contribution margin calculation.. Valid values are `true|false`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity associated with this profitability segment, used for statutory and IFRS/GAAP reporting.. Valid values are `^[A-Z0-9]{1,4}$`',
    `contribution_margin_level` STRING COMMENT 'Defines the contribution margin hierarchy level at which this segment is evaluated (CM1 = revenue minus variable COGS, CM2 = CM1 minus variable selling costs, CM3 = CM2 minus fixed costs, CM4 = CM3 minus overhead, EBITDA = earnings before interest, taxes, depreciation, and amortization).. Valid values are `CM1|CM2|CM3|CM4|EBITDA`',
    `copa_type` STRING COMMENT 'Indicates whether the segment is defined under costing-based CO-PA or account-based CO-PA in SAP S/4HANA, which determines the valuation approach for contribution margin reporting.. Valid values are `costing_based|account_based`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the geographic dimension of the profitability segment, enabling country-level contribution margin and EBITDA reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the profitability segment master record was first created in the source system, used for audit trail and data governance compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code used as the primary transaction currency for this profitability segments financial postings.. Valid values are `^[A-Z]{3}$`',
    `customer_group_code` STRING COMMENT 'Code identifying the customer group dimension of the profitability segment (e.g., OEM, distributor, end-user, government), enabling customer-segment contribution margin analysis.. Valid values are `^[A-Z0-9]{1,2}$`',
    `distribution_channel_code` STRING COMMENT 'SAP distribution channel code indicating the route through which products or services are sold (e.g., direct sales, dealer, OEM, e-commerce).. Valid values are `^[A-Z0-9]{1,2}$`',
    `division_code` STRING COMMENT 'SAP division code grouping products or services into business lines for profitability analysis and segment reporting.. Valid values are `^[A-Z0-9]{1,2}$`',
    `fiscal_year_variant` STRING COMMENT 'SAP fiscal year variant code defining the fiscal calendar structure (e.g., calendar year, April-March, October-September) applicable to this profitability segment.. Valid values are `^[A-Z0-9]{1,2}$`',
    `functional_area_code` STRING COMMENT 'Code classifying the functional area (e.g., manufacturing, sales, administration, R&D) for cost-of-sales accounting and income statement reporting by function of expense.. Valid values are `^[A-Z0-9]{1,16}$`',
    `ifrs8_reportable_segment_flag` BOOLEAN COMMENT 'Indicates whether this profitability segment qualifies as a reportable operating segment under IFRS 8, requiring separate disclosure in external financial statements.. Valid values are `true|false`',
    `industry_code` STRING COMMENT 'Industry classification code of the customer segment within this profitability segment (e.g., automotive, aerospace, energy, food and beverage), supporting vertical market profitability analysis.. Valid values are `^[A-Z0-9]{1,10}$`',
    `intercompany_flag` BOOLEAN COMMENT 'Indicates whether this profitability segment involves intercompany transactions between legal entities, requiring elimination in consolidated financial statements.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the profitability segment master record, supporting change tracking and data quality monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `parent_segment_code` STRING COMMENT 'Code of the parent profitability segment in the hierarchy, enabling roll-up of contribution margin and EBITDA from sub-segments to higher-level reporting segments.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `plan_version` STRING COMMENT 'SAP CO plan version identifier associated with this profitability segment, distinguishing between original budget, revised forecast, and actuals versions for variance analysis.. Valid values are `^[A-Z0-9_-]{1,10}$`',
    `plant_code` STRING COMMENT 'SAP plant code representing the manufacturing or distribution facility dimension of the profitability segment, enabling plant-level contribution margin analysis.. Valid values are `^[A-Z0-9]{1,4}$`',
    `product_group_code` STRING COMMENT 'Code identifying the product group or product line dimension of the profitability segment, enabling contribution margin analysis by product family.. Valid values are `^[A-Z0-9_-]{1,18}$`',
    `product_hierarchy_code` STRING COMMENT 'SAP product hierarchy node code used to classify products within the segment for multi-level profitability drill-down reporting.. Valid values are `^[A-Z0-9]{1,18}$`',
    `region_code` STRING COMMENT 'Code identifying the sales region dimension of the profitability segment (e.g., EMEA, APAC, AMER, DACH), supporting regional profitability analysis and management reporting.. Valid values are `^[A-Z0-9_-]{1,10}$`',
    `reporting_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code used for group-level consolidated reporting of this profitability segment, supporting multi-currency EBITDA consolidation.. Valid values are `^[A-Z]{3}$`',
    `sales_organization_code` STRING COMMENT 'SAP sales organization code representing the selling unit responsible for the revenue associated with this profitability segment.. Valid values are `^[A-Z0-9]{1,4}$`',
    `segment_code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying the CO-PA profitability segment combination. Derived from SAP S/4HANA CO-PA segment key.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `segment_hierarchy_level` STRING COMMENT 'Numeric level within the profitability segment hierarchy, where level 1 represents the top-most aggregation and higher numbers represent more granular sub-segments.. Valid values are `^[1-9][0-9]*$`',
    `segment_name` STRING COMMENT 'Descriptive name of the profitability segment used in management reporting and EBITDA dashboards.',
    `segment_type` STRING COMMENT 'Classification of the segment dimension type used for multi-dimensional profitability analysis (e.g., product line, customer segment, geography, sales channel).. Valid values are `product_line|customer_segment|geography|sales_channel|business_area|combined`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this profitability segment master record originates, supporting data lineage and audit traceability.. Valid values are `SAP_S4HANA|MANUAL|MIGRATION`',
    `source_system_key` STRING COMMENT 'Natural key or composite key from the originating source system (SAP CO-PA segment key) used for reconciliation and data lineage tracing back to the system of record.',
    `status` STRING COMMENT 'Current operational status of the profitability segment master record, controlling whether new postings and planning entries are permitted.. Valid values are `active|inactive|blocked|under_review`',
    `transfer_price_indicator` BOOLEAN COMMENT 'Indicates whether intercompany transfer pricing is applied to postings within this profitability segment, relevant for eliminations and arms-length pricing compliance.. Valid values are `true|false`',
    `valid_from_date` DATE COMMENT 'Date from which this profitability segment definition is effective and active for financial postings and planning, supporting time-dependent segment configurations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date until which this profitability segment definition remains effective. After this date, the segment is no longer available for new postings.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_profitability_segment PRIMARY KEY(`profitability_segment_id`)
) COMMENT 'Master record defining the profitability analysis (CO-PA) segments used for contribution margin and EBITDA reporting. Captures segment characteristics including customer, product, sales organization, distribution channel, region, industry, and business area combinations. Enables multi-dimensional profitability analysis by product line, customer segment, geography, and sales channel in alignment with IFRS 8 segment reporting requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`copa_posting` (
    `copa_posting_id` BIGINT COMMENT 'Unique surrogate identifier for each CO-PA posting record in the silver layer. Serves as the primary key for the profitability analysis posting table.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Profitability Analysis (CO-PA) postings capture revenue and costs at the product level for margin reporting. Management accounting uses this for product-level P&L and contribution margin analysis.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: copa_posting.controlling_area_code (STRING) is a denormalized reference to the controlling_area master. CO-PA postings are made within a controlling area. Adding controlling_area_id FK normalizes this',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: copa_posting.cost_center_code (STRING) is a denormalized reference to the cost_center master. CO-PA postings reference cost centers for cost attribution. Adding cost_center_id FK normalizes this manag',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: copa_posting uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-level CO',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: copa_posting.company_code (STRING) is a denormalized reference to the legal_entity master. CO-PA postings are scoped to legal entities. Adding legal_entity_id FK normalizes entity scoping for multi-en',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Profitability analysis postings link to production orders to analyze manufacturing contribution margins by product, customer, or region. Controlling uses this for profitability segment reporting.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: copa_posting.profit_center_code (STRING) is a denormalized reference to the profit_center master. CO-PA postings are attributed to profit centers. Adding profit_center_id FK normalizes this profitabil',
    `profitability_segment_id` BIGINT COMMENT 'Foreign key linking to finance.profitability_segment. Business justification: copa_posting.segment_code (STRING) is a denormalized reference to the profitability_segment master. CO-PA postings are made to specific profitability segments. Adding profitability_segment_id FK creat',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Profitability analysis postings link to opportunities for deal-level margin analysis. Finance and sales review actual profitability against opportunity estimates in quarterly business reviews.',
    `team_id` BIGINT COMMENT 'Foreign key linking to sales.sales_team. Business justification: Profitability postings are analyzed by sales team for performance measurement. Finance produces P&L reports by sales team to evaluate team-level contribution margins.',
    `billing_document_number` STRING COMMENT 'Reference to the SD billing document (invoice or credit/debit memo) that originated the CO-PA posting. Enables traceability from profitability posting back to the sales transaction.',
    `capex_opex_indicator` STRING COMMENT 'Classifies the CO-PA posting as relating to capital expenditure (CAPEX) or operational expenditure (OPEX). Required for EBITDA calculation, financial statement classification, and CAPEX/OPEX tracking.. Valid values are `CAPEX|OPEX|N/A`',
    `company_code` STRING COMMENT 'The SAP company code representing the legal entity for which the CO-PA posting is recorded. Enables statutory reporting and legal entity-level P&L analysis.',
    `contribution_margin_level` STRING COMMENT 'The contribution margin hierarchy level to which this value field posting contributes (e.g., CM1 = Gross Revenue minus COGS, CM2 = CM1 minus variable overhead, CM3 = CM2 minus fixed overhead). Supports structured management P&L and EBITDA waterfall reporting.. Valid values are `cm1|cm2|cm3|cm4|ebitda|ebit|net_income`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the CO-PA posting record was created in the source system. Used for audit trail, data lineage, and reconciliation purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_number` STRING COMMENT 'The SAP customer account number representing the customer dimension of the profitability segment. Enables customer-level profitability and contribution margin analysis.',
    `distribution_channel` STRING COMMENT 'The distribution channel through which the product or service was sold (e.g., direct sales, dealer, OEM, e-commerce). Part of the CO-PA profitability segment and used for channel-level margin analysis.',
    `document_date` DATE COMMENT 'The date of the originating business document (e.g., billing document date, settlement date) that triggered the CO-PA posting. May differ from posting date due to period-end processing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_number` STRING COMMENT 'The unique document number assigned by SAP CO-PA to identify the profitability analysis posting document. Used for traceability back to the source transaction.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied to convert the transaction currency amount to the local currency at the time of posting. Critical for multi-currency consolidation and variance analysis.',
    `fiscal_period` STRING COMMENT 'The fiscal period (1–12 for regular periods, 13–16 for special/adjustment periods) within the fiscal year to which the CO-PA posting is assigned. Drives period-based P&L and contribution margin reporting.. Valid values are `^([1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which the CO-PA posting belongs. Used for annual financial reporting, EBITDA analysis, and year-over-year comparisons.. Valid values are `^d{4}$`',
    `group_currency` STRING COMMENT 'The ISO 4217 three-letter currency code of the group/consolidation currency used for consolidated financial reporting and EBITDA analysis.. Valid values are `^[A-Z]{3}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to the CO-PA posting record. Supports change tracking, delta processing in the lakehouse pipeline, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `line_item_number` STRING COMMENT 'Sequential line item number within the CO-PA posting document, distinguishing individual value field entries within the same document.',
    `local_currency` STRING COMMENT 'The ISO 4217 three-letter currency code of the company code local currency used for statutory reporting.. Valid values are `^[A-Z]{3}$`',
    `material_number` STRING COMMENT 'The SAP material number (Stock Keeping Unit) of the product sold or produced, representing the product dimension of the profitability segment. Enables product-level contribution margin analysis.',
    `posting_date` DATE COMMENT 'The date on which the CO-PA posting was recorded in the system. Determines the fiscal period assignment and is used for period-based contribution margin and EBITDA reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `posting_type` STRING COMMENT 'Indicates whether the CO-PA posting represents actual realized values, planned values, budget allocations, or forecast data. Fundamental for plan-vs-actual variance analysis and EBITDA reporting.. Valid values are `actual|plan|budget|forecast|statistical`',
    `product_hierarchy_code` STRING COMMENT 'The product hierarchy node code classifying the material into product groups and lines. Enables aggregated contribution margin reporting at product line and product group levels.',
    `quantity` DECIMAL(18,2) COMMENT 'The quantity associated with the CO-PA posting (e.g., billed quantity, production quantity). Used for unit contribution margin calculations and volume-based profitability analysis.',
    `quantity_unit` STRING COMMENT 'The unit of measure for the quantity field (e.g., EA for each, KG for kilogram, PC for piece, M for meter). Required for accurate volume-based contribution margin analysis.',
    `record_type` STRING COMMENT 'SAP CO-PA record type classifying the nature of the posting. Key values include F (Billing Document), B (Direct Posting from FI), C (Order/Project Settlement), E (Single Transaction Costing). Drives how the record is used in contribution margin reporting.. Valid values are `F|B|C|E|G|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z`',
    `reference_document_number` STRING COMMENT 'The reference document number from the originating transaction (e.g., FI document number, production order number, WBS element). Provides audit trail linkage between the CO-PA posting and the source business transaction.',
    `reversal_document_number` STRING COMMENT 'The document number of the original CO-PA posting that this record reverses, or the reversal document number if this original posting has been reversed. Supports audit trail and correction tracking.',
    `reversal_indicator` BOOLEAN COMMENT 'Indicates whether this CO-PA posting is a reversal of a previously posted document. Reversals are used for corrections and period-end adjustments. True = this is a reversal posting.. Valid values are `true|false`',
    `sales_order_number` STRING COMMENT 'The sales order number associated with the CO-PA posting, linking profitability data to the originating customer order. Supports order-level profitability analysis.',
    `sales_org_code` STRING COMMENT 'The sales organization code representing the organizational unit responsible for the sale. Part of the profitability segment definition and used for regional and channel-level P&L analysis.',
    `source_system` STRING COMMENT 'The operational system of record from which the CO-PA posting originated (e.g., SAP S/4HANA, Siemens Opcenter MES). Supports data lineage, reconciliation, and multi-system integration traceability.',
    `transaction_currency` STRING COMMENT 'The ISO 4217 three-letter currency code of the original transaction (e.g., USD, EUR, CNY). The currency in which the value field amount was originally recorded.. Valid values are `^[A-Z]{3}$`',
    `value_field_amount` DECIMAL(18,2) COMMENT 'The monetary amount posted to the CO-PA value field in the transaction currency. Represents the financial value of the specific contribution margin component (revenue, deduction, COGS, variance, overhead) for this posting.',
    `value_field_amount_group` DECIMAL(18,2) COMMENT 'The monetary amount posted to the CO-PA value field converted to the group/consolidation currency. Used for consolidated EBITDA reporting and multinational financial consolidation.',
    `value_field_amount_local` DECIMAL(18,2) COMMENT 'The monetary amount posted to the CO-PA value field converted to the company code local currency. Used for statutory reporting and local GAAP compliance.',
    `value_field_category` STRING COMMENT 'Business classification of the CO-PA value field indicating the contribution margin line it represents (e.g., gross revenue, sales deductions, COGS, manufacturing variance, overhead allocation). Enables structured contribution margin waterfall reporting.. Valid values are `gross_revenue|sales_deduction|net_revenue|cogs|manufacturing_variance|overhead_allocation|price_variance|quantity_variance|mix_variance|other_variance|freight|rebate|commission|royalty`',
    `value_field_name` STRING COMMENT 'The name of the CO-PA value field being posted (e.g., VV010 for gross revenue, VV020 for sales deductions, VV030 for COGS, VV040 for overhead). Identifies the specific financial component of the contribution margin structure.',
    `version` STRING COMMENT 'The planning version identifier used in CO-PA. For actual postings this is typically version 0; for plan/budget/forecast postings this identifies the specific planning version (e.g., 001 for annual budget, 010 for rolling forecast).',
    CONSTRAINT pk_copa_posting PRIMARY KEY(`copa_posting_id`)
) COMMENT 'Transactional record capturing actual and planned value flows into the CO-PA profitability analysis module. Records revenue, sales deductions, COGS, variances, and overhead allocations at the profitability segment level. Captures value field amounts, quantity fields, record type (actual/plan/budget), billing document reference, and period. Provides the granular data foundation for contribution margin reporting, EBITDA analysis, and management P&L by segment.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` (
    `intercompany_transaction_id` BIGINT COMMENT 'Unique system-generated identifier for each intercompany transaction record within the Manufacturing group. Serves as the primary key for the silver layer data product.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: intercompany_transaction.cost_center (STRING) is a denormalized reference to the cost_center master. Adding cost_center_id FK normalizes cost center assignment on intercompany transactions for managem',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: intercompany_transaction uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for per',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: intercompany_transaction.profit_center (STRING) is a denormalized reference to the profit_center master. Adding profit_center_id FK normalizes profit center assignment on intercompany transactions for',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: intercompany_transaction.gl_account_sending (STRING) is a denormalized reference to the gl_account master for the sending entitys GL account. Adding sending_gl_account_id FK normalizes this GL refere',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: intercompany_transaction.sending_entity_code (STRING) is a denormalized reference to the legal_entity master for the sending entity. Adding sending_legal_entity_id FK normalizes the sender side of int',
    `amount_group_currency` DECIMAL(18,2) COMMENT 'The transaction gross amount translated into the groups reporting currency (e.g., USD or EUR) using the applicable exchange rate. Used for consolidated financial statements and EBITDA reporting.',
    `cost_center` STRING COMMENT 'The cost center code in the sending entity to which the intercompany cost recharge or expense is allocated. Supports internal cost accounting and COGS analysis.',
    `country_by_country_flag` BOOLEAN COMMENT 'Indicates whether this intercompany transaction is subject to OECD BEPS Action 13 Country-by-Country Reporting requirements. Drives inclusion in the CbCR master file and local file documentation.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the intercompany transaction record was first created in the source system or the silver layer. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `document_reference` STRING COMMENT 'Reference to the originating source document (e.g., purchase order number, invoice number, loan agreement number) that triggered the intercompany transaction. Supports three-way matching and audit trail.',
    `due_date` DATE COMMENT 'The contractual due date by which the intercompany payable must be settled by the sending entity, as defined in the intercompany agreement or payment terms.. Valid values are `^d{4}-d{2}-d{2}$`',
    `elimination_flag` BOOLEAN COMMENT 'Indicates whether this intercompany transaction has been flagged for elimination during group consolidation to avoid double-counting of revenues and expenses in the consolidated financial statements.. Valid values are `true|false`',
    `elimination_status` STRING COMMENT 'The current status of the intercompany elimination process for this transaction during group consolidation. Tracks whether the transaction has been fully, partially, or not yet eliminated.. Valid values are `pending|eliminated|partially_eliminated|not_applicable|disputed`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to translate the transaction currency amount into the group reporting currency at the time of posting. Sourced from the ERP exchange rate table.',
    `exchange_rate_type` STRING COMMENT 'The type of exchange rate applied for currency translation (e.g., spot rate, monthly average, closing rate, budget rate). Determines the translation methodology per IAS 21 and GAAP ASC 830.. Valid values are `spot|average|closing|budget|standard`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month 1–12, or special periods 13–16) within the fiscal year in which the intercompany transaction is posted. Supports period-end close and consolidation cycles.. Valid values are `^(1[0-6]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the intercompany transaction is recorded, used for period-end consolidation, elimination, and statutory reporting.. Valid values are `^d{4}$`',
    `gl_account_receiving` STRING COMMENT 'The General Ledger account number in the receiving entitys chart of accounts to which the corresponding intercompany entry is posted (credit side). Required for intercompany reconciliation.',
    `gross_amount` DECIMAL(18,2) COMMENT 'The total gross monetary value of the intercompany transaction before any adjustments, discounts, or taxes, expressed in the transaction currency. Core financial measure for consolidation and elimination.',
    `group_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the groups consolidation reporting currency into which all intercompany amounts are translated for consolidated financial statements.. Valid values are `^[A-Z]{3}$`',
    `intercompany_agreement_reference` STRING COMMENT 'The reference number or identifier of the intercompany agreement (ICA) or master service agreement governing this transaction. Required for transfer pricing documentation and legal compliance.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to the intercompany transaction record in the source system or silver layer. Supports change tracking and incremental data loading.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `markup_percentage` DECIMAL(18,2) COMMENT 'The percentage markup applied above cost to derive the transfer price for intercompany transactions, as defined in the intercompany pricing agreement. Used for transfer pricing documentation and OECD compliance.',
    `net_amount` DECIMAL(18,2) COMMENT 'The net monetary value of the intercompany transaction after deducting applicable discounts, rebates, or adjustments, expressed in the transaction currency.',
    `payment_status` STRING COMMENT 'The settlement status of the intercompany transaction, indicating whether the corresponding intercompany payable/receivable has been settled, is outstanding, or has been netted through a cash pooling arrangement.. Valid values are `unpaid|partially_paid|paid|overdue|netted|waived`',
    `posting_date` DATE COMMENT 'The date on which the intercompany transaction is posted to the general ledger in the sending entitys books. Determines the fiscal period for accounting recognition.. Valid values are `^d{4}-d{2}-d{2}$`',
    `profit_center` STRING COMMENT 'The profit center code associated with the intercompany transaction for internal profitability reporting and segment analysis. Supports EBITDA reporting by business unit.',
    `receiving_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the receiving legal entitys country of incorporation. Used for cross-border transfer pricing analysis and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `receiving_entity_code` STRING COMMENT 'The company code or legal entity identifier of the entity receiving the goods, services, or funds and recording the corresponding credit/receivable entry.',
    `reconciliation_date` DATE COMMENT 'The date on which the intercompany transaction was successfully reconciled between the sending and receiving entities. Used for period-end close monitoring and audit compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reconciliation_status` STRING COMMENT 'The reconciliation status of the intercompany transaction between the sending and receiving entities. Tracks whether both sides of the transaction agree on amounts, dates, and classification.. Valid values are `unreconciled|in_progress|reconciled|disputed|approved|rejected`',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this intercompany transaction is a reversal of a previously posted transaction. Used to identify correcting entries and maintain audit integrity.. Valid values are `true|false`',
    `reversed_transaction_number` STRING COMMENT 'The transaction number of the original intercompany transaction that this record reverses. Populated only when reversal_flag is true, enabling audit trail linkage.',
    `sending_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the sending legal entitys country of incorporation. Used for country-by-country reporting and transfer pricing jurisdiction analysis.. Valid values are `^[A-Z]{3}$`',
    `source_system` STRING COMMENT 'The operational system of record from which this intercompany transaction was originated or extracted (e.g., SAP S/4HANA FI module). Supports data lineage and reconciliation to source.. Valid values are `SAP_S4HANA|MANUAL|LEGACY|OTHER`',
    `status` STRING COMMENT 'The overall lifecycle status of the intercompany transaction record, from initial draft through posting, approval, and potential reversal or cancellation.. Valid values are `draft|posted|approved|reversed|cancelled|under_review`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax component (e.g., VAT, GST, withholding tax) associated with the intercompany transaction, expressed in the transaction currency. Required for tax compliance and statutory reporting.',
    `transaction_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the intercompany transaction is denominated (e.g., USD, EUR, GBP). The base currency for all transaction amounts.. Valid values are `^[A-Z]{3}$`',
    `transaction_date` DATE COMMENT 'The business date on which the intercompany transaction was initiated or the economic event occurred. Used for period allocation and transfer pricing documentation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `transaction_number` STRING COMMENT 'Business-facing alphanumeric reference number assigned to the intercompany transaction, used for cross-entity reconciliation and audit trail. Follows the format ICT-YYYY-NNNNNNNN.. Valid values are `^ICT-[0-9]{4}-[0-9]{8}$`',
    `transaction_type` STRING COMMENT 'Classification of the intercompany transaction by its business nature, such as intercompany sale of goods, cost recharge, management fee, loan, dividend payment, or royalty. Drives accounting treatment and elimination logic.. Valid values are `intercompany_sale|intercompany_purchase|cost_recharge|management_fee|intercompany_loan|dividend_payment|royalty|service_charge|capital_contribution|netting`',
    `transfer_price` DECIMAL(18,2) COMMENT 'The arms-length price applied to the intercompany transaction as determined by the transfer pricing policy and intercompany agreement. Critical for OECD transfer pricing compliance and tax authority documentation.',
    `transfer_pricing_method` STRING COMMENT 'The OECD-approved transfer pricing methodology used to determine the arms-length price for this intercompany transaction (e.g., Comparable Uncontrolled Price, Cost Plus, Transactional Net Margin Method).. Valid values are `comparable_uncontrolled_price|resale_price|cost_plus|transactional_net_margin|profit_split|other`',
    CONSTRAINT pk_intercompany_transaction PRIMARY KEY(`intercompany_transaction_id`)
) COMMENT 'Transactional record capturing financial transactions between Manufacturing legal entities including intercompany sales, loans, cost recharges, and dividend payments. Records sending entity, receiving entity, transaction type, gross amount, transfer price, markup percentage, intercompany agreement reference, elimination flag, and reconciliation status. Critical for group consolidation, intercompany elimination, and transfer pricing compliance under OECD guidelines.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` (
    `currency_exchange_rate_id` BIGINT COMMENT 'Unique surrogate identifier for each currency exchange rate record in the silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: currency_exchange_rate.controlling_area_code (STRING) is a denormalized reference to the controlling_area master. Exchange rates can be scoped to controlling areas in SAP. Adding controlling_area_id F',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: currency_exchange_rate.company_code (STRING) is a denormalized reference to the legal_entity master. Exchange rates can be company-code specific. Adding legal_entity_id FK normalizes entity scoping fo',
    `approval_status` STRING COMMENT 'Workflow approval status for the exchange rate record, indicating whether it has been reviewed and authorized by the treasury or finance controller. Supports segregation of duties and internal control requirements under SOX and IFRS governance frameworks.. Valid values are `pending|approved|rejected|auto_approved`',
    `approved_by` STRING COMMENT 'Name or user identifier of the treasury officer or finance controller who approved this exchange rate for use in financial postings. Supports audit trail requirements under SOX and internal control frameworks.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the exchange rate record was formally approved for use in financial transactions and consolidation. Part of the audit trail for internal controls and regulatory compliance.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `averaging_method` STRING COMMENT 'For average-type exchange rates, specifies the mathematical method used to compute the average (e.g., simple average of daily closing rates, weighted average by transaction volume). Required for IAS 21 compliance when using average rates for P&L translation.. Valid values are `simple_average|weighted_average|daily_average|monthly_average|not_applicable`',
    `company_code` STRING COMMENT 'SAP company code identifying the legal entity or organizational unit for which this exchange rate is specifically configured. Some rate types (e.g., budget, intercompany) may be company-code-specific while standard market rates are global.. Valid values are `^[A-Z0-9]{1,6}$`',
    `consolidation_relevant` BOOLEAN COMMENT 'Indicates whether this exchange rate is designated for use in group financial consolidation and translation of subsidiary financial statements into the group reporting currency. Supports IAS 21 and IFRS 10 consolidation translation requirements.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this exchange rate record was first created in the source system or ingested into the lakehouse. Part of the standard audit trail for financial data governance and SOX compliance.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `currency_pair` STRING COMMENT 'Concatenated display representation of the currency pair in standard FX market notation (e.g., USD/EUR, GBP/JPY). Used for reporting, dashboards, and FX analytics. Derived from from_currency_code and to_currency_code but stored for query performance.. Valid values are `^[A-Z]{3}/[A-Z]{3}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The numeric exchange rate expressing how many units of the to-currency are equivalent to one unit of the from-currency. High precision (10 decimal places) is required for currencies with large denomination differences (e.g., JPY/IDR pairs) and to avoid rounding errors in large-value financial transactions.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or special period) within the fiscal year to which this rate applies. Used for period-average and period-closing rates in monthly financial close and consolidation processes. Supports up to 16 periods including special posting periods.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this exchange rate applies, particularly relevant for budget rates, average rates, and period-closing rates used in annual financial consolidation and statutory reporting.. Valid values are `^[0-9]{4}$`',
    `from_currency_code` STRING COMMENT 'ISO 4217 three-letter code of the source currency being converted from (e.g., USD, EUR, GBP). Represents the transaction or base currency in the exchange rate pair.. Valid values are `^[A-Z]{3}$`',
    `inverse_rate` DECIMAL(18,2) COMMENT 'The reciprocal of the exchange rate (1 / exchange_rate), expressing how many units of the from-currency equal one unit of the to-currency. Stored explicitly to avoid division-by-zero errors and to support bidirectional conversion lookups in financial systems.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `is_triangulation_rate` BOOLEAN COMMENT 'Indicates whether this exchange rate was derived via triangulation through a third reference currency (e.g., EUR as the pivot currency for non-EUR pairs within the Eurozone). Required for EU regulatory compliance and for auditing cross-rate derivation methodology.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this exchange rate record, whether in the source system or the lakehouse. Supports change detection, incremental loading, and audit trail requirements for financial data governance.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `quotation_method` STRING COMMENT 'Indicates whether the exchange rate is expressed as a direct quotation (units of domestic currency per one unit of foreign currency) or indirect quotation (units of foreign currency per one unit of domestic currency). Affects how the rate is applied in currency conversion calculations.. Valid values are `direct|indirect`',
    `rate_category` STRING COMMENT 'Categorizes the rate as mid-market, bank buying, bank selling, official central bank rate, or parallel market rate. Relevant for countries with multiple official exchange rate regimes and for treasury operations distinguishing between buy/sell rates.. Valid values are `mid|buying|selling|official|parallel`',
    `rate_date` DATE COMMENT 'The specific market date on which the exchange rate was observed or published by the rate source. For spot rates, this is the trade date. For average rates, this may be the last day of the averaging period. Distinct from valid_from_date which governs ERP applicability.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `rate_key` STRING COMMENT 'Business natural key uniquely identifying a rate record, composed of from-currency code, to-currency code, rate type, and valid-from date (e.g., USD_EUR_SPOT_2024-01-01). Supports idempotent upserts and deduplication in the lakehouse.. Valid values are `^[A-Z]{3}_[A-Z]{3}_[A-Z0-9_]+_[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `rate_ratio_from` DECIMAL(18,2) COMMENT 'The number of from-currency units used as the base for the exchange rate quotation (e.g., 100 for currencies quoted per 100 units such as JPY). Supports indirect quotation conventions where the rate is expressed per N units rather than per 1 unit.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `rate_ratio_to` DECIMAL(18,2) COMMENT 'The number of to-currency units used as the target for the exchange rate quotation. Together with rate_ratio_from, defines the exact quotation convention (e.g., 1 USD = 100 JPY expressed as ratio 1:100). Required for accurate cross-rate calculations.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `rate_source` STRING COMMENT 'The originating provider or feed from which the exchange rate was obtained. Common sources include ECB (European Central Bank), Reuters, Bloomberg, central bank feeds, IMF, World Bank, internal treasury, or manual entry. Critical for audit trails and rate governance under IAS 21 and group consolidation policies.. Valid values are `ECB|Reuters|Bloomberg|internal|central_bank|manual|IMF|World_Bank|bank_feed`',
    `rate_source_reference` STRING COMMENT 'Specific reference identifier or URL from the rate source (e.g., ECB publication reference, Reuters RIC code, Bloomberg ticker, or central bank bulletin reference). Provides traceability for audit and regulatory compliance purposes.',
    `rate_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the exchange rate was captured or published, including timezone offset. Critical for intraday spot rates and for reconciling rates across time zones in a multinational treasury environment.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `rate_type` STRING COMMENT 'Classification of the exchange rate indicating its intended use: spot (real-time market rate), average (period average for P&L translation), closing (period-end balance sheet rate), budget (planning rate), historical (original transaction rate), intercompany (internal transfer pricing rate), or hedge (hedging instrument rate). Aligns with IAS 21 translation requirements.. Valid values are `spot|average|closing|budget|historical|intercompany|hedge`',
    `rate_type_code` STRING COMMENT 'Short system code identifying the exchange rate type as configured in the ERP (e.g., M for standard translation, P for budget, B for bank buying rate in SAP S/4HANA). Enables direct mapping to source system rate type keys.. Valid values are `^[A-Z0-9]{1,4}$`',
    `revaluation_relevant` BOOLEAN COMMENT 'Indicates whether this exchange rate is designated for use in foreign currency revaluation runs (e.g., month-end balance sheet revaluation of open items and balances). Supports IAS 21 revaluation processes in SAP S/4HANA FI.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system or feed from which this exchange rate record was ingested into the lakehouse (e.g., SAP S/4HANA FI, Reuters feed, Bloomberg API, ECB data warehouse, manual treasury upload). Supports data lineage and reconciliation.. Valid values are `SAP_S4HANA|Reuters|Bloomberg|ECB|manual|treasury_system|intercompany`',
    `source_system_key` STRING COMMENT 'The primary key or unique record identifier of this exchange rate as it exists in the originating source system (e.g., SAP TCURR composite key). Enables bidirectional traceability between the lakehouse silver layer and the system of record.',
    `spread_rate` DECIMAL(18,2) COMMENT 'The bid-ask spread applied to the mid-market rate to derive the buying or selling rate used in actual transactions. Relevant for bank-fed rates and treasury operations where transaction costs are embedded in the rate.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `status` STRING COMMENT 'Current lifecycle status of the exchange rate record. Active rates are available for transaction processing; superseded rates have been replaced by newer entries; pending_approval rates await treasury or finance controller sign-off before use in official postings.. Valid values are `active|inactive|superseded|pending_approval|approved|rejected`',
    `to_currency_code` STRING COMMENT 'ISO 4217 three-letter code of the target currency being converted to (e.g., EUR, USD, JPY). Represents the reporting or group currency in the exchange rate pair.. Valid values are `^[A-Z]{3}$`',
    `triangulation_currency_code` STRING COMMENT 'ISO 4217 code of the intermediate reference currency used in triangulation rate derivation (typically EUR for Eurozone cross-rates). Populated only when is_triangulation_rate is true.. Valid values are `^[A-Z]{3}$`',
    `valid_from_date` DATE COMMENT 'The calendar date from which this exchange rate is effective and applicable for currency conversion. Used to select the correct rate for a given transaction date. Supports temporal validity management in multi-period financial reporting.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `valid_to_date` DATE COMMENT 'The calendar date until which this exchange rate remains effective. A null or high-date value (e.g., 9999-12-31) indicates the rate is currently active with no defined expiry. Supports SCD Type 2 temporal management in the silver layer.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    CONSTRAINT pk_currency_exchange_rate PRIMARY KEY(`currency_exchange_rate_id`)
) COMMENT 'Reference master for foreign currency exchange rates used across all financial transactions and consolidation processes. Captures currency pair (from/to currency), exchange rate type (spot, average, closing, budget), valid-from date, exchange rate value, rate source (ECB, Reuters, internal), and rate status. Supports multi-currency transaction recording, foreign currency revaluation, and group consolidation translation under IAS 21.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`tax_code` (
    `tax_code_id` BIGINT COMMENT 'Unique surrogate identifier for each tax code record in the Manufacturing finance domain. Serves as the primary key for the tax_code reference master table.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: tax_code.company_code (STRING) is a denormalized reference to the legal_entity master. Tax codes are defined per company code/legal entity for jurisdiction-specific tax compliance. Adding legal_entity',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: tax_code.gl_account_tax_payable (STRING) is a denormalized reference to the gl_account master for the tax payable account. Adding tax_payable_gl_account_id FK normalizes this GL mapping for tax liabil',
    `code` STRING COMMENT 'Alphanumeric tax code identifier as defined in the financial system (e.g., SAP FI tax code such as V1, A1, I0). Used to determine applicable tax rates and GL account assignments on financial transactions.. Valid values are `^[A-Z0-9]{1,4}$`',
    `company_code` STRING COMMENT 'SAP company code to which this tax code is assigned. Enables company-specific tax configuration and supports multi-entity financial reporting and statutory compliance across Manufacturing legal entities.. Valid values are `^[A-Z0-9]{1,4}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the country in which this tax code is applicable (e.g., DEU for Germany, USA for United States, CHN for China). Supports multi-country tax compliance and statutory reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tax code record was first created in the system of record. Supports audit trail, data lineage, and compliance with IFRS and GAAP record-keeping requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the currency in which the minimum tax base amount and any fixed tax amounts are denominated (e.g., EUR, USD, GBP). Supports multi-currency tax calculation across Manufacturings global operations.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Human-readable description of the tax code explaining its purpose and applicability (e.g., Standard Input VAT 19%, Zero-Rated Output VAT, US Sales Tax - California).',
    `eu_tax_flag` BOOLEAN COMMENT 'Indicates whether this tax code is applicable to European Union intra-community transactions. When true, the tax code is used for EU cross-border supplies and acquisitions subject to EU VAT rules, including EC Sales List and Intrastat reporting.. Valid values are `true|false`',
    `gl_account_tax_receivable` STRING COMMENT 'GL account number assigned for posting tax receivable / deductible input tax amounts when this tax code is applied on purchase transactions. Supports VAT reclaim and input tax recovery processes.. Valid values are `^[0-9]{6,10}$`',
    `jurisdiction_code` STRING COMMENT 'Code identifying the tax jurisdiction to which this tax code applies (e.g., country code, state/province code, or composite jurisdiction code for US sales tax). Supports multi-jurisdiction tax determination and cross-border transaction processing.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this tax code record. Used for change data capture (CDC) in the Databricks Silver Layer pipeline, audit trail maintenance, and compliance with tax record retention requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `minimum_tax_base_amount` DECIMAL(18,2) COMMENT 'Minimum transaction base amount threshold below which this tax code is not applied. Used for de minimis tax rules and small transaction exemptions in certain jurisdictions.',
    `non_deductible_percentage` DECIMAL(18,2) COMMENT 'Percentage of the input tax that is non-deductible and cannot be reclaimed as input VAT credit (e.g., 50% non-deductible for mixed-use assets). Used in partial VAT recovery calculations and tax return preparation.. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `plant_applicability` STRING COMMENT 'Defines the scope of plant-level applicability for this tax code — whether it applies to all manufacturing plants, a specific plant, or all plants within a given country. Supports plant-level tax determination in manufacturing operations.. Valid values are `all_plants|specific_plant|plant_country`',
    `posting_indicator` STRING COMMENT 'Controls how the tax amount is posted in the general ledger: posted to a separate tax GL account, distributed to the expense/revenue line item, or not posted at all. Determines the accounting treatment of tax amounts in financial postings.. Valid values are `post_separately|distribute_to_expense|not_posted`',
    `purchasing_tax_code_flag` BOOLEAN COMMENT 'Indicates whether this tax code is configured for use in purchasing (procurement) transactions within SAP MM/Ariba. When true, the code is available for assignment on purchase orders, goods receipts, and vendor invoices.. Valid values are `true|false`',
    `region_code` STRING COMMENT 'Sub-national region or state code where the tax code applies (e.g., US state code CA for California, TX for Texas). Relevant for US sales tax, Canadian provincial tax, and other sub-national tax regimes.',
    `reporting_category` STRING COMMENT 'Categorization of the tax code for statutory tax reporting purposes. Determines which tax return or regulatory report this tax code contributes to (e.g., VAT return box mapping, Intrastat, EC Sales List, withholding tax return). Supports automated tax return preparation.. Valid values are `vat_return|withholding_tax_return|sales_tax_return|intrastat|ec_sales_list|annual_tax_return|other`',
    `reverse_charge_flag` BOOLEAN COMMENT 'Indicates whether this tax code applies the reverse charge mechanism, where the tax liability is shifted from the supplier to the customer (common in B2B cross-border EU transactions and construction services). When true, the buyer self-accounts for VAT.. Valid values are `true|false`',
    `sales_tax_code_flag` BOOLEAN COMMENT 'Indicates whether this tax code is configured for use in sales (order-to-cash) transactions within SAP SD. When true, the code is available for assignment on sales orders, billing documents, and customer invoices.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this tax code record was sourced (e.g., SAP S/4HANA FI, SAP Ariba). Supports data lineage tracking and reconciliation in the Databricks Silver Layer lakehouse.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL|OTHER`',
    `source_system_key` STRING COMMENT 'The natural key or unique identifier of this tax code record in the originating source system (e.g., SAP tax code + company code composite key). Enables traceability and reconciliation between the lakehouse Silver Layer and the system of record.',
    `status` STRING COMMENT 'Current operational status of the tax code. Active codes are available for use in financial transactions. Inactive codes are blocked from new postings. Superseded codes have been replaced by updated tax codes following rate changes.. Valid values are `active|inactive|pending_approval|superseded`',
    `tax_authority_name` STRING COMMENT 'Name of the tax authority or revenue agency responsible for administering this tax code (e.g., Bundeszentralamt für Steuern for Germany, IRS for USA, HMRC for UK). Used for tax remittance and compliance reporting.',
    `tax_base_amount_type` STRING COMMENT 'Defines the basis on which the tax rate is applied: net amount (tax calculated on net invoice value), gross amount (tax calculated on gross including other taxes), tax-on-tax (cascading tax), or fixed amount. Determines the tax calculation logic for financial transactions.. Valid values are `net_amount|gross_amount|tax_on_tax|fixed_amount`',
    `tax_category` STRING COMMENT 'Categorization of the tax code by rate tier or exemption status. Supports VAT compliance reporting, tax return preparation, and cross-border transaction tax determination under EU VAT Directive and local tax laws.. Valid values are `standard_rate|reduced_rate|zero_rate|exempt|non_taxable|reverse_charge|mixed`',
    `tax_exemption_reason` STRING COMMENT 'Description or code of the legal basis for tax exemption when the tax rate is zero or the category is exempt (e.g., Intra-community supply Article 138 VAT Directive, Export supply, Medical exemption). Required for statutory reporting and audit trail.',
    `tax_group` STRING COMMENT 'Grouping classification for tax codes used in tax reporting, analytics, and consolidation (e.g., EU_VAT, US_SALES_TAX, WITHHOLDING, EXCISE). Supports aggregated tax reporting across jurisdictions and tax type consolidation.',
    `tax_procedure_code` STRING COMMENT 'Code identifying the tax calculation procedure or tax schema to which this tax code belongs (e.g., SAP tax procedure TAXD for Germany, TAXUS for USA). Determines the sequence of condition types used in tax calculation.',
    `tax_rate_change_reason` STRING COMMENT 'Description of the reason for a tax rate change or new tax code creation (e.g., Legislative amendment effective 2024-01-01, COVID-19 temporary rate reduction, Post-Brexit UK VAT adjustment). Provides audit trail for tax rate history.',
    `tax_rate_percentage` DECIMAL(18,2) COMMENT 'The applicable tax rate expressed as a percentage (e.g., 19.0000 for 19% German VAT, 7.2500 for 7.25% California sales tax). Used in tax calculation on financial transactions and tax return filings.. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `tax_return_box_code` STRING COMMENT 'Reference code mapping this tax code to a specific box or line on the statutory tax return form (e.g., VAT return box number, sales tax schedule line). Enables automated population of tax returns from transaction data.',
    `tax_type` STRING COMMENT 'Classification of the tax code by tax mechanism. Distinguishes between input VAT (recoverable tax on purchases), output VAT (tax charged on sales), withholding tax (tax deducted at source), sales tax, use tax, excise duty, and other tax types. Critical for VAT return preparation and tax compliance reporting.. Valid values are `input_vat|output_vat|withholding_tax|sales_tax|use_tax|excise_tax|customs_duty|goods_services_tax|service_tax|other`',
    `transaction_direction` STRING COMMENT 'Indicates whether this tax code is applicable to purchase transactions (accounts payable / input tax), sales transactions (accounts receivable / output tax), or both directions. Controls tax code availability in procurement and sales processes.. Valid values are `purchase|sale|both`',
    `valid_from_date` DATE COMMENT 'The date from which this tax code and its associated rate become effective. Supports time-dependent tax rate management, enabling historical tax rate lookups and future rate changes to be pre-configured.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'The date until which this tax code and its associated rate remain effective. A null or maximum date value (9999-12-31) indicates an open-ended validity. Supports tax rate change management and historical compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `withholding_tax_type` STRING COMMENT 'For withholding tax codes, specifies whether withholding tax is calculated and posted at the time of invoice posting, payment posting, or both. Applicable only when tax_type is withholding_tax. Supports accurate WHT liability tracking and remittance.. Valid values are `invoice|payment|both|not_applicable`',
    CONSTRAINT pk_tax_code PRIMARY KEY(`tax_code_id`)
) COMMENT 'Reference master defining tax codes and tax rates applicable to financial transactions across all Manufacturing jurisdictions. Captures tax code, tax type (input/output VAT, withholding tax, sales tax), tax rate percentage, tax jurisdiction, validity dates, GL account assignment for tax postings, and reporting category. Supports VAT compliance, tax return preparation, and cross-border transaction tax determination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`statement_version` (
    `statement_version_id` BIGINT COMMENT 'Unique surrogate key identifying each financial statement version record in the silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: statement_version.chart_of_accounts_code (STRING) is a denormalized reference to the chart_of_accounts master. Financial statement versions are built on top of a chart of accounts. Adding chart_of_acc',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: statement_version.controlling_area_code (STRING) is a denormalized reference to the controlling_area master. Statement versions can be scoped to controlling areas. Adding controlling_area_id FK normal',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: statement_version.company_code (STRING) is a denormalized reference to the legal_entity master. Financial statement versions are defined per legal entity for statutory reporting. Adding legal_entity_i',
    `approval_date` DATE COMMENT 'Date on which this financial statement version was formally approved for production use. Required for audit trail and SOX compliance documentation of financial reporting structure changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or user ID of the finance controller, CFO, or authorized approver who approved this financial statement version for use in statutory reporting and period-end close processes.',
    `capex_opex_split_flag` BOOLEAN COMMENT 'Indicates whether this FSV includes separate line item groupings for CAPEX and OPEX classification, enabling capital investment tracking and operational cost analysis in financial statements.. Valid values are `true|false`',
    `cogs_line_item_flag` BOOLEAN COMMENT 'Indicates whether this FSV contains dedicated COGS line item definitions for manufacturing cost reporting. Supports gross margin analysis and product profitability reporting in industrial manufacturing contexts.. Valid values are `true|false`',
    `company_code` STRING COMMENT 'SAP company code to which this financial statement version is assigned, representing the smallest organizational unit for which a complete set of accounts can be drawn up for statutory reporting purposes.. Valid values are `^[A-Z0-9]{1,10}$`',
    `consolidation_chart_of_accounts` STRING COMMENT 'Code of the group consolidation chart of accounts used for mapping local GL accounts to group-level line items within this FSV. Enables multi-entity group reporting and intercompany elimination.. Valid values are `^[A-Z0-9]{1,10}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction for which this financial statement version is designed. Determines applicable local GAAP requirements, regulatory filing formats, and statutory disclosure obligations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this financial statement version record was first created in the system of record. Used for audit trail, data lineage, and change management tracking in compliance with SOX and ISO 9001 requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which this financial statement version is presented. Determines the functional or presentation currency for statutory and group reporting purposes.. Valid values are `^[A-Z]{3}$`',
    `ebitda_reporting_flag` BOOLEAN COMMENT 'Indicates whether this FSV includes EBITDA line item definitions and GL account assignments to support EBITDA reporting for investor relations, credit agreements, and management performance tracking.. Valid values are `true|false`',
    `fiscal_year_variant` STRING COMMENT 'SAP fiscal year variant code defining the fiscal year calendar (e.g., calendar year, non-calendar year, 4-4-5 period structure) applicable to this financial statement version for period assignment.. Valid values are `^[A-Z0-9]{1,4}$`',
    `fsv_code` STRING COMMENT 'Alphanumeric code uniquely identifying the financial statement version within the system of record (e.g., SAP FSV key). Used as the business key for cross-system referencing and statutory report generation.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `fsv_long_name` STRING COMMENT 'Full descriptive name of the financial statement version providing complete context for statutory filings, audit documentation, and regulatory submissions.',
    `fsv_name` STRING COMMENT 'Short descriptive name of the financial statement version as defined in the system of record (e.g., IFRS Group Reporting, US GAAP Statutory). Used in report headers and user-facing displays.',
    `group_reporting_flag` BOOLEAN COMMENT 'Indicates whether this financial statement version is used for group-level consolidated reporting across multiple legal entities. When true, intercompany eliminations and minority interest adjustments are applied.. Valid values are `true|false`',
    `hierarchy_structure` STRING COMMENT 'Defines whether the financial statement version uses a flat single-level structure or a multi-level hierarchical node structure for grouping and subtotaling line items in statutory reports.. Valid values are `FLAT|HIERARCHICAL|MULTI_LEVEL`',
    `intercompany_elimination_flag` BOOLEAN COMMENT 'Indicates whether intercompany transaction eliminations are applied when generating financial statements under this FSV. Required for consolidated group reporting to avoid double-counting of intra-group revenues and expenses.. Valid values are `true|false`',
    `language_key` STRING COMMENT 'ISO 639-1 two-letter language code for the primary language in which this FSVs descriptions and line item labels are maintained. Supports multi-language statutory reporting across jurisdictions.. Valid values are `^[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this financial statement version record. Supports change detection, incremental data loading in the lakehouse pipeline, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ledger_code` STRING COMMENT 'Identifier of the accounting ledger (e.g., leading ledger, extension ledger) to which this FSV applies. Supports parallel accounting under multiple standards (IFRS and local GAAP simultaneously).. Valid values are `^[A-Z0-9]{1,10}$`',
    `management_reporting_flag` BOOLEAN COMMENT 'Indicates whether this FSV is used for internal management reporting purposes (e.g., EBITDA reporting, segment performance, cost center P&L). Management FSVs may differ from statutory structures.. Valid values are `true|false`',
    `max_hierarchy_levels` STRING COMMENT 'Maximum number of hierarchical levels defined within this financial statement version structure. Governs the depth of subtotaling nodes available for statutory report generation and group consolidation.. Valid values are `^[1-9][0-9]?$`',
    `regulatory_filing_format` STRING COMMENT 'Electronic or physical format required for regulatory submission of financial statements prepared under this FSV. XBRL/iXBRL formats are mandated by SEC (EDGAR), ESMA, and other regulatory bodies for digital filings.. Valid values are `XBRL|iXBRL|PDF|XML|CSV|PAPER|EDGAR|ESMA|NONE`',
    `reporting_standard` STRING COMMENT 'Accounting standard under which this financial statement version is prepared. Determines recognition, measurement, and disclosure rules applied to all GL account assignments within this FSV.. Valid values are `IFRS|US_GAAP|LOCAL_GAAP|IFRS_FOR_SME|STATUTORY|MANAGEMENT`',
    `segment_reporting_flag` BOOLEAN COMMENT 'Indicates whether this FSV supports segment-level financial statement presentation as required by IFRS 8 or US GAAP ASC 280 for publicly listed entities with multiple operating segments.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this financial statement version definition was extracted. Supports data lineage tracking and reconciliation between the lakehouse silver layer and source systems.. Valid values are `SAP_S4HANA|MANUAL|LEGACY|OTHER`',
    `source_system_key` STRING COMMENT 'Natural key or technical identifier of this financial statement version record in the originating source system (e.g., SAP FSV internal key). Enables traceability and reconciliation between the lakehouse and source system.',
    `statement_type` STRING COMMENT 'Classification of the primary financial statement this version represents. Determines the structural template, line item ordering, and regulatory filing requirements applicable to this FSV.. Valid values are `BALANCE_SHEET|INCOME_STATEMENT|CASH_FLOW|EQUITY_CHANGES|NOTES|COMPREHENSIVE_INCOME|COMBINED`',
    `status` STRING COMMENT 'Current lifecycle status of the financial statement version. Only ACTIVE versions are used for period-end close, statutory reporting, and regulatory filing. DEPRECATED versions are retained for historical audit purposes.. Valid values are `ACTIVE|INACTIVE|DRAFT|UNDER_REVIEW|DEPRECATED|ARCHIVED`',
    `statutory_reporting_flag` BOOLEAN COMMENT 'Indicates whether this FSV is designated for statutory regulatory filing with government authorities or tax bodies. Statutory FSVs are subject to audit and regulatory review requirements.. Valid values are `true|false`',
    `tax_reporting_flag` BOOLEAN COMMENT 'Indicates whether this financial statement version is used for tax authority reporting and corporate income tax return preparation. Tax FSVs may include deferred tax line items and tax-specific adjustments.. Valid values are `true|false`',
    `valid_from_date` DATE COMMENT 'Date from which this financial statement version is effective and can be used for period-end close and statutory reporting. Supports time-dependent FSV management for accounting standard transitions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date until which this financial statement version remains effective. After this date, the FSV is no longer available for new period-end close runs. Supports controlled retirement of superseded reporting structures.. Valid values are `^d{4}-d{2}-d{2}$`',
    `version_description` STRING COMMENT 'Narrative description of the changes or purpose of this specific version iteration, including details of structural modifications, new line item additions, or GL account reassignments made in this version.',
    `version_number` STRING COMMENT 'Sequential version number of this financial statement version definition. Incremented when structural changes are made to hierarchy nodes, line item assignments, or GL account mappings to support change history tracking.. Valid values are `^[1-9][0-9]*$`',
    `xbrl_taxonomy_version` STRING COMMENT 'Version identifier of the XBRL taxonomy (e.g., IFRS Taxonomy 2023, US GAAP Taxonomy 2023) used for tagging financial statement line items in this FSV for regulatory digital filing submissions.',
    CONSTRAINT pk_statement_version PRIMARY KEY(`statement_version_id`)
) COMMENT 'Reference master defining the financial statement structures used for balance sheet, income statement, and cash flow reporting. Captures FSV code, FSV name, reporting standard (IFRS, US GAAP, local GAAP), hierarchy nodes, GL account assignments to line items, and language-specific descriptions. Enables statutory financial statement generation, group reporting, and regulatory filing preparation across all legal entities.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`period_close_activity` (
    `period_close_activity_id` BIGINT COMMENT 'Unique surrogate identifier for each financial period-end or year-end close activity record in the Manufacturing lakehouse silver layer.',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: period_close_activity.controlling_area_code (STRING) is a denormalized reference to the controlling_area master. Period close activities are scoped to controlling areas. Adding controlling_area_id FK ',
    `employee_id` BIGINT COMMENT 'System user ID of the individual responsible for executing or overseeing this close activity. Used for accountability tracking, workload assignment, and audit trail in the period-end close process.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: period_close_activity uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates the essential link between close activities and the fiscal peri',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: period_close_activity.company_code (STRING) is a denormalized reference to the legal_entity master. Period close activities are executed per legal entity. Adding legal_entity_id FK normalizes entity s',
    `signoff_user_employee_id` BIGINT COMMENT 'System user ID of the individual who provided the formal sign-off approval for this close activity. Required for SOX Section 302/404 compliance and internal audit trail.',
    `accounting_standard` STRING COMMENT 'The accounting standard framework under which this close activity is performed. Manufacturing operates under both IFRS and GAAP across its global legal entities, requiring parallel close activities for each standard.. Valid values are `IFRS|GAAP|LOCAL_GAAP|IFRS_AND_GAAP`',
    `activity_code` STRING COMMENT 'Unique alphanumeric code identifying the specific close activity step (e.g., DEP_RUN, GRIR_CLR, FX_REVAL, COST_ALLOC, PC_DIST, BAL_CARRY). Used for programmatic reference and integration with SAP S/4HANA FI close cockpit.. Valid values are `^[A-Z0-9_]{3,30}$`',
    `activity_name` STRING COMMENT 'Human-readable name of the financial close activity (e.g., Depreciation Run, GR/IR Clearing, Foreign Currency Revaluation, Cost Allocation Cycle, Profit Center Distribution, Balance Carryforward).',
    `activity_type` STRING COMMENT 'Classification of the financial close activity type. Drives sequencing logic and dependency management within the period-end close process. Aligned with SAP S/4HANA FI closing cockpit activity categories.. Valid values are `depreciation_run|grir_clearing|foreign_currency_revaluation|cost_allocation_cycle|profit_center_distribution|balance_carryforward|accrual_posting|intercompany_elimination|tax_calculation|inventory_valuation|asset_capitalization|provisions_posting|bank_reconciliation|ledger_closing|other`',
    `actual_completion_timestamp` TIMESTAMP COMMENT 'The actual date and time at which this close activity was successfully completed. Used to calculate duration, measure close efficiency, and confirm period-end close completeness.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_start_timestamp` TIMESTAMP COMMENT 'The actual date and time at which execution of this close activity commenced. Compared against scheduled_start_timestamp to measure close process adherence and identify delays.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `close_category` STRING COMMENT 'Indicates whether this activity belongs to a monthly period-end close, quarterly close, annual year-end close, or a special period adjustment. Determines the scope and regulatory reporting obligations associated with the activity.. Valid values are `period_end|quarter_end|year_end|special_period`',
    `company_code` STRING COMMENT 'SAP S/4HANA company code representing the legal entity for which this close activity is executed. Enables multi-entity close tracking across all Manufacturing legal entities globally.. Valid values are `^[A-Z0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp at which this period close activity record was created in the lakehouse silver layer. Used for data lineage, audit trail, and incremental load processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `dependency_activity_code` STRING COMMENT 'The activity_code of the predecessor close activity that must be completed before this activity can begin. Captures the dependency chain within the period-end close plan for sequencing and blocking logic.. Valid values are `^[A-Z0-9_]{3,30}$`',
    `due_timestamp` TIMESTAMP COMMENT 'The deadline timestamp by which this close activity must be completed to meet the period-end close schedule. Activities not completed by this timestamp are flagged as overdue for escalation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `error_log_reference` STRING COMMENT 'Reference identifier or path to the error log generated when this close activity fails or completes with errors. Enables rapid diagnosis and resolution of close failures. May reference SAP application log (SLG1) object.',
    `error_message` STRING COMMENT 'Short description of the error or exception encountered during execution of this close activity. Captured for immediate visibility in close dashboards without requiring access to the full error log.',
    `execution_mode` STRING COMMENT 'Indicates whether the close activity is executed automatically by the system (e.g., scheduled batch job), manually by a user, or semi-automatically (system-assisted with manual confirmation). Supports automation tracking and audit.. Valid values are `automatic|manual|semi_automatic`',
    `execution_status` STRING COMMENT 'Current execution status of the close activity. Drives close cockpit dashboard visibility, escalation workflows, and period-end completeness checks. Aligned with SAP S/4HANA closing cockpit task status values.. Valid values are `not_started|in_progress|completed|completed_with_errors|failed|skipped|cancelled|on_hold|pending_approval`',
    `fiscal_period` STRING COMMENT 'The fiscal period number (1–12 for regular periods, 13–16 for special/adjustment periods) within the fiscal year to which this close activity applies. Aligns with SAP S/4HANA posting period variant.. Valid values are `^(1[0-6]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this period close activity belongs. Used for annual reporting, statutory filing, and year-end close sequencing.. Valid values are `^[0-9]{4}$`',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this close activity is mandatory for period-end close completion. Mandatory activities must be completed and signed off before the fiscal period can be locked for posting.. Valid values are `true|false`',
    `is_period_locked` BOOLEAN COMMENT 'Indicates whether the fiscal period was locked for posting upon completion of this activity. A value of True confirms that no further postings are permitted for the associated fiscal period and company code.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to this period close activity record. Supports change detection, incremental processing, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ledger_code` STRING COMMENT 'Identifies the accounting ledger (e.g., leading ledger 0L for IFRS, extension ledger for local GAAP) against which this close activity is executed. Supports parallel accounting under IFRS and local GAAP.. Valid values are `^[A-Z0-9]{2}$`',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, manual observations, exception explanations, or instructions related to this close activity. Used by finance teams to document non-standard close situations.',
    `priority` STRING COMMENT 'Business priority assigned to this close activity within the period-end close sequence. Critical activities (e.g., depreciation run, balance carryforward) must complete before dependent activities can proceed.. Valid values are `critical|high|medium|low`',
    `responsible_team` STRING COMMENT 'Name of the finance team or organizational unit responsible for this close activity (e.g., Corporate Accounting, Regional Finance EMEA, Tax Compliance, Treasury). Supports workload distribution and escalation routing.',
    `responsible_user_name` STRING COMMENT 'Full name of the user responsible for executing this close activity. Retained for audit trail readability and reporting without requiring a join to user master data.',
    `retry_count` STRING COMMENT 'Number of times this close activity has been re-executed after an initial failure or error. Tracks re-run attempts for audit purposes and identifies persistently failing activities requiring escalation.. Valid values are `^[0-9]+$`',
    `sap_document_number` STRING COMMENT 'The SAP S/4HANA accounting document number generated upon successful execution of this close activity (e.g., depreciation posting document, revaluation document). Provides direct traceability to the resulting journal entries.',
    `sap_job_name` STRING COMMENT 'Name of the SAP background job scheduled to execute this close activity automatically. Used for job monitoring, failure diagnosis, and re-execution tracking in the SAP S/4HANA system.',
    `sap_program_name` STRING COMMENT 'The SAP S/4HANA program name or transaction code used to execute this close activity (e.g., AFAB for depreciation run, F.13 for GR/IR clearing, FAGL_FC_VAL for foreign currency revaluation). Enables direct traceability to the source system execution.',
    `scheduled_date` DATE COMMENT 'The planned calendar date on which this close activity is scheduled to be executed, as defined in the period-end close calendar. Used for close timeline management and SLA monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'The precise date and time at which this close activity is scheduled to begin execution. Enables sequencing and dependency management for automated close runs in SAP S/4HANA closing cockpit.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `sequence_number` STRING COMMENT 'Numeric sequence position of this activity within the period-end close plan. Defines the execution order and dependency chain for the close process. Lower numbers execute first.. Valid values are `^[0-9]+$`',
    `signoff_comments` STRING COMMENT 'Free-text comments provided by the approver during the sign-off process. May include conditional approval notes, exceptions granted, or instructions for follow-up actions.',
    `signoff_status` STRING COMMENT 'Status of the formal sign-off approval for this close activity. Certain activities (e.g., balance carryforward, year-end close) require explicit management approval before the period can be locked. Supports SOX compliance.. Valid values are `pending|approved|rejected|not_required`',
    `signoff_timestamp` TIMESTAMP COMMENT 'The date and time at which the formal sign-off approval was granted for this close activity. Provides an immutable audit timestamp for SOX and internal audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this close activity record originates. Primarily SAP S/4HANA FI Closing Cockpit, but may include manual entries or other integrated systems.. Valid values are `SAP_S4HANA|MANUAL|OTHER`',
    CONSTRAINT pk_period_close_activity PRIMARY KEY(`period_close_activity_id`)
) COMMENT 'Transactional record tracking the execution status of financial period-end and year-end close activities across all Manufacturing legal entities. Captures close activity type (depreciation run, GR/IR clearing, foreign currency revaluation, cost allocation cycle, profit center distribution, balance carryforward), scheduled date, actual completion date, responsible user, execution status, error log reference, and sign-off approval. Ensures completeness and auditability of the financial close process.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`house_bank` (
    `house_bank_id` BIGINT COMMENT 'Primary key for house_bank',
    `account_closure_date` DATE COMMENT 'Date when the house bank account was closed or deactivated, if applicable.',
    `account_holder_name` STRING COMMENT 'Legal name of the account holder as registered with the bank, typically the company legal entity name.',
    `account_opening_date` DATE COMMENT 'Date when the house bank account was opened with the financial institution.',
    `account_type` STRING COMMENT 'Classification of the bank account based on its operational purpose and functionality.',
    `bank_account_number` STRING COMMENT 'Primary account number held by the organization at this house bank for operational transactions.',
    `bank_address_line_1` STRING COMMENT 'Primary street address of the bank branch or headquarters.',
    `bank_address_line_2` STRING COMMENT 'Secondary address information such as suite, floor, or building number.',
    `bank_branch_code` STRING COMMENT 'Internal or external code identifying the specific branch location.',
    `bank_branch_name` STRING COMMENT 'Name of the specific branch or office where the account is maintained.',
    `bank_city` STRING COMMENT 'City where the bank branch is located.',
    `bank_code` STRING COMMENT 'Internal code used to identify the house bank within the organizations financial systems. Used for transaction processing and reporting.',
    `bank_contact_email` STRING COMMENT 'Primary email address for bank communications and inquiries.',
    `bank_contact_phone` STRING COMMENT 'Primary phone number for contacting the bank branch or relationship manager.',
    `bank_control_key` STRING COMMENT 'Control key or check digit used for validation of bank account data in payment processing systems.',
    `bank_country_code` STRING COMMENT 'Three-letter ISO country code indicating the country where the house bank is domiciled.',
    `bank_file_format` STRING COMMENT 'Standard file format used for electronic bank statement and payment file exchange (e.g., MT940, BAI2, CAMT.053, ISO 20022).',
    `bank_key` STRING COMMENT 'Country-specific bank identifier such as routing number (USA), sort code (UK), or Bankleitzahl (Germany) used for domestic payment processing.',
    `bank_name` STRING COMMENT 'Official legal name of the financial institution serving as the house bank.',
    `bank_postal_code` STRING COMMENT 'Postal or ZIP code for the bank branch address.',
    `bank_relationship_manager` STRING COMMENT 'Name of the bank relationship manager or account officer responsible for this account.',
    `bank_state_province` STRING COMMENT 'State, province, or region where the bank branch is located.',
    `bank_statement_frequency` STRING COMMENT 'Frequency at which bank statements are generated and received for this account.',
    `company_code` STRING COMMENT 'Internal company code or legal entity identifier that owns or operates this house bank account.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code representing the primary currency of the bank account.',
    `daily_transaction_limit` DECIMAL(18,2) COMMENT 'Maximum total amount of transactions allowed per day from this house bank account.',
    `electronic_banking_enabled` BOOLEAN COMMENT 'Indicates whether electronic banking services (online banking, API integration) are enabled for this account.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which transactions from this house bank are posted.',
    `iban` STRING COMMENT 'International Bank Account Number for cross-border transactions and SEPA payments.',
    `is_primary_account` BOOLEAN COMMENT 'Indicates whether this is the primary house bank account for the company or legal entity.',
    `is_zero_balance_account` BOOLEAN COMMENT 'Indicates whether this is a zero balance account (ZBA) that automatically sweeps funds to or from a concentration account.',
    `last_reconciliation_date` DATE COMMENT 'Date of the most recent bank reconciliation performed for this account.',
    `maximum_transaction_amount` DECIMAL(18,2) COMMENT 'Maximum amount allowed for a single transaction from this house bank account based on bank limits or internal controls.',
    `minimum_balance_amount` DECIMAL(18,2) COMMENT 'Minimum balance required to be maintained in the account as per bank agreement or internal policy.',
    `notes` STRING COMMENT 'Additional notes, comments, or special instructions related to the house bank account.',
    `payment_method_supported` STRING COMMENT 'Comma-separated list of payment methods supported by this house bank account (e.g., wire, ACH, check, SEPA, SWIFT).',
    `status` STRING COMMENT 'Current operational status of the house bank account indicating whether it is available for transactions.',
    `swift_code` STRING COMMENT 'SWIFT/BIC code uniquely identifying the financial institution for international wire transfers and interbank communications.',
    CONSTRAINT pk_house_bank PRIMARY KEY(`house_bank_id`)
) COMMENT 'Master reference table for house_bank. Referenced by house_bank_id.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`cash_pool` (
    `cash_pool_id` BIGINT COMMENT 'Primary key for cash_pool',
    `business_unit_id` BIGINT COMMENT 'Identifier of the business unit responsible for the cash pool. Used for organizational reporting and cost allocation.',
    `house_bank_id` BIGINT COMMENT 'Foreign key linking to finance.house_bank. Business justification: Cash pools have a lead bank that manages the pool. The lead_bank_id should be replaced with FK to house_bank product to enable proper cash pooling structure and bank relationship management.',
    `legal_entity_id` BIGINT COMMENT 'Identifier of the primary legal entity that owns or manages the cash pool. Links to the legal entity master data.',
    `approval_date` DATE COMMENT 'Date when the cash pool structure and terms were formally approved by treasury management or the finance committee.',
    `base_currency_code` STRING COMMENT 'Three-letter ISO currency code representing the base currency of the cash pool. All balances and transactions are denominated or converted to this currency.',
    `category` STRING COMMENT 'Business category indicating the primary purpose of the cash pool within the overall treasury management strategy.',
    `code` STRING COMMENT 'Short alphanumeric code used as a business identifier for the cash pool. Used in treasury operations and reporting.',
    `country_code` STRING COMMENT 'Three-letter ISO country code of the primary jurisdiction where the cash pool is domiciled. Critical for regulatory and tax compliance.',
    `description` STRING COMMENT 'Detailed description of the cash pool purpose, scope, and participating entities. Provides context for treasury operations.',
    `effective_end_date` DATE COMMENT 'Date when the cash pool ceased operations or is scheduled to be closed. Null for currently active pools.',
    `effective_start_date` DATE COMMENT 'Date when the cash pool became effective and operational. Marks the beginning of the cash pool lifecycle.',
    `interest_rate_percent` DECIMAL(18,2) COMMENT 'Interest rate percentage applied to balances in the cash pool. Used for interest allocation and compensation calculations in notional pooling.',
    `is_active` BOOLEAN COMMENT 'Boolean indicator of whether the cash pool is currently active and operational for treasury transactions.',
    `last_rebalance_date` DATE COMMENT 'Date when the cash pool was last rebalanced or swept. Used to track the frequency and timing of cash concentration activities.',
    `lead_bank_account_number` STRING COMMENT 'Primary bank account number associated with the cash pool at the lead bank. Used for fund transfers and balance management.',
    `maximum_balance_amount` DECIMAL(18,2) COMMENT 'Maximum balance threshold allowed in the cash pool. Excess funds above this level may be swept to investment accounts or distributed.',
    `minimum_balance_amount` DECIMAL(18,2) COMMENT 'Minimum balance threshold that must be maintained in the cash pool. Triggers alerts or automated funding when breached.',
    `name` STRING COMMENT 'Full business name of the cash pool. Human-readable identifier used in treasury management and financial reporting.',
    `overdraft_limit_amount` DECIMAL(18,2) COMMENT 'Maximum overdraft or negative balance amount permitted for the cash pool. Represents the credit facility available for short-term liquidity needs.',
    `purpose` STRING COMMENT 'Business purpose and strategic objective of the cash pool. Describes how the pool supports overall treasury and liquidity management goals.',
    `region_code` STRING COMMENT 'Geographic region code where the cash pool operates. Used for regional treasury management and compliance reporting.',
    `regulatory_framework` STRING COMMENT 'Applicable regulatory framework governing the cash pool operations. May include banking regulations, capital requirements, and cross-border fund movement rules.',
    `status` STRING COMMENT 'Current operational status of the cash pool. Indicates whether the pool is actively managing funds or in a non-operational state.',
    `structure` STRING COMMENT 'Organizational structure of the cash pool indicating the level of centralization and geographic scope of pooling arrangements.',
    `target_balance_amount` DECIMAL(18,2) COMMENT 'Target balance amount that the cash pool aims to maintain for optimal liquidity management. Used in automated rebalancing processes.',
    `tax_jurisdiction_code` STRING COMMENT 'Tax jurisdiction code where the cash pool is subject to taxation. Critical for interest income allocation and withholding tax compliance.',
    `type` STRING COMMENT 'Classification of the cash pooling structure. Physical pools involve actual fund transfers; notional pools use interest compensation without fund movement; hybrid combines both; zero balancing sweeps balances daily.',
    CONSTRAINT pk_cash_pool PRIMARY KEY(`cash_pool_id`)
) COMMENT 'Master reference table for cash_pool. Referenced by cash_pool_id.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`ledger` (
    `ledger_id` BIGINT COMMENT 'Primary key for ledger',
    `business_unit_id` BIGINT COMMENT 'Reference to the business unit or division that this ledger supports for management reporting and cost allocation.',
    `chart_of_accounts_id` BIGINT COMMENT 'Reference to the chart of accounts structure that defines the account hierarchy and classification for this ledger.',
    `cost_center_id` BIGINT COMMENT 'Default cost center associated with this ledger for overhead allocation and management accounting purposes.',
    `legal_entity_id` BIGINT COMMENT 'Reference to the legal entity that owns or operates this ledger for statutory and regulatory reporting purposes.',
    `parent_ledger_id` BIGINT COMMENT 'Reference to the parent ledger in a hierarchical ledger structure, used for consolidation and roll-up reporting.',
    `accounting_standard` STRING COMMENT 'The accounting standard or framework that governs this ledgers financial reporting requirements.',
    `approval_workflow_required` BOOLEAN COMMENT 'Flag indicating whether transactions posted to this ledger require approval workflow before final posting.',
    `audit_trail_enabled` BOOLEAN COMMENT 'Flag indicating whether comprehensive audit trail logging is enabled for all transactions posted to this ledger.',
    `code` STRING COMMENT 'Short alphanumeric code uniquely identifying the ledger for business reference and reporting purposes.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the primary jurisdiction for this ledgers statutory reporting requirements.',
    `created_date` DATE COMMENT 'The date when this ledger record was initially created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the functional currency of the ledger.',
    `description` STRING COMMENT 'Detailed description of the ledgers purpose, scope, and usage within the financial system.',
    `effective_end_date` DATE COMMENT 'The date after which this ledger is no longer active for transaction posting, used for ledger closure or migration.',
    `effective_start_date` DATE COMMENT 'The date from which this ledger becomes active and available for transaction posting.',
    `external_system_code` STRING COMMENT 'Identifier used to reference this ledger in external financial systems or consolidation platforms.',
    `fiscal_year_variant` STRING COMMENT 'Code identifying the fiscal year calendar structure used by this ledger, defining period boundaries and year-end dates.',
    `is_consolidation_enabled` BOOLEAN COMMENT 'Flag indicating whether this ledger participates in multi-entity financial consolidation processes.',
    `is_intercompany_enabled` BOOLEAN COMMENT 'Flag indicating whether this ledger supports intercompany transaction tracking and elimination processes.',
    `is_multi_currency_enabled` BOOLEAN COMMENT 'Flag indicating whether this ledger supports transactions in multiple currencies with automatic conversion to functional currency.',
    `is_primary` BOOLEAN COMMENT 'Flag indicating whether this is the primary ledger for the legal entity, used as the source of truth for statutory reporting.',
    `last_closed_period` STRING COMMENT 'The most recent fiscal period that has been closed and locked for this ledger, preventing further transaction posting.',
    `last_modified_date` DATE COMMENT 'The date when this ledger record was most recently updated or modified.',
    `name` STRING COMMENT 'Full descriptive name of the ledger used for display and reporting purposes.',
    `notes` STRING COMMENT 'Free-form text field for capturing additional information, special instructions, or business context related to this ledger.',
    `opening_balance_date` DATE COMMENT 'The date on which opening balances were established for this ledger, typically the go-live or migration date.',
    `region_code` STRING COMMENT 'Geographic region code for grouping ledgers by operational or reporting region.',
    `retention_period_years` STRING COMMENT 'Number of years that financial data in this ledger must be retained to comply with statutory and regulatory requirements.',
    `status` STRING COMMENT 'Current operational status of the ledger indicating whether it is available for transaction posting and reporting.',
    `translation_method` STRING COMMENT 'The method used for translating foreign currency transactions and balances into the ledgers functional currency.',
    `type` STRING COMMENT 'Classification of the ledger indicating its functional purpose within the financial accounting structure.',
    CONSTRAINT pk_ledger PRIMARY KEY(`ledger_id`)
) COMMENT 'Master reference table for ledger. Referenced by ledger_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ADD CONSTRAINT `fk_finance_controlling_area_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ADD CONSTRAINT `fk_finance_fiscal_period_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ADD CONSTRAINT `fk_finance_fiscal_period_prior_period_fiscal_period_id` FOREIGN KEY (`prior_period_fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_ledger_id` FOREIGN KEY (`ledger_id`) REFERENCES `manufacturing_ecm`.`finance`.`ledger`(`ledger_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `manufacturing_ecm`.`finance`.`bank_account`(`bank_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ADD CONSTRAINT `fk_finance_bank_account_cash_pool_id` FOREIGN KEY (`cash_pool_id`) REFERENCES `manufacturing_ecm`.`finance`.`cash_pool`(`cash_pool_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ADD CONSTRAINT `fk_finance_bank_account_house_bank_id` FOREIGN KEY (`house_bank_id`) REFERENCES `manufacturing_ecm`.`finance`.`house_bank`(`house_bank_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `manufacturing_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ADD CONSTRAINT `fk_finance_product_cost_estimate_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ADD CONSTRAINT `fk_finance_profitability_segment_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_profitability_segment_id` FOREIGN KEY (`profitability_segment_id`) REFERENCES `manufacturing_ecm`.`finance`.`profitability_segment`(`profitability_segment_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ADD CONSTRAINT `fk_finance_currency_exchange_rate_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ADD CONSTRAINT `fk_finance_statement_version_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ADD CONSTRAINT `fk_finance_statement_version_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ADD CONSTRAINT `fk_finance_period_close_activity_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ADD CONSTRAINT `fk_finance_period_close_activity_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` ADD CONSTRAINT `fk_finance_cash_pool_house_bank_id` FOREIGN KEY (`house_bank_id`) REFERENCES `manufacturing_ecm`.`finance`.`house_bank`(`house_bank_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` ADD CONSTRAINT `fk_finance_ledger_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` ADD CONSTRAINT `fk_finance_ledger_parent_ledger_id` FOREIGN KEY (`parent_ledger_id`) REFERENCES `manufacturing_ecm`.`finance`.`ledger`(`ledger_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`finance` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `manufacturing_ecm`.`finance` SET TAGS ('dbx_domain' = 'finance');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart of Accounts Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_category` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_category` SET TAGS ('dbx_value_regex' = 'balance_sheet|income_statement|cash_flow|statistical');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_group` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Group');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_hierarchy_level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_long_name` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Long Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_name` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_number` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'asset|liability|equity|revenue|expense');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `alternative_account_number` SET TAGS ('dbx_business_glossary_term' = 'Alternative (Local Statutory) Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `alternative_account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `alternative_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `alternative_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `balance_in_local_currency_only` SET TAGS ('dbx_business_glossary_term' = 'Balance in Local Currency Only Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `balance_in_local_currency_only` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `blocked_for_posting` SET TAGS ('dbx_business_glossary_term' = 'Account Blocked for Posting Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `blocked_for_posting` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'capex|opex|not_applicable');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Chart of Accounts (CoA) Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `cogs_indicator` SET TAGS ('dbx_business_glossary_term' = 'Cost of Goods Sold (COGS) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `cogs_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `consolidation_account` SET TAGS ('dbx_business_glossary_term' = 'Group Consolidation Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `consolidation_account` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `consolidation_group` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Group Assignment');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `cost_element_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Element (CO) Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `cost_element_category` SET TAGS ('dbx_value_regex' = 'primary|secondary|not_applicable');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `cost_element_type` SET TAGS ('dbx_business_glossary_term' = 'Cost Element (CO) Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `cost_element_type` SET TAGS ('dbx_value_regex' = 'material_costs|personnel_costs|depreciation|external_services|overhead|revenue|statistical|not_applicable');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Account Creation Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `created_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Account Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `ebitda_line` SET TAGS ('dbx_business_glossary_term' = 'Earnings Before Interest Taxes Depreciation and Amortization (EBITDA) Line Classification');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `ebitda_line` SET TAGS ('dbx_value_regex' = 'revenue|cogs|gross_profit|operating_expense|ebitda|depreciation|amortization|interest|tax|not_applicable');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `field_status_group` SET TAGS ('dbx_business_glossary_term' = 'Field Status Group');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `field_status_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `financial_statement_item` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement (FS) Line Item');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area Classification');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `functional_area` SET TAGS ('dbx_value_regex' = 'manufacturing|sales_and_distribution|research_and_development|general_and_administrative|procurement|logistics|not_assigned');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `gaap_classification` SET TAGS ('dbx_business_glossary_term' = 'Generally Accepted Accounting Principles (GAAP) Classification');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `ifrs_classification` SET TAGS ('dbx_business_glossary_term' = 'International Financial Reporting Standards (IFRS) Classification');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `line_item_display` SET TAGS ('dbx_business_glossary_term' = 'Line Item Display Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `line_item_display` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `normal_balance` SET TAGS ('dbx_business_glossary_term' = 'Normal Balance Side');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `normal_balance` SET TAGS ('dbx_value_regex' = 'debit|credit');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `open_item_management` SET TAGS ('dbx_business_glossary_term' = 'Open Item Management Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `open_item_management` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `posting_without_tax_allowed` SET TAGS ('dbx_business_glossary_term' = 'Posting Without Tax Code Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `posting_without_tax_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `profit_loss_indicator` SET TAGS ('dbx_business_glossary_term' = 'Profit and Loss (P&L) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `profit_loss_indicator` SET TAGS ('dbx_value_regex' = 'profit_and_loss|balance_sheet');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `reconciliation_account_type` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Account Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `reconciliation_account_type` SET TAGS ('dbx_value_regex' = 'accounts_receivable|accounts_payable|fixed_assets|not_reconciliation');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `sort_key` SET TAGS ('dbx_business_glossary_term' = 'Sort Key (Assignment Field)');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `sort_key` SET TAGS ('dbx_value_regex' = '^[0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Account Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending_approval|retired');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `tax_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `tax_category` SET TAGS ('dbx_value_regex' = 'input_tax|output_tax|not_relevant|tax_account');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Account Valid From Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Account Valid To Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `activity_type_active` SET TAGS ('dbx_business_glossary_term' = 'Activity Type Accounting Active Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `activity_type_active` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `allocation_method` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `allocation_method` SET TAGS ('dbx_value_regex' = 'assessment|distribution|indirect_activity_allocation|template_allocation');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `capex_budget_profile` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Budget Profile');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `co_version` SET TAGS ('dbx_business_glossary_term' = 'Controlling (CO) Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `co_version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `company_code_assignment_type` SET TAGS ('dbx_business_glossary_term' = 'Company Code Assignment Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `company_code_assignment_type` SET TAGS ('dbx_value_regex' = '1|2');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `copa_type` SET TAGS ('dbx_business_glossary_term' = 'Profitability Analysis (CO-PA) Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `copa_type` SET TAGS ('dbx_value_regex' = 'costing_based|account_based|both');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `cost_center_standard_hierarchy` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Standard Hierarchy');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `currency_type` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Currency Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `currency_type` SET TAGS ('dbx_value_regex' = '10|20|30|40|50|60');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `language_key` SET TAGS ('dbx_business_glossary_term' = 'Language Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `language_key` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `number_of_posting_periods` SET TAGS ('dbx_business_glossary_term' = 'Number of Posting Periods');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `number_of_posting_periods` SET TAGS ('dbx_value_regex' = '^(12|13|14|16)$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `number_of_special_periods` SET TAGS ('dbx_business_glossary_term' = 'Number of Special Periods');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `number_of_special_periods` SET TAGS ('dbx_value_regex' = '^[0-4]$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `order_management_active` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Management Active Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `order_management_active` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Planning Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `plan_version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `product_cost_controlling_active` SET TAGS ('dbx_business_glossary_term' = 'Product Cost Controlling (CO-PC) Active Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `product_cost_controlling_active` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `profit_center_accounting_active` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Accounting Active Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `profit_center_accounting_active` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `profit_center_standard_hierarchy` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Standard Hierarchy');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `profitability_analysis_active` SET TAGS ('dbx_business_glossary_term' = 'Profitability Analysis (CO-PA) Active Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `profitability_analysis_active` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `settlement_profile` SET TAGS ('dbx_business_glossary_term' = 'Settlement Profile');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|decommissioned');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `transfer_price_variant` SET TAGS ('dbx_business_glossary_term' = 'Transfer Price Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'cross_company|single_company');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`controlling_area` ALTER COLUMN `variance_key` SET TAGS ('dbx_business_glossary_term' = 'Variance Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `prior_period_fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Prior Fiscal Period Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `accounting_standard` SET TAGS ('dbx_business_glossary_term' = 'Accounting Standard');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `accounting_standard` SET TAGS ('dbx_value_regex' = 'IFRS|GAAP|IFRS_GAAP|LOCAL_GAAP|STAT');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `ap_posting_allowed` SET TAGS ('dbx_business_glossary_term' = 'Accounts Payable (AP) Posting Allowed Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `ap_posting_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `ar_posting_allowed` SET TAGS ('dbx_business_glossary_term' = 'Accounts Receivable (AR) Posting Allowed Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `ar_posting_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `asset_posting_allowed` SET TAGS ('dbx_business_glossary_term' = 'Asset Accounting Posting Allowed Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `asset_posting_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `close_completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Period Close Completed Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `close_completed_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `close_initiated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Period Close Initiated Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `close_initiated_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `close_target_date` SET TAGS ('dbx_business_glossary_term' = 'Period Close Target Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `close_target_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Period End Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `gl_posting_allowed` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Posting Allowed Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `gl_posting_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `half_year_number` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Half-Year Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `half_year_number` SET TAGS ('dbx_value_regex' = '^[1-2]$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `is_adjustment_period` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Period Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `is_adjustment_period` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `is_special_period` SET TAGS ('dbx_business_glossary_term' = 'Special Period Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `is_special_period` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `is_year_end_period` SET TAGS ('dbx_business_glossary_term' = 'Year-End Period Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `is_year_end_period` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `ledger_code` SET TAGS ('dbx_business_glossary_term' = 'Accounting Ledger Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `legal_entity_code` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `mm_posting_allowed` SET TAGS ('dbx_business_glossary_term' = 'Materials Management (MM) Posting Allowed Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `mm_posting_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `period_name` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `period_number` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `period_number` SET TAGS ('dbx_value_regex' = '^([1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `period_short_code` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Short Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `period_type` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `period_type` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|special');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `posting_period_variant` SET TAGS ('dbx_business_glossary_term' = 'Posting Period Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `quarter_number` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `quarter_number` SET TAGS ('dbx_value_regex' = '^[1-4]$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `reopen_reason` SET TAGS ('dbx_business_glossary_term' = 'Period Reopen Reason');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `reopen_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Period Reopen Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `reopen_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `reporting_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Reporting Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `reporting_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Period Start Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|closed|blocked|in_closing|reopened|archived');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `tax_period_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Reporting Period Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `tax_period_number` SET TAGS ('dbx_value_regex' = '^([1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `weeks_in_period` SET TAGS ('dbx_business_glossary_term' = 'Weeks in Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `weeks_in_period` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-4][0-9]|5[0-3])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `working_days_count` SET TAGS ('dbx_business_glossary_term' = 'Working Days Count');
ALTER TABLE `manufacturing_ecm`.`finance`.`fiscal_period` ALTER COLUMN `working_days_count` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Posting User ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `ledger_id` SET TAGS ('dbx_business_glossary_term' = 'Ledger ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `ledger_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Group Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_group_currency` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_local_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_local_currency` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_local_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Transaction Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_transaction_currency` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `amount_in_transaction_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `assignment_number` SET TAGS ('dbx_business_glossary_term' = 'Assignment Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `business_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `clearing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_business_glossary_term' = 'Debit/Credit Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_value_regex' = 'S|H');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_header_text` SET TAGS ('dbx_business_glossary_term' = 'Document Header Text');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `document_type_description` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Type Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `entry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Entry Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `entry_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `functional_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,16}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,12}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `line_item_text` SET TAGS ('dbx_business_glossary_term' = 'Line Item Text');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `plant` SET TAGS ('dbx_business_glossary_term' = 'Plant');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `plant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `posting_key` SET TAGS ('dbx_business_glossary_term' = 'Posting Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `posting_key` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `posting_status` SET TAGS ('dbx_business_glossary_term' = 'Posting Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `posting_status` SET TAGS ('dbx_value_regex' = 'posted|reversed|parked|held|cleared|error');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `reversed_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversed Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `reversed_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|INTERFACE|LEGACY');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `tax_amount` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_line_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Line ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Account Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'A|D|K|M|S');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Group Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `amount_transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Transaction Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `amount_transaction_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `assignment` SET TAGS ('dbx_business_glossary_term' = 'Assignment Field');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `business_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `clearing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `clearing_document` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_business_glossary_term' = 'Debit/Credit Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_value_regex' = 'D|C');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `entry_date` SET TAGS ('dbx_business_glossary_term' = 'Entry Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `entry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `functional_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,16}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `gl_account` SET TAGS ('dbx_value_regex' = '^[0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `group_currency` SET TAGS ('dbx_business_glossary_term' = 'Group Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `group_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `ledger_group` SET TAGS ('dbx_business_glossary_term' = 'Ledger Group');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `line_item_number` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Line Item Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `line_item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `line_item_text` SET TAGS ('dbx_business_glossary_term' = 'Line Item Text');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `local_currency` SET TAGS ('dbx_business_glossary_term' = 'Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `local_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `posting_key` SET TAGS ('dbx_business_glossary_term' = 'Posting Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `posting_key` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `special_gl_indicator` SET TAGS ('dbx_business_glossary_term' = 'Special General Ledger (GL) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `special_gl_indicator` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` SET TAGS ('dbx_subdomain' = 'payables_receivables');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` SET TAGS ('dbx_original_name' = 'accounts_payable_invoice');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Payable (AP) Invoice ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `amount_in_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Company Code Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `amount_in_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `baseline_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Baseline Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `baseline_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '[A-Z0-9]{4}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_business_glossary_term' = 'Company Code Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `discount_due_date` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Due Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `discount_due_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `entry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Entry Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `entry_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '0[1-9]|1[0-6]');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = 'd{4}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_currency` SET TAGS ('dbx_business_glossary_term' = 'Invoice Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_currency` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Invoice Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_value_regex' = 'RECEIVED|PARKED|POSTED|APPROVED|BLOCKED|IN_DISPUTE|PARTIALLY_PAID|PAID|CANCELLED|REVERSED');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_value_regex' = 'STANDARD|CREDIT_MEMO|DEBIT_MEMO|RECURRING|PREPAYMENT|INTERCOMPANY|SELF_BILLING');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `payment_block_indicator` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `payment_block_indicator` SET TAGS ('dbx_value_regex' = 'R|A|B|I|V|s');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'ACH|WIRE|CHECK|SEPA|SWIFT|VIRTUAL_CARD|OTHER');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `purchasing_org` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL|EDI|OCR');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_business_glossary_term' = 'Three-Way Match Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_value_regex' = 'MATCHED|PARTIALLY_MATCHED|UNMATCHED|EXCEPTION|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `vendor_account_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `vendor_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `vendor_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ALTER COLUMN `withholding_tax_code` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` SET TAGS ('dbx_subdomain' = 'payables_receivables');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` SET TAGS ('dbx_original_name' = 'accounts_receivable_invoice');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Receivable (AR) Invoice ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_business_glossary_term' = 'Invoice Amount in Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `billing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `billing_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `clearing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `clearing_status` SET TAGS ('dbx_business_glossary_term' = 'Clearing Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `clearing_status` SET TAGS ('dbx_value_regex' = 'open|partially_cleared|fully_cleared|written_off');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Invoice Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Discount Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dispute_indicator` SET TAGS ('dbx_business_glossary_term' = 'Dispute Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dispute_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dispute_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dispute_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Due Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dunning_block` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dunning_block` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dunning Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dunning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `dunning_level` SET TAGS ('dbx_value_regex' = '^[0-9]$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = '^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_value_regex' = 'standard|credit_memo|debit_memo|pro_forma|intercompany|down_payment|cancellation');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `open_amount` SET TAGS ('dbx_business_glossary_term' = 'Open (Outstanding) Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `open_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Payer Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payment_block` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payment_block` SET TAGS ('dbx_value_regex' = '^[A-Z ]?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `payment_terms_description` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `revenue_recognition_status` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `revenue_recognition_status` SET TAGS ('dbx_value_regex' = 'pending|recognized|deferred|partially_recognized|reversed');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|cancelled|reversed|on_hold');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` SET TAGS ('dbx_subdomain' = 'treasury_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `run_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `run_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Payment Amount (Transaction Currency)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount` SET TAGS ('dbx_value_regex' = '^-?d{1,18}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Payment Amount (Group Currency)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_value_regex' = '^-?d{1,18}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_local` SET TAGS ('dbx_business_glossary_term' = 'Payment Amount (Local Currency)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_local` SET TAGS ('dbx_value_regex' = '^-?d{1,18}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_local` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `amount_local` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `block` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `block` SET TAGS ('dbx_value_regex' = '^[A-Z0-9 ]{0,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `business_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `clearing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `direction` SET TAGS ('dbx_business_glossary_term' = 'Payment Direction');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `direction` SET TAGS ('dbx_value_regex' = 'outgoing|incoming');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_value_regex' = '^-?d{1,18}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_value_regex' = '^d{1,9}(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(1[0-6]|[1-9])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `gl_account` SET TAGS ('dbx_value_regex' = '^[0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `house_bank` SET TAGS ('dbx_business_glossary_term' = 'House Bank');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `house_bank` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `is_reversed` SET TAGS ('dbx_business_glossary_term' = 'Payment Reversal Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `is_reversed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'bank_transfer|check|ach|sepa|wire|direct_debit|other');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `method_supplement` SET TAGS ('dbx_business_glossary_term' = 'Payment Method Supplement');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9/-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `reversal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'proposed|approved|in_process|posted|cleared|reversed|rejected|on_hold');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Payment Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'ap_payment|ar_receipt|intercompany|employee_expense|tax_payment|other');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_value_regex' = '^-?d{1,18}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` SET TAGS ('dbx_subdomain' = 'treasury_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Account ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `cash_pool_id` SET TAGS ('dbx_business_glossary_term' = 'Cash Pool Identifier (ID)');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'House Bank Account Identifier (ID)');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `house_bank_id` SET TAGS ('dbx_business_glossary_term' = 'House Bank Identifier (ID)');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `house_bank_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_close_date` SET TAGS ('dbx_business_glossary_term' = 'Account Close Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_close_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_currency` SET TAGS ('dbx_business_glossary_term' = 'Account Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,34}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_open_date` SET TAGS ('dbx_business_glossary_term' = 'Account Open Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_open_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_purpose` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Purpose');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_purpose` SET TAGS ('dbx_value_regex' = 'operating|payroll|tax|intercompany|vendor_payment|customer_collection|petty_cash|investment|escrow|regulatory_reserve');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'current|savings|deposit|payroll|escrow|zero_balance|notional_pooling|overdraft');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `authorized_signatory_1` SET TAGS ('dbx_business_glossary_term' = 'Authorized Signatory 1');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `authorized_signatory_1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `authorized_signatory_2` SET TAGS ('dbx_business_glossary_term' = 'Authorized Signatory 2');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `authorized_signatory_2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_branch_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Branch Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_city` SET TAGS ('dbx_business_glossary_term' = 'Bank City');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Bank Relationship Contact Email');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Relationship Contact Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_country` SET TAGS ('dbx_business_glossary_term' = 'Bank Country');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_key` SET TAGS ('dbx_business_glossary_term' = 'Bank Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_routing_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Routing Number (ABA)');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_routing_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_routing_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_routing_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_statement_format` SET TAGS ('dbx_business_glossary_term' = 'Bank Statement Format');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_statement_format` SET TAGS ('dbx_value_regex' = 'MT940|CAMT053|BAI2|OFX|CSV|MANUAL');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `blocked_reason` SET TAGS ('dbx_business_glossary_term' = 'Account Blocked Reason');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `blocked_reason` SET TAGS ('dbx_value_regex' = 'regulatory_hold|fraud_investigation|dormancy|signatory_change|audit_hold|bank_request|other');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `cash_pool_role` SET TAGS ('dbx_business_glossary_term' = 'Cash Pool Role');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `cash_pool_role` SET TAGS ('dbx_value_regex' = 'header|participant|not_applicable');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `electronic_banking_enabled` SET TAGS ('dbx_business_glossary_term' = 'Electronic Banking Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `electronic_banking_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `iban` SET TAGS ('dbx_business_glossary_term' = 'International Bank Account Number (IBAN)');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `iban` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `iban` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `iban` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Account Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `last_reconciliation_date` SET TAGS ('dbx_business_glossary_term' = 'Last Bank Reconciliation Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `last_reconciliation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `overdraft_limit` SET TAGS ('dbx_business_glossary_term' = 'Overdraft Limit');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `overdraft_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `payment_method_allowed` SET TAGS ('dbx_business_glossary_term' = 'Payment Method Allowed');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `payroll_account_flag` SET TAGS ('dbx_business_glossary_term' = 'Payroll Account Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `payroll_account_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `signing_authority_type` SET TAGS ('dbx_business_glossary_term' = 'Signing Authority Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `signing_authority_type` SET TAGS ('dbx_value_regex' = 'single|dual|board_resolution|power_of_attorney');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `sort_code` SET TAGS ('dbx_business_glossary_term' = 'Bank Sort Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `sort_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending_closure|closed|under_review');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `swift_bic_code` SET TAGS ('dbx_business_glossary_term' = 'SWIFT/BIC Code (Society for Worldwide Interbank Financial Telecommunication / Bank Identifier Code)');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `swift_bic_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` SET TAGS ('dbx_subdomain' = 'asset_management');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `asset_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Transaction ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `asset_register_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Register Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `it_asset_id` SET TAGS ('dbx_business_glossary_term' = 'It Asset Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_business_glossary_term' = 'Accumulated Depreciation');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `accumulated_depreciation` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Group Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Class Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `asset_class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `asset_value_date` SET TAGS ('dbx_business_glossary_term' = 'Asset Value Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `asset_value_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure / Operational Expenditure (CAPEX/OPEX) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `depreciation_area` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `depreciation_area` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `depreciation_key` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `depreciation_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Financial Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^([1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `gl_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `group_currency` SET TAGS ('dbx_business_glossary_term' = 'Group Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `group_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `local_currency` SET TAGS ('dbx_business_glossary_term' = 'Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `local_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `net_book_value_after` SET TAGS ('dbx_business_glossary_term' = 'Net Book Value After Transaction');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `net_book_value_after` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `net_book_value_before` SET TAGS ('dbx_business_glossary_term' = 'Net Book Value Before Transaction');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `net_book_value_before` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `posting_status` SET TAGS ('dbx_business_glossary_term' = 'Posting Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `posting_status` SET TAGS ('dbx_value_regex' = 'posted|reversed|parked|blocked|cleared');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `remaining_useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Remaining Useful Life (Years)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_amount` SET TAGS ('dbx_business_glossary_term' = 'Transaction Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_text` SET TAGS ('dbx_business_glossary_term' = 'Transaction Text');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_type_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Transaction Type Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_type_category` SET TAGS ('dbx_value_regex' = 'acquisition|retirement|transfer|write_down|write_up|depreciation|amortization|impairment|revaluation|capitalization|partial_retirement|scrapping');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_type_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Transaction Type Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `transaction_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life (Years)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount in Group Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount in Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `amount_local_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Approval Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Budget Approval Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|rejected|withdrawn|locked');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `availability_control_active` SET TAGS ('dbx_business_glossary_term' = 'Budget Availability Control Active Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `availability_control_active` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Budget Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'annual|multi_year|supplemental|contingency|rolling_forecast');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `commitment_amount` SET TAGS ('dbx_business_glossary_term' = 'Commitment Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `commitment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `distribution_key` SET TAGS ('dbx_business_glossary_term' = 'Budget Distribution Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `distribution_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Budget End Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(1[0-6]|[1-9])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `functional_area` SET TAGS ('dbx_value_regex' = 'production|sales|administration|research_development|procurement|logistics|quality|maintenance|finance|it');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Budget Notes');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Budget Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^BDG-[0-9]{4}-[A-Z0-9]{6,12}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `plan_version_number` SET TAGS ('dbx_business_glossary_term' = 'Plan Version Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `plan_version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `planning_method` SET TAGS ('dbx_business_glossary_term' = 'Budget Planning Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `planning_method` SET TAGS ('dbx_value_regex' = 'top_down|bottom_up|zero_based|activity_based|incremental|rolling');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|POWER_BI|MANUAL|ARIBA|EXTERNAL');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Start Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Submission Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `submitted_by` SET TAGS ('dbx_business_glossary_term' = 'Submitted By');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `tolerance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Budget Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Budget Type (CAPEX/OPEX)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX|revenue|headcount|project');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Budget Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = 'original|revised|forecast|final|preliminary');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ALTER COLUMN `wbs_element` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{1,24}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `budget_line_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Line ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Header ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `it_budget_id` SET TAGS ('dbx_business_glossary_term' = 'It Budget Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `objective_id` SET TAGS ('dbx_business_glossary_term' = 'Hse Objective Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Territory Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `budget_type` SET TAGS ('dbx_business_glossary_term' = 'Budget Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `budget_type` SET TAGS ('dbx_value_regex' = 'original|revised|supplemental|rolling_forecast|zero_based');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure / Operational Expenditure (CAPEX/OPEX) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `cost_element` SET TAGS ('dbx_business_glossary_term' = 'Cost Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `cost_element` SET TAGS ('dbx_value_regex' = '^[0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `cost_element_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `cost_element_category` SET TAGS ('dbx_value_regex' = 'primary_costs|secondary_costs|revenue|statistical');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `cost_element_name` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `distribution_key` SET TAGS ('dbx_business_glossary_term' = 'Distribution Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `distribution_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(1[0-6]|[1-9])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `functional_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,16}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `local_currency` SET TAGS ('dbx_business_glossary_term' = 'Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `local_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `plan_version` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `plan_version_description` SET TAGS ('dbx_business_glossary_term' = 'Plan Version Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `planned_amount` SET TAGS ('dbx_business_glossary_term' = 'Planned Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `planned_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `planned_amount_currency` SET TAGS ('dbx_business_glossary_term' = 'Planned Amount Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `planned_amount_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `planned_amount_local` SET TAGS ('dbx_business_glossary_term' = 'Planned Amount Local Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `planned_amount_local` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_business_glossary_term' = 'Planned Quantity');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Segment');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|EXCEL_UPLOAD|POWER_BI|OTHER');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|rejected|locked|archived');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `run_id` SET TAGS ('dbx_business_glossary_term' = 'Allocation Cycle Run ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `internal_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Receiver Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Receiver Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Sender Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount_controlling_currency` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount in Controlling Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocated_amount_controlling_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_basis_quantity` SET TAGS ('dbx_business_glossary_term' = 'Allocation Basis Quantity');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_basis_unit` SET TAGS ('dbx_business_glossary_term' = 'Allocation Basis Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_document_number` SET TAGS ('dbx_business_glossary_term' = 'Allocation Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_business_glossary_term' = 'Allocation Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_value_regex' = 'percentage|equivalence_numbers|statistical_key_figure|fixed_amount|activity_quantity|plan_values');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_value_regex' = 'distribution|assessment|reposting|overhead_calculation|activity_allocation|template_allocation');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure / Operational Expenditure (CAPEX/OPEX) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `cycle_name` SET TAGS ('dbx_business_glossary_term' = 'Allocation Cycle Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(1[0-6]|[1-9])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `functional_area` SET TAGS ('dbx_business_glossary_term' = 'Functional Area');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `original_document_number` SET TAGS ('dbx_business_glossary_term' = 'Original Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `plan_actual_indicator` SET TAGS ('dbx_business_glossary_term' = 'Plan/Actual Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `plan_actual_indicator` SET TAGS ('dbx_value_regex' = 'plan|actual|commitment');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `receiver_cost_center` SET TAGS ('dbx_business_glossary_term' = 'Receiver Cost Center');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `receiver_wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Receiver Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `secondary_cost_element` SET TAGS ('dbx_business_glossary_term' = 'Secondary Cost Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Segment');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `sender_cost_element` SET TAGS ('dbx_business_glossary_term' = 'Sender Cost Element');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `sender_cost_element_group` SET TAGS ('dbx_business_glossary_term' = 'Sender Cost Element Group');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `statistical_key_figure` SET TAGS ('dbx_business_glossary_term' = 'Statistical Key Figure (SKF)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Controlling Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `product_cost_estimate_id` SET TAGS ('dbx_business_glossary_term' = 'Product Cost Estimate ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `version_id` SET TAGS ('dbx_business_glossary_term' = 'Production Version Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `base_quantity` SET TAGS ('dbx_business_glossary_term' = 'Base Quantity');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `base_quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Base Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `bom_alternative` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Alternative');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `bom_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_date` SET TAGS ('dbx_business_glossary_term' = 'Costing Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_run_number` SET TAGS ('dbx_business_glossary_term' = 'Costing Run Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_status` SET TAGS ('dbx_business_glossary_term' = 'Costing Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_status` SET TAGS ('dbx_value_regex' = 'created|in_process|completed|error|marked|released|cancelled');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_type` SET TAGS ('dbx_business_glossary_term' = 'Costing Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_type` SET TAGS ('dbx_value_regex' = 'standard|modified_standard|inventory_cost|sales_order|simulation|actual');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_variant` SET TAGS ('dbx_business_glossary_term' = 'Costing Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `costing_version` SET TAGS ('dbx_business_glossary_term' = 'Costing Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `error_indicator` SET TAGS ('dbx_business_glossary_term' = 'Error Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `error_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `group_currency_cost` SET TAGS ('dbx_business_glossary_term' = 'Group Currency Total Standard Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `group_currency_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `labor_cost` SET TAGS ('dbx_business_glossary_term' = 'Labor Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `labor_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `lot_size` SET TAGS ('dbx_business_glossary_term' = 'Lot Size');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `lot_size_unit` SET TAGS ('dbx_business_glossary_term' = 'Lot Size Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `machine_cost` SET TAGS ('dbx_business_glossary_term' = 'Machine Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `machine_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `make_buy_indicator` SET TAGS ('dbx_business_glossary_term' = 'Make/Buy Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `make_buy_indicator` SET TAGS ('dbx_value_regex' = 'make_to_stock|make_to_order|engineer_to_order|assemble_to_order|buy');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `material_cost` SET TAGS ('dbx_business_glossary_term' = 'Material Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `material_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `overhead_cost` SET TAGS ('dbx_business_glossary_term' = 'Overhead Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `overhead_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `overhead_key` SET TAGS ('dbx_business_glossary_term' = 'Overhead Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `price_control_indicator` SET TAGS ('dbx_business_glossary_term' = 'Price Control Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `price_control_indicator` SET TAGS ('dbx_value_regex' = 'S|V');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Product Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `release_date` SET TAGS ('dbx_business_glossary_term' = 'Release Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `routing_alternative` SET TAGS ('dbx_business_glossary_term' = 'Routing Alternative');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `routing_number` SET TAGS ('dbx_business_glossary_term' = 'Routing Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `routing_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `routing_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `subcontracting_cost` SET TAGS ('dbx_business_glossary_term' = 'Subcontracting Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `subcontracting_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `total_standard_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Standard Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `total_standard_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `production_order_cost_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Cost ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `bop_id` SET TAGS ('dbx_business_glossary_term' = 'Bop Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `scrap_rework_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Scrap Rework Transaction Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_labor_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Labor Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_labor_cost` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_labor_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_machine_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Machine Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_machine_cost` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_machine_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_material_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Material Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_material_cost` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_material_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_overhead_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Overhead Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_overhead_cost` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_overhead_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_total_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Total Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_total_cost` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `actual_total_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_business_glossary_term' = 'Company Code Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Production Quantity');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `costing_variant` SET TAGS ('dbx_business_glossary_term' = 'Costing Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `costing_variant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_value_regex' = '^d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Finished Good Material Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Finished Good Material Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_currency` SET TAGS ('dbx_business_glossary_term' = 'Order Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_finish_date` SET TAGS ('dbx_business_glossary_term' = 'Production Order Finish Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_finish_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Production Order Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Production Order Quantity');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Production Order Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_quantity_unit` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_start_date` SET TAGS ('dbx_business_glossary_term' = 'Production Order Start Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Production Order Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'CREATED|RELEASED|PARTIALLY_CONFIRMED|CONFIRMED|TECHNICALLY_COMPLETE|CLOSED|DELETED');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Production Order Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'PP01|PP02|PP03|PP04|PI01|PI02|REM|PM01|PM02');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `planned_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Planned Cost Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `planned_cost_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `planned_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `rework_cost` SET TAGS ('dbx_business_glossary_term' = 'Rework Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `rework_cost` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `rework_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `scrap_cost` SET TAGS ('dbx_business_glossary_term' = 'Scrap Cost');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `scrap_cost` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `scrap_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Cost Settlement Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `settlement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Cost Settlement Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'NOT_SETTLED|PARTIALLY_SETTLED|FULLY_SETTLED|SETTLEMENT_BLOCKED');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|OPCENTER_MES|MANUAL');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `technical_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Technical Completion Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `technical_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Variance Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `variance_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `variance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `variance_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Variance Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `variance_category` SET TAGS ('dbx_value_regex' = 'PRICE|QUANTITY|RESOURCE_USAGE|SCRAP|LOT_SIZE|REMAINING|MIXED_PRICE|INPUT_PRICE|INPUT_QUANTITY|OUTPUT_PRICE|OUTPUT_QUANTITY');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `variance_key` SET TAGS ('dbx_business_glossary_term' = 'Variance Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `variance_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `wip_value` SET TAGS ('dbx_business_glossary_term' = 'Work In Progress (WIP) Value');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `wip_value` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ALTER COLUMN `wip_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `profitability_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Product Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `business_area_code` SET TAGS ('dbx_business_glossary_term' = 'Business Area Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `business_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure / Operational Expenditure (CAPEX/OPEX) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX|MIXED|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `cogs_relevant_flag` SET TAGS ('dbx_business_glossary_term' = 'Cost of Goods Sold (COGS) Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `cogs_relevant_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `contribution_margin_level` SET TAGS ('dbx_business_glossary_term' = 'Contribution Margin Level');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `contribution_margin_level` SET TAGS ('dbx_value_regex' = 'CM1|CM2|CM3|CM4|EBITDA');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `copa_type` SET TAGS ('dbx_business_glossary_term' = 'Profitability Analysis (CO-PA) Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `copa_type` SET TAGS ('dbx_value_regex' = 'costing_based|account_based');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Segment Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Group Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Area Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `functional_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,16}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `ifrs8_reportable_segment_flag` SET TAGS ('dbx_business_glossary_term' = 'IFRS 8 Reportable Segment Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `ifrs8_reportable_segment_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `industry_code` SET TAGS ('dbx_business_glossary_term' = 'Industry Sector Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `industry_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `parent_segment_code` SET TAGS ('dbx_business_glossary_term' = 'Parent Segment Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `parent_segment_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `plan_version` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `product_group_code` SET TAGS ('dbx_business_glossary_term' = 'Product Group Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `product_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,18}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `product_hierarchy_code` SET TAGS ('dbx_business_glossary_term' = 'Product Hierarchy Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `product_hierarchy_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,18}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `reporting_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Reporting Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `reporting_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `segment_code` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `segment_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `segment_hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Segment Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `segment_hierarchy_level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `segment_name` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `segment_type` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `segment_type` SET TAGS ('dbx_value_regex' = 'product_line|customer_segment|geography|sales_channel|business_area|combined');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|under_review');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `transfer_price_indicator` SET TAGS ('dbx_business_glossary_term' = 'Transfer Price Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `transfer_price_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` SET TAGS ('dbx_subdomain' = 'cost_controlling');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `copa_posting_id` SET TAGS ('dbx_business_glossary_term' = 'Profitability Analysis (CO-PA) Posting ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `profitability_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `team_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Team Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `billing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `capex_opex_indicator` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX|N/A');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `contribution_margin_level` SET TAGS ('dbx_business_glossary_term' = 'Contribution Margin Level');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `contribution_margin_level` SET TAGS ('dbx_value_regex' = 'cm1|cm2|cm3|cm4|ebitda|ebit|net_income');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `customer_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Document Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^([1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `group_currency` SET TAGS ('dbx_business_glossary_term' = 'Group Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `group_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `line_item_number` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Line Item Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `local_currency` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `local_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number (SKU)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `posting_type` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Posting Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `posting_type` SET TAGS ('dbx_value_regex' = 'actual|plan|budget|forecast|statistical');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `product_hierarchy_code` SET TAGS ('dbx_business_glossary_term' = 'Product Hierarchy Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Quantity Field');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `record_type` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Record Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `record_type` SET TAGS ('dbx_value_regex' = 'F|B|C|E|G|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `sales_org_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_amount` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Value Field Amount (Transaction Currency)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_amount_group` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Value Field Amount (Group Currency)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_amount_group` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_amount_local` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Value Field Amount (Local Currency)');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_amount_local` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_category` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Value Field Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_category` SET TAGS ('dbx_value_regex' = 'gross_revenue|sales_deduction|net_revenue|cogs|manufacturing_variance|overhead_allocation|price_variance|quantity_variance|mix_variance|other_variance|freight|rebate|commission|royalty');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `value_field_name` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Value Field Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'CO-PA Plan Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` SET TAGS ('dbx_subdomain' = 'payables_receivables');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `intercompany_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Sending Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Sending Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Amount in Group Currency');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `amount_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `country_by_country_flag` SET TAGS ('dbx_business_glossary_term' = 'Country-by-Country Reporting (CbCR) Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `country_by_country_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Source Document Reference');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `elimination_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Elimination Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `elimination_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `elimination_status` SET TAGS ('dbx_business_glossary_term' = 'Elimination Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `elimination_status` SET TAGS ('dbx_value_regex' = 'pending|eliminated|partially_eliminated|not_applicable|disputed');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_value_regex' = 'spot|average|closing|budget|standard');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(1[0-6]|[1-9])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `gl_account_receiving` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account - Receiving Entity');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Transaction Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `group_currency` SET TAGS ('dbx_business_glossary_term' = 'Group Reporting Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `group_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `intercompany_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Agreement Reference');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `markup_percentage` SET TAGS ('dbx_business_glossary_term' = 'Transfer Price Markup Percentage');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `markup_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Transaction Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'unpaid|partially_paid|paid|overdue|netted|waived');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `receiving_country_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Entity Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `receiving_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `receiving_entity_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Legal Entity Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `reconciliation_date` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `reconciliation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Reconciliation Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'unreconciled|in_progress|reconciled|disputed|approved|rejected');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `reversed_transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Reversed Transaction Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `sending_country_code` SET TAGS ('dbx_business_glossary_term' = 'Sending Entity Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `sending_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|LEGACY|OTHER');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|posted|approved|reversed|cancelled|under_review');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_date` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_value_regex' = '^ICT-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'intercompany_sale|intercompany_purchase|cost_recharge|management_fee|intercompany_loan|dividend_payment|royalty|service_charge|capital_contribution|netting');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transfer_price` SET TAGS ('dbx_business_glossary_term' = 'Transfer Price');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transfer_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transfer_pricing_method` SET TAGS ('dbx_business_glossary_term' = 'Transfer Pricing Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ALTER COLUMN `transfer_pricing_method` SET TAGS ('dbx_value_regex' = 'comparable_uncontrolled_price|resale_price|cost_plus|transactional_net_margin|profit_split|other');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `currency_exchange_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Approval Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|auto_approved');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `averaging_method` SET TAGS ('dbx_business_glossary_term' = 'Rate Averaging Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `averaging_method` SET TAGS ('dbx_value_regex' = 'simple_average|weighted_average|daily_average|monthly_average|not_applicable');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `consolidation_relevant` SET TAGS ('dbx_business_glossary_term' = 'Group Consolidation Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `consolidation_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `currency_pair` SET TAGS ('dbx_business_glossary_term' = 'Currency Pair');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `currency_pair` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}/[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Value');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `from_currency_code` SET TAGS ('dbx_business_glossary_term' = 'From Currency Code (ISO 4217)');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `from_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `inverse_rate` SET TAGS ('dbx_business_glossary_term' = 'Inverse Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `inverse_rate` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `is_triangulation_rate` SET TAGS ('dbx_business_glossary_term' = 'Triangulation Rate Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `is_triangulation_rate` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `quotation_method` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Quotation Method');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `quotation_method` SET TAGS ('dbx_value_regex' = 'direct|indirect');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_category` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_category` SET TAGS ('dbx_value_regex' = 'mid|buying|selling|official|parallel');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_key` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Natural Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_key` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}_[A-Z]{3}_[A-Z0-9_]+_[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_ratio_from` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Ratio From-Currency Units');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_ratio_from` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_ratio_to` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Ratio To-Currency Units');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_ratio_to` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_source` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Source');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_source` SET TAGS ('dbx_value_regex' = 'ECB|Reuters|Bloomberg|internal|central_bank|manual|IMF|World_Bank|bank_feed');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_source_reference` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Source Reference');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_type` SET TAGS ('dbx_value_regex' = 'spot|average|closing|budget|historical|intercompany|hedge');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_type_code` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `rate_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `revaluation_relevant` SET TAGS ('dbx_business_glossary_term' = 'Foreign Currency Revaluation Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `revaluation_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Reuters|Bloomberg|ECB|manual|treasury_system|intercompany');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Record Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `spread_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Spread');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `spread_rate` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|superseded|pending_approval|approved|rejected');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `to_currency_code` SET TAGS ('dbx_business_glossary_term' = 'To Currency Code (ISO 4217)');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `to_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `triangulation_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Triangulation Currency Code (ISO 4217)');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `triangulation_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Valid From Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Valid To Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Payable Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `eu_tax_flag` SET TAGS ('dbx_business_glossary_term' = 'European Union (EU) Tax Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `eu_tax_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `gl_account_tax_receivable` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account for Tax Receivable');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `gl_account_tax_receivable` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `minimum_tax_base_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Tax Base Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `non_deductible_percentage` SET TAGS ('dbx_business_glossary_term' = 'Non-Deductible Tax Percentage');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `non_deductible_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `plant_applicability` SET TAGS ('dbx_business_glossary_term' = 'Plant Applicability Scope');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `plant_applicability` SET TAGS ('dbx_value_regex' = 'all_plants|specific_plant|plant_country');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `posting_indicator` SET TAGS ('dbx_business_glossary_term' = 'Tax Posting Indicator');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `posting_indicator` SET TAGS ('dbx_value_regex' = 'post_separately|distribute_to_expense|not_posted');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `purchasing_tax_code_flag` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Tax Code Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `purchasing_tax_code_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region / State Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `reporting_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Reporting Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `reporting_category` SET TAGS ('dbx_value_regex' = 'vat_return|withholding_tax_return|sales_tax_return|intrastat|ec_sales_list|annual_tax_return|other');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `reverse_charge_flag` SET TAGS ('dbx_business_glossary_term' = 'Reverse Charge Mechanism Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `reverse_charge_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `sales_tax_code_flag` SET TAGS ('dbx_business_glossary_term' = 'Sales Tax Code Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `sales_tax_code_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|superseded');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Tax Authority Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_base_amount_type` SET TAGS ('dbx_business_glossary_term' = 'Tax Base Amount Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_base_amount_type` SET TAGS ('dbx_value_regex' = 'net_amount|gross_amount|tax_on_tax|fixed_amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_category` SET TAGS ('dbx_value_regex' = 'standard_rate|reduced_rate|zero_rate|exempt|non_taxable|reverse_charge|mixed');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_exemption_reason` SET TAGS ('dbx_business_glossary_term' = 'Tax Exemption Reason');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_group` SET TAGS ('dbx_business_glossary_term' = 'Tax Group');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Procedure Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_rate_change_reason` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate Change Reason');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_rate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_rate_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_return_box_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Return Box Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_type` SET TAGS ('dbx_business_glossary_term' = 'Tax Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `tax_type` SET TAGS ('dbx_value_regex' = 'input_vat|output_vat|withholding_tax|sales_tax|use_tax|excise_tax|customs_duty|goods_services_tax|service_tax|other');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `transaction_direction` SET TAGS ('dbx_business_glossary_term' = 'Transaction Direction');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `transaction_direction` SET TAGS ('dbx_value_regex' = 'purchase|sale|both');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `withholding_tax_type` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax (WHT) Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ALTER COLUMN `withholding_tax_type` SET TAGS ('dbx_value_regex' = 'invoice|payment|both|not_applicable');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` SET TAGS ('dbx_original_name' = 'financial_statement_version');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `statement_version_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Version Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `capex_opex_split_flag` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Split Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `capex_opex_split_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `cogs_line_item_flag` SET TAGS ('dbx_business_glossary_term' = 'Cost of Goods Sold (COGS) Line Item Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `cogs_line_item_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `consolidation_chart_of_accounts` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Chart of Accounts Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `consolidation_chart_of_accounts` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Reporting Currency Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `ebitda_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'Earnings Before Interest Taxes Depreciation and Amortization (EBITDA) Reporting Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `ebitda_reporting_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `fsv_code` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Version (FSV) Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `fsv_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `fsv_long_name` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Version (FSV) Long Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `fsv_name` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Version (FSV) Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `group_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'Group Reporting Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `group_reporting_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `hierarchy_structure` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Structure Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `hierarchy_structure` SET TAGS ('dbx_value_regex' = 'FLAT|HIERARCHICAL|MULTI_LEVEL');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `intercompany_elimination_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Elimination Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `intercompany_elimination_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `language_key` SET TAGS ('dbx_business_glossary_term' = 'Language Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `language_key` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `ledger_code` SET TAGS ('dbx_business_glossary_term' = 'Ledger Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `ledger_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `management_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'Management Reporting Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `management_reporting_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `max_hierarchy_levels` SET TAGS ('dbx_business_glossary_term' = 'Maximum Hierarchy Levels');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `max_hierarchy_levels` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]?$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `regulatory_filing_format` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Format');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `regulatory_filing_format` SET TAGS ('dbx_value_regex' = 'XBRL|iXBRL|PDF|XML|CSV|PAPER|EDGAR|ESMA|NONE');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `reporting_standard` SET TAGS ('dbx_business_glossary_term' = 'Reporting Standard');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `reporting_standard` SET TAGS ('dbx_value_regex' = 'IFRS|US_GAAP|LOCAL_GAAP|IFRS_FOR_SME|STATUTORY|MANAGEMENT');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `segment_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'Segment Reporting Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `segment_reporting_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|LEGACY|OTHER');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `statement_type` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `statement_type` SET TAGS ('dbx_value_regex' = 'BALANCE_SHEET|INCOME_STATEMENT|CASH_FLOW|EQUITY_CHANGES|NOTES|COMPREHENSIVE_INCOME|COMBINED');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Financial Statement Version Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'ACTIVE|INACTIVE|DRAFT|UNDER_REVIEW|DEPRECATED|ARCHIVED');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `statutory_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'Statutory Reporting Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `statutory_reporting_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `tax_reporting_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Reporting Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `tax_reporting_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `version_description` SET TAGS ('dbx_business_glossary_term' = 'Version Description');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ALTER COLUMN `xbrl_taxonomy_version` SET TAGS ('dbx_business_glossary_term' = 'eXtensible Business Reporting Language (XBRL) Taxonomy Version');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `period_close_activity_id` SET TAGS ('dbx_business_glossary_term' = 'Period Close Activity ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible User ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `signoff_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Sign-Off Approver User ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `accounting_standard` SET TAGS ('dbx_business_glossary_term' = 'Accounting Standard');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `accounting_standard` SET TAGS ('dbx_value_regex' = 'IFRS|GAAP|LOCAL_GAAP|IFRS_AND_GAAP');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `activity_code` SET TAGS ('dbx_business_glossary_term' = 'Close Activity Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `activity_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `activity_name` SET TAGS ('dbx_business_glossary_term' = 'Close Activity Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `activity_type` SET TAGS ('dbx_business_glossary_term' = 'Close Activity Type');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `activity_type` SET TAGS ('dbx_value_regex' = 'depreciation_run|grir_clearing|foreign_currency_revaluation|cost_allocation_cycle|profit_center_distribution|balance_carryforward|accrual_posting|intercompany_elimination|tax_calculation|inventory_valuation|asset_capitalization|provisions_posting|...');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `actual_completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `actual_completion_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `close_category` SET TAGS ('dbx_business_glossary_term' = 'Financial Close Category');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `close_category` SET TAGS ('dbx_value_regex' = 'period_end|quarter_end|year_end|special_period');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `dependency_activity_code` SET TAGS ('dbx_business_glossary_term' = 'Predecessor Activity Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `dependency_activity_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `due_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Close Activity Due Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `due_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `error_log_reference` SET TAGS ('dbx_business_glossary_term' = 'Error Log Reference');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `error_message` SET TAGS ('dbx_business_glossary_term' = 'Error Message');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `execution_mode` SET TAGS ('dbx_business_glossary_term' = 'Execution Mode');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `execution_mode` SET TAGS ('dbx_value_regex' = 'automatic|manual|semi_automatic');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `execution_status` SET TAGS ('dbx_business_glossary_term' = 'Execution Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `execution_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|completed_with_errors|failed|skipped|cancelled|on_hold|pending_approval');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(1[0-6]|[1-9])$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Activity Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `is_period_locked` SET TAGS ('dbx_business_glossary_term' = 'Period Locked Flag');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `is_period_locked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `ledger_code` SET TAGS ('dbx_business_glossary_term' = 'Accounting Ledger Code');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `ledger_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Close Activity Notes');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Close Activity Priority');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `responsible_team` SET TAGS ('dbx_business_glossary_term' = 'Responsible Finance Team');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `responsible_user_name` SET TAGS ('dbx_business_glossary_term' = 'Responsible User Full Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `responsible_user_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `responsible_user_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `retry_count` SET TAGS ('dbx_business_glossary_term' = 'Retry Count');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `retry_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Accounting Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `sap_job_name` SET TAGS ('dbx_business_glossary_term' = 'SAP Background Job Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `sap_program_name` SET TAGS ('dbx_business_glossary_term' = 'SAP Program / Transaction Name');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Close Activity Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Close Activity Sequence Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `sequence_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `signoff_comments` SET TAGS ('dbx_business_glossary_term' = 'Sign-Off Approver Comments');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `signoff_status` SET TAGS ('dbx_business_glossary_term' = 'Sign-Off Approval Status');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `signoff_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|not_required');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `signoff_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Sign-Off Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `signoff_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`finance`.`house_bank` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`house_bank` SET TAGS ('dbx_subdomain' = 'treasury_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`house_bank` ALTER COLUMN `house_bank_id` SET TAGS ('dbx_business_glossary_term' = 'House Bank Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`house_bank` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`house_bank` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`house_bank` ALTER COLUMN `iban` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`house_bank` ALTER COLUMN `iban` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` SET TAGS ('dbx_subdomain' = 'treasury_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` ALTER COLUMN `cash_pool_id` SET TAGS ('dbx_business_glossary_term' = 'Cash Pool Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` ALTER COLUMN `house_bank_id` SET TAGS ('dbx_business_glossary_term' = 'Lead House Bank Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` ALTER COLUMN `lead_bank_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` ALTER COLUMN `ledger_id` SET TAGS ('dbx_business_glossary_term' = 'Ledger Identifier');
