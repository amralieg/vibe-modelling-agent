-- Metric views for domain: service | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_service_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service request performance metrics tracking case volume, resolution efficiency, SLA compliance, and customer satisfaction for aftermarket support operations."
  source: "`manufacturing_ecm`.`service`.`request`"
  dimensions:
    - name: "request_status"
      expr: status
      comment: "Current lifecycle status of the service request (new, in_progress, resolved, closed, cancelled)"
    - name: "request_category"
      expr: category
      comment: "High-level classification of service request type (technical_support, warranty_claim, installation, complaint)"
    - name: "request_sub_category"
      expr: sub_category
      comment: "Granular categorization within primary category (hardware_failure, software_bug, configuration_issue)"
    - name: "severity"
      expr: severity
      comment: "Business impact severity classification (critical, high, medium, low)"
    - name: "priority"
      expr: priority
      comment: "Operational priority level for queue management and dispatch scheduling"
    - name: "sla_tier"
      expr: sla_tier
      comment: "Service Level Agreement tier determining response and resolution time commitments"
    - name: "origin_channel"
      expr: origin_channel
      comment: "Channel through which customer initiated the service request (phone, email, web_portal, field)"
    - name: "product_line"
      expr: product_line
      comment: "Product line or family of the equipment associated with the service request"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of customer site for regional performance reporting"
    - name: "site_region"
      expr: site_region
      comment: "Geographic sales or service region (EMEA, Americas, APAC) for regional management dashboards"
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Categorized root cause of the reported issue for quality trend analysis and CAPA initiation"
    - name: "resolution_type"
      expr: resolution_type
      comment: "Classification of resolution method applied (remote_fix, field_service, part_replacement, software_update)"
    - name: "is_escalated"
      expr: is_escalated
      comment: "Flag indicating whether the service request has been escalated beyond initial support tier"
    - name: "is_sla_breached"
      expr: is_sla_breached
      comment: "Flag indicating whether the service request has breached its contractual SLA resolution target"
    - name: "is_warranty_claim"
      expr: is_warranty_claim
      comment: "Flag indicating whether this service request has been formally classified as a warranty claim"
    - name: "opened_month"
      expr: DATE_TRUNC('MONTH', opened_timestamp)
      comment: "Month when the service request was officially opened for trend analysis"
    - name: "resolved_month"
      expr: DATE_TRUNC('MONTH', resolved_timestamp)
      comment: "Month when the service request was technically resolved for resolution trend analysis"
  measures:
    - name: "total_service_requests"
      expr: COUNT(1)
      comment: "Total number of service requests submitted for volume tracking and capacity planning"
    - name: "unique_customers"
      expr: COUNT(DISTINCT CASE WHEN product_line IS NOT NULL THEN product_line END)
      comment: "Count of distinct product lines with service requests for portfolio coverage analysis"
    - name: "avg_sla_response_target_hours"
      expr: AVG(CAST(sla_response_target_hours AS DOUBLE))
      comment: "Average contractual response time target in hours across all service requests"
    - name: "avg_sla_resolution_target_hours"
      expr: AVG(CAST(sla_resolution_target_hours AS DOUBLE))
      comment: "Average contractual resolution time target in hours across all service requests"
    - name: "avg_customer_satisfaction_score"
      expr: AVG(CAST(customer_satisfaction_score AS DOUBLE))
      comment: "Average customer satisfaction score collected via post-resolution survey (1-5 or 1-10 scale)"
    - name: "sla_breach_count"
      expr: SUM(CASE WHEN is_sla_breached = true THEN 1 ELSE 0 END)
      comment: "Total count of service requests that breached contractual SLA resolution targets"
    - name: "escalation_count"
      expr: SUM(CASE WHEN is_escalated = true THEN 1 ELSE 0 END)
      comment: "Total count of service requests escalated beyond initial support tier for management intervention"
    - name: "warranty_claim_count"
      expr: SUM(CASE WHEN is_warranty_claim = true THEN 1 ELSE 0 END)
      comment: "Total count of service requests formally classified as warranty claims for warranty cost tracking"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_warranty_claim`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Warranty claim financial and operational metrics tracking claim volume, approval rates, cost recovery, and quality feedback for product reliability improvement."
  source: "`manufacturing_ecm`.`service`.`warranty_claim`"
  dimensions:
    - name: "claim_status"
      expr: status
      comment: "Current lifecycle status of the warranty claim (submitted, under_review, approved, rejected, settled)"
    - name: "claim_type"
      expr: claim_type
      comment: "Classification of warranty claim resolution type (repair, replacement, credit, refund, field_service)"
    - name: "claim_decision"
      expr: decision
      comment: "Final adjudication decision on the warranty claim (approved, rejected, partially_approved)"
    - name: "failure_mode"
      expr: failure_mode
      comment: "Standardized classification of product failure type aligned with FMEA failure mode taxonomy"
    - name: "root_cause"
      expr: root_cause
      comment: "Determined root cause of product failure following investigation for CAPA and quality improvement"
    - name: "product_category"
      expr: product_category
      comment: "High-level product category of the claimed item for warranty analytics by product line"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of customer site for regional warranty analytics"
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization code responsible for the original product sale for cost allocation"
    - name: "is_within_warranty"
      expr: is_within_warranty
      comment: "Flag indicating whether the product was within active warranty period at claim submission"
    - name: "supplier_chargeback_flag"
      expr: supplier_chargeback_flag
      comment: "Flag indicating whether warranty claim cost has been or will be charged back to supplier"
    - name: "submission_month"
      expr: DATE_TRUNC('MONTH', submission_date)
      comment: "Month when warranty claim was formally submitted for trend analysis"
    - name: "resolution_month"
      expr: DATE_TRUNC('MONTH', resolution_date)
      comment: "Month when warranty claim was operationally resolved for resolution trend analysis"
  measures:
    - name: "total_warranty_claims"
      expr: COUNT(1)
      comment: "Total number of warranty claims submitted for volume tracking and quality monitoring"
    - name: "total_claimed_amount"
      expr: SUM(CAST(claimed_amount AS DOUBLE))
      comment: "Total monetary amount claimed by customers for warranty coverage including repair costs and parts"
    - name: "total_approved_amount"
      expr: SUM(CAST(approved_amount AS DOUBLE))
      comment: "Total monetary amount approved by Manufacturing for warranty settlement after claim review"
    - name: "total_repair_cost"
      expr: SUM(CAST(repair_cost AS DOUBLE))
      comment: "Total actual cost incurred to repair defective products under warranty including labor and parts"
    - name: "total_supplier_chargeback_amount"
      expr: SUM(CAST(supplier_chargeback_amount AS DOUBLE))
      comment: "Total monetary amount to be recovered from suppliers for supplier-caused defects"
    - name: "approved_claim_count"
      expr: SUM(CASE WHEN decision = 'approved' THEN 1 ELSE 0 END)
      comment: "Total count of warranty claims fully approved for coverage for approval rate calculation"
    - name: "rejected_claim_count"
      expr: SUM(CASE WHEN decision = 'rejected' THEN 1 ELSE 0 END)
      comment: "Total count of warranty claims rejected for coverage for rejection rate analysis"
    - name: "within_warranty_claim_count"
      expr: SUM(CASE WHEN is_within_warranty = true THEN 1 ELSE 0 END)
      comment: "Total count of claims submitted within active warranty period for eligibility tracking"
    - name: "supplier_chargeback_claim_count"
      expr: SUM(CASE WHEN supplier_chargeback_flag = true THEN 1 ELSE 0 END)
      comment: "Total count of warranty claims with supplier chargeback for supplier quality management"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_service_contract_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service contract line item revenue and coverage metrics tracking contracted service value, SLA commitments, and preventive maintenance entitlements for aftermarket profitability analysis."
  source: "`manufacturing_ecm`.`service`.`contract_line`"
  dimensions:
    - name: "contract_line_status"
      expr: status
      comment: "Current lifecycle status of the service contract line item (active, suspended, cancelled, expired)"
    - name: "service_type"
      expr: service_type
      comment: "Classification of service being contracted (preventive_maintenance, corrective_maintenance, remote_monitoring, full_service)"
    - name: "service_category"
      expr: service_category
      comment: "High-level category grouping for the service line (hardware_maintenance, software_support, electrification_services)"
    - name: "sla_tier"
      expr: sla_tier
      comment: "SLA tier assigned to this contract line defining service commitment level (Platinum, Gold, Silver)"
    - name: "billing_frequency"
      expr: billing_frequency
      comment: "Frequency at which this contract line is invoiced (monthly, quarterly, annually, one-time)"
    - name: "billing_plan_type"
      expr: billing_plan_type
      comment: "Type of billing plan applied (periodic, milestone-driven, on-demand, prepaid, postpaid)"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code indicating country where service is delivered"
    - name: "cost_center"
      expr: cost_center
      comment: "SAP cost center code associated with service delivery for cost allocation and margin analysis"
    - name: "profit_center"
      expr: profit_center
      comment: "SAP profit center code to which revenue is attributed for contract profitability analysis"
    - name: "coverage_hours"
      expr: coverage_hours
      comment: "Service coverage window defining hours and days during which SLA obligations apply (8x5, 24x7)"
    - name: "remote_monitoring_included"
      expr: remote_monitoring_included
      comment: "Flag indicating whether remote monitoring and diagnostics via IIoT is included in scope"
    - name: "spare_parts_included"
      expr: spare_parts_included
      comment: "Flag indicating whether spare parts and replacement components are included at no additional charge"
    - name: "software_updates_included"
      expr: software_updates_included
      comment: "Flag indicating whether firmware and software updates are included in scope"
    - name: "penalty_clause_applicable"
      expr: penalty_clause_applicable
      comment: "Flag indicating whether financial penalties apply if SLA targets are not met"
    - name: "coverage_start_month"
      expr: DATE_TRUNC('MONTH', coverage_start_date)
      comment: "Month when service coverage for this contract line becomes effective"
  measures:
    - name: "total_contract_lines"
      expr: COUNT(1)
      comment: "Total number of service contract line items for contract portfolio volume tracking"
    - name: "total_line_value"
      expr: SUM(CAST(line_value AS DOUBLE))
      comment: "Total monetary value of all contract lines representing contracted revenue over coverage period"
    - name: "total_quantity"
      expr: SUM(CAST(quantity AS DOUBLE))
      comment: "Total number of units, assets, or service instances covered across all contract lines"
    - name: "avg_unit_price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average price per unit of service or covered asset before discounts across contract lines"
    - name: "avg_net_price"
      expr: AVG(CAST(net_price AS DOUBLE))
      comment: "Average unit price after application of discount percentage across contract lines"
    - name: "avg_discount_percent"
      expr: AVG(CAST(discount_percent AS DOUBLE))
      comment: "Average percentage discount applied to unit price across contract lines"
    - name: "avg_response_time_hours"
      expr: AVG(CAST(response_time_hours AS DOUBLE))
      comment: "Average maximum hours for service response initiation across contract lines"
    - name: "avg_resolution_time_hours"
      expr: AVG(CAST(resolution_time_hours AS DOUBLE))
      comment: "Average maximum hours for full issue resolution across contract lines"
    - name: "avg_availability_target_percent"
      expr: AVG(CAST(availability_target_percent AS DOUBLE))
      comment: "Average contractually committed equipment availability percentage across contract lines"
    - name: "avg_penalty_rate_percent"
      expr: AVG(CAST(penalty_rate_percent AS DOUBLE))
      comment: "Average percentage of line value deducted as financial penalty per SLA breach event"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_field_service_report`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Field service completion report metrics tracking labor hours, parts consumption, service costs, and first-time fix rates for field service efficiency and profitability analysis."
  source: "`manufacturing_ecm`.`service`.`report`"
  dimensions:
    - name: "report_status"
      expr: status
      comment: "Current lifecycle status of the service report (draft, submitted, customer_signed, approved, archived)"
    - name: "report_type"
      expr: type
      comment: "Classification of service activity documented (preventive_maintenance, corrective_maintenance, installation, commissioning, emergency_repair)"
    - name: "billing_type"
      expr: billing_type
      comment: "Classification of how the service visit will be billed (contract_covered, time_and_material, warranty, goodwill)"
    - name: "resolution_code"
      expr: resolution_code
      comment: "Standardized code indicating type of resolution applied (repair, replacement, adjustment, software_update)"
    - name: "root_cause_code"
      expr: root_cause_code
      comment: "Standardized code categorizing root cause of equipment failure or service need"
    - name: "test_outcome"
      expr: test_outcome
      comment: "Overall outcome of post-service functional testing (pass, fail, conditional_pass)"
    - name: "equipment_condition_found"
      expr: equipment_condition_found
      comment: "Condition of equipment as assessed by technician upon arrival prior to performing work"
    - name: "equipment_condition_left"
      expr: equipment_condition_left
      comment: "Condition of equipment as assessed by technician upon completion of service visit"
    - name: "site_country_code"
      expr: site_country_code
      comment: "ISO 3166-1 alpha-3 country code of customer site where service was performed"
    - name: "is_warranty_applicable"
      expr: is_warranty_applicable
      comment: "Flag indicating whether the service performed is covered under an active warranty"
    - name: "is_follow_up_required"
      expr: is_follow_up_required
      comment: "Flag indicating whether technician identified need for follow-up service visit or additional work"
    - name: "is_safety_incident_reported"
      expr: is_safety_incident_reported
      comment: "Flag indicating whether a safety incident or near-miss was observed and formally reported"
    - name: "report_month"
      expr: DATE_TRUNC('MONTH', date)
      comment: "Month when field service report was completed and submitted for trend analysis"
  measures:
    - name: "total_service_reports"
      expr: COUNT(1)
      comment: "Total number of field service completion reports for service activity volume tracking"
    - name: "total_labor_hours"
      expr: SUM(CAST(labor_hours_total AS DOUBLE))
      comment: "Total number of labor hours expended by technicians during service visits for workforce productivity analysis"
    - name: "total_parts_consumed_cost"
      expr: SUM(CAST(parts_consumed_cost AS DOUBLE))
      comment: "Total cost of all spare parts and materials consumed during service visits for COGS reporting"
    - name: "total_travel_time_hours"
      expr: SUM(CAST(travel_time_hours AS DOUBLE))
      comment: "Total number of hours spent by technicians traveling to and from customer sites for territory optimization"
    - name: "avg_labor_hours_per_visit"
      expr: AVG(CAST(labor_hours_total AS DOUBLE))
      comment: "Average number of labor hours per service visit for service efficiency benchmarking"
    - name: "avg_parts_cost_per_visit"
      expr: AVG(CAST(parts_consumed_cost AS DOUBLE))
      comment: "Average cost of spare parts consumed per service visit for parts consumption analysis"
    - name: "avg_travel_time_per_visit"
      expr: AVG(CAST(travel_time_hours AS DOUBLE))
      comment: "Average travel time per service visit for dispatch routing optimization"
    - name: "warranty_service_count"
      expr: SUM(CASE WHEN is_warranty_applicable = true THEN 1 ELSE 0 END)
      comment: "Total count of service visits covered under active warranty for warranty cost tracking"
    - name: "follow_up_required_count"
      expr: SUM(CASE WHEN is_follow_up_required = true THEN 1 ELSE 0 END)
      comment: "Total count of service visits requiring follow-up work for first-time fix rate calculation"
    - name: "safety_incident_count"
      expr: SUM(CASE WHEN is_safety_incident_reported = true THEN 1 ELSE 0 END)
      comment: "Total count of service visits with reported safety incidents or near-misses for HSE compliance"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_service_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service billing and revenue metrics tracking aftermarket service invoicing, payment collection, revenue recognition, and accounts receivable performance for financial management."
  source: "`manufacturing_ecm`.`service`.`service_invoice`"
  dimensions:
    - name: "invoice_status"
      expr: status
      comment: "Current lifecycle status of the service invoice (draft, issued, paid, partially_paid, overdue, cancelled)"
    - name: "invoice_type"
      expr: type
      comment: "Classification of invoice document type (standard_billing, credit_memo, debit_memo, proforma, cancellation)"
    - name: "billing_category"
      expr: billing_category
      comment: "Primary category of aftermarket service being billed for revenue segmentation by service type"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of customer site where service was rendered for regional reporting"
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization code responsible for service sale for revenue assignment and regional reporting"
    - name: "cost_center"
      expr: cost_center
      comment: "SAP cost center associated with service delivery costs for COGS allocation in aftermarket reporting"
    - name: "profit_center"
      expr: profit_center
      comment: "SAP profit center to which service revenue is attributed for aftermarket P&L reporting by business unit"
    - name: "payment_terms"
      expr: payment_terms
      comment: "SAP payment terms key defining due date calculation and early payment discount conditions"
    - name: "tax_code"
      expr: tax_code
      comment: "SAP tax code determining applicable tax rate and tax account assignment for VAT/GST compliance"
    - name: "dispute_reason"
      expr: dispute_reason
      comment: "Reason code for customer-raised invoice disputes for dispute resolution and billing quality improvement"
    - name: "billing_period_start_month"
      expr: DATE_TRUNC('MONTH', billing_period_start_date)
      comment: "Month when service period covered by invoice begins for periodic contract billing analysis"
    - name: "payment_due_month"
      expr: DATE_TRUNC('MONTH', payment_due_date)
      comment: "Month when customer payment is due for cash flow forecasting and collections management"
  measures:
    - name: "total_service_invoices"
      expr: COUNT(1)
      comment: "Total number of service invoices issued for billing volume tracking and revenue cycle monitoring"
    - name: "total_gross_amount"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total invoice amount inclusive of all taxes representing total amount payable by customers"
    - name: "total_net_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total invoice amount before taxes and after discounts representing net revenue recognized for service"
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount applied to invoices including VAT, GST, or sales tax for statutory reporting"
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discount applied to invoices including contract-based discounts and volume rebates"
    - name: "total_paid_amount"
      expr: SUM(CAST(paid_amount AS DOUBLE))
      comment: "Total cumulative amount received against invoices to date for accounts receivable tracking"
    - name: "avg_exchange_rate"
      expr: AVG(CAST(exchange_rate AS DOUBLE))
      comment: "Average foreign currency exchange rate applied at invoice creation for multi-currency consolidation"
    - name: "avg_gross_amount"
      expr: AVG(CAST(gross_amount AS DOUBLE))
      comment: "Average invoice amount inclusive of taxes per invoice for average transaction value analysis"
    - name: "avg_net_amount"
      expr: AVG(CAST(net_amount AS DOUBLE))
      comment: "Average invoice amount before taxes per invoice for average revenue per invoice analysis"
    - name: "paid_invoice_count"
      expr: SUM(CASE WHEN status = 'paid' THEN 1 ELSE 0 END)
      comment: "Total count of fully paid invoices for payment collection rate calculation"
    - name: "overdue_invoice_count"
      expr: SUM(CASE WHEN status = 'overdue' THEN 1 ELSE 0 END)
      comment: "Total count of overdue invoices for accounts receivable aging and collections prioritization"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_spare_parts_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Spare parts fulfillment metrics tracking parts request volume, fulfillment rates, backorder levels, and parts consumption costs for aftermarket inventory and service operations management."
  source: "`manufacturing_ecm`.`service`.`spare_parts_request`"
  dimensions:
    - name: "request_status"
      expr: status
      comment: "Current lifecycle status of spare parts request (pending, approved, issued, backordered, cancelled)"
    - name: "request_type"
      expr: request_type
      comment: "Classification of spare parts request by service demand nature (field_service, warranty_repair, preventive_maintenance, emergency_breakdown)"
    - name: "urgency_level"
      expr: urgency_level
      comment: "Priority classification indicating operational urgency (critical, high, medium, low) for warehouse picking priority"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval workflow status for spare parts request (pending_approval, approved, rejected)"
    - name: "part_category"
      expr: part_category
      comment: "Technical category of spare part for inventory classification (electrical, mechanical, hydraulic, electronic)"
    - name: "source_warehouse_code"
      expr: source_warehouse_code
      comment: "Code identifying warehouse from which spare part is issued for multi-warehouse fulfillment routing"
    - name: "delivery_country_code"
      expr: delivery_country_code
      comment: "ISO 3166-1 alpha-3 country code of delivery destination for export compliance and logistics management"
    - name: "cost_center"
      expr: cost_center
      comment: "SAP cost center code to which spare parts cost is allocated for financial reporting"
    - name: "shipping_method"
      expr: shipping_method
      comment: "Mode of transportation selected for delivery (standard_ground, expedited, air_freight, courier)"
    - name: "warranty_covered"
      expr: warranty_covered
      comment: "Flag indicating whether spare part request is covered under active warranty agreement"
    - name: "request_month"
      expr: DATE_TRUNC('MONTH', request_date)
      comment: "Month when spare parts request was formally submitted for demand trend analysis"
  measures:
    - name: "total_parts_requests"
      expr: COUNT(1)
      comment: "Total number of spare parts requests submitted for parts demand volume tracking"
    - name: "total_quantity_requested"
      expr: SUM(CAST(quantity_requested AS DOUBLE))
      comment: "Total number of units of spare parts requested across all requests for demand forecasting"
    - name: "total_quantity_issued"
      expr: SUM(CAST(quantity_issued AS DOUBLE))
      comment: "Total number of units of spare parts physically issued from warehouse for fulfillment rate calculation"
    - name: "total_quantity_backordered"
      expr: SUM(CAST(quantity_backordered AS DOUBLE))
      comment: "Total quantity of spare parts that could not be fulfilled and placed on backorder for stock availability analysis"
    - name: "total_parts_cost"
      expr: SUM(CAST(total_cost AS DOUBLE))
      comment: "Total cost of spare parts requests representing actual parts cost charged to service orders or warranty claims"
    - name: "avg_unit_cost"
      expr: AVG(CAST(unit_cost AS DOUBLE))
      comment: "Average standard or moving average cost per unit of spare part for parts cost benchmarking"
    - name: "avg_quantity_requested"
      expr: AVG(CAST(quantity_requested AS DOUBLE))
      comment: "Average number of units requested per spare parts request for order size analysis"
    - name: "avg_quantity_issued"
      expr: AVG(CAST(quantity_issued AS DOUBLE))
      comment: "Average number of units issued per spare parts request for fulfillment efficiency analysis"
    - name: "approved_request_count"
      expr: SUM(CASE WHEN approval_status = 'approved' THEN 1 ELSE 0 END)
      comment: "Total count of approved spare parts requests for approval rate calculation"
    - name: "backordered_request_count"
      expr: SUM(CASE WHEN status = 'backordered' THEN 1 ELSE 0 END)
      comment: "Total count of spare parts requests with backorder status for stock availability monitoring"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_service_escalation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service escalation metrics tracking escalation volume, escalation levels, resolution effectiveness, and revenue at risk for service quality management and executive visibility into critical customer situations."
  source: "`manufacturing_ecm`.`service`.`escalation`"
  dimensions:
    - name: "escalation_status"
      expr: status
      comment: "Current lifecycle status of service escalation (open, in_progress, resolved, de_escalated, closed)"
    - name: "escalation_level"
      expr: level
      comment: "Severity tier of escalation ranging from L1 (first-line supervisor) to L4 (executive/C-suite)"
    - name: "escalation_category"
      expr: category
      comment: "High-level classification of escalation type for routing and trend analysis"
    - name: "trigger_reason"
      expr: trigger_reason
      comment: "Primary business reason that caused escalation to be raised (SLA_breach, customer_dissatisfaction, technical_complexity, safety_risk)"
    - name: "priority"
      expr: priority
      comment: "Business priority assigned to escalation for response urgency and resource allocation"
    - name: "product_line"
      expr: product_line
      comment: "Product line or family of equipment involved in escalation for product-level escalation trend analysis"
    - name: "site_country_code"
      expr: site_country_code
      comment: "ISO 3166-1 alpha-3 country code of customer site where escalated service issue is occurring"
    - name: "site_region"
      expr: site_region
      comment: "Geographic sales or service region of customer site for regional management escalation dashboards"
    - name: "sla_tier"
      expr: sla_tier
      comment: "SLA tier applicable to originating service request or field service order determining contractual obligations"
    - name: "resolution_type"
      expr: resolution_type
      comment: "Categorized type of resolution applied to close escalation for resolution pattern analysis"
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "High-level categorization of root cause identified for escalation for CAPA tracking and systemic issue identification"
    - name: "sla_breach_type"
      expr: sla_breach_type
      comment: "Specifies whether SLA breach was on initial response time, resolution time, or both"
    - name: "is_customer_notified"
      expr: is_customer_notified
      comment: "Flag indicating whether customer has been formally notified of escalation status and actions being taken"
    - name: "is_sla_breached"
      expr: is_sla_breached
      comment: "Flag indicating whether escalation was triggered by or is associated with breach of contracted SLA"
    - name: "escalation_month"
      expr: DATE_TRUNC('MONTH', timestamp)
      comment: "Month when escalation was formally raised for trend analysis"
  measures:
    - name: "total_escalations"
      expr: COUNT(1)
      comment: "Total number of service escalations raised for escalation volume tracking and service quality monitoring"
    - name: "total_estimated_revenue_at_risk"
      expr: SUM(CAST(estimated_revenue_at_risk AS DOUBLE))
      comment: "Total estimated monetary value of revenue at risk due to escalations for commercial prioritization"
    - name: "avg_estimated_revenue_at_risk"
      expr: AVG(CAST(estimated_revenue_at_risk AS DOUBLE))
      comment: "Average estimated revenue at risk per escalation for escalation severity benchmarking"
    - name: "sla_breached_escalation_count"
      expr: SUM(CASE WHEN is_sla_breached = true THEN 1 ELSE 0 END)
      comment: "Total count of escalations triggered by or associated with SLA breach for SLA compliance analysis"
    - name: "customer_notified_escalation_count"
      expr: SUM(CASE WHEN is_customer_notified = true THEN 1 ELSE 0 END)
      comment: "Total count of escalations where customer has been formally notified for customer communication compliance tracking"
    - name: "resolved_escalation_count"
      expr: SUM(CASE WHEN status = 'resolved' THEN 1 ELSE 0 END)
      comment: "Total count of escalations that have been technically resolved for escalation resolution rate calculation"
    - name: "l3_escalation_count"
      expr: SUM(CASE WHEN level = 'L3' THEN 1 ELSE 0 END)
      comment: "Total count of escalations reaching L3 (senior management) level for executive escalation tracking"
    - name: "l4_escalation_count"
      expr: SUM(CASE WHEN level = 'L4' THEN 1 ELSE 0 END)
      comment: "Total count of escalations reaching L4 (executive/C-suite) level for critical escalation monitoring"
$$;