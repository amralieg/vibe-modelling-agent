-- Schema for Domain: quality | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:41

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`quality` COMMENT 'End-to-end quality assurance and control across design, manufacturing, and field operations. Owns APQP plans, FMEA (Failure Mode and Effects Analysis), SPC (Statistical Process Control) data, inspection plans, quality audits, defect tracking, and PPM rates. Includes incoming material inspection, in-process quality gates, final vehicle PDI (Pre-Delivery Inspection), NCAP/WLTP test results, and corrective action (8D, 5-Why) processes. Supports IATF 16949 compliance.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`control_plan` (
    `control_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the quality control plan.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Control plans in IATF 16949 are authored at the vehicle model level to define inspection characteristics for all configurations of that model. Quality engineers need to retrieve all control plans for ',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Control plans are project‑tracked in the WBS for capital budgeting and cost control.',
    `inspection_plan_id` BIGINT COMMENT 'Link to the detailed inspection plan referenced by this control plan.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Control plans are line‑specific for process control; required for the Production Control Review report.',
    `routing_id` BIGINT COMMENT 'Foreign key linking to manufacturing.routing. Business justification: APQP/PPAP mandates that control plans map directly to manufacturing routings — each routing operation must have corresponding control characteristics. This is a core IATF 16949 and AIAG APQP requireme',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: APQP control plans are authored for specific part numbers/SKUs. Quality teams retrieve all active control plans for a given SKU during production setup and supplier audits. Without this FK, control pl',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: CONTROL PLAN EXECUTION: Measurement equipment used in control plans must be tracked for maintenance and traceability.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: IATF 16949 requires control plans to be defined at the process/work-center level. Quality engineers assign control plans to specific work centers for process audits and operator instructions. Currentl',
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
    `target_value` DECIMAL(18,2) COMMENT 'Desired nominal value for the controlled characteristic.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the control plan record.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable value for the characteristic.',
    `created_by` STRING COMMENT 'Name or identifier of the employee who authored the control plan.',
    CONSTRAINT pk_control_plan PRIMARY KEY(`control_plan_id`)
) COMMENT 'Quality control plan defining the process controls, inspection methods, measurement systems, reaction plans, and control characteristics for each manufacturing operation or assembly step. Links to PFMEA and inspection plans. Specifies sample sizes, frequencies, control methods (SPC, attribute, visual), and responsible functions per IATF 16949 requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` (
    `inspection_plan_id` BIGINT COMMENT 'Unique identifier for the inspection plan.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Incoming inspection planning requires associating each inspection plan with the specific inbound part it governs. The existing plain-text `part_number` column is a denormalization of inbound_part. Rep',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Automotive quality teams author model-specific inspection plans (body, paint, powertrain checks) for each vehicle model. Model launch readiness and annual quality audits require this link. Replaces de',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Inspection Cost Allocation report assigns inspection plan expenses to the responsible cost center.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Inspection plans are defined per production line to meet line‑specific quality standards; used in the Line Inspection Planning process.',
    `routing_id` BIGINT COMMENT 'Foreign key linking to manufacturing.routing. Business justification: SAP PP-QM integration assigns inspection plans to routing operations. New model launches require every routing operation to have a corresponding inspection plan (PPAP element). This FK enables automat',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Inspection plans define inspection criteria for specific parts/SKUs. inspection_plan.part_number is a denormalized free-text field that should be replaced by a proper FK to sku_master. Quality and pro',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: SAP QM inspection plans are assigned to routing operations at specific work centers. applicable_process and plant_location on inspection_plan are plain-text proxies for this. Proper FK enables sh',
    `acceptance_criteria` STRING COMMENT 'Textual definition of pass/fail conditions.',
    `applicable_process` STRING COMMENT 'Manufacturing process to which the inspection plan applies.. Valid values are `IQC|IPQC|PDI|Final`',
    `approval_date` DATE COMMENT 'Date when the inspection plan was approved.',
    `approved_by` STRING COMMENT 'User identifier of the approver.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection plan record was first created.',
    `criticality_level` STRING COMMENT 'Risk level associated with the inspection characteristic.. Valid values are `low|medium|high|critical`',
    `department_responsible` STRING COMMENT 'Organizational department owning the inspection plan.',
    `inspection_plan_description` STRING COMMENT 'Detailed description of the purpose and scope of the inspection plan.',
    `effective_end_date` DATE COMMENT 'Date when the inspection plan expires or is superseded (nullable).',
    `effective_start_date` DATE COMMENT 'Date when the inspection plan becomes effective.',
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
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: In automotive quality (IATF 16949), every inspection lot is executed against a control plan that defines the inspection method, sample size, frequency, and reaction plan. The control plan is the gover',
    `delivery_appointment_id` BIGINT COMMENT 'Foreign key linking to sales.delivery_appointment. Business justification: Pre-Delivery Inspection (PDI) is a formal quality gate before vehicle handover. The inspection lot created during PDI must be traceable to the delivery appointment it was performed for, enabling PDI p',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Required for the Inbound Part Inspection Lot report that ties each inspection lot to the specific inbound part received.',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_shipment. Business justification: Incoming goods inspection (IGI) process requires tracing each inspection lot to the specific inbound shipment that triggered it. Enables supplier quality reporting by shipment, supports SCAR issuance,',
    `inspection_plan_id` BIGINT COMMENT 'Reference to the inspection plan governing this lot.',
    `plant_id` BIGINT COMMENT 'Identifier of the employee who performed or supervised the inspection.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Inspection lots are executed per part; adding sku_master_id supports the Lot Traceability Report linking lots to the specific SKU.',
    `stock_balance_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_balance. Business justification: Inspection lots place specific stock quantities into quality-inspection hold (stock_balance.quality_inspection_stock_qty). Quality must link the lot to the exact stock balance record to execute stock ',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Needed for the Supplier Inspection Summary dashboard aggregating inspection lots per supplier.',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: PDI inspection lots are created at vehicle compounds before dealer delivery. Inspection lots reference plants and dealerships but not compounds, creating a gap in compound-level quality traceability. ',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Supports the Inspection Lot Traceability report, associating each lot with its vehicle order to ensure inspection results are linked to the correct customer order.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: End-of-line and pre-delivery inspection (PDI) lots are created per individual VIN in automotive production. Traceability regulations and warranty quality reports require linking each inspection lot to',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Inspection lots are generated at specific work centers (paint gate, end-of-line, body shop). The plain-text work_center column on inspection_lot is a denormalization of manufacturing.work_center. Pr',
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
    `quantity_accepted` STRING COMMENT 'Number of units/items that passed inspection criteria.',
    `quantity_inspected` STRING COMMENT 'Total number of units/items examined in this inspection lot.',
    `quantity_rejected` STRING COMMENT 'Number of units/items that failed inspection criteria.',
    `remarks` STRING COMMENT 'Free‑form comments or notes captured by the inspector.',
    `serial_number` STRING COMMENT 'Serial number of the inspected unit, if applicable.',
    `source_document_number` STRING COMMENT 'Reference number of the originating document such as goods receipt, production order, or delivery.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the inspection lot record.',
    CONSTRAINT pk_inspection_lot PRIMARY KEY(`inspection_lot_id`)
) COMMENT 'Transactional record of a quality inspection event triggered for a batch of incoming materials, WIP assemblies, or finished vehicles. Captures lot origin (goods receipt, production order, delivery), inspection type, quantity inspected, inspection start/end timestamps, assigned inspector, and overall usage decision (accept, reject, conditional release). Sourced from SAP QM inspection lot management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_result` (
    `inspection_result_id` BIGINT COMMENT 'Unique identifier for the inspection result record.',
    `characteristic_id` BIGINT COMMENT 'Identifier of the inspected characteristic or measurement point.',
    `inspection_lot_id` BIGINT COMMENT 'Identifier of the inspection lot (header) to which this result belongs.',
    `plant_id` BIGINT COMMENT 'Identifier of the employee who performed the inspection.',
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
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable value for the characteristic.',
    CONSTRAINT pk_inspection_result PRIMARY KEY(`inspection_result_id`)
) COMMENT 'Individual characteristic measurement result recorded during an inspection lot. Captures the measured value or attribute outcome, tolerance limits, pass/fail status, measurement instrument used, and inspector ID for each characteristic within an inspection plan. Supports SPC data collection and statistical analysis of process capability (Cp, Cpk).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`defect_record` (
    `defect_record_id` BIGINT COMMENT 'System-generated unique identifier for the defect record.',
    `dealer_repair_order_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_repair_order. Business justification: Warranty and field defect tracking requires linking defect records to the dealer repair order that identified or documented the defect. Enables warranty cost analysis, repeat-defect reporting, and fie',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Defect records are frequently generated from dealer warranty claims; linking enables root‑cause analysis and dealer‑specific defect trends.',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: End-of-line and PDI defects are recorded against specific finished vehicles in stock. Quality disposition decisions (hold, rework, release) directly drive finished_vehicle_stock.hold_code and stock_st',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: PPM defect rate reporting and IATF 16949 traceability require linking defect records to the specific inbound part definition (including PPAP status, engineering change level). Supplier quality enginee',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Defects discovered during incoming material inspection, in-process quality gates, or PDI are raised FROM an inspection lot. The defect_record should reference the triggering inspection_lot to enable t',
    `inspection_result_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_result. Business justification: A defect record can be traced to a specific failing inspection result (the individual characteristic measurement that triggered the non-conformance). This granular link enables root cause analysis at ',
    `dealer_inventory_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_inventory. Business justification: PDI defect detection and pre-delivery quality holds require linking a defect record to the specific dealer inventory unit affected. Supports inventory hold workflows, PDI pass/fail reporting, and reca',
    `model_id` BIGINT COMMENT 'Reference to the quality plan or inspection plan associated with the defect.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: COPQ report requires assigning each defect to the responsible cost center for financial impact analysis.',
    `powertrain_variant_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_variant. Business justification: Powertrain-specific defect rate reporting (EV battery defects vs ICE engine defects) is a core quality engineering process. Quality engineers track PPM rates by powertrain variant for supplier scoreca',
    `procurement_po_line_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line. Business justification: Defects from incoming inspection are traceable to the specific PO line supplying the defective material. This FK supports supplier PPM (parts-per-million) defect rate reporting by PO line — a standard',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Defect records are tied to the specific production order where the defect was detected, essential for the Defect Tracking Dashboard.',
    `service_parts_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.service_parts_stock. Business justification: Defects in service parts stock (counterfeit parts, shelf-life violations, storage damage) require linking the defect record to the specific service_parts_stock entry for disposition and quarantine. Af',
    `sku_master_id` BIGINT COMMENT 'Identifier of the part or component associated with the defect.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Defect records must reference the canonical part master for root‑cause analysis; removes redundant part_number/name.',
    `telemetry_event_id` BIGINT COMMENT 'Foreign key linking to sales.telemetry_event. Business justification: Root cause analysis links each defect to the specific telemetry event that triggered it, required for the Defect Investigation Report.',
    `vehicle_build_id` BIGINT COMMENT 'Foreign key linking to manufacturing.vehicle_build. Business justification: Defects are detected during the vehicle build process at specific build stages. defect_record links to production_order and vin_registry but not to vehicle_build directly. Quality engineers need all ',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: Defects detected at vehicle compounds (storage damage, PDI failures, handling damage) must be traceable to the specific compound for compound performance audits and corrective actions. Automotive qual',
    `vehicle_handover_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_handover. Business justification: Defects discovered at vehicle handover (damage noted on handover condition report, PDI failures at delivery) must link to the handover event for warranty start tracking, dealer claims, and customer sa',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Defects found during final inspection or PDI must be linked to the specific vehicle order to support order-hold workflows, delivery-readiness sign-off, and customer-facing defect disclosure. Quality t',
    `vehicle_transport_order_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_transport_order. Business justification: Transport damage claims and carrier liability attribution require linking defect records to the specific vehicle transport order. Automotive OEMs track transit-damage defects against VTOs for carrier ',
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
    `investigation_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the investigation was concluded.',
    `investigation_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the root‑cause investigation began.',
    `is_repeat_defect` BOOLEAN COMMENT 'Flag indicating whether this defect has been observed previously.',
    `location_zone` STRING COMMENT 'Vehicle zone or assembly area where the defect was identified (e.g., body, powertrain).',
    `ppm_rate` DECIMAL(18,2) COMMENT 'Defect rate expressed in parts per million for quality metrics.',
    `quantity_affected` STRING COMMENT 'Number of units or parts impacted by the defect.',
    `root_cause` STRING COMMENT 'Root cause analysis result describing why the defect occurred.',
    `severity` STRING COMMENT 'Severity level indicating impact on safety, performance, or compliance.. Valid values are `critical|major|minor|warning|info`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the defect record.',
    `vin` STRING COMMENT 'VIN of the vehicle in which the defect was found.',
    CONSTRAINT pk_defect_record PRIMARY KEY(`defect_record_id`)
) COMMENT 'Operational record of a quality defect or non-conformance identified at any stage — incoming material, in-process assembly, final inspection, or field. Captures defect code, defect description, location on vehicle (zone/component), severity classification, detection method, quantity affected, containment action taken, and disposition (rework, scrap, use-as-is). Sourced from Apriso/Dassault MES quality control module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` (
    `quality_ppap_submission_id` BIGINT COMMENT 'Unique identifier for the quality_ppap_submission data product (auto-inserted pre-linking).',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: The AIAG PPAP (Production Part Approval Process) requires a Control Plan as one of its 18 mandatory elements (Element 16). A PPAP submission must reference the associated control plan that governs the',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: PPAP submission belongs to an APQP plan; linking via apqp_plan_id enables reuse of part_number and plan details.',
    `powertrain_variant_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_variant. Business justification: Supplier PPAP submissions for powertrain components (engines, battery packs, transmissions) are approved per powertrain variant. Supplier quality engineers track PPAP approval status by powertrain var',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: PPAP submissions are made by specific procurement suppliers. Linking quality_ppap_submission to procurement_supplier is fundamental for supplier qualification tracking, PPAP status reporting by suppli',
    `production_bom_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_bom. Business justification: AIAG PPAP requires the production BOM as a mandatory submission element (Design Records). quality_ppap_submission must reference the specific production_bom version used at PPAP submission time. This ',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: PPAP submissions are part-number-specific approval packages. Linking quality_ppap_submission to sku_master enables procurement and quality teams to verify PPAP approval status before releasing a part ',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: PPAP submissions are mandated by supplier contracts in automotive (AIAG PPAP / IATF 16949). The PPAP must reference the contract that requires it, enabling contract compliance tracking, PPAP level ver',
    `supply_ppap_submission_id` BIGINT COMMENT 'Foreign key linking to supply.supply_ppap_submission. Business justification: PPAP Submission Tracking links the quality PPAP record to the original supply PPAP submission for compliance audits.',
    CONSTRAINT pk_quality_ppap_submission PRIMARY KEY(`quality_ppap_submission_id`)
) COMMENT 'Production Part Approval Process submission record for a supplier part or internally manufactured component. Tracks PPAP level (1-5), submission reason (new part, engineering change, tooling change), submission date, approval status, and the 18 PPAP elements status (design records, PFMEA, control plan, MSA, capability study, etc.). Supports IATF 16949 supplier quality management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`corrective_action` (
    `corrective_action_id` BIGINT COMMENT 'Unique identifier for the quality_corrective_action data product (auto-inserted pre-linking).',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.audit. Business justification: Audit findings (major/minor non-conformances) directly trigger corrective actions. The audit table has corrective_action_required, corrective_action_due_date, and corrective_action_status fields indic',
    `case_id` BIGINT COMMENT 'Foreign key linking to customer.case. Business justification: Automotive CAPA (Corrective and Preventive Action) processes are frequently initiated by customer complaint cases. Linking quality_corrective_action directly to the triggering customer case supports c',
    `dealer_repair_order_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_repair_order. Business justification: Recall remediation and warranty corrective actions are executed through dealer repair orders. Linking quality_corrective_action to the implementing repair order enables corrective action closure verif',
    `defect_record_id` BIGINT COMMENT 'add column defect_record_id (BIGINT) with FK to quality.defect_record.defect_record_id - corrective actions are triggered by defect records and must link back',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - corrective actions are implemented at specific plants',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: Supplier Corrective Action Requests (SCARs) are a core automotive quality process (IATF 16949 clause 10.2). When a corrective action is issued to a supplier, it must reference the procurement supplier',
    `root_cause_analysis_id` BIGINT COMMENT 'Foreign key linking to quality.root_cause_analysis. Business justification: In the 8D corrective action process (standard in automotive IATF 16949), D4 is root cause identification and D5-D6 are corrective/preventive actions. A corrective action is directly driven by a root c',
    `action_description` STRING COMMENT '',
    `action_type` STRING COMMENT '',
    `closed_date` DATE COMMENT '',
    `containment_action` STRING COMMENT '',
    `corrective_action_number` STRING COMMENT '',
    `corrective_action_status` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `due_date` DATE COMMENT '',
    `effectiveness_verified_flag` BOOLEAN COMMENT '',
    `priority` STRING COMMENT '',
    `root_cause_summary` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_corrective_action PRIMARY KEY(`corrective_action_id`)
) COMMENT 'Corrective and Preventive Action (CAPA) record managing the structured problem-solving process for quality escapes and non-conformances. Supports 8D (Eight Disciplines) and 5-Why methodologies. Captures problem statement, containment actions (D3), root cause analysis (D4/5-Why), permanent corrective actions (D5), verification of effectiveness (D6), and preventive action deployment (D7). Tracks open/closed status and due dates.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`audit` (
    `audit_id` BIGINT COMMENT 'System-generated unique identifier for the quality audit record.',
    `plant_id` BIGINT COMMENT 'Surrogate key for the audited facility.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Carrier quality audits (IATF compliance, safety rating audits, transport quality audits) are a standard automotive OEM process. The audit table has no carrier reference despite audit_type supporting c',
    `control_plan_id` BIGINT COMMENT 'Identifier of the audit plan that defines scope, criteria, and schedule.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer Quality Audit process requires linking each audit to the specific dealership for compliance reporting and corrective action tracking.',
    `franchise_agreement_id` BIGINT COMMENT 'Foreign key linking to dealer.franchise_agreement. Business justification: Dealer standards and facility audits are conducted against specific franchise agreement requirements. Linking audit to franchise_agreement supports franchise compliance scoring, renewal decisions, and',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Quality audits in automotive (IATF 16949, VDA 6.3) frequently audit the adequacy and compliance of inspection plans — verifying that inspection plans are current, approved, and being followed on the s',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Model launch readiness audits and model-year quality audits are scoped to a specific vehicle model in automotive. Regulatory compliance audits (IATF 16949) and internal quality gates require audit rec',
    `primary_auditee_location_plant_id` BIGINT COMMENT 'Surrogate key for the audited facility.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: Supplier audits in automotive are conducted against procurement supplier records. The audit table has supply_supplier_id but lacks a procurement_supplier_id FK, creating a gap in supplier audit histor',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Quality audits are performed per production line; the Line Audit Summary report depends on this linkage.',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Supplier audits in automotive are frequently conducted to verify compliance with specific supplier contracts (contract compliance audits). Linking audit to supplier_contract enables contract-level aud',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: Vehicle compound audits (PDI capability, storage condition, security, environmental compliance) are performed by automotive OEM quality teams. The audit table references plants but not compounds, whic',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Warehouse quality audits (5S, inventory accuracy, hazardous material storage compliance, IATF 16949 logistics audits) are a standard automotive quality process. The audit table has audit_type and audi',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: VDA 6.3 process audits and IATF layered process audits (LPA) are conducted at specific work centers. audit.auditee_location is plain text. Proper FK to work_center enables work-center-level audit sche',
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
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the audit record.',
    CONSTRAINT pk_audit PRIMARY KEY(`audit_id`)
) COMMENT 'Quality system and process audit record capturing planned and unplanned audits conducted at plants, supplier facilities, or dealer service centers. Tracks audit type (system, process, product, layered process audit — LPA), audit scope, audit date, lead auditor, findings count by severity, overall audit score, and closure status. Supports IATF 16949 internal audit requirements and customer-specific requirements (CSR).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`characteristic` (
    `characteristic_id` BIGINT COMMENT 'Primary key for characteristic',
    `parent_characteristic_id` BIGINT COMMENT 'Self-referencing FK on characteristic (parent_characteristic_id)',
    `characteristic_category` STRING COMMENT 'Broad classification of the characteristic within quality domains.',
    `characteristic_status` STRING COMMENT 'Current lifecycle status of the characteristic.',
    `created_by_user` STRING COMMENT 'User identifier who initially created the characteristic record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the characteristic record was first created.',
    `criticality_level` STRING COMMENT 'Business impact rating of the characteristic on product quality.',
    `data_type` STRING COMMENT 'Data type of the characteristics measured value.',
    `characteristic_description` STRING COMMENT 'Detailed description of what the characteristic measures or represents.',
    `effective_from` DATE COMMENT 'Date when the characteristic becomes valid for use.',
    `effective_until` DATE COMMENT 'Date when the characteristic is retired or superseded (nullable).',
    `frequency` STRING COMMENT 'How often the characteristic is measured or evaluated.',
    `measurement_method` STRING COMMENT 'Technique used to capture the characteristic value.',
    `measurement_unit` STRING COMMENT 'Unit of measure associated with the characteristic (e.g., mm, kg, sec).',
    `characteristic_name` STRING COMMENT 'Human‑readable name of the quality characteristic.',
    `notes` STRING COMMENT 'Free‑form comments or observations about the characteristic.',
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
    `parent_root_cause_analysis_id` BIGINT COMMENT 'Self-referencing FK on root_cause_analysis (related_root_cause_analysis_id)',
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
    `root_cause_analysis_status` STRING COMMENT 'Current lifecycle status of the root cause analysis.',
    `root_cause_analysis_type` STRING COMMENT 'Indicates whether the cause is systemic, occasional, or a one‑off event.',
    `severity_level` STRING COMMENT 'Numeric rating (1‑5) of the impact severity of the root cause on product quality.',
    `target_resolution_date` DATE COMMENT 'Planned date by which the corrective action should be completed.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the root cause analysis record.',
    `verification_method` STRING COMMENT 'Method used to verify that the corrective action resolved the root cause.',
    `verification_result` STRING COMMENT 'Outcome of the verification activity.',
    CONSTRAINT pk_root_cause_analysis PRIMARY KEY(`root_cause_analysis_id`)
) COMMENT 'Master reference table for root_cause_analysis. Referenced by root_cause_analysis_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` (
    `inspection_characteristic_id` BIGINT COMMENT 'Primary key for the inspection characteristic association record.',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to the characteristic being measured or inspected.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to the inspection plan that defines the overall inspection scope and context.',
    `acceptance_criteria` STRING COMMENT 'Pass/fail decision rules specific to this characteristic within this inspection plan (e.g., AQL levels, Cpk requirements).',
    `created_by_user` STRING COMMENT 'User identifier of the quality engineer who added this characteristic to the inspection plan.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this inspection characteristic requirement was added to the plan.',
    `frequency` STRING COMMENT 'How often this characteristic should be inspected under this plan (e.g., every unit, hourly, per lot).',
    `gauge_type` STRING COMMENT 'Specific gauge or measurement instrument required for inspecting this characteristic under this plan.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether this characteristic is designated as critical within the context of this inspection plan.',
    `measurement_method` STRING COMMENT 'Specific measurement technique to be used for this characteristic within this inspection plan context. May override or specialize the default method defined on the characteristic master.',
    `sample_size` STRING COMMENT 'Number of samples to be measured for this characteristic during inspection execution per this plan.',
    `sequence_number` STRING COMMENT 'Order in which this characteristic should be inspected within the inspection plan workflow.',
    `tolerance_lower` DECIMAL(18,2) COMMENT 'Plan-specific lower tolerance limit for this characteristic. May override the characteristic master tolerance based on application context.',
    `tolerance_upper` DECIMAL(18,2) COMMENT 'Plan-specific upper tolerance limit for this characteristic. May override the characteristic master tolerance based on application context.',
    `updated_by_user` STRING COMMENT 'User identifier who last modified this inspection characteristic requirement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this inspection characteristic requirement.',
    CONSTRAINT pk_inspection_characteristic PRIMARY KEY(`inspection_characteristic_id`)
) COMMENT 'This association product represents the inspection requirement between an inspection plan and a characteristic. It captures the specific measurement instructions, tolerances, sampling rules, and acceptance criteria that apply when a particular characteristic is inspected under a particular inspection plan. Each record links one inspection_plan to one characteristic with attributes that exist only in the context of this inspection requirement.. Existence Justification: In automotive quality management (IATF 16949 / VDA standards), an inspection plan is explicitly structured as a collection of multiple characteristics to be inspected, and each characteristic can appear in multiple inspection plans (e.g., bore diameter is inspected in incoming material plans, in-process plans, and final vehicle PDI plans). The business actively manages inspection characteristics or inspection plan lines as operational entities with plan-specific measurement instructions, tolerances, sampling rules, and acceptance criteria that vary by context.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `vibe_automotive_v1`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_inspection_result_id` FOREIGN KEY (`inspection_result_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_result`(`inspection_result_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ADD CONSTRAINT `fk_quality_quality_ppap_submission_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `vibe_automotive_v1`.`quality`.`audit`(`audit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_root_cause_analysis_id` FOREIGN KEY (`root_cause_analysis_id`) REFERENCES `vibe_automotive_v1`.`quality`.`root_cause_analysis`(`root_cause_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_parent_characteristic_id` FOREIGN KEY (`parent_characteristic_id`) REFERENCES `vibe_automotive_v1`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ADD CONSTRAINT `fk_quality_root_cause_analysis_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ADD CONSTRAINT `fk_quality_root_cause_analysis_parent_root_cause_analysis_id` FOREIGN KEY (`parent_root_cause_analysis_id`) REFERENCES `vibe_automotive_v1`.`quality`.`root_cause_analysis`(`root_cause_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ADD CONSTRAINT `fk_quality_inspection_characteristic_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `vibe_automotive_v1`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ADD CONSTRAINT `fk_quality_inspection_characteristic_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`quality` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`quality` SET TAGS ('dbx_domain' = 'quality');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` SET TAGS ('dbx_subdomain' = 'process_control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Associated Inspection Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` SET TAGS ('dbx_subdomain' = 'process_control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `acceptance_criteria` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Criteria Description (ACC_CRIT)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `applicable_process` SET TAGS ('dbx_business_glossary_term' = 'Applicable Process for Inspection (PROCESS)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ALTER COLUMN `applicable_process` SET TAGS ('dbx_value_regex' = 'IQC|IPQC|PDI|Final');
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
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` SET TAGS ('dbx_subdomain' = 'process_control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Identifier (EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `stock_balance_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Balance Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `decision` SET TAGS ('dbx_business_glossary_term' = 'Overall Inspection Decision');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `decision` SET TAGS ('dbx_value_regex' = 'accept|reject|conditional_release');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ALTER COLUMN `defect_code` SET TAGS ('dbx_business_glossary_term' = 'Defect Code (Quality Defect Identifier)');
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
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` SET TAGS ('dbx_subdomain' = 'process_control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_result_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Characteristic ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
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
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_record_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `dealer_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `inspection_result_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `dealer_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Inventory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `procurement_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `service_parts_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Service Parts Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Component Identifier (COMPONENT_ID)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `telemetry_event_id` SET TAGS ('dbx_business_glossary_term' = 'Telemetry Event Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Build Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_handover_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `containment_action` SET TAGS ('dbx_business_glossary_term' = 'Containment Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `corrective_action` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category (CATEGORY)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_category` SET TAGS ('dbx_value_regex' = 'incoming|in_process|final|field');
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ALTER COLUMN `defect_code` SET TAGS ('dbx_business_glossary_term' = 'Defect Code (DEFECT_CODE)');
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
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` SET TAGS ('dbx_subdomain' = 'supplier_validation');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `quality_ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for quality_ppap_submission');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Apqp Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Production Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_ppap_submission` ALTER COLUMN `supply_ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Ppap Submission Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `corrective_action_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for quality_corrective_action');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `case_id` SET TAGS ('dbx_business_glossary_term' = 'Case Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `dealer_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ALTER COLUMN `root_cause_analysis_id` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` SET TAGS ('dbx_subdomain' = 'supplier_validation');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Auditee Location ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Plan ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `franchise_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `primary_auditee_location_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Auditee Location ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_business_glossary_term' = 'Audit Number');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^AUD-d{6}$');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_business_glossary_term' = 'Audit Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_business_glossary_term' = 'Audit Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'system|process|product|layered_process');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditee_location` SET TAGS ('dbx_business_glossary_term' = 'Auditee Location');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Auditor Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Closure Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_business_glossary_term' = 'Closure Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_value_regex' = 'open|closed|deferred');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `compliance_reference` SET TAGS ('dbx_business_glossary_term' = 'Compliance Reference');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_status` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `corrective_action_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `documents_count` SET TAGS ('dbx_business_glossary_term' = 'Audit Documents Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Audit Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_major` SET TAGS ('dbx_business_glossary_term' = 'Major Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_minor` SET TAGS ('dbx_business_glossary_term' = 'Minor Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_severe` SET TAGS ('dbx_business_glossary_term' = 'Severe Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `findings_total` SET TAGS ('dbx_business_glossary_term' = 'Total Findings Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Audit Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'internal|external|third_party');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `non_conformance_count` SET TAGS ('dbx_business_glossary_term' = 'Non‑Conformance Count');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `non_conformance_severity` SET TAGS ('dbx_business_glossary_term' = 'Non‑Conformance Severity');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `non_conformance_severity` SET TAGS ('dbx_value_regex' = 'critical|major|minor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Audit Notes');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `overall_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Audit Score');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_value_regex' = 'IATF|ISO9001|ISO14001|NHTSA|EPA');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Audit Scope');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `score_category` SET TAGS ('dbx_business_glossary_term' = 'Audit Score Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `score_category` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` SET TAGS ('dbx_subdomain' = 'process_control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `parent_characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Characteristic Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ALTER COLUMN `parent_characteristic_id` SET TAGS ('dbx_self_ref_fk' = 'true');
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
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_id` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis Identifier');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `parent_root_cause_analysis_id` SET TAGS ('dbx_business_glossary_term' = 'Related Root Cause Analysis Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `parent_root_cause_analysis_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `actual_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_category` SET TAGS ('dbx_business_glossary_term' = 'Category');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_code` SET TAGS ('dbx_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `corrective_action_owner` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Owner');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `corrective_action_plan` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Plan');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `detection_phase` SET TAGS ('dbx_business_glossary_term' = 'Detection Phase');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `impact_description` SET TAGS ('dbx_business_glossary_term' = 'Impact Description');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `occurrence_phase` SET TAGS ('dbx_business_glossary_term' = 'Occurrence Phase');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `owner` SET TAGS ('dbx_business_glossary_term' = 'Owner');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Priority');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `root_cause_analysis_type` SET TAGS ('dbx_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Severity Level');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Target Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `verification_method` SET TAGS ('dbx_business_glossary_term' = 'Verification Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ALTER COLUMN `verification_result` SET TAGS ('dbx_business_glossary_term' = 'Verification Result');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` SET TAGS ('dbx_subdomain' = 'process_control');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` SET TAGS ('dbx_association_edges' = 'quality.inspection_plan,quality.characteristic');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `inspection_characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Characteristic ID');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Characteristic - Characteristic Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Characteristic - Inspection Plan Id');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `acceptance_criteria` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Criteria');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `created_by_user` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `gauge_type` SET TAGS ('dbx_business_glossary_term' = 'Gauge Type');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Characteristic Flag');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Sequence');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `tolerance_lower` SET TAGS ('dbx_business_glossary_term' = 'Lower Tolerance Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `tolerance_upper` SET TAGS ('dbx_business_glossary_term' = 'Upper Tolerance Limit');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_characteristic` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
