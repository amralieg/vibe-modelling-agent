-- Metric views for domain: procurement | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_procurement_spend`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core procurement spend analytics tracking total spend, maverick spend, contract compliance, and savings realization across suppliers, categories, and organizational units"
  source: "`manufacturing_ecm`.`procurement`.`spend_transaction`"
  dimensions:
    - name: "category_code"
      expr: category_code
      comment: "Spend category code for classification"
    - name: "supplier_code"
      expr: supplier_code
      comment: "Supplier identifier"
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity"
    - name: "country_code"
      expr: country_code
      comment: "Country of transaction"
    - name: "procurement_type"
      expr: procurement_type
      comment: "Type of procurement (direct, indirect, services)"
    - name: "is_contract_backed"
      expr: is_contract_backed
      comment: "Whether spend is backed by a contract"
    - name: "is_maverick_spend"
      expr: is_maverick_spend
      comment: "Whether spend is maverick (off-contract)"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of transaction"
    - name: "transaction_type"
      expr: transaction_type
      comment: "Type of spend transaction"
    - name: "material_group"
      expr: material_group
      comment: "Material group classification"
    - name: "document_date"
      expr: document_date
      comment: "Date of transaction document"
  measures:
    - name: "total_spend_amount"
      expr: SUM(CAST(spend_amount AS DOUBLE))
      comment: "Total procurement spend amount - primary KPI for spend visibility and budget tracking"
    - name: "maverick_spend_amount"
      expr: SUM(CASE WHEN is_maverick_spend = TRUE THEN CAST(spend_amount AS DOUBLE) ELSE 0 END)
      comment: "Total maverick (off-contract) spend - critical for compliance and cost control"
    - name: "contract_backed_spend_amount"
      expr: SUM(CASE WHEN is_contract_backed = TRUE THEN CAST(spend_amount AS DOUBLE) ELSE 0 END)
      comment: "Total contract-backed spend - measures procurement compliance and leverage"
    - name: "total_savings_amount"
      expr: SUM(CAST(savings_amount AS DOUBLE))
      comment: "Total realized savings from procurement initiatives - key value delivery metric"
    - name: "total_quantity"
      expr: SUM(CAST(quantity AS DOUBLE))
      comment: "Total quantity procured across all transactions"
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount paid - important for financial reconciliation"
    - name: "transaction_count"
      expr: COUNT(1)
      comment: "Total number of spend transactions - measures procurement activity volume"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT supplier_code)
      comment: "Number of unique suppliers - measures supplier base concentration and diversification"
    - name: "unique_category_count"
      expr: COUNT(DISTINCT category_code)
      comment: "Number of unique spend categories - measures spend portfolio breadth"
    - name: "avg_transaction_value"
      expr: AVG(CAST(spend_amount AS DOUBLE))
      comment: "Average spend per transaction - indicates transaction size patterns"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_supplier_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Supplier performance scorecard tracking on-time delivery, quality, fill rate, and overall ratings to drive supplier management decisions"
  source: "`manufacturing_ecm`.`procurement`.`procurement_supplier_performance`"
  dimensions:
    - name: "category_name"
      expr: category_name
      comment: "Spend category name"
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "country_code"
      expr: country_code
      comment: "Country of supplier site"
    - name: "performance_tier"
      expr: performance_tier
      comment: "Supplier performance tier classification (e.g., Tier 1, Tier 2)"
    - name: "evaluation_period_type"
      expr: evaluation_period_type
      comment: "Type of evaluation period (monthly, quarterly, annual)"
    - name: "scorecard_type"
      expr: scorecard_type
      comment: "Type of supplier scorecard"
    - name: "preferred_supplier_flag"
      expr: preferred_supplier_flag
      comment: "Whether supplier is designated as preferred"
    - name: "improvement_plan_required_flag"
      expr: improvement_plan_required_flag
      comment: "Whether supplier requires improvement plan"
    - name: "requalification_required_flag"
      expr: requalification_required_flag
      comment: "Whether supplier requires requalification"
    - name: "evaluation_period_start_date"
      expr: evaluation_period_start_date
      comment: "Start date of evaluation period"
    - name: "evaluation_period_end_date"
      expr: evaluation_period_end_date
      comment: "End date of evaluation period"
  measures:
    - name: "avg_on_time_delivery_rate"
      expr: AVG(CAST(on_time_delivery_rate AS DOUBLE))
      comment: "Average on-time delivery rate percentage - critical KPI for supply chain reliability"
    - name: "avg_fill_rate"
      expr: AVG(CAST(fill_rate AS DOUBLE))
      comment: "Average fill rate percentage - measures supplier ability to fulfill orders completely"
    - name: "avg_quality_ppm"
      expr: AVG(CAST(quality_ppm AS DOUBLE))
      comment: "Average quality defects in parts per million - key quality performance indicator"
    - name: "avg_overall_rating"
      expr: AVG(CAST(overall_rating AS DOUBLE))
      comment: "Average overall supplier rating - composite performance score for supplier ranking"
    - name: "avg_invoice_accuracy_rate"
      expr: AVG(CAST(invoice_accuracy_rate AS DOUBLE))
      comment: "Average invoice accuracy rate - measures billing quality and reduces AP workload"
    - name: "avg_responsiveness_score"
      expr: AVG(CAST(responsiveness_score AS DOUBLE))
      comment: "Average responsiveness score - measures supplier communication and issue resolution"
    - name: "total_spend_amount"
      expr: SUM(CAST(spend_amount AS DOUBLE))
      comment: "Total spend with evaluated suppliers - links performance to spend volume"
    - name: "total_rejected_quantity"
      expr: SUM(CAST(rejected_quantity AS DOUBLE))
      comment: "Total quantity rejected due to quality issues - measures quality impact"
    - name: "total_received_quantity"
      expr: SUM(CAST(total_received_quantity AS DOUBLE))
      comment: "Total quantity received from suppliers"
    - name: "supplier_count"
      expr: COUNT(1)
      comment: "Number of supplier performance evaluations"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT procurement_supplier_id)
      comment: "Number of unique suppliers evaluated"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_purchase_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Purchase order execution metrics tracking order value, quantity fulfillment, delivery performance, and invoice matching to optimize procurement operations"
  source: "`manufacturing_ecm`.`procurement`.`procurement_po_line_item`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "material_group"
      expr: material_group
      comment: "Material group classification"
    - name: "item_category"
      expr: item_category
      comment: "PO line item category"
    - name: "account_assignment_category"
      expr: account_assignment_category
      comment: "Account assignment category (cost center, asset, project)"
    - name: "status"
      expr: status
      comment: "PO line item status"
    - name: "goods_receipt_status"
      expr: goods_receipt_status
      comment: "Goods receipt status"
    - name: "invoice_status"
      expr: invoice_status
      comment: "Invoice verification status"
    - name: "deletion_indicator"
      expr: deletion_indicator
      comment: "Whether line item is marked for deletion"
    - name: "final_delivery_indicator"
      expr: final_delivery_indicator
      comment: "Whether final delivery has been made"
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "Country of origin for materials"
    - name: "scheduled_delivery_date"
      expr: scheduled_delivery_date
      comment: "Scheduled delivery date"
  measures:
    - name: "total_order_value"
      expr: SUM(CAST(net_order_value AS DOUBLE))
      comment: "Total net order value - primary KPI for PO spend commitment"
    - name: "total_ordered_quantity"
      expr: SUM(CAST(ordered_quantity AS DOUBLE))
      comment: "Total quantity ordered across all PO lines"
    - name: "total_goods_receipt_quantity"
      expr: SUM(CAST(goods_receipt_quantity AS DOUBLE))
      comment: "Total quantity received - measures order fulfillment"
    - name: "total_invoiced_quantity"
      expr: SUM(CAST(invoiced_quantity AS DOUBLE))
      comment: "Total quantity invoiced - tracks billing progress"
    - name: "avg_net_price"
      expr: AVG(CAST(net_price AS DOUBLE))
      comment: "Average net price per unit - indicates pricing trends"
    - name: "avg_overdelivery_tolerance_pct"
      expr: AVG(CAST(overdelivery_tolerance_pct AS DOUBLE))
      comment: "Average overdelivery tolerance percentage"
    - name: "avg_underdelivery_tolerance_pct"
      expr: AVG(CAST(underdelivery_tolerance_pct AS DOUBLE))
      comment: "Average underdelivery tolerance percentage"
    - name: "po_line_count"
      expr: COUNT(1)
      comment: "Total number of PO line items - measures procurement activity"
    - name: "unique_po_count"
      expr: COUNT(DISTINCT po_number)
      comment: "Number of unique purchase orders"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT procurement_purchase_order_id)
      comment: "Number of unique purchase orders (proxy for supplier diversity)"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_goods_receipt`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Goods receipt performance tracking on-time delivery, receipt value, quality inspection, and three-way match status to optimize inbound logistics"
  source: "`manufacturing_ecm`.`procurement`.`procurement_goods_receipt`"
  dimensions:
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity"
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "Country of origin for received goods"
    - name: "movement_type"
      expr: movement_type
      comment: "SAP movement type for goods receipt"
    - name: "status"
      expr: status
      comment: "Goods receipt status"
    - name: "quality_inspection_status"
      expr: quality_inspection_status
      comment: "Quality inspection status"
    - name: "three_way_match_status"
      expr: three_way_match_status
      comment: "Three-way match status (PO-GR-Invoice)"
    - name: "gr_ir_clearing_status"
      expr: gr_ir_clearing_status
      comment: "GR/IR clearing account status"
    - name: "on_time_delivery_flag"
      expr: on_time_delivery_flag
      comment: "Whether delivery was on time"
    - name: "is_return_delivery"
      expr: is_return_delivery
      comment: "Whether this is a return delivery"
    - name: "is_reversal"
      expr: is_reversal
      comment: "Whether this is a reversal transaction"
    - name: "quality_inspection_required"
      expr: quality_inspection_required
      comment: "Whether quality inspection is required"
    - name: "hazardous_material_flag"
      expr: hazardous_material_flag
      comment: "Whether goods are hazardous materials"
    - name: "posting_date"
      expr: posting_date
      comment: "Posting date of goods receipt"
    - name: "scheduled_delivery_date"
      expr: scheduled_delivery_date
      comment: "Scheduled delivery date"
  measures:
    - name: "total_gr_value"
      expr: SUM(CAST(total_gr_value AS DOUBLE))
      comment: "Total goods receipt value - measures inbound material value"
    - name: "avg_exchange_rate"
      expr: AVG(CAST(exchange_rate AS DOUBLE))
      comment: "Average exchange rate for foreign currency receipts"
    - name: "goods_receipt_count"
      expr: COUNT(1)
      comment: "Total number of goods receipts - measures inbound activity volume"
    - name: "on_time_delivery_count"
      expr: SUM(CASE WHEN on_time_delivery_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of on-time deliveries - key supplier performance metric"
    - name: "late_delivery_count"
      expr: SUM(CASE WHEN on_time_delivery_flag = FALSE THEN 1 ELSE 0 END)
      comment: "Number of late deliveries - measures delivery reliability issues"
    - name: "return_delivery_count"
      expr: SUM(CASE WHEN is_return_delivery = TRUE THEN 1 ELSE 0 END)
      comment: "Number of return deliveries - indicates quality or specification issues"
    - name: "reversal_count"
      expr: SUM(CASE WHEN is_reversal = TRUE THEN 1 ELSE 0 END)
      comment: "Number of reversal transactions - measures transaction errors"
    - name: "quality_inspection_required_count"
      expr: SUM(CASE WHEN quality_inspection_required = TRUE THEN 1 ELSE 0 END)
      comment: "Number of receipts requiring quality inspection"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT supplier_number)
      comment: "Number of unique suppliers with goods receipts"
    - name: "unique_po_count"
      expr: COUNT(DISTINCT purchase_order_number)
      comment: "Number of unique purchase orders received against"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_sourcing_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sourcing event effectiveness tracking estimated vs awarded spend, savings realization, supplier participation, and cycle time to optimize strategic sourcing"
  source: "`manufacturing_ecm`.`procurement`.`procurement_sourcing_event`"
  dimensions:
    - name: "event_type"
      expr: event_type
      comment: "Type of sourcing event (RFQ, RFP, auction)"
    - name: "category_code"
      expr: category_code
      comment: "Spend category code"
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity"
    - name: "country_code"
      expr: country_code
      comment: "Country of sourcing event"
    - name: "status"
      expr: status
      comment: "Sourcing event status"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of sourcing event"
    - name: "sourcing_strategy"
      expr: sourcing_strategy
      comment: "Sourcing strategy employed"
    - name: "procurement_type"
      expr: procurement_type
      comment: "Type of procurement (direct, indirect, services)"
    - name: "is_multi_round"
      expr: is_multi_round
      comment: "Whether event has multiple bidding rounds"
    - name: "is_reverse_auction"
      expr: is_reverse_auction
      comment: "Whether event is a reverse auction"
    - name: "reach_compliance_required"
      expr: reach_compliance_required
      comment: "Whether REACH compliance is required"
    - name: "rohs_compliance_required"
      expr: rohs_compliance_required
      comment: "Whether RoHS compliance is required"
    - name: "conflict_minerals_applicable"
      expr: conflict_minerals_applicable
      comment: "Whether conflict minerals reporting applies"
    - name: "publish_date"
      expr: publish_date
      comment: "Date event was published to suppliers"
    - name: "bid_close_date"
      expr: bid_close_date
      comment: "Date bidding closed"
    - name: "award_decision_date"
      expr: award_decision_date
      comment: "Date award decision was made"
  measures:
    - name: "total_estimated_spend"
      expr: SUM(CAST(estimated_spend_amount AS DOUBLE))
      comment: "Total estimated spend for sourcing events - measures sourcing pipeline value"
    - name: "total_awarded_value"
      expr: SUM(CAST(awarded_value AS DOUBLE))
      comment: "Total awarded value - measures actual sourcing outcomes"
    - name: "total_realized_savings"
      expr: SUM(CAST(realized_savings_amount AS DOUBLE))
      comment: "Total realized savings from sourcing events - key value delivery metric"
    - name: "total_target_savings"
      expr: SUM(CAST(target_savings_amount AS DOUBLE))
      comment: "Total target savings - measures savings goals"
    - name: "total_baseline_price"
      expr: SUM(CAST(baseline_price_amount AS DOUBLE))
      comment: "Total baseline price before sourcing - used for savings calculation"
    - name: "avg_invited_supplier_count"
      expr: AVG(CAST(invited_supplier_count AS DOUBLE))
      comment: "Average number of suppliers invited per event - measures competition breadth"
    - name: "avg_responding_supplier_count"
      expr: AVG(CAST(responding_supplier_count AS DOUBLE))
      comment: "Average number of responding suppliers - measures supplier engagement"
    - name: "avg_awarded_supplier_count"
      expr: AVG(CAST(awarded_supplier_count AS DOUBLE))
      comment: "Average number of suppliers awarded - measures award split strategy"
    - name: "sourcing_event_count"
      expr: COUNT(1)
      comment: "Total number of sourcing events - measures strategic sourcing activity"
    - name: "unique_category_count"
      expr: COUNT(DISTINCT category_code)
      comment: "Number of unique categories sourced - measures sourcing coverage"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_contract`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Contract management metrics tracking total contract value, released value, utilization, compliance requirements, and renewal status to optimize contract portfolio"
  source: "`manufacturing_ecm`.`procurement`.`procurement_contract`"
  dimensions:
    - name: "type"
      expr: type
      comment: "Contract type"
    - name: "status"
      expr: status
      comment: "Contract status"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of contract"
    - name: "category_code"
      expr: category_code
      comment: "Spend category code"
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "country_code"
      expr: country_code
      comment: "Country of contract"
    - name: "procurement_type"
      expr: procurement_type
      comment: "Type of procurement (direct, indirect, services)"
    - name: "auto_renewal_flag"
      expr: auto_renewal_flag
      comment: "Whether contract auto-renews"
    - name: "penalty_clause_flag"
      expr: penalty_clause_flag
      comment: "Whether contract has penalty clauses"
    - name: "reach_compliance_required"
      expr: reach_compliance_required
      comment: "Whether REACH compliance is required"
    - name: "rohs_compliance_required"
      expr: rohs_compliance_required
      comment: "Whether RoHS compliance is required"
    - name: "effective_start_date"
      expr: effective_start_date
      comment: "Contract effective start date"
    - name: "effective_end_date"
      expr: effective_end_date
      comment: "Contract effective end date"
    - name: "termination_date"
      expr: termination_date
      comment: "Contract termination date if terminated"
  measures:
    - name: "total_contract_value"
      expr: SUM(CAST(total_contract_value AS DOUBLE))
      comment: "Total contract value - measures committed spend under contract"
    - name: "total_released_value"
      expr: SUM(CAST(released_value AS DOUBLE))
      comment: "Total released value - measures actual spend against contracts"
    - name: "total_minimum_order_value"
      expr: SUM(CAST(minimum_order_value AS DOUBLE))
      comment: "Total minimum order value commitments"
    - name: "contract_count"
      expr: COUNT(1)
      comment: "Total number of contracts - measures contract portfolio size"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT supplier_code)
      comment: "Number of unique suppliers under contract - measures supplier base coverage"
    - name: "auto_renewal_contract_count"
      expr: SUM(CASE WHEN auto_renewal_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of auto-renewing contracts - measures renewal risk exposure"
    - name: "penalty_clause_contract_count"
      expr: SUM(CASE WHEN penalty_clause_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of contracts with penalty clauses - measures contractual risk"
    - name: "reach_compliance_contract_count"
      expr: SUM(CASE WHEN reach_compliance_required = TRUE THEN 1 ELSE 0 END)
      comment: "Number of contracts requiring REACH compliance"
    - name: "rohs_compliance_contract_count"
      expr: SUM(CASE WHEN rohs_compliance_required = TRUE THEN 1 ELSE 0 END)
      comment: "Number of contracts requiring RoHS compliance"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_supplier_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Supplier invoice processing metrics tracking gross/net amounts, payment discounts, variances, three-way match status, and payment blocks to optimize AP efficiency"
  source: "`manufacturing_ecm`.`procurement`.`procurement_supplier_invoice`"
  dimensions:
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity"
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "supplier_code"
      expr: supplier_code
      comment: "Supplier identifier"
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of invoice"
    - name: "status"
      expr: status
      comment: "Invoice status"
    - name: "three_way_match_status"
      expr: three_way_match_status
      comment: "Three-way match status (PO-GR-Invoice)"
    - name: "is_payment_blocked"
      expr: is_payment_blocked
      comment: "Whether payment is blocked"
    - name: "is_duplicate"
      expr: is_duplicate
      comment: "Whether invoice is flagged as duplicate"
    - name: "payment_method"
      expr: payment_method
      comment: "Payment method"
    - name: "payment_block_reason"
      expr: payment_block_reason
      comment: "Reason for payment block"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of invoice"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period of invoice"
    - name: "posting_date"
      expr: posting_date
      comment: "Posting date of invoice"
    - name: "baseline_date"
      expr: baseline_date
      comment: "Baseline date for payment terms"
    - name: "early_payment_discount_date"
      expr: early_payment_discount_date
      comment: "Date by which early payment discount applies"
  measures:
    - name: "total_gross_amount"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross invoice amount - measures total AP liability"
    - name: "total_net_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net invoice amount after discounts - measures actual payment obligation"
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount - important for tax reconciliation"
    - name: "total_withholding_tax_amount"
      expr: SUM(CAST(withholding_tax_amount AS DOUBLE))
      comment: "Total withholding tax amount - measures tax withholding obligations"
    - name: "total_early_payment_discount"
      expr: SUM(CAST(early_payment_discount_amount AS DOUBLE))
      comment: "Total early payment discount available - measures cash management opportunity"
    - name: "total_price_variance"
      expr: SUM(CAST(price_variance_amount AS DOUBLE))
      comment: "Total price variance - measures pricing discrepancies vs PO"
    - name: "total_quantity_variance"
      expr: SUM(CAST(quantity_variance_amount AS DOUBLE))
      comment: "Total quantity variance - measures quantity discrepancies vs GR"
    - name: "invoice_count"
      expr: COUNT(1)
      comment: "Total number of invoices - measures AP processing volume"
    - name: "blocked_invoice_count"
      expr: SUM(CASE WHEN is_payment_blocked = TRUE THEN 1 ELSE 0 END)
      comment: "Number of blocked invoices - measures payment processing issues"
    - name: "duplicate_invoice_count"
      expr: SUM(CASE WHEN is_duplicate = TRUE THEN 1 ELSE 0 END)
      comment: "Number of duplicate invoices - measures invoice control effectiveness"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT supplier_code)
      comment: "Number of unique suppliers invoicing - measures supplier base activity"
    - name: "unique_po_count"
      expr: COUNT(DISTINCT po_number)
      comment: "Number of unique purchase orders invoiced against"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_purchase_requisition`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Purchase requisition processing metrics tracking estimated value, approval status, conversion to PO, and cycle time to optimize procurement request-to-order process"
  source: "`manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`"
  dimensions:
    - name: "requisition_type"
      expr: requisition_type
      comment: "Type of purchase requisition"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of requisition"
    - name: "status"
      expr: status
      comment: "Requisition status"
    - name: "purchasing_org"
      expr: purchasing_org
      comment: "Purchasing organization"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity"
    - name: "procurement_type"
      expr: procurement_type
      comment: "Type of procurement (direct, indirect, services)"
    - name: "item_category"
      expr: item_category
      comment: "Item category"
    - name: "account_assignment_category"
      expr: account_assignment_category
      comment: "Account assignment category (cost center, asset, project)"
    - name: "material_group"
      expr: material_group
      comment: "Material group classification"
    - name: "converted_to_po_flag"
      expr: converted_to_po_flag
      comment: "Whether requisition has been converted to PO"
    - name: "fixed_source_indicator"
      expr: fixed_source_indicator
      comment: "Whether requisition has fixed source of supply"
    - name: "source_of_demand"
      expr: source_of_demand
      comment: "Source of demand (MRP, manual, etc.)"
    - name: "requisition_date"
      expr: requisition_date
      comment: "Date requisition was created"
    - name: "required_delivery_date"
      expr: required_delivery_date
      comment: "Required delivery date"
    - name: "release_date"
      expr: release_date
      comment: "Date requisition was released"
  measures:
    - name: "total_estimated_value"
      expr: SUM(CAST(estimated_value AS DOUBLE))
      comment: "Total estimated value of requisitions - measures procurement demand pipeline"
    - name: "total_requested_quantity"
      expr: SUM(CAST(requested_quantity AS DOUBLE))
      comment: "Total quantity requested across all requisitions"
    - name: "avg_valuation_price"
      expr: AVG(CAST(valuation_price AS DOUBLE))
      comment: "Average valuation price per unit - indicates cost estimation accuracy"
    - name: "requisition_count"
      expr: COUNT(1)
      comment: "Total number of requisition line items - measures procurement request volume"
    - name: "unique_requisition_count"
      expr: COUNT(DISTINCT requisition_number)
      comment: "Number of unique requisitions"
    - name: "converted_to_po_count"
      expr: SUM(CASE WHEN converted_to_po_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of requisitions converted to PO - measures conversion efficiency"
    - name: "pending_conversion_count"
      expr: SUM(CASE WHEN converted_to_po_flag = FALSE THEN 1 ELSE 0 END)
      comment: "Number of requisitions pending PO conversion - measures backlog"
    - name: "fixed_source_count"
      expr: SUM(CASE WHEN fixed_source_indicator = TRUE THEN 1 ELSE 0 END)
      comment: "Number of requisitions with fixed source - measures sourcing flexibility"
    - name: "unique_requestor_count"
      expr: COUNT(DISTINCT requestor_name)
      comment: "Number of unique requestors - measures procurement user base"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_supplier_risk`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Supplier risk assessment metrics tracking risk scores, financial impact, single-source exposure, and compliance status to enable proactive risk mitigation"
  source: "`manufacturing_ecm`.`procurement`.`supplier_risk`"
  dimensions:
    - name: "risk_tier"
      expr: risk_tier
      comment: "Risk tier classification (high, medium, low)"
    - name: "severity"
      expr: severity
      comment: "Risk severity level"
    - name: "status"
      expr: status
      comment: "Risk status"
    - name: "risk_subcategory"
      expr: risk_subcategory
      comment: "Risk subcategory"
    - name: "financial_risk_rating"
      expr: financial_risk_rating
      comment: "Financial risk rating"
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "Country of origin for supplier"
    - name: "affected_plant_code"
      expr: affected_plant_code
      comment: "Plant code affected by risk"
    - name: "affected_material_group"
      expr: affected_material_group
      comment: "Material group affected by risk"
    - name: "is_single_source"
      expr: is_single_source
      comment: "Whether supplier is single source"
    - name: "is_escalated"
      expr: is_escalated
      comment: "Whether risk has been escalated"
    - name: "business_continuity_plan_status"
      expr: business_continuity_plan_status
      comment: "Status of business continuity plan"
    - name: "conflict_minerals_status"
      expr: conflict_minerals_status
      comment: "Conflict minerals compliance status"
    - name: "reach_compliance_status"
      expr: reach_compliance_status
      comment: "REACH compliance status"
    - name: "rohs_compliance_status"
      expr: rohs_compliance_status
      comment: "RoHS compliance status"
    - name: "regulatory_compliance_status"
      expr: regulatory_compliance_status
      comment: "Overall regulatory compliance status"
    - name: "sanctions_screening_status"
      expr: sanctions_screening_status
      comment: "Sanctions screening status"
    - name: "identification_date"
      expr: identification_date
      comment: "Date risk was identified"
    - name: "assessment_date"
      expr: assessment_date
      comment: "Date risk was assessed"
    - name: "target_resolution_date"
      expr: target_resolution_date
      comment: "Target date for risk resolution"
  measures:
    - name: "avg_risk_score"
      expr: AVG(CAST(risk_score AS DOUBLE))
      comment: "Average risk score - composite risk indicator for supplier portfolio health"
    - name: "avg_impact_score"
      expr: AVG(CAST(impact_score AS DOUBLE))
      comment: "Average impact score - measures potential business impact of risks"
    - name: "avg_probability_score"
      expr: AVG(CAST(probability_score AS DOUBLE))
      comment: "Average probability score - measures likelihood of risk occurrence"
    - name: "avg_financial_risk_score"
      expr: AVG(CAST(financial_risk_score AS DOUBLE))
      comment: "Average financial risk score - measures supplier financial stability"
    - name: "avg_geopolitical_risk_score"
      expr: AVG(CAST(geopolitical_risk_score AS DOUBLE))
      comment: "Average geopolitical risk score - measures country/region risk exposure"
    - name: "total_estimated_financial_impact"
      expr: SUM(CAST(estimated_financial_impact AS DOUBLE))
      comment: "Total estimated financial impact of risks - measures potential cost exposure"
    - name: "total_annual_spend_at_risk"
      expr: SUM(CAST(annual_spend_amount AS DOUBLE))
      comment: "Total annual spend at risk - measures spend exposure to supplier risks"
    - name: "avg_spend_concentration_pct"
      expr: AVG(CAST(spend_concentration_percent AS DOUBLE))
      comment: "Average spend concentration percentage - measures supplier dependency"
    - name: "risk_count"
      expr: COUNT(1)
      comment: "Total number of supplier risks - measures risk portfolio size"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT supplier_id)
      comment: "Number of unique suppliers with identified risks"
    - name: "single_source_risk_count"
      expr: SUM(CASE WHEN is_single_source = TRUE THEN 1 ELSE 0 END)
      comment: "Number of single-source supplier risks - critical supply continuity metric"
    - name: "escalated_risk_count"
      expr: SUM(CASE WHEN is_escalated = TRUE THEN 1 ELSE 0 END)
      comment: "Number of escalated risks - measures high-priority risk exposure"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_savings_initiative`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Procurement savings initiative tracking projected vs realized savings, savings percentage, and realization status to measure value delivery from cost reduction programs"
  source: "`manufacturing_ecm`.`procurement`.`savings_initiative`"
  dimensions:
    - name: "initiative_type"
      expr: initiative_type
      comment: "Type of savings initiative"
    - name: "status"
      expr: status
      comment: "Initiative status"
    - name: "realization_status"
      expr: realization_status
      comment: "Savings realization status"
    - name: "category_code"
      expr: category_code
      comment: "Spend category code"
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity"
    - name: "country_code"
      expr: country_code
      comment: "Country of initiative"
    - name: "procurement_type"
      expr: procurement_type
      comment: "Type of procurement (direct, indirect, services)"
    - name: "sourcing_strategy"
      expr: sourcing_strategy
      comment: "Sourcing strategy employed"
    - name: "finance_validated"
      expr: finance_validated
      comment: "Whether savings have been validated by finance"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of initiative"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period of initiative"
    - name: "identification_date"
      expr: identification_date
      comment: "Date initiative was identified"
    - name: "realization_date"
      expr: realization_date
      comment: "Date savings were realized"
  measures:
    - name: "total_projected_savings"
      expr: SUM(CAST(projected_savings_amount AS DOUBLE))
      comment: "Total projected savings - measures savings pipeline and targets"
    - name: "total_realized_savings"
      expr: SUM(CAST(realized_savings_amount AS DOUBLE))
      comment: "Total realized savings - key value delivery metric for procurement performance"
    - name: "total_baseline_spend"
      expr: SUM(CAST(baseline_spend_amount AS DOUBLE))
      comment: "Total baseline spend before initiatives - used for savings percentage calculation"
    - name: "avg_baseline_price"
      expr: AVG(CAST(baseline_price AS DOUBLE))
      comment: "Average baseline price before negotiation"
    - name: "avg_negotiated_price"
      expr: AVG(CAST(negotiated_price AS DOUBLE))
      comment: "Average negotiated price after initiative"
    - name: "avg_savings_percent"
      expr: AVG(CAST(savings_percent AS DOUBLE))
      comment: "Average savings percentage - measures initiative effectiveness"
    - name: "initiative_count"
      expr: COUNT(1)
      comment: "Total number of savings initiatives - measures cost reduction program activity"
    - name: "finance_validated_count"
      expr: SUM(CASE WHEN finance_validated = TRUE THEN 1 ELSE 0 END)
      comment: "Number of finance-validated initiatives - measures savings credibility"
    - name: "unique_category_count"
      expr: COUNT(DISTINCT category_code)
      comment: "Number of unique categories with savings initiatives - measures program breadth"
    - name: "unique_supplier_count"
      expr: COUNT(DISTINCT supplier_id)
      comment: "Number of unique suppliers involved in savings initiatives"
$$;