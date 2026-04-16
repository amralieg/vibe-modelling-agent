-- Metric views for domain: production | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_production_confirmation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Production confirmation metrics tracking actual output, labor efficiency, and quality performance at the operation level"
  source: "`manufacturing_ecm`.`production`.`production_confirmation`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where production was confirmed"
    - name: "material_number"
      expr: material_number
      comment: "Material produced"
    - name: "production_order_number"
      expr: production_order_number
      comment: "Production order number"
    - name: "shift"
      expr: shift
      comment: "Shift during which production occurred"
    - name: "posting_date"
      expr: posting_date
      comment: "Date when production was posted"
    - name: "is_final_confirmation"
      expr: is_final_confirmation
      comment: "Whether this is the final confirmation for the order"
    - name: "production_strategy"
      expr: production_strategy
      comment: "Production strategy used"
  measures:
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed across all production confirmations"
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total scrap quantity reported"
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total rework quantity reported"
    - name: "total_actual_labor_time_hours"
      expr: SUM(CAST(actual_labor_time_min AS DOUBLE)) / 60.0
      comment: "Total actual labor time in hours"
    - name: "total_actual_machine_time_hours"
      expr: SUM(CAST(actual_machine_time_min AS DOUBLE)) / 60.0
      comment: "Total actual machine time in hours"
    - name: "total_actual_setup_time_hours"
      expr: SUM(CAST(actual_setup_time_min AS DOUBLE)) / 60.0
      comment: "Total actual setup time in hours"
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_cost_amount AS DOUBLE))
      comment: "Total actual cost of production confirmations"
    - name: "first_pass_yield_pct"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE) - CAST(scrap_quantity AS DOUBLE) - CAST(rework_quantity AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 2)
      comment: "First pass yield percentage (good quantity / total confirmed quantity)"
    - name: "scrap_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(scrap_quantity AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 2)
      comment: "Scrap rate as percentage of total confirmed quantity"
    - name: "rework_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(rework_quantity AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 2)
      comment: "Rework rate as percentage of total confirmed quantity"
    - name: "avg_labor_time_per_unit_minutes"
      expr: ROUND(SUM(CAST(actual_labor_time_min AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 2)
      comment: "Average labor time per unit produced in minutes"
    - name: "avg_machine_time_per_unit_minutes"
      expr: ROUND(SUM(CAST(actual_machine_time_min AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 2)
      comment: "Average machine time per unit produced in minutes"
    - name: "avg_cost_per_unit"
      expr: ROUND(SUM(CAST(actual_cost_amount AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 2)
      comment: "Average actual cost per unit produced"
    - name: "confirmation_count"
      expr: COUNT(1)
      comment: "Number of production confirmations"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_downtime_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Downtime event metrics tracking equipment availability, downtime reasons, and production losses"
  source: "`manufacturing_ecm`.`production`.`downtime_event`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where downtime occurred"
    - name: "machine_code"
      expr: machine_code
      comment: "Machine identifier"
    - name: "reason_code"
      expr: reason_code
      comment: "Downtime reason code"
    - name: "category"
      expr: category
      comment: "Downtime category"
    - name: "is_planned"
      expr: is_planned
      comment: "Whether downtime was planned"
    - name: "oee_impact_category"
      expr: oee_impact_category
      comment: "OEE impact category (availability, performance, quality)"
    - name: "shift_code"
      expr: shift_code
      comment: "Shift during which downtime occurred"
    - name: "status"
      expr: status
      comment: "Downtime event status"
  measures:
    - name: "total_downtime_hours"
      expr: SUM(CAST(duration_minutes AS DOUBLE)) / 60.0
      comment: "Total downtime in hours"
    - name: "total_lost_production_quantity"
      expr: SUM(CAST(lost_production_quantity AS DOUBLE))
      comment: "Total production quantity lost due to downtime"
    - name: "avg_downtime_duration_minutes"
      expr: AVG(CAST(duration_minutes AS DOUBLE))
      comment: "Average downtime duration per event in minutes"
    - name: "downtime_event_count"
      expr: COUNT(1)
      comment: "Number of downtime events"
    - name: "mtbf_hours"
      expr: ROUND(SUM(CAST(duration_minutes AS DOUBLE)) / NULLIF(COUNT(1), 0) / 60.0, 2)
      comment: "Mean time between failures in hours (proxy using avg downtime duration)"
    - name: "unplanned_downtime_hours"
      expr: SUM(CASE WHEN is_planned = False THEN CAST(duration_minutes AS DOUBLE) ELSE 0 END) / 60.0
      comment: "Total unplanned downtime in hours"
    - name: "planned_downtime_hours"
      expr: SUM(CASE WHEN is_planned = True THEN CAST(duration_minutes AS DOUBLE) ELSE 0 END) / 60.0
      comment: "Total planned downtime in hours"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_oee_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Overall Equipment Effectiveness (OEE) metrics tracking availability, performance, and quality losses"
  source: "`manufacturing_ecm`.`production`.`oee_event`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center identifier"
    - name: "material_number"
      expr: material_number
      comment: "Material being produced"
    - name: "production_order_number"
      expr: production_order_number
      comment: "Production order number"
    - name: "shift_code"
      expr: shift_code
      comment: "Shift identifier"
    - name: "shift_date"
      expr: shift_date
      comment: "Date of the shift"
    - name: "event_type"
      expr: event_type
      comment: "Type of OEE event (production, downtime, changeover)"
    - name: "loss_category"
      expr: loss_category
      comment: "OEE loss category (availability, performance, quality)"
    - name: "downtime_type"
      expr: downtime_type
      comment: "Type of downtime"
  measures:
    - name: "total_actual_quantity"
      expr: SUM(CAST(actual_quantity AS DOUBLE))
      comment: "Total actual quantity produced"
    - name: "total_good_quantity"
      expr: SUM(CAST(good_quantity AS DOUBLE))
      comment: "Total good quantity (no defects)"
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total scrap quantity"
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total rework quantity"
    - name: "total_planned_quantity"
      expr: SUM(CAST(planned_quantity AS DOUBLE))
      comment: "Total planned quantity"
    - name: "total_duration_hours"
      expr: SUM(CAST(duration_minutes AS DOUBLE)) / 60.0
      comment: "Total event duration in hours"
    - name: "quality_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(good_quantity AS DOUBLE)) / NULLIF(SUM(CAST(actual_quantity AS DOUBLE)), 0), 2)
      comment: "Quality rate percentage (good quantity / actual quantity)"
    - name: "performance_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_quantity AS DOUBLE)) / NULLIF(SUM(CAST(planned_quantity AS DOUBLE)), 0), 2)
      comment: "Performance rate percentage (actual / planned quantity)"
    - name: "avg_actual_production_rate"
      expr: AVG(CAST(actual_production_rate AS DOUBLE))
      comment: "Average actual production rate"
    - name: "avg_planned_production_rate"
      expr: AVG(CAST(planned_production_rate AS DOUBLE))
      comment: "Average planned production rate"
    - name: "oee_event_count"
      expr: COUNT(1)
      comment: "Number of OEE events"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_scrap_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Scrap metrics tracking waste, quality issues, and associated costs by reason and location"
  source: "`manufacturing_ecm`.`production`.`scrap_record`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where scrap occurred"
    - name: "material_number"
      expr: material_number
      comment: "Material scrapped"
    - name: "scrap_reason_code"
      expr: scrap_reason_code
      comment: "Reason code for scrap"
    - name: "scrap_category"
      expr: scrap_category
      comment: "Scrap category"
    - name: "defect_code"
      expr: defect_code
      comment: "Defect code associated with scrap"
    - name: "production_order_number"
      expr: production_order_number
      comment: "Production order number"
    - name: "operation_number"
      expr: operation_number
      comment: "Operation where scrap occurred"
    - name: "is_rework"
      expr: is_rework
      comment: "Whether scrap is from rework"
    - name: "hazardous_material_flag"
      expr: hazardous_material_flag
      comment: "Whether scrapped material is hazardous"
    - name: "posting_date"
      expr: posting_date
      comment: "Date when scrap was posted"
  measures:
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total scrap quantity"
    - name: "total_scrap_cost"
      expr: SUM(CAST(scrap_cost AS DOUBLE))
      comment: "Total cost of scrapped material"
    - name: "avg_scrap_cost_per_unit"
      expr: ROUND(SUM(CAST(scrap_cost AS DOUBLE)) / NULLIF(SUM(CAST(scrap_quantity AS DOUBLE)), 0), 2)
      comment: "Average scrap cost per unit"
    - name: "scrap_record_count"
      expr: COUNT(1)
      comment: "Number of scrap records"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_changeover`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Changeover metrics tracking setup efficiency, SMED compliance, and availability losses"
  source: "`manufacturing_ecm`.`production`.`changeover`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where changeover occurred"
    - name: "from_material_number"
      expr: from_material_number
      comment: "Material being changed from"
    - name: "to_material_number"
      expr: to_material_number
      comment: "Material being changed to"
    - name: "type"
      expr: type
      comment: "Changeover type"
    - name: "is_planned"
      expr: is_planned
      comment: "Whether changeover was planned"
    - name: "is_smed_compliant"
      expr: is_smed_compliant
      comment: "Whether changeover follows SMED (Single-Minute Exchange of Die) principles"
    - name: "smed_category"
      expr: smed_category
      comment: "SMED category classification"
    - name: "shift_code"
      expr: shift_code
      comment: "Shift during which changeover occurred"
    - name: "status"
      expr: status
      comment: "Changeover status"
  measures:
    - name: "total_changeover_duration_hours"
      expr: SUM(CAST(total_duration_min AS DOUBLE)) / 60.0
      comment: "Total changeover duration in hours"
    - name: "total_internal_time_hours"
      expr: SUM(CAST(internal_time_min AS DOUBLE)) / 60.0
      comment: "Total internal changeover time in hours (machine stopped)"
    - name: "total_external_time_hours"
      expr: SUM(CAST(external_time_min AS DOUBLE)) / 60.0
      comment: "Total external changeover time in hours (machine running)"
    - name: "total_ramp_up_duration_hours"
      expr: SUM(CAST(ramp_up_duration_min AS DOUBLE)) / 60.0
      comment: "Total ramp-up duration in hours"
    - name: "total_oee_availability_loss_hours"
      expr: SUM(CAST(oee_availability_loss_min AS DOUBLE)) / 60.0
      comment: "Total OEE availability loss due to changeover in hours"
    - name: "total_scrap_during_rampup"
      expr: SUM(CAST(scrap_during_rampup_qty AS DOUBLE))
      comment: "Total scrap quantity during ramp-up"
    - name: "avg_changeover_duration_minutes"
      expr: AVG(CAST(total_duration_min AS DOUBLE))
      comment: "Average changeover duration in minutes"
    - name: "avg_duration_variance_minutes"
      expr: AVG(CAST(duration_variance_min AS DOUBLE))
      comment: "Average variance from target changeover duration in minutes"
    - name: "changeover_count"
      expr: COUNT(1)
      comment: "Number of changeover events"
    - name: "smed_compliance_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN is_smed_compliant = True THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of changeovers that are SMED compliant"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_capacity_requirement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Capacity planning metrics tracking utilization, overload, and capacity gaps by work center"
  source: "`manufacturing_ecm`.`production`.`capacity_requirement`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center identifier"
    - name: "capacity_category_code"
      expr: capacity_category_code
      comment: "Capacity category code"
    - name: "planning_period_start_date"
      expr: planning_period_start_date
      comment: "Start date of planning period"
    - name: "planning_period_end_date"
      expr: planning_period_end_date
      comment: "End date of planning period"
    - name: "is_overloaded"
      expr: is_overloaded
      comment: "Whether work center is overloaded"
    - name: "shift_code"
      expr: shift_code
      comment: "Shift identifier"
    - name: "status"
      expr: status
      comment: "Capacity requirement status"
  measures:
    - name: "total_required_capacity_hours"
      expr: SUM(CAST(required_capacity_hours AS DOUBLE))
      comment: "Total required capacity in hours"
    - name: "total_available_capacity_hours"
      expr: SUM(CAST(available_capacity_hours AS DOUBLE))
      comment: "Total available capacity in hours"
    - name: "total_remaining_capacity_hours"
      expr: SUM(CAST(remaining_capacity_hours AS DOUBLE))
      comment: "Total remaining capacity in hours"
    - name: "total_overload_hours"
      expr: SUM(CAST(overload_hours AS DOUBLE))
      comment: "Total overload hours (capacity shortfall)"
    - name: "total_setup_hours"
      expr: SUM(CAST(setup_hours AS DOUBLE))
      comment: "Total setup hours required"
    - name: "total_processing_hours"
      expr: SUM(CAST(processing_hours AS DOUBLE))
      comment: "Total processing hours required"
    - name: "total_teardown_hours"
      expr: SUM(CAST(teardown_hours AS DOUBLE))
      comment: "Total teardown hours required"
    - name: "avg_load_percentage"
      expr: AVG(CAST(load_percentage AS DOUBLE))
      comment: "Average capacity load percentage"
    - name: "avg_utilization_rate"
      expr: AVG(CAST(utilization_rate AS DOUBLE))
      comment: "Average utilization rate"
    - name: "capacity_utilization_pct"
      expr: ROUND(100.0 * SUM(CAST(required_capacity_hours AS DOUBLE)) / NULLIF(SUM(CAST(available_capacity_hours AS DOUBLE)), 0), 2)
      comment: "Capacity utilization percentage (required / available)"
    - name: "capacity_requirement_count"
      expr: COUNT(1)
      comment: "Number of capacity requirement records"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_cost_estimate`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Production cost estimation metrics tracking planned vs actual costs and variances by cost component"
  source: "`manufacturing_ecm`.`production`.`cost_estimate`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "material_number"
      expr: material_number
      comment: "Material being costed"
    - name: "costing_type"
      expr: costing_type
      comment: "Type of costing (standard, actual, planned)"
    - name: "costing_version"
      expr: costing_version
      comment: "Costing version"
    - name: "production_order_number"
      expr: production_order_number
      comment: "Production order number"
    - name: "status"
      expr: status
      comment: "Cost estimate status"
    - name: "variance_category"
      expr: variance_category
      comment: "Cost variance category"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period"
  measures:
    - name: "total_planned_material_cost"
      expr: SUM(CAST(planned_material_cost AS DOUBLE))
      comment: "Total planned material cost"
    - name: "total_planned_labor_cost"
      expr: SUM(CAST(planned_labor_cost AS DOUBLE))
      comment: "Total planned labor cost"
    - name: "total_planned_machine_cost"
      expr: SUM(CAST(planned_machine_cost AS DOUBLE))
      comment: "Total planned machine cost"
    - name: "total_planned_overhead_cost"
      expr: SUM(CAST(planned_overhead_cost AS DOUBLE))
      comment: "Total planned overhead cost"
    - name: "total_planned_subcontracting_cost"
      expr: SUM(CAST(planned_subcontracting_cost AS DOUBLE))
      comment: "Total planned subcontracting cost"
    - name: "total_planned_total_cost"
      expr: SUM(CAST(planned_total_cost AS DOUBLE))
      comment: "Total planned cost (all components)"
    - name: "total_actual_material_cost"
      expr: SUM(CAST(actual_material_cost AS DOUBLE))
      comment: "Total actual material cost"
    - name: "total_actual_labor_cost"
      expr: SUM(CAST(actual_labor_cost AS DOUBLE))
      comment: "Total actual labor cost"
    - name: "total_actual_machine_cost"
      expr: SUM(CAST(actual_machine_cost AS DOUBLE))
      comment: "Total actual machine cost"
    - name: "total_actual_overhead_cost"
      expr: SUM(CAST(actual_overhead_cost AS DOUBLE))
      comment: "Total actual overhead cost"
    - name: "total_actual_total_cost"
      expr: SUM(CAST(actual_total_cost AS DOUBLE))
      comment: "Total actual cost (all components)"
    - name: "total_cost_variance"
      expr: SUM(CAST(cost_variance AS DOUBLE))
      comment: "Total cost variance (actual - planned)"
    - name: "avg_planned_cost_per_unit"
      expr: AVG(CAST(planned_cost_per_unit AS DOUBLE))
      comment: "Average planned cost per unit"
    - name: "cost_variance_pct"
      expr: ROUND(100.0 * SUM(CAST(cost_variance AS DOUBLE)) / NULLIF(SUM(CAST(planned_total_cost AS DOUBLE)), 0), 2)
      comment: "Cost variance percentage (variance / planned cost)"
    - name: "cost_estimate_count"
      expr: COUNT(1)
      comment: "Number of cost estimates"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Production schedule metrics tracking planned vs confirmed quantities, schedule adherence, and capacity loading"
  source: "`manufacturing_ecm`.`production`.`schedule`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center identifier"
    - name: "material_number"
      expr: material_number
      comment: "Material being scheduled"
    - name: "production_strategy"
      expr: production_strategy
      comment: "Production strategy"
    - name: "scheduling_strategy"
      expr: scheduling_strategy
      comment: "Scheduling strategy"
    - name: "status"
      expr: status
      comment: "Schedule status"
    - name: "scheduled_start_date"
      expr: scheduled_start_date
      comment: "Scheduled start date"
    - name: "scheduled_end_date"
      expr: scheduled_end_date
      comment: "Scheduled end date"
    - name: "shift_pattern"
      expr: shift_pattern
      comment: "Shift pattern"
  measures:
    - name: "total_planned_quantity"
      expr: SUM(CAST(planned_quantity AS DOUBLE))
      comment: "Total planned quantity"
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total confirmed quantity"
    - name: "total_planned_cost"
      expr: SUM(CAST(planned_cost AS DOUBLE))
      comment: "Total planned cost"
    - name: "avg_capacity_load_pct"
      expr: AVG(CAST(capacity_load_percent AS DOUBLE))
      comment: "Average capacity load percentage"
    - name: "avg_oee_target_pct"
      expr: AVG(CAST(oee_target_percent AS DOUBLE))
      comment: "Average OEE target percentage"
    - name: "avg_cycle_time_seconds"
      expr: AVG(CAST(cycle_time_seconds AS DOUBLE))
      comment: "Average cycle time in seconds"
    - name: "avg_takt_time_seconds"
      expr: AVG(CAST(takt_time_seconds AS DOUBLE))
      comment: "Average takt time in seconds"
    - name: "schedule_attainment_pct"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE)) / NULLIF(SUM(CAST(planned_quantity AS DOUBLE)), 0), 2)
      comment: "Schedule attainment percentage (confirmed / planned quantity)"
    - name: "schedule_count"
      expr: COUNT(1)
      comment: "Number of schedule records"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_work_center`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Work center master data metrics tracking capacity, efficiency targets, and operational parameters"
  source: "`manufacturing_ecm`.`production`.`work_center`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: code
      comment: "Work center code"
    - name: "work_center_name"
      expr: name
      comment: "Work center name"
    - name: "type"
      expr: type
      comment: "Work center type"
    - name: "category_code"
      expr: category_code
      comment: "Work center category"
    - name: "capacity_category"
      expr: capacity_category
      comment: "Capacity category"
    - name: "production_strategy"
      expr: production_strategy
      comment: "Production strategy"
    - name: "status"
      expr: status
      comment: "Work center status"
  measures:
    - name: "total_capacity_hours_per_day"
      expr: SUM(CAST(capacity_available_hours_per_day AS DOUBLE))
      comment: "Total available capacity hours per day across work centers"
    - name: "total_floor_area_sqm"
      expr: SUM(CAST(floor_area_sqm AS DOUBLE))
      comment: "Total floor area in square meters"
    - name: "avg_efficiency_rate_pct"
      expr: AVG(CAST(efficiency_rate_percent AS DOUBLE))
      comment: "Average efficiency rate percentage"
    - name: "avg_utilization_rate_pct"
      expr: AVG(CAST(utilization_rate_percent AS DOUBLE))
      comment: "Average utilization rate percentage"
    - name: "avg_oee_target_pct"
      expr: AVG(CAST(oee_target_percent AS DOUBLE))
      comment: "Average OEE target percentage"
    - name: "avg_cycle_time_seconds"
      expr: AVG(CAST(cycle_time_seconds AS DOUBLE))
      comment: "Average cycle time in seconds"
    - name: "avg_takt_time_seconds"
      expr: AVG(CAST(takt_time_seconds AS DOUBLE))
      comment: "Average takt time in seconds"
    - name: "avg_setup_time_minutes"
      expr: AVG(CAST(setup_time_minutes AS DOUBLE))
      comment: "Average setup time in minutes"
    - name: "work_center_count"
      expr: COUNT(1)
      comment: "Number of work centers"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_routing`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Routing master data metrics tracking process complexity, lead times, and operation counts"
  source: "`manufacturing_ecm`.`production`.`routing`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "routing_number"
      expr: number
      comment: "Routing number"
    - name: "material_number"
      expr: material_number
      comment: "Material for which routing is defined"
    - name: "type"
      expr: type
      comment: "Routing type"
    - name: "usage"
      expr: usage
      comment: "Routing usage"
    - name: "production_strategy"
      expr: production_strategy
      comment: "Production strategy"
    - name: "status"
      expr: status
      comment: "Routing status"
    - name: "has_alternative_sequences"
      expr: has_alternative_sequences
      comment: "Whether routing has alternative sequences"
    - name: "has_parallel_sequences"
      expr: has_parallel_sequences
      comment: "Whether routing has parallel sequences"
  measures:
    - name: "total_labor_time_hours"
      expr: SUM(CAST(total_labor_time_min AS DOUBLE)) / 60.0
      comment: "Total labor time in hours"
    - name: "total_machine_time_hours"
      expr: SUM(CAST(total_machine_time_min AS DOUBLE)) / 60.0
      comment: "Total machine time in hours"
    - name: "total_setup_time_hours"
      expr: SUM(CAST(total_setup_time_min AS DOUBLE)) / 60.0
      comment: "Total setup time in hours"
    - name: "avg_total_lead_time_days"
      expr: AVG(CAST(total_lead_time_days AS DOUBLE))
      comment: "Average total lead time in days"
    - name: "avg_takt_time_seconds"
      expr: AVG(CAST(takt_time_sec AS DOUBLE))
      comment: "Average takt time in seconds"
    - name: "avg_base_quantity"
      expr: AVG(CAST(base_quantity AS DOUBLE))
      comment: "Average base quantity"
    - name: "routing_count"
      expr: COUNT(1)
      comment: "Number of routings"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_batch`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Batch traceability and quality metrics tracking batch quantities, shelf life, and compliance status"
  source: "`manufacturing_ecm`.`production`.`batch`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "material_number"
      expr: material_number
      comment: "Material number"
    - name: "production_order_number"
      expr: production_order_number
      comment: "Production order number"
    - name: "status"
      expr: status
      comment: "Batch status"
    - name: "origin_type"
      expr: origin_type
      comment: "Batch origin type"
    - name: "hazardous_material_flag"
      expr: hazardous_material_flag
      comment: "Whether batch contains hazardous material"
    - name: "is_restricted_substance_compliant"
      expr: is_restricted_substance_compliant
      comment: "Whether batch is compliant with restricted substance regulations"
    - name: "reach_svhc_flag"
      expr: reach_svhc_flag
      comment: "Whether batch contains REACH SVHC substances"
    - name: "manufacturing_date"
      expr: manufacturing_date
      comment: "Manufacturing date"
    - name: "goods_receipt_date"
      expr: goods_receipt_date
      comment: "Goods receipt date"
  measures:
    - name: "total_batch_quantity"
      expr: SUM(CAST(quantity AS DOUBLE))
      comment: "Total batch quantity"
    - name: "avg_purity_percent"
      expr: AVG(CAST(purity_percent AS DOUBLE))
      comment: "Average purity percentage"
    - name: "avg_tensile_strength_mpa"
      expr: AVG(CAST(tensile_strength_mpa AS DOUBLE))
      comment: "Average tensile strength in MPa"
    - name: "avg_viscosity_mpa_s"
      expr: AVG(CAST(viscosity_mpa_s AS DOUBLE))
      comment: "Average viscosity in mPa·s"
    - name: "batch_count"
      expr: COUNT(1)
      comment: "Number of batches"
    - name: "compliance_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN is_restricted_substance_compliant = True THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of batches that are restricted substance compliant"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`production_hold`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Production hold metrics tracking hold reasons, durations, and financial impact"
  source: "`manufacturing_ecm`.`production`.`hold`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant identifier"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where hold occurred"
    - name: "material_number"
      expr: material_number
      comment: "Material on hold"
    - name: "type"
      expr: type
      comment: "Hold type"
    - name: "reason_code"
      expr: reason_code
      comment: "Hold reason code"
    - name: "status"
      expr: status
      comment: "Hold status"
    - name: "severity_level"
      expr: severity_level
      comment: "Hold severity level"
    - name: "priority"
      expr: priority
      comment: "Hold priority"
    - name: "disposition"
      expr: disposition
      comment: "Hold disposition decision"
    - name: "affected_entity_type"
      expr: affected_entity_type
      comment: "Type of entity affected by hold"
  measures:
    - name: "total_affected_quantity"
      expr: SUM(CAST(affected_quantity AS DOUBLE))
      comment: "Total quantity affected by holds"
    - name: "total_estimated_financial_impact"
      expr: SUM(CAST(estimated_financial_impact AS DOUBLE))
      comment: "Total estimated financial impact of holds"
    - name: "avg_estimated_financial_impact"
      expr: AVG(CAST(estimated_financial_impact AS DOUBLE))
      comment: "Average estimated financial impact per hold"
    - name: "hold_count"
      expr: COUNT(1)
      comment: "Number of hold events"
$$;