-- Metric views for domain: workforce | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_employee`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core employee workforce metrics including headcount, tenure, and compensation analytics"
  source: "`manufacturing_ecm`.`workforce`.`employee`"
  dimensions:
    - name: "employment_status"
      expr: employment_status
      comment: "Current employment status (Active, Terminated, Leave, etc.)"
    - name: "gender"
      expr: gender
      comment: "Employee gender for diversity analytics"
    - name: "work_location_country"
      expr: work_location_country
      comment: "Country where employee is located"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or facility code"
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "Cost center for financial allocation"
    - name: "department_code"
      expr: department_code
      comment: "Department code for organizational grouping"
    - name: "union_member"
      expr: union_member
      comment: "Whether employee is a union member"
    - name: "highest_education_level"
      expr: highest_education_level
      comment: "Highest education level attained"
    - name: "hire_year"
      expr: YEAR(hire_date)
      comment: "Year employee was hired"
    - name: "termination_reason"
      expr: termination_reason
      comment: "Reason for termination if applicable"
  measures:
    - name: "total_headcount"
      expr: COUNT(DISTINCT employee_id)
      comment: "Total unique employee count - primary workforce sizing metric"
    - name: "total_base_salary"
      expr: SUM(CAST(base_salary_amount AS DOUBLE))
      comment: "Total base salary across all employees - key compensation cost metric"
    - name: "avg_base_salary"
      expr: AVG(CAST(base_salary_amount AS DOUBLE))
      comment: "Average base salary per employee - compensation benchmarking metric"
    - name: "avg_tenure_days"
      expr: AVG(DATEDIFF(COALESCE(termination_date, CURRENT_DATE()), hire_date))
      comment: "Average employee tenure in days - retention and experience metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_absence`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Employee absence and leave metrics for workforce availability and productivity analysis"
  source: "`manufacturing_ecm`.`workforce`.`absence_record`"
  dimensions:
    - name: "absence_type_code"
      expr: absence_type_code
      comment: "Type of absence (sick, vacation, FMLA, etc.)"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of absence request"
    - name: "country_code"
      expr: country_code
      comment: "Country where absence occurred"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "Cost center for absence tracking"
    - name: "fmla_qualifying"
      expr: fmla_qualifying
      comment: "Whether absence qualifies under FMLA"
    - name: "production_impact_flag"
      expr: production_impact_flag
      comment: "Whether absence impacted production"
    - name: "absence_month"
      expr: DATE_TRUNC('MONTH', start_date)
      comment: "Month when absence started"
  measures:
    - name: "total_absence_records"
      expr: COUNT(DISTINCT absence_record_id)
      comment: "Total number of absence records - volume metric for workforce availability"
    - name: "total_absence_hours"
      expr: SUM(CAST(absence_hours AS DOUBLE))
      comment: "Total hours of absence - key productivity loss metric"
    - name: "avg_absence_hours"
      expr: AVG(CAST(absence_hours AS DOUBLE))
      comment: "Average hours per absence event - absence severity metric"
    - name: "total_working_days_absent"
      expr: SUM(CAST(working_days_absent AS DOUBLE))
      comment: "Total working days lost to absence - operational impact metric"
    - name: "total_fmla_hours"
      expr: SUM(CAST(fmla_hours_used AS DOUBLE))
      comment: "Total FMLA hours used - compliance and leave management metric"
    - name: "absence_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT absence_record_id) / NULLIF(COUNT(DISTINCT employee_id), 0), 2)
      comment: "Absence rate as percentage of employees - workforce reliability metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_labor_cost`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Labor cost and productivity metrics for manufacturing operations and financial planning"
  source: "`manufacturing_ecm`.`workforce`.`labor_cost_entry`"
  dimensions:
    - name: "country_code"
      expr: country_code
      comment: "Country where labor cost was incurred"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "company_code"
      expr: company_code
      comment: "Company code for financial consolidation"
    - name: "activity_type"
      expr: activity_type
      comment: "Type of labor activity performed"
    - name: "pay_code"
      expr: pay_code
      comment: "Pay code for labor classification"
    - name: "posting_status"
      expr: posting_status
      comment: "Financial posting status"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period for financial reporting"
    - name: "work_month"
      expr: DATE_TRUNC('MONTH', work_date)
      comment: "Month when work was performed"
  measures:
    - name: "total_labor_cost"
      expr: SUM(CAST(total_labor_cost AS DOUBLE))
      comment: "Total labor cost - primary workforce expense metric for financial planning"
    - name: "total_hours_worked"
      expr: SUM(CAST(hours_worked AS DOUBLE))
      comment: "Total hours worked - productivity capacity metric"
    - name: "total_overtime_hours"
      expr: SUM(CAST(overtime_hours AS DOUBLE))
      comment: "Total overtime hours - operational efficiency and cost control metric"
    - name: "avg_cost_rate"
      expr: AVG(CAST(actual_cost_rate AS DOUBLE))
      comment: "Average labor cost rate per hour - cost benchmarking metric"
    - name: "total_burden_cost"
      expr: SUM(CAST(burden_cost_amount AS DOUBLE))
      comment: "Total burden cost (benefits, taxes, overhead) - full labor cost metric"
    - name: "labor_cost_per_hour"
      expr: ROUND(SUM(CAST(total_labor_cost AS DOUBLE)) / NULLIF(SUM(CAST(hours_worked AS DOUBLE)), 0), 2)
      comment: "Labor cost per hour worked - efficiency and cost control KPI"
    - name: "overtime_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(overtime_hours AS DOUBLE)) / NULLIF(SUM(CAST(hours_worked AS DOUBLE)), 0), 2)
      comment: "Overtime as percentage of total hours - operational efficiency metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_payroll`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Payroll and compensation metrics for workforce cost management and compliance"
  source: "`manufacturing_ecm`.`workforce`.`payroll_result`"
  dimensions:
    - name: "country_code"
      expr: country_code
      comment: "Country for payroll processing"
    - name: "company_code"
      expr: company_code
      comment: "Company code for financial consolidation"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "Cost center for expense allocation"
    - name: "payroll_area"
      expr: payroll_area
      comment: "Payroll processing area"
    - name: "payment_method"
      expr: payment_method
      comment: "Method of payment (direct deposit, check, etc.)"
    - name: "run_type"
      expr: run_type
      comment: "Type of payroll run (regular, off-cycle, etc.)"
    - name: "pay_period_month"
      expr: DATE_TRUNC('MONTH', pay_period_start_date)
      comment: "Month of pay period"
  measures:
    - name: "total_gross_pay"
      expr: SUM(CAST(gross_pay_amount AS DOUBLE))
      comment: "Total gross pay - primary compensation cost metric"
    - name: "total_net_pay"
      expr: SUM(CAST(net_pay_amount AS DOUBLE))
      comment: "Total net pay after deductions - actual cash outflow metric"
    - name: "total_deductions"
      expr: SUM(CAST(total_deductions_amount AS DOUBLE))
      comment: "Total deductions from gross pay - compliance and benefits metric"
    - name: "total_employer_taxes"
      expr: SUM(CAST(employer_tax_contribution_amount AS DOUBLE))
      comment: "Total employer tax contributions - full labor cost metric"
    - name: "total_employer_benefits"
      expr: SUM(CAST(employer_benefits_contribution_amount AS DOUBLE))
      comment: "Total employer benefits contributions - full labor cost metric"
    - name: "total_overtime_pay"
      expr: SUM(CAST(overtime_pay_amount AS DOUBLE))
      comment: "Total overtime pay - operational efficiency and cost metric"
    - name: "total_regular_hours"
      expr: SUM(CAST(regular_hours_paid AS DOUBLE))
      comment: "Total regular hours paid - workforce capacity metric"
    - name: "total_overtime_hours"
      expr: SUM(CAST(overtime_hours_paid AS DOUBLE))
      comment: "Total overtime hours paid - operational efficiency metric"
    - name: "avg_gross_pay"
      expr: AVG(CAST(gross_pay_amount AS DOUBLE))
      comment: "Average gross pay per employee - compensation benchmarking metric"
    - name: "total_labor_burden"
      expr: SUM((CAST(employer_tax_contribution_amount AS DOUBLE)) + (CAST(employer_benefits_contribution_amount AS DOUBLE)))
      comment: "Total employer burden (taxes + benefits) - full labor cost metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_training`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Training effectiveness and compliance metrics for workforce development and regulatory adherence"
  source: "`manufacturing_ecm`.`workforce`.`training_record`"
  dimensions:
    - name: "training_type"
      expr: training_type
      comment: "Type of training (safety, technical, compliance, etc.)"
    - name: "delivery_method"
      expr: delivery_method
      comment: "Training delivery method (classroom, online, on-the-job, etc.)"
    - name: "status"
      expr: status
      comment: "Training record status (completed, in-progress, failed, etc.)"
    - name: "pass_fail_result"
      expr: pass_fail_result
      comment: "Pass or fail result for training"
    - name: "country_code"
      expr: country_code
      comment: "Country where training occurred"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "Cost center for training expense allocation"
    - name: "completion_month"
      expr: DATE_TRUNC('MONTH', completion_date)
      comment: "Month when training was completed"
  measures:
    - name: "total_training_records"
      expr: COUNT(DISTINCT training_record_id)
      comment: "Total training records - volume metric for workforce development"
    - name: "total_training_cost"
      expr: SUM(CAST(training_cost_amount AS DOUBLE))
      comment: "Total training cost - workforce development investment metric"
    - name: "avg_training_cost"
      expr: AVG(CAST(training_cost_amount AS DOUBLE))
      comment: "Average cost per training - cost efficiency metric"
    - name: "avg_assessment_score"
      expr: AVG(CAST(assessment_score AS DOUBLE))
      comment: "Average assessment score - training effectiveness metric"
    - name: "training_completion_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN status = 'Completed' THEN training_record_id END) / NULLIF(COUNT(DISTINCT training_record_id), 0), 2)
      comment: "Training completion rate - workforce development effectiveness KPI"
    - name: "training_pass_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN pass_fail_result = 'Pass' THEN training_record_id END) / NULLIF(COUNT(DISTINCT CASE WHEN pass_fail_result IN ('Pass', 'Fail') THEN training_record_id END), 0), 2)
      comment: "Training pass rate - training quality and effectiveness metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_overtime_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Overtime request and approval metrics for operational planning and cost control"
  source: "`manufacturing_ecm`.`workforce`.`overtime_request`"
  dimensions:
    - name: "overall_status"
      expr: overall_status
      comment: "Overall status of overtime request"
    - name: "reason_code"
      expr: reason_code
      comment: "Reason code for overtime request"
    - name: "country_code"
      expr: country_code
      comment: "Country where overtime is requested"
    - name: "site_code"
      expr: site_code
      comment: "Site or facility code"
    - name: "supervisor_approval_status"
      expr: supervisor_approval_status
      comment: "Supervisor approval status"
    - name: "hr_approval_status"
      expr: hr_approval_status
      comment: "HR approval status"
    - name: "is_regulatory_compliant"
      expr: is_regulatory_compliant
      comment: "Whether request is regulatory compliant"
    - name: "request_month"
      expr: DATE_TRUNC('MONTH', request_date)
      comment: "Month when overtime was requested"
  measures:
    - name: "total_overtime_requests"
      expr: COUNT(DISTINCT overtime_request_id)
      comment: "Total overtime requests - operational demand metric"
    - name: "total_requested_hours"
      expr: SUM(CAST(requested_hours AS DOUBLE))
      comment: "Total requested overtime hours - capacity planning metric"
    - name: "total_approved_hours"
      expr: SUM(CAST(approved_hours AS DOUBLE))
      comment: "Total approved overtime hours - operational capacity metric"
    - name: "total_actual_hours"
      expr: SUM(CAST(actual_hours_worked AS DOUBLE))
      comment: "Total actual overtime hours worked - execution metric"
    - name: "total_estimated_cost"
      expr: SUM(CAST(estimated_labor_cost AS DOUBLE))
      comment: "Total estimated overtime cost - budget planning metric"
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_labor_cost AS DOUBLE))
      comment: "Total actual overtime cost - cost control metric"
    - name: "approval_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(approved_hours AS DOUBLE)) / NULLIF(SUM(CAST(requested_hours AS DOUBLE)), 0), 2)
      comment: "Overtime approval rate - operational efficiency and control metric"
    - name: "execution_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_hours_worked AS DOUBLE)) / NULLIF(SUM(CAST(approved_hours AS DOUBLE)), 0), 2)
      comment: "Overtime execution rate - planning accuracy metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_performance_review`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Employee performance and talent management metrics for workforce development and succession planning"
  source: "`manufacturing_ecm`.`workforce`.`performance_review`"
  dimensions:
    - name: "overall_rating"
      expr: overall_rating
      comment: "Overall performance rating"
    - name: "review_status"
      expr: review_status
      comment: "Status of performance review"
    - name: "review_cycle_type"
      expr: review_cycle_type
      comment: "Type of review cycle (annual, mid-year, etc.)"
    - name: "country_code"
      expr: country_code
      comment: "Country where employee is located"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "Cost center for organizational grouping"
    - name: "high_potential_flag"
      expr: high_potential_flag
      comment: "Whether employee is identified as high potential"
    - name: "succession_candidate"
      expr: succession_candidate
      comment: "Whether employee is a succession candidate"
    - name: "promotion_recommendation"
      expr: promotion_recommendation
      comment: "Whether promotion is recommended"
    - name: "review_year"
      expr: review_year
      comment: "Year of performance review"
  measures:
    - name: "total_reviews"
      expr: COUNT(DISTINCT performance_review_id)
      comment: "Total performance reviews - talent management coverage metric"
    - name: "avg_overall_rating_score"
      expr: AVG(CAST(overall_rating_score AS DOUBLE))
      comment: "Average overall rating score - workforce performance metric"
    - name: "avg_goal_achievement_score"
      expr: AVG(CAST(goal_achievement_score AS DOUBLE))
      comment: "Average goal achievement score - performance effectiveness metric"
    - name: "avg_competency_rating_score"
      expr: AVG(CAST(competency_rating_score AS DOUBLE))
      comment: "Average competency rating score - skill development metric"
    - name: "avg_merit_increase_pct"
      expr: AVG(CAST(merit_increase_recommended_pct AS DOUBLE))
      comment: "Average merit increase percentage - compensation planning metric"
    - name: "high_potential_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN high_potential_flag = TRUE THEN performance_review_id END) / NULLIF(COUNT(DISTINCT performance_review_id), 0), 2)
      comment: "High potential identification rate - talent pipeline metric"
    - name: "succession_candidate_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN succession_candidate = TRUE THEN performance_review_id END) / NULLIF(COUNT(DISTINCT performance_review_id), 0), 2)
      comment: "Succession candidate rate - leadership pipeline metric"
    - name: "promotion_recommendation_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN promotion_recommendation = TRUE THEN performance_review_id END) / NULLIF(COUNT(DISTINCT performance_review_id), 0), 2)
      comment: "Promotion recommendation rate - career development metric"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_headcount_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Workforce planning and capacity metrics for strategic resource allocation and budget management"
  source: "`manufacturing_ecm`.`workforce`.`headcount_plan`"
  dimensions:
    - name: "plan_type"
      expr: plan_type
      comment: "Type of headcount plan (budget, forecast, strategic, etc.)"
    - name: "plan_scenario"
      expr: plan_scenario
      comment: "Planning scenario (base, optimistic, pessimistic, etc.)"
    - name: "plan_status"
      expr: plan_status
      comment: "Status of headcount plan"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of plan"
    - name: "country_code"
      expr: country_code
      comment: "Country for headcount planning"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "employment_type"
      expr: employment_type
      comment: "Type of employment (full-time, part-time, contractor, etc.)"
    - name: "direct_labor_indicator"
      expr: direct_labor_indicator
      comment: "Whether position is direct labor"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year for planning"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period for planning"
  measures:
    - name: "total_planned_headcount"
      expr: SUM(CAST(planned_headcount AS DOUBLE))
      comment: "Total planned headcount - workforce capacity planning metric"
    - name: "total_budgeted_headcount"
      expr: SUM(CAST(budgeted_headcount AS DOUBLE))
      comment: "Total budgeted headcount - budget planning metric"
    - name: "total_actual_headcount"
      expr: SUM(CAST(actual_headcount AS DOUBLE))
      comment: "Total actual headcount - execution tracking metric"
    - name: "total_planned_fte"
      expr: SUM(CAST(planned_fte AS DOUBLE))
      comment: "Total planned FTE - workforce capacity metric"
    - name: "total_actual_fte"
      expr: SUM(CAST(actual_fte AS DOUBLE))
      comment: "Total actual FTE - workforce utilization metric"
    - name: "total_planned_labor_cost"
      expr: SUM(CAST(planned_labor_cost AS DOUBLE))
      comment: "Total planned labor cost - budget planning metric"
    - name: "total_budgeted_labor_cost"
      expr: SUM(CAST(budgeted_labor_cost AS DOUBLE))
      comment: "Total budgeted labor cost - financial planning metric"
    - name: "total_open_positions"
      expr: SUM(CAST(open_positions AS DOUBLE))
      comment: "Total open positions - recruitment demand metric"
    - name: "total_headcount_variance"
      expr: SUM(CAST(headcount_variance AS DOUBLE))
      comment: "Total headcount variance (actual vs plan) - execution accuracy metric"
    - name: "headcount_fill_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_headcount AS DOUBLE)) / NULLIF(SUM(CAST(planned_headcount AS DOUBLE)), 0), 2)
      comment: "Headcount fill rate - recruitment effectiveness KPI"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_employee_certification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Employee certification and compliance metrics for regulatory adherence and skill validation"
  source: "`manufacturing_ecm`.`workforce`.`employee_certification`"
  dimensions:
    - name: "certification_code"
      expr: certification_code
      comment: "Certification code or identifier"
    - name: "status"
      expr: status
      comment: "Certification status (active, expired, pending, etc.)"
    - name: "country_code"
      expr: country_code
      comment: "Country where certification is held"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "mandatory_flag"
      expr: mandatory_flag
      comment: "Whether certification is mandatory"
    - name: "regulatory_requirement_flag"
      expr: regulatory_requirement_flag
      comment: "Whether certification is a regulatory requirement"
    - name: "hse_compliance_flag"
      expr: hse_compliance_flag
      comment: "Whether certification is for HSE compliance"
    - name: "issue_year"
      expr: YEAR(issue_date)
      comment: "Year certification was issued"
    - name: "expiry_year"
      expr: YEAR(expiry_date)
      comment: "Year certification expires"
  measures:
    - name: "total_certifications"
      expr: COUNT(DISTINCT employee_certification_id)
      comment: "Total employee certifications - compliance coverage metric"
    - name: "total_training_cost"
      expr: SUM(CAST(training_cost_amount AS DOUBLE))
      comment: "Total certification training cost - workforce development investment metric"
    - name: "avg_training_cost"
      expr: AVG(CAST(training_cost_amount AS DOUBLE))
      comment: "Average training cost per certification - cost efficiency metric"
    - name: "total_training_hours"
      expr: SUM(CAST(training_hours AS DOUBLE))
      comment: "Total training hours for certifications - workforce development effort metric"
    - name: "avg_exam_score"
      expr: AVG(CAST(exam_score AS DOUBLE))
      comment: "Average exam score - certification quality metric"
    - name: "certification_compliance_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN status = 'Active' THEN employee_certification_id END) / NULLIF(COUNT(DISTINCT employee_certification_id), 0), 2)
      comment: "Active certification rate - compliance effectiveness KPI"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_grievance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Employee grievance and labor relations metrics for workplace culture and union relations management"
  source: "`manufacturing_ecm`.`workforce`.`grievance`"
  dimensions:
    - name: "category"
      expr: category
      comment: "Grievance category"
    - name: "sub_category"
      expr: sub_category
      comment: "Grievance sub-category"
    - name: "status"
      expr: status
      comment: "Grievance status"
    - name: "resolution_outcome"
      expr: resolution_outcome
      comment: "Outcome of grievance resolution"
    - name: "step_level"
      expr: step_level
      comment: "Grievance step level in process"
    - name: "country_code"
      expr: country_code
      comment: "Country where grievance occurred"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "safety_related"
      expr: safety_related
      comment: "Whether grievance is safety-related"
    - name: "osha_reportable"
      expr: osha_reportable
      comment: "Whether grievance is OSHA reportable"
    - name: "filing_month"
      expr: DATE_TRUNC('MONTH', filing_date)
      comment: "Month when grievance was filed"
  measures:
    - name: "total_grievances"
      expr: COUNT(DISTINCT grievance_id)
      comment: "Total grievances filed - labor relations health metric"
    - name: "total_back_pay"
      expr: SUM(CAST(back_pay_amount AS DOUBLE))
      comment: "Total back pay awarded - financial impact of grievances"
    - name: "avg_resolution_days"
      expr: AVG(DATEDIFF(resolution_date, filing_date))
      comment: "Average days to resolve grievance - process efficiency metric"
    - name: "grievance_resolution_rate_pct"
      expr: ROUND(100.0 * COUNT(DISTINCT CASE WHEN status = 'Resolved' THEN grievance_id END) / NULLIF(COUNT(DISTINCT grievance_id), 0), 2)
      comment: "Grievance resolution rate - labor relations effectiveness KPI"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`workforce_disciplinary_action`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Disciplinary action metrics for workforce conduct management and compliance"
  source: "`manufacturing_ecm`.`workforce`.`disciplinary_action`"
  dimensions:
    - name: "action_type"
      expr: action_type
      comment: "Type of disciplinary action"
    - name: "severity_level"
      expr: severity_level
      comment: "Severity level of infraction"
    - name: "infraction_category"
      expr: infraction_category
      comment: "Category of infraction"
    - name: "status"
      expr: status
      comment: "Status of disciplinary action"
    - name: "country_code"
      expr: country_code
      comment: "Country where action occurred"
    - name: "plant_code"
      expr: plant_code
      comment: "Plant or facility code"
    - name: "safety_related_flag"
      expr: safety_related_flag
      comment: "Whether action is safety-related"
    - name: "osha_recordable_flag"
      expr: osha_recordable_flag
      comment: "Whether action is OSHA recordable"
    - name: "union_member_flag"
      expr: union_member_flag
      comment: "Whether employee is union member"
    - name: "action_month"
      expr: DATE_TRUNC('MONTH', action_date)
      comment: "Month when action was taken"
  measures:
    - name: "total_disciplinary_actions"
      expr: COUNT(DISTINCT disciplinary_action_id)
      comment: "Total disciplinary actions - workforce conduct metric"
    - name: "avg_progressive_step"
      expr: AVG(CAST(progressive_step_number AS DOUBLE))
      comment: "Average progressive discipline step - severity tracking metric"
    - name: "total_suspension_days"
      expr: SUM(CAST(suspension_days AS DOUBLE))
      comment: "Total suspension days - workforce availability impact metric"
$$;