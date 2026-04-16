-- Schema for Domain: finance | Business:  | Version: v1_mvm
-- Generated on: 2026-04-16 09:51:30

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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`journal_entry` (
    `journal_entry_id` BIGINT COMMENT 'Unique surrogate identifier for each journal entry record in the silver layer lakehouse. Serves as the primary key for the journal_entry data product.',
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: journal_entry.gl_account_number is a denormalized STRING reference to the authoritative chart_of_accounts master. Adding chart_of_accounts_id FK normalizes this relationship, enabling JOIN to retrieve',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: journal_entry.controlling_area (STRING) is a denormalized reference to the controlling_area master. Adding controlling_area_id FK normalizes this organizational scoping relationship for management acc',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: journal_entry uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master, enabling period-s',
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
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: journal_entry_line.gl_account is a denormalized STRING reference to the GL account code in chart_of_accounts. Each journal entry line posts to a specific GL account — this is a fundamental 1:N relatio',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: journal_entry_line uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-le',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: journal_entry_line.document_number (STRING) is a denormalized reference to the parent journal_entry. Adding journal_entry_id FK creates the essential parent-child relationship between journal entry he',
    `request_id` BIGINT COMMENT 'Foreign key linking to service.request. Business justification: Service requests that consume resources (technician time, parts) generate journal entry lines for accruals or actual cost postings. Finance references the service request on the line item for audit tr',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`payment` (
    `payment_id` BIGINT COMMENT 'Unique surrogate identifier for each payment transaction record in the finance data product. Serves as the primary key for the payment entity in the Databricks Silver Layer.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to the AP invoice record being cleared or partially cleared by this payment.',
    `bank_account_id` BIGINT COMMENT 'Internal identifier of the companys house bank account used to execute or receive the payment. References the bank account master data in SAP, enabling bank statement reconciliation and liquidity management. Not a full account number (PCI-sensitive data is masked).. Valid values are `^[A-Z0-9_-]{1,35}$`',
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: payment.gl_account is a denormalized STRING reference to the GL clearing account used for payment postings. Payments clear through specific GL accounts (bank clearing, cash accounts). Adding chart_of_',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: Payments are processed within a controlling area that governs currency settings, cost center assignments, and financial consolidation scope. Adding controlling_area_id FK to payment establishes the CO',
    `credit_profile_id` BIGINT COMMENT 'Foreign key linking to customer.credit_profile. Business justification: Incoming payments are matched against a customers credit profile to update outstanding balances and credit utilization. Cash application teams in manufacturing use this to release blocked orders and ',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: payment uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-level cash fl',
    `amount` DECIMAL(18,2) COMMENT 'The gross payment amount in the transaction currency. For outgoing payments, this is the amount disbursed to the payee. For incoming payments, this is the amount received from the payer. Stored with 4 decimal places to support high-precision currencies.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    `amount_group_currency` DECIMAL(18,2) COMMENT 'The payment amount translated to the group (consolidation) currency for multinational consolidated financial reporting. Supports EBITDA, COGS, and group-level cash flow reporting under IFRS and GAAP.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    `amount_local` DECIMAL(18,2) COMMENT 'The payment amount converted to the local (company code) currency using the exchange rate at the time of posting. Used for statutory reporting, local GAAP compliance, and legal entity financial statements.. Valid values are `^-?d{1,18}(.d{1,4})?$`',
    `block` STRING COMMENT 'SAP payment block key indicating whether the payment is blocked from processing and the reason (e.g., R = manual block, A = blocked for payment, blank = not blocked). Used for payment approval workflows and dispute management.. Valid values are `^[A-Z0-9 ]{0,2}$`',
    `business_area` STRING COMMENT 'SAP business area associated with the payment, representing a distinct operational segment or division within the company code. Supports segment-level financial reporting and internal management accounting.. Valid values are `^[A-Z0-9]{1,6}$`',
    `cleared_amount` DECIMAL(18,2) COMMENT 'The monetary amount of the invoice cleared by this specific payment allocation. For partial payments, this is less than the invoice gross amount. Belongs to the clearing event, not to the payment or invoice alone.',
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
    `discount_taken` DECIMAL(18,2) COMMENT 'The cash discount amount actually captured on this specific clearing event. Reflects whether the early payment discount was applied at the time of this allocation. Belongs to the clearing event, not to the payment or invoice alone.',
    `document_date` DATE COMMENT 'The date of the original source document (e.g., check date, bank transfer initiation date) that triggered the payment. Used for document-level audit and aging analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_number` STRING COMMENT 'The financial document number assigned by SAP S/4HANA FI upon posting of the payment transaction. Used for audit trail, clearing, and reconciliation purposes across AP and AR processes.. Valid values are `^[A-Z0-9]{1,20}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied at the time of payment posting to convert the transaction currency amount to the local currency. Sourced from SAP exchange rate tables. Stored with 6 decimal places for precision.. Valid values are `^d{1,9}(.d{1,6})?$`',
    `exchange_rate_type` STRING COMMENT 'The SAP exchange rate type used for currency conversion (e.g., M = standard translation at average rate, B = bank buying rate, G = bank selling rate). Determines which rate table is applied for the conversion.. Valid values are `^[A-Z0-9]{1,4}$`',
    `fiscal_period` STRING COMMENT 'The fiscal posting period (1–16, including special periods) within the fiscal year to which the payment is assigned. Supports period-level financial reporting and month-end close reconciliation.. Valid values are `^(1[0-6]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which the payment posting belongs, as determined by the company code fiscal year variant in SAP. Used for period-close, statutory reporting, and EBITDA/COGS analysis.. Valid values are `^d{4}$`',
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
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: asset_transaction.gl_account_number is a denormalized STRING reference to the fixed asset GL account in chart_of_accounts. Asset transactions (acquisitions, retirements, depreciation) post to specific',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: Asset transactions (CAPEX acquisitions, depreciation runs, retirements) are executed within a controlling area that governs CAPEX budget profiles, depreciation areas, and cost center assignments. Addi',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: asset_transaction uses fiscal_year (INT) and fiscal_period (INT) as separate denormalized fields. Adding fiscal_period_id FK creates a direct relational link to the fiscal_period master for period-lev',
    `installation_record_id` BIGINT COMMENT 'Foreign key linking to service.installation_record. Business justification: When equipment is installed at a customer or plant site, an asset transaction (capitalization or transfer) is triggered. Finance links the asset transaction to the installation record to establish the',
    `tooling_equipment_id` BIGINT COMMENT 'Foreign key linking to engineering.tooling_equipment. Business justification: Tooling and equipment in manufacturing are capitalized assets. Finance records acquisition, depreciation, and disposal transactions against specific tooling items. Asset accountants use this link dail',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`finance`.`cash_application` (
    `cash_application_id` BIGINT COMMENT 'Primary key for the cash_application association',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to the AR invoice record being cleared by the payment',
    `payment_id` BIGINT COMMENT 'Foreign key linking to the payment record that was applied to the invoice',
    `cleared_amount` DECIMAL(18,2) COMMENT 'The portion of the payment amount applied to this specific invoice in the transaction currency. Belongs to the cash application event, not to the payment (which may cover many invoices) nor to the invoice (which may be partially cleared by multiple payments).',
    `clearing_date` DATE COMMENT 'The date on which this specific payment-to-invoice matching event was posted in SAP FI-AR. Represents when the open item was cleared, distinct from the payment execution date or the invoice due date.',
    `clearing_document_number` STRING COMMENT 'SAP accounting document number of the clearing transaction (payment, credit memo, or write-off) that settled this invoice. Supports payment reconciliation and audit trail. [Moved from ar_invoice: With the M:N cash application model in place, the clearing_document_number on ar_invoice becomes redundant and misleading — it can only store one payment reference, but an invoice may be cleared by multiple payments. The full clearing relationship is now captured in the cash_application association table. The clearing_document_number on payment should also be reviewed for the same reason.]. Valid values are `^[A-Z0-9-]{1,40}$`',
    `discount_taken` DECIMAL(18,2) COMMENT 'The early payment cash discount amount applied to this specific invoice within this payment application event. Differs from the invoice-level discount_amount as it reflects the actual discount realized at clearing time for this invoice-payment pair.',
    `remittance_reference` STRING COMMENT 'The customer-provided reference number or line identifier from the remittance advice that links this payment to this specific invoice. Used by AR teams to match incoming payments to open invoices during manual and automated cash application.',
    CONSTRAINT pk_cash_application PRIMARY KEY(`cash_application_id`)
) COMMENT 'This association product represents the Cash Application event between payment and ar_invoice. It captures the operational record of how a specific payment amount is applied to a specific AR invoice during the AR clearing process. Each record links one payment to one ar_invoice and carries the cleared amount, discount taken, and remittance reference that exist only in the context of this payment-to-invoice matching event. Sourced from SAP S/4HANA FI-AR open item clearing (BSAD/BSID tables).. Existence Justification: In manufacturing AR operations, cash application (payment-to-invoice matching) is a genuine operational M:N business process. A single customer remittance payment covers multiple invoices simultaneously, and a single invoice can receive partial payments across multiple payment runs over its lifecycle. This is not an analytical correlation — AR teams actively create, manage, and reconcile these clearing records as part of daily collections operations.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `manufacturing_ecm`.`finance`.`bank_account`(`bank_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ADD CONSTRAINT `fk_finance_cash_application_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `manufacturing_ecm`.`finance`.`payment`(`payment_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`finance` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `manufacturing_ecm`.`finance` SET TAGS ('dbx_domain' = 'finance');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`chart_of_accounts` SET TAGS ('dbx_subdomain' = 'ledger_management');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` SET TAGS ('dbx_subdomain' = 'ledger_management');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` SET TAGS ('dbx_subdomain' = 'ledger_management');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_line_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Line ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ALTER COLUMN `request_id` SET TAGS ('dbx_business_glossary_term' = 'Request Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` SET TAGS ('dbx_subdomain' = 'cash_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Clearing - Ap Invoice Id');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Identifier');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `credit_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Profile Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `cleared_amount` SET TAGS ('dbx_business_glossary_term' = 'Cleared Amount');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ALTER COLUMN `discount_taken` SET TAGS ('dbx_business_glossary_term' = 'Discount Taken');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` SET TAGS ('dbx_subdomain' = 'cash_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Account ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_pii_financial' = 'true');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` SET TAGS ('dbx_subdomain' = 'cash_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `asset_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Transaction ID');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `installation_record_id` SET TAGS ('dbx_business_glossary_term' = 'Installation Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ALTER COLUMN `tooling_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Equipment Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` SET TAGS ('dbx_subdomain' = 'cash_operations');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` SET TAGS ('dbx_association_edges' = 'finance.payment,finance.ar_invoice');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `cash_application_id` SET TAGS ('dbx_business_glossary_term' = 'Cash Application - Cash Application Id');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Cash Application - Ar Invoice Id');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Cash Application - Payment Id');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `cleared_amount` SET TAGS ('dbx_business_glossary_term' = 'Cleared Amount');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `cleared_amount` SET TAGS ('dbx_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `discount_taken` SET TAGS ('dbx_business_glossary_term' = 'Discount Taken');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `discount_taken` SET TAGS ('dbx_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ALTER COLUMN `remittance_reference` SET TAGS ('dbx_business_glossary_term' = 'Remittance Reference');
