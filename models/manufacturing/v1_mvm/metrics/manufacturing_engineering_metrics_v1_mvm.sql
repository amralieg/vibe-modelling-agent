-- Metric views for domain: engineering | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_bom_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering BOM line item metrics tracking component complexity, scrap risk, and structural depth across product assemblies. Supports MRP planning quality, BOM governance, and component rationalization decisions."
  source: "`manufacturing_ecm`.`engineering`.`bom_line`"
  filter: status = 'Active'
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the manufacturing facility for which the BOM line is valid. Enables plant-level BOM complexity and scrap risk analysis."
    - name: "bom_usage"
      expr: bom_usage
      comment: "BOM usage type (e.g., Production, Engineering, Costing). Allows segmentation of metrics by the business purpose of the BOM."
    - name: "item_category"
      expr: item_category
      comment: "SAP BOM item category (Stock, Non-Stock, Phantom, Document). Drives analysis of component type distribution across product structures."
    - name: "procurement_type"
      expr: procurement_type
      comment: "Make vs. buy classification for the component. Supports supply chain strategy analysis and MRP planning logic segmentation."
    - name: "bom_level"
      expr: bom_level
      comment: "Hierarchical depth level of the component in the multi-level BOM (0=finished good, 1=first-tier sub-assembly). Used for BOM explosion depth analysis."
    - name: "effectivity_start_date"
      expr: DATE_TRUNC('month', effectivity_start_date)
      comment: "Month of BOM line effectivity start date. Enables trend analysis of engineering change introductions over time."
    - name: "is_phantom_assembly"
      expr: is_phantom_assembly
      comment: "Indicates whether the BOM line is a phantom assembly. Used to filter or segment phantom vs. physical component metrics."
    - name: "is_bulk_material"
      expr: is_bulk_material
      comment: "Indicates whether the component is a bulk material. Supports analysis of bulk vs. discrete component distribution in BOMs."
  measures:
    - name: "total_active_bom_lines"
      expr: COUNT(1)
      comment: "Total number of active BOM line items. Baseline measure of BOM structural complexity and component count across product assemblies."
    - name: "distinct_components"
      expr: COUNT(DISTINCT component_number)
      comment: "Number of unique component part numbers across active BOM lines. Measures component variety and supports part rationalization and standardization initiatives."
    - name: "distinct_parent_boms"
      expr: COUNT(DISTINCT engineering_bom_id)
      comment: "Number of distinct parent BOM headers covered by active BOM lines. Indicates breadth of product structure managed in the engineering domain."
    - name: "avg_component_quantity"
      expr: AVG(CAST(quantity AS DOUBLE))
      comment: "Average component quantity per BOM line. Identifies unusually high or low component usage patterns that may indicate BOM errors or design inefficiencies."
    - name: "avg_scrap_factor_pct"
      expr: AVG(CAST(scrap_factor_percent AS DOUBLE))
      comment: "Average scrap factor percentage across active BOM lines. A rising average signals increasing material waste risk and inflated MRP gross requirements, directly impacting production cost."
    - name: "total_weighted_scrap_quantity"
      expr: SUM(CAST(quantity AS DOUBLE) * CAST(scrap_factor_percent AS DOUBLE) / 100.0)
      comment: "Total scrap-adjusted component quantity (quantity × scrap factor) across all active BOM lines. Quantifies the aggregate material loss exposure embedded in the current BOM structure."
    - name: "high_scrap_bom_lines"
      expr: COUNT(CASE WHEN CAST(scrap_factor_percent AS DOUBLE) > 5.0 THEN 1 END)
      comment: "Number of BOM lines with scrap factor exceeding 5%. High-scrap lines represent priority targets for process improvement and cost reduction programs."
    - name: "phantom_assembly_lines"
      expr: COUNT(CASE WHEN is_phantom_assembly = TRUE THEN 1 END)
      comment: "Count of phantom assembly BOM lines. Phantom assemblies affect MRP explosion logic; tracking their prevalence supports BOM governance and MRP performance optimization."
    - name: "avg_bom_depth_level"
      expr: AVG(CAST(bom_level AS DOUBLE))
      comment: "Average BOM depth level across active lines. Deeper BOMs increase MRP explosion complexity and production scheduling lead time; this metric guides product structure simplification efforts."
    - name: "bom_lines_with_alternative"
      expr: COUNT(CASE WHEN alternative_item_group IS NOT NULL THEN 1 END)
      comment: "Number of BOM lines that have an approved alternative item group defined. Measures supply chain resilience built into the product structure through approved substitutes."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_bop_operation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Bill of Process operation metrics tracking manufacturing cycle time, setup efficiency, inspection coverage, and subcontracting exposure. Supports capacity planning, SMED initiatives, and make-vs-buy decisions."
  source: "`manufacturing_ecm`.`engineering`.`bop_operation`"
  filter: status = 'Active'
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the operation is performed. Enables plant-level process time and efficiency benchmarking."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center identifier where the operation is executed. Supports work center utilization and bottleneck analysis."
    - name: "operation_type"
      expr: operation_type
      comment: "Classification of the operation (in-house, subcontracted, inspection). Drives make-vs-buy and quality coverage analysis."
    - name: "control_key"
      expr: control_key
      comment: "SAP PP control key governing scheduling, costing, and inspection behavior. Used to segment operations by their planning and costing relevance."
    - name: "inspection_relevant"
      expr: inspection_relevant
      comment: "Flag indicating whether the operation requires an in-process quality inspection. Enables quality coverage rate analysis across the Bill of Process."
    - name: "hazardous_material_relevant"
      expr: hazardous_material_relevant
      comment: "Flag indicating whether the operation involves hazardous materials. Supports EHS compliance reporting and safety risk monitoring."
    - name: "effective_from_date"
      expr: DATE_TRUNC('month', effective_from_date)
      comment: "Month of operation effectivity start. Enables trend analysis of routing changes and new operation introductions over time."
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "SAP cost center associated with the work center. Supports cost allocation and COGS analysis by organizational unit."
  measures:
    - name: "total_active_operations"
      expr: COUNT(1)
      comment: "Total number of active BoP operation steps. Baseline measure of manufacturing process complexity across all routings."
    - name: "distinct_work_centers"
      expr: COUNT(DISTINCT work_center_code)
      comment: "Number of distinct work centers utilized across active operations. Measures the breadth of production resource utilization and supports capacity planning scope."
    - name: "avg_setup_time_min"
      expr: AVG(CAST(setup_time_min AS DOUBLE))
      comment: "Average setup time in minutes per operation. A key SMED (Single-Minute Exchange of Dies) KPI — high average setup time indicates changeover reduction opportunities that directly improve OEE and throughput."
    - name: "total_setup_time_min"
      expr: SUM(CAST(setup_time_min AS DOUBLE))
      comment: "Total setup time in minutes across all active operations. Quantifies the aggregate non-value-added changeover burden embedded in the current Bill of Process."
    - name: "avg_machine_time_min"
      expr: AVG(CAST(machine_time_min AS DOUBLE))
      comment: "Average machine processing time per operation. Baseline for capacity planning, takt time analysis, and OEE calculation at the routing level."
    - name: "avg_labor_time_min"
      expr: AVG(CAST(labor_time_min AS DOUBLE))
      comment: "Average labor time per operation. Drives workforce planning, direct labor cost estimation, and takt time compliance analysis."
    - name: "total_cycle_time_min"
      expr: SUM(CAST(setup_time_min AS DOUBLE) + CAST(machine_time_min AS DOUBLE) + CAST(labor_time_min AS DOUBLE) + CAST(teardown_time_min AS DOUBLE))
      comment: "Total standard cycle time (setup + machine + labor + teardown) across all active operations. Represents the aggregate manufacturing time commitment in the current Bill of Process."
    - name: "setup_to_machine_time_ratio"
      expr: SUM(CAST(setup_time_min AS DOUBLE)) / NULLIF(SUM(CAST(machine_time_min AS DOUBLE)), 0)
      comment: "Ratio of total setup time to total machine time. A ratio above 0.2 signals excessive changeover overhead relative to productive machine time, flagging SMED improvement priorities."
    - name: "inspection_relevant_operations"
      expr: COUNT(CASE WHEN inspection_relevant = TRUE THEN 1 END)
      comment: "Number of operations with mandatory in-process quality inspection. Measures quality gate coverage across the manufacturing process."
    - name: "inspection_coverage_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN inspection_relevant = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of active operations that include an in-process quality inspection step. Low coverage rates indicate quality risk gaps in the manufacturing process that may lead to escapes."
    - name: "subcontracted_operations"
      expr: COUNT(CASE WHEN operation_type = 'external' OR operation_type = 'subcontracting' THEN 1 END)
      comment: "Number of operations performed by external subcontractors. Measures external processing dependency and supports make-vs-buy strategic review."
    - name: "avg_external_processing_price"
      expr: AVG(CAST(external_processing_price AS DOUBLE))
      comment: "Average standard price for externally processed operations. Benchmarks subcontracting cost levels and supports supplier negotiation and insourcing ROI analysis."
    - name: "hazardous_operations_count"
      expr: COUNT(CASE WHEN hazardous_material_relevant = TRUE THEN 1 END)
      comment: "Number of operations involving hazardous materials. Drives EHS compliance planning, PPE requirement tracking, and regulatory reporting obligations."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_cad_model`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "CAD model lifecycle and design quality metrics tracking release velocity, DFM/DFA compliance, model maturity, and PLM vault health. Supports APQP milestone governance, design reuse, and PLM data quality management."
  source: "`manufacturing_ecm`.`engineering`.`cad_model`"
  dimensions:
    - name: "product_line"
      expr: product_line
      comment: "Product line or family to which the CAD model belongs. Enables portfolio-level design maturity and release velocity analysis."
    - name: "owning_group"
      expr: owning_group
      comment: "Engineering team or department responsible for the CAD model. Supports workload distribution and team-level design productivity reporting."
    - name: "cad_tool"
      expr: cad_tool
      comment: "CAD/CAM software used to create the model (e.g., Siemens NX, CATIA). Enables tool-level analysis for license optimization and migration planning."
    - name: "model_type"
      expr: model_type
      comment: "Type of CAD model (3D solid, 2D drawing, simulation). Segments metrics by model category for targeted governance."
    - name: "component_type"
      expr: component_type
      comment: "Classification of the component or assembly (part, assembly, sub-assembly). Supports BOM structure and design complexity analysis."
    - name: "dfm_status"
      expr: dfm_status
      comment: "Design for Manufacturability analysis status. Enables tracking of DFM compliance rates across the design portfolio."
    - name: "dfa_status"
      expr: dfa_status
      comment: "Design for Assembly analysis status. Supports DFA compliance rate monitoring and assembly process optimization."
    - name: "release_date_month"
      expr: DATE_TRUNC('month', release_date)
      comment: "Month of formal CAD model release. Enables release velocity trend analysis and APQP milestone tracking."
    - name: "primary_material"
      expr: primary_material
      comment: "Primary engineering material assigned to the model. Supports material standardization and REACH/RoHS compliance analysis."
  measures:
    - name: "total_cad_models"
      expr: COUNT(1)
      comment: "Total number of CAD model records. Baseline measure of PLM vault size and design portfolio scope."
    - name: "released_models"
      expr: COUNT(CASE WHEN release_date IS NOT NULL THEN 1 END)
      comment: "Number of CAD models that have been formally released. Measures design release throughput and APQP milestone achievement."
    - name: "models_checked_out"
      expr: COUNT(CASE WHEN checked_out_by IS NOT NULL THEN 1 END)
      comment: "Number of CAD models currently checked out for editing. High counts indicate active design work in progress; persistent checkouts may signal blocked collaboration or stale locks."
    - name: "dfm_pass_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN dfm_status = 'passed' THEN 1 END) / NULLIF(COUNT(CASE WHEN dfm_status IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of CAD models that have passed DFM analysis. Low DFM pass rates predict manufacturing feasibility issues, rework costs, and production launch delays."
    - name: "dfa_pass_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN dfa_status = 'passed' THEN 1 END) / NULLIF(COUNT(CASE WHEN dfa_status IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of CAD models that have passed DFA analysis. Measures assembly process compatibility of the design portfolio and drives part count reduction initiatives."
    - name: "avg_model_mass_kg"
      expr: AVG(CAST(mass_kg AS DOUBLE))
      comment: "Average component mass in kilograms across CAD models. Supports weight-sensitive design compliance, logistics cost estimation, and structural analysis benchmarking."
    - name: "total_vault_size_mb"
      expr: SUM(CAST(file_size_mb AS DOUBLE))
      comment: "Total PLM vault storage consumed by CAD model files in megabytes. Drives storage capacity planning and data migration scoping decisions."
    - name: "avg_file_size_mb"
      expr: AVG(CAST(file_size_mb AS DOUBLE))
      comment: "Average CAD model file size in megabytes. Identifies oversized models that degrade PLM system performance and collaboration efficiency."
    - name: "master_model_count"
      expr: COUNT(CASE WHEN is_master_model = TRUE THEN 1 END)
      comment: "Number of models designated as master geometry models. Ensures one authoritative master model exists per component revision; deviations indicate PLM data governance issues."
    - name: "export_controlled_models"
      expr: COUNT(CASE WHEN export_control_class IS NOT NULL AND export_control_class != 'EAR99' THEN 1 END)
      comment: "Number of CAD models subject to export control restrictions (ITAR/EAR). Measures the scope of export compliance obligations and access control requirements for international collaboration."
    - name: "distinct_design_owners"
      expr: COUNT(DISTINCT design_owner)
      comment: "Number of distinct design engineers owning CAD models. Supports workload distribution analysis and succession planning for critical design assets."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_eco`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering Change Order metrics tracking change velocity, implementation cycle time, cost variance, regulatory compliance, and PPAP obligations. Core KPIs for engineering change management governance and program execution performance."
  source: "`manufacturing_ecm`.`engineering`.`eco`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the ECO must be implemented. Enables plant-level change management performance and workload analysis."
    - name: "change_type"
      expr: change_type
      comment: "Type of engineering change (BOM, drawing, routing, etc.). Segments change volume and cost by the nature of the modification."
    - name: "change_class"
      expr: change_class
      comment: "Severity classification of the change (Class 1 Major, Class 2 Minor, Class 3 Administrative). Drives PPAP requirements and approval workflow complexity."
    - name: "priority"
      expr: priority
      comment: "Business priority of the ECO (Critical, High, Medium, Low). Enables prioritization of change management resources and escalation tracking."
    - name: "originating_department"
      expr: originating_department
      comment: "Department that initiated the ECO. Supports change volume analytics and departmental accountability reporting."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the ECO (Draft, Approved, Released, Completed, Closed). Enables pipeline and backlog analysis."
    - name: "regulatory_driven"
      expr: regulatory_driven
      comment: "Flag indicating whether the ECO is mandated by a regulatory requirement. Separates compliance-driven changes from engineering-initiated changes for risk reporting."
    - name: "requested_date_month"
      expr: DATE_TRUNC('month', requested_date)
      comment: "Month the ECO was requested. Enables change volume trend analysis and seasonal pattern identification."
    - name: "effectivity_type"
      expr: effectivity_type
      comment: "Method by which the change becomes effective (date-based, serial-number-based, lot-based). Supports effectivity management complexity analysis."
  measures:
    - name: "total_ecos"
      expr: COUNT(1)
      comment: "Total number of Engineering Change Orders. Baseline measure of engineering change management workload and organizational change velocity."
    - name: "open_ecos"
      expr: COUNT(CASE WHEN status NOT IN ('Closed', 'Completed', 'Cancelled') THEN 1 END)
      comment: "Number of ECOs currently open (not yet closed or completed). Measures the active change management backlog and implementation workload."
    - name: "overdue_ecos"
      expr: COUNT(CASE WHEN implementation_deadline < CURRENT_DATE AND status NOT IN ('Closed', 'Completed', 'Cancelled') THEN 1 END)
      comment: "Number of ECOs that have passed their implementation deadline without being closed. Overdue ECOs represent compliance risk, production disruption risk, and program schedule risk."
    - name: "on_time_completion_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN completed_date <= implementation_deadline AND completed_date IS NOT NULL THEN 1 END) / NULLIF(COUNT(CASE WHEN completed_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of completed ECOs that were finished on or before the implementation deadline. Core KPI for engineering change management execution performance."
    - name: "avg_implementation_cycle_days"
      expr: AVG(CAST(DATEDIFF(completed_date, requested_date) AS DOUBLE))
      comment: "Average number of days from ECO request to completion. Measures engineering change management cycle time efficiency; long cycle times delay production launches and regulatory compliance."
    - name: "avg_approval_lead_days"
      expr: AVG(CAST(DATEDIFF(approved_date, requested_date) AS DOUBLE))
      comment: "Average number of days from ECO request to formal approval. Measures approval workflow efficiency; excessive approval lead time blocks manufacturing execution."
    - name: "total_estimated_cost"
      expr: SUM(CAST(estimated_cost AS DOUBLE))
      comment: "Total estimated cost to implement all ECOs in scope. Quantifies the aggregate engineering change investment for CAPEX/OPEX planning and budget governance."
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_cost AS DOUBLE))
      comment: "Total actual cost incurred to implement completed ECOs. Compared against estimated cost to measure change cost estimation accuracy and budget adherence."
    - name: "cost_variance"
      expr: SUM((CAST(actual_cost AS DOUBLE)) - (CAST(estimated_cost AS DOUBLE)))
      comment: "Aggregate cost variance (actual minus estimated) across completed ECOs. Positive variance indicates cost overruns; negative indicates savings. Drives improvement of change cost estimation models."
    - name: "ppap_required_ecos"
      expr: COUNT(CASE WHEN ppap_required = TRUE THEN 1 END)
      comment: "Number of ECOs requiring a PPAP submission. Measures the PPAP compliance workload generated by engineering changes and supports customer quality obligation tracking."
    - name: "regulatory_driven_ecos"
      expr: COUNT(CASE WHEN regulatory_driven = TRUE THEN 1 END)
      comment: "Number of ECOs mandated by regulatory requirements (RoHS, REACH, CE Marking, etc.). Measures regulatory compliance change burden and supports mandatory completion tracking."
    - name: "customer_approval_required_ecos"
      expr: COUNT(CASE WHEN customer_approval_required = TRUE THEN 1 END)
      comment: "Number of ECOs requiring formal customer approval before implementation. Measures customer-facing change management obligations and associated program risk."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_dfmea`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Design FMEA risk metrics tracking RPN severity distribution, safety-critical exposure, action closure rates, and PPAP readiness. Supports APQP governance, design risk reduction, and regulatory compliance management."
  source: "`manufacturing_ecm`.`engineering`.`dfmea`"
  filter: status != 'obsolete'
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code of the engineering site responsible for the design. Enables site-level design risk profile comparison."
    - name: "scope_level"
      expr: scope_level
      comment: "Hierarchical scope of the DFMEA (component, subsystem, assembly, system). Segments risk metrics by design analysis depth."
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "APQP phase during which the DFMEA was created or updated. Enables phase-gate risk maturity tracking across the product development lifecycle."
    - name: "action_priority"
      expr: action_priority
      comment: "AIAG-VDA Action Priority classification (High, Medium, Low). Segments failure modes by urgency for corrective action prioritization."
    - name: "safety_critical"
      expr: safety_critical
      comment: "Flag indicating whether the DFMEA contains safety-critical failure modes (severity 9-10). Enables mandatory escalation tracking and regulatory compliance monitoring."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the DFMEA (draft, in_review, approved, closed). Enables pipeline and backlog analysis of design risk assessments."
    - name: "preparation_date_month"
      expr: DATE_TRUNC('month', preparation_date)
      comment: "Month the DFMEA was prepared. Enables trend analysis of design risk assessment activity over time."
    - name: "ppap_submission_required"
      expr: ppap_submission_required
      comment: "Flag indicating whether the DFMEA is required for a PPAP submission. Segments metrics by customer-facing quality obligation."
  measures:
    - name: "total_dfmea_records"
      expr: COUNT(1)
      comment: "Total number of active DFMEA failure mode records. Baseline measure of design risk assessment coverage across the product portfolio."
    - name: "safety_critical_dfmeas"
      expr: COUNT(CASE WHEN safety_critical = TRUE THEN 1 END)
      comment: "Number of DFMEAs containing safety-critical failure modes (severity 9-10). Measures the safety risk exposure in the design portfolio requiring mandatory escalation and additional validation."
    - name: "high_priority_open_actions"
      expr: COUNT(CASE WHEN action_priority = 'H' AND action_completion_date IS NULL THEN 1 END)
      comment: "Number of high-priority DFMEA action items not yet completed. Measures unresolved critical design risk exposure that requires immediate engineering intervention."
    - name: "action_closure_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN action_completion_date IS NOT NULL THEN 1 END) / NULLIF(COUNT(CASE WHEN recommended_action IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of DFMEA recommended actions that have been completed. Low closure rates indicate stalled risk mitigation and APQP schedule risk."
    - name: "avg_days_to_action_closure"
      expr: AVG(CAST(DATEDIFF(action_completion_date, preparation_date) AS DOUBLE))
      comment: "Average number of days from DFMEA preparation to action completion. Measures design risk mitigation cycle time; long closure times indicate APQP execution delays."
    - name: "regulatory_compliance_dfmeas"
      expr: COUNT(CASE WHEN regulatory_compliance_flag = TRUE THEN 1 END)
      comment: "Number of DFMEAs addressing regulatory compliance failure modes (RoHS, REACH, CE Marking). Measures the regulatory risk exposure embedded in the design portfolio."
    - name: "ppap_required_dfmeas"
      expr: COUNT(CASE WHEN ppap_submission_required = TRUE THEN 1 END)
      comment: "Number of DFMEAs required for PPAP submission packages. Measures the PPAP documentation workload and customer quality obligation scope."
    - name: "approved_dfmeas"
      expr: COUNT(CASE WHEN status = 'approved' THEN 1 END)
      comment: "Number of DFMEAs in approved and baselined status. Measures design risk assessment maturity and APQP phase gate readiness."
    - name: "dfmea_approval_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN status = 'approved' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of DFMEAs that have been formally approved. Low approval rates indicate APQP phase gate bottlenecks and PPAP readiness risk."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_pfmea`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Process FMEA risk metrics tracking process failure mode severity, RPN distribution, action closure rates, and CAPA linkage. Supports manufacturing process risk governance, SPC control plan alignment, and IATF 16949 compliance."
  source: "`manufacturing_ecm`.`engineering`.`pfmea`"
  filter: status != 'obsolete'
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant where the process being analyzed is executed. Enables plant-level process risk profile benchmarking."
    - name: "work_center"
      expr: work_center
      comment: "SAP work center or Opcenter resource where the operation is performed. Supports work center-level risk concentration analysis."
    - name: "action_priority"
      expr: action_priority
      comment: "AIAG-VDA 2019 Action Priority (High, Medium, Low). Segments process failure modes by urgency for corrective action prioritization."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the PFMEA document. Enables pipeline and backlog analysis of process risk assessments."
    - name: "approval_date_month"
      expr: DATE_TRUNC('month', approval_date)
      comment: "Month the PFMEA was formally approved. Enables trend analysis of process risk assessment maturity over time."
    - name: "model_year"
      expr: model_year
      comment: "Model year or program year associated with the PFMEA. Supports APQP program tracking and PPAP submission documentation."
  measures:
    - name: "total_pfmea_records"
      expr: COUNT(1)
      comment: "Total number of active PFMEA failure mode records. Baseline measure of process risk assessment coverage across manufacturing operations."
    - name: "high_priority_open_actions"
      expr: COUNT(CASE WHEN action_priority = 'High' AND action_completion_date IS NULL THEN 1 END)
      comment: "Number of high-priority PFMEA action items not yet completed. Measures unresolved critical process risk exposure requiring immediate corrective action."
    - name: "action_closure_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN action_completion_date IS NOT NULL THEN 1 END) / NULLIF(COUNT(CASE WHEN recommended_action IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of PFMEA recommended actions that have been completed. Low closure rates indicate stalled process risk mitigation and IATF 16949 compliance risk."
    - name: "overdue_actions"
      expr: COUNT(CASE WHEN action_target_date < CURRENT_DATE AND action_completion_date IS NULL THEN 1 END)
      comment: "Number of PFMEA action items past their target completion date without being closed. Measures process risk mitigation schedule adherence and CAPA execution performance."
    - name: "avg_days_to_action_closure"
      expr: AVG(CAST(DATEDIFF(action_completion_date, approval_date) AS DOUBLE))
      comment: "Average days from PFMEA approval to action completion. Measures process risk mitigation cycle time efficiency."
    - name: "pfmeas_with_capa"
      expr: COUNT(CASE WHEN capa_number IS NOT NULL THEN 1 END)
      comment: "Number of PFMEA records linked to a formal CAPA record. Measures the rate at which process failure modes are escalated to the quality management system for structured corrective action."
    - name: "capa_linkage_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN capa_number IS NOT NULL THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of PFMEA records linked to a CAPA. Low linkage rates indicate process risk items are not being formally escalated to the QMS, creating audit and compliance gaps."
    - name: "approved_pfmeas"
      expr: COUNT(CASE WHEN status = 'approved' THEN 1 END)
      comment: "Number of PFMEAs in formally approved status. Measures process risk assessment maturity and production readiness for PPAP and IATF 16949 compliance."
    - name: "pfmea_approval_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN status = 'approved' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of PFMEAs that have been formally approved. Core APQP and IATF 16949 compliance KPI for process risk governance."
    - name: "distinct_processes_covered"
      expr: COUNT(DISTINCT bop_id)
      comment: "Number of distinct Bills of Process covered by active PFMEAs. Measures the breadth of process risk assessment coverage across the manufacturing routing portfolio."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_change_affected_item`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering change affected item metrics tracking change implementation velocity, safety-critical exposure, regulatory approval compliance, verification closure rates, and cost impact. Supports change control board governance and program risk management."
  source: "`manufacturing_ecm`.`engineering`.`change_affected_item`"
  dimensions:
    - name: "item_type"
      expr: item_type
      comment: "Type of item affected by the engineering change (component, BOM, drawing, routing, document). Segments change impact by artifact type."
    - name: "change_action"
      expr: change_action
      comment: "Action performed on the affected item (Revise, Create, Obsolete, Supersede). Enables analysis of change action distribution and complexity."
    - name: "impact_level"
      expr: impact_level
      comment: "Severity of the change impact (Critical, Major, Minor, Cosmetic). Drives prioritization of change implementation resources."
    - name: "implementation_status"
      expr: implementation_status
      comment: "Current implementation status of the change for this affected item. Enables pipeline and backlog analysis of change execution."
    - name: "owning_plant_code"
      expr: owning_plant_code
      comment: "Plant responsible for implementing the change. Supports plant-level change execution performance monitoring."
    - name: "effectivity_type"
      expr: effectivity_type
      comment: "Method by which the change becomes effective (date, serial number, lot, immediate). Supports effectivity management complexity analysis."
    - name: "effectivity_date_month"
      expr: DATE_TRUNC('month', effectivity_date)
      comment: "Month the engineering change becomes effective. Enables change wave analysis and production cutover planning."
    - name: "change_reason_code"
      expr: change_reason_code
      comment: "Standardized reason code for the engineering change. Supports root cause analysis and change trend reporting."
  measures:
    - name: "total_affected_items"
      expr: COUNT(1)
      comment: "Total number of affected item records across all engineering changes. Baseline measure of engineering change scope and implementation workload."
    - name: "safety_critical_items"
      expr: COUNT(CASE WHEN safety_critical_flag = TRUE THEN 1 END)
      comment: "Number of affected items classified as safety-critical. Measures the safety risk exposure in the active change portfolio requiring mandatory regulatory review and DFMEA/PFMEA updates."
    - name: "form_fit_function_changes"
      expr: COUNT(CASE WHEN form_fit_function_flag = TRUE THEN 1 END)
      comment: "Number of affected items where the change impacts form, fit, or function. FFF changes trigger mandatory customer notification and PPAP re-submission obligations."
    - name: "regulatory_approval_pending"
      expr: COUNT(CASE WHEN regulatory_approval_required = TRUE AND regulatory_approval_status NOT IN ('approved', 'Approved') THEN 1 END)
      comment: "Number of affected items requiring regulatory approval that have not yet received it. Measures regulatory compliance bottlenecks blocking change implementation."
    - name: "verification_closure_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN verification_status IN ('completed', 'passed', 'Completed', 'Passed') THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of affected items where post-implementation verification has been successfully completed. Low rates indicate unverified changes in production, creating quality and audit risk."
    - name: "on_time_implementation_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN implementation_date <= planned_implementation_date AND implementation_date IS NOT NULL THEN 1 END) / NULLIF(COUNT(CASE WHEN implementation_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of affected items implemented on or before the planned implementation date. Core KPI for engineering change execution performance and program schedule adherence."
    - name: "avg_implementation_delay_days"
      expr: AVG(CAST(DATEDIFF(implementation_date, planned_implementation_date) AS DOUBLE))
      comment: "Average number of days between planned and actual implementation date. Positive values indicate delays; negative values indicate early completion. Measures change execution schedule performance."
    - name: "total_estimated_cost_impact"
      expr: SUM(CAST(estimated_cost_impact AS DOUBLE))
      comment: "Total estimated financial impact of all engineering changes across affected items. Quantifies the aggregate cost consequence of the active change portfolio for financial planning."
    - name: "cost_saving_items"
      expr: COUNT(CASE WHEN CAST(estimated_cost_impact AS DOUBLE) < 0 THEN 1 END)
      comment: "Number of affected items where the engineering change is expected to reduce cost. Measures the value-generating change activity within the engineering change portfolio."
    - name: "distinct_ecns_covered"
      expr: COUNT(DISTINCT ecn_id)
      comment: "Number of distinct ECNs represented in the affected item records. Measures the breadth of engineering change activity driving implementation workload."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`engineering_substitute_component`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Substitute component metrics tracking supply chain resilience, MRP-active substitution coverage, form-fit-function equivalence rates, and quality revalidation obligations. Supports supply chain risk management and procurement strategy decisions."
  source: "`manufacturing_ecm`.`engineering`.`substitute_component`"
  filter: status IN ('approved', 'active', 'Approved', 'Active')
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the substitution is valid. Enables plant-level supply chain resilience analysis."
    - name: "substitution_type"
      expr: substitution_type
      comment: "Classification of the substitution (full, conditional, temporary, emergency). Segments resilience metrics by substitution permanence and reliability."
    - name: "substitution_reason_code"
      expr: substitution_reason_code
      comment: "Standardized reason code for the substitution. Supports root cause analysis of supply chain vulnerabilities driving substitute approvals."
    - name: "cost_impact_indicator"
      expr: cost_impact_indicator
      comment: "Directional cost impact of using the substitute (increase, neutral, decrease). Enables cost impact distribution analysis across the substitution portfolio."
    - name: "originating_department"
      expr: originating_department
      comment: "Department that originated the substitution request. Supports cross-functional accountability and workflow routing analysis."
    - name: "valid_from_date_month"
      expr: DATE_TRUNC('month', valid_from_date)
      comment: "Month the substitution became effective. Enables trend analysis of substitute approval activity over time."
  measures:
    - name: "total_approved_substitutes"
      expr: COUNT(1)
      comment: "Total number of approved substitute component associations. Baseline measure of supply chain resilience built into the engineering BOM structure."
    - name: "mrp_active_substitutes"
      expr: COUNT(CASE WHEN mrp_relevance_flag = TRUE THEN 1 END)
      comment: "Number of substitute components active and visible to the MRP engine. Measures the effective supply chain resilience available for automatic MRP exception handling."
    - name: "mrp_activation_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN mrp_relevance_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of approved substitutes that are MRP-active. Low rates indicate approved substitutes are not being leveraged in planning runs, reducing supply chain resilience effectiveness."
    - name: "form_fit_function_equivalents"
      expr: COUNT(CASE WHEN form_fit_function_flag = TRUE THEN 1 END)
      comment: "Number of substitutes that are true form, fit, and function equivalents. FFF equivalents can be used without design or process modification, representing the highest-quality resilience option."
    - name: "fff_equivalence_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN form_fit_function_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of approved substitutes that are FFF equivalents. High rates indicate robust supply chain resilience with minimal engineering change risk when substitutes are activated."
    - name: "quality_revalidation_required"
      expr: COUNT(CASE WHEN requires_quality_revalidation = TRUE THEN 1 END)
      comment: "Number of substitutes requiring quality revalidation (FAI, control plan update) before production use. Measures the quality compliance workload triggered by substitute activation."
    - name: "export_controlled_substitutes"
      expr: COUNT(CASE WHEN export_control_flag = TRUE THEN 1 END)
      comment: "Number of substitute components subject to export control regulations. Measures the compliance complexity of the substitution portfolio for international supply chain scenarios."
    - name: "avg_quantity_conversion_factor"
      expr: AVG(CAST(quantity_conversion_factor AS DOUBLE))
      comment: "Average quantity conversion factor across approved substitutes. Values significantly different from 1.0 indicate substitutes requiring quantity adjustments, adding MRP planning complexity."
    - name: "distinct_primary_components_covered"
      expr: COUNT(DISTINCT bom_line_id)
      comment: "Number of distinct primary BOM components that have at least one approved substitute. Measures the breadth of supply chain resilience coverage across the product structure."
    - name: "emergency_substitutes"
      expr: COUNT(CASE WHEN substitution_type = 'emergency' THEN 1 END)
      comment: "Number of emergency-only substitute approvals. High counts signal systemic supply chain fragility requiring strategic sourcing intervention."
$$;