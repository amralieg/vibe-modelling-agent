-- Metric views for domain: logistics | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_carrier_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Carrier performance KPIs measuring on-time delivery, cost efficiency, quality, and service level compliance for strategic carrier management and contract negotiations"
  source: "`manufacturing_ecm`.`logistics`.`carrier_performance`"
  dimensions:
    - name: "carrier_id"
      expr: carrier_id
      comment: "Unique identifier for the carrier being evaluated"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation (air, ocean, road, rail, intermodal)"
    - name: "service_type"
      expr: service_type
      comment: "Type of service provided (express, standard, economy)"
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "ISO country code of shipment origin"
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "ISO country code of shipment destination"
    - name: "service_lane_code"
      expr: service_lane_code
      comment: "Specific shipping lane or route identifier"
    - name: "performance_rating"
      expr: performance_rating
      comment: "Categorical performance rating (excellent, good, fair, poor)"
    - name: "scorecard_period_type"
      expr: scorecard_period_type
      comment: "Evaluation period type (monthly, quarterly, annual)"
    - name: "period_start_date"
      expr: period_start_date
      comment: "Start date of the performance evaluation period"
    - name: "period_end_date"
      expr: period_end_date
      comment: "End date of the performance evaluation period"
    - name: "sla_breach_flag"
      expr: sla_breach_flag
      comment: "Indicator whether SLA was breached during the period"
    - name: "corrective_action_required"
      expr: corrective_action_required
      comment: "Indicator whether corrective action is required"
  measures:
    - name: "total_freight_spend"
      expr: SUM(CAST(total_freight_spend AS DOUBLE))
      comment: "Total freight spend across all shipments in the period - critical for carrier cost management and budget allocation"
    - name: "avg_freight_spend_per_shipment"
      expr: AVG(CAST(total_freight_spend AS DOUBLE))
      comment: "Average freight spend per shipment - key metric for cost efficiency benchmarking"
    - name: "otif_achievement_rate"
      expr: ROUND(100.0 * AVG(CAST(otif_actual_percent AS DOUBLE)), 2)
      comment: "On-Time In-Full delivery achievement rate - primary KPI for carrier service quality and customer satisfaction"
    - name: "on_time_delivery_rate"
      expr: ROUND(100.0 * AVG(CAST(transit_time_compliance_percent AS DOUBLE)), 2)
      comment: "Transit time compliance rate - measures carrier reliability against committed delivery windows"
    - name: "damage_claim_rate"
      expr: ROUND(AVG(CAST(damage_claim_rate_percent AS DOUBLE)), 2)
      comment: "Percentage of shipments with damage claims - critical quality metric for carrier selection and risk management"
    - name: "total_damage_claim_value"
      expr: SUM(CAST(damage_claim_value AS DOUBLE))
      comment: "Total monetary value of damage claims - key financial risk metric for carrier performance"
    - name: "tender_acceptance_rate"
      expr: ROUND(AVG(CAST(tender_acceptance_percent AS DOUBLE)), 2)
      comment: "Rate at which carriers accept shipment tenders - measures carrier capacity commitment and reliability"
    - name: "avg_transit_time_days"
      expr: AVG(CAST(avg_transit_time_days AS DOUBLE))
      comment: "Average actual transit time in days - operational efficiency metric for route planning"
    - name: "transit_time_variance"
      expr: AVG(CAST(avg_transit_time_days AS DOUBLE) - CAST(contracted_transit_time_days AS DOUBLE))
      comment: "Average variance between actual and contracted transit time - measures carrier schedule adherence"
    - name: "co2_emissions_per_tonne_km"
      expr: AVG(CAST(co2_per_tonne_km AS DOUBLE))
      comment: "Average CO2 emissions per tonne-kilometer - sustainability KPI for green logistics initiatives"
    - name: "invoice_accuracy_rate"
      expr: ROUND(AVG(CAST(invoice_accuracy_percent AS DOUBLE)), 2)
      comment: "Invoice accuracy percentage - financial operations efficiency metric"
    - name: "edi_compliance_rate"
      expr: ROUND(AVG(CAST(edi_compliance_percent AS DOUBLE)), 2)
      comment: "EDI compliance percentage - digital integration maturity metric"
    - name: "pickup_compliance_rate"
      expr: ROUND(AVG(CAST(pickup_compliance_percent AS DOUBLE)), 2)
      comment: "Pickup compliance percentage - measures carrier adherence to scheduled pickup windows"
    - name: "overall_performance_score"
      expr: AVG(CAST(overall_score AS DOUBLE))
      comment: "Weighted overall performance score - composite KPI for carrier ranking and contract decisions"
    - name: "carrier_performance_count"
      expr: COUNT(1)
      comment: "Number of performance evaluation records - baseline metric for data completeness"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_delivery_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Delivery performance KPIs measuring OTIF (On-Time In-Full) achievement, fill rates, and customer service levels - critical for customer satisfaction and operational excellence"
  source: "`manufacturing_ecm`.`logistics`.`delivery_performance`"
  dimensions:
    - name: "carrier_id"
      expr: carrier_id
      comment: "Carrier responsible for the delivery"
    - name: "customer_number"
      expr: customer_number
      comment: "Customer identifier for segmented performance analysis"
    - name: "customer_name"
      expr: customer_name
      comment: "Customer name for reporting"
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "Destination country for geographic performance analysis"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation used"
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms governing delivery responsibility"
    - name: "plant_code"
      expr: plant_code
      comment: "Originating plant or distribution center"
    - name: "material_number"
      expr: material_number
      comment: "Material or product identifier"
    - name: "is_on_time"
      expr: is_on_time
      comment: "Boolean flag indicating on-time delivery achievement"
    - name: "is_in_full"
      expr: is_in_full
      comment: "Boolean flag indicating in-full delivery achievement"
    - name: "is_otif"
      expr: is_otif
      comment: "Boolean flag indicating OTIF (On-Time In-Full) achievement"
    - name: "otif_failure_reason_category"
      expr: otif_failure_reason_category
      comment: "High-level category of OTIF failure for root cause analysis"
    - name: "customer_impact_severity"
      expr: customer_impact_severity
      comment: "Severity level of customer impact (critical, high, medium, low)"
    - name: "measurement_period"
      expr: measurement_period
      comment: "Time period for performance measurement (daily, weekly, monthly)"
    - name: "actual_delivery_date"
      expr: actual_delivery_date
      comment: "Actual delivery date for time-series analysis"
    - name: "promised_delivery_date"
      expr: promised_delivery_date
      comment: "Promised delivery date for commitment tracking"
  measures:
    - name: "otif_achievement_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_otif = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "On-Time In-Full delivery rate - primary customer service KPI and contract compliance metric"
    - name: "on_time_delivery_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_on_time = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "On-time delivery rate - measures schedule adherence and reliability"
    - name: "in_full_delivery_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_in_full = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "In-full delivery rate - measures order completeness and inventory accuracy"
    - name: "avg_fill_rate"
      expr: ROUND(AVG(CAST(fill_rate_pct AS DOUBLE)), 2)
      comment: "Average fill rate percentage - measures ability to fulfill ordered quantities"
    - name: "total_ordered_quantity"
      expr: SUM(CAST(ordered_quantity AS DOUBLE))
      comment: "Total quantity ordered - baseline for demand fulfillment analysis"
    - name: "total_delivered_quantity"
      expr: SUM(CAST(delivered_quantity AS DOUBLE))
      comment: "Total quantity delivered - actual fulfillment volume"
    - name: "order_fulfillment_rate"
      expr: ROUND(100.0 * SUM(CAST(delivered_quantity AS DOUBLE)) / NULLIF(SUM(CAST(ordered_quantity AS DOUBLE)), 0), 2)
      comment: "Overall order fulfillment rate - strategic metric for supply chain effectiveness"
    - name: "avg_delivery_variance_days"
      expr: AVG(DATEDIFF(actual_delivery_date, promised_delivery_date))
      comment: "Average delivery variance in days (positive = late, negative = early) - measures schedule accuracy"
    - name: "late_delivery_count"
      expr: SUM(CASE WHEN DATEDIFF(actual_delivery_date, promised_delivery_date) > 0 THEN 1 ELSE 0 END)
      comment: "Count of late deliveries - operational metric for performance improvement"
    - name: "critical_impact_delivery_count"
      expr: SUM(CASE WHEN customer_impact_severity = 'Critical' THEN 1 ELSE 0 END)
      comment: "Count of deliveries with critical customer impact - escalation and risk management metric"
    - name: "delivery_performance_count"
      expr: COUNT(1)
      comment: "Total number of delivery performance records - baseline metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_audit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight audit and payment KPIs measuring invoice accuracy, cost variance, dispute rates, and payment efficiency - critical for freight cost control and carrier financial management"
  source: "`manufacturing_ecm`.`logistics`.`freight_audit`"
  dimensions:
    - name: "carrier_id"
      expr: carrier_id
      comment: "Carrier being audited"
    - name: "audit_status"
      expr: audit_status
      comment: "Status of the audit (pending, approved, disputed, rejected)"
    - name: "audit_type"
      expr: audit_type
      comment: "Type of audit (pre-payment, post-payment, exception)"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "service_level"
      expr: service_level
      comment: "Service level of the shipment"
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "Origin country for geographic cost analysis"
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "Destination country for geographic cost analysis"
    - name: "is_disputed"
      expr: is_disputed
      comment: "Flag indicating whether invoice is disputed"
    - name: "is_duplicate_invoice"
      expr: is_duplicate_invoice
      comment: "Flag indicating duplicate invoice detection"
    - name: "variance_reason_code"
      expr: variance_reason_code
      comment: "Code categorizing the reason for cost variance"
    - name: "payment_status"
      expr: payment_status
      comment: "Payment status (pending, paid, on-hold, cancelled)"
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the invoice"
    - name: "audit_date"
      expr: audit_date
      comment: "Date of audit for time-series analysis"
  measures:
    - name: "total_invoiced_amount"
      expr: SUM(CAST(invoiced_amount AS DOUBLE))
      comment: "Total invoiced freight charges - baseline for freight spend analysis"
    - name: "total_approved_amount"
      expr: SUM(CAST(approved_amount AS DOUBLE))
      comment: "Total approved payment amount after audit - actual freight cost"
    - name: "total_contracted_amount"
      expr: SUM(CAST(contracted_amount AS DOUBLE))
      comment: "Total contracted freight cost - baseline for variance analysis"
    - name: "total_variance_amount"
      expr: SUM(CAST(variance_amount AS DOUBLE))
      comment: "Total cost variance (invoiced vs contracted) - key metric for freight cost control and carrier compliance"
    - name: "freight_cost_savings"
      expr: SUM(CAST(invoiced_amount AS DOUBLE) - CAST(approved_amount AS DOUBLE))
      comment: "Total savings from audit process - ROI metric for freight audit program"
    - name: "avg_variance_percentage"
      expr: ROUND(AVG(CAST(variance_percentage AS DOUBLE)), 2)
      comment: "Average variance percentage - measures carrier pricing accuracy and contract adherence"
    - name: "dispute_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_disputed = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of invoices disputed - quality metric for carrier billing accuracy"
    - name: "duplicate_invoice_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_duplicate_invoice = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of duplicate invoices detected - process control metric"
    - name: "total_accessorial_charges_invoiced"
      expr: SUM(CAST(accessorial_charges_invoiced AS DOUBLE))
      comment: "Total accessorial charges invoiced - cost driver analysis metric"
    - name: "total_accessorial_charges_approved"
      expr: SUM(CAST(accessorial_charges_approved AS DOUBLE))
      comment: "Total accessorial charges approved - actual accessorial cost"
    - name: "accessorial_variance"
      expr: SUM(CAST(accessorial_charges_invoiced AS DOUBLE) - CAST(accessorial_charges_approved AS DOUBLE))
      comment: "Variance in accessorial charges - identifies unauthorized or incorrect accessorial billing"
    - name: "total_fuel_surcharge"
      expr: SUM(CAST(fuel_surcharge_invoiced AS DOUBLE))
      comment: "Total fuel surcharge invoiced - cost component analysis"
    - name: "avg_audit_cycle_time_days"
      expr: AVG(DATEDIFF(approved_timestamp, audit_date))
      comment: "Average days from audit to approval - process efficiency metric"
    - name: "avg_dispute_resolution_time_days"
      expr: AVG(DATEDIFF(dispute_resolution_date, dispute_raised_date))
      comment: "Average days to resolve disputes - carrier relationship and process efficiency metric"
    - name: "freight_audit_count"
      expr: COUNT(1)
      comment: "Total number of freight audits - baseline metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_claim`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight claims KPIs measuring damage rates, claim values, settlement efficiency, and carrier liability - critical for risk management and carrier performance evaluation"
  source: "`manufacturing_ecm`.`logistics`.`freight_claim`"
  dimensions:
    - name: "carrier_id"
      expr: carrier_id
      comment: "Carrier responsible for the shipment"
    - name: "claim_type"
      expr: claim_type
      comment: "Type of claim (damage, loss, shortage, delay)"
    - name: "status"
      expr: status
      comment: "Current status of the claim (filed, acknowledged, approved, denied, settled)"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "Origin country for geographic risk analysis"
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "Destination country for geographic risk analysis"
    - name: "dispute_status"
      expr: dispute_status
      comment: "Status of any dispute on the claim"
    - name: "inspection_required"
      expr: inspection_required
      comment: "Flag indicating whether inspection is required"
    - name: "filed_date"
      expr: filed_date
      comment: "Date claim was filed for time-series analysis"
    - name: "incident_date"
      expr: incident_date
      comment: "Date of the incident"
  measures:
    - name: "total_claimed_amount"
      expr: SUM(CAST(claimed_amount AS DOUBLE))
      comment: "Total amount claimed - measures financial exposure from freight damage and loss"
    - name: "total_settlement_amount"
      expr: SUM(CAST(final_settlement_amount AS DOUBLE))
      comment: "Total amount settled - actual financial recovery from carriers"
    - name: "total_insurance_recovery"
      expr: SUM(CAST(insurance_recovery_amount AS DOUBLE))
      comment: "Total insurance recovery amount - risk mitigation metric"
    - name: "claim_recovery_rate"
      expr: ROUND(100.0 * SUM(CAST(final_settlement_amount AS DOUBLE)) / NULLIF(SUM(CAST(claimed_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of claimed amount recovered - measures effectiveness of claims management and carrier liability enforcement"
    - name: "avg_claim_value"
      expr: AVG(CAST(claimed_amount AS DOUBLE))
      comment: "Average claim value - risk severity metric"
    - name: "total_damaged_quantity"
      expr: SUM(CAST(damaged_quantity AS DOUBLE))
      comment: "Total quantity of damaged goods - operational quality metric"
    - name: "avg_claim_resolution_time_days"
      expr: AVG(DATEDIFF(settlement_date, filed_date))
      comment: "Average days from filing to settlement - process efficiency and carrier responsiveness metric"
    - name: "avg_carrier_response_time_days"
      expr: AVG(DATEDIFF(carrier_acknowledgment_date, filed_date))
      comment: "Average days for carrier to acknowledge claim - carrier service quality metric"
    - name: "claim_approval_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN status = 'Approved' OR status = 'Settled' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of claims approved or settled - measures claim validity and carrier acceptance"
    - name: "claim_denial_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN status = 'Denied' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of claims denied - risk metric for claim quality and carrier disputes"
    - name: "overdue_claim_count"
      expr: SUM(CASE WHEN carrier_decision_due_date < CURRENT_DATE() AND status NOT IN ('Settled', 'Denied', 'Closed') THEN 1 ELSE 0 END)
      comment: "Count of overdue claims - operational metric for claims backlog management"
    - name: "freight_claim_count"
      expr: COUNT(1)
      comment: "Total number of freight claims - baseline metric for claim frequency analysis"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight invoice KPIs measuring freight spend, cost components, payment efficiency, and invoice accuracy - critical for freight cost management and financial operations"
  source: "`manufacturing_ecm`.`logistics`.`freight_invoice`"
  dimensions:
    - name: "carrier_id"
      expr: carrier_id
      comment: "Carrier issuing the invoice"
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of invoice (standard, credit, debit, adjustment)"
    - name: "status"
      expr: status
      comment: "Invoice status (received, audited, approved, paid, disputed)"
    - name: "audit_status"
      expr: audit_status
      comment: "Audit status of the invoice"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "service_level"
      expr: service_level
      comment: "Service level of the shipment"
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "Origin country for geographic spend analysis"
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "Destination country for geographic spend analysis"
    - name: "is_intercompany"
      expr: is_intercompany
      comment: "Flag indicating intercompany transaction"
    - name: "payment_method"
      expr: payment_method
      comment: "Method of payment (wire, ACH, check, credit card)"
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Payment terms code"
    - name: "billing_period_start_date"
      expr: billing_period_start_date
      comment: "Start of billing period for time-series analysis"
    - name: "billing_period_end_date"
      expr: billing_period_end_date
      comment: "End of billing period"
  measures:
    - name: "total_freight_spend"
      expr: SUM(CAST(invoiced_amount AS DOUBLE))
      comment: "Total freight spend - primary financial metric for freight cost management and budgeting"
    - name: "total_base_freight_amount"
      expr: SUM(CAST(base_freight_amount AS DOUBLE))
      comment: "Total base freight charges excluding surcharges - core transportation cost"
    - name: "total_accessorial_amount"
      expr: SUM(CAST(accessorial_amount AS DOUBLE))
      comment: "Total accessorial charges - cost driver for non-standard services"
    - name: "total_fuel_surcharge"
      expr: SUM(CAST(fuel_surcharge_amount AS DOUBLE))
      comment: "Total fuel surcharge - volatile cost component for hedging and forecasting"
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount - compliance and cost analysis metric"
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discount amount - measures negotiated savings"
    - name: "total_approved_amount"
      expr: SUM(CAST(approved_amount AS DOUBLE))
      comment: "Total approved payment amount - actual freight cost after audit"
    - name: "accessorial_as_pct_of_base"
      expr: ROUND(100.0 * SUM(CAST(accessorial_amount AS DOUBLE)) / NULLIF(SUM(CAST(base_freight_amount AS DOUBLE)), 0), 2)
      comment: "Accessorial charges as percentage of base freight - cost structure metric for negotiation leverage"
    - name: "fuel_surcharge_as_pct_of_base"
      expr: ROUND(100.0 * SUM(CAST(fuel_surcharge_amount AS DOUBLE)) / NULLIF(SUM(CAST(base_freight_amount AS DOUBLE)), 0), 2)
      comment: "Fuel surcharge as percentage of base freight - cost volatility metric"
    - name: "avg_invoice_amount"
      expr: AVG(CAST(invoiced_amount AS DOUBLE))
      comment: "Average invoice amount - baseline for cost per shipment analysis"
    - name: "avg_payment_cycle_time_days"
      expr: AVG(DATEDIFF(payment_date, received_date))
      comment: "Average days from invoice receipt to payment - working capital and process efficiency metric"
    - name: "avg_days_to_due_date"
      expr: AVG(DATEDIFF(due_date, received_date))
      comment: "Average days from receipt to due date - payment terms analysis"
    - name: "disputed_invoice_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN dispute_reason IS NOT NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of invoices disputed - quality metric for carrier billing accuracy"
    - name: "avg_dispute_resolution_time_days"
      expr: AVG(DATEDIFF(dispute_resolution_date, received_date))
      comment: "Average days to resolve invoice disputes - process efficiency metric"
    - name: "freight_invoice_count"
      expr: COUNT(1)
      comment: "Total number of freight invoices - baseline metric for invoice volume analysis"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight order KPIs measuring shipment volumes, weights, costs, and service levels - critical for capacity planning and freight procurement"
  source: "`manufacturing_ecm`.`logistics`.`freight_order`"
  dimensions:
    - name: "carrier_id"
      expr: carrier_id
      comment: "Carrier assigned to the freight order"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "service_level"
      expr: service_level
      comment: "Service level (express, standard, economy)"
    - name: "order_type"
      expr: order_type
      comment: "Type of freight order (FTL, LTL, parcel, intermodal)"
    - name: "status"
      expr: status
      comment: "Current status of the freight order"
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "Origin country for lane analysis"
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "Destination country for lane analysis"
    - name: "origin_location_code"
      expr: origin_location_code
      comment: "Origin location code"
    - name: "destination_location_code"
      expr: destination_location_code
      comment: "Destination location code"
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms governing freight responsibility"
    - name: "hazmat_flag"
      expr: hazmat_flag
      comment: "Flag indicating hazardous materials"
    - name: "temperature_controlled_flag"
      expr: temperature_controlled_flag
      comment: "Flag indicating temperature-controlled shipment"
    - name: "planned_pickup_date"
      expr: planned_pickup_date
      comment: "Planned pickup date for time-series analysis"
    - name: "planned_delivery_date"
      expr: planned_delivery_date
      comment: "Planned delivery date"
  measures:
    - name: "total_freight_orders"
      expr: COUNT(1)
      comment: "Total number of freight orders - baseline volume metric for capacity planning"
    - name: "total_gross_weight_kg"
      expr: SUM(CAST(gross_weight_kg AS DOUBLE))
      comment: "Total gross weight in kilograms - capacity utilization metric"
    - name: "total_volume_m3"
      expr: SUM(CAST(volume_m3 AS DOUBLE))
      comment: "Total volume in cubic meters - capacity utilization metric"
    - name: "avg_weight_per_order_kg"
      expr: AVG(CAST(gross_weight_kg AS DOUBLE))
      comment: "Average weight per order - shipment profile metric for mode optimization"
    - name: "avg_volume_per_order_m3"
      expr: AVG(CAST(volume_m3 AS DOUBLE))
      comment: "Average volume per order - shipment profile metric"
    - name: "total_estimated_freight_cost"
      expr: SUM(CAST(estimated_freight_cost AS DOUBLE))
      comment: "Total estimated freight cost - budget planning metric"
    - name: "total_confirmed_freight_cost"
      expr: SUM(CAST(confirmed_freight_cost AS DOUBLE))
      comment: "Total confirmed freight cost - actual committed spend"
    - name: "avg_freight_cost_per_kg"
      expr: ROUND(SUM(CAST(confirmed_freight_cost AS DOUBLE)) / NULLIF(SUM(CAST(gross_weight_kg AS DOUBLE)), 0), 4)
      comment: "Average freight cost per kilogram - unit cost efficiency metric for mode and carrier benchmarking"
    - name: "avg_freight_cost_per_m3"
      expr: ROUND(SUM(CAST(confirmed_freight_cost AS DOUBLE)) / NULLIF(SUM(CAST(volume_m3 AS DOUBLE)), 0), 2)
      comment: "Average freight cost per cubic meter - density-based cost metric"
    - name: "hazmat_shipment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN hazmat_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of hazmat shipments - compliance and risk metric"
    - name: "temp_controlled_shipment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN temperature_controlled_flag = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of temperature-controlled shipments - specialized capacity requirement metric"
    - name: "avg_planned_transit_time_days"
      expr: AVG(DATEDIFF(planned_delivery_date, planned_pickup_date))
      comment: "Average planned transit time in days - service level planning metric"
    - name: "avg_actual_transit_time_days"
      expr: AVG(DATEDIFF(CAST(actual_delivery_timestamp AS DATE), CAST(actual_pickup_timestamp AS DATE)))
      comment: "Average actual transit time in days - operational performance metric"
    - name: "on_time_pickup_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN CAST(actual_pickup_timestamp AS DATE) <= planned_pickup_date THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN actual_pickup_timestamp IS NOT NULL THEN 1 ELSE 0 END), 0), 2)
      comment: "Percentage of on-time pickups - carrier performance metric"
    - name: "on_time_delivery_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN CAST(actual_delivery_timestamp AS DATE) <= planned_delivery_date THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN actual_delivery_timestamp IS NOT NULL THEN 1 ELSE 0 END), 0), 2)
      comment: "Percentage of on-time deliveries - primary service level KPI"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_shipment_exception`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Shipment exception KPIs measuring disruption frequency, delay impact, root causes, and resolution efficiency - critical for supply chain risk management and continuous improvement"
  source: "`manufacturing_ecm`.`logistics`.`shipment_exception`"
  dimensions:
    - name: "exception_type"
      expr: exception_type
      comment: "Type of exception (delay, damage, loss, customs hold, weather)"
    - name: "exception_code"
      expr: exception_code
      comment: "Specific exception code for detailed analysis"
    - name: "severity"
      expr: severity
      comment: "Severity level (critical, high, medium, low)"
    - name: "status"
      expr: status
      comment: "Current status of the exception (open, investigating, resolved, closed)"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "carrier_name"
      expr: carrier_name
      comment: "Carrier responsible for the shipment"
    - name: "root_cause_code"
      expr: root_cause_code
      comment: "Root cause code for Pareto analysis"
    - name: "responsible_party"
      expr: responsible_party
      comment: "Party responsible for the exception (carrier, shipper, consignee, customs)"
    - name: "is_sla_breached"
      expr: is_sla_breached
      comment: "Flag indicating SLA breach"
    - name: "is_customer_notified"
      expr: is_customer_notified
      comment: "Flag indicating customer notification"
    - name: "escalation_level"
      expr: escalation_level
      comment: "Escalation level (none, L1, L2, executive)"
    - name: "detection_source"
      expr: detection_source
      comment: "Source of exception detection (automated, manual, customer)"
    - name: "exception_country_code"
      expr: exception_country_code
      comment: "Country where exception occurred"
    - name: "occurrence_timestamp"
      expr: occurrence_timestamp
      comment: "Timestamp when exception occurred"
  measures:
    - name: "total_exceptions"
      expr: COUNT(1)
      comment: "Total number of shipment exceptions - baseline metric for supply chain disruption frequency"
    - name: "exception_rate"
      expr: ROUND(100.0 * COUNT(1) / NULLIF(COUNT(DISTINCT shipment_number), 0), 2)
      comment: "Exception rate per shipment - quality metric for operational excellence"
    - name: "critical_exception_count"
      expr: SUM(CASE WHEN severity = 'Critical' THEN 1 ELSE 0 END)
      comment: "Count of critical exceptions - risk management metric requiring immediate attention"
    - name: "sla_breach_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_sla_breached = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of exceptions causing SLA breach - customer impact metric"
    - name: "avg_estimated_delay_days"
      expr: AVG(CAST(estimated_delay_days AS DOUBLE))
      comment: "Average estimated delay in days - impact severity metric"
    - name: "avg_actual_delay_days"
      expr: AVG(CAST(actual_delay_days AS DOUBLE))
      comment: "Average actual delay in days - realized impact metric"
    - name: "total_financial_impact"
      expr: SUM(CAST(financial_impact_amount AS DOUBLE))
      comment: "Total financial impact of exceptions - cost of poor quality metric for business case prioritization"
    - name: "avg_financial_impact_per_exception"
      expr: AVG(CAST(financial_impact_amount AS DOUBLE))
      comment: "Average financial impact per exception - severity metric"
    - name: "avg_detection_to_resolution_days"
      expr: AVG(DATEDIFF(CAST(resolution_timestamp AS DATE), CAST(detection_timestamp AS DATE)))
      comment: "Average days from detection to resolution - process efficiency metric"
    - name: "avg_occurrence_to_detection_days"
      expr: AVG(DATEDIFF(CAST(detection_timestamp AS DATE), CAST(occurrence_timestamp AS DATE)))
      comment: "Average days from occurrence to detection - visibility and monitoring effectiveness metric"
    - name: "customer_notification_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_customer_notified = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of exceptions with customer notification - communication compliance metric"
    - name: "escalation_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN escalation_level IS NOT NULL AND escalation_level != 'None' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of exceptions requiring escalation - complexity and severity indicator"
    - name: "avg_temperature_excursion_range"
      expr: AVG(CAST(temperature_excursion_max_c AS DOUBLE) - CAST(temperature_excursion_min_c AS DOUBLE))
      comment: "Average temperature excursion range for cold chain exceptions - quality risk metric"
    - name: "unresolved_exception_count"
      expr: SUM(CASE WHEN status NOT IN ('Resolved', 'Closed') THEN 1 ELSE 0 END)
      comment: "Count of unresolved exceptions - operational backlog metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_customs_declaration`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customs declaration KPIs measuring clearance efficiency, duty costs, compliance rates, and cross-border trade performance - critical for international logistics and trade compliance"
  source: "`manufacturing_ecm`.`logistics`.`customs_declaration`"
  dimensions:
    - name: "declaration_type"
      expr: declaration_type
      comment: "Type of customs declaration (import, export, transit)"
    - name: "compliance_status"
      expr: compliance_status
      comment: "Compliance status (compliant, non-compliant, pending review)"
    - name: "status"
      expr: status
      comment: "Current status of the declaration (filed, cleared, held, rejected)"
    - name: "country_of_import_code"
      expr: country_of_import_code
      comment: "Import country for trade lane analysis"
    - name: "country_of_export_code"
      expr: country_of_export_code
      comment: "Export country for trade lane analysis"
    - name: "country_of_origin_code"
      expr: country_of_origin_code
      comment: "Country of origin for preferential trade analysis"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "customs_broker_name"
      expr: customs_broker_name
      comment: "Customs broker handling the declaration"
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms governing customs responsibility"
    - name: "trade_agreement_code"
      expr: trade_agreement_code
      comment: "Trade agreement code for preferential duty analysis"
    - name: "preferential_origin"
      expr: preferential_origin
      comment: "Flag indicating preferential origin status"
    - name: "is_reach_compliant"
      expr: is_reach_compliant
      comment: "REACH compliance flag"
    - name: "is_rohs_compliant"
      expr: is_rohs_compliant
      comment: "RoHS compliance flag"
    - name: "filing_date"
      expr: filing_date
      comment: "Filing date for time-series analysis"
    - name: "clearance_date"
      expr: clearance_date
      comment: "Clearance date"
  measures:
    - name: "total_declarations"
      expr: COUNT(1)
      comment: "Total number of customs declarations - baseline metric for cross-border trade volume"
    - name: "total_declared_value"
      expr: SUM(CAST(declared_value AS DOUBLE))
      comment: "Total declared value of goods - trade value metric for duty calculation basis"
    - name: "total_duty_amount"
      expr: SUM(CAST(duty_amount AS DOUBLE))
      comment: "Total duty amount paid - direct cost of international trade"
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount (VAT, GST, etc.) - indirect tax burden"
    - name: "total_customs_cost"
      expr: SUM(CAST(duty_amount AS DOUBLE) + CAST(tax_amount AS DOUBLE))
      comment: "Total customs cost (duty + tax) - comprehensive landed cost component for pricing decisions"
    - name: "avg_duty_rate"
      expr: ROUND(AVG(CAST(duty_rate_percent AS DOUBLE)), 2)
      comment: "Average duty rate percentage - effective tariff rate metric"
    - name: "effective_duty_rate"
      expr: ROUND(100.0 * SUM(CAST(duty_amount AS DOUBLE)) / NULLIF(SUM(CAST(declared_value AS DOUBLE)), 0), 2)
      comment: "Effective duty rate (duty/declared value) - actual duty burden for trade optimization"
    - name: "avg_clearance_time_days"
      expr: AVG(DATEDIFF(clearance_date, filing_date))
      comment: "Average days from filing to clearance - customs efficiency and supply chain velocity metric"
    - name: "clearance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN status = 'Cleared' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of declarations cleared - customs success rate"
    - name: "compliance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN compliance_status = 'Compliant' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of compliant declarations - regulatory compliance metric"
    - name: "preferential_origin_utilization_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN preferential_origin = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of declarations using preferential origin - FTA utilization metric for duty savings"
    - name: "total_gross_weight_kg"
      expr: SUM(CAST(gross_weight_kg AS DOUBLE))
      comment: "Total gross weight in kilograms - trade volume metric"
    - name: "total_net_weight_kg"
      expr: SUM(CAST(net_weight_kg AS DOUBLE))
      comment: "Total net weight in kilograms - actual goods weight"
    - name: "avg_declared_value_per_kg"
      expr: ROUND(SUM(CAST(declared_value AS DOUBLE)) / NULLIF(SUM(CAST(net_weight_kg AS DOUBLE)), 0), 2)
      comment: "Average declared value per kilogram - value density metric for risk profiling"
    - name: "reach_compliance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_reach_compliant = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "REACH compliance rate - EU chemical regulation compliance metric"
    - name: "rohs_compliance_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN is_rohs_compliant = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "RoHS compliance rate - electronics regulation compliance metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_route`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Route performance KPIs measuring distance, cost, transit time, and sustainability - critical for network optimization and carrier selection"
  source: "`manufacturing_ecm`.`logistics`.`route`"
  dimensions:
    - name: "route_id"
      expr: route_id
      comment: "Unique route identifier"
    - name: "code"
      expr: code
      comment: "Route code"
    - name: "name"
      expr: name
      comment: "Route name"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "service_type"
      expr: service_type
      comment: "Service type (direct, hub, milk run)"
    - name: "type"
      expr: type
      comment: "Route type (inbound, outbound, interplant)"
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "Origin country"
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "Destination country"
    - name: "origin_location_code"
      expr: origin_location_code
      comment: "Origin location code"
    - name: "destination_location_code"
      expr: destination_location_code
      comment: "Destination location code"
    - name: "preferred_carrier_code"
      expr: preferred_carrier_code
      comment: "Preferred carrier for the route"
    - name: "status"
      expr: status
      comment: "Route status (active, inactive, planned)"
    - name: "customs_required"
      expr: customs_required
      comment: "Flag indicating customs clearance required"
    - name: "hazmat_permitted"
      expr: hazmat_permitted
      comment: "Flag indicating hazmat permitted"
    - name: "temperature_controlled"
      expr: temperature_controlled
      comment: "Flag indicating temperature-controlled capability"
  measures:
    - name: "total_routes"
      expr: COUNT(1)
      comment: "Total number of routes - baseline metric for network complexity"
    - name: "total_distance_km"
      expr: SUM(CAST(distance_km AS DOUBLE))
      comment: "Total distance in kilometers - network coverage metric"
    - name: "avg_distance_km"
      expr: AVG(CAST(distance_km AS DOUBLE))
      comment: "Average route distance in kilometers - network design metric"
    - name: "total_standard_freight_cost"
      expr: SUM(CAST(standard_freight_cost AS DOUBLE))
      comment: "Total standard freight cost across all routes - network cost baseline"
    - name: "avg_freight_cost_per_km"
      expr: ROUND(SUM(CAST(standard_freight_cost AS DOUBLE)) / NULLIF(SUM(CAST(distance_km AS DOUBLE)), 0), 4)
      comment: "Average freight cost per kilometer - cost efficiency metric for mode and carrier benchmarking"
    - name: "avg_co2_emission_factor"
      expr: AVG(CAST(co2_emission_factor_kg_per_km AS DOUBLE))
      comment: "Average CO2 emission factor per kilometer - sustainability metric for carbon footprint management"
    - name: "total_co2_emissions_kg"
      expr: SUM(CAST(distance_km AS DOUBLE) * CAST(co2_emission_factor_kg_per_km AS DOUBLE))
      comment: "Total CO2 emissions in kilograms - environmental impact metric for ESG reporting"
    - name: "avg_max_weight_capacity_kg"
      expr: AVG(CAST(max_weight_kg AS DOUBLE))
      comment: "Average maximum weight capacity per route - capacity planning metric"
    - name: "avg_max_volume_capacity_m3"
      expr: AVG(CAST(max_volume_m3 AS DOUBLE))
      comment: "Average maximum volume capacity per route - capacity planning metric"
    - name: "cross_border_route_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN customs_required = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of routes requiring customs - complexity metric for international logistics"
    - name: "hazmat_capable_route_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN hazmat_permitted = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of routes permitting hazmat - specialized capability metric"
    - name: "temp_controlled_route_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN temperature_controlled = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of temperature-controlled routes - cold chain capability metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_delivery`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Delivery execution KPIs measuring volumes, weights, on-time performance, and goods movement status - critical for outbound logistics operations and customer service"
  source: "`manufacturing_ecm`.`logistics`.`delivery`"
  dimensions:
    - name: "carrier_id"
      expr: carrier_id
      comment: "Carrier executing the delivery"
    - name: "status"
      expr: status
      comment: "Delivery status (planned, in transit, delivered, cancelled)"
    - name: "overall_goods_movement_status"
      expr: overall_goods_movement_status
      comment: "Overall goods movement status"
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation"
    - name: "type"
      expr: type
      comment: "Delivery type (standard, rush, direct)"
    - name: "ship_from_country_code"
      expr: ship_from_country_code
      comment: "Ship-from country"
    - name: "ship_to_country_code"
      expr: ship_to_country_code
      comment: "Ship-to country"
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms governing delivery"
    - name: "freight_terms"
      expr: freight_terms
      comment: "Freight terms (prepaid, collect)"
    - name: "priority_level"
      expr: priority_level
      comment: "Priority level (urgent, high, normal, low)"
    - name: "picking_status"
      expr: picking_status
      comment: "Picking status"
    - name: "packing_status"
      expr: packing_status
      comment: "Packing status"
    - name: "hazmat_indicator"
      expr: hazmat_indicator
      comment: "Hazmat indicator flag"
    - name: "planned_delivery_date"
      expr: planned_delivery_date
      comment: "Planned delivery date for time-series analysis"
    - name: "actual_delivery_date"
      expr: actual_delivery_date
      comment: "Actual delivery date"
  measures:
    - name: "total_deliveries"
      expr: COUNT(1)
      comment: "Total number of deliveries - baseline volume metric for outbound logistics capacity planning"
    - name: "total_delivery_quantity"
      expr: SUM(CAST(total_delivery_quantity AS DOUBLE))
      comment: "Total quantity delivered - fulfillment volume metric"
    - name: "total_gross_weight_kg"
      expr: SUM(CAST(total_gross_weight_kg AS DOUBLE))
      comment: "Total gross weight in kilograms - capacity utilization metric"
    - name: "total_net_weight_kg"
      expr: SUM(CAST(total_net_weight_kg AS DOUBLE))
      comment: "Total net weight in kilograms - actual goods weight"
    - name: "total_volume_m3"
      expr: SUM(CAST(total_volume_m3 AS DOUBLE))
      comment: "Total volume in cubic meters - capacity utilization metric"
    - name: "avg_weight_per_delivery_kg"
      expr: AVG(CAST(total_gross_weight_kg AS DOUBLE))
      comment: "Average weight per delivery - shipment profile metric"
    - name: "avg_volume_per_delivery_m3"
      expr: AVG(CAST(total_volume_m3 AS DOUBLE))
      comment: "Average volume per delivery - shipment profile metric"
    - name: "on_time_delivery_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN actual_delivery_date <= planned_delivery_date THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN actual_delivery_date IS NOT NULL THEN 1 ELSE 0 END), 0), 2)
      comment: "On-time delivery rate - primary customer service KPI"
    - name: "avg_delivery_lead_time_days"
      expr: AVG(DATEDIFF(actual_delivery_date, goods_issue_date))
      comment: "Average delivery lead time in days - operational efficiency metric"
    - name: "short_shipment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN CAST(short_ship_quantity AS DOUBLE) > 0 THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of deliveries with short shipments - fulfillment quality metric"
    - name: "over_shipment_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN CAST(over_ship_quantity AS DOUBLE) > 0 THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of deliveries with over shipments - inventory control metric"
    - name: "hazmat_delivery_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN hazmat_indicator = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of hazmat deliveries - compliance and risk metric"
    - name: "completed_delivery_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN status = 'Delivered' OR status = 'Completed' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of completed deliveries - execution success rate"
$$;