-- Metric views for domain: asset | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_asset_bom`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Asset Bom business metrics"
  source: "`manufacturing_ecm`.`asset`.`asset_bom`"
  dimensions:
    - name: "Alternative Part Number"
      expr: alternative_part_number
    - name: "Change Notice Number"
      expr: change_notice_number
    - name: "Child Component Number"
      expr: child_component_number
    - name: "Component Type"
      expr: component_type
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Criticality Rating"
      expr: criticality_rating
    - name: "Currency Code"
      expr: currency_code
    - name: "Drawing Number"
      expr: drawing_number
    - name: "Effective From Date"
      expr: effective_from_date
    - name: "Effective To Date"
      expr: effective_to_date
    - name: "Hierarchy Level"
      expr: hierarchy_level
    - name: "Installation Position"
      expr: installation_position
    - name: "Internal Part Number"
      expr: internal_part_number
    - name: "Is Regulatory Controlled"
      expr: is_regulatory_controlled
    - name: "Is Safety Critical"
      expr: is_safety_critical
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Asset Bom"
      expr: COUNT(DISTINCT asset_bom_id)
    - name: "Total Estimated Unit Cost"
      expr: SUM(estimated_unit_cost)
    - name: "Average Estimated Unit Cost"
      expr: AVG(estimated_unit_cost)
    - name: "Total Quantity"
      expr: SUM(quantity)
    - name: "Average Quantity"
      expr: AVG(quantity)
    - name: "Total Recommended Stock Quantity"
      expr: SUM(recommended_stock_quantity)
    - name: "Average Recommended Stock Quantity"
      expr: AVG(recommended_stock_quantity)
    - name: "Total Replacement Interval Hours"
      expr: SUM(replacement_interval_hours)
    - name: "Average Replacement Interval Hours"
      expr: AVG(replacement_interval_hours)
    - name: "Total Weight Kg"
      expr: SUM(weight_kg)
    - name: "Average Weight Kg"
      expr: AVG(weight_kg)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_asset_document`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Asset Document business metrics"
  source: "`manufacturing_ecm`.`asset`.`asset_document`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Author"
      expr: author
    - name: "Category"
      expr: category
    - name: "Certificate Number"
      expr: certificate_number
    - name: "Certification Body"
      expr: certification_body
    - name: "Change Notice Number"
      expr: change_notice_number
    - name: "Classification"
      expr: classification
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Description"
      expr: description
    - name: "Drawing Number"
      expr: drawing_number
    - name: "File Format"
      expr: file_format
    - name: "File Size Kb"
      expr: file_size_kb
    - name: "Is Controlled"
      expr: is_controlled
    - name: "Is Mandatory"
      expr: is_mandatory
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Asset Document"
      expr: COUNT(DISTINCT asset_document_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_asset_notification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Asset Notification business metrics"
  source: "`manufacturing_ecm`.`asset`.`asset_notification`"
  dimensions:
    - name: "Assembly"
      expr: assembly
    - name: "Breakdown Indicator"
      expr: breakdown_indicator
    - name: "Category"
      expr: category
    - name: "Cause Code"
      expr: cause_code
    - name: "Cause Description"
      expr: cause_description
    - name: "Closed Timestamp"
      expr: closed_timestamp
    - name: "Completed Timestamp"
      expr: completed_timestamp
    - name: "Country Code"
      expr: country_code
    - name: "Damage Code"
      expr: damage_code
    - name: "Damage Description"
      expr: damage_description
    - name: "Description"
      expr: description
    - name: "Effect Code"
      expr: effect_code
    - name: "Environment Relevant"
      expr: environment_relevant
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Long Text"
      expr: long_text
    - name: "Main Work Center"
      expr: main_work_center
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Asset Notification"
      expr: COUNT(DISTINCT asset_notification_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_asset_supply_agreement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Asset Supply Agreement business metrics"
  source: "`manufacturing_ecm`.`asset`.`asset_supply_agreement`"
  dimensions:
    - name: "Agreement End Date"
      expr: agreement_end_date
    - name: "Agreement Start Date"
      expr: agreement_start_date
    - name: "Last Purchase Date"
      expr: last_purchase_date
    - name: "Lead Time Days"
      expr: lead_time_days
    - name: "Preferred Supplier Flag"
      expr: preferred_supplier_flag
    - name: "Preferred Vendor Number"
      expr: preferred_vendor_number
    - name: "Price Currency Code"
      expr: price_currency_code
    - name: "Status"
      expr: status
    - name: "Agreement End Date Month"
      expr: DATE_TRUNC('MONTH', agreement_end_date)
    - name: "Agreement Start Date Month"
      expr: DATE_TRUNC('MONTH', agreement_start_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Asset Supply Agreement"
      expr: COUNT(DISTINCT asset_supply_agreement_id)
    - name: "Total Minimum Order Quantity"
      expr: SUM(minimum_order_quantity)
    - name: "Average Minimum Order Quantity"
      expr: AVG(minimum_order_quantity)
    - name: "Total Quality Rating"
      expr: SUM(quality_rating)
    - name: "Average Quality Rating"
      expr: AVG(quality_rating)
    - name: "Total Unit Price"
      expr: SUM(unit_price)
    - name: "Average Unit Price"
      expr: AVG(unit_price)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_asset_valuation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Asset Valuation business metrics"
  source: "`manufacturing_ecm`.`asset`.`asset_valuation`"
  dimensions:
    - name: "Accumulated Depreciation Gl Account"
      expr: accumulated_depreciation_gl_account
    - name: "Acquisition Cost Currency"
      expr: acquisition_cost_currency
    - name: "Acquisition Date"
      expr: acquisition_date
    - name: "Asset Class Code"
      expr: asset_class_code
    - name: "Asset Sub Number"
      expr: asset_sub_number
    - name: "Asset Under Construction Flag"
      expr: asset_under_construction_flag
    - name: "Capex Project Number"
      expr: capex_project_number
    - name: "Capitalization Date"
      expr: capitalization_date
    - name: "Company Code"
      expr: company_code
    - name: "Controlling Area Code"
      expr: controlling_area_code
    - name: "Cost Center Code"
      expr: cost_center_code
    - name: "Date"
      expr: date
    - name: "Depreciation Key"
      expr: depreciation_key
    - name: "Depreciation Method"
      expr: depreciation_method
    - name: "Disposal Date"
      expr: disposal_date
    - name: "Fiscal Period"
      expr: fiscal_period
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Asset Valuation"
      expr: COUNT(DISTINCT asset_valuation_id)
    - name: "Total Accumulated Depreciation"
      expr: SUM(accumulated_depreciation)
    - name: "Average Accumulated Depreciation"
      expr: AVG(accumulated_depreciation)
    - name: "Total Acquisition Cost"
      expr: SUM(acquisition_cost)
    - name: "Average Acquisition Cost"
      expr: AVG(acquisition_cost)
    - name: "Total Acquisition Cost Group Currency"
      expr: SUM(acquisition_cost_group_currency)
    - name: "Average Acquisition Cost Group Currency"
      expr: AVG(acquisition_cost_group_currency)
    - name: "Total Current Period Depreciation"
      expr: SUM(current_period_depreciation)
    - name: "Average Current Period Depreciation"
      expr: AVG(current_period_depreciation)
    - name: "Total Disposal Proceeds"
      expr: SUM(disposal_proceeds)
    - name: "Average Disposal Proceeds"
      expr: AVG(disposal_proceeds)
    - name: "Total Impairment Loss"
      expr: SUM(impairment_loss)
    - name: "Average Impairment Loss"
      expr: AVG(impairment_loss)
    - name: "Total Net Book Value"
      expr: SUM(net_book_value)
    - name: "Average Net Book Value"
      expr: AVG(net_book_value)
    - name: "Total Residual Value"
      expr: SUM(residual_value)
    - name: "Average Residual Value"
      expr: AVG(residual_value)
    - name: "Total Residual Value Percent"
      expr: SUM(residual_value_percent)
    - name: "Average Residual Value Percent"
      expr: AVG(residual_value_percent)
    - name: "Total Revaluation Amount"
      expr: SUM(revaluation_amount)
    - name: "Average Revaluation Amount"
      expr: AVG(revaluation_amount)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_calibration_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Calibration Record business metrics"
  source: "`manufacturing_ecm`.`asset`.`calibration_record`"
  dimensions:
    - name: "Adjustment Made Flag"
      expr: adjustment_made_flag
    - name: "Approval Date"
      expr: approval_date
    - name: "Approved By"
      expr: approved_by
    - name: "Calibration Date"
      expr: calibration_date
    - name: "Calibration Interval Days"
      expr: calibration_interval_days
    - name: "Calibration Method"
      expr: calibration_method
    - name: "Calibration Number"
      expr: calibration_number
    - name: "Calibration Standard Reference"
      expr: calibration_standard_reference
    - name: "Calibration Type"
      expr: calibration_type
    - name: "Capa Reference Number"
      expr: capa_reference_number
    - name: "Certificate Issue Date"
      expr: certificate_issue_date
    - name: "Certificate Number"
      expr: certificate_number
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Functional Location"
      expr: functional_location
    - name: "Instrument Description"
      expr: instrument_description
    - name: "Instrument Tag"
      expr: instrument_tag
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Calibration Record"
      expr: COUNT(DISTINCT calibration_record_id)
    - name: "Total As Found Value"
      expr: SUM(as_found_value)
    - name: "Average As Found Value"
      expr: AVG(as_found_value)
    - name: "Total As Left Value"
      expr: SUM(as_left_value)
    - name: "Average As Left Value"
      expr: AVG(as_left_value)
    - name: "Total Environmental Humidity Percent"
      expr: SUM(environmental_humidity_percent)
    - name: "Average Environmental Humidity Percent"
      expr: AVG(environmental_humidity_percent)
    - name: "Total Environmental Temperature C"
      expr: SUM(environmental_temperature_c)
    - name: "Average Environmental Temperature C"
      expr: AVG(environmental_temperature_c)
    - name: "Total Measurement Uncertainty"
      expr: SUM(measurement_uncertainty)
    - name: "Average Measurement Uncertainty"
      expr: AVG(measurement_uncertainty)
    - name: "Total Tolerance Lower Limit"
      expr: SUM(tolerance_lower_limit)
    - name: "Average Tolerance Lower Limit"
      expr: AVG(tolerance_lower_limit)
    - name: "Total Tolerance Upper Limit"
      expr: SUM(tolerance_upper_limit)
    - name: "Average Tolerance Upper Limit"
      expr: AVG(tolerance_upper_limit)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_capex_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Capex Request business metrics"
  source: "`manufacturing_ecm`.`asset`.`capex_request`"
  dimensions:
    - name: "Actual Completion Date"
      expr: actual_completion_date
    - name: "Approval Date"
      expr: approval_date
    - name: "Approved By"
      expr: approved_by
    - name: "Budget Cycle"
      expr: budget_cycle
    - name: "Company Code"
      expr: company_code
    - name: "Cost Center Code"
      expr: cost_center_code
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Current Approval Level"
      expr: current_approval_level
    - name: "Description"
      expr: description
    - name: "Group Currency Code"
      expr: group_currency_code
    - name: "Investment Program Position"
      expr: investment_program_position
    - name: "Justification Category"
      expr: justification_category
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Payback Period Months"
      expr: payback_period_months
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Capex Request"
      expr: COUNT(DISTINCT capex_request_id)
    - name: "Total Amount In Group Currency"
      expr: SUM(amount_in_group_currency)
    - name: "Average Amount In Group Currency"
      expr: AVG(amount_in_group_currency)
    - name: "Total Approved Amount"
      expr: SUM(approved_amount)
    - name: "Average Approved Amount"
      expr: AVG(approved_amount)
    - name: "Total Estimated Roi Percent"
      expr: SUM(estimated_roi_percent)
    - name: "Average Estimated Roi Percent"
      expr: AVG(estimated_roi_percent)
    - name: "Total Internal Rate Of Return Percent"
      expr: SUM(internal_rate_of_return_percent)
    - name: "Average Internal Rate Of Return Percent"
      expr: AVG(internal_rate_of_return_percent)
    - name: "Total Net Present Value"
      expr: SUM(net_present_value)
    - name: "Average Net Present Value"
      expr: AVG(net_present_value)
    - name: "Total Requested Amount"
      expr: SUM(requested_amount)
    - name: "Average Requested Amount"
      expr: AVG(requested_amount)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_class`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Class business metrics"
  source: "`manufacturing_ecm`.`asset`.`class`"
  dimensions:
    - name: "Applicable Standard"
      expr: applicable_standard
    - name: "Asset Type"
      expr: asset_type
    - name: "Capitalization Threshold Currency"
      expr: capitalization_threshold_currency
    - name: "Category"
      expr: category
    - name: "Ce Marking Required"
      expr: ce_marking_required
    - name: "Code"
      expr: code
    - name: "Cost Center Code"
      expr: cost_center_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Criticality Rating"
      expr: criticality_rating
    - name: "Depreciation Method"
      expr: depreciation_method
    - name: "Description"
      expr: description
    - name: "Effective Date"
      expr: effective_date
    - name: "Energy Class"
      expr: energy_class
    - name: "Environmental Risk Class"
      expr: environmental_risk_class
    - name: "Expiry Date"
      expr: expiry_date
    - name: "Gl Account Code"
      expr: gl_account_code
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Class"
      expr: COUNT(DISTINCT class_id)
    - name: "Total Capitalization Threshold Amount"
      expr: SUM(capitalization_threshold_amount)
    - name: "Average Capitalization Threshold Amount"
      expr: AVG(capitalization_threshold_amount)
    - name: "Total Mean Time Between Failures Hours"
      expr: SUM(mean_time_between_failures_hours)
    - name: "Average Mean Time Between Failures Hours"
      expr: AVG(mean_time_between_failures_hours)
    - name: "Total Mean Time To Repair Hours"
      expr: SUM(mean_time_to_repair_hours)
    - name: "Average Mean Time To Repair Hours"
      expr: AVG(mean_time_to_repair_hours)
    - name: "Total Residual Value Percent"
      expr: SUM(residual_value_percent)
    - name: "Average Residual Value Percent"
      expr: AVG(residual_value_percent)
    - name: "Total Useful Life Years"
      expr: SUM(useful_life_years)
    - name: "Average Useful Life Years"
      expr: AVG(useful_life_years)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_condition_assessment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Condition Assessment business metrics"
  source: "`manufacturing_ecm`.`asset`.`condition_assessment`"
  dimensions:
    - name: "Action Due Date"
      expr: action_due_date
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Assessment Category"
      expr: assessment_category
    - name: "Assessment Date"
      expr: assessment_date
    - name: "Assessment Findings"
      expr: assessment_findings
    - name: "Assessment Number"
      expr: assessment_number
    - name: "Assessment Type"
      expr: assessment_type
    - name: "Capex Flag"
      expr: capex_flag
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "End Of Life Date"
      expr: end_of_life_date
    - name: "Environmental Risk Flag"
      expr: environmental_risk_flag
    - name: "Failure Risk Level"
      expr: failure_risk_level
    - name: "Iiot Data Used Flag"
      expr: iiot_data_used_flag
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Condition Assessment"
      expr: COUNT(DISTINCT condition_assessment_id)
    - name: "Total Condition Score"
      expr: SUM(condition_score)
    - name: "Average Condition Score"
      expr: AVG(condition_score)
    - name: "Total Electrical Condition Score"
      expr: SUM(electrical_condition_score)
    - name: "Average Electrical Condition Score"
      expr: AVG(electrical_condition_score)
    - name: "Total Estimated Repair Cost"
      expr: SUM(estimated_repair_cost)
    - name: "Average Estimated Repair Cost"
      expr: AVG(estimated_repair_cost)
    - name: "Total Instrumentation Condition Score"
      expr: SUM(instrumentation_condition_score)
    - name: "Average Instrumentation Condition Score"
      expr: AVG(instrumentation_condition_score)
    - name: "Total Mechanical Condition Score"
      expr: SUM(mechanical_condition_score)
    - name: "Average Mechanical Condition Score"
      expr: AVG(mechanical_condition_score)
    - name: "Total Remaining Useful Life Years"
      expr: SUM(remaining_useful_life_years)
    - name: "Average Remaining Useful Life Years"
      expr: AVG(remaining_useful_life_years)
    - name: "Total Structural Condition Score"
      expr: SUM(structural_condition_score)
    - name: "Average Structural Condition Score"
      expr: AVG(structural_condition_score)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_contract_risk_assessment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Contract Risk Assessment business metrics"
  source: "`manufacturing_ecm`.`asset`.`contract_risk_assessment`"
  dimensions:
    - name: "Assessment Status"
      expr: assessment_status
    - name: "Created Date"
      expr: created_date
    - name: "Last Updated Date"
      expr: last_updated_date
    - name: "Mitigation Measures"
      expr: mitigation_measures
    - name: "Next Review Date"
      expr: next_review_date
    - name: "Review Frequency"
      expr: review_frequency
    - name: "Risk Assessment Date"
      expr: risk_assessment_date
    - name: "Risk Level"
      expr: risk_level
    - name: "Risk Owner"
      expr: risk_owner
    - name: "Created Date Month"
      expr: DATE_TRUNC('MONTH', created_date)
    - name: "Last Updated Date Month"
      expr: DATE_TRUNC('MONTH', last_updated_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Contract Risk Assessment"
      expr: COUNT(DISTINCT contract_risk_assessment_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_control_implementation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Control Implementation business metrics"
  source: "`manufacturing_ecm`.`asset`.`control_implementation`"
  dimensions:
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Effectiveness Rating"
      expr: effectiveness_rating
    - name: "Implementation Date"
      expr: implementation_date
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Next Verification Due Date"
      expr: next_verification_due_date
    - name: "Remediation Notes"
      expr: remediation_notes
    - name: "Responsible Engineer"
      expr: responsible_engineer
    - name: "Status"
      expr: status
    - name: "Verification Date"
      expr: verification_date
    - name: "Created Timestamp Month"
      expr: DATE_TRUNC('MONTH', created_timestamp)
    - name: "Implementation Date Month"
      expr: DATE_TRUNC('MONTH', implementation_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Control Implementation"
      expr: COUNT(DISTINCT control_implementation_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_equipment_allocation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Equipment Allocation business metrics"
  source: "`manufacturing_ecm`.`asset`.`equipment_allocation`"
  dimensions:
    - name: "Allocated By"
      expr: allocated_by
    - name: "Allocation Date"
      expr: allocation_date
    - name: "Allocation Status"
      expr: allocation_status
    - name: "Project Priority"
      expr: project_priority
    - name: "Usage End Date"
      expr: usage_end_date
    - name: "Usage Start Date"
      expr: usage_start_date
    - name: "Allocation Date Month"
      expr: DATE_TRUNC('MONTH', allocation_date)
    - name: "Usage End Date Month"
      expr: DATE_TRUNC('MONTH', usage_end_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Equipment Allocation"
      expr: COUNT(DISTINCT equipment_allocation_id)
    - name: "Total Allocation Percentage"
      expr: SUM(allocation_percentage)
    - name: "Average Allocation Percentage"
      expr: AVG(allocation_percentage)
    - name: "Total Cost Allocation Rate"
      expr: SUM(cost_allocation_rate)
    - name: "Average Cost Allocation Rate"
      expr: AVG(cost_allocation_rate)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_equipment_certification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Equipment Certification business metrics"
  source: "`manufacturing_ecm`.`asset`.`equipment_certification`"
  dimensions:
    - name: "Certificate Number"
      expr: certificate_number
    - name: "Certification Date"
      expr: certification_date
    - name: "Certifying Body"
      expr: certifying_body
    - name: "Compliance Status"
      expr: compliance_status
    - name: "Documentation Reference"
      expr: documentation_reference
    - name: "Expiry Date"
      expr: expiry_date
    - name: "Last Audit Date"
      expr: last_audit_date
    - name: "Next Audit Date"
      expr: next_audit_date
    - name: "Notes"
      expr: notes
    - name: "Responsible Engineer"
      expr: responsible_engineer
    - name: "Certification Date Month"
      expr: DATE_TRUNC('MONTH', certification_date)
    - name: "Expiry Date Month"
      expr: DATE_TRUNC('MONTH', expiry_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Equipment Certification"
      expr: COUNT(DISTINCT equipment_certification_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_equipment_compliance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Equipment Compliance business metrics"
  source: "`manufacturing_ecm`.`asset`.`equipment_compliance`"
  dimensions:
    - name: "Assessment Method"
      expr: assessment_method
    - name: "Compliance Status"
      expr: compliance_status
    - name: "Created Date"
      expr: created_date
    - name: "Evidence Reference"
      expr: evidence_reference
    - name: "Exemption Expiry Date"
      expr: exemption_expiry_date
    - name: "Exemption Flag"
      expr: exemption_flag
    - name: "Exemption Reason"
      expr: exemption_reason
    - name: "Last Assessment Date"
      expr: last_assessment_date
    - name: "Last Updated Date"
      expr: last_updated_date
    - name: "Next Review Date"
      expr: next_review_date
    - name: "Non Compliance Severity"
      expr: non_compliance_severity
    - name: "Remediation Due Date"
      expr: remediation_due_date
    - name: "Responsible Person"
      expr: responsible_person
    - name: "Created Date Month"
      expr: DATE_TRUNC('MONTH', created_date)
    - name: "Exemption Expiry Date Month"
      expr: DATE_TRUNC('MONTH', exemption_expiry_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Equipment Compliance"
      expr: COUNT(DISTINCT equipment_compliance_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_equipment_contract_coverage`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Equipment Contract Coverage business metrics"
  source: "`manufacturing_ecm`.`asset`.`equipment_contract_coverage`"
  dimensions:
    - name: "Coverage End Date"
      expr: coverage_end_date
    - name: "Coverage Start Date"
      expr: coverage_start_date
    - name: "Covered Components Scope"
      expr: covered_components_scope
    - name: "Priority Response Flag"
      expr: priority_response_flag
    - name: "Sla Tier"
      expr: sla_tier
    - name: "Coverage End Date Month"
      expr: DATE_TRUNC('MONTH', coverage_end_date)
    - name: "Coverage Start Date Month"
      expr: DATE_TRUNC('MONTH', coverage_start_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Equipment Contract Coverage"
      expr: COUNT(DISTINCT equipment_contract_coverage_id)
    - name: "Total Contract Line Value"
      expr: SUM(contract_line_value)
    - name: "Average Contract Line Value"
      expr: AVG(contract_line_value)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_equipment_service_contract`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Equipment Service Contract business metrics"
  source: "`manufacturing_ecm`.`asset`.`equipment_service_contract`"
  dimensions:
    - name: "Contract Currency"
      expr: contract_currency
    - name: "Contract End Date"
      expr: contract_end_date
    - name: "Contract Start Date"
      expr: contract_start_date
    - name: "Contract Status"
      expr: contract_status
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Is Primary Service Provider"
      expr: is_primary_service_provider
    - name: "Service Level Agreement"
      expr: service_level_agreement
    - name: "Service Type"
      expr: service_type
    - name: "Updated Timestamp"
      expr: updated_timestamp
    - name: "Contract End Date Month"
      expr: DATE_TRUNC('MONTH', contract_end_date)
    - name: "Contract Start Date Month"
      expr: DATE_TRUNC('MONTH', contract_start_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Equipment Service Contract"
      expr: COUNT(DISTINCT equipment_service_contract_id)
    - name: "Total Annual Contract Value"
      expr: SUM(annual_contract_value)
    - name: "Average Annual Contract Value"
      expr: AVG(annual_contract_value)
    - name: "Total Response Time Hours"
      expr: SUM(response_time_hours)
    - name: "Average Response Time Hours"
      expr: AVG(response_time_hours)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_failure_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Failure Record business metrics"
  source: "`manufacturing_ecm`.`asset`.`failure_record`"
  dimensions:
    - name: "Capa Reference Number"
      expr: capa_reference_number
    - name: "Capa Required Flag"
      expr: capa_required_flag
    - name: "Closed Timestamp"
      expr: closed_timestamp
    - name: "Cost Center"
      expr: cost_center
    - name: "Currency Code"
      expr: currency_code
    - name: "Damage Code"
      expr: damage_code
    - name: "Detection Method"
      expr: detection_method
    - name: "Environmental Incident Flag"
      expr: environmental_incident_flag
    - name: "Failed Component"
      expr: failed_component
    - name: "Failed Component Part Number"
      expr: failed_component_part_number
    - name: "Failure Cause Code"
      expr: failure_cause_code
    - name: "Failure Cause Description"
      expr: failure_cause_description
    - name: "Failure Class"
      expr: failure_class
    - name: "Failure Code"
      expr: failure_code
    - name: "Failure Effect Code"
      expr: failure_effect_code
    - name: "Failure Effect Description"
      expr: failure_effect_description
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Failure Record"
      expr: COUNT(DISTINCT failure_record_id)
    - name: "Total Actual Repair Cost"
      expr: SUM(actual_repair_cost)
    - name: "Average Actual Repair Cost"
      expr: AVG(actual_repair_cost)
    - name: "Total Affected Production Quantity"
      expr: SUM(affected_production_quantity)
    - name: "Average Affected Production Quantity"
      expr: AVG(affected_production_quantity)
    - name: "Total Downtime Duration Minutes"
      expr: SUM(downtime_duration_minutes)
    - name: "Average Downtime Duration Minutes"
      expr: AVG(downtime_duration_minutes)
    - name: "Total Estimated Repair Cost"
      expr: SUM(estimated_repair_cost)
    - name: "Average Estimated Repair Cost"
      expr: AVG(estimated_repair_cost)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_iiot_asset_telemetry`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Iiot Asset Telemetry business metrics"
  source: "`manufacturing_ecm`.`asset`.`iiot_asset_telemetry`"
  dimensions:
    - name: "Anomaly Detection Flag"
      expr: anomaly_detection_flag
    - name: "Asset Operational State"
      expr: asset_operational_state
    - name: "Breach Severity"
      expr: breach_severity
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Edge Device Code"
      expr: edge_device_code
    - name: "Event Timestamp"
      expr: event_timestamp
    - name: "Functional Location Code"
      expr: functional_location_code
    - name: "Ingestion Timestamp"
      expr: ingestion_timestamp
    - name: "Measurement Type"
      expr: measurement_type
    - name: "Mindsphere Aspect Name"
      expr: mindsphere_aspect_name
    - name: "Mindsphere Asset Reference"
      expr: mindsphere_asset_reference
    - name: "Mindsphere Variable Name"
      expr: mindsphere_variable_name
    - name: "Oee Loss Category"
      expr: oee_loss_category
    - name: "Plant Code"
      expr: plant_code
    - name: "Production Order Number"
      expr: production_order_number
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Iiot Asset Telemetry"
      expr: COUNT(DISTINCT iiot_asset_telemetry_id)
    - name: "Total Anomaly Score"
      expr: SUM(anomaly_score)
    - name: "Average Anomaly Score"
      expr: AVG(anomaly_score)
    - name: "Total Cycle Count"
      expr: SUM(cycle_count)
    - name: "Average Cycle Count"
      expr: AVG(cycle_count)
    - name: "Total Lower Alarm Limit"
      expr: SUM(lower_alarm_limit)
    - name: "Average Lower Alarm Limit"
      expr: AVG(lower_alarm_limit)
    - name: "Total Lower Warning Limit"
      expr: SUM(lower_warning_limit)
    - name: "Average Lower Warning Limit"
      expr: AVG(lower_warning_limit)
    - name: "Total Operating Hours Cumulative"
      expr: SUM(operating_hours_cumulative)
    - name: "Average Operating Hours Cumulative"
      expr: AVG(operating_hours_cumulative)
    - name: "Total Reading Value"
      expr: SUM(reading_value)
    - name: "Average Reading Value"
      expr: AVG(reading_value)
    - name: "Total Upper Alarm Limit"
      expr: SUM(upper_alarm_limit)
    - name: "Average Upper Alarm Limit"
      expr: AVG(upper_alarm_limit)
    - name: "Total Upper Warning Limit"
      expr: SUM(upper_warning_limit)
    - name: "Average Upper Warning Limit"
      expr: AVG(upper_warning_limit)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_lifecycle_event`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Lifecycle Event business metrics"
  source: "`manufacturing_ecm`.`asset`.`lifecycle_event`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Asset Configuration Change"
      expr: asset_configuration_change
    - name: "Asset Status After"
      expr: asset_status_after
    - name: "Asset Status Before"
      expr: asset_status_before
    - name: "Cost Center"
      expr: cost_center
    - name: "Cost Classification"
      expr: cost_classification
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Description"
      expr: description
    - name: "Disposal Method"
      expr: disposal_method
    - name: "Downtime Duration Minutes"
      expr: downtime_duration_minutes
    - name: "Ecn Number"
      expr: ecn_number
    - name: "Environmental Impact Flag"
      expr: environmental_impact_flag
    - name: "Event Category"
      expr: event_category
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Lifecycle Event"
      expr: COUNT(DISTINCT lifecycle_event_id)
    - name: "Total Disposal Value"
      expr: SUM(disposal_value)
    - name: "Average Disposal Value"
      expr: AVG(disposal_value)
    - name: "Total Event Cost"
      expr: SUM(event_cost)
    - name: "Average Event Cost"
      expr: AVG(event_cost)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_maintenance_item`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Maintenance Item business metrics"
  source: "`manufacturing_ecm`.`asset`.`maintenance_item`"
  dimensions:
    - name: "Activity Type"
      expr: activity_type
    - name: "Calibration Standard"
      expr: calibration_standard
    - name: "Control Key"
      expr: control_key
    - name: "Cost Center"
      expr: cost_center
    - name: "Cost Classification"
      expr: cost_classification
    - name: "Cost Currency"
      expr: cost_currency
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Hazardous Material Indicator"
      expr: hazardous_material_indicator
    - name: "Interval Unit"
      expr: interval_unit
    - name: "Item Number"
      expr: item_number
    - name: "Item Text"
      expr: item_text
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Lead Time Days"
      expr: lead_time_days
    - name: "Lockout Tagout Required"
      expr: lockout_tagout_required
    - name: "Long Text"
      expr: long_text
    - name: "Maintenance Category"
      expr: maintenance_category
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Maintenance Item"
      expr: COUNT(DISTINCT maintenance_item_id)
    - name: "Total Estimated Cost"
      expr: SUM(estimated_cost)
    - name: "Average Estimated Cost"
      expr: AVG(estimated_cost)
    - name: "Total Estimated Duration Hours"
      expr: SUM(estimated_duration_hours)
    - name: "Average Estimated Duration Hours"
      expr: AVG(estimated_duration_hours)
    - name: "Total Expected Measurement Value"
      expr: SUM(expected_measurement_value)
    - name: "Average Expected Measurement Value"
      expr: AVG(expected_measurement_value)
    - name: "Total Interval Value"
      expr: SUM(interval_value)
    - name: "Average Interval Value"
      expr: AVG(interval_value)
    - name: "Total Tolerance Lower Limit"
      expr: SUM(tolerance_lower_limit)
    - name: "Average Tolerance Lower Limit"
      expr: AVG(tolerance_lower_limit)
    - name: "Total Tolerance Upper Limit"
      expr: SUM(tolerance_upper_limit)
    - name: "Average Tolerance Upper Limit"
      expr: AVG(tolerance_upper_limit)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_maintenance_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Maintenance Plan business metrics"
  source: "`manufacturing_ecm`.`asset`.`maintenance_plan`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Completion Requirement"
      expr: completion_requirement
    - name: "Cost Center"
      expr: cost_center
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Cycle Unit"
      expr: cycle_unit
    - name: "Description"
      expr: description
    - name: "End Date"
      expr: end_date
    - name: "Equipment Category"
      expr: equipment_category
    - name: "External Plan Reference"
      expr: external_plan_reference
    - name: "Last Completion Date"
      expr: last_completion_date
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Last Scheduled Date"
      expr: last_scheduled_date
    - name: "Lead Time Days"
      expr: lead_time_days
    - name: "Maintenance Plant"
      expr: maintenance_plant
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Maintenance Plan"
      expr: COUNT(DISTINCT maintenance_plan_id)
    - name: "Total Call Horizon Percentage"
      expr: SUM(call_horizon_percentage)
    - name: "Average Call Horizon Percentage"
      expr: AVG(call_horizon_percentage)
    - name: "Total Counter Reading At Last Service"
      expr: SUM(counter_reading_at_last_service)
    - name: "Average Counter Reading At Last Service"
      expr: AVG(counter_reading_at_last_service)
    - name: "Total Cycle Value"
      expr: SUM(cycle_value)
    - name: "Average Cycle Value"
      expr: AVG(cycle_value)
    - name: "Total Estimated Cost"
      expr: SUM(estimated_cost)
    - name: "Average Estimated Cost"
      expr: AVG(estimated_cost)
    - name: "Total Estimated Duration Hours"
      expr: SUM(estimated_duration_hours)
    - name: "Average Estimated Duration Hours"
      expr: AVG(estimated_duration_hours)
    - name: "Total Tolerance Percentage"
      expr: SUM(tolerance_percentage)
    - name: "Average Tolerance Percentage"
      expr: AVG(tolerance_percentage)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_measurement_point`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Measurement Point business metrics"
  source: "`manufacturing_ecm`.`asset`.`measurement_point`"
  dimensions:
    - name: "Alert Enabled"
      expr: alert_enabled
    - name: "Calibration Interval Days"
      expr: calibration_interval_days
    - name: "Calibration Required"
      expr: calibration_required
    - name: "Category"
      expr: category
    - name: "Characteristic Code"
      expr: characteristic_code
    - name: "Condition Monitoring Enabled"
      expr: condition_monitoring_enabled
    - name: "Counter Reading Direction"
      expr: counter_reading_direction
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Decimal Places"
      expr: decimal_places
    - name: "Last Calibration Date"
      expr: last_calibration_date
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Last Reading By"
      expr: last_reading_by
    - name: "Last Reading Timestamp"
      expr: last_reading_timestamp
    - name: "Maintenance Strategy Code"
      expr: maintenance_strategy_code
    - name: "Mindsphere Aspect Name"
      expr: mindsphere_aspect_name
    - name: "Mindsphere Asset Reference"
      expr: mindsphere_asset_reference
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Measurement Point"
      expr: COUNT(DISTINCT measurement_point_id)
    - name: "Total Counter Overflow Value"
      expr: SUM(counter_overflow_value)
    - name: "Average Counter Overflow Value"
      expr: AVG(counter_overflow_value)
    - name: "Total Last Reading Value"
      expr: SUM(last_reading_value)
    - name: "Average Last Reading Value"
      expr: AVG(last_reading_value)
    - name: "Total Lower Limit"
      expr: SUM(lower_limit)
    - name: "Average Lower Limit"
      expr: AVG(lower_limit)
    - name: "Total Target Value"
      expr: SUM(target_value)
    - name: "Average Target Value"
      expr: AVG(target_value)
    - name: "Total Upper Limit"
      expr: SUM(upper_limit)
    - name: "Average Upper Limit"
      expr: AVG(upper_limit)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_measurement_reading`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Measurement Reading business metrics"
  source: "`manufacturing_ecm`.`asset`.`measurement_reading`"
  dimensions:
    - name: "Breach Severity"
      expr: breach_severity
    - name: "Calibration Due Date"
      expr: calibration_due_date
    - name: "Characteristic Value"
      expr: characteristic_value
    - name: "Counter Overflow Indicator"
      expr: counter_overflow_indicator
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Functional Location"
      expr: functional_location
    - name: "Is Estimated"
      expr: is_estimated
    - name: "Last Calibration Date"
      expr: last_calibration_date
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Maintenance Plan Number"
      expr: maintenance_plan_number
    - name: "Plant Code"
      expr: plant_code
    - name: "Reading Date"
      expr: reading_date
    - name: "Reading Number"
      expr: reading_number
    - name: "Reading Quality"
      expr: reading_quality
    - name: "Reading Source"
      expr: reading_source
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Measurement Reading"
      expr: COUNT(DISTINCT measurement_reading_id)
    - name: "Total Delta Value"
      expr: SUM(delta_value)
    - name: "Average Delta Value"
      expr: AVG(delta_value)
    - name: "Total Lower Alarm Limit"
      expr: SUM(lower_alarm_limit)
    - name: "Average Lower Alarm Limit"
      expr: AVG(lower_alarm_limit)
    - name: "Total Lower Warning Limit"
      expr: SUM(lower_warning_limit)
    - name: "Average Lower Warning Limit"
      expr: AVG(lower_warning_limit)
    - name: "Total Reading Value"
      expr: SUM(reading_value)
    - name: "Average Reading Value"
      expr: AVG(reading_value)
    - name: "Total Upper Alarm Limit"
      expr: SUM(upper_alarm_limit)
    - name: "Average Upper Alarm Limit"
      expr: AVG(upper_alarm_limit)
    - name: "Total Upper Warning Limit"
      expr: SUM(upper_warning_limit)
    - name: "Average Upper Warning Limit"
      expr: AVG(upper_warning_limit)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_permit_to_work`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Permit To Work business metrics"
  source: "`manufacturing_ecm`.`asset`.`permit_to_work`"
  dimensions:
    - name: "Approved Timestamp"
      expr: approved_timestamp
    - name: "Closed By"
      expr: closed_by
    - name: "Closed Timestamp"
      expr: closed_timestamp
    - name: "Closure Confirmation"
      expr: closure_confirmation
    - name: "Confined Space Class"
      expr: confined_space_class
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Description"
      expr: description
    - name: "Electrical Voltage Level"
      expr: electrical_voltage_level
    - name: "Fire Watch Required"
      expr: fire_watch_required
    - name: "Gas Test Required"
      expr: gas_test_required
    - name: "Gas Test Result"
      expr: gas_test_result
    - name: "Hot Work Type"
      expr: hot_work_type
    - name: "Incident Occurred"
      expr: incident_occurred
    - name: "Incident Report Number"
      expr: incident_report_number
    - name: "Isolation Points"
      expr: isolation_points
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Permit To Work"
      expr: COUNT(DISTINCT permit_to_work_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_predictive_alert`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Predictive Alert business metrics"
  source: "`manufacturing_ecm`.`asset`.`predictive_alert`"
  dimensions:
    - name: "Acknowledged By"
      expr: acknowledged_by
    - name: "Acknowledged Timestamp"
      expr: acknowledged_timestamp
    - name: "Action Priority"
      expr: action_priority
    - name: "Alert Category"
      expr: alert_category
    - name: "Alert Generated Timestamp"
      expr: alert_generated_timestamp
    - name: "Alert Number"
      expr: alert_number
    - name: "Alert Type"
      expr: alert_type
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Environmental Risk Flag"
      expr: environmental_risk_flag
    - name: "False Positive Flag"
      expr: false_positive_flag
    - name: "Functional Location"
      expr: functional_location
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Model Name"
      expr: model_name
    - name: "Model Version"
      expr: model_version
    - name: "Plant Code"
      expr: plant_code
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Predictive Alert"
      expr: COUNT(DISTINCT predictive_alert_id)
    - name: "Total Actual Value"
      expr: SUM(actual_value)
    - name: "Average Actual Value"
      expr: AVG(actual_value)
    - name: "Total Confidence Score"
      expr: SUM(confidence_score)
    - name: "Average Confidence Score"
      expr: AVG(confidence_score)
    - name: "Total Deviation Percent"
      expr: SUM(deviation_percent)
    - name: "Average Deviation Percent"
      expr: AVG(deviation_percent)
    - name: "Total Threshold Value"
      expr: SUM(threshold_value)
    - name: "Average Threshold Value"
      expr: AVG(threshold_value)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_reliability_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Reliability Record business metrics"
  source: "`manufacturing_ecm`.`asset`.`reliability_record`"
  dimensions:
    - name: "Asset Category"
      expr: asset_category
    - name: "Asset Criticality"
      expr: asset_criticality
    - name: "Asset Name"
      expr: asset_name
    - name: "Asset Number"
      expr: asset_number
    - name: "Computed Timestamp"
      expr: computed_timestamp
    - name: "Condition Monitoring Status"
      expr: condition_monitoring_status
    - name: "Corrective Work Order Count"
      expr: corrective_work_order_count
    - name: "Country Code"
      expr: country_code
    - name: "Data Source System"
      expr: data_source_system
    - name: "Failure Count"
      expr: failure_count
    - name: "Failure Mode Primary"
      expr: failure_mode_primary
    - name: "Last Failure Date"
      expr: last_failure_date
    - name: "Last Preventive Maintenance Date"
      expr: last_preventive_maintenance_date
    - name: "Maintenance Cost Currency Code"
      expr: maintenance_cost_currency_code
    - name: "Next Preventive Maintenance Date"
      expr: next_preventive_maintenance_date
    - name: "Period End Date"
      expr: period_end_date
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Reliability Record"
      expr: COUNT(DISTINCT reliability_record_id)
    - name: "Total Asset Age Years"
      expr: SUM(asset_age_years)
    - name: "Average Asset Age Years"
      expr: AVG(asset_age_years)
    - name: "Total Availability Percentage"
      expr: SUM(availability_percentage)
    - name: "Average Availability Percentage"
      expr: AVG(availability_percentage)
    - name: "Total Availability Target Percentage"
      expr: SUM(availability_target_percentage)
    - name: "Average Availability Target Percentage"
      expr: AVG(availability_target_percentage)
    - name: "Total Maintenance Cost Local Currency"
      expr: SUM(maintenance_cost_local_currency)
    - name: "Average Maintenance Cost Local Currency"
      expr: AVG(maintenance_cost_local_currency)
    - name: "Total Mean Time Between Failures Hours"
      expr: SUM(mean_time_between_failures_hours)
    - name: "Average Mean Time Between Failures Hours"
      expr: AVG(mean_time_between_failures_hours)
    - name: "Total Mean Time To Repair Hours"
      expr: SUM(mean_time_to_repair_hours)
    - name: "Average Mean Time To Repair Hours"
      expr: AVG(mean_time_to_repair_hours)
    - name: "Total Oee Contribution Percentage"
      expr: SUM(oee_contribution_percentage)
    - name: "Average Oee Contribution Percentage"
      expr: AVG(oee_contribution_percentage)
    - name: "Total Planned Downtime Hours"
      expr: SUM(planned_downtime_hours)
    - name: "Average Planned Downtime Hours"
      expr: AVG(planned_downtime_hours)
    - name: "Total Preventive Maintenance Compliance Percentage"
      expr: SUM(preventive_maintenance_compliance_percentage)
    - name: "Average Preventive Maintenance Compliance Percentage"
      expr: AVG(preventive_maintenance_compliance_percentage)
    - name: "Total Reliability Target Mtbf Hours"
      expr: SUM(reliability_target_mtbf_hours)
    - name: "Average Reliability Target Mtbf Hours"
      expr: AVG(reliability_target_mtbf_hours)
    - name: "Total Remaining Useful Life Years"
      expr: SUM(remaining_useful_life_years)
    - name: "Average Remaining Useful Life Years"
      expr: AVG(remaining_useful_life_years)
    - name: "Total Scheduled Operating Hours"
      expr: SUM(scheduled_operating_hours)
    - name: "Average Scheduled Operating Hours"
      expr: AVG(scheduled_operating_hours)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_service_contract`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service Contract business metrics"
  source: "`manufacturing_ecm`.`asset`.`service_contract`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Auto Renewal Flag"
      expr: auto_renewal_flag
    - name: "Contract Category"
      expr: contract_category
    - name: "Contract Title"
      expr: contract_title
    - name: "Contract Type"
      expr: contract_type
    - name: "Cost Center"
      expr: cost_center
    - name: "Country Code"
      expr: country_code
    - name: "Covered Asset Scope"
      expr: covered_asset_scope
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Emergency Response Included"
      expr: emergency_response_included
    - name: "End Date"
      expr: end_date
    - name: "Gl Account Code"
      expr: gl_account_code
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Notice Period Days"
      expr: notice_period_days
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Service Contract"
      expr: COUNT(DISTINCT service_contract_id)
    - name: "Total Annual Value"
      expr: SUM(annual_value)
    - name: "Average Annual Value"
      expr: AVG(annual_value)
    - name: "Total Penalty Rate Percent"
      expr: SUM(penalty_rate_percent)
    - name: "Average Penalty Rate Percent"
      expr: AVG(penalty_rate_percent)
    - name: "Total Sla Resolution Time Hours"
      expr: SUM(sla_resolution_time_hours)
    - name: "Average Sla Resolution Time Hours"
      expr: AVG(sla_resolution_time_hours)
    - name: "Total Sla Response Time Hours"
      expr: SUM(sla_response_time_hours)
    - name: "Average Sla Response Time Hours"
      expr: AVG(sla_response_time_hours)
    - name: "Total Uptime Guarantee Percent"
      expr: SUM(uptime_guarantee_percent)
    - name: "Average Uptime Guarantee Percent"
      expr: AVG(uptime_guarantee_percent)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_shutdown_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Shutdown Plan business metrics"
  source: "`manufacturing_ecm`.`asset`.`shutdown_plan`"
  dimensions:
    - name: "Actual End Date"
      expr: actual_end_date
    - name: "Actual Start Date"
      expr: actual_start_date
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Budget Code"
      expr: budget_code
    - name: "Capex Opex Classification"
      expr: capex_opex_classification
    - name: "Contractor Required Flag"
      expr: contractor_required_flag
    - name: "Cost Center"
      expr: cost_center
    - name: "Country Code"
      expr: country_code
    - name: "Craft Types Required"
      expr: craft_types_required
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Critical Path Description"
      expr: critical_path_description
    - name: "Currency Code"
      expr: currency_code
    - name: "Description"
      expr: description
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Name"
      expr: name
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Shutdown Plan"
      expr: COUNT(DISTINCT shutdown_plan_id)
    - name: "Total Actual Cost"
      expr: SUM(actual_cost)
    - name: "Average Actual Cost"
      expr: AVG(actual_cost)
    - name: "Total Estimated Cost"
      expr: SUM(estimated_cost)
    - name: "Average Estimated Cost"
      expr: AVG(estimated_cost)
    - name: "Total Estimated Labor Hours"
      expr: SUM(estimated_labor_hours)
    - name: "Average Estimated Labor Hours"
      expr: AVG(estimated_labor_hours)
    - name: "Total Estimated Production Loss Hours"
      expr: SUM(estimated_production_loss_hours)
    - name: "Average Estimated Production Loss Hours"
      expr: AVG(estimated_production_loss_hours)
    - name: "Total Planned Duration Days"
      expr: SUM(planned_duration_days)
    - name: "Average Planned Duration Days"
      expr: AVG(planned_duration_days)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_task_list`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Task List business metrics"
  source: "`manufacturing_ecm`.`asset`.`task_list`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Change Notice Number"
      expr: change_notice_number
    - name: "Cost Currency"
      expr: cost_currency
    - name: "Craft Type"
      expr: craft_type
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Description"
      expr: description
    - name: "Equipment Category"
      expr: equipment_category
    - name: "Group Counter"
      expr: group_counter
    - name: "Group Number"
      expr: group_number
    - name: "Hazardous Material Indicator"
      expr: hazardous_material_indicator
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Lockout Tagout Required"
      expr: lockout_tagout_required
    - name: "Maintenance Type"
      expr: maintenance_type
    - name: "Material List Indicator"
      expr: material_list_indicator
    - name: "Name"
      expr: name
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Task List"
      expr: COUNT(DISTINCT task_list_id)
    - name: "Total Estimated Duration Hours"
      expr: SUM(estimated_duration_hours)
    - name: "Average Estimated Duration Hours"
      expr: AVG(estimated_duration_hours)
    - name: "Total Estimated Labor Cost"
      expr: SUM(estimated_labor_cost)
    - name: "Average Estimated Labor Cost"
      expr: AVG(estimated_labor_cost)
    - name: "Total Estimated Material Cost"
      expr: SUM(estimated_material_cost)
    - name: "Average Estimated Material Cost"
      expr: AVG(estimated_material_cost)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_warranty`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Warranty business metrics"
  source: "`manufacturing_ecm`.`asset`.`warranty`"
  dimensions:
    - name: "Category"
      expr: category
    - name: "Claim Procedure"
      expr: claim_procedure
    - name: "Claim Submission Deadline Days"
      expr: claim_submission_deadline_days
    - name: "Contract Reference Number"
      expr: contract_reference_number
    - name: "Country Code"
      expr: country_code
    - name: "Coverage Basis"
      expr: coverage_basis
    - name: "Covered Components"
      expr: covered_components
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Document Reference"
      expr: document_reference
    - name: "Exclusions"
      expr: exclusions
    - name: "Expiry Date"
      expr: expiry_date
    - name: "Labor Covered Flag"
      expr: labor_covered_flag
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Model Number"
      expr: model_number
    - name: "Name"
      expr: name
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Warranty"
      expr: COUNT(DISTINCT warranty_id)
    - name: "Total Response Time Hours"
      expr: SUM(response_time_hours)
    - name: "Average Response Time Hours"
      expr: AVG(response_time_hours)
    - name: "Total Total Claim Limit Amount"
      expr: SUM(total_claim_limit_amount)
    - name: "Average Total Claim Limit Amount"
      expr: AVG(total_claim_limit_amount)
    - name: "Total Total Claimed Amount"
      expr: SUM(total_claimed_amount)
    - name: "Average Total Claimed Amount"
      expr: AVG(total_claimed_amount)
    - name: "Total Usage Limit Value"
      expr: SUM(usage_limit_value)
    - name: "Average Usage Limit Value"
      expr: AVG(usage_limit_value)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`asset_work_order_operation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Work Order Operation business metrics"
  source: "`manufacturing_ecm`.`asset`.`work_order_operation`"
  dimensions:
    - name: "Activity Type"
      expr: activity_type
    - name: "Actual Finish Timestamp"
      expr: actual_finish_timestamp
    - name: "Actual Start Timestamp"
      expr: actual_start_timestamp
    - name: "Completion Confirmation Text"
      expr: completion_confirmation_text
    - name: "Confirmation Number"
      expr: confirmation_number
    - name: "Control Key"
      expr: control_key
    - name: "Cost Currency"
      expr: cost_currency
    - name: "Cost Element"
      expr: cost_element
    - name: "Craft Type"
      expr: craft_type
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "External Service Order Number"
      expr: external_service_order_number
    - name: "Is Milestone"
      expr: is_milestone
    - name: "Is Safety Critical"
      expr: is_safety_critical
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Number Of Technicians"
      expr: number_of_technicians
    - name: "Operation Long Text"
      expr: operation_long_text
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Work Order Operation"
      expr: COUNT(DISTINCT work_order_operation_id)
    - name: "Total Actual Cost"
      expr: SUM(actual_cost)
    - name: "Average Actual Cost"
      expr: AVG(actual_cost)
    - name: "Total Actual Duration Hours"
      expr: SUM(actual_duration_hours)
    - name: "Average Actual Duration Hours"
      expr: AVG(actual_duration_hours)
    - name: "Total Actual Labor Hours"
      expr: SUM(actual_labor_hours)
    - name: "Average Actual Labor Hours"
      expr: AVG(actual_labor_hours)
    - name: "Total Estimated Cost"
      expr: SUM(estimated_cost)
    - name: "Average Estimated Cost"
      expr: AVG(estimated_cost)
    - name: "Total Estimated Duration Hours"
      expr: SUM(estimated_duration_hours)
    - name: "Average Estimated Duration Hours"
      expr: AVG(estimated_duration_hours)
    - name: "Total Estimated Labor Hours"
      expr: SUM(estimated_labor_hours)
    - name: "Average Estimated Labor Hours"
      expr: AVG(estimated_labor_hours)
    - name: "Total Remaining Labor Hours"
      expr: SUM(remaining_labor_hours)
    - name: "Average Remaining Labor Hours"
      expr: AVG(remaining_labor_hours)
$$;