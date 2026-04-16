-- Metric views for domain: finance | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_ap_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Accounts Payable invoice metrics tracking payables volume, amounts, payment terms, and supplier performance"
  source: "`manufacturing_ecm`.`finance`.`ap_invoice`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of invoice posting"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period of invoice posting"
    - name: "invoice_status"
      expr: invoice_status
      comment: "Current status of the invoice (e.g., posted, blocked, paid)"
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of invoice (e.g., standard, credit memo, debit memo)"
    - name: "capex_opex_indicator"
      expr: capex_opex_indicator
      comment: "Capital vs operational expenditure classification"
    - name: "vendor_account_number"
      expr: vendor_account_number
      comment: "Supplier/vendor account identifier"
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Payment terms code defining due date calculation"
    - name: "three_way_match_status"
      expr: three_way_match_status
      comment: "Status of three-way match (PO, GRN, Invoice)"
    - name: "posting_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Month of invoice posting for trend analysis"
    - name: "payment_block_indicator"
      expr: payment_block_indicator
      comment: "Indicator if payment is blocked"
  measures:
    - name: "total_invoice_amount"
      expr: SUM(CAST(amount_in_company_currency AS DOUBLE))
      comment: "Total invoice amount in company currency - key payables liability metric"
    - name: "total_net_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net invoice amount excluding tax"
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount on invoices"
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total early payment discount amount available"
    - name: "invoice_count"
      expr: COUNT(1)
      comment: "Number of AP invoices processed"
    - name: "unique_vendor_count"
      expr: COUNT(DISTINCT vendor_account_number)
      comment: "Number of unique vendors with invoices"
    - name: "avg_invoice_amount"
      expr: AVG(CAST(amount_in_company_currency AS DOUBLE))
      comment: "Average invoice amount - indicates typical transaction size"
    - name: "discount_capture_rate"
      expr: ROUND(100.0 * SUM(CAST(discount_amount AS DOUBLE)) / NULLIF(SUM(CAST(gross_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of potential early payment discounts captured - key cash management KPI"
    - name: "blocked_invoice_count"
      expr: SUM(CASE WHEN payment_block_indicator IS NOT NULL AND payment_block_indicator != '' THEN 1 ELSE 0 END)
      comment: "Number of invoices with payment blocks - indicates process exceptions"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_ar_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Accounts Receivable invoice metrics tracking revenue recognition, collections, and customer payment behavior"
  source: "`manufacturing_ecm`.`finance`.`ar_invoice`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of invoice"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period of invoice"
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of invoice (e.g., standard, credit memo, debit memo)"
    - name: "clearing_status"
      expr: clearing_status
      comment: "Payment clearing status (open, cleared, partial)"
    - name: "revenue_recognition_status"
      expr: revenue_recognition_status
      comment: "Revenue recognition status for financial reporting"
    - name: "country_code"
      expr: country_code
      comment: "Country code for geographic analysis"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization responsible for the invoice"
    - name: "invoice_month"
      expr: DATE_TRUNC('MONTH', invoice_date)
      comment: "Month of invoice date for trend analysis"
    - name: "dispute_indicator"
      expr: dispute_indicator
      comment: "Whether invoice is in dispute"
    - name: "dunning_level"
      expr: CAST(dunning_level AS STRING)
      comment: "Dunning level for overdue invoices"
  measures:
    - name: "total_invoice_amount"
      expr: SUM(CAST(amount_local_currency AS DOUBLE))
      comment: "Total invoice amount in local currency - key revenue metric"
    - name: "total_net_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net invoice amount excluding tax"
    - name: "total_open_amount"
      expr: SUM(CAST(open_amount AS DOUBLE))
      comment: "Total outstanding receivables amount - critical cash flow metric"
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount on invoices"
    - name: "invoice_count"
      expr: COUNT(1)
      comment: "Number of AR invoices issued"
    - name: "unique_customer_count"
      expr: COUNT(DISTINCT payer_account_number)
      comment: "Number of unique customers with invoices"
    - name: "avg_invoice_amount"
      expr: AVG(CAST(amount_local_currency AS DOUBLE))
      comment: "Average invoice amount - indicates typical transaction size"
    - name: "collection_rate"
      expr: ROUND(100.0 * (SUM(CAST(net_amount AS DOUBLE)) - SUM(CAST(open_amount AS DOUBLE))) / NULLIF(SUM(CAST(net_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of invoiced amount collected - key collections efficiency KPI"
    - name: "disputed_invoice_count"
      expr: SUM(CASE WHEN dispute_indicator = TRUE THEN 1 ELSE 0 END)
      comment: "Number of invoices in dispute - indicates customer satisfaction issues"
    - name: "overdue_invoice_count"
      expr: SUM(CASE WHEN dunning_level > 0 THEN 1 ELSE 0 END)
      comment: "Number of overdue invoices requiring dunning - credit risk indicator"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_budget`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Budget planning and control metrics tracking budget allocation, utilization, and variance management"
  source: "`manufacturing_ecm`.`finance`.`budget`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of budget"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period of budget"
    - name: "budget_type"
      expr: type
      comment: "Type of budget (e.g., operating, capital, project)"
    - name: "budget_category"
      expr: category
      comment: "Budget category classification"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of budget"
    - name: "version"
      expr: version
      comment: "Budget version (original, revised, forecast)"
    - name: "functional_area"
      expr: functional_area
      comment: "Functional area of budget allocation"
  measures:
    - name: "total_budget_amount"
      expr: SUM(CAST(amount AS DOUBLE))
      comment: "Total budgeted amount - key planning baseline"
    - name: "total_commitment_amount"
      expr: SUM(CAST(commitment_amount AS DOUBLE))
      comment: "Total committed amount against budget"
    - name: "budget_count"
      expr: COUNT(1)
      comment: "Number of budget line items"
    - name: "avg_budget_amount"
      expr: AVG(CAST(amount AS DOUBLE))
      comment: "Average budget allocation per line item"
    - name: "budget_utilization_rate"
      expr: ROUND(100.0 * SUM(CAST(commitment_amount AS DOUBLE)) / NULLIF(SUM(CAST(amount AS DOUBLE)), 0), 2)
      comment: "Percentage of budget committed - key budget control KPI"
    - name: "available_budget_amount"
      expr: SUM((CAST(amount AS DOUBLE)) - (CAST(commitment_amount AS DOUBLE)))
      comment: "Remaining available budget - critical for spending decisions"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_journal_entry`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "General ledger journal entry metrics tracking posting volume, amounts, and financial activity patterns"
  source: "`manufacturing_ecm`.`finance`.`journal_entry`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of journal entry"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period of journal entry"
    - name: "document_type"
      expr: document_type
      comment: "Document type of journal entry"
    - name: "posting_status"
      expr: posting_status
      comment: "Posting status (posted, parked, simulated)"
    - name: "debit_credit_indicator"
      expr: debit_credit_indicator
      comment: "Debit or credit indicator"
    - name: "functional_area"
      expr: functional_area
      comment: "Functional area of posting"
    - name: "posting_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Month of posting for trend analysis"
    - name: "reversal_indicator"
      expr: reversal_indicator
      comment: "Whether entry is a reversal"
  measures:
    - name: "total_local_currency_amount"
      expr: SUM(CAST(amount_in_local_currency AS DOUBLE))
      comment: "Total journal entry amount in local currency"
    - name: "total_group_currency_amount"
      expr: SUM(CAST(amount_in_group_currency AS DOUBLE))
      comment: "Total journal entry amount in group currency - key consolidation metric"
    - name: "journal_entry_count"
      expr: COUNT(1)
      comment: "Number of journal entries posted - transaction volume indicator"
    - name: "unique_document_count"
      expr: COUNT(DISTINCT document_number)
      comment: "Number of unique journal entry documents"
    - name: "avg_entry_amount"
      expr: AVG(CAST(amount_in_local_currency AS DOUBLE))
      comment: "Average journal entry amount"
    - name: "reversal_count"
      expr: SUM(CASE WHEN reversal_indicator = TRUE THEN 1 ELSE 0 END)
      comment: "Number of reversal entries - indicates correction activity"
    - name: "reversal_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN reversal_indicator = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of entries that are reversals - data quality indicator"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_payment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Payment transaction metrics tracking cash outflows, payment methods, and treasury operations"
  source: "`manufacturing_ecm`.`finance`.`payment`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of payment"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period of payment"
    - name: "payment_method"
      expr: method
      comment: "Payment method (e.g., wire, check, ACH)"
    - name: "payment_type"
      expr: type
      comment: "Payment type classification"
    - name: "payment_status"
      expr: status
      comment: "Payment status (e.g., cleared, pending, failed)"
    - name: "payment_direction"
      expr: direction
      comment: "Payment direction (inbound/outbound)"
    - name: "house_bank"
      expr: house_bank
      comment: "House bank used for payment"
    - name: "payment_month"
      expr: DATE_TRUNC('MONTH', date)
      comment: "Month of payment for trend analysis"
    - name: "is_reversed"
      expr: is_reversed
      comment: "Whether payment was reversed"
  measures:
    - name: "total_payment_amount"
      expr: SUM(CAST(amount AS DOUBLE))
      comment: "Total payment amount - key cash flow metric"
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total early payment discount taken - cash management efficiency"
    - name: "payment_count"
      expr: COUNT(1)
      comment: "Number of payments processed"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT reference)
      comment: "Number of unique payment recipients"
    - name: "avg_payment_amount"
      expr: AVG(CAST(amount AS DOUBLE))
      comment: "Average payment amount"
    - name: "reversed_payment_count"
      expr: SUM(CASE WHEN is_reversed = TRUE THEN 1 ELSE 0 END)
      comment: "Number of reversed payments - indicates payment issues"
    - name: "payment_reversal_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_reversed = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of payments reversed - payment quality indicator"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_intercompany_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Intercompany transaction metrics tracking cross-entity transfers, reconciliation, and elimination status"
  source: "`manufacturing_ecm`.`finance`.`intercompany_transaction`"
  dimensions:
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of intercompany transaction"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period of intercompany transaction"
    - name: "transaction_type"
      expr: transaction_type
      comment: "Type of intercompany transaction"
    - name: "sending_country_code"
      expr: sending_country_code
      comment: "Country of sending entity"
    - name: "receiving_country_code"
      expr: receiving_country_code
      comment: "Country of receiving entity"
    - name: "reconciliation_status"
      expr: reconciliation_status
      comment: "Reconciliation status between entities"
    - name: "elimination_status"
      expr: elimination_status
      comment: "Consolidation elimination status"
    - name: "transfer_pricing_method"
      expr: transfer_pricing_method
      comment: "Transfer pricing method applied"
    - name: "payment_status"
      expr: payment_status
      comment: "Payment status of intercompany transaction"
  measures:
    - name: "total_intercompany_amount"
      expr: SUM(CAST(amount_group_currency AS DOUBLE))
      comment: "Total intercompany transaction amount in group currency - key consolidation metric"
    - name: "total_gross_amount"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross intercompany amount"
    - name: "total_net_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net intercompany amount"
    - name: "transaction_count"
      expr: COUNT(1)
      comment: "Number of intercompany transactions"
    - name: "unique_entity_pair_count"
      expr: COUNT(DISTINCT CONCAT(sending_country_code, '-', receiving_country_code))
      comment: "Number of unique intercompany entity pairs"
    - name: "unreconciled_transaction_count"
      expr: SUM(CASE WHEN reconciliation_status != 'Reconciled' THEN 1 ELSE 0 END)
      comment: "Number of unreconciled intercompany transactions - key control metric"
    - name: "reconciliation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN reconciliation_status = 'Reconciled' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of intercompany transactions reconciled - critical consolidation KPI"
    - name: "avg_transaction_amount"
      expr: AVG(CAST(amount_group_currency AS DOUBLE))
      comment: "Average intercompany transaction amount"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_production_order_cost`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Production order cost metrics tracking manufacturing cost performance, variance, and efficiency"
  source: "`manufacturing_ecm`.`finance`.`production_order_cost`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of production order"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period of production order"
    - name: "order_type"
      expr: order_type
      comment: "Type of production order"
    - name: "order_status"
      expr: order_status
      comment: "Status of production order"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "variance_category"
      expr: variance_category
      comment: "Category of cost variance"
    - name: "settlement_status"
      expr: settlement_status
      comment: "Settlement status of production order"
    - name: "order_month"
      expr: DATE_TRUNC('MONTH', order_start_date)
      comment: "Month of order start for trend analysis"
  measures:
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_total_cost AS DOUBLE))
      comment: "Total actual production cost - key manufacturing cost metric"
    - name: "total_planned_cost"
      expr: SUM(CAST(planned_cost_amount AS DOUBLE))
      comment: "Total planned production cost"
    - name: "total_variance_amount"
      expr: SUM(CAST(variance_amount AS DOUBLE))
      comment: "Total cost variance (actual vs planned) - critical efficiency indicator"
    - name: "total_material_cost"
      expr: SUM(CAST(actual_material_cost AS DOUBLE))
      comment: "Total actual material cost"
    - name: "total_labor_cost"
      expr: SUM(CAST(actual_labor_cost AS DOUBLE))
      comment: "Total actual labor cost"
    - name: "total_machine_cost"
      expr: SUM(CAST(actual_machine_cost AS DOUBLE))
      comment: "Total actual machine cost"
    - name: "total_overhead_cost"
      expr: SUM(CAST(actual_overhead_cost AS DOUBLE))
      comment: "Total actual overhead cost"
    - name: "total_scrap_cost"
      expr: SUM(CAST(scrap_cost AS DOUBLE))
      comment: "Total scrap cost - quality and waste indicator"
    - name: "total_rework_cost"
      expr: SUM(CAST(rework_cost AS DOUBLE))
      comment: "Total rework cost - quality issue indicator"
    - name: "production_order_count"
      expr: COUNT(1)
      comment: "Number of production orders"
    - name: "cost_variance_rate"
      expr: ROUND(100.0 * SUM(CAST(variance_amount AS DOUBLE)) / NULLIF(SUM(CAST(planned_cost_amount AS DOUBLE)), 0), 2)
      comment: "Cost variance as percentage of planned cost - key manufacturing efficiency KPI"
    - name: "avg_order_cost"
      expr: AVG(CAST(actual_total_cost AS DOUBLE))
      comment: "Average production order cost"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_asset_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Fixed asset transaction metrics tracking asset acquisitions, depreciation, and net book value changes"
  source: "`manufacturing_ecm`.`finance`.`asset_transaction`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of asset transaction"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period of asset transaction"
    - name: "transaction_type_code"
      expr: transaction_type_code
      comment: "Type of asset transaction (acquisition, depreciation, disposal)"
    - name: "transaction_type_category"
      expr: transaction_type_category
      comment: "Category of asset transaction"
    - name: "asset_class_code"
      expr: asset_class_code
      comment: "Asset class code"
    - name: "depreciation_area"
      expr: depreciation_area
      comment: "Depreciation area (book, tax, IFRS)"
    - name: "capex_opex_indicator"
      expr: capex_opex_indicator
      comment: "Capital vs operational expenditure classification"
    - name: "posting_status"
      expr: posting_status
      comment: "Posting status of transaction"
    - name: "transaction_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Month of transaction posting for trend analysis"
  measures:
    - name: "total_transaction_amount"
      expr: SUM(CAST(transaction_amount AS DOUBLE))
      comment: "Total asset transaction amount"
    - name: "total_accumulated_depreciation"
      expr: SUM(CAST(accumulated_depreciation AS DOUBLE))
      comment: "Total accumulated depreciation - key asset valuation metric"
    - name: "total_net_book_value_after"
      expr: SUM(CAST(net_book_value_after AS DOUBLE))
      comment: "Total net book value after transaction - balance sheet metric"
    - name: "transaction_count"
      expr: COUNT(1)
      comment: "Number of asset transactions"
    - name: "unique_asset_count"
      expr: COUNT(DISTINCT asset_register_id)
      comment: "Number of unique assets with transactions"
    - name: "avg_transaction_amount"
      expr: AVG(CAST(transaction_amount AS DOUBLE))
      comment: "Average asset transaction amount"
    - name: "avg_remaining_useful_life"
      expr: AVG(CAST(remaining_useful_life_years AS DOUBLE))
      comment: "Average remaining useful life of assets in years - asset age indicator"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_copa_posting`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Profitability Analysis (CO-PA) metrics tracking contribution margin, revenue, and cost by profitability segment"
  source: "`manufacturing_ecm`.`finance`.`copa_posting`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of CO-PA posting"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period of CO-PA posting"
    - name: "contribution_margin_level"
      expr: contribution_margin_level
      comment: "Contribution margin level (CM1, CM2, CM3, etc.)"
    - name: "value_field_category"
      expr: value_field_category
      comment: "Category of value field (revenue, cost, margin)"
    - name: "value_field_name"
      expr: value_field_name
      comment: "Name of value field"
    - name: "sales_org_code"
      expr: sales_org_code
      comment: "Sales organization code"
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel"
    - name: "customer_number"
      expr: customer_number
      comment: "Customer number"
    - name: "material_number"
      expr: material_number
      comment: "Material/product number"
    - name: "posting_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Month of posting for trend analysis"
  measures:
    - name: "total_value_field_amount"
      expr: SUM(CAST(value_field_amount AS DOUBLE))
      comment: "Total CO-PA value field amount - key profitability metric"
    - name: "total_value_field_amount_group"
      expr: SUM(CAST(value_field_amount_group AS DOUBLE))
      comment: "Total CO-PA value field amount in group currency"
    - name: "total_quantity"
      expr: SUM(CAST(quantity AS DOUBLE))
      comment: "Total quantity sold/produced"
    - name: "posting_count"
      expr: COUNT(1)
      comment: "Number of CO-PA postings"
    - name: "unique_customer_count"
      expr: COUNT(DISTINCT customer_number)
      comment: "Number of unique customers"
    - name: "unique_product_count"
      expr: COUNT(DISTINCT material_number)
      comment: "Number of unique products"
    - name: "avg_value_per_posting"
      expr: AVG(CAST(value_field_amount AS DOUBLE))
      comment: "Average value per CO-PA posting"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`finance_period_close_activity`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Period close activity metrics tracking close process execution, timeliness, and completion status"
  source: "`manufacturing_ecm`.`finance`.`period_close_activity`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity segmentation"
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of period close"
    - name: "fiscal_period"
      expr: CAST(fiscal_period AS STRING)
      comment: "Fiscal period being closed"
    - name: "activity_type"
      expr: activity_type
      comment: "Type of close activity"
    - name: "close_category"
      expr: close_category
      comment: "Category of close activity (e.g., GL, AP, AR, consolidation)"
    - name: "execution_status"
      expr: execution_status
      comment: "Execution status of close activity"
    - name: "signoff_status"
      expr: signoff_status
      comment: "Sign-off status of close activity"
    - name: "responsible_team"
      expr: responsible_team
      comment: "Team responsible for close activity"
    - name: "priority"
      expr: priority
      comment: "Priority level of close activity"
    - name: "is_mandatory"
      expr: is_mandatory
      comment: "Whether activity is mandatory for close"
  measures:
    - name: "total_activity_count"
      expr: COUNT(1)
      comment: "Total number of period close activities"
    - name: "completed_activity_count"
      expr: SUM(CASE WHEN execution_status = 'Completed' THEN 1 ELSE 0 END)
      comment: "Number of completed close activities"
    - name: "pending_activity_count"
      expr: SUM(CASE WHEN execution_status IN ('Pending', 'In Progress') THEN 1 ELSE 0 END)
      comment: "Number of pending close activities - indicates close progress"
    - name: "failed_activity_count"
      expr: SUM(CASE WHEN execution_status = 'Failed' THEN 1 ELSE 0 END)
      comment: "Number of failed close activities - indicates close issues"
    - name: "completion_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN execution_status = 'Completed' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of close activities completed - key close progress KPI"
    - name: "signoff_completion_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN signoff_status = 'Signed Off' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of activities signed off - close quality indicator"
    - name: "mandatory_activity_count"
      expr: SUM(CASE WHEN is_mandatory = TRUE THEN 1 ELSE 0 END)
      comment: "Number of mandatory close activities"
$$;