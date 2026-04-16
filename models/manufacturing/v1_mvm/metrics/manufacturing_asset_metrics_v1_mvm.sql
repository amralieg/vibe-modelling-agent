-- Metric views for domain: asset | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_asset_notification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Operational KPIs for maintenance notifications covering breakdown frequency, response SLA compliance, notification aging, and maintenance category distribution. Used by maintenance managers and plant directors to steer corrective vs. preventive maintenance balance and prioritize resource allocation."
  source: "`manufacturing_ecm`.`asset`.`asset_notification`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant or Maximo site code where the notified asset is located. Enables plant-level benchmarking of maintenance notification volumes and breakdown rates."
    - name: "notification_type"
      expr: type
      comment: "SAP PM notification type: M1 (Malfunction Report), M2 (Activity Request), M3 (Inspection Request), M4 (General Maintenance Request). Drives downstream work order creation logic."
    - name: "maintenance_category"
      expr: category
      comment: "Maintenance trigger strategy: PREVENTIVE, CORRECTIVE, PREDICTIVE, CONDITION_BASED, EMERGENCY. Core dimension for TPM strategy analytics and maintenance mix reporting."
    - name: "notification_status"
      expr: status
      comment: "Current SAP PM processing status: OSNO, NOPR, ORAS, NOCO, CLSD, CANC. Drives workflow routing and open notification backlog reporting."
    - name: "priority"
      expr: priority
      comment: "Notification urgency level: 1 (Very High/Emergency), 2 (High), 3 (Medium), 4 (Low). Used for resource allocation and SLA compliance segmentation."
    - name: "breakdown_indicator"
      expr: breakdown_indicator
      comment: "Flag indicating whether the notification represents a complete equipment breakdown (True) vs. degraded performance or minor fault (False). Core dimension for breakdown KPI reporting."
    - name: "safety_relevant"
      expr: safety_relevant
      comment: "Flag indicating safety implications for personnel or environment. Used to segment safety-critical notifications for HSE escalation tracking."
    - name: "reported_month"
      expr: DATE_TRUNC('MONTH', reported_timestamp)
      comment: "Month in which the notification was reported. Enables trend analysis of notification volumes and breakdown rates over time."
    - name: "planning_plant"
      expr: planning_plant
      comment: "Plant responsible for planning the maintenance work. May differ from the asset location plant in centralized maintenance organizations."
    - name: "main_work_center"
      expr: main_work_center
      comment: "Primary maintenance work center responsible for executing activities triggered by this notification. Used for workload balancing and capacity planning."
    - name: "damage_code"
      expr: damage_code
      comment: "Standardized damage catalog code identifying the type of physical damage observed. Supports failure pattern analysis and FMEA validation."
    - name: "cause_code"
      expr: cause_code
      comment: "Root cause catalog code for the equipment failure. Supports CAPA processes and reliability engineering root cause analysis."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the plant location. Supports multinational regulatory compliance and regional maintenance benchmarking."
  measures:
    - name: "total_notifications"
      expr: COUNT(1)
      comment: "Total number of maintenance notifications raised. Baseline volume metric for maintenance demand planning and trend analysis."
    - name: "breakdown_notification_count"
      expr: COUNT(CASE WHEN breakdown_indicator = TRUE THEN 1 END)
      comment: "Number of notifications flagged as complete equipment breakdowns (unplanned stoppages). Directly drives OEE availability loss reporting and emergency response KPIs."
    - name: "breakdown_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN breakdown_indicator = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of all notifications that represent full equipment breakdowns. A rising breakdown rate signals deteriorating asset reliability and drives investment in preventive maintenance programs."
    - name: "emergency_notification_count"
      expr: COUNT(CASE WHEN category = 'EMERGENCY' THEN 1 END)
      comment: "Number of emergency-category notifications representing immediate safety or production risk. Executives monitor this to assess plant safety posture and emergency response readiness."
    - name: "safety_relevant_notification_count"
      expr: COUNT(CASE WHEN safety_relevant = TRUE THEN 1 END)
      comment: "Number of notifications with safety implications for personnel, equipment, or environment. Mandatory HSE KPI for ISO 45001 compliance and OSHA incident reporting."
    - name: "avg_malfunction_duration_hours"
      expr: ROUND(AVG(CAST((unix_timestamp(malfunction_end_time) - unix_timestamp(malfunction_start_time)) AS DOUBLE) / 3600.0), 2)
      comment: "Average duration in hours between malfunction start and end timestamps. Proxy for Mean Time To Repair (MTTR) at the notification level. A key OEE and reliability KPI used by plant managers to benchmark repair efficiency."
    - name: "total_malfunction_downtime_hours"
      expr: ROUND(SUM(CAST((unix_timestamp(malfunction_end_time) - unix_timestamp(malfunction_start_time)) AS DOUBLE) / 3600.0), 2)
      comment: "Total equipment downtime hours accumulated across all malfunction notifications. Directly quantifies production availability loss and feeds OEE calculations. A primary CAPEX justification metric for asset replacement decisions."
    - name: "open_notification_count"
      expr: COUNT(CASE WHEN status IN ('OSNO', 'NOPR', 'ORAS') THEN 1 END)
      comment: "Number of notifications currently open and not yet completed or closed. Represents the active maintenance backlog. Executives use this to assess maintenance team capacity and backlog risk."
    - name: "overdue_notification_count"
      expr: COUNT(CASE WHEN required_end_date < CURRENT_DATE AND status NOT IN ('NOCO', 'CLSD', 'CANC') THEN 1 END)
      comment: "Number of notifications where the required end date has passed but the notification is not yet completed or closed. Directly measures SLA breach exposure and escalation risk."
    - name: "sla_breach_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN required_end_date < CURRENT_DATE AND status NOT IN ('NOCO', 'CLSD', 'CANC') THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of notifications that have breached their required completion date SLA. A critical vendor and maintenance team performance KPI used in quarterly business reviews and contract penalty assessments."
    - name: "avg_notification_age_days"
      expr: ROUND(AVG(CAST(datediff(CURRENT_DATE, reported_date) AS DOUBLE)), 2)
      comment: "Average age in days of all notifications from reported date to today. Measures maintenance backlog aging. Aging backlogs signal resource constraints or prioritization failures that leadership must address."
    - name: "work_order_conversion_count"
      expr: COUNT(CASE WHEN work_order_number IS NOT NULL THEN 1 END)
      comment: "Number of notifications that have been converted to a work order. Measures the effectiveness of the notification-to-execution pipeline. Low conversion rates indicate planning bottlenecks."
    - name: "work_order_conversion_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN work_order_number IS NOT NULL THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of notifications that have been converted to a maintenance work order. A low rate indicates notification processing bottlenecks or resource constraints that impair maintenance execution."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_asset_valuation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Financial KPIs for the fixed asset register covering net book value, accumulated depreciation, impairment losses, and asset portfolio health. Used by CFOs, controllers, and asset managers for IFRS/GAAP balance sheet reporting, CAPEX planning, and asset lifecycle investment decisions."
  source: "`manufacturing_ecm`.`asset`.`asset_valuation`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the manufacturing facility where the asset is located. Enables plant-level CAPEX tracking and asset register reporting."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code representing the legal entity owning the asset. Supports multi-entity IFRS/GAAP consolidated reporting."
    - name: "depreciation_method"
      expr: depreciation_method
      comment: "Accounting depreciation method applied (e.g., straight-line, declining balance). Drives depreciation expense forecasting and IFRS/GAAP policy compliance reporting."
    - name: "asset_status"
      expr: status
      comment: "Current lifecycle status of the asset valuation record (e.g., active, fully_depreciated, disposed). Controls financial reporting inclusion and depreciation run eligibility."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal posting period within the fiscal year. Enables period-level depreciation and balance sheet reporting for month-end and year-end close."
    - name: "valuation_date"
      expr: DATE_TRUNC('MONTH', date)
      comment: "Month of the valuation reporting date. Used for trend analysis of net book value and depreciation charges over time."
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "SAP Controlling cost center to which depreciation and asset costs are allocated. Enables OPEX cost allocation to manufacturing departments for internal reporting."
    - name: "controlling_area_code"
      expr: controlling_area_code
      comment: "SAP CO area code grouping company codes for internal cost accounting. Enables cross-company CAPEX/OPEX analysis."
    - name: "acquisition_cost_currency"
      expr: acquisition_cost_currency
      comment: "ISO 4217 transaction currency for acquisition cost. Supports multi-currency asset accounting for multinational operations."
    - name: "asset_under_construction_flag"
      expr: asset_under_construction_flag
      comment: "Indicates whether the asset is classified as Asset Under Construction (AUC). AUC assets are not yet depreciated and require separate CAPEX tracking."
    - name: "capex_project_number"
      expr: capex_project_number
      comment: "SAP PS project number funding the asset acquisition. Links asset valuation to originating CAPEX budget for investment tracking and ROI analysis."
  measures:
    - name: "total_net_book_value"
      expr: SUM(CAST(net_book_value AS DOUBLE))
      comment: "Total carrying amount of all assets on the balance sheet (acquisition cost minus accumulated depreciation and impairment). The primary fixed asset balance sheet KPI for IFRS/GAAP reporting and CAPEX portfolio valuation."
    - name: "total_acquisition_cost"
      expr: SUM(CAST(acquisition_cost AS DOUBLE))
      comment: "Total gross historical acquisition cost of all assets in the portfolio. Represents the total capital invested in manufacturing assets. Used for CAPEX tracking and insurance valuation."
    - name: "total_accumulated_depreciation"
      expr: SUM(CAST(accumulated_depreciation AS DOUBLE))
      comment: "Total cumulative depreciation charged against all assets. Measures the aggregate consumption of asset value over time. Used for balance sheet presentation and asset age assessment."
    - name: "total_current_period_depreciation"
      expr: SUM(CAST(current_period_depreciation AS DOUBLE))
      comment: "Total depreciation expense charged in the current fiscal period. A direct P&L OPEX charge that plant controllers monitor for budget variance and cost center allocation accuracy."
    - name: "total_impairment_loss"
      expr: SUM(CAST(impairment_loss AS DOUBLE))
      comment: "Total impairment losses recognized across the asset portfolio. A critical IAS 36 compliance KPI. Rising impairment signals asset obsolescence or market value decline requiring executive intervention."
    - name: "avg_net_book_value_per_asset"
      expr: ROUND(AVG(CAST(net_book_value AS DOUBLE)), 2)
      comment: "Average net book value per asset valuation record. Provides a portfolio health indicator — a declining average signals aging assets approaching end of useful life and drives replacement CAPEX planning."
    - name: "depreciation_coverage_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(accumulated_depreciation AS DOUBLE)) / NULLIF(SUM(CAST(acquisition_cost AS DOUBLE)), 0), 2)
      comment: "Percentage of total acquisition cost that has been depreciated (accumulated depreciation / acquisition cost). A high rate indicates an aging asset portfolio nearing end of useful life, triggering CAPEX replacement planning discussions at the executive level."
    - name: "total_disposal_proceeds"
      expr: SUM(CAST(disposal_proceeds AS DOUBLE))
      comment: "Total proceeds received from asset disposals. Used to calculate gain/loss on disposal and assess the effectiveness of the asset disposal program in recovering residual value."
    - name: "total_revaluation_amount"
      expr: SUM(CAST(revaluation_amount AS DOUBLE))
      comment: "Net revaluation adjustments applied to the asset portfolio under the IAS 16 revaluation model. Positive values indicate upward revaluation; negative values indicate write-downs. Monitored by CFOs for balance sheet fair value accuracy."
    - name: "assets_under_construction_count"
      expr: COUNT(CASE WHEN asset_under_construction_flag = TRUE THEN 1 END)
      comment: "Number of assets currently classified as Assets Under Construction (AUC). Represents in-progress CAPEX investments not yet generating depreciation. Executives monitor this to track CAPEX deployment velocity."
    - name: "fully_depreciated_asset_count"
      expr: COUNT(CASE WHEN status = 'fully_depreciated' THEN 1 END)
      comment: "Number of assets that have reached full depreciation (net book value at residual value). A high count signals an aging asset base requiring replacement investment decisions."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_calibration_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quality and compliance KPIs for the instrument calibration program covering pass/fail rates, out-of-tolerance frequency, calibration overdue status, and adjustment rates. Used by quality managers and plant directors to ensure ISO 9001 QMS compliance, measurement system integrity, and regulatory audit readiness."
  source: "`manufacturing_ecm`.`asset`.`calibration_record`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the manufacturing facility where the instrument is installed. Supports multi-site calibration program management and plant-level compliance reporting."
    - name: "calibration_result"
      expr: result
      comment: "Overall outcome of the calibration event (pass/fail). Core dimension for calibration compliance rate analysis and QMS non-conformance workflow triggering."
    - name: "calibration_type"
      expr: calibration_type
      comment: "Classification of the calibration event trigger (e.g., scheduled, after-repair, initial). Supports analysis of calibration frequency drivers and QMS audit trails."
    - name: "laboratory_type"
      expr: laboratory_type
      comment: "Internal vs. external accredited/non-accredited laboratory classification. Affects traceability requirements and QMS documentation standards."
    - name: "calibration_status"
      expr: status
      comment: "Current lifecycle status of the calibration record within the QMS workflow. Controls compliance reporting visibility."
    - name: "adjustment_made"
      expr: adjustment_made_flag
      comment: "Whether a physical adjustment was made during calibration. When true, prior measurement impact assessment may be required, triggering CAPA workflows."
    - name: "calibration_month"
      expr: DATE_TRUNC('MONTH', calibration_date)
      comment: "Month in which the calibration was performed. Enables trend analysis of calibration volumes, pass rates, and overdue patterns over time."
    - name: "laboratory_name"
      expr: laboratory_name
      comment: "Name of the laboratory performing the calibration. Enables supplier performance analysis for external calibration service providers."
    - name: "manufacturer"
      expr: manufacturer
      comment: "Instrument manufacturer. Used for warranty tracking and manufacturer-specific calibration procedure compliance analysis."
  measures:
    - name: "total_calibrations"
      expr: COUNT(1)
      comment: "Total number of calibration events performed. Baseline volume metric for calibration program workload and resource planning."
    - name: "calibration_pass_count"
      expr: COUNT(CASE WHEN result = 'pass' THEN 1 END)
      comment: "Number of calibration events where the instrument met required accuracy specifications. Used to assess overall measurement system health."
    - name: "calibration_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN result = 'pass' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibrations resulting in a pass outcome. A declining pass rate signals systemic instrument degradation or inadequate calibration intervals, requiring quality management intervention."
    - name: "out_of_tolerance_count"
      expr: COUNT(CASE WHEN result = 'fail' THEN 1 END)
      comment: "Number of calibrations where the instrument was found out of tolerance. Each out-of-tolerance finding may require CAPA initiation and product quality impact assessment per ISO 9001."
    - name: "out_of_tolerance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN result = 'fail' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibrations resulting in an out-of-tolerance finding. A critical QMS KPI — high rates indicate measurement system failures that may have compromised product quality and require executive escalation."
    - name: "adjustment_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN adjustment_made_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibrations requiring a physical instrument adjustment. High adjustment rates indicate instruments drifting out of specification, signaling the need to shorten calibration intervals or replace instruments."
    - name: "overdue_calibration_count"
      expr: COUNT(CASE WHEN next_due_date < CURRENT_DATE AND status NOT IN ('cancelled', 'superseded') THEN 1 END)
      comment: "Number of instruments with a past-due calibration date. Overdue calibrations represent direct ISO 9001 compliance violations and audit findings. Executives use this to assess QMS compliance risk."
    - name: "capa_triggered_count"
      expr: COUNT(CASE WHEN capa_reference_number IS NOT NULL THEN 1 END)
      comment: "Number of calibration events that triggered a CAPA (Corrective and Preventive Action). Measures the downstream quality impact of out-of-tolerance findings and the responsiveness of the quality management system."
    - name: "avg_measurement_uncertainty"
      expr: ROUND(AVG(CAST(measurement_uncertainty AS DOUBLE)), 6)
      comment: "Average expanded measurement uncertainty across calibration events. A lower value indicates higher measurement precision. Used by metrology teams to assess whether instruments meet ISO/IEC 17025 uncertainty requirements for product acceptance decisions."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_maintenance_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for the preventive maintenance program covering plan coverage, scheduling compliance, cost budgeting, and regulatory adherence. Used by maintenance directors and plant managers to steer TPM program effectiveness, ensure regulatory compliance, and optimize maintenance OPEX spend."
  source: "`manufacturing_ecm`.`asset`.`maintenance_plan`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant or Maximo site code where the assets covered by this plan are located. Enables plant-level TPM program performance benchmarking."
    - name: "plan_category"
      expr: plan_category
      comment: "TPM discipline category: preventive, predictive, lubrication, calibration, regulatory inspection, major overhaul. Core dimension for maintenance strategy mix analysis."
    - name: "strategy_type"
      expr: strategy_type
      comment: "Maintenance strategy type: time-based, counter-based, condition-based, predictive. Drives scheduling logic and IIoT integration analysis."
    - name: "plan_status"
      expr: status
      comment: "Current lifecycle status of the maintenance plan (drafting, active, suspended, retired). Controls whether the plan is actively generating work orders."
    - name: "regulatory_requirement"
      expr: regulatory_requirement
      comment: "Whether the plan is mandated by a regulatory body (OSHA, EPA, ISO 45001). Regulatory plans receive elevated priority and mandatory completion tracking."
    - name: "safety_critical"
      expr: safety_critical
      comment: "Whether the plan covers safety-critical equipment. Triggers mandatory completion tracking under ISO 45001 and drives HSE compliance reporting."
    - name: "maintenance_type"
      expr: maintenance_type
      comment: "Operational classification: planned scheduled vs. emergency or shutdown-based maintenance. Used for maintenance mix and schedule adherence analysis."
    - name: "equipment_category"
      expr: equipment_category
      comment: "Equipment type covered by the plan (e.g., CNC machines, PLC systems, SCADA infrastructure). Enables asset-class-level maintenance program analysis."
    - name: "planner_group"
      expr: planner_group
      comment: "SAP PM planner group responsible for managing and scheduling this plan. Used for workload distribution and planning accountability reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO 4217 currency code for plan cost values. Supports multinational cost consolidation."
  measures:
    - name: "total_maintenance_plans"
      expr: COUNT(1)
      comment: "Total number of maintenance plans in the portfolio. Baseline metric for TPM program scope and coverage assessment."
    - name: "active_plan_count"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Number of maintenance plans currently active and generating work orders. Measures the operational footprint of the preventive maintenance program."
    - name: "regulatory_plan_count"
      expr: COUNT(CASE WHEN regulatory_requirement = TRUE THEN 1 END)
      comment: "Number of maintenance plans mandated by regulatory requirements. Executives monitor this to understand compliance obligations and associated mandatory OPEX spend."
    - name: "overdue_plan_count"
      expr: COUNT(CASE WHEN next_due_date < CURRENT_DATE AND status = 'active' THEN 1 END)
      comment: "Number of active maintenance plans where the next due date has passed without completion. Directly measures preventive maintenance schedule compliance failure — a leading indicator of asset reliability risk."
    - name: "pm_schedule_compliance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN next_due_date >= CURRENT_DATE AND status = 'active' THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'active' THEN 1 END), 0), 2)
      comment: "Percentage of active maintenance plans that are on schedule (next due date not yet passed). A core TPM KPI — low compliance rates signal resource constraints or scheduling failures that increase unplanned breakdown risk."
    - name: "total_estimated_maintenance_cost"
      expr: SUM(CAST(estimated_cost AS DOUBLE))
      comment: "Total planned OPEX cost across all maintenance plans for one execution cycle. Used for annual maintenance budget planning and CAPEX vs. OPEX classification at the portfolio level."
    - name: "avg_estimated_cost_per_plan"
      expr: ROUND(AVG(CAST(estimated_cost AS DOUBLE)), 2)
      comment: "Average planned cost per maintenance plan execution cycle. Benchmarks maintenance cost efficiency across plant sites and equipment categories."
    - name: "total_estimated_duration_hours"
      expr: SUM(CAST(estimated_duration_hours AS DOUBLE))
      comment: "Total planned maintenance hours across all plans. Quantifies the maintenance labor demand for capacity planning and downtime scheduling impact assessment."
    - name: "safety_critical_plan_count"
      expr: COUNT(CASE WHEN safety_critical = TRUE THEN 1 END)
      comment: "Number of maintenance plans covering safety-critical equipment. Executives monitor this to ensure mandatory safety maintenance obligations are resourced and tracked under ISO 45001."
    - name: "avg_cycle_value"
      expr: ROUND(AVG(CAST(cycle_value AS DOUBLE)), 2)
      comment: "Average maintenance cycle interval value across plans. Used to assess whether maintenance frequencies are aligned with OEM recommendations and asset criticality ratings."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_measurement_reading`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IIoT and condition monitoring KPIs for equipment measurement readings covering threshold breach rates, reading quality, sensor coverage, and condition-based maintenance trigger frequency. Used by reliability engineers and plant managers to steer predictive maintenance programs and assess IIoT sensor network health."
  source: "`manufacturing_ecm`.`asset`.`measurement_reading`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code or facility identifier where the asset and measurement point are located. Supports multi-site OEE and condition monitoring analytics."
    - name: "reading_type"
      expr: reading_type
      comment: "Classification of the reading: continuous measurement, counter, or characteristic. Drives downstream processing logic for condition-based maintenance."
    - name: "reading_source"
      expr: reading_source
      comment: "Origin of the reading: manual inspection, IIoT sensor (MindSphere), SCADA, MES, PLC/DCS, or API. Used to assess automation coverage and manual inspection dependency."
    - name: "breach_severity"
      expr: breach_severity
      comment: "Threshold breach severity: none, warning, alarm, critical. Drives maintenance priority and escalation workflow analysis."
    - name: "reading_quality"
      expr: reading_quality
      comment: "OPC-UA quality indicator: good, uncertain, bad. Critical for IIoT and SCADA data quality management and sensor reliability assessment."
    - name: "reading_status"
      expr: reading_status
      comment: "Lifecycle status of the reading record: active, cancelled, superseded, pending_review. Controls which readings are valid for condition monitoring."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the plant where the measurement was taken. Supports multinational regulatory compliance reporting."
    - name: "reading_month"
      expr: DATE_TRUNC('MONTH', reading_timestamp)
      comment: "Month in which the reading was captured. Enables trend analysis of sensor activity, breach frequency, and condition monitoring coverage over time."
    - name: "functional_location"
      expr: functional_location
      comment: "Hierarchical plant structure identifier (production line, work center). Enables spatial analytics for condition monitoring coverage and breach hotspot identification."
  measures:
    - name: "total_readings"
      expr: COUNT(1)
      comment: "Total number of measurement readings captured. Baseline metric for IIoT sensor network activity and condition monitoring program coverage."
    - name: "threshold_breach_count"
      expr: COUNT(CASE WHEN threshold_breach_indicator = TRUE THEN 1 END)
      comment: "Number of readings that breached a defined warning or alarm threshold. Each breach is a potential condition-based maintenance trigger. Executives monitor breach frequency to assess asset health deterioration trends."
    - name: "threshold_breach_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN threshold_breach_indicator = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of readings that breached a threshold. A rising breach rate signals systemic asset health deterioration across the monitored equipment fleet, driving predictive maintenance investment decisions."
    - name: "critical_breach_count"
      expr: COUNT(CASE WHEN breach_severity = 'critical' THEN 1 END)
      comment: "Number of readings classified as critical severity breaches requiring immediate maintenance intervention or asset shutdown. A direct safety and production risk KPI monitored by plant directors."
    - name: "bad_quality_reading_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN reading_quality = 'bad' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of readings with bad quality (sensor fault, out of range). High rates indicate sensor network reliability issues that undermine the predictive maintenance program and require IIoT infrastructure investment."
    - name: "automated_reading_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN reading_source IN ('iiot_sensor', 'scada', 'plc_dcs', 'mindsphere') THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of readings captured automatically via IIoT/SCADA vs. manual inspection. A key digital transformation KPI — executives use this to track progress toward automated condition monitoring and reduced manual inspection costs."
    - name: "avg_reading_value"
      expr: ROUND(AVG(CAST(reading_value AS DOUBLE)), 4)
      comment: "Average measurement reading value across all readings. Used as a baseline for deviation analysis and trend monitoring of equipment operating parameters."
    - name: "total_counter_delta_value"
      expr: SUM(CAST(delta_value AS DOUBLE))
      comment: "Total incremental counter consumption (e.g., total operating hours, total production cycles) accumulated across all counter-type readings. Directly feeds usage-based maintenance scheduling and asset lifecycle consumption tracking."
    - name: "estimated_reading_count"
      expr: COUNT(CASE WHEN is_estimated = TRUE THEN 1 END)
      comment: "Number of readings that were estimated rather than directly measured. High estimated reading counts indicate sensor gaps or data quality issues that reduce the reliability of condition-based maintenance decisions."
    - name: "distinct_measurement_points_monitored"
      expr: COUNT(DISTINCT measurement_point_id)
      comment: "Number of unique measurement points with at least one reading. Measures the breadth of the condition monitoring program. Executives use this to track IIoT sensor deployment coverage across the asset fleet."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_service_contract`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Vendor service contract KPIs covering contract portfolio value, SLA terms, coverage scope, and contract lifecycle status. Used by procurement directors, asset managers, and CFOs to manage vendor maintenance spend, negotiate contract renewals, and enforce SLA compliance."
  source: "`manufacturing_ecm`.`asset`.`service_contract`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the primary facility where contracted maintenance services are performed. Enables plant-level vendor spend and SLA compliance analysis."
    - name: "contract_type"
      expr: contract_type
      comment: "Commercial structure of the contract: full-service, PM-only, time-and-materials, OEM service agreement, emergency response. Drives spend classification and vendor strategy analysis."
    - name: "contract_category"
      expr: contract_category
      comment: "Nature of the service provider: OEM direct, third-party, in-house, consortium. Used for make-vs-buy analysis and vendor portfolio management."
    - name: "contract_status"
      expr: status
      comment: "Current lifecycle status of the service contract (draft, active, suspended, expired, terminated). Controls which contracts are operationally active and generating obligations."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the primary service location. Supports multi-country regulatory compliance and regional spend reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO 4217 currency code for contract value amounts. Supports multi-currency spend consolidation."
    - name: "preventive_maintenance_included"
      expr: preventive_maintenance_included
      comment: "Whether scheduled PM visits are included in the contract scope. Used to assess PM coverage and identify assets relying on time-and-materials billing."
    - name: "spare_parts_included"
      expr: spare_parts_included
      comment: "Whether spare parts costs are covered within the contract value. Drives MRO cost allocation and total cost of ownership analysis."
    - name: "emergency_response_included"
      expr: emergency_response_included
      comment: "Whether 24/7 emergency breakdown response is included in the contract scope. Critical for assessing emergency maintenance coverage and risk exposure."
    - name: "penalty_clause_flag"
      expr: penalty_clause_flag
      comment: "Whether the contract includes financial penalty clauses for SLA breaches. Used to assess vendor accountability and financial risk exposure from SLA failures."
    - name: "contract_expiry_month"
      expr: DATE_TRUNC('MONTH', end_date)
      comment: "Month in which the contract expires. Used for renewal pipeline management and procurement planning."
  measures:
    - name: "total_contracts"
      expr: COUNT(1)
      comment: "Total number of service contracts in the portfolio. Baseline metric for vendor relationship scope and contract management workload."
    - name: "active_contract_count"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Number of currently active service contracts. Measures the operational vendor maintenance coverage footprint."
    - name: "total_annual_contract_value"
      expr: SUM(CAST(annual_value AS DOUBLE))
      comment: "Total annualized value of all service contracts. The primary vendor maintenance OPEX spend KPI used by CFOs and procurement directors for budget planning and spend optimization."
    - name: "avg_annual_contract_value"
      expr: ROUND(AVG(CAST(annual_value AS DOUBLE)), 2)
      comment: "Average annualized value per service contract. Used to benchmark contract size and identify outliers requiring renegotiation or consolidation."
    - name: "contracts_expiring_within_90_days"
      expr: COUNT(CASE WHEN end_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) AND status = 'active' THEN 1 END)
      comment: "Number of active contracts expiring within the next 90 days. A critical procurement pipeline KPI — executives use this to ensure timely renewal negotiations and avoid unplanned maintenance coverage gaps."
    - name: "expiring_contract_value_90_days"
      expr: SUM(CASE WHEN end_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) AND status = 'active' THEN CAST(annual_value AS DOUBLE) ELSE 0 END)
      comment: "Total annualized value of contracts expiring within 90 days. Quantifies the financial exposure from upcoming contract renewals and drives procurement prioritization."
    - name: "avg_sla_response_time_hours"
      expr: ROUND(AVG(CAST(sla_response_time_hours AS DOUBLE)), 2)
      comment: "Average contractually guaranteed vendor response time in hours across the contract portfolio. Used to assess whether the vendor SLA portfolio meets equipment criticality requirements and OEE uptime targets."
    - name: "avg_sla_resolution_time_hours"
      expr: ROUND(AVG(CAST(sla_resolution_time_hours AS DOUBLE)), 2)
      comment: "Average contractually guaranteed fault-to-restoration time in hours. A key OEE and production availability KPI — executives use this to assess whether vendor resolution commitments are aligned with production uptime targets."
    - name: "avg_uptime_guarantee_pct"
      expr: ROUND(AVG(CAST(uptime_guarantee_percent AS DOUBLE)), 2)
      comment: "Average contractually guaranteed equipment uptime percentage across the contract portfolio. Directly linked to OEE targets. A low average signals inadequate vendor commitments relative to production availability requirements."
    - name: "contracts_with_penalty_clause_count"
      expr: COUNT(CASE WHEN penalty_clause_flag = TRUE THEN 1 END)
      comment: "Number of contracts with financial penalty clauses for SLA breaches. Measures the degree of vendor accountability enforcement in the contract portfolio. Executives use this to assess procurement governance strength."
    - name: "auto_renewal_contract_count"
      expr: COUNT(CASE WHEN auto_renewal_flag = TRUE THEN 1 END)
      comment: "Number of contracts configured for automatic renewal. High counts represent uncontrolled OPEX commitments — procurement directors monitor this to ensure intentional renewal decisions and avoid budget surprises."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_warranty`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Asset warranty portfolio KPIs covering warranty coverage status, claim activity, cost recovery performance, and expiry risk. Used by after-sales managers, procurement directors, and asset managers to maximize warranty cost recovery, manage supplier obligations, and prevent coverage gaps."
  source: "`manufacturing_ecm`.`asset`.`warranty`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the manufacturing facility where the warranted asset is installed. Supports multi-site warranty management and regional reporting."
    - name: "warranty_type"
      expr: type
      comment: "Warranty coverage type: OEM standard, extended service agreement, supplier warranty. Drives cost recovery strategy and supplier obligation management."
    - name: "warranty_category"
      expr: category
      comment: "Nature of the covered asset: complete equipment unit, component, sub-assembly, software, structural. Supports claim eligibility assessment and coverage scope analysis."
    - name: "warranty_status"
      expr: status
      comment: "Current lifecycle status of the warranty record. Drives maintenance decision support (warranty vs. repair) and claim eligibility checks."
    - name: "coverage_basis"
      expr: coverage_basis
      comment: "Warranty trigger basis: time-based, usage-based, time-and-usage, or event-based. Used to assess warranty validity and remaining coverage calculations."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the asset location. Supports jurisdiction-specific warranty regulation compliance and multi-national reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO 4217 currency code for warranty monetary values. Supports multi-currency cost recovery tracking."
    - name: "labor_covered"
      expr: labor_covered_flag
      comment: "Whether labor costs for warranty repairs are covered. Drives cost recovery calculations and maintenance work order cost allocation."
    - name: "parts_covered"
      expr: parts_covered_flag
      comment: "Whether replacement parts are covered under the warranty. Determines whether spare parts costs should be claimed from the supplier."
    - name: "warranty_expiry_month"
      expr: DATE_TRUNC('MONTH', expiry_date)
      comment: "Month in which the warranty expires. Used for proactive renewal planning and coverage gap risk management."
  measures:
    - name: "total_warranties"
      expr: COUNT(1)
      comment: "Total number of warranty records in the portfolio. Baseline metric for warranty coverage scope and after-sales program scale."
    - name: "active_warranty_count"
      expr: COUNT(CASE WHEN status = 'active' AND expiry_date >= CURRENT_DATE THEN 1 END)
      comment: "Number of currently active and unexpired warranties. Measures the breadth of warranty coverage available for maintenance cost recovery decisions."
    - name: "warranties_expiring_within_90_days"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) AND status = 'active' THEN 1 END)
      comment: "Number of active warranties expiring within 90 days. A critical procurement and after-sales KPI — executives use this to trigger renewal negotiations and prevent unplanned maintenance cost exposure."
    - name: "total_claimed_amount"
      expr: SUM(CAST(total_claimed_amount AS DOUBLE))
      comment: "Total cumulative monetary value of all warranty claims submitted. Measures the financial value recovered from OEM and supplier warranties. A direct OPEX reduction KPI monitored by CFOs and procurement directors."
    - name: "total_claim_limit_amount"
      expr: SUM(CAST(total_claim_limit_amount AS DOUBLE))
      comment: "Total maximum cumulative claim value available across the warranty portfolio. Represents the total warranty cost recovery potential. Used for financial planning and OPEX budget optimization."
    - name: "warranty_utilization_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(total_claimed_amount AS DOUBLE)) / NULLIF(SUM(CAST(total_claim_limit_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of total available warranty claim value that has been utilized. Low utilization rates indicate missed cost recovery opportunities — executives use this to drive after-sales teams to maximize warranty claim submissions."
    - name: "avg_response_time_hours"
      expr: ROUND(AVG(CAST(response_time_hours AS DOUBLE)), 2)
      comment: "Average OEM/supplier warranty response time commitment in hours. Used to assess whether warranty SLA terms meet equipment criticality requirements and production uptime targets."
    - name: "warranties_with_open_claims"
      expr: COUNT(CASE WHEN open_claim_count > 0 THEN 1 END)
      comment: "Number of warranties with at least one open or in-progress claim. Measures active warranty claim workload and supplier obligation management complexity."
    - name: "renewal_eligible_count"
      expr: COUNT(CASE WHEN renewal_option_flag = TRUE AND expiry_date >= CURRENT_DATE THEN 1 END)
      comment: "Number of active warranties eligible for renewal. Procurement and after-sales teams use this to prioritize renewal negotiations and maintain continuous coverage for critical assets."
$$;