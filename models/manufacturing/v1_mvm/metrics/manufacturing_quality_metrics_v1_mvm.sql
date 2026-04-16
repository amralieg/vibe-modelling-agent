-- Metric views for domain: quality | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_inspection_lot`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Inspection lot quality performance metrics covering yield, scrap, rework, and nonconformance rates across plants, work centers, and inspection types. Core KPI view for manufacturing quality governance and ISO 9001 Clause 8.6 compliance."
  source: "`manufacturing_ecm`.`quality`.`inspection_lot`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or facility where the inspection lot was executed. Enables multi-site quality benchmarking."
    - name: "inspection_type"
      expr: inspection_type
      comment: "SAP QM inspection type code (e.g., 01=GR from PO, 04=GR from Production, 06=Delivery to Customer). Distinguishes incoming, in-process, and final inspection performance."
    - name: "inspection_type_description"
      expr: inspection_type_description
      comment: "Human-readable label for the inspection type, used in dashboards and reports."
    - name: "lot_origin"
      expr: lot_origin
      comment: "Business process that triggered the inspection lot (production order, goods receipt, customer delivery). Supports root cause analysis by origin."
    - name: "usage_decision_code"
      expr: usage_decision_code
      comment: "Final disposition code for the lot (A=Accept, R=Reject, B=Rework, Q=Blocked). Drives downstream stock posting and quality reporting."
    - name: "inspection_stage"
      expr: inspection_stage
      comment: "Dynamic modification stage (Normal, Tightened, Reduced, Skip) reflecting quality history-based inspection intensity adjustment."
    - name: "work_center"
      expr: work_center
      comment: "Production work center or cell where the in-process inspection was performed. Enables work-center-level defect analysis."
    - name: "vendor_number"
      expr: vendor_number
      comment: "Supplier/vendor number for incoming goods receipt inspection lots. Supports supplier quality scorecard reporting."
    - name: "vendor_name"
      expr: vendor_name
      comment: "Supplier name for incoming goods receipt inspection lots. Provides human-readable supplier identification."
    - name: "inspection_start_month"
      expr: DATE_TRUNC('MONTH', inspection_start_date)
      comment: "Month in which inspection commenced. Enables monthly quality trend analysis."
    - name: "inspection_start_year"
      expr: YEAR(inspection_start_date)
      comment: "Year in which inspection commenced. Supports annual quality performance reporting."
    - name: "is_first_article_inspection"
      expr: is_first_article_inspection
      comment: "Flag indicating whether the lot is a First Article Inspection (FAI). Separates FAI performance from routine production inspection."
    - name: "unit_of_measure"
      expr: unit_of_measure
      comment: "Base unit of measure for lot quantities (EA, KG, M). Required for correct quantity aggregation context."
  measures:
    - name: "total_lot_quantity"
      expr: SUM(CAST(lot_quantity AS DOUBLE))
      comment: "Total quantity of material submitted for inspection across all lots. Denominator for yield and defect rate calculations."
    - name: "total_accepted_quantity"
      expr: SUM(CAST(accepted_quantity AS DOUBLE))
      comment: "Total quantity accepted for unrestricted use after inspection. Numerator for first-pass yield calculation."
    - name: "total_nonconforming_quantity"
      expr: SUM(CAST(nonconforming_quantity AS DOUBLE))
      comment: "Total quantity found nonconforming across all inspection lots. Key input for PPM defect rate and cost of poor quality reporting."
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity scrapped due to nonconformance. Directly drives scrap cost and COGS impact reporting."
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total quantity requiring rework before acceptance. Drives rework cost tracking and capacity planning."
    - name: "first_pass_yield_pct"
      expr: ROUND(100.0 * SUM(CAST(accepted_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity accepted on first pass without rework or scrap. Core manufacturing quality KPI — directly linked to production efficiency and customer satisfaction."
    - name: "scrap_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(scrap_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity scrapped. Directly tied to material cost waste and COGS impact. Triggers corrective action when above threshold."
    - name: "rework_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(rework_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity requiring rework. Indicates hidden factory cost and process instability."
    - name: "nonconformance_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(nonconforming_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity found nonconforming. Composite quality escape rate used in supplier scorecards and plant quality reviews."
    - name: "total_inspection_lots"
      expr: COUNT(1)
      comment: "Total number of inspection lots executed. Baseline volume measure for quality workload and throughput analysis."
    - name: "rejected_lots"
      expr: COUNT(CASE WHEN usage_decision_code = 'R' THEN 1 END)
      comment: "Number of inspection lots formally rejected. Tracks rejection frequency for supplier and process quality governance."
    - name: "lot_rejection_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN usage_decision_code = 'R' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of inspection lots rejected. Executive-level quality KPI used in supplier qualification and plant performance reviews."
    - name: "avg_inspection_cycle_time_days"
      expr: AVG(DATEDIFF(inspection_end_date, inspection_start_date))
      comment: "Average number of days from inspection start to completion. Measures inspection throughput efficiency and identifies bottlenecks in the quality process."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_capa`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Corrective and Preventive Action (CAPA) performance metrics tracking cycle time, on-time closure, recurrence rates, and effectiveness. Supports ISO 9001 Clause 10.2 compliance and quality system maturity assessment."
  source: "`manufacturing_ecm`.`quality`.`capa`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the CAPA originated. Enables plant-level corrective action performance benchmarking."
    - name: "type"
      expr: type
      comment: "CAPA type: Corrective (addressing existing nonconformance), Preventive (addressing potential risk), or Improvement. Drives strategic quality investment decisions."
    - name: "status"
      expr: status
      comment: "Current workflow status of the CAPA (Initiated, Root Cause Analysis, Action Planning, Implementation, Verification, Closed). Tracks pipeline health."
    - name: "priority"
      expr: priority
      comment: "Business priority level (Critical, High, Medium, Low) based on risk severity and customer impact. Drives escalation and resource allocation."
    - name: "source_type"
      expr: source_type
      comment: "Originating trigger for the CAPA (NCR, Customer Complaint, Audit Finding, SPC Alert, Supplier Defect, Field Failure). Identifies systemic quality escape sources."
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "6M Ishikawa root cause category (Man, Machine, Material, Method, Measurement, Environment). Enables systemic trend analysis for quality improvement investment."
    - name: "action_owner_department"
      expr: action_owner_department
      comment: "Department responsible for CAPA implementation. Supports workload distribution and departmental quality accountability reporting."
    - name: "effectiveness_rating"
      expr: effectiveness_rating
      comment: "Formal assessment of whether the corrective action successfully eliminated the root cause. Measures quality system effectiveness."
    - name: "recurrence_flag"
      expr: recurrence_flag
      comment: "Indicates whether the nonconformance recurred after CAPA closure. Critical flag for escalation and systemic quality failure analysis."
    - name: "regulatory_reporting_required"
      expr: regulatory_reporting_required
      comment: "Indicates whether the CAPA requires regulatory notification (OSHA, EPA, CE). Drives compliance workflow prioritization."
    - name: "initiated_month"
      expr: DATE_TRUNC('MONTH', initiated_date)
      comment: "Month the CAPA was initiated. Enables monthly trend analysis of quality problem volume."
    - name: "initiated_year"
      expr: YEAR(initiated_date)
      comment: "Year the CAPA was initiated. Supports annual quality performance and ISO audit reporting."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the originating plant. Supports multinational regulatory compliance and regional quality performance analysis."
  measures:
    - name: "total_capas"
      expr: COUNT(1)
      comment: "Total number of CAPA records. Baseline volume measure for quality problem frequency and corrective action workload."
    - name: "open_capas"
      expr: COUNT(CASE WHEN status NOT IN ('Closed', 'Verified') THEN 1 END)
      comment: "Number of CAPAs not yet closed. Tracks open corrective action backlog — a key quality system health indicator reviewed in management reviews."
    - name: "overdue_capas"
      expr: COUNT(CASE WHEN actual_closure_date IS NULL AND target_closure_date < CURRENT_DATE() THEN 1 END)
      comment: "Number of CAPAs past their target closure date without being closed. Directly triggers escalation and resource reallocation decisions."
    - name: "on_time_closure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_closure_date IS NOT NULL AND actual_closure_date <= target_closure_date THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_closure_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of closed CAPAs completed on or before the target closure date. Core SLA compliance KPI for quality management system performance."
    - name: "recurrence_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN recurrence_flag = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_closure_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of closed CAPAs where the nonconformance recurred. Measures corrective action effectiveness — high recurrence signals systemic quality failure and drives escalation."
    - name: "avg_capa_cycle_time_days"
      expr: AVG(DATEDIFF(actual_closure_date, initiated_date))
      comment: "Average number of days from CAPA initiation to formal closure. Measures quality response agility — directly linked to customer satisfaction and regulatory compliance timelines."
    - name: "regulatory_reportable_capas"
      expr: COUNT(CASE WHEN regulatory_reporting_required = TRUE THEN 1 END)
      comment: "Number of CAPAs requiring regulatory notification. Tracks regulatory compliance exposure and mandatory reporting obligations."
    - name: "customer_notification_required_capas"
      expr: COUNT(CASE WHEN customer_notification_required = TRUE THEN 1 END)
      comment: "Number of CAPAs requiring formal customer notification. Tracks customer-impacting quality events and SLA obligations."
    - name: "effective_capa_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN effectiveness_rating IN ('Effective', 'Highly Effective') THEN 1 END) / NULLIF(COUNT(CASE WHEN effectiveness_rating IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of verified CAPAs rated as effective or highly effective. Measures quality system maturity and corrective action quality — a key ISO 9001 management review metric."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_customer_complaint`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer complaint quality metrics covering financial impact, resolution cycle time, SLA compliance, safety escalations, and 8D problem-solving effectiveness. Directly linked to customer retention, warranty cost, and field quality performance."
  source: "`manufacturing_ecm`.`quality`.`customer_complaint`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the affected product was produced. Enables plant-level field quality accountability."
    - name: "complaint_type"
      expr: complaint_type
      comment: "Classification of complaint (Field Failure, Warranty Claim, OEM Partner Complaint, Safety Concern, Regulatory Issue). Drives prioritization and resolution strategy."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the complaint (Received, Under Investigation, Containment, Root Cause, Closed). Tracks resolution pipeline health."
    - name: "priority"
      expr: priority
      comment: "Business priority level based on safety impact, customer significance, and regulatory exposure. Drives escalation and resource allocation."
    - name: "defect_category"
      expr: defect_category
      comment: "High-level defect category (Dimensional, Functional, Surface, Material, Assembly). Enables Pareto analysis for quality improvement investment."
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Standardized root cause classification. Enables systemic trend analysis across complaints to identify recurring quality failures."
    - name: "eight_d_status"
      expr: eight_d_status
      comment: "Current 8D problem-solving step. Tracks structured resolution progress and identifies bottlenecks in the complaint resolution process."
    - name: "warranty_status"
      expr: warranty_status
      comment: "Warranty coverage status (In Warranty, Out of Warranty, Goodwill). Drives financial liability classification and resolution approach."
    - name: "safety_related"
      expr: safety_related
      comment: "Indicates whether the complaint involves a safety hazard. Safety complaints require mandatory escalation and executive visibility."
    - name: "regulatory_reportable"
      expr: regulatory_reportable
      comment: "Indicates whether the complaint must be reported to a regulatory authority. Tracks mandatory compliance reporting obligations."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the customer location. Enables regional field quality trend analysis and regulatory reporting."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO currency code for financial impact amounts. Required for multi-currency financial reporting context."
    - name: "received_month"
      expr: DATE_TRUNC('MONTH', received_date)
      comment: "Month the complaint was received. Enables monthly complaint volume and financial impact trend analysis."
    - name: "received_year"
      expr: YEAR(received_date)
      comment: "Year the complaint was received. Supports annual field quality performance and warranty cost reporting."
    - name: "source_channel"
      expr: source_channel
      comment: "Channel through which the complaint was received (Portal, Email, Phone, Field Service). Enables complaint intake pattern analysis."
  measures:
    - name: "total_complaints"
      expr: COUNT(1)
      comment: "Total number of customer complaints received. Baseline field quality volume metric reviewed in executive quality steering meetings."
    - name: "total_financial_impact"
      expr: SUM(CAST(financial_impact_amount AS DOUBLE))
      comment: "Total financial cost of customer complaints including warranty claims, field returns, rework, and customer penalties. Core Cost of Poor Quality (COPQ) metric for executive decision-making."
    - name: "avg_financial_impact_per_complaint"
      expr: AVG(CAST(financial_impact_amount AS DOUBLE))
      comment: "Average financial cost per complaint. Enables prioritization of complaint types and root causes by economic impact."
    - name: "total_units_complained"
      expr: SUM(CAST(quantity_complained AS DOUBLE))
      comment: "Total number of units reported as defective across all complaints. Denominator for field PPM calculation and scope assessment."
    - name: "safety_complaint_count"
      expr: COUNT(CASE WHEN safety_related = TRUE THEN 1 END)
      comment: "Number of complaints involving potential safety hazards. Safety complaints require mandatory escalation — a non-negotiable executive visibility metric."
    - name: "safety_complaint_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN safety_related = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of complaints classified as safety-related. Tracks safety risk exposure in the field — directly linked to product liability and regulatory risk."
    - name: "on_time_closure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_closure_date IS NOT NULL AND actual_closure_date <= target_closure_date THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_closure_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of closed complaints resolved within the committed target closure date. Measures SLA compliance and customer responsiveness — directly linked to customer retention."
    - name: "avg_resolution_cycle_time_days"
      expr: AVG(DATEDIFF(actual_closure_date, received_date))
      comment: "Average days from complaint receipt to formal closure. Measures customer responsiveness and 8D resolution efficiency — a key customer satisfaction driver."
    - name: "customer_approved_closure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN customer_approved_closure = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_closure_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of closed complaints with formal customer sign-off on the resolution. Measures true customer satisfaction with complaint resolution quality."
    - name: "open_complaints"
      expr: COUNT(CASE WHEN status NOT IN ('Closed') THEN 1 END)
      comment: "Number of complaints not yet formally closed. Tracks open complaint backlog — a key customer relationship health indicator."
    - name: "regulatory_reportable_complaints"
      expr: COUNT(CASE WHEN regulatory_reportable = TRUE THEN 1 END)
      comment: "Number of complaints requiring regulatory authority notification. Tracks mandatory compliance reporting obligations and regulatory risk exposure."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_inspection_result`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Detailed inspection result metrics covering process capability (Cp/Cpk), SPC violation rates, conformance rates, and measurement quality at the characteristic level. Enables Six Sigma process improvement and PPAP capability compliance monitoring."
  source: "`manufacturing_ecm`.`quality`.`inspection_result`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the inspection was performed. Enables multi-site process capability benchmarking."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Production work center or inspection station. Enables work-center-level process capability and defect analysis."
    - name: "inspection_category"
      expr: inspection_category
      comment: "Category of inspection (Incoming, In-Process, Final, FAI, Supplier, Customer Return). Distinguishes quality performance by supply chain stage."
    - name: "inspection_stage"
      expr: inspection_stage
      comment: "Production stage at which the inspection was performed. Enables value-stream-level quality traceability."
    - name: "characteristic_type"
      expr: characteristic_type
      comment: "Classification of the characteristic (Variable, Attribute, Count). Drives appropriate SPC methodology and capability analysis."
    - name: "conformance_decision"
      expr: conformance_decision
      comment: "Quality conformance decision for the characteristic result (Accepted, Rejected, Conditional Accept, Rework Required, Scrap). Drives disposition workflow."
    - name: "measurement_method"
      expr: measurement_method
      comment: "Measurement technique used (CMM, Caliper, Micrometer, Visual, Go/No-Go). Supports Measurement System Analysis traceability."
    - name: "inspection_month"
      expr: DATE_TRUNC('MONTH', inspection_timestamp)
      comment: "Month of inspection. Enables monthly process capability trend analysis."
    - name: "spc_violation_flag"
      expr: spc_violation_flag
      comment: "Indicates whether the measurement triggered an SPC rule violation. Separates in-control from out-of-control process performance."
    - name: "retest_flag"
      expr: retest_flag
      comment: "Indicates whether this is a retest measurement. Tracks measurement system reliability and inspection rework."
  measures:
    - name: "total_inspection_results"
      expr: COUNT(1)
      comment: "Total number of individual characteristic measurements recorded. Baseline inspection volume for workload and coverage analysis."
    - name: "nonconforming_results"
      expr: COUNT(CASE WHEN conformance_decision IN ('rejected', 'Rejected') THEN 1 END)
      comment: "Number of individual characteristic measurements found nonconforming. Drives defect Pareto analysis and CAPA initiation."
    - name: "characteristic_conformance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN conformance_decision IN ('accepted', 'Accepted') THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of individual characteristic measurements conforming to specification. Granular quality conformance rate used in process capability reporting and PPAP submissions."
    - name: "avg_cpk_index"
      expr: AVG(CAST(cpk_index AS DOUBLE))
      comment: "Average Cpk (Centered Process Capability Index) across all measured characteristics. Core Six Sigma KPI — values below 1.33 trigger process improvement actions and PPAP resubmission."
    - name: "avg_cp_index"
      expr: AVG(CAST(cp_index AS DOUBLE))
      comment: "Average Cp (Process Capability Index) across all measured characteristics. Measures process spread relative to specification width — used alongside Cpk in PPAP capability studies."
    - name: "spc_violation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN spc_violation_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of measurements triggering SPC rule violations. Measures process instability — high rates trigger immediate process investigation and production holds."
    - name: "characteristics_below_cpk_threshold"
      expr: COUNT(CASE WHEN CAST(cpk_index AS DOUBLE) < 1.33 THEN 1 END)
      comment: "Number of characteristic measurements with Cpk below the AIAG minimum threshold of 1.33. Directly identifies processes requiring capability improvement for PPAP compliance."
    - name: "retest_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN retest_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of measurements that are retests. High retest rates indicate measurement system issues or borderline process performance requiring investigation."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_spc_sample`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Statistical Process Control (SPC) sample metrics tracking process capability, out-of-control signal rates, and specification violation rates in real-time production monitoring. Enables proactive process intervention before defects reach customers."
  source: "`manufacturing_ecm`.`quality`.`spc_sample`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the SPC sample was collected. Enables multi-site process stability comparison."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center or production cell where the characteristic was measured. Primary dimension for SPC monitoring and process ownership."
    - name: "operation_number"
      expr: operation_number
      comment: "Routing operation number at which the SPC sample was taken. Links process monitoring to specific manufacturing steps."
    - name: "shift_code"
      expr: shift_code
      comment: "Production shift (Day, Night, Afternoon) during which the sample was collected. Enables shift-level process variation analysis."
    - name: "sample_status"
      expr: sample_status
      comment: "Processing status of the SPC sample (Collected, Validated, Rejected, Voided). Ensures only valid samples are included in capability analysis."
    - name: "data_source"
      expr: data_source
      comment: "How the measurement was captured (Manual, Auto-Gauge, MES, SCADA, IIoT). Affects data quality confidence and measurement system analysis."
    - name: "we_rule_violated"
      expr: we_rule_violated
      comment: "Specific Western Electric rule violated (WE1: beyond 3-sigma, WE2: 9 consecutive points, etc.). Enables targeted process investigation by violation type."
    - name: "sample_month"
      expr: DATE_TRUNC('MONTH', sample_timestamp)
      comment: "Month of sample collection. Enables monthly process capability trend analysis."
    - name: "unit_of_measure"
      expr: unit_of_measure
      comment: "Engineering unit of the measured value. Required for correct interpretation of capability indices across characteristics."
  measures:
    - name: "total_spc_samples"
      expr: COUNT(1)
      comment: "Total number of SPC data points collected. Baseline measure for SPC monitoring coverage and sampling compliance."
    - name: "out_of_control_signals"
      expr: COUNT(CASE WHEN out_of_control_flag = TRUE THEN 1 END)
      comment: "Number of SPC samples triggering out-of-control signals. Each signal requires immediate process investigation — directly linked to defect prevention."
    - name: "out_of_control_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN out_of_control_flag = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN sample_status = 'VALIDATED' THEN 1 END), 0), 2)
      comment: "Percentage of validated SPC samples triggering out-of-control signals. Core process stability KPI — high rates indicate systemic process instability requiring engineering intervention."
    - name: "spec_violation_count"
      expr: COUNT(CASE WHEN spec_violation_flag = TRUE THEN 1 END)
      comment: "Number of SPC samples where the measured value falls outside engineering specification limits. Represents actual nonconforming production — directly drives scrap and rework costs."
    - name: "spec_violation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN spec_violation_flag = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN sample_status = 'VALIDATED' THEN 1 END), 0), 2)
      comment: "Percentage of validated samples outside specification limits. Measures actual defect rate in production — directly linked to scrap cost and customer escape risk."
    - name: "avg_cpk_index"
      expr: AVG(CAST(cpk_index AS DOUBLE))
      comment: "Average Cpk across all SPC samples. Real-time process capability indicator — values below 1.33 trigger process improvement actions per AIAG standards."
    - name: "avg_cp_index"
      expr: AVG(CAST(cp_index AS DOUBLE))
      comment: "Average Cp across all SPC samples. Measures process spread relative to specification width — used with Cpk to diagnose centering vs. spread issues."
    - name: "avg_subgroup_mean"
      expr: AVG(CAST(subgroup_mean AS DOUBLE))
      comment: "Average of subgroup means across all SPC samples. Tracks process location over time — deviations from the center line indicate process drift requiring adjustment."
    - name: "avg_subgroup_range"
      expr: AVG(CAST(subgroup_range AS DOUBLE))
      comment: "Average subgroup range across all SPC samples. Measures process variability — increasing range indicates growing process instability."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_gauge_calibration`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Gauge calibration compliance metrics tracking calibration pass rates, out-of-service rates, measurement recall exposure, and calibration program health. Supports ISO 9001 Clause 7.1.5 measurement resource management and PPAP MSA requirements."
  source: "`manufacturing_ecm`.`quality`.`gauge_calibration`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the gauge is assigned and calibration was performed. Enables plant-level metrology compliance reporting."
    - name: "calibration_lab_type"
      expr: calibration_lab_type
      comment: "Internal vs. external accredited calibration laboratory. Supports make-vs-buy calibration strategy decisions."
    - name: "calibration_lab_name"
      expr: calibration_lab_name
      comment: "Name of the calibration laboratory. Enables lab performance benchmarking and accreditation compliance tracking."
    - name: "calibration_result"
      expr: calibration_result
      comment: "Pass/fail outcome of the calibration event. Core compliance dimension for calibration program health reporting."
    - name: "as_found_condition"
      expr: as_found_condition
      comment: "Condition of the gauge before calibration adjustment. Tracks gauge drift patterns and informs calibration interval optimization."
    - name: "adjustment_performed"
      expr: adjustment_performed
      comment: "Indicates whether the gauge required physical adjustment during calibration. High adjustment rates signal gauge quality or usage issues."
    - name: "out_of_service_flag"
      expr: out_of_service_flag
      comment: "Indicates whether the gauge was removed from service due to calibration failure. Tracks measurement system availability impact."
    - name: "recall_required_flag"
      expr: recall_required_flag
      comment: "Indicates whether a measurement recall investigation is required. Recall events have significant quality and regulatory implications."
    - name: "department_code"
      expr: department_code
      comment: "Department responsible for the gauge. Enables departmental calibration compliance accountability."
    - name: "calibration_month"
      expr: DATE_TRUNC('MONTH', certificate_issue_date)
      comment: "Month of calibration certificate issuance. Enables monthly calibration program activity and compliance trend analysis."
  measures:
    - name: "total_calibration_events"
      expr: COUNT(1)
      comment: "Total number of gauge calibration events. Baseline measure for calibration program activity and workload."
    - name: "calibration_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN calibration_result = 'Pass' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibration events with a passing result. Core metrology program health KPI — low pass rates indicate gauge fleet quality issues requiring investment."
    - name: "calibration_fail_count"
      expr: COUNT(CASE WHEN calibration_result = 'Fail' THEN 1 END)
      comment: "Number of calibration events resulting in failure. Each failure triggers gauge withdrawal and potential measurement recall — directly linked to quality risk."
    - name: "out_of_service_gauge_events"
      expr: COUNT(CASE WHEN out_of_service_flag = TRUE THEN 1 END)
      comment: "Number of calibration events resulting in gauge removal from service. Tracks measurement system availability impact on production quality control."
    - name: "measurement_recall_events"
      expr: COUNT(CASE WHEN recall_required_flag = TRUE THEN 1 END)
      comment: "Number of calibration events triggering a measurement recall investigation. Recall events have significant quality, regulatory, and customer impact — requires executive visibility."
    - name: "adjustment_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN adjustment_performed = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibration events requiring physical gauge adjustment. High rates indicate gauge drift issues and may warrant calibration interval reduction."
    - name: "avg_measurement_uncertainty"
      expr: AVG(CAST(measurement_uncertainty AS DOUBLE))
      comment: "Average expanded measurement uncertainty across calibration events. Tracks metrology system quality — high uncertainty values may invalidate inspection results and PPAP capability studies."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_usage_decision`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quality usage decision metrics tracking material disposition outcomes, acceptance rates, scrap and rejection quantities, inspection cycle times, and quality scores. Core quality disposition KPI view linking inspection outcomes to inventory and cost impacts."
  source: "`manufacturing_ecm`.`quality`.`usage_decision`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the usage decision was made. Enables plant-level quality disposition performance analysis."
    - name: "decision_category"
      expr: decision_category
      comment: "High-level disposition category (Accept, Reject, Conditional Release, Scrap). Standardized classification for cross-plant quality performance comparison."
    - name: "decision_code"
      expr: decision_code
      comment: "Formal SAP QM disposition code (A=Accept, R=Reject, C=Conditional, S=Scrap). Drives downstream stock posting and financial impact."
    - name: "inspection_type"
      expr: inspection_type
      comment: "Inspection stage at which the decision was made (Incoming, In-Process, Final, FAI). Identifies where in the value stream quality issues are being caught."
    - name: "inspection_lot_origin"
      expr: inspection_lot_origin
      comment: "Business process that triggered the inspection lot (GR, Production Order, Customer Delivery). Supports root cause analysis by origin."
    - name: "vendor_number"
      expr: vendor_number
      comment: "Supplier number for incoming goods inspection decisions. Enables supplier quality scorecard and PPM reporting."
    - name: "regulatory_hold"
      expr: regulatory_hold
      comment: "Indicates whether material is under regulatory hold. Regulatory holds block stock posting and require executive escalation."
    - name: "decision_month"
      expr: DATE_TRUNC('MONTH', decision_date)
      comment: "Month the usage decision was made. Enables monthly quality disposition trend analysis."
    - name: "decision_year"
      expr: YEAR(decision_date)
      comment: "Year the usage decision was made. Supports annual quality performance and cost of poor quality reporting."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the plant. Supports multinational regulatory compliance and regional quality performance analysis."
  measures:
    - name: "total_usage_decisions"
      expr: COUNT(1)
      comment: "Total number of usage decisions made. Baseline measure for quality disposition volume and inspection throughput."
    - name: "total_inspection_quantity"
      expr: SUM(CAST(inspection_quantity AS DOUBLE))
      comment: "Total quantity of material submitted for inspection and disposition. Denominator for acceptance and rejection rate calculations."
    - name: "total_accepted_quantity"
      expr: SUM(CAST(accepted_quantity AS DOUBLE))
      comment: "Total quantity accepted for unrestricted use. Measures quality-approved material flow into production and shipment."
    - name: "total_rejected_quantity"
      expr: SUM(CAST(rejected_quantity AS DOUBLE))
      comment: "Total quantity rejected and posted to blocked stock. Directly drives supplier debit memos, returns, and cost of poor quality."
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity scrapped through usage decisions. Core cost of poor quality metric — directly impacts COGS and material efficiency."
    - name: "material_acceptance_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(accepted_quantity AS DOUBLE)) / NULLIF(SUM(CAST(inspection_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected material quantity accepted for unrestricted use. Primary quality yield metric at the material disposition level — directly linked to production efficiency and supplier performance."
    - name: "material_rejection_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(rejected_quantity AS DOUBLE)) / NULLIF(SUM(CAST(inspection_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected material quantity rejected. Drives supplier corrective action, procurement decisions, and cost of poor quality reporting."
    - name: "avg_quality_score"
      expr: AVG(CAST(quality_score AS DOUBLE))
      comment: "Average quality score (0-100) across usage decisions. Composite quality performance indicator used in supplier scorecards and plant quality reviews."
    - name: "avg_inspection_cycle_time_days"
      expr: AVG(DATEDIFF(decision_date, inspection_lot_created_date))
      comment: "Average days from inspection lot creation to usage decision. Measures inspection throughput efficiency — long cycle times indicate bottlenecks that delay production and shipment."
    - name: "regulatory_hold_decisions"
      expr: COUNT(CASE WHEN regulatory_hold = TRUE THEN 1 END)
      comment: "Number of usage decisions with active regulatory holds. Tracks regulatory compliance risk exposure — regulatory holds block inventory and require executive escalation."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_ppap_submission`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "PPAP submission readiness and approval metrics tracking submission completeness, customer approval rates, capability compliance, and on-time submission performance. Core APQP/PPAP program management KPI view for new product launches and supplier qualification."
  source: "`manufacturing_ecm`.`quality`.`ppap_submission`"
  dimensions:
    - name: "approval_status"
      expr: approval_status
      comment: "Customer disposition of the PPAP submission (Approved, Conditionally Approved, Rejected). Drives production release authorization and supplier qualification decisions."
    - name: "status"
      expr: status
      comment: "Current workflow status of the PPAP package (Draft, Submitted, Under Review, Approved, Rejected). Tracks submission pipeline health."
    - name: "submission_level"
      expr: CAST(submission_level AS STRING)
      comment: "PPAP submission level (1-5) defining documentation extent required. Level 3 is the standard full submission per AIAG."
    - name: "submission_reason"
      expr: submission_reason
      comment: "Business reason triggering the PPAP (New Part, ECN, Tooling Change, Annual Revalidation). Identifies PPAP volume drivers and program risk areas."
    - name: "regulatory_compliance_status"
      expr: regulatory_compliance_status
      comment: "Status of regulatory compliance (RoHS, REACH, CE Marking, UL) declared in the PPAP. Tracks regulatory risk in new product launches."
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "Country where the part is manufactured. Required for trade compliance and regulatory reporting in PPAP submissions."
    - name: "submission_month"
      expr: DATE_TRUNC('MONTH', submission_date)
      comment: "Month of PPAP submission. Enables monthly launch readiness and PPAP pipeline trend analysis."
    - name: "submission_year"
      expr: YEAR(submission_date)
      comment: "Year of PPAP submission. Supports annual new product launch quality performance reporting."
  measures:
    - name: "total_ppap_submissions"
      expr: COUNT(1)
      comment: "Total number of PPAP submissions. Baseline measure for new product launch volume and supplier qualification activity."
    - name: "approved_submissions"
      expr: COUNT(CASE WHEN approval_status = 'Approved' THEN 1 END)
      comment: "Number of PPAP submissions receiving full customer approval. Measures launch readiness success rate."
    - name: "ppap_approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN approval_status = 'Approved' THEN 1 END) / NULLIF(COUNT(CASE WHEN approval_status IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of PPAP submissions receiving full customer approval on first submission. Core new product launch quality KPI — low rates indicate systemic quality planning gaps."
    - name: "rejected_submissions"
      expr: COUNT(CASE WHEN approval_status = 'Rejected' THEN 1 END)
      comment: "Number of PPAP submissions rejected by the customer. Each rejection delays production launch and incurs resubmission costs."
    - name: "avg_ppap_completeness_pct"
      expr: AVG(CAST(overall_ppap_completeness_pct AS DOUBLE))
      comment: "Average percentage of required PPAP elements completed at submission. Measures submission quality and launch readiness — low completeness predicts rejection risk."
    - name: "avg_min_cpk_value"
      expr: AVG(CAST(min_cpk_value AS DOUBLE))
      comment: "Average minimum Cpk value across PPAP capability studies. Measures process capability compliance at launch — values below 1.33 indicate production readiness risk."
    - name: "submissions_below_cpk_threshold"
      expr: COUNT(CASE WHEN CAST(min_cpk_value AS DOUBLE) < 1.33 THEN 1 END)
      comment: "Number of PPAP submissions with minimum Cpk below the AIAG threshold of 1.33. Directly identifies parts requiring process improvement before production authorization."
    - name: "on_time_submission_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN submission_date IS NOT NULL AND submission_date <= required_submission_date THEN 1 END) / NULLIF(COUNT(CASE WHEN required_submission_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of PPAP submissions completed by the customer-required deadline. Measures program timing compliance — late submissions delay production launch and risk customer penalties."
    - name: "open_action_items_total"
      expr: SUM(CAST(open_action_count AS DOUBLE))
      comment: "Total number of open action items across all PPAP submissions. Tracks unresolved launch readiness issues — high counts indicate systemic quality planning gaps requiring resource allocation."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_quality_notification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quality notification volume, cycle time, and resolution metrics covering internal defects, customer complaints, and supplier defect notifications. Central quality event management KPI view for ISO 9001 management review and operational quality governance."
  source: "`manufacturing_ecm`.`quality`.`quality_notification`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the quality issue originated. Enables plant-level quality event performance analysis."
    - name: "type"
      expr: type
      comment: "SAP QM notification type (Q1=Internal, Q2=Customer Complaint, Q3=Supplier Defect). Distinguishes quality event sources for targeted corrective action."
    - name: "type_description"
      expr: type_description
      comment: "Human-readable notification type label. Used in executive dashboards and management review reports."
    - name: "priority"
      expr: priority
      comment: "Priority level (1=Very High/Safety, 2=High/Production, 3=Medium/Quality Risk, 4=Low/Improvement). Drives escalation and response time targets."
    - name: "defect_category"
      expr: defect_category
      comment: "Defect classification (Dimensional, Surface, Functional, Material, Process). Enables Pareto analysis for quality improvement investment prioritization."
    - name: "detection_stage"
      expr: detection_stage
      comment: "Stage where the defect was detected (Incoming, In-Process, Final, Customer). Measures detection effectiveness and escape rate by stage."
    - name: "status"
      expr: status
      comment: "SAP QM processing status (OSNO=Outstanding, NOPR=In Process, NOCO=Completed, CLSD=Closed). Tracks notification pipeline health."
    - name: "responsible_department"
      expr: responsible_department
      comment: "Department responsible for resolving the notification. Enables departmental quality accountability and workload analysis."
    - name: "regulatory_reportable"
      expr: regulatory_reportable
      comment: "Indicates whether the quality issue requires regulatory authority notification. Tracks mandatory compliance reporting obligations."
    - name: "created_month"
      expr: DATE_TRUNC('MONTH', created_timestamp)
      comment: "Month the notification was created. Enables monthly quality event volume and trend analysis."
    - name: "country_code"
      expr: country_code
      comment: "ISO country code of the originating plant. Supports multinational quality performance and regulatory compliance analysis."
  measures:
    - name: "total_notifications"
      expr: COUNT(1)
      comment: "Total number of quality notifications raised. Baseline quality event volume metric reviewed in management reviews and operational steering meetings."
    - name: "open_notifications"
      expr: COUNT(CASE WHEN status NOT IN ('CLSD', 'NOCO') THEN 1 END)
      comment: "Number of quality notifications not yet closed. Tracks open quality issue backlog — a key quality system health indicator."
    - name: "overdue_notifications"
      expr: COUNT(CASE WHEN actual_closure_date IS NULL AND required_end_date < CURRENT_DATE() THEN 1 END)
      comment: "Number of quality notifications past their required resolution date. Directly triggers escalation and resource reallocation — a critical SLA compliance metric."
    - name: "on_time_closure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_closure_date IS NOT NULL AND actual_closure_date <= required_end_date THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_closure_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of closed notifications resolved within the required end date. Measures quality response SLA compliance — directly linked to customer satisfaction and regulatory obligations."
    - name: "total_nonconforming_quantity"
      expr: SUM(CAST(nonconforming_quantity AS DOUBLE))
      comment: "Total quantity of nonconforming material identified across all quality notifications. Drives PPM calculation, scrap cost estimation, and containment scope assessment."
    - name: "avg_resolution_cycle_time_days"
      expr: AVG(DATEDIFF(actual_closure_date, created_timestamp))
      comment: "Average days from notification creation to formal closure. Measures quality response agility — a key operational efficiency and customer satisfaction metric."
    - name: "capa_required_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN capa_required = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of quality notifications requiring a formal CAPA. Measures the severity and systemic nature of quality issues — high rates indicate recurring or critical quality problems."
    - name: "regulatory_reportable_notifications"
      expr: COUNT(CASE WHEN regulatory_reportable = TRUE THEN 1 END)
      comment: "Number of quality notifications requiring regulatory authority notification. Tracks mandatory compliance reporting exposure — requires executive visibility and legal review."
    - name: "supplier_defect_notifications"
      expr: COUNT(CASE WHEN type = 'Q3' THEN 1 END)
      comment: "Number of supplier defect notifications (Q3 type). Tracks incoming quality failures attributable to suppliers — drives supplier development and qualification decisions."
$$;