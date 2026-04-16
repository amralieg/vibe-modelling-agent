-- Metric views for domain: order | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_atp_commitment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "ATP/CTP commitment accuracy and backorder exposure metrics. Tracks delivery promise reliability, quantity confirmation rates, and backorder risk across plants, materials, and sales organizations. Critical for supply chain and order fulfillment leadership to assess promise accuracy and identify over-commitment risk."
  source: "`manufacturing_ecm`.`order`.`atp_commitment`"
  dimensions:
    - name: "commitment_type"
      expr: commitment_type
      comment: "Distinguishes ATP (stock-based) from CTP (capacity-based) commitments, enabling analysis of fulfillment mode mix and promise reliability by type."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the ATP/CTP commitment (e.g., active, superseded, expired). Used to filter to valid commitments and analyze supersession rates."
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization responsible for the commitment. Enables regional and legal-entity-level delivery promise performance reporting."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the plant or shipping point. Supports multi-country delivery promise accuracy analysis and export compliance segmentation."
    - name: "material_number"
      expr: material_number
      comment: "SAP material number (SKU) for which the commitment was generated. Enables product-level backorder and confirmation rate analysis."
    - name: "checking_rule"
      expr: checking_rule
      comment: "SAP checking rule applied during the ATP/CTP check. Enables analysis of promise accuracy by checking rule configuration."
    - name: "delivery_priority"
      expr: delivery_priority
      comment: "Delivery priority code assigned to the order item. Enables analysis of ATP allocation effectiveness by priority tier."
    - name: "confirmed_delivery_date"
      expr: confirmed_delivery_date
      comment: "Confirmed delivery date from the ATP/CTP engine. Used as a time dimension for delivery promise scheduling and backlog analysis."
    - name: "requested_delivery_date"
      expr: requested_delivery_date
      comment: "Customer-requested delivery date. Used alongside confirmed delivery date to measure delivery date deviation at commitment level."
    - name: "partial_delivery_allowed"
      expr: partial_delivery_allowed
      comment: "Indicates whether partial delivery is permitted. Enables segmentation of commitment accuracy metrics between full and partial delivery scenarios."
  measures:
    - name: "total_requested_quantity"
      expr: SUM(CAST(requested_quantity AS DOUBLE))
      comment: "Total customer-requested quantity across all ATP/CTP commitments. Baseline demand volume for commitment coverage analysis."
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed by the ATP/CTP engine. Measures the volume of demand that received a delivery promise."
    - name: "total_backorder_quantity"
      expr: SUM(CAST(backorder_quantity AS DOUBLE))
      comment: "Total quantity placed on backorder due to insufficient availability. Key indicator of supply shortfall and customer delivery risk."
    - name: "total_atp_quantity"
      expr: SUM(CAST(atp_quantity AS DOUBLE))
      comment: "Total net ATP quantity available across all commitments at time of check. Measures uncommitted available stock pool."
    - name: "commitment_confirmation_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE)) / NULLIF(SUM(CAST(requested_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of requested quantity that was confirmed by the ATP/CTP engine. Core KPI for delivery promise accuracy — low rates signal supply constraints or ATP configuration issues."
    - name: "backorder_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(backorder_quantity AS DOUBLE)) / NULLIF(SUM(CAST(requested_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of requested quantity placed on backorder. Directly measures supply shortfall impact on customer delivery commitments. Executives use this to assess fulfillment risk."
    - name: "commitment_count"
      expr: COUNT(1)
      comment: "Total number of ATP/CTP commitment records. Used as the denominator for per-commitment averages and to assess commitment volume trends."
    - name: "active_commitment_count"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of currently active ATP/CTP commitments. Measures the live delivery promise backlog requiring fulfillment execution."
    - name: "superseded_commitment_count"
      expr: COUNT(CASE WHEN status = 'Superseded' THEN 1 END)
      comment: "Number of commitments that were superseded by revised checks. High supersession rates indicate delivery promise instability and customer communication risk."
    - name: "avg_atp_quantity_per_commitment"
      expr: AVG(CAST(atp_quantity AS DOUBLE))
      comment: "Average net ATP quantity per commitment record. Indicates typical available stock depth at time of promise — declining averages signal tightening supply."
    - name: "ctp_commitment_count"
      expr: COUNT(CASE WHEN commitment_type = 'CTP' THEN 1 END)
      comment: "Number of commitments fulfilled via Capable-to-Promise (production capacity) logic. High CTP volumes indicate MTS stock depletion and reliance on production scheduling for delivery promises."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_blanket_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Blanket order consumption, open commitment, and agreement health metrics. Tracks how much of long-term customer volume commitments have been released versus remaining open, and monitors agreement lifecycle. Critical for sales operations, supply chain planning, and contract management leadership."
  source: "`manufacturing_ecm`.`order`.`blanket_order`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the blanket order (e.g., active, expired, completed). Enables filtering to active agreements and analysis of agreement health distribution."
    - name: "agreement_type"
      expr: agreement_type
      comment: "Classification of the blanket order type (scheduling agreement, quantity contract, value contract, framework order). Enables analysis by commercial agreement structure."
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization responsible for the blanket order. Enables regional and legal-entity-level commitment and consumption reporting."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the ship-to destination. Supports geographic analysis of blanket order volumes and open commitments."
    - name: "division"
      expr: division
      comment: "SAP division (product line or business unit) responsible for fulfillment. Enables product-line-level blanket order consumption analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency of the blanket order. Required for multi-currency financial analysis of committed values."
    - name: "validity_start_date"
      expr: validity_start_date
      comment: "Agreement effective start date. Used for cohort analysis of blanket orders by contract period."
    - name: "validity_end_date"
      expr: validity_end_date
      comment: "Agreement expiry date. Used to identify agreements approaching expiry requiring renewal action."
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant responsible for fulfillment. Enables plant-level analysis of blanket order demand and capacity planning."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms code for deliveries under this blanket order. Supports logistics cost and risk analysis by delivery terms."
  measures:
    - name: "total_committed_quantity"
      expr: SUM(CAST(committed_quantity AS DOUBLE))
      comment: "Total quantity committed by customers across all blanket orders. Represents the total long-term demand volume under contract — key input for capacity and supply planning."
    - name: "total_released_quantity"
      expr: SUM(CAST(released_quantity AS DOUBLE))
      comment: "Total quantity released (called off) against blanket orders to date. Measures actual demand consumption against long-term commitments."
    - name: "total_open_quantity"
      expr: SUM(CAST(open_quantity AS DOUBLE))
      comment: "Total remaining open quantity across all blanket orders. Represents unfulfilled customer commitments — critical for forward demand planning and capacity allocation."
    - name: "blanket_order_count"
      expr: COUNT(1)
      comment: "Total number of blanket order agreements. Used to track agreement portfolio size and trend."
    - name: "active_blanket_order_count"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of currently active blanket order agreements. Measures the live long-term customer commitment portfolio."
    - name: "release_consumption_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(released_quantity AS DOUBLE)) / NULLIF(SUM(CAST(committed_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of committed quantity that has been released to date. Core KPI for blanket order utilization — low rates may indicate customer demand shortfall or agreement underperformance."
    - name: "avg_discount_percent"
      expr: AVG(CAST(discount_percent AS DOUBLE))
      comment: "Average discount percentage across blanket orders. Monitors commercial discount levels in long-term agreements — used by sales finance to assess margin risk in the committed order book."
    - name: "avg_open_quantity_per_order"
      expr: AVG(CAST(open_quantity AS DOUBLE))
      comment: "Average remaining open quantity per blanket order. Indicates typical unfulfilled commitment size — used for supply planning and customer engagement prioritization."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_credit_check`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer credit risk exposure, credit check outcomes, and credit utilization metrics for order-to-cash risk management. Tracks credit limit utilization, blocked order volumes, override rates, and exposure composition. Used by CFO, credit management, and sales finance to manage financial risk in the order book."
  source: "`manufacturing_ecm`.`order`.`credit_check`"
  dimensions:
    - name: "result"
      expr: result
      comment: "Outcome of the credit check (approved, blocked, warning). Primary dimension for analyzing credit risk distribution across the order book."
    - name: "check_type"
      expr: check_type
      comment: "Credit check method (static, dynamic, manual). Enables analysis of check methodology effectiveness and risk coverage."
    - name: "risk_category"
      expr: risk_category
      comment: "Customer risk classification at time of check. Enables segmentation of credit exposure and block rates by customer risk tier."
    - name: "credit_control_area"
      expr: credit_control_area
      comment: "SAP credit control area governing the check. Enables analysis of credit risk by organizational credit management unit."
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization associated with the order. Enables regional credit risk and block rate reporting."
    - name: "country_code"
      expr: country_code
      comment: "Customer billing country. Supports geographic credit risk analysis and regional policy compliance."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of credit amounts. Required for multi-currency credit exposure consolidation."
    - name: "override_flag"
      expr: override_flag
      comment: "Indicates whether the credit check result was manually overridden. Enables SOX compliance monitoring of override frequency."
    - name: "check_date"
      expr: check_date
      comment: "Date the credit check was performed. Used as a time dimension for trend analysis of credit risk and block rates."
    - name: "release_authorization_level"
      expr: release_authorization_level
      comment: "Authorization level required to release a blocked order. Enables analysis of escalation burden by risk tier."
  measures:
    - name: "total_credit_limit_amount"
      expr: SUM(CAST(credit_limit_amount AS DOUBLE))
      comment: "Total approved credit limit across all checked customers. Represents the total authorized credit exposure ceiling in the portfolio."
    - name: "total_current_exposure_amount"
      expr: SUM(CAST(current_exposure_amount AS DOUBLE))
      comment: "Total current credit exposure across all customers at time of check. Core financial risk KPI — measures total outstanding credit risk in the order book."
    - name: "total_available_credit_amount"
      expr: SUM(CAST(available_credit_amount AS DOUBLE))
      comment: "Total remaining available credit across all customers. Measures headroom in the credit portfolio — declining values signal increasing financial risk."
    - name: "total_order_value_checked"
      expr: SUM(CAST(order_value_amount AS DOUBLE))
      comment: "Total value of sales orders that triggered credit checks. Measures the financial volume of orders subject to credit risk evaluation."
    - name: "total_open_receivables_amount"
      expr: SUM(CAST(open_receivables_amount AS DOUBLE))
      comment: "Total outstanding accounts receivable included in credit exposure. Key component of dynamic credit exposure — high values indicate collection risk."
    - name: "total_open_orders_amount"
      expr: SUM(CAST(open_orders_amount AS DOUBLE))
      comment: "Total value of open undelivered sales orders included in dynamic credit exposure. Measures committed but unbilled revenue at credit risk."
    - name: "credit_check_count"
      expr: COUNT(1)
      comment: "Total number of credit check evaluations performed. Used to normalize block rates and override rates."
    - name: "blocked_order_count"
      expr: COUNT(CASE WHEN result = 'Blocked' THEN 1 END)
      comment: "Number of orders blocked by credit check. Directly measures credit-driven order fulfillment disruption — high counts signal customer financial distress or policy tightening."
    - name: "credit_block_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN result = 'Blocked' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of credit checks resulting in an order block. Core credit risk KPI — rising block rates signal deteriorating customer credit health or tightening credit policy."
    - name: "override_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN override_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of credit checks where the automated result was manually overridden. SOX compliance KPI — high override rates indicate control weakness and require audit scrutiny."
    - name: "avg_credit_utilization_pct"
      expr: AVG(CAST(utilization_percent AS DOUBLE))
      comment: "Average credit limit utilization percentage across all checked customers. Measures how fully customers are drawing on their credit lines — high averages indicate elevated portfolio risk."
    - name: "avg_payment_index"
      expr: AVG(CAST(payment_index AS DOUBLE))
      comment: "Average customer payment behavior score across credit checks. Declining averages signal worsening payment behavior in the customer base — leading indicator of bad debt risk."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_fulfillment_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Order fulfillment execution performance metrics including on-time delivery rates, bottleneck frequency, fulfillment quantity accuracy, and delivery delay analysis. Core operational KPI view for supply chain, operations, and customer service leadership to manage delivery performance and identify execution failures."
  source: "`manufacturing_ecm`.`order`.`fulfillment_plan`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the fulfillment plan (e.g., planned, confirmed, completed, cancelled). Enables analysis of plan execution progress and cancellation rates."
    - name: "on_time_delivery_flag"
      expr: on_time_delivery_flag
      comment: "Indicates whether the fulfillment plan was completed on or before the planned delivery date. Primary dimension for OTD segmentation."
    - name: "bottleneck_flag"
      expr: bottleneck_flag
      comment: "Indicates whether a capacity or material bottleneck was identified. Enables analysis of bottleneck frequency and its correlation with delivery delays."
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant responsible for fulfillment execution. Enables plant-level OTD and bottleneck performance benchmarking."
    - name: "scheduling_type"
      expr: scheduling_type
      comment: "Forward or backward scheduling logic applied. Enables analysis of scheduling approach impact on delivery performance."
    - name: "atp_ctp_check_result"
      expr: atp_ctp_check_result
      comment: "Result of the ATP/CTP check at order confirmation. Enables correlation between availability check outcomes and actual fulfillment performance."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms code for the fulfillment. Enables analysis of delivery performance by risk transfer terms."
    - name: "planned_delivery_date"
      expr: planned_delivery_date
      comment: "Target delivery date committed in the fulfillment plan. Used as a time dimension for delivery performance trend analysis."
    - name: "actual_fulfillment_date"
      expr: actual_fulfillment_date
      comment: "Actual date fulfillment was completed. Used alongside planned delivery date to measure delivery delay."
    - name: "mrp_controller"
      expr: mrp_controller
      comment: "MRP controller responsible for the fulfillment plan. Enables planner-level performance analysis and workload management."
  measures:
    - name: "fulfillment_plan_count"
      expr: COUNT(1)
      comment: "Total number of fulfillment plans. Baseline volume measure for normalizing OTD and bottleneck rates."
    - name: "on_time_delivery_count"
      expr: COUNT(CASE WHEN on_time_delivery_flag = TRUE THEN 1 END)
      comment: "Number of fulfillment plans completed on or before the planned delivery date. Numerator for OTD rate calculation."
    - name: "on_time_delivery_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN on_time_delivery_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fulfillment plans delivered on time. Premier customer service KPI — directly tied to customer satisfaction, SLA compliance, and contract penalty risk."
    - name: "bottleneck_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN bottleneck_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fulfillment plans with an identified capacity or material bottleneck. Operational risk KPI — high rates signal systemic supply chain constraints requiring executive intervention."
    - name: "total_planned_quantity"
      expr: SUM(CAST(planned_quantity AS DOUBLE))
      comment: "Total quantity planned for fulfillment across all plans. Measures the total production and logistics commitment volume."
    - name: "total_fulfilled_quantity"
      expr: SUM(CAST(fulfilled_quantity AS DOUBLE))
      comment: "Total quantity actually delivered and confirmed as fulfilled. Measures actual output against planned commitment."
    - name: "fulfillment_quantity_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(fulfilled_quantity AS DOUBLE)) / NULLIF(SUM(CAST(planned_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of planned quantity actually fulfilled. Measures fulfillment completeness — shortfalls indicate partial delivery issues or cancellations impacting revenue recognition."
    - name: "avg_fulfilled_quantity"
      expr: AVG(CAST(fulfilled_quantity AS DOUBLE))
      comment: "Average fulfilled quantity per fulfillment plan. Used to benchmark typical order size and detect anomalies in fulfillment execution."
    - name: "plans_with_exception_count"
      expr: COUNT(CASE WHEN exception_alert_code IS NOT NULL THEN 1 END)
      comment: "Number of fulfillment plans with an active exception alert. Measures the volume of plans requiring exception-based management intervention."
    - name: "exception_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN exception_alert_code IS NOT NULL THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of fulfillment plans with an active exception. High exception rates indicate systemic execution problems requiring operations leadership attention."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_goods_issue`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Goods issue throughput, shipment value, reversal rate, and hazardous goods metrics. Represents the physical inventory departure event that triggers revenue recognition eligibility. Used by logistics, finance, and operations leadership to monitor outbound shipment performance and COGS impact."
  source: "`manufacturing_ecm`.`order`.`goods_issue`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current processing status of the goods issue (posted, reversed, blocked, in_transit, confirmed). Enables analysis of shipment completion and reversal rates."
    - name: "movement_type"
      expr: movement_type
      comment: "SAP movement type classifying the goods issue transaction (e.g., 601 for delivery, 261 for production order). Enables analysis by shipment purpose and inventory impact type."
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or distribution center from which goods were issued. Enables plant-level shipment throughput and COGS analysis."
    - name: "reversal_flag"
      expr: reversal_flag
      comment: "Indicates whether the goods issue is a reversal of a prior posting. Enables reversal rate analysis and identification of shipment quality issues."
    - name: "hazardous_material_flag"
      expr: hazardous_material_flag
      comment: "Indicates whether the issued material is classified as hazardous. Enables compliance monitoring of hazardous goods shipment volumes."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms code for the goods issue. Determines revenue recognition trigger point and risk transfer — critical for IFRS 15 compliance analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Currency of the goods issue value. Required for multi-currency COGS and revenue recognition reporting."
    - name: "posting_date"
      expr: posting_date
      comment: "Accounting posting date of the goods issue. Used as the primary time dimension for fiscal period COGS and shipment volume analysis."
    - name: "shipping_point"
      expr: shipping_point
      comment: "SAP shipping point from which goods were dispatched. Enables logistics performance analysis by dispatch location."
    - name: "valuation_type"
      expr: valuation_type
      comment: "Inventory valuation method (moving average, standard cost, FIFO). Enables analysis of COGS calculation methodology and its impact on reported margins."
  measures:
    - name: "total_issued_quantity"
      expr: SUM(CAST(issued_quantity AS DOUBLE))
      comment: "Total quantity of material physically issued from stock. Core throughput measure for outbound logistics — drives inventory reduction and revenue recognition eligibility."
    - name: "total_goods_issue_value"
      expr: SUM(CAST(value AS DOUBLE))
      comment: "Total inventory value of issued goods (COGS impact). Directly measures the cost of goods sold triggered by outbound shipments — critical for gross margin and P&L reporting."
    - name: "goods_issue_count"
      expr: COUNT(1)
      comment: "Total number of goods issue postings. Measures outbound shipment transaction volume and logistics throughput."
    - name: "reversal_count"
      expr: COUNT(CASE WHEN reversal_flag = TRUE THEN 1 END)
      comment: "Number of goods issue reversals. Measures shipment cancellation and error correction volume — high reversal counts indicate logistics quality issues."
    - name: "reversal_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN reversal_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of goods issues that were reversed. Operational quality KPI — high reversal rates signal shipment errors, customer rejections, or process failures requiring investigation."
    - name: "avg_goods_issue_value"
      expr: AVG(CAST(value AS DOUBLE))
      comment: "Average value per goods issue posting. Used to benchmark typical shipment value and detect anomalies in outbound logistics."
    - name: "total_delivery_quantity"
      expr: SUM(CAST(delivery_quantity AS DOUBLE))
      comment: "Total quantity confirmed on outbound delivery documents. Used alongside issued quantity to identify over/under-delivery situations."
    - name: "delivery_quantity_accuracy_pct"
      expr: ROUND(100.0 * SUM(CAST(issued_quantity AS DOUBLE)) / NULLIF(SUM(CAST(delivery_quantity AS DOUBLE)), 0), 2)
      comment: "Ratio of actually issued quantity to delivery-confirmed quantity. Measures shipment accuracy — deviations from 100% indicate over/under-delivery situations requiring customer and logistics management attention."
    - name: "hazardous_goods_issue_count"
      expr: COUNT(CASE WHEN hazardous_material_flag = TRUE THEN 1 END)
      comment: "Number of goods issues involving hazardous materials. Compliance monitoring KPI — used by EHS and logistics teams to track regulated shipment volumes."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_order_confirmation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Order confirmation financial value, delivery promise accuracy, deviation rates, and customer acknowledgment metrics. Represents the contractual commitment between manufacturer and customer. Used by sales, finance, and customer service leadership to monitor confirmed order book value, delivery date accuracy, and confirmation quality."
  source: "`manufacturing_ecm`.`order`.`order_confirmation`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Lifecycle status of the order confirmation (issued, acknowledged, superseded, cancelled). Enables analysis of confirmation quality and cancellation rates."
    - name: "customer_acknowledgment_status"
      expr: customer_acknowledgment_status
      comment: "Whether the customer has formally acknowledged the confirmation. Enables SLA compliance monitoring for customer acceptance workflows."
    - name: "deviation_flag"
      expr: deviation_flag
      comment: "Indicates whether the confirmation contains deviations from the original order request. Primary dimension for order fulfillment accuracy analysis."
    - name: "atp_ctp_check_status"
      expr: atp_ctp_check_status
      comment: "Result of the ATP/CTP check at confirmation. Enables analysis of delivery promise backing (stock vs. capacity) across the confirmed order book."
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization responsible for the confirmed order. Enables regional confirmed order book and deviation rate reporting."
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel for the confirmed order. Enables channel-level order book value and deviation analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency of the confirmation. Required for multi-currency order book value reporting."
    - name: "country_of_destination"
      expr: country_of_destination
      comment: "Final delivery destination country. Enables geographic analysis of confirmed order book and export compliance monitoring."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Confirmed Incoterms code. Enables analysis of delivery obligation distribution and logistics cost allocation across the order book."
    - name: "date"
      expr: date
      comment: "Date the order confirmation was issued. Primary time dimension for order book trend analysis and SLA compliance tracking."
  measures:
    - name: "total_confirmed_net_value"
      expr: SUM(CAST(confirmed_net_value AS DOUBLE))
      comment: "Total confirmed net order value across all confirmations. Represents the contractual revenue commitment in the order book — core financial KPI for revenue forecasting and sales performance."
    - name: "total_confirmed_gross_value"
      expr: SUM(CAST(confirmed_gross_value AS DOUBLE))
      comment: "Total confirmed gross order value including taxes. Used for total financial obligation reporting and customer billing analysis."
    - name: "total_confirmed_tax_amount"
      expr: SUM(CAST(confirmed_tax_amount AS DOUBLE))
      comment: "Total tax amount across confirmed orders. Used for tax liability reporting and statutory compliance monitoring."
    - name: "order_confirmation_count"
      expr: COUNT(1)
      comment: "Total number of order confirmations issued. Measures order intake volume and confirmation throughput."
    - name: "deviation_count"
      expr: COUNT(CASE WHEN deviation_flag = TRUE THEN 1 END)
      comment: "Number of confirmations containing deviations from the original customer order. Measures order fulfillment accuracy failures requiring customer communication."
    - name: "deviation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN deviation_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of order confirmations with deviations from the original request. Customer satisfaction KPI — high deviation rates indicate supply constraints, pricing issues, or order management failures."
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed across all order confirmations. Measures the volume of demand formally committed for fulfillment."
    - name: "total_ordered_quantity"
      expr: SUM(CAST(ordered_quantity AS DOUBLE))
      comment: "Total quantity originally requested by customers. Used alongside confirmed quantity to measure order fill rate at confirmation stage."
    - name: "order_fill_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE)) / NULLIF(SUM(CAST(ordered_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of ordered quantity confirmed at order confirmation stage. Measures supply availability against customer demand at the point of commercial commitment — key order-to-cash efficiency KPI."
    - name: "avg_confirmed_net_value"
      expr: AVG(CAST(confirmed_net_value AS DOUBLE))
      comment: "Average confirmed net order value per confirmation. Measures typical order size — used for revenue mix analysis and sales strategy assessment."
    - name: "acknowledged_confirmation_count"
      expr: COUNT(CASE WHEN customer_acknowledgment_status = 'Acknowledged' THEN 1 END)
      comment: "Number of confirmations formally acknowledged by the customer. Measures contractual binding rate — unacknowledged confirmations represent commercial risk."
    - name: "customer_acknowledgment_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN customer_acknowledgment_status = 'Acknowledged' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of order confirmations formally acknowledged by customers. SLA compliance KPI — low rates indicate customer communication failures or disputed order terms."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_quotation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quotation pipeline value, win/loss conversion rates, discount levels, and sales velocity metrics. Tracks the pre-order commercial pipeline from RFQ response through order conversion. Used by sales leadership, commercial finance, and strategy teams to manage pipeline health, pricing discipline, and win rate performance."
  source: "`manufacturing_ecm`.`order`.`quotation`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the quotation (draft, submitted, accepted, rejected, expired, converted). Primary dimension for pipeline stage analysis and conversion funnel reporting."
    - name: "type"
      expr: type
      comment: "Commercial structure of the quotation (standard, framework, blanket, project, spot). Enables analysis of pipeline composition by deal type."
    - name: "sales_representative"
      expr: sales_representative
      comment: "Sales representative responsible for the quotation. Enables individual sales performance analysis, commission calculation, and workload management."
    - name: "win_loss_reason"
      expr: win_loss_reason
      comment: "Categorized reason for quotation win or loss. Critical for competitive intelligence, pricing strategy, and sales process improvement."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency of the quotation. Required for multi-currency pipeline value reporting."
    - name: "shipping_country_code"
      expr: shipping_country_code
      comment: "Customer ship-to country. Enables geographic pipeline analysis and export compliance monitoring."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms code for the quoted shipment. Enables analysis of delivery obligation distribution across the pipeline."
    - name: "issue_date"
      expr: issue_date
      comment: "Date the quotation was issued. Primary time dimension for pipeline trend analysis and sales velocity measurement."
    - name: "validity_end_date"
      expr: validity_end_date
      comment: "Quotation expiry date. Used to identify pipeline at risk of expiry requiring follow-up action."
    - name: "division"
      expr: division
      comment: "SAP division (product line) for the quoted products. Enables product-line-level pipeline and win rate analysis."
  measures:
    - name: "total_pipeline_net_value"
      expr: SUM(CAST(net_value AS DOUBLE))
      comment: "Total net value of all quotations in the pipeline. Core sales pipeline KPI — measures the total commercial opportunity under active quotation. Used for revenue forecasting and sales target tracking."
    - name: "total_pipeline_gross_value"
      expr: SUM(CAST(gross_value AS DOUBLE))
      comment: "Total gross value of all quotations before discounts. Used alongside net value to measure total discount impact across the pipeline."
    - name: "weighted_pipeline_value"
      expr: SUM(CAST(net_value AS DOUBLE) * CAST(probability_percent AS DOUBLE) / 100.0)
      comment: "Probability-weighted pipeline net value. Adjusts raw pipeline value by win probability to produce a risk-adjusted revenue forecast — essential for accurate sales planning and resource allocation."
    - name: "quotation_count"
      expr: COUNT(1)
      comment: "Total number of quotations. Baseline volume measure for win rate and conversion rate calculations."
    - name: "converted_quotation_count"
      expr: COUNT(CASE WHEN status = 'converted' THEN 1 END)
      comment: "Number of quotations converted to sales orders. Numerator for win rate calculation — measures commercial pipeline conversion effectiveness."
    - name: "win_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN status = 'converted' THEN 1 END) / NULLIF(COUNT(CASE WHEN status IN ('converted', 'rejected', 'expired') THEN 1 END), 0), 2)
      comment: "Percentage of decided quotations (converted, rejected, or expired) that were won. Premier sales effectiveness KPI — directly measures commercial competitiveness and pricing strategy success."
    - name: "avg_quotation_net_value"
      expr: AVG(CAST(net_value AS DOUBLE))
      comment: "Average net value per quotation. Measures typical deal size — used for sales mix analysis and identifying shifts toward higher or lower value opportunities."
    - name: "avg_discount_percentage"
      expr: AVG(CAST(discount_percentage AS DOUBLE))
      comment: "Average header-level discount percentage across quotations. Pricing governance KPI — rising averages indicate margin erosion risk and may trigger pricing policy review."
    - name: "avg_win_probability_pct"
      expr: AVG(CAST(probability_percent AS DOUBLE))
      comment: "Average sales-estimated win probability across open quotations. Measures pipeline quality and sales confidence — declining averages signal weakening competitive position."
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount across all quotations. Used for tax liability estimation in the pipeline and statutory compliance planning."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_schedule_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Delivery schedule line commitment accuracy, fulfillment progress, and delivery block analysis. Tracks ATP/CTP-confirmed delivery commitments at the granular schedule line level. Used by supply chain, logistics, and customer service leadership to monitor delivery promise fulfillment, open delivery backlogs, and block resolution performance."
  source: "`manufacturing_ecm`.`order`.`schedule_line`"
  dimensions:
    - name: "goods_issue_status"
      expr: goods_issue_status
      comment: "Current goods issue processing status (fully issued, partially issued, not issued). Primary dimension for delivery execution progress analysis."
    - name: "atp_ctp_check_result"
      expr: atp_ctp_check_result
      comment: "Result of the ATP/CTP availability check for this schedule line. Enables analysis of delivery promise backing and partial confirmation rates."
    - name: "category"
      expr: category
      comment: "SAP schedule line category (e.g., CP with MRP, CN without MRP). Enables analysis of MRP-relevant delivery commitments versus informational lines."
    - name: "plant_code"
      expr: plant_code
      comment: "Plant responsible for fulfilling the schedule line. Enables plant-level delivery performance and open backlog analysis."
    - name: "export_control_status"
      expr: export_control_status
      comment: "Export control compliance status. Enables monitoring of export-blocked delivery volumes and compliance risk."
    - name: "delivery_relevance_indicator"
      expr: delivery_relevance_indicator
      comment: "Indicates whether the schedule line triggers outbound delivery creation. Enables filtering to operationally relevant delivery commitments."
    - name: "partial_delivery_allowed"
      expr: partial_delivery_allowed
      comment: "Indicates whether partial delivery is permitted. Enables segmentation of fulfillment metrics between full and partial delivery scenarios."
    - name: "confirmed_delivery_date"
      expr: confirmed_delivery_date
      comment: "ATP/CTP-confirmed delivery date. Primary time dimension for delivery schedule analysis and on-time performance tracking."
    - name: "requested_delivery_date"
      expr: requested_delivery_date
      comment: "Customer-requested delivery date. Used alongside confirmed delivery date to measure delivery date deviation at schedule line level."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency of the schedule line net value. Required for multi-currency delivery backlog value reporting."
  measures:
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed by ATP/CTP for delivery across all schedule lines. Measures the total binding delivery commitment volume."
    - name: "total_ordered_quantity"
      expr: SUM(CAST(ordered_quantity AS DOUBLE))
      comment: "Total originally requested quantity across all schedule lines. Used to measure ATP/CTP confirmation coverage against customer demand."
    - name: "total_delivered_quantity"
      expr: SUM(CAST(delivered_quantity AS DOUBLE))
      comment: "Total quantity actually goods-issued and delivered against schedule lines. Measures fulfillment execution progress against confirmed commitments."
    - name: "schedule_line_count"
      expr: COUNT(1)
      comment: "Total number of delivery schedule lines. Baseline volume measure for delivery commitment portfolio analysis."
    - name: "delivery_fulfillment_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(delivered_quantity AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of confirmed quantity that has been delivered. Measures delivery execution completeness against ATP/CTP commitments — the primary schedule line fulfillment KPI."
    - name: "schedule_line_confirmation_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE)) / NULLIF(SUM(CAST(ordered_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of ordered quantity confirmed by ATP/CTP at schedule line level. Measures supply availability against customer demand at the delivery scheduling stage."
    - name: "total_net_value"
      expr: SUM(CAST(net_value AS DOUBLE))
      comment: "Total net monetary value of all schedule lines. Measures the financial value of the confirmed delivery backlog — used for revenue recognition planning and billing forecasting."
    - name: "blocked_schedule_line_count"
      expr: COUNT(CASE WHEN delivery_block_code IS NOT NULL THEN 1 END)
      comment: "Number of schedule lines with an active delivery block. Measures the volume of confirmed deliveries prevented from shipping — directly impacts customer service levels and revenue recognition."
    - name: "delivery_block_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN delivery_block_code IS NOT NULL THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of schedule lines with an active delivery block. Operational risk KPI — high block rates indicate systemic credit, export control, or quality hold issues disrupting shipment execution."
    - name: "avg_over_delivery_tolerance_pct"
      expr: AVG(CAST(over_delivery_tolerance_pct AS DOUBLE))
      comment: "Average over-delivery tolerance percentage across schedule lines. Used by logistics and customer service to understand flexibility in delivery quantity management."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`order_status_history`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Order lifecycle SLA compliance, status transition velocity, block frequency, and process automation metrics. Tracks every status change in the order-to-cash process to identify bottlenecks, SLA breaches, and cycle time inefficiencies. Used by operations, customer service, and process excellence leadership to optimize order-to-cash performance."
  source: "`manufacturing_ecm`.`order`.`status_history`"
  dimensions:
    - name: "new_status"
      expr: new_status
      comment: "The order status reached by this transition. Enables analysis of order volume at each lifecycle stage and identification of status bottlenecks."
    - name: "previous_status"
      expr: previous_status
      comment: "The order status before this transition. Used with new_status to analyze specific transition paths and identify problematic status flows."
    - name: "transition_type"
      expr: transition_type
      comment: "How the transition was initiated (automatic, manual, batch, integration). Enables analysis of automation rates and manual intervention frequency."
    - name: "sla_breach_flag"
      expr: sla_breach_flag
      comment: "Indicates whether this transition occurred after the SLA deadline. Primary dimension for SLA compliance analysis."
    - name: "block_type"
      expr: block_type
      comment: "Type of block applied or released during this transition. Enables analysis of block frequency and resolution time by block category."
    - name: "change_reason_code"
      expr: change_reason_code
      comment: "Standardized reason code for the status transition. Enables root cause analysis of order lifecycle events and process improvement prioritization."
    - name: "sales_organization"
      expr: sales_organization
      comment: "SAP sales organization associated with the order. Enables regional order lifecycle performance and SLA compliance analysis."
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant associated with the order at time of transition. Enables plant-level order lifecycle and SLA performance benchmarking."
    - name: "is_reversal"
      expr: is_reversal
      comment: "Indicates whether this transition is a reversal of a prior status change. Enables analysis of order lifecycle exception and error rates."
    - name: "status_change_date"
      expr: status_change_date
      comment: "Calendar date of the status transition. Primary time dimension for order lifecycle trend analysis and SLA breach detection."
  measures:
    - name: "status_transition_count"
      expr: COUNT(1)
      comment: "Total number of order status transitions. Measures order lifecycle activity volume and process throughput."
    - name: "sla_breach_count"
      expr: COUNT(CASE WHEN sla_breach_flag = TRUE THEN 1 END)
      comment: "Number of status transitions that occurred after the SLA deadline. Directly measures SLA compliance failures — high counts indicate systemic process delays requiring executive intervention."
    - name: "sla_breach_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN sla_breach_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of status transitions that breached the SLA deadline. Premier order-to-cash process KPI — directly tied to customer satisfaction, contract penalty risk, and operational efficiency."
    - name: "manual_transition_count"
      expr: COUNT(CASE WHEN transition_type = 'Manual' THEN 1 END)
      comment: "Number of status transitions initiated manually by a user. Measures manual intervention burden in the order-to-cash process — high counts indicate automation gaps."
    - name: "automation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN transition_type = 'Automatic' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of status transitions executed automatically by system rules. Process efficiency KPI — higher automation rates indicate a more streamlined, scalable order-to-cash process."
    - name: "reversal_transition_count"
      expr: COUNT(CASE WHEN is_reversal = TRUE THEN 1 END)
      comment: "Number of status transitions that represent reversals of prior changes. Measures order lifecycle exception frequency — high reversal counts indicate process errors or customer-driven order changes."
    - name: "reversal_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_reversal = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of status transitions that are reversals. Process quality KPI — high reversal rates indicate systemic order management errors or high customer change request volumes."
    - name: "approval_required_transition_count"
      expr: COUNT(CASE WHEN approval_required_flag = TRUE THEN 1 END)
      comment: "Number of status transitions requiring formal management approval. Measures governance overhead in the order-to-cash process — used to assess delegation of authority policy effectiveness."
    - name: "notification_sent_count"
      expr: COUNT(CASE WHEN notification_sent_flag = TRUE THEN 1 END)
      comment: "Number of status transitions that triggered a customer notification. Measures customer communication compliance — used to ensure customers are informed of order lifecycle events per SLA requirements."
    - name: "distinct_orders_with_sla_breach"
      expr: COUNT(DISTINCT CASE WHEN sla_breach_flag = TRUE THEN line_item_id END)
      comment: "Number of distinct order line items that experienced at least one SLA breach. Measures the breadth of SLA compliance failures across the order portfolio — used to assess customer impact scope."
$$;