-- Metric views for domain: quality | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_inspection_lot`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core quality inspection metrics tracking acceptance rates, defect rates, and inspection efficiency across lots"
  source: "`manufacturing_ecm`.`quality`.`inspection_lot`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where inspection occurred"
    - name: "inspection_type"
      expr: inspection_type
      comment: "Type of inspection performed (incoming, in-process, final)"
    - name: "inspection_stage"
      expr: inspection_stage
      comment: "Stage in production where inspection occurred"
    - name: "material_number"
      expr: material_number
      comment: "Material or part number being inspected"
    - name: "vendor_number"
      expr: vendor_number
      comment: "Supplier vendor number for incoming inspections"
    - name: "status"
      expr: status
      comment: "Current status of inspection lot"
    - name: "usage_decision_code"
      expr: usage_decision_code
      comment: "Final usage decision (accept, reject, rework)"
    - name: "inspection_start_month"
      expr: DATE_TRUNC('MONTH', inspection_start_date)
      comment: "Month when inspection started"
    - name: "is_first_article"
      expr: is_first_article_inspection
      comment: "Whether this is a first article inspection"
  measures:
    - name: "total_inspection_lots"
      expr: COUNT(1)
      comment: "Total number of inspection lots"
    - name: "total_lot_quantity"
      expr: SUM(CAST(lot_quantity AS DOUBLE))
      comment: "Total quantity inspected across all lots"
    - name: "total_accepted_quantity"
      expr: SUM(CAST(accepted_quantity AS DOUBLE))
      comment: "Total quantity accepted after inspection"
    - name: "total_nonconforming_quantity"
      expr: SUM(CAST(nonconforming_quantity AS DOUBLE))
      comment: "Total quantity identified as nonconforming"
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total quantity sent for rework"
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity scrapped"
    - name: "acceptance_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(accepted_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity accepted (key quality KPI)"
    - name: "defect_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(nonconforming_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity found nonconforming (key quality KPI)"
    - name: "rework_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(rework_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity requiring rework"
    - name: "scrap_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(scrap_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inspected quantity scrapped (cost impact KPI)"
    - name: "first_pass_yield_pct"
      expr: ROUND(100.0 * SUM(CAST(accepted_quantity AS DOUBLE)) / NULLIF(SUM(CAST(lot_quantity AS DOUBLE)), 0), 2)
      comment: "First pass yield - percentage accepted without rework (manufacturing efficiency KPI)"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_inspection_result`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Detailed inspection result metrics tracking process capability, conformance, and SPC violations"
  source: "`manufacturing_ecm`.`quality`.`inspection_result`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "material_number"
      expr: material_number
      comment: "Material or part number inspected"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where inspection occurred"
    - name: "inspection_stage"
      expr: inspection_stage
      comment: "Stage of inspection (incoming, in-process, final)"
    - name: "characteristic_type"
      expr: characteristic_type
      comment: "Type of characteristic measured (variable, attribute)"
    - name: "conformance_decision"
      expr: conformance_decision
      comment: "Conformance decision (pass, fail, conditional)"
    - name: "inspection_month"
      expr: DATE_TRUNC('MONTH', inspection_timestamp)
      comment: "Month when inspection was performed"
    - name: "spc_violation_flag"
      expr: spc_violation_flag
      comment: "Whether SPC control rule was violated"
    - name: "retest_flag"
      expr: retest_flag
      comment: "Whether this was a retest"
  measures:
    - name: "total_inspection_results"
      expr: COUNT(1)
      comment: "Total number of inspection results recorded"
    - name: "avg_cpk_index"
      expr: AVG(CAST(cpk_index AS DOUBLE))
      comment: "Average process capability index Cpk (key process capability KPI)"
    - name: "avg_cp_index"
      expr: AVG(CAST(cp_index AS DOUBLE))
      comment: "Average process capability index Cp"
    - name: "min_cpk_index"
      expr: MIN(CAST(cpk_index AS DOUBLE))
      comment: "Minimum Cpk observed (identifies worst-performing processes)"
    - name: "conforming_results"
      expr: COUNT(CASE WHEN conformance_decision = 'Pass' THEN 1 END)
      comment: "Number of conforming inspection results"
    - name: "nonconforming_results"
      expr: COUNT(CASE WHEN conformance_decision = 'Fail' THEN 1 END)
      comment: "Number of nonconforming inspection results"
    - name: "conformance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN conformance_decision = 'Pass' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of inspection results that conform to specifications (quality performance KPI)"
    - name: "spc_violation_count"
      expr: COUNT(CASE WHEN spc_violation_flag = TRUE THEN 1 END)
      comment: "Number of SPC control rule violations"
    - name: "spc_violation_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN spc_violation_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of results with SPC violations (process stability KPI)"
    - name: "retest_count"
      expr: COUNT(CASE WHEN retest_flag = TRUE THEN 1 END)
      comment: "Number of retests performed"
    - name: "retest_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN retest_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of results requiring retest (inspection efficiency KPI)"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_customer_complaint`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer complaint metrics tracking complaint volume, closure performance, and financial impact"
  source: "`manufacturing_ecm`.`quality`.`customer_complaint`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant code where issue originated"
    - name: "complaint_type"
      expr: complaint_type
      comment: "Type of customer complaint"
    - name: "defect_category"
      expr: defect_category
      comment: "Category of defect reported"
    - name: "priority"
      expr: priority
      comment: "Priority level of complaint"
    - name: "status"
      expr: status
      comment: "Current status of complaint"
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Root cause category identified"
    - name: "eight_d_status"
      expr: eight_d_status
      comment: "Status of 8D problem solving process"
    - name: "safety_related"
      expr: safety_related
      comment: "Whether complaint is safety-related"
    - name: "regulatory_reportable"
      expr: regulatory_reportable
      comment: "Whether complaint must be reported to regulators"
    - name: "received_month"
      expr: DATE_TRUNC('MONTH', received_date)
      comment: "Month complaint was received"
    - name: "country_code"
      expr: country_code
      comment: "Country where complaint originated"
  measures:
    - name: "total_complaints"
      expr: COUNT(1)
      comment: "Total number of customer complaints (key customer satisfaction KPI)"
    - name: "total_quantity_complained"
      expr: SUM(CAST(quantity_complained AS DOUBLE))
      comment: "Total quantity of units complained about"
    - name: "total_financial_impact"
      expr: SUM(CAST(financial_impact_amount AS DOUBLE))
      comment: "Total financial impact of complaints (cost of quality KPI)"
    - name: "avg_financial_impact_per_complaint"
      expr: AVG(CAST(financial_impact_amount AS DOUBLE))
      comment: "Average financial impact per complaint"
    - name: "closed_complaints"
      expr: COUNT(CASE WHEN status = 'Closed' THEN 1 END)
      comment: "Number of closed complaints"
    - name: "open_complaints"
      expr: COUNT(CASE WHEN status IN ('Open', 'In Progress') THEN 1 END)
      comment: "Number of open or in-progress complaints"
    - name: "closure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN status = 'Closed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of complaints closed (complaint resolution performance KPI)"
    - name: "safety_related_complaints"
      expr: COUNT(CASE WHEN safety_related = TRUE THEN 1 END)
      comment: "Number of safety-related complaints (critical quality KPI)"
    - name: "regulatory_reportable_complaints"
      expr: COUNT(CASE WHEN regulatory_reportable = TRUE THEN 1 END)
      comment: "Number of complaints requiring regulatory reporting (compliance KPI)"
    - name: "customer_approved_closures"
      expr: COUNT(CASE WHEN customer_approved_closure = TRUE THEN 1 END)
      comment: "Number of closures approved by customer"
    - name: "customer_approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN customer_approved_closure = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'Closed' THEN 1 END), 0), 2)
      comment: "Percentage of closed complaints approved by customer (customer satisfaction KPI)"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_quality_capa`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Corrective and Preventive Action metrics tracking CAPA effectiveness, closure performance, and recurrence"
  source: "`manufacturing_ecm`.`quality`.`quality_capa`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant where CAPA was initiated"
    - name: "type"
      expr: type
      comment: "Type of action (corrective, preventive)"
    - name: "status"
      expr: status
      comment: "Current status of CAPA"
    - name: "priority"
      expr: priority
      comment: "Priority level of CAPA"
    - name: "source_type"
      expr: source_type
      comment: "Source that triggered CAPA (audit, complaint, NCR, etc.)"
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Category of root cause identified"
    - name: "defect_category"
      expr: defect_category
      comment: "Category of defect addressed"
    - name: "effectiveness_rating"
      expr: effectiveness_rating
      comment: "Effectiveness rating of CAPA"
    - name: "recurrence_flag"
      expr: recurrence_flag
      comment: "Whether this is a recurring issue"
    - name: "regulatory_reporting_required"
      expr: regulatory_reporting_required
      comment: "Whether regulatory reporting is required"
    - name: "initiated_month"
      expr: DATE_TRUNC('MONTH', initiated_date)
      comment: "Month CAPA was initiated"
    - name: "action_owner_department"
      expr: action_owner_department
      comment: "Department responsible for CAPA"
  measures:
    - name: "total_capas"
      expr: COUNT(1)
      comment: "Total number of CAPAs (quality system activity KPI)"
    - name: "closed_capas"
      expr: COUNT(CASE WHEN status = 'Closed' THEN 1 END)
      comment: "Number of closed CAPAs"
    - name: "open_capas"
      expr: COUNT(CASE WHEN status IN ('Open', 'In Progress') THEN 1 END)
      comment: "Number of open or in-progress CAPAs"
    - name: "overdue_capas"
      expr: COUNT(CASE WHEN status != 'Closed' AND target_closure_date < CURRENT_DATE THEN 1 END)
      comment: "Number of CAPAs past target closure date (quality system performance KPI)"
    - name: "closure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN status = 'Closed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of CAPAs closed (CAPA effectiveness KPI)"
    - name: "recurrence_count"
      expr: COUNT(CASE WHEN recurrence_flag = TRUE THEN 1 END)
      comment: "Number of recurring CAPAs"
    - name: "recurrence_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN recurrence_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of CAPAs that are recurrences (root cause effectiveness KPI)"
    - name: "effective_capas"
      expr: COUNT(CASE WHEN effectiveness_rating IN ('Effective', 'Highly Effective') THEN 1 END)
      comment: "Number of CAPAs rated as effective"
    - name: "effectiveness_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN effectiveness_rating IN ('Effective', 'Highly Effective') THEN 1 END) / NULLIF(COUNT(CASE WHEN status = 'Closed' THEN 1 END), 0), 2)
      comment: "Percentage of closed CAPAs rated effective (CAPA quality KPI)"
    - name: "regulatory_reportable_capas"
      expr: COUNT(CASE WHEN regulatory_reporting_required = TRUE THEN 1 END)
      comment: "Number of CAPAs requiring regulatory reporting (compliance KPI)"
    - name: "customer_notification_required_count"
      expr: COUNT(CASE WHEN customer_notification_required = TRUE THEN 1 END)
      comment: "Number of CAPAs requiring customer notification"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_scrap_rework`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Scrap and rework metrics tracking cost of quality, rework effectiveness, and defect patterns"
  source: "`manufacturing_ecm`.`quality`.`scrap_rework_transaction`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant where scrap/rework occurred"
    - name: "transaction_type"
      expr: transaction_type
      comment: "Type of transaction (scrap, rework)"
    - name: "disposition"
      expr: disposition
      comment: "Disposition decision (scrap, rework, use-as-is)"
    - name: "detection_stage"
      expr: detection_stage
      comment: "Stage where defect was detected"
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Root cause category of defect"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where defect occurred"
    - name: "part_number"
      expr: part_number
      comment: "Part number affected"
    - name: "transaction_month"
      expr: DATE_TRUNC('MONTH', transaction_date)
      comment: "Month of transaction"
    - name: "shift_code"
      expr: shift_code
      comment: "Shift when defect occurred"
    - name: "rework_passed_inspection"
      expr: rework_passed_inspection
      comment: "Whether reworked parts passed inspection"
  measures:
    - name: "total_transactions"
      expr: COUNT(1)
      comment: "Total number of scrap/rework transactions"
    - name: "total_quantity_affected"
      expr: SUM(CAST(quantity_affected AS DOUBLE))
      comment: "Total quantity affected by defects"
    - name: "total_quantity_scrapped"
      expr: SUM(CAST(quantity_scrapped AS DOUBLE))
      comment: "Total quantity scrapped"
    - name: "total_quantity_reworked"
      expr: SUM(CAST(quantity_reworked AS DOUBLE))
      comment: "Total quantity reworked"
    - name: "total_scrap_cost"
      expr: SUM(CAST(scrap_cost AS DOUBLE))
      comment: "Total cost of scrapped material (cost of quality KPI)"
    - name: "total_rework_cost"
      expr: SUM(CAST(rework_cost AS DOUBLE))
      comment: "Total cost of rework (cost of quality KPI)"
    - name: "total_quality_cost"
      expr: SUM((CAST(scrap_cost AS DOUBLE)) + (CAST(rework_cost AS DOUBLE)))
      comment: "Total cost of quality (scrap + rework) - key financial KPI"
    - name: "total_rework_labor_hours"
      expr: SUM(CAST(rework_labor_hours AS DOUBLE))
      comment: "Total labor hours spent on rework"
    - name: "avg_rework_cost_per_unit"
      expr: AVG(CAST(rework_cost AS DOUBLE))
      comment: "Average rework cost per transaction"
    - name: "avg_scrap_cost_per_unit"
      expr: AVG(CAST(scrap_cost AS DOUBLE))
      comment: "Average scrap cost per transaction"
    - name: "scrap_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(quantity_scrapped AS DOUBLE)) / NULLIF(SUM(CAST(quantity_affected AS DOUBLE)), 0), 2)
      comment: "Percentage of affected quantity that was scrapped (quality performance KPI)"
    - name: "rework_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(quantity_reworked AS DOUBLE)) / NULLIF(SUM(CAST(quantity_affected AS DOUBLE)), 0), 2)
      comment: "Percentage of affected quantity that was reworked"
    - name: "rework_success_count"
      expr: COUNT(CASE WHEN rework_passed_inspection = TRUE THEN 1 END)
      comment: "Number of successful rework operations"
    - name: "rework_success_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN rework_passed_inspection = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN transaction_type = 'Rework' THEN 1 END), 0), 2)
      comment: "Percentage of rework that passed inspection (rework effectiveness KPI)"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_supplier_quality`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Supplier quality event metrics tracking supplier performance, defect rates, and cost impact"
  source: "`manufacturing_ecm`.`quality`.`supplier_quality_event`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant receiving supplier material"
    - name: "event_type"
      expr: event_type
      comment: "Type of supplier quality event"
    - name: "severity"
      expr: severity
      comment: "Severity level of event"
    - name: "status"
      expr: status
      comment: "Current status of event"
    - name: "defect_category"
      expr: defect_category
      comment: "Category of defect"
    - name: "detection_stage"
      expr: detection_stage
      comment: "Stage where defect was detected"
    - name: "disposition"
      expr: disposition
      comment: "Disposition decision for nonconforming material"
    - name: "containment_status"
      expr: containment_status
      comment: "Status of containment actions"
    - name: "eight_d_submission_status"
      expr: eight_d_submission_status
      comment: "Status of 8D report submission"
    - name: "supplier_country_code"
      expr: supplier_country_code
      comment: "Country of supplier"
    - name: "detection_month"
      expr: DATE_TRUNC('MONTH', detection_date)
      comment: "Month defect was detected"
    - name: "chargeback_flag"
      expr: chargeback_flag
      comment: "Whether chargeback was issued to supplier"
    - name: "regulatory_reportable_flag"
      expr: regulatory_reportable_flag
      comment: "Whether event is regulatory reportable"
  measures:
    - name: "total_supplier_events"
      expr: COUNT(1)
      comment: "Total number of supplier quality events (supplier performance KPI)"
    - name: "total_nonconforming_quantity"
      expr: SUM(CAST(nonconforming_quantity AS DOUBLE))
      comment: "Total quantity of nonconforming material from suppliers"
    - name: "total_received_quantity"
      expr: SUM(CAST(total_received_quantity AS DOUBLE))
      comment: "Total quantity received from suppliers"
    - name: "total_nonconformance_cost"
      expr: SUM(CAST(nonconformance_cost AS DOUBLE))
      comment: "Total cost of supplier nonconformances (supplier cost of quality KPI)"
    - name: "avg_nonconformance_cost"
      expr: AVG(CAST(nonconformance_cost AS DOUBLE))
      comment: "Average cost per supplier quality event"
    - name: "supplier_defect_rate_ppm"
      expr: ROUND(1000000.0 * SUM(CAST(nonconforming_quantity AS DOUBLE)) / NULLIF(SUM(CAST(total_received_quantity AS DOUBLE)), 0), 2)
      comment: "Supplier defect rate in parts per million (key supplier quality KPI)"
    - name: "closed_events"
      expr: COUNT(CASE WHEN status = 'Closed' THEN 1 END)
      comment: "Number of closed supplier quality events"
    - name: "open_events"
      expr: COUNT(CASE WHEN status IN ('Open', 'In Progress') THEN 1 END)
      comment: "Number of open supplier quality events"
    - name: "closure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN status = 'Closed' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of supplier events closed (supplier issue resolution KPI)"
    - name: "chargeback_count"
      expr: COUNT(CASE WHEN chargeback_flag = TRUE THEN 1 END)
      comment: "Number of events with supplier chargeback"
    - name: "chargeback_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN chargeback_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of events resulting in chargeback (supplier accountability KPI)"
    - name: "regulatory_reportable_events"
      expr: COUNT(CASE WHEN regulatory_reportable_flag = TRUE THEN 1 END)
      comment: "Number of regulatory reportable supplier events (compliance KPI)"
    - name: "eight_d_submitted_count"
      expr: COUNT(CASE WHEN eight_d_submission_status = 'Submitted' THEN 1 END)
      comment: "Number of events with 8D report submitted"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_audit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quality audit metrics tracking audit findings, nonconformances, and audit effectiveness"
  source: "`manufacturing_ecm`.`quality`.`audit`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant where audit was conducted"
    - name: "type"
      expr: type
      comment: "Type of audit (internal, external, certification, supplier)"
    - name: "category"
      expr: category
      comment: "Audit category"
    - name: "standard"
      expr: standard
      comment: "Standard audited against (ISO 9001, IATF 16949, etc.)"
    - name: "overall_result"
      expr: overall_result
      comment: "Overall audit result (pass, fail, conditional)"
    - name: "process_area"
      expr: process_area
      comment: "Process area audited"
    - name: "department_code"
      expr: department_code
      comment: "Department audited"
    - name: "certification_body"
      expr: certification_body
      comment: "Certification body conducting audit"
    - name: "audit_month"
      expr: DATE_TRUNC('MONTH', actual_start_date)
      comment: "Month audit was conducted"
    - name: "capa_required_flag"
      expr: capa_required_flag
      comment: "Whether CAPA is required from audit"
  measures:
    - name: "total_audits"
      expr: COUNT(1)
      comment: "Total number of audits conducted (audit program activity KPI)"
    - name: "passed_audits"
      expr: COUNT(CASE WHEN overall_result = 'Pass' THEN 1 END)
      comment: "Number of audits passed"
    - name: "failed_audits"
      expr: COUNT(CASE WHEN overall_result = 'Fail' THEN 1 END)
      comment: "Number of audits failed"
    - name: "audit_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN overall_result = 'Pass' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of audits passed (quality system performance KPI)"
    - name: "total_findings"
      expr: SUM(CAST(total_findings_count AS DOUBLE))
      comment: "Total number of audit findings"
    - name: "total_major_nc"
      expr: SUM(CAST(major_nc_count AS DOUBLE))
      comment: "Total number of major nonconformances (critical quality system KPI)"
    - name: "total_minor_nc"
      expr: SUM(CAST(minor_nc_count AS DOUBLE))
      comment: "Total number of minor nonconformances"
    - name: "total_observations"
      expr: SUM(CAST(observation_count AS DOUBLE))
      comment: "Total number of observations"
    - name: "avg_findings_per_audit"
      expr: AVG(CAST(total_findings_count AS DOUBLE))
      comment: "Average number of findings per audit"
    - name: "avg_major_nc_per_audit"
      expr: AVG(CAST(major_nc_count AS DOUBLE))
      comment: "Average major nonconformances per audit (audit severity KPI)"
    - name: "open_findings"
      expr: SUM(CAST(open_findings_count AS DOUBLE))
      comment: "Total number of open audit findings"
    - name: "audits_requiring_capa"
      expr: COUNT(CASE WHEN capa_required_flag = TRUE THEN 1 END)
      comment: "Number of audits requiring CAPA"
    - name: "capa_required_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN capa_required_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of audits requiring CAPA (audit impact KPI)"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_ppap_submission`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "PPAP submission metrics tracking approval rates, completeness, and process capability"
  source: "`manufacturing_ecm`.`quality`.`ppap_submission`"
  dimensions:
    - name: "approval_status"
      expr: approval_status
      comment: "PPAP approval status"
    - name: "status"
      expr: status
      comment: "Current status of PPAP submission"
    - name: "submission_level"
      expr: submission_level
      comment: "PPAP submission level (1-5)"
    - name: "submission_reason"
      expr: submission_reason
      comment: "Reason for PPAP submission"
    - name: "regulatory_compliance_status"
      expr: regulatory_compliance_status
      comment: "Regulatory compliance status"
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "Country of origin for parts"
    - name: "supplier_code"
      expr: supplier_code
      comment: "Supplier code"
    - name: "submission_month"
      expr: DATE_TRUNC('MONTH', submission_date)
      comment: "Month of PPAP submission"
  measures:
    - name: "total_ppap_submissions"
      expr: COUNT(1)
      comment: "Total number of PPAP submissions"
    - name: "approved_submissions"
      expr: COUNT(CASE WHEN approval_status = 'Approved' THEN 1 END)
      comment: "Number of approved PPAP submissions"
    - name: "rejected_submissions"
      expr: COUNT(CASE WHEN approval_status = 'Rejected' THEN 1 END)
      comment: "Number of rejected PPAP submissions"
    - name: "ppap_approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN approval_status = 'Approved' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of PPAP submissions approved (new product launch quality KPI)"
    - name: "avg_ppap_completeness_pct"
      expr: AVG(CAST(overall_ppap_completeness_pct AS DOUBLE))
      comment: "Average PPAP completeness percentage (PPAP readiness KPI)"
    - name: "avg_min_cpk"
      expr: AVG(CAST(min_cpk_value AS DOUBLE))
      comment: "Average minimum Cpk across PPAP submissions (process capability KPI)"
    - name: "submissions_with_fai_complete"
      expr: COUNT(CASE WHEN fai_complete = TRUE THEN 1 END)
      comment: "Number of submissions with FAI complete"
    - name: "submissions_with_msa_complete"
      expr: COUNT(CASE WHEN msa_complete = TRUE THEN 1 END)
      comment: "Number of submissions with MSA complete"
    - name: "submissions_with_pfmea_complete"
      expr: COUNT(CASE WHEN pfmea_complete = TRUE THEN 1 END)
      comment: "Number of submissions with PFMEA complete"
    - name: "submissions_with_control_plan_complete"
      expr: COUNT(CASE WHEN control_plan_complete = TRUE THEN 1 END)
      comment: "Number of submissions with control plan complete"
    - name: "fai_completion_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN fai_complete = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of submissions with FAI complete"
    - name: "msa_completion_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN msa_complete = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of submissions with MSA complete"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_gauge_calibration`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Gauge calibration metrics tracking calibration compliance, out-of-tolerance rates, and measurement system health"
  source: "`manufacturing_ecm`.`quality`.`gauge_calibration`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant where gauge is located"
    - name: "calibration_result"
      expr: calibration_result
      comment: "Result of calibration (pass, fail, conditional)"
    - name: "calibration_lab_type"
      expr: calibration_lab_type
      comment: "Type of calibration lab (internal, external)"
    - name: "as_found_condition"
      expr: as_found_condition
      comment: "Condition of gauge as found (in-tolerance, out-of-tolerance)"
    - name: "as_left_condition"
      expr: as_left_condition
      comment: "Condition of gauge after calibration"
    - name: "adjustment_performed"
      expr: adjustment_performed
      comment: "Whether adjustment was performed"
    - name: "out_of_service_flag"
      expr: out_of_service_flag
      comment: "Whether gauge was taken out of service"
    - name: "recall_required_flag"
      expr: recall_required_flag
      comment: "Whether measurement recall is required"
    - name: "calibration_month"
      expr: DATE_TRUNC('MONTH', certificate_issue_date)
      comment: "Month of calibration"
    - name: "department_code"
      expr: department_code
      comment: "Department owning gauge"
  measures:
    - name: "total_calibrations"
      expr: COUNT(1)
      comment: "Total number of gauge calibrations performed"
    - name: "passed_calibrations"
      expr: COUNT(CASE WHEN calibration_result = 'Pass' THEN 1 END)
      comment: "Number of calibrations passed"
    - name: "failed_calibrations"
      expr: COUNT(CASE WHEN calibration_result = 'Fail' THEN 1 END)
      comment: "Number of calibrations failed"
    - name: "calibration_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN calibration_result = 'Pass' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibrations passed (measurement system health KPI)"
    - name: "out_of_tolerance_count"
      expr: COUNT(CASE WHEN as_found_condition = 'Out-of-Tolerance' THEN 1 END)
      comment: "Number of gauges found out of tolerance"
    - name: "out_of_tolerance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN as_found_condition = 'Out-of-Tolerance' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of gauges found out of tolerance (measurement risk KPI)"
    - name: "adjustments_performed_count"
      expr: COUNT(CASE WHEN adjustment_performed = TRUE THEN 1 END)
      comment: "Number of calibrations requiring adjustment"
    - name: "adjustment_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN adjustment_performed = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibrations requiring adjustment"
    - name: "out_of_service_count"
      expr: COUNT(CASE WHEN out_of_service_flag = TRUE THEN 1 END)
      comment: "Number of gauges taken out of service"
    - name: "recall_required_count"
      expr: COUNT(CASE WHEN recall_required_flag = TRUE THEN 1 END)
      comment: "Number of calibrations requiring measurement recall (critical quality risk KPI)"
    - name: "recall_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN recall_required_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of calibrations requiring recall (measurement system risk KPI)"
    - name: "avg_measurement_uncertainty"
      expr: AVG(CAST(measurement_uncertainty AS DOUBLE))
      comment: "Average measurement uncertainty"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_msa_study`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Measurement System Analysis metrics tracking GRR performance and measurement capability"
  source: "`manufacturing_ecm`.`quality`.`msa_study`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant where MSA was conducted"
    - name: "study_type"
      expr: study_type
      comment: "Type of MSA study (GRR, bias, linearity, stability)"
    - name: "analysis_method"
      expr: analysis_method
      comment: "Analysis method used (ANOVA, range, etc.)"
    - name: "acceptability_decision"
      expr: acceptability_decision
      comment: "Acceptability decision (acceptable, marginal, unacceptable)"
    - name: "status"
      expr: status
      comment: "Status of MSA study"
    - name: "restudy_required"
      expr: restudy_required
      comment: "Whether restudy is required"
    - name: "study_month"
      expr: DATE_TRUNC('MONTH', study_date)
      comment: "Month MSA was conducted"
    - name: "part_number"
      expr: part_number
      comment: "Part number studied"
  measures:
    - name: "total_msa_studies"
      expr: COUNT(1)
      comment: "Total number of MSA studies conducted"
    - name: "acceptable_studies"
      expr: COUNT(CASE WHEN acceptability_decision = 'Acceptable' THEN 1 END)
      comment: "Number of acceptable MSA studies"
    - name: "unacceptable_studies"
      expr: COUNT(CASE WHEN acceptability_decision = 'Unacceptable' THEN 1 END)
      comment: "Number of unacceptable MSA studies"
    - name: "msa_acceptance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN acceptability_decision = 'Acceptable' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of MSA studies acceptable (measurement system capability KPI)"
    - name: "avg_grr_percent"
      expr: AVG(CAST(grr_percent AS DOUBLE))
      comment: "Average Gage R&R percentage (key measurement system KPI)"
    - name: "avg_repeatability_percent"
      expr: AVG(CAST(repeatability_percent AS DOUBLE))
      comment: "Average repeatability percentage"
    - name: "avg_reproducibility_percent"
      expr: AVG(CAST(reproducibility_percent AS DOUBLE))
      comment: "Average reproducibility percentage"
    - name: "avg_part_variation_percent"
      expr: AVG(CAST(part_variation_percent AS DOUBLE))
      comment: "Average part variation percentage"
    - name: "avg_bias_percent"
      expr: AVG(CAST(bias_percent AS DOUBLE))
      comment: "Average bias percentage"
    - name: "studies_requiring_restudy"
      expr: COUNT(CASE WHEN restudy_required = TRUE THEN 1 END)
      comment: "Number of studies requiring restudy"
    - name: "restudy_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN restudy_required = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of studies requiring restudy (measurement system improvement need KPI)"
    - name: "avg_linearity_value"
      expr: AVG(CAST(linearity_value AS DOUBLE))
      comment: "Average linearity value"
    - name: "avg_stability_range"
      expr: AVG(CAST(stability_range AS DOUBLE))
      comment: "Average stability range"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`quality_apqp_project`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "APQP project metrics tracking new product launch readiness, deliverable completion, and PPAP status"
  source: "`manufacturing_ecm`.`quality`.`apqp_project`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant for APQP project"
    - name: "current_phase"
      expr: current_phase
      comment: "Current APQP phase"
    - name: "status"
      expr: status
      comment: "Project status"
    - name: "priority"
      expr: priority
      comment: "Project priority"
    - name: "risk_level"
      expr: risk_level
      comment: "Risk level of project"
    - name: "ppap_status"
      expr: ppap_status
      comment: "PPAP status"
    - name: "customer_approval_status"
      expr: customer_approval_status
      comment: "Customer approval status"
    - name: "dfmea_status"
      expr: dfmea_status
      comment: "Design FMEA status"
    - name: "pfmea_status"
      expr: pfmea_status
      comment: "Process FMEA status"
    - name: "control_plan_status"
      expr: control_plan_status
      comment: "Control plan status"
    - name: "fai_status"
      expr: fai_status
      comment: "First article inspection status"
    - name: "project_type"
      expr: project_type
      comment: "Type of APQP project"
    - name: "launch_month"
      expr: DATE_TRUNC('MONTH', target_launch_date)
      comment: "Target launch month"
  measures:
    - name: "total_apqp_projects"
      expr: COUNT(1)
      comment: "Total number of APQP projects (new product launch activity KPI)"
    - name: "active_projects"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of active APQP projects"
    - name: "completed_projects"
      expr: COUNT(CASE WHEN status = 'Completed' THEN 1 END)
      comment: "Number of completed APQP projects"
    - name: "on_time_launches"
      expr: COUNT(CASE WHEN actual_launch_date <= target_launch_date THEN 1 END)
      comment: "Number of on-time product launches"
    - name: "on_time_launch_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_launch_date <= target_launch_date THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_launch_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of launches on time (launch execution KPI)"
    - name: "avg_deliverables_completed"
      expr: AVG(CAST(deliverables_completed AS DOUBLE))
      comment: "Average number of deliverables completed"
    - name: "avg_deliverables_total"
      expr: AVG(CAST(deliverables_total AS DOUBLE))
      comment: "Average total deliverables per project"
    - name: "avg_open_issues"
      expr: AVG(CAST(open_issues_count AS DOUBLE))
      comment: "Average number of open issues per project"
    - name: "ppap_approved_count"
      expr: COUNT(CASE WHEN ppap_status = 'Approved' THEN 1 END)
      comment: "Number of projects with PPAP approved"
    - name: "ppap_approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN ppap_status = 'Approved' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of projects with PPAP approved (launch readiness KPI)"
    - name: "customer_approved_count"
      expr: COUNT(CASE WHEN customer_approval_status = 'Approved' THEN 1 END)
      comment: "Number of projects with customer approval"
    - name: "customer_approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN customer_approval_status = 'Approved' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of projects with customer approval (customer satisfaction KPI)"
    - name: "high_risk_projects"
      expr: COUNT(CASE WHEN risk_level = 'High' THEN 1 END)
      comment: "Number of high-risk APQP projects (risk management KPI)"
$$;