-- Metric views for domain: service | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_service_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for customer service request performance, SLA compliance, escalation management, and customer satisfaction across the aftermarket service domain. Used by Service VPs and Operations Directors to steer field service quality and support efficiency."
  source: "`manufacturing_ecm`.`service`.`request`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the service request (open, resolved, closed, etc.), used to segment active vs. completed cases."
    - name: "severity"
      expr: severity
      comment: "Business impact severity classification (critical, high, medium, low) driving SLA tier assignment and dispatch prioritization."
    - name: "priority"
      expr: priority
      comment: "Operational priority level assigned to the service request for queue management and dispatch scheduling."
    - name: "category"
      expr: category
      comment: "High-level classification of the service request type (warranty claim, technical support, installation, etc.) for routing and SLA assignment."
    - name: "sub_category"
      expr: sub_category
      comment: "Secondary classification providing granular categorization within the primary case category (e.g., hardware_failure, software_bug)."
    - name: "origin_channel"
      expr: origin_channel
      comment: "Channel through which the customer initiated the service request (phone, email, web portal, field technician) for channel analytics."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the customer site for regional SLA management and compliance reporting."
    - name: "site_region"
      expr: site_region
      comment: "Geographic sales or service region (EMEA, Americas, APAC) for regional performance reporting and resource planning."
    - name: "product_line"
      expr: product_line
      comment: "Product line or family associated with the service request (Motion Control, Low Voltage Drives, Building Automation) for product-level analytics."
    - name: "assigned_team"
      expr: assigned_team
      comment: "Support team or service group currently assigned to the request for workload distribution and team-level SLA reporting."
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Categorized root cause of the reported issue for quality trend analysis and CAPA initiation."
    - name: "resolution_type"
      expr: resolution_type
      comment: "Classification of the resolution method applied to close the service request for service cost analysis."
    - name: "warranty_status"
      expr: warranty_status
      comment: "Warranty coverage status of the product at the time the service request was created, determining cost coverage."
    - name: "opened_month"
      expr: DATE_TRUNC('MONTH', opened_timestamp)
      comment: "Month in which the service request was opened, used for trend analysis and monthly SLA reporting."
    - name: "opened_year"
      expr: YEAR(opened_timestamp)
      comment: "Year in which the service request was opened for annual performance benchmarking."
  measures:
    - name: "total_service_requests"
      expr: COUNT(1)
      comment: "Total number of service requests in the period. Baseline volume KPI used by service operations to assess demand and capacity requirements."
    - name: "sla_breached_requests"
      expr: COUNT(CASE WHEN is_sla_breached = TRUE THEN 1 END)
      comment: "Number of service requests that breached their contractual SLA resolution target. Directly drives customer penalty exposure and contract risk."
    - name: "escalated_requests"
      expr: COUNT(CASE WHEN is_escalated = TRUE THEN 1 END)
      comment: "Number of service requests escalated beyond the initial support tier. High escalation volume signals systemic service quality issues requiring management intervention."
    - name: "warranty_claim_requests"
      expr: COUNT(CASE WHEN is_warranty_claim = TRUE THEN 1 END)
      comment: "Number of service requests formally classified as warranty claims. Drives warranty cost reserve planning and supplier chargeback decisions."
    - name: "avg_customer_satisfaction_score"
      expr: AVG(CAST(customer_satisfaction_score AS DOUBLE))
      comment: "Average customer satisfaction score (CSAT) collected via post-resolution survey. Primary customer experience KPI used in QBRs and NPS correlation analysis."
    - name: "avg_response_time_hours"
      expr: AVG(CAST(TIMESTAMPDIFF(MINUTE, opened_timestamp, first_response_timestamp) AS DOUBLE) / 60.0)
      comment: "Average time in hours from service request opening to first customer response. Core SLA performance indicator tracked against contractual response time commitments."
    - name: "avg_resolution_time_hours"
      expr: AVG(CAST(TIMESTAMPDIFF(MINUTE, opened_timestamp, resolved_timestamp) AS DOUBLE) / 60.0)
      comment: "Average time in hours from service request opening to resolution. Primary resolution SLA KPI used to assess service delivery efficiency and identify bottlenecks."
    - name: "critical_severity_requests"
      expr: COUNT(CASE WHEN severity = 'critical' THEN 1 END)
      comment: "Number of critical severity service requests (production stoppage or safety risk). Executives monitor this to assess operational risk exposure and emergency resource deployment."
    - name: "open_requests"
      expr: COUNT(CASE WHEN status NOT IN ('closed', 'resolved') THEN 1 END)
      comment: "Number of currently open service requests. Operational backlog KPI used for capacity planning and SLA risk assessment."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_sla_tracking`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Real-time and historical SLA compliance KPIs tracking response and resolution performance against contractual commitments. Used by Service Directors and Account Managers to manage SLA risk, penalty exposure, and escalation effectiveness across customer tiers and regions."
  source: "`manufacturing_ecm`.`service`.`sla_tracking`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current real-time SLA compliance status (on-track, at-risk, breached, completed, paused, cancelled) for operational monitoring."
    - name: "sla_tier"
      expr: sla_tier
      comment: "Service tier classification (Platinum, Gold, Silver, etc.) determining SLA target thresholds. Used to segment compliance by customer tier."
    - name: "sla_type"
      expr: sla_type
      comment: "Classification of the SLA commitment being tracked (response, resolution, on-site arrival) for granular compliance analysis."
    - name: "priority"
      expr: priority
      comment: "Priority level of the service request or field service order influencing applicable SLA targets."
    - name: "service_category"
      expr: service_category
      comment: "Category of service associated with the tracked request for SLA performance segmentation by service type."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the customer site for regional SLA compliance reporting."
    - name: "region_code"
      expr: region_code
      comment: "Internal business region code (EMEA, APAC, AMER) for regional SLA performance aggregation."
    - name: "assigned_team"
      expr: assigned_team
      comment: "Service team responsible for resolving the request, used for team-level SLA performance reporting."
    - name: "breach_reason_code"
      expr: breach_reason_code
      comment: "Standardized reason code explaining why the SLA was breached, used for root cause analysis and CAPA workflows."
    - name: "escalation_level"
      expr: escalation_level
      comment: "Escalation tier reached (Level 1 through Executive) for escalation effectiveness analysis."
    - name: "sla_start_month"
      expr: DATE_TRUNC('MONTH', sla_start_timestamp)
      comment: "Month the SLA clock started, used for monthly SLA compliance trend reporting."
    - name: "response_status"
      expr: response_status
      comment: "Compliance status for the response SLA milestone (met, breached) for granular response performance analysis."
    - name: "resolution_status"
      expr: resolution_status
      comment: "Compliance status for the resolution SLA milestone (met, breached) for granular resolution performance analysis."
  measures:
    - name: "total_sla_records"
      expr: COUNT(1)
      comment: "Total number of SLA tracking records in the period. Baseline volume for SLA compliance rate calculations."
    - name: "breached_sla_records"
      expr: COUNT(CASE WHEN status = 'breached' THEN 1 END)
      comment: "Number of SLA tracking records with a confirmed breach. Directly drives penalty liability and customer contract risk exposure."
    - name: "at_risk_sla_records"
      expr: COUNT(CASE WHEN status = 'at_risk' THEN 1 END)
      comment: "Number of SLA records currently at risk of breaching. Proactive operational KPI enabling intervention before formal breach occurs."
    - name: "escalated_sla_records"
      expr: COUNT(CASE WHEN is_escalated = TRUE THEN 1 END)
      comment: "Number of SLA tracking records that triggered escalation. High escalation rate signals systemic service delivery failures requiring management action."
    - name: "total_penalty_amount"
      expr: SUM(CAST(penalty_amount AS DOUBLE))
      comment: "Total financial penalty or service credit amount accrued from SLA breaches. Direct P&L impact metric used by Finance and Service leadership for contract risk management."
    - name: "avg_breach_duration_minutes"
      expr: AVG(CAST(breach_duration_minutes AS DOUBLE))
      comment: "Average number of minutes by which SLA targets were exceeded on breached records. Measures breach severity and informs penalty calculation and process improvement prioritization."
    - name: "penalty_applicable_records"
      expr: COUNT(CASE WHEN penalty_applicable = TRUE THEN 1 END)
      comment: "Number of SLA records where financial penalties are contractually applicable. Used by Finance to scope penalty liability exposure."
    - name: "completed_within_sla_records"
      expr: COUNT(CASE WHEN status = 'completed' THEN 1 END)
      comment: "Number of SLA records successfully completed within target. Numerator for SLA compliance rate calculation used in QBRs and customer reporting."
    - name: "avg_warning_threshold_percent"
      expr: AVG(CAST(warning_threshold_percent AS DOUBLE))
      comment: "Average warning threshold percentage configured across SLA records. Used to assess proactive alerting coverage and calibrate at-risk detection sensitivity."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_dispatch_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Field service dispatch efficiency and workforce utilization KPIs. Used by Field Service Managers and Operations Directors to optimize technician deployment, reduce SLA breach risk, and improve scheduling quality across service territories."
  source: "`manufacturing_ecm`.`service`.`dispatch_schedule`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current operational status of the dispatch schedule (scheduled, en-route, on-site, completed, cancelled) for real-time workforce visibility."
    - name: "priority"
      expr: priority
      comment: "Priority level of the dispatch assignment (critical, high, medium, low) influencing scheduling order and resource allocation."
    - name: "service_type"
      expr: service_type
      comment: "Classification of the field service activity being dispatched for workforce planning and SLA tracking by service type."
    - name: "scheduling_method"
      expr: scheduling_method
      comment: "Method by which the dispatch was scheduled (manual, auto-optimized, semi-automated) for scheduling efficiency analysis."
    - name: "required_skill"
      expr: required_skill
      comment: "Primary skill or certification required for the field service activity, used for skill-based scheduling analytics."
    - name: "site_country_code"
      expr: site_country_code
      comment: "ISO 3166-1 alpha-3 country code of the customer site for geographic dispatch analysis."
    - name: "site_city"
      expr: site_city
      comment: "City of the customer site for geographic dispatch analysis and territory management."
    - name: "scheduled_start_month"
      expr: DATE_TRUNC('MONTH', scheduled_start)
      comment: "Month of the scheduled dispatch start for monthly field service volume and utilization trend analysis."
    - name: "is_sla_breached"
      expr: is_sla_breached
      comment: "Indicates whether the dispatch resulted in an SLA breach, used to segment on-time vs. breached dispatches."
    - name: "parts_required"
      expr: parts_required
      comment: "Indicates whether spare parts were required for the dispatch, used for parts pre-staging effectiveness analysis."
    - name: "customer_signature_obtained"
      expr: customer_signature_obtained
      comment: "Indicates whether customer sign-off was obtained, used as a proxy for service delivery acceptance rate."
  measures:
    - name: "total_dispatches"
      expr: COUNT(1)
      comment: "Total number of field service dispatch records. Baseline volume KPI for field workforce utilization and capacity planning."
    - name: "sla_breached_dispatches"
      expr: COUNT(CASE WHEN is_sla_breached = TRUE THEN 1 END)
      comment: "Number of dispatches that resulted in an SLA breach. Directly drives customer penalty exposure and contract risk management decisions."
    - name: "cancelled_dispatches"
      expr: COUNT(CASE WHEN status = 'cancelled' THEN 1 END)
      comment: "Number of cancelled dispatch schedules. High cancellation rates signal scheduling instability, parts unavailability, or customer-side issues requiring operational intervention."
    - name: "avg_actual_duration_min"
      expr: AVG(CAST(actual_duration_min AS DOUBLE))
      comment: "Average actual on-site service duration in minutes. Used to calibrate scheduled duration standards, improve capacity planning, and identify inefficient service activities."
    - name: "avg_scheduled_duration_min"
      expr: AVG(CAST(scheduled_duration_min AS DOUBLE))
      comment: "Average planned duration in minutes allocated for service activities. Compared against actual duration to measure scheduling accuracy and identify systematic under/over-estimation."
    - name: "avg_actual_travel_time_min"
      expr: AVG(CAST(actual_travel_time_min AS DOUBLE))
      comment: "Average actual travel time in minutes to customer sites. Used for territory optimization, technician base location planning, and travel cost reduction initiatives."
    - name: "avg_estimated_travel_time_min"
      expr: AVG(CAST(estimated_travel_time_min AS DOUBLE))
      comment: "Average estimated travel time in minutes from the scheduling engine. Compared against actual travel time to assess routing algorithm accuracy."
    - name: "rescheduled_dispatches"
      expr: COUNT(CASE WHEN reschedule_count > 0 THEN 1 END)
      comment: "Number of dispatches that were rescheduled at least once. Scheduling instability indicator used to identify problematic service orders and improve first-time scheduling accuracy."
    - name: "customer_signature_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN customer_signature_obtained = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'completed' THEN 1 END), 0), 2)
      comment: "Percentage of completed dispatches where customer signature was obtained. Measures service delivery acceptance rate and documentation compliance."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_warranty_claim`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Warranty claim financial exposure, approval rates, and resolution cycle time KPIs. Used by Service Finance, Quality, and Product Management to manage warranty cost reserves, supplier chargebacks, and product quality improvement programs."
  source: "`manufacturing_ecm`.`service`.`warranty_claim`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the warranty claim (submitted, under_review, approved, rejected, settled) for pipeline management."
    - name: "claim_type"
      expr: claim_type
      comment: "Classification of the warranty claim resolution type (repair, replacement, credit, refund, field service) for cost and logistics planning."
    - name: "decision"
      expr: decision
      comment: "Final adjudication decision (approved, rejected, partially_approved) for approval rate analysis and customer communication."
    - name: "failure_mode"
      expr: failure_mode
      comment: "Standardized classification of the product failure type aligned with FMEA taxonomy for quality trending and root cause analysis."
    - name: "root_cause"
      expr: root_cause
      comment: "Determined root cause of the product failure for CAPA initiation and supplier chargeback decisions."
    - name: "product_category"
      expr: product_category
      comment: "High-level product category of the claimed item for warranty analytics and defect trending by product line."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the customer site for regional warranty analytics and statutory compliance."
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization responsible for the original product sale for warranty cost allocation and intercompany chargebacks."
    - name: "supplier_chargeback_flag"
      expr: supplier_chargeback_flag
      comment: "Indicates whether the warranty cost is charged back to a supplier, used to segment internal vs. supplier-recoverable warranty costs."
    - name: "is_within_warranty"
      expr: is_within_warranty
      comment: "Indicates whether the product was within its active warranty period at claim submission, used to validate coverage eligibility."
    - name: "submission_month"
      expr: DATE_TRUNC('MONTH', submission_date)
      comment: "Month of warranty claim submission for trend analysis and warranty reserve planning."
    - name: "submission_year"
      expr: YEAR(submission_date)
      comment: "Year of warranty claim submission for annual warranty cost benchmarking."
  measures:
    - name: "total_warranty_claims"
      expr: COUNT(1)
      comment: "Total number of warranty claims submitted. Baseline volume KPI for warranty reserve adequacy assessment and product quality monitoring."
    - name: "total_claimed_amount"
      expr: SUM(CAST(claimed_amount AS DOUBLE))
      comment: "Total monetary amount claimed by customers for warranty coverage. Primary warranty financial exposure KPI used by Finance for reserve provisioning."
    - name: "total_approved_amount"
      expr: SUM(CAST(approved_amount AS DOUBLE))
      comment: "Total monetary amount approved for warranty settlement. Actual warranty liability KPI used for P&L impact reporting and cost of quality analysis."
    - name: "total_repair_cost"
      expr: SUM(CAST(repair_cost AS DOUBLE))
      comment: "Total actual cost incurred to repair defective products under warranty. Used for warranty reserve accounting and cost of quality reporting."
    - name: "total_supplier_chargeback_amount"
      expr: SUM(CAST(supplier_chargeback_amount AS DOUBLE))
      comment: "Total monetary amount to be recovered from suppliers for defective components. Directly informs procurement supplier quality management and cost recovery programs."
    - name: "approved_claims"
      expr: COUNT(CASE WHEN decision = 'approved' THEN 1 END)
      comment: "Number of warranty claims approved for coverage. Numerator for warranty approval rate calculation used in customer satisfaction and quality reporting."
    - name: "rejected_claims"
      expr: COUNT(CASE WHEN decision = 'rejected' THEN 1 END)
      comment: "Number of warranty claims rejected. High rejection rates may indicate customer misuse patterns or documentation gaps requiring process improvement."
    - name: "supplier_chargeback_claims"
      expr: COUNT(CASE WHEN supplier_chargeback_flag = TRUE THEN 1 END)
      comment: "Number of warranty claims with supplier chargeback triggered. Used by Procurement to manage supplier quality scorecards and recovery negotiations."
    - name: "avg_resolution_cycle_days"
      expr: AVG(CAST(DATEDIFF(resolution_date, submission_date) AS DOUBLE))
      comment: "Average number of days from warranty claim submission to operational resolution. Measures warranty processing efficiency and customer experience impact."
    - name: "avg_approved_amount"
      expr: AVG(CAST(approved_amount AS DOUBLE))
      comment: "Average approved warranty settlement amount per claim. Used to benchmark claim severity and calibrate warranty reserve per unit sold."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_contract_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service contract portfolio value, coverage mix, and commercial terms KPIs. Used by Service Sales, Finance, and Contract Management to track contracted revenue, SLA exposure, and renewal pipeline across the service contract portfolio."
  source: "`manufacturing_ecm`.`service`.`contract_line`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the service contract line (active, suspended, cancelled) driving billing eligibility and SLA enforcement."
    - name: "service_type"
      expr: service_type
      comment: "Classification of the contracted service (preventive maintenance, corrective maintenance, remote monitoring, full-service) for portfolio mix analysis."
    - name: "service_category"
      expr: service_category
      comment: "High-level service category (hardware maintenance, software support, electrification services) for revenue reporting and portfolio analysis."
    - name: "billing_frequency"
      expr: billing_frequency
      comment: "Invoicing frequency (monthly, quarterly, annually, one-time) for revenue recognition scheduling and cash flow planning."
    - name: "billing_plan_type"
      expr: billing_plan_type
      comment: "Type of billing plan (periodic, milestone, on-demand, prepaid, postpaid) for invoicing logic and revenue recognition analysis."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the covered equipment installation site for regional contract portfolio analysis."
    - name: "coverage_hours"
      expr: coverage_hours
      comment: "Service coverage window (8x5, 24x7) defining SLA obligation hours for coverage tier mix analysis."
    - name: "profit_center"
      expr: profit_center
      comment: "SAP profit center to which contract line revenue is attributed for organizational profitability analysis."
    - name: "cost_center"
      expr: cost_center
      comment: "SAP cost center for service delivery cost allocation and margin analysis at the service delivery unit level."
    - name: "penalty_clause_applicable"
      expr: penalty_clause_applicable
      comment: "Indicates whether financial penalties apply if SLA targets are not met, used to segment high-risk contract lines."
    - name: "spare_parts_included"
      expr: spare_parts_included
      comment: "Indicates whether spare parts are included in the contract scope, affecting cost-to-serve and parts inventory planning."
    - name: "remote_monitoring_included"
      expr: remote_monitoring_included
      comment: "Indicates whether remote monitoring via IIoT is included, used to track digital service adoption across the contract portfolio."
    - name: "coverage_start_month"
      expr: DATE_TRUNC('MONTH', coverage_start_date)
      comment: "Month coverage begins for contract cohort analysis and renewal pipeline management."
    - name: "coverage_end_month"
      expr: DATE_TRUNC('MONTH', coverage_end_date)
      comment: "Month coverage expires for renewal tracking and at-risk contract identification."
  measures:
    - name: "total_contract_lines"
      expr: COUNT(1)
      comment: "Total number of service contract lines. Baseline portfolio size KPI for contract management and renewal planning."
    - name: "total_contracted_line_value"
      expr: SUM(CAST(line_value AS DOUBLE))
      comment: "Total contracted revenue value across all service contract lines. Primary service revenue backlog KPI used by Finance and Service Sales for revenue forecasting."
    - name: "active_contract_lines"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Number of currently active service contract lines. Measures the live service portfolio size driving current SLA obligations and billing."
    - name: "active_contracted_value"
      expr: SUM(CASE WHEN status = 'active' THEN CAST(line_value AS DOUBLE) ELSE 0 END)
      comment: "Total contracted value of active service contract lines. Represents the current service revenue under management and SLA obligation exposure."
    - name: "avg_net_price"
      expr: AVG(CAST(net_price AS DOUBLE))
      comment: "Average net unit price after discounts across contract lines. Used to monitor pricing realization and discount erosion trends in the service portfolio."
    - name: "avg_discount_percent"
      expr: AVG(CAST(discount_percent AS DOUBLE))
      comment: "Average discount percentage applied across contract lines. Monitors commercial discipline and discount policy compliance in service contract negotiations."
    - name: "penalty_clause_lines"
      expr: COUNT(CASE WHEN penalty_clause_applicable = TRUE THEN 1 END)
      comment: "Number of contract lines with active penalty clauses. Quantifies SLA penalty exposure across the service portfolio for risk management."
    - name: "total_penalty_exposure_value"
      expr: SUM(CASE WHEN penalty_clause_applicable = TRUE THEN CAST(line_value AS DOUBLE) * CAST(penalty_rate_percent AS DOUBLE) / 100.0 ELSE 0 END)
      comment: "Estimated maximum penalty exposure calculated as line value multiplied by penalty rate for lines with active penalty clauses. Used by Finance for warranty and SLA liability provisioning."
    - name: "avg_availability_target_pct"
      expr: AVG(CAST(availability_target_percent AS DOUBLE))
      comment: "Average contractually committed equipment availability percentage across contract lines. Measures the stringency of uptime commitments in the service portfolio."
    - name: "distinct_covered_assets"
      expr: COUNT(DISTINCT covered_equipment_serial_number)
      comment: "Number of distinct equipment serial numbers covered under service contracts. Measures the breadth of the installed base under active service coverage."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_spare_parts_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Spare parts fulfillment performance, cost, and backorder KPIs for aftermarket service operations. Used by Service Operations, Supply Chain, and Finance to manage parts availability, fulfillment cycle times, and aftermarket cost-to-serve."
  source: "`manufacturing_ecm`.`service`.`spare_parts_request`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the spare parts request (submitted, approved, issued, delivered, cancelled) for fulfillment pipeline management."
    - name: "request_type"
      expr: request_type
      comment: "Classification of the spare parts request (field service, warranty repair, preventive maintenance, emergency breakdown) for demand segmentation."
    - name: "urgency_level"
      expr: urgency_level
      comment: "Operational urgency classification driving warehouse picking priority and expedited shipping decisions."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval workflow status for high-value or restricted parts requiring managerial authorization."
    - name: "shipping_method"
      expr: shipping_method
      comment: "Mode of transportation selected for parts delivery, influencing freight cost and delivery lead time."
    - name: "delivery_country_code"
      expr: delivery_country_code
      comment: "ISO 3166-1 alpha-3 country code of the delivery destination for cross-border logistics and export compliance analysis."
    - name: "source_warehouse_code"
      expr: source_warehouse_code
      comment: "Warehouse from which the spare part is issued for multi-warehouse fulfillment routing and inventory depletion analysis."
    - name: "warranty_covered"
      expr: warranty_covered
      comment: "Indicates whether the spare part request is covered under warranty, used to segment billable vs. warranty-absorbed parts costs."
    - name: "request_month"
      expr: DATE_TRUNC('MONTH', request_date)
      comment: "Month of spare parts request submission for demand trend analysis and inventory planning."
    - name: "cost_center"
      expr: cost_center
      comment: "SAP cost center for spare parts cost allocation and aftermarket service cost reporting by organizational unit."
  measures:
    - name: "total_parts_requests"
      expr: COUNT(1)
      comment: "Total number of spare parts requests. Baseline demand volume KPI for aftermarket parts planning and warehouse capacity management."
    - name: "total_parts_cost"
      expr: SUM(CAST(total_cost AS DOUBLE))
      comment: "Total cost of spare parts issued across all requests. Primary aftermarket cost-to-serve KPI used by Finance for COGS reporting and service margin analysis."
    - name: "total_quantity_requested"
      expr: SUM(CAST(quantity_requested AS DOUBLE))
      comment: "Total quantity of spare parts requested. Used for demand forecasting, safety stock calibration, and supplier order planning."
    - name: "total_quantity_issued"
      expr: SUM(CAST(quantity_issued AS DOUBLE))
      comment: "Total quantity of spare parts physically issued from warehouse. Compared against quantity requested to measure fulfillment completeness."
    - name: "total_quantity_backordered"
      expr: SUM(CAST(quantity_backordered AS DOUBLE))
      comment: "Total quantity of spare parts placed on backorder due to stock unavailability. High backorder volume signals inventory gaps causing field service delays and SLA risk."
    - name: "avg_fulfillment_cycle_days"
      expr: AVG(CAST(DATEDIFF(actual_delivery_date, request_date) AS DOUBLE))
      comment: "Average number of days from spare parts request submission to actual delivery. Core parts fulfillment SLA KPI used to assess supply chain responsiveness."
    - name: "on_time_delivery_requests"
      expr: COUNT(CASE WHEN actual_delivery_date <= requested_delivery_date THEN 1 END)
      comment: "Number of spare parts requests delivered on or before the requested delivery date. Numerator for on-time delivery rate calculation used in supply chain performance reporting."
    - name: "emergency_parts_requests"
      expr: COUNT(CASE WHEN urgency_level = 'emergency' OR request_type = 'emergency_breakdown' THEN 1 END)
      comment: "Number of emergency or breakdown-driven spare parts requests. High emergency request volume indicates reactive maintenance patterns and insufficient preventive maintenance coverage."
    - name: "warranty_covered_requests"
      expr: COUNT(CASE WHEN warranty_covered = TRUE THEN 1 END)
      comment: "Number of spare parts requests covered under active warranty. Used to quantify warranty parts consumption and validate warranty cost reserve adequacy."
    - name: "avg_unit_cost"
      expr: AVG(CAST(unit_cost AS DOUBLE))
      comment: "Average unit cost of spare parts requested. Used for parts cost benchmarking, supplier negotiation, and aftermarket pricing strategy."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_installation_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Installation and commissioning performance KPIs tracking cycle times, quality outcomes, and customer acceptance rates for automation and electrification product deployments. Used by Service Operations and Project Management to improve commissioning efficiency and warranty activation timeliness."
  source: "`manufacturing_ecm`.`service`.`installation_record`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the installation activity (scheduled, in_progress, completed, signed_off) for project pipeline management."
    - name: "installation_type"
      expr: installation_type
      comment: "Classification of the installation activity (new installation, upgrade, replacement, relocation, decommission) for portfolio mix analysis."
    - name: "product_category"
      expr: product_category
      comment: "Category of the automation or electrification product being installed for installed base segmentation and service analytics."
    - name: "fai_result"
      expr: fai_result
      comment: "Outcome of the First Article Inspection (pass, fail, conditional_pass) for commissioning quality monitoring."
    - name: "checklist_completion_status"
      expr: checklist_completion_status
      comment: "Status of the commissioning checklist (fully_completed, partially_completed, completed_with_exceptions) for quality gate compliance."
    - name: "site_country_code"
      expr: site_country_code
      comment: "ISO 3166-1 alpha-3 country code of the installation site for regional commissioning performance analysis."
    - name: "site_city"
      expr: site_city
      comment: "City of the installation site for geographic commissioning workload analysis."
    - name: "is_customer_signed_off"
      expr: is_customer_signed_off
      comment: "Indicates whether the customer formally accepted the installation, used to measure customer acceptance rate."
    - name: "safety_check_completed"
      expr: safety_check_completed
      comment: "Indicates whether mandatory safety checks were completed prior to commissioning, used for safety compliance monitoring."
    - name: "ce_marking_verified"
      expr: ce_marking_verified
      comment: "Indicates whether CE marking compliance was verified at commissioning, required for EEA regulatory compliance."
    - name: "scheduled_month"
      expr: DATE_TRUNC('MONTH', scheduled_date)
      comment: "Month the installation was scheduled for commissioning workload trend analysis and resource planning."
  measures:
    - name: "total_installations"
      expr: COUNT(1)
      comment: "Total number of installation and commissioning records. Baseline volume KPI for field service capacity planning and project pipeline management."
    - name: "customer_signed_off_installations"
      expr: COUNT(CASE WHEN is_customer_signed_off = TRUE THEN 1 END)
      comment: "Number of installations formally accepted by the customer. Measures successful commissioning completion rate and triggers warranty activation."
    - name: "safety_compliant_installations"
      expr: COUNT(CASE WHEN safety_check_completed = TRUE THEN 1 END)
      comment: "Number of installations where all mandatory safety checks were completed. Safety compliance KPI required for regulatory reporting and risk management."
    - name: "fai_passed_installations"
      expr: COUNT(CASE WHEN fai_result = 'pass' THEN 1 END)
      comment: "Number of installations where the First Article Inspection passed. Measures commissioning quality and first-time-right performance."
    - name: "avg_commissioning_duration_hours"
      expr: AVG(CAST(TIMESTAMPDIFF(MINUTE, actual_start_timestamp, actual_end_timestamp) AS DOUBLE) / 60.0)
      comment: "Average actual commissioning duration in hours from start to completion. Used to benchmark installation efficiency, improve resource planning, and identify complex product categories."
    - name: "avg_checklist_completion_pct"
      expr: AVG(CAST(checklist_completion_percentage AS DOUBLE))
      comment: "Average percentage of commissioning checklist items completed across installations. Measures commissioning thoroughness and identifies systematic gaps in the installation process."
    - name: "avg_schedule_adherence_days"
      expr: AVG(CAST(DATEDIFF(CAST(actual_start_timestamp AS DATE), scheduled_date) AS DOUBLE))
      comment: "Average number of days between scheduled and actual installation start. Measures scheduling accuracy and identifies systemic delays in commissioning execution."
    - name: "ce_marking_verified_installations"
      expr: COUNT(CASE WHEN ce_marking_verified = TRUE THEN 1 END)
      comment: "Number of installations with CE marking compliance verified. Regulatory compliance KPI for products sold in the European Economic Area."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`service_entitlement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service entitlement portfolio health, coverage mix, and incident consumption KPIs. Used by Service Operations and Finance to monitor entitlement utilization, renewal risk, and the commercial value of the active service entitlement portfolio."
  source: "`manufacturing_ecm`.`service`.`entitlement`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the service entitlement (active, expired, cancelled) controlling service eligibility and case creation."
    - name: "type"
      expr: type
      comment: "Classification of the entitlement source (warranty, service_contract, support_tier, subscription, extended_warranty, preventive_maintenance) for portfolio mix analysis."
    - name: "coverage_scope"
      expr: coverage_scope
      comment: "Services covered under the entitlement (parts and labor, labor only, remote support only, etc.) for billing and dispatch decision support."
    - name: "region"
      expr: region
      comment: "Geographic service region (EMEA, APAC, AMER) for territory management and regional KPI reporting."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code for regional SLA enforcement and compliance reporting."
    - name: "owning_business_unit"
      expr: owning_business_unit
      comment: "Internal business unit responsible for fulfilling service obligations (Automation Services, Electrification Services) for P&L reporting."
    - name: "covered_product_family"
      expr: covered_product_family
      comment: "Product family covered under the entitlement for installed base coverage analysis."
    - name: "service_hours_coverage"
      expr: service_hours_coverage
      comment: "Hours of service coverage included (24x7, 8x5) for SLA clock management and coverage tier mix analysis."
    - name: "auto_renewal_flag"
      expr: auto_renewal_flag
      comment: "Indicates whether the entitlement auto-renews, used to segment renewal pipeline by automatic vs. manual renewal."
    - name: "on_site_support_flag"
      expr: on_site_support_flag
      comment: "Indicates whether on-site field service is included, used to assess field dispatch authorization scope."
    - name: "end_month"
      expr: DATE_TRUNC('MONTH', end_date)
      comment: "Month the entitlement expires for renewal pipeline management and at-risk entitlement identification."
  measures:
    - name: "total_entitlements"
      expr: COUNT(1)
      comment: "Total number of service entitlements. Baseline portfolio size KPI for service coverage management."
    - name: "active_entitlements"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Number of currently active service entitlements. Measures the live service coverage portfolio driving current SLA obligations and case eligibility."
    - name: "total_entitlement_value"
      expr: SUM(CAST(value AS DOUBLE))
      comment: "Total monetary value of services covered across all entitlements. Primary service revenue under management KPI used for revenue recognition and contract profitability analysis."
    - name: "active_entitlement_value"
      expr: SUM(CASE WHEN status = 'active' THEN CAST(value AS DOUBLE) ELSE 0 END)
      comment: "Total monetary value of active service entitlements. Represents current service revenue backlog and SLA obligation exposure."
    - name: "expiring_within_90_days"
      expr: COUNT(CASE WHEN status = 'active' AND end_date <= DATE_ADD(CURRENT_DATE(), 90) THEN 1 END)
      comment: "Number of active entitlements expiring within the next 90 days. Renewal pipeline urgency KPI used by Service Sales to prioritize renewal outreach and prevent coverage gaps."
    - name: "avg_spare_parts_coverage_limit"
      expr: AVG(CAST(spare_parts_coverage_limit AS DOUBLE))
      comment: "Average monetary cap on spare parts coverage per entitlement. Used to assess parts liability exposure and calibrate parts inventory investment for covered assets."
    - name: "on_site_support_entitlements"
      expr: COUNT(CASE WHEN on_site_support_flag = TRUE THEN 1 END)
      comment: "Number of entitlements including on-site field service visits. Measures the scope of field dispatch obligations and associated resource requirements."
    - name: "auto_renewal_entitlements"
      expr: COUNT(CASE WHEN auto_renewal_flag = TRUE THEN 1 END)
      comment: "Number of entitlements configured for automatic renewal. Measures the stability of the recurring service revenue base."
$$;