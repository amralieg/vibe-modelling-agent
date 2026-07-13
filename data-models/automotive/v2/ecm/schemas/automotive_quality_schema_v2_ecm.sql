-- Schema for Domain: quality | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:54

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`quality` COMMENT 'End-to-end quality assurance and control across design, manufacturing, and field operations. Owns APQP plans, FMEA (Failure Mode and Effects Analysis), SPC (Statistical Process Control) data, inspection plans, quality audits, defect tracking, and PPM rates. Includes incoming material inspection, in-process quality gates, final vehicle PDI (Pre-Delivery Inspection), NCAP/WLTP test results, and corrective action (8D, 5-Why) processes. Supports IATF 16949 compliance.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` (
    `apqp_plan_id` BIGINT COMMENT 'System-generated unique identifier for the APQP plan record.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: APQP planning requires referencing the homologation approval to align release dates with regulatory clearance.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: APQP planning is defined per vehicle model; linking APQP plan to model enables model‑specific quality goals and gate tracking.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: APQP planning is executed per vehicle program; linking aligns plans with program metadata and eliminates program_name duplication.',
    `actual_ppm` DECIMAL(18,2) COMMENT 'Measured parts-per-million defect rate observed after validation.',
    `actual_release_date` DATE COMMENT 'Actual date when the product was released to production.',
    `apqp_phase` STRING COMMENT 'Current phase of the APQP process for the plan.. Valid values are `concept|design|process|validation|launch`',
    `classification_type` STRING COMMENT 'Category of the APQP plan based on product scope.. Valid values are `new_model|refresh|component|system`',
    `compliance_status` STRING COMMENT 'Current IATF 16949 compliance status of the APQP plan.. Valid values are `compliant|non_compliant|pending`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the APQP plan record was created in the system.',
    `documentation_link` STRING COMMENT 'URL or path to the primary APQP documentation repository.',
    `effective_from` DATE COMMENT 'Date when the APQP plan becomes effective.',
    `effective_until` DATE COMMENT 'Date when the APQP plan expires or is superseded (nullable).',
    `eop_date` DATE COMMENT 'Date when series production ended for the vehicle/program.',
    `gate_completion_date` DATE COMMENT 'Actual date when the milestone gate was completed.',
    `gate_due_date` DATE COMMENT 'Planned due date for the milestone gate.',
    `gate_status` STRING COMMENT 'Current status of the milestone gate.. Valid values are `open|closed|delayed|approved|rejected`',
    `lifecycle_status` STRING COMMENT 'Current lifecycle state of the APQP plan.. Valid values are `draft|active|suspended|completed|archived`',
    `milestone_gate` STRING COMMENT 'Specific APQP milestone gate associated with the plan.. Valid values are `gate1|gate2|gate3|gate4|gate5`',
    `mitigation_plan` STRING COMMENT 'Description of actions taken to mitigate identified risks.',
    `model_year` STRING COMMENT 'Model year (calendar year) of the vehicle model associated with the APQP plan.',
    `notes` STRING COMMENT 'Free-text field for additional comments or observations.',
    `owner_name` STRING COMMENT 'Name of the internal owner or manager of the APQP plan.',
    `part_number` STRING COMMENT 'Identifier of the part or component covered by the APQP plan (e.g., OEM part number).',
    `plan_number` STRING COMMENT 'External business identifier assigned to the APQP plan, often used in documentation and reporting.',
    `quality_goal_ppm` DECIMAL(18,2) COMMENT 'Target parts-per-million defect rate defined for the APQP plan.',
    `responsible_team` STRING COMMENT 'Team or department accountable for executing the APQP plan.',
    `risk_assessment_date` DATE COMMENT 'Date when the risk assessment for the APQP plan was performed.',
    `risk_level` STRING COMMENT 'Overall risk classification for the APQP plan.. Valid values are `low|medium|high|critical`',
    `sop_date` DATE COMMENT 'Date when series production started for the vehicle/program.',
    `ssot_governance_note` STRING COMMENT '',
    `target_ppm` DECIMAL(18,2) COMMENT 'Planned PPM level to achieve during the APQP process.',
    `target_release_date` DATE COMMENT 'Planned date for the product release associated with the APQP plan.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the APQP plan record.',
    `version_number` STRING COMMENT 'Version identifier for the APQP plan record.',
    CONSTRAINT pk_apqp_plan PRIMARY KEY(`apqp_plan_id`)
) COMMENT 'Advanced Product Quality Planning master record governing the structured quality planning process for new vehicle programs and components. Tracks APQP phases (concept, design, process, validation, launch), milestone gates, responsible teams, and completion status per program/part. Aligns with IATF 16949 requirements and links to engineering change and SOP timelines.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`fmea` (
    `fmea_id` BIGINT COMMENT 'System-generated unique identifier for the FMEA record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: FMEA action owner must be a responsible employee; linking enables tracking accountability in corrective action reports.',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: FMEA is performed based on design specs; linking provides traceability for risk analysis reports.',
    `engineering_bom_component_id` BIGINT COMMENT 'Unique identifier of the vehicle component or part to which the FMEA applies.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: FMEA must be linked to applicable regulatory requirements to verify compliance of failure modes.',
    `actual_completion_date` DATE COMMENT 'Date the recommended action was actually completed.',
    `analysis_number` STRING COMMENT 'External reference number assigned to the FMEA analysis, used for tracking across systems.',
    `analysis_type` STRING COMMENT 'Indicates whether the FMEA is a Design FMEA (DFMEA) or Process FMEA (PFMEA).. Valid values are `design|process`',
    `approval_date` DATE COMMENT 'Date the FMEA analysis received formal approval.',
    `approved_by` STRING COMMENT 'Name of the engineer or manager who approved the FMEA analysis.',
    `cause` STRING COMMENT 'Underlying cause(s) that could lead to the failure mode.',
    `control_effectiveness_rating` STRING COMMENT 'Score (1‑10) assessing how well the current control detects or prevents the failure.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the FMEA record was first created in the system.',
    `current_control` STRING COMMENT 'Description of existing controls that mitigate the failure mode.',
    `detection_description` STRING COMMENT 'Narrative explanation of the detection rating.',
    `detection_method` STRING COMMENT 'Method or technique used by the current control to detect the failure.',
    `detection_rating` STRING COMMENT 'Score (1‑10) indicating the ability of current controls to detect the failure before it reaches the customer.',
    `effective_from` DATE COMMENT 'Date from which the FMEA analysis is considered active.',
    `effective_until` DATE COMMENT 'Date after which the FMEA analysis is retired or superseded (nullable).',
    `failure_effect` STRING COMMENT 'Impact of the failure mode on vehicle performance, safety, or compliance.',
    `failure_mode` STRING COMMENT 'Description of the way the component could potentially fail.',
    `fmea_status` STRING COMMENT 'Current lifecycle status of the FMEA record.. Valid values are `open|closed|in_progress|deferred`',
    `notes` STRING COMMENT 'Free‑form comments or observations related to the FMEA.',
    `occurrence_description` STRING COMMENT 'Narrative explanation of the occurrence rating.',
    `occurrence_rating` STRING COMMENT 'Likelihood score (1‑10) that the cause will occur.',
    `recommended_action` STRING COMMENT 'Proposed corrective or preventive action to reduce severity, occurrence, or improve detection.',
    `revision_number` STRING COMMENT 'Version of the FMEA record after each update or re‑analysis.',
    `rpn` STRING COMMENT 'Calculated risk priority number (S × O × D) used to prioritize corrective actions.',
    `severity_description` STRING COMMENT 'Narrative explanation of the severity rating.',
    `severity_rating` STRING COMMENT 'Severity score (1‑10) reflecting seriousness of the failure effect.',
    `ssot_governance_note` STRING COMMENT '',
    `subsystem` STRING COMMENT 'Higher‑level subsystem or system grouping the component belongs to (e.g., Powertrain, Chassis).',
    `target_completion_date` DATE COMMENT 'Planned date by which the recommended action should be completed.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the FMEA record.',
    CONSTRAINT pk_fmea PRIMARY KEY(`fmea_id`)
) COMMENT 'Failure Mode and Effects Analysis master record capturing potential failure modes, their effects, causes, current controls, severity/occurrence/detection ratings, and Risk Priority Numbers (RPN) for vehicle components, subsystems, and manufacturing processes. Supports both Design FMEA (DFMEA) and Process FMEA (PFMEA) per AIAG-VDA FMEA methodology. Tracks recommended actions and revised RPN after corrective actions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`control_plan` (
    `control_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the quality control plan.',
    `fmea_id` BIGINT COMMENT 'Link to the Process FMEA that this control plan supports.',
    `control_associated_pfmea_fmea_id` BIGINT COMMENT 'Link to the Process FMEA that this control plan supports.',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: Control plans are derived from design specifications; FK enables automatic extraction of spec requirements for quality control.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: CONTROL PLAN EXECUTION: Measurement equipment used in control plans must be tracked for maintenance and traceability.',
    `inspection_plan_id` BIGINT COMMENT 'Link to the detailed inspection plan referenced by this control plan.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Control plans are line‑specific for process control; required for the Production Control Review report.',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Control plans are project‑tracked in the WBS for capital budgeting and cost control.',
    `approval_date` DATE COMMENT 'Date when the control plan received final approval.',
    `approval_status` STRING COMMENT 'Current approval state of the control plan.. Valid values are `pending|approved|rejected|revoked`',
    `approved_by` STRING COMMENT 'Employee identifier who approved the control plan.',
    `change_control_number` STRING COMMENT 'Reference number for the change control record associated with this plan.',
    `control_method` STRING COMMENT 'Statistical or inspection method used to control the characteristic.. Valid values are `spc|attribute|visual|functional|dimensional`',
    `control_plan_status` STRING COMMENT 'Current lifecycle status of the control plan per IATF 16949.. Valid values are `draft|active|suspended|retired|archived`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the control plan record was first created in the system.',
    `control_plan_description` STRING COMMENT 'Free‑text description of the purpose, scope, and key characteristics of the control plan.',
    `effective_end_date` DATE COMMENT 'Date when the control plan is retired or superseded (null if open‑ended).',
    `effective_start_date` DATE COMMENT 'Date when the control plan becomes effective for production.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the control plan is mandatory for the operation.',
    `lower_spec_limit` DECIMAL(18,2) COMMENT 'Minimum acceptable value for the characteristic.',
    `measurement_unit` STRING COMMENT 'Unit of measure for the control characteristic (e.g., mm, psi). [ENUM-REF-CANDIDATE: mm|cm|inch|mm2|g|kg|psi|kpa|percent — 9 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information or comments.',
    `plan_name` STRING COMMENT 'Human‑readable name of the control plan.',
    `plan_number` STRING COMMENT 'Business identifier or code assigned to the control plan (e.g., CP‑2024‑001).',
    `plan_type` STRING COMMENT 'Category of manufacturing operation the plan applies to.. Valid values are `assembly|paint|engine|chassis|electrical|final`',
    `reaction_plan` STRING COMMENT 'Defined corrective actions if a measurement falls outside specification limits.',
    `responsible_function` STRING COMMENT 'Organizational function accountable for the control plan.. Valid values are `assembly_line|quality_engineering|process_engineering|manufacturing|test_lab`',
    `revision_date` DATE COMMENT 'Date when the current revision was released.',
    `revision_number` STRING COMMENT 'Sequential revision number of the control plan.',
    `sample_frequency` STRING COMMENT 'Frequency at which sampling is performed.. Valid values are `per_shift|per_batch|per_hour|per_day`',
    `sample_size` STRING COMMENT 'Number of units inspected per sampling event as defined by the plan.',
    `ssot_governance_note` STRING COMMENT '',
    `target_value` DECIMAL(18,2) COMMENT 'Desired nominal value for the controlled characteristic.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the control plan record.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable value for the characteristic.',
    `created_by` STRING COMMENT 'Name or identifier of the employee who authored the control plan.',
    CONSTRAINT pk_control_plan PRIMARY KEY(`control_plan_id`)
) COMMENT 'Quality control plan defining the process controls, inspection methods, measurement systems, reaction plans, and control characteristics for each manufacturing operation or assembly step. Links to PFMEA and inspection plans. Specifies sample sizes, frequencies, control methods (SPC, attribute, visual), and responsible functions per IATF 16949 requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` (
    `inspection_plan_id` BIGINT COMMENT 'Unique identifier for the inspection plan.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Inspection Cost Allocation report assigns inspection plan expenses to the responsible cost center.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: INSPECTION PLANNING: Plans are assigned to specific functional locations (stations) to satisfy ISO/TS 16949 inspection scheduling.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Inspection plans are defined per production line to meet line‑specific quality standards; used in the Line Inspection Planning process.',
    `acceptance_criteria` STRING COMMENT 'Textual definition of pass/fail conditions.',
    `applicable_process` STRING COMMENT 'Manufacturing process to which the inspection plan applies.. Valid values are `IQC|IPQC|PDI|Final`',
    `approval_date` DATE COMMENT 'Date when the inspection plan was approved.',
    `approved_by` STRING COMMENT 'User identifier of the approver.',
    `associated_quality_system` STRING COMMENT 'Quality system or methodology linked to the plan.. Valid values are `APQP|FMEA|SPC|PPAP|None`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection plan record was first created.',
    `criticality_level` STRING COMMENT 'Risk level associated with the inspection characteristic.. Valid values are `low|medium|high|critical`',
    `department_responsible` STRING COMMENT 'Organizational department owning the inspection plan.',
    `inspection_plan_description` STRING COMMENT 'Detailed description of the purpose and scope of the inspection plan.',
    `effective_end_date` DATE COMMENT 'Date when the inspection plan expires or is superseded (nullable).',
    `effective_start_date` DATE COMMENT 'Date when the inspection plan becomes effective.',
    `field_service_applicable_flag` BOOLEAN COMMENT 'Whether this inspection plan applies to field service operations',
    `frequency` STRING COMMENT 'How often the inspection is performed.. Valid values are `per_batch|per_shift|per_vehicle|per_day`',
    `gauge_type` STRING COMMENT 'Specific gauge or instrument type used.. Valid values are `dial|digital|laser|micrometer`',
    `inspection_category` STRING COMMENT 'Broad category of the inspection activity.. Valid values are `dimensional|functional|visual|electrical`',
    `inspection_plan_status` STRING COMMENT 'Current lifecycle status of the inspection plan.. Valid values are `draft|active|inactive|retired`',
    `is_automated` BOOLEAN COMMENT 'Indicates whether the inspection is performed by automated equipment.',
    `last_review_date` DATE COMMENT 'Date of the most recent plan review.',
    `measurement_method` STRING COMMENT 'Technique used to perform the measurement.. Valid values are `CMM|Gauge|Visual|Automated|Manual`',
    `measurement_unit` STRING COMMENT 'Unit of measure for tolerances and results.. Valid values are `mm|cm|inch|mm^2|psi`',
    `model_year` STRING COMMENT 'Model year (calendar year) of the vehicle.',
    `notes` STRING COMMENT 'Free‑form comments or special instructions.',
    `part_number` STRING COMMENT 'Identifier of the part or component the inspection plan targets.',
    `plan_name` STRING COMMENT 'Human‑readable name of the inspection plan.',
    `plan_number` STRING COMMENT 'Business identifier assigned to the inspection plan.',
    `plan_type` STRING COMMENT 'Classification of the plan (e.g., incoming material, in‑process, final vehicle).. Valid values are `incoming_material|in_process|final_vehicle|custom`',
    `plant_location` STRING COMMENT 'Code of the manufacturing plant where the plan is executed.',
    `regulatory_compliance` STRING COMMENT 'Applicable regulatory framework(s) for the inspection.. Valid values are `IATF16949|ISO9001|EPA|NHTSA|None`',
    `requires_approval` BOOLEAN COMMENT 'True if the inspection results must be formally approved.',
    `review_cycle_days` STRING COMMENT 'Number of days between mandatory reviews.',
    `revision_number` STRING COMMENT 'Sequential revision number for change tracking.',
    `sample_size` STRING COMMENT 'Number of units to be inspected per batch.',
    `ssot_governance_note` STRING COMMENT '',
    `tolerance_lower` DECIMAL(18,2) COMMENT 'Minimum acceptable measurement value.',
    `tolerance_upper` DECIMAL(18,2) COMMENT 'Maximum acceptable measurement value.',
    `updated_by` STRING COMMENT 'Identifier of the user who last modified the inspection plan.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the inspection plan.',
    `vehicle_model` STRING COMMENT 'Vehicle model designation for which the plan is applicable.',
    `version` STRING COMMENT 'Version label of the inspection plan (e.g., v1.0, v2.1).',
    `created_by` STRING COMMENT 'Identifier of the user who created the inspection plan.',
    CONSTRAINT pk_inspection_plan PRIMARY KEY(`inspection_plan_id`)
) COMMENT 'Detailed inspection plan specifying the characteristics to be measured, measurement methods, gauges/instruments, tolerances, sample sizes, and acceptance criteria for incoming material, in-process, and final vehicle inspections. Supports incoming material inspection (IQC), in-process quality gates, and PDI (Pre-Delivery Inspection). Linked to SAP QM inspection lots.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` (
    `inspection_lot_id` BIGINT COMMENT 'System-generated unique identifier for the inspection lot record.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: LOT INSPECTION: Inspection lots are performed on specific equipment; linking supports maintenance planning and defect attribution.',
    `field_visit_id` BIGINT COMMENT 'FK to field visit where inspection lot was created',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Required for the Inbound Part Inspection Lot report that ties each inspection lot to the specific inbound part received.',
    `inspection_plan_id` BIGINT COMMENT 'Reference to the inspection plan governing this lot.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who performed or supervised the inspection.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the employee who performed or supervised the inspection.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Traceability: inspection lot results must be linked to the specific shipment for recall, OTD and quality KPI reporting.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Inspection lots are executed per part; adding sku_master_id supports the Lot Traceability Report linking lots to the specific SKU.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Needed for the Supplier Inspection Summary dashboard aggregating inspection lots per supplier.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Supports the Inspection Lot Traceability report, associating each lot with its vehicle order to ensure inspection results are linked to the correct customer order.',
    `batch_number` STRING COMMENT 'Batch identifier associated with the material or component.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which the corrective action must be completed.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether a corrective action must be initiated for the identified defect.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection lot record was first created in the system.',
    `decision` STRING COMMENT 'Final usage decision for the lot after inspection.. Valid values are `accept|reject|conditional_release`',
    `defect_code` STRING COMMENT 'Standardized code for any defect identified during inspection.',
    `defect_description` STRING COMMENT 'Narrative description of the defect.',
    `inspection_lot_status` STRING COMMENT 'Current lifecycle status of the inspection lot.. Valid values are `open|in_progress|closed|rejected|released`',
    `inspection_method` STRING COMMENT 'Technique used to perform the inspection.. Valid values are `visual|dimensional|functional|non_destructive|automated`',
    `inspection_reason_code` STRING COMMENT 'Code indicating why the inspection was triggered (e.g., SOP, PPAP, random sampling).',
    `inspection_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection activity was performed.',
    `lot_closure_date` DATE COMMENT 'Date when the inspection lot was closed after final decision.',
    `lot_number` STRING COMMENT 'Business identifier assigned to the inspection lot, often matching the SAP lot number.',
    `lot_origin` STRING COMMENT 'Origin of the lot (e.g., goods receipt, production order).. Valid values are `goods_receipt|production_order|delivery|return`',
    `lot_type` STRING COMMENT 'Classification of the lot being inspected (e.g., incoming material, work‑in‑process assembly, finished vehicle, prototype).. Valid values are `incoming_material|wip_assembly|finished_vehicle|prototype`',
    `measurement_result_status` STRING COMMENT 'Result of the measurement against specification limits.. Valid values are `pass|fail|out_of_spec`',
    `measurement_unit` STRING COMMENT 'Unit of measure associated with the measured value (e.g., mm, V).',
    `measurement_value` DECIMAL(18,2) COMMENT 'Quantitative measurement recorded during inspection (e.g., dimension, voltage).',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant where the inspection took place.',
    `quantity_accepted` STRING COMMENT 'Number of units/items that passed inspection criteria.',
    `quantity_inspected` STRING COMMENT 'Total number of units/items examined in this inspection lot.',
    `quantity_rejected` STRING COMMENT 'Number of units/items that failed inspection criteria.',
    `remarks` STRING COMMENT 'Free‑form comments or notes captured by the inspector.',
    `serial_number` STRING COMMENT 'Serial number of the inspected unit, if applicable.',
    `source_document_number` STRING COMMENT 'Reference number of the originating document such as goods receipt, production order, or delivery.',
    `ssot_governance_note` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the inspection lot record.',
    `work_center` STRING COMMENT 'Work center responsible for the production step associated with the lot.',
    CONSTRAINT pk_inspection_lot PRIMARY KEY(`inspection_lot_id`)
) COMMENT 'Transactional record of a quality inspection event triggered for a batch of incoming materials, WIP assemblies, or finished vehicles. Captures lot origin (goods receipt, production order, delivery), inspection type, quantity inspected, inspection start/end timestamps, assigned inspector, and overall usage decision (accept, reject, conditional release). Sourced from SAP QM inspection lot management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_result` (
    `inspection_result_id` BIGINT COMMENT 'Unique identifier for the inspection result record.',
    `characteristic_id` BIGINT COMMENT 'Identifier of the inspected characteristic or measurement point.',
    `gauge_master_id` BIGINT COMMENT 'Identifier of the measurement instrument used.',
    `inspection_lot_id` BIGINT COMMENT 'Identifier of the inspection lot (header) to which this result belongs.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who performed the inspection.',
    `primary_gauge_master_id` BIGINT COMMENT 'Identifier of the measurement instrument used.',
    `comments` STRING COMMENT 'Free-text notes or observations recorded by the inspector.',
    `cp_value` DECIMAL(18,2) COMMENT 'Cp value calculated for the characteristic.',
    `cpk_value` DECIMAL(18,2) COMMENT 'Cpk value calculated for the characteristic.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection result record was created.',
    `deviation_amount` DECIMAL(18,2) COMMENT 'Numeric difference between measured value and nearest specification limit.',
    `inspection_timestamp` TIMESTAMP COMMENT 'Date and time when the measurement was taken.',
    `is_critical` BOOLEAN COMMENT 'Indicates if the characteristic is critical to vehicle safety or compliance.',
    `line_sequence` STRING COMMENT 'Sequential order of the characteristic within the inspection lot.',
    `lower_spec_limit` DECIMAL(18,2) COMMENT 'Minimum acceptable value for the characteristic.',
    `measurement_accuracy` DECIMAL(18,2) COMMENT 'Accuracy specification of the measurement instrument.',
    `measurement_condition` STRING COMMENT 'Environmental condition during measurement.. Valid values are `normal|high_temp|low_temp|vibration`',
    `measurement_humidity_percent` DECIMAL(18,2) COMMENT 'Relative humidity percentage at time of measurement.',
    `measurement_location` STRING COMMENT 'Physical location on the vehicle or part where measurement was taken.',
    `measurement_method` STRING COMMENT 'Method used to capture the measurement.. Valid values are `manual|automated|sensor`',
    `measurement_resolution` DECIMAL(18,2) COMMENT 'Resolution of the measurement instrument.',
    `measurement_source` STRING COMMENT 'Origin of the measurement data (e.g., internal sensor, external lab).. Valid values are `internal|external`',
    `measurement_temperature_c` DECIMAL(18,2) COMMENT 'Ambient temperature in Celsius at time of measurement.',
    `measurement_tool` STRING COMMENT 'Tool or equipment used for the measurement.',
    `measurement_uncertainty` DECIMAL(18,2) COMMENT 'Estimated uncertainty of the measurement.',
    `measurement_unit` STRING COMMENT 'Unit of measure for the measured value (e.g., millimeter, kilogram).. Valid values are `mm|cm|in|mmHg|psi|kg`',
    `measurement_value` DECIMAL(18,2) COMMENT 'Numeric value recorded for the characteristic.',
    `record_status` STRING COMMENT 'Current lifecycle status of the record (e.g., active, archived).. Valid values are `active|inactive|archived`',
    `result_status` STRING COMMENT 'Pass/fail outcome of the measurement.. Valid values are `pass|fail|na`',
    `ssot_governance_note` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable value for the characteristic.',
    CONSTRAINT pk_inspection_result PRIMARY KEY(`inspection_result_id`)
) COMMENT 'Individual characteristic measurement result recorded during an inspection lot. Captures the measured value or attribute outcome, tolerance limits, pass/fail status, measurement instrument used, and inspector ID for each characteristic within an inspection plan. Supports SPC data collection and statistical analysis of process capability (Cp, Cpk).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`defect_record` (
    `defect_record_id` BIGINT COMMENT 'System-generated unique identifier for the defect record.',
    `apqp_plan_id` BIGINT COMMENT 'Reference to the quality plan or inspection plan associated with the defect.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: COPQ report requires assigning each defect to the responsible cost center for financial impact analysis.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Defect records are frequently generated from dealer warranty claims; linking enables root‑cause analysis and dealer‑specific defect trends.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Defect records must reference the canonical part master for root‑cause analysis; removes redundant part_number/name.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the external supplier linked to the defect, if applicable.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Defect records are tied to the specific production order where the defect was detected, essential for the Defect Tracking Dashboard.',
    `recall_defect_report_id` BIGINT COMMENT 'Foreign key linking to compliance.recall_defect_report. Business justification: Defect records that trigger a recall are linked to the recall defect report for regulatory tracking.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Defect records must capture the employee who reported the issue for corrective‑action workflow.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Supplier performance: each defect is tied to the shipment that delivered the part, enabling root‑cause and logistics KPI analysis.',
    `sku_master_id` BIGINT COMMENT 'Identifier of the part or component associated with the defect.',
    `telemetry_event_id` BIGINT COMMENT 'Foreign key linking to mobility.telemetry_event. Business justification: Root cause analysis links each defect to the specific telemetry event that triggered it, required for the Defect Investigation Report.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: REQUIRED: Recall & warranty management needs to associate each defect record with the owning customers vehicle record to trigger service actions.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Defect records are tied to a specific VIN; FK to vin_registry allows traceability from defect to exact vehicle for warranty and recall actions.',
    `containment_action` STRING COMMENT 'Immediate action taken to contain the defect and prevent further impact.',
    `corrective_action` STRING COMMENT 'Planned or executed action to eliminate the root cause of the defect.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which the corrective action must be completed.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the defect record was initially created in the system.',
    `defect_category` STRING COMMENT 'Stage of the product lifecycle where the defect was detected.. Valid values are `incoming|in_process|final|field`',
    `defect_code` STRING COMMENT 'Business identifier code assigned to the defect for tracking and reporting.',
    `defect_description` STRING COMMENT 'Detailed textual description of the non‑conformance or quality issue.',
    `defect_record_status` STRING COMMENT 'Current lifecycle status of the defect record.. Valid values are `open|investigating|closed|rejected|deferred`',
    `defect_type` STRING COMMENT 'Classification of the defect by its origin or nature.. Valid values are `material|process|design|supplier|assembly|software`',
    `detected_timestamp` TIMESTAMP COMMENT 'Date and time when the defect was first observed.',
    `detection_method` STRING COMMENT 'Method or channel through which the defect was discovered.. Valid values are `inspection|test|audit|customer_complaint|sensor|automated`',
    `disposition` STRING COMMENT 'Final disposition of the defective item after evaluation.. Valid values are `rework|scrap|use_as_is|return_to_supplier|deferred`',
    `field_quality_investigation_id` BIGINT COMMENT 'FK to field quality investigation that identified this defect',
    `investigation_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the investigation was concluded.',
    `investigation_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the root‑cause investigation began.',
    `is_repeat_defect` BOOLEAN COMMENT 'Flag indicating whether this defect has been observed previously.',
    `location_zone` STRING COMMENT 'Vehicle zone or assembly area where the defect was identified (e.g., body, powertrain).',
    `ppm_rate` DECIMAL(18,2) COMMENT 'Defect rate expressed in parts per million for quality metrics.',
    `quantity_affected` STRING COMMENT 'Number of units or parts impacted by the defect.',
    `root_cause` STRING COMMENT 'Root cause analysis result describing why the defect occurred.',
    `severity` STRING COMMENT 'Severity level indicating impact on safety, performance, or compliance.. Valid values are `critical|major|minor|warning|info`',
    `ssot_governance_note` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the defect record.',
    `vin` STRING COMMENT 'VIN of the vehicle in which the defect was found.',
    CONSTRAINT pk_defect_record PRIMARY KEY(`defect_record_id`)
) COMMENT 'Operational record of a quality defect or non-conformance identified at any stage — incoming material, in-process assembly, final inspection, or field. Captures defect code, defect description, location on vehicle (zone/component), severity classification, detection method, quantity affected, containment action taken, and disposition (rework, scrap, use-as-is). Sourced from Apriso/Dassault MES quality control module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`spc_chart` (
    `spc_chart_id` BIGINT COMMENT 'System‑generated unique identifier for the SPC chart configuration record.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: SPC ANALYSIS: Charts are generated from data collected by a particular piece of equipment; linking enables root‑cause tracing.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: SPC charts monitor key characteristics of each work center; required for the Work Center SPC Dashboard.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date‑time when the SPC chart configuration was formally approved.',
    `center_line` DECIMAL(18,2) COMMENT 'Target center line (mean) for the SPC chart.',
    `chart_name` STRING COMMENT 'Human‑readable name identifying the SPC chart for a specific CTQ characteristic.',
    `chart_type` STRING COMMENT 'Type of SPC chart used to monitor the characteristic (e.g., X‑bar/R, p‑chart).. Valid values are `X-bar/R|X-bar/S|p-chart|c-chart|u-chart|np-chart`',
    `confidence_level` DECIMAL(18,2) COMMENT 'Statistical confidence level applied when setting control limits, expressed as a percentage.',
    `control_limit_lcl` DECIMAL(18,2) COMMENT 'Statistical lower control limit for the chart, calculated from process data.',
    `control_limit_ucl` DECIMAL(18,2) COMMENT 'Statistical upper control limit for the chart, calculated from process data.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the SPC chart record was first created in the system.',
    `ctq_characteristic` STRING COMMENT 'Name of the critical‑to‑quality (CTQ) characteristic being monitored (e.g., bolt torque, paint thickness).',
    `data_source_system` STRING COMMENT 'System of record that supplies the raw measurement data for the SPC chart.. Valid values are `SAP QM|MES|Teamcenter|Custom`',
    `spc_chart_description` STRING COMMENT 'Free‑form description providing additional context for the chart.',
    `effective_from` DATE COMMENT 'Date from which the SPC chart configuration becomes valid.',
    `effective_until` DATE COMMENT 'Date after which the SPC chart configuration is no longer valid (null if open‑ended).',
    `field_data_included_flag` BOOLEAN COMMENT 'Whether field measurement data is included in this SPC chart',
    `measurement_unit` STRING COMMENT 'Unit of measure for the monitored characteristic (e.g., mm, psi). [ENUM-REF-CANDIDATE: mm|cm|mmHg|psi|rpm|kg|%|mm/s — 8 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Optional free‑text field for any extra information or remarks.',
    `ocap` STRING COMMENT 'Defined actions to be taken when the chart signals an out‑of‑control condition.',
    `process_step` STRING COMMENT 'Descriptive name of the manufacturing process step where the SPC chart is applied.',
    `process_step_code` STRING COMMENT 'Internal code identifying the process step (e.g., ASSEMBLY_01).',
    `sample_count` STRING COMMENT 'Total number of samples used to compute the charts control limits.',
    `sampling_frequency` STRING COMMENT 'Frequency at which samples are taken for the SPC chart.. Valid values are `per_shift|per_hour|per_day|per_batch|per_lot`',
    `spc_chart_status` STRING COMMENT 'Current lifecycle status of the SPC chart configuration.. Valid values are `active|inactive|deprecated|pending`',
    `ssot_governance_note` STRING COMMENT '',
    `statistical_method` STRING COMMENT 'Statistical technique used to calculate control limits (e.g., Shewhart, EWMA).. Valid values are `Shewhart|EWMA|CUSUM|XMR`',
    `subgroup_size` STRING COMMENT 'Number of units in each sampling subgroup used for chart calculations.',
    `target_value` DECIMAL(18,2) COMMENT 'Desired target value for the characteristic (center line target).',
    `tolerance_lower` DECIMAL(18,2) COMMENT 'Lower acceptable tolerance bound for the characteristic.',
    `tolerance_upper` DECIMAL(18,2) COMMENT 'Upper acceptable tolerance bound for the characteristic.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the SPC chart record.',
    `version_number` STRING COMMENT 'Version identifier for the chart configuration, incremented on changes.',
    CONSTRAINT pk_spc_chart PRIMARY KEY(`spc_chart_id`)
) COMMENT 'Statistical Process Control chart master record defining the SPC monitoring configuration for a critical-to-quality (CTQ) characteristic at a specific process step. Specifies chart type (X-bar/R, X-bar/S, p-chart, c-chart), control limits (UCL, LCL), center line, subgroup size, sampling frequency, and out-of-control action plan (OCAP). Supports IATF 16949 SPC requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` (
    `spc_data_point_id` BIGINT COMMENT 'Unique surrogate key for each SPC measurement data point.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the production machine or equipment that generated the measurement.',
    `functional_location_id` BIGINT COMMENT 'Identifier of the plant floor location where the measurement occurred.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant.',
    `employee_id` BIGINT COMMENT 'Identifier of the operator who supervised or initiated the measurement.',
    `quality_corrective_action_id` BIGINT COMMENT 'Reference to the corrective action record triggered by this out‑of‑control event.',
    `spc_chart_id` BIGINT COMMENT 'Identifier of the SPC chart to which this data point belongs.',
    `spc_operator_employee_id` BIGINT COMMENT 'Identifier of the operator who supervised or initiated the measurement.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: SPC data points are collected per work center for statistical analysis; needed for the SPC Data Collection process.',
    `batch_number` STRING COMMENT 'Batch identifier for the material or component being inspected.',
    `calibration_date` DATE COMMENT 'Date when the sensor was last calibrated.',
    `calibration_due_date` DATE COMMENT 'Next scheduled calibration date for the sensor.',
    `comments` STRING COMMENT 'Free‑text field for operator or system notes.',
    `cp_value` DECIMAL(18,2) COMMENT 'Cp value calculated for the process at the time of measurement.',
    `cpk_value` DECIMAL(18,2) COMMENT 'Cpk value calculated for the process at the time of measurement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the SPC data point record was created in the system.',
    `data_quality_flag` BOOLEAN COMMENT 'Indicator of the raw data quality after validation.',
    `defect_code` STRING COMMENT 'Code of the defect identified when the point is out of control.',
    `field_measurement_flag` BOOLEAN COMMENT 'Whether this data point was collected in field conditions',
    `is_critical` BOOLEAN COMMENT 'True if the measurement relates to a critical quality characteristic.',
    `lot_number` STRING COMMENT 'Manufacturing lot identifier associated with the measurement.',
    `lower_control_limit` DECIMAL(18,2) COMMENT 'Statistical lower control limit for the SPC chart.',
    `lower_warning_limit` DECIMAL(18,2) COMMENT 'Optional warning limit below which a warning is raised (but not out‑of‑control).',
    `measurement_method` STRING COMMENT 'Indicates whether the measurement was captured automatically or manually.. Valid values are `automated|manual`',
    `measurement_sequence` STRING COMMENT 'Sequential order of the measurement within the subgroup.',
    `measurement_timestamp` TIMESTAMP COMMENT 'Date and time when the measurement was recorded on the shop floor.',
    `measurement_type` STRING COMMENT 'Category of the SPC variable being measured.. Valid values are `dimension|pressure|temperature|speed|voltage`',
    `measurement_unit` STRING COMMENT 'Unit of measure associated with the measurement value.. Valid values are `mm|cm|mmhg|psi|°c|%`',
    `measurement_value` DECIMAL(18,2) COMMENT 'Numeric value recorded for the SPC variable.',
    `out_of_control_flag` BOOLEAN COMMENT 'True when the data point violates any Western Electric rule.',
    `part_number` STRING COMMENT 'OEM part number (BOM reference) linked to the SPC measurement.',
    `pp_value` DECIMAL(18,2) COMMENT 'Pp value representing short‑term capability.',
    `ppk_value` DECIMAL(18,2) COMMENT 'Ppk value representing short‑term capability index.',
    `process_step` STRING COMMENT 'Production step or operation where the measurement was taken.. Valid values are `welding|painting|assembly|inspection|testing`',
    `sample_number` STRING COMMENT 'Sequential sample number within the subgroup.',
    `sample_size` STRING COMMENT 'Number of units in the subgroup used for this measurement.',
    `sensor_code` BIGINT COMMENT 'Identifier of the sensor device that recorded the measurement.',
    `sensor_type` STRING COMMENT 'Technology type of the sensor used for the measurement.. Valid values are `laser|ultrasonic|thermocouple|vision`',
    `shift` STRING COMMENT 'Work shift during which the measurement was taken.. Valid values are `day|swing|graveyard`',
    `spc_data_point_status` STRING COMMENT 'Current lifecycle status of the data point record.. Valid values are `active|inactive|archived`',
    `ssot_governance_note` STRING COMMENT '',
    `subgroup_number` STRING COMMENT 'Logical subgroup index used for SPC calculations.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the SPC data point record.',
    `upper_control_limit` DECIMAL(18,2) COMMENT 'Statistical upper control limit for the SPC chart.',
    `upper_warning_limit` DECIMAL(18,2) COMMENT 'Optional warning limit above which a warning is raised (but not out‑of‑control).',
    `western_electric_rule_violation` STRING COMMENT 'Specific Western Electric rule that was violated, if any.. Valid values are `none|rule1|rule2|rule3|rule4`',
    CONSTRAINT pk_spc_data_point PRIMARY KEY(`spc_data_point_id`)
) COMMENT 'Individual SPC measurement data point recorded against an SPC chart for a specific subgroup or sample. Captures measured value, subgroup number, timestamp, operator, shift, machine, and out-of-control signal flags (Western Electric rules violations). Enables real-time process monitoring and capability trending (Cp, Cpk, Pp, Ppk).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` (
    `quality_ppap_submission_id` BIGINT COMMENT 'Unique identifier for the quality_ppap_submission data product (auto-inserted pre-linking).',
    `apqp_plan_id` BIGINT COMMENT 'Foreign key linking to quality.apqp_plan. Business justification: PPAP submission belongs to an APQP plan; linking via apqp_plan_id enables reuse of part_number and plan details.',
    `field_validation_status` STRING COMMENT 'Field validation status for this PPAP submission',
    `ssot_governance_note` STRING COMMENT '',
    `supply_ppap_submission_id` BIGINT COMMENT 'Foreign key linking to supply.supply_ppap_submission. Business justification: PPAP Submission Tracking links the quality PPAP record to the original supply PPAP submission for compliance audits.',
    CONSTRAINT pk_quality_ppap_submission PRIMARY KEY(`quality_ppap_submission_id`)
) COMMENT 'Production Part Approval Process submission record for a supplier part or internally manufactured component. Tracks PPAP level (1-5), submission reason (new part, engineering change, tooling change), submission date, approval status, and the 18 PPAP elements status (design records, PFMEA, control plan, MSA, capability study, etc.). Supports IATF 16949 supplier quality management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` (
    `quality_corrective_action_id` BIGINT COMMENT 'Unique identifier for the quality_corrective_action data product (auto-inserted pre-linking).',
    `defect_record_id` BIGINT COMMENT 'add column defect_record_id (BIGINT) with FK to quality.defect_record.defect_record_id - corrective actions are triggered by defect records and must link back',
    `employee_id` BIGINT COMMENT 'add column employee_id (BIGINT) with FK to workforce.employee.employee_id - corrective actions have responsible owners',
    `field_engineering_report_id` BIGINT COMMENT 'FK to field engineering report that recommended this corrective action',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - corrective actions are implemented at specific plants',
    `action_description` STRING COMMENT 'Description of the corrective action taken.',
    `action_status` STRING COMMENT 'Status of the corrective action (open, in-progress, closed).',
    `action_type` STRING COMMENT 'Type of corrective action (containment, corrective, preventive)',
    `closed_date` DATE COMMENT 'Date the corrective action was verified and closed.',
    `completion_date` DATE COMMENT 'Actual date the corrective action was completed',
    `due_date` DATE COMMENT 'Target completion date for the corrective action.',
    `effectiveness_rating` STRING COMMENT 'Rating of how effective the corrective action was after implementation',
    `priority` STRING COMMENT 'Priority level of the corrective action (critical, high, medium, low)',
    `root_cause_summary` STRING COMMENT 'Summary of the root cause addressed by this corrective action',
    `ssot_governance_note` STRING COMMENT '',
    `quality_corrective_action_status` STRING COMMENT 'Current status of the corrective action (open, in-progress, closed, verified)',
    `verification_date` DATE COMMENT 'Date when the corrective action effectiveness was verified',
    `verification_method` STRING COMMENT 'Method used to verify effectiveness of the corrective action',
    CONSTRAINT pk_quality_corrective_action PRIMARY KEY(`quality_corrective_action_id`)
) COMMENT 'Corrective and Preventive Action (CAPA) record managing the structured problem-solving process for quality escapes and non-conformances. Supports 8D (Eight Disciplines) and 5-Why methodologies. Captures problem statement, containment actions (D3), root cause analysis (D4/5-Why), permanent corrective actions (D5), verification of effectiveness (D6), and preventive action deployment (D7). Tracks open/closed status and due dates.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`audit` (
    `audit_id` BIGINT COMMENT 'System-generated unique identifier for the quality audit record.',
    `employee_id` BIGINT COMMENT 'System identifier of the auditor (links to employee master).',
    `control_plan_id` BIGINT COMMENT 'Identifier of the audit plan that defines scope, criteria, and schedule.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Audit Expense Tracking links each audit to the cost center bearing the audit cost for financial statements.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer Quality Audit process requires linking each audit to the specific dealership for compliance reporting and corrective action tracking.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: AUDIT VERIFICATION: Audits often verify calibration and condition of equipment; FK enables audit‑to‑asset traceability.',
    `field_visit_id` BIGINT COMMENT 'FK to field visit during which audit was conducted',
    `primary_employee_id` BIGINT COMMENT 'System identifier of the auditor (links to employee master).',
    `plant_id` BIGINT COMMENT 'Surrogate key for the audited facility.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Quality audits are performed per production line; the Line Audit Summary report depends on this linkage.',
    `standard_id` BIGINT COMMENT 'Foreign key linking to quality.quality_standard. Business justification: Quality standards are referenced by audits; adding standard_id to quality_audit creates the needed lookup.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Quality audits are scheduled per vehicle program; linking provides program context for audit findings and compliance reporting.',
    `audit_date` DATE COMMENT 'Calendar date on which the audit was performed.',
    `audit_number` STRING COMMENT 'Human‑readable audit identifier used in reports and communications.. Valid values are `^AUD-d{6}$`',
    `audit_status` STRING COMMENT 'Current lifecycle state of the audit.. Valid values are `planned|in_progress|completed|closed|cancelled`',
    `audit_type` STRING COMMENT 'Classification of the audit (system, process, product, or layered process audit).. Valid values are `system|process|product|layered_process`',
    `auditee_location` STRING COMMENT 'Code of the plant, facility, or site where the audit was conducted.',
    `auditor_name` STRING COMMENT 'Full name of the lead auditor responsible for the audit.',
    `closure_date` DATE COMMENT 'Date on which the audit was formally closed.',
    `closure_status` STRING COMMENT 'Current status of audit closure activities.. Valid values are `open|closed|deferred`',
    `compliance_reference` STRING COMMENT 'Reference to the specific standard(s) (e.g., IATF 16949, ISO 9001) the audit addresses.',
    `corrective_action_due_date` DATE COMMENT 'Target date for completing all required corrective actions.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether any findings require corrective action.',
    `corrective_action_status` STRING COMMENT 'Current progress status of corrective actions.. Valid values are `not_started|in_progress|completed`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the audit record was first created in the system.',
    `documents_count` STRING COMMENT 'Number of supporting documents attached to the audit record.',
    `duration_minutes` STRING COMMENT 'Total time spent conducting the audit, measured in minutes.',
    `findings_major` STRING COMMENT 'Count of findings classified as major.',
    `findings_minor` STRING COMMENT 'Count of findings classified as minor.',
    `findings_severe` STRING COMMENT 'Count of findings classified as severe (high impact).',
    `findings_total` STRING COMMENT 'Total number of findings identified during the audit.',
    `method` STRING COMMENT 'Indicates whether the audit was performed internally, by an external party, or a third‑party provider.. Valid values are `internal|external|third_party`',
    `non_conformance_count` STRING COMMENT 'Number of non‑conformances identified during the audit.',
    `non_conformance_severity` STRING COMMENT 'Highest severity level among identified non‑conformances.. Valid values are `critical|major|minor`',
    `notes` STRING COMMENT 'Free‑form observations, comments, or remarks recorded by the auditor.',
    `overall_score` DECIMAL(18,2) COMMENT 'Numeric score (0‑100) representing overall audit performance.',
    `regulatory_body` STRING COMMENT 'Governing body or standard applicable to the audit.. Valid values are `IATF|ISO9001|ISO14001|NHTSA|EPA`',
    `risk_level` STRING COMMENT 'Overall risk rating derived from audit findings.. Valid values are `low|medium|high|critical`',
    `scope` STRING COMMENT 'Narrative description of the functional or geographic scope covered by the audit.',
    `score_category` STRING COMMENT 'Qualitative categorisation of the overall audit score.. Valid values are `excellent|good|fair|poor`',
    `ssot_governance_note` STRING COMMENT 'SSOT owner for audit_finding entity. Other domains reference this via FK.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the audit record.',
    CONSTRAINT pk_audit PRIMARY KEY(`audit_id`)
) COMMENT 'Quality system and process audit record capturing planned and unplanned audits conducted at plants, supplier facilities, or dealer service centers. Tracks audit type (system, process, product, layered process audit — LPA), audit scope, audit date, lead auditor, findings count by severity, overall audit score, and closure status. Supports IATF 16949 internal audit requirements and customer-specific requirements (CSR).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`quality_audit_finding` (
    `quality_audit_finding_id` BIGINT COMMENT 'Primary key for local quality_audit_finding reference',
    `compliance_audit_finding_id` BIGINT COMMENT 'FK reference to SSOT compliance.compliance_audit_finding',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_quality_audit_finding PRIMARY KEY(`quality_audit_finding_id`)
) COMMENT 'Reference to SSOT owner compliance.compliance_audit_finding. Individual finding or observation raised during a quality audit. Captures finding type (major non-conformance, minor non-conformance, observation, opportunity for improvement), clause reference (IATF 16949, ISO 9001, customer-specific), finding description, evidence, assigned owner, due date for corrective action, and closure verification status. Linked to the parent quality audit record.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` (
    `quality_pdi_inspection_id` BIGINT COMMENT 'Unique identifier for the quality_pdi_inspection data product (auto-inserted pre-linking).',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.quality_audit. Business justification: PDI inspection is part of a quality audit process; linking to quality_audit provides audit context.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Pre‑Delivery Inspection results are recorded per vehicle; linking to the connected vehicle enables traceability for OTA readiness and compliance reporting.',
    `field_visit_id` BIGINT COMMENT 'FK to field visit during which PDI was performed',
    `logistics_pdi_inspection_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_pdi_inspection. Business justification: PDI hand‑over: quality PDI record must reference the logistics PDI execution for final vehicle acceptance.',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_quality_pdi_inspection PRIMARY KEY(`quality_pdi_inspection_id`)
) COMMENT 'Pre-Delivery Inspection (PDI) record for a finished vehicle prior to handover to dealer or customer. Captures VIN, inspection date, plant or PDI center, inspector ID, checklist version, total defects found, defect categories (cosmetic, functional, safety), rework required flag, and final pass/fail disposition. Supports dealer network quality standards and customer satisfaction targets.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` (
    `ncap_test_result_id` BIGINT COMMENT 'System-generated unique identifier for the NCAP test result record.',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.quality_audit. Business justification: NCAP test results are safety audit outcomes; linking to quality_audit captures audit association.',
    `change_id` BIGINT COMMENT 'Identifier of the engineering change (ECN) associated with the vehicle configuration.',
    `engineering_test_result_id` BIGINT COMMENT 'SSOT reference to engineering.engineering_test_result (resolves cross-domain duplicate of test_result).',
    `ncap_submission_id` BIGINT COMMENT 'Foreign key linking to compliance.ncap_submission. Business justification: NCAP test results feed directly into the NCAP submission report required for safety certification.',
    `vin_registry_id` BIGINT COMMENT 'Internal surrogate key for the vehicle under test.',
    `primary_vin_registry_id` BIGINT COMMENT 'Internal surrogate key for the vehicle under test.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: NCAP test results require the test operators identity for regulatory traceability.',
    `compliance_status` STRING COMMENT 'Overall compliance determination against applicable safety regulations.. Valid values are `compliant|non_compliant|under_review`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the test result record was first created in the data lake.',
    `data_source_system` STRING COMMENT 'Source system that supplied the test result data.. Valid values are `SAP|Teamcenter|MES|Custom`',
    `field_validation_note` STRING COMMENT 'Field validation notes for NCAP test correlation',
    `homologation_status` STRING COMMENT 'Regulatory approval status of the vehicle based on the test outcome.. Valid values are `passed|failed|pending|exempt`',
    `model_year` STRING COMMENT 'Model year of the vehicle variant tested.',
    `rating_scale` STRING COMMENT 'Scale definition used for the star rating (e.g., 5‑star).',
    `raw_score_front` DECIMAL(18,2) COMMENT 'Raw numeric score for the frontal offset impact test.',
    `raw_score_pole` DECIMAL(18,2) COMMENT 'Raw numeric score for the pole impact test.',
    `raw_score_side` DECIMAL(18,2) COMMENT 'Raw numeric score for the side impact test.',
    `ssot_governance_note` STRING COMMENT '',
    `star_rating` STRING COMMENT 'Overall star rating assigned by the NCAP program (0‑5).',
    `test_comments` STRING COMMENT 'Free‑text notes captured by the test team.',
    `test_condition` STRING COMMENT 'Environmental and operational conditions during the test (e.g., temperature, humidity).',
    `test_configuration` STRING COMMENT 'Detailed configuration of the vehicle for the test (e.g., seat position, restraint settings).',
    `test_date` DATE COMMENT 'Calendar date on which the crash test was performed.',
    `test_facility` STRING COMMENT 'Name of the laboratory or proving ground where the test took place.',
    `test_observer` STRING COMMENT 'Name of the independent observer or auditor present during testing.',
    `test_program` STRING COMMENT 'The NCAP program under which the vehicle was tested.. Valid values are `Euro NCAP|NHTSA|ANCAP|Global NCAP`',
    `test_report_number` STRING COMMENT 'External reference number assigned by the testing authority for the test report.',
    `test_result_status` STRING COMMENT 'Lifecycle status of the test result record.. Valid values are `draft|final|approved|rejected`',
    `test_type` STRING COMMENT 'Category of crash test performed.. Valid values are `frontal_offset|side_impact|pole|pedestrian|aeb`',
    `test_version` STRING COMMENT 'Version identifier of the test protocol used.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the test result record.',
    `vehicle_variant` STRING COMMENT 'Specific model variant or trim level of the vehicle.',
    `vehicle_vin` STRING COMMENT 'Globally unique vehicle identifier used to link the test result to a specific vehicle.',
    CONSTRAINT pk_ncap_test_result PRIMARY KEY(`ncap_test_result_id`)
) COMMENT 'New Car Assessment Programme (NCAP) and regulatory crash/safety test result record for a vehicle model variant. Captures test program (Euro NCAP, NHTSA, ANCAP), test date, test facility, vehicle configuration tested, test type (frontal offset, side impact, pole test, pedestrian, AEB), raw scores, star ratings, and homologation status. Supports regulatory compliance and product safety reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` (
    `wltp_test_result_id` BIGINT COMMENT 'System-generated unique identifier for each WLTP test result record.',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.quality_audit. Business justification: WLTP test results are part of quality audit evidence; linking to quality_audit provides audit traceability.',
    `engineering_test_result_id` BIGINT COMMENT 'SSOT reference to engineering.engineering_test_result (resolves cross-domain duplicate of test_result).',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: WLTP test data must be linked to the operator to satisfy emissions reporting standards.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the vehicle (or prototype) that was tested.',
    `ambient_humidity_percent` DECIMAL(18,2) COMMENT 'Relative humidity measured during the test.',
    `ambient_pressure_kpa` DECIMAL(18,2) COMMENT 'Atmospheric pressure at the test site.',
    `ambient_temperature_c` DECIMAL(18,2) COMMENT 'Ambient temperature recorded during the test.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the test result record was first created in the system.',
    `electric_range_km` DECIMAL(18,2) COMMENT 'Maximum distance the electric or plug‑in hybrid powertrain can travel on a full charge under WLTP conditions.',
    `extra_high_speed_co2_g_per_km` DECIMAL(18,2) COMMENT 'CO2 emissions measured during the extra‑high‑speed phase of the WLTP cycle.',
    `extra_high_speed_fuel_l_per_100km` DECIMAL(18,2) COMMENT 'Fuel consumption recorded in the extra‑high‑speed phase.',
    `field_correlation_status` STRING COMMENT 'Field correlation status for WLTP test results',
    `high_speed_co2_g_per_km` DECIMAL(18,2) COMMENT 'CO2 emissions measured during the high‑speed phase of the WLTP cycle.',
    `high_speed_fuel_l_per_100km` DECIMAL(18,2) COMMENT 'Fuel consumption recorded in the high‑speed phase.',
    `homologation_certificate_issue_date` DATE COMMENT 'Date the homologation certificate was issued.',
    `homologation_certificate_number` STRING COMMENT 'Official certificate identifier issued after successful type‑approval.',
    `homologation_status` STRING COMMENT 'Current status of the homologation process for this test result.. Valid values are `pending|approved|rejected`',
    `low_speed_co2_g_per_km` DECIMAL(18,2) COMMENT 'CO2 emissions measured during the low‑speed phase of the WLTP cycle.',
    `low_speed_fuel_l_per_100km` DECIMAL(18,2) COMMENT 'Fuel consumption recorded in the low‑speed phase.',
    `medium_speed_co2_g_per_km` DECIMAL(18,2) COMMENT 'CO2 emissions measured during the medium‑speed phase of the WLTP cycle.',
    `medium_speed_fuel_l_per_100km` DECIMAL(18,2) COMMENT 'Fuel consumption recorded in the medium‑speed phase.',
    `model_year` STRING COMMENT 'Calendar year for which the vehicle model is designated.',
    `notes` STRING COMMENT 'Additional comments or observations recorded by the test operator.',
    `nox_mg_per_km` DECIMAL(18,2) COMMENT 'Measured nitrogen‑oxides emissions for the test cycle.',
    `particulate_mg_per_km` DECIMAL(18,2) COMMENT 'Measured particulate matter emissions for the test cycle.',
    `powertrain_variant_code` STRING COMMENT 'Internal code identifying the specific powertrain configuration (e.g., engine, hybrid, electric) used in the test.',
    `ssot_governance_note` STRING COMMENT '',
    `test_facility` STRING COMMENT 'Name of the laboratory or proving ground where the WLTP test was conducted.',
    `test_methodology` STRING COMMENT 'Indicates whether the test was conducted on a chassis dynamometer (lab) or in‑vehicle.. Valid values are `lab|in_vehicle`',
    `test_result_status` STRING COMMENT 'Overall outcome of the test execution.. Valid values are `completed|failed|cancelled`',
    `test_standard_version` STRING COMMENT 'Version of the WLTP standard applied (e.g., WLTP v2022).',
    `test_timestamp` TIMESTAMP COMMENT 'Date and time when the WLTP test was performed.',
    `test_type` STRING COMMENT 'Classification of the test methodology applied (e.g., WLTP, Real‑Driving Emissions (RDE), ECE).. Valid values are `WLTP|RDE|ECE`',
    `total_co2_g_per_km` DECIMAL(18,2) COMMENT 'Overall CO2 emissions for the complete WLTP cycle.',
    `total_fuel_l_per_100km` DECIMAL(18,2) COMMENT 'Overall fuel consumption for the complete WLTP cycle.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the test result record.',
    CONSTRAINT pk_wltp_test_result PRIMARY KEY(`wltp_test_result_id`)
) COMMENT 'Worldwide Harmonised Light Vehicles Test Procedure (WLTP) and emissions/fuel economy test result record for a vehicle powertrain variant. Captures test date, test facility, drive cycle phases (low, medium, high, extra-high), CO2 emissions (g/km), fuel consumption (L/100km), electric range (km for EV/PHEV), NOx and particulate values, and homologation certificate reference. Supports EPA, CARB, and EU type-approval compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` (
    `gauge_msa_id` BIGINT COMMENT 'Unique surrogate key for the gauge MSA record.',
    `gauge_master_id` BIGINT COMMENT 'Identifier of the gauge or measurement device being studied.',
    `acceptability_status` STRING COMMENT 'Result classification based on %GRR thresholds: acceptable (<10%), marginal (10‑30%), unacceptable (>30%).. Valid values are `acceptable|marginal|unacceptable`',
    `approval_date` DATE COMMENT 'Date when the MSA study was approved.',
    `approval_status` STRING COMMENT 'Current approval state of the MSA study results.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'User identifier who approved the MSA study.',
    `calibration_date` DATE COMMENT 'Date of the most recent calibration of the gauge prior to the study.',
    `calibration_due_date` DATE COMMENT 'Scheduled date for the next calibration of the gauge.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the MSA record was first created in the system.',
    `field_conditions_tested_flag` BOOLEAN COMMENT 'Whether MSA was tested under field conditions',
    `gauge_msa_status` STRING COMMENT 'Current lifecycle status of the gauge MSA record.. Valid values are `active|retired|archived`',
    `gauge_name` STRING COMMENT 'Human‑readable name or label of the gauge.',
    `gauge_type` STRING COMMENT 'Category of gauge based on measurement principle.. Valid values are `dimensional|functional|visual|electrical`',
    `grr_percent` DECIMAL(18,2) COMMENT 'Overall %GRR result from the study.',
    `measurement_range_max` DECIMAL(18,2) COMMENT 'Upper bound of the gauges measurable range.',
    `measurement_range_min` DECIMAL(18,2) COMMENT 'Lower bound of the gauges measurable range.',
    `measurement_unit` STRING COMMENT 'Unit of measurement used by the gauge (e.g., millimeters).',
    `ndc` STRING COMMENT 'Count of distinct measurement categories (e.g., size bins) used in the study.',
    `notes` STRING COMMENT 'Free‑form comments or observations about the study.',
    `operator_count` STRING COMMENT 'Count of distinct operators who performed measurements in the study.',
    `part_count` STRING COMMENT 'Number of distinct parts measured during the study.',
    `ssot_governance_note` STRING COMMENT '',
    `study_date` DATE COMMENT 'Calendar date when the MSA study was conducted.',
    `study_type` STRING COMMENT 'Type of MSA study performed on the gauge.. Valid values are `Gauge_RR|Linearity|Bias|Stability`',
    `trial_count` STRING COMMENT 'Number of measurement repetitions per operator‑part combination.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the MSA record.',
    `created_by` STRING COMMENT 'User identifier who created the MSA record.',
    CONSTRAINT pk_gauge_msa PRIMARY KEY(`gauge_msa_id`)
) COMMENT 'Measurement System Analysis (MSA) study record for a gauge, instrument, or measurement device used in quality inspection. Captures gauge ID, study type (Gauge R&R, linearity, bias, stability), study date, number of operators, number of parts, number of trials, %GRR result, number of distinct categories (ndc), and acceptability status (acceptable <10%, marginal 10-30%, unacceptable >30%). Supports IATF 16949 MSA requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`gauge_master` (
    `gauge_master_id` BIGINT COMMENT 'Unique surrogate key for each gauge master record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Gauge custodianship is assigned to a specific employee; linking enables maintenance responsibility tracking.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: CALIBRATION: Gauges are physical equipment tracked for maintenance; linking enables calibration schedule and asset lifecycle management.',
    `accuracy` DECIMAL(18,2) COMMENT 'Maximum permissible deviation from true value, expressed in the unit of measure.',
    `asset_tag` STRING COMMENT 'Internal barcode or RFID tag used to track the gauge in asset management systems.',
    `calibration_certificate_number` STRING COMMENT 'Reference number of the most recent calibration certificate issued by the lab.',
    `calibration_due_flag` BOOLEAN COMMENT 'True when the current date is past the next_calibration_date and the gauge has not been recalibrated.',
    `calibration_history_available` BOOLEAN COMMENT 'True if detailed calibration logs are retained for this gauge.',
    `calibration_interval_days` STRING COMMENT 'Number of days between required calibrations as defined by the calibration plan.',
    `calibration_method` STRING COMMENT 'Technique or standard employed to calibrate the gauge (e.g., laser interferometry, dead‑weight).',
    `calibration_status` STRING COMMENT 'Operational status of the gauge with respect to its calibration schedule.. Valid values are `calibrated|due|overdue|out_of_service`',
    `compliance_standard` STRING COMMENT 'Quality or environmental standard that dictates calibration and usage requirements for the gauge.. Valid values are `IATF16949|ISO9001|ISO14001`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the gauge master record was first created.',
    `gauge_master_description` STRING COMMENT 'Detailed description of the gauge, its application and special characteristics.',
    `effective_from` DATE COMMENT 'Date when the gauge was placed into service.',
    `effective_until` DATE COMMENT 'Date when the gauge was decommissioned or taken out of service (null if still active).',
    `field_portable_flag` BOOLEAN COMMENT 'Whether this gauge is portable for field use',
    `gauge_master_status` STRING COMMENT 'Current lifecycle state of the gauge within the quality system.. Valid values are `active|inactive|retired|maintenance`',
    `gauge_number` STRING COMMENT 'Human‑readable identifier printed on the gauge.',
    `gauge_type` STRING COMMENT 'Category of measurement instrument (e.g., Coordinate Measuring Machine, caliper, torque wrench, vision system, laser tracker).. Valid values are `cmm|caliper|torque_wrench|vision_system|laser_tracker`',
    `inspection_capability` STRING COMMENT 'Main type of measurement the gauge provides for quality inspections.. Valid values are `dimensional|torque|visual|electrical`',
    `is_critical_gauge` BOOLEAN COMMENT 'True when the gauge is used for measurements that affect product safety or regulatory compliance.',
    `last_calibrated_by` STRING COMMENT 'Identifier of the person or external lab that performed the most recent calibration.',
    `last_calibration_date` DATE COMMENT 'Calendar date when the gauge was last calibrated.',
    `line` STRING COMMENT 'Specific line or cell within the plant that uses the gauge.',
    `location` STRING COMMENT 'General area (e.g., warehouse, line, lab) where the gauge is stored or used.',
    `manufacturer` STRING COMMENT 'Company that produced the gauge.',
    `measurement_range_max` DECIMAL(18,2) COMMENT 'Highest value the gauge can accurately measure.',
    `measurement_range_min` DECIMAL(18,2) COMMENT 'Lowest value the gauge can accurately measure.',
    `model_number` STRING COMMENT 'Manufacturers model identifier for the gauge.',
    `next_calibration_date` DATE COMMENT 'Projected date for the next required calibration based on interval.',
    `notes` STRING COMMENT 'Additional comments, observations, or special handling instructions for the gauge.',
    `plant` STRING COMMENT 'Code or name of the manufacturing plant where the gauge resides.',
    `purchase_date` DATE COMMENT 'Calendar date the gauge was acquired by the organization.',
    `serial_number` STRING COMMENT 'Unique serial number stamped on the gauge hardware.',
    `ssot_governance_note` STRING COMMENT '',
    `station` STRING COMMENT 'Exact station or work‑cell where the gauge is deployed.',
    `tolerance` DECIMAL(18,2) COMMENT 'Acceptable deviation range for measurements taken with the gauge.',
    `unit_of_measure` STRING COMMENT 'Standard unit used for the gauges measurement range.. Valid values are `mm|in|psi|nm`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the gauge master record.',
    `warranty_expiration_date` DATE COMMENT 'Date when the manufacturers warranty for the gauge ends.',
    CONSTRAINT pk_gauge_master PRIMARY KEY(`gauge_master_id`)
) COMMENT 'Master record for all measurement instruments, gauges, fixtures, and test equipment used in quality inspection and SPC. Captures gauge number, description, type (CMM, caliper, torque wrench, vision system), calibration interval, last calibration date, next calibration due date, calibration status, location (plant/line/station), and responsible custodian. Supports gauge calibration management per IATF 16949.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`ppm_record` (
    `ppm_record_id` BIGINT COMMENT 'Unique identifier for the PPM defect rate record.',
    `quality_gate_id` BIGINT COMMENT 'Foreign key linking to quality.quality_gate. Business justification: PPM records are evaluated at quality gates; linking to quality_gate enables gate‑level analysis.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier providing the part.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: PPM records must capture who entered the data for auditability and data‑quality checks.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: PPM reporting is SKU‑specific; linking to sku_master enables the Supplier Part Quality Dashboard and accurate ppm aggregation per part.',
    `approval_date` DATE COMMENT 'Date when the PPM record was approved.',
    `approved_by` STRING COMMENT 'Name or identifier of the person who approved the PPM record.',
    `batch_number` STRING COMMENT 'Identifier of the production batch associated with the PPM measurement.',
    `comments` STRING COMMENT 'Additional remarks or observations about the PPM record.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the PPM record was first created in the system.',
    `defect_category` STRING COMMENT 'High‑level classification of the defect cause.. Valid values are `material|process|design|assembly|other`',
    `defect_category_count` BIGINT COMMENT 'Number of defects attributed to the selected defect category.',
    `field_ppm_contribution` DECIMAL(18,2) COMMENT 'PPM contribution from field failures',
    `inspection_type` STRING COMMENT 'Category of inspection (e.g., incoming, in‑process, final, pre‑delivery).. Valid values are `incoming|in_process|final|pdi`',
    `is_outlier` BOOLEAN COMMENT 'True if the PPM value is flagged as an outlier by statistical rules.',
    `lot_number` STRING COMMENT 'Identifier of the material lot linked to the PPM record.',
    `measurement_timestamp` TIMESTAMP COMMENT 'Date‑time when the PPM measurement was recorded.',
    `model_year` STRING COMMENT 'Calendar year the vehicle model was released.',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant where the parts were produced.',
    `plant_name` STRING COMMENT 'Descriptive name of the manufacturing plant.',
    `ppm_record_status` STRING COMMENT 'Lifecycle status of the PPM record.. Valid values are `open|closed|reviewed`',
    `ppm_value` DECIMAL(18,2) COMMENT 'Defects per million parts (PPM) for the reporting period.',
    `ppm_variance` DECIMAL(18,2) COMMENT 'Actual PPM minus target PPM; positive indicates over‑target.',
    `quality_gate_passed` BOOLEAN COMMENT 'True if the part passed the defined quality gate for the period.',
    `region_code` STRING COMMENT 'Three‑letter country/region code where the measurement originated.. Valid values are `^[A-Z]{3}$`',
    `reporting_period` STRING COMMENT 'Month (YYYY‑MM) or quarter (Qn‑YYYY) for which the PPM is calculated.. Valid values are `^d{4}-(0[1-9]|1[0-2])$|^Q[1-4]-d{4}$`',
    `revision_number` STRING COMMENT 'Incremental revision number of the PPM record.',
    `ssot_governance_note` STRING COMMENT '',
    `target_ppm` DECIMAL(18,2) COMMENT 'Maximum acceptable PPM value as defined by the quality goal.',
    `total_defective_parts` BIGINT COMMENT 'Number of parts that failed quality inspection in the reporting period.',
    `total_parts_received` BIGINT COMMENT 'Total number of parts received from the supplier or produced in‑process during the reporting period.',
    `trend_indicator` STRING COMMENT 'Indicates whether the PPM trend is improving, declining, or stable.. Valid values are `improving|declining|stable`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the PPM record.',
    `vehicle_model` STRING COMMENT 'Model designation of the vehicle that uses the part.',
    CONSTRAINT pk_ppm_record PRIMARY KEY(`ppm_record_id`)
) COMMENT 'Parts Per Million (PPM) defect rate record tracking supplier or internal process quality performance over a defined period. Captures supplier or plant code, part number, reporting period (month/quarter), total parts received or produced, total defective parts, PPM value, defect category breakdown, and trend vs. target. Supports supplier quality scorecards and IATF 16949 supplier monitoring requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`gate_result` (
    `gate_result_id` BIGINT COMMENT 'Unique system-generated identifier for each gate result record.',
    `quality_gate_id` BIGINT COMMENT 'Identifier of the quality gate where the vehicle was inspected.',
    `employee_id` BIGINT COMMENT 'Identifier of the shop‑floor operator who performed the gate scan.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the shop‑floor operator who performed the gate scan.',
    `trip_id` BIGINT COMMENT 'Foreign key linking to mobility.trip. Business justification: Gate results during final testing are associated with the test trip record to correlate inspection outcomes with vehicle movement, needed for the Final Gate Report.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Needed for the Production Gate Tracking dashboard linking gate results to the specific vehicle order to monitor delivery schedules and quality release dates.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Gate results are captured per vehicle during production; linking to vin_registry supports gate‑by‑VIN reporting and rework analysis.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether a corrective action must be initiated due to a fail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the gate result record was first created in the system.',
    `defect_count` STRING COMMENT 'Count of distinct defects recorded during the gate inspection.',
    `gate_location` STRING COMMENT 'Plant or line code where the gate is physically located.',
    `gate_status` STRING COMMENT 'Overall result of the gate inspection; pass indicates compliance, fail indicates one or more defects.. Valid values are `pass|fail`',
    `gate_type` STRING COMMENT 'Functional classification of the gate (e.g., assembly, paint, final).. Valid values are `assembly|paint|final|engine|chassis`',
    `inspection_result_code` STRING COMMENT 'Standardized code representing the detailed outcome of the inspection.',
    `notes` STRING COMMENT 'Free‑form comments or observations recorded by the operator.',
    `quality_score` DECIMAL(18,2) COMMENT 'Numeric score (0‑100) summarizing overall quality performance for this gate.',
    `rework_loop_count` STRING COMMENT 'Number of rework cycles the vehicle has undergone prior to this gate.',
    `scan_timestamp` TIMESTAMP COMMENT 'Date and time when the vehicle passed the gate and was scanned.',
    `shift` STRING COMMENT 'Shift during which the gate scan occurred.. Valid values are `day|night|swing`',
    `ssot_governance_note` STRING COMMENT '',
    `time_at_gate_seconds` STRING COMMENT 'Duration in seconds that the vehicle spent at the gate for inspection.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the gate result record.',
    `vin` STRING COMMENT 'Globally unique 17‑character identifier assigned to the vehicle.',
    CONSTRAINT pk_gate_result PRIMARY KEY(`gate_result_id`)
) COMMENT 'Transactional record of a vehicle or assembly unit passing through a quality gate during production. Captures VIN or assembly serial number, gate ID, scan timestamp, operator ID, shift, overall pass/fail status, number of defects found, rework loop count, and time-at-gate. Sourced from Apriso/Dassault MES shop floor traceability. Enables first-time quality (FTQ) and direct run rate calculations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` (
    `supplier_quality_event_id` BIGINT COMMENT 'Unique identifier for the supplier quality event.',
    `field_failure_analysis_id` BIGINT COMMENT 'FK to field failure analysis implicating this supplier',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where defect was detected.',
    `employee_id` BIGINT COMMENT 'Identifier of the internal owner responsible for investigation.',
    `supplier_investigation_owner_employee_id` BIGINT COMMENT 'Identifier of the internal owner responsible for investigation.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Supplier Quality Event Management uses the supply‑domain supplier master for root‑cause analysis and reporting.',
    `actual_resolution_time_days` STRING COMMENT 'Actual number of days taken to resolve the issue.',
    `affected_quantity` STRING COMMENT 'Total quantity of parts received in the shipment.',
    `attached_documentation` STRING COMMENT 'Reference to attached documents (e.g., photos, test reports).',
    `comments` STRING COMMENT 'Additional free-text comments or notes.',
    `compliance_standard` STRING COMMENT 'Regulatory or quality standard relevant to the event.. Valid values are `IATF16949|ISO9001|EPA|NHTSA`',
    `containment_action` STRING COMMENT 'Immediate action taken to contain the defect.',
    `corrective_action_due_date` DATE COMMENT 'Target date for implementing corrective actions.',
    `corrective_action_plan` STRING COMMENT 'Planned corrective actions to resolve the defect.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the event record was created.',
    `defect_description` STRING COMMENT 'Narrative description of the defect observed.',
    `defect_quantity` STRING COMMENT 'Number of units affected by the defect.',
    `defect_severity` STRING COMMENT 'Severity classification of the defect.. Valid values are `critical|major|minor`',
    `delivery_note_number` STRING COMMENT 'Reference number of the delivery note associated with the part.',
    `detection_method` STRING COMMENT 'Method used to detect the defect.. Valid values are `visual|automated|test|audit`',
    `event_number` STRING COMMENT 'Business identifier assigned to the quality event.',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the quality event was recorded.',
    `expected_resolution_time_days` STRING COMMENT 'Planned number of days to resolve the issue.',
    `is_critical` BOOLEAN COMMENT 'Flag indicating if the event is classified as critical.',
    `is_repeat_issue` BOOLEAN COMMENT 'Flag indicating if this defect has occurred previously for the same part/supplier.',
    `part_number` STRING COMMENT 'Identifier of the part or material supplied.',
    `quality_system` STRING COMMENT 'Quality system or standard applicable (e.g., IATF 16949).',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates if the defect impacts regulatory compliance (e.g., NHTSA).',
    `resolution_date` DATE COMMENT 'Date when the event was resolved.',
    `resolution_status` STRING COMMENT 'Overall status of the event resolution.. Valid values are `resolved|unresolved|closed|deferred`',
    `risk_rating` STRING COMMENT 'Overall risk rating associated with the defect.. Valid values are `high|medium|low`',
    `root_cause_analysis` STRING COMMENT 'Analysis identifying the root cause of the defect.',
    `sca_number` STRING COMMENT 'Identifier of the Supplier Corrective Action Request.',
    `sca_requested` BOOLEAN COMMENT 'Indicates whether a formal SCAR was issued to the supplier.',
    `ssot_governance_note` STRING COMMENT '',
    `supplier_response_due_date` DATE COMMENT 'Date by which the supplier must respond with corrective action.',
    `supplier_response_status` STRING COMMENT 'Current status of the suppliers response.. Valid values are `pending|submitted|rejected|approved`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the event record.',
    CONSTRAINT pk_supplier_quality_event PRIMARY KEY(`supplier_quality_event_id`)
) COMMENT 'Supplier quality incident or deviation event record raised when a supplier-delivered part or material fails incoming inspection or causes a production disruption. Captures supplier code, part number, delivery note reference, defect description, quantity affected, severity (critical, major, minor), containment action, supplier response due date, and resolution status. Supports supplier corrective action request (SCAR) workflow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` (
    `warranty_quality_signal_id` BIGINT COMMENT 'Unique system-generated identifier for the warranty quality signal record.',
    `aftersales_warranty_claim_id` BIGINT COMMENT 'Identifier of the warranty claim that generated the signal.',
    `breakdown_case_id` BIGINT COMMENT 'FK to breakdown case that generated this warranty quality signal',
    `case_id` BIGINT COMMENT 'Identifier of the direct customer complaint record.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Warranty signals are tied to the specific telematics unit of the vehicle for recall actions and service planning, required by the Warranty Claim Processing workflow.',
    `credit_memo_id` BIGINT COMMENT 'Foreign key linking to billing.credit_memo. Business justification: REQUIRED: Warranty cost‑recovery process creates a credit memo to recover supplier costs; linking signal to credit_memo enables automated financial tracking.',
    `field_return_id` BIGINT COMMENT 'Identifier of the field return record linked to the signal.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer where the vehicle was serviced or sold.',
    `party_id` BIGINT COMMENT 'Identifier of the end‑customer owner of the vehicle.',
    `quality_corrective_action_id` BIGINT COMMENT 'Identifier linking to the corrective action plan associated with the signal.',
    `root_cause_analysis_id` BIGINT COMMENT 'Identifier linking to the root cause analysis record.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Field failure analysis: warranty signals are linked to the originating shipment to identify logistics‑related issues.',
    `tsb_id` BIGINT COMMENT 'Identifier of the TSB that triggered the signal, if applicable.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Warranty quality signals reference a specific vehicle VIN; FK enables correlation of field failures with original vehicle data.',
    `warranty_customer_party_id` BIGINT COMMENT 'Identifier of the end‑customer owner of the vehicle.',
    `warranty_dealer_dealership_id` BIGINT COMMENT 'Identifier of the dealer where the vehicle was serviced or sold.',
    `affected_vin_count` BIGINT COMMENT 'Count of distinct VINs impacted by this signal.',
    `associated_vehicle_model` STRING COMMENT 'Vehicle model (e.g., Corolla, F-150) linked to the signal.',
    `associated_vehicle_variant` STRING COMMENT 'Specific variant or trim level of the vehicle.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the signal record was first created in the lakehouse.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for the impact amount. [ENUM-REF-CANDIDATE: USD|EUR|JPY|GBP|CAD|AUD|CHF|CNY|INR|BRL|... — promote to reference product]',
    `data_source` STRING COMMENT 'Logical data source name or database where the raw record resides.',
    `detection_timestamp` TIMESTAMP COMMENT 'Exact time the quality issue was first detected in the field.',
    `escalation_level` STRING COMMENT 'Level of escalation to corrective action processes.. Valid values are `none|level1|level2|level3`',
    `failure_description` STRING COMMENT 'Narrative description of the observed failure or defect.',
    `failure_mode` STRING COMMENT 'Technical classification of how the part failed (e.g., fracture, leak).',
    `impact_amount` DECIMAL(18,2) COMMENT 'Estimated financial impact of the quality issue.',
    `is_repeat_signal` BOOLEAN COMMENT 'Flag indicating whether this signal has been observed previously.',
    `is_systemic` BOOLEAN COMMENT 'Flag indicating whether the issue is considered systemic across multiple vehicles.',
    `model_year` STRING COMMENT 'Model year of the vehicle associated with the signal.',
    `notes` STRING COMMENT 'Free‑text field for additional context or analyst comments.',
    `occurrence_count` BIGINT COMMENT 'Number of times the failure has been reported in the field.',
    `part_name` STRING COMMENT 'Descriptive name of the part or system linked to the signal.',
    `part_number` STRING COMMENT 'OEM part number of the component associated with the quality signal.',
    `severity_level` STRING COMMENT 'Business impact severity assigned to the signal.. Valid values are `critical|high|medium|low|info`',
    `severity_score` DECIMAL(18,2) COMMENT 'Numeric severity rating (e.g., 0.00–10.00) derived from internal scoring models.',
    `signal_code` STRING COMMENT 'Business identifier code for the quality signal, used for tracking and reporting.',
    `signal_status` STRING COMMENT 'Current lifecycle status of the quality signal.. Valid values are `open|investigating|closed|escalated`',
    `source_reference` STRING COMMENT 'Identifier of the originating record in the source system (e.g., claim number, return ID).',
    `source_type` STRING COMMENT 'Origin of the signal: warranty claim, field return, technical service bulletin trigger, or direct customer complaint.. Valid values are `warranty_claim|field_return|tsb_trigger|customer_complaint`',
    `ssot_governance_note` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the signal record.',
    CONSTRAINT pk_warranty_quality_signal PRIMARY KEY(`warranty_quality_signal_id`)
) COMMENT 'Field quality signal derived from warranty claims and field returns that indicates a potential systemic quality issue requiring engineering or manufacturing investigation. Captures signal source (warranty claim, field return, TSB trigger, customer complaint), affected part or system, failure description, field occurrence count, affected VIN population, signal severity, and escalation status to corrective action. Bridges after-sales warranty data with quality engineering.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`standard` (
    `standard_id` BIGINT COMMENT 'System-generated unique identifier for the quality standard record.',
    `jurisdiction_id` BIGINT COMMENT 'add column jurisdiction_id (BIGINT) with FK to compliance.jurisdiction.jurisdiction_id - quality standards (IATF 16949, ISO) apply within specific jurisdictions',
    `applicability_scope` STRING COMMENT 'Geographic or plant scope where the standard applies.. Valid values are `global|regional|plant_specific`',
    `standard_code` STRING COMMENT 'Official alphanumeric code assigned by the issuing body (e.g., ISO 9001, IATF 16949).',
    `compliance_status` STRING COMMENT 'Current compliance assessment of the organization against this standard.. Valid values are `compliant|non_compliant|partial|pending`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the standard record was first created in the system.',
    `standard_description` STRING COMMENT 'Detailed description of the scope, purpose and content of the standard.',
    `document_format` STRING COMMENT 'File format of the stored standard document.. Valid values are `pdf|docx|xlsx|html`',
    `document_url` STRING COMMENT 'Web address or repository link to the electronic version of the standard.',
    `effective_date` DATE COMMENT 'Date on which the standard becomes effective.',
    `expiry_date` DATE COMMENT 'Date on which the standard expires or is superseded (nullable if open‑ended).',
    `field_service_applicable_flag` BOOLEAN COMMENT 'Whether this quality standard applies to field service operations',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether compliance with this standard is mandatory for the organization.',
    `issuing_body` STRING COMMENT 'Organization that issued the standard (e.g., ISO, IATF, EPA, NHTSA).',
    `language` STRING COMMENT 'Language in which the standard document is written.. Valid values are `en|de|fr|es|zh|ja`',
    `lifecycle_status` STRING COMMENT 'Current lifecycle state of the standard record.. Valid values are `draft|active|inactive|retired|pending`',
    `notes` STRING COMMENT 'Free‑form comments or additional information about the standard.',
    `regulatory_body` STRING COMMENT 'Regulatory authority associated with the standard (e.g., NHTSA, EPA, UNECE).',
    `regulatory_section` STRING COMMENT 'Specific section or clause of the regulation that the standard addresses.',
    `revision_date` DATE COMMENT 'Date when the latest revision of the standard was released.',
    `revision_number` STRING COMMENT 'Internal revision identifier for updates to the standard document.',
    `ssot_governance_note` STRING COMMENT '',
    `standard_type` STRING COMMENT 'Category of the standard (e.g., quality management, environmental, safety, emissions, regulatory, process).. Valid values are `quality|environment|safety|emissions|regulatory|process`',
    `title` STRING COMMENT 'Human‑readable title of the quality standard or specification.',
    `updated_by` STRING COMMENT 'User identifier of the person who last modified the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the standard record.',
    `version_number` STRING COMMENT 'Version identifier of the standard (e.g., 1.0, 2.3).',
    `created_by` STRING COMMENT 'User identifier of the person who created the record.',
    CONSTRAINT pk_standard PRIMARY KEY(`standard_id`)
) COMMENT 'Reference master for quality standards, specifications, and regulatory requirements applicable to the business. Captures standard code (IATF 16949, ISO 9001, ISO 14001, FMVSS, ECE regulations), standard title, issuing body, version, effective date, expiry date, applicability scope (global, regional, plant-specific), and compliance status. Used to link quality plans, audits, and test results to governing requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`defect_code` (
    `defect_code_id` BIGINT COMMENT 'Primary key for defect_code reference table; role inferred as REFERENCE_LOOKUP, no minimum categories required.',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - defect codes are often program-specific in automotive quality systems',
    `affected_system` STRING COMMENT 'Vehicle system or subsystem impacted by the defect.. Valid values are `Powertrain|Chassis|Electrical|Interior|Exterior|ADAS`',
    `affected_zone` STRING COMMENT 'Physical zone of the vehicle where the defect occurs.. Valid values are `Front|Rear|Left|Right|Center|All`',
    `applicable_stage` STRING COMMENT 'Process stage(s) where the defect can be recorded.. Valid values are `incoming|in_process|final|field`',
    `defect_code_category` STRING COMMENT 'High‑level classification of the defect type.. Valid values are `dimensional|cosmetic|functional|safety|nvh`',
    `defect_code_code` STRING COMMENT 'Standardized alphanumeric identifier for the defect (e.g., D001).',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether a corrective action is mandatory for this defect.',
    `cost_impact_estimate` DECIMAL(18,2) COMMENT 'Estimated financial impact of the defect per occurrence.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the defect code record was created.',
    `defect_code_description` STRING COMMENT 'Detailed textual description of the defect.',
    `detection_method` STRING COMMENT 'Typical method used to detect the defect.. Valid values are `visual|sensor|test|audit|automated`',
    `effective_end_date` DATE COMMENT 'Date after which the defect code is no longer valid (nullable).',
    `effective_start_date` DATE COMMENT 'Date from which the defect code becomes valid.',
    `field_failure_category` STRING COMMENT 'Field failure category mapping for this defect code',
    `is_active` BOOLEAN COMMENT 'Indicates whether the defect code is currently active for use.',
    `defect_code_name` STRING COMMENT 'Human‑readable name describing the defect.',
    `notes` STRING COMMENT 'Free‑form notes or remarks about the defect code.',
    `regulatory_compliance` STRING COMMENT 'Regulatory framework(s) the defect code complies with.. Valid values are `iatf16949|iso9001|epa|nhtsa|none`',
    `root_cause_category` STRING COMMENT 'Primary cause category for the defect.. Valid values are `design|material|process|supplier|installation|unknown`',
    `severity_default` STRING COMMENT 'Default severity rating assigned to the defect.. Valid values are `low|medium|high|critical`',
    `ssot_governance_note` STRING COMMENT '',
    `typical_resolution_time_days` STRING COMMENT 'Average number of days to resolve the defect after detection.',
    `updated_by` STRING COMMENT 'User or system that performed the latest update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the defect code record.',
    `version_number` STRING COMMENT 'Version of the defect code definition for change control.',
    `warranty_implication` STRING COMMENT 'Impact of the defect on warranty obligations.. Valid values are `none|warranty_repair|warranty_replacement|recall`',
    `created_by` STRING COMMENT 'User or system that created the defect code record.',
    CONSTRAINT pk_defect_code PRIMARY KEY(`defect_code_id`)
) COMMENT 'Reference catalog of standardized defect codes and classifications used across all quality inspection, defect recording, and warranty processes. Captures defect code, defect name, defect category (dimensional, cosmetic, functional, safety, NVH), affected system or zone, severity default, detection method, and applicable process stage (incoming, in-process, final, field). Ensures consistent defect classification across plants and suppliers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`notification` (
    `notification_id` BIGINT COMMENT 'System-generated unique identifier for the quality notification record.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Quality notifications are often addressed to a specific dealership to trigger corrective actions or safety recalls.',
    `field_visit_id` BIGINT COMMENT 'FK to field visit that generated this quality notification',
    `employee_id` BIGINT COMMENT 'Identifier of the quality engineer responsible for the case.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Exception handling: quality notifications reference the shipment they affect, required for logistics exception dashboards.',
    `tertiary_notification_employee_id` BIGINT COMMENT 'Identifier of the quality engineer responsible for the case.',
    `actual_resolution_date` DATE COMMENT 'Date when the issue was actually closed or resolved.',
    `affected_material_number` STRING COMMENT 'SAP material number of the part implicated in the quality issue.',
    `affected_vehicle_vin` STRING COMMENT 'VIN of the vehicle affected by the quality problem.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `attachment_count` STRING COMMENT 'Number of supporting documents or images attached to the notification.',
    `corrective_action_due_date` DATE COMMENT 'Deadline for completing the corrective actions.',
    `corrective_action_plan` STRING COMMENT 'Planned actions to remediate the issue and prevent recurrence.',
    `creation_timestamp` TIMESTAMP COMMENT 'Date‑time when the notification record was created in the system.',
    `defect_category` STRING COMMENT 'Classification of the defect type.. Valid values are `cosmetic|functional|safety|performance`',
    `department_responsible` STRING COMMENT 'Organizational department accountable for the notification.',
    `escalation_level` STRING COMMENT 'Level of escalation applied to the notification.. Valid values are `none|level1|level2|level3`',
    `is_critical` BOOLEAN COMMENT 'True if the issue is deemed critical to product quality or safety.',
    `is_regulatory_compliance` BOOLEAN COMMENT 'True if the issue is subject to regulatory reporting requirements.',
    `is_safety_related` BOOLEAN COMMENT 'Indicates whether the issue impacts vehicle safety.',
    `last_update_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the notification.',
    `notification_number` STRING COMMENT 'Business identifier assigned to the notification, used for tracking and reference.',
    `notification_status` STRING COMMENT 'Current lifecycle state of the quality notification.. Valid values are `open|in_process|resolved|closed|rejected`',
    `notification_type` STRING COMMENT 'Category describing the nature of the quality issue.. Valid values are `complaint|defect|deviation|customer_feedback`',
    `originator_contact` STRING COMMENT 'Email address of the originator for follow‑up communication.',
    `originator_name` STRING COMMENT 'Full name of the person or entity that raised the notification.',
    `originator_type` STRING COMMENT 'Indicates whether the notification was raised internally, by a customer, dealer, or supplier.. Valid values are `internal|customer|dealer|supplier`',
    `plant_location_code` STRING COMMENT 'Code of the manufacturing plant where the issue originated.',
    `ppm_rate` DECIMAL(18,2) COMMENT 'Measured defect rate associated with the issue.',
    `priority` STRING COMMENT 'Business priority assigned to the notification for handling urgency.. Valid values are `low|medium|high|critical`',
    `problem_description` STRING COMMENT 'Detailed narrative of the quality issue as reported.',
    `regulatory_body` STRING COMMENT 'Governing authority relevant to the notification.. Valid values are `IATF|NHTSA|EPA|ISO9001|ISO14001`',
    `related_claim_number` STRING COMMENT 'Warranty or insurance claim identifier associated with the notification.',
    `related_order_number` STRING COMMENT 'Sales order number linked to the quality issue, if applicable.',
    `root_cause_analysis` STRING COMMENT 'Summary of the identified root cause for the quality problem.',
    `ssot_governance_note` STRING COMMENT '',
    `target_resolution_date` DATE COMMENT 'Planned date by which the issue should be resolved.',
    CONSTRAINT pk_notification PRIMARY KEY(`notification_id`)
) COMMENT 'SAP QM quality notification record capturing formal quality alerts, complaints, and problem reports raised internally or from customers/dealers. Captures notification type (complaint, defect, deviation), originator, affected material or vehicle, problem description, priority, assigned quality engineer, target resolution date, and status (open, in-process, completed). Sourced from SAP QM notification management module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`calibration_event` (
    `calibration_event_id` BIGINT COMMENT 'Unique identifier for the calibration event record.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or assembly line where the gauge is installed.',
    `gauge_master_id` BIGINT COMMENT 'Identifier of the gauge or measurement instrument being calibrated.',
    `primary_equipment_registry_id` BIGINT COMMENT 'Identifier of the equipment or assembly line where the gauge is installed.',
    `primary_gauge_master_id` BIGINT COMMENT 'Identifier of the gauge or measurement instrument being calibrated.',
    `technician_id` BIGINT COMMENT 'Identifier of the technician who performed the calibration.',
    `as_found_value` DECIMAL(18,2) COMMENT 'Measured value of the gauge before any adjustment.',
    `as_left_value` DECIMAL(18,2) COMMENT 'Measured value of the gauge after adjustment (post‑calibration).',
    `calibration_event_status` STRING COMMENT 'Overall lifecycle status of the calibration event.. Valid values are `scheduled|in_progress|completed|failed|cancelled`',
    `calibration_lab` STRING COMMENT 'Name of the internal or external laboratory that performed the calibration.',
    `calibration_method` STRING COMMENT 'Method used for calibration – internal (in‑house) or external (third‑party lab).. Valid values are `internal|external`',
    `calibration_standard` STRING COMMENT 'Standard or procedure used for the calibration (e.g., ISO 9001, IATF 16949).',
    `calibration_status` STRING COMMENT 'Current status of the calibration record.. Valid values are `completed|pending|overdue`',
    `calibration_timestamp` TIMESTAMP COMMENT 'Exact date and time when the calibration activity was performed.',
    `certificate_number` STRING COMMENT 'Identifier of the calibration certificate issued after successful calibration.',
    `compliance_standard` STRING COMMENT 'Reference to the regulatory or quality standard governing the calibration (e.g., IATF 16949 Clause 7.1.5).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the calibration event record was created in the system.',
    `event_number` STRING COMMENT 'Business identifier or reference number for the calibration event.',
    `gauge_number` STRING COMMENT 'Manufacturer-assigned serial or part number of the gauge.',
    `lab_accreditation` STRING COMMENT 'Accreditation body or standard (e.g., ISO/IEC 17025) that the calibration lab holds.',
    `location` STRING COMMENT 'Physical location (plant, line, or station) where the gauge is used or calibrated.',
    `measurement_range_max` DECIMAL(18,2) COMMENT 'Maximum measurable value of the gauge according to its specification.',
    `measurement_range_min` DECIMAL(18,2) COMMENT 'Minimum measurable value of the gauge according to its specification.',
    `measurement_uncertainty` DECIMAL(18,2) COMMENT 'Stated uncertainty of the gauge measurement after calibration.',
    `next_due_date` DATE COMMENT 'Scheduled date for the next required calibration of the gauge.',
    `notes` STRING COMMENT 'Free‑form notes or comments about the calibration event.',
    `result` STRING COMMENT 'Outcome of the calibration activity.. Valid values are `pass|fail|adjusted`',
    `ssot_governance_note` STRING COMMENT '',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the as‑found and as‑left values (e.g., mm, in, µm).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the calibration event record.',
    CONSTRAINT pk_calibration_event PRIMARY KEY(`calibration_event_id`)
) COMMENT 'Transactional record of a gauge or measurement instrument calibration activity. Captures gauge ID, calibration date, calibration laboratory (internal or accredited external), calibration standard used, as-found condition, as-left condition, calibration result (pass/fail/adjusted), certificate number, next due date, and technician ID. Supports IATF 16949 Clause 7.1.5 measurement equipment traceability requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`target` (
    `target_id` BIGINT COMMENT 'System-generated unique identifier for the quality target record.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Quality targets are set per dealership (e.g., service CSI scores); the link supports performance scorecards and incentive eligibility.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant to which the target applies.',
    `employee_id` BIGINT COMMENT 'Identifier of the person or team accountable for achieving the target.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier whose parts or processes are covered by the target.',
    `production_line_id` BIGINT COMMENT 'Identifier of the specific production line or cell.',
    `target_responsible_owner_employee_id` BIGINT COMMENT 'Identifier of the person or team accountable for achieving the target.',
    `vehicle_program_id` BIGINT COMMENT 'Identifier of the vehicle model or program associated with the target.',
    `alignment_policy` STRING COMMENT 'Reference to the corporate quality policy or objective that this target supports.',
    `baseline_value` DECIMAL(18,2) COMMENT 'Historical performance value used as a reference point.',
    `target_code` STRING COMMENT 'Business code used to reference the target in external systems (e.g., SAP QM).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the target record was created.',
    `effective_from` DATE COMMENT 'Date when the quality target becomes binding.',
    `effective_until` DATE COMMENT 'Date when the quality target expires or is superseded.',
    `field_performance_target` DECIMAL(18,2) COMMENT 'Field service performance target value',
    `measurement_period_end` DATE COMMENT 'Last day of the period over which the target is measured.',
    `measurement_period_start` DATE COMMENT 'First day of the period over which the target is measured.',
    `measurement_unit` STRING COMMENT 'Unit of measure for the target (e.g., PPM, Percent, Rating).',
    `target_name` STRING COMMENT 'Human‑readable name describing the quality objective.',
    `notes` STRING COMMENT 'Free‑form comments, rationale, or special conditions for the target.',
    `ssot_governance_note` STRING COMMENT '',
    `stretch_target_value` DECIMAL(18,2) COMMENT 'Optional higher‑performance goal beyond the primary target.',
    `target_status` STRING COMMENT 'Current state of the quality target.. Valid values are `planned|active|completed|closed|cancelled`',
    `target_type` STRING COMMENT 'Category of the quality metric the target represents.. Valid values are `ppm|ftq|warranty_rate|audit_score|ncap_rating`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the target record.',
    `value` DECIMAL(18,2) COMMENT 'Planned numeric value for the quality metric.',
    CONSTRAINT pk_target PRIMARY KEY(`target_id`)
) COMMENT 'Quality performance target master record defining the planned quality objectives for a plant, production line, supplier, or vehicle program over a defined period. Captures target type (PPM, FTQ, warranty rate per 1000 vehicles — R/1000, audit score, NCAP star rating), target value, stretch target, baseline value, measurement period, responsible owner, and alignment to corporate quality policy. Supports IATF 16949 quality objectives management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` (
    `defect_code_assignment_id` BIGINT COMMENT 'Primary key for the defect_code_assignment association',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to the defect code',
    `field_quality_investigation_id` BIGINT COMMENT 'FK to field quality investigation that assigned this defect code',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to the SKU master',
    `defect_category` STRING COMMENT 'Category of the defect specific to this SKU assignment',
    `defect_description` STRING COMMENT 'Free‑form description of how the defect manifests on the SKU',
    `ppm_rate` DECIMAL(18,2) COMMENT 'Parts per million failure rate for this defect on the SKU',
    `quantity_affected` BIGINT COMMENT 'Number of units of the SKU affected by the defect',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_defect_code_assignment PRIMARY KEY(`defect_code_assignment_id`)
) COMMENT 'Association product that records the relationship between defect codes and SKUs, capturing impact metrics for each pairing.. Existence Justification: Engineers assign defect codes to individual SKUs to capture which parts are impacted by a given quality issue. A single defect code can affect many SKUs, and a single SKU can be linked to multiple defect codes, each with its own impact metrics. The assignment is actively managed and stores attributes such as quantity affected and ppm rate.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`characteristic` (
    `characteristic_id` BIGINT COMMENT 'Primary key for characteristic',
    `parent_characteristic_id` BIGINT COMMENT 'Self-referencing FK on characteristic (parent_characteristic_id)',
    `characteristic_category` STRING COMMENT 'Broad classification of the characteristic within quality domains.',
    `created_by_user` STRING COMMENT 'User identifier who initially created the characteristic record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the characteristic record was first created.',
    `criticality_level` STRING COMMENT 'Business impact rating of the characteristic on product quality.',
    `data_type` STRING COMMENT 'Data type of the characteristics measured value.',
    `characteristic_description` STRING COMMENT 'Detailed description of what the characteristic measures or represents.',
    `effective_from` DATE COMMENT 'Date when the characteristic becomes valid for use.',
    `effective_until` DATE COMMENT 'Date when the characteristic is retired or superseded (nullable).',
    `field_measurable_flag` BOOLEAN COMMENT 'Whether this characteristic can be measured in field conditions',
    `frequency` STRING COMMENT 'How often the characteristic is measured or evaluated.',
    `measurement_method` STRING COMMENT 'Technique used to capture the characteristic value.',
    `measurement_unit` STRING COMMENT 'Unit of measure associated with the characteristic (e.g., mm, kg, sec).',
    `characteristic_name` STRING COMMENT 'Human‑readable name of the quality characteristic.',
    `notes` STRING COMMENT 'Free‑form comments or observations about the characteristic.',
    `related_standard` STRING COMMENT 'Applicable quality or regulatory standard linked to the characteristic.',
    `ssot_governance_note` STRING COMMENT '',
    `characteristic_status` STRING COMMENT 'Current lifecycle status of the characteristic.',
    `target_value` DECIMAL(18,2) COMMENT 'Target or nominal value that the characteristic should achieve.',
    `tolerance_lower` DECIMAL(18,2) COMMENT 'Maximum acceptable deviation below the target value.',
    `tolerance_upper` DECIMAL(18,2) COMMENT 'Maximum acceptable deviation above the target value.',
    `updated_by_user` STRING COMMENT 'User identifier who last modified the characteristic record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the characteristic record.',
    CONSTRAINT pk_characteristic PRIMARY KEY(`characteristic_id`)
) COMMENT 'Master reference table for characteristic. Referenced by characteristic_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` (
    `root_cause_analysis_id` BIGINT COMMENT 'Primary key for root_cause_analysis',
    `defect_record_id` BIGINT COMMENT 'add column defect_record_id (BIGINT) with FK to quality.defect_record.defect_record_id - root cause analysis is performed on specific defects',
    `field_failure_analysis_id` BIGINT COMMENT 'FK to field failure analysis feeding this RCA',
    `parent_root_cause_analysis_id` BIGINT COMMENT 'Self-referencing FK on root_cause_analysis (related_root_cause_analysis_id)',
    `root_related_rca_root_cause_analysis_id` BIGINT COMMENT 'FK to a related root cause analysis record',
    `actual_resolution_date` DATE COMMENT 'Date on which the corrective action was actually completed.',
    `root_cause_analysis_category` STRING COMMENT 'High‑level classification of the root cause source.',
    `root_cause_analysis_code` STRING COMMENT 'Business identifier or code used to reference the root cause in reports and work orders.',
    `corrective_action_owner` STRING COMMENT 'Person or team accountable for executing the corrective action plan.',
    `corrective_action_plan` STRING COMMENT 'Planned corrective actions to eliminate or mitigate the root cause.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the root cause analysis record was first created.',
    `root_cause_analysis_description` STRING COMMENT 'Detailed narrative describing the root cause, its symptoms, and context.',
    `detection_phase` STRING COMMENT 'Process phase in which the root cause was first detected.',
    `effective_from` DATE COMMENT 'Date from which the root cause analysis definition becomes active.',
    `effective_until` DATE COMMENT 'Date after which the root cause analysis definition is retired (nullable).',
    `failure_mode` STRING COMMENT 'Specific failure mode linked to the root cause (e.g., "Crack in chassis").',
    `impact_description` STRING COMMENT 'Narrative of the business or safety impact caused by the root cause.',
    `root_cause_analysis_name` STRING COMMENT 'Human‑readable name of the root cause (e.g., "Incorrect Torque Specification").',
    `occurrence_phase` STRING COMMENT 'Process phase where the root cause actually occurred.',
    `owner` STRING COMMENT 'Name of the person or team responsible for investigating and resolving the root cause.',
    `priority` STRING COMMENT 'Business priority assigned to address the root cause.',
    `risk_rating` STRING COMMENT 'Overall risk rating associated with the root cause.',
    `severity_level` STRING COMMENT 'Numeric rating (1‑5) of the impact severity of the root cause on product quality.',
    `ssot_governance_note` STRING COMMENT '',
    `root_cause_analysis_status` STRING COMMENT 'Current lifecycle status of the root cause analysis.',
    `target_resolution_date` DATE COMMENT 'Planned date by which the corrective action should be completed.',
    `root_cause_analysis_type` STRING COMMENT 'Indicates whether the cause is systemic, occasional, or a one‑off event.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the root cause analysis record.',
    `verification_method` STRING COMMENT 'Method used to verify that the corrective action resolved the root cause.',
    `verification_result` STRING COMMENT 'Outcome of the verification activity.',
    CONSTRAINT pk_root_cause_analysis PRIMARY KEY(`root_cause_analysis_id`)
) COMMENT 'Master reference table for root_cause_analysis. Referenced by root_cause_analysis_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`field_return` (
    `field_return_id` BIGINT COMMENT 'Primary key for field_return',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer associated with the returned vehicle.',
    `field_failure_analysis_id` BIGINT COMMENT 'FK to field failure analysis for this returned part',
    `original_field_return_id` BIGINT COMMENT 'Self-referencing FK on field_return (original_field_return_id)',
    `party_id` BIGINT COMMENT 'Identifier of the end‑customer who owned the vehicle at the time of return.',
    `service_center_id` BIGINT COMMENT 'Identifier of the service center that received the returned vehicle.',
    `additional_notes` STRING COMMENT 'Free‑form field for any extra information related to the field return.',
    `corrective_action` STRING COMMENT 'Planned or executed corrective action to address the defect.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the monetary amounts.',
    `defect_code` STRING COMMENT 'Standardized code identifying the defect or failure observed.',
    `defect_description` STRING COMMENT 'Narrative description of the defect associated with the return.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total monetary amount associated with the return before deductions.',
    `labor_hours` DECIMAL(18,2) COMMENT 'Total labor hours spent on repairing the returned item.',
    `labor_rate` DECIMAL(18,2) COMMENT 'Hourly labor rate applied to the repair work (in the currency of net_amount).',
    `mileage_at_return` STRING COMMENT 'Odometer reading (in miles) at the time the vehicle was returned.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final monetary amount after tax and any adjustments.',
    `parts_replaced_count` STRING COMMENT 'Number of parts replaced during the repair of the returned item.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when this field return record was first created in the data lake.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to this field return record.',
    `repair_completion_date` DATE COMMENT 'Date when repair work on the returned item was completed.',
    `repair_status` STRING COMMENT 'Current status of any repair work performed on the returned item.',
    `return_number` STRING COMMENT 'Business identifier assigned to the field return, used for tracking and communication.',
    `return_reason` STRING COMMENT 'Free‑text description of why the vehicle or component was returned from the field.',
    `return_timestamp` TIMESTAMP COMMENT 'Date and time when the field return was officially recorded.',
    `return_type` STRING COMMENT 'Classification of the return reason such as warranty, recall, or customer complaint.',
    `root_cause` STRING COMMENT 'Root cause analysis result for the defect leading to the return.',
    `ssot_governance_note` STRING COMMENT '',
    `field_return_status` STRING COMMENT 'Current lifecycle status of the field return.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component applied to the gross amount.',
    `vehicle_vin` STRING COMMENT 'Unique 17‑character identifier of the vehicle being returned.',
    `warranty_claim_number` STRING COMMENT 'Reference number of the warranty claim linked to this return, if applicable.',
    CONSTRAINT pk_field_return PRIMARY KEY(`field_return_id`)
) COMMENT 'Master reference table for field_return. Referenced by field_return_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`quality_gate` (
    `quality_gate_id` BIGINT COMMENT 'System-generated unique identifier for the quality gate record.',
    `control_plan_id` BIGINT COMMENT 'Link to the control plan that governs this quality gate.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Quality Gate Cost Allocation report tracks gate execution costs per cost center for budgeting.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: GATE OPERATION: Each quality gate station relies on specific equipment; linking supports equipment downtime and audit records.',
    `fmea_id` BIGINT COMMENT 'Link to the Failure Mode and Effects Analysis that this gate supports.',
    `inspection_plan_id` BIGINT COMMENT 'Link to the inspection plan that defines the detailed checks for this gate.',
    `quality_gate_fmea_id` BIGINT COMMENT 'Link to the Failure Mode and Effects Analysis that this gate supports.',
    `quality_gate_inspection_plan_id` BIGINT COMMENT 'Link to the inspection plan that defines the detailed checks for this gate.',
    `approval_date` DATE COMMENT 'Date when the gate definition was approved.',
    `approved_by` STRING COMMENT 'User identifier who approved the gate definition.',
    `audit_status` STRING COMMENT 'Current status of the gates compliance audit.. Valid values are `pending|approved|rejected`',
    `change_control_number` STRING COMMENT 'Reference to the change control record governing this gate revision.',
    `compliance_standard` STRING COMMENT 'Regulatory or quality standard that this gate satisfies.. Valid values are `IATF16949|ISO9001|ISO14001`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the gate record was first created in the system.',
    `data_source_system` STRING COMMENT 'Originating ERP/MES system that supplied the gate data (e.g., SAP QM, Apriso).',
    `effective_end_date` DATE COMMENT 'Date after which the gate definition is retired (null if indefinite).',
    `effective_start_date` DATE COMMENT 'Date from which the gate definition becomes active.',
    `equipment_required` STRING COMMENT 'Specific tools or fixtures needed to execute the gate.',
    `escalation_rule` STRING COMMENT 'Procedure and responsible function if the gate fails.',
    `field_readiness_check_flag` BOOLEAN COMMENT 'Whether field readiness is checked at this quality gate',
    `gate_code` STRING COMMENT 'Unique alphanumeric code assigned to the gate for reference in MES and PLM systems.',
    `gate_name` STRING COMMENT 'Human‑readable name of the quality gate used in reports and UI.',
    `gate_status` STRING COMMENT 'Current operational status of the gate definition.. Valid values are `active|inactive|retired|draft`',
    `gate_type` STRING COMMENT 'Category of the gate indicating the kind of check performed (e.g., dimensional, functional, torque, water, roll, end‑of‑line).. Valid values are `dimensional|functional|torque|water|roll|eol`',
    `inspection_method` STRING COMMENT 'Method used to perform the gate check.. Valid values are `manual|automated|sensor`',
    `is_critical` BOOLEAN COMMENT 'Indicates whether failure at this gate triggers a production stop.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the gate is compulsory for the associated production process.',
    `last_review_date` DATE COMMENT 'Date of the most recent review of the gate definition.',
    `lifecycle_status` STRING COMMENT 'Lifecycle stage of the gate (e.g., planned, in‑progress, completed, closed).. Valid values are `planned|in_progress|completed|closed`',
    `line` STRING COMMENT 'Identifier of the production line within the plant.',
    `location` STRING COMMENT 'Free‑form description of the physical location (plant, line, station) where the gate is applied.',
    `lower_spec_limit` DECIMAL(18,2) COMMENT 'Minimum acceptable value for the measured characteristic.',
    `measurement_unit` STRING COMMENT 'Unit of measure used for quantitative criteria (e.g., mm, N·m, psi).',
    `notes` STRING COMMENT 'Free‑form comments or observations about the gate.',
    `operator_role` STRING COMMENT 'Job role or qualification required for the operator performing the gate.',
    `pass_fail_criteria` STRING COMMENT 'Definition of the acceptance limits that determine pass or fail outcomes.',
    `plant` STRING COMMENT 'Identifier of the manufacturing plant (e.g., Plant A, Plant B).',
    `priority` STRING COMMENT 'Numeric priority used for scheduling and escalation (higher = more critical).',
    `required_checks` STRING COMMENT 'Narrative of the mandatory inspections or measurements that must be completed at this gate.',
    `review_cycle_days` STRING COMMENT 'Number of days between mandatory reviews of the gate.',
    `revision_number` STRING COMMENT 'Sequential revision count for the gate record.',
    `shift` STRING COMMENT 'Work shift during which the gate is scheduled.. Valid values are `day|night|swing`',
    `ssot_governance_note` STRING COMMENT '',
    `station` STRING COMMENT 'Specific workstation or station where the gate is executed.',
    `target_value` DECIMAL(18,2) COMMENT 'Target numeric value that the gate measurement should achieve.',
    `tolerance` DECIMAL(18,2) COMMENT 'Allowed deviation from the target value (e.g., ±0.5%).',
    `updated_by` STRING COMMENT 'User identifier who last modified the gate record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the gate record.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable value for the measured characteristic.',
    `version_number` STRING COMMENT 'Version identifier for change management of the gate definition.',
    `created_by` STRING COMMENT 'User identifier who initially created the gate record.',
    CONSTRAINT pk_quality_gate PRIMARY KEY(`quality_gate_id`)
) COMMENT 'In-process quality gate master record defining the mandatory quality checkpoints within the vehicle assembly or manufacturing process. Captures gate name, gate type (dimensional check, functional test, torque audit, water test, roll test, end-of-line EOL test), location (plant, line, station), required checks, pass/fail criteria, and escalation rules. Linked to control plans and MES work order routing.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `vibe_automotive_v1`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_control_associated_pfmea_fmea_id` FOREIGN KEY (`control_associated_pfmea_fmea_id`) REFERENCES `vibe_automotive_v1`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `vibe_automotive_v1`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_gauge_master_id` FOREIGN KEY (`gauge_master_id`) REFERENCES `vibe_automotive_v1`.`quality`.`gauge_master`(`gauge_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_primary_gauge_master_id` FOREIGN KEY (`primary_gauge_master_id`) REFERENCES `vibe_automotive_v1`.`quality`.`gauge_master`(`gauge_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_apqp_plan_id` FOREIGN KEY (`apqp_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`apqp_plan`(`apqp_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_quality_corrective_action_id` FOREIGN KEY (`quality_corrective_action_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_corrective_action`(`quality_corrective_action_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_spc_chart_id` FOREIGN KEY (`spc_chart_id`) REFERENCES `vibe_automotive_v1`.`quality`.`spc_chart`(`spc_chart_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ADD CONSTRAINT `fk_quality_quality_ppap_submission_apqp_plan_id` FOREIGN KEY (`apqp_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`apqp_plan`(`apqp_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` ADD CONSTRAINT `fk_quality_quality_corrective_action_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_standard_id` FOREIGN KEY (`standard_id`) REFERENCES `vibe_automotive_v1`.`quality`.`standard`(`standard_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ADD CONSTRAINT `fk_quality_quality_pdi_inspection_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `vibe_automotive_v1`.`quality`.`audit`(`audit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ADD CONSTRAINT `fk_quality_ncap_test_result_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `vibe_automotive_v1`.`quality`.`audit`(`audit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ADD CONSTRAINT `fk_quality_wltp_test_result_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `vibe_automotive_v1`.`quality`.`audit`(`audit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ADD CONSTRAINT `fk_quality_gauge_msa_gauge_master_id` FOREIGN KEY (`gauge_master_id`) REFERENCES `vibe_automotive_v1`.`quality`.`gauge_master`(`gauge_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ADD CONSTRAINT `fk_quality_ppm_record_quality_gate_id` FOREIGN KEY (`quality_gate_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_gate`(`quality_gate_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ADD CONSTRAINT `fk_quality_gate_result_quality_gate_id` FOREIGN KEY (`quality_gate_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_gate`(`quality_gate_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_field_return_id` FOREIGN KEY (`field_return_id`) REFERENCES `vibe_automotive_v1`.`quality`.`field_return`(`field_return_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_quality_corrective_action_id` FOREIGN KEY (`quality_corrective_action_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_corrective_action`(`quality_corrective_action_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_root_cause_analysis_id` FOREIGN KEY (`root_cause_analysis_id`) REFERENCES `vibe_automotive_v1`.`quality`.`root_cause_analysis`(`root_cause_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ADD CONSTRAINT `fk_quality_calibration_event_gauge_master_id` FOREIGN KEY (`gauge_master_id`) REFERENCES `vibe_automotive_v1`.`quality`.`gauge_master`(`gauge_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ADD CONSTRAINT `fk_quality_calibration_event_primary_gauge_master_id` FOREIGN KEY (`primary_gauge_master_id`) REFERENCES `vibe_automotive_v1`.`quality`.`gauge_master`(`gauge_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ADD CONSTRAINT `fk_quality_defect_code_assignment_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_parent_characteristic_id` FOREIGN KEY (`parent_characteristic_id`) REFERENCES `vibe_automotive_v1`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ADD CONSTRAINT `fk_quality_root_cause_analysis_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ADD CONSTRAINT `fk_quality_root_cause_analysis_parent_root_cause_analysis_id` FOREIGN KEY (`parent_root_cause_analysis_id`) REFERENCES `vibe_automotive_v1`.`quality`.`root_cause_analysis`(`root_cause_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ADD CONSTRAINT `fk_quality_root_cause_analysis_root_related_rca_root_cause_analysis_id` FOREIGN KEY (`root_related_rca_root_cause_analysis_id`) REFERENCES `vibe_automotive_v1`.`quality`.`root_cause_analysis`(`root_cause_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_original_field_return_id` FOREIGN KEY (`original_field_return_id`) REFERENCES `vibe_automotive_v1`.`quality`.`field_return`(`field_return_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ADD CONSTRAINT `fk_quality_quality_gate_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ADD CONSTRAINT `fk_quality_quality_gate_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `vibe_automotive_v1`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ADD CONSTRAINT `fk_quality_quality_gate_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ADD CONSTRAINT `fk_quality_quality_gate_quality_gate_fmea_id` FOREIGN KEY (`quality_gate_fmea_id`) REFERENCES `vibe_automotive_v1`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ADD CONSTRAINT `fk_quality_quality_gate_quality_gate_inspection_plan_id` FOREIGN KEY (`quality_gate_inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`quality` SET TAGS ('dbx_pii_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`quality` SET TAGS ('dbx_pii_domain' = 'quality');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `apqp_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'APQP Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `actual_ppm` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual PPM');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `actual_release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Release Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'APQP Phase');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_pii_value_regex' = 'concept|design|process|validation|launch');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `classification_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Classification Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `classification_type` SET TAGS ('dbx_pii_value_regex' = 'new_model|refresh|component|system');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `documentation_link` SET TAGS ('dbx_pii_business_glossary_term' = 'Documentation Link');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `gate_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Completion Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `gate_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `gate_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `gate_status` SET TAGS ('dbx_pii_value_regex' = 'open|closed|delayed|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'draft|active|suspended|completed|archived');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `milestone_gate` SET TAGS ('dbx_pii_business_glossary_term' = 'Milestone Gate');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `milestone_gate` SET TAGS ('dbx_pii_value_regex' = 'gate1|gate2|gate3|gate4|gate5');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `mitigation_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Mitigation Plan');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `owner_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Owner Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `owner_name` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_pii_business_glossary_term' = 'APQP Plan Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `quality_goal_ppm` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Goal (PPM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `responsible_team` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Team');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `risk_assessment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Assessment Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `target_ppm` SET TAGS ('dbx_pii_business_glossary_term' = 'Target PPM');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `target_release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Release Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `fmea_id` SET TAGS ('dbx_pii_business_glossary_term' = 'FMEA ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Action Owner Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `engineering_bom_component_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Component ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `analysis_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Analysis Number (AN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `analysis_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Analysis Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `analysis_type` SET TAGS ('dbx_pii_value_regex' = 'design|process');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `cause` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `control_effectiveness_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Effectiveness Rating');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `current_control` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `detection_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `detection_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `detection_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Rating (D)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `failure_effect` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Effect');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `failure_mode` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Mode');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `fmea_status` SET TAGS ('dbx_pii_business_glossary_term' = 'FMEA Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `fmea_status` SET TAGS ('dbx_pii_value_regex' = 'open|closed|in_progress|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `occurrence_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Occurrence Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `occurrence_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Occurrence Rating (O)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `recommended_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Recommended Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `rpn` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Priority Number (RPN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `severity_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Severity Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `severity_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Severity Rating (S)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `subsystem` SET TAGS ('dbx_pii_business_glossary_term' = 'Subsystem');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `target_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Completion Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `fmea_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated PFMEA ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_associated_pfmea_fmea_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated PFMEA ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Inspection Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected|revoked');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `change_control_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Control Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_method` SET TAGS ('dbx_pii_value_regex' = 'spc|attribute|visual|functional|dimensional');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_pii_value_regex' = 'draft|active|suspended|retired|archived');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_pii_value_regex' = 'assembly|paint|engine|chassis|electrical|final');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `reaction_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Reaction Plan');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `responsible_function` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Function');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `responsible_function` SET TAGS ('dbx_pii_value_regex' = 'assembly_line|quality_engineering|process_engineering|manufacturing|test_lab');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `revision_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `sample_frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Sample Frequency');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `sample_frequency` SET TAGS ('dbx_pii_value_regex' = 'per_shift|per_batch|per_hour|per_day');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_pii_business_glossary_term' = 'Sample Size');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `target_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `acceptance_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Acceptance Criteria Description (ACC_CRIT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `applicable_process` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Process for Inspection (PROCESS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `applicable_process` SET TAGS ('dbx_pii_value_regex' = 'IQC|IPQC|PDI|Final');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date (APPROVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By User Identifier (APPROVED_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `associated_quality_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Quality System (QUAL_SYS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `associated_quality_system` SET TAGS ('dbx_pii_value_regex' = 'APQP|FMEA|SPC|PPAP|None');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `criticality_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Criticality Level (CRIT_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `criticality_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `department_responsible` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Department (DEPT_RESP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Description (DESC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date (EFFECTIVE_UNTIL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date (EFFECTIVE_FROM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Frequency (FREQ)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `frequency` SET TAGS ('dbx_pii_value_regex' = 'per_batch|per_shift|per_vehicle|per_day');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `gauge_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Type (GAUGE_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `gauge_type` SET TAGS ('dbx_pii_value_regex' = 'dial|digital|laser|micrometer');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Category (INS_CAT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_category` SET TAGS ('dbx_pii_value_regex' = 'dimensional|functional|visual|electrical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_status` SET TAGS ('dbx_pii_value_regex' = 'draft|active|inactive|retired');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `is_automated` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Inspection Automated (IS_AUTOMATED)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date (LAST_REVIEW_DATE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Method (MEAS_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_value_regex' = 'CMM|Gauge|Visual|Automated|Manual');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit (MEAS_UNIT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_value_regex' = 'mm|cm|inch|mm^2|psi');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number (PART_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Name (PLAN_NAME)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Number (PLAN_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Type (TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_pii_value_regex' = 'incoming_material|in_process|final_vehicle|custom');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plant_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Location Code (PLANT_LOC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Indicator (REG_COMP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_pii_value_regex' = 'IATF16949|ISO9001|EPA|NHTSA|None');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `requires_approval` SET TAGS ('dbx_pii_business_glossary_term' = 'Requires Approval Flag (REQ_APPROVAL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `review_cycle_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Cycle in Days (REVIEW_CYCLE_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number (REV_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_pii_business_glossary_term' = 'Sample Size (SAMPLE_SZ)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `tolerance_lower` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Tolerance Limit (TOL_LOWER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `tolerance_upper` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Tolerance Limit (TOL_UPPER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Identifier (UPDATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model (MODEL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Version (VER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User Identifier (CREATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspector Identifier (EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspector Identifier (EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `shipment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `decision` SET TAGS ('dbx_pii_business_glossary_term' = 'Overall Inspection Decision');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `decision` SET TAGS ('dbx_pii_value_regex' = 'accept|reject|conditional_release');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `defect_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code (Quality Defect Identifier)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `defect_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Lot Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_status` SET TAGS ('dbx_pii_value_regex' = 'open|in_progress|closed|rejected|released');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_method` SET TAGS ('dbx_pii_value_regex' = 'visual|dimensional|functional|non_destructive|automated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Reason Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_closure_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Closure Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Lot Number (LOT_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_origin` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Origin Source');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_origin` SET TAGS ('dbx_pii_value_regex' = 'goods_receipt|production_order|delivery|return');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Lot Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_type` SET TAGS ('dbx_pii_value_regex' = 'incoming_material|wip_assembly|finished_vehicle|prototype');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_result_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Result Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_result_status` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|out_of_spec');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `quantity_accepted` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Accepted');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `quantity_inspected` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Inspected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `quantity_rejected` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `remarks` SET TAGS ('dbx_pii_business_glossary_term' = 'Remarks / Comments');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `source_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Document Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `work_center` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_result_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Result ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Characteristic ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `gauge_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Instrument ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspector ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `primary_gauge_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Instrument ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `cp_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Capability (Cp)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `cpk_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Capability Index (Cpk)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `deviation_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Deviation Amount');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `line_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Sequence');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_accuracy` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Accuracy');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_condition` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Condition');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_condition` SET TAGS ('dbx_pii_value_regex' = 'normal|high_temp|low_temp|vibration');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_humidity_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Humidity (%)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Location');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_value_regex' = 'manual|automated|sensor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_resolution` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Source');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_source` SET TAGS ('dbx_pii_value_regex' = 'internal|external');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_tool` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Tool');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_uncertainty` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Uncertainty');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_value_regex' = 'mm|cm|in|mmHg|psi|kg');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measured Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|archived');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `result_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Result Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `result_status` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|na');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `apqp_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `recall_defect_report_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Defect Report Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reported By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `shipment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Identifier (COMPONENT_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `telemetry_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Telemetry Event Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `containment_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Containment Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `corrective_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Category (CATEGORY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_value_regex' = 'incoming|in_process|final|field');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code (DEFECT_CODE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_record_status` SET TAGS ('dbx_pii_value_regex' = 'open|investigating|closed|rejected|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Type (DEFECT_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_type` SET TAGS ('dbx_pii_value_regex' = 'material|process|design|supplier|assembly|software');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `detected_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Detection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `detection_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Method (DETECTION_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `detection_method` SET TAGS ('dbx_pii_value_regex' = 'inspection|test|audit|customer_complaint|sensor|automated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `disposition` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Disposition (DISPOSITION)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `disposition` SET TAGS ('dbx_pii_value_regex' = 'rework|scrap|use_as_is|return_to_supplier|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `investigation_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Investigation End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `investigation_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Investigation Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `is_repeat_defect` SET TAGS ('dbx_pii_business_glossary_term' = 'Repeat Defect Indicator');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `location_zone` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Zone');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `ppm_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Parts Per Million Rate (PPM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `quantity_affected` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Affected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `root_cause` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `severity` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Severity (SEVERITY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `severity` SET TAGS ('dbx_pii_value_regex' = 'critical|major|minor|warning|info');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `spc_chart_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Process Control Chart ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `center_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Center Line');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `chart_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Process Control Chart Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `chart_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Process Control Chart Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `chart_type` SET TAGS ('dbx_pii_value_regex' = 'X-bar/R|X-bar/S|p-chart|c-chart|u-chart|np-chart');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `confidence_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Confidence Level (%)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `control_limit_lcl` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Control Limit (LCL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `control_limit_ucl` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `ctq_characteristic` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical‑to‑Quality Characteristic');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System for SPC Data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_value_regex' = 'SAP QM|MES|Teamcenter|Custom');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `spc_chart_description` SET TAGS ('dbx_pii_business_glossary_term' = 'SPC Chart Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `ocap` SET TAGS ('dbx_pii_business_glossary_term' = 'Out‑of‑Control Action Plan');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `process_step` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Process Step');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `process_step_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Step Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `sample_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Sample Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `sampling_frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Sampling Frequency');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `sampling_frequency` SET TAGS ('dbx_pii_value_regex' = 'per_shift|per_hour|per_day|per_batch|per_lot');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `spc_chart_status` SET TAGS ('dbx_pii_business_glossary_term' = 'SPC Chart Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `spc_chart_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|deprecated|pending');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `statistical_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `statistical_method` SET TAGS ('dbx_pii_value_regex' = 'Shewhart|EWMA|CUSUM|XMR');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `subgroup_size` SET TAGS ('dbx_pii_business_glossary_term' = 'Subgroup Size');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `target_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `tolerance_lower` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Tolerance Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `tolerance_upper` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Tolerance Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SPC Chart Version Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `spc_data_point_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Statistical Process Control Data Point ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Machine ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Location ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `quality_corrective_action_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `spc_chart_id` SET TAGS ('dbx_pii_business_glossary_term' = 'SPC Chart ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `spc_operator_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `spc_operator_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `spc_operator_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `work_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `calibration_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `cp_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Capability (Cp)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `cpk_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Capability Index (Cpk)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Quality Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `defect_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `lower_control_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Control Limit (LCL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `lower_warning_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Warning Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_value_regex' = 'automated|manual');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Sequence');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_type` SET TAGS ('dbx_pii_value_regex' = 'dimension|pressure|temperature|speed|voltage');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_value_regex' = 'mm|cm|mmhg|psi|°c|%');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `measurement_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `out_of_control_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Out‑of‑Control Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `pp_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Performance Potential (Pp)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `ppk_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Performance Potential Index (Ppk)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `process_step` SET TAGS ('dbx_pii_business_glossary_term' = 'Process Step');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `process_step` SET TAGS ('dbx_pii_value_regex' = 'welding|painting|assembly|inspection|testing');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `sample_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Sample Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `sample_size` SET TAGS ('dbx_pii_business_glossary_term' = 'Sample Size');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `sensor_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `sensor_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `sensor_type` SET TAGS ('dbx_pii_value_regex' = 'laser|ultrasonic|thermocouple|vision');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `shift` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `shift` SET TAGS ('dbx_pii_value_regex' = 'day|swing|graveyard');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `spc_data_point_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `spc_data_point_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|archived');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `subgroup_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Subgroup Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `upper_control_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `upper_warning_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Warning Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `western_electric_rule_violation` SET TAGS ('dbx_pii_business_glossary_term' = 'Western Electric Rule Violation');
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ALTER COLUMN `western_electric_rule_violation` SET TAGS ('dbx_pii_value_regex' = 'none|rule1|rule2|rule3|rule4');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `quality_ppap_submission_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for quality_ppap_submission');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `apqp_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Apqp Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `supply_ppap_submission_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supply Ppap Submission Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` ALTER COLUMN `quality_corrective_action_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for quality_corrective_action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Audit ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Auditor ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Auditor ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Auditee Location ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `standard_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_pii_value_regex' = '^AUD-d{6}$');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_value_regex' = 'planned|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_pii_value_regex' = 'system|process|product|layered_process');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditee_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Auditee Location');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Auditor Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `closure_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Closure Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Closure Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_pii_value_regex' = 'open|closed|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `compliance_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Reference');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Required');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_status` SET TAGS ('dbx_pii_value_regex' = 'not_started|in_progress|completed');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `documents_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Documents Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_major` SET TAGS ('dbx_pii_business_glossary_term' = 'Major Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_minor` SET TAGS ('dbx_pii_business_glossary_term' = 'Minor Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_severe` SET TAGS ('dbx_pii_business_glossary_term' = 'Severe Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_total` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `method` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `method` SET TAGS ('dbx_pii_value_regex' = 'internal|external|third_party');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `non_conformance_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Non‑Conformance Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `non_conformance_severity` SET TAGS ('dbx_pii_business_glossary_term' = 'Non‑Conformance Severity');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `non_conformance_severity` SET TAGS ('dbx_pii_value_regex' = 'critical|major|minor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `overall_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Overall Audit Score');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'IATF|ISO9001|ISO14001|NHTSA|EPA');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `scope` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Scope');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `score_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Score Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `score_category` SET TAGS ('dbx_pii_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_audit_finding` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_audit_finding` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_audit_finding` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_audit_finding` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ALTER COLUMN `quality_pdi_inspection_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for quality_pdi_inspection');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ALTER COLUMN `audit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Audit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ALTER COLUMN `logistics_pdi_inspection_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Logistics Pdi Inspection Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `ncap_test_result_id` SET TAGS ('dbx_pii_business_glossary_term' = 'NCAP Test Result ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `audit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Audit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `change_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change ID (ECID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `ncap_submission_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Ncap Submission Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `primary_vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Operator Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status (CS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|under_review');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Source System (DSS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_value_regex' = 'SAP|Teamcenter|MES|Custom');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Status (HS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|pending|exempt');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `rating_scale` SET TAGS ('dbx_pii_business_glossary_term' = 'Rating Scale (RS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `raw_score_front` SET TAGS ('dbx_pii_business_glossary_term' = 'Front Impact Raw Score (FIRS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `raw_score_pole` SET TAGS ('dbx_pii_business_glossary_term' = 'Pole Impact Raw Score (PIRS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `raw_score_side` SET TAGS ('dbx_pii_business_glossary_term' = 'Side Impact Raw Score (SIRS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `star_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Star Rating (SR)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Comments (TCMT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_condition` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Condition (TCND)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_configuration` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Configuration (TC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Date (TD)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_facility` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Facility (TF)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_observer` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Observer (TOB)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_program` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Program (TP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_program` SET TAGS ('dbx_pii_value_regex' = 'Euro NCAP|NHTSA|ANCAP|Global NCAP');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_report_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Report Number (TRN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_result_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result Status (TRS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_result_status` SET TAGS ('dbx_pii_value_regex' = 'draft|final|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Type (TT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_value_regex' = 'frontal_offset|side_impact|pole|pedestrian|aeb');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `test_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Version (TV)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Variant (VV)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `wltp_test_result_id` SET TAGS ('dbx_pii_business_glossary_term' = 'WLTP Test Result Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `audit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Audit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Operator Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `ambient_humidity_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Ambient Humidity (%)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `ambient_pressure_kpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Ambient Pressure (kPa)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `ambient_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Ambient Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `electric_range_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Electric Range (km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `extra_high_speed_co2_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Extra‑High Speed Phase CO2 Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `extra_high_speed_fuel_l_per_100km` SET TAGS ('dbx_pii_business_glossary_term' = 'Extra‑High Speed Phase Fuel Consumption (L/100km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `high_speed_co2_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'High Speed Phase CO2 Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `high_speed_fuel_l_per_100km` SET TAGS ('dbx_pii_business_glossary_term' = 'High Speed Phase Fuel Consumption (L/100km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `homologation_certificate_issue_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Certificate Issue Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `homologation_certificate_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Certificate Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `low_speed_co2_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Low Speed Phase CO2 Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `low_speed_fuel_l_per_100km` SET TAGS ('dbx_pii_business_glossary_term' = 'Low Speed Phase Fuel Consumption (L/100km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `medium_speed_co2_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Medium Speed Phase CO2 Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `medium_speed_fuel_l_per_100km` SET TAGS ('dbx_pii_business_glossary_term' = 'Medium Speed Phase Fuel Consumption (L/100km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `nox_mg_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'NOx Emissions (mg/km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `particulate_mg_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Particulate Matter Emissions (mg/km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `powertrain_variant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Variant Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_facility` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Facility Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_methodology` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Methodology');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_methodology` SET TAGS ('dbx_pii_value_regex' = 'lab|in_vehicle');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_result_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Result Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_result_status` SET TAGS ('dbx_pii_value_regex' = 'completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_standard_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Standard Version');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `test_type` SET TAGS ('dbx_pii_value_regex' = 'WLTP|RDE|ECE');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `total_co2_g_per_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Total CO2 Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `total_fuel_l_per_100km` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Fuel Consumption (L/100km)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `gauge_msa_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Measurement System Analysis ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `gauge_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `acceptability_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Acceptability Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `acceptability_status` SET TAGS ('dbx_pii_value_regex' = 'acceptable|marginal|unacceptable');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `calibration_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `gauge_msa_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `gauge_msa_status` SET TAGS ('dbx_pii_value_regex' = 'active|retired|archived');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `gauge_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `gauge_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `gauge_type` SET TAGS ('dbx_pii_value_regex' = 'dimensional|functional|visual|electrical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `grr_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Repeatability and Reproducibility Percentage');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `measurement_range_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Maximum');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `measurement_range_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Minimum');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `ndc` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Distinct Categories');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `operator_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Operators');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `part_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Parts');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `study_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Study Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `study_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Study Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `study_type` SET TAGS ('dbx_pii_value_regex' = 'Gauge_RR|Linearity|Bias|Stability');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `trial_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Trials');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_msa` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `gauge_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Master Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Custodian Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `accuracy` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Accuracy');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `asset_tag` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `calibration_certificate_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Certificate Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `calibration_due_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Due Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `calibration_history_available` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration History Available');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Interval (Days)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `calibration_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_value_regex' = 'calibrated|due|overdue|out_of_service');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_value_regex' = 'IATF16949|ISO9001|ISO14001');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `gauge_master_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `gauge_master_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Operational Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `gauge_master_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|retired|maintenance');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `gauge_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `gauge_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `gauge_type` SET TAGS ('dbx_pii_value_regex' = 'cmm|caliper|torque_wrench|vision_system|laser_tracker');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `inspection_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Capability');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `inspection_capability` SET TAGS ('dbx_pii_value_regex' = 'dimensional|torque|visual|electrical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `is_critical_gauge` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Gauge Indicator');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `last_calibrated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Calibrated By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `line` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `location` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Location');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `manufacturer` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Manufacturer');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `measurement_range_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Maximum');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `measurement_range_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Minimum');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `model_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Model Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `next_calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `plant` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `purchase_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Purchase Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Serial Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `station` SET TAGS ('dbx_pii_business_glossary_term' = 'Station Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `tolerance` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Tolerance');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'mm|in|psi|nm');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `ppm_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parts Per Million Record ID (PPM_RECORD_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `quality_gate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Identifier (SUPPLIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Recorded By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date (APPROVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By (APPROVED_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number (BATCH_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Comments (COMMENTS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp (CREATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Category (DEFECT_CATEGORY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_value_regex' = 'material|process|design|assembly|other');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `defect_category_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Category Count (DEFECT_CATEGORY_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `inspection_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Type (INSPECTION_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `inspection_type` SET TAGS ('dbx_pii_value_regex' = 'incoming|in_process|final|pdi');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `is_outlier` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Outlier (IS_OUTLIER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number (LOT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `measurement_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Timestamp (MEASUREMENT_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MODEL_YEAR)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code (PLANT_CODE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `plant_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Name (PLANT_NAME)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `ppm_record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'PPM Record Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `ppm_record_status` SET TAGS ('dbx_pii_value_regex' = 'open|closed|reviewed');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `ppm_value` SET TAGS ('dbx_pii_business_glossary_term' = 'PPM Value (PPM_VALUE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `ppm_variance` SET TAGS ('dbx_pii_business_glossary_term' = 'PPM Variance (PPM_VARIANCE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `quality_gate_passed` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Passed (QUALITY_GATE_PASSED)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code (REGION_CODE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `reporting_period` SET TAGS ('dbx_pii_business_glossary_term' = 'Reporting Period (REPORTING_PERIOD)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `reporting_period` SET TAGS ('dbx_pii_value_regex' = '^d{4}-(0[1-9]|1[0-2])$|^Q[1-4]-d{4}$');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number (REVISION_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `target_ppm` SET TAGS ('dbx_pii_business_glossary_term' = 'Target PPM (TARGET_PPM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `total_defective_parts` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Defective Parts (TOTAL_DEFECTIVE_PARTS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `total_parts_received` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Parts Received (TOTAL_PARTS_RECEIVED)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `trend_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Trend Indicator (TREND_INDICATOR)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `trend_indicator` SET TAGS ('dbx_pii_value_regex' = 'improving|declining|stable');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp (UPDATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model (VEHICLE_MODEL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `gate_result_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Result Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `quality_gate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `trip_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `defect_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Defects Detected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `gate_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Location Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `gate_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Pass/Fail Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `gate_status` SET TAGS ('dbx_pii_value_regex' = 'pass|fail');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `gate_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `gate_type` SET TAGS ('dbx_pii_value_regex' = 'assembly|paint|final|engine|chassis');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `inspection_result_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Result Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Result Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `quality_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Score');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `rework_loop_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Rework Loop Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `scan_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Scan Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `shift` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Shift');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `shift` SET TAGS ('dbx_pii_value_regex' = 'day|night|swing');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `time_at_gate_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Time at Gate (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_quality_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Quality Event ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Investigation Owner ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_investigation_owner_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Investigation Owner ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_investigation_owner_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_investigation_owner_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `actual_resolution_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Resolution Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `affected_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Quantity');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `attached_documentation` SET TAGS ('dbx_pii_business_glossary_term' = 'Attached Documentation Reference');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_value_regex' = 'IATF16949|ISO9001|EPA|NHTSA');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `containment_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Containment Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `corrective_action_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Plan');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `defect_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `defect_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Quantity');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `defect_severity` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Severity');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `defect_severity` SET TAGS ('dbx_pii_value_regex' = 'critical|major|minor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `detection_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `detection_method` SET TAGS ('dbx_pii_value_regex' = 'visual|automated|test|audit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `event_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Quality Event Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `expected_resolution_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Expected Resolution Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `is_repeat_issue` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Repeat Issue');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `quality_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Management System');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `resolution_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `resolution_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `resolution_status` SET TAGS ('dbx_pii_value_regex' = 'resolved|unresolved|closed|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `risk_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `risk_rating` SET TAGS ('dbx_pii_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `root_cause_analysis` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Analysis');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `sca_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SCAR Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `sca_requested` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Corrective Action Request Issued');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_response_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Response Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_response_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Response Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_response_status` SET TAGS ('dbx_pii_value_regex' = 'pending|submitted|rejected|approved');
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `warranty_quality_signal_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Quality Signal ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `aftersales_warranty_claim_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Claim ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `case_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Complaint ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `credit_memo_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Memo Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `field_return_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Field Return ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `quality_corrective_action_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `root_cause_analysis_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Analysis ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `shipment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `tsb_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Technical Service Bulletin ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `warranty_customer_party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `warranty_dealer_dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `affected_vin_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected VIN Count (AVC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `associated_vehicle_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Vehicle Model (AVM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `associated_vehicle_variant` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Vehicle Variant (AVV)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (CC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `data_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Source (DSRC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Escalation Level (EL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_value_regex' = 'none|level1|level2|level3');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `failure_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Description (FD)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `failure_mode` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Mode (FM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `impact_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Impact Amount (IMPA)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `is_repeat_signal` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Repeat Signal (IRS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `is_systemic` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Systemic (IS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `occurrence_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Occurrence Count (OC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `part_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Name (PNAME)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `severity_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Severity Level (SL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `severity_level` SET TAGS ('dbx_pii_value_regex' = 'critical|high|medium|low|info');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `severity_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Severity Score (SSCORE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `signal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Code (SC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `signal_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Status (SS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `signal_status` SET TAGS ('dbx_pii_value_regex' = 'open|investigating|closed|escalated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `source_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Reference (SR)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `source_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Type (ST)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `source_type` SET TAGS ('dbx_pii_value_regex' = 'warranty_claim|field_return|tsb_trigger|customer_complaint');
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `standard_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Standard Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicability Scope (SCOPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_pii_value_regex' = 'global|regional|plant_specific');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `standard_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Code (CODE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status (COMP_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|partial|pending');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CRE_TSTMP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `standard_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Description (DESC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `document_format` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Format (DOC_FMT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `document_format` SET TAGS ('dbx_pii_value_regex' = 'pdf|docx|xlsx|html');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `document_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Document URL (DOC_URL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date (EFF_DT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date (EXP_DT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Mandatory (MANDATORY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `issuing_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Issuing Body (ISSUER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `language` SET TAGS ('dbx_pii_business_glossary_term' = 'Document Language (LANG)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `language` SET TAGS ('dbx_pii_value_regex' = 'en|de|fr|es|zh|ja');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'draft|active|inactive|retired|pending');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body (REG_BODY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `regulatory_section` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Section (REG_SEC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `revision_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Date (REV_DT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number (REV_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `standard_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Type (TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `standard_type` SET TAGS ('dbx_pii_value_regex' = 'quality|environment|safety|emissions|regulatory|process');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `title` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Title (TITLE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By (UPD_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (UPD_TSTMP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number (VER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By (CRE_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected System');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_system` SET TAGS ('dbx_pii_value_regex' = 'Powertrain|Chassis|Electrical|Interior|Exterior|ADAS');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_zone` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Zone');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_zone` SET TAGS ('dbx_pii_value_regex' = 'Front|Rear|Left|Right|Center|All');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `applicable_stage` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Process Stage');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `applicable_stage` SET TAGS ('dbx_pii_value_regex' = 'incoming|in_process|final|field');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_category` SET TAGS ('dbx_pii_value_regex' = 'dimensional|cosmetic|functional|safety|nvh');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Required');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `cost_impact_estimate` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Impact Estimate');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `detection_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `detection_method` SET TAGS ('dbx_pii_value_regex' = 'visual|sensor|test|audit|automated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_pii_value_regex' = 'iatf16949|iso9001|epa|nhtsa|none');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_pii_value_regex' = 'design|material|process|supplier|installation|unknown');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `severity_default` SET TAGS ('dbx_pii_business_glossary_term' = 'Default Severity');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `severity_default` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `typical_resolution_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Typical Resolution Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `warranty_implication` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Implication');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `warranty_implication` SET TAGS ('dbx_pii_value_regex' = 'none|warranty_repair|warranty_replacement|recall');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `notification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Notification ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Quality Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `shipment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `tertiary_notification_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Quality Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `tertiary_notification_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `tertiary_notification_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `actual_resolution_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `affected_material_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Material Number (MATNR)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `affected_vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `affected_vehicle_vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `attachment_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Attachment Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `corrective_action_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Plan (CAP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `creation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_value_regex' = 'cosmetic|functional|safety|performance');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `department_responsible` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Escalation Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_value_regex' = 'none|level1|level2|level3');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `is_regulatory_compliance` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `is_safety_related` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety‑Related Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `last_update_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `notification_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Notification Number (QN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `notification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Notification Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `notification_status` SET TAGS ('dbx_pii_value_regex' = 'open|in_process|resolved|closed|rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `notification_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Notification Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `notification_type` SET TAGS ('dbx_pii_value_regex' = 'complaint|defect|deviation|customer_feedback');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_contact` SET TAGS ('dbx_pii_business_glossary_term' = 'Originator Contact Email (OCE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_contact` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_contact` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Originator Name (ON)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Originator Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `originator_type` SET TAGS ('dbx_pii_value_regex' = 'internal|customer|dealer|supplier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `plant_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Location Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `ppm_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Parts Per Million Defect Rate (PPM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `problem_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Problem Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_pii_value_regex' = 'IATF|NHTSA|EPA|ISO9001|ISO14001');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `related_claim_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Claim Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `related_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Order Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `root_cause_analysis` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Analysis (RCA)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Event ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `gauge_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `primary_equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Equipment ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `primary_gauge_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `technician_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Technician ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `as_found_value` SET TAGS ('dbx_pii_business_glossary_term' = 'As-Found Measurement Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `as_left_value` SET TAGS ('dbx_pii_business_glossary_term' = 'As-Left Measurement Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_event_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Event Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_event_status` SET TAGS ('dbx_pii_value_regex' = 'scheduled|in_progress|completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_lab` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Laboratory Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_method` SET TAGS ('dbx_pii_value_regex' = 'internal|external');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Standard Reference');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_value_regex' = 'completed|pending|overdue');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `calibration_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Date and Time');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `certificate_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Certificate Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard Reference');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `event_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Event Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `gauge_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Gauge Serial Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `lab_accreditation` SET TAGS ('dbx_pii_business_glossary_term' = 'Laboratory Accreditation Body');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `location` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Location (Plant/Line)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `measurement_range_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Maximum');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `measurement_range_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Range Minimum');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `measurement_uncertainty` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Uncertainty');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `next_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `result` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Result');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `result` SET TAGS ('dbx_pii_value_regex' = 'pass|fail|adjusted');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Target Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `production_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_responsible_owner_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_responsible_owner_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_responsible_owner_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `alignment_policy` SET TAGS ('dbx_pii_business_glossary_term' = 'Alignment to Corporate Quality Policy');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `baseline_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Baseline Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Target Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `measurement_period_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Period End Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `measurement_period_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Target Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `stretch_target_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Stretch Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_status` SET TAGS ('dbx_pii_value_regex' = 'planned|active|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Target Type (PPM, FTQ, Warranty Rate, Audit Score, NCAP Rating)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `target_type` SET TAGS ('dbx_pii_value_regex' = 'ppm|ftq|warranty_rate|audit_score|ncap_rating');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ALTER COLUMN `value` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` SET TAGS ('dbx_pii_subdomain' = 'inspection_results');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` SET TAGS ('dbx_pii_association_edges' = 'quality.defect_code,inventory.sku_master');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ALTER COLUMN `defect_code_assignment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code Assignment - Defect Code Assignment Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code Assignment - Defect Code Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code Assignment - Sku Master Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ALTER COLUMN `defect_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Category (Assignment)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ALTER COLUMN `defect_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description (Assignment)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ALTER COLUMN `ppm_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'PPM Rate');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ALTER COLUMN `quantity_affected` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Affected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Characteristic Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `parent_characteristic_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Characteristic Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `parent_characteristic_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `created_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `criticality_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Criticality Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `data_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Frequency');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `measurement_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `related_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Standard');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `target_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `tolerance_lower` SET TAGS ('dbx_pii_business_glossary_term' = 'Tolerance Lower');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `tolerance_upper` SET TAGS ('dbx_pii_business_glossary_term' = 'Tolerance Upper');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause Analysis Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `parent_root_cause_analysis_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Root Cause Analysis Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `parent_root_cause_analysis_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `actual_resolution_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `corrective_action_owner` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Owner');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `corrective_action_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action Plan');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `detection_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Detection Phase');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `failure_mode` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Mode');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `impact_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Impact Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `occurrence_phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Occurrence Phase');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `owner` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `risk_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `severity_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Severity Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `verification_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Verification Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `verification_result` SET TAGS ('dbx_pii_business_glossary_term' = 'Verification Result');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` SET TAGS ('dbx_pii_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `field_return_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Field Return Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `original_field_return_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Original Field Return Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `original_field_return_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `service_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Center Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `additional_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `corrective_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Corrective Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `defect_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `defect_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `gross_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `labor_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `labor_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Labor Rate');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `mileage_at_return` SET TAGS ('dbx_pii_business_glossary_term' = 'Mileage At Return');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `parts_replaced_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Parts Replaced Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `repair_completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Repair Completion Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `repair_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Repair Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Return Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Return Reason');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Return Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Return Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `root_cause` SET TAGS ('dbx_pii_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `field_return_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Vin');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `warranty_claim_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Claim Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` SET TAGS ('dbx_pii_subdomain' = 'planning_standards');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `quality_gate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Control Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `fmea_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated FMEA Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Inspection Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `quality_gate_fmea_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated FMEA Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `quality_gate_inspection_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Inspection Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `change_control_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Control Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_pii_value_regex' = 'IATF16949|ISO9001|ISO14001');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `data_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `equipment_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Required Equipment');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `escalation_rule` SET TAGS ('dbx_pii_business_glossary_term' = 'Escalation Rule');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `gate_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `gate_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `gate_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `gate_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|retired|draft');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `gate_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Gate Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `gate_type` SET TAGS ('dbx_pii_value_regex' = 'dimensional|functional|torque|water|roll|eol');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `inspection_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `inspection_method` SET TAGS ('dbx_pii_value_regex' = 'manual|automated|sensor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Mandatory Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'planned|in_progress|completed|closed');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `line` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `location` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Location Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Lower Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `operator_role` SET TAGS ('dbx_pii_business_glossary_term' = 'Operator Role');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `pass_fail_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Pass/Fail Criteria');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `plant` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Gate Priority');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `required_checks` SET TAGS ('dbx_pii_business_glossary_term' = 'Required Checks Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `review_cycle_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Cycle (Days)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `revision_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `shift` SET TAGS ('dbx_pii_business_glossary_term' = 'Shift');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `shift` SET TAGS ('dbx_pii_value_regex' = 'day|night|swing');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `station` SET TAGS ('dbx_pii_business_glossary_term' = 'Station Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `target_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `tolerance` SET TAGS ('dbx_pii_business_glossary_term' = 'Tolerance');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Upper Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User');
