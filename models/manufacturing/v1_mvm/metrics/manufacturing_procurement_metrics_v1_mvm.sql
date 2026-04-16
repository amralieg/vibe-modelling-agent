-- Metric views for domain: procurement | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_delivery_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Supplier delivery performance metrics tracking on-time delivery (OTD), schedule adherence, quantity fill rates, and JIT compliance. Core KPI view for procurement operations and supplier scorecards in lean manufacturing environments."
  source: "`manufacturing_ecm`.`procurement`.`delivery_schedule`"
  filter: status NOT IN ('cancelled', 'closed')
  dimensions:
    - name: "supplier_id"
      expr: supplier_id
      comment: "Supplier identifier enabling per-supplier delivery performance analysis and scorecarding."
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the receiving manufacturing facility, enabling plant-level delivery performance benchmarking."
    - name: "schedule_type"
      expr: schedule_type
      comment: "Delivery schedule type (JIT, forecast, firm, Kanban) enabling performance segmentation by replenishment strategy."
    - name: "release_type"
      expr: release_type
      comment: "Schedule release type (JIT, forecast, immediate, manual) for segmenting delivery performance by commitment firmness."
    - name: "schedule_adherence_status"
      expr: schedule_adherence_status
      comment: "Categorical delivery adherence status (on_time, early, late, partial, missed, pending) for exception-based reporting."
    - name: "material_number"
      expr: material_number
      comment: "SAP material number enabling part-level delivery performance analysis and MRP reconciliation."
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization code for org-level delivery performance governance."
    - name: "purchasing_group_code"
      expr: purchasing_group_code
      comment: "Purchasing group (buyer) code enabling buyer-level delivery performance accountability."
    - name: "delivery_country_code"
      expr: delivery_country_code
      comment: "Delivery destination country code for regional supply chain performance analysis."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms code for segmenting delivery performance by risk and cost transfer terms."
    - name: "scheduled_delivery_month"
      expr: DATE_TRUNC('MONTH', scheduled_delivery_date)
      comment: "Month of scheduled delivery date for trend analysis of supplier delivery performance over time."
    - name: "actual_delivery_month"
      expr: DATE_TRUNC('MONTH', actual_delivery_date)
      comment: "Month of actual delivery date for tracking when deliveries were physically received."
    - name: "unit_of_measure"
      expr: unit_of_measure
      comment: "Base unit of measure for quantity metrics, ensuring consistent aggregation across materials."
    - name: "mrp_element_type"
      expr: mrp_element_type
      comment: "MRP planning element type that originated the schedule line, enabling demand-source analysis."
  measures:
    - name: "total_schedule_lines"
      expr: COUNT(1)
      comment: "Total number of delivery schedule lines. Baseline volume measure for delivery performance rate calculations."
    - name: "on_time_delivery_lines"
      expr: COUNT(CASE WHEN is_on_time = TRUE THEN 1 END)
      comment: "Count of schedule lines where actual delivery fell within the scheduled window. Numerator for OTD rate."
    - name: "on_time_delivery_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_on_time = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_delivery_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "On-Time Delivery (OTD) rate as a percentage of completed deliveries. Primary supplier delivery KPI used in scorecards and SLA compliance reporting. Executives use this to identify underperforming suppliers and trigger corrective action."
    - name: "total_scheduled_quantity"
      expr: SUM(CAST(scheduled_quantity AS DOUBLE))
      comment: "Total quantity scheduled for delivery across all schedule lines. Baseline for fill rate and coverage calculations."
    - name: "total_delivered_quantity"
      expr: SUM(CAST(delivered_quantity AS DOUBLE))
      comment: "Total quantity actually received via GRN processing. Used to calculate delivery fill rate against scheduled demand."
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed by suppliers for delivery. Compared against scheduled quantity to assess supplier commitment reliability."
    - name: "delivery_fill_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(delivered_quantity AS DOUBLE)) / NULLIF(SUM(CAST(scheduled_quantity AS DOUBLE)), 0), 2)
      comment: "Delivery fill rate: percentage of scheduled quantity actually delivered. Critical KPI for supply coverage and production continuity risk. A fill rate below target triggers supplier escalation and safety stock reviews."
    - name: "supplier_confirmation_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE)) / NULLIF(SUM(CAST(scheduled_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of scheduled quantity confirmed by the supplier. Measures supplier responsiveness and commitment reliability. Low confirmation rates signal capacity risk requiring procurement intervention."
    - name: "missed_delivery_lines"
      expr: COUNT(CASE WHEN schedule_adherence_status = 'missed' THEN 1 END)
      comment: "Count of schedule lines with no delivery received (missed status). Direct indicator of supply disruption risk and production line stoppage exposure."
    - name: "late_delivery_lines"
      expr: COUNT(CASE WHEN schedule_adherence_status = 'late' THEN 1 END)
      comment: "Count of schedule lines where delivery occurred after the scheduled date. Used in supplier performance scorecards and penalty clause triggers."
    - name: "partial_delivery_lines"
      expr: COUNT(CASE WHEN schedule_adherence_status = 'partial' THEN 1 END)
      comment: "Count of schedule lines with quantity shortfall deliveries. Partial deliveries create production planning gaps and inventory reconciliation overhead."
    - name: "schedule_lines_with_grn"
      expr: COUNT(CASE WHEN grn_number IS NOT NULL THEN 1 END)
      comment: "Count of schedule lines with a posted Goods Receipt Note. Measures actual goods receipt completion rate for three-way match readiness."
    - name: "avg_days_early_late"
      expr: AVG(CAST(CASE WHEN actual_delivery_date IS NOT NULL THEN days_early_late END AS DOUBLE))
      comment: "Average days early (negative) or late (positive) across completed deliveries. A positive average indicates systemic lateness; used in supplier performance reviews and SLA renegotiations."
    - name: "total_schedule_value"
      expr: SUM(CAST(scheduled_quantity AS DOUBLE) * CAST(unit_price AS DOUBLE))
      comment: "Total monetary value of scheduled deliveries (scheduled quantity × unit price). Enables spend-weighted delivery performance analysis and financial exposure quantification for missed/late deliveries."
    - name: "delivered_value"
      expr: SUM(CAST(delivered_quantity AS DOUBLE) * CAST(unit_price AS DOUBLE))
      comment: "Total monetary value of goods actually received. Compared against scheduled value to quantify financial exposure from delivery shortfalls."
    - name: "jit_schedule_lines"
      expr: COUNT(CASE WHEN schedule_type = 'JIT' THEN 1 END)
      comment: "Count of JIT delivery schedule lines. JIT lines carry the highest production risk if missed; used to prioritize supplier escalation and lean manufacturing performance monitoring."
    - name: "jit_on_time_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN schedule_type = 'JIT' AND is_on_time = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN schedule_type = 'JIT' AND actual_delivery_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "On-time delivery rate specifically for JIT schedule lines. JIT OTD is a critical lean manufacturing KPI — failures directly cause production line stoppages and are escalated to executive level."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_supply_agreement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Supply agreement portfolio metrics covering contract utilization, committed spend, agreement lifecycle health, and sourcing strategy compliance. Enables category managers and CPOs to monitor contract coverage, renewal risk, and spend commitment against negotiated agreements."
  source: "`manufacturing_ecm`.`procurement`.`supply_agreement`"
  filter: status IN ('active', 'suspended', 'expired', 'terminated')
  dimensions:
    - name: "supplier_id"
      expr: supplier_id
      comment: "Supplier identifier for per-supplier contract portfolio analysis."
    - name: "agreement_type"
      expr: agreement_type
      comment: "Agreement type (scheduling agreement, blanket order, framework contract, master supply agreement) for portfolio segmentation."
    - name: "procurement_type"
      expr: procurement_type
      comment: "Procurement scope classification (direct materials, indirect, MRO, services, CAPEX) for spend category governance."
    - name: "status"
      expr: status
      comment: "Agreement lifecycle status (active, suspended, expired, terminated) for contract health monitoring."
    - name: "category_code"
      expr: category_code
      comment: "Spend category code for category-level contract coverage and utilization analysis."
    - name: "plant_code"
      expr: plant_code
      comment: "Plant code for plant-level supply agreement coverage and spend commitment reporting."
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization for org-level contract portfolio governance."
    - name: "currency_code"
      expr: currency_code
      comment: "Agreement currency for multi-currency spend commitment reporting."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Incoterms code for supply risk and logistics cost analysis by delivery terms."
    - name: "pricing_condition_type"
      expr: pricing_condition_type
      comment: "Pricing mechanism type (fixed, tiered, index-linked, cost-plus) for commercial risk and cost volatility analysis."
    - name: "country_of_supply"
      expr: country_of_supply
      comment: "Supply country for geographic supply chain risk and trade compliance reporting."
    - name: "penalty_clause_flag"
      expr: penalty_clause_flag
      comment: "Indicates agreements with contractual penalty clauses, enabling risk-weighted contract portfolio analysis."
    - name: "auto_renewal_flag"
      expr: auto_renewal_flag
      comment: "Indicates auto-renewing agreements for contract lifecycle management and renewal risk monitoring."
    - name: "effective_start_year"
      expr: YEAR(effective_start_date)
      comment: "Year the agreement became effective for cohort analysis of contract portfolio vintage."
    - name: "effective_end_year"
      expr: YEAR(effective_end_date)
      comment: "Year the agreement expires for renewal pipeline planning and expiry risk monitoring."
  measures:
    - name: "total_agreements"
      expr: COUNT(1)
      comment: "Total number of supply agreements in the portfolio. Baseline measure for contract coverage and density analysis."
    - name: "active_agreements"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Count of currently active supply agreements. Measures effective contract coverage across the supplier base."
    - name: "total_committed_value"
      expr: SUM(CAST(total_committed_value AS DOUBLE))
      comment: "Total monetary value committed across all supply agreements. Primary spend commitment KPI used in budget planning, cash flow forecasting, and procurement strategy reviews."
    - name: "total_released_value"
      expr: SUM(CAST(released_value AS DOUBLE))
      comment: "Total value of purchase order releases issued against supply agreements. Measures actual spend execution against contracted commitments."
    - name: "agreement_utilization_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(released_value AS DOUBLE)) / NULLIF(SUM(CAST(total_committed_value AS DOUBLE)), 0), 2)
      comment: "Percentage of committed agreement value that has been released/consumed. Low utilization signals under-leveraged contracts or demand shortfalls; high utilization signals risk of exceeding committed volumes. Critical for category management and supplier negotiations."
    - name: "total_committed_quantity"
      expr: SUM(CAST(total_committed_quantity AS DOUBLE))
      comment: "Total volume committed across all supply agreements. Used for capacity reservation planning and supplier volume commitment tracking."
    - name: "total_released_quantity"
      expr: SUM(CAST(released_quantity AS DOUBLE))
      comment: "Total quantity released against supply agreements. Compared against committed quantity to monitor volume consumption and remaining open commitment."
    - name: "avg_unit_price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average negotiated unit price across supply agreements. Used in price benchmarking, should-cost analysis, and supplier negotiation preparation."
    - name: "agreements_expiring_within_90_days"
      expr: COUNT(CASE WHEN status = 'active' AND effective_end_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Count of active agreements expiring within 90 days. Critical renewal risk KPI — procurement teams use this to prioritize renegotiation and prevent supply gaps from contract lapses."
    - name: "agreements_with_penalty_clauses"
      expr: COUNT(CASE WHEN penalty_clause_flag = TRUE THEN 1 END)
      comment: "Count of agreements containing contractual penalty clauses. Measures supplier accountability coverage and financial risk protection in the contract portfolio."
    - name: "terminated_agreements"
      expr: COUNT(CASE WHEN status = 'terminated' THEN 1 END)
      comment: "Count of early-terminated agreements. Elevated termination rates signal supplier relationship issues or sourcing strategy failures requiring executive review."
    - name: "avg_agreement_duration_days"
      expr: AVG(CAST(DATEDIFF(effective_end_date, effective_start_date) AS DOUBLE))
      comment: "Average duration of supply agreements in days. Longer agreements indicate strategic supplier relationships; shorter agreements may signal sourcing instability or spot-market dependency."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_demand_forecast`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Demand forecast quality and S&OP planning metrics covering forecast accuracy (MAPE, bias), consensus adjustment magnitude, MRP relevance coverage, and forecasted spend. Enables supply chain leadership to govern S&OP cycle quality and identify systemic forecast errors that drive procurement inefficiency."
  source: "`manufacturing_ecm`.`procurement`.`demand_forecast`"
  filter: status IN ('locked', 'approved', 'final')
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant code for plant-level forecast accuracy and demand planning performance analysis."
    - name: "forecast_period_type"
      expr: forecast_period_type
      comment: "Forecast time bucket granularity (weekly, monthly, quarterly) for horizon-specific accuracy analysis."
    - name: "version_type"
      expr: version_type
      comment: "Forecast version type (baseline, statistical, consensus, final, adjusted, simulation) for S&OP governance and version comparison."
    - name: "demand_category"
      expr: demand_category
      comment: "Demand type classification (independent, dependent, spare parts, promotional, NPI, phase-out) for methodology-appropriate accuracy benchmarking."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC inventory classification (A/B/C) for value-weighted forecast accuracy analysis and differentiated planning policy governance."
    - name: "xyz_classification"
      expr: xyz_classification
      comment: "XYZ demand variability classification (X/Y/Z) for demand pattern-based forecast strategy assessment."
    - name: "product_category_code"
      expr: product_category_code
      comment: "Procurement category code for category-level demand planning and spend forecast analysis."
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization for org-level demand signal and procurement planning accountability."
    - name: "mrp_type"
      expr: mrp_type
      comment: "SAP MRP type for segmenting forecast accuracy by planning methodology."
    - name: "is_mrp_relevant"
      expr: is_mrp_relevant
      comment: "MRP relevance flag for filtering active demand signals consumed by planning runs."
    - name: "is_supplier_shared"
      expr: is_supplier_shared
      comment: "Supplier sharing flag for CPFR (Collaborative Planning, Forecasting, and Replenishment) coverage analysis."
    - name: "sop_cycle"
      expr: sop_cycle
      comment: "S&OP planning cycle (YYYY-MM) for cycle-over-cycle forecast quality trend analysis."
    - name: "forecast_start_month"
      expr: DATE_TRUNC('MONTH', forecast_start_date)
      comment: "Forecast period start month for time-series demand planning analysis."
    - name: "country_code"
      expr: country_code
      comment: "Country code for regional demand aggregation and cross-border supply planning analysis."
  measures:
    - name: "total_forecast_records"
      expr: COUNT(1)
      comment: "Total number of active forecast records. Baseline measure for S&OP planning coverage assessment."
    - name: "total_forecasted_quantity"
      expr: SUM(CAST(forecasted_quantity AS DOUBLE))
      comment: "Total consensus demand quantity across all active forecast records. Primary demand signal volume consumed by MRP planning runs."
    - name: "total_forecasted_spend"
      expr: SUM(CAST(forecasted_spend_amount AS DOUBLE))
      comment: "Total estimated procurement spend across all active forecasts. Used for budget planning, cash flow projection, and supplier capacity reservation negotiations."
    - name: "avg_forecast_mape"
      expr: AVG(CAST(mape AS DOUBLE))
      comment: "Average Mean Absolute Percentage Error (MAPE) across forecast records. Primary S&OP forecast accuracy KPI — lower is better. Executives use this to assess planning quality and justify safety stock investment."
    - name: "avg_forecast_bias"
      expr: AVG(CAST(forecast_bias AS DOUBLE))
      comment: "Average forecast bias (positive = over-forecast, negative = under-forecast). Systemic bias drives excess inventory or stockouts; used to detect and correct algorithmic or commercial forecast distortions."
    - name: "total_consensus_adjustment_quantity"
      expr: SUM(CAST(consensus_adjustment_quantity AS DOUBLE))
      comment: "Total manual consensus adjustment applied over the statistical baseline. Large adjustments indicate low confidence in statistical models and high reliance on manual overrides — a governance risk signal."
    - name: "total_statistical_forecast_quantity"
      expr: SUM(CAST(statistical_forecast_quantity AS DOUBLE))
      comment: "Total system-generated statistical forecast quantity before consensus adjustments. Compared against total_forecasted_quantity to quantify the magnitude of human override in the S&OP process."
    - name: "consensus_override_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(consensus_adjustment_quantity AS DOUBLE)) / NULLIF(SUM(CAST(statistical_forecast_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage by which consensus adjustments deviate from the statistical baseline. High override rates signal either poor model performance or excessive commercial bias — both require S&OP governance intervention."
    - name: "mrp_relevant_forecast_records"
      expr: COUNT(CASE WHEN is_mrp_relevant = TRUE THEN 1 END)
      comment: "Count of forecast records active and eligible for MRP consumption. Measures effective demand signal coverage for procurement planning."
    - name: "supplier_shared_forecast_records"
      expr: COUNT(CASE WHEN is_supplier_shared = TRUE THEN 1 END)
      comment: "Count of forecasts shared with suppliers for capacity reservation. Measures CPFR program coverage — a strategic KPI for collaborative supply chain maturity."
    - name: "avg_safety_stock_quantity"
      expr: AVG(CAST(safety_stock_quantity AS DOUBLE))
      comment: "Average recommended safety stock level derived from demand forecasts. Tracks buffer inventory investment driven by forecast uncertainty — directly impacts working capital and service level trade-offs."
    - name: "total_safety_stock_quantity"
      expr: SUM(CAST(safety_stock_quantity AS DOUBLE))
      comment: "Total safety stock quantity recommended across all forecast records. Quantifies the aggregate working capital tied up in demand uncertainty buffers — a key supply chain efficiency metric."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_mrp_planned_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "MRP planned order pipeline metrics covering planned procurement value, firming rates, conversion performance, and exception workload. Enables supply chain and procurement leadership to monitor MRP planning health, controller workload, and the conversion pipeline from planned orders to purchase requisitions."
  source: "`manufacturing_ecm`.`procurement`.`mrp_planned_order`"
  filter: status NOT IN ('cancelled')
  dimensions:
    - name: "order_type"
      expr: order_type
      comment: "Planned order type (purchase requisition, production order, transfer order, subcontracting) for conversion path analysis."
    - name: "procurement_type"
      expr: procurement_type
      comment: "Procurement type (external, in-house, both) for segmenting planned orders by sourcing strategy."
    - name: "status"
      expr: status
      comment: "Planned order lifecycle status (created, firmed, converted, exception) for pipeline stage analysis."
    - name: "mrp_controller_code"
      expr: mrp_controller_code
      comment: "MRP controller code for workload distribution and controller performance analysis."
    - name: "demand_source_type"
      expr: demand_source_type
      comment: "Demand element type that triggered the planned order (sales order, forecast, safety stock, BOM explosion) for demand-source traceability."
    - name: "lot_size_key"
      expr: lot_size_key
      comment: "Lot-sizing procedure for analyzing procurement cost efficiency and order quantity optimization."
    - name: "mrp_type"
      expr: mrp_type
      comment: "MRP planning procedure for segmenting planned order pipeline by planning methodology."
    - name: "is_firmed"
      expr: is_firmed
      comment: "Firmed flag for distinguishing protected planned orders from system-managed orders in the pipeline."
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization for org-level planned order conversion accountability."
    - name: "purchasing_group_code"
      expr: purchasing_group_code
      comment: "Purchasing group (buyer) for buyer-level planned order workload and conversion performance."
    - name: "company_code"
      expr: company_code
      comment: "Company code for legal entity-level MRP planning and spend commitment reporting."
    - name: "planned_start_month"
      expr: DATE_TRUNC('MONTH', planned_start_date)
      comment: "Month of planned order start date for procurement pipeline timing analysis."
    - name: "requirements_month"
      expr: DATE_TRUNC('MONTH', requirements_date)
      comment: "Month material is required for demand coverage analysis and supply planning horizon visibility."
    - name: "exception_message_code"
      expr: exception_message_code
      comment: "MRP exception message code for exception workload analysis and controller action prioritization."
  measures:
    - name: "total_planned_orders"
      expr: COUNT(1)
      comment: "Total planned orders in the pipeline. Baseline measure for MRP planning workload and procurement pipeline sizing."
    - name: "total_planned_order_value"
      expr: SUM(CAST(planned_order_value AS DOUBLE))
      comment: "Total estimated monetary value of planned orders. Primary procurement commitment pipeline KPI used in budget planning and cash flow forecasting."
    - name: "total_planned_quantity"
      expr: SUM(CAST(planned_quantity AS DOUBLE))
      comment: "Total quantity across all planned orders. Used for supply coverage analysis and capacity reservation planning."
    - name: "firmed_planned_orders"
      expr: COUNT(CASE WHEN is_firmed = TRUE THEN 1 END)
      comment: "Count of firmed (MRP-protected) planned orders. Measures the proportion of the pipeline locked against automatic MRP rescheduling."
    - name: "firmed_planned_order_value"
      expr: SUM(CASE WHEN is_firmed = TRUE THEN CAST(planned_order_value AS DOUBLE) ELSE 0 END)
      comment: "Total value of firmed planned orders. Represents the committed procurement pipeline protected from MRP changes — a key supply stability metric."
    - name: "firming_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_firmed = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of planned orders that have been firmed by MRP controllers. Low firming rates indicate planning instability and excessive MRP churn; high rates indicate proactive controller engagement."
    - name: "converted_planned_orders"
      expr: COUNT(CASE WHEN status = 'converted' THEN 1 END)
      comment: "Count of planned orders converted to purchase requisitions or production orders. Measures procurement execution velocity from MRP signal to actionable order."
    - name: "conversion_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN status = 'converted' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of planned orders converted to purchase requisitions or production orders. Low conversion rates indicate MRP controller bottlenecks or planning quality issues requiring management intervention."
    - name: "planned_orders_with_exceptions"
      expr: COUNT(CASE WHEN exception_message_code IS NOT NULL THEN 1 END)
      comment: "Count of planned orders with active MRP exception messages. High exception counts signal planning deviations requiring controller action — a key MRP health KPI."
    - name: "exception_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN exception_message_code IS NOT NULL THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of planned orders carrying MRP exception messages. Elevated exception rates indicate systemic planning instability, demand volatility, or supply disruptions requiring executive attention."
    - name: "avg_planned_order_value"
      expr: AVG(CAST(planned_order_value AS DOUBLE))
      comment: "Average monetary value per planned order. Used for procurement workload sizing and buyer capacity planning."
    - name: "total_safety_stock_quantity"
      expr: SUM(CAST(safety_stock_quantity AS DOUBLE))
      comment: "Total safety stock quantity across planned orders. Quantifies buffer inventory investment driven by demand and supply uncertainty in the MRP planning horizon."
    - name: "bom_exploded_orders"
      expr: COUNT(CASE WHEN bom_explosion_indicator = TRUE THEN 1 END)
      comment: "Count of planned orders where BOM explosion was performed. Measures the depth of dependent demand planning and multi-level MRP coverage."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_preferred_supplier_list`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Preferred Supplier List (PSL) governance metrics covering supplier qualification coverage, strategic supplier concentration, compliance status, diversity program participation, and PSL renewal health. Enables category managers and CPOs to govern sourcing policy compliance and supplier portfolio quality."
  source: "`manufacturing_ecm`.`procurement`.`preferred_supplier_list`"
  filter: status IN ('active', 'approved', 'expired')
  dimensions:
    - name: "supplier_id"
      expr: supplier_id
      comment: "Supplier identifier for per-supplier PSL status and compliance analysis."
    - name: "category_code"
      expr: category_code
      comment: "Spend category code for category-level preferred supplier coverage and compliance analysis."
    - name: "preference_tier"
      expr: preference_tier
      comment: "Preference tier (Preferred, Approved, Conditional, Restricted) for sourcing policy compliance and tier distribution analysis."
    - name: "procurement_type"
      expr: procurement_type
      comment: "Procurement type (direct, indirect, MRO, services, CAPEX) for spend-type-specific PSL governance."
    - name: "plant_code"
      expr: plant_code
      comment: "Plant code for plant-level preferred supplier coverage analysis."
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization for org-level PSL governance and compliance reporting."
    - name: "status"
      expr: status
      comment: "PSL entry lifecycle status for active vs. expired supplier designation monitoring."
    - name: "approval_status"
      expr: approval_status
      comment: "Workflow approval status for PSL entries pending authorization — identifies governance bottlenecks."
    - name: "is_strategic_supplier"
      expr: is_strategic_supplier
      comment: "Strategic supplier flag for executive-level relationship management and strategic partner portfolio analysis."
    - name: "is_single_source"
      expr: is_single_source
      comment: "Single-source flag for supply concentration risk monitoring and sole-source justification compliance."
    - name: "is_diversity_supplier"
      expr: is_diversity_supplier
      comment: "Diversity supplier flag for supplier diversity program compliance and ESG reporting."
    - name: "region_code"
      expr: region_code
      comment: "Geographic region code for regional PSL coverage and sourcing strategy analysis."
    - name: "country_code"
      expr: country_code
      comment: "Country code for country-level preferred supplier governance and trade compliance."
    - name: "rohs_compliant"
      expr: rohs_compliant
      comment: "RoHS compliance flag for electronics procurement regulatory compliance monitoring."
    - name: "reach_compliant"
      expr: reach_compliant
      comment: "REACH compliance flag for chemical and material procurement regulatory compliance monitoring."
    - name: "conflict_minerals_compliant"
      expr: conflict_minerals_compliant
      comment: "Conflict minerals compliance flag for Dodd-Frank Section 1502 regulatory compliance tracking."
    - name: "valid_to_year"
      expr: YEAR(valid_to_date)
      comment: "Year of PSL entry expiry for renewal pipeline planning and expiry risk monitoring."
  measures:
    - name: "total_psl_entries"
      expr: COUNT(1)
      comment: "Total preferred supplier list entries. Baseline measure for PSL portfolio size and category coverage."
    - name: "active_psl_entries"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Count of currently active PSL entries. Measures effective preferred supplier coverage across categories and plants."
    - name: "strategic_supplier_count"
      expr: COUNT(CASE WHEN is_strategic_supplier = TRUE THEN 1 END)
      comment: "Count of PSL entries designated as strategic suppliers. Strategic suppliers warrant executive relationship management and joint development programs — a key portfolio quality metric."
    - name: "single_source_entries"
      expr: COUNT(CASE WHEN is_single_source = TRUE THEN 1 END)
      comment: "Count of single-source PSL entries. High single-source concentration indicates supply chain risk requiring diversification strategy review at executive level."
    - name: "single_source_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_single_source = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'active' THEN 1 END), 0), 2)
      comment: "Percentage of active PSL entries that are single-sourced. A critical supply concentration risk KPI — elevated rates trigger supply chain resilience reviews and dual-sourcing initiatives."
    - name: "diversity_supplier_count"
      expr: COUNT(CASE WHEN is_diversity_supplier = TRUE THEN 1 END)
      comment: "Count of diversity supplier PSL entries. Measures supplier diversity program coverage for ESG compliance and corporate social responsibility reporting."
    - name: "diversity_supplier_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_diversity_supplier = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'active' THEN 1 END), 0), 2)
      comment: "Percentage of active PSL entries that are diversity suppliers. Tracks supplier diversity program performance against corporate ESG targets."
    - name: "psl_entries_expiring_within_90_days"
      expr: COUNT(CASE WHEN status = 'active' AND valid_to_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Count of active PSL entries expiring within 90 days. Procurement teams use this to prioritize supplier requalification and PSL renewal to prevent sourcing policy gaps."
    - name: "rohs_compliant_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN rohs_compliant = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'active' THEN 1 END), 0), 2)
      comment: "Percentage of active PSL entries with confirmed RoHS compliance. Regulatory compliance KPI for electronics procurement — non-compliance exposes the company to EU market access risk."
    - name: "reach_compliant_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN reach_compliant = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'active' THEN 1 END), 0), 2)
      comment: "Percentage of active PSL entries with confirmed REACH compliance. Regulatory compliance KPI for chemical and material procurement — non-compliance creates EU market and liability risk."
    - name: "conflict_minerals_compliant_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN conflict_minerals_compliant = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'active' THEN 1 END), 0), 2)
      comment: "Percentage of active PSL entries with conflict minerals compliance documentation. Dodd-Frank Section 1502 compliance KPI — gaps expose the company to SEC reporting violations and reputational risk."
    - name: "avg_spend_allocation_pct"
      expr: AVG(CAST(spend_allocation_percent AS DOUBLE))
      comment: "Average target spend allocation percentage across PSL entries. Used to assess sourcing strategy balance and identify over-concentration in single suppliers within categories."
    - name: "tier1_preferred_supplier_count"
      expr: COUNT(CASE WHEN preference_tier = 'Preferred' AND status = 'active' THEN 1 END)
      comment: "Count of active Tier 1 (Preferred) PSL entries. Measures the depth of the primary preferred supplier pool — thin Tier 1 coverage increases supply risk and reduces negotiating leverage."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`procurement_quota_arrangement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quota arrangement utilization and multi-source supply strategy metrics. Enables category managers to monitor supplier volume allocation compliance, quota consumption rates, and sourcing diversification effectiveness across the approved supplier base."
  source: "`manufacturing_ecm`.`procurement`.`quota_arrangement`"
  filter: status = 'active' AND is_blocked = FALSE
  dimensions:
    - name: "supplier_id"
      expr: supplier_id
      comment: "Supplier identifier for per-supplier quota allocation and utilization analysis."
    - name: "category_code"
      expr: category_code
      comment: "Procurement category code for category-level quota strategy and multi-source compliance analysis."
    - name: "procurement_type"
      expr: procurement_type
      comment: "Procurement method (external, subcontracting, consignment, stock transfer) for quota strategy segmentation."
    - name: "purchasing_org_code"
      expr: purchasing_org_code
      comment: "Purchasing organization for org-level quota governance and sourcing strategy compliance."
    - name: "is_fixed_source"
      expr: is_fixed_source
      comment: "Fixed source flag for identifying sole-source quota lines that bypass ratio calculations."
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "Country of origin for geographic supply diversification and trade compliance analysis."
    - name: "unit_of_measure"
      expr: unit_of_measure
      comment: "Unit of measure for consistent quantity aggregation across quota arrangements."
    - name: "valid_from_year"
      expr: YEAR(valid_from_date)
      comment: "Year quota arrangement became effective for vintage analysis of sourcing strategy evolution."
    - name: "valid_to_year"
      expr: YEAR(valid_to_date)
      comment: "Year quota arrangement expires for renewal pipeline and sourcing continuity planning."
  measures:
    - name: "total_quota_lines"
      expr: COUNT(1)
      comment: "Total active quota arrangement lines. Baseline measure for multi-source supply strategy coverage."
    - name: "total_allocated_quantity"
      expr: SUM(CAST(allocated_quantity AS DOUBLE))
      comment: "Total cumulative quantity allocated to suppliers under quota arrangements. Measures actual procurement volume distributed across the approved supplier base."
    - name: "total_quota_base_quantity"
      expr: SUM(CAST(quota_base_quantity AS DOUBLE))
      comment: "Total quota base quantity across all active arrangements. Reference baseline for quota utilization rate calculation."
    - name: "quota_utilization_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(allocated_quantity AS DOUBLE)) / NULLIF(SUM(CAST(quota_base_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of quota base quantity consumed through actual allocations. Measures how effectively the multi-source strategy is being executed — significant deviations from target percentages indicate sourcing policy non-compliance."
    - name: "avg_quota_percentage"
      expr: AVG(CAST(quota_percentage AS DOUBLE))
      comment: "Average quota percentage allocated per supplier line. Used to assess sourcing concentration and validate that multi-source strategies are balanced per procurement policy."
    - name: "fixed_source_quota_lines"
      expr: COUNT(CASE WHEN is_fixed_source = TRUE THEN 1 END)
      comment: "Count of fixed-source quota lines that bypass ratio calculations. High fixed-source concentration indicates single-source dependency risk within nominally multi-source arrangements."
    - name: "quota_lines_expiring_within_90_days"
      expr: COUNT(CASE WHEN valid_to_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN 1 END)
      comment: "Count of active quota lines expiring within 90 days. Procurement teams use this to prioritize quota renewal and prevent MRP source determination failures from expired arrangements."
    - name: "avg_minimum_lot_size"
      expr: AVG(CAST(minimum_lot_size AS DOUBLE))
      comment: "Average minimum order quantity across quota lines. Used in procurement cost optimization and order consolidation strategy analysis."
    - name: "avg_maximum_lot_size"
      expr: AVG(CAST(maximum_lot_size AS DOUBLE))
      comment: "Average maximum order quantity across quota lines. Used to assess supplier capacity constraints and order splitting requirements in multi-source strategies."
$$;