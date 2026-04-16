-- Metric views for domain: production | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_production_confirmation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core production output KPIs derived from goods confirmations posted against production orders. Covers throughput yield, scrap rate, rework rate, actual vs standard time efficiency, and cost settlement. Used by plant managers, production controllers, and operations VPs to steer shop floor performance, OEE quality component, and COGS variance."
  source: "`manufacturing_ecm`.`production`.`production_confirmation`"
  filter: status = 'Posted'
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the manufacturing facility. Enables multi-plant benchmarking of production output performance."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where the confirmed operation was executed. Enables work-center-level throughput and quality analysis."
    - name: "material_number"
      expr: material_number
      comment: "SAP material number of the finished or semi-finished product confirmed. Enables product-level yield and scrap analysis."
    - name: "material_description"
      expr: material_description
      comment: "Human-readable material description for reporting without requiring a material master join."
    - name: "production_strategy"
      expr: production_strategy
      comment: "Manufacturing strategy (MTO, MTS, ETO, ATO) under which the order was executed. Enables strategy-level performance segmentation."
    - name: "shift"
      expr: shift
      comment: "Production shift during which the confirmation was recorded. Enables shift-level OEE and throughput benchmarking."
    - name: "posting_date"
      expr: posting_date
      comment: "Accounting posting date for the confirmation. Enables daily, weekly, and monthly production output trend analysis."
    - name: "operation_number"
      expr: operation_number
      comment: "Routing operation sequence number confirmed. Enables operation-level quality and efficiency analysis."
    - name: "is_final_confirmation"
      expr: is_final_confirmation
      comment: "Indicates whether this is the final confirmation for the order. Used to filter for completed order analysis vs. partial confirmations."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the manufacturing plant. Supports regional and multinational production performance reporting."
    - name: "variance_reason_code"
      expr: variance_reason_code
      comment: "Coded reason for production deviations. Enables root cause analysis of yield and time variances."
  measures:
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity of good units successfully produced and confirmed. Primary throughput KPI for production output volume tracking."
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity of units scrapped during confirmed operations. Feeds scrap rate KPI and COGS variance analysis."
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total quantity of units requiring rework. Feeds cost-of-poor-quality (COPQ) and CAPA prioritization."
    - name: "total_production_output"
      expr: SUM((confirmed_quantity) + (scrap_quantity) + (rework_quantity))
      comment: "Total gross production output including good units, scrap, and rework. Denominator for yield and scrap rate calculations."
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_cost_amount AS DOUBLE))
      comment: "Total actual manufacturing cost settled to production orders. Core input for COGS reporting and actual vs. standard cost variance analysis."
    - name: "total_actual_machine_time_min"
      expr: SUM(CAST(actual_machine_time_min AS DOUBLE))
      comment: "Total actual machine runtime in minutes across all confirmed operations. Used for machine utilization and OEE performance rate analysis."
    - name: "total_actual_labor_time_min"
      expr: SUM(CAST(actual_labor_time_min AS DOUBLE))
      comment: "Total actual labor time in minutes across all confirmed operations. Used for workforce productivity and labor cost settlement analysis."
    - name: "total_actual_setup_time_min"
      expr: SUM(CAST(actual_setup_time_min AS DOUBLE))
      comment: "Total actual setup/changeover time in minutes. Key input for SMED analysis and OEE availability loss quantification."
    - name: "confirmation_count"
      expr: COUNT(1)
      comment: "Total number of production confirmations posted. Baseline volume metric for confirmation activity and order completion tracking."
    - name: "final_confirmation_count"
      expr: COUNT(CASE WHEN is_final_confirmation = TRUE THEN 1 END)
      comment: "Number of final confirmations posted, representing completed production order operations. Used to track order completion rate."
    - name: "scrap_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(scrap_quantity AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)) + SUM(CAST(scrap_quantity AS DOUBLE)) + SUM(CAST(rework_quantity AS DOUBLE)), 0), 2)
      comment: "Scrap rate as a percentage of total gross output. Critical quality KPI for Six Sigma, CAPA prioritization, and COGS variance steering."
    - name: "rework_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(rework_quantity AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)) + SUM(CAST(scrap_quantity AS DOUBLE)) + SUM(CAST(rework_quantity AS DOUBLE)), 0), 2)
      comment: "Rework rate as a percentage of total gross output. Measures cost-of-poor-quality and drives CAPA investment decisions."
    - name: "first_pass_yield_pct"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)) + SUM(CAST(scrap_quantity AS DOUBLE)) + SUM(CAST(rework_quantity AS DOUBLE)), 0), 2)
      comment: "First-pass yield: percentage of gross output that is good on the first pass without scrap or rework. Premier quality KPI for lean and Six Sigma programs."
    - name: "avg_actual_cost_per_unit"
      expr: ROUND(SUM(CAST(actual_cost_amount AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 4)
      comment: "Average actual manufacturing cost per confirmed good unit. Enables actual vs. standard cost per unit variance analysis for COGS management."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_scrap_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Scrap and rework event KPIs for production quality and waste management. Covers scrap cost, scrap quantity by category and work center, rework rates, and hazardous scrap compliance. Used by quality managers, plant controllers, and operations VPs to drive Six Sigma programs, CAPA prioritization, and COGS waste reduction."
  source: "`manufacturing_ecm`.`production`.`scrap_record`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the scrap event occurred. Enables multi-plant scrap benchmarking and regional compliance reporting."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where scrap was generated. Identifies quality hotspots for targeted improvement programs."
    - name: "material_number"
      expr: material_number
      comment: "SAP material number of the scrapped material. Enables material-level scrap rate analysis and MRP II feedback."
    - name: "scrap_category"
      expr: scrap_category
      comment: "High-level classification of scrap origin (process, machine, material defect, operator error). Drives root cause categorization for Six Sigma and CAPA."
    - name: "scrap_reason_code"
      expr: scrap_reason_code
      comment: "Standardized reason code for the scrap cause. Enables Pareto analysis and CAPA prioritization."
    - name: "defect_code"
      expr: defect_code
      comment: "Specific defect classification code from the quality catalog. Supports SPC analysis and defect Pareto reporting."
    - name: "shift_code"
      expr: shift_code
      comment: "Production shift during which the scrap event occurred. Enables shift-level scrap benchmarking and operator performance analysis."
    - name: "production_strategy"
      expr: production_strategy
      comment: "Manufacturing strategy under which the scrapped order was produced. Contextualizes scrap impact on customer commitments and inventory."
    - name: "is_rework"
      expr: is_rework
      comment: "Indicates whether the scrapped item is designated for rework rather than disposal. Distinguishes recoverable non-conformances from permanent scrap."
    - name: "hazardous_material_flag"
      expr: hazardous_material_flag
      comment: "Indicates whether the scrapped material is hazardous. Triggers mandatory disposal procedures and regulatory reporting obligations."
    - name: "posting_date"
      expr: posting_date
      comment: "Accounting posting date for the scrap event. Determines the financial period for COGS variance recognition."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the plant where scrap occurred. Supports multi-country regulatory compliance and regional scrap benchmarking."
  measures:
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity of material declared as scrap. Core metric for scrap rate KPI calculation and Six Sigma improvement programs."
    - name: "total_scrap_cost"
      expr: SUM(CAST(scrap_cost AS DOUBLE))
      comment: "Total monetary value of scrapped material. Key input for COGS variance analysis and financial impact assessment of quality failures."
    - name: "scrap_event_count"
      expr: COUNT(1)
      comment: "Total number of scrap events recorded. Baseline frequency metric for scrap occurrence trend analysis and CAPA trigger monitoring."
    - name: "rework_event_count"
      expr: COUNT(CASE WHEN is_rework = TRUE THEN 1 END)
      comment: "Number of scrap events designated for rework rather than disposal. Measures recoverable quality failures and rework order generation rate."
    - name: "hazardous_scrap_quantity"
      expr: SUM(CASE WHEN hazardous_material_flag = TRUE THEN scrap_quantity ELSE 0 END)
      comment: "Total quantity of hazardous material scrapped. Drives regulatory compliance reporting and hazardous waste disposal cost tracking."
    - name: "hazardous_scrap_cost"
      expr: SUM(CASE WHEN hazardous_material_flag = TRUE THEN scrap_cost ELSE 0 END)
      comment: "Total cost of hazardous material scrapped. Quantifies financial exposure from hazardous waste and drives HSE investment decisions."
    - name: "avg_scrap_cost_per_event"
      expr: ROUND(SUM(CAST(scrap_cost AS DOUBLE)) / NULLIF(COUNT(1), 0), 2)
      comment: "Average scrap cost per scrap event. Enables prioritization of high-cost scrap categories for targeted quality improvement investment."
    - name: "distinct_production_orders_with_scrap"
      expr: COUNT(DISTINCT production_order_number)
      comment: "Number of distinct production orders that generated scrap events. Measures breadth of quality issues across the production order portfolio."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_downtime_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Equipment and production downtime KPIs for OEE availability analysis, MTTR tracking, and TPM program management. Covers total downtime duration, lost production, unplanned downtime rate, and mean time to repair. Used by plant managers, maintenance directors, and operations VPs to steer reliability improvement and OEE availability targets."
  source: "`manufacturing_ecm`.`production`.`downtime_event`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the downtime event occurred. Enables multi-plant OEE benchmarking and global downtime analysis."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center or production cell where downtime occurred. Identifies reliability hotspots for TPM and maintenance investment."
    - name: "machine_code"
      expr: machine_code
      comment: "Specific machine or equipment asset that experienced downtime. Enables asset-level MTBF/MTTR analysis and predictive maintenance prioritization."
    - name: "category"
      expr: category
      comment: "High-level downtime category (breakdown, planned maintenance, changeover, material shortage, quality hold). Drives OEE loss categorization and TPM pillar analysis."
    - name: "reason_code"
      expr: reason_code
      comment: "Standardized downtime reason code. Enables Pareto analysis of downtime causes and FMEA correlation."
    - name: "is_planned"
      expr: is_planned
      comment: "Indicates whether downtime was planned or unplanned. Critical for correctly computing OEE availability — only unplanned downtime reduces OEE."
    - name: "oee_impact_category"
      expr: oee_impact_category
      comment: "OEE loss category classification (availability loss vs. planned stop). Enables automated OEE waterfall chart generation."
    - name: "shift_code"
      expr: shift_code
      comment: "Production shift during which the downtime occurred. Enables shift-level downtime analysis and labor accountability in TPM programs."
    - name: "responsible_department"
      expr: responsible_department
      comment: "Department accountable for resolving the downtime event. Used for departmental KPI reporting and escalation routing."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the plant where downtime occurred. Supports multi-country OEE benchmarking and regional maintenance performance analysis."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the downtime event (open, resolved, closed). Drives workflow routing and enables open vs. resolved downtime analysis."
  measures:
    - name: "total_downtime_minutes"
      expr: SUM(CAST(duration_minutes AS DOUBLE))
      comment: "Total elapsed downtime in minutes across all events. Primary OEE availability loss metric and TPM performance indicator."
    - name: "unplanned_downtime_minutes"
      expr: SUM(CASE WHEN is_planned = FALSE THEN duration_minutes ELSE 0 END)
      comment: "Total unplanned downtime in minutes. The OEE availability loss component — only unplanned stops reduce OEE availability rate."
    - name: "planned_downtime_minutes"
      expr: SUM(CASE WHEN is_planned = TRUE THEN duration_minutes ELSE 0 END)
      comment: "Total planned downtime in minutes (scheduled maintenance, changeovers). Used to calculate planned stop time and net available production time."
    - name: "total_lost_production_quantity"
      expr: SUM(CAST(lost_production_quantity AS DOUBLE))
      comment: "Total production units lost due to downtime events. Quantifies the production impact of downtime for financial impact assessment and OEE performance loss."
    - name: "downtime_event_count"
      expr: COUNT(1)
      comment: "Total number of downtime events recorded. Baseline frequency metric for downtime occurrence rate and MTBF denominator."
    - name: "unplanned_downtime_event_count"
      expr: COUNT(CASE WHEN is_planned = FALSE THEN 1 END)
      comment: "Number of unplanned downtime events. Used as the frequency component for MTBF calculations and reliability trend analysis."
    - name: "avg_downtime_duration_minutes"
      expr: ROUND(SUM(CAST(duration_minutes AS DOUBLE)) / NULLIF(COUNT(1), 0), 2)
      comment: "Mean Time To Repair (MTTR) proxy — average duration per downtime event in minutes. Key reliability KPI for maintenance effectiveness and TPM program evaluation."
    - name: "avg_unplanned_downtime_minutes"
      expr: ROUND(SUM(CASE WHEN is_planned = FALSE THEN duration_minutes ELSE 0 END) / NULLIF(COUNT(CASE WHEN is_planned = FALSE THEN 1 END), 0), 2)
      comment: "Average duration of unplanned downtime events in minutes. Measures maintenance response effectiveness and drives MTTR reduction targets."
    - name: "distinct_machines_with_downtime"
      expr: COUNT(DISTINCT machine_code)
      comment: "Number of distinct machines that experienced downtime events. Measures breadth of reliability issues across the asset fleet for maintenance resource allocation."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_capacity_requirement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Capacity planning KPIs for work center load analysis, bottleneck identification, and MRP II capacity leveling. Covers required vs. available capacity, overload hours, load percentage, and setup/processing time breakdown. Used by production planners, plant managers, and supply chain VPs to steer capacity investment and scheduling decisions."
  source: "`manufacturing_ecm`.`production`.`capacity_requirement`"
  filter: status IN ('Active', 'Overloaded', 'Leveled')
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code for the manufacturing facility. Enables multi-plant capacity visibility across the enterprise."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center for which capacity is being planned. Core dimension for bottleneck identification and capacity leveling decisions."
    - name: "capacity_category_name"
      expr: capacity_category_name
      comment: "Human-readable capacity category (Machine, Labor, Tool). Enables segmentation of capacity analysis by resource type."
    - name: "planning_period_start_date"
      expr: planning_period_start_date
      comment: "Start date of the planning period. Enables time-series capacity load trend analysis across planning horizons."
    - name: "planning_horizon_type"
      expr: planning_horizon_type
      comment: "Granularity of the planning time bucket (Daily, Weekly, Monthly). Determines resolution of capacity load visibility."
    - name: "shift_code"
      expr: shift_code
      comment: "Production shift for which capacity is planned. Enables shift-level capacity load analysis and scheduling."
    - name: "status"
      expr: status
      comment: "Planning state of the capacity requirement (Active, Leveled, Overloaded, Cancelled, Simulated). Enables filtering for actionable overload conditions."
    - name: "is_overloaded"
      expr: is_overloaded
      comment: "Flag indicating whether the work center is overloaded during the planning period. Triggers capacity leveling actions and what-if scheduling scenarios."
    - name: "leveling_action"
      expr: leveling_action
      comment: "Action taken to resolve overload (Rescheduled, Split, Outsourced, Overtime, Deferred). Supports audit trail of capacity leveling decisions."
    - name: "capacity_version"
      expr: capacity_version
      comment: "SAP planning version identifier. Enables what-if scenario management and simulation-based capacity planning comparison."
    - name: "mrp_run_date"
      expr: mrp_run_date
      comment: "Date of the MRP II planning run that generated this requirement. Enables comparison of capacity plans across successive MRP runs."
  measures:
    - name: "total_required_capacity_hours"
      expr: SUM(CAST(required_capacity_hours AS DOUBLE))
      comment: "Total capacity hours required at work centers during the planning period. Core metric for capacity load analysis and bottleneck identification."
    - name: "total_available_capacity_hours"
      expr: SUM(CAST(available_capacity_hours AS DOUBLE))
      comment: "Total capacity hours available at work centers during the planning period. Denominator for load percentage and capacity utilization calculations."
    - name: "total_overload_hours"
      expr: SUM(CAST(overload_hours AS DOUBLE))
      comment: "Total hours by which required capacity exceeds available capacity. Quantifies severity of overload conditions for prioritization and leveling decisions."
    - name: "total_remaining_capacity_hours"
      expr: SUM(CAST(remaining_capacity_hours AS DOUBLE))
      comment: "Total residual available capacity hours after subtracting required from available. Negative values indicate overload conditions requiring immediate action."
    - name: "total_setup_hours"
      expr: SUM(CAST(setup_hours AS DOUBLE))
      comment: "Total capacity hours attributable to setup/changeover activities. Supports SMED analysis and setup time reduction initiatives to free capacity."
    - name: "total_processing_hours"
      expr: SUM(CAST(processing_hours AS DOUBLE))
      comment: "Total capacity hours attributable to actual production/processing activities. Distinguishes value-adding time from setup and teardown for capacity optimization."
    - name: "total_production_order_hours"
      expr: SUM(CAST(production_order_hours AS DOUBLE))
      comment: "Capacity hours from firm production orders. Represents committed capacity load for reliable short-term scheduling decisions."
    - name: "total_planned_order_hours"
      expr: SUM(CAST(planned_order_hours AS DOUBLE))
      comment: "Capacity hours from MRP-generated planned orders not yet converted. Distinguishes firm demand from tentative demand for capacity analysis."
    - name: "overloaded_work_center_count"
      expr: COUNT(DISTINCT CASE WHEN is_overloaded = TRUE THEN work_center_code END)
      comment: "Number of distinct work centers in overload condition. Measures breadth of capacity bottlenecks for escalation and investment prioritization."
    - name: "avg_load_percentage"
      expr: ROUND(SUM(CAST(required_capacity_hours AS DOUBLE)) / NULLIF(SUM(CAST(available_capacity_hours AS DOUBLE)), 0) * 100.0, 2)
      comment: "Average capacity load percentage across work centers and planning periods. Key bottleneck indicator for capacity leveling and scheduling decisions."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_shop_order_operation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Shop floor execution KPIs at the operation level for OEE performance rate, cycle time efficiency, first-pass yield, and downtime analysis. Used by production supervisors, plant managers, and operations VPs to steer shop floor performance, identify bottlenecks, and drive lean manufacturing improvements."
  source: "`manufacturing_ecm`.`production`.`shop_order_operation`"
  filter: status IN ('completed', 'partially_confirmed')
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the operation was executed. Enables multi-plant shop floor performance benchmarking."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where the operation was executed. Core dimension for capacity utilization, OEE, and bottleneck analysis."
    - name: "operation_type"
      expr: operation_type
      comment: "Classification of the operation by functional role (processing, setup, inspection, rework). Enables lean analysis of value-adding vs. non-value-adding time."
    - name: "material_number"
      expr: material_number
      comment: "SAP material number of the product being produced. Enables product-level OEE, yield, and scrap analysis."
    - name: "shift_code"
      expr: shift_code
      comment: "Production shift during which the operation was executed. Enables shift-level OEE analysis and labor cost allocation."
    - name: "production_strategy"
      expr: production_strategy
      comment: "Manufacturing strategy (MTO, MTS, ETO, ATO) under which the operation was executed. Drives scheduling priority and cost allocation analysis."
    - name: "downtime_reason_code"
      expr: downtime_reason_code
      comment: "Coded classification of the primary downtime cause during the operation. Used for Pareto analysis of downtime losses and TPM improvement programs."
    - name: "nc_flag"
      expr: nc_flag
      comment: "Indicates whether a non-conformance was detected during the operation. Key quality gate indicator for NCR creation and hold management."
    - name: "spc_violation_flag"
      expr: spc_violation_flag
      comment: "Indicates whether an SPC control chart violation was detected. Triggers quality alert and potential hold in the MES quality module."
    - name: "status"
      expr: status
      comment: "Current execution status of the shop order operation. Drives WIP tracking and production scheduling visibility."
  measures:
    - name: "total_yield_quantity"
      expr: SUM(CAST(yield_quantity AS DOUBLE))
      comment: "Total quantity of conforming good units produced across all operations. Core throughput metric for OEE quality rate and first-pass yield calculations."
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity of units scrapped during operations. Feeds OEE quality rate calculation and scrap cost reporting."
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total quantity of units requiring rework. Feeds cost-of-poor-quality reporting and CAPA initiation decisions."
    - name: "total_actual_run_time_min"
      expr: SUM(CAST(actual_run_time_min AS DOUBLE))
      comment: "Total actual machine run time in minutes across all operations. Core input for OEE performance rate calculation and cycle time variance analysis."
    - name: "total_standard_run_time_min"
      expr: SUM(CAST(standard_run_time_min AS DOUBLE))
      comment: "Total standard (planned) run time in minutes across all operations. Denominator for OEE performance rate and efficiency variance analysis."
    - name: "total_actual_setup_time_min"
      expr: SUM(CAST(actual_setup_time_min AS DOUBLE))
      comment: "Total actual setup time in minutes. Key input for SMED analysis, changeover optimization, and OEE availability loss calculation."
    - name: "total_downtime_min"
      expr: SUM(CAST(downtime_min AS DOUBLE))
      comment: "Total unplanned downtime in minutes recorded during operations. Core input for OEE availability rate calculation and downtime root cause analysis."
    - name: "operation_count"
      expr: COUNT(1)
      comment: "Total number of shop order operations executed. Baseline volume metric for shop floor activity and throughput analysis."
    - name: "nc_operation_count"
      expr: COUNT(CASE WHEN nc_flag = TRUE THEN 1 END)
      comment: "Number of operations where a non-conformance was detected. Measures quality gate failure rate and NCR generation frequency."
    - name: "spc_violation_count"
      expr: COUNT(CASE WHEN spc_violation_flag = TRUE THEN 1 END)
      comment: "Number of operations with SPC control chart violations. Measures process stability and drives statistical process control interventions."
    - name: "oee_performance_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(standard_run_time_min AS DOUBLE)) / NULLIF(SUM(CAST(actual_run_time_min AS DOUBLE)), 0), 2)
      comment: "OEE Performance Rate: ratio of standard run time to actual run time expressed as a percentage. Measures how efficiently the work center runs when operating, excluding downtime and quality losses."
    - name: "first_pass_yield_pct"
      expr: ROUND(100.0 * SUM(CAST(yield_quantity AS DOUBLE)) / NULLIF(SUM(CAST(yield_quantity AS DOUBLE)) + SUM(CAST(scrap_quantity AS DOUBLE)) + SUM(CAST(rework_quantity AS DOUBLE)), 0), 2)
      comment: "First-pass yield at the operation level: percentage of gross output that is good on the first pass. Premier quality KPI for lean and Six Sigma programs at the operation level."
    - name: "avg_cycle_time_sec"
      expr: ROUND(AVG(CAST(cycle_time_sec AS DOUBLE)), 2)
      comment: "Average actual cycle time in seconds per operation execution. Compared against takt time to identify bottlenecks and balance production lines."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_order_status`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Production order lifecycle and SLA performance KPIs. Covers order lead time, SLA breach rate, schedule adherence, scrap rate by order, and status dwell time analysis. Used by production planners, plant managers, and supply chain VPs to steer on-time delivery performance, identify bottlenecks in the order lifecycle, and manage SLA compliance."
  source: "`manufacturing_ecm`.`production`.`order_status`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the production order is being executed. Enables multi-plant order performance benchmarking."
    - name: "material_number"
      expr: material_number
      comment: "SAP material number of the product being manufactured. Enables product-level lead time and quality analysis."
    - name: "from_status"
      expr: from_status
      comment: "Production order status before the transition. Enables analysis of dwell time in each lifecycle state."
    - name: "to_status"
      expr: to_status
      comment: "Production order status after the transition. Enables funnel analysis of order progression through the lifecycle."
    - name: "trigger_event_type"
      expr: trigger_event_type
      comment: "Business event that caused the status transition (MRP run, manual release, QM hold). Enables root cause analysis of order lifecycle events."
    - name: "status_reason_code"
      expr: status_reason_code
      comment: "Standardized reason code for the status transition. Supports root cause analysis of delays and production performance issues."
    - name: "order_category"
      expr: order_category
      comment: "SAP order category (production, process, rework, inspection). Enables differentiated analysis of standard vs. rework order performance."
    - name: "priority_code"
      expr: priority_code
      comment: "Business priority assigned to the production order. Enables priority-segmented SLA compliance analysis and escalation management."
    - name: "is_sla_breached"
      expr: is_sla_breached
      comment: "Indicates whether the production order exceeded its SLA target duration. Drives escalation workflows and production performance KPI reporting."
    - name: "scheduled_start_date"
      expr: scheduled_start_date
      comment: "Planned start date of the production order. Used for schedule adherence and lead time SLA tracking."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the manufacturing site. Supports multinational regulatory compliance and regional performance reporting."
  measures:
    - name: "total_order_transitions"
      expr: COUNT(1)
      comment: "Total number of production order status transitions. Baseline volume metric for order lifecycle activity and throughput analysis."
    - name: "distinct_production_orders"
      expr: COUNT(DISTINCT production_order_number)
      comment: "Number of distinct production orders with status transitions. Measures the breadth of active order portfolio for capacity and scheduling management."
    - name: "sla_breached_order_count"
      expr: COUNT(DISTINCT CASE WHEN is_sla_breached = TRUE THEN production_order_number END)
      comment: "Number of distinct production orders that breached their SLA target duration. Critical KPI for on-time delivery performance and customer commitment management."
    - name: "total_status_dwell_time_minutes"
      expr: SUM(CAST(duration_minutes AS DOUBLE))
      comment: "Total time in minutes that production orders spent in each status before transitioning. Enables dwell time analysis and bottleneck identification in the order lifecycle."
    - name: "avg_status_dwell_time_minutes"
      expr: ROUND(SUM(CAST(duration_minutes AS DOUBLE)) / NULLIF(COUNT(1), 0), 2)
      comment: "Average dwell time per status transition in minutes. Identifies lifecycle stages where orders are stuck, driving process improvement and SLA management."
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total cumulative confirmed quantity across all order status snapshots. Enables partial completion tracking and throughput analysis by order lifecycle stage."
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total scrap quantity declared across production order status transitions. Enables scrap rate analysis by order lifecycle stage and production strategy."
    - name: "sla_breach_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_sla_breached = TRUE THEN production_order_number END) / NULLIF(COUNT(DISTINCT production_order_number), 0), 2)
      comment: "Percentage of production orders that breached their SLA target. Premier on-time delivery KPI for steering customer commitment performance and identifying systemic scheduling issues."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_material_staging`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Material availability and shop floor staging KPIs for JIT performance, material shortage management, and WIP costing. Covers staging fulfillment rate, shortage quantities, issued cost, and staging lead time. Used by production planners, warehouse managers, and supply chain VPs to steer material availability, JIT replenishment effectiveness, and production readiness."
  source: "`manufacturing_ecm`.`production`.`material_staging`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where material staging takes place. Enables multi-plant material availability benchmarking."
    - name: "staging_status"
      expr: staging_status
      comment: "Current lifecycle status of the staging record (planned, staged, issued, short, partially_issued, reversed, cancelled). Enables funnel analysis of material flow to the shop floor."
    - name: "production_strategy"
      expr: production_strategy
      comment: "Manufacturing strategy (MTO, MTS, ETO, ATO) under which the production order was created. Determines material planning and staging behavior."
    - name: "replenishment_strategy"
      expr: replenishment_strategy
      comment: "Material replenishment strategy (JIT, Kanban, MRP, manual, consignment). Enables JIT vs. push replenishment performance comparison."
    - name: "shortage_indicator"
      expr: shortage_indicator
      comment: "Boolean flag indicating whether a material shortage exists for this staging record. Drives shortage alerts and expediting actions."
    - name: "movement_type"
      expr: movement_type
      comment: "SAP inventory movement type code (261 GI to Production Order, 262 Reversal, 311 Transfer). Enables analysis of goods issue vs. reversal activity."
    - name: "planned_staging_date"
      expr: planned_staging_date
      comment: "Planned date for material staging. Enables staging lead time analysis and JIT performance measurement."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the manufacturing plant. Supports multinational regulatory compliance and regional reporting."
    - name: "hazardous_material_indicator"
      expr: hazardous_material_indicator
      comment: "Indicates whether the staged material is hazardous. Triggers additional handling protocols and safety compliance tracking."
  measures:
    - name: "total_required_quantity"
      expr: SUM(CAST(required_quantity AS DOUBLE))
      comment: "Total planned quantity of material required for production orders. Represents total material demand before actual issuance for shortage analysis."
    - name: "total_issued_quantity"
      expr: SUM(CAST(issued_quantity AS DOUBLE))
      comment: "Total quantity of material formally issued to production orders via goods issue posting. Represents confirmed material consumption for WIP costing."
    - name: "total_staged_quantity"
      expr: SUM(CAST(staged_quantity AS DOUBLE))
      comment: "Total quantity physically moved to staging areas but not yet formally issued. Measures intermediate staging pipeline for JIT and Kanban workflow analysis."
    - name: "total_short_quantity"
      expr: SUM(CAST(short_quantity AS DOUBLE))
      comment: "Total quantity of material that could not be staged or issued due to insufficient stock. Quantifies material shortage impact on production readiness."
    - name: "total_issued_cost"
      expr: SUM(CAST(total_issued_cost AS DOUBLE))
      comment: "Total cost of issued material quantities. Feeds WIP costing, production order actual cost, and COGS reporting."
    - name: "staging_record_count"
      expr: COUNT(1)
      comment: "Total number of material staging records. Baseline volume metric for staging activity and material flow analysis."
    - name: "shortage_record_count"
      expr: COUNT(CASE WHEN shortage_indicator = TRUE THEN 1 END)
      comment: "Number of staging records with material shortages. Measures frequency of material availability failures impacting production readiness."
    - name: "material_fulfillment_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(issued_quantity AS DOUBLE)) / NULLIF(SUM(CAST(required_quantity AS DOUBLE)), 0), 2)
      comment: "Material fulfillment rate: percentage of required quantity actually issued to production. Premier JIT and material availability KPI for production readiness management."
    - name: "shortage_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN shortage_indicator = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of staging records with material shortages. Measures systemic material availability risk and drives expediting and procurement escalation decisions."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_planned_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "MRP II planned order KPIs for production planning effectiveness, conversion rate, and planning horizon coverage. Covers planned order volume, conversion to production orders, firmed order ratio, and planned cost. Used by production planners, supply chain VPs, and operations directors to steer MRP planning quality, capacity commitment, and demand fulfillment readiness."
  source: "`manufacturing_ecm`.`production`.`planned_order`"
  filter: status != 'deleted'
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the planned order is to be executed. Enables multi-plant production planning visibility."
    - name: "material_number"
      expr: material_number
      comment: "SAP material number of the product to be produced. Enables material-level planning coverage and conversion analysis."
    - name: "production_strategy"
      expr: production_strategy
      comment: "Manufacturing strategy (MTO, MTS, ETO, ATO) governing the planned order. Determines demand traceability and inventory posting behavior."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the planned order (created, firmed, converted, partially_converted). Enables funnel analysis of planning-to-execution conversion."
    - name: "is_firmed"
      expr: is_firmed
      comment: "Indicates whether the planned order has been manually firmed by a planner. Distinguishes committed production plan from MRP-generated tentative demand."
    - name: "is_converted"
      expr: is_converted
      comment: "Indicates whether the planned order has been converted to a production order. Measures planning-to-execution conversion completeness."
    - name: "demand_source_type"
      expr: demand_source_type
      comment: "Classification of the originating demand element (sales order, forecast, dependent demand). Supports demand traceability and planning analysis."
    - name: "scheduled_start_date"
      expr: scheduled_start_date
      comment: "Planned start date for production. Enables time-horizon analysis of planned order coverage and scheduling lead time."
    - name: "mrp_run_date"
      expr: mrp_run_date
      comment: "Date of the MRP run that generated the planned order. Enables traceability of planned orders back to specific planning cycles."
    - name: "exception_message_code"
      expr: exception_message_code
      comment: "SAP MRP exception message code indicating planning anomalies requiring planner attention. Drives the MRP exception monitor workflow."
  measures:
    - name: "planned_order_count"
      expr: COUNT(1)
      comment: "Total number of planned orders generated by MRP. Baseline volume metric for planning activity and MRP output analysis."
    - name: "firmed_order_count"
      expr: COUNT(CASE WHEN is_firmed = TRUE THEN 1 END)
      comment: "Number of manually firmed planned orders. Measures the proportion of the production plan that is committed and protected from MRP rescheduling."
    - name: "converted_order_count"
      expr: COUNT(CASE WHEN is_converted = TRUE THEN 1 END)
      comment: "Number of planned orders converted to production orders or purchase requisitions. Measures planning-to-execution conversion completeness."
    - name: "total_planned_cost"
      expr: SUM(CAST(planned_cost AS DOUBLE))
      comment: "Total estimated production cost across all planned orders. Used for cost planning, COGS forecasting, and budget variance analysis."
    - name: "avg_in_house_production_days"
      expr: ROUND(AVG(CAST(in_house_production_days AS DOUBLE)), 2)
      comment: "Average planned in-house production lead time in days. Used for MRP scheduling quality assessment and ATP/CTP commitment accuracy analysis."
    - name: "conversion_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_converted = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of planned orders converted to production orders. Measures planning execution effectiveness and MRP-to-shop-floor conversion efficiency."
    - name: "firmed_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_firmed = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of planned orders that have been manually firmed. Measures production plan stability and planner commitment to the MRP output."
    - name: "exception_order_count"
      expr: COUNT(CASE WHEN exception_message_code IS NOT NULL THEN 1 END)
      comment: "Number of planned orders with MRP exception messages requiring planner attention. Measures planning quality and the workload of exception-driven replanning activities."
$$;