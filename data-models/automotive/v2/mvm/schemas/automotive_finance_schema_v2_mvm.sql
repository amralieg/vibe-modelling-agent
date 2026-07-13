-- Schema for Domain: finance | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-13 17:05:57

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`finance` COMMENT 'Core financial management including general ledger, accounts payable, accounts receivable, cost center accounting, and financial reporting. Manages CapEx (Capital Expenditure) tracking, budget planning, FY (Fiscal Year) close, EBITDA reporting, profitability analysis by vehicle line/plant/region, and intercompany settlements. Tracks manufacturing cost (material, labor, overhead), warranty reserves, and inventory valuation. Supports SOX compliance, IFRS/GAAP reporting. Integrates with SAP FI/CO.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`gl_account` (
    `gl_account_id` BIGINT COMMENT 'System-generated unique identifier for the GL account record.',
    `company_code_id` BIGINT COMMENT 'add column company_code_id (BIGINT) with FK to finance.company_code.company_code_id - GL accounts are defined within specific company codes per SAP FI',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: gl_account carries cost_center_code as a denormalized STRING attribute representing the default cost center assignment for the GL account in SAP FI/CO. In SAP, GL accounts can have a default cost cent',
    `balance_type` STRING COMMENT 'Indicates whether the account is reported on the balance sheet or the profit & loss statement.. Valid values are `profit_and_loss|balance_sheet`',
    `budget_amount` DECIMAL(18,2) COMMENT 'Approved budget amount allocated to the account for the fiscal year, expressed in the account currency.',
    `chart_of_accounts_version` STRING COMMENT 'Version identifier of the chart of accounts in which this account is defined.',
    `closing_balance` DECIMAL(18,2) COMMENT 'Balance of the account at the end of the fiscal year.',
    `gl_account_code` STRING COMMENT 'External business code used to identify the GL account in the chart of accounts.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the GL account record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code in which the account balances are expressed.',
    `gl_account_description` STRING COMMENT 'Free‑form description providing additional context about the account.',
    `effective_from` DATE COMMENT 'Date on which the GL account becomes active for posting.',
    `effective_to` DATE COMMENT 'Date on which the GL account is retired or becomes inactive; null if open‑ended.',
    `fiscal_year` STRING COMMENT 'Fiscal year (FY) to which the account is primarily associated for budgeting.',
    `gl_account_status` STRING COMMENT 'Current lifecycle status of the account.. Valid values are `active|inactive|blocked|pending`',
    `gl_account_type` STRING COMMENT 'Classification of the account as asset, liability, equity, revenue, or expense.. Valid values are `asset|liability|equity|revenue|expense`',
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
    `tax_category` STRING COMMENT 'Category defining the tax treatment applied to postings in this account.. Valid values are `taxable|exempt|zero|reverse`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the GL account record.',
    CONSTRAINT pk_gl_account PRIMARY KEY(`gl_account_id`)
) COMMENT 'General Ledger (GL) account master record aligned with SAP FI chart of accounts. Defines each account in the corporate chart of accounts including account type (asset, liability, equity, revenue, expense), account group, P&L vs balance sheet classification, currency, tax category, and reconciliation account flags. SSOT for all GL account definitions used across FI/CO postings, IFRS/GAAP reporting, and SOX compliance controls.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`cost_center` (
    `cost_center_id` BIGINT COMMENT 'Unique surrogate key for the cost center master record.',
    `parent_cost_center_id` BIGINT COMMENT 'Identifier of the immediate parent cost center in the hierarchy (null for top‑level).',
    `actual_spend` DECIMAL(18,2) COMMENT 'Cumulative actual expenses posted to the cost center.',
    `allocation_method` STRING COMMENT 'Method used to allocate indirect costs to the cost center.. Valid values are `fixed|percentage|activity_based|none`',
    `approval_status` STRING COMMENT 'Current approval state of the cost centers budget.. Valid values are `pending|approved|rejected`',
    `budget_amount` DECIMAL(18,2) COMMENT 'Planned budget amount allocated to the cost center for the fiscal year.',
    `cost_center_category` STRING COMMENT 'Higher‑level classification of the cost center for reporting purposes.. Valid values are `cost_center|profit_center|investment_center`',
    `cost_center_code` STRING COMMENT 'External business code assigned to the cost center (e.g., SAP CO cost center code).',
    `cost_center_status` STRING COMMENT 'Current operational status of the cost center.. Valid values are `active|inactive|planned|closed`',
    `cost_center_type` STRING COMMENT 'Category of the cost center indicating its primary function within the organization.. Valid values are `production|administration|research|sales|service`',
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
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the cost center record.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between budgeted and actual spend (budget – actual).',
    CONSTRAINT pk_cost_center PRIMARY KEY(`cost_center_id`)
) COMMENT 'Cost center master record representing an organizational unit to which manufacturing costs, labor, overhead, and indirect expenses are assigned. Aligned with SAP CO cost center accounting (CCA). Captures cost center hierarchy, responsible manager, plant assignment, profit center linkage, valid-from/to dates, currency, and cost center category (production, administration, R&D, sales). Supports EBITDA reporting and profitability analysis by plant, vehicle line, and region.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`company_code` (
    `company_code_id` BIGINT COMMENT 'Surrogate primary key uniquely identifying the company code record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: company_code carries cost_center_code as a denormalized STRING attribute representing the default or primary cost center associated with the legal entity. In SAP FI, company codes are linked to cost c',
    `address_line1` STRING COMMENT 'Primary street address of the legal entity.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, floor, etc.).',
    `business_line` STRING COMMENT 'Primary business line or functional area of the entity. [ENUM-REF-CANDIDATE: design_engineering|manufacturing|sales|after_sales|r&d|finance|procurement — 7 candidates stripped; promote to reference product]',
    `chart_of_accounts` STRING COMMENT 'Identifier of the chart of accounts used for financial posting.',
    `city` STRING COMMENT 'City where the legal entity is located.',
    `company_code` STRING COMMENT 'Alphanumeric identifier used in SAP FI to represent the legal entity (e.g., US01, DE02).',
    `company_code_status` STRING COMMENT 'Current operational status of the legal entity.. Valid values are `active|inactive|closed|pending`',
    `consolidation_group` STRING COMMENT 'Group identifier used for legal consolidation of financial statements.',
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
    `tax_id_number` STRING COMMENT 'Government‑issued tax identifier for the legal entity.',
    `tax_jurisdiction_code` STRING COMMENT 'Code representing the tax jurisdiction applicable to the entity.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the company code record.',
    `website_url` STRING COMMENT 'Public website URL of the legal entity.',
    CONSTRAINT pk_company_code PRIMARY KEY(`company_code_id`)
) COMMENT 'Legal entity and company code master record representing an independent accounting unit within the Automotive enterprise. Aligned with SAP FI company code configuration. Captures legal entity name, country of incorporation, fiscal year variant, chart of accounts assignment, local currency, functional currency, IFRS/GAAP reporting standard, tax jurisdiction, and intercompany settlement group. Supports multi-entity consolidation and intercompany eliminations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`journal_entry` (
    `journal_entry_id` BIGINT COMMENT 'Unique identifier for the journal entry record.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Replace string company_code with FK to company_code for proper relational integrity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Reference cost_center master instead of free‑text code.',
    `dealership_id` BIGINT COMMENT 'Identifier of the user or system that performed the posting.',
    `party_id` BIGINT COMMENT 'Identifier of the business partner (vendor, customer, or other) associated with the entry.',
    `plant_id` BIGINT COMMENT 'Identifier of the user or system that performed the posting.',
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
    `journal_entry_status` STRING COMMENT 'Current processing status of the journal entry.. Valid values are `posted|reversed|pending|error`',
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
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating if the entry is a reversal of a previous entry.',
    `segment` STRING COMMENT 'Segment identifier for internal reporting (e.g., automotive, powertrain).',
    `source_module` STRING COMMENT 'Specific module within the source system (e.g., FI‑GL).',
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
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Link line to profit_center master for profitability reporting.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` (
    `ar_invoice_id` BIGINT COMMENT 'System-generated unique identifier for the AR invoice record.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to vehicle.connected_vehicle. Business justification: Connectivity subscription billing: AR invoices are issued for telematics/data plan subscriptions tied to a specific connected vehicle service record. The existing vin_registry_id covers vehicle sale i',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: ar_invoice carries cost_center_code as a denormalized STRING attribute used for revenue allocation and profitability reporting by cost center. Normalizing this to a cost_center_id FK enables proper co',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: AR invoices generate GL journal entries upon posting (revenue recognition, AR debit, tax credit). Linking ar_invoice to its primary journal_entry_id establishes the audit trail from the AR sub-ledger ',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.customer_fleet_account. Business justification: Automotive fleet billing consolidates AR invoices against fleet accounts for bulk vehicle purchases and service contracts. Fleet account managers require direct invoice-to-fleet-account linkage for co',
    `company_code_id` BIGINT COMMENT 'Identifier of the related legal entity in an intercompany invoice.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer or dealer billed on the invoice.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Automotive service and warranty AR invoices are explicitly tied to ownership records to validate warranty coverage period, ownership tenure, and service eligibility. Enables ownership-period billing r',
    `accounting_date` DATE COMMENT 'Date used for accounting period posting.',
    `aging_bucket` STRING COMMENT 'Age category of the invoice based on days past due.. Valid values are `current|1_30|31_60|61_90|90_plus|unknown`',
    `ar_invoice_date` DATE COMMENT 'Date the invoice was issued to the customer.',
    `ar_invoice_status` STRING COMMENT 'Current processing state of the invoice.. Valid values are `draft|open|posted|cancelled|paid|reversed`',
    `ar_invoice_type` STRING COMMENT 'High‑level classification of the invoice content.. Valid values are `vehicle_sale|parts|service|lease|subscription|other`',
    `billing_document_number` STRING COMMENT 'Reference number of the SAP billing document linked to this invoice.',
    `ar_invoice_category` STRING COMMENT 'Business segment or market category for the invoice.. Valid values are `domestic|export|internal|fleet|government|other`',
    `collection_status` STRING COMMENT 'Status of the invoice in the collections process.. Valid values are `on_time|late|defaulted|written_off|disputed|unknown`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the invoice record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the invoice.',
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
    `sales_org_code` STRING COMMENT 'Code of the sales organization responsible for the transaction.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax calculated for the invoice.',
    `tax_code` STRING COMMENT 'Tax jurisdiction code used for tax calculation.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate percentage for the invoice.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the invoice record.',
    `warranty_reserve_amount` DECIMAL(18,2) COMMENT 'Monetary amount set aside for future warranty claims related to this invoice.',
    `warranty_reserve_flag` BOOLEAN COMMENT 'Indicates whether a warranty reserve has been booked for this invoice.',
    CONSTRAINT pk_ar_invoice PRIMARY KEY(`ar_invoice_id`)
) COMMENT 'Accounts Receivable (AR) customer invoice record capturing outgoing invoices issued to dealers, fleet customers, and intercompany entities for vehicle sales, parts, and services. Aligned with SAP FI-AR and SD billing integration. Captures customer/dealer ID, invoice date, due date, payment terms, gross amount, tax amount, net amount, currency, billing document reference, vehicle line, MSRP vs net selling price, and collection status. Supports dealer billing reconciliation and revenue recognition.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`ar_payment` (
    `ar_payment_id` BIGINT COMMENT 'System-generated unique identifier for the AR payment record.',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: An AR payment is applied against an AR invoice — this is the fundamental AR cash application relationship. ar_payment currently stores invoice_number as a denormalized STRING reference. Adding ar_invo',
    `party_id` BIGINT COMMENT 'Identifier of the party (dealer, fleet account, or intercompany entity) that made the payment.',
    `retail_sale_id` BIGINT COMMENT 'Foreign key linking to dealer.retail_sale. Business justification: Customer and dealer payments for retail vehicle purchases are applied against specific deals. Linking ar_payment to retail_sale enables deal-level cash application reconciliation, daily cash reporting',
    `ar_payment_date` DATE COMMENT 'Date the payment was received or processed.',
    `ar_payment_status` STRING COMMENT 'Current lifecycle status of the payment.. Valid values are `pending|posted|cleared|rejected|void`',
    `bank_account_number` STRING COMMENT 'Bank account number where the payment was received.',
    `bank_name` STRING COMMENT 'Name of the bank that received the payment.',
    `cash_application_status` STRING COMMENT 'Status of cash application against the invoice(s).. Valid values are `unapplied|applied|partially_applied`',
    `channel` STRING COMMENT 'Channel through which the payment was submitted.. Valid values are `in_person|online_portal|mobile_app|batch|auto`',
    `clearance_date` DATE COMMENT 'Date the payment cleared the bank and was posted to the ledger.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code of the payment.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Discounts applied to the payment, if any.',
    `due_date` DATE COMMENT 'Date by which the payment was expected according to terms.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency conversion rate applied when payment currency differs from functional currency.',
    `exchange_rate_date` DATE COMMENT 'Date on which the exchange rate was sourced.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total amount received before any deductions.',
    `is_partial_payment` BOOLEAN COMMENT 'Flag indicating whether the payment covers the full invoice amount.',
    `method` STRING COMMENT 'Instrument used to make the payment.. Valid values are `cash|check|wire|credit_card|online|eft`',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount applied to the invoice after tax and discounts.',
    `notes` STRING COMMENT 'Free‑form text for any additional information about the payment.',
    `number` STRING COMMENT 'Unique payment reference assigned by the finance system.',
    `original_amount` DECIMAL(18,2) COMMENT 'Payment amount in the original foreign currency before conversion.',
    `posting_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment was posted to the general ledger.',
    `remittance_reference` STRING COMMENT 'Reference provided by the payer to reconcile the payment.',
    `source` STRING COMMENT 'Origin of the payment within the organization.. Valid values are `dealer|fleet|intercompany|direct_customer`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component deducted from the gross amount, if applicable.',
    `terms_code` STRING COMMENT 'Standard payment terms associated with the invoice.. Valid values are `NET30|NET45|NET60`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the payment record.',
    CONSTRAINT pk_ar_payment PRIMARY KEY(`ar_payment_id`)
) COMMENT 'Accounts Receivable incoming payment record capturing payments received from dealers, fleet accounts, and intercompany entities against AR invoices. Captures payment date, customer/dealer ID, payment method, amount received, currency, cleared invoice references, bank account, remittance advice reference, partial payment indicator, and cash application status. Supports dealer receivables management, DSO (Days Sales Outstanding) tracking, and cash flow forecasting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` (
    `vehicle_profitability_id` BIGINT COMMENT 'System-generated unique identifier for each vehicle profitability record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: vehicle_profitability carries cost_center_code as a denormalized STRING attribute referencing the cost center responsible for the vehicles manufacturing costs and overhead allocation. Normalizing thi',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: Vehicle profitability is directly impacted by incentive programs applied to the sale. Linking vehicle_profitability to the applied sales_incentive_program enables incentive cost attribution in per-veh',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Profitability analysis per model requires linking each profitability record to the vehicle model entity for aggregating costs and revenues by model.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Vehicle profitability is always attributed to the manufacturing plant for regional P&L, transfer pricing, and plant-level margin reporting. vehicle_profitability.plant_code is a plain-text denorm; rep',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer that sold the vehicle.',
    `party_id` BIGINT COMMENT 'Identifier of the end‑customer who purchased the vehicle.',
    `primary_vehicle_dealership_id` BIGINT COMMENT 'Identifier of the dealer that sold the vehicle.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Automotive vehicle profitability analysis must link to the ownership transaction to attribute margin by acquisition channel, ownership type, and trade-in value. OEM and dealer margin reporting require',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Vehicle profitability analysis in automotive finance is always tied to the engineering vehicle program (platform, powertrain, model year). Linking vehicle_profitability to vehicle_program enables prog',
    `actual_manufacturing_cost` DECIMAL(18,2) COMMENT 'Real cost incurred for material, labor, and overhead.',
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
    `profit_center_code` STRING COMMENT 'Profit center used for revenue attribution.',
    `sales_channel` STRING COMMENT 'Channel through which the vehicle was sold.. Valid values are `Dealer|Direct|Online|Fleet|Wholesale`',
    `selling_distribution_cost` DECIMAL(18,2) COMMENT 'Costs associated with sales, logistics, and dealer commissions.',
    `standard_manufacturing_cost` DECIMAL(18,2) COMMENT 'Planned cost based on standard BOM and routing.',
    `subsidy_amount` DECIMAL(18,2) COMMENT 'Monetary value of any applicable subsidy.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Taxes applied to the net revenue.',
    `transaction_date` DATE COMMENT 'Date the vehicle sale and profitability calculation occurred.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `vehicle_category` STRING COMMENT 'Business segment classification of the vehicle.. Valid values are `Passenger|Commercial|Luxury|Performance`',
    `vehicle_height_mm` STRING COMMENT 'Overall height of the vehicle in millimetres.',
    `vehicle_length_mm` STRING COMMENT 'Overall length of the vehicle in millimetres.',
    `vehicle_line` STRING COMMENT 'Model line or family (e.g., SUV, Truck, Sedan).',
    `vehicle_profitability_status` STRING COMMENT 'Current lifecycle status of the profitability record.. Valid values are `active|closed|reversed|pending`',
    `vehicle_weight_kg` DECIMAL(18,2) COMMENT 'Curb weight of the vehicle in kilograms.',
    `vehicle_width_mm` STRING COMMENT 'Overall width of the vehicle in millimetres.',
    `warranty_miles` STRING COMMENT 'Maximum mileage covered by the warranty.',
    `warranty_reserve_charge` DECIMAL(18,2) COMMENT 'Provision for future warranty claims allocated to this vehicle.',
    `warranty_years` STRING COMMENT 'Length of the standard warranty in years.',
    CONSTRAINT pk_vehicle_profitability PRIMARY KEY(`vehicle_profitability_id`)
) COMMENT 'Vehicle-level profitability record capturing the contribution margin and net profitability for each vehicle unit sold, by VIN, vehicle line, plant, market region, and sales channel. Captures gross revenue (MSRP), net revenue (after dealer incentives and discounts), standard manufacturing cost, actual manufacturing cost, gross margin, selling and distribution cost, warranty reserve charge, and net contribution margin. Supports EBITDA reporting by vehicle line/plant/region and management accounting for product portfolio decisions.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ADD CONSTRAINT `fk_finance_gl_account_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ADD CONSTRAINT `fk_finance_gl_account_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_parent_cost_center_id` FOREIGN KEY (`parent_cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ADD CONSTRAINT `fk_finance_company_code_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_automotive_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_automotive_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ADD CONSTRAINT `fk_finance_ar_payment_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `vibe_automotive_v1`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`finance` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_automotive_v1`.`finance` SET TAGS ('dbx_domain' = 'finance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `balance_type` SET TAGS ('dbx_business_glossary_term' = 'Balance Sheet vs. Profit & Loss Classification');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `balance_type` SET TAGS ('dbx_value_regex' = 'profit_and_loss|balance_sheet');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `chart_of_accounts_version` SET TAGS ('dbx_business_glossary_term' = 'Chart of Accounts Version');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `closing_balance` SET TAGS ('dbx_business_glossary_term' = 'Closing Balance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_description` SET TAGS ('dbx_business_glossary_term' = 'GL Account Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `effective_to` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_status` SET TAGS ('dbx_business_glossary_term' = 'GL Account Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_type` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_type` SET TAGS ('dbx_value_regex' = 'asset|liability|equity|revenue|expense');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `group` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_budgeted` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Account Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_consolidation_account` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Account Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_deprecated` SET TAGS ('dbx_business_glossary_term' = 'Deprecation Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_reconciliation_account` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Account Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `is_tax_relevant` SET TAGS ('dbx_business_glossary_term' = 'Tax Relevance Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `last_posting_date` SET TAGS ('dbx_business_glossary_term' = 'Last Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `last_reconciliation_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reconciliation Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `gl_account_name` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `opening_balance` SET TAGS ('dbx_business_glossary_term' = 'Opening Balance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `reporting_level` SET TAGS ('dbx_business_glossary_term' = 'Reporting Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `reporting_level` SET TAGS ('dbx_value_regex' = 'company|division|plant|region|country');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Business Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `segment` SET TAGS ('dbx_value_regex' = 'OEM|Aftermarket|Service|R&D');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `tax_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `tax_category` SET TAGS ('dbx_value_regex' = 'taxable|exempt|zero|reverse');
ALTER TABLE `vibe_automotive_v1`.`finance`.`gl_account` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `parent_cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Cost Center ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `actual_spend` SET TAGS ('dbx_business_glossary_term' = 'Actual Spend');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `allocation_method` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `allocation_method` SET TAGS ('dbx_value_regex' = 'fixed|percentage|activity_based|none');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_category` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_category` SET TAGS ('dbx_value_regex' = 'cost_center|profit_center|investment_center');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_status` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_status` SET TAGS ('dbx_value_regex' = 'active|inactive|planned|closed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_type` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_type` SET TAGS ('dbx_value_regex' = 'production|administration|research|sales|service');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `country` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_description` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Description');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `effective_to` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `cost_center_name` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `reporting_level` SET TAGS ('dbx_business_glossary_term' = 'Reporting Level');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `reporting_level` SET TAGS ('dbx_value_regex' = 'plant|division|global');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Variance Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Identifier');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `business_line` SET TAGS ('dbx_business_glossary_term' = 'Business Line');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `chart_of_accounts` SET TAGS ('dbx_business_glossary_term' = 'Chart of Accounts Assignment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `city` SET TAGS ('dbx_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code (SAP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code_status` SET TAGS ('dbx_business_glossary_term' = 'Entity Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `company_code_status` SET TAGS ('dbx_value_regex' = 'active|inactive|closed|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `consolidation_group` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO 3166-1 alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `entity_type` SET TAGS ('dbx_business_glossary_term' = 'Entity Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `entity_type` SET TAGS ('dbx_value_regex' = 'legal_entity|joint_venture|subsidiary|branch|holding');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year Variant');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `fiscal_year_variant` SET TAGS ('dbx_value_regex' = 'FY01|FY02|FY03|FY04|FY05|FY06');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `functional_currency` SET TAGS ('dbx_business_glossary_term' = 'Functional Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `functional_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `industry_sector` SET TAGS ('dbx_business_glossary_term' = 'Industry Sector');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `industry_sector` SET TAGS ('dbx_value_regex' = 'passenger_vehicles|commercial_vehicles|components|services|software');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `is_consolidated` SET TAGS ('dbx_business_glossary_term' = 'Is Consolidated Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `legal_name` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `local_currency` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `local_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `phone_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `registration_number` SET TAGS ('dbx_business_glossary_term' = 'Company Registration Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `registration_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `reporting_standard` SET TAGS ('dbx_business_glossary_term' = 'Financial Reporting Standard');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `reporting_standard` SET TAGS ('dbx_value_regex' = 'IFRS|GAAP|IFRS_FOR_SME|US_GAAP|EU_GAAP');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Reporting Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `short_name` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Short Name');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_id_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number (TIN)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_id_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_id_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`company_code` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Website URL');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Posting User ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Business Partner ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Posting User ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Document Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CUR)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_business_glossary_term' = 'Debit/Credit Indicator (DC)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_value_regex' = 'debit|credit');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_language` SET TAGS ('dbx_business_glossary_term' = 'Document Language');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type (DT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'SA|KR|AB|DR|CR');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `intercompany_indicator` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_adjustment` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_consolidated` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_manual_entry` SET TAGS ('dbx_business_glossary_term' = 'Manual Entry Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `is_test_entry` SET TAGS ('dbx_business_glossary_term' = 'Test Entry Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_status` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `journal_entry_status` SET TAGS ('dbx_value_regex' = 'posted|reversed|pending|error');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `ledger_group` SET TAGS ('dbx_business_glossary_term' = 'Ledger Group');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `line_item_count` SET TAGS ('dbx_business_glossary_term' = 'Line Item Count');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `plant` SET TAGS ('dbx_business_glossary_term' = 'Plant (PLANT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_category` SET TAGS ('dbx_business_glossary_term' = 'Posting Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_key` SET TAGS ('dbx_business_glossary_term' = 'Posting Key');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_period` SET TAGS ('dbx_business_glossary_term' = 'Posting Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_reference` SET TAGS ('dbx_business_glossary_term' = 'Posting Reference');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_text` SET TAGS ('dbx_business_glossary_term' = 'Posting Text');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Posting Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `posting_user_role` SET TAGS ('dbx_business_glossary_term' = 'Posting User Role');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Reporting Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `source_module` SET TAGS ('dbx_business_glossary_term' = 'Source Module');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `tax_jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `transaction_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` SET TAGS ('dbx_subdomain' = 'general_ledger');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_line_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Line ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Account Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `amount_cc` SET TAGS ('dbx_business_glossary_term' = 'Posting Amount (Company Code Currency)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `amount_tc` SET TAGS ('dbx_business_glossary_term' = 'Posting Amount (Transaction Currency)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `assignment` SET TAGS ('dbx_business_glossary_term' = 'Assignment Field');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_cc` SET TAGS ('dbx_business_glossary_term' = 'Company Code Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_cc` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_tc` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `currency_tc` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_business_glossary_term' = 'Debit/Credit Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `debit_credit_indicator` SET TAGS ('dbx_value_regex' = 'D|C');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `exchange_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `plant` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `posting_key` SET TAGS ('dbx_business_glossary_term' = 'Posting Key');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Line Quantity');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reference_document_item` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Item');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Segment');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `sequence` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `text` SET TAGS ('dbx_business_glossary_term' = 'Line Item Text');
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` SET TAGS ('dbx_subdomain' = 'receivables_management');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Receivable Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Fleet Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Entity ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `accounting_date` SET TAGS ('dbx_business_glossary_term' = 'Accounting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_value_regex' = 'current|1_30|31_60|61_90|90_plus|unknown');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_status` SET TAGS ('dbx_value_regex' = 'draft|open|posted|cancelled|paid|reversed');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_type` SET TAGS ('dbx_value_regex' = 'vehicle_sale|parts|service|lease|subscription|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `billing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_category` SET TAGS ('dbx_business_glossary_term' = 'Invoice Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `ar_invoice_category` SET TAGS ('dbx_value_regex' = 'domestic|export|internal|fleet|government|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `collection_status` SET TAGS ('dbx_business_glossary_term' = 'Collection Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `collection_status` SET TAGS ('dbx_value_regex' = 'on_time|late|defaulted|written_off|disputed|unknown');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `discount_reason` SET TAGS ('dbx_business_glossary_term' = 'Discount Reason');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'credit_card|bank_transfer|cash|check|online|other');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_received_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Received Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|failed|reversed|partial|unknown');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net_30|net_45|net_60|cod|prepaid|milestone');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `sales_org_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `warranty_reserve_amount` SET TAGS ('dbx_business_glossary_term' = 'Warranty Reserve Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ALTER COLUMN `warranty_reserve_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Reserve Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` SET TAGS ('dbx_subdomain' = 'receivables_management');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Receivable Payment ID (AR_PAYMENT_ID)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Payer Identifier (PAYER_ID)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `retail_sale_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Sale Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date (PAYMENT_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status (PAYMENT_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `ar_payment_status` SET TAGS ('dbx_value_regex' = 'pending|posted|cleared|rejected|void');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number (BANK_ACCOUNT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `bank_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Name (BANK_NAME)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `cash_application_status` SET TAGS ('dbx_business_glossary_term' = 'Cash Application Status (CASH_APPLICATION_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `cash_application_status` SET TAGS ('dbx_value_regex' = 'unapplied|applied|partially_applied');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Payment Channel (PAYMENT_CHANNEL)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'in_person|online_portal|mobile_app|batch|auto');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `clearance_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Clearance Date (CLEARANCE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217) (CURRENCY_CODE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount Applied to Payment (DISCOUNT_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date (DUE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate to Functional Currency (EXCHANGE_RATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `exchange_rate_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Date (EXCHANGE_RATE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Payment Amount (GROSS_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `is_partial_payment` SET TAGS ('dbx_business_glossary_term' = 'Partial Payment Indicator (IS_PARTIAL_PAYMENT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method (PAYMENT_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'cash|check|wire|credit_card|online|eft');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Payment Amount (NET_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Payment Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number (PAYMENT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `original_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Payment Amount in Foreign Currency (ORIGINAL_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `posting_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Posting Timestamp (POSTING_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `remittance_reference` SET TAGS ('dbx_business_glossary_term' = 'Remittance Advice Reference (REMITTANCE_REFERENCE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `source` SET TAGS ('dbx_business_glossary_term' = 'Payment Source (PAYMENT_SOURCE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `source` SET TAGS ('dbx_value_regex' = 'dealer|fleet|intercompany|direct_customer');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount Applied to Payment (TAX_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code (PAYMENT_TERMS_CODE)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `terms_code` SET TAGS ('dbx_value_regex' = 'NET30|NET45|NET60');
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` SET TAGS ('dbx_subdomain' = 'receivables_management');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_profitability_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Profitability Record ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `primary_vehicle_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `actual_manufacturing_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Manufacturing Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `ebitda_contribution` SET TAGS ('dbx_business_glossary_term' = 'EBITDA Contribution');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `emission_rating` SET TAGS ('dbx_business_glossary_term' = 'Emission Rating');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'EV|HEV|PHEV|ICE|Hybrid');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `gross_margin` SET TAGS ('dbx_business_glossary_term' = 'Gross Margin');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `gross_revenue_msrp` SET TAGS ('dbx_business_glossary_term' = 'Gross Revenue (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Dealer Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `is_eligible_for_subsidy` SET TAGS ('dbx_business_glossary_term' = 'Subsidy Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `net_contribution_margin` SET TAGS ('dbx_business_glossary_term' = 'Net Contribution Margin');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `net_revenue` SET TAGS ('dbx_business_glossary_term' = 'Net Revenue');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'Dealer|Direct|Online|Fleet|Wholesale');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `selling_distribution_cost` SET TAGS ('dbx_business_glossary_term' = 'Selling & Distribution Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `standard_manufacturing_cost` SET TAGS ('dbx_business_glossary_term' = 'Standard Manufacturing Cost');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `subsidy_amount` SET TAGS ('dbx_business_glossary_term' = 'Subsidy Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `transaction_date` SET TAGS ('dbx_business_glossary_term' = 'Transaction Date');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_category` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Category');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_category` SET TAGS ('dbx_value_regex' = 'Passenger|Commercial|Luxury|Performance');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_height_mm` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Height (mm)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_length_mm` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Length (mm)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_line` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Line');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_profitability_status` SET TAGS ('dbx_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_profitability_status` SET TAGS ('dbx_value_regex' = 'active|closed|reversed|pending');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `vehicle_width_mm` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Width (mm)');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `warranty_miles` SET TAGS ('dbx_business_glossary_term' = 'Warranty Mileage Limit');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `warranty_reserve_charge` SET TAGS ('dbx_business_glossary_term' = 'Warranty Reserve Charge');
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ALTER COLUMN `warranty_years` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Years)');
