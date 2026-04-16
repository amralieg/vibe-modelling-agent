-- Metric views for domain: billing | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`billing_billing_block`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Billing block operational metrics tracking invoice holds, resolution cycle times, and billing integrity controls. Supports cash flow impact analysis and billing process quality improvement."
  source: "`manufacturing_ecm`.`billing`.`billing_block`"
  dimensions:
    - name: "reason_code"
      expr: reason_code
      comment: "Standardized reason for billing block - root cause analysis dimension"
    - name: "reason_category"
      expr: reason_category
      comment: "High-level category grouping block reasons for management reporting"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the billing block"
    - name: "object_type"
      expr: object_type
      comment: "Type of business document blocked (sales order, delivery, customer account)"
    - name: "company_code"
      expr: company_code
      comment: "Legal entity responsible for the blocked billing transaction"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization accountable for resolving the block"
    - name: "is_automatic_block"
      expr: is_automatic_block
      comment: "Indicates whether block was system-triggered vs manually applied"
    - name: "escalation_level"
      expr: escalation_level
      comment: "Management escalation tier for unresolved blocks"
    - name: "applied_date"
      expr: applied_date
      comment: "Date the billing block was applied"
  measures:
    - name: "Total Blocked Invoice Amount"
      expr: SUM(CAST(blocked_invoice_amount AS DOUBLE))
      comment: "Total invoice value withheld due to billing blocks - direct cash flow impact for treasury"
    - name: "Billing Block Count"
      expr: COUNT(1)
      comment: "Total number of active billing blocks - operational workload indicator"
    - name: "Avg Hold Duration Days"
      expr: AVG(CAST(hold_duration_days AS DOUBLE))
      comment: "Average days billing blocks remain active - resolution efficiency KPI"
    - name: "Escalated Block Count"
      expr: COUNT(DISTINCT CASE WHEN escalation_level IS NOT NULL THEN billing_block_id END)
      comment: "Number of blocks requiring management escalation - process quality indicator"
    - name: "Automatic Block Count"
      expr: COUNT(DISTINCT CASE WHEN is_automatic_block = TRUE THEN billing_block_id END)
      comment: "Number of system-triggered blocks - automation effectiveness metric"
    - name: "Released Block Count"
      expr: COUNT(DISTINCT CASE WHEN status = 'released' THEN billing_block_id END)
      comment: "Number of blocks successfully resolved and released"
    - name: "Avg Blocked Amount Per Block"
      expr: AVG(CAST(blocked_invoice_amount AS DOUBLE))
      comment: "Average invoice value per billing block - financial impact per incident"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`billing_invoice_line_item`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Invoice line-level revenue and margin metrics supporting product profitability analysis, pricing effectiveness, and revenue recognition accuracy. Enables detailed revenue analytics by product, customer, and channel."
  source: "`manufacturing_ecm`.`billing`.`invoice_line_item`"
  dimensions:
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization responsible for the sale"
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel for channel-level revenue analysis"
    - name: "division"
      expr: division
      comment: "Product division for segment reporting"
    - name: "plant"
      expr: plant
      comment: "Manufacturing or distribution facility supplying the goods"
    - name: "profit_center"
      expr: profit_center
      comment: "Profit center for internal profitability reporting"
    - name: "material_number"
      expr: material_number
      comment: "Product material number for product-level revenue analysis"
    - name: "billing_item_category"
      expr: billing_item_category
      comment: "Billing item category controlling billing behavior"
    - name: "revenue_recognition_method"
      expr: revenue_recognition_method
      comment: "Revenue recognition method (point-in-time vs over-time)"
    - name: "billing_date"
      expr: billing_date
      comment: "Date invoice was created and issued"
    - name: "fiscal_year"
      expr: YEAR(billing_date)
      comment: "Fiscal year of billing for annual revenue reporting"
    - name: "fiscal_month"
      expr: MONTH(billing_date)
      comment: "Fiscal month of billing for monthly revenue analysis"
  measures:
    - name: "Total Net Revenue"
      expr: SUM(CAST(net_line_value AS DOUBLE))
      comment: "Total net invoice revenue before tax - primary revenue metric for financial statements"
    - name: "Total Gross Revenue"
      expr: SUM(CAST(gross_line_value AS DOUBLE))
      comment: "Total gross invoice value before discounts - list price revenue"
    - name: "Total COGS"
      expr: SUM(CAST(cogs_amount AS DOUBLE))
      comment: "Total cost of goods sold - direct cost for margin calculation"
    - name: "Total Gross Margin"
      expr: SUM(CAST(gross_margin_amount AS DOUBLE))
      comment: "Total gross profit (revenue minus COGS) - profitability metric for executive dashboards"
    - name: "Total Discount Amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discounts applied - pricing effectiveness and margin leakage indicator"
    - name: "Total Tax Amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax collected - tax compliance reporting"
    - name: "Total Billed Quantity"
      expr: SUM(CAST(billed_quantity AS DOUBLE))
      comment: "Total quantity billed across all line items - volume metric"
    - name: "Invoice Line Count"
      expr: COUNT(1)
      comment: "Total number of invoice line items - transaction volume indicator"
    - name: "Avg Unit Price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average unit price across line items - pricing level indicator"
    - name: "Avg Discount Pct"
      expr: AVG(CAST(discount_percentage AS DOUBLE))
      comment: "Average discount percentage applied - pricing discipline metric"
    - name: "Gross Margin Pct"
      expr: ROUND(100.0 * SUM(CAST(gross_margin_amount AS DOUBLE)) / NULLIF(SUM(CAST(net_line_value AS DOUBLE)), 0), 2)
      comment: "Gross margin as percentage of net revenue - profitability rate for strategic planning"
    - name: "Discount Rate Pct"
      expr: ROUND(100.0 * SUM(CAST(discount_amount AS DOUBLE)) / NULLIF(SUM(CAST(gross_line_value AS DOUBLE)), 0), 2)
      comment: "Discount as percentage of gross revenue - margin leakage rate for pricing optimization"
    - name: "Unique Products Billed"
      expr: COUNT(DISTINCT material_number)
      comment: "Number of unique products billed - product portfolio breadth"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`billing_payment_receipt`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer payment receipt metrics tracking cash collection, payment timing, and AR clearing effectiveness. Supports cash flow management, collections performance monitoring, and working capital optimization."
  source: "`manufacturing_ecm`.`billing`.`payment_receipt`"
  dimensions:
    - name: "payment_type"
      expr: payment_type
      comment: "Payment classification (full, partial, advance, overpayment)"
    - name: "payment_channel"
      expr: payment_channel
      comment: "Channel through which payment was received and processed"
    - name: "status"
      expr: status
      comment: "Current processing status of the payment receipt"
    - name: "company_code"
      expr: company_code
      comment: "Legal entity receiving the payment"
    - name: "is_partial_payment"
      expr: is_partial_payment
      comment: "Indicates partial payment requiring follow-up"
    - name: "reversal_indicator"
      expr: reversal_indicator
      comment: "Indicates reversed payment (returned check, failed ACH)"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of payment posting"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period (month) of payment posting"
    - name: "posting_date"
      expr: posting_date
      comment: "Accounting posting date of the payment"
  measures:
    - name: "Total Payment Amount"
      expr: SUM(CAST(amount_in_company_currency AS DOUBLE))
      comment: "Total cash collected in company currency - primary cash flow metric for treasury"
    - name: "Total Applied Amount"
      expr: SUM(CAST(applied_amount AS DOUBLE))
      comment: "Total payment amount applied to invoices - AR clearing effectiveness"
    - name: "Total Outstanding Balance"
      expr: SUM(CAST(outstanding_balance AS DOUBLE))
      comment: "Total remaining AR balance after payment application - residual AR"
    - name: "Total Discount Taken"
      expr: SUM(CAST(discount_taken_amount AS DOUBLE))
      comment: "Total early payment discounts taken by customers - discount program cost"
    - name: "Total Tax Amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax component in payments - tax compliance reporting"
    - name: "Payment Receipt Count"
      expr: COUNT(1)
      comment: "Total number of payment receipts - transaction volume indicator"
    - name: "Partial Payment Count"
      expr: COUNT(DISTINCT CASE WHEN is_partial_payment = TRUE THEN payment_receipt_id END)
      comment: "Number of partial payments requiring follow-up - collections workload indicator"
    - name: "Reversed Payment Count"
      expr: COUNT(DISTINCT CASE WHEN reversal_indicator = TRUE THEN payment_receipt_id END)
      comment: "Number of reversed payments - payment quality and risk indicator"
    - name: "Avg Payment Amount"
      expr: AVG(CAST(amount_in_company_currency AS DOUBLE))
      comment: "Average payment receipt value - typical payment transaction size"
    - name: "Unique Paying Customers"
      expr: COUNT(DISTINCT customer_account_number)
      comment: "Number of unique customers making payments - payment activity breadth"
    - name: "Payment Application Rate"
      expr: ROUND(100.0 * SUM(CAST(applied_amount AS DOUBLE)) / NULLIF(SUM(CAST(amount_in_company_currency AS DOUBLE)), 0), 2)
      comment: "Percentage of payments successfully applied to invoices - cash application efficiency for operations"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`billing_performance_obligation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IFRS 15 / ASC 606 performance obligation metrics tracking revenue recognition progress, contract fulfillment, and remaining obligations. Supports revenue forecasting, contract management, and financial compliance."
  source: "`manufacturing_ecm`.`billing`.`performance_obligation`"
  dimensions:
    - name: "obligation_type"
      expr: obligation_type
      comment: "Classification of performance obligation by deliverable nature"
    - name: "satisfaction_method"
      expr: satisfaction_method
      comment: "Revenue recognition timing (point-in-time vs over-time)"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the performance obligation"
    - name: "company_code"
      expr: billing_company_code
      comment: "Legal entity responsible for revenue recognition"
    - name: "profit_center"
      expr: profit_center
      comment: "Profit center for segment-level revenue reporting"
    - name: "country_code"
      expr: country_code
      comment: "Jurisdiction where obligation is fulfilled"
    - name: "is_distinct"
      expr: is_distinct
      comment: "Indicates distinct performance obligation under IFRS 15"
    - name: "revenue_recognition_standard"
      expr: revenue_recognition_standard
      comment: "Applicable accounting standard (IFRS 15 or ASC 606)"
    - name: "fiscal_year"
      expr: YEAR(start_date)
      comment: "Fiscal year of obligation start"
  measures:
    - name: "Total Allocated Transaction Price"
      expr: SUM(CAST(allocated_transaction_price AS DOUBLE))
      comment: "Total transaction price allocated to performance obligations - revenue ceiling for contracts"
    - name: "Total Recognized Revenue"
      expr: SUM(CAST(recognized_revenue_amount AS DOUBLE))
      comment: "Total revenue recognized to date - earned revenue for financial statements"
    - name: "Total Remaining Obligation"
      expr: SUM(CAST(remaining_obligation_amount AS DOUBLE))
      comment: "Total unsatisfied performance obligation value - revenue backlog for forecasting"
    - name: "Total Standalone Selling Price"
      expr: SUM(CAST(standalone_selling_price AS DOUBLE))
      comment: "Total standalone selling price for allocation basis"
    - name: "Avg Completion Percentage"
      expr: AVG(CAST(completion_percentage AS DOUBLE))
      comment: "Average completion progress across obligations - portfolio fulfillment status"
    - name: "Performance Obligation Count"
      expr: COUNT(1)
      comment: "Total number of performance obligations - contract complexity indicator"
    - name: "Fully Satisfied Obligation Count"
      expr: COUNT(DISTINCT CASE WHEN status = 'fully_satisfied' THEN performance_obligation_id END)
      comment: "Number of completed obligations - fulfillment throughput"
    - name: "Unique Contracts"
      expr: COUNT(DISTINCT contract_number)
      comment: "Number of unique contracts with performance obligations"
    - name: "Revenue Recognition Rate"
      expr: ROUND(100.0 * SUM(CAST(recognized_revenue_amount AS DOUBLE)) / NULLIF(SUM(CAST(allocated_transaction_price AS DOUBLE)), 0), 2)
      comment: "Percentage of allocated price recognized as revenue - contract fulfillment rate for executive dashboards"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`billing_billing_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Billing plan metrics tracking milestone-based and periodic billing schedules for long-term contracts. Supports revenue forecasting, billing schedule management, and contract performance monitoring."
  source: "`manufacturing_ecm`.`billing`.`plan`"
  dimensions:
    - name: "type"
      expr: type
      comment: "Billing plan structure (milestone, periodic, partial invoice, progress)"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the billing plan"
    - name: "billing_rule"
      expr: billing_rule
      comment: "Calculation method for invoice amounts"
    - name: "contract_type"
      expr: contract_type
      comment: "Manufacturing contract model (ETO, MTO, MTS, ATO)"
    - name: "company_code"
      expr: company_code
      comment: "Legal entity responsible for the billing plan"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization managing the billing plan"
    - name: "is_billing_blocked"
      expr: is_billing_blocked
      comment: "Indicates whether billing is currently blocked"
    - name: "approval_status"
      expr: approval_status
      comment: "Workflow approval status of the billing plan"
    - name: "fiscal_year"
      expr: YEAR(start_date)
      comment: "Fiscal year of billing plan start"
  measures:
    - name: "Total Plan Amount"
      expr: SUM(CAST(total_plan_amount AS DOUBLE))
      comment: "Total value scheduled for billing across all plans - revenue backlog for forecasting"
    - name: "Total Billed Amount"
      expr: SUM(CAST(billed_amount AS DOUBLE))
      comment: "Total amount invoiced to date - realized revenue from billing plans"
    - name: "Total Unbilled Amount"
      expr: SUM(CAST(unbilled_amount AS DOUBLE))
      comment: "Total remaining amount to be invoiced - future revenue pipeline for cash flow planning"
    - name: "Total Down Payment Amount"
      expr: SUM(CAST(down_payment_amount AS DOUBLE))
      comment: "Total advance payments required - upfront cash collection"
    - name: "Total Contract Value"
      expr: SUM(CAST(contract_value AS DOUBLE))
      comment: "Total contract value associated with billing plans"
    - name: "Billing Plan Count"
      expr: COUNT(1)
      comment: "Total number of billing plans - contract volume indicator"
    - name: "Active Plan Count"
      expr: COUNT(DISTINCT CASE WHEN status = 'active' THEN plan_id END)
      comment: "Number of active billing plans - current billing workload"
    - name: "Blocked Plan Count"
      expr: COUNT(DISTINCT CASE WHEN is_billing_blocked = TRUE THEN plan_id END)
      comment: "Number of plans with billing blocks - billing hold impact"
    - name: "Billing Completion Rate"
      expr: ROUND(100.0 * SUM(CAST(billed_amount AS DOUBLE)) / NULLIF(SUM(CAST(total_plan_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of planned billing completed - contract fulfillment progress for project management"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`billing_revenue_recognition_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Revenue recognition event metrics tracking IFRS 15 / ASC 606 compliance, revenue timing, and contract liability management. Supports financial close, revenue forecasting, and audit compliance."
  source: "`manufacturing_ecm`.`billing`.`revenue_recognition_event`"
  dimensions:
    - name: "event_type"
      expr: event_type
      comment: "Trigger that caused revenue recognition"
    - name: "recognition_method"
      expr: recognition_method
      comment: "Revenue recognition timing (point-in-time vs over-time)"
    - name: "status"
      expr: status
      comment: "Current processing status in financial close workflow"
    - name: "company_code"
      expr: company_code
      comment: "Legal entity responsible for revenue recognition"
    - name: "profit_center"
      expr: profit_center
      comment: "Profit center for segment-level revenue reporting"
    - name: "country_code"
      expr: country_code
      comment: "Jurisdiction where revenue is recognized"
    - name: "is_intercompany"
      expr: is_intercompany
      comment: "Indicates intercompany revenue requiring elimination"
    - name: "accounting_period"
      expr: accounting_period
      comment: "Fiscal accounting period (YYYY-MM) of revenue recognition"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of revenue recognition"
    - name: "recognition_date"
      expr: recognition_date
      comment: "Business date revenue was recognized"
  measures:
    - name: "Total Recognized Revenue"
      expr: SUM(CAST(recognized_amount AS DOUBLE))
      comment: "Total revenue recognized in transaction currency - earned revenue for income statement"
    - name: "Total Recognized Revenue Company Currency"
      expr: SUM(CAST(recognized_amount_company_currency AS DOUBLE))
      comment: "Total revenue in company currency - statutory reporting revenue"
    - name: "Total Deferred Revenue"
      expr: SUM(CAST(deferred_revenue_amount AS DOUBLE))
      comment: "Total revenue deferred (contract liability) - balance sheet obligation for future performance"
    - name: "Total Contract Liability Balance"
      expr: SUM(CAST(contract_liability_balance AS DOUBLE))
      comment: "Total outstanding contract liability - advance payments and deferred revenue"
    - name: "Total Contract Asset Balance"
      expr: SUM(CAST(contract_asset_balance AS DOUBLE))
      comment: "Total contract asset (revenue recognized exceeding billing) - unbilled receivables"
    - name: "Total Transaction Price Allocated"
      expr: SUM(CAST(transaction_price_allocated AS DOUBLE))
      comment: "Total transaction price allocated to performance obligations"
    - name: "Revenue Recognition Event Count"
      expr: COUNT(1)
      comment: "Total number of revenue recognition events - transaction volume"
    - name: "Avg Completion Percentage"
      expr: AVG(CAST(percentage_of_completion AS DOUBLE))
      comment: "Average completion progress for over-time recognition - portfolio fulfillment status"
    - name: "Unique Performance Obligations"
      expr: COUNT(DISTINCT performance_obligation_id)
      comment: "Number of unique performance obligations recognized"
    - name: "Revenue Recognition Rate"
      expr: ROUND(100.0 * SUM(CAST(recognized_amount AS DOUBLE)) / NULLIF(SUM(CAST(transaction_price_allocated AS DOUBLE)), 0), 2)
      comment: "Percentage of allocated price recognized - fulfillment progress for executive dashboards"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`billing_write_off`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Bad debt write-off metrics tracking uncollectable receivables, credit losses, and recovery activity. Supports credit risk management, IFRS 9 expected credit loss analysis, and financial statement accuracy."
  source: "`manufacturing_ecm`.`billing`.`write_off`"
  dimensions:
    - name: "reason_code"
      expr: reason_code
      comment: "Standardized reason for write-off - root cause dimension"
    - name: "method"
      expr: method
      comment: "Accounting method (direct write-off vs allowance method)"
    - name: "status"
      expr: status
      comment: "Current processing status of the write-off"
    - name: "approval_status"
      expr: approval_status
      comment: "Workflow approval status for write-off authorization"
    - name: "company_code"
      expr: company_code
      comment: "Legal entity recording the write-off"
    - name: "country_code"
      expr: country_code
      comment: "Jurisdiction of the write-off for regional credit loss analysis"
    - name: "is_recovery_expected"
      expr: is_recovery_expected
      comment: "Indicates whether subsequent recovery is anticipated"
    - name: "reversal_indicator"
      expr: reversal_indicator
      comment: "Indicates reversed write-off (payment received after write-off)"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of write-off posting"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period (month) of write-off posting"
    - name: "write_off_date"
      expr: date
      comment: "Date write-off was approved and executed"
  measures:
    - name: "Total Write-Off Amount"
      expr: SUM(CAST(amount AS DOUBLE))
      comment: "Total uncollectable receivables written off - bad debt expense for income statement"
    - name: "Total Recovery Amount"
      expr: SUM(CAST(recovery_amount AS DOUBLE))
      comment: "Total amount recovered after write-off - bad debt recovery income"
    - name: "Total Original Invoice Amount"
      expr: SUM(CAST(original_invoice_amount AS DOUBLE))
      comment: "Total original invoice value before write-off - credit loss context"
    - name: "Write-Off Count"
      expr: COUNT(1)
      comment: "Total number of write-offs - credit loss frequency indicator"
    - name: "Avg Write-Off Amount"
      expr: AVG(CAST(amount AS DOUBLE))
      comment: "Average write-off value - typical credit loss size"
    - name: "Unique Customers Written Off"
      expr: COUNT(DISTINCT customer_account_number)
      comment: "Number of unique customers with write-offs - credit risk breadth"
    - name: "Recovery Expected Count"
      expr: COUNT(DISTINCT CASE WHEN is_recovery_expected = TRUE THEN write_off_id END)
      comment: "Number of write-offs with expected recovery - potential recovery pipeline"
    - name: "Actual Recovery Count"
      expr: COUNT(DISTINCT CASE WHEN recovery_amount > 0 THEN write_off_id END)
      comment: "Number of write-offs with actual recovery - recovery success rate"
    - name: "Recovery Rate"
      expr: ROUND(100.0 * SUM(CAST(recovery_amount AS DOUBLE)) / NULLIF(SUM(CAST(amount AS DOUBLE)), 0), 2)
      comment: "Percentage of written-off amount recovered - collections effectiveness post-write-off for credit management"
    - name: "Write-Off Rate"
      expr: ROUND(100.0 * SUM(CAST(amount AS DOUBLE)) / NULLIF(SUM(CAST(original_invoice_amount AS DOUBLE)), 0), 2)
      comment: "Write-off as percentage of original invoice value - credit loss severity for risk assessment"
$$;