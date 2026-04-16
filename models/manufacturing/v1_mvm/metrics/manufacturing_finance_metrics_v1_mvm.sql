-- Metric views for domain: finance | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_asset_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for fixed asset financial movements including CAPEX spend, depreciation charges, asset impairment, and net book value changes. Supports CAPEX reporting, EBITDA bridge, and asset lifecycle management for Manufacturing leadership."
  source: "`manufacturing_ecm`.`finance`.`asset_transaction`"
  filter: posting_status = 'posted' AND reversal_flag = False
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "SAP legal entity code enabling multi-entity CAPEX and depreciation reporting across Manufacturing geographies."
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of the asset transaction for annual CAPEX reporting and depreciation schedules."
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period (month) within the fiscal year for period-level CAPEX and depreciation run analysis."
    - name: "transaction_type_category"
      expr: transaction_type_category
      comment: "Business-level category of the asset movement (acquisition, retirement, transfer, write-down, depreciation) for CAPEX reporting and impairment analysis."
    - name: "asset_class_code"
      expr: asset_class_code
      comment: "SAP FI-AA asset class (machinery, buildings, IT equipment, vehicles) enabling depreciation and CAPEX analysis by asset category."
    - name: "capex_opex_indicator"
      expr: capex_opex_indicator
      comment: "CAPEX vs OPEX classification critical for EBITDA calculation and management reporting."
    - name: "cost_center"
      expr: cost_center
      comment: "Organizational cost center to which the asset and depreciation charges are assigned for management reporting."
    - name: "profit_center"
      expr: profit_center
      comment: "SAP profit center for segment-level EBITDA and profitability analysis by business unit."
    - name: "depreciation_area"
      expr: depreciation_area
      comment: "Valuation view (IFRS, Tax, Local GAAP, Cost Accounting) enabling parallel multi-GAAP depreciation reporting."
    - name: "depreciation_key"
      expr: depreciation_key
      comment: "Depreciation method applied (straight-line, declining balance) for impairment testing and depreciation analysis."
    - name: "posting_date"
      expr: posting_date
      comment: "GL posting date for period-end cut-off and financial reporting alignment."
    - name: "wbs_element"
      expr: wbs_element
      comment: "SAP Project System WBS element for capital project CAPEX tracking and settlement analysis."
    - name: "intercompany_flag"
      expr: intercompany_flag
      comment: "Identifies intercompany asset transfers requiring elimination in consolidated financial statements."
    - name: "local_currency"
      expr: local_currency
      comment: "Functional currency of the legal entity for statutory reporting context."
    - name: "group_currency"
      expr: group_currency
      comment: "Group consolidation currency for enterprise-level CAPEX and EBITDA reporting."
  measures:
    - name: "total_capex_spend_local"
      expr: SUM(CASE WHEN transaction_type_category = 'Acquisition' AND capex_opex_indicator = 'CAPEX' THEN amount_local_currency ELSE 0 END)
      comment: "Total capital expenditure acquisitions in local currency. Core CAPEX KPI used in board decks, investment committee reviews, and EBITDA bridge reporting."
    - name: "total_capex_spend_group"
      expr: SUM(CASE WHEN transaction_type_category = 'Acquisition' AND capex_opex_indicator = 'CAPEX' THEN amount_group_currency ELSE 0 END)
      comment: "Total CAPEX acquisitions translated to group consolidation currency for enterprise-level CAPEX vs budget reporting."
    - name: "total_depreciation_charge_local"
      expr: SUM(CASE WHEN transaction_type_category = 'Depreciation' THEN ABS(amount_local_currency) ELSE 0 END)
      comment: "Total periodic depreciation charge in local currency. Directly impacts EBITDA and is a key line in the management P&L and EBITDA bridge."
    - name: "total_depreciation_charge_group"
      expr: SUM(CASE WHEN transaction_type_category = 'Depreciation' THEN ABS(amount_group_currency) ELSE 0 END)
      comment: "Total depreciation charge in group currency for consolidated EBITDA and D&A reporting to group finance."
    - name: "total_asset_retirements_local"
      expr: SUM(CASE WHEN transaction_type_category = 'Retirement' THEN ABS(amount_local_currency) ELSE 0 END)
      comment: "Total value of fixed assets retired or disposed of in local currency. Signals asset lifecycle decisions and impacts PP&E balance sheet position."
    - name: "total_write_downs_local"
      expr: SUM(CASE WHEN transaction_type_category = 'Write-down' THEN ABS(amount_local_currency) ELSE 0 END)
      comment: "Total impairment write-downs on fixed assets in local currency. Critical for impairment testing compliance (IAS 36) and signals asset value deterioration requiring management action."
    - name: "total_accumulated_depreciation"
      expr: SUM(CAST(accumulated_depreciation AS DOUBLE))
      comment: "Total accumulated depreciation across all assets as of transaction posting date. Used for balance sheet PP&E net book value presentation and asset impairment assessment."
    - name: "total_net_book_value_after"
      expr: SUM(CAST(net_book_value_after AS DOUBLE))
      comment: "Total net book value (carrying amount) of assets after transactions are applied in local currency. Core balance sheet KPI for PP&E reporting and impairment assessment."
    - name: "avg_remaining_useful_life_years"
      expr: AVG(CAST(remaining_useful_life_years AS DOUBLE))
      comment: "Average remaining useful life of assets at transaction posting date. Signals fleet aging and future depreciation run-rate; triggers asset refresh investment decisions."
    - name: "avg_useful_life_years"
      expr: AVG(CAST(useful_life_years AS DOUBLE))
      comment: "Average total useful life assigned to assets. Used alongside remaining useful life to assess asset age profile and depreciation policy consistency."
    - name: "transaction_count"
      expr: COUNT(1)
      comment: "Total number of asset transaction postings. Used as a volume baseline for period-end close completeness checks and audit sampling."
    - name: "intercompany_transfer_amount_local"
      expr: SUM(CASE WHEN intercompany_flag = True AND transaction_type_category = 'Transfer' THEN ABS(amount_local_currency) ELSE 0 END)
      comment: "Total value of intercompany asset transfers in local currency. Required for consolidation elimination and transfer pricing compliance monitoring."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_payment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for AP and AR payment operations including cash outflow, cash inflow, discount capture, withholding tax, and payment method efficiency. Supports treasury cash management, working capital optimization, and AP/AR performance reporting."
  source: "`manufacturing_ecm`.`finance`.`payment`"
  filter: is_reversed = False
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Legal entity for which the payment is posted, enabling entity-level cash flow and working capital reporting."
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of the payment for annual cash flow and working capital analysis."
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period for monthly cash flow reporting and period-end close reconciliation."
    - name: "payment_direction"
      expr: direction
      comment: "Outgoing (AP disbursement) or incoming (AR cash receipt) classification for cash flow statement preparation."
    - name: "payment_type"
      expr: type
      comment: "Nature of payment (AP run, AR receipt, intercompany, expense reimbursement, tax remittance) for sub-ledger reconciliation."
    - name: "payment_method"
      expr: method
      comment: "Payment instrument (bank transfer, ACH, SEPA, wire, check) for treasury efficiency and bank fee analysis."
    - name: "payment_status"
      expr: status
      comment: "Lifecycle status of the payment (posted, cleared, rejected) for cash management and AP/AR reconciliation."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency cash flow and FX exposure reporting."
    - name: "country_code"
      expr: country_code
      comment: "Country of the legal entity or bank account for regulatory and cross-border payment compliance reporting."
    - name: "cost_center"
      expr: cost_center
      comment: "Cost center for departmental OPEX/CAPEX payment tracking and budget variance analysis."
    - name: "business_area"
      expr: business_area
      comment: "Business division for segment-level cash flow and working capital reporting."
    - name: "house_bank"
      expr: house_bank
      comment: "Bank institution through which the payment is processed for bank-level cash position and fee analysis."
    - name: "posting_date"
      expr: posting_date
      comment: "GL posting date for period-end cash flow cut-off and bank reconciliation."
    - name: "payment_date"
      expr: date
      comment: "Value date of payment execution for cash flow timing and bank statement matching."
  measures:
    - name: "total_outgoing_payments_local"
      expr: SUM(CASE WHEN direction = 'outgoing' THEN amount_local ELSE 0 END)
      comment: "Total AP disbursements in local currency. Core cash outflow KPI for treasury cash positioning and working capital management."
    - name: "total_incoming_payments_local"
      expr: SUM(CASE WHEN direction = 'incoming' THEN amount_local ELSE 0 END)
      comment: "Total AR cash receipts in local currency. Core cash inflow KPI for DSO management and liquidity forecasting."
    - name: "total_outgoing_payments_group"
      expr: SUM(CASE WHEN direction = 'outgoing' THEN amount_group_currency ELSE 0 END)
      comment: "Total AP disbursements in group consolidation currency for enterprise-level cash flow reporting."
    - name: "total_incoming_payments_group"
      expr: SUM(CASE WHEN direction = 'incoming' THEN amount_group_currency ELSE 0 END)
      comment: "Total AR cash receipts in group currency for consolidated cash flow statement preparation."
    - name: "total_discount_captured"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total early payment cash discounts captured across all AP payments. Directly impacts P&L cash discount income and measures effectiveness of early payment programs."
    - name: "total_withholding_tax"
      expr: SUM(CAST(withholding_tax_amount AS DOUBLE))
      comment: "Total withholding tax deducted at source across cross-border payments. Required for statutory tax reporting and transfer pricing compliance monitoring."
    - name: "payment_count"
      expr: COUNT(1)
      comment: "Total number of payment transactions. Used as volume baseline for payment run efficiency, bank fee benchmarking, and process automation KPIs."
    - name: "distinct_payment_methods_used"
      expr: COUNT(DISTINCT method)
      comment: "Number of distinct payment methods in use. Supports treasury rationalization initiatives and payment method standardization programs."
    - name: "avg_payment_amount_local"
      expr: AVG(CAST(amount_local AS DOUBLE))
      comment: "Average payment amount in local currency. Benchmarks payment size distribution and identifies outliers requiring additional approval controls."
    - name: "total_net_payment_amount_local"
      expr: SUM(CAST(amount_local AS DOUBLE))
      comment: "Total gross payment amount in local currency across all payment directions. Used for period-level cash flow statement preparation and bank reconciliation."
    - name: "total_cleared_amount"
      expr: SUM(CAST(cleared_amount AS DOUBLE))
      comment: "Total invoice amount cleared by payments. Measures the effectiveness of the payment run in settling open AP/AR items and reducing outstanding balances."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_journal_entry_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "High-value GL posting KPIs for COGS analysis, EBITDA reporting, cost center performance, and multi-currency financial consolidation. The atomic unit of Manufacturing financial reporting, enabling drill-down from enterprise P&L to individual cost postings."
  source: "`manufacturing_ecm`.`finance`.`journal_entry_line`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Legal entity for statutory and consolidated financial reporting."
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year for annual P&L, COGS, and EBITDA reporting."
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period for monthly management reporting and period-end close."
    - name: "document_type"
      expr: document_type
      comment: "SAP document type (GL, vendor invoice, customer invoice, asset posting) for transaction classification and audit."
    - name: "debit_credit_indicator"
      expr: debit_credit_indicator
      comment: "Debit or credit posting indicator for double-entry bookkeeping integrity and balance verification."
    - name: "account_type"
      expr: account_type
      comment: "Account type (Asset, Customer, Vendor, Material, GL) for subledger reconciliation and reporting classification."
    - name: "cost_center"
      expr: cost_center
      comment: "Cost center for departmental cost allocation, OPEX tracking, and management P&L reporting."
    - name: "profit_center"
      expr: profit_center
      comment: "Profit center for segment-level EBITDA and profitability analysis by business unit or product line."
    - name: "functional_area"
      expr: functional_area
      comment: "Functional area (Manufacturing, Sales, R&D, G&A) for income statement presentation by function of expense per IFRS IAS 1."
    - name: "business_area"
      expr: business_area
      comment: "Business division (Automation Systems, Electrification Solutions) for segment reporting."
    - name: "wbs_element"
      expr: wbs_element
      comment: "WBS element for capital project cost tracking and CAPEX vs OPEX classification."
    - name: "ledger_group"
      expr: ledger_group
      comment: "Accounting ledger (IFRS, GAAP, local GAAP) for parallel accounting and multi-standard reporting."
    - name: "transaction_currency"
      expr: transaction_currency
      comment: "Original transaction currency for multi-currency FX exposure and reconciliation analysis."
    - name: "posting_date"
      expr: posting_date
      comment: "GL posting date for period-end cut-off and financial reporting."
    - name: "source_system"
      expr: source_system
      comment: "Originating system (SAP S/4HANA, MES, WMS) for data lineage and multi-system reconciliation."
  measures:
    - name: "total_debit_amount_local"
      expr: SUM(CASE WHEN debit_credit_indicator = 'D' THEN amount_local_currency ELSE 0 END)
      comment: "Total debit postings in local currency. Foundation for trial balance preparation and period-end close verification."
    - name: "total_credit_amount_local"
      expr: SUM(CASE WHEN debit_credit_indicator = 'C' THEN amount_local_currency ELSE 0 END)
      comment: "Total credit postings in local currency. Paired with total debits for double-entry balance verification and trial balance."
    - name: "total_amount_group_currency"
      expr: SUM(CAST(amount_group_currency AS DOUBLE))
      comment: "Total net posting amount in group consolidation currency for enterprise-level P&L and EBITDA reporting."
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total indirect tax (VAT/GST) posted across all line items. Required for tax return preparation, VAT reconciliation, and multi-jurisdiction tax compliance."
    - name: "total_capex_postings_local"
      expr: SUM(CASE WHEN wbs_element IS NOT NULL AND wbs_element != '' THEN amount_local_currency ELSE 0 END)
      comment: "Total GL postings assigned to WBS elements (capital projects) in local currency. Proxy for CAPEX spend tracking from the GL perspective."
    - name: "journal_line_count"
      expr: COUNT(1)
      comment: "Total number of GL line item postings. Used for period-end close completeness, audit volume assessment, and automation rate benchmarking."
    - name: "distinct_cost_centers_posted"
      expr: COUNT(DISTINCT cost_center)
      comment: "Number of distinct cost centers receiving postings in the period. Monitors cost allocation breadth and identifies inactive cost centers for master data cleanup."
    - name: "distinct_profit_centers_posted"
      expr: COUNT(DISTINCT profit_center)
      comment: "Number of distinct profit centers with postings. Supports segment reporting completeness and profit center hierarchy governance."
    - name: "avg_line_amount_local"
      expr: AVG(CAST(amount_local_currency AS DOUBLE))
      comment: "Average GL line item amount in local currency. Benchmarks posting size distribution and supports anomaly detection for fraud and error controls."
    - name: "total_manufacturing_cost_local"
      expr: SUM(CASE WHEN functional_area = 'Manufacturing' THEN amount_local_currency ELSE 0 END)
      comment: "Total GL postings attributed to the Manufacturing functional area in local currency. Core input for COGS calculation and gross margin reporting."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_cash_application`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "AR cash application efficiency KPIs measuring invoice clearing performance, discount capture at clearing, and remittance matching. Supports DSO reduction, collections effectiveness, and working capital optimization for Manufacturing finance leadership."
  source: "`manufacturing_ecm`.`finance`.`cash_application`"
  dimensions:
    - name: "clearing_date"
      expr: clearing_date
      comment: "Date the payment-to-invoice matching event was posted in SAP FI-AR for period-level cash application analysis."
    - name: "clearing_document_number"
      expr: clearing_document_number
      comment: "SAP clearing document reference for audit trail and payment reconciliation."
    - name: "remittance_reference"
      expr: remittance_reference
      comment: "Customer remittance reference for matching quality analysis and straight-through processing rate measurement."
  measures:
    - name: "total_cleared_amount"
      expr: SUM(CAST(cleared_amount AS DOUBLE))
      comment: "Total invoice amount cleared through cash application events. Primary KPI for AR collections effectiveness and open item reduction."
    - name: "total_discount_taken_at_clearing"
      expr: SUM(CAST(discount_taken AS DOUBLE))
      comment: "Total early payment discounts realized at the point of invoice clearing. Measures the financial benefit of early payment programs and customer discount compliance."
    - name: "cash_application_event_count"
      expr: COUNT(1)
      comment: "Total number of payment-to-invoice matching events. Volume KPI for AR operations workload, automation rate benchmarking, and period-end close completeness."
    - name: "distinct_invoices_cleared"
      expr: COUNT(DISTINCT ar_invoice_id)
      comment: "Number of distinct AR invoices cleared in the period. Measures breadth of collections activity and open item reduction effectiveness."
    - name: "distinct_payments_applied"
      expr: COUNT(DISTINCT payment_id)
      comment: "Number of distinct payments applied to invoices. Supports payment run efficiency analysis and identifies payments covering multiple invoices (remittance complexity)."
    - name: "avg_cleared_amount_per_event"
      expr: AVG(CAST(cleared_amount AS DOUBLE))
      comment: "Average amount cleared per cash application event. Benchmarks clearing event size and supports identification of high-value clearing events requiring additional controls."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_bank_account`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Treasury bank account portfolio KPIs covering account coverage, overdraft facility management, electronic banking adoption, and cash pool structure. Supports treasury rationalization, bank relationship management, and liquidity risk governance."
  source: "`manufacturing_ecm`.`finance`.`bank_account`"
  filter: status = 'active'
  dimensions:
    - name: "bank_country"
      expr: bank_country
      comment: "Country of the banking institution for geographic treasury footprint and regulatory compliance reporting."
    - name: "account_type"
      expr: account_type
      comment: "Account type (current, deposit, payroll, zero balance, notional pooling) for treasury structure analysis."
    - name: "account_currency"
      expr: account_currency
      comment: "Account denomination currency for FX exposure and multi-currency cash positioning."
    - name: "cash_pool_role"
      expr: cash_pool_role
      comment: "Role in cash pooling structure (header, participant) for liquidity concentration analysis."
    - name: "bank_name"
      expr: bank_name
      comment: "Banking institution name for bank relationship management and counterparty concentration risk."
    - name: "account_purpose"
      expr: account_purpose
      comment: "Designated business purpose of the account for segregation of funds and internal controls reporting."
    - name: "signing_authority_type"
      expr: signing_authority_type
      comment: "Authorization type (single, dual, board resolution) for internal controls and SOX compliance reporting."
    - name: "electronic_banking_enabled"
      expr: electronic_banking_enabled
      comment: "Whether e-banking is activated for automated statement downloads and payment file submission."
    - name: "intercompany_flag"
      expr: intercompany_flag
      comment: "Identifies intercompany-designated accounts for consolidation elimination and transfer pricing compliance."
    - name: "payroll_account_flag"
      expr: payroll_account_flag
      comment: "Identifies payroll-dedicated accounts subject to additional segregation of duties controls."
  measures:
    - name: "active_account_count"
      expr: COUNT(1)
      comment: "Total number of active corporate bank accounts. Core treasury portfolio KPI for bank relationship rationalization and account consolidation programs."
    - name: "total_overdraft_facility"
      expr: SUM(CAST(overdraft_limit AS DOUBLE))
      comment: "Total authorized overdraft facility across all active accounts in account currency. Key liquidity risk KPI for treasury — signals maximum short-term credit exposure to banking counterparties."
    - name: "avg_overdraft_limit"
      expr: AVG(CAST(overdraft_limit AS DOUBLE))
      comment: "Average overdraft facility per active account. Benchmarks credit facility sizing and supports renegotiation of bank credit lines."
    - name: "electronic_banking_adoption_count"
      expr: COUNT(CASE WHEN electronic_banking_enabled = True THEN 1 END)
      comment: "Number of accounts with electronic banking enabled. Measures treasury automation coverage — low adoption signals manual reconciliation risk and process inefficiency."
    - name: "distinct_banking_institutions"
      expr: COUNT(DISTINCT bank_name)
      comment: "Number of distinct banking institutions in the corporate bank account portfolio. Measures bank relationship concentration and counterparty diversification for treasury risk management."
    - name: "distinct_account_currencies"
      expr: COUNT(DISTINCT account_currency)
      comment: "Number of distinct currencies across active bank accounts. Measures FX exposure breadth and supports currency rationalization in treasury operations."
    - name: "cash_pool_participant_count"
      expr: COUNT(CASE WHEN cash_pool_role IS NOT NULL AND cash_pool_role != '' THEN 1 END)
      comment: "Number of accounts participating in cash pooling structures. Measures liquidity concentration effectiveness and cash pool coverage ratio."
$$;