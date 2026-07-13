-- Schema for Domain: quality | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-13 17:05:58

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`quality` COMMENT 'End-to-end quality assurance and control across design, manufacturing, and field operations. Owns APQP plans, FMEA (Failure Mode and Effects Analysis), SPC (Statistical Process Control) data, inspection plans, quality audits, defect tracking, and PPM rates. Includes incoming material inspection, in-process quality gates, final vehicle PDI (Pre-Delivery Inspection), NCAP/WLTP test results, and corrective action (8D, 5-Why) processes. Supports IATF 16949 compliance.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`fmea` (
    `fmea_id` BIGINT COMMENT 'System-generated unique identifier for the FMEA record.',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: FMEA is performed based on design specs; linking provides traceability for risk analysis reports.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: DFMEA/PFMEA in APQP is scoped to a specific vehicle model. Quality engineers must link each FMEA to the vehicle model it covers for IATF 16949 compliance, quality gate reviews, and model-level failure',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: DFMEA (Design FMEA) is performed at the part/component level per APQP. Quality engineers must trace which part_master record a failure mode analysis covers. IATF 16949 requires part-level FMEA traceab',
    `platform_id` BIGINT COMMENT 'Foreign key linking to vehicle.platform. Business justification: Platform-level DFMEA is standard APQP practice — shared architecture across multiple models requires a single platform FMEA. Quality engineers scope FMEAs to vehicle platforms for cross-model failure ',
    `production_bom_id` BIGINT COMMENT 'Unique identifier of the vehicle component or part to which the FMEA applies.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: FMEAs are scoped to vehicle programs during APQP gate reviews. Program-level FMEA status reporting and launch readiness assessments require this link. Every automotive quality engineer expects FMEA to',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Process FMEA (PFMEA) in automotive APQP is explicitly linked to work centers — failure modes are analyzed per manufacturing station. fmea.analysis_type distinguishes PFMEA from DFMEA. Direct FK to wor',
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
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: Production control plans in automotive are often configuration-specific (model + trim + model year), especially for variant-specific processes. PPAP documentation and APQP control plans reference the ',
    `fmea_id` BIGINT COMMENT 'Link to the Process FMEA that this control plan supports.',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: Control plans are derived from design specifications; FK enables automatic extraction of spec requirements for quality control.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: IATF 16949 requires control plans to be scoped to a specific vehicle model. Quality engineers create and audit control plans per model for APQP deliverables, PPAP submissions, and model-specific produ',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Control plans are written for specific parts as a core APQP deliverable. Part-level control plan retrieval is required for incoming inspection, production quality gates, and supplier audits. No existi',
    `inspection_plan_id` BIGINT COMMENT 'Link to the detailed inspection plan referenced by this control plan.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Control plans are line‑specific for process control; required for the Production Control Review report.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Control plans are APQP deliverables scoped to vehicle programs. Program launch readiness reviews require all control plans to be linked to the program. Quality managers report control plan completion ',
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
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: Inspection plans derive acceptance criteria and tolerances directly from design specifications. APQP traceability requires linking inspection plans to the design spec that defines the requirements bei',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: inspection_plan has a plain-text vehicle_model column — a clear denormalization. Inspection plans are scoped to vehicle models in automotive quality operations (IATF 16949). Replacing the text field',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Inspection plans are written for specific parts. The part_number plain attribute on inspection_plan is a denormalization of part_master. A proper FK enables part-level inspection plan lookup during re',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Inspection plans are defined per production line to meet line‑specific quality standards; used in the Line Inspection Planning process.',
    `routing_id` BIGINT COMMENT 'Foreign key linking to manufacturing.routing. Business justification: In APQP and IATF 16949, inspection plans are tied to specific routing operations — each routing step can have a defined inspection plan. Linking inspection_plan to routing enables operation-level qual',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Inspection plans are scoped to vehicle programs and model years. The vehicle_model plain attribute is a denormalization signal. Program-level inspection plan completeness reporting is required for APQ',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: IATF 16949 and APQP require inspection plans to be defined at the work center level (e.g., torque audit at final assembly station). applicable_process is a denormalized text description of the work ce',
    `acceptance_criteria` STRING COMMENT 'Textual definition of pass/fail conditions.',
    `approval_date` DATE COMMENT 'Date when the inspection plan was approved.',
    `approved_by` STRING COMMENT 'User identifier of the approver.',
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
    `version` STRING COMMENT 'Version label of the inspection plan (e.g., v1.0, v2.1).',
    `created_by` STRING COMMENT 'Identifier of the user who created the inspection plan.',
    CONSTRAINT pk_inspection_plan PRIMARY KEY(`inspection_plan_id`)
) COMMENT 'Detailed inspection plan specifying the characteristics to be measured, measurement methods, gauges/instruments, tolerances, sample sizes, and acceptance criteria for incoming material, in-process, and final vehicle inspections. Supports incoming material inspection (IQC), in-process quality gates, and PDI (Pre-Delivery Inspection). Linked to SAP QM inspection lots.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` (
    `inspection_lot_id` BIGINT COMMENT 'System-generated unique identifier for the inspection lot record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: LOT INSPECTION: Inspection lots are performed on specific equipment; linking supports maintenance planning and defect attribution.',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: inspection_lot currently stores defect_code as a raw STRING, which is a denormalized reference to the defect_code catalog. Adding defect_code_id as a proper FK to quality.defect_code normalizes this r',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Bulk fleet deliveries require PDI inspection lots tied to the fleet contract for contract-level quality acceptance reporting, delivery milestone tracking, and fleet customer quality scorecards — a sta',
    `inspection_plan_id` BIGINT COMMENT 'Reference to the inspection plan governing this lot.',
    `order_line_id` BIGINT COMMENT 'Foreign key linking to sales.order_line. Business justification: Part-level incoming goods and PDI inspection tracking: an inspection lot for a specific accessory, option package, or component must trace to the exact order line that triggered procurement/installati',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Required for the Inbound Part Inspection Lot report that ties each inspection lot to the specific inbound part received.',
    `plant_id` BIGINT COMMENT 'Identifier of the employee who performed or supervised the inspection.',
    `po_line_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line. Business justification: Inspection lots for incoming goods are created against a specific PO line (material, quantity, supplier). This link enables per-line-item quality performance reporting, PPAP status tracking by PO line',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Traceability: inspection lot results must be linked to the specific shipment for recall, OTD and quality KPI reporting.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Inspection lots are executed per part; adding sku_master_id supports the Lot Traceability Report linking lots to the specific SKU.',
    `vehicle_allocation_id` BIGINT COMMENT 'Foreign key linking to dealer.vehicle_allocation. Business justification: PDI (pre-delivery inspection) lots at dealerships are tied to specific vehicle allocation batches. Linking inspection_lot to vehicle_allocation enables PDI pass/fail tracking per allocation, supports ',
    `vehicle_build_id` BIGINT COMMENT 'Foreign key linking to manufacturing.vehicle_build. Business justification: Automotive EOL inspection creates inspection lots per vehicle build. Linking inspection_lot to vehicle_build enables VIN-level inspection traceability required by IATF 16949 and NHTSA recall investiga',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Inspection lots are tied to production runs for specific vehicle programs. Program-level quality KPI reporting (PPM, first-pass yield by program) and launch quality monitoring require inspection lots ',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: inspection_lot has a plain work_center text column — a clear denormalization of manufacturing.work_center. Inspection lots are created at specific work centers during production. Proper FK enables w',
    `batch_number` STRING COMMENT 'Batch identifier associated with the material or component.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which the corrective action must be completed.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether a corrective action must be initiated for the identified defect.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection lot record was first created in the system.',
    `decision` STRING COMMENT 'Final usage decision for the lot after inspection.. Valid values are `accept|reject|conditional_release`',
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
    `quantity_accepted` STRING COMMENT 'Number of units/items that passed inspection criteria.',
    `quantity_inspected` STRING COMMENT 'Total number of units/items examined in this inspection lot.',
    `quantity_rejected` STRING COMMENT 'Number of units/items that failed inspection criteria.',
    `remarks` STRING COMMENT 'Free‑form comments or notes captured by the inspector.',
    `serial_number` STRING COMMENT 'Serial number of the inspected unit, if applicable.',
    `source_document_number` STRING COMMENT 'Reference number of the originating document such as goods receipt, production order, or delivery.',
    `ssot_governance_note` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the inspection lot record.',
    CONSTRAINT pk_inspection_lot PRIMARY KEY(`inspection_lot_id`)
) COMMENT 'Transactional record of a quality inspection event triggered for a batch of incoming materials, WIP assemblies, or finished vehicles. Captures lot origin (goods receipt, production order, delivery), inspection type, quantity inspected, inspection start/end timestamps, assigned inspector, and overall usage decision (accept, reject, conditional release). Sourced from SAP QM inspection lot management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_result` (
    `inspection_result_id` BIGINT COMMENT 'Unique identifier for the inspection result record.',
    `characteristic_id` BIGINT COMMENT 'Identifier of the inspected characteristic or measurement point.',
    `dealer_repair_order_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_repair_order. Business justification: PDI and warranty repair inspection results must be traceable to the specific dealer repair order that triggered the inspection. Quality audit trails, warranty administration, and OEM dealer quality ce',
    `delivery_appointment_id` BIGINT COMMENT 'Foreign key linking to sales.delivery_appointment. Business justification: PDI inspection results (characteristic-level measurements) must link to the delivery appointment to determine vehicle delivery readiness, support digital PDI checklists, and provide characteristic-lev',
    `inspection_lot_id` BIGINT COMMENT 'Identifier of the inspection lot (header) to which this result belongs.',
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
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: COPQ report requires assigning each defect to the responsible cost center for financial impact analysis.',
    `dealer_repair_order_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_repair_order. Business justification: Defects discovered during dealer service are documented against the repair order that identified them. Warranty root cause analysis, OEM quality investigations, and dealer repair quality audits all re',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Defect records are frequently generated from dealer warranty claims; linking enables root‑cause analysis and dealer‑specific defect trends.',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: defect_record currently stores defect_code as a raw STRING, which is a denormalized reference to the defect_code catalog. Adding defect_code_id as a proper FK to quality.defect_code normalizes this re',
    `delivery_appointment_id` BIGINT COMMENT 'Foreign key linking to sales.delivery_appointment. Business justification: Defects discovered during PDI or at vehicle handover must link to the delivery appointment for PDI quality reporting, customer satisfaction correlation, and delivery hold/release decisions — a core au',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: End-of-line or pre-delivery defects on finished vehicles require placing a quality hold on the finished_vehicle_stock record (hold_code, hold_reason) to prevent delivery. This FK enables the Quality H',
    `goods_movement_id` BIGINT COMMENT 'Foreign key linking to inventory.goods_movement. Business justification: Defect containment triggers a goods movement (scrap posting, transfer to blocked stock, return to supplier). This FK links the quality event to the resulting inventory transaction, enabling audit trai',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_goods_receipt. Business justification: Supplier defects detected at incoming inspection must be traceable to the specific goods receipt batch for PPM reporting, supplier scorecards, and 8D root-cause analysis. Automotive supplier quality t',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: A defect record is frequently raised as a direct result of a failed inspection lot. Adding inspection_lot_id to defect_record creates the traceable link from the operational defect back to the inspect',
    `order_line_id` BIGINT COMMENT 'Foreign key linking to sales.order_line. Business justification: Defects on specific ordered components (accessories, option packages, powertrain variants) must trace to the originating order line for warranty cost allocation, supplier chargeback, and component-lev',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Defect records must reference the canonical part master for root‑cause analysis; removes redundant part_number/name.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Defect records that trigger a recall are linked to the recall defect report for regulatory tracking.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Defect records must capture the employee who reported the issue for corrective‑action workflow.',
    `po_line_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line. Business justification: Incoming defects must be traceable to the PO line that sourced the defective material for supplier PPM calculation, PPAP deviation tracking, and warranty cost recovery. Automotive OEM supplier quality',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Automotive quality KPIs (defects per unit, line DPU) are tracked at production line level. defect_record has plant_id and production_order_id but no direct production_line_id. Direct FK enables line-l',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Defect records are tied to the specific production order where the defect was detected, essential for the Defect Tracking Dashboard.',
    `sku_master_id` BIGINT COMMENT 'Identifier of the part or component associated with the defect.',
    `stock_balance_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_balance. Business justification: Defect containment process: recording a defect triggers blocking of affected stock (blocked_stock_qty on stock_balance). Quality engineers and inventory controllers use this link to execute containmen',
    `supplier_id` BIGINT COMMENT 'Identifier of the external supplier linked to the defect, if applicable.',
    `telemetry_event_id` BIGINT COMMENT 'Foreign key linking to customer.telemetry_event. Business justification: Root cause analysis links each defect to the specific telemetry event that triggered it, required for the Defect Investigation Report.',
    `vehicle_build_id` BIGINT COMMENT 'Foreign key linking to manufacturing.vehicle_build. Business justification: IATF 16949 traceability requires defects to be traceable to the exact vehicle build record (VIN, build stage, quality_gate_status). defect_record has vin but no FK to vehicle_build; this enables EOL d',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: REQUIRED: Recall & warranty management needs to associate each defect record with the owning customers vehicle record to trigger service actions.',
    `vehicle_program_id` BIGINT COMMENT 'Reference to the quality plan or inspection plan associated with the defect.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Automotive quality operations track defects by work center (weld station, paint booth, trim line) for station-level PPM and OEE quality metrics. defect_record has plant_id and production_order_id but ',
    `containment_action` STRING COMMENT 'Immediate action taken to contain the defect and prevent further impact.',
    `corrective_action` STRING COMMENT 'Planned or executed action to eliminate the root cause of the defect.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which the corrective action must be completed.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the defect record was initially created in the system.',
    `defect_category` STRING COMMENT 'Stage of the product lifecycle where the defect was detected.. Valid values are `incoming|in_process|final|field`',
    `defect_description` STRING COMMENT 'Detailed textual description of the non‑conformance or quality issue.',
    `defect_record_status` STRING COMMENT 'Current lifecycle status of the defect record.. Valid values are `open|investigating|closed|rejected|deferred`',
    `defect_type` STRING COMMENT 'Classification of the defect by its origin or nature.. Valid values are `material|process|design|supplier|assembly|software`',
    `detected_timestamp` TIMESTAMP COMMENT 'Date and time when the defect was first observed.',
    `detection_method` STRING COMMENT 'Method or channel through which the defect was discovered.. Valid values are `inspection|test|audit|customer_complaint|sensor|automated`',
    `disposition` STRING COMMENT 'Final disposition of the defective item after evaluation.. Valid values are `rework|scrap|use_as_is|return_to_supplier|deferred`',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`corrective_action` (
    `corrective_action_id` BIGINT COMMENT 'Unique identifier for the quality_corrective_action data product (auto-inserted pre-linking).',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Corrective actions incur rework, containment, and labor costs charged to specific cost centers. Automotive quality accounting requires 8D/corrective action cost tracking against cost centers for varia',
    `defect_record_id` BIGINT COMMENT 'add column defect_record_id (BIGINT) with FK to quality.defect_record.defect_record_id - corrective actions are triggered by defect records and must link back',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Corrective actions in automotive 8D/CAPA processes are frequently model-scoped (design changes, process updates affecting all units of a model). Linking quality_corrective_action to vehicle.model enab',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: CAPAs are frequently part-specific — targeting a design or process change for a specific component. Part-level CAPA tracking enables repeat defect analysis and supplier quality scorecards by part numb',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - corrective actions are implemented at specific plants',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: Supplier Corrective Action Requests (SCARs) in automotive are issued directly to a specific supplier. The quality_corrective_action has no current FK to procurement_supplier, making it impossible to r',
    `vehicle_program_id` BIGINT COMMENT 'FK to field engineering report that recommended this corrective action',
    `action_description` STRING COMMENT 'Description of the corrective action taken.',
    `action_status` STRING COMMENT 'Status of the corrective action (open, in-progress, closed).',
    `action_type` STRING COMMENT 'Type of corrective action (containment, corrective, preventive)',
    `closed_date` DATE COMMENT 'Date the corrective action was verified and closed.',
    `completion_date` DATE COMMENT 'Actual date the corrective action was completed',
    `due_date` DATE COMMENT 'Target completion date for the corrective action.',
    `effectiveness_rating` STRING COMMENT 'Rating of how effective the corrective action was after implementation',
    `priority` STRING COMMENT 'Priority level of the corrective action (critical, high, medium, low)',
    `quality_corrective_action_status` STRING COMMENT 'Current status of the corrective action (open, in-progress, closed, verified)',
    `root_cause_summary` STRING COMMENT 'Summary of the root cause addressed by this corrective action',
    `ssot_governance_note` STRING COMMENT '',
    `verification_date` DATE COMMENT 'Date when the corrective action effectiveness was verified',
    `verification_method` STRING COMMENT 'Method used to verify effectiveness of the corrective action',
    CONSTRAINT pk_corrective_action PRIMARY KEY(`corrective_action_id`)
) COMMENT 'Corrective and Preventive Action (CAPA) record managing the structured problem-solving process for quality escapes and non-conformances. Supports 8D (Eight Disciplines) and 5-Why methodologies. Captures problem statement, containment actions (D3), root cause analysis (D4/5-Why), permanent corrective actions (D5), verification of effectiveness (D6), and preventive action deployment (D7). Tracks open/closed status and due dates.';

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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`characteristic` (
    `characteristic_id` BIGINT COMMENT 'Primary key for characteristic',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: Quality characteristics (CTQs, critical/significant characteristics) are derived from design specifications. The design spec defines target values and tolerances that become measurable quality charact',
    `parent_characteristic_id` BIGINT COMMENT 'Self-referencing FK on characteristic (parent_characteristic_id)',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Characteristics are defined for specific parts — critical/significant characteristics are part-specific and referenced in control plans and inspection plans. Part-level characteristic lookup is requir',
    `characteristic_category` STRING COMMENT 'Broad classification of the characteristic within quality domains.',
    `characteristic_status` STRING COMMENT 'Current lifecycle status of the characteristic.',
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
    `ssot_governance_note` STRING COMMENT '',
    `target_value` DECIMAL(18,2) COMMENT 'Target or nominal value that the characteristic should achieve.',
    `tolerance_lower` DECIMAL(18,2) COMMENT 'Maximum acceptable deviation below the target value.',
    `tolerance_upper` DECIMAL(18,2) COMMENT 'Maximum acceptable deviation above the target value.',
    `updated_by_user` STRING COMMENT 'User identifier who last modified the characteristic record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the characteristic record.',
    CONSTRAINT pk_characteristic PRIMARY KEY(`characteristic_id`)
) COMMENT 'Master reference table for characteristic. Referenced by characteristic_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`field_return` (
    `field_return_id` BIGINT COMMENT 'Primary key for field_return',
    `aftersales_repair_order_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_repair_order. Business justification: Field return origination tracking: a field return is typically initiated during a dealership repair order. Linking field_return to the originating repair order enables warranty cost reconciliation, pa',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Field returns in automotive generate warranty credit memos or dealer reimbursement AR invoices. Linking field_return to ar_invoice enables warranty claim financial reconciliation — a named AR process.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer associated with the returned vehicle.',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: field_return currently stores defect_code as a raw STRING, which is a denormalized reference to the defect_code catalog. Adding defect_code_id as a proper FK to quality.defect_code normalizes this rel',
    `defect_record_id` BIGINT COMMENT 'Foreign key linking to quality.defect_record. Business justification: A field return is the physical manifestation of a quality defect detected in the field. Linking field_return to defect_record creates the end-to-end quality traceability chain: defect_record (operatio',
    `delivery_appointment_id` BIGINT COMMENT 'Foreign key linking to sales.delivery_appointment. Business justification: Field returns initiated at delivery (customer refuses vehicle due to defect at handover) must link to the delivery appointment for delivery quality reporting, customer satisfaction tracking, and re-de',
    `goods_movement_id` BIGINT COMMENT 'Foreign key linking to inventory.goods_movement. Business justification: Automotive aftersales field returns (warranty/customer returns) generate a goods receipt movement when the returned part arrives at the warehouse or dealership. This FK links the field return record t',
    `order_line_id` BIGINT COMMENT 'Foreign key linking to sales.order_line. Business justification: Part-level field returns (e.g., a specific accessory or option package returned under warranty) must link to the originating order line for component-level warranty cost allocation, supplier recovery,',
    `original_field_return_id` BIGINT COMMENT 'Self-referencing FK on field_return (original_field_return_id)',
    `part_master_id` BIGINT COMMENT 'FK to field failure analysis for this returned part',
    `party_id` BIGINT COMMENT 'Identifier of the end‑customer who owned the vehicle at the time of return.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Warranty field return processing requires linking the return to the specific vehicle ownership record to identify the registered owner for customer notification, warranty entitlement validation, and r',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Field returns are analyzed by vehicle program for warranty trend analysis and engineering feedback loops. Program-level field return rate reporting drives design improvement decisions and is a standar',
    `corrective_action` STRING COMMENT 'Planned or executed corrective action to address the defect.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the monetary amounts.',
    `defect_description` STRING COMMENT 'Narrative description of the defect associated with the return.',
    `field_return_status` STRING COMMENT 'Current lifecycle status of the field return.',
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
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component applied to the gross amount.',
    CONSTRAINT pk_field_return PRIMARY KEY(`field_return_id`)
) COMMENT 'Master reference table for field_return. Referenced by field_return_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `vibe_automotive_v1`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `vibe_automotive_v1`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_parent_characteristic_id` FOREIGN KEY (`parent_characteristic_id`) REFERENCES `vibe_automotive_v1`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_original_field_return_id` FOREIGN KEY (`original_field_return_id`) REFERENCES `vibe_automotive_v1`.`quality`.`field_return`(`field_return_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`quality` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`quality` SET TAGS ('dbx_domain' = 'quality');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` SET TAGS ('dbx_subdomain' = 'risk_prevention');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'FMEA ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `platform_id` SET TAGS ('dbx_business_glossary_term' = 'Platform Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Component ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `analysis_number` SET TAGS ('dbx_business_glossary_term' = 'Analysis Number (AN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `analysis_type` SET TAGS ('dbx_business_glossary_term' = 'Analysis Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `analysis_type` SET TAGS ('dbx_value_regex' = 'design|process');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `control_effectiveness_rating` SET TAGS ('dbx_business_glossary_term' = 'Control Effectiveness Rating');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `current_control` SET TAGS ('dbx_business_glossary_term' = 'Current Control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `detection_description` SET TAGS ('dbx_business_glossary_term' = 'Detection Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `detection_method` SET TAGS ('dbx_business_glossary_term' = 'Detection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `detection_rating` SET TAGS ('dbx_business_glossary_term' = 'Detection Rating (D)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `failure_effect` SET TAGS ('dbx_business_glossary_term' = 'Failure Effect');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `fmea_status` SET TAGS ('dbx_business_glossary_term' = 'FMEA Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `fmea_status` SET TAGS ('dbx_value_regex' = 'open|closed|in_progress|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `occurrence_description` SET TAGS ('dbx_business_glossary_term' = 'Occurrence Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `occurrence_rating` SET TAGS ('dbx_business_glossary_term' = 'Occurrence Rating (O)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `recommended_action` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `rpn` SET TAGS ('dbx_business_glossary_term' = 'Risk Priority Number (RPN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `severity_description` SET TAGS ('dbx_business_glossary_term' = 'Severity Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Severity Rating (S)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `subsystem` SET TAGS ('dbx_business_glossary_term' = 'Subsystem');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `target_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Target Completion Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` SET TAGS ('dbx_subdomain' = 'risk_prevention');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Associated PFMEA ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Associated Inspection Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|revoked');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `change_control_number` SET TAGS ('dbx_business_glossary_term' = 'Change Control Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_method` SET TAGS ('dbx_business_glossary_term' = 'Control Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_method` SET TAGS ('dbx_value_regex' = 'spc|attribute|visual|functional|dimensional');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|retired|archived');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_description` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'assembly|paint|engine|chassis|electrical|final');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `reaction_plan` SET TAGS ('dbx_business_glossary_term' = 'Reaction Plan');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `responsible_function` SET TAGS ('dbx_business_glossary_term' = 'Responsible Function');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `responsible_function` SET TAGS ('dbx_value_regex' = 'assembly_line|quality_engineering|process_engineering|manufacturing|test_lab');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `revision_date` SET TAGS ('dbx_business_glossary_term' = 'Revision Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `sample_frequency` SET TAGS ('dbx_business_glossary_term' = 'Sample Frequency');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `sample_frequency` SET TAGS ('dbx_value_regex' = 'per_shift|per_batch|per_hour|per_day');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` SET TAGS ('dbx_subdomain' = 'risk_prevention');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `acceptance_criteria` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Criteria Description (ACC_CRIT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date (APPROVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (APPROVED_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `criticality_level` SET TAGS ('dbx_business_glossary_term' = 'Criticality Level (CRIT_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `criticality_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `department_responsible` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department (DEPT_RESP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_description` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Description (DESC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EFFECTIVE_UNTIL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (EFFECTIVE_FROM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency (FREQ)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `frequency` SET TAGS ('dbx_value_regex' = 'per_batch|per_shift|per_vehicle|per_day');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `gauge_type` SET TAGS ('dbx_business_glossary_term' = 'Gauge Type (GAUGE_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `gauge_type` SET TAGS ('dbx_value_regex' = 'dial|digital|laser|micrometer');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_category` SET TAGS ('dbx_business_glossary_term' = 'Inspection Category (INS_CAT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_category` SET TAGS ('dbx_value_regex' = 'dimensional|functional|visual|electrical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_status` SET TAGS ('dbx_value_regex' = 'draft|active|inactive|retired');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `is_automated` SET TAGS ('dbx_business_glossary_term' = 'Is Inspection Automated (IS_AUTOMATED)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date (LAST_REVIEW_DATE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method (MEAS_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_method` SET TAGS ('dbx_value_regex' = 'CMM|Gauge|Visual|Automated|Manual');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit (MEAS_UNIT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_value_regex' = 'mm|cm|inch|mm^2|psi');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Name (PLAN_NAME)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Number (PLAN_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Type (TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'incoming_material|in_process|final_vehicle|custom');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plant_location` SET TAGS ('dbx_business_glossary_term' = 'Plant Location Code (PLANT_LOC)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Indicator (REG_COMP)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_value_regex' = 'IATF16949|ISO9001|EPA|NHTSA|None');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `requires_approval` SET TAGS ('dbx_business_glossary_term' = 'Requires Approval Flag (REQ_APPROVAL)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `review_cycle_days` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle in Days (REVIEW_CYCLE_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number (REV_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size (SAMPLE_SZ)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `tolerance_lower` SET TAGS ('dbx_business_glossary_term' = 'Lower Tolerance Limit (TOL_LOWER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `tolerance_upper` SET TAGS ('dbx_business_glossary_term' = 'Upper Tolerance Limit (TOL_UPPER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By User Identifier (UPDATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Version (VER)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier (CREATED_BY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Identifier (EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Build Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `decision` SET TAGS ('dbx_business_glossary_term' = 'Overall Inspection Decision');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `decision` SET TAGS ('dbx_value_regex' = 'accept|reject|conditional_release');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `defect_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|closed|rejected|released');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_method` SET TAGS ('dbx_business_glossary_term' = 'Inspection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_method` SET TAGS ('dbx_value_regex' = 'visual|dimensional|functional|non_destructive|automated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Inspection Reason Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Lot Closure Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Number (LOT_NO)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_origin` SET TAGS ('dbx_business_glossary_term' = 'Lot Origin Source');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_origin` SET TAGS ('dbx_value_regex' = 'goods_receipt|production_order|delivery|return');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `lot_type` SET TAGS ('dbx_value_regex' = 'incoming_material|wip_assembly|finished_vehicle|prototype');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_result_status` SET TAGS ('dbx_business_glossary_term' = 'Measurement Result Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_result_status` SET TAGS ('dbx_value_regex' = 'pass|fail|out_of_spec');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `measurement_value` SET TAGS ('dbx_business_glossary_term' = 'Measured Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `quantity_accepted` SET TAGS ('dbx_business_glossary_term' = 'Quantity Accepted');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `quantity_inspected` SET TAGS ('dbx_business_glossary_term' = 'Quantity Inspected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `quantity_rejected` SET TAGS ('dbx_business_glossary_term' = 'Quantity Rejected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks / Comments');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `source_document_number` SET TAGS ('dbx_business_glossary_term' = 'Source Document Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_result_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Characteristic ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `dealer_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `cp_value` SET TAGS ('dbx_business_glossary_term' = 'Process Capability (Cp)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `cpk_value` SET TAGS ('dbx_business_glossary_term' = 'Process Capability Index (Cpk)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `deviation_amount` SET TAGS ('dbx_business_glossary_term' = 'Deviation Amount');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `line_sequence` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_accuracy` SET TAGS ('dbx_business_glossary_term' = 'Measurement Accuracy');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_condition` SET TAGS ('dbx_business_glossary_term' = 'Measurement Condition');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_condition` SET TAGS ('dbx_value_regex' = 'normal|high_temp|low_temp|vibration');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_humidity_percent` SET TAGS ('dbx_business_glossary_term' = 'Measurement Humidity (%)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_location` SET TAGS ('dbx_business_glossary_term' = 'Measurement Location');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_method` SET TAGS ('dbx_value_regex' = 'manual|automated|sensor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_resolution` SET TAGS ('dbx_business_glossary_term' = 'Measurement Resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_source` SET TAGS ('dbx_business_glossary_term' = 'Measurement Source');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_source` SET TAGS ('dbx_value_regex' = 'internal|external');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Measurement Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_tool` SET TAGS ('dbx_business_glossary_term' = 'Measurement Tool');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_uncertainty` SET TAGS ('dbx_business_glossary_term' = 'Measurement Uncertainty');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_value_regex' = 'mm|cm|in|mmHg|psi|kg');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `measurement_value` SET TAGS ('dbx_business_glossary_term' = 'Measured Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `record_status` SET TAGS ('dbx_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `record_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `result_status` SET TAGS ('dbx_business_glossary_term' = 'Result Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `result_status` SET TAGS ('dbx_value_regex' = 'pass|fail|na');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_record_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `dealer_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `goods_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Movement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Defect Report Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Component Identifier (COMPONENT_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `stock_balance_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Balance Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `telemetry_event_id` SET TAGS ('dbx_business_glossary_term' = 'Telemetry Event Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Build Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `containment_action` SET TAGS ('dbx_business_glossary_term' = 'Containment Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `corrective_action` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category (CATEGORY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_value_regex' = 'incoming|in_process|final|field');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_record_status` SET TAGS ('dbx_business_glossary_term' = 'Defect Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_record_status` SET TAGS ('dbx_value_regex' = 'open|investigating|closed|rejected|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_type` SET TAGS ('dbx_business_glossary_term' = 'Defect Type (DEFECT_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_type` SET TAGS ('dbx_value_regex' = 'material|process|design|supplier|assembly|software');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `detected_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Defect Detection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `detection_method` SET TAGS ('dbx_business_glossary_term' = 'Detection Method (DETECTION_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `detection_method` SET TAGS ('dbx_value_regex' = 'inspection|test|audit|customer_complaint|sensor|automated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Defect Disposition (DISPOSITION)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'rework|scrap|use_as_is|return_to_supplier|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `investigation_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Investigation End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `investigation_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Investigation Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `is_repeat_defect` SET TAGS ('dbx_business_glossary_term' = 'Repeat Defect Indicator');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `location_zone` SET TAGS ('dbx_business_glossary_term' = 'Location Zone');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `ppm_rate` SET TAGS ('dbx_business_glossary_term' = 'Parts Per Million Rate (PPM)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `quantity_affected` SET TAGS ('dbx_business_glossary_term' = 'Quantity Affected');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Defect Severity (SEVERITY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|major|minor|warning|info');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `corrective_action_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for quality_corrective_action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_system` SET TAGS ('dbx_business_glossary_term' = 'Affected System');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_system` SET TAGS ('dbx_value_regex' = 'Powertrain|Chassis|Electrical|Interior|Exterior|ADAS');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_zone` SET TAGS ('dbx_business_glossary_term' = 'Affected Zone');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `affected_zone` SET TAGS ('dbx_value_regex' = 'Front|Rear|Left|Right|Center|All');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `applicable_stage` SET TAGS ('dbx_business_glossary_term' = 'Applicable Process Stage');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `applicable_stage` SET TAGS ('dbx_value_regex' = 'incoming|in_process|final|field');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_category` SET TAGS ('dbx_value_regex' = 'dimensional|cosmetic|functional|safety|nvh');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_code` SET TAGS ('dbx_business_glossary_term' = 'Defect Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `cost_impact_estimate` SET TAGS ('dbx_business_glossary_term' = 'Cost Impact Estimate');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `detection_method` SET TAGS ('dbx_business_glossary_term' = 'Detection Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `detection_method` SET TAGS ('dbx_value_regex' = 'visual|sensor|test|audit|automated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `defect_code_name` SET TAGS ('dbx_business_glossary_term' = 'Defect Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_value_regex' = 'iatf16949|iso9001|epa|nhtsa|none');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'design|material|process|supplier|installation|unknown');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `severity_default` SET TAGS ('dbx_business_glossary_term' = 'Default Severity');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `severity_default` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `typical_resolution_time_days` SET TAGS ('dbx_business_glossary_term' = 'Typical Resolution Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `warranty_implication` SET TAGS ('dbx_business_glossary_term' = 'Warranty Implication');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `warranty_implication` SET TAGS ('dbx_value_regex' = 'none|warranty_repair|warranty_replacement|recall');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` SET TAGS ('dbx_subdomain' = 'risk_prevention');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `parent_characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Characteristic Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `parent_characteristic_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_category` SET TAGS ('dbx_business_glossary_term' = 'Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `criticality_level` SET TAGS ('dbx_business_glossary_term' = 'Criticality Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `data_type` SET TAGS ('dbx_business_glossary_term' = 'Data Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Frequency');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `tolerance_lower` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Lower');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `tolerance_upper` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Upper');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `field_return_id` SET TAGS ('dbx_business_glossary_term' = 'Field Return Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `aftersales_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `defect_record_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `goods_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Movement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `original_field_return_id` SET TAGS ('dbx_business_glossary_term' = 'Original Field Return Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `original_field_return_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `corrective_action` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `defect_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `field_return_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `labor_rate` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `mileage_at_return` SET TAGS ('dbx_business_glossary_term' = 'Mileage At Return');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `parts_replaced_count` SET TAGS ('dbx_business_glossary_term' = 'Parts Replaced Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `repair_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Repair Completion Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `repair_status` SET TAGS ('dbx_business_glossary_term' = 'Repair Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_number` SET TAGS ('dbx_business_glossary_term' = 'Return Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_reason` SET TAGS ('dbx_business_glossary_term' = 'Return Reason');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Return Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `return_type` SET TAGS ('dbx_business_glossary_term' = 'Return Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause');
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
