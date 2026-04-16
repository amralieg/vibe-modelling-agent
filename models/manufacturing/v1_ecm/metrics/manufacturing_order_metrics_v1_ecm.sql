-- Metric views for domain: order | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_sales_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core sales order performance metrics tracking revenue, margin, fulfillment efficiency, and customer delivery commitments. Enables executive dashboards for order-to-cash cycle analysis, revenue forecasting, and operational performance management."
  source: "`manufacturing_ecm`.`order`.`line_item`"
  dimensions:
    - name: "order_status"
      expr: status
      comment: "Current lifecycle status of the order line item (open, confirmed, delivered, invoiced, cancelled) for pipeline and fulfillment tracking"
    - name: "fulfillment_mode"
      expr: fulfillment_mode_id
      comment: "Manufacturing fulfillment strategy (MTO, MTS, ETO, ATO) driving lead time commitments and production planning"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing or distribution facility responsible for fulfilling the order line"
    - name: "sales_organization"
      expr: sales_order_id
      comment: "Sales organization identifier for regional revenue attribution and multi-entity reporting"
    - name: "product_hierarchy"
      expr: product_hierarchy
      comment: "Product family classification for portfolio analysis and product line performance"
    - name: "order_month"
      expr: DATE_TRUNC('MONTH', created_timestamp)
      comment: "Month of order creation for time-series revenue and booking analysis"
    - name: "requested_delivery_month"
      expr: DATE_TRUNC('MONTH', requested_delivery_date)
      comment: "Month of customer-requested delivery for demand planning and capacity forecasting"
    - name: "confirmed_delivery_month"
      expr: DATE_TRUNC('MONTH', confirmed_delivery_date)
      comment: "Month of ATP/CTP-confirmed delivery for revenue recognition planning and shipment forecasting"
  measures:
    - name: "Total Order Lines"
      expr: COUNT(1)
      comment: "Total number of sales order line items for volume analysis and order complexity assessment"
    - name: "Total Net Revenue"
      expr: SUM(CAST(net_value AS DOUBLE))
      comment: "Total net order value after discounts, representing committed revenue for financial forecasting and performance tracking"
    - name: "Total Ordered Quantity"
      expr: SUM(CAST(ordered_quantity AS DOUBLE))
      comment: "Total quantity ordered by customers for demand planning and production capacity analysis"
    - name: "Total Confirmed Quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed via ATP/CTP checks, representing firm manufacturing commitments"
    - name: "Total Delivered Quantity"
      expr: SUM(CAST(delivered_quantity AS DOUBLE))
      comment: "Total quantity physically delivered and goods-issued for fulfillment performance tracking"
    - name: "Avg Net Price Per Unit"
      expr: AVG(CAST(net_price AS DOUBLE))
      comment: "Average net unit price across order lines for pricing strategy analysis and margin management"
    - name: "Avg Discount Percent"
      expr: AVG(CAST(discount_percent AS DOUBLE))
      comment: "Average discount percentage applied to orders for pricing governance and margin erosion monitoring"
    - name: "Distinct Orders"
      expr: COUNT(DISTINCT sales_order_id)
      comment: "Number of unique sales orders for order volume and customer engagement analysis"
    - name: "Distinct Products"
      expr: COUNT(DISTINCT material_number)
      comment: "Number of unique products ordered for portfolio breadth and product mix analysis"
    - name: "ATP Confirmed Lines"
      expr: SUM(CASE WHEN atp_ctp_confirmed = TRUE THEN 1 ELSE 0 END)
      comment: "Number of order lines with ATP/CTP confirmation for delivery promise accuracy tracking"
    - name: "Blocked Lines"
      expr: SUM(CASE WHEN delivery_block IS NOT NULL OR billing_block IS NOT NULL THEN 1 ELSE 0 END)
      comment: "Number of order lines with delivery or billing blocks for order management exception tracking"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_order_fulfillment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Delivery schedule performance metrics tracking on-time delivery, fulfillment accuracy, and ATP/CTP commitment reliability. Critical for supply chain KPIs, customer SLA compliance, and operational excellence dashboards."
  source: "`manufacturing_ecm`.`order`.`schedule_line`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing or distribution facility responsible for fulfillment"
    - name: "shipping_point"
      expr: shipping_point
      comment: "Physical shipping location for logistics performance analysis"
    - name: "delivery_block_status"
      expr: CASE WHEN delivery_block_code IS NOT NULL THEN 'Blocked' ELSE 'Clear' END
      comment: "Whether the schedule line is blocked for delivery processing"
    - name: "goods_issue_month"
      expr: DATE_TRUNC('MONTH', goods_issue_date)
      comment: "Month of goods issue for shipment volume and revenue recognition timing analysis"
    - name: "confirmed_delivery_month"
      expr: DATE_TRUNC('MONTH', confirmed_delivery_date)
      comment: "Month of confirmed delivery commitment for capacity planning and customer promise tracking"
  measures:
    - name: "Total Schedule Lines"
      expr: COUNT(1)
      comment: "Total number of delivery schedule lines for fulfillment complexity and split delivery analysis"
    - name: "Total Confirmed Quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity committed for delivery via ATP/CTP checks"
    - name: "Total Delivered Quantity"
      expr: SUM(CAST(delivered_quantity AS DOUBLE))
      comment: "Total quantity physically delivered for fulfillment performance tracking"
    - name: "Total Schedule Line Value"
      expr: SUM(CAST(net_value AS DOUBLE))
      comment: "Total net value of schedule lines for revenue recognition and financial planning"
    - name: "On-Time Delivery Lines"
      expr: SUM(CASE WHEN goods_issue_date <= confirmed_delivery_date THEN 1 ELSE 0 END)
      comment: "Number of schedule lines delivered on or before the confirmed delivery date for OTD KPI calculation"
    - name: "Late Delivery Lines"
      expr: SUM(CASE WHEN goods_issue_date > confirmed_delivery_date THEN 1 ELSE 0 END)
      comment: "Number of schedule lines delivered after the confirmed delivery date for SLA breach tracking"
    - name: "Blocked Schedule Lines"
      expr: SUM(CASE WHEN delivery_block_code IS NOT NULL THEN 1 ELSE 0 END)
      comment: "Number of schedule lines blocked for delivery for exception management and root cause analysis"
    - name: "Distinct Orders"
      expr: COUNT(DISTINCT sales_order_id)
      comment: "Number of unique sales orders with schedule lines for order volume tracking"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_quotation_conversion`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sales quotation effectiveness metrics tracking win rates, quote-to-order conversion, pricing competitiveness, and sales cycle efficiency. Essential for sales leadership, pricing strategy, and revenue pipeline management."
  source: "`manufacturing_ecm`.`order`.`order_quotation`"
  dimensions:
    - name: "quotation_status"
      expr: status
      comment: "Current lifecycle status of the quotation (draft, submitted, accepted, rejected, expired, converted)"
    - name: "quotation_type"
      expr: type
      comment: "Classification of quotation by commercial structure (standard, framework, blanket, project, spot)"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization responsible for the quotation for regional performance analysis"
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Channel through which the quotation was issued for channel effectiveness analysis"
    - name: "fulfillment_mode"
      expr: fulfillment_mode_id
      comment: "Fulfillment strategy quoted (MTO, MTS, ETO, ATO) for lead time and pricing analysis"
    - name: "issue_month"
      expr: DATE_TRUNC('MONTH', issue_date)
      comment: "Month of quotation issuance for time-series pipeline and conversion analysis"
    - name: "win_loss_reason"
      expr: win_loss_reason
      comment: "Categorized reason for quotation acceptance or rejection for competitive intelligence"
  measures:
    - name: "Total Quotations"
      expr: COUNT(1)
      comment: "Total number of quotations issued for sales activity volume tracking"
    - name: "Total Quoted Value"
      expr: SUM(CAST(net_value AS DOUBLE))
      comment: "Total net value of all quotations for pipeline value and revenue forecasting"
    - name: "Total Quoted Gross Value"
      expr: SUM(CAST(gross_value AS DOUBLE))
      comment: "Total gross value before discounts for pricing strategy and discount analysis"
    - name: "Avg Discount Percent"
      expr: AVG(CAST(discount_percentage AS DOUBLE))
      comment: "Average discount percentage across quotations for pricing governance and margin management"
    - name: "Converted Quotations"
      expr: SUM(CASE WHEN status = 'converted' THEN 1 ELSE 0 END)
      comment: "Number of quotations converted to sales orders for win rate calculation"
    - name: "Rejected Quotations"
      expr: SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END)
      comment: "Number of quotations rejected by customers for loss analysis and competitive intelligence"
    - name: "Expired Quotations"
      expr: SUM(CASE WHEN status = 'expired' THEN 1 ELSE 0 END)
      comment: "Number of quotations that expired without customer action for follow-up and pipeline hygiene"
    - name: "Avg Probability Percent"
      expr: AVG(CAST(probability_percent AS DOUBLE))
      comment: "Average sales-estimated win probability for pipeline weighting and forecast accuracy"
    - name: "Distinct Customers"
      expr: COUNT(DISTINCT customer_account_number)
      comment: "Number of unique customers receiving quotations for market reach and customer engagement analysis"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_order_blocks`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Order block and hold management metrics tracking credit holds, export control blocks, quality holds, and resolution efficiency. Critical for order-to-cash risk management, compliance monitoring, and working capital optimization."
  source: "`manufacturing_ecm`.`order`.`order_block`"
  dimensions:
    - name: "block_type"
      expr: type
      comment: "Type of block applied (credit_block, delivery_block, billing_block, export_control_block, quality_hold)"
    - name: "block_status"
      expr: status
      comment: "Current status of the block (active, released, escalated, expired, cancelled)"
    - name: "reason_code"
      expr: reason_code
      comment: "Standardized reason code for why the block was applied for root cause analysis"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization associated with the blocked order for regional compliance tracking"
    - name: "credit_control_area"
      expr: credit_control_area
      comment: "Credit control area responsible for managing credit blocks"
    - name: "applied_month"
      expr: DATE_TRUNC('MONTH', applied_timestamp)
      comment: "Month when the block was applied for time-series exception tracking"
    - name: "is_recurring"
      expr: is_recurring_block
      comment: "Whether this customer or order has experienced the same block type previously"
  measures:
    - name: "Total Blocks"
      expr: COUNT(1)
      comment: "Total number of order blocks applied for exception volume and process health monitoring"
    - name: "Total Blocked Order Value"
      expr: SUM(CAST(order_value_at_block AS DOUBLE))
      comment: "Total value of orders blocked for working capital impact and revenue at risk analysis"
    - name: "Total Credit Exposure"
      expr: SUM(CAST(credit_exposure_amount AS DOUBLE))
      comment: "Total customer credit exposure at time of credit blocks for risk management and collections prioritization"
    - name: "Active Blocks"
      expr: SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END)
      comment: "Number of currently active blocks requiring resolution for operational workload tracking"
    - name: "Released Blocks"
      expr: SUM(CASE WHEN status = 'released' THEN 1 ELSE 0 END)
      comment: "Number of blocks successfully released for resolution effectiveness tracking"
    - name: "Escalated Blocks"
      expr: SUM(CASE WHEN status = 'escalated' THEN 1 ELSE 0 END)
      comment: "Number of blocks escalated to higher authority for complex exception management"
    - name: "Customer Notified Blocks"
      expr: SUM(CASE WHEN customer_notified = TRUE THEN 1 ELSE 0 END)
      comment: "Number of blocks where customer was formally notified for SLA compliance tracking"
    - name: "Distinct Blocked Orders"
      expr: COUNT(DISTINCT sales_order_id)
      comment: "Number of unique sales orders with blocks for order-level exception rate calculation"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_credit_management`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Credit risk and exposure management metrics tracking credit utilization, approval rates, and customer payment behavior. Essential for CFO dashboards, credit policy effectiveness, and accounts receivable risk management."
  source: "`manufacturing_ecm`.`order`.`credit_check`"
  dimensions:
    - name: "check_result"
      expr: result
      comment: "Outcome of the credit check (approved, blocked, warning) for approval rate analysis"
    - name: "check_type"
      expr: check_type
      comment: "Method of credit check (static, dynamic, manual) for process efficiency analysis"
    - name: "risk_category"
      expr: risk_category
      comment: "Customer risk classification at time of check for risk-based portfolio segmentation"
    - name: "credit_control_area"
      expr: credit_control_area
      comment: "Organizational unit managing credit for multi-entity credit policy analysis"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization for regional credit performance tracking"
    - name: "check_month"
      expr: DATE_TRUNC('MONTH', check_date)
      comment: "Month of credit check for time-series credit risk and exposure trending"
    - name: "override_flag"
      expr: override_flag
      comment: "Whether the automated check result was manually overridden for governance and audit tracking"
  measures:
    - name: "Total Credit Checks"
      expr: COUNT(1)
      comment: "Total number of credit checks performed for credit management workload and process volume"
    - name: "Total Order Value Checked"
      expr: SUM(CAST(order_value_amount AS DOUBLE))
      comment: "Total value of orders subject to credit checks for revenue at risk analysis"
    - name: "Total Credit Exposure"
      expr: SUM(CAST(current_exposure_amount AS DOUBLE))
      comment: "Total customer credit exposure across all checks for portfolio risk assessment"
    - name: "Total Credit Limit"
      expr: SUM(CAST(credit_limit_amount AS DOUBLE))
      comment: "Total approved credit limits for credit capacity and policy effectiveness analysis"
    - name: "Total Available Credit"
      expr: SUM(CAST(available_credit_amount AS DOUBLE))
      comment: "Total remaining credit available to customers for credit headroom and capacity planning"
    - name: "Total Open Receivables"
      expr: SUM(CAST(open_receivables_amount AS DOUBLE))
      comment: "Total outstanding accounts receivable included in exposure calculations for collections prioritization"
    - name: "Approved Checks"
      expr: SUM(CASE WHEN result = 'approved' THEN 1 ELSE 0 END)
      comment: "Number of credit checks approved for approval rate and credit policy effectiveness"
    - name: "Blocked Checks"
      expr: SUM(CASE WHEN result = 'blocked' THEN 1 ELSE 0 END)
      comment: "Number of credit checks resulting in blocks for credit risk and exception management"
    - name: "Overridden Checks"
      expr: SUM(CASE WHEN override_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of checks with manual overrides for governance and segregation of duties compliance"
    - name: "Avg Credit Utilization Percent"
      expr: AVG(CAST(utilization_percent AS DOUBLE))
      comment: "Average credit limit utilization percentage for portfolio risk and credit policy calibration"
    - name: "Distinct Customers Checked"
      expr: COUNT(DISTINCT customer_account_number)
      comment: "Number of unique customers subject to credit checks for customer risk portfolio analysis"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_export_compliance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Export control and trade compliance metrics tracking license requirements, denied party screening, embargo checks, and regulatory clearance efficiency. Critical for Chief Compliance Officer dashboards, regulatory audit readiness, and international trade risk management."
  source: "`manufacturing_ecm`.`order`.`export_control_check`"
  dimensions:
    - name: "check_status"
      expr: status
      comment: "Current status of export control check (cleared, blocked, pending_review, expired, cancelled)"
    - name: "regulatory_framework"
      expr: regulatory_framework
      comment: "Primary export control regulation governing the check (EAR, ITAR, EU_DUAL_USE, UK_OGEL)"
    - name: "destination_country"
      expr: destination_country_code
      comment: "Destination country for export for country-level risk and compliance analysis"
    - name: "license_required"
      expr: license_required_flag
      comment: "Whether an export license is required for this shipment"
    - name: "denied_party_result"
      expr: denied_party_screening_result
      comment: "Result of denied party screening (pass, fail, potential_match, not_applicable)"
    - name: "embargo_result"
      expr: embargo_check_result
      comment: "Result of embargo screening (pass, fail, not_applicable)"
    - name: "risk_classification"
      expr: risk_classification
      comment: "Risk level assigned to the export transaction (low, medium, high, critical)"
    - name: "check_month"
      expr: DATE_TRUNC('MONTH', check_date)
      comment: "Month of export control check for time-series compliance and workload analysis"
  measures:
    - name: "Total Export Checks"
      expr: COUNT(1)
      comment: "Total number of export control checks performed for compliance workload and process volume"
    - name: "Cleared Checks"
      expr: SUM(CASE WHEN status = 'cleared' THEN 1 ELSE 0 END)
      comment: "Number of export checks cleared for shipment for compliance approval rate tracking"
    - name: "Blocked Checks"
      expr: SUM(CASE WHEN status = 'blocked' THEN 1 ELSE 0 END)
      comment: "Number of export checks blocked for regulatory risk and exception management"
    - name: "Pending Review Checks"
      expr: SUM(CASE WHEN status = 'pending_review' THEN 1 ELSE 0 END)
      comment: "Number of checks requiring manual analyst review for compliance workload and SLA tracking"
    - name: "License Required Checks"
      expr: SUM(CASE WHEN license_required_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of shipments requiring export licenses for license management and lead time planning"
    - name: "Denied Party Failures"
      expr: SUM(CASE WHEN denied_party_screening_result = 'fail' THEN 1 ELSE 0 END)
      comment: "Number of checks failing denied party screening for regulatory risk and customer due diligence"
    - name: "Embargo Failures"
      expr: SUM(CASE WHEN embargo_check_result = 'fail' THEN 1 ELSE 0 END)
      comment: "Number of checks failing embargo screening for sanctions compliance and trade risk"
    - name: "Manual Overrides"
      expr: SUM(CASE WHEN override_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of checks with manual overrides for governance and audit trail compliance"
    - name: "Recheck Required"
      expr: SUM(CASE WHEN recheck_required_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of checks requiring re-screening due to changes for compliance process efficiency"
    - name: "Distinct Orders Checked"
      expr: COUNT(DISTINCT sales_order_id)
      comment: "Number of unique sales orders subject to export control checks for order-level compliance coverage"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_returns_management`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer returns and reverse logistics metrics tracking return rates, return reasons, credit memo processing, and warranty claim patterns. Essential for quality management, customer satisfaction analysis, and reverse supply chain optimization."
  source: "`manufacturing_ecm`.`order`.`returns_order`"
  dimensions:
    - name: "return_status"
      expr: status
      comment: "Current lifecycle status of the return order for returns processing pipeline visibility"
    - name: "return_reason"
      expr: return_reason_code
      comment: "Standardized reason code for the return (defective, wrong_item, over_delivery, warranty_return) for root cause analysis"
    - name: "material_condition"
      expr: material_condition_code
      comment: "Physical condition of returned material (new, used, damaged, defective) for disposition routing"
    - name: "disposition_code"
      expr: disposition_code
      comment: "Final disposition decision (restock, scrap, refurbish, vendor_return) for reverse logistics efficiency"
    - name: "return_plant"
      expr: return_plant_code
      comment: "Facility receiving and processing the return for regional returns management analysis"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization for regional returns rate and quality performance tracking"
    - name: "warranty_claim"
      expr: warranty_claim_flag
      comment: "Whether the return is associated with a warranty claim for warranty cost and quality analysis"
    - name: "return_month"
      expr: DATE_TRUNC('MONTH', order_date)
      comment: "Month of return order creation for time-series returns rate and quality trending"
  measures:
    - name: "Total Returns"
      expr: COUNT(1)
      comment: "Total number of customer return orders for returns volume and reverse logistics workload"
    - name: "Total Return Quantity"
      expr: SUM(CAST(return_quantity AS DOUBLE))
      comment: "Total quantity of material returned by customers for returns rate and quality impact analysis"
    - name: "Total Return Value"
      expr: SUM(CAST(net_return_value AS DOUBLE))
      comment: "Total net value of returns for revenue impact and warranty cost analysis"
    - name: "Total Restocking Fees"
      expr: SUM(CAST(restocking_fee AS DOUBLE))
      comment: "Total restocking fees charged to customers for returns cost recovery and policy effectiveness"
    - name: "Warranty Returns"
      expr: SUM(CASE WHEN warranty_claim_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of returns associated with warranty claims for warranty cost and product quality tracking"
    - name: "Inspection Required Returns"
      expr: SUM(CASE WHEN inspection_required_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of returns requiring quality inspection for quality management workload and process efficiency"
    - name: "Credit Memo Requested Returns"
      expr: SUM(CASE WHEN credit_memo_request_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of returns triggering credit memo requests for accounts receivable and customer refund processing"
    - name: "Distinct Returned Products"
      expr: COUNT(DISTINCT material_number)
      comment: "Number of unique products returned for product quality and design issue identification"
    - name: "Distinct Original Orders"
      expr: COUNT(DISTINCT sales_order_id)
      comment: "Number of unique original sales orders with returns for order-level returns rate calculation"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_pricing_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Pricing condition and discount effectiveness metrics tracking discount depth, pricing variance, and margin leakage. Critical for pricing strategy, margin management, and commercial policy governance."
  source: "`manufacturing_ecm`.`order`.`pricing_condition`"
  dimensions:
    - name: "condition_type"
      expr: condition_type_code
      comment: "SAP condition type code identifying the pricing element (price, discount, surcharge, freight, tax)"
    - name: "condition_category"
      expr: condition_category
      comment: "High-level classification (price, discount, surcharge, freight, tax, rebate, bonus)"
    - name: "condition_origin"
      expr: condition_origin
      comment: "How the condition was determined (automatic, manual, contract, promotion, intercompany)"
    - name: "condition_status"
      expr: condition_status
      comment: "Lifecycle status of the condition (active, inactive, deleted, blocked, statistical)"
    - name: "price_list_type"
      expr: price_list_type
      comment: "Price list category (wholesale, retail, OEM, distributor, export) for pricing strategy analysis"
    - name: "is_manual_entry"
      expr: manual_entry_allowed
      comment: "Whether the condition value can be manually overridden for pricing governance tracking"
    - name: "pricing_month"
      expr: DATE_TRUNC('MONTH', pricing_date)
      comment: "Month of pricing determination for time-series pricing and margin analysis"
  measures:
    - name: "Total Pricing Conditions"
      expr: COUNT(1)
      comment: "Total number of pricing conditions applied for pricing complexity and process efficiency analysis"
    - name: "Total Condition Value"
      expr: SUM(CAST(condition_value AS DOUBLE))
      comment: "Total monetary value of all pricing conditions for pricing impact and margin analysis"
    - name: "Total Condition Base Value"
      expr: SUM(CAST(condition_base_value AS DOUBLE))
      comment: "Total base amount upon which conditions are applied for pricing structure analysis"
    - name: "Avg Condition Rate"
      expr: AVG(CAST(condition_rate AS DOUBLE))
      comment: "Average rate or percentage across conditions for pricing strategy and discount depth analysis"
    - name: "Active Conditions"
      expr: SUM(CASE WHEN condition_status = 'active' THEN 1 ELSE 0 END)
      comment: "Number of active pricing conditions applied to orders for pricing policy effectiveness"
    - name: "Manual Conditions"
      expr: SUM(CASE WHEN condition_origin = 'manual' THEN 1 ELSE 0 END)
      comment: "Number of manually entered pricing conditions for pricing governance and exception tracking"
    - name: "Contract-Based Conditions"
      expr: SUM(CASE WHEN condition_origin = 'contract' THEN 1 ELSE 0 END)
      comment: "Number of conditions derived from contracts for contract compliance and pricing accuracy"
    - name: "Distinct Orders"
      expr: COUNT(DISTINCT sales_order_id)
      comment: "Number of unique sales orders with pricing conditions for order-level pricing analysis"
    - name: "Distinct Quotations"
      expr: COUNT(DISTINCT order_quotation_id)
      comment: "Number of unique quotations with pricing conditions for quotation pricing analysis"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_atp_commitment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Available-to-Promise and Capable-to-Promise commitment metrics tracking delivery promise accuracy, backorder rates, and ATP/CTP confirmation reliability. Essential for supply chain planning, customer promise management, and inventory optimization."
  source: "`manufacturing_ecm`.`order`.`atp_commitment`"
  dimensions:
    - name: "commitment_type"
      expr: commitment_type
      comment: "Whether delivery promise was generated via ATP (stock-based) or CTP (capacity-based) logic"
    - name: "commitment_status"
      expr: status
      comment: "Current status of the ATP/CTP commitment (confirmed, superseded, cancelled)"
    - name: "fulfillment_mode"
      expr: fulfillment_mode_id
      comment: "Fulfillment strategy (MTS uses ATP, MTO uses CTP) for mode-specific promise accuracy"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing or distribution facility for plant-level ATP/CTP performance analysis"
    - name: "checking_rule"
      expr: checking_rule
      comment: "SAP checking rule applied during ATP/CTP check for availability logic analysis"
    - name: "partial_delivery_allowed"
      expr: partial_delivery_allowed
      comment: "Whether customer accepts partial deliveries for split shipment and backorder analysis"
    - name: "commitment_month"
      expr: DATE_TRUNC('MONTH', confirmed_delivery_date)
      comment: "Month of confirmed delivery commitment for capacity planning and demand forecasting"
  measures:
    - name: "Total Commitments"
      expr: COUNT(1)
      comment: "Total number of ATP/CTP commitments generated for delivery promise volume and process efficiency"
    - name: "Total Requested Quantity"
      expr: SUM(CAST(requested_quantity AS DOUBLE))
      comment: "Total quantity requested by customers for demand planning and capacity analysis"
    - name: "Total Confirmed Quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed by ATP/CTP engine for firm manufacturing and delivery commitments"
    - name: "Total Backorder Quantity"
      expr: SUM(CAST(backorder_quantity AS DOUBLE))
      comment: "Total quantity placed on backorder due to insufficient availability for backlog management"
    - name: "Total ATP Quantity"
      expr: SUM(CAST(atp_quantity AS DOUBLE))
      comment: "Total net ATP quantity calculated by SAP ATP engine for inventory availability analysis"
    - name: "Total Cumulative ATP Quantity"
      expr: SUM(CAST(cumulative_atp_quantity AS DOUBLE))
      comment: "Total cumulative ATP across planning periods for time-phased availability analysis"
    - name: "Full Confirmations"
      expr: SUM(CASE WHEN confirmed_quantity >= requested_quantity THEN 1 ELSE 0 END)
      comment: "Number of commitments with full quantity confirmation for promise accuracy and customer satisfaction"
    - name: "Partial Confirmations"
      expr: SUM(CASE WHEN confirmed_quantity < requested_quantity AND confirmed_quantity > 0 THEN 1 ELSE 0 END)
      comment: "Number of commitments with partial quantity confirmation for backorder and split delivery analysis"
    - name: "Zero Confirmations"
      expr: SUM(CASE WHEN confirmed_quantity = 0 THEN 1 ELSE 0 END)
      comment: "Number of commitments with no quantity confirmed for stockout and capacity constraint analysis"
    - name: "Distinct Orders"
      expr: COUNT(DISTINCT sales_order_id)
      comment: "Number of unique sales orders with ATP/CTP commitments for order-level promise tracking"
$$;