-- Metric views for domain: logistics | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_delivery_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Outbound delivery execution KPIs measuring on-time delivery (OTD), goods issue cycle time, short-ship and over-ship variances, and shipment volume throughput. Primary scorecard for logistics execution and customer service level performance."
  source: "`manufacturing_ecm`.`logistics`.`delivery`"
  dimensions:
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation (road, rail, air, ocean, multimodal) used for the delivery. Enables modal performance benchmarking and cost-to-serve analysis."
    - name: "ship_from_country_code"
      expr: ship_from_country_code
      comment: "ISO 3166-1 alpha-3 origin country of the shipment. Used for regional logistics performance analysis and export compliance reporting."
    - name: "ship_to_country_code"
      expr: ship_to_country_code
      comment: "ISO 3166-1 alpha-3 destination country. Enables trade lane performance analysis and import duty applicability assessment."
    - name: "delivery_type"
      expr: type
      comment: "Classification of the delivery (customer outbound, interplant transfer, DC replenishment, return, subcontractor). Segments performance by delivery scenario."
    - name: "priority_level"
      expr: priority_level
      comment: "Business priority assigned to the delivery (e.g., critical, high, standard). Enables SLA compliance analysis by priority tier."
    - name: "shipping_point"
      expr: shipping_point
      comment: "SAP shipping point (plant/warehouse/dock) from which the delivery was dispatched. Supports facility-level throughput and workload analysis."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms 2020 code governing risk and cost transfer. Used to segment freight cost ownership and liability analysis."
    - name: "goods_issue_month"
      expr: DATE_TRUNC('MONTH', goods_issue_date)
      comment: "Month in which goods issue was posted. Enables period-over-period delivery volume and performance trending."
    - name: "planned_delivery_month"
      expr: DATE_TRUNC('MONTH', planned_delivery_date)
      comment: "Month of the planned delivery date. Used for forward-looking delivery commitment analysis and capacity planning."
    - name: "hazmat_indicator"
      expr: hazmat_indicator
      comment: "Flag indicating whether the delivery contains hazardous materials. Enables HAZMAT-specific compliance and carrier performance segmentation."
  measures:
    - name: "total_deliveries"
      expr: COUNT(1)
      comment: "Total number of outbound delivery documents. Baseline volume metric for throughput analysis and capacity planning."
    - name: "on_time_deliveries"
      expr: COUNT(CASE WHEN actual_delivery_date <= planned_delivery_date THEN 1 END)
      comment: "Number of deliveries where actual delivery date was on or before the planned delivery date. Numerator for OTD rate calculation."
    - name: "late_deliveries"
      expr: COUNT(CASE WHEN actual_delivery_date > planned_delivery_date THEN 1 END)
      comment: "Number of deliveries where actual delivery date exceeded the planned delivery date. Drives carrier performance management and root cause analysis."
    - name: "deliveries_with_pod_confirmed"
      expr: COUNT(CASE WHEN pod_date IS NOT NULL THEN 1 END)
      comment: "Number of deliveries with confirmed proof of delivery. Measures POD completion rate, which drives billing and revenue recognition in POD-based scenarios."
    - name: "total_gross_weight_kg"
      expr: SUM(CAST(total_gross_weight_kg AS DOUBLE))
      comment: "Total gross weight shipped across all deliveries in kilograms. Key input for freight cost allocation, carrier capacity utilization, and customs reporting."
    - name: "total_net_weight_kg"
      expr: SUM(CAST(total_net_weight_kg AS DOUBLE))
      comment: "Total net weight shipped excluding packaging. Used for customs valuation and REACH/RoHS compliance declarations."
    - name: "total_volume_m3"
      expr: SUM(CAST(total_volume_m3 AS DOUBLE))
      comment: "Total volumetric shipment size in cubic meters. Drives truck/container utilization analysis and dimensional weight freight cost estimation."
    - name: "total_short_ship_quantity"
      expr: SUM(CAST(short_ship_quantity AS DOUBLE))
      comment: "Total quantity short-shipped across all deliveries. Non-zero values indicate fulfillment gaps that trigger back-order processing and customer notifications."
    - name: "total_over_ship_quantity"
      expr: SUM(CAST(over_ship_quantity AS DOUBLE))
      comment: "Total quantity over-shipped across all deliveries. Drives credit memo processing and customer approval workflows."
    - name: "total_delivery_quantity"
      expr: SUM(CAST(total_delivery_quantity AS DOUBLE))
      comment: "Total quantity dispatched across all delivery documents. Baseline for fulfillment rate and short-ship variance analysis."
    - name: "deliveries_with_short_ship"
      expr: COUNT(CASE WHEN short_ship_quantity > 0 THEN 1 END)
      comment: "Number of deliveries with at least one short-shipped line. Measures fulfillment reliability and production/inventory alignment."
    - name: "avg_delivery_gross_weight_kg"
      expr: AVG(CAST(total_gross_weight_kg AS DOUBLE))
      comment: "Average gross weight per delivery in kilograms. Used for carrier load planning benchmarks and freight cost per shipment analysis."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_order_execution`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight order execution KPIs covering carrier pickup punctuality, transit time actuals vs. plan, freight cost estimation accuracy, and load utilization. Core operational scorecard for TMS execution performance and carrier management."
  source: "`manufacturing_ecm`.`logistics`.`freight_order`"
  dimensions:
    - name: "transport_mode"
      expr: transport_mode
      comment: "Primary mode of transportation (road, rail, air, ocean, intermodal). Enables modal cost and performance benchmarking."
    - name: "order_type"
      expr: order_type
      comment: "Classification of the freight order (inbound, outbound, interplant, return, cross-dock, drop-ship). Segments execution KPIs by operational scenario."
    - name: "service_level"
      expr: service_level
      comment: "Contracted service level (standard, express, priority, dedicated). Enables SLA compliance analysis by service tier."
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "ISO 3166-1 alpha-3 origin country. Supports trade lane performance analysis and export compliance reporting."
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "ISO 3166-1 alpha-3 destination country. Enables import duty applicability and lane-level cost analysis."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the freight order (created, confirmed, in_transit, delivered, cancelled). Tracks execution pipeline health."
    - name: "hazmat_flag"
      expr: hazmat_flag
      comment: "Indicates whether the freight order contains hazardous materials. Enables HAZMAT compliance and carrier certification analysis."
    - name: "planned_pickup_month"
      expr: DATE_TRUNC('MONTH', planned_pickup_date)
      comment: "Month of planned carrier pickup. Enables monthly freight volume and cost trending."
    - name: "planned_delivery_month"
      expr: DATE_TRUNC('MONTH', planned_delivery_date)
      comment: "Month of planned delivery date. Used for forward-looking capacity and SLA commitment analysis."
    - name: "temperature_controlled_flag"
      expr: temperature_controlled_flag
      comment: "Indicates whether the freight order requires cold chain transport. Segments cold chain vs. ambient freight performance."
  measures:
    - name: "total_freight_orders"
      expr: COUNT(1)
      comment: "Total number of freight orders. Baseline volume metric for TMS execution throughput and carrier workload analysis."
    - name: "on_time_pickup_orders"
      expr: COUNT(CASE WHEN actual_pickup_timestamp <= planned_pickup_timestamp THEN 1 END)
      comment: "Number of freight orders where the carrier picked up on or before the planned pickup time. Numerator for carrier pickup punctuality rate."
    - name: "on_time_delivery_orders"
      expr: COUNT(CASE WHEN actual_delivery_timestamp <= planned_delivery_timestamp THEN 1 END)
      comment: "Number of freight orders delivered on or before the planned delivery timestamp. Numerator for freight order OTD rate."
    - name: "total_confirmed_freight_cost"
      expr: SUM(CAST(confirmed_freight_cost AS DOUBLE))
      comment: "Total confirmed (actual) freight cost across all executed freight orders. Primary freight spend metric for cost-to-serve and P&L reporting."
    - name: "total_estimated_freight_cost"
      expr: SUM(CAST(estimated_freight_cost AS DOUBLE))
      comment: "Total pre-execution estimated freight cost. Used as the budget baseline for actual vs. estimated freight cost variance analysis."
    - name: "avg_confirmed_freight_cost"
      expr: AVG(CAST(confirmed_freight_cost AS DOUBLE))
      comment: "Average confirmed freight cost per freight order. Benchmarks cost efficiency across carriers, modes, and lanes."
    - name: "total_gross_weight_kg"
      expr: SUM(CAST(gross_weight_kg AS DOUBLE))
      comment: "Total gross weight shipped across all freight orders in kilograms. Drives carrier capacity utilization and rate calculation validation."
    - name: "total_volume_m3"
      expr: SUM(CAST(volume_m3 AS DOUBLE))
      comment: "Total cubic volume across all freight orders in cubic meters. Used for container/truck utilization optimization and dimensional weight analysis."
    - name: "avg_loading_meters"
      expr: AVG(CAST(loading_meters AS DOUBLE))
      comment: "Average linear loading meters per freight order. Standard European road freight capacity metric for LTL/FTL determination and load planning."
    - name: "cancelled_freight_orders"
      expr: COUNT(CASE WHEN status = 'cancelled' THEN 1 END)
      comment: "Number of cancelled freight orders. Elevated cancellation rates signal carrier reliability issues, demand volatility, or route disruptions."
    - name: "hazmat_freight_orders"
      expr: COUNT(CASE WHEN hazmat_flag = TRUE THEN 1 END)
      comment: "Number of freight orders containing hazardous materials. Drives HAZMAT compliance monitoring and carrier certification validation."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_invoice_audit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight invoice audit and payment KPIs measuring invoice accuracy, dispute rates, overcharge recovery, fuel surcharge spend, and payment cycle time. Drives freight audit program effectiveness and carrier invoice compliance management."
  source: "`manufacturing_ecm`.`logistics`.`freight_invoice`"
  dimensions:
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation billed on the invoice. Enables freight cost analysis and rate validation by modal category."
    - name: "audit_status"
      expr: audit_status
      comment: "Freight audit status (passed, failed, pending, disputed). Segments invoices by audit outcome for exception management."
    - name: "invoice_status"
      expr: status
      comment: "Current payment lifecycle status of the freight invoice (received, under_audit, approved, disputed, paid). Tracks AP workflow health."
    - name: "invoice_type"
      expr: invoice_type
      comment: "Classification of the invoice (standard, consolidated, credit, debit, re-bill). Enables billing pattern analysis."
    - name: "service_level"
      expr: service_level
      comment: "Contracted service level under which the freight was shipped. Validates that billed service level matches contracted rates."
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "ISO 3166-1 alpha-3 shipment origin country. Enables trade lane freight cost allocation and customs compliance analysis."
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "ISO 3166-1 alpha-3 shipment destination country. Supports import duty applicability and lane-level cost benchmarking."
    - name: "functional_currency_code"
      expr: functional_currency_code
      comment: "Functional reporting currency for financial consolidation. Ensures consistent multi-currency freight cost reporting."
    - name: "audit_exception_code"
      expr: audit_exception_code
      comment: "Standardized exception code for audit failures (RATE_MISMATCH, DUPLICATE_INVOICE, UNAUTHORIZED_ACCESSORIAL, WEIGHT_DISCREPANCY). Drives root cause analysis."
    - name: "invoice_month"
      expr: DATE_TRUNC('MONTH', billing_period_start_date)
      comment: "Month of the billing period start date. Enables monthly freight spend trending and period-over-period variance analysis."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Contracted payment terms (NET30, NET45, etc.). Used for cash flow forecasting and early payment discount analysis."
  measures:
    - name: "total_freight_invoices"
      expr: COUNT(1)
      comment: "Total number of freight invoices received. Baseline volume metric for freight audit workload and AP processing capacity planning."
    - name: "total_invoiced_amount_functional"
      expr: SUM(CAST(invoiced_amount_functional AS DOUBLE))
      comment: "Total gross freight spend in functional reporting currency across all invoices. Primary freight cost KPI for P&L, OPEX, and cost-to-serve reporting."
    - name: "total_approved_amount"
      expr: SUM(CAST(approved_amount AS DOUBLE))
      comment: "Total amount approved for payment after freight audit and dispute resolution. Represents validated freight spend net of overcharges."
    - name: "total_base_freight_amount"
      expr: SUM(CAST(base_freight_amount AS DOUBLE))
      comment: "Total base freight charges excluding surcharges and accessorials. Used for rate benchmarking and contracted rate compliance validation."
    - name: "total_fuel_surcharge_amount"
      expr: SUM(CAST(fuel_surcharge_amount AS DOUBLE))
      comment: "Total fuel surcharge spend across all invoices. Tracks fuel cost exposure and validates surcharge calculations against contracted fuel index tables."
    - name: "total_accessorial_amount"
      expr: SUM(CAST(accessorial_amount AS DOUBLE))
      comment: "Total accessorial charges (liftgate, detention, residential delivery, etc.). Elevated accessorials signal operational inefficiencies or unauthorized carrier charges."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total contractual discounts and rebates applied by carriers. Measures discount capture effectiveness against negotiated contract terms."
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax charges (VAT, GST) on freight invoices. Required for tax input credit recovery and compliance reporting."
    - name: "disputed_invoices"
      expr: COUNT(CASE WHEN status = 'disputed' THEN 1 END)
      comment: "Number of freight invoices in disputed status. High dispute counts indicate systemic carrier billing issues or rate contract misalignment."
    - name: "audit_failed_invoices"
      expr: COUNT(CASE WHEN audit_status = 'failed' THEN 1 END)
      comment: "Number of invoices that failed freight audit. Numerator for audit failure rate; drives overcharge recovery and carrier corrective action."
    - name: "paid_invoices"
      expr: COUNT(CASE WHEN payment_date IS NOT NULL THEN 1 END)
      comment: "Number of invoices with confirmed payment. Used to track AP payment cycle completion and on-time payment KPI."
    - name: "avg_invoiced_amount_functional"
      expr: AVG(CAST(invoiced_amount_functional AS DOUBLE))
      comment: "Average freight invoice value in functional currency. Benchmarks invoice size trends and identifies anomalous billing patterns."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_carrier_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Carrier master KPIs measuring on-time delivery performance, claims exposure, cargo liability coverage, and carrier portfolio health. Drives carrier scorecard, performance tier management, and strategic carrier selection decisions."
  source: "`manufacturing_ecm`.`logistics`.`carrier`"
  dimensions:
    - name: "transport_mode"
      expr: transport_mode
      comment: "Primary transportation mode offered by the carrier (road, rail, air, ocean, intermodal). Enables modal carrier portfolio analysis."
    - name: "performance_tier"
      expr: performance_tier
      comment: "Carrier performance tier (e.g., preferred, approved, conditional, probationary). Drives carrier selection priority in TMS route optimization."
    - name: "carrier_status"
      expr: status
      comment: "Current operational status of the carrier master record (active, inactive, suspended). Controls carrier availability for TMS booking."
    - name: "country_of_registration"
      expr: country_of_registration
      comment: "ISO 3166-1 alpha-3 country where the carrier is legally registered. Used for trade compliance and regulatory verification analysis."
    - name: "carrier_type"
      expr: type
      comment: "Carrier business model classification (asset-based, non-asset/broker, hybrid). Drives contract terms and liability rule segmentation."
    - name: "safety_rating"
      expr: safety_rating
      comment: "FMCSA safety fitness rating for road carriers. Used in carrier qualification screening and compliance risk assessment."
    - name: "hazmat_certified"
      expr: hazmat_certified
      comment: "Indicates whether the carrier is certified for HAZMAT transport. Enables HAZMAT-capable carrier pool analysis."
    - name: "edi_capable"
      expr: edi_capable
      comment: "Indicates whether the carrier supports EDI integration. Drives TMS automation capability assessment."
    - name: "insurance_expiry_month"
      expr: DATE_TRUNC('MONTH', insurance_expiry_date)
      comment: "Month of insurance certificate expiry. Enables proactive insurance renewal monitoring and compliance risk management."
    - name: "contract_end_month"
      expr: DATE_TRUNC('MONTH', contract_end_date)
      comment: "Month of carrier contract expiry. Drives proactive contract renewal planning and carrier renegotiation scheduling."
  measures:
    - name: "total_carriers"
      expr: COUNT(1)
      comment: "Total number of carrier master records. Baseline for carrier portfolio size and diversity analysis."
    - name: "active_carriers"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Number of carriers with active status available for TMS booking. Measures effective carrier pool size for route coverage."
    - name: "avg_on_time_delivery_rate"
      expr: AVG(CAST(on_time_delivery_rate AS DOUBLE))
      comment: "Average on-time delivery rate across all carriers (trailing 12-month). Portfolio-level OTD benchmark for carrier scorecard and performance tier assignment."
    - name: "avg_claims_ratio"
      expr: AVG(CAST(claims_ratio AS DOUBLE))
      comment: "Average freight damage/loss claims ratio across all carriers (trailing 12-month). Elevated values signal cargo handling quality issues and insurance risk exposure."
    - name: "total_cargo_liability_limit"
      expr: SUM(CAST(cargo_liability_limit AS DOUBLE))
      comment: "Total cargo liability coverage across all active carriers. Measures aggregate insurance protection for the carrier portfolio."
    - name: "avg_cargo_liability_limit"
      expr: AVG(CAST(cargo_liability_limit AS DOUBLE))
      comment: "Average cargo liability limit per carrier. Benchmarks insurance coverage adequacy against shipment values and risk exposure."
    - name: "carriers_expiring_insurance_90d"
      expr: COUNT(CASE WHEN insurance_expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Number of carriers with insurance certificates expiring within 90 days. Drives proactive renewal outreach to prevent use of uninsured carriers."
    - name: "carriers_expiring_contract_90d"
      expr: COUNT(CASE WHEN contract_end_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Number of carriers with transportation contracts expiring within 90 days. Triggers contract renewal workflows and renegotiation planning."
    - name: "hazmat_certified_carriers"
      expr: COUNT(CASE WHEN hazmat_certified = TRUE THEN 1 END)
      comment: "Number of HAZMAT-certified carriers in the approved carrier list. Ensures sufficient HAZMAT-capable carrier coverage for dangerous goods shipments."
    - name: "edi_capable_carriers"
      expr: COUNT(CASE WHEN edi_capable = TRUE THEN 1 END)
      comment: "Number of EDI-capable carriers. Measures TMS automation coverage and identifies carriers requiring manual integration workarounds."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_inbound_delivery_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Inbound supplier delivery KPIs measuring supplier on-time delivery, goods receipt cycle time, quantity discrepancy rates, and delivery value throughput. Drives supplier performance management, three-way matching efficiency, and production material availability."
  source: "`manufacturing_ecm`.`logistics`.`inbound_delivery`"
  dimensions:
    - name: "delivery_type"
      expr: delivery_type
      comment: "Classification of the inbound delivery (standard PO, subcontract, returns, interplant). Segments performance by delivery scenario."
    - name: "material_type"
      expr: material_type
      comment: "Classification of received material (raw material, component, MRO, finished goods). Drives inventory valuation and MRP processing segmentation."
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "ISO 3166-1 alpha-3 country where received goods were manufactured. Required for customs declarations and REACH/RoHS compliance analysis."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms 2020 code governing risk and cost transfer for the inbound delivery. Determines freight cost ownership and customs obligation."
    - name: "quality_inspection_status"
      expr: quality_inspection_status
      comment: "Current quality inspection status (passed, failed, pending, quarantined). Enables quality-driven inventory availability analysis."
    - name: "discrepancy_type"
      expr: discrepancy_type
      comment: "Classification of receiving discrepancy (quantity, quality, documentation). Drives supplier corrective action and NCR routing."
    - name: "warehouse_number"
      expr: warehouse_number
      comment: "Receiving warehouse identifier. Enables facility-level inbound throughput and dock capacity analysis."
    - name: "expected_delivery_month"
      expr: DATE_TRUNC('MONTH', expected_delivery_date)
      comment: "Month of expected supplier delivery. Enables monthly inbound volume planning and supplier commitment tracking."
    - name: "grn_posting_month"
      expr: DATE_TRUNC('MONTH', grn_posting_date)
      comment: "Month of GRN posting. Used for period-end inventory valuation and accounts payable accrual analysis."
  measures:
    - name: "total_inbound_deliveries"
      expr: COUNT(1)
      comment: "Total number of inbound delivery records. Baseline volume metric for receiving throughput and dock scheduling analysis."
    - name: "on_time_inbound_deliveries"
      expr: COUNT(CASE WHEN actual_delivery_date <= expected_delivery_date THEN 1 END)
      comment: "Number of inbound deliveries received on or before the expected delivery date. Numerator for supplier on-time delivery rate."
    - name: "late_inbound_deliveries"
      expr: COUNT(CASE WHEN actual_delivery_date > expected_delivery_date THEN 1 END)
      comment: "Number of inbound deliveries received after the expected delivery date. Drives supplier performance management and production risk assessment."
    - name: "deliveries_with_discrepancy"
      expr: COUNT(CASE WHEN discrepancy_flag = TRUE THEN 1 END)
      comment: "Number of inbound deliveries with a quantity, quality, or documentation discrepancy. Numerator for discrepancy rate; triggers NCR and supplier CAPA workflows."
    - name: "total_received_quantity"
      expr: SUM(CAST(received_quantity AS DOUBLE))
      comment: "Total quantity of materials physically received across all inbound deliveries. Drives inventory replenishment and MRP availability confirmation."
    - name: "total_ordered_quantity"
      expr: SUM(CAST(ordered_quantity AS DOUBLE))
      comment: "Total quantity ordered on originating purchase orders. Denominator for receipt-to-order fulfillment rate calculation."
    - name: "total_open_quantity"
      expr: SUM(CAST(open_quantity AS DOUBLE))
      comment: "Total quantity still outstanding against open purchase orders. Drives supplier follow-up actions and MRP shortage alert management."
    - name: "total_delivery_value"
      expr: SUM(CAST(delivery_value AS DOUBLE))
      comment: "Total monetary value of received goods across all inbound deliveries. Used for GRN valuation, inventory accounting, and AP accrual reporting."
    - name: "avg_delivery_value"
      expr: AVG(CAST(delivery_value AS DOUBLE))
      comment: "Average value per inbound delivery. Benchmarks supplier shipment size and supports freight cost-per-value analysis."
    - name: "quality_inspection_required_count"
      expr: COUNT(CASE WHEN quality_inspection_required = TRUE THEN 1 END)
      comment: "Number of inbound deliveries requiring quality inspection before stock release. Drives QM workload planning and inspection lot management."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_cost_management`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight rate portfolio KPIs measuring contracted rate coverage, rate amount benchmarks, fuel surcharge exposure, and rate lifecycle health. Drives freight procurement strategy, rate negotiation effectiveness, and TMS rate governance."
  source: "`manufacturing_ecm`.`logistics`.`freight_rate`"
  dimensions:
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation to which the rate applies. Enables modal rate benchmarking and carrier selection cost analysis."
    - name: "rate_type"
      expr: rate_type
      comment: "Classification of the rate component (base_rate, fuel_surcharge, accessorial). Segments freight cost structure for spend analysis."
    - name: "rate_source"
      expr: rate_source
      comment: "Origin of the rate (contract, spot, benchmark, tariff). Measures contracted vs. spot rate utilization and procurement strategy effectiveness."
    - name: "service_level"
      expr: service_level
      comment: "Service level tier associated with the rate (standard, express, economy, priority). Enables cost-by-service-level analysis."
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "ISO 3166-1 alpha-3 origin country of the rate lane. Enables origin-level freight cost benchmarking."
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "ISO 3166-1 alpha-3 destination country of the rate lane. Supports trade lane rate analysis and import cost planning."
    - name: "rate_status"
      expr: status
      comment: "Lifecycle status of the rate record (active, expired, superseded, pending_approval). Controls rate availability for TMS cost estimation."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO 4217 currency in which the rate is denominated. Supports multi-currency rate portfolio analysis."
    - name: "rate_basis"
      expr: rate_basis
      comment: "Unit of measure for rate application (per kg, per pallet, per container, per mile). Enables rate structure analysis and invoice validation."
    - name: "effective_month"
      expr: DATE_TRUNC('MONTH', effective_date)
      comment: "Month the rate became effective. Enables rate lifecycle and contract renewal cycle analysis."
  measures:
    - name: "total_rate_records"
      expr: COUNT(1)
      comment: "Total number of freight rate records in the TMS. Baseline for rate portfolio size and coverage analysis."
    - name: "active_rate_records"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Number of currently active freight rates available for TMS cost estimation. Measures rate coverage health across lanes and modes."
    - name: "expiring_rates_90d"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Number of freight rates expiring within 90 days. Drives proactive rate renewal and carrier renegotiation to prevent TMS rate gaps."
    - name: "avg_rate_amount"
      expr: AVG(CAST(rate_amount AS DOUBLE))
      comment: "Average freight rate amount per rate record. Benchmarks rate levels across carriers, modes, and lanes for procurement negotiations."
    - name: "min_rate_amount"
      expr: MIN(rate_amount)
      comment: "Minimum freight rate amount in the portfolio. Identifies the most competitive rate available for a given lane or mode segment."
    - name: "max_rate_amount"
      expr: MAX(rate_amount)
      comment: "Maximum freight rate amount in the portfolio. Identifies rate ceiling exposure and outlier rates requiring renegotiation."
    - name: "avg_fuel_surcharge_pct"
      expr: AVG(CAST(fuel_surcharge_pct AS DOUBLE))
      comment: "Average fuel surcharge percentage across rate records. Measures fuel cost exposure and validates surcharge levels against contracted fuel index benchmarks."
    - name: "avg_minimum_charge"
      expr: AVG(CAST(minimum_charge AS DOUBLE))
      comment: "Average minimum freight charge floor across rate records. Used in freight cost estimation for small shipments and carrier cost recovery analysis."
    - name: "hazmat_eligible_rates"
      expr: COUNT(CASE WHEN hazmat_eligible = TRUE THEN 1 END)
      comment: "Number of freight rates eligible for HAZMAT shipments. Ensures sufficient HAZMAT rate coverage for dangerous goods transport planning."
    - name: "contract_rates"
      expr: COUNT(CASE WHEN rate_source = 'contract' THEN 1 END)
      comment: "Number of contracted freight rates. Measures contracted rate coverage vs. spot rate dependency — higher contracted coverage reduces freight cost volatility."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_transport_plan_efficiency`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Transport plan KPIs measuring freight spend planning accuracy, load consolidation efficiency, CO2 emissions footprint, and plan execution health. Drives Distribution Requirements Planning (DRP) effectiveness, freight budget management, and sustainability reporting."
  source: "`manufacturing_ecm`.`logistics`.`transport_plan`"
  dimensions:
    - name: "transport_mode"
      expr: transport_mode
      comment: "Primary mode of transportation in the plan (road, rail, air, ocean, intermodal). Enables modal cost and emissions benchmarking."
    - name: "plan_type"
      expr: plan_type
      comment: "Classification of the transport plan (outbound, inbound, interplant, cross-dock). Segments planning KPIs by operational scenario."
    - name: "plan_status"
      expr: status
      comment: "Current lifecycle status of the transport plan (draft, confirmed, in_execution, executed, cancelled, on_hold). Tracks planning pipeline health."
    - name: "optimization_objective"
      expr: optimization_objective
      comment: "TMS optimization criterion used (cost, time, CO2). Enables analysis of trade-offs between cost, speed, and sustainability objectives."
    - name: "service_level"
      expr: service_level
      comment: "Planned service level (standard, express, priority, dedicated). Enables cost-by-service-level planning analysis."
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "ISO 3166-1 alpha-3 freight origin country. Supports regional freight budget allocation and carrier lane management."
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "ISO 3166-1 alpha-3 freight destination country. Enables import/export compliance and lane-level cost planning."
    - name: "planning_organization"
      expr: planning_organization
      comment: "Organizational unit responsible for the transport plan. Supports multi-entity freight budget allocation and accountability reporting."
    - name: "planned_departure_month"
      expr: DATE_TRUNC('MONTH', planned_departure_date)
      comment: "Month of planned freight departure. Enables monthly freight volume and spend trending aligned with DRP cycles."
    - name: "hazmat_included"
      expr: hazmat_included
      comment: "Indicates whether the plan includes HAZMAT freight. Enables HAZMAT-specific compliance and carrier planning analysis."
  measures:
    - name: "total_transport_plans"
      expr: COUNT(1)
      comment: "Total number of transport plans. Baseline volume metric for TMS planning throughput and DRP cycle analysis."
    - name: "total_planned_freight_spend"
      expr: SUM(CAST(planned_freight_spend AS DOUBLE))
      comment: "Total planned freight cost across all transport plans. Primary freight budget KPI for OPEX planning and cost-to-serve analysis."
    - name: "avg_planned_freight_spend"
      expr: AVG(CAST(planned_freight_spend AS DOUBLE))
      comment: "Average planned freight spend per transport plan. Benchmarks plan-level cost efficiency across modes, lanes, and planning organizations."
    - name: "total_planned_weight_kg"
      expr: SUM(CAST(planned_weight_kg AS DOUBLE))
      comment: "Total planned gross weight across all transport plans in kilograms. Drives carrier capacity validation and load optimization analysis."
    - name: "total_planned_volume_m3"
      expr: SUM(CAST(planned_volume_m3 AS DOUBLE))
      comment: "Total planned freight volume in cubic meters. Used for container/truck utilization optimization and freight cost estimation."
    - name: "total_planned_co2_emissions_kg"
      expr: SUM(CAST(planned_co2_emissions_kg AS DOUBLE))
      comment: "Total planned CO2 equivalent emissions in kilograms across all transport plans. Core sustainability KPI for ESG reporting and carbon footprint management."
    - name: "avg_planned_co2_emissions_kg"
      expr: AVG(CAST(planned_co2_emissions_kg AS DOUBLE))
      comment: "Average planned CO2 emissions per transport plan. Benchmarks carbon efficiency across modes and optimization objectives."
    - name: "executed_transport_plans"
      expr: COUNT(CASE WHEN status = 'executed' THEN 1 END)
      comment: "Number of fully executed transport plans. Measures plan-to-execution conversion rate and DRP fulfillment effectiveness."
    - name: "cancelled_transport_plans"
      expr: COUNT(CASE WHEN status = 'cancelled' THEN 1 END)
      comment: "Number of cancelled transport plans. Elevated cancellation rates signal demand volatility, carrier unavailability, or route disruptions."
    - name: "customs_required_plans"
      expr: COUNT(CASE WHEN customs_required = TRUE THEN 1 END)
      comment: "Number of transport plans requiring customs clearance. Drives trade compliance workload planning and customs documentation resource allocation."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_shipment_item_fulfillment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Shipment item line-level KPIs measuring fulfillment rate, customs value throughput, weight and volume shipped, and compliance flags (REACH, RoHS, HAZMAT). Enables item-level traceability from sales order to physical delivery and drives order fulfillment quality management."
  source: "`manufacturing_ecm`.`logistics`.`shipment_item`"
  dimensions:
    - name: "item_status"
      expr: item_status
      comment: "Current processing status of the shipment item (picked, packed, shipped, delivered, exception). Tracks item-level fulfillment lifecycle."
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "ISO 3166-1 alpha-3 country where the material was manufactured. Required for customs declarations and preferential tariff determination."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms 2020 code for the shipment item. Governs title transfer and insurance obligations at the item level."
    - name: "is_hazardous"
      expr: is_hazardous
      comment: "Indicates whether the item contains hazardous materials. Enables HAZMAT compliance monitoring and dangerous goods documentation tracking."
    - name: "is_reach_compliant"
      expr: is_reach_compliant
      comment: "EU REACH compliance flag for the shipped item. Required for export to EU markets and customer compliance declarations."
    - name: "is_rohs_compliant"
      expr: is_rohs_compliant
      comment: "EU RoHS compliance flag for the shipped item. Required for electrical/electronic equipment exports to EU markets."
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code from which the item was shipped. Enables facility-level fulfillment performance and inventory allocation analysis."
    - name: "goods_issue_month"
      expr: DATE_TRUNC('MONTH', goods_issue_date)
      comment: "Month of goods issue posting. Enables period-level revenue recognition and COGS allocation analysis."
    - name: "promised_delivery_month"
      expr: DATE_TRUNC('MONTH', promised_delivery_date)
      comment: "Month of customer-committed delivery date. Used for OTIF measurement and customer promise management."
    - name: "export_control_classification"
      expr: export_control_classification
      comment: "ECCN or EAR99 export control classification. Enables export license requirement analysis and trade compliance risk segmentation."
  measures:
    - name: "total_shipment_items"
      expr: COUNT(1)
      comment: "Total number of shipment item lines. Baseline volume metric for outbound fulfillment throughput analysis."
    - name: "on_time_shipment_items"
      expr: COUNT(CASE WHEN actual_delivery_date <= promised_delivery_date THEN 1 END)
      comment: "Number of shipment items delivered on or before the customer-promised delivery date. Numerator for item-level OTIF rate calculation."
    - name: "total_quantity_shipped"
      expr: SUM(CAST(quantity_shipped AS DOUBLE))
      comment: "Total quantity dispatched across all shipment item lines. Core fulfillment volume metric for order completion analysis."
    - name: "total_quantity_ordered"
      expr: SUM(CAST(quantity_ordered AS DOUBLE))
      comment: "Total quantity requested on originating sales orders. Denominator for item-level fulfillment rate calculation."
    - name: "total_gross_weight_kg"
      expr: SUM(CAST(gross_weight_kg AS DOUBLE))
      comment: "Total gross weight shipped across all item lines in kilograms. Required for freight billing, carrier manifests, and customs documentation."
    - name: "total_net_weight_kg"
      expr: SUM(CAST(net_weight_kg AS DOUBLE))
      comment: "Total net weight shipped excluding packaging. Used for customs declarations and carrier weight compliance."
    - name: "total_volume_m3"
      expr: SUM(CAST(volume_m3 AS DOUBLE))
      comment: "Total volumetric shipment size in cubic meters. Drives freight space planning and dimensional weight calculation."
    - name: "total_customs_value"
      expr: SUM(CAST(customs_value AS DOUBLE))
      comment: "Total declared customs value across all shipment items. Used for import duty calculation and customs declaration filing."
    - name: "hazardous_shipment_items"
      expr: COUNT(CASE WHEN is_hazardous = TRUE THEN 1 END)
      comment: "Number of shipment item lines containing hazardous materials. Drives HAZMAT documentation compliance and carrier restriction validation."
    - name: "avg_unit_price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average selling price per unit across all shipment items. Used for commercial invoice benchmarking and revenue per shipment analysis."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_tracking_event_visibility`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Shipment tracking event KPIs measuring exception rates, dwell time at logistics nodes, delivery confirmation rates, and end-to-end shipment visibility coverage. Drives OTIF performance measurement, exception management, and carrier EDI/API integration health."
  source: "`manufacturing_ecm`.`logistics`.`tracking_event`"
  dimensions:
    - name: "event_type"
      expr: event_type
      comment: "Shipment milestone category (departed, in-transit, customs-cleared, out-for-delivery, delivered, exception). Drives OTIF measurement and visibility dashboard segmentation."
    - name: "transport_mode"
      expr: transport_mode
      comment: "Mode of transportation active at the time of the event. Enables modal performance benchmarking and carbon footprint analysis."
    - name: "event_source"
      expr: event_source
      comment: "Originating system of the tracking event (carrier EDI, TMS, GPS telematics, IIoT, manual). Measures tracking feed reliability and automation coverage."
    - name: "location_type"
      expr: location_type
      comment: "Type of location where the event occurred (port, warehouse, customs, carrier hub, customer site). Enables network bottleneck identification."
    - name: "customs_status"
      expr: customs_status
      comment: "Customs clearance status at the time of the event. Critical for cross-border trade compliance and import/export documentation management."
    - name: "exception_code"
      expr: exception_code
      comment: "Standardized exception classification code. Drives root cause analysis and carrier CAPA process management."
    - name: "carrier_name"
      expr: carrier_name
      comment: "Name of the carrier reporting the tracking event. Enables carrier-level visibility quality and exception rate benchmarking."
    - name: "event_month"
      expr: DATE_TRUNC('MONTH', event_timestamp)
      comment: "Month of the tracking event. Enables monthly exception trending and seasonal shipment visibility analysis."
    - name: "is_exception"
      expr: is_exception
      comment: "Boolean flag indicating whether the event represents a shipment exception. Primary filter for exception management dashboards."
  measures:
    - name: "total_tracking_events"
      expr: COUNT(1)
      comment: "Total number of tracking events ingested. Baseline metric for shipment visibility coverage and EDI/API feed volume analysis."
    - name: "exception_events"
      expr: COUNT(CASE WHEN is_exception = TRUE THEN 1 END)
      comment: "Number of tracking events flagged as shipment exceptions (delay, damage, lost, refused). Numerator for exception rate; drives carrier performance management."
    - name: "delivered_events"
      expr: COUNT(CASE WHEN event_type = 'delivered' THEN 1 END)
      comment: "Number of confirmed delivery events. Measures POD confirmation coverage and triggers billing/revenue recognition in POD-based scenarios."
    - name: "distinct_shipments_tracked"
      expr: COUNT(DISTINCT tracking_number)
      comment: "Number of distinct shipments with at least one tracking event. Measures end-to-end shipment visibility coverage across the carrier network."
    - name: "avg_dwell_time_minutes"
      expr: AVG(CAST(dwell_time_minutes AS DOUBLE))
      comment: "Average dwell time in minutes at event locations. Elevated dwell times identify terminal bottlenecks, detention charges, and customs clearance delays."
    - name: "distinct_carriers_tracked"
      expr: COUNT(DISTINCT carrier_id)
      comment: "Number of distinct carriers with active tracking events. Measures carrier tracking integration coverage and identifies carriers with visibility gaps."
    - name: "customs_cleared_events"
      expr: COUNT(CASE WHEN event_type = 'customs-cleared' THEN 1 END)
      comment: "Number of customs clearance confirmation events. Tracks cross-border shipment compliance milestone completion and customs processing throughput."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`logistics_freight_contract_governance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Freight contract portfolio KPIs measuring SLA commitment levels, penalty exposure, volume commitment coverage, contract lifecycle health, and insurance compliance. Drives freight procurement governance, contract renewal planning, and carrier SLA management."
  source: "`manufacturing_ecm`.`logistics`.`freight_contract`"
  dimensions:
    - name: "contract_type"
      expr: contract_type
      comment: "Commercial structure of the contract (spot, annual, multi-year, master, framework, lane-specific, dedicated, intermodal). Segments portfolio by contract strategy."
    - name: "transport_mode"
      expr: transport_mode
      comment: "Primary mode of transportation covered by the contract. Enables modal contract portfolio analysis."
    - name: "contract_status"
      expr: status
      comment: "Current lifecycle status of the freight contract (draft, approved, active, expired, terminated). Tracks contract portfolio health."
    - name: "geographic_scope"
      expr: geographic_scope
      comment: "Geographic coverage of the contract (domestic, regional, international, global). Enables geographic contract coverage analysis."
    - name: "service_level"
      expr: service_level
      comment: "Contracted service level tier (standard, express, priority, dedicated). Enables cost-by-service-level contract analysis."
    - name: "origin_country_code"
      expr: origin_country_code
      comment: "ISO 3166-1 alpha-3 primary origin country of the contract. Supports regional freight procurement analysis."
    - name: "destination_country_code"
      expr: destination_country_code
      comment: "ISO 3166-1 alpha-3 primary destination country of the contract. Enables trade lane contract coverage analysis."
    - name: "sla_penalty_clause"
      expr: sla_penalty_clause
      comment: "Type of SLA penalty mechanism (none, credit_per_day, pct_of_invoice, fixed_amount, service_credit). Segments contracts by penalty exposure type."
    - name: "expiry_month"
      expr: DATE_TRUNC('MONTH', expiry_date)
      comment: "Month of contract expiry. Drives proactive contract renewal planning and carrier renegotiation scheduling."
    - name: "hazmat_permitted"
      expr: hazmat_permitted
      comment: "Indicates whether HAZMAT transport is permitted under the contract. Ensures HAZMAT contract coverage for dangerous goods shipments."
  measures:
    - name: "total_freight_contracts"
      expr: COUNT(1)
      comment: "Total number of freight contracts in the portfolio. Baseline for contract portfolio size and carrier relationship management."
    - name: "active_freight_contracts"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Number of currently active freight contracts. Measures effective contract coverage for TMS rate and carrier assignment."
    - name: "contracts_expiring_90d"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Number of freight contracts expiring within 90 days. Drives proactive renewal workflows to prevent rate gaps and carrier disruptions."
    - name: "avg_sla_on_time_delivery_target_pct"
      expr: AVG(CAST(sla_on_time_delivery_target_pct AS DOUBLE))
      comment: "Average contractually committed OTD target percentage across all contracts. Benchmarks SLA ambition level and identifies contracts with below-standard commitments."
    - name: "total_sla_penalty_amount"
      expr: SUM(CAST(sla_penalty_amount AS DOUBLE))
      comment: "Total SLA penalty exposure across all contracts with fixed penalty clauses. Quantifies financial risk from carrier non-performance."
    - name: "total_minimum_volume_commitment"
      expr: SUM(CAST(minimum_volume_commitment AS DOUBLE))
      comment: "Total minimum volume commitment across all active contracts. Measures contractual freight volume obligations and shortfall penalty exposure."
    - name: "total_maximum_volume_cap"
      expr: SUM(CAST(maximum_volume_cap AS DOUBLE))
      comment: "Total maximum volume capacity committed by carriers across all contracts. Measures contracted carrier capacity ceiling for demand planning."
    - name: "avg_insurance_minimum_coverage"
      expr: AVG(CAST(insurance_minimum_coverage AS DOUBLE))
      comment: "Average minimum cargo insurance coverage required across all contracts. Benchmarks insurance protection standards in the carrier contract portfolio."
    - name: "auto_renewal_contracts"
      expr: COUNT(CASE WHEN auto_renewal_flag = TRUE THEN 1 END)
      comment: "Number of contracts with automatic renewal clauses. Identifies contracts requiring proactive cancellation notice to avoid unintended renewals."
    - name: "hazmat_permitted_contracts"
      expr: COUNT(CASE WHEN hazmat_permitted = TRUE THEN 1 END)
      comment: "Number of contracts authorizing HAZMAT transport. Ensures sufficient HAZMAT contract coverage for dangerous goods shipment planning."
$$;