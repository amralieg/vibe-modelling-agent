-- Metric views for domain: engineering | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_ecn`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering Change Notice (ECN) metrics tracking change management effectiveness, cost impact, and implementation performance"
  source: "`manufacturing_ecm`.`engineering`.`ecn`"
  dimensions:
    - name: "change_type"
      expr: change_type
      comment: "Type of engineering change (e.g., design, process, material)"
    - name: "priority"
      expr: priority
      comment: "Priority level of the change notice"
    - name: "status"
      expr: status
      comment: "Current status of the ECN (e.g., draft, approved, implemented, rejected)"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant affected by the change"
    - name: "owning_department"
      expr: owning_department
      comment: "Department responsible for the change"
    - name: "safety_impact"
      expr: safety_impact
      comment: "Whether the change has safety implications"
    - name: "regulatory_compliance_impact"
      expr: regulatory_compliance_impact
      comment: "Whether the change affects regulatory compliance"
    - name: "requires_ppap"
      expr: requires_ppap
      comment: "Whether Production Part Approval Process is required"
    - name: "approval_year"
      expr: YEAR(approval_date)
      comment: "Year when the ECN was approved"
    - name: "approval_quarter"
      expr: CONCAT('Q', QUARTER(approval_date), '-', YEAR(approval_date))
      comment: "Quarter when the ECN was approved"
    - name: "approval_month"
      expr: DATE_TRUNC('MONTH', approval_date)
      comment: "Month when the ECN was approved"
  measures:
    - name: "total_ecn_count"
      expr: COUNT(1)
      comment: "Total number of engineering change notices"
    - name: "unique_ecn_count"
      expr: COUNT(DISTINCT ecn_id)
      comment: "Distinct count of engineering change notices"
    - name: "total_estimated_implementation_cost"
      expr: SUM(CAST(estimated_implementation_cost AS DOUBLE))
      comment: "Total estimated cost to implement all ECNs"
    - name: "total_actual_implementation_cost"
      expr: SUM(CAST(actual_implementation_cost AS DOUBLE))
      comment: "Total actual cost incurred implementing ECNs"
    - name: "avg_estimated_implementation_cost"
      expr: AVG(CAST(estimated_implementation_cost AS DOUBLE))
      comment: "Average estimated implementation cost per ECN"
    - name: "avg_actual_implementation_cost"
      expr: AVG(CAST(actual_implementation_cost AS DOUBLE))
      comment: "Average actual implementation cost per ECN"
    - name: "safety_critical_ecn_count"
      expr: COUNT(CASE WHEN safety_impact = TRUE THEN 1 END)
      comment: "Number of ECNs with safety impact"
    - name: "regulatory_impact_ecn_count"
      expr: COUNT(CASE WHEN regulatory_compliance_impact = TRUE THEN 1 END)
      comment: "Number of ECNs affecting regulatory compliance"
    - name: "ppap_required_ecn_count"
      expr: COUNT(CASE WHEN requires_ppap = TRUE THEN 1 END)
      comment: "Number of ECNs requiring PPAP revalidation"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_eco`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering Change Order (ECO) metrics tracking change execution, cost variance, and completion performance"
  source: "`manufacturing_ecm`.`engineering`.`eco`"
  dimensions:
    - name: "change_type"
      expr: change_type
      comment: "Type of engineering change order"
    - name: "change_class"
      expr: change_class
      comment: "Classification of the change (e.g., major, minor, emergency)"
    - name: "status"
      expr: status
      comment: "Current status of the ECO"
    - name: "priority"
      expr: priority
      comment: "Priority level of the change order"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where change is implemented"
    - name: "originating_department"
      expr: originating_department
      comment: "Department that originated the change order"
    - name: "ppap_required"
      expr: ppap_required
      comment: "Whether PPAP is required for this change"
    - name: "regulatory_driven"
      expr: regulatory_driven
      comment: "Whether the change is driven by regulatory requirements"
    - name: "approved_year"
      expr: YEAR(approved_date)
      comment: "Year when the ECO was approved"
    - name: "completed_year"
      expr: YEAR(completed_date)
      comment: "Year when the ECO was completed"
  measures:
    - name: "total_eco_count"
      expr: COUNT(1)
      comment: "Total number of engineering change orders"
    - name: "unique_eco_count"
      expr: COUNT(DISTINCT eco_id)
      comment: "Distinct count of engineering change orders"
    - name: "total_estimated_cost"
      expr: SUM(CAST(estimated_cost AS DOUBLE))
      comment: "Total estimated cost for all ECOs"
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_cost AS DOUBLE))
      comment: "Total actual cost incurred for all ECOs"
    - name: "avg_estimated_cost"
      expr: AVG(CAST(estimated_cost AS DOUBLE))
      comment: "Average estimated cost per ECO"
    - name: "avg_actual_cost"
      expr: AVG(CAST(actual_cost AS DOUBLE))
      comment: "Average actual cost per ECO"
    - name: "regulatory_driven_eco_count"
      expr: COUNT(CASE WHEN regulatory_driven = TRUE THEN 1 END)
      comment: "Number of ECOs driven by regulatory requirements"
    - name: "ppap_required_eco_count"
      expr: COUNT(CASE WHEN ppap_required = TRUE THEN 1 END)
      comment: "Number of ECOs requiring PPAP"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_dfmea`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Design Failure Mode and Effects Analysis (DFMEA) metrics tracking risk assessment, RPN trends, and action effectiveness"
  source: "`manufacturing_ecm`.`engineering`.`dfmea`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current status of the DFMEA"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "Advanced Product Quality Planning phase"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "safety_critical"
      expr: safety_critical
      comment: "Whether the failure mode is safety critical"
    - name: "regulatory_compliance_flag"
      expr: regulatory_compliance_flag
      comment: "Whether regulatory compliance is affected"
    - name: "ppap_submission_required"
      expr: ppap_submission_required
      comment: "Whether PPAP submission is required"
    - name: "action_priority"
      expr: action_priority
      comment: "Priority level of recommended actions"
    - name: "preparation_year"
      expr: YEAR(preparation_date)
      comment: "Year when DFMEA was prepared"
  measures:
    - name: "total_dfmea_count"
      expr: COUNT(1)
      comment: "Total number of DFMEA records"
    - name: "unique_dfmea_count"
      expr: COUNT(DISTINCT dfmea_id)
      comment: "Distinct count of DFMEAs"
    - name: "safety_critical_dfmea_count"
      expr: COUNT(CASE WHEN safety_critical = TRUE THEN 1 END)
      comment: "Number of safety-critical failure modes identified"
    - name: "regulatory_compliance_dfmea_count"
      expr: COUNT(CASE WHEN regulatory_compliance_flag = TRUE THEN 1 END)
      comment: "Number of DFMEAs with regulatory compliance implications"
    - name: "ppap_required_dfmea_count"
      expr: COUNT(CASE WHEN ppap_submission_required = TRUE THEN 1 END)
      comment: "Number of DFMEAs requiring PPAP submission"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_pfmea`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Process Failure Mode and Effects Analysis (PFMEA) metrics tracking process risk, control effectiveness, and action closure"
  source: "`manufacturing_ecm`.`engineering`.`pfmea`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current status of the PFMEA"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "action_priority"
      expr: action_priority
      comment: "Priority level of recommended actions"
    - name: "approval_year"
      expr: YEAR(approval_date)
      comment: "Year when PFMEA was approved"
  measures:
    - name: "total_pfmea_count"
      expr: COUNT(1)
      comment: "Total number of PFMEA records"
    - name: "unique_pfmea_count"
      expr: COUNT(DISTINCT pfmea_id)
      comment: "Distinct count of PFMEAs"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_design_review`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Design review metrics tracking review effectiveness, action item closure, and compliance verification"
  source: "`manufacturing_ecm`.`engineering`.`design_review`"
  dimensions:
    - name: "review_type"
      expr: review_type
      comment: "Type of design review (e.g., preliminary, critical, final)"
    - name: "status"
      expr: status
      comment: "Current status of the design review"
    - name: "disposition"
      expr: disposition
      comment: "Review disposition (e.g., approved, conditional, rejected)"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "APQP phase during which review was conducted"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "ce_marking_applicable"
      expr: ce_marking_applicable
      comment: "Whether CE marking is applicable"
    - name: "is_reach_compliant"
      expr: is_reach_compliant
      comment: "Whether design is REACH compliant"
    - name: "is_rohs_compliant"
      expr: is_rohs_compliant
      comment: "Whether design is RoHS compliant"
    - name: "review_year"
      expr: YEAR(review_date)
      comment: "Year when design review was conducted"
  measures:
    - name: "total_design_review_count"
      expr: COUNT(1)
      comment: "Total number of design reviews"
    - name: "unique_design_review_count"
      expr: COUNT(DISTINCT design_review_id)
      comment: "Distinct count of design reviews"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_design_review_action`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Design review action item metrics tracking closure rate, escalation, and risk mitigation effectiveness"
  source: "`manufacturing_ecm`.`engineering`.`design_review_action`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current status of the action item"
    - name: "priority"
      expr: priority
      comment: "Priority level of the action item"
    - name: "action_type"
      expr: action_type
      comment: "Type of action required"
    - name: "category"
      expr: category
      comment: "Category of the action item"
    - name: "risk_level"
      expr: risk_level
      comment: "Risk level associated with the action"
    - name: "safety_critical"
      expr: safety_critical
      comment: "Whether the action is safety critical"
    - name: "regulatory_compliance_flag"
      expr: regulatory_compliance_flag
      comment: "Whether regulatory compliance is affected"
    - name: "ppap_relevant"
      expr: ppap_relevant
      comment: "Whether the action is relevant to PPAP"
    - name: "escalation_flag"
      expr: escalation_flag
      comment: "Whether the action has been escalated"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "owner_department"
      expr: owner_department
      comment: "Department responsible for the action"
    - name: "raised_year"
      expr: YEAR(raised_date)
      comment: "Year when action was raised"
  measures:
    - name: "total_action_count"
      expr: COUNT(1)
      comment: "Total number of design review action items"
    - name: "unique_action_count"
      expr: COUNT(DISTINCT design_review_action_id)
      comment: "Distinct count of design review actions"
    - name: "safety_critical_action_count"
      expr: COUNT(CASE WHEN safety_critical = TRUE THEN 1 END)
      comment: "Number of safety-critical action items"
    - name: "escalated_action_count"
      expr: COUNT(CASE WHEN escalation_flag = TRUE THEN 1 END)
      comment: "Number of escalated action items"
    - name: "regulatory_action_count"
      expr: COUNT(CASE WHEN regulatory_compliance_flag = TRUE THEN 1 END)
      comment: "Number of actions with regulatory compliance implications"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_design_validation_test`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Design validation test metrics tracking test pass rate, compliance verification, and deviation management"
  source: "`manufacturing_ecm`.`engineering`.`design_validation_test`"
  dimensions:
    - name: "test_type"
      expr: test_type
      comment: "Type of validation test conducted"
    - name: "test_phase"
      expr: test_phase
      comment: "Phase of testing (e.g., prototype, pilot, production)"
    - name: "status"
      expr: status
      comment: "Current status of the test"
    - name: "result"
      expr: result
      comment: "Test result (e.g., pass, fail, conditional)"
    - name: "test_standard"
      expr: test_standard
      comment: "Standard or specification tested against"
    - name: "ce_marking_applicable"
      expr: ce_marking_applicable
      comment: "Whether CE marking is applicable"
    - name: "ppap_applicable"
      expr: ppap_applicable
      comment: "Whether test is part of PPAP"
    - name: "ul_certification_applicable"
      expr: ul_certification_applicable
      comment: "Whether UL certification is applicable"
    - name: "regulatory_submission_flag"
      expr: regulatory_submission_flag
      comment: "Whether test results require regulatory submission"
    - name: "test_facility_country"
      expr: test_facility_country
      comment: "Country where test was conducted"
    - name: "test_year"
      expr: YEAR(actual_start_date)
      comment: "Year when test was started"
  measures:
    - name: "total_test_count"
      expr: COUNT(1)
      comment: "Total number of design validation tests"
    - name: "unique_test_count"
      expr: COUNT(DISTINCT design_validation_test_id)
      comment: "Distinct count of design validation tests"
    - name: "avg_measured_value"
      expr: AVG(CAST(measured_value AS DOUBLE))
      comment: "Average measured value across tests"
    - name: "avg_acceptance_criteria_min"
      expr: AVG(CAST(acceptance_criteria_min AS DOUBLE))
      comment: "Average minimum acceptance criteria"
    - name: "avg_acceptance_criteria_max"
      expr: AVG(CAST(acceptance_criteria_max AS DOUBLE))
      comment: "Average maximum acceptance criteria"
    - name: "regulatory_submission_test_count"
      expr: COUNT(CASE WHEN regulatory_submission_flag = TRUE THEN 1 END)
      comment: "Number of tests requiring regulatory submission"
    - name: "ppap_applicable_test_count"
      expr: COUNT(CASE WHEN ppap_applicable = TRUE THEN 1 END)
      comment: "Number of tests applicable to PPAP"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_engineering_prototype`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering prototype metrics tracking build cost variance, test effectiveness, and PPAP readiness"
  source: "`manufacturing_ecm`.`engineering`.`engineering_prototype`"
  dimensions:
    - name: "type"
      expr: type
      comment: "Type of prototype (e.g., concept, functional, production-intent)"
    - name: "status"
      expr: status
      comment: "Current status of the prototype"
    - name: "disposition"
      expr: disposition
      comment: "Disposition of the prototype after testing"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "APQP phase during prototype build"
    - name: "ppap_status"
      expr: ppap_status
      comment: "PPAP status of the prototype"
    - name: "fai_status"
      expr: fai_status
      comment: "First Article Inspection status"
    - name: "test_result"
      expr: test_result
      comment: "Overall test result for the prototype"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where prototype was built"
    - name: "product_line"
      expr: product_line
      comment: "Product line of the prototype"
    - name: "is_reach_compliant"
      expr: is_reach_compliant
      comment: "Whether prototype is REACH compliant"
    - name: "is_rohs_compliant"
      expr: is_rohs_compliant
      comment: "Whether prototype is RoHS compliant"
    - name: "build_year"
      expr: YEAR(build_date)
      comment: "Year when prototype was built"
  measures:
    - name: "total_prototype_count"
      expr: COUNT(1)
      comment: "Total number of engineering prototypes"
    - name: "unique_prototype_count"
      expr: COUNT(DISTINCT engineering_prototype_id)
      comment: "Distinct count of engineering prototypes"
    - name: "total_estimated_build_cost"
      expr: SUM(CAST(estimated_build_cost AS DOUBLE))
      comment: "Total estimated cost to build all prototypes"
    - name: "total_actual_build_cost"
      expr: SUM(CAST(actual_build_cost AS DOUBLE))
      comment: "Total actual cost incurred building prototypes"
    - name: "avg_estimated_build_cost"
      expr: AVG(CAST(estimated_build_cost AS DOUBLE))
      comment: "Average estimated build cost per prototype"
    - name: "avg_actual_build_cost"
      expr: AVG(CAST(actual_build_cost AS DOUBLE))
      comment: "Average actual build cost per prototype"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_project`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering project metrics tracking budget variance, schedule performance, and APQP gate effectiveness"
  source: "`manufacturing_ecm`.`engineering`.`project`"
  dimensions:
    - name: "type"
      expr: type
      comment: "Type of engineering project"
    - name: "status"
      expr: status
      comment: "Current status of the project"
    - name: "phase"
      expr: phase
      comment: "Current phase of the project"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "APQP phase of the project"
    - name: "priority"
      expr: priority
      comment: "Priority level of the project"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant associated with the project"
    - name: "product_line"
      expr: product_line
      comment: "Product line of the project"
    - name: "owning_department"
      expr: owning_department
      comment: "Department owning the project"
    - name: "ppap_required"
      expr: ppap_required
      comment: "Whether PPAP is required for the project"
    - name: "gate_review_outcome"
      expr: gate_review_outcome
      comment: "Outcome of the gate review"
    - name: "capex_opex_classification"
      expr: capex_opex_classification
      comment: "Whether project is CAPEX or OPEX"
    - name: "target_market"
      expr: target_market
      comment: "Target market for the project"
    - name: "planned_start_year"
      expr: YEAR(planned_start_date)
      comment: "Year when project is planned to start"
  measures:
    - name: "total_project_count"
      expr: COUNT(1)
      comment: "Total number of engineering projects"
    - name: "unique_project_count"
      expr: COUNT(DISTINCT project_id)
      comment: "Distinct count of engineering projects"
    - name: "total_approved_budget"
      expr: SUM(CAST(approved_budget AS DOUBLE))
      comment: "Total approved budget across all projects"
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_cost AS DOUBLE))
      comment: "Total actual cost incurred across all projects"
    - name: "total_estimated_development_cost"
      expr: SUM(CAST(estimated_development_cost AS DOUBLE))
      comment: "Total estimated development cost for all projects"
    - name: "avg_approved_budget"
      expr: AVG(CAST(approved_budget AS DOUBLE))
      comment: "Average approved budget per project"
    - name: "avg_actual_cost"
      expr: AVG(CAST(actual_cost AS DOUBLE))
      comment: "Average actual cost per project"
    - name: "avg_target_unit_cost"
      expr: AVG(CAST(target_unit_cost AS DOUBLE))
      comment: "Average target unit cost across projects"
    - name: "ppap_required_project_count"
      expr: COUNT(CASE WHEN ppap_required = TRUE THEN 1 END)
      comment: "Number of projects requiring PPAP"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_component_revision`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Component revision metrics tracking revision frequency, cost impact, and compliance status"
  source: "`manufacturing_ecm`.`engineering`.`component_revision`"
  dimensions:
    - name: "revision_status"
      expr: revision_status
      comment: "Status of the component revision"
    - name: "revision_type"
      expr: revision_type
      comment: "Type of revision (e.g., major, minor, emergency)"
    - name: "lifecycle_phase"
      expr: lifecycle_phase
      comment: "Lifecycle phase of the component"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "is_form_fit_function_change"
      expr: is_form_fit_function_change
      comment: "Whether revision affects form, fit, or function"
    - name: "is_safety_critical"
      expr: is_safety_critical
      comment: "Whether component is safety critical"
    - name: "ppap_required"
      expr: ppap_required
      comment: "Whether PPAP is required for this revision"
    - name: "is_reach_compliant"
      expr: is_reach_compliant
      comment: "Whether component is REACH compliant"
    - name: "is_rohs_compliant"
      expr: is_rohs_compliant
      comment: "Whether component is RoHS compliant"
    - name: "release_year"
      expr: YEAR(release_date)
      comment: "Year when revision was released"
  measures:
    - name: "total_revision_count"
      expr: COUNT(1)
      comment: "Total number of component revisions"
    - name: "unique_revision_count"
      expr: COUNT(DISTINCT component_revision_id)
      comment: "Distinct count of component revisions"
    - name: "unique_component_count"
      expr: COUNT(DISTINCT component_id)
      comment: "Distinct count of components with revisions"
    - name: "total_standard_cost"
      expr: SUM(CAST(standard_cost AS DOUBLE))
      comment: "Total standard cost across all component revisions"
    - name: "avg_standard_cost"
      expr: AVG(CAST(standard_cost AS DOUBLE))
      comment: "Average standard cost per component revision"
    - name: "avg_weight_kg"
      expr: AVG(CAST(weight_kg AS DOUBLE))
      comment: "Average weight in kilograms per component revision"
    - name: "form_fit_function_change_count"
      expr: COUNT(CASE WHEN is_form_fit_function_change = TRUE THEN 1 END)
      comment: "Number of revisions affecting form, fit, or function"
    - name: "safety_critical_revision_count"
      expr: COUNT(CASE WHEN is_safety_critical = TRUE THEN 1 END)
      comment: "Number of safety-critical component revisions"
    - name: "ppap_required_revision_count"
      expr: COUNT(CASE WHEN ppap_required = TRUE THEN 1 END)
      comment: "Number of revisions requiring PPAP"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_bop_operation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Bill of Process operation metrics tracking cycle time, labor efficiency, and process cost"
  source: "`manufacturing_ecm`.`engineering`.`bop_operation`"
  dimensions:
    - name: "operation_type"
      expr: operation_type
      comment: "Type of manufacturing operation"
    - name: "status"
      expr: status
      comment: "Status of the operation"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where operation is performed"
    - name: "inspection_relevant"
      expr: inspection_relevant
      comment: "Whether operation requires inspection"
    - name: "hazardous_material_relevant"
      expr: hazardous_material_relevant
      comment: "Whether operation involves hazardous materials"
    - name: "scheduling_type"
      expr: scheduling_type
      comment: "Type of scheduling used for the operation"
    - name: "effective_year"
      expr: YEAR(effective_from_date)
      comment: "Year when operation became effective"
  measures:
    - name: "total_operation_count"
      expr: COUNT(1)
      comment: "Total number of BOP operations"
    - name: "unique_operation_count"
      expr: COUNT(DISTINCT bop_operation_id)
      comment: "Distinct count of BOP operations"
    - name: "total_setup_time_min"
      expr: SUM(CAST(setup_time_min AS DOUBLE))
      comment: "Total setup time in minutes across all operations"
    - name: "total_machine_time_min"
      expr: SUM(CAST(machine_time_min AS DOUBLE))
      comment: "Total machine time in minutes across all operations"
    - name: "total_labor_time_min"
      expr: SUM(CAST(labor_time_min AS DOUBLE))
      comment: "Total labor time in minutes across all operations"
    - name: "total_teardown_time_min"
      expr: SUM(CAST(teardown_time_min AS DOUBLE))
      comment: "Total teardown time in minutes across all operations"
    - name: "avg_setup_time_min"
      expr: AVG(CAST(setup_time_min AS DOUBLE))
      comment: "Average setup time in minutes per operation"
    - name: "avg_machine_time_min"
      expr: AVG(CAST(machine_time_min AS DOUBLE))
      comment: "Average machine time in minutes per operation"
    - name: "avg_labor_time_min"
      expr: AVG(CAST(labor_time_min AS DOUBLE))
      comment: "Average labor time in minutes per operation"
    - name: "avg_interoperation_time_min"
      expr: AVG(CAST(interoperation_time_min AS DOUBLE))
      comment: "Average interoperation time in minutes"
    - name: "avg_external_processing_price"
      expr: AVG(CAST(external_processing_price AS DOUBLE))
      comment: "Average external processing price per operation"
    - name: "avg_base_quantity"
      expr: AVG(CAST(base_quantity AS DOUBLE))
      comment: "Average base quantity per operation"
    - name: "inspection_relevant_operation_count"
      expr: COUNT(CASE WHEN inspection_relevant = TRUE THEN 1 END)
      comment: "Number of operations requiring inspection"
    - name: "hazardous_material_operation_count"
      expr: COUNT(CASE WHEN hazardous_material_relevant = TRUE THEN 1 END)
      comment: "Number of operations involving hazardous materials"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_approved_manufacturer`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Approved manufacturer list metrics tracking supplier quality, lead time, and compliance status"
  source: "`manufacturing_ecm`.`engineering`.`approved_manufacturer`"
  dimensions:
    - name: "approval_status"
      expr: approval_status
      comment: "Current approval status of the manufacturer"
    - name: "aml_type"
      expr: aml_type
      comment: "Type of approved manufacturer listing"
    - name: "manufacturer_country"
      expr: manufacturer_country
      comment: "Country where manufacturer is located"
    - name: "country_of_manufacture"
      expr: country_of_manufacture
      comment: "Country where parts are manufactured"
    - name: "ppap_status"
      expr: ppap_status
      comment: "PPAP status of the manufacturer"
    - name: "is_reach_compliant"
      expr: is_reach_compliant
      comment: "Whether manufacturer is REACH compliant"
    - name: "is_rohs_compliant"
      expr: is_rohs_compliant
      comment: "Whether manufacturer is RoHS compliant"
    - name: "ce_marking_confirmed"
      expr: ce_marking_confirmed
      comment: "Whether CE marking has been confirmed"
    - name: "approval_year"
      expr: YEAR(approval_date)
      comment: "Year when manufacturer was approved"
  measures:
    - name: "total_approved_manufacturer_count"
      expr: COUNT(1)
      comment: "Total number of approved manufacturer records"
    - name: "unique_approved_manufacturer_count"
      expr: COUNT(DISTINCT approved_manufacturer_id)
      comment: "Distinct count of approved manufacturers"
    - name: "avg_quality_rating"
      expr: AVG(CAST(quality_rating AS DOUBLE))
      comment: "Average quality rating across approved manufacturers"
    - name: "avg_ppm_defect_rate"
      expr: AVG(CAST(ppm_defect_rate AS DOUBLE))
      comment: "Average parts per million defect rate"
    - name: "avg_unit_price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average unit price across approved manufacturers"
    - name: "avg_minimum_order_quantity"
      expr: AVG(CAST(minimum_order_quantity AS DOUBLE))
      comment: "Average minimum order quantity"
    - name: "reach_compliant_manufacturer_count"
      expr: COUNT(CASE WHEN is_reach_compliant = TRUE THEN 1 END)
      comment: "Number of REACH compliant manufacturers"
    - name: "rohs_compliant_manufacturer_count"
      expr: COUNT(CASE WHEN is_rohs_compliant = TRUE THEN 1 END)
      comment: "Number of RoHS compliant manufacturers"
    - name: "ce_marking_confirmed_count"
      expr: COUNT(CASE WHEN ce_marking_confirmed = TRUE THEN 1 END)
      comment: "Number of manufacturers with confirmed CE marking"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_change_affected_item`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Change affected item metrics tracking change impact, implementation status, and cost implications"
  source: "`manufacturing_ecm`.`engineering`.`change_affected_item`"
  dimensions:
    - name: "change_action"
      expr: change_action
      comment: "Action taken on the affected item (e.g., add, modify, delete)"
    - name: "item_type"
      expr: item_type
      comment: "Type of item affected by the change"
    - name: "implementation_status"
      expr: implementation_status
      comment: "Status of change implementation"
    - name: "impact_level"
      expr: impact_level
      comment: "Level of impact from the change"
    - name: "cost_impact_category"
      expr: cost_impact_category
      comment: "Category of cost impact"
    - name: "effectivity_type"
      expr: effectivity_type
      comment: "Type of effectivity (e.g., date, serial number, lot)"
    - name: "safety_critical_flag"
      expr: safety_critical_flag
      comment: "Whether the affected item is safety critical"
    - name: "regulatory_approval_required"
      expr: regulatory_approval_required
      comment: "Whether regulatory approval is required"
    - name: "form_fit_function_flag"
      expr: form_fit_function_flag
      comment: "Whether change affects form, fit, or function"
    - name: "owning_plant_code"
      expr: owning_plant_code
      comment: "Plant code owning the affected item"
    - name: "implementation_year"
      expr: YEAR(implementation_date)
      comment: "Year when change was implemented"
  measures:
    - name: "total_affected_item_count"
      expr: COUNT(1)
      comment: "Total number of items affected by changes"
    - name: "unique_affected_item_count"
      expr: COUNT(DISTINCT change_affected_item_id)
      comment: "Distinct count of affected items"
    - name: "total_estimated_cost_impact"
      expr: SUM(CAST(estimated_cost_impact AS DOUBLE))
      comment: "Total estimated cost impact of all changes"
    - name: "avg_estimated_cost_impact"
      expr: AVG(CAST(estimated_cost_impact AS DOUBLE))
      comment: "Average estimated cost impact per affected item"
    - name: "safety_critical_item_count"
      expr: COUNT(CASE WHEN safety_critical_flag = TRUE THEN 1 END)
      comment: "Number of safety-critical items affected"
    - name: "regulatory_approval_required_count"
      expr: COUNT(CASE WHEN regulatory_approval_required = TRUE THEN 1 END)
      comment: "Number of items requiring regulatory approval"
    - name: "form_fit_function_change_count"
      expr: COUNT(CASE WHEN form_fit_function_flag = TRUE THEN 1 END)
      comment: "Number of items with form, fit, or function changes"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_material_specification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Material specification metrics tracking material properties, compliance, and specification coverage"
  source: "`manufacturing_ecm`.`engineering`.`material_specification`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Status of the material specification"
    - name: "material_type"
      expr: material_type
      comment: "Type of material"
    - name: "material_group"
      expr: material_group
      comment: "Material group classification"
    - name: "base_material"
      expr: base_material
      comment: "Base material composition"
    - name: "grade_designation"
      expr: grade_designation
      comment: "Material grade designation"
    - name: "applicable_standard"
      expr: applicable_standard
      comment: "Applicable material standard"
    - name: "standard_body"
      expr: standard_body
      comment: "Standards body (e.g., ASTM, ISO, DIN)"
    - name: "is_reach_compliant"
      expr: is_reach_compliant
      comment: "Whether material is REACH compliant"
    - name: "is_rohs_compliant"
      expr: is_rohs_compliant
      comment: "Whether material is RoHS compliant"
    - name: "svhc_flag"
      expr: svhc_flag
      comment: "Whether material contains Substances of Very High Concern"
    - name: "conflict_minerals_flag"
      expr: conflict_minerals_flag
      comment: "Whether material contains conflict minerals"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "effective_year"
      expr: YEAR(effective_from_date)
      comment: "Year when specification became effective"
  measures:
    - name: "total_material_spec_count"
      expr: COUNT(1)
      comment: "Total number of material specifications"
    - name: "unique_material_spec_count"
      expr: COUNT(DISTINCT material_specification_id)
      comment: "Distinct count of material specifications"
    - name: "avg_density_kg_per_m3"
      expr: AVG(CAST(density_kg_per_m3 AS DOUBLE))
      comment: "Average material density in kg per cubic meter"
    - name: "avg_tensile_strength_min_mpa"
      expr: AVG(CAST(tensile_strength_min_mpa AS DOUBLE))
      comment: "Average minimum tensile strength in MPa"
    - name: "avg_yield_strength_min_mpa"
      expr: AVG(CAST(yield_strength_min_mpa AS DOUBLE))
      comment: "Average minimum yield strength in MPa"
    - name: "avg_elongation_min_percent"
      expr: AVG(CAST(elongation_min_percent AS DOUBLE))
      comment: "Average minimum elongation percentage"
    - name: "avg_hardness_min"
      expr: AVG(CAST(hardness_min AS DOUBLE))
      comment: "Average minimum hardness value"
    - name: "avg_hardness_max"
      expr: AVG(CAST(hardness_max AS DOUBLE))
      comment: "Average maximum hardness value"
    - name: "avg_operating_temp_min_c"
      expr: AVG(CAST(operating_temp_min_c AS DOUBLE))
      comment: "Average minimum operating temperature in Celsius"
    - name: "avg_operating_temp_max_c"
      expr: AVG(CAST(operating_temp_max_c AS DOUBLE))
      comment: "Average maximum operating temperature in Celsius"
    - name: "reach_compliant_material_count"
      expr: COUNT(CASE WHEN is_reach_compliant = TRUE THEN 1 END)
      comment: "Number of REACH compliant materials"
    - name: "rohs_compliant_material_count"
      expr: COUNT(CASE WHEN is_rohs_compliant = TRUE THEN 1 END)
      comment: "Number of RoHS compliant materials"
    - name: "svhc_material_count"
      expr: COUNT(CASE WHEN svhc_flag = TRUE THEN 1 END)
      comment: "Number of materials containing SVHC"
    - name: "conflict_minerals_material_count"
      expr: COUNT(CASE WHEN conflict_minerals_flag = TRUE THEN 1 END)
      comment: "Number of materials containing conflict minerals"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_cad_model`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "CAD model metrics tracking design maturity, file management, and model complexity"
  source: "`manufacturing_ecm`.`engineering`.`cad_model`"
  dimensions:
    - name: "model_type"
      expr: model_type
      comment: "Type of CAD model (e.g., part, assembly, drawing)"
    - name: "component_type"
      expr: component_type
      comment: "Type of component modeled"
    - name: "cad_tool"
      expr: cad_tool
      comment: "CAD software tool used"
    - name: "file_format"
      expr: file_format
      comment: "File format of the CAD model"
    - name: "dfa_status"
      expr: dfa_status
      comment: "Design for Assembly status"
    - name: "dfm_status"
      expr: dfm_status
      comment: "Design for Manufacturing status"
    - name: "is_master_model"
      expr: is_master_model
      comment: "Whether this is the master model"
    - name: "product_line"
      expr: product_line
      comment: "Product line of the model"
    - name: "primary_material"
      expr: primary_material
      comment: "Primary material of the component"
    - name: "release_year"
      expr: YEAR(release_date)
      comment: "Year when model was released"
  measures:
    - name: "total_cad_model_count"
      expr: COUNT(1)
      comment: "Total number of CAD models"
    - name: "unique_cad_model_count"
      expr: COUNT(DISTINCT cad_model_id)
      comment: "Distinct count of CAD models"
    - name: "total_file_size_mb"
      expr: SUM(CAST(file_size_mb AS DOUBLE))
      comment: "Total file size in megabytes across all CAD models"
    - name: "avg_file_size_mb"
      expr: AVG(CAST(file_size_mb AS DOUBLE))
      comment: "Average file size in megabytes per CAD model"
    - name: "avg_mass_kg"
      expr: AVG(CAST(mass_kg AS DOUBLE))
      comment: "Average mass in kilograms per CAD model"
    - name: "avg_bounding_box_x_mm"
      expr: AVG(CAST(bounding_box_x_mm AS DOUBLE))
      comment: "Average bounding box X dimension in millimeters"
    - name: "avg_bounding_box_y_mm"
      expr: AVG(CAST(bounding_box_y_mm AS DOUBLE))
      comment: "Average bounding box Y dimension in millimeters"
    - name: "avg_bounding_box_z_mm"
      expr: AVG(CAST(bounding_box_z_mm AS DOUBLE))
      comment: "Average bounding box Z dimension in millimeters"
    - name: "master_model_count"
      expr: COUNT(CASE WHEN is_master_model = TRUE THEN 1 END)
      comment: "Number of master CAD models"
$$;