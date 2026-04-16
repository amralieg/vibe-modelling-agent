-- Schema for Domain: quality | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:36

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`quality` COMMENT 'Manages the Quality Management System (QMS) including inspection plans, FAI (First Article Inspection), AQL/SPC/Six Sigma controls, NCR processing, CAPA workflows, FMEA analyses, APQP, PPAP documentation, and quality audits. Tracks PPM, Cp/Cpk indices, scrap rate, and yield across all production stages. Ensures compliance with ISO 9001.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`inspection_plan` (
    `inspection_plan_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a quality inspection plan record in the lakehouse silver layer.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Inspection plans define quality checks for specific engineered components. Quality engineers reference component specifications daily to create inspection criteria and measurement points.',
    `routing_id` BIGINT COMMENT 'Foreign key linking to production.routing. Business justification: Inspection plans define quality checks aligned with production routing operations. Quality engineers create inspection plans that mirror the manufacturing process flow for in-process verification.',
    `approved_by` STRING COMMENT 'Name or user ID of the quality authority (e.g., Quality Engineer, Quality Manager) who formally approved and released this inspection plan. Required for ISO 9001 document control compliance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection plan was formally approved and released for production use. Provides an auditable approval trail for ISO 9001 document control.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `apqp_phase` STRING COMMENT 'APQP phase during which this inspection plan was developed or is applicable. Tracks the maturity of the quality plan from concept through production launch per AIAG APQP methodology.. Valid values are `phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_validation|phase_5_launch|production`',
    `aql_level` DECIMAL(18,2) COMMENT 'Acceptable Quality Level expressed as the maximum percent defective (or defects per hundred units) that is considered satisfactory as a process average. Governs the accept/reject decision for inspection lots per ANSI/ASQ Z1.4 or ISO 2859-1 sampling tables.. Valid values are `^(0.065|0.1|0.15|0.25|0.4|0.65|1.0|1.5|2.5|4.0|6.5|10.0|15.0|25.0|40.0|65.0|100.0)$`',
    `change_notice_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered the creation or revision of this inspection plan. Provides traceability between design changes and quality plan updates.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where this inspection plan is applicable. Supports country-specific regulatory requirements and multi-country quality management.. Valid values are `^[A-Z]{3}$`',
    `cpk_minimum_required` DECIMAL(18,2) COMMENT 'Minimum acceptable Cpk (Process Capability Index - Centered) threshold that must be achieved for quantitative characteristics in this plan. Typically 1.33 for standard processes and 1.67 for safety-critical characteristics per Six Sigma and AIAG standards.. Valid values are `^[0-9]{1,2}(.[0-9]{1,2})?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection plan record was initially created in SAP QM. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_code` STRING COMMENT 'Customer identifier when this inspection plan is tailored to meet a specific customers quality requirements or contractual specifications. Supports customer-specific PPAP and SLA compliance.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `destructive_test` BOOLEAN COMMENT 'Indicates whether any inspection characteristic in this plan requires destructive testing, which renders the sampled unit unusable after inspection. Impacts sample size planning and material cost accounting.. Valid values are `true|false`',
    `dynamic_modification_rule` STRING COMMENT 'SAP QM dynamic modification rule code that governs automatic tightening, normal, or reduced inspection switching based on cumulative quality history (accept/reject run). Implements skip-lot and reduced inspection per ISO 2859-3.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `fai_required` BOOLEAN COMMENT 'Indicates whether a First Article Inspection (FAI) must be completed using this plan before serial production is authorized. FAI validates that the manufacturing process can produce parts conforming to all design requirements.. Valid values are `true|false`',
    `inspection_category` STRING COMMENT 'Broad category of inspection methodology applied in this plan, indicating the nature of the quality checks performed (e.g., dimensional measurement, visual examination, functional testing, non-destructive testing).. Valid values are `dimensional|visual|functional|chemical|mechanical|electrical|environmental|destructive|non_destructive`',
    `inspection_level` STRING COMMENT 'Inspection level (I, II, III, or special levels S-1 through S-4) as defined in ANSI/ASQ Z1.4 / ISO 2859-1, determining the relative sample size used for the inspection. Level II is the standard default.. Valid values are `I|II|III|S-1|S-2|S-3|S-4`',
    `inspection_method_code` STRING COMMENT 'Code identifying the standardized inspection method or test procedure (e.g., CMM measurement, visual gauge, hardness test, tensile test) to be applied for the characteristics in this plan.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `language_code` STRING COMMENT 'ISO 639-1 two-letter language code for the language in which this inspection plans descriptions and instructions are maintained. Supports multinational operations with localized shop floor documentation.. Valid values are `^[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the inspection plan record. Supports change tracking and ensures the silver layer reflects the latest SAP QM state.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `long_text` STRING COMMENT 'Free-text field containing detailed instructions, notes, or special requirements for executing this inspection plan. May include references to standard operating procedures (SOPs), safety precautions, or customer-specific directives.',
    `material_description` STRING COMMENT 'Human-readable description of the material or part governed by this inspection plan, as maintained in the SAP material master. Supports reporting and plan identification without requiring a material number lookup.',
    `material_number` STRING COMMENT 'SAP material master number identifying the part, component, or finished good to which this inspection plan applies. Links the plan to the product engineering and production domains.. Valid values are `^[A-Z0-9-]{1,18}$`',
    `measurement_equipment_type` STRING COMMENT 'Type of measurement or test equipment required to execute the inspection characteristics defined in this plan. Used for calibration scheduling and equipment reservation in Maximo EAM.. Valid values are `cmm|caliper|micrometer|gauge|spectrometer|hardness_tester|vision_system|coordinate_measuring|torque_wrench|other`',
    `operation_number` STRING COMMENT 'Production routing operation number (e.g., 0010, 0020) at which this inspection plan is executed. Ties the quality inspection to a specific step in the Bill of Process (BoP) or production order routing.. Valid values are `^[0-9]{4}$`',
    `plan_group` STRING COMMENT 'SAP QM plan group key that logically groups related inspection plans for the same material or process. Multiple plan group counters can exist within a single plan group.. Valid values are `^[A-Z0-9-]{1,8}$`',
    `plan_group_counter` STRING COMMENT 'Sequential counter within a plan group distinguishing alternative inspection plans (e.g., different sampling levels or customer-specific variants) for the same material.. Valid values are `^[0-9]{1,2}$`',
    `plan_number` STRING COMMENT 'Business-facing alphanumeric identifier for the inspection plan as assigned in SAP QM (transaction QP01). Used for cross-referencing with shop floor documents and quality records.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `plan_type` STRING COMMENT 'Classification of the inspection plan by the stage or trigger in the production and supply chain process. Determines when and where the inspection is executed (e.g., goods receipt from supplier, in-process at work center, final inspection before shipment, First Article Inspection).. Valid values are `goods_receipt|goods_issue|in_process|final_inspection|first_article|supplier_audit|customer_return|periodic_inspection`',
    `plant_code` STRING COMMENT 'SAP organizational unit code identifying the manufacturing plant or facility where this inspection plan is applicable. Supports multi-plant and multinational operations.. Valid values are `^[A-Z0-9]{1,4}$`',
    `ppap_level` STRING COMMENT 'PPAP submission level (1 through 5) required for this inspection plan, defining the extent of documentation and evidence that must be submitted to the customer for part approval. Level 3 is the default full submission.. Valid values are `^[1-5]$`',
    `revision_level` STRING COMMENT 'Alphanumeric revision identifier indicating the current version of the inspection plan. Incremented upon each approved Engineering Change Notice (ECN) or quality-driven update.. Valid values are `^[A-Z0-9]{1,3}$`',
    `rohs_reach_applicable` BOOLEAN COMMENT 'Indicates whether this inspection plan includes characteristics required to verify compliance with RoHS (Restriction of Hazardous Substances) and/or REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) regulations for the material.. Valid values are `true|false`',
    `sample_size` STRING COMMENT 'Fixed or calculated number of units to be drawn from an inspection lot for measurement and evaluation. May be overridden by dynamic sampling rules based on quality history.. Valid values are `^[0-9]{1,6}$`',
    `sample_size_unit` STRING COMMENT 'Unit of measure for the sample size (e.g., EA for each/piece, KG for kilogram, L for liter). Aligns with SAP base unit of measure for the material.. Valid values are `EA|KG|L|M|M2|M3|PC`',
    `sampling_procedure_code` STRING COMMENT 'Code referencing the statistical sampling procedure defined in SAP QM, specifying the sampling scheme (e.g., fixed sample, percentage, skip-lot) applied during inspection lot creation.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `skip_lot_enabled` BOOLEAN COMMENT 'Indicates whether skip-lot inspection is permitted for this plan, allowing certain lots to bypass full inspection based on a positive quality history. Governed by the dynamic modification rule.. Valid values are `true|false`',
    `spc_enabled` BOOLEAN COMMENT 'Indicates whether Statistical Process Control (SPC) charting and Cp/Cpk capability analysis are activated for the quantitative characteristics in this inspection plan. When true, measurement results feed SPC control charts.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current lifecycle status of the inspection plan. Only plans in released or active status are eligible to govern inspection lot execution in SAP QM and Siemens Opcenter MES.. Valid values are `draft|active|inactive|obsolete|under_review|released`',
    `supplier_code` STRING COMMENT 'SAP vendor/supplier code when this inspection plan is specifically applicable to incoming goods from a particular supplier. Enables supplier-specific quality control and PPAP compliance tracking.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `usage_decision_required` BOOLEAN COMMENT 'Indicates whether a formal usage decision (accept, reject, conditional release) must be recorded in SAP QM upon completion of the inspection lot governed by this plan. Mandatory for regulated or safety-critical materials.. Valid values are `true|false`',
    `work_center_code` STRING COMMENT 'Identifier of the SAP work center or Opcenter MES resource where the inspection is physically performed. Used for scheduling inspection capacity and assigning qualified inspectors.. Valid values are `^[A-Z0-9-]{1,8}$`',
    `valid_from` DATE COMMENT 'Date from which this inspection plan version is effective and may be used to govern inspection lot execution. Part of the plans validity period in SAP QM.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'Date after which this inspection plan version expires and must not be used for new inspection lots. Supports plan lifecycle management and ensures only current-revision plans are applied.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_inspection_plan PRIMARY KEY(`inspection_plan_id`)
) COMMENT 'Master definition of quality inspection plans specifying inspection characteristics, sampling methods, AQL levels, measurement techniques, and acceptance criteria for a given part, operation, or process stage. Sourced from SAP QM inspection plan master data. Serves as the template governing all inspection lot execution.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`inspection_lot` (
    `inspection_lot_id` BIGINT COMMENT 'Unique system-generated identifier for the inspection lot record. Serves as the primary key for all quality inspection events in the Quality Management System (QMS).',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Inspection lot for delivery - normalize by replacing delivery_number text with FK',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Inspection lots track which production equipment produced the batch being inspected. Quality teams reference equipment daily to trace defects to specific machines and trigger maintenance.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: An inspection lot is always governed by an inspection plan that defines the sampling method, AQL level, and characteristics to inspect. The inspection_plan_number and inspection_plan_version string fi',
    `logistics_inbound_delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.inbound_delivery. Business justification: Inspection lots are created for incoming material upon receipt. Each inbound delivery triggers inspection lot creation for receiving inspection before stock placement - standard QC workflow.',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Inspection lot for production order - normalize by replacing production_order_number text with FK',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Inspection lot for purchase order - normalize by replacing purchase_order_number text with FK',
    `accepted_quantity` DECIMAL(18,2) COMMENT 'Quantity of material within the inspection lot that passed inspection and was accepted for unrestricted use or further processing. Used for yield calculation and stock posting to unrestricted stock.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `batch_number` STRING COMMENT 'Manufacturing batch or lot number associated with the inspected material. Enables batch-level traceability, genealogy tracking, and recall management in compliance with regulatory requirements.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the inspected material was manufactured or sourced. Required for customs compliance, REACH/RoHS regulatory reporting, and trade documentation.. Valid values are `^[A-Z]{3}$`',
    `defects_found` STRING COMMENT 'Total count of defects or non-conformances identified during inspection of this lot. Used for PPM (Parts Per Million) defect rate calculation, SPC charting, and quality trend analysis.. Valid values are `^[0-9]+$`',
    `dynamic_modification_rule` STRING COMMENT 'SAP QM dynamic modification rule applied to this inspection lot, which adjusts the inspection scope (normal, tightened, reduced, skip) based on the supplier or process quality history. Supports risk-based inspection frequency management.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `inspection_end_date` DATE COMMENT 'Actual date on which all inspection activities and results recording were completed for this lot. Used to calculate inspection cycle time and identify bottlenecks in the quality process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_result_summary` STRING COMMENT 'Overall summarized outcome of all inspection characteristic results for the lot. Indicates whether the lot passed, failed, or was conditionally accepted based on the aggregate of individual characteristic evaluations.. Valid values are `accepted|rejected|conditionally_accepted|pending|partially_accepted`',
    `inspection_stage` STRING COMMENT 'Current inspection severity stage for this lot as determined by the dynamic modification rule. Reflects the quality history-based adjustment to inspection intensity: Normal, Tightened (stricter), Reduced (less frequent), or Skip (no inspection).. Valid values are `normal|tightened|reduced|skip`',
    `inspection_start_date` DATE COMMENT 'Planned or actual date on which physical inspection activities commenced for this lot. Used for scheduling, workload planning, and measuring inspection lead time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_type` STRING COMMENT 'SAP QM inspection type code defining the origin and nature of the inspection lot. Examples: 01 (Goods Receipt from Purchase Order), 04 (Goods Receipt from Production), 05 (Goods Issue), 06 (Delivery to Customer), 08 (Repetitive Manufacturing), 10 (Audit), 89 (Manual). Drives inspection plan selection and process flow.. Valid values are `01|04|05|06|08|09|10|11|12|13|14|15|89`',
    `inspection_type_description` STRING COMMENT 'Human-readable description of the inspection type code, such as Goods Receipt from Purchase Order or In-Process Inspection. Supports reporting and user interface display.',
    `is_first_article_inspection` BOOLEAN COMMENT 'Indicates whether this inspection lot represents a First Article Inspection (FAI) event, typically performed on the first production run of a new or revised part. FAI lots require full dimensional and functional verification per PPAP requirements.. Valid values are `true|false`',
    `lot_created_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection lot was created in SAP QM, either automatically triggered by a business event (e.g., goods receipt, production order confirmation) or manually by a quality user.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lot_number` STRING COMMENT 'Business-facing alphanumeric identifier for the inspection lot as displayed in SAP QM. Used for cross-referencing with production orders, goods receipts, and quality notifications.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `lot_origin` STRING COMMENT 'Business process that triggered the creation of the inspection lot. Identifies whether the lot originated from a production order, goods receipt, customer delivery, manual creation, or other source. Critical for traceability and root cause analysis.. Valid values are `production_order|purchase_order|goods_receipt|delivery|manual|repetitive_manufacturing|returns|audit|in_process`',
    `lot_quantity` DECIMAL(18,2) COMMENT 'Total quantity of material submitted for inspection in this lot. Expressed in the base unit of measure of the material. Used for AQL sampling plan determination and yield calculations.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `material_description` STRING COMMENT 'Short text description of the material or component being inspected, as maintained in the SAP material master. Supports readability in quality reports and dashboards.',
    `material_number` STRING COMMENT 'SAP material master number identifying the product or component subject to inspection. Used to retrieve the applicable inspection plan, specification limits, and quality history.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `ncr_number` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) raised against this inspection lot when nonconformances are identified. Links the inspection lot to the formal NCR and CAPA workflow for corrective action tracking.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `nonconforming_quantity` DECIMAL(18,2) COMMENT 'Quantity of material within the inspection lot that was found to be nonconforming and not accepted for unrestricted use. Drives scrap rate and yield calculations at the lot level.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site where the inspection lot was created and executed. Enables plant-level quality performance analysis and multi-site benchmarking.. Valid values are `^[A-Z0-9]{1,4}$`',
    `rework_quantity` DECIMAL(18,2) COMMENT 'Quantity of material within the inspection lot that requires rework before it can be accepted for use. Drives rework cost tracking, capacity planning, and quality cost analysis.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `sample_size` DECIMAL(18,2) COMMENT 'Actual quantity drawn from the inspection lot for physical inspection and testing, as determined by the AQL sampling plan or dynamic modification rule. May differ from the lot quantity.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `scrap_quantity` DECIMAL(18,2) COMMENT 'Quantity of material within the inspection lot that was scrapped due to nonconformance and cannot be reworked or used. Feeds into scrap rate KPI and COGS impact reporting.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `status` STRING COMMENT 'Current processing status of the inspection lot within the SAP QM workflow. Tracks progression from lot creation through results recording to usage decision and completion. Drives downstream stock posting and release actions.. Valid values are `created|in_inspection|results_recorded|usage_decision_made|completed|cancelled`',
    `storage_location` STRING COMMENT 'SAP storage location within the plant where the inspected material is physically held during the inspection process. Relevant for stock posting and usage decision execution.. Valid values are `^[A-Z0-9]{1,4}$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the inspection lot quantity (e.g., EA for each, KG for kilogram, M for meter, L for liter). Aligns with SAP material master unit of measure configuration.. Valid values are `^[A-Z]{1,6}$`',
    `usage_decision_by` STRING COMMENT 'User ID or name of the quality inspector or quality engineer who made the final usage decision for the inspection lot. Required for accountability, audit trail, and regulatory compliance.',
    `usage_decision_code` STRING COMMENT 'SAP QM usage decision code indicating the final disposition of the inspected material (e.g., A=Accept/Unrestricted Use, R=Reject/Scrap, B=Rework, Q=Blocked Stock, S=Sample Retention). Triggers automatic stock posting in SAP MM.. Valid values are `^[A-Z0-9]{1,4}$`',
    `usage_decision_description` STRING COMMENT 'Human-readable description of the usage decision code, such as Accept - Unrestricted Use, Reject - Scrap, or Conditional Release - Rework Required. Supports quality reporting and disposition documentation.',
    `usage_decision_timestamp` TIMESTAMP COMMENT 'Date and time when the usage decision was made and recorded in SAP QM. Critical for measuring inspection cycle time, SLA compliance, and audit trail requirements under ISO 9001.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `vendor_name` STRING COMMENT 'Name of the external supplier or vendor associated with the inspection lot for incoming goods receipt inspections. Supports supplier quality management reporting without requiring a join to the vendor master.',
    `vendor_number` STRING COMMENT 'SAP vendor/supplier number associated with the inspection lot when the origin is a goods receipt from a purchase order. Enables supplier quality performance tracking, PPM analysis, and vendor scorecard reporting.. Valid values are `^[A-Z0-9]{1,10}$`',
    `work_center` STRING COMMENT 'SAP work center or production cell where the in-process inspection was performed. Enables quality performance analysis at the machine, line, or cell level for SPC and process capability monitoring.. Valid values are `^[A-Z0-9-]{1,10}$`',
    CONSTRAINT pk_inspection_lot PRIMARY KEY(`inspection_lot_id`)
) COMMENT 'Transactional record of a quality inspection event triggered by a production order, goods receipt, or delivery. Captures lot origin, inspection type, quantity, status, usage decision, and results summary. Core operational entity in SAP QM representing each discrete inspection execution instance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`inspection_result` (
    `inspection_result_id` BIGINT COMMENT 'Unique system-generated identifier for each individual inspection result record captured during inspection lot execution.',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.quality_characteristic. Business justification: Each inspection result captures a measurement for a specific quality characteristic (CTQ). The characteristic_code and characteristic_name string fields are redundant once the FK to quality_characteri',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: When an inspection result identifies a defect, it references a standardized defect classification code. The defect_code and defect_description string fields are redundant once the FK to the defect_cod',
    `employee_id` BIGINT COMMENT 'Employee identifier of the quality inspector who performed the measurement and recorded this result. Supports inspector sign-off traceability and audit requirements.',
    `gauge_id` BIGINT COMMENT 'Identifier of the measurement instrument or gauge used to capture this result, enabling traceability to calibration records and Measurement System Analysis (MSA) studies.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Inspection results are child records of an inspection lot — each measured characteristic result belongs to a specific lot execution. The inspection_lot_number string field is redundant once the FK is ',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Inspection result for production order - normalize by replacing production_order_number text with FK',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Automated inspection results come from OT systems (vision systems, CMMs, inline gauges). Manufacturing tracks which OT system generated each result for traceability, calibration correlation, and syste',
    `aql_level` STRING COMMENT 'The Acceptable Quality Level (AQL) applied to this inspection, defining the maximum acceptable defect rate (e.g., 0.65, 1.0, 2.5, 4.0). Determines the sampling plan stringency.',
    `attribute_result` STRING COMMENT 'Pass/fail conformance result for attribute-type characteristics (e.g., visual inspection, go/no-go gauge). Null for variable characteristics where measured_value is used.. Valid values are `pass|fail|not_applicable`',
    `batch_number` STRING COMMENT 'Production batch or lot number of the material being inspected, enabling full batch traceability for quality results and potential recall scenarios.',
    `characteristic_type` STRING COMMENT 'Classification of the characteristic as variable (measured numeric value), attribute (pass/fail conformance), or count (number of defects). Drives the applicable SPC methodology.. Valid values are `variable|attribute|count`',
    `conformance_decision` STRING COMMENT 'The quality conformance decision for this individual characteristic result: accepted (within spec), rejected (out of spec), conditional accept (use-as-is disposition), rework required, scrap, or pending review.. Valid values are `accepted|rejected|conditional_accept|rework_required|scrap|pending`',
    `cp_index` DECIMAL(18,2) COMMENT 'Process Capability Index (Cp) for this characteristic, measuring the ratio of the specification width to the process spread (6 sigma). Indicates potential process capability without centering.',
    `cpk_index` DECIMAL(18,2) COMMENT 'Process Capability Index Centered (Cpk) for this characteristic, measuring actual process capability accounting for process centering relative to specification limits. Key Six Sigma metric.',
    `inspection_category` STRING COMMENT 'Category of inspection at which this result was captured: incoming goods inspection, in-process (shop floor), final inspection, First Article Inspection (FAI), audit, supplier, or customer return.. Valid values are `incoming|in_process|final|first_article|audit|supplier|customer_return`',
    `inspection_operation_number` STRING COMMENT 'Operation or step number within the inspection plan at which this characteristic was measured, aligning to the inspection plan structure in SAP QM.',
    `inspection_stage` STRING COMMENT 'Production stage at which the inspection was performed, enabling traceability of quality results across the manufacturing value stream.. Valid values are `receiving|pre_production|in_process|post_process|final|shipping`',
    `inspection_timestamp` TIMESTAMP COMMENT 'Date and time when the measurement was physically taken and recorded, in ISO 8601 format. Critical for SPC time-series analysis and traceability.',
    `inspector_name` STRING COMMENT 'Full name of the quality inspector who performed the measurement. Retained for audit trail and regulatory compliance purposes.',
    `lower_control_limit` DECIMAL(18,2) COMMENT 'Statistical Process Control (SPC) lower control limit for the characteristic, calculated from process data (typically mean - 3 sigma). Triggers SPC alerts when breached.',
    `lower_spec_limit` DECIMAL(18,2) COMMENT 'The minimum allowable value for the characteristic as defined in the engineering specification or drawing. Used for conformance determination and Cp/Cpk calculation.',
    `material_number` STRING COMMENT 'SAP material number or part number of the product or component being inspected. Enables quality performance analysis by material/SKU.',
    `measured_value` DECIMAL(18,2) COMMENT 'Actual numeric measurement recorded for a variable characteristic during inspection (e.g., 24.987 mm). Null for attribute-type characteristics.',
    `measurement_method` STRING COMMENT 'Method or technique used to obtain the measurement (e.g., CMM, caliper, micrometer, optical comparator, hardness tester, visual, go/no-go gauge). Supports Measurement System Analysis (MSA).',
    `ncr_number` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) raised as a result of this failed inspection result. Null if the result is conforming. Links quality results to the NCR/CAPA workflow.',
    `nominal_value` DECIMAL(18,2) COMMENT 'The engineering design target or nominal value for the characteristic as specified in the drawing or inspection plan.',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where the inspection was performed. Supports multi-site quality performance benchmarking.',
    `retest_flag` BOOLEAN COMMENT 'Indicates whether this result is a retest measurement taken after a previous failed or inconclusive result for the same characteristic on the same sample.. Valid values are `true|false`',
    `retest_sequence` STRING COMMENT 'Sequential number indicating which retest attempt this result represents (1 = first retest, 2 = second retest, etc.). Value is 0 for the original measurement.',
    `sample_number` STRING COMMENT 'Sequential number of this individual sample or specimen within the inspection lot sample set, enabling traceability to specific physical units measured.',
    `sample_size` STRING COMMENT 'Number of units or specimens included in the sample for this characteristic measurement, as defined by the sampling plan (AQL-based or fixed).',
    `serial_number` STRING COMMENT 'Serial number of the specific unit being inspected, where serialized traceability is required (e.g., safety-critical components, high-value assemblies).',
    `sign_off_timestamp` TIMESTAMP COMMENT 'Date and time when the inspector formally signed off on this inspection result, confirming the measurement is complete and the conformance decision is final.',
    `spc_rule_violated` STRING COMMENT 'Identifies the specific SPC rule that was violated (e.g., Rule 1: Point beyond 3-sigma, Rule 2: 9 consecutive points same side, Rule 4: 14 alternating points). Null if no violation.',
    `spc_violation_flag` BOOLEAN COMMENT 'Indicates whether this measurement triggered an SPC rule violation (e.g., Western Electric rules, Nelson rules) such as a point beyond control limits or a run of consecutive points on one side of the mean.. Valid values are `true|false`',
    `unit_of_measure` STRING COMMENT 'Engineering unit of the measured value (e.g., mm, kg, MPa, Ra, °C). Follows ISO 80000 standard units of measurement.',
    `upper_control_limit` DECIMAL(18,2) COMMENT 'Statistical Process Control (SPC) upper control limit for the characteristic, calculated from process data (typically mean + 3 sigma). Triggers SPC alerts when exceeded.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'The maximum allowable value for the characteristic as defined in the engineering specification or drawing. Used for conformance determination and Cp/Cpk calculation.',
    `work_center_code` STRING COMMENT 'Code of the production work center or inspection station where the measurement was taken, enabling quality performance analysis at the work center level.',
    CONSTRAINT pk_inspection_result PRIMARY KEY(`inspection_result_id`)
) COMMENT 'Detailed measurement and characteristic result records captured during inspection lot execution. Stores individual measured values, attribute conformance decisions, SPC data points, Cp/Cpk indices per characteristic, and inspector sign-off. Enables traceability from lot to individual measurement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`usage_decision` (
    `usage_decision_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a single usage decision record within the Quality Management System. Serves as the primary key for the usage_decision data product.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Usage decisions (accept/reject/rework) require authorized employee approval for material disposition. Critical for regulatory compliance and traceability in manufacturing quality systems.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: A usage decision is formally made at the conclusion of an inspection lot — it is the disposition record for that lot (accept, reject, conditional release). The inspection_lot_number string field is re',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Usage decision for production order - normalize by replacing production_order_number text with FK',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Usage decision for purchase order - normalize by replacing purchase_order_number text with FK',
    `accepted_quantity` DECIMAL(18,2) COMMENT 'Quantity of material from the inspection lot that is accepted and posted to unrestricted-use stock following the usage decision. May be less than the total inspection quantity when partial acceptance or split posting is applied.. Valid values are `^d+(.d{1,4})?$`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time at which the secondary approval for the usage decision was granted. Used for approval cycle time measurement and audit trail documentation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the quality manager or authorized approver who provided secondary approval for the usage decision, when requires_approval is true. Supports segregation of duties and audit trail compliance.',
    `batch_number` STRING COMMENT 'The production or supplier batch number associated with the inspection lot. Enables batch-level traceability of the usage decision, supporting recall management, genealogy tracking, and regulatory compliance.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `comments` STRING COMMENT 'Free-text field for the quality engineer to record additional observations, justifications, or contextual notes related to the usage decision. Supports audit trail documentation and provides qualitative context not captured by structured fields.',
    `conditional_release_conditions` STRING COMMENT 'Free-text description of the specific conditions, restrictions, or requirements that must be met for material released under a conditional usage decision to be used in production or shipped to customers. Applicable only when decision_category is conditional_release.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the usage decision was made. Supports multi-country regulatory compliance reporting (e.g., CE Marking, RoHS/REACH, FDA) and regional quality performance analytics.. Valid values are `^[A-Z]{3}$`',
    `decision_category` STRING COMMENT 'High-level classification of the usage decision outcome used for reporting and analytics. Maps multiple decision codes to a standardized category for cross-plant and cross-material quality performance analysis.. Valid values are `accept|reject|conditional_release|scrap|rework|return_to_supplier`',
    `decision_code` STRING COMMENT 'Standardized quality decision code assigned at the conclusion of the inspection lot, representing the formal disposition outcome (e.g., A=Accept, R=Reject, C=Conditional Release, S=Scrap). Drives downstream stock posting in SAP QM.. Valid values are `^[A-Z0-9]{1,4}$`',
    `decision_date` DATE COMMENT 'The calendar date on which the formal usage decision was made and recorded in the Quality Management System. Used for cycle time analysis, compliance reporting, and inspection lot closure tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `decision_description` STRING COMMENT 'Human-readable description of the usage decision code, providing context for the disposition outcome (e.g., Accepted — All characteristics within specification, Rejected — Critical defect found).',
    `decision_reversal_reason` STRING COMMENT 'Free-text explanation provided when a previously made usage decision is reversed or overturned. Documents the business justification for the reversal, supporting audit trail and corrective action analysis.',
    `decision_status` STRING COMMENT 'Current lifecycle status of the usage decision record. Tracks whether the decision is still open (inspection lot not yet closed), under review, formally decided, reversed (decision overturned), or cancelled.. Valid values are `open|in_review|decided|reversed|cancelled`',
    `decision_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone offset) at which the usage decision was recorded in the system. Supports audit trail requirements and precise cycle time measurement from inspection lot creation to decision closure.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `defect_code` STRING COMMENT 'Primary defect classification code associated with the usage decision when the outcome is a rejection or conditional release. Drawn from the standardized defect catalog and used for Pareto analysis, FMEA updates, and CAPA initiation.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `defect_description` STRING COMMENT 'Textual description of the primary defect or nonconformance identified during inspection that influenced the usage decision. Provides qualitative context for the defect code and supports root cause analysis.',
    `inspection_lot_created_date` DATE COMMENT 'The date on which the inspection lot was originally created in SAP QM. Combined with decision_date, enables calculation of inspection cycle time (time from lot creation to usage decision), a key quality process KPI.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_lot_origin` STRING COMMENT 'The business process that triggered the creation of the inspection lot subject to this usage decision. Indicates whether the inspection arose from a goods receipt, production order completion, outbound delivery, customer complaint, or other quality event.. Valid values are `goods_receipt|production_order|delivery|customer_complaint|audit|periodic_inspection|first_article|returns`',
    `inspection_quantity` DECIMAL(18,2) COMMENT 'Total quantity of material submitted for inspection in the inspection lot, expressed in the base unit of measure. Represents the full lot size against which the usage decision is applied.. Valid values are `^d+(.d{1,4})?$`',
    `inspection_type` STRING COMMENT 'Classification of the inspection stage at which the usage decision is made. Distinguishes between incoming goods inspection, in-process inspection, final inspection, First Article Inspection (FAI), and other inspection categories.. Valid values are `incoming|in_process|final|first_article|periodic|audit|customer_return|supplier_return`',
    `material_description` STRING COMMENT 'Short descriptive name of the material or component under inspection, as maintained in the SAP material master. Provides human-readable context for the usage decision record without requiring a join to the material master.',
    `material_number` STRING COMMENT 'The SAP material master number identifying the material or component subject to the inspection lot and usage decision. Enables traceability from quality decision back to the material master and Bill of Materials (BOM).. Valid values are `^[A-Z0-9-]{1,40}$`',
    `ncr_number` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) raised in association with this usage decision, applicable when the decision results in a rejection or conditional release. Links the usage decision to the formal nonconformance management workflow.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or storage facility where the inspection lot was created and the usage decision was made. Supports multi-plant quality performance reporting and regional compliance tracking.. Valid values are `^[A-Z0-9]{1,4}$`',
    `quality_score` DECIMAL(18,2) COMMENT 'Numeric quality score (0–100) assigned to the inspection lot at the time of the usage decision, reflecting the overall conformance level of the inspected material. Derived from inspection results and used for supplier quality scorecards and trend analysis.. Valid values are `^(100(.00?)?|d{1,2}(.d{1,2})?)$`',
    `quantity_unit_of_measure` STRING COMMENT 'The unit of measure (UoM) applicable to all quantity fields on the usage decision (inspection_quantity, accepted_quantity, rejected_quantity, scrap_quantity). Examples: EA (each), KG (kilogram), M (meter), L (liter).. Valid values are `^[A-Z]{2,5}$`',
    `regulatory_hold` BOOLEAN COMMENT 'Indicates whether the material subject to this usage decision is placed under a regulatory hold (e.g., due to RoHS/REACH non-compliance, CE Marking failure, or FDA regulatory action). When true, stock posting is blocked pending regulatory clearance.. Valid values are `true|false`',
    `rejected_quantity` DECIMAL(18,2) COMMENT 'Quantity of material from the inspection lot that is rejected and posted to blocked stock or returned to supplier following the usage decision. Drives downstream NCR creation and disposition workflows.. Valid values are `^d+(.d{1,4})?$`',
    `requires_approval` BOOLEAN COMMENT 'Indicates whether the usage decision requires a secondary approval from a quality manager or designated authority before it becomes effective. Applicable for high-risk materials, critical components, or decisions involving conditional release.. Valid values are `true|false`',
    `responsible_quality_engineer` STRING COMMENT 'Name or employee identifier of the quality engineer who made and recorded the formal usage decision. Establishes accountability and supports audit trail requirements under ISO 9001 and regulatory frameworks.',
    `scrap_quantity` DECIMAL(18,2) COMMENT 'Quantity of material from the inspection lot that is designated for scrapping as part of the usage decision disposition. Used for scrap rate calculation and cost of poor quality (COPQ) reporting.. Valid values are `^d+(.d{1,4})?$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which the usage decision record was sourced. Supports data lineage tracking in the Databricks Silver Layer lakehouse and enables reconciliation between systems.. Valid values are `SAP_QM|OPCENTER_MES|MANUAL|TEAMCENTER`',
    `stock_posting_instruction` STRING COMMENT 'The inventory posting instruction generated by the usage decision, directing SAP MM to transfer stock from quality inspection stock to the appropriate stock category (e.g., unrestricted, blocked, scrap). This is the primary downstream trigger for inventory movement in SAP QM.. Valid values are `unrestricted|blocked|scrap|return_to_vendor|rework|conditional_release|quality_stock`',
    `stock_posting_status` STRING COMMENT 'Current execution status of the stock posting instruction associated with the usage decision. Indicates whether the inventory transfer triggered by the decision has been successfully posted in SAP MM or is pending/failed.. Valid values are `pending|posted|failed|not_required`',
    `storage_location` STRING COMMENT 'SAP storage location within the plant where the inspected stock resides. Used to determine the source location for stock posting instructions triggered by the usage decision (e.g., transfer from quality inspection stock to unrestricted or blocked stock).. Valid values are `^[A-Z0-9]{1,4}$`',
    `vendor_number` STRING COMMENT 'SAP vendor/supplier number associated with the inspected material, applicable when the inspection lot originates from a goods receipt against a purchase order. Enables supplier quality performance tracking and scorecard reporting.. Valid values are `^[A-Z0-9-]{1,10}$`',
    CONSTRAINT pk_usage_decision PRIMARY KEY(`usage_decision_id`)
) COMMENT 'Records the formal quality usage decision made at the conclusion of an inspection lot — accept, reject, conditional release, or scrap. Captures decision code, decision date, responsible quality engineer, stock posting instruction, and any associated NCR reference. Drives downstream inventory posting in SAP QM.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`quality_capa` (
    `quality_capa_id` BIGINT COMMENT 'Unique system-generated identifier for the CAPA record within the Quality Management System.',
    `capa_record_id` BIGINT COMMENT 'Foreign key linking to compliance.capa_record. Business justification: Quality CAPAs often originate from compliance audit findings or regulatory requirements. Manufacturing facilities track which quality improvement actions address specific compliance obligations for re',
    `ecn_id` BIGINT COMMENT 'Foreign key linking to engineering.ecn. Business justification: Corrective actions often require engineering changes to resolve quality issues. CAPA systems link to ECNs when design modifications are needed to prevent recurrence.',
    `eco_id` BIGINT COMMENT 'Foreign key linking to engineering.eco. Business justification: CAPA corrective actions may trigger engineering change orders to implement design improvements. Quality teams track ECO implementation as part of CAPA closure verification.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Corrective actions often target equipment causing quality issues. CAPA teams implement equipment modifications, maintenance improvements, or replacements to eliminate root causes of defects.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Corrective action projects often use internal orders to track and budget quality improvement costs separately from production operations.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Corrective/Preventive Actions require an assigned owner employee responsible for implementation and closure. Core requirement of ISO 9001 quality management systems.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: CAPA (Corrective Action Preventive Action) may require design changes handled through R&D projects. Quality teams link CAPA to R&D projects when root cause analysis identifies design deficiencies requ',
    `action_owner` STRING COMMENT 'Name or employee ID of the individual responsible for implementing the corrective or preventive action and ensuring timely closure of the CAPA.',
    `action_owner_department` STRING COMMENT 'Department or organizational unit of the CAPA action owner, used for workload distribution, escalation routing, and departmental quality performance reporting.',
    `actual_closure_date` DATE COMMENT 'Date on which the CAPA was formally closed after successful verification of effectiveness, used to measure cycle time and on-time closure performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `affected_part_description` STRING COMMENT 'Human-readable description of the affected part, component, or material to provide context without requiring a lookup.',
    `affected_part_number` STRING COMMENT 'Part number or SKU of the product, component, or material directly affected by the nonconformance or quality issue.',
    `affected_process` STRING COMMENT 'Name or code of the manufacturing process, work center, or production stage where the nonconformance was identified or originated.',
    `approved_by` STRING COMMENT 'Name or employee ID of the quality manager or authorized approver who reviewed and formally approved the CAPA record and action plan.',
    `approved_date` DATE COMMENT 'Date on which the CAPA record and corrective action plan were formally approved by the authorized quality manager.. Valid values are `^d{4}-d{2}-d{2}$`',
    `corrective_action_description` STRING COMMENT 'Detailed description of the corrective or preventive actions planned and implemented to eliminate the root cause and prevent recurrence of the nonconformance.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the CAPA originated, supporting multinational regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `customer_notification_required` BOOLEAN COMMENT 'Indicates whether the customer must be formally notified of the nonconformance and the corrective actions taken, as required by customer-specific requirements or SLA agreements.. Valid values are `true|false`',
    `customer_notified_date` DATE COMMENT 'Date on which the customer was formally notified of the nonconformance and the corrective actions being taken.. Valid values are `^d{4}-d{2}-d{2}$`',
    `defect_category` STRING COMMENT 'Classification of the defect or nonconformance type to enable trend analysis and targeted corrective actions across the quality management system.. Valid values are `dimensional|functional|cosmetic|material|process|documentation|safety|environmental|labeling|packaging`',
    `effectiveness_rating` STRING COMMENT 'Formal assessment of whether the implemented corrective or preventive action successfully eliminated the root cause and prevented recurrence of the nonconformance.. Valid values are `effective|partially_effective|not_effective|pending_verification`',
    `immediate_containment_action` STRING COMMENT 'Description of the short-term containment actions taken to prevent further nonconforming product from reaching the customer or next process stage while the root cause is investigated.',
    `initiated_by` STRING COMMENT 'Name or employee ID of the person who initiated and raised the CAPA record in the Quality Management System.',
    `initiated_date` DATE COMMENT 'Date on which the CAPA was formally initiated and entered into the Quality Management System.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the CAPA record, supporting audit trail requirements and change tracking for ISO 9001 compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `number` STRING COMMENT 'Human-readable business reference number for the CAPA record, used in communications, reports, and audit trails. Follows the format CAPA-YYYY-NNNNNN.. Valid values are `^CAPA-[0-9]{4}-[0-9]{6}$`',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where the CAPA originated, supporting multi-site quality management and regional reporting.',
    `priority` STRING COMMENT 'Business priority level assigned to the CAPA based on risk severity, customer impact, regulatory exposure, or recurrence frequency.. Valid values are `critical|high|medium|low`',
    `problem_statement` STRING COMMENT 'Detailed description of the quality problem, nonconformance, or potential risk being addressed, including what, where, when, and extent of the issue.',
    `recurrence_capa_number` STRING COMMENT 'Reference number of the new CAPA raised if the original nonconformance recurred, enabling traceability of recurring quality issues and escalation chains.. Valid values are `^CAPA-[0-9]{4}-[0-9]{6}$`',
    `recurrence_flag` BOOLEAN COMMENT 'Indicates whether the same or similar nonconformance has recurred after the CAPA was closed, triggering escalation and re-opening of the quality action.. Valid values are `true|false`',
    `regulatory_body` STRING COMMENT 'Name of the regulatory authority or certification body to which the nonconformance must be reported (e.g., OSHA, EPA, UL, CE, RoHS authority).',
    `regulatory_reporting_required` BOOLEAN COMMENT 'Indicates whether the nonconformance or corrective action requires formal notification to a regulatory body such as OSHA, EPA, or a product certification authority.. Valid values are `true|false`',
    `revised_closure_date` DATE COMMENT 'Updated target closure date if the original target was extended due to complexity, resource constraints, or scope changes, with justification tracked separately.. Valid values are `^d{4}-d{2}-d{2}$`',
    `root_cause_category` STRING COMMENT 'Categorization of the root cause using the 6M Ishikawa framework: Man, Machine, Material, Method, Measurement, or Environment, enabling systemic trend analysis.. Valid values are `man|machine|material|method|measurement|environment|management`',
    `root_cause_description` STRING COMMENT 'Detailed narrative of the identified root cause(s) of the nonconformance as determined through the root cause analysis methodology.',
    `root_cause_method` STRING COMMENT 'Methodology used to identify the root cause of the nonconformance, such as 5-Why analysis, Ishikawa (fishbone) diagram, Fault Tree Analysis, or 8D problem solving.. Valid values are `5_why|ishikawa|fault_tree|8d|pareto|fmea|brainstorming|other`',
    `source_reference_number` STRING COMMENT 'Reference number of the originating document or record that triggered the CAPA (e.g., NCR number, audit finding ID, customer complaint number).',
    `source_type` STRING COMMENT 'Identifies the originating trigger for the CAPA, such as a Non-Conformance Report (NCR), customer complaint, audit finding, Statistical Process Control (SPC) alert, supplier defect, or field failure.. Valid values are `ncr|customer_complaint|audit_finding|spc_alert|supplier_defect|field_failure|internal_observation|regulatory_finding|ppap_rejection|fai_failure`',
    `status` STRING COMMENT 'Current workflow status of the CAPA record, tracking progression from initiation through root cause analysis, action planning, implementation, verification, and closure.. Valid values are `draft|open|root_cause_analysis|action_planning|implementation|verification|closed|cancelled`',
    `target_closure_date` DATE COMMENT 'Planned date by which all corrective or preventive actions must be implemented and the CAPA formally closed, used for SLA tracking and escalation management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `title` STRING COMMENT 'Short descriptive title summarizing the nonconformance or quality issue that triggered the CAPA.',
    `type` STRING COMMENT 'Classifies the action as corrective (addressing an existing nonconformance), preventive (addressing a potential nonconformance), or improvement (proactive quality enhancement).. Valid values are `corrective|preventive|improvement`',
    `verification_date` DATE COMMENT 'Date on which the effectiveness of the corrective or preventive action was formally verified and documented.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verification_evidence` STRING COMMENT 'Description or reference to objective evidence (inspection records, audit results, SPC charts, production data) demonstrating the effectiveness of the implemented actions.',
    `verification_method` STRING COMMENT 'Method used to verify that the implemented corrective or preventive action was effective in eliminating the root cause and preventing recurrence.. Valid values are `inspection|audit|spc_monitoring|process_validation|customer_feedback|production_run|document_review|other`',
    `verified_by` STRING COMMENT 'Name or employee ID of the quality engineer or auditor who performed and approved the effectiveness verification of the CAPA.',
    CONSTRAINT pk_quality_capa PRIMARY KEY(`quality_capa_id`)
) COMMENT 'Corrective and Preventive Action (CAPA) record managing the full workflow from root cause analysis through action implementation and effectiveness verification. Tracks problem statement, root cause method (5-Why, Ishikawa), assigned owner, target closure date, verification evidence, and recurrence status. Supports ISO 9001 Clause 10.2 compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`fmea` (
    `fmea_id` BIGINT COMMENT 'Unique system-generated identifier for the FMEA record within the Quality Management System.',
    `hazard_assessment_id` BIGINT COMMENT 'Foreign key linking to hse.hazard_assessment. Business justification: Process FMEAs identify failure modes with safety consequences requiring formal hazard assessments. Quality engineers link FMEAs to HSE hazard assessments when process risks have worker safety or envir',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: FMEA studies require a designated lead engineer to coordinate cross-functional team analysis. Standard practice in APQP and product development quality processes.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: DFMEA (Design FMEA) is created during R&D projects as part of APQP process. Quality engineers reference the R&D project to track design risk analysis throughout product development lifecycle.',
    `action_completed_date` DATE COMMENT 'Actual date on which the recommended action was completed and evidence of implementation was recorded.. Valid values are `^d{4}-d{2}-d{2}$`',
    `action_priority` STRING COMMENT 'Action Priority classification (High/Medium/Low) per the AIAG-VDA 2019 methodology, providing a structured risk prioritization that complements or replaces the traditional RPN threshold approach.. Valid values are `H|M|L`',
    `action_responsibility` STRING COMMENT 'Name or role of the person or team responsible for implementing the recommended action.',
    `action_target_date` DATE COMMENT 'Target date by which the recommended action must be completed and verified, used for tracking open action items.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or role of the authorized approver (e.g., Quality Manager, Chief Engineer) who formally approved the FMEA for release.',
    `approved_date` DATE COMMENT 'Date on which the FMEA document was formally approved and released for use in production or design activities.. Valid values are `^d{4}-d{2}-d{2}$`',
    `design_stage` STRING COMMENT 'Product development stage at which this FMEA was created or last updated, aligned with the Advanced Product Quality Planning (APQP) phase gate process.. Valid values are `concept|preliminary_design|detailed_design|prototype|production|post_production`',
    `detection_control` STRING COMMENT 'Description of existing controls used to detect the failure cause or failure mode before the product reaches the customer or the next process step (e.g., inspection, SPC, testing).',
    `detection_rating` STRING COMMENT 'Numeric rating (1–10) assessing the ability of current controls to detect the failure cause or failure mode before the item reaches the customer. A rating of 10 indicates no detection capability.. Valid values are `^([1-9]|10)$`',
    `failure_cause` STRING COMMENT 'Root cause or mechanism by which the failure mode could occur, used to identify targeted prevention and detection controls.',
    `failure_effect` STRING COMMENT 'Description of the consequence of the failure mode on the customer, end user, downstream process, or system performance.',
    `failure_mode` STRING COMMENT 'Description of the manner in which the item or process could potentially fail to meet the design intent or process requirement.',
    `function` STRING COMMENT 'Description of the intended function or purpose of the item or process step being analyzed, forming the basis for failure mode identification.',
    `initiated_date` DATE COMMENT 'Date on which the FMEA study was formally initiated, used for tracking analysis lead time and APQP milestone compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `item_name` STRING COMMENT 'Name of the product, component, subsystem, or process step that is the subject of this FMEA analysis.',
    `item_number` STRING COMMENT 'Engineering part number or process identifier associated with the item being analyzed, as maintained in the PLM or ERP system.',
    `last_reviewed_date` DATE COMMENT 'Date of the most recent formal review of the FMEA, required periodically or following engineering changes, quality escapes, or field failures.. Valid values are `^d{4}-d{2}-d{2}$`',
    `model_year_applicability` STRING COMMENT 'Model year(s) or product generation(s) to which this FMEA analysis applies, supporting traceability across product lifecycle changes.',
    `number` STRING COMMENT 'Human-readable business reference number for the FMEA document, used for cross-referencing in engineering and quality documentation.. Valid values are `^FMEA-[A-Z]{2,6}-[0-9]{4,8}$`',
    `occurrence_rating` STRING COMMENT 'Numeric rating (1–10) estimating the likelihood or frequency with which the failure cause will occur during the design life or process run.. Valid values are `^([1-9]|10)$`',
    `prepared_by` STRING COMMENT 'Name or employee identifier of the quality or engineering professional who authored and prepared the FMEA document.',
    `prevention_control` STRING COMMENT 'Description of existing design or process controls that prevent the failure cause or failure mode from occurring (e.g., design standards, process parameters, mistake-proofing / Poka-Yoke).',
    `process_step` STRING COMMENT 'For PFMEA records, the specific manufacturing process step or operation (e.g., welding, assembly, machining) where the failure mode can occur, aligned with the Bill of Process (BoP).',
    `recommended_action` STRING COMMENT 'Proposed corrective or preventive action to reduce severity, occurrence, or detection ratings and lower the overall risk of the failure mode.',
    `regulatory_impact_flag` BOOLEAN COMMENT 'Indicates whether the failure mode has potential regulatory or compliance implications (e.g., CE Marking, RoHS, REACH, UL certification requirements).. Valid values are `true|false`',
    `revised_action_priority` STRING COMMENT 'Updated Action Priority classification (High/Medium/Low) after mitigation actions have been implemented, confirming whether residual risk is acceptable.. Valid values are `H|M|L`',
    `revised_detection_rating` STRING COMMENT 'Updated detection rating after implementation of recommended actions, reflecting improvements in detection controls.. Valid values are `^([1-9]|10)$`',
    `revised_occurrence_rating` STRING COMMENT 'Updated occurrence rating after implementation of recommended actions, reflecting improvements in prevention controls.. Valid values are `^([1-9]|10)$`',
    `revised_rpn` STRING COMMENT 'Recalculated Risk Priority Number (Revised S × Revised O × Revised D) after mitigation actions have been implemented, used to confirm risk reduction effectiveness.. Valid values are `^([1-9][0-9]{0,2}|1000)$`',
    `revised_severity_rating` STRING COMMENT 'Updated severity rating after implementation of recommended actions, reflecting any design changes that reduce the impact of the failure effect.. Valid values are `^([1-9]|10)$`',
    `revision` STRING COMMENT 'Revision or version identifier of the FMEA document, incremented each time the analysis is formally updated following an engineering change or corrective action.. Valid values are `^[A-Z0-9]{1,5}$`',
    `rpn` STRING COMMENT 'Risk Priority Number calculated as Severity × Occurrence × Detection (range 1–1000). Used to prioritize failure modes for corrective action. Note: AIAG-VDA 2019 supplements RPN with Action Priority (AP).. Valid values are `^([1-9][0-9]{0,2}|1000)$`',
    `safety_critical_flag` BOOLEAN COMMENT 'Indicates whether the failure mode is associated with a safety-critical characteristic that could result in injury, regulatory non-compliance, or product recall. Triggers mandatory escalation and CAPA.. Valid values are `true|false`',
    `severity_rating` STRING COMMENT 'Numeric rating (1–10) indicating the seriousness of the failure effect on the customer or downstream process. A rating of 10 represents a safety-critical or regulatory non-compliance failure.. Valid values are `^([1-9]|10)$`',
    `source_system` STRING COMMENT 'Name of the originating operational system from which this FMEA record was sourced (e.g., Siemens Teamcenter PLM, SAP S/4HANA QM), supporting data lineage in the lakehouse.',
    `status` STRING COMMENT 'Current lifecycle status of the FMEA document, governing its applicability and use in production and design activities.. Valid values are `draft|in_review|approved|released|obsolete|cancelled`',
    `team_members` STRING COMMENT 'Names or roles of the cross-functional team members who participated in the FMEA study, as required by AIAG-VDA methodology for collaborative risk assessment.',
    `title` STRING COMMENT 'Descriptive title of the FMEA study, typically referencing the product, assembly, or process being analyzed.',
    `type` STRING COMMENT 'Classification of the FMEA study: DFMEA (Design Failure Mode and Effects Analysis) for product design risk, PFMEA (Process Failure Mode and Effects Analysis) for manufacturing process risk, SFMEA for system-level, or MFMEA for machinery.. Valid values are `DFMEA|PFMEA|SFMEA|MFMEA`',
    CONSTRAINT pk_fmea PRIMARY KEY(`fmea_id`)
) COMMENT 'Failure Mode and Effects Analysis (FMEA) master record capturing design or process risk assessments. Stores function, potential failure mode, effect, severity (S), occurrence (O), detection (D), RPN score, recommended actions, and revised RPN after mitigation. Supports both DFMEA and PFMEA per AIAG/VDA methodology.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`fmea_action` (
    `fmea_action_id` BIGINT COMMENT 'Unique system-generated identifier for each FMEA action item record within the quality management system.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Each FMEA action item must be assigned to a specific employee for accountability and tracking completion of risk mitigation activities.',
    `fmea_id` BIGINT COMMENT 'Foreign key linking to quality.fmea. Business justification: FMEA action items are child records of an FMEA master record — each action tracks recommended or completed actions to reduce RPN for a specific failure mode. The fmea_reference_number string field is ',
    `quality_capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: FMEA actions may be linked to a CAPA when the action requires formal corrective/preventive action management. The related_capa_number string field is redundant once the FK is established.',
    `action_category` STRING COMMENT 'Indicates whether the action is a recommended action (proposed but not yet committed), a planned action (committed with a target date), an implemented action (completed), or a cancelled action.. Valid values are `recommended|implemented|planned|cancelled`',
    `action_description` STRING COMMENT 'Detailed narrative description of the recommended or implemented action to reduce risk, including the specific change, control, or improvement to be made to address the identified failure mode.',
    `action_number` STRING COMMENT 'Human-readable business reference number for the FMEA action item, used for cross-referencing in engineering documents, CAPA records, and audit trails.. Valid values are `^ACT-[A-Z0-9]{4,20}$`',
    `action_result_description` STRING COMMENT 'Narrative description of the actual outcome and evidence of the completed action, documenting what was done, how it was implemented, and the results observed.',
    `action_type` STRING COMMENT 'Classifies the nature of the action: prevention actions reduce the likelihood of failure occurrence, detection actions improve the ability to detect failures, correction actions address identified failures, and redesign/process change actions modify the design or process.. Valid values are `prevention|detection|correction|redesign|process_change|validation|verification|monitoring`',
    `actual_cost` DECIMAL(18,2) COMMENT 'Actual cost incurred to implement the FMEA action, recorded upon completion for variance analysis against the estimated cost and financial reporting.',
    `apqp_phase` STRING COMMENT 'Identifies the APQP phase during which this action was identified or is being executed, enabling alignment of risk mitigation activities with the product development lifecycle.. Valid values are `phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch|post_launch`',
    `completion_date` DATE COMMENT 'Actual date on which the FMEA action item was completed and implemented, used to measure on-time performance and close the action lifecycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `control_type` STRING COMMENT 'Specifies the type of control or change implemented by the action, such as a design change, process change, additional inspection, Poka-Yoke (error-proofing), Statistical Process Control (SPC), or training.. Valid values are `design_change|process_change|additional_control|test_validation|inspection|poka_yoke|spc|training|procedure_update|supplier_change`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the FMEA action record was first created in the system, providing an audit trail for record creation and compliance with ISO 9001 document control requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated and actual cost amounts, supporting multi-currency operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `effectiveness_confirmed` BOOLEAN COMMENT 'Indicates whether the effectiveness of the implemented action has been formally confirmed through verification activities, confirming that the intended risk reduction was achieved.. Valid values are `true|false`',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Estimated cost to implement the FMEA action, used for budgeting, cost-benefit analysis, and prioritization of risk mitigation investments.',
    `evidence_reference` STRING COMMENT 'Reference to supporting evidence documents, test reports, inspection records, or document management system links that demonstrate the completion and effectiveness of the action.',
    `failure_mode_description` STRING COMMENT 'Description of the specific failure mode identified in the FMEA entry to which this action is linked, providing context for the risk being mitigated.',
    `fmea_type` STRING COMMENT 'Classifies the FMEA to which this action belongs: Design FMEA (DFMEA) for product design risk, Process FMEA (PFMEA) for manufacturing process risk, System FMEA (SFMEA) for system-level risk, or Machinery FMEA (MFMEA) for equipment risk.. Valid values are `DFMEA|PFMEA|SFMEA|MFMEA`',
    `initial_detection_rating` STRING COMMENT 'Original detection rating (1–10 scale) assigned to the failure mode before the action is implemented, representing the ability of current controls to detect the failure. 10 indicates the lowest detectability.. Valid values are `^([1-9]|10)$`',
    `initial_occurrence_rating` STRING COMMENT 'Original occurrence rating (1–10 scale) assigned to the failure mode before the action is implemented, representing the likelihood of the failure mode occurring. 10 indicates the highest frequency.. Valid values are `^([1-9]|10)$`',
    `initial_rpn` STRING COMMENT 'Original Risk Priority Number calculated as Severity × Occurrence × Detection before any action is taken, establishing the baseline risk level for the failure mode. Range: 1–1000.. Valid values are `^([1-9]|[1-9][0-9]{1,2}|1000)$`',
    `initial_severity_rating` STRING COMMENT 'Original severity rating (1–10 scale) assigned to the failure mode before the action is implemented, representing the seriousness of the effect on the customer or process. 10 indicates the most severe impact.. Valid values are `^([1-9]|10)$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the FMEA action record, supporting audit trail requirements and change history tracking per ISO 9001 document control.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `part_number` STRING COMMENT 'Engineering part number or component identifier associated with the FMEA entry, linking the action to the specific product or component being analyzed.',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where the FMEA action applies, supporting multi-site operations and plant-level risk management reporting.',
    `ppap_required` BOOLEAN COMMENT 'Indicates whether the completion of this FMEA action requires a PPAP submission or re-submission to the customer, typically triggered by design or process changes.. Valid values are `true|false`',
    `priority` STRING COMMENT 'Business priority level assigned to the action item, used to drive resource allocation and scheduling. Critical actions address high-RPN failure modes requiring immediate attention.. Valid values are `critical|high|medium|low`',
    `process_step` STRING COMMENT 'Name or identifier of the specific manufacturing process step or operation to which this FMEA action applies, relevant for PFMEA actions tied to specific shop floor operations.',
    `related_ecn_number` STRING COMMENT 'Reference number of any Engineering Change Notice (ECN) or Engineering Change Order (ECO) raised as a result of this FMEA action, linking risk mitigation to formal design or process change management.',
    `responsible_department` STRING COMMENT 'Organizational department or function responsible for executing the action, such as Design Engineering, Manufacturing Engineering, Quality Assurance, or Production.',
    `responsible_owner` STRING COMMENT 'Name or identifier of the individual or role accountable for executing and completing the FMEA action item within the target date.',
    `revised_detection_rating` STRING COMMENT 'Updated detection rating (1–10 scale) after the action has been implemented, reflecting the improved ability to detect the failure mode as a result of the action.. Valid values are `^([1-9]|10)$`',
    `revised_occurrence_rating` STRING COMMENT 'Updated occurrence rating (1–10 scale) after the action has been implemented, reflecting the reduced likelihood of the failure mode occurring as a result of the action.. Valid values are `^([1-9]|10)$`',
    `revised_rpn` STRING COMMENT 'Updated Risk Priority Number calculated as revised Severity × revised Occurrence × revised Detection after the action is implemented, demonstrating the risk reduction achieved. Range: 1–1000.. Valid values are `^([1-9]|[1-9][0-9]{1,2}|1000)$`',
    `revised_severity_rating` STRING COMMENT 'Updated severity rating (1–10 scale) after the action has been implemented, reflecting any reduction in the severity of the failure mode effect achieved by the action.. Valid values are `^([1-9]|10)$`',
    `rpn_reduction_target` STRING COMMENT 'Target RPN value that the action is expected to achieve upon completion, used to set measurable risk reduction objectives and evaluate action effectiveness.. Valid values are `^([1-9]|[1-9][0-9]{1,2}|1000)$`',
    `status` STRING COMMENT 'Current lifecycle status of the FMEA action item, tracking progress from initial identification through completion and verification of effectiveness.. Valid values are `open|in_progress|completed|verified|cancelled|overdue`',
    `target_date` DATE COMMENT 'Planned date by which the FMEA action item must be completed, used for scheduling, escalation, and overdue tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verification_date` DATE COMMENT 'Date on which the effectiveness of the completed action was verified and confirmed, ensuring the action achieved the intended risk reduction.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verified_by` STRING COMMENT 'Name or identifier of the individual who verified the effectiveness of the completed action, confirming that the risk reduction objective was achieved.',
    CONSTRAINT pk_fmea_action PRIMARY KEY(`fmea_action_id`)
) COMMENT 'Individual action item records linked to an FMEA entry, tracking recommended and completed actions to reduce RPN. Captures action description, responsible owner, target date, completion date, revised S/O/D ratings, and updated RPN. Enables lifecycle tracking of risk mitigation activities within DFMEA and PFMEA workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`control_plan` (
    `control_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the Quality Control Plan record within the enterprise data platform.',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.quality_characteristic. Business justification: A control plan row defines controls for a specific quality characteristic (CTQ). The product_characteristic string field is redundant once the FK to quality_characteristic is established. process_char',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Control plans document quality controls for manufacturing specific components. They reference component characteristics, tolerances, and specifications defined by engineering.',
    `fmea_id` BIGINT COMMENT 'Foreign key linking to quality.fmea. Business justification: A control plan is derived from and references a Process FMEA (PFMEA) — the control methods and reaction plans in the control plan are designed to address failure modes identified in the FMEA. The pfme',
    `routing_id` BIGINT COMMENT 'Foreign key linking to production.routing. Business justification: Control plans document quality controls at each routing operation. APQP requirement linking process steps to inspection methods, reaction plans, and control methods.',
    `approved_by` STRING COMMENT 'Name or employee ID of the quality authority (e.g., Quality Engineer, Quality Manager) who formally approved this control plan for production use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the control plan was formally approved, providing an audit trail for quality management system compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `characteristic_class` STRING COMMENT 'Risk-based classification of the controlled characteristic indicating its impact on safety, regulatory compliance, or fit/function. Critical characteristics typically require 100% inspection or SPC monitoring.. Valid values are `critical|significant|major|minor|none`',
    `control_chart_type` STRING COMMENT 'Type of SPC control chart applied to monitor the characteristic (e.g., X-bar/R, Individuals/MR, p-chart for attribute data). Null or none if SPC is not applied.. Valid values are `xbar_r|xbar_s|individuals_mr|p_chart|np_chart|c_chart|u_chart|cusum|ewma|none`',
    `control_method` STRING COMMENT 'The method or technique used to control or monitor the characteristic (e.g., SPC charting, CMM measurement, go/no-go gauge, visual inspection, Poka-Yoke device).. Valid values are `spc|attribute_gauge|variable_gauge|visual_inspection|cmm|functional_test|go_no_go|poka_yoke|100_percent|sampling`',
    `cpk_minimum` DECIMAL(18,2) COMMENT 'Minimum acceptable Cpk (Process Capability Index - Centered) threshold required for this characteristic. Typically 1.33 for standard characteristics and 1.67 for critical/safety characteristics per AIAG standards.. Valid values are `^[0-9]{1,2}.[0-9]{1,3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the control plan record was first created in the quality management system.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_code` STRING COMMENT 'Code identifying the customer for whom this control plan was developed, particularly relevant for customer-specific requirements (CSR) in automotive and industrial supply chains.',
    `effective_date` DATE COMMENT 'Date on which this revision of the control plan became effective and was authorized for use in production.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which this control plan revision expires or is scheduled for mandatory review and revalidation, supporting periodic review requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the control plan record, supporting change tracking and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `measurement_technique` STRING COMMENT 'Specific measurement instrument, gauge, or test equipment used to evaluate the controlled characteristic (e.g., Vernier caliper, torque wrench, CMM, hardness tester).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this control plan to ensure continued adequacy and alignment with current process conditions and engineering specifications.. Valid values are `^d{4}-d{2}-d{2}$`',
    `part_revision` STRING COMMENT 'Engineering revision level of the part drawing or specification that this control plan is aligned to, ensuring traceability between design and process controls.. Valid values are `^[A-Z0-9]{1,5}$`',
    `plan_number` STRING COMMENT 'Business-assigned unique document number for the control plan, used for cross-referencing in PPAP submissions, APQP deliverables, and quality management systems.. Valid values are `^CP-[A-Z0-9]{2,10}-[0-9]{4,8}$`',
    `plan_type` STRING COMMENT 'APQP-defined phase classification of the control plan: Prototype (early development), Pre-Launch (pilot/validation), or Production (full-rate manufacturing). Directly maps to AIAG APQP phase gates.. Valid values are `prototype|pre_launch|production`',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where this control plan is applied, supporting multi-site quality governance in a multinational manufacturing environment.',
    `ppap_level` STRING COMMENT 'PPAP submission level (1–5) associated with this control plan, defining the extent of documentation required for customer approval per AIAG PPAP Reference Manual.. Valid values are `1|2|3|4|5`',
    `prepared_by` STRING COMMENT 'Name or employee ID of the quality or process engineer who authored and prepared this control plan.',
    `process_characteristic` STRING COMMENT 'The process parameter or input variable being controlled (e.g., temperature, torque, feed rate, pressure) that directly affects the product characteristic.',
    `process_flow_reference` STRING COMMENT 'Document number or identifier of the Process Flow Diagram (PFD) that this control plan is aligned to, maintaining the APQP triad linkage: PFD → PFMEA → Control Plan.',
    `process_name` STRING COMMENT 'Name of the manufacturing process or process step covered by this control plan (e.g., Welding, CNC Machining, Assembly, Painting).',
    `process_step_number` STRING COMMENT 'Sequential step number from the Process Flow Diagram (PFD) that this control plan entry corresponds to, enabling direct traceability between the process flow and control plan.',
    `production_line` STRING COMMENT 'Identifier or name of the specific production line, cell, or work center where this control plan is applied.',
    `reaction_plan` STRING COMMENT 'Documented corrective actions or containment steps to be taken when the process or product characteristic goes out of control or exceeds specification limits. Includes operator instructions and escalation path.',
    `revision` STRING COMMENT 'Current revision level or version of the control plan document, incremented upon each approved engineering change or process update.. Valid values are `^[A-Z0-9]{1,5}$`',
    `sample_frequency` STRING COMMENT 'Frequency or interval at which samples are taken for inspection or measurement (e.g., every 1 hour, every 50 parts, start of shift, per lot, continuous).',
    `sample_size` STRING COMMENT 'Number of parts or units to be measured per inspection event, as defined by the AQL sampling plan or SPC subgroup size.. Valid values are `^[1-9][0-9]*$`',
    `source_system` STRING COMMENT 'Operational system of record from which this control plan record originated (e.g., SAP QM, Siemens Opcenter MES, Siemens Teamcenter PLM), supporting data lineage in the lakehouse.. Valid values are `sap_qm|opcenter_mes|teamcenter_plm|manual|other`',
    `specification_lower_limit` STRING COMMENT 'Lower Specification Limit (LSL) for the controlled characteristic. Values below this limit indicate a non-conformance requiring NCR initiation.',
    `specification_nominal` STRING COMMENT 'Target or nominal value for the controlled characteristic as specified in the engineering drawing or product specification (e.g., 25.00 mm, 150 Nm).',
    `specification_upper_limit` STRING COMMENT 'Upper Specification Limit (USL) for the controlled characteristic. Values exceeding this limit indicate a non-conformance requiring NCR initiation.',
    `status` STRING COMMENT 'Current lifecycle status of the control plan, governing whether it is actively used on the shop floor or has been superseded by a newer revision.. Valid values are `draft|under_review|approved|active|superseded|obsolete|on_hold`',
    `title` STRING COMMENT 'Descriptive title of the control plan, typically referencing the part name, process family, or product line it governs.',
    `unit_of_measure` STRING COMMENT 'Engineering unit of measure for the specification values and measurement results (e.g., mm, Nm, °C, bar, kg, %).',
    `work_instruction_reference` STRING COMMENT 'Document number or identifier of the associated work instruction or Standard Operating Procedure (SOP) that operators follow to execute the controlled process step.',
    CONSTRAINT pk_control_plan PRIMARY KEY(`control_plan_id`)
) COMMENT 'Quality Control Plan master record defining the process controls, inspection frequency, reaction plans, and measurement systems for each manufacturing process step. Links to PFMEA, process flow, and inspection plan. Core APQP deliverable used in PPAP submissions and ongoing production quality governance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`ppap_submission` (
    `ppap_submission_id` BIGINT COMMENT 'Unique system-generated identifier for the PPAP submission record within the Quality Management System.',
    `apqp_project_id` BIGINT COMMENT 'Foreign key linking to quality.apqp_project. Business justification: A PPAP submission is a key deliverable and milestone of an APQP project. The apqp_project tracks ppap_submission_date, ppap_approval_date, and ppap_status, confirming the direct relationship. No redun',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: PPAP submissions validate production readiness for specific components. Each PPAP package documents that a component meets engineering specifications before production approval.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: PPAP submissions document production configuration at approval time. Automotive suppliers must prove parts are made with approved equipment/software configurations. IT manages these configuration base',
    `order_quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: PPAP submissions are prepared during quotation phase for new parts. Customers require PPAP approval before awarding production orders, linking quality validation to commercial quotation.',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: PPAP submissions often require proof of product certifications (UL, CSA, CE marks) as part of customer approval. Automotive and industrial manufacturers link PPAP packages to active certifications for',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: PPAP submissions are the final quality approval for new parts developed in R&D projects. Manufacturing links PPAP to the originating R&D project for traceability and design history file requirements.',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: PPAP (Production Part Approval Process) submissions are required before production begins for new customer programs. Sales opportunities for new parts/products require PPAP approval before order fulfi',
    `annual_production_volume` STRING COMMENT 'Declared annual production volume (units per year) for the part as stated on the Part Submission Warrant (PSW), used to validate process capability studies.',
    `appearance_approval_complete` BOOLEAN COMMENT 'Indicates whether the Appearance Approval Report (AAR) element has been completed and included in the PPAP submission package, applicable for appearance-critical parts.. Valid values are `true|false`',
    `approval_date` DATE COMMENT 'Date on which the customer formally approved or conditionally approved the PPAP submission, authorizing production shipments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_status` STRING COMMENT 'Formal customer disposition of the PPAP submission: Approved (full production authorized), Conditionally Approved (limited production with open actions), or Rejected (resubmission required).. Valid values are `approved|conditionally_approved|rejected|pending`',
    `capability_study_complete` BOOLEAN COMMENT 'Indicates whether the initial process capability study (Cp/Cpk analysis) has been completed and included in the PPAP submission package.. Valid values are `true|false`',
    `control_plan_complete` BOOLEAN COMMENT 'Indicates whether the Control Plan element documenting all process controls, inspection methods, and reaction plans has been completed and included in the PPAP package.. Valid values are `true|false`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the part is manufactured, required for trade compliance, customs declarations, and regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `customer_engineer_name` STRING COMMENT 'Name of the customers quality engineer or supplier quality engineer (SQE) responsible for reviewing and approving the PPAP submission.',
    `customer_part_number` STRING COMMENT 'The customers own part number for the component, which may differ from the suppliers internal part number. Required for cross-reference on the PSW.',
    `design_record_complete` BOOLEAN COMMENT 'Indicates whether the design record element (drawings, CAD models, specifications) has been completed and included in the PPAP submission package.. Valid values are `true|false`',
    `deviation_number` STRING COMMENT 'Reference number of any interim approval, deviation, or waiver granted by the customer allowing limited production shipments while the PPAP is conditionally approved or pending full approval.',
    `expiry_date` DATE COMMENT 'Date on which the PPAP approval expires and revalidation is required, applicable for time-limited approvals or annual revalidation programs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fai_complete` BOOLEAN COMMENT 'Indicates whether the First Article Inspection (FAI) / dimensional results element has been completed and included in the PPAP submission package.. Valid values are `true|false`',
    `manufacturing_process_description` STRING COMMENT 'Brief description of the key manufacturing processes used to produce the part (e.g., injection molding, CNC machining, stamping), as declared on the Part Submission Warrant (PSW).',
    `material_test_results_complete` BOOLEAN COMMENT 'Indicates whether material test results and performance test results (including functional testing) have been completed and included in the PPAP submission package.. Valid values are `true|false`',
    `min_cpk_value` DECIMAL(18,2) COMMENT 'Minimum Cpk (Process Capability Index - Centered) value recorded across all critical and significant characteristics in the capability study, used to assess process stability and conformance.',
    `msa_complete` BOOLEAN COMMENT 'Indicates whether the Measurement System Analysis (MSA) / Gauge R&R studies have been completed and included in the PPAP submission package.. Valid values are `true|false`',
    `notes` STRING COMMENT 'Free-text field for additional comments, clarifications, or special instructions related to the PPAP submission, including customer-specific requirements or open issue descriptions.',
    `open_action_count` STRING COMMENT 'Number of open action items or deviations associated with the PPAP submission, particularly relevant for conditionally approved submissions requiring resolution before full approval.',
    `overall_ppap_completeness_pct` DECIMAL(18,2) COMMENT 'Percentage of required PPAP elements that have been completed and submitted, calculated as completed elements divided by total required elements. Used for submission readiness tracking.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `part_revision_level` STRING COMMENT 'Engineering revision level or version of the part drawing/design record at the time of PPAP submission, ensuring traceability to the correct design baseline.',
    `pfmea_complete` BOOLEAN COMMENT 'Indicates whether the Process Failure Mode and Effects Analysis (PFMEA) element has been completed and included in the PPAP submission package.. Valid values are `true|false`',
    `production_run_quantity` STRING COMMENT 'Number of parts produced during the significant production run used to generate PPAP samples and capability data, typically a minimum of 300 consecutive parts per AIAG requirements.',
    `psw_number` STRING COMMENT 'Unique reference number of the Part Submission Warrant (PSW) document, which is the formal cover document of the PPAP package signed by the supplier and accepted by the customer.',
    `psw_signatory_name` STRING COMMENT 'Name of the suppliers authorized representative who signed the Part Submission Warrant (PSW), certifying compliance with all PPAP requirements.',
    `psw_signed_date` DATE COMMENT 'Date on which the suppliers authorized representative signed the Part Submission Warrant (PSW), certifying that all PPAP requirements have been met.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulatory_compliance_status` STRING COMMENT 'Status of the parts compliance with applicable regulatory requirements (e.g., RoHS, REACH, CE Marking, UL) as declared in the PPAP submission.. Valid values are `compliant|non_compliant|pending_review|not_applicable`',
    `required_submission_date` DATE COMMENT 'Customer-mandated or program-required deadline by which the PPAP submission must be completed and approved, used for program timing and launch readiness tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sample_quantity` STRING COMMENT 'Number of sample parts submitted to the customer as part of the PPAP package for dimensional and functional verification.',
    `status` STRING COMMENT 'Current workflow status of the PPAP submission package, tracking its progression from initial draft through customer approval or rejection.. Valid values are `draft|submitted|under_review|approved|conditionally_approved|rejected|on_hold|withdrawn|expired`',
    `submission_date` DATE COMMENT 'Date on which the completed PPAP package was formally submitted to the customer for review and approval.. Valid values are `^d{4}-d{2}-d{2}$`',
    `submission_level` STRING COMMENT 'PPAP submission level (1–5) as defined by AIAG, indicating the extent of documentation and physical samples required. Level 1 = Warrant only; Level 3 = Full PPAP; Level 5 = Full PPAP retained at supplier.. Valid values are `1|2|3|4|5`',
    `submission_number` STRING COMMENT 'Human-readable business reference number for the PPAP submission, used for cross-system tracking and customer communication.. Valid values are `^PPAP-[A-Z0-9]{4,10}-[0-9]{4,8}$`',
    `submission_reason` STRING COMMENT 'Business reason triggering the PPAP submission, such as new part introduction, Engineering Change Notice (ECN), tooling change, or annual revalidation.. Valid values are `new_part|engineering_change|tooling_change|process_change|supplier_change|material_change|correction_of_discrepancy|annual_revalidation|other`',
    `supplier_code` STRING COMMENT 'Unique identifier code assigned to the supplier or manufacturing site submitting the PPAP package, as registered in the supplier master.',
    `supplier_manufacturing_site` STRING COMMENT 'Name or identifier of the specific manufacturing facility or plant at the supplier where the part is produced, as required on the Part Submission Warrant (PSW).',
    `supplier_name` STRING COMMENT 'Legal or trade name of the supplier organization submitting the PPAP package.',
    `supplier_quality_engineer` STRING COMMENT 'Name of the suppliers quality engineer responsible for preparing, coordinating, and submitting the PPAP package.',
    CONSTRAINT pk_ppap_submission PRIMARY KEY(`ppap_submission_id`)
) COMMENT 'Production Part Approval Process (PPAP) submission package record tracking the status and completeness of all required PPAP elements (design records, PFMEA, control plan, MSA, capability studies, FAI, etc.) for a given part and supplier. Captures submission level, customer approval status, and PSW (Part Submission Warrant) details.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`fai_record` (
    `fai_record_id` BIGINT COMMENT 'Unique system-generated identifier for the First Article Inspection (FAI) record. Serves as the primary key for this entity in the Databricks Silver Layer.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: First Article Inspection verifies the first production unit matches engineering design. Quality inspectors compare actual measurements against component engineering drawings and specifications.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: FAI records must document exact equipment/software configuration used during first article inspection. IT manages configuration items, and quality references these for repeatability and AS9102 complia',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: A First Article Inspection is executed as an inspection lot (inspection_lot has is_first_article_inspection flag). Linking fai_record to the inspection_lot that captured the measurements enables full ',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: A First Article Inspection record may reference an NCR when nonconforming characteristics are found during FAI. The ncr_reference string field is redundant once the FK to ncr is established.',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: FAI record for production order - normalize by replacing production_order_number text with FK',
    `ppap_submission_id` BIGINT COMMENT 'Foreign key linking to quality.ppap_submission. Business justification: FAI is a required element of PPAP (fai_complete flag exists in ppap_submission). The FAI record should reference the PPAP submission package it belongs to, enabling traceability from PPAP package to F',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: FAI record for supplier - normalize by replacing supplier_code and supplier_name with FK',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: First Article Inspection validates that production parts match R&D design specifications. FAI records reference the R&D project to verify conformance to original design intent and engineering requirem',
    `approval_date` DATE COMMENT 'Date on which the FAI was formally approved by the designated approving authority (internal quality engineer, customer representative, or regulatory body).. Valid values are `^d{4}-d{2}-d{2}$`',
    `approver_name` STRING COMMENT 'Full name of the authorized quality representative or customer delegate who reviewed and approved or rejected the FAI package.',
    `balloon_drawing_reference` STRING COMMENT 'Reference identifier or document number of the ballooned drawing used during the FAI. A ballooned drawing annotates each dimension and characteristic with a numbered balloon corresponding to the inspection data sheet entries.',
    `characteristics_conforming` STRING COMMENT 'Number of inspected characteristics that were found to be within the specified engineering tolerances and fully conforming to the drawing requirements.. Valid values are `^[0-9]+$`',
    `characteristics_nonconforming` STRING COMMENT 'Number of inspected characteristics that were found to be outside the specified engineering tolerances. Non-conforming characteristics trigger Non-Conformance Report (NCR) and Corrective and Preventive Action (CAPA) processes.. Valid values are `^[0-9]+$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the manufacturing plant or supplier facility where the first article was produced. Supports multinational regulatory compliance (CE Marking, RoHS, REACH) and export control tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the FAI record was initially created in the quality management system. Used for audit trail, record retention compliance, and lifecycle tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_code` STRING COMMENT 'Identifier of the customer for whom the FAI is being performed, when the inspection is driven by customer-specific requirements or a customer-specific form (e.g., PPAP customer-specific requirements). Blank for internal FAIs.',
    `deviation_reference` STRING COMMENT 'Reference number of any approved engineering deviation or waiver associated with this FAI, permitting use of a part that does not fully conform to the drawing specification under defined conditions.',
    `disposition` STRING COMMENT 'Final disposition decision for the FAI. Approved means the part fully conforms to all requirements. Approved with Deviation allows limited production under documented deviation. Rejected requires rework or re-inspection. Interim Approval permits limited production pending resolution of open items.. Valid values are `approved|approved_with_deviation|rejected|interim_approval|pending_review|voided`',
    `drawing_number` STRING COMMENT 'Reference number of the engineering drawing used as the baseline specification for dimensional, material, and functional verification during the FAI.',
    `drawing_revision` STRING COMMENT 'Revision level of the engineering drawing referenced during the FAI. Must match the part revision to ensure inspection is performed against the correct specification baseline.. Valid values are `^[A-Z0-9]{1,5}$`',
    `expiry_date` DATE COMMENT 'Date after which the FAI approval is no longer valid and a re-FAI may be required. Applicable when customer contracts or quality plans specify a validity period for FAI approvals.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fai_number` STRING COMMENT 'Human-readable, business-assigned FAI reference number used for cross-referencing with engineering drawings, customer documentation, and quality records. Typically follows a structured naming convention tied to part number and revision.. Valid values are `^FAI-[A-Z0-9]{2,10}-[0-9]{4,8}$`',
    `fai_reason` STRING COMMENT 'Business reason that triggered the FAI. Captures whether the inspection was initiated due to a new part introduction, engineering change, process change, supplier change, tooling change, production interruption, customer request, or Corrective and Preventive Action (CAPA).. Valid values are `new_part|design_change|process_change|supplier_change|tooling_change|production_interruption|customer_request|corrective_action`',
    `fai_type` STRING COMMENT 'Classification of the FAI scope. Full indicates a complete FAI per AS9102. Partial covers a subset of characteristics. Delta is triggered by an Engineering Change Order (ECO) affecting specific features. Re-FAI is required after a process or supplier change.. Valid values are `full|partial|delta|re-fai`',
    `form1_design_documentation_complete` BOOLEAN COMMENT 'Indicates whether AS9102 Form 1 (Design Documentation) has been fully completed and all required design documentation (drawings, specifications, material certifications) has been collected and verified.. Valid values are `true|false`',
    `form2_product_accountability_complete` BOOLEAN COMMENT 'Indicates whether AS9102 Form 2 (Product Accountability, Materials, and Special Processes) has been fully completed, including raw material certifications, special process approvals (e.g., heat treatment, plating), and sub-tier supplier documentation.. Valid values are `true|false`',
    `form3_characteristic_accountability_complete` BOOLEAN COMMENT 'Indicates whether AS9102 Form 3 (Characteristic Accountability, Verification, and Compatibility Evaluation) has been fully completed, covering all dimensional, functional, and critical characteristics from the ballooned drawing.. Valid values are `true|false`',
    `functional_test_status` STRING COMMENT 'Status of functional performance testing conducted on the first article part to verify it meets operational and performance specifications beyond dimensional conformance.. Valid values are `not_required|pending|passed|failed|waived`',
    `inspection_date` DATE COMMENT 'Date on which the First Article Inspection was physically performed. Used for scheduling, compliance tracking, and quality record retention.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_standard` STRING COMMENT 'Quality standard or specification framework governing the FAI process. AS9102 is the aerospace standard; AIAG PPAP is the automotive standard; customer-specific standards may apply for key accounts.. Valid values are `AS9102|AIAG_PPAP|ISO_9001|customer_specific|internal`',
    `inspector_name` STRING COMMENT 'Full name of the quality inspector or engineer who performed the First Article Inspection. Required for traceability and accountability per quality management system requirements.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the FAI record. Supports change tracking, audit trail requirements, and data lineage in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `material_certification_status` STRING COMMENT 'Status of raw material certifications (mill certs, material test reports) required as part of the FAI package. Verifies that the material used in the first article conforms to the specified material standard.. Valid values are `not_required|pending|received|verified|rejected`',
    `open_items_count` STRING COMMENT 'Number of FAI action items or discrepancies that remain open and unresolved at the time of record capture. Open items may prevent full approval and require resolution before final disposition.. Valid values are `^[0-9]+$`',
    `part_name` STRING COMMENT 'Descriptive name of the part or assembly subject to the First Article Inspection, as defined in the engineering drawing or Product Lifecycle Management (PLM) system.',
    `part_revision` STRING COMMENT 'Engineering revision level of the part drawing at the time of the FAI. Ensures the inspection is performed against the correct and current drawing revision. Linked to Engineering Change Notice (ECN) / Engineering Change Order (ECO) history.. Valid values are `^[A-Z0-9]{1,5}$`',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where the first article part was produced and inspected. Supports multi-site quality management and regulatory compliance tracking.',
    `ppap_level` STRING COMMENT 'PPAP submission level required by the customer, ranging from Level 1 (Part Submission Warrant only) to Level 5 (complete package reviewed at suppliers facility). Applicable when the FAI is part of a PPAP submission per AIAG standards.. Valid values are `1|2|3|4|5|not_applicable`',
    `psw_status` STRING COMMENT 'Status of the Part Submission Warrant (PSW), the PPAP cover document that summarizes the FAI results and certifies that the part meets all customer requirements. Required for PPAP-based FAI submissions.. Valid values are `not_required|pending|submitted|approved|rejected`',
    `source_system` STRING COMMENT 'Operational system of record from which the FAI record was ingested into the Databricks Silver Layer. Supports data lineage, reconciliation, and audit trail requirements.. Valid values are `SAP_QM|Opcenter_MES|Teamcenter_PLM|manual|other`',
    `special_process_approval_status` STRING COMMENT 'Status of approvals for special manufacturing processes (e.g., welding, heat treatment, surface treatment, non-destructive testing) applied to the first article part. Special processes typically require NADCAP or customer-specific accreditation.. Valid values are `not_required|pending|approved|rejected`',
    `status` STRING COMMENT 'Current workflow status of the FAI record throughout its lifecycle, from initial creation through inspection, submission, review, and final disposition.. Valid values are `draft|in_progress|submitted|under_review|approved|rejected|closed|voided`',
    `submission_date` DATE COMMENT 'Date on which the completed FAI package was formally submitted to the customer or internal approving authority for review and disposition.. Valid values are `^d{4}-d{2}-d{2}$`',
    `total_characteristics` STRING COMMENT 'Total number of dimensional, material, and functional characteristics identified on the ballooned drawing and required to be measured and verified during the FAI.. Valid values are `^[0-9]+$`',
    `work_center` STRING COMMENT 'Manufacturing work center or production cell where the first article part was produced. Used to trace the FAI to a specific shop floor location for process validation and traceability.',
    CONSTRAINT pk_fai_record PRIMARY KEY(`fai_record_id`)
) COMMENT 'First Article Inspection (FAI) record documenting the dimensional, material, and functional verification of the first production part against engineering drawings and specifications. Captures balloon drawing reference, measured vs. nominal values, AS9102 / customer-specific form completion status, and approval disposition.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`spc_chart` (
    `spc_chart_id` BIGINT COMMENT 'Unique system-generated identifier for the SPC chart master record within the Quality Management System.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: SPC charts are generated by specific quality management applications (Minitab, InfinityQS, etc.). IT manages these applications for licensing, updates, and support. Quality teams reference which appli',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.quality_characteristic. Business justification: An SPC chart monitors a specific quality characteristic (CTQ). The characteristic_name and characteristic_type string fields are redundant once the FK to quality_characteristic is established, as thes',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: An SPC chart is defined within the context of a control plan — the control plan specifies the control chart type, sample size, and frequency. The control_plan_reference string field is redundant once ',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: SPC charts monitor process capability of specific equipment. Quality analysts track control charts per machine to detect equipment degradation and trigger maintenance before producing defects.',
    `approved_by` STRING COMMENT 'Name or employee identifier of the quality engineer or quality manager who approved this SPC chart configuration for production use. Required for PPAP documentation and ISO 9001 audit trails.',
    `approved_date` DATE COMMENT 'Date on which the SPC chart configuration was formally approved for production use by the responsible quality authority.. Valid values are `^d{4}-d{2}-d{2}$`',
    `baseline_established_date` DATE COMMENT 'Date on which the SPC chart baseline (center line and control limits) was established from the initial process study. Used to track when the chart was last recalibrated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `baseline_sample_count` STRING COMMENT 'Number of subgroups collected during the initial baseline study used to establish the center line and control limits. AIAG recommends a minimum of 25 subgroups for a stable baseline.. Valid values are `^[1-9][0-9]*$`',
    `center_line` DECIMAL(18,2) COMMENT 'Center line value of the primary SPC chart representing the process grand mean (Xbar-bar) or process proportion (p-bar), established during the baseline study phase. Used as the reference for control limit calculations.',
    `chart_number` STRING COMMENT 'Human-readable business identifier for the SPC chart, used for cross-referencing in quality documentation, PPAP packages, and audit records.. Valid values are `^SPC-[A-Z0-9]{3,20}$`',
    `chart_type` STRING COMMENT 'Type of Statistical Process Control (SPC) control chart used to monitor the process characteristic. Xbar-R and Xbar-S are used for variable data with subgroups; I-MR for individual measurements; p, np, c, u charts for attribute data; CUSUM and EWMA for detecting small shifts.. Valid values are `Xbar-R|Xbar-S|I-MR|p-chart|np-chart|c-chart|u-chart|CUSUM|EWMA`',
    `control_limit_method` STRING COMMENT 'Statistical method used to calculate the control limits for this chart. Standard is 3-sigma (99.73% confidence). Some applications use 2-sigma warning limits or custom multipliers.. Valid values are `3-sigma|2-sigma|custom`',
    `cp_target` DECIMAL(18,2) COMMENT 'Minimum acceptable target value for the Cp (Process Capability Index) for this characteristic. Cp measures the spread of the process relative to the specification width. Typical AIAG minimum is 1.33 for new processes.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `cpk_target` DECIMAL(18,2) COMMENT 'Minimum acceptable target value for the Cpk (Centered Process Capability Index) for this characteristic. Cpk accounts for process centering relative to specification limits. Typical AIAG minimum is 1.33 for new processes.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the SPC chart master record was first created in the Quality Management System. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed narrative describing the purpose, scope, and monitored characteristic of the SPC chart for quality documentation and operator guidance.',
    `detection_rule_set` STRING COMMENT 'Identifies the set of run rules applied to detect out-of-control conditions on the SPC chart. Common rule sets include Western Electric (AT&T) rules, Nelson rules, and AIAG rules. Governs alarm logic in Siemens Opcenter MES Quality module.. Valid values are `Western Electric|Nelson|AIAG|Custom`',
    `effective_date` DATE COMMENT 'Date from which this SPC chart configuration is effective and enforced in production monitoring. Supports version-controlled chart management aligned with engineering change processes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which this SPC chart configuration expires and must be reviewed or replaced. Supports scheduled revalidation cycles required by quality management systems.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gauge_type` STRING COMMENT 'Type of measurement gauge or instrument used to collect data for this SPC chart, e.g., CMM, Caliper, Vision System, Load Cell. Supports Gauge R&R (Measurement System Analysis) traceability.',
    `lcl` DECIMAL(18,2) COMMENT 'Lower Control Limit for the primary chart, calculated as the process center minus three standard deviations (3-sigma). Measurements below LCL trigger an out-of-control signal. May be zero or null for attribute charts where negative values are not meaningful.',
    `lsl` DECIMAL(18,2) COMMENT 'Lower engineering specification limit for the monitored characteristic as defined in the product drawing or control plan. Used to calculate process capability indices (Cp, Cpk). Distinct from the statistical LCL.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the SPC chart master record. Supports change tracking and audit compliance under ISO 9001.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `msa_required` BOOLEAN COMMENT 'Indicates whether a Measurement System Analysis (MSA) / Gauge R&R study is required for the measurement system used with this SPC chart, as mandated by AIAG PPAP and APQP requirements.. Valid values are `true|false`',
    `name` STRING COMMENT 'Descriptive name of the SPC chart identifying the monitored process characteristic, e.g., Shaft Diameter Xbar-R Chart — Line 3.',
    `operation_number` STRING COMMENT 'Manufacturing operation or process step number (from the Bill of Process / routing) at which this SPC chart is applied, as defined in SAP S/4HANA PP routing or Siemens Opcenter MES work order operations.',
    `part_number` STRING COMMENT 'Engineering part number or material number of the product or component whose characteristic is monitored by this SPC chart. Corresponds to the material master in SAP S/4HANA MM and the component in Siemens Teamcenter PLM.',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where this SPC chart is applied. Supports multi-plant, multinational operations and plant-level quality reporting.',
    `range_center_line` DECIMAL(18,2) COMMENT 'Center line of the range or standard deviation sub-chart, representing the average range (R-bar) or average standard deviation (S-bar) from the baseline study. Null for single-chart types.',
    `range_lcl` DECIMAL(18,2) COMMENT 'Lower Control Limit for the range (R) or standard deviation (S) sub-chart. Typically zero for small subgroup sizes (n < 7) in Xbar-R charts. Null for single-chart types.',
    `range_ucl` DECIMAL(18,2) COMMENT 'Upper Control Limit for the range (R) or standard deviation (S) sub-chart used in Xbar-R and Xbar-S charts to monitor process variability. Null for single-chart types such as p-chart or c-chart.',
    `recalculation_trigger` STRING COMMENT 'Defines the condition that triggers recalculation of the SPC chart control limits, such as a scheduled review, an Engineering Change Notice (ECN), a process change event, or automatic recalculation after a defined number of new subgroups.. Valid values are `manual|scheduled|process_change|engineering_change|automatic`',
    `revision_reason` STRING COMMENT 'Narrative explanation for the most recent revision of the SPC chart configuration, e.g., Process improvement after Kaizen event, Engineering Change Order ECO-2024-0112, Annual revalidation.',
    `sampling_frequency` STRING COMMENT 'Defined frequency or interval at which subgroup samples are collected for SPC monitoring, e.g., Every 1 hour, Every 50 parts, Every shift. Governs the sampling plan in Siemens Opcenter MES Quality module.',
    `sampling_frequency_unit` STRING COMMENT 'Unit of the sampling frequency interval, indicating whether sampling is time-based (minutes, hours, shifts) or production-volume-based (parts, batches).. Valid values are `parts|minutes|hours|shifts|days|batches`',
    `sampling_frequency_value` DECIMAL(18,2) COMMENT 'Numeric value of the sampling interval, used in conjunction with sampling_frequency_unit to define the complete sampling schedule, e.g., 2 hours or 100 parts.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `sigma_level` DECIMAL(18,2) COMMENT 'Target sigma level for the monitored process characteristic, expressing the number of standard deviations between the process mean and the nearest specification limit. A Six Sigma target corresponds to 6.0.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `status` STRING COMMENT 'Current operational status of the SPC chart master record. Active charts are enforced in Siemens Opcenter MES for ongoing production monitoring. Suspended charts are temporarily halted pending review.. Valid values are `active|inactive|draft|suspended|archived`',
    `subgroup_size` STRING COMMENT 'Number of individual measurements collected per subgroup sample for the SPC chart. Determines the statistical basis for control limit calculations. Typically 2–10 for Xbar-R charts; 1 for I-MR charts.. Valid values are `^[1-9][0-9]*$`',
    `ucl` DECIMAL(18,2) COMMENT 'Upper Control Limit for the primary (mean or proportion) chart, calculated statistically as the process center plus three standard deviations (3-sigma). Measurements exceeding UCL trigger an out-of-control signal in Siemens Opcenter MES.',
    `unit_of_measure` STRING COMMENT 'Engineering unit of measurement for the monitored characteristic, e.g., mm, kg, MPa, percent, count. Governs how measurement readings are interpreted against control limits.',
    `usl` DECIMAL(18,2) COMMENT 'Upper engineering specification limit for the monitored characteristic as defined in the product drawing or control plan. Used to calculate process capability indices (Cp, Cpk). Distinct from the statistical UCL.',
    `version_number` STRING COMMENT 'Version identifier of the SPC chart configuration, incremented when control limits, sampling parameters, or detection rules are revised. Supports audit trail and change management requirements.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    `work_center_code` STRING COMMENT 'Code identifying the manufacturing work center or machine where this SPC chart is applied for process monitoring. Corresponds to the work center master in SAP S/4HANA PP and Siemens Opcenter MES.',
    CONSTRAINT pk_spc_chart PRIMARY KEY(`spc_chart_id`)
) COMMENT 'Statistical Process Control (SPC) chart master record defining the control chart configuration for a monitored process characteristic — chart type (Xbar-R, Xbar-S, p-chart, c-chart), subgroup size, sampling frequency, UCL/LCL control limits, and Cp/Cpk targets. Governs ongoing SPC monitoring in Siemens Opcenter MES Quality module.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`spc_sample` (
    `spc_sample_id` BIGINT COMMENT 'Unique system-generated identifier for each individual SPC data point record captured during production monitoring.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the shop floor operator who collected the SPC sample. Used for operator-level quality analysis and traceability. Classified confidential as it links to workforce records.. Valid values are `^[A-Z0-9-]{2,20}$`',
    `gauge_id` BIGINT COMMENT 'Identifier of the measurement instrument or gauge used to collect the sample, enabling gauge R&R traceability and calibration status verification.. Valid values are `^[A-Z0-9-]{2,30}$`',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: SPC samples may be collected during an inspection lot execution. The inspection_lot_number string field is redundant once the FK to inspection_lot is established, enabling traceability from SPC data p',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: SPC sample from production order - normalize by replacing production_order_number text with FK',
    `spc_chart_id` BIGINT COMMENT 'Foreign key linking to quality.spc_chart. Business justification: SPC samples are data points collected for a specific SPC chart. Each sample belongs to a chart that defines the control limits and characteristic being monitored. The chart_type, characteristic_name, ',
    `batch_number` STRING COMMENT 'Production batch or lot number associated with the sampled material, enabling batch-level traceability and quality disposition.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `center_line` DECIMAL(18,2) COMMENT 'Center line value of the control chart (grand mean X-double-bar or mean range R-bar) representing the process average used as the baseline for control limit calculation.. Valid values are `^-?d+(.d+)?$`',
    `control_plan_number` STRING COMMENT 'Reference to the APQP Control Plan document that governs the SPC monitoring requirements for this characteristic, linking sample data to the formal quality control plan.. Valid values are `^[A-Z0-9-]{2,30}$`',
    `cp_index` DECIMAL(18,2) COMMENT 'Process Capability Index (Cp) calculated at the time of sampling, measuring the ratio of specification width to process spread (6-sigma). Indicates potential capability without centering adjustment.. Valid values are `^d+(.d+)?$`',
    `cpk_index` DECIMAL(18,2) COMMENT 'Centered Process Capability Index (Cpk) calculated at the time of sampling, accounting for process mean offset from the specification midpoint. Key Six Sigma metric for process performance.. Valid values are `^-?d+(.d+)?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the SPC sample record was created in the system, used for data lineage, audit trail, and Silver layer ingestion tracking.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `data_source` STRING COMMENT 'Indicates how the measurement was captured: manually entered by operator, automatically collected from a connected gauge, received from MES, SCADA system, or IIoT sensor. Affects data quality confidence.. Valid values are `MANUAL|AUTOMATED_GAUGE|MES|SCADA|IIoT_SENSOR`',
    `lower_control_limit` DECIMAL(18,2) COMMENT 'Lower control limit for the monitored statistic calculated from process baseline data. Signals out-of-control condition when the statistic falls below this value.. Valid values are `^-?d+(.d+)?$`',
    `lower_spec_limit` DECIMAL(18,2) COMMENT 'Lower engineering specification limit for the quality characteristic as defined in the design or customer requirement. Used for Cp/Cpk capability index calculation.. Valid values are `^-?d+(.d+)?$`',
    `material_number` STRING COMMENT 'SAP material number of the product or component being produced and monitored, enabling quality analysis by material.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `measured_value` DECIMAL(18,2) COMMENT 'The actual numeric measurement recorded for the monitored quality characteristic at the time of sampling. Core data point for SPC analysis.. Valid values are `^-?d+(.d+)?$`',
    `operation_number` STRING COMMENT 'Routing operation number within the production order at which the SPC sample was taken, identifying the specific process step being monitored.. Valid values are `^[0-9]{4}$`',
    `out_of_control_flag` BOOLEAN COMMENT 'Indicates whether this sample point triggered any out-of-control signal based on applied Western Electric or Nelson rules. True triggers immediate operator notification and potential process investigation.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant where the SPC sample was collected, enabling multi-site quality performance comparison.. Valid values are `^[A-Z0-9]{2,10}$`',
    `sample_sequence_number` STRING COMMENT 'Sequential position of this individual measurement within its subgroup (e.g., 1 of 5). Used to reconstruct subgroup composition for SPC recalculation.. Valid values are `^[1-9][0-9]*$`',
    `sample_status` STRING COMMENT 'Current processing status of the SPC sample record (e.g., COLLECTED upon initial entry, VALIDATED after quality review, REJECTED if measurement error detected, VOIDED if sample invalidated).. Valid values are `COLLECTED|VALIDATED|REJECTED|VOIDED`',
    `sample_timestamp` TIMESTAMP COMMENT 'Exact date and time when the subgroup sample measurement was collected on the shop floor, used for time-series SPC charting and trend analysis.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `sampling_frequency_code` STRING COMMENT 'Code referencing the sampling plan frequency rule applied (e.g., EVERY_50_PARTS, HOURLY, EVERY_BATCH), as defined in the inspection plan. Supports audit of sampling compliance.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `shift_code` STRING COMMENT 'Code identifying the production shift during which the SPC sample was collected (e.g., DAY, NIGHT, AFTERNOON). Enables shift-level quality stratification and comparison.. Valid values are `^[A-Z0-9]{1,10}$`',
    `spec_violation_flag` BOOLEAN COMMENT 'Indicates whether the measured value falls outside the engineering specification limits (USL or LSL), representing a non-conforming measurement regardless of control chart status.. Valid values are `true|false`',
    `subgroup_mean` DECIMAL(18,2) COMMENT 'Arithmetic mean of all measured values within the subgroup (X-bar). Plotted on the Xbar control chart to monitor process location.. Valid values are `^-?d+(.d+)?$`',
    `subgroup_number` STRING COMMENT 'Identifier grouping individual measurements into a rational subgroup for Xbar-R or Xbar-S chart calculations. Multiple sample records share the same subgroup_id.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `subgroup_range` DECIMAL(18,2) COMMENT 'Range (maximum minus minimum) of measured values within the subgroup. Plotted on the R-chart to monitor process variability for small subgroup sizes.. Valid values are `^d+(.d+)?$`',
    `subgroup_size` STRING COMMENT 'Number of individual measurements in the subgroup (n). Determines the appropriate control chart constants (A2, D3, D4) used for control limit calculation.. Valid values are `^[1-9][0-9]*$`',
    `subgroup_std_dev` DECIMAL(18,2) COMMENT 'Sample standard deviation of measured values within the subgroup. Used in Xbar-S charts for larger subgroup sizes as a more efficient estimator of process spread.. Valid values are `^d+(.d+)?$`',
    `unit_of_measure` STRING COMMENT 'Engineering unit of the measured value (e.g., mm, kg, MPa, °C, %). Required for correct interpretation and comparison of SPC data across characteristics.. Valid values are `^[a-zA-Z%°/]{1,20}$`',
    `upper_control_limit` DECIMAL(18,2) COMMENT 'Upper control limit for the monitored statistic (mean, range, or standard deviation) calculated from process baseline data. Signals out-of-control condition when exceeded.. Valid values are `^-?d+(.d+)?$`',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'Upper engineering specification limit for the quality characteristic as defined in the design or customer requirement. Used for Cp/Cpk capability index calculation.. Valid values are `^-?d+(.d+)?$`',
    `void_reason` STRING COMMENT 'Free-text explanation for why a sample record was voided (e.g., gauge malfunction, operator error, environmental disturbance). Populated only when sample_status is VOIDED.',
    `we_rule_violated` STRING COMMENT 'Identifies the specific Western Electric rule that triggered the out-of-control signal (e.g., WE1: one point beyond 3-sigma, WE2: nine consecutive points on one side of center line). NONE if no violation detected.. Valid values are `NONE|WE1|WE2|WE3|WE4|WE5|WE6|WE7|WE8|MULTIPLE`',
    `work_center_code` STRING COMMENT 'Code identifying the specific work center or production cell where the monitored characteristic was measured, sourced from SAP S/4HANA PP/QM.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `zone_classification` STRING COMMENT 'Zone classification of the plotted point relative to the control chart center line (Zone C: within 1-sigma, Zone B: 1–2 sigma, Zone A: 2–3 sigma). Used for Western Electric pattern rule evaluation.. Valid values are `A|B|C|IN_CONTROL`',
    CONSTRAINT pk_spc_sample PRIMARY KEY(`spc_sample_id`)
) COMMENT 'Individual SPC data point record capturing a subgroup sample measurement collected during production for a monitored characteristic. Stores sample timestamp, measured values, subgroup mean, range/standard deviation, control limit violations, out-of-control signal flags (Western Electric rules), and operator ID. Feeds real-time SPC monitoring.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`audit` (
    `audit_id` BIGINT COMMENT 'Unique system-generated identifier for the quality audit master record. Serves as the primary key for all audit-related data within the Quality Management System (QMS).',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Customer audits are conducted by specific customer accounts to verify supplier quality systems. Manufacturing tracks which customers audited facilities, findings, and follow-up actions for certificati',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Quality audits charge labor and travel costs to specific cost centers for tracking quality assurance expenses and budget compliance.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the lead auditor responsible for planning, executing, and reporting the audit. Sourced from Kronos Workforce Central or SAP HR. Used for auditor qualification tracking and workload management.',
    `quality_capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: A quality audit that identifies systemic issues may require a CAPA. The capa_reference_number string field is redundant once the FK to capa is established, enabling traceability from audit to correcti',
    `actual_end_date` DATE COMMENT 'Date on which the audit execution was actually completed. Used to calculate actual audit duration and measure adherence to the planned audit schedule.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_start_date` DATE COMMENT 'Date on which the audit execution actually commenced. Compared against scheduled_start_date to measure audit program adherence and identify scheduling deviations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `auditee_name` STRING COMMENT 'Name of the individual, department head, or organizational representative being audited. For supplier audits, this is the primary contact at the supplier organization.',
    `capa_required_flag` BOOLEAN COMMENT 'Indicates whether a formal Corrective and Preventive Action (CAPA) is required as a result of audit findings. Set to TRUE when major or minor nonconformances are identified. Triggers CAPA workflow initiation in the QMS.. Valid values are `true|false`',
    `category` STRING COMMENT 'Indicates whether the audit is conducted internally (first-party), by a customer or interested party (second-party/external), or by an independent certification body (third-party). Drives audit planning, resource allocation, and regulatory reporting obligations.. Valid values are `internal|external|third_party`',
    `certification_body` STRING COMMENT 'Name of the external certification or accreditation body conducting or overseeing the audit (e.g., TÜV SÜD, Bureau Veritas, SGS, DNV). Applicable for third-party and regulatory audits. Null for internal audits.',
    `certification_standard_version` STRING COMMENT 'Specific version or revision of the standard against which the audit is conducted (e.g., ISO 9001:2015, ISO 14001:2015, ISO 45001:2018). Ensures traceability to the correct revision of the applicable standard.',
    `closure_date` DATE COMMENT 'Date on which the audit was formally closed, indicating all findings have been resolved, corrective actions verified, and the audit record is complete. Key metric for audit cycle time reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the country where the audit is conducted. Supports multi-national regulatory compliance tracking and regional quality performance analytics.. Valid values are `^[A-Z]{3}$`',
    `department_code` STRING COMMENT 'Organizational code of the primary department or business unit being audited (e.g., production, procurement, engineering). Used for departmental quality performance tracking and resource planning.',
    `finding_summary` STRING COMMENT 'Executive-level narrative summary of the key findings, nonconformances, and observations identified during the audit. Included in the formal audit report and management review inputs per ISO 9001 Clause 9.3.',
    `frequency` STRING COMMENT 'Defined recurrence interval for this type of audit as specified in the audit program. Drives automatic scheduling of future audits and ensures compliance with ISO 9001 Clause 9.2 requirements for periodic internal audits.. Valid values are `monthly|quarterly|semi_annual|annual|biennial|ad_hoc`',
    `lead_auditor_name` STRING COMMENT 'Full name of the lead auditor responsible for the audit. Retained for reporting and traceability purposes in audit records and regulatory submissions.',
    `major_nc_count` STRING COMMENT 'Number of major nonconformances identified during the audit. Major nonconformances represent systemic failures or complete absence of a required process element and typically require immediate CAPA initiation.. Valid values are `^[0-9]+$`',
    `minor_nc_count` STRING COMMENT 'Number of minor nonconformances identified during the audit. Minor nonconformances represent isolated lapses or partial conformance and require corrective action within a defined timeframe.. Valid values are `^[0-9]+$`',
    `next_audit_due_date` DATE COMMENT 'Planned date for the next scheduled audit of the same scope and area, derived from the audit frequency defined in the audit program. Supports proactive audit scheduling and ISO 9001 Clause 9.2 compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Human-readable, business-facing unique identifier for the audit record, typically generated by the QMS or SAP QM module. Used for cross-referencing in reports, corrective actions, and regulatory submissions.. Valid values are `^QA-[0-9]{4}-[0-9]{6}$`',
    `objective` STRING COMMENT 'Statement of the purpose and intended outcomes of the audit (e.g., Verify conformance to ISO 9001 Clause 8.5, Assess supplier capability for new component qualification). Guides audit planning and criteria selection.',
    `observation_count` STRING COMMENT 'Number of observations or opportunities for improvement (OFIs) noted during the audit. Observations do not constitute nonconformances but highlight areas of potential risk or improvement.. Valid values are `^[0-9]+$`',
    `open_findings_count` STRING COMMENT 'Number of audit findings that remain open and unresolved at the time of record update. Used for audit closure tracking, escalation management, and quality KPI dashboards.. Valid values are `^[0-9]+$`',
    `overall_result` STRING COMMENT 'High-level outcome of the audit indicating the overall conformance status of the audited area. Major nonconformance typically triggers mandatory CAPA and may affect certification status. Used for executive quality dashboards and regulatory reporting.. Valid values are `conforming|minor_nonconformance|major_nonconformance|observation_only|not_applicable`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site where the audit is conducted. Enables plant-level quality performance reporting and multi-site benchmarking.. Valid values are `^[A-Z0-9]{4}$`',
    `process_area` STRING COMMENT 'Specific manufacturing or business process area covered by the audit (e.g., Incoming Inspection, Final Assembly, Supplier Qualification, Document Control). Enables process-level quality trend analysis.',
    `program_reference` STRING COMMENT 'Reference identifier linking this audit to the annual or multi-year audit program under which it was planned. Supports audit program management and ISO 9001 Clause 9.2 compliance demonstration.',
    `report_issued_date` DATE COMMENT 'Date on which the formal audit report was issued to the auditee and relevant stakeholders. Used to measure report turnaround time and compliance with audit program timelines.. Valid values are `^d{4}-d{2}-d{2}$`',
    `risk_based_priority` STRING COMMENT 'Risk-based priority level assigned to the audit, reflecting the criticality of the audited process or area. Derived from risk assessments, previous audit results, and process importance. Supports risk-based audit program planning per ISO 9001 Clause 9.2.. Valid values are `critical|high|medium|low`',
    `scheduled_end_date` DATE COMMENT 'Planned completion date for the audit as defined in the audit schedule. Used alongside scheduled_start_date to determine planned audit duration and resource allocation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scheduled_start_date` DATE COMMENT 'Planned start date for the audit as defined in the annual audit program or audit schedule. Used for audit program planning, resource scheduling, and on-time execution KPI tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scope` STRING COMMENT 'Narrative description of the boundaries and extent of the audit, including the processes, departments, product lines, facilities, or organizational units covered. Aligns with ISO 9001 Clause 9.2 requirements for defining audit scope.',
    `site_name` STRING COMMENT 'Full descriptive name of the facility, plant, or organizational unit being audited (e.g., Stuttgart Assembly Plant, Supplier – Acme Components Ltd.). Complements plant_code for human-readable reporting.',
    `standard` STRING COMMENT 'The primary standard, specification, or regulatory requirement against which the audit is conducted (e.g., ISO 9001:2015, IATF 16949:2016, Customer-Specific Requirements – OEM XYZ, OSHA 29 CFR 1910). Defines the audit criteria baseline.',
    `status` STRING COMMENT 'Current lifecycle status of the audit record. Drives workflow routing, escalation triggers, and compliance reporting. Closed indicates all findings have been resolved and the audit is formally concluded.. Valid values are `planned|in_progress|completed|cancelled|on_hold|closed`',
    `team_members` STRING COMMENT 'Comma-separated list or free-text description of all auditors and technical experts participating in the audit team. Supports audit traceability and competency verification requirements under ISO 19011.',
    `title` STRING COMMENT 'Descriptive title or short name for the audit, summarizing its subject matter (e.g., ISO 9001 Annual Surveillance Audit – Plant A, Supplier Process Audit – Vendor XYZ). Used for identification in dashboards and reports.',
    `total_findings_count` STRING COMMENT 'Total number of audit findings (nonconformances, observations, and opportunities for improvement) identified during the audit. Used for quality trend analysis and audit effectiveness measurement.. Valid values are `^[0-9]+$`',
    `type` STRING COMMENT 'Classification of the audit by its subject matter. System audits evaluate the overall QMS; process audits evaluate specific manufacturing or business processes; product audits evaluate finished goods or components; supplier audits evaluate vendor quality systems; regulatory audits are conducted by or for regulatory bodies.. Valid values are `system|process|product|supplier|customer|regulatory|combined`',
    CONSTRAINT pk_audit PRIMARY KEY(`audit_id`)
) COMMENT 'Quality audit master record for internal and external audits conducted against ISO 9001, customer-specific requirements, or process standards. Captures audit type (system, process, product), scope, audit team, scheduled and actual dates, audit criteria, overall finding summary, and closure status. Supports ISO 9001 Clause 9.2 internal audit requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` (
    `quality_audit_finding_id` BIGINT COMMENT 'Unique system-generated identifier for each individual audit finding record within the Quality Management System.',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.quality_audit. Business justification: An audit finding is a child record of a quality audit — it cannot exist without the parent audit. The audit_number string field is redundant once the FK to quality_audit is established.',
    `employee_id` BIGINT COMMENT 'Employee or certification identifier of the auditor who raised the finding, used for auditor qualification tracking and workload analysis.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: An audit finding may result in or reference an NCR for formal nonconformance documentation. The ncr_number string field is redundant once the FK to ncr is established.',
    `owner_employee_id` BIGINT COMMENT 'Employee identifier of the person assigned ownership and accountability for resolving the audit finding and ensuring timely closure.',
    `quality_capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: Audit findings that require corrective action reference the CAPA record initiated in response. The capa_number string field is redundant once the FK is established, enabling traceability from audit fi',
    `actual_closure_date` DATE COMMENT 'Actual calendar date on which the audit finding was formally closed following successful verification of corrective action effectiveness.. Valid values are `^d{4}-d{2}-d{2}$`',
    `audit_scope` STRING COMMENT 'Description of the scope boundary of the audit from which this finding originated, including processes, departments, sites, or product lines covered.',
    `audit_type` STRING COMMENT 'Category of the audit that generated this finding, distinguishing between internal quality audits, external certification audits, supplier audits, regulatory inspections, and customer audits.. Valid values are `internal|external|supplier|customer|regulatory|certification|surveillance|process|product|system`',
    `auditee_name` STRING COMMENT 'Name of the individual, team, or organizational unit being audited and responsible for the process area where the finding was raised.',
    `auditor_name` STRING COMMENT 'Full name of the lead auditor or audit team member who identified and documented this specific finding during the audit.',
    `capa_required` BOOLEAN COMMENT 'Indicates whether a formal Corrective and Preventive Action (CAPA) workflow must be initiated for this finding. Mandatory for all nonconformity findings per ISO 9001 Clause 10.2.. Valid values are `true|false`',
    `closure_verification_method` STRING COMMENT 'Method used to verify that the corrective action for this finding was effectively implemented, such as re-audit, document review, process observation, or measurement verification.. Valid values are `re_audit|document_review|process_observation|measurement_verification|management_review`',
    `closure_verified_by` STRING COMMENT 'Name or employee ID of the auditor or quality manager who performed the closure verification, confirming that corrective actions were implemented effectively and the finding is resolved.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the site or location where the audit finding was identified. Supports multinational regulatory compliance tracking and regional quality reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the audit finding record was first created in the Quality Management System, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `department_code` STRING COMMENT 'Organizational department code responsible for the process area where the finding was raised, used for departmental quality performance reporting and accountability tracking.',
    `evidence_document_reference` STRING COMMENT 'Reference number or path to supporting documents, records, photographs, or attachments that serve as objective evidence for the audit finding (e.g., Teamcenter document ID, SharePoint path).',
    `finding_description` STRING COMMENT 'Detailed narrative description of the audit finding, including what was observed, where it was observed, and why it constitutes a nonconformity, observation, or opportunity for improvement.',
    `finding_number` STRING COMMENT 'Human-readable business reference number for the audit finding, used for tracking and communication across departments and with external auditors.. Valid values are `^AF-[0-9]{4}-[0-9]{6}$`',
    `finding_title` STRING COMMENT 'Short, descriptive title summarizing the audit finding for display in dashboards, reports, and management reviews. Typically 10–100 characters.',
    `finding_type` STRING COMMENT 'Classification of the audit finding per ISO 9001 audit terminology: major nonconformity (systemic failure), minor nonconformity (isolated lapse), observation (potential risk), or opportunity for improvement (OFI). Drives CAPA workflow initiation.. Valid values are `nonconformity|major_nonconformity|minor_nonconformity|observation|opportunity_for_improvement|positive_finding`',
    `iso_clause_reference` STRING COMMENT 'Specific ISO standard clause number(s) against which the nonconformity or observation was raised (e.g., ISO 9001:2015 Clause 8.5.1). Essential for regulatory reporting and certification body communication.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the audit finding record, supporting change tracking, audit trail compliance, and data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `objective_evidence` STRING COMMENT 'Factual, verifiable evidence collected during the audit that substantiates the finding, such as document references, measurement data, observations, or interview records. Required by ISO 19011 for valid audit findings.',
    `owner_name` STRING COMMENT 'Full name of the assigned owner responsible for driving resolution of the audit finding, initiating corrective actions, and confirming closure.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site where the audit finding was raised. Supports multi-site quality performance analysis.',
    `process_area` STRING COMMENT 'Business process or functional area where the audit finding was identified (e.g., Production Planning, Quality Assurance, Procurement, Warehouse Management). Aligns with core business process taxonomy.',
    `raised_date` DATE COMMENT 'Calendar date on which the audit finding was formally identified and documented during the audit. Used as the baseline for response due date calculation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `recurrence_flag` BOOLEAN COMMENT 'Indicates whether this finding represents a recurrence of a previously closed finding in the same process area or against the same requirement. Recurrent findings trigger escalated CAPA and management review.. Valid values are `true|false`',
    `regulatory_body` STRING COMMENT 'Name of the regulatory authority or certification body relevant to this finding (e.g., ISO, OSHA, EPA, UL, CE, IEC), used for regulatory reporting and certification maintenance.',
    `regulatory_impact` BOOLEAN COMMENT 'Indicates whether the audit finding has potential regulatory compliance implications (e.g., OSHA, EPA, CE Marking, RoHS/REACH, IEC 62443), requiring mandatory reporting or regulatory notification.. Valid values are `true|false`',
    `repeat_finding_reference` STRING COMMENT 'Finding number of the prior audit finding that this record is a recurrence of, enabling trend analysis and systemic failure identification across audit cycles.',
    `requirement_reference` STRING COMMENT 'Reference to the specific customer requirement, internal procedure, regulatory requirement, or contractual obligation that was not met, supplementing the ISO clause reference.',
    `response_due_date` DATE COMMENT 'Required date by which the auditee or finding owner must submit an initial response, root cause analysis, or corrective action plan. Drives escalation and SLA compliance monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `severity` STRING COMMENT 'Risk-based severity rating of the audit finding indicating the potential impact on product quality, regulatory compliance, or business operations. Critical findings require immediate escalation.. Valid values are `critical|major|minor|informational`',
    `status` STRING COMMENT 'Current lifecycle status of the audit finding from initial identification through closure verification. Drives workflow routing and escalation triggers.. Valid values are `open|under_review|response_submitted|capa_in_progress|pending_verification|closed|cancelled`',
    `supplier_code` STRING COMMENT 'SAP Ariba or SAP MM vendor/supplier code when the audit finding was raised during a supplier audit, enabling supplier quality performance tracking and scorecard updates.',
    `target_closure_date` DATE COMMENT 'Planned date by which the audit finding is expected to be fully resolved, corrective actions implemented, and closure verification completed.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_quality_audit_finding PRIMARY KEY(`quality_audit_finding_id`)
) COMMENT 'Individual finding record raised during a quality audit, capturing finding type (nonconformity, observation, opportunity for improvement), clause reference, objective evidence, severity, assigned owner, required response date, and closure verification. Linked to CAPA workflow for nonconformity findings.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`apqp_project` (
    `apqp_project_id` BIGINT COMMENT 'Unique system-generated identifier for the Advanced Product Quality Planning (APQP) project record within the Quality Management System.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: APQP projects are customer-specific new product launch initiatives. Manufacturing tracks which customer the APQP is for, as deliverables, timelines, and requirements vary by customer specification.',
    `apqp_plan_id` BIGINT COMMENT 'Foreign key linking to quality.apqp_plan. Business justification: An APQP project is the execution instance of an APQP plan. The apqp_plan is the master record defining the structured NPI process, while apqp_project tracks execution status, phase gates, and delivera',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: APQP projects require internal orders to collect all new product development costs (tooling, validation, testing) for financial tracking and capitalization decisions.',
    `it_project_id` BIGINT COMMENT 'Foreign key linking to technology.it_project. Business justification: APQP projects for new products often require IT projects (new MES modules, inspection software, data integration). Quality and IT co-manage these initiatives, requiring direct linkage for timeline and',
    `project_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_project. Business justification: APQP projects align with engineering development projects. Quality teams track APQP deliverables against engineering project milestones for new product launches and design changes.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: APQP (Advanced Product Quality Planning) projects directly follow R&D projects to transition designs into production. Quality teams reference the R&D project to ensure design requirements flow into ma',
    `actual_launch_date` DATE COMMENT 'Actual date on which production launch was achieved and the product entered full production, used for schedule adherence analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `control_plan_status` STRING COMMENT 'Completion and approval status of the Control Plan deliverable, a key APQP Phase 3/4 output defining inspection and process control methods for production.. Valid values are `not_started|in_progress|completed|approved|not_required`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary manufacturing country for this APQP project, used for regulatory compliance scoping and export control assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the APQP project record was first created in the Quality Management System, establishing the audit trail start point.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `current_phase` STRING COMMENT 'The active APQP phase the project is currently executing, aligned to the five-phase AIAG APQP framework: Phase 1 (Planning), Phase 2 (Product Design & Development), Phase 3 (Process Design & Development), Phase 4 (Product & Process Validation), Phase 5 (Production Launch).. Valid values are `phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_validation|phase_5_production_launch|completed`',
    `customer_approval_status` STRING COMMENT 'Status of customer approval checkpoints within the APQP project, tracking whether the customer has formally accepted key deliverables and authorized production.. Valid values are `not_required|pending|submitted|approved|conditionally_approved|rejected`',
    `customer_part_number` STRING COMMENT 'The customers own part number for the product being introduced, required for PPAP submission and customer approval documentation.',
    `deliverables_completed` STRING COMMENT 'Number of APQP deliverables that have been formally completed and approved, used to track project progress against the total deliverable count.',
    `deliverables_total` STRING COMMENT 'Total number of APQP deliverables defined for this project across all five phases, used as the denominator for completion percentage tracking.',
    `dfmea_status` STRING COMMENT 'Completion status of the Design Failure Mode and Effects Analysis (DFMEA) deliverable within the APQP project, a mandatory Phase 2 output.. Valid values are `not_started|in_progress|completed|approved|not_required`',
    `fai_required` BOOLEAN COMMENT 'Indicates whether a First Article Inspection (FAI) is required as part of the APQP validation phase for this product introduction.. Valid values are `true|false`',
    `fai_status` STRING COMMENT 'Current completion status of the First Article Inspection for this APQP project, indicating whether the FAI has been performed and its outcome.. Valid values are `not_required|not_started|in_progress|completed_pass|completed_fail|waived`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the APQP project record, supporting audit trail requirements and change tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `material_description` STRING COMMENT 'Short description of the product or component being introduced or changed, as defined in the SAP material master.',
    `material_number` STRING COMMENT 'SAP S/4HANA material master number identifying the product or component that is the subject of this APQP project.',
    `open_issues_count` STRING COMMENT 'Number of unresolved issues, action items, or concerns currently open against this APQP project, used for management review and escalation tracking.',
    `part_number` STRING COMMENT 'Engineering part number from the Product Lifecycle Management (PLM) system (Siemens Teamcenter) identifying the specific part or assembly subject to APQP planning.',
    `part_revision` STRING COMMENT 'Engineering revision level of the part or assembly at the time the APQP project was initiated, as tracked in the PLM system.',
    `pfmea_status` STRING COMMENT 'Completion status of the Process Failure Mode and Effects Analysis (PFMEA) deliverable within the APQP project, a mandatory Phase 3 output.. Valid values are `not_started|in_progress|completed|approved|not_required`',
    `phase_gate_status` STRING COMMENT 'Approval status of the most recently completed phase gate review, indicating whether the project has been formally authorized to proceed to the next phase.. Valid values are `not_started|in_progress|gate_review_pending|gate_approved|gate_rejected|waived`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility responsible for executing the APQP project and producing the new product.',
    `ppap_approval_date` DATE COMMENT 'Date on which the customer formally approved the PPAP submission, authorizing production shipments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ppap_level` STRING COMMENT 'PPAP submission level (1–5) as defined by AIAG, specifying the extent of documentation and samples required for customer approval. Level 3 is the default full submission.. Valid values are `1|2|3|4|5`',
    `ppap_status` STRING COMMENT 'Current status of the PPAP submission process for this APQP project, tracking progress from preparation through customer approval.. Valid values are `not_required|not_started|in_preparation|submitted|approved|conditionally_approved|rejected|resubmission_required`',
    `ppap_submission_date` DATE COMMENT 'Date on which the PPAP package was formally submitted to the customer for approval, a key milestone in Phase 4 validation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `priority` STRING COMMENT 'Business priority assigned to the APQP project, used for resource allocation and scheduling decisions across concurrent new product introduction programs.. Valid values are `low|medium|high|critical`',
    `program_manager` STRING COMMENT 'Name or employee identifier of the program manager accountable for overall APQP project execution, cross-functional team coordination, and gate milestone delivery.',
    `project_number` STRING COMMENT 'Human-readable business identifier for the APQP project, used for cross-functional communication, document referencing, and customer-facing correspondence.. Valid values are `^APQP-[A-Z0-9]{4,20}$`',
    `project_start_date` DATE COMMENT 'Planned or actual start date of the APQP project, marking the formal kick-off of Phase 1 planning activities.. Valid values are `^d{4}-d{2}-d{2}$`',
    `project_type` STRING COMMENT 'Classification of the APQP project by the nature of the change or introduction driving the quality planning effort.. Valid values are `new_product|product_revision|process_change|supplier_change|regulatory_change|platform_extension`',
    `quality_engineer` STRING COMMENT 'Name or employee identifier of the quality engineer responsible for APQP deliverable completion, inspection plan development, and PPAP submission coordination.',
    `risk_level` STRING COMMENT 'Overall risk classification of the APQP project based on technical complexity, supplier readiness, regulatory requirements, and schedule criticality. Drives escalation and resource allocation decisions.. Valid values are `low|medium|high|critical`',
    `rohs_reach_applicable` BOOLEAN COMMENT 'Indicates whether the product subject to this APQP project must comply with EU RoHS and REACH chemical substance regulations, triggering mandatory compliance documentation in the PPAP package.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this APQP project record originates (e.g., SAP S/4HANA QM, Siemens Opcenter MES), supporting data lineage and integration traceability.',
    `status` STRING COMMENT 'Current lifecycle status of the APQP project, driving workflow routing, gate review scheduling, and management escalation.. Valid values are `draft|active|on_hold|gate_review|customer_approval_pending|completed|cancelled`',
    `target_launch_date` DATE COMMENT 'Planned date for production launch (Phase 5 completion), representing the committed date for first production shipment to the customer.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_apqp_project PRIMARY KEY(`apqp_project_id`)
) COMMENT 'Advanced Product Quality Planning (APQP) project record managing the structured new product introduction quality planning lifecycle across five phases: planning, product design, process design, product/process validation, and production launch. Tracks gate milestones, deliverable completion, risk status, and customer approval checkpoints.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` (
    `apqp_deliverable_id` BIGINT COMMENT 'Unique system-generated identifier for each APQP deliverable record within the quality management system.',
    `apqp_project_id` BIGINT COMMENT 'Foreign key linking to quality.apqp_project. Business justification: An APQP deliverable is a child record of an APQP project — each deliverable (design FMEA, process flow, control plan, etc.) belongs to a specific APQP project phase. The apqp_project_number string fie',
    `actual_completion_date` DATE COMMENT 'Date on which the APQP deliverable was actually completed and submitted for review, used to measure schedule adherence and identify delays.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_date` DATE COMMENT 'Date on which the APQP deliverable received formal approval from the designated approver, marking the completion of the review and sign-off process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_status` STRING COMMENT 'Formal approval disposition of the APQP deliverable, indicating whether it has been reviewed and approved by the responsible authority, conditionally approved with open actions, or rejected requiring rework.. Valid values are `pending|conditionally_approved|approved|rejected|not_required`',
    `approved_by` STRING COMMENT 'Name or identifier of the individual who formally approved this APQP deliverable, providing accountability and audit trail for the approval decision.',
    `apqp_phase` STRING COMMENT 'The APQP phase to which this deliverable belongs, aligned with the five-phase AIAG APQP framework: Plan and Define, Product Design and Development, Process Design and Development, Product and Process Validation, and Feedback Assessment and Corrective Action.. Valid values are `phase_1_plan_and_define|phase_2_product_design_and_development|phase_3_process_design_and_development|phase_4_product_and_process_validation|phase_5_feedback_assessment_and_corrective_action`',
    `comments` STRING COMMENT 'Free-text field for additional notes, reviewer feedback, or contextual information related to the APQP deliverable, supporting communication within the APQP project team.',
    `completion_percentage` DECIMAL(18,2) COMMENT 'Percentage of work completed for this APQP deliverable, used for progress tracking and project status reporting within the APQP project plan.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this APQP deliverable record was created in the system, providing an audit trail for record creation and supporting compliance with ISO 9001 document control requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_approval_required` BOOLEAN COMMENT 'Indicates whether this APQP deliverable requires formal customer review and approval before it can be considered complete, applicable for customer-specific APQP requirements.. Valid values are `true|false`',
    `customer_approved_date` DATE COMMENT 'Date on which the customer formally approved this APQP deliverable, applicable when customer approval is required as part of the PPAP or APQP process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `customer_code` STRING COMMENT 'Identifier of the customer for whom this APQP deliverable is being prepared, supporting customer-specific quality planning requirements and PPAP submission tracking.',
    `deliverable_name` STRING COMMENT 'Descriptive name of the APQP deliverable, providing a human-readable title for identification and reporting purposes.',
    `deliverable_number` STRING COMMENT 'Business-facing unique reference number for the APQP deliverable, used for cross-system tracking and documentation referencing.. Valid values are `^APQP-DLV-[A-Z0-9]{4,20}$`',
    `deliverable_type` STRING COMMENT 'Classification of the APQP deliverable type as defined by the AIAG APQP framework, such as Design FMEA, Process Flow Diagram, Control Plan, MSA Study, or Capability Study.. Valid values are `design_fmea|process_fmea|process_flow_diagram|control_plan|msa_study|capability_study|measurement_system_analysis|design_verification_plan|prototype_build_control_plan|pre_launch_control_plan|production_control_plan|first_article_inspection|ppap_submission|packaging_specification|floor_plan_layout|reaction_plan|other`',
    `document_reference` STRING COMMENT 'Reference identifier or URL linking to the actual deliverable document stored in the PLM or document management system, such as a Teamcenter document number or SharePoint path.',
    `document_version` STRING COMMENT 'Version or revision identifier of the linked deliverable document, ensuring traceability to the specific document revision that was reviewed and approved.',
    `gate_review_required` BOOLEAN COMMENT 'Indicates whether this APQP deliverable is a mandatory gate review item that must be formally signed off before the APQP project can advance to the next phase.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this APQP deliverable record was last updated, supporting change tracking, audit trail requirements, and data freshness assessment.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `open_issues_count` STRING COMMENT 'Number of open action items or issues associated with this APQP deliverable that must be resolved before final approval, used to track readiness and gate review decisions.. Valid values are `^[0-9]+$`',
    `part_name` STRING COMMENT 'Descriptive name of the part or component associated with this APQP deliverable, providing human-readable product identification for reporting and communication.',
    `part_number` STRING COMMENT 'Engineering part number of the product or component to which this APQP deliverable applies, enabling traceability to the product design and manufacturing process.',
    `part_revision` STRING COMMENT 'Engineering revision level of the part or component at the time this APQP deliverable was created or last updated, ensuring alignment with the correct design iteration.',
    `planned_completion_date` DATE COMMENT 'Target completion date for this APQP deliverable as defined in the APQP project plan, used for milestone tracking and on-time delivery measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_start_date` DATE COMMENT 'Scheduled start date for work on this APQP deliverable as defined in the APQP project plan, used for timeline management and resource scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `plant_code` STRING COMMENT 'Manufacturing plant or facility code where the product associated with this APQP deliverable will be produced, enabling plant-level quality planning and reporting.',
    `ppap_element_number` STRING COMMENT 'PPAP element number corresponding to this deliverable as defined in the AIAG PPAP standard (e.g., Element 3 for Design FMEA, Element 8 for MSA Study), enabling structured PPAP package assembly.',
    `ppap_level` STRING COMMENT 'PPAP submission level associated with this deliverable, indicating the extent of documentation and evidence required for customer approval per AIAG PPAP guidelines.. Valid values are `level_1|level_2|level_3|level_4|level_5|not_applicable`',
    `priority` STRING COMMENT 'Business priority level assigned to the APQP deliverable, used to drive resource allocation and escalation decisions within the APQP project team.. Valid values are `critical|high|medium|low`',
    `rejection_reason` STRING COMMENT 'Description of the reason(s) for rejection when an APQP deliverable has been rejected during review, providing guidance for rework and corrective action.',
    `responsible_department` STRING COMMENT 'Organizational department or function responsible for producing this APQP deliverable, such as Quality Engineering, Design Engineering, Manufacturing Engineering, or Supplier Quality.',
    `responsible_owner` STRING COMMENT 'Name or identifier of the individual or team accountable for completing and delivering this APQP deliverable on time and to the required quality standard.',
    `revised_completion_date` DATE COMMENT 'Updated target completion date for the APQP deliverable when the original planned date has been formally revised due to scope changes, resource constraints, or project delays.. Valid values are `^d{4}-d{2}-d{2}$`',
    `risk_level` STRING COMMENT 'Risk level assigned to this APQP deliverable based on technical complexity, schedule criticality, or supplier capability, used to prioritize management attention and mitigation actions.. Valid values are `high|medium|low|not_assessed`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this APQP deliverable record originated, such as Siemens Teamcenter PLM or SAP S/4HANA QM, supporting data lineage and integration traceability.',
    `status` STRING COMMENT 'Current workflow status of the APQP deliverable, tracking its progression from initiation through completion and approval.. Valid values are `not_started|in_progress|pending_review|approved|rejected|on_hold|cancelled|overdue`',
    `supplier_code` STRING COMMENT 'Identifier of the supplier responsible for or associated with this APQP deliverable, applicable when the deliverable relates to a purchased component or supplier development activity.',
    CONSTRAINT pk_apqp_deliverable PRIMARY KEY(`apqp_deliverable_id`)
) COMMENT 'Individual APQP deliverable tracking record within an APQP project phase — e.g., design FMEA, process flow diagram, control plan, MSA study, capability study. Captures deliverable type, responsible owner, planned and actual completion dates, approval status, and linked document reference.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`defect_code` (
    `defect_code_id` BIGINT COMMENT 'Unique surrogate identifier for each defect code record in the enterprise quality management system. Serves as the primary key for the defect code master reference table.',
    `applicable_industry_sector` STRING COMMENT 'Industry sector or product line for which this defect code is relevant (e.g., Automation Systems, Electrification, Smart Infrastructure, Transportation). Supports multi-division enterprises where defect taxonomies may differ by business unit.',
    `applicable_material_type` STRING COMMENT 'Type of material or product to which this defect code is applicable. Restricts defect code selection during inspection to relevant material types, reducing data entry errors and improving defect data quality.. Valid values are `raw_material|semi-finished|finished_good|purchased_component|all`',
    `approved_by` STRING COMMENT 'Name or employee ID of the quality authority (e.g., Quality Manager, Quality Engineer) who approved this defect code for use in the enterprise defect taxonomy. Supports audit trail and change control requirements.',
    `approved_date` DATE COMMENT 'Date on which this defect code was formally approved by the designated quality authority. Part of the document control and change management audit trail required by ISO 9001.. Valid values are `^d{4}-d{2}-d{2}$`',
    `aql_level` STRING COMMENT 'Default Acceptable Quality Level associated with this defect code for sampling inspection purposes. Defines the maximum percent defective that can be considered satisfactory as a process average for this defect type.. Valid values are `0.065|0.10|0.15|0.25|0.40|0.65|1.0|1.5|2.5|4.0|6.5|10.0`',
    `capa_required` BOOLEAN COMMENT 'Indicates whether detection of this defect type mandates the initiation of a CAPA record. Automates CAPA workflow triggering in the QMS for high-severity or recurring defect types.. Valid values are `true|false`',
    `catalog_code_group` STRING COMMENT 'SAP QM catalog code group to which this defect code belongs. Code groups organize related defect codes within a catalog for structured selection during inspection result recording and NCR creation.. Valid values are `^[A-Z0-9_-]{1,10}$`',
    `catalog_type` STRING COMMENT 'SAP QM catalog type classification indicating whether this code represents a defect type (what went wrong), defect cause (why it went wrong), defect location (where on the part), or defect action (what was done). Aligns with SAP QM catalog 1/2/3/5 structure.. Valid values are `defect_type|defect_cause|defect_location|defect_action`',
    `category` STRING COMMENT 'High-level classification of the defect type based on its nature. Dimensional defects relate to out-of-tolerance measurements; surface defects include scratches, porosity, and finish issues; functional defects affect product performance; material defects relate to wrong or substandard material; assembly defects arise from incorrect assembly operations.. Valid values are `dimensional|surface|functional|material|assembly|electrical|cosmetic|documentation|packaging|other`',
    `change_notice_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Quality Change Order that authorized the creation or modification of this defect code. Provides traceability between defect taxonomy changes and formal change management records.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `code` STRING COMMENT 'Standardized alphanumeric code uniquely identifying a specific defect type within the enterprise defect taxonomy. Used across NCRs, inspection results, scrap/rework transactions, and CAPA records to ensure consistent defect classification.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this defect code record was first created in the system. Used for audit trail, data lineage, and change history tracking in compliance with ISO 9001 documented information requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_notification_required` BOOLEAN COMMENT 'Indicates whether the customer must be notified when this defect type is detected on product destined for or already delivered to them. Supports SLA compliance and customer quality agreement obligations.. Valid values are `true|false`',
    `customer_standard_reference` STRING COMMENT 'Reference to a customer-specific quality standard, drawing note, or specification that defines acceptance criteria for this defect type. Enables customer-specific defect taxonomy mapping for OEM and key account quality reporting.',
    `default_disposition` STRING COMMENT 'Default material disposition action recommended for nonconforming product carrying this defect code. Provides a starting point for quality engineers during usage decision processing, though final disposition may be overridden case-by-case.. Valid values are `scrap|rework|use_as_is|return_to_supplier|sort|reinspect|pending_review`',
    `default_severity_rating` STRING COMMENT 'Default FMEA severity rating (1–10 scale) associated with this defect type, as defined in the enterprise FMEA reference manual. Used to pre-populate FMEA records and to prioritize defect types in Risk Priority Number (RPN) calculations.. Valid values are `^([1-9]|10)$`',
    `defect_class` STRING COMMENT 'Severity classification of the defect based on its impact on product safety, function, and customer satisfaction. Critical defects may cause safety hazards or regulatory non-compliance; major defects significantly impair function or appearance; minor defects are slight deviations with minimal impact; incidental defects are negligible.. Valid values are `critical|major|minor|incidental`',
    `defect_family` STRING COMMENT 'Grouping of related defect codes into a logical family for Pareto analysis, trend reporting, and Six Sigma improvement projects. Examples: Weld Defects, Machining Defects, Surface Treatment Defects. Enables roll-up reporting across defect codes.',
    `detection_method` STRING COMMENT 'Primary inspection or detection method used to identify this defect type. Informs inspection plan design, gauge selection, and SPC control strategy. Aligns with FMEA detection controls.. Valid values are `visual|dimensional|functional|destructive|non-destructive|automated|spc|gauge|cmm|x-ray|ultrasonic|other`',
    `external_code_mapping` STRING COMMENT 'Corresponding defect code or classification identifier used by a customer, supplier, or external standard body. Enables cross-reference between the enterprise defect taxonomy and external quality systems for EDI, customer portal reporting, and supplier scorecards.',
    `iso_standard_reference` STRING COMMENT 'Reference to the applicable ISO standard clause or section that defines or governs this defect type. Examples: ISO 9001:2015 Clause 8.7, ISO 1101 (Geometric Tolerancing), ISO 8062 (Casting Tolerances). Supports compliance traceability.',
    `language_code` STRING COMMENT 'ISO 639-1 language code for the language in which the defect code descriptions are maintained (e.g., en, de, zh-CN). Supports multilingual defect taxonomy for global manufacturing operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this defect code record. Supports change tracking, data freshness monitoring, and audit compliance for the quality master data management process.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `long_description` STRING COMMENT 'Detailed narrative description of the defect, including observable characteristics, typical manifestation, and distinguishing features. Used for inspector training, FMEA documentation, and CAPA root cause analysis.',
    `ncr_auto_create` BOOLEAN COMMENT 'Indicates whether detection of this defect type during inspection should automatically trigger creation of a Non-Conformance Report (NCR) in the QMS without manual intervention. Supports automated quality workflow execution.. Valid values are `true|false`',
    `plant_applicability` STRING COMMENT 'Comma-separated list or wildcard pattern of plant codes where this defect code is valid and available for use. Supports multi-plant enterprises where certain defect types are specific to particular manufacturing sites or technologies.',
    `ppap_relevant` BOOLEAN COMMENT 'Indicates whether this defect type is relevant to PPAP submission requirements. PPAP-relevant defects must be addressed in the control plan and may require customer approval before production release.. Valid values are `true|false`',
    `ppm_threshold` DECIMAL(18,2) COMMENT 'Maximum acceptable defect occurrence rate expressed in Parts Per Million (PPM) for this defect type. Used to set quality targets, trigger CAPA escalation, and evaluate supplier quality performance against contractual PPM commitments.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `process_stage` STRING COMMENT 'Manufacturing or supply chain process stage at which this defect type is typically detected or originates. Used to route inspection findings to the correct process owner and to focus PFMEA and SPC controls at the right stage.. Valid values are `incoming|in-process|final|outgoing|field|supplier|design|assembly|machining|welding|painting|testing|packaging|other`',
    `regulatory_reportable` BOOLEAN COMMENT 'Indicates whether occurrences of this defect type must be reported to a regulatory authority (e.g., CE Marking body, UL, EPA, OSHA). Drives automated regulatory notification workflows in the QMS.. Valid values are `true|false`',
    `rework_cost_category` STRING COMMENT 'Categorical classification of the typical rework cost associated with this defect type. Used for cost-of-quality (COQ) analysis, scrap/rework budget planning, and prioritization of defect prevention investments.. Valid values are `low|medium|high|critical`',
    `rohs_reach_relevant` BOOLEAN COMMENT 'Indicates whether this defect type is relevant to RoHS or REACH regulatory compliance. When true, NCRs carrying this defect code may trigger mandatory regulatory reporting and customer notification workflows.. Valid values are `true|false`',
    `safety_critical` BOOLEAN COMMENT 'Indicates whether this defect type is classified as safety-critical, meaning its occurrence could result in personal injury, equipment damage, or regulatory non-compliance. Safety-critical defects trigger mandatory escalation, hold, and CAPA workflows.. Valid values are `true|false`',
    `short_description` STRING COMMENT 'Brief, standardized label for the defect code used in dropdown selections, reports, and shop floor displays. Typically 5–50 characters for quick identification.',
    `source_system` STRING COMMENT 'Operational system of record from which this defect code was originated or is mastered. Supports data lineage tracking and reconciliation across SAP QM, Siemens Opcenter MES, and Teamcenter PLM systems.. Valid values are `SAP_QM|OPCENTER_MES|TEAMCENTER_PLM|MANUAL|OTHER`',
    `spc_applicable` BOOLEAN COMMENT 'Indicates whether Statistical Process Control monitoring should be applied to track the occurrence rate of this defect type over time. When true, SPC charts (e.g., p-chart, c-chart) are generated for this defect code in the quality analytics platform.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current lifecycle status of the defect code record. Active codes are available for use in inspections and NCRs; inactive codes are temporarily disabled; obsolete codes are retired and no longer assignable to new transactions; under_review codes are pending approval for activation or modification.. Valid values are `active|inactive|obsolete|under_review`',
    `valid_from` DATE COMMENT 'Date from which this defect code is valid and available for use in quality transactions. Supports time-bounded defect taxonomy management and ensures historical records reference the correct code version.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'Date after which this defect code is no longer valid for use in new quality transactions. Enables planned obsolescence of defect codes while preserving historical data integrity.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_defect_code PRIMARY KEY(`defect_code_id`)
) COMMENT 'Reference master for standardized defect classification codes used across NCRs, inspection results, and scrap/rework transactions. Captures defect code, defect category (dimensional, surface, functional, material, assembly), defect family, applicable process stage, and ISO/customer standard mapping. Ensures consistent defect taxonomy enterprise-wide.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`characteristic` (
    `characteristic_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a quality characteristic (Critical to Quality feature) master record within the Quality Management System.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Quality characteristics define measurable attributes of components derived from engineering specifications. Each characteristic links to specific component dimensions, tolerances, or material properti',
    `approved_by` STRING COMMENT 'Name or employee ID of the quality engineer or quality manager who approved this characteristic definition for use in production inspection. Required for ISO 9001 documented information control.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this quality characteristic definition was formally approved for production use. Provides an audit trail for ISO 9001 documented information control and PPAP submission evidence.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `aql_level` STRING COMMENT 'The Acceptable Quality Level (AQL) assigned to this characteristic, representing the maximum percent defective (or defects per hundred units) that is considered acceptable as a process average. Drives the sampling plan stringency for this characteristic.. Valid values are `0.065|0.10|0.15|0.25|0.40|0.65|1.0|1.5|2.5|4.0|6.5|10.0`',
    `category` STRING COMMENT 'Indicates whether the characteristic is measured on a continuous variable scale (e.g., diameter in mm) or evaluated as a pass/fail attribute (e.g., presence of a feature, visual conformance). Drives the appropriate SPC chart type and sampling plan.. Valid values are `variable|attribute`',
    `change_notice_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that created or last modified this quality characteristic definition. Provides full traceability from characteristic specification to the approved design change.',
    `classification` STRING COMMENT 'Risk-based classification of the characteristic indicating its impact on safety, regulatory compliance, or product function. Critical characteristics affect safety or regulatory compliance; major characteristics affect product function or customer satisfaction; minor characteristics have limited impact; informational characteristics are tracked for data collection only.. Valid values are `critical|major|minor|informational`',
    `cp_minimum_required` DECIMAL(18,2) COMMENT 'The minimum acceptable Cp (Process Capability Index) value required for this characteristic, representing the ratio of specification width to process spread. Used alongside Cpk to assess both process spread and centering in capability studies.. Valid values are `^[0-9]{1,2}.[0-9]{1,2}$`',
    `cpk_minimum_required` DECIMAL(18,2) COMMENT 'The minimum acceptable Cpk (Process Capability Index — Centered) value required for this characteristic to demonstrate process capability. Typical thresholds are 1.33 for standard characteristics and 1.67 for safety-critical or CTQ characteristics. Used in PPAP capability studies.. Valid values are `^[0-9]{1,2}.[0-9]{1,2}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this quality characteristic master record was first created in the system. Supports audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ctq_flag` BOOLEAN COMMENT 'Indicates whether this characteristic is designated as Critical to Quality (CTQ) — a feature whose performance standard must be met to satisfy the customer. CTQ characteristics receive heightened inspection frequency, SPC monitoring, and PPAP documentation requirements.. Valid values are `true|false`',
    `decimal_places` STRING COMMENT 'Number of decimal places to which the characteristic measurement should be recorded and displayed. Drives measurement resolution requirements and gauge selection. For example, a diameter measured to 0.001 mm requires 3 decimal places.. Valid values are `^[0-9]$`',
    `destructive_test` BOOLEAN COMMENT 'Indicates whether measurement of this characteristic requires destructive testing (i.e., the part cannot be used after measurement). Destructive characteristics require special sampling strategies and cannot be 100% inspected.. Valid values are `true|false`',
    `drawing_number` STRING COMMENT 'Reference to the engineering drawing or CAD document from which this quality characteristic specification is derived. Provides traceability to the design record and supports PPAP documentation requirements.',
    `drawing_revision` STRING COMMENT 'Revision level of the engineering drawing from which this characteristic specification is sourced. Ensures that inspection requirements are aligned with the current approved design revision.. Valid values are `^[A-Z0-9]{1,5}$`',
    `gauge_type` STRING COMMENT 'Type of measurement instrument or gauge required to measure this quality characteristic. Used to link the characteristic to calibrated measurement equipment in the gauge management system and to define MSA (Measurement System Analysis) requirements.. Valid values are `caliper|micrometer|cmm|go_no_go_gauge|optical_comparator|profilometer|hardness_tester|tensile_tester|spectrometer|vision_system|torque_wrench|pressure_gauge|thermometer|multimeter|coordinate_measuring_machine|laser_scanner|ultrasonic_tester|other`',
    `group` STRING COMMENT 'Logical grouping of related quality characteristics for organizational and reporting purposes (e.g., Geometric Tolerances, Surface Finish, Mechanical Properties, Chemical Composition). Used to structure inspection plans and control plans.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this quality characteristic master record was last updated. Used for change tracking, data synchronization, and audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lower_spec_limit` DECIMAL(18,2) COMMENT 'The minimum allowable value for the quality characteristic as defined in the engineering specification or customer requirement. Measurements below this limit are non-conforming.',
    `lower_tolerance` DECIMAL(18,2) COMMENT 'The negative tolerance deviation from the nominal value (e.g., -0.05 mm). Together with upper_tolerance, defines the bilateral or unilateral tolerance band around the nominal value as specified on engineering drawings.',
    `material_number` STRING COMMENT 'SAP material number of the part, assembly, or raw material to which this quality characteristic applies. Enables traceability from the characteristic definition to the specific material master record.',
    `measurement_method` STRING COMMENT 'Description of the prescribed measurement method or procedure for evaluating this characteristic (e.g., Measure at 3 cross-sections using CMM, Visual inspection under 10x magnification, Tensile test per ASTM E8). References the applicable test standard or SOP.',
    `name` STRING COMMENT 'Descriptive name of the quality characteristic (e.g., Shaft Outer Diameter, Surface Roughness Ra, Tensile Strength). Used in inspection plans, control plans, and operator instructions.',
    `nominal_value` DECIMAL(18,2) COMMENT 'The target or ideal value for the quality characteristic as specified in the engineering drawing or product specification. Serves as the reference point for tolerance calculations and SPC centerline.',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the quality characteristic as defined in SAP QM master data (e.g., inspection characteristic catalog number). Used to reference the characteristic across inspection plans, control plans, and SPC charts.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where this quality characteristic is applicable. Supports multi-plant operations where the same part may have plant-specific inspection requirements.. Valid values are `^[A-Z0-9]{4}$`',
    `regulatory_flag` BOOLEAN COMMENT 'Indicates whether this characteristic is subject to regulatory compliance requirements (e.g., RoHS/REACH chemical limits, CE marking dimensional tolerances, UL electrical ratings). Non-conformance may trigger mandatory regulatory reporting.. Valid values are `true|false`',
    `safety_critical_flag` BOOLEAN COMMENT 'Indicates whether this characteristic is safety-critical, meaning non-conformance could result in personal injury, property damage, or regulatory non-compliance. Safety-critical characteristics require mandatory inspection and cannot be skipped or waived.. Valid values are `true|false`',
    `sampling_procedure_code` STRING COMMENT 'Code referencing the applicable sampling procedure or plan for this characteristic (e.g., AQL sampling plan code, skip-lot procedure code). Determines how many samples are drawn from a lot for inspection of this characteristic.',
    `short_description` STRING COMMENT 'Abbreviated description of the quality characteristic for use in reports, shop floor displays, and HMI screens where space is limited.',
    `skip_lot_eligible` BOOLEAN COMMENT 'Indicates whether this characteristic is eligible for skip-lot inspection (reduced inspection frequency based on demonstrated supplier or process quality history). Safety-critical and CTQ characteristics are typically excluded from skip-lot programs.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this quality characteristic master record originates (e.g., SAP QM inspection characteristic catalog, Siemens Teamcenter PLM, Siemens Opcenter MES). Supports data lineage and reconciliation in the lakehouse.. Valid values are `SAP_QM|TEAMCENTER|OPCENTER|MANUAL|OTHER`',
    `spc_chart_type` STRING COMMENT 'The type of SPC control chart used to monitor this characteristic. Variable charts (Xbar-R, Xbar-S, I-MR) are used for continuous measurements; attribute charts (p, np, c, u) are used for pass/fail or count data. CUSUM and EWMA are used for detecting small shifts.. Valid values are `xbar_r|xbar_s|individuals_mr|p_chart|np_chart|c_chart|u_chart|cusum|ewma`',
    `spc_enabled` BOOLEAN COMMENT 'Indicates whether Statistical Process Control (SPC) monitoring is activated for this characteristic. When true, measurement results are plotted on control charts and evaluated against control limits to detect process instability.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current lifecycle status of the quality characteristic master record. Active characteristics are available for use in inspection plans; inactive are temporarily suspended; obsolete are retired; under_review are pending engineering change approval.. Valid values are `active|inactive|obsolete|under_review`',
    `type` STRING COMMENT 'Classification of the quality characteristic by its physical or functional nature. Dimensional covers length/diameter/angle; functional covers performance attributes; visual covers appearance; material covers composition/hardness; electrical covers voltage/resistance; chemical covers composition/purity.. Valid values are `dimensional|functional|visual|material|electrical|chemical|mechanical|thermal|geometric|surface`',
    `unit_of_measure` STRING COMMENT 'The engineering unit in which the quality characteristic is measured and expressed (e.g., mm for dimensional, MPa for tensile strength, Ra for surface roughness, HRC for hardness, % for chemical composition). Aligns with SI units and industry-standard measurement units.. Valid values are `mm|cm|m|in|ft|kg|g|lb|N|Nm|MPa|GPa|bar|psi|°C|°F|K|V|A|Ω|Hz|%|ppm|μm|Ra|Rz|HRC|HB|HV|mm²|cm³|L|mL|lux|dB|`',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'The maximum allowable value for the quality characteristic as defined in the engineering specification or customer requirement. Measurements exceeding this limit are non-conforming.',
    `upper_tolerance` DECIMAL(18,2) COMMENT 'The positive tolerance deviation from the nominal value (e.g., +0.05 mm). Together with lower_tolerance, defines the bilateral or unilateral tolerance band around the nominal value as specified on engineering drawings.',
    `work_center_code` STRING COMMENT 'Code identifying the production work center or process step where this characteristic is measured. Links the characteristic to the specific manufacturing operation in the routing or Bill of Process (BoP).',
    `valid_from` DATE COMMENT 'The date from which this quality characteristic definition is effective and may be used in inspection plans. Supports time-phased characteristic management aligned with engineering change notices (ECN/ECO).. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'The date after which this quality characteristic definition is no longer effective. Used to manage characteristic obsolescence aligned with engineering change orders (ECO) and product end-of-life.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_characteristic PRIMARY KEY(`characteristic_id`)
) COMMENT 'Master record for quality characteristics (CTQ — Critical to Quality features) defined for parts, assemblies, or processes. Captures characteristic name, type (dimensional, functional, visual, material), nominal value, tolerance limits, measurement unit, gauge type, and classification (critical, major, minor). Referenced by inspection plans, control plans, and SPC charts.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`gauge` (
    `gauge_id` BIGINT COMMENT 'Unique system-generated identifier for each gauge or measurement instrument master record in the Quality Management System.',
    `asset_register_id` BIGINT COMMENT 'Foreign key linking to finance.asset_register. Business justification: Measurement equipment above capitalization thresholds are fixed assets requiring depreciation tracking, asset tagging, and financial reporting in manufacturing.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Measurement gauges are physical assets requiring maintenance, calibration, and lifecycle management. Asset management tracks gauge location, condition, and maintenance history as critical measurement ',
    `it_asset_id` BIGINT COMMENT 'Foreign key linking to technology.it_asset. Business justification: Digital gauges (CMMs, vision systems, digital micrometers) are IT assets requiring tracking, maintenance, and lifecycle management. Manufacturing facilities manage these as part of their IT asset inve',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: Gauges are assigned to specific work centers where theyre used for inspection. Quality technicians need to locate gauges by work center for production support.',
    `accuracy` DECIMAL(18,2) COMMENT 'Manufacturer-specified accuracy or maximum permissible error (MPE) of the gauge, expressed in the gauges unit of measure. Used to assess fitness for purpose against tolerance requirements.',
    `asset_tag_number` STRING COMMENT 'Internal fixed-asset tag or barcode label number affixed to the physical gauge, used for asset tracking in the EAM/CMMS system (Maximo) and physical inventory audits.',
    `assigned_location` STRING COMMENT 'Physical location where the gauge is assigned and stored when not in use, such as a plant code, building, room, or work center (e.g., Plant 01 – Metrology Lab, Work Center WC-100).',
    `calibration_certificate_number` STRING COMMENT 'Reference number of the most recent calibration certificate issued by the calibrating laboratory. Provides traceability to national or international measurement standards.',
    `calibration_interval_days` STRING COMMENT 'Defined frequency of calibration expressed in calendar days, as established by the metrology program. Drives automatic calculation of the next calibration due date.. Valid values are `^[1-9][0-9]*$`',
    `calibration_lab_accreditation_number` STRING COMMENT 'Accreditation body certificate number for the calibration laboratory (e.g., A2LA, UKAS, DAkkS accreditation number), confirming traceability to national measurement standards.',
    `calibration_lab_name` STRING COMMENT 'Name of the internal or external laboratory that performed the most recent calibration. External labs should be accredited to ISO/IEC 17025.',
    `calibration_status` STRING COMMENT 'Current calibration validity status of the gauge. Calibrated indicates the gauge is within its valid calibration period; overdue indicates the calibration due date has passed; out_of_service indicates the gauge is removed from use pending repair or calibration.. Valid values are `calibrated|overdue|out_of_service|in_calibration|retired|lost`',
    `calibration_type` STRING COMMENT 'Indicates whether calibration is performed by an internal metrology lab, an external accredited laboratory, or on-site by a field calibration service.. Valid values are `internal|external|on_site`',
    `cost_center` STRING COMMENT 'Financial cost center responsible for the gauge, used for CAPEX/OPEX allocation of calibration costs and depreciation in SAP CO.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the gauge is physically located. Supports multinational regulatory compliance and regional metrology authority reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the gauge master record was first created in the Quality Management System. Used for audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the purchase cost and any financial values associated with the gauge (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Full descriptive name of the gauge or measurement instrument, including make, model, and key measurement capability (e.g., Mitutoyo Digital Caliper 0-150mm).',
    `is_reference_standard` BOOLEAN COMMENT 'Indicates whether this gauge serves as a reference or master standard used to calibrate other working gauges within the internal metrology hierarchy.. Valid values are `true|false`',
    `last_calibration_date` DATE COMMENT 'Date on which the most recent calibration of the gauge was performed. Used to calculate calibration status and next due date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the gauge master record. Used for change tracking, audit compliance, and data synchronization with source systems.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_msa_date` DATE COMMENT 'Date on which the most recent Measurement System Analysis (MSA) or Gauge Repeatability and Reproducibility (Gauge R&R) study was conducted for this gauge.. Valid values are `^d{4}-d{2}-d{2}$`',
    `manufacturer` STRING COMMENT 'Name of the original equipment manufacturer (OEM) of the gauge or measurement instrument (e.g., Mitutoyo, Hexagon, Starrett, Fluke).',
    `measurement_range_max` DECIMAL(18,2) COMMENT 'Upper bound of the gauges measurement range, expressed in the gauges unit of measure. Defines the maximum measurable value for capability assessment.',
    `measurement_range_min` DECIMAL(18,2) COMMENT 'Lower bound of the gauges measurement range, expressed in the gauges unit of measure. Defines the minimum measurable value for capability assessment.',
    `model_number` STRING COMMENT 'Manufacturer-assigned model or part number for the gauge, used for procurement, spare parts identification, and technical documentation lookup.',
    `msa_required` BOOLEAN COMMENT 'Indicates whether a formal Measurement System Analysis (MSA) — including Gauge R&R study — is required for this gauge per the AIAG MSA manual or PPAP requirements.. Valid values are `true|false`',
    `next_calibration_due_date` DATE COMMENT 'Scheduled date by which the gauge must be recalibrated to remain in a valid calibration status. Derived from last calibration date plus calibration interval.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Human-readable business identifier for the gauge, typically assigned by the metrology or quality department and used on calibration certificates and inspection records.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `out_of_tolerance_action` STRING COMMENT 'Defined action to be taken when the gauge is found out of tolerance during calibration. Drives the CAPA or NCR workflow for affected measurements made since the last valid calibration.. Valid values are `repair|replace|adjust|retire|escalate|use_as_is_with_restriction`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site to which the gauge is assigned. Supports multi-site gauge inventory management.. Valid values are `^[A-Z0-9]{2,10}$`',
    `purchase_cost` DECIMAL(18,2) COMMENT 'Original acquisition cost of the gauge in the transaction currency. Used for asset valuation, CAPEX reporting, and cost-benefit analysis of calibration vs. replacement decisions.',
    `purchase_date` DATE COMMENT 'Date on which the gauge was originally purchased or acquired. Used for asset lifecycle management, depreciation calculation, and warranty tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `recall_required` BOOLEAN COMMENT 'Indicates whether a measurement recall investigation is required for inspection results recorded with this gauge since its last valid calibration, triggered when the gauge is found out of tolerance.. Valid values are `true|false`',
    `resolution` DECIMAL(18,2) COMMENT 'Smallest increment of measurement the gauge can display or detect, expressed in the gauges unit of measure (e.g., 0.001 mm for a digital micrometer). Used in Measurement System Analysis (MSA).',
    `responsible_person` STRING COMMENT 'Name or employee ID of the quality or metrology technician responsible for managing the gauges calibration schedule and custody. Supports accountability under ISO 9001.',
    `rr_percent` DECIMAL(18,2) COMMENT 'Result of the most recent Gauge R&R study expressed as a percentage of total process variation or tolerance. Values below 10% are acceptable; 10–30% may be conditionally acceptable; above 30% requires corrective action.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `source_system` STRING COMMENT 'Operational system of record from which the gauge master record was sourced (e.g., SAP QM, Maximo EAM). Supports data lineage and reconciliation in the Databricks Silver Layer.. Valid values are `SAP_QM|Maximo|Manual|MindSphere|other`',
    `status` STRING COMMENT 'Overall lifecycle status of the gauge master record. Active indicates the gauge is available for use in inspection; retired indicates it has been permanently removed from service.. Valid values are `active|inactive|retired|lost|scrapped|on_loan`',
    `traceability_standard` STRING COMMENT 'National or international measurement standard to which the gauges calibration is traceable (e.g., NIST, PTB, NPL, BIPM). Required for ISO 9001 and ISO/IEC 17025 compliance.',
    `type` STRING COMMENT 'Classification of the measurement instrument by its measurement principle or physical form, such as CMM (Coordinate Measuring Machine), caliper, micrometer, go/no-go gauge, or torque wrench.. Valid values are `CMM|caliper|micrometer|go_no_go|torque_wrench|height_gauge|dial_indicator|bore_gauge|surface_roughness_tester|hardness_tester|optical_comparator|force_gauge|pressure_gauge|thermometer|multimeter|other`',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure in which the gauge records measurements (e.g., mm for dimensional gauges, Nm for torque wrenches, °C for thermometers).. Valid values are `mm|cm|m|in|ft|kg|g|lb|N|Nm|Pa|bar|psi|°C|°F|K|V|A|Ohm|Hz|rpm|other`',
    `warranty_expiry_date` DATE COMMENT 'Date on which the manufacturers warranty for the gauge expires. Used to determine whether repair or replacement costs are covered under warranty.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_gauge PRIMARY KEY(`gauge_id`)
) COMMENT 'Gauge and measurement instrument master record for all measuring equipment used in quality inspection. Captures gauge ID, description, gauge type (CMM, caliper, micrometer, go/no-go, torque wrench), calibration interval, last calibration date, next due date, calibration status, and assigned location. Supports ISO 9001 Clause 7.1.5 measurement resource management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` (
    `gauge_calibration_id` BIGINT COMMENT 'Unique system-generated identifier for each gauge calibration event record in the Quality Management System.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Gauge calibrations must record the certified technician who performed the calibration for measurement system traceability and ISO 17025 compliance.',
    `calibration_record_id` BIGINT COMMENT 'Foreign key linking to asset.calibration_record. Business justification: Gauge calibrations are asset calibration events. Asset management owns the calibration schedule and records; quality references these to validate measurement equipment certification before use.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Calibration services and metrology lab costs are charged to quality cost centers for departmental expense tracking and budget management.',
    `gauge_id` BIGINT COMMENT 'Unique identifier of the gauge or measurement instrument being calibrated, as registered in the measurement equipment master.',
    `service_ticket_id` BIGINT COMMENT 'Foreign key linking to technology.service_ticket. Business justification: Digital gauge calibration failures or software issues generate IT service tickets for troubleshooting. Metrology labs track these tickets to document technical support received and resolution time for',
    `adjustment_description` STRING COMMENT 'Description of any adjustments, repairs, or corrective actions performed on the gauge during the calibration event.',
    `adjustment_performed` BOOLEAN COMMENT 'Indicates whether the gauge required physical adjustment or repair during the calibration event to bring it within tolerance.. Valid values are `true|false`',
    `as_found_condition` STRING COMMENT 'Condition of the gauge as found at the start of calibration, before any adjustment. Indicates whether the instrument was within tolerance prior to calibration.. Valid values are `in_tolerance|out_of_tolerance|damaged|unknown`',
    `as_found_value` DECIMAL(18,2) COMMENT 'Actual measured value recorded at the start of calibration before any adjustment, used for MSA and drift analysis.',
    `as_left_condition` STRING COMMENT 'Condition of the gauge after calibration and any adjustments or repairs. Indicates the final state of the instrument upon return to service.. Valid values are `in_tolerance|out_of_tolerance|adjusted|repaired|condemned`',
    `as_left_value` DECIMAL(18,2) COMMENT 'Actual measured value recorded after calibration and any adjustments, confirming the instrument is within tolerance before return to service.',
    `calibration_event_number` STRING COMMENT 'Human-readable business identifier for the calibration event, used for traceability and audit trail purposes across the QMS.. Valid values are `^CAL-[0-9]{4}-[0-9]{6}$`',
    `calibration_interval_days` STRING COMMENT 'Defined recalibration interval in calendar days, used to schedule the next calibration event and manage the calibration program.. Valid values are `^[1-9][0-9]*$`',
    `calibration_lab_name` STRING COMMENT 'Name of the calibration laboratory (internal lab name or external accredited lab) that performed the calibration.',
    `calibration_lab_type` STRING COMMENT 'Indicates whether the calibration was performed by an internal metrology lab or an accredited external calibration laboratory.. Valid values are `internal|external`',
    `calibration_procedure_number` STRING COMMENT 'Reference number of the Standard Operating Procedure (SOP) or work instruction used to perform the calibration, ensuring repeatability and compliance.',
    `calibration_result` STRING COMMENT 'Overall pass/fail outcome of the calibration event. A fail result triggers gauge withdrawal from service and initiates a CAPA or NCR process.. Valid values are `pass|fail|conditional_pass|void`',
    `calibration_standard_used` STRING COMMENT 'Reference standard or master gauge used during calibration (e.g., NIST-traceable gauge block set, reference thermometer), ensuring measurement traceability.',
    `certificate_issue_date` DATE COMMENT 'Date on which the calibration certificate was issued by the calibration laboratory.. Valid values are `^d{4}-d{2}-d{2}$`',
    `certificate_number` STRING COMMENT 'Unique certificate number issued by the calibration laboratory upon completion of calibration, serving as the primary traceability document reference.',
    `comments` STRING COMMENT 'Free-text field for additional notes, observations, or remarks recorded by the calibration technician or quality engineer during the calibration event.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility where the calibration was performed, supporting multinational traceability and regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `department_code` STRING COMMENT 'Code identifying the department or work center responsible for the gauge (e.g., metrology lab, production floor, quality inspection).',
    `lab_accreditation_number` STRING COMMENT 'Accreditation certificate number of the external calibration laboratory (e.g., A2LA, NVLAP, UKAS accreditation number), confirming traceability to national standards.',
    `manufacturer` STRING COMMENT 'Name of the manufacturer or brand of the gauge or measurement instrument.',
    `measurement_uncertainty` DECIMAL(18,2) COMMENT 'Expanded measurement uncertainty (U) associated with the calibration result, expressed at a 95% confidence level (k=2), as required for MSA and traceability.',
    `measurement_unit` STRING COMMENT 'Unit of measure for the as-found and as-left calibration values (e.g., mm, inch, Nm, bar, °C, V, A).',
    `model_number` STRING COMMENT 'Manufacturer model or part number of the gauge, used for procurement, spare parts, and calibration procedure lookup.',
    `msa_study_reference` STRING COMMENT 'Reference number of the associated Measurement System Analysis (MSA) study (Gauge R&R, linearity, bias study) linked to this calibration event.',
    `next_calibration_due_date` DATE COMMENT 'Scheduled date by which the next calibration of this gauge must be completed to maintain measurement traceability and compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `out_of_service_flag` BOOLEAN COMMENT 'Indicates whether the gauge has been removed from service due to calibration failure, damage, or expiry. Triggers quarantine and prevents use in production measurements.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where the gauge is assigned and the calibration was performed.',
    `recall_required_flag` BOOLEAN COMMENT 'Indicates whether a measurement recall is required for parts or products measured with this gauge during the period it was found out of tolerance, triggering a quality impact assessment.. Valid values are `true|false`',
    `reviewed_by` STRING COMMENT 'Name or employee ID of the quality engineer or metrology supervisor who reviewed and approved the calibration record.',
    `source_system` STRING COMMENT 'Operational system of record from which this calibration record was sourced (e.g., SAP QM, Maximo EAM), supporting data lineage and audit trail in the lakehouse.. Valid values are `SAP_QM|Maximo_EAM|Manual|MindSphere|Other`',
    `standard_traceability_reference` STRING COMMENT 'Certificate or reference number of the calibration standard used, establishing the metrological traceability chain to national or international measurement standards.',
    `status` STRING COMMENT 'Current calibration status of the gauge. Active means in-service and within calibration period; overdue means past due date; withdrawn means removed from service pending calibration or repair.. Valid values are `active|overdue|withdrawn|expired|in_calibration|condemned`',
    `tolerance_lower_limit` DECIMAL(18,2) COMMENT 'Lower tolerance limit for the gauge measurement range, used to determine pass/fail of the calibration result.',
    `tolerance_upper_limit` DECIMAL(18,2) COMMENT 'Upper tolerance limit for the gauge measurement range, used to determine pass/fail of the calibration result.',
    CONSTRAINT pk_gauge_calibration PRIMARY KEY(`gauge_calibration_id`)
) COMMENT 'Calibration event record for each gauge or measurement instrument calibration activity. Captures calibration date, calibration lab (internal/external), calibration standard used, as-found and as-left condition, pass/fail result, calibration certificate number, and next scheduled calibration date. Provides full MSA and traceability audit trail.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`msa_study` (
    `msa_study_id` BIGINT COMMENT 'Unique system-generated identifier for the Measurement System Analysis (MSA) study record within the Quality Management System.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Measurement System Analysis studies require a qualified analyst employee to conduct GR&R studies and validate measurement capability per AIAG standards.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: MSA studies require statistical software (Minitab, JMP, etc.) for R&R calculations. IT manages these applications, and quality engineers must know which application version was used for audit complian',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.quality_characteristic. Business justification: An MSA study evaluates the adequacy of a measurement system for a specific quality characteristic. The characteristic_code, characteristic_name, and characteristic_type string fields are redundant onc',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: An MSA study validates the measurement system for a characteristic defined in a control plan. The control_plan_number string field is redundant once the FK to control_plan is established.',
    `gauge_id` BIGINT COMMENT 'Unique identifier of the measurement gauge or instrument used in the MSA study, cross-referenced with the calibration and asset management records.',
    `ppap_submission_id` BIGINT COMMENT 'Foreign key linking to quality.ppap_submission. Business justification: MSA studies are required elements of PPAP submissions (msa_complete flag exists in ppap_submission). The ppap_submission_number string field is redundant once the FK to ppap_submission is established.',
    `acceptability_decision` STRING COMMENT 'Overall acceptability verdict for the measurement system based on %GRR, number of distinct categories (ndc), and applicable acceptance criteria. Drives PPAP approval and control plan validation.. Valid values are `acceptable|conditionally_acceptable|unacceptable|requires_improvement`',
    `analysis_method` STRING COMMENT 'Statistical analysis method used to compute MSA results. ANOVA (Analysis of Variance) is the preferred method as it separates the interaction effect; Average & Range method is a simpler alternative.. Valid values are `average_range|anova|range_method`',
    `approved_by` STRING COMMENT 'Name or employee ID of the quality authority (e.g., Quality Engineer, Supplier Quality Engineer) who reviewed and approved the MSA study results.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the MSA study was formally approved by the quality authority, establishing the official record for PPAP and audit purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `bias_percent` DECIMAL(18,2) COMMENT 'Bias expressed as a percentage of the process tolerance or total variation, providing a normalized measure of systematic measurement error.',
    `bias_value` DECIMAL(18,2) COMMENT 'Systematic error of the measurement system — the difference between the observed average measurement and the reference (true) value. Applicable for bias and linearity study types.',
    `conducted_by` STRING COMMENT 'Name or employee ID of the quality engineer or technician responsible for planning and executing the MSA study.',
    `confidence_level_percent` DECIMAL(18,2) COMMENT 'Statistical confidence level applied in the MSA analysis (typically 95%). Determines the width of confidence intervals for %GRR and other statistical estimates.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility where the MSA study was performed, supporting multinational regulatory compliance and reporting.. Valid values are `^[A-Z]{3}$`',
    `expiry_date` DATE COMMENT 'Date after which the MSA study results are no longer considered valid and a re-study is required. Typically set based on calibration intervals, process changes, or customer-defined re-evaluation periods.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gauge_name` STRING COMMENT 'Descriptive name or model designation of the measurement gauge or instrument evaluated in the MSA study (e.g., CMM, micrometer, vision system).',
    `grr_basis` STRING COMMENT 'Basis used for calculating %GRR — either as a percentage of total study variation (TV) or as a percentage of the engineering tolerance. The basis affects acceptability thresholds and must be documented for PPAP.. Valid values are `study_variation|tolerance`',
    `grr_percent` DECIMAL(18,2) COMMENT '%GRR is the primary MSA acceptability metric expressing total measurement system variation (repeatability + reproducibility) as a percentage of total study variation or tolerance. Values <10% are acceptable, 10–30% may be conditionally acceptable, >30% are unacceptable per AIAG criteria.. Valid values are `^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$`',
    `linearity_value` DECIMAL(18,2) COMMENT 'Measure of the consistency of bias across the operating range of the measurement system. A non-zero linearity value indicates the gauge bias changes at different measurement points.',
    `ndc` STRING COMMENT 'Number of Distinct Categories (ndc) the measurement system can reliably distinguish within the process variation. An ndc ≥ 5 is required for an acceptable measurement system per AIAG criteria.. Valid values are `^[0-9]+$`',
    `number_of_appraisers` STRING COMMENT 'Count of operators or appraisers who participated in the MSA study. Typically 2–3 appraisers for a standard Gauge R&R study per AIAG guidelines.. Valid values are `^[1-9][0-9]*$`',
    `number_of_parts` STRING COMMENT 'Count of sample parts used in the MSA study. Typically 10 parts selected to represent the full range of process variation per AIAG guidelines.. Valid values are `^[1-9][0-9]*$`',
    `number_of_replicates` STRING COMMENT 'Number of repeated measurements taken by each appraiser on each part. Typically 2–3 replicates per AIAG guidelines to ensure statistical validity.. Valid values are `^[1-9][0-9]*$`',
    `part_number` STRING COMMENT 'Material or part number of the product component for which the measurement system is being evaluated, as defined in the engineering BOM.',
    `part_revision_level` STRING COMMENT 'Engineering revision level of the part at the time the MSA study was conducted, ensuring traceability to the correct design record.',
    `part_variation_percent` DECIMAL(18,2) COMMENT 'Percentage of total study variation attributable to actual part-to-part variation. A high %PV relative to %GRR indicates the measurement system can adequately distinguish between parts.. Valid values are `^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$`',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where the MSA study was conducted and where the measurement system is deployed.',
    `process_step` STRING COMMENT 'Manufacturing process step or operation at which the measurement system is applied, as referenced in the Process Flow Diagram and Control Plan.',
    `repeatability_percent` DECIMAL(18,2) COMMENT 'Percentage of total variation attributable to Equipment Variation (EV) — the within-appraiser measurement variation when the same appraiser measures the same part repeatedly with the same gauge.. Valid values are `^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$`',
    `reproducibility_percent` DECIMAL(18,2) COMMENT 'Percentage of total variation attributable to Appraiser Variation (AV) — the between-appraiser measurement variation when different appraisers measure the same part with the same gauge.. Valid values are `^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$`',
    `restudy_reason` STRING COMMENT 'Reason code explaining why a re-study of the measurement system is required or was triggered, supporting root cause analysis and corrective action tracking.. Valid values are `unacceptable_grr|gauge_modified|process_change|study_expired|customer_request|periodic_revalidation|other`',
    `restudy_required` BOOLEAN COMMENT 'Indicates whether a re-study of the measurement system is required due to unacceptable %GRR results, gauge modification, process change, or expiry of the previous study.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Operational system of record from which the MSA study data was originated or imported (e.g., SAP QM, Siemens Opcenter MES, Minitab statistical software).. Valid values are `SAP_QM|Opcenter_MES|Minitab|JMP|manual|other`',
    `stability_range` DECIMAL(18,2) COMMENT 'Range of measurement variation observed over time during a stability study, used to assess whether the measurement system remains consistent across different time periods.',
    `status` STRING COMMENT 'Current lifecycle status of the MSA study, from initial drafting through completion, approval, or rejection by the quality authority.. Valid values are `draft|in_progress|completed|approved|rejected|cancelled|superseded`',
    `study_date` DATE COMMENT 'Date on which the MSA study data collection was performed. Used for traceability, calibration currency verification, and PPAP documentation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `study_number` STRING COMMENT 'Human-readable business identifier for the MSA study, used for cross-referencing in PPAP packages, control plans, and quality records.. Valid values are `^MSA-[0-9]{4}-[0-9]{5}$`',
    `study_type` STRING COMMENT 'Classification of the MSA study methodology. Gauge R&R evaluates repeatability and reproducibility; linearity assesses bias across the operating range; bias measures systematic error; stability tracks measurement variation over time; attribute agreement analysis evaluates categorical measurement systems.. Valid values are `gauge_r_and_r|linearity|bias|stability|attribute_agreement|destructive_r_and_r`',
    `title` STRING COMMENT 'Descriptive title of the MSA study identifying the gauge, characteristic, and scope of the measurement system evaluation.',
    `tolerance` DECIMAL(18,2) COMMENT 'Engineering tolerance (upper spec limit minus lower spec limit) of the measured characteristic, used as the denominator when calculating %GRR to tolerance.',
    `total_observations` STRING COMMENT 'Total number of measurement observations collected in the study, calculated as appraisers × parts × replicates. Used to validate study completeness.. Valid values are `^[1-9][0-9]*$`',
    `unit_of_measure` STRING COMMENT 'Engineering unit of measurement for the characteristic values recorded in the MSA study (e.g., mm, µm, N, kPa, °C).',
    CONSTRAINT pk_msa_study PRIMARY KEY(`msa_study_id`)
) COMMENT 'Measurement System Analysis (MSA) study record evaluating the adequacy of a measurement system for a given gauge and characteristic. Captures study type (Gauge R&R, linearity, bias, stability), number of appraisers, parts, and replicates, %GRR result, number of distinct categories (ndc), and acceptability decision. Required for PPAP and control plan validation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` (
    `scrap_rework_transaction_id` BIGINT COMMENT 'Unique system-generated identifier for each scrap or rework transaction event recorded during production. Serves as the primary key for this entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Scrap and rework costs must be allocated to responsible cost centers for variance analysis and financial reporting in manufacturing accounting.',
    `credit_note_id` BIGINT COMMENT 'Foreign key linking to billing.credit_note. Business justification: When scrap or rework occurs due to customer-supplied materials or customer-caused issues, manufacturers issue credit notes. Quality teams track which scrap transactions resulted in financial credits t',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Each scrap/rework transaction is classified by a standardized defect code. The defect_code and defect_description string fields are redundant once the FK to the defect_code master is established.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the machine operator or production worker who performed the operation that resulted in the scrap or rework. Used for operator-level quality performance tracking.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Scrap transactions record which equipment produced rejected material. Operations and quality teams analyze scrap by equipment to identify problematic machines requiring maintenance or adjustment.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Scrap and rework transactions post to specific GL accounts (scrap expense, rework labor) for financial statement reporting and cost of quality tracking.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Scrap and rework transactions often originate from inspection lot results. The inspection_lot_number string field is redundant once the FK to inspection_lot is established.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: A scrap or rework transaction is typically linked to an NCR that documents the nonconformance. The ncr_number string field is redundant once the FK to ncr is established.',
    `quality_capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: Recurring scrap/rework patterns may trigger a CAPA. The capa_reference_number string field is redundant once the FK to capa is established.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Scrap and rework transactions are tracked against sales orders to calculate true cost of quality, adjust delivery schedules, and determine order profitability impact.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Scrap/rework transaction may reference asset work order - normalize by replacing work_order_number text with FK to asset.work_order',
    `batch_number` STRING COMMENT 'Production batch or lot number of the affected material, enabling batch-level traceability and recall management for nonconforming product.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the manufacturing plant where the scrap or rework event occurred. Supports multi-country regulatory compliance reporting and global quality benchmarking.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the cost values recorded in this transaction (e.g., USD, EUR, CNY). Supports multi-currency financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `defect_location` STRING COMMENT 'Physical location or zone on the part or assembly where the defect was identified (e.g., Top Surface, Weld Joint A, Bore Diameter), supporting targeted process improvement.',
    `detection_stage` STRING COMMENT 'Stage in the production or delivery process at which the defect was detected (e.g., in-process, final inspection, customer return). Indicates the effectiveness of quality controls and escape point analysis.. Valid values are `incoming_inspection|in_process|final_inspection|customer_return|field|audit`',
    `disposition` STRING COMMENT 'Final disposition decision for the nonconforming material, indicating how the affected parts are to be handled (e.g., scrap, rework, use-as-is with deviation, return to supplier).. Valid values are `scrap|rework|repair|use_as_is|return_to_supplier|downgrade|pending`',
    `disposition_justification` STRING COMMENT 'Free-text explanation supporting the disposition decision, particularly required for use-as-is or conditional release dispositions to document engineering or quality authority approval rationale.',
    `operation_description` STRING COMMENT 'Descriptive name of the manufacturing operation (e.g., CNC Milling, Welding, Assembly) at which the defect was detected, providing human-readable context for reporting.',
    `operation_number` STRING COMMENT 'Routing operation number within the work order at which the scrap or rework was identified, enabling pinpointing of the specific process step responsible for the defect.',
    `part_description` STRING COMMENT 'Short description of the affected part or material, providing human-readable identification for quality reports and cost analysis without requiring a material master lookup.',
    `part_number` STRING COMMENT 'Material or part number of the component or finished good affected by the scrap or rework event, as defined in the SAP material master.',
    `part_revision` STRING COMMENT 'Engineering revision level of the part at the time of the scrap or rework event, ensuring traceability to the correct drawing and specification version.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where the scrap or rework event occurred. Supports multi-plant quality performance benchmarking.',
    `quantity_affected` DECIMAL(18,2) COMMENT 'Total quantity of parts or units involved in the scrap or rework event, expressed in the base unit of measure. Used as the numerator in scrap rate and yield calculations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `quantity_reworked` DECIMAL(18,2) COMMENT 'Portion of the affected quantity sent for rework or repair operations to bring the parts back into conformance with specifications. Feeds rework rate and yield calculations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `quantity_scrapped` DECIMAL(18,2) COMMENT 'Portion of the affected quantity that was permanently disposed of as scrap and written off from inventory. Feeds scrap rate KPI calculations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `reported_by` STRING COMMENT 'Employee ID or name of the person who identified and recorded the scrap or rework event in the system (may differ from the operator who caused the defect).',
    `rework_completed_date` DATE COMMENT 'Date on which the rework operation was completed and the parts were re-inspected and accepted. Used to calculate rework cycle time and track open rework items.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rework_cost` DECIMAL(18,2) COMMENT 'Total monetary cost incurred to rework the nonconforming parts, including labor, machine time, and material costs. Contributes to cost-of-poor-quality (COPQ) reporting.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `rework_labor_hours` DECIMAL(18,2) COMMENT 'Total direct labor hours expended to rework the nonconforming parts back to specification. Used for labor efficiency analysis and rework cost calculation.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `rework_passed_inspection` BOOLEAN COMMENT 'Indicates whether the reworked parts successfully passed re-inspection and were accepted into conforming stock. False indicates the parts required further rework or were ultimately scrapped.. Valid values are `true|false`',
    `root_cause_category` STRING COMMENT 'High-level Ishikawa (fishbone) category classifying the root cause of the defect (6M framework: Machine, Method, Material, Man, Measurement, Environment). Supports systemic quality improvement analysis.. Valid values are `machine|method|material|man|measurement|environment|design|supplier|unknown`',
    `scrap_cost` DECIMAL(18,2) COMMENT 'Total monetary cost of the scrapped material, calculated as the standard or actual cost of the scrapped quantity. Used for cost-of-poor-quality (COPQ) reporting and financial impact analysis.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `serial_number` STRING COMMENT 'Unique serial number of the individual unit affected, applicable for serialized parts. Enables unit-level traceability for high-value or safety-critical components.',
    `shift_code` STRING COMMENT 'Production shift identifier during which the scrap or rework event occurred (e.g., Day, Afternoon, Night). Enables shift-level quality performance analysis and operator accountability.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this scrap or rework transaction was originated or extracted (e.g., SAP QM, Siemens Opcenter MES). Supports data lineage and audit traceability.. Valid values are `SAP_QM|OPCENTER_MES|MANUAL|MAXIMO|OTHER`',
    `status` STRING COMMENT 'Current processing status of the scrap or rework transaction, tracking its lifecycle from initial recording through completion or cancellation.. Valid values are `open|in_progress|completed|cancelled|pending_approval`',
    `transaction_date` DATE COMMENT 'Calendar date on which the scrap or rework event was identified and recorded on the shop floor. Used for daily production quality reporting and trend analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `transaction_number` STRING COMMENT 'Human-readable business reference number assigned to the scrap or rework transaction, used for cross-referencing in shop floor documents, NCRs, and cost reports.. Valid values are `^SR-[0-9]{4}-[0-9]{6}$`',
    `transaction_timestamp` TIMESTAMP COMMENT 'Precise date and time when the scrap or rework event was recorded in the manufacturing execution system, enabling shift-level and time-of-day analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `transaction_type` STRING COMMENT 'Classifies the disposition event as scrap (material written off), rework (reprocessed to meet specification), repair (restored to acceptable condition), downgrade (reclassified to lower grade), or return to supplier.. Valid values are `scrap|rework|repair|downgrade|return_to_supplier`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the quantity fields (e.g., EA for each, KG for kilogram, M for meter). Aligns with the SAP material master unit of measure.. Valid values are `EA|KG|M|M2|M3|L|PC|SET|BOX|FT|LB`',
    `work_center_code` STRING COMMENT 'Code identifying the specific work center or production cell responsible for the operation where the scrap or rework was generated. Used for work-center-level quality performance analysis.',
    CONSTRAINT pk_scrap_rework_transaction PRIMARY KEY(`scrap_rework_transaction_id`)
) COMMENT 'Transactional record of each scrap or rework event occurring during production, capturing affected work order, operation, part number, quantity scrapped or reworked, defect code, scrap cost, rework labor hours, responsible work center, and disposition. Feeds scrap rate and yield calculations across production stages.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` (
    `supplier_quality_event_id` BIGINT COMMENT 'Unique system-generated identifier for the supplier quality event record in the lakehouse silver layer.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Supplier quality events track incoming component defects. Quality engineers reference component specifications to determine if supplier parts meet engineering requirements and approve dispositions.',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Supplier quality events are classified by standardized defect codes. The defect_code and defect_description string fields are redundant once the FK to the defect_code master is established.',
    `logistics_inbound_delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.inbound_delivery. Business justification: Supplier quality events (rejections, containment) are triggered by specific inbound deliveries. Receiving inspection teams document quality issues against the exact delivery that arrived with defects.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: A supplier quality event (incoming quality failure, supplier NCR) is linked to an internal NCR for formal nonconformance processing. The ncr_number string field is redundant once the FK to ncr is esta',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Supplier quality event references purchase order - normalize by replacing purchase_order_number text with FK',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Supplier quality event references supplier - normalize by replacing supplier_code and supplier_name with FK',
    `quality_capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: Supplier quality events requiring corrective action reference a CAPA record. The capa_reference_number string field is redundant once the FK to capa is established.',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to service.spare_parts_catalog. Business justification: Supplier quality events (defective parts) directly impact spare parts catalog. Quality teams flag defective spare parts to prevent field service from using non-conforming inventory.',
    `third_party_risk_id` BIGINT COMMENT 'Foreign key linking to compliance.third_party_risk. Business justification: Supplier quality issues (defects, non-conformances) feed into third-party risk assessments. Procurement and quality teams track which supplier incidents contribute to compliance risk profiles for vend',
    `batch_number` STRING COMMENT 'Supplier batch or lot number of the nonconforming material, enabling traceability back to the suppliers production run for containment and recall activities.',
    `chargeback_flag` BOOLEAN COMMENT 'Indicates whether a financial chargeback has been or will be issued to the supplier for the costs incurred due to the nonconformance, triggering the SAP FI/CO chargeback process.. Valid values are `true|false`',
    `closure_date` DATE COMMENT 'Date on which the supplier quality event was formally closed following verification of corrective action effectiveness, used for cycle time analysis and supplier responsiveness KPIs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `containment_action` STRING COMMENT 'Description of the immediate containment action taken to prevent nonconforming material from reaching production or customers, corresponding to Step D3 of the 8D problem-solving methodology.',
    `containment_status` STRING COMMENT 'Current status of the immediate containment action, tracking whether containment has been initiated, is in progress, completed, or independently verified.. Valid values are `not_started|in_progress|completed|verified`',
    `corrective_action_description` STRING COMMENT 'Description of the permanent corrective action implemented by the supplier (8D Step D5/D6) to eliminate the root cause and prevent recurrence of the nonconformance.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which the supplier must complete and demonstrate implementation of the permanent corrective action, used for CAPA closure tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supplier quality event record was first created in the source system (SAP QM), used for audit trail, data lineage, and event aging calculations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the nonconformance cost amount, supporting multi-currency reporting in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `defect_category` STRING COMMENT 'High-level category of the defect type, enabling cross-supplier and cross-commodity defect trend analysis for quality improvement programs.. Valid values are `dimensional|material|functional|cosmetic|labeling|packaging|documentation|contamination|mixed_parts|wrong_part`',
    `detection_date` DATE COMMENT 'Calendar date on which the supplier quality nonconformance was first detected, used for aging analysis, response time tracking, and supplier SLA compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `detection_stage` STRING COMMENT 'Stage in the manufacturing or supply chain process at which the supplier nonconformance was detected, used to assess the effectiveness of incoming quality controls and escape point analysis.. Valid values are `incoming_inspection|dock_audit|production_line|assembly|final_inspection|field_return|customer_complaint`',
    `disposition` STRING COMMENT 'Disposition decision for the nonconforming material, determining whether it will be returned to the supplier, scrapped, reworked, used as-is under deviation, or sorted. Drives SAP S/4HANA stock posting actions.. Valid values are `return_to_supplier|scrap|rework|use_as_is|sort_and_use|conditional_release|pending`',
    `eight_d_submission_date` DATE COMMENT 'Date on which the supplier submitted their 8D problem-solving report in response to the SCAR, used for response time SLA measurement and supplier performance scoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `eight_d_submission_status` STRING COMMENT 'Status of the suppliers 8D (Eight Disciplines) problem-solving report submission, tracking whether the 8D has been requested, submitted by the supplier, accepted, or rejected by the quality team.. Valid values are `not_required|pending|submitted|accepted|rejected|overdue`',
    `event_number` STRING COMMENT 'Human-readable business reference number for the supplier quality event, used for cross-system tracking and communication with suppliers.. Valid values are `^SQE-[0-9]{4}-[0-9]{6}$`',
    `event_type` STRING COMMENT 'Classification of the supplier quality event type, distinguishing between incoming inspection failures, supplier Non-Conformance Reports (NCRs), Supplier Corrective Action Requests (SCARs), 8D responses, field returns, audit findings, dock rejections, and concession requests.. Valid values are `incoming_inspection_failure|supplier_ncr|scar|8d_response|field_return|audit_finding|dock_rejection|concession_request`',
    `grn_number` STRING COMMENT 'Goods Receipt Note (GRN) reference number from SAP S/4HANA MM identifying the specific delivery batch in which the nonconformance was detected during incoming inspection.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supplier quality event record, supporting change tracking, audit compliance, and incremental data loading in the Databricks lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `nonconformance_cost` DECIMAL(18,2) COMMENT 'Total cost of nonconformance (CONC) associated with this supplier quality event, including inspection, sorting, rework, scrap, and production disruption costs. Used for supplier chargeback and quality cost reporting.',
    `nonconforming_quantity` DECIMAL(18,2) COMMENT 'Total quantity of nonconforming units identified in the supplier quality event, used for PPM calculation, disposition planning, and supplier rating impact assessment.',
    `part_revision_level` STRING COMMENT 'Engineering revision level of the part at the time of the quality event, critical for determining whether the nonconformance relates to an obsolete or current design specification.',
    `plant_code` STRING COMMENT 'SAP S/4HANA plant code identifying the receiving manufacturing facility where the nonconforming material was delivered and the quality event was raised.',
    `ppm_impact` DECIMAL(18,2) COMMENT 'Calculated Parts Per Million (PPM) defect rate for this quality event, representing the number of defective parts per million parts received. Used directly in SAP QM vendor evaluation scoring and supplier quality KPI dashboards.',
    `quantity_unit_of_measure` STRING COMMENT 'Unit of measure for the nonconforming quantity, aligned with SAP S/4HANA base unit of measure for the material.. Valid values are `EA|KG|M|M2|M3|L|PC|SET|BOX|ROLL`',
    `regulatory_reportable_flag` BOOLEAN COMMENT 'Indicates whether the supplier quality event involves a regulatory reportable nonconformance, such as a REACH/RoHS violation, CE marking non-compliance, or safety-critical defect requiring notification to regulatory authorities.. Valid values are `true|false`',
    `responsible_sqe` STRING COMMENT 'Name or employee ID of the Supplier Quality Engineer (SQE) responsible for managing this quality event, coordinating with the supplier, and driving closure of the SCAR and 8D.',
    `root_cause_description` STRING COMMENT 'Supplier-provided root cause description from the 8D report (Step D4), documenting the verified root cause of the nonconformance for corrective action planning and recurrence prevention.',
    `scar_issued_date` DATE COMMENT 'Date on which the Supplier Corrective Action Request (SCAR) was formally issued to the supplier, initiating the response timeline and SLA clock.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scar_number` STRING COMMENT 'Reference number for the formal Supplier Corrective Action Request (SCAR) issued to the supplier, requiring documented root cause analysis and corrective action plan submission.. Valid values are `^SCAR-[0-9]{4}-[0-9]{6}$`',
    `scar_response_due_date` DATE COMMENT 'Contractual or agreed deadline by which the supplier must submit their corrective action response to the SCAR, used for SLA compliance monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `severity` STRING COMMENT 'Severity classification of the supplier quality event indicating the impact on product safety, regulatory compliance, production continuity, or customer satisfaction. Critical events may trigger immediate supplier suspension.. Valid values are `critical|major|minor|observation`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this supplier quality event originated, supporting data lineage and multi-system reconciliation in the Databricks silver layer.. Valid values are `SAP_QM|SAP_MM|ARIBA|TEAMCENTER|MANUAL`',
    `status` STRING COMMENT 'Current workflow status of the supplier quality event, tracking progression from initial detection through containment, 8D submission, corrective action, and closure.. Valid values are `open|under_review|containment_active|8d_submitted|8d_accepted|8d_rejected|capa_in_progress|closed|cancelled|on_hold`',
    `supplier_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the supplier manufacturing site, used for regional quality performance analysis and regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `supplier_manufacturing_site` STRING COMMENT 'Specific manufacturing plant or facility of the supplier where the nonconforming product was produced, relevant for multi-site suppliers.',
    `supplier_rating_impact` STRING COMMENT 'Assessment of the impact this quality event has on the suppliers overall quality rating in the SAP QM vendor evaluation system, ranging from no impact to triggering supplier probation or suspension.. Valid values are `no_impact|minor_deduction|major_deduction|probation_triggered|suspension_triggered`',
    `total_received_quantity` DECIMAL(18,2) COMMENT 'Total quantity received in the associated delivery or GRN, used as the denominator for PPM (Parts Per Million) defect rate calculation for supplier performance reporting.',
    CONSTRAINT pk_supplier_quality_event PRIMARY KEY(`supplier_quality_event_id`)
) COMMENT 'Supplier quality event record capturing incoming quality failures, supplier NCRs, 8D responses, and supplier corrective action requests (SCAR). Tracks supplier ID, affected PO/GRN, defect description, PPM impact, 8D submission status, containment actions, and supplier rating impact. Supports supplier quality management and SAP QM vendor evaluation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`customer_complaint` (
    `customer_complaint_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each customer complaint record in the Quality Management System.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Customer complaints assign an employee to investigate, respond, and implement corrective actions. Critical for customer satisfaction and warranty management.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Customer complaints identify specific components with field failures. Quality teams reference component engineering data to investigate root cause and determine if design changes are needed.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Customer complaint from customer account - normalize by replacing customer_name text with FK',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Customer complaints are classified by standardized defect codes for consistent reporting and trend analysis. The defect_code string field is redundant once the FK to the defect_code master is establis',
    `incident_id` BIGINT COMMENT 'Foreign key linking to hse.incident. Business justification: Customer complaints about product safety issues often trace back to manufacturing incidents (contamination, improper handling). Quality teams link complaints to originating safety events for investiga',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: Customer complaints may reference an internal NCR created to process the field quality issue. The ncr_number string field is redundant once the FK to ncr is established.',
    `quality_capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: Customer complaints requiring corrective action reference a CAPA record. The capa_number string field is redundant once the FK to capa is established.',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Customer complaints during pre-sales or warranty periods often link to sales opportunities for replacement systems, upgrades, or corrective solutions. Sales teams track quality issues that generate ne',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Customer complaints reference the specific shipment that delivered defective products. Quality teams trace complaints back to shipments for root cause analysis and batch identification.',
    `actual_closure_date` DATE COMMENT 'Date on which the complaint was formally closed after customer acceptance of the resolution, used for SLA compliance measurement and cycle time analysis.',
    `batch_number` STRING COMMENT 'Production batch or lot number of the affected product, used to assess the scope of the quality issue and determine whether a batch recall or containment is required.',
    `complaint_number` STRING COMMENT 'Human-readable business reference number assigned to the complaint, used for cross-system tracking and customer communication (e.g., CC-2024-000123).. Valid values are `^CC-[0-9]{4}-[0-9]{6}$`',
    `complaint_type` STRING COMMENT 'Classification of the complaint by its nature and origin, distinguishing field failures, warranty claims, OEM partner complaints, safety concerns, and regulatory issues.. Valid values are `field_failure|warranty_claim|oem_partner_complaint|safety_concern|regulatory_complaint|delivery_quality|cosmetic_defect|functional_defect|documentation_error|labeling_error`',
    `containment_action` STRING COMMENT 'Description of the immediate containment action taken to protect the customer from further exposure to the defect, corresponding to 8D Discipline 3 (D3).',
    `containment_completion_date` DATE COMMENT 'Date on which the containment action was fully implemented and verified, used to measure response speed and SLA compliance for immediate customer protection.',
    `corrective_action_description` STRING COMMENT 'Description of the permanent corrective action implemented to eliminate the root cause and prevent recurrence, corresponding to 8D D5/D6.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers location where the failure was reported, used for regional quality trend analysis and regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the financial impact amount (e.g., USD, EUR, GBP), supporting multi-currency financial reporting.. Valid values are `^[A-Z]{3}$`',
    `customer_approved_closure` BOOLEAN COMMENT 'Indicates whether the customer has formally accepted and approved the complaint resolution before the record is closed, ensuring customer sign-off is captured.. Valid values are `true|false`',
    `customer_reference_number` STRING COMMENT 'The complaint or claim reference number assigned by the customer or OEM partner in their own system, used for cross-referencing during resolution communications.',
    `customer_satisfaction_rating` STRING COMMENT 'Customers satisfaction rating provided at complaint closure, measuring the effectiveness of the resolution process and informing Net Promoter Score (NPS) and customer retention analytics.. Valid values are `very_satisfied|satisfied|neutral|dissatisfied|very_dissatisfied|not_rated`',
    `defect_category` STRING COMMENT 'High-level category of the defect type, used for trend analysis, FMEA alignment, and quality reporting across product lines.. Valid values are `functional|dimensional|cosmetic|material|electrical|software|documentation|packaging|labeling|safety`',
    `eight_d_status` STRING COMMENT 'Current step in the 8 Disciplines (8D) structured problem-solving process, tracking progression from team formation through root cause analysis to preventive action and closure.. Valid values are `not_started|D1_team_formed|D2_problem_described|D3_containment_active|D4_root_cause_identified|D5_corrective_actions_defined|D6_corrective_actions_implemented|D7_preventive_actions_defined|D8_closed`',
    `failure_date` DATE COMMENT 'Date on which the product failure or quality issue was first observed or experienced by the customer, used for warranty age calculation and field reliability analysis.',
    `failure_description` STRING COMMENT 'Detailed narrative description of the failure or quality issue as reported by the customer, including observed symptoms, conditions of failure, and customer impact.',
    `financial_impact_amount` DECIMAL(18,2) COMMENT 'Estimated or actual financial cost associated with the complaint, including warranty claims, field returns, rework, scrap, and customer penalties. Used for Cost of Poor Quality (COPQ) reporting.',
    `part_revision` STRING COMMENT 'Engineering revision level of the affected part at the time of the complaint, critical for determining whether the issue is design-related and for ECN/ECO traceability.',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or facility where the affected product was produced, used for plant-level quality performance analysis.',
    `priority` STRING COMMENT 'Business priority level assigned to the complaint based on safety impact, customer significance, regulatory exposure, and production disruption risk.. Valid values are `critical|high|medium|low`',
    `quantity_complained` DECIMAL(18,2) COMMENT 'Number of units reported as defective or non-conforming in the customer complaint, used for PPM calculation and scope assessment.',
    `quantity_unit_of_measure` STRING COMMENT 'Unit of measure for the complained quantity (e.g., EA for each, PC for pieces, KG for kilograms), aligned with SAP UoM configuration.. Valid values are `EA|PC|KG|M|M2|M3|L|SET|LOT`',
    `received_date` DATE COMMENT 'Date on which the complaint was formally received and registered in the Quality Management System, used for SLA tracking and response time measurement.',
    `regulatory_reportable` BOOLEAN COMMENT 'Indicates whether the complaint involves a safety or regulatory issue that must be reported to a governing body (e.g., OSHA, EPA, CE/RoHS authority), triggering mandatory notification workflows.. Valid values are `true|false`',
    `responsible_engineer` STRING COMMENT 'Name or employee ID of the quality engineer assigned as the primary owner of the complaint investigation and resolution process.',
    `root_cause_category` STRING COMMENT 'Standardized classification of the root cause type, enabling trend analysis across complaints to identify systemic quality issues by category.. Valid values are `design|process|material|supplier|human_error|tooling|measurement|environment|software|unknown`',
    `root_cause_description` STRING COMMENT 'Detailed description of the verified root cause of the failure, as determined through structured root cause analysis (e.g., 5-Why, Ishikawa), corresponding to 8D D4.',
    `safety_related` BOOLEAN COMMENT 'Indicates whether the complaint involves a potential safety hazard to end users or operators, triggering escalated priority handling and mandatory safety review.. Valid values are `true|false`',
    `serial_number` STRING COMMENT 'Serial number of the specific unit reported in the complaint, enabling traceability to the production batch, manufacturing date, and shop floor records.',
    `source_channel` STRING COMMENT 'Channel through which the complaint was received, enabling analysis of complaint intake patterns and customer engagement touchpoints.. Valid values are `customer_portal|email|phone|field_service|sales_rep|oem_partner|regulatory_body|social_media|warranty_system`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which the complaint record originated (e.g., SAP QM, Salesforce CRM), supporting data lineage and integration traceability.. Valid values are `SAP_QM|Salesforce_CRM|MindSphere|Manual|Opcenter_MES|Customer_Portal`',
    `status` STRING COMMENT 'Current lifecycle status of the customer complaint, tracking progression from initial receipt through 8D problem-solving workflow to closure.. Valid values are `open|in_progress|containment_active|root_cause_analysis|corrective_action|pending_customer_approval|closed|cancelled`',
    `target_closure_date` DATE COMMENT 'Committed date by which the complaint must be fully resolved and closed, as agreed with the customer or defined by internal SLA policy.',
    `title` STRING COMMENT 'Short descriptive title summarizing the nature of the customer complaint, used for quick identification in lists and dashboards.',
    `warranty_status` STRING COMMENT 'Indicates whether the complained product is within the warranty period, out of warranty, or subject to a goodwill claim, driving financial liability and resolution approach.. Valid values are `in_warranty|out_of_warranty|warranty_disputed|goodwill|not_applicable`',
    CONSTRAINT pk_customer_complaint PRIMARY KEY(`customer_complaint_id`)
) COMMENT 'Customer quality complaint record capturing field quality issues reported by customers or OEM partners. Stores complaint reference, customer ID, affected product/serial number, failure description, warranty status, 8D problem-solving workflow status, containment actions, root cause, corrective action, and customer satisfaction closure. Links to CAPA and NCR.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`quality_notification` (
    `quality_notification_id` BIGINT COMMENT 'Unique surrogate identifier for the quality notification record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Quality notification from customer - normalize by replacing customer_number and customer_name with FK',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Quality notifications are classified by standardized defect codes. The defect_code and defect_description string fields are redundant once the FK to the defect_code master is established.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Quality notifications reference the inspection lot that triggered the quality problem. The inspection_lot_number string field is redundant once the FK to inspection_lot is established.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: A SAP QM quality notification references an NCR for formal nonconformance documentation. The ncr_reference_number string field is redundant once the FK to ncr is established.',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Quality notification for production order - normalize by replacing production_order_number text with FK',
    `quality_capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: Quality notifications requiring corrective action reference a CAPA record. The capa_reference_number string field is redundant once the FK to capa is established.',
    `service_ticket_id` BIGINT COMMENT 'Foreign key linking to technology.service_ticket. Business justification: Quality notifications about system issues (QMS downtime, gauge software errors) generate IT service tickets. Quality teams track these tickets to monitor resolution of technology issues impacting qual',
    `actual_closure_date` DATE COMMENT 'Date on which the quality notification was formally closed in SAP QM after all tasks, corrective actions, and verifications were completed. Used for cycle time and SLA compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `batch_number` STRING COMMENT 'Production or supplier batch number of the affected material, enabling batch-level traceability and targeted containment actions for nonconforming product.',
    `capa_required` BOOLEAN COMMENT 'Indicates whether a formal CAPA (Corrective and Preventive Action) must be initiated as a result of this quality notification. Drives CAPA workflow creation in the QMS.. Valid values are `true|false`',
    `containment_action` STRING COMMENT 'Description of the immediate containment action taken to prevent further nonconforming product from reaching the customer or next process step (e.g., quarantine, 100% inspection, production hold).',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or site where the quality notification originated. Supports multi-country regulatory compliance and geographic quality performance analysis.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the quality notification was first created in SAP QM. Marks the start of the notification lifecycle and is used for SLA (Service Level Agreement) response time measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `defect_category` STRING COMMENT 'Classification of the defect or quality problem into a standard category (e.g., Dimensional, Surface, Functional, Labeling, Documentation, Process, Material). Used for Pareto analysis and trend reporting.',
    `description` STRING COMMENT 'Detailed narrative description of the quality issue, defect, complaint, or improvement opportunity. Captures the full problem statement as entered by the originator.',
    `detection_stage` STRING COMMENT 'Stage in the production or supply chain process at which the quality defect or nonconformance was detected. Supports escape analysis and process improvement initiatives.. Valid values are `Incoming Inspection|In-Process|Final Inspection|Customer|Field|Audit|Supplier`',
    `material_description` STRING COMMENT 'Descriptive name of the affected material or component as maintained in the SAP material master, providing human-readable context for the notification.',
    `material_number` STRING COMMENT 'SAP material master number identifying the product, component, or raw material affected by the quality notification. Central reference for traceability across production, procurement, and quality.',
    `nonconforming_quantity` DECIMAL(18,2) COMMENT 'Quantity of units, parts, or material identified as nonconforming in the quality notification. Used for scrap rate calculation, PPM (Parts Per Million) reporting, and cost of poor quality analysis.',
    `number` STRING COMMENT 'SAP QM-assigned alphanumeric notification number that uniquely identifies the quality notification in the source system. Used for cross-system referencing and communication with stakeholders.. Valid values are `^[0-9]{10,12}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site where the quality issue originated or was detected. Supports plant-level quality performance reporting.',
    `priority` STRING COMMENT 'Priority level assigned to the notification indicating urgency of resolution. 1 = Very High (Safety/Regulatory), 2 = High (Production Impact), 3 = Medium (Quality Risk), 4 = Low (Improvement). Drives escalation and response time targets.. Valid values are `1|2|3|4`',
    `priority_description` STRING COMMENT 'Human-readable label for the priority level (e.g., Very High, High, Medium, Low) to support reporting and user communication.. Valid values are `Very High|High|Medium|Low`',
    `purchase_order_number` STRING COMMENT 'SAP purchase order number associated with the incoming goods or supplier delivery linked to the quality notification, enabling procurement-quality traceability.',
    `quantity_unit_of_measure` STRING COMMENT 'Unit of measure for the nonconforming quantity (e.g., EA for each, KG for kilogram, M for meter, L for liter). Aligns with SAP base unit of measure for the material.',
    `regulatory_reportable` BOOLEAN COMMENT 'Indicates whether the quality issue documented in this notification must be reported to a regulatory authority (e.g., OSHA, EPA, CE Marking authority, UL). Triggers compliance reporting workflows.. Valid values are `true|false`',
    `reported_by` STRING COMMENT 'SAP user ID or employee identifier of the person who created and submitted the quality notification. Supports accountability tracking and notification originator analysis.',
    `reported_by_department` STRING COMMENT 'Organizational department of the person who reported the quality notification (e.g., Quality Assurance, Production, Procurement, Customer Service). Enables departmental quality reporting.',
    `required_end_date` DATE COMMENT 'Target date by which the quality notification must be fully resolved and closed, as defined by SLA (Service Level Agreement) and priority rules. Drives escalation workflows.. Valid values are `^d{4}-d{2}-d{2}$`',
    `required_start_date` DATE COMMENT 'Date by which processing of the quality notification must begin, as defined by the notification priority and SLA (Service Level Agreement) rules. Used for scheduling and escalation management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `responsible_department` STRING COMMENT 'Organizational department responsible for investigating and resolving the quality notification (e.g., Quality Engineering, Manufacturing, Supplier Quality, R&D).',
    `responsible_person` STRING COMMENT 'SAP user ID or employee identifier of the quality engineer or coordinator assigned as the primary owner responsible for processing and closing the notification.',
    `serial_number` STRING COMMENT 'Unique serial number of the specific unit or assembly affected by the quality notification, enabling unit-level traceability for serialized products.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which the quality notification originated (e.g., SAP_QM, SALESFORCE_CRM for customer complaints, OPCENTER_MES for shop floor defects, MANUAL for paper-based entries). Supports data lineage.. Valid values are `SAP_QM|SALESFORCE_CRM|OPCENTER_MES|MANUAL`',
    `status` STRING COMMENT 'Current processing status of the quality notification using SAP system status codes. OSNO = Outstanding (Not Started), NOPR = In Process, NOCO = Completed, NOPT = Partially Completed, CLSD = Closed, DLFL = Deletion Flag. Drives workflow routing and SLA tracking.. Valid values are `OSNO|NOPR|NOCO|NOPT|CLSD|DLFL`',
    `title` STRING COMMENT 'Short descriptive title summarizing the quality problem, complaint, or improvement request captured in the notification. Used as the primary display label in dashboards and reports.',
    `type` STRING COMMENT 'SAP QM notification type code classifying the nature of the quality event. Q1 = Internal Problem Notification, Q2 = Customer Complaint, Q3 = Supplier Defect Notification, F1 = Maintenance Request, F2 = Activity Report, S1 = Service Notification, S2 = Customer Inquiry.. Valid values are `Q1|Q2|Q3|F1|F2|S1|S2`',
    `type_description` STRING COMMENT 'Human-readable description of the notification type (e.g., Internal Defect, Customer Complaint, Supplier Defect Notification) to support reporting and user interfaces.',
    `vendor_name` STRING COMMENT 'Name of the supplier or vendor associated with the quality notification, providing human-readable context for supplier defect notifications and procurement quality reporting.',
    `vendor_number` STRING COMMENT 'SAP vendor master number identifying the supplier responsible for the defective material or component, applicable for supplier defect notifications (Q3 type). Used for supplier quality performance tracking.',
    `work_center_code` STRING COMMENT 'SAP work center code identifying the specific production cell, line, or machine where the quality issue was detected or originated. Enables work-center-level defect analysis.',
    CONSTRAINT pk_quality_notification PRIMARY KEY(`quality_notification_id`)
) COMMENT 'SAP QM Quality Notification record used to formally document and manage quality problems, complaints, and improvement requests within the enterprise. Captures notification type (internal defect, customer complaint, supplier defect), priority, affected object (material, equipment, order), task list, and processing status. Central workflow trigger in SAP QM.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`certificate` (
    `certificate_id` BIGINT COMMENT 'Unique surrogate identifier for the quality certificate record in the lakehouse silver layer.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Quality certificates (CoC, CoA) require authorized employee signature for legal validity and customer acceptance. Standard requirement for material certifications.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Quality certificates document conformance of specific components to specifications. Certificates reference component engineering data including material specs, dimensions, and test requirements.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Quality certificate for customer - normalize by replacing customer_code and customer_name with FK',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Quality certificate for delivery - normalize by replacing delivery_number text with FK',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: Quality certificates (CoC, material certs) are issued under specific product certifications (ISO, UL, CE). Manufacturing must link quality documentation to the governing certification for customer del',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Quality certificates (ISO, material certs, compliance docs) are often required during sales cycles to win contracts. Sales teams request certificates to close deals, especially in regulated industries',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Quality certificates (CoC, material certs) must accompany shipments for customer delivery. Quality teams issue certificates tied to specific shipments daily for compliance and customer requirements.',
    `applicable_standards` STRING COMMENT 'Comma-separated list of quality, safety, or regulatory standards met by the certified product (e.g., ISO 9001:2015, IEC 61131, RoHS, REACH, CE, UL, ANSI). Stored as a delimited string for reporting.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the certificate was formally approved by the authorized signatory, marking the transition from draft to approved status.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `authorized_signatory_name` STRING COMMENT 'Full name of the quality authority (e.g., Quality Manager, Quality Engineer) who authorized and signed the certificate, as required for legal and regulatory validity.',
    `authorized_signatory_title` STRING COMMENT 'Job title or role of the authorized signatory (e.g., Quality Manager, Director of Quality Assurance), providing context for the authority level of the certification.',
    `batch_number` STRING COMMENT 'Manufacturing batch or lot number for which the certificate is issued, enabling full traceability from raw material through finished goods.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `ce_marking_applicable` BOOLEAN COMMENT 'Indicates whether the product requires CE marking under applicable EU directives, confirming conformity with European health, safety, and environmental protection standards.. Valid values are `true|false`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the issuing plants location, used for regulatory compliance, CE marking, and export documentation.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the quality certificate record was first created in the system, used for audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_part_number` STRING COMMENT 'Customers own part number or drawing number for the certified product, required for customer-specific certificate formats and cross-reference.',
    `customer_specific_requirements` STRING COMMENT 'Description of any customer-specific quality certificate requirements (e.g., AIAG, IATF 16949 customer specifics, additional test data, format mandates) that must be met for this certificate.',
    `deviation_number` STRING COMMENT 'Reference number of any approved deviation or waiver under which the product was released, indicating conditional conformance and linking to the formal deviation approval record.',
    `document_storage_reference` STRING COMMENT 'Reference path or identifier to the signed certificate document stored in the document management system (e.g., Siemens Teamcenter DMS or SAP DMS), enabling retrieval of the original signed PDF.',
    `expiry_date` DATE COMMENT 'Date after which the certificate is no longer considered valid, applicable for time-limited certifications or shelf-life-controlled products.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_lot_number` STRING COMMENT 'SAP QM inspection lot number associated with the quality inspection that underpins this certificate, providing traceability to detailed inspection results.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `issue_date` DATE COMMENT 'Date on which the quality certificate was officially issued and signed, as printed on the certificate document.. Valid values are `^d{4}-d{2}-d{2}$`',
    `issuing_plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility that produced the goods and issued the quality certificate.. Valid values are `^[A-Z0-9]{2,10}$`',
    `issuing_plant_name` STRING COMMENT 'Full descriptive name of the manufacturing plant issuing the certificate, used for display on printed certificates and customer-facing documents.',
    `number` STRING COMMENT 'Business-assigned unique certificate number used for external reference, customer communication, and traceability. Typically generated by SAP QM or the issuing plants QMS.. Valid values are `^[A-Z0-9-]{5,40}$`',
    `overall_conformance_result` STRING COMMENT 'Summary conformance decision for the certified batch or lot: Conforming (all characteristics within specification), Non-Conforming, or Conditionally Conforming (released with deviation).. Valid values are `Conforming|Non_Conforming|Conditionally_Conforming`',
    `part_name` STRING COMMENT 'Descriptive name of the part or material covered by the certificate, as defined in the SAP material master or PLM system.',
    `part_revision` STRING COMMENT 'Engineering revision level of the part at the time the certificate was issued, ensuring traceability to the correct design baseline.. Valid values are `^[A-Z0-9.]{1,10}$`',
    `production_order_number` STRING COMMENT 'SAP production order number under which the certified batch or lot was manufactured, linking the certificate to the manufacturing execution record.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `purchase_order_number` STRING COMMENT 'Customers purchase order number referenced on the certificate, providing contractual linkage between the quality document and the commercial transaction.',
    `quantity_certified` DECIMAL(18,2) COMMENT 'Total quantity of product units or material covered by this certificate.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the certified product complies with the EU REACH Regulation (EC No 1907/2006) regarding chemical substance registration and restriction.. Valid values are `true|false`',
    `revision_number` STRING COMMENT 'Revision or version identifier of the certificate, incremented when a certificate is amended or reissued to reflect updated test results or corrections.. Valid values are `^[A-Z0-9.]{1,10}$`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the certified product complies with the EU RoHS Directive (2011/65/EU) restricting hazardous substances in electrical and electronic equipment.. Valid values are `true|false`',
    `serial_number` STRING COMMENT 'Individual unit serial number when the certificate applies to a serialized product rather than a batch or lot.',
    `source_system` STRING COMMENT 'Operational system of record from which this quality certificate record originated (e.g., SAP QM, Siemens Opcenter MES), supporting data lineage and reconciliation.. Valid values are `SAP_QM|Opcenter_MES|Teamcenter_PLM|Manual|Other`',
    `specification_number` STRING COMMENT 'Engineering specification, drawing, or standard number against which the product was tested and certified.',
    `status` STRING COMMENT 'Current lifecycle status of the quality certificate, from initial draft through issuance, potential supersession, or revocation.. Valid values are `Draft|Pending_Approval|Approved|Issued|Superseded|Revoked|Expired|Cancelled`',
    `superseded_by_certificate_number` STRING COMMENT 'Certificate number of the replacement certificate when this certificate has been superseded, enabling version chain traceability.',
    `test_results_summary` STRING COMMENT 'Narrative or structured summary of key test results included on the certificate, such as dimensional, mechanical, chemical, or functional test outcomes.',
    `type` STRING COMMENT 'Classification of the quality certificate: Certificate of Conformance (CoC), Certificate of Analysis (CoA), Material Test Report (MTR), First Article Inspection (FAI) Certificate, Inspection Certificate, Declaration of Conformity, Test Report, or Other.. Valid values are `CoC|CoA|MTR|FAI_Certificate|Inspection_Certificate|Conformity_Declaration|Test_Report|Other`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the certified quantity (e.g., EA, KG, M, L, PC), aligned with SAP base unit of measure.. Valid values are `^[A-Z]{1,10}$`',
    CONSTRAINT pk_certificate PRIMARY KEY(`certificate_id`)
) COMMENT 'Quality certificate (Certificate of Conformance / Certificate of Analysis) record issued for a manufactured batch, lot, or shipment. Captures certificate type (CoC, CoA, material test report), issuing plant, part number, batch/lot number, test results summary, applicable standards met, authorized signatory, and customer-specific certificate requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`qms_document` (
    `qms_document_id` BIGINT COMMENT 'Unique surrogate identifier for each QMS controlled document record in the Databricks Silver Layer.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: QMS documents are managed in document control applications (MasterControl, TrackWise, etc.). IT maintains these systems, and quality must track which application hosts each controlled document for acc',
    `access_level` STRING COMMENT 'Data classification and access control level for the document, determining which roles and organizational units may view, edit, or distribute the document.. Valid values are `public|internal|confidential|restricted`',
    `approval_status` STRING COMMENT 'Specific approval workflow status indicating whether the document has been formally reviewed and approved by the designated authority, distinct from the overall document lifecycle status.. Valid values are `not_submitted|pending|approved|rejected|conditionally_approved`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the authorized approver who formally approved the current revision of the document for release and use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Exact date and time when the document was formally approved by the authorized approver, providing an auditable electronic signature timestamp for regulatory compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `change_notice_number` STRING COMMENT 'Reference number of the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered the current document revision, linking document changes to the formal change management process.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the site or jurisdiction where this document is applicable, supporting multi-country regulatory compliance management.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the document record was first created in the document management system, establishing the start of the document lifecycle audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `distribution_scope` STRING COMMENT 'Defines the intended audience and distribution boundaries for the document, controlling who receives notifications of new revisions and who must acknowledge receipt.. Valid values are `all_sites|specific_plant|specific_department|supplier|customer|external_regulatory|internal_only`',
    `document_category` STRING COMMENT 'Business domain category grouping the document for navigation, reporting, and access control purposes within the QMS document hierarchy.. Valid values are `quality_management|production|engineering|safety|environmental|regulatory_compliance|supplier_quality|customer_quality|laboratory|maintenance`',
    `document_number` STRING COMMENT 'Unique controlled document number assigned by the document management system, used as the primary business identifier for the document across all systems including SAP QM and Siemens Teamcenter PLM.. Valid values are `^[A-Z]{2,6}-[A-Z]{2,6}-[0-9]{4,8}(-[A-Z0-9]+)?$`',
    `document_owner` STRING COMMENT 'Name or employee identifier of the individual responsible for maintaining the accuracy and currency of the document. The document owner initiates review cycles and change requests.',
    `document_type` STRING COMMENT 'Classification of the QMS document by its functional type, such as Standard Operating Procedure (SOP), work instruction, quality manual, form, or specification. Drives document control workflows and retention rules.. Valid values are `quality_manual|procedure|work_instruction|form|specification|standard|policy|record_template|control_plan|inspection_plan|sop|drawing|test_method|regulatory_submission`',
    `effective_date` DATE COMMENT 'Date on which the current approved revision of the document becomes officially effective and must be used in operations. Prior revisions are superseded on this date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `electronic_signature_required` BOOLEAN COMMENT 'Indicates whether the document requires a compliant electronic signature for approval, applicable to regulated industries and documents subject to 21 CFR Part 11 or equivalent electronic records requirements.. Valid values are `true|false`',
    `expiry_date` DATE COMMENT 'Date on which the document automatically expires if not reviewed and re-approved. Applicable to time-limited documents such as regulatory submissions, temporary deviations, and certifications.. Valid values are `^d{4}-d{2}-d{2}$`',
    `external_origin_flag` BOOLEAN COMMENT 'Indicates whether the document originates from an external source (e.g., customer specification, regulatory standard, supplier document) rather than being internally authored. External documents require different control procedures per ISO 9001.. Valid values are `true|false`',
    `file_format` STRING COMMENT 'File format of the controlled document master file, used for document management system compatibility checks and long-term archival format compliance.. Valid values are `pdf|docx|xlsx|pptx|dwg|dxf|xml|html|txt|other`',
    `iso_clause_reference` STRING COMMENT 'Specific ISO standard clause(s) that this document supports or fulfills, enabling traceability between controlled documents and quality management system requirements (e.g., ISO 9001:2015 Clause 8.5.1).',
    `language_code` STRING COMMENT 'ISO 639-1/639-2 language code of the document content (e.g., en, de, zh-CN), supporting multilingual document management for multinational operations.. Valid values are `^[a-z]{2,3}(-[A-Z]{2,3})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the document record, used for change tracking and audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `owner_department` STRING COMMENT 'Organizational department or function responsible for the document, used for routing approvals, access control, and departmental document register reporting.',
    `parent_document_number` STRING COMMENT 'Document number of the higher-level document that this document is subordinate to (e.g., a work instruction referencing its parent procedure, or a form referencing its parent SOP), enabling document hierarchy navigation.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site where this document is primarily applicable. Used for site-specific document filtering and compliance reporting.',
    `prepared_by` STRING COMMENT 'Name or employee identifier of the individual who authored or prepared the document for the current revision.',
    `regulatory_standard` STRING COMMENT 'Primary regulatory or industry standard that this document is written to comply with or support, enabling compliance gap analysis and audit readiness reporting.. Valid values are `iso_9001|iso_14001|iso_45001|iso_50001|iec_61131|iec_62443|osha|epa|rohs|reach|ce_marking|ul|nist|ansi|iatf_16949|as9100|none`',
    `retention_period_years` STRING COMMENT 'Mandatory retention period in years for the document and its associated records, determined by regulatory requirements, customer contracts, and internal policy. Drives records management and archival workflows.. Valid values are `^[0-9]{1,3}$`',
    `review_due_date` DATE COMMENT 'Scheduled date by which the document must be reviewed for continued adequacy and accuracy. Drives the periodic review workflow to ensure documents remain current per ISO 9001 requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `review_frequency_months` STRING COMMENT 'Periodic review cycle in months defining how frequently the document must be reviewed for continued adequacy. Drives automated review due date calculation and reminder notifications.. Valid values are `^[0-9]{1,3}$`',
    `revision_level` STRING COMMENT 'Current revision identifier of the document (e.g., A, B, C or 01, 02, 03). Incremented each time the document undergoes a formal change and re-approval cycle per the Engineering Change Notice (ECN) or Engineering Change Order (ECO) process.. Valid values are `^[A-Z0-9]{1,5}$`',
    `revision_reason` STRING COMMENT 'Description of the reason for the current document revision, such as process improvement, CAPA-driven update, regulatory change, or customer requirement. Provides audit trail context for document changes.',
    `rohs_reach_applicable` BOOLEAN COMMENT 'Indicates whether this document is relevant to compliance with EU RoHS (Restriction of Hazardous Substances) or REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) regulations, flagging it for inclusion in regulatory compliance audits.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Operational system of record from which this QMS document record was sourced, supporting data lineage tracking in the Databricks Silver Layer.. Valid values are `teamcenter_plm|sap_qm|opcenter_mes|manual|other`',
    `status` STRING COMMENT 'Current lifecycle status of the QMS document within the document control workflow, from initial draft through approval, effectivity, and eventual obsolescence.. Valid values are `draft|under_review|pending_approval|approved|effective|superseded|obsolete|withdrawn|on_hold`',
    `storage_location_path` STRING COMMENT 'Repository path or URL where the controlled document master file is stored in the document management system (e.g., Siemens Teamcenter PLM or SharePoint), enabling direct navigation to the source document.',
    `superseded_document_number` STRING COMMENT 'Document number of the previous document or revision that this document replaces, maintaining traceability of document evolution and ensuring obsolete documents are properly retired.',
    `title` STRING COMMENT 'Full descriptive title of the QMS controlled document as it appears on the document cover page and in the document register.',
    `training_required` BOOLEAN COMMENT 'Indicates whether personnel must complete formal training and acknowledgement upon release or revision of this document before they are authorized to perform the associated activities.. Valid values are `true|false`',
    CONSTRAINT pk_qms_document PRIMARY KEY(`qms_document_id`)
) COMMENT 'Quality Management System (QMS) controlled document master record covering SOPs, work instructions, quality manuals, forms, and specifications. Captures document number, revision level, document type, owner, approval status, effective date, review due date, and distribution scope. Supports ISO 9001 Clause 7.5 documented information requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`apqp_plan` (
    `apqp_plan_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a single APQP plan record within the quality management system.',
    `actual_launch_date` DATE COMMENT 'Actual date on which production launch was achieved, compared against the target launch date to measure APQP schedule adherence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `apqp_readiness_score` DECIMAL(18,2) COMMENT 'Overall APQP readiness score expressed as a percentage (0–100), calculated from the weighted completion status of all key APQP deliverables, used to assess launch readiness.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `control_plan_status` STRING COMMENT 'Completion and approval status of the Control Plan, a mandatory APQP deliverable spanning Phases 3 and 4 that defines process controls for production.. Valid values are `not_started|in_progress|completed|approved|not_applicable`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the manufacturing plant executing the APQP plan, supporting multinational regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the APQP plan record was first created in the system, providing audit trail and data lineage for the quality management system.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `cross_functional_team` STRING COMMENT 'Comma-separated list of team members from engineering, quality, manufacturing, procurement, and customer functions participating in the APQP plan.',
    `current_phase` STRING COMMENT 'The active APQP phase (Phase 1–5) the plan is currently executing, aligned with the AIAG APQP five-phase framework for new product introduction.. Valid values are `phase_1_plan_and_define|phase_2_product_design_and_development|phase_3_process_design_and_development|phase_4_product_and_process_validation|phase_5_feedback_assessment_and_corrective_action`',
    `customer_approval_status` STRING COMMENT 'Status of customer approval for the APQP plan or associated PPAP, indicating whether the customer has formally accepted the quality planning outputs.. Valid values are `not_required|pending|approved|conditionally_approved|rejected`',
    `customer_code` STRING COMMENT 'Identifier of the customer for whom the APQP plan is being executed, relevant when the plan is driven by a customer-specific new product introduction requirement.',
    `customer_part_number` STRING COMMENT 'The customers own part number for the product being planned, required for cross-referencing during PPAP submission and customer approval activities.',
    `deliverables_completed` STRING COMMENT 'Number of APQP deliverables that have been completed and approved across all phases, used to track overall plan progress.. Valid values are `^[0-9]+$`',
    `deliverables_total` STRING COMMENT 'Total number of APQP deliverables defined in the plan across all five phases, used as the denominator for completion tracking.. Valid values are `^[0-9]+$`',
    `dfmea_status` STRING COMMENT 'Completion and approval status of the Design Failure Mode and Effects Analysis (DFMEA), a mandatory APQP Phase 2 deliverable.. Valid values are `not_started|in_progress|completed|approved|not_applicable`',
    `fai_status` STRING COMMENT 'Completion and approval status of the First Article Inspection (FAI), confirming that the first production parts meet all design and specification requirements.. Valid values are `not_started|in_progress|completed|approved|not_applicable`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the APQP plan record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `msa_status` STRING COMMENT 'Completion and approval status of the Measurement System Analysis (MSA) / Gauge R&R study, required to validate measurement systems before PPAP submission.. Valid values are `not_started|in_progress|completed|approved|not_applicable`',
    `open_issues_count` STRING COMMENT 'Number of unresolved issues or action items currently open against this APQP plan, used to assess launch risk and drive closure activities.. Valid values are `^[0-9]+$`',
    `part_name` STRING COMMENT 'Descriptive name of the part or product family covered by this APQP plan.',
    `part_number` STRING COMMENT 'Engineering part number of the product or component that is the subject of this APQP plan, linking quality planning to the product design record.',
    `part_revision` STRING COMMENT 'Engineering revision level of the part at the time the APQP plan was initiated, ensuring traceability to the design record.',
    `pfmea_status` STRING COMMENT 'Completion and approval status of the Process Failure Mode and Effects Analysis (PFMEA), a mandatory APQP Phase 3 deliverable.. Valid values are `not_started|in_progress|completed|approved|not_applicable`',
    `phase_gate_status` STRING COMMENT 'Status of the phase gate review for the current APQP phase, indicating whether the plan has passed the formal gate review to proceed to the next phase.. Valid values are `not_started|in_progress|gate_review_pending|gate_approved|gate_rejected|closed`',
    `plan_number` STRING COMMENT 'Business-facing unique identifier for the APQP plan, used for cross-functional referencing across quality, engineering, and production teams.. Valid values are `^APQP-[A-Z0-9]{2,10}-[0-9]{4,8}$`',
    `plan_owner` STRING COMMENT 'Name or employee identifier of the quality engineer or program manager accountable for driving the APQP plan to completion.',
    `plan_owner_department` STRING COMMENT 'Organizational department of the APQP plan owner, used for workload reporting and cross-functional accountability tracking.',
    `plan_start_date` DATE COMMENT 'Planned start date for the overall APQP plan, marking the formal initiation of the new product quality planning process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `plan_type` STRING COMMENT 'Classification of the APQP plan by the nature of the product quality planning activity, distinguishing new product introductions from change-driven plans.. Valid values are `new_product_introduction|engineering_change|supplier_change|process_change|capacity_expansion|regulatory_compliance`',
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant responsible for executing the APQP plan and producing the subject part.',
    `ppap_approval_date` DATE COMMENT 'Date on which the customer granted PPAP approval, confirming the manufacturing process is capable of producing conforming product.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ppap_level` STRING COMMENT 'PPAP submission level (1–5) required by the customer, defining the extent of documentation and samples to be submitted for approval.. Valid values are `^[1-5]$`',
    `ppap_status` STRING COMMENT 'Current status of the PPAP submission associated with this APQP plan, tracking progress from preparation through customer approval.. Valid values are `not_started|in_preparation|submitted|approved|conditionally_approved|rejected|interim_approval`',
    `ppap_submission_date` DATE COMMENT 'Planned or actual date for PPAP submission to the customer, a key milestone deliverable within Phase 4 of the APQP process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `priority` STRING COMMENT 'Business priority assigned to the APQP plan, reflecting strategic importance of the associated new product introduction or change program.. Valid values are `low|medium|high|critical`',
    `product_family` STRING COMMENT 'Product family or product line to which the APQP plan applies, enabling portfolio-level quality planning visibility across related products.',
    `risk_level` STRING COMMENT 'Overall risk classification assigned to the APQP plan based on product complexity, supplier readiness, and process maturity, used to prioritize management attention.. Valid values are `low|medium|high|critical`',
    `rohs_reach_applicable` BOOLEAN COMMENT 'Indicates whether the product covered by this APQP plan is subject to RoHS (Restriction of Hazardous Substances) and/or REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) regulatory compliance requirements.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which the APQP plan data originates, supporting data lineage and integration traceability in the lakehouse.. Valid values are `SAP_S4HANA|Siemens_Teamcenter|Siemens_Opcenter|Manual|Other`',
    `status` STRING COMMENT 'Current lifecycle status of the APQP plan, governing whether it is actively being executed, completed, or archived.. Valid values are `draft|active|on_hold|completed|cancelled|superseded`',
    `target_launch_date` DATE COMMENT 'Target date for production launch (Job 1 / SOP - Start of Production), representing the end goal of the APQP process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `title` STRING COMMENT 'Descriptive title of the APQP plan, typically referencing the new product introduction (NPI) program or product family being launched.',
    CONSTRAINT pk_apqp_plan PRIMARY KEY(`apqp_plan_id`)
) COMMENT 'Master record for Advanced Product Quality Planning (APQP) plans associated with R&D-to-production transition projects. Captures APQP phase (Phase 1–5), plan owner, target product family, planned and actual completion dates per phase, key deliverables checklist status (DFMEA, PFMEA, control plan, MSA, PPAP), and overall APQP readiness score. Bridges the R&D domain with quality and engineering domains during new product introduction (NPI) transitions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` (
    `plan_characteristic_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying this specific plan-characteristic assignment record',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to the quality characteristic (CTQ feature) being inspected under this plan',
    `gauge_id` BIGINT COMMENT 'Identifier of the specific measurement equipment or gauge assigned for measuring this characteristic in this plan',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to the inspection plan master record that governs this characteristic inspection',
    `quality_characteristic_id` BIGINT COMMENT 'Foreign key to quality_characteristic',
    `aql_level` STRING COMMENT 'The AQL assigned to this characteristic within this plan, representing the maximum percent defective acceptable for this specific characteristic inspection',
    `characteristic_class` STRING COMMENT 'Risk-based classification of this characteristic within the context of this plan (critical, major, minor, incidental), which may differ from the characteristic master classification based on application context',
    `characteristic_count` STRING COMMENT 'Total number of inspection characteristics (both quantitative and qualitative) defined within this inspection plan. Provides a quick indicator of plan complexity and inspection effort. [Moved from inspection_plan: This is a derived count of plan_characteristic records and should be calculated dynamically rather than stored redundantly in the inspection_plan product]. Valid values are `^[0-9]{1,4}$`',
    `cpk_minimum_required` DECIMAL(18,2) COMMENT 'The minimum acceptable Cpk threshold for this characteristic within this plan, which may be more stringent than the characteristic master default based on plan context',
    `effective_date` DATE COMMENT 'Date from which this characteristic assignment to this plan becomes active and governs inspection execution',
    `expiration_date` DATE COMMENT 'Date after which this characteristic assignment to this plan is no longer active, supporting plan revision management',
    `inspection_method_code` STRING COMMENT 'Code identifying the specific inspection method or test procedure to be used for this characteristic in this plan (e.g., CMM measurement, visual inspection, functional test)',
    `recording_type` STRING COMMENT 'Specifies how measurement results for this characteristic should be recorded in this plan (single value per sample, summary statistics, calculated value)',
    `sample_size` STRING COMMENT 'Number of units to be measured for this specific characteristic within this plan, which may differ from the plan-level sample size based on characteristic criticality',
    `sequence_number` STRING COMMENT 'Sequential order in which this characteristic appears in the inspection plan, determining the inspection workflow sequence on the shop floor',
    `skip_lot_eligible` BOOLEAN COMMENT 'Indicates whether this characteristic is eligible for skip-lot inspection within this plan based on historical performance',
    `spc_enabled` BOOLEAN COMMENT 'Indicates whether Statistical Process Control monitoring is activated for this characteristic within this specific plan context',
    `status` STRING COMMENT 'Current lifecycle status of this characteristic assignment within this plan',
    CONSTRAINT pk_plan_characteristic PRIMARY KEY(`plan_characteristic_id`)
) COMMENT 'This association product represents the operational assignment of quality characteristics to inspection plans in the SAP QM system. Each record defines how a specific quality characteristic is inspected within a specific inspection plan, including characteristic-specific sampling parameters, acceptance criteria, measurement methods, and SPC requirements that exist only in the context of this plan-characteristic combination. This is the operational master data that governs inspection lot execution.. Existence Justification: In industrial manufacturing QMS practice, inspection plans are explicitly multi-characteristic documents that define how multiple CTQ features are inspected. A single inspection plan governs inspection of many characteristics (e.g., a shaft inspection plan checks diameter, length, surface finish, hardness), and a single quality characteristic appears in many inspection plans (e.g., outer diameter is checked in plans for shafts, bearings, housings). Quality engineers actively manage these plan-characteristic assignments with characteristic-specific parameters.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`project_team_member` (
    `project_team_member_id` BIGINT COMMENT 'Unique system-generated identifier for each APQP project team member assignment record',
    `apqp_project_id` BIGINT COMMENT 'Foreign key linking to the APQP project for which this team member is assigned',
    `employee_id` BIGINT COMMENT 'Foreign key linking to the employee assigned to this APQP project team',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'The percentage of the employees working time allocated to this APQP project, used for resource capacity planning and workload balancing across multiple concurrent projects. Expressed as a decimal (e.g., 0.25 for 25% allocation).',
    `assignment_status` STRING COMMENT 'Current status of this team member assignment, tracking whether the assignment is active, planned for future phases, temporarily on hold, completed, or has been reassigned to another employee.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp capturing when this team member assignment record was created in the system.',
    `end_date` DATE COMMENT 'The date on which this employees formal assignment to the APQP project team concluded, either due to project completion, phase transition, or team restructuring. Null indicates ongoing active assignment.',
    `is_core_team` BOOLEAN COMMENT 'Indicates whether this employee is a core team member (true) or extended team member (false) for this APQP project. Core team members have full-time accountability across all phases, while extended team members provide phase-specific or functional support.',
    `phase_responsibility` STRING COMMENT 'The specific APQP phase(s) for which this team member has primary responsibility or active participation. Enables phase-specific resource planning and accountability tracking across the structured five-phase process (Planning, Product Design, Process Design, Product/Process Validation, Production Launch).',
    `start_date` DATE COMMENT 'The date on which this employee formally joined the APQP project team, marking the beginning of their active participation and responsibility for project deliverables.',
    `team_role` STRING COMMENT 'The functional role this employee fulfills on the APQP project team, defining their responsibilities and deliverable ownership across the five-phase lifecycle. Core roles include Program Manager, Quality Engineer, Design Engineer, Manufacturing Engineer, and Purchasing Representative.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp capturing when this team member assignment record was last modified.',
    CONSTRAINT pk_project_team_member PRIMARY KEY(`project_team_member_id`)
) COMMENT 'This association product represents the Assignment between apqp_project and employee. It captures the formal assignment of employees to APQP project teams with defined roles, phase responsibilities, and resource allocation. Each record links one apqp_project to one employee with attributes that exist only in the context of this team assignment, enabling cross-functional team management and resource planning across the five-phase APQP lifecycle.. Existence Justification: APQP projects in manufacturing require cross-functional teams with multiple employees assigned to each project in defined roles (Program Manager, Quality Engineer, Design Engineer, Manufacturing Engineer, etc.), and employees typically work on multiple APQP projects simultaneously with varying allocation percentages and phase-specific responsibilities. The business actively manages these team assignments as operational records, tracking role, phase responsibility, allocation percentage, start/end dates, and core vs. extended team status. This is a recognized business process where project managers and resource planners create, update, and query team assignments throughout the APQP lifecycle.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`gauge_loan` (
    `gauge_loan_id` BIGINT COMMENT 'Unique system-generated identifier for each gauge loan transaction record',
    `gauge_id` BIGINT COMMENT 'Foreign key linking to the gauge master record identifying which measurement instrument is being loaned',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier master record identifying which supplier has custody of the gauge',
    `authorized_by` STRING COMMENT 'Name or employee ID of the quality or metrology personnel who authorized the gauge loan. Used for accountability and audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the gauge loan record was created in the system',
    `custody_status` STRING COMMENT 'Current status of the gauge loan: OUT_ON_LOAN (currently with supplier), RETURNED (back in internal custody), OVERDUE (past expected return date), LOST (not returned and cannot be located), IN_CALIBRATION (at supplier for calibration service)',
    `expected_return_date` DATE COMMENT 'Scheduled or agreed-upon date by which the gauge should be returned from supplier custody. Used for tracking overdue loans and asset management.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'System timestamp when the gauge loan record was last modified',
    `loan_end_date` DATE COMMENT 'Date on which the gauge was returned from supplier custody or null if still on loan. Used to close the loan record and calculate actual loan duration.',
    `loan_purpose` STRING COMMENT 'Business reason for the gauge loan, such as specific project, incoming inspection requirement, or calibration service. Provides context for the custody transfer.',
    `loan_start_date` DATE COMMENT 'Date on which the gauge was transferred to supplier custody. Used to calculate loan duration and trigger return reminders.',
    `notes` STRING COMMENT 'Free-text notes capturing additional details about the loan, special handling instructions, or issues encountered during the loan period.',
    `ownership_type` STRING COMMENT 'Classification of the custody arrangement: LOAN (temporary transfer for supplier use), CALIBRATION_SERVICE (sent to supplier for calibration), CONSIGNMENT (supplier holds for potential use), TRIAL (evaluation period)',
    `return_condition` STRING COMMENT 'Condition assessment of the gauge upon return from supplier custody: GOOD (no issues), DAMAGED (physical damage observed), REQUIRES_CALIBRATION (due for recalibration), OUT_OF_TOLERANCE (failed verification check), LOST (not returned)',
    `shipping_tracking_number` STRING COMMENT 'Carrier tracking number for the shipment of the gauge to or from the supplier. Used to track physical movement and confirm delivery.',
    CONSTRAINT pk_gauge_loan PRIMARY KEY(`gauge_loan_id`)
) COMMENT 'This association product represents the loan or custody transfer of measurement equipment between the organization and suppliers. It captures the business process of loaning gauges to suppliers for in-process inspection or sending gauges to suppliers for calibration services. Each record links one gauge to one supplier with attributes that track custody, loan period, and return condition.. Existence Justification: In industrial manufacturing operations, gauges and measurement equipment are frequently loaned to suppliers for two primary business scenarios: (1) suppliers performing in-process inspection using the manufacturers calibrated gauges to ensure quality consistency, and (2) gauges being sent to external calibration laboratories (who are suppliers) for periodic calibration services. A single gauge can be loaned to multiple suppliers over time (e.g., sent to Supplier A for calibration in Q1, loaned to Supplier B for incoming inspection in Q2), and suppliers interact with multiple gauges (e.g., a calibration lab services dozens of different gauges, a tier-1 supplier may borrow multiple measurement tools for a production run). The business actively manages these loan transactions with custody tracking, return dates, and condition assessment.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`measurement_capability` (
    `measurement_capability_id` BIGINT COMMENT 'Unique surrogate key identifying this measurement capability configuration',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to the quality characteristic being measured',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to the OT system performing the measurement',
    `quality_characteristic_id` BIGINT COMMENT 'Foreign key to quality_characteristic - the characteristic being measured',
    `active_flag` BOOLEAN COMMENT 'Indicates whether this measurement capability configuration is currently active in production. Inactive configurations represent historical or planned capabilities.',
    `alarm_threshold` DECIMAL(18,2) COMMENT 'The measurement value threshold at which the OT system triggers an alarm or notification for this quality characteristic. May differ from specification limits to provide early warning.',
    `collection_frequency` STRING COMMENT 'Frequency at which this OT system collects measurement data for this quality characteristic (e.g., CONTINUOUS, EVERY_PART, EVERY_5_PARTS, HOURLY). Drives SPC subgroup formation.',
    `data_format` STRING COMMENT 'The data format or protocol used by the OT system to transmit measurement data for this characteristic (e.g., OPC_UA, MODBUS_TCP, MTConnect, CSV_FILE). Drives integration architecture.',
    `effective_end_date` DATE COMMENT 'Date on which this measurement capability configuration ceased or will cease to be effective. Null for currently active configurations.',
    `effective_start_date` DATE COMMENT 'Date from which this measurement capability configuration became or will become effective in production operations.',
    `gage_r_and_r_percentage` DECIMAL(18,2) COMMENT 'The Gage Repeatability and Reproducibility percentage from the most recent MSA study for this characteristic-system combination. Must be <10% for critical characteristics, <30% for others.',
    `last_msa_date` DATE COMMENT 'Date of the most recent Measurement System Analysis study validating this OT systems capability to measure this characteristic. MSA studies typically required annually or after system changes.',
    `measurement_capability` STRING COMMENT 'Assessment of whether this OT system is capable of measuring this quality characteristic within specification limits. Drives routing decisions for inspection and inline measurement.',
    `measurement_resolution` DECIMAL(18,2) COMMENT 'The smallest increment that this OT system can resolve when measuring this characteristic. Must be at least 10x finer than tolerance to meet measurement system analysis (MSA) requirements.',
    `next_msa_due_date` DATE COMMENT 'Scheduled date for the next MSA study for this characteristic-system pairing. Drives calibration and validation planning.',
    `spc_enabled` BOOLEAN COMMENT 'Indicates whether Statistical Process Control monitoring is enabled for this characteristic-system pairing. When true, measurement data is fed to SPC charts for real-time process monitoring.',
    CONSTRAINT pk_measurement_capability PRIMARY KEY(`measurement_capability_id`)
) COMMENT 'This association product represents the measurement capability configuration between quality characteristics and OT systems. It captures which OT systems are capable of measuring which quality characteristics, along with the technical parameters governing data collection, SPC enablement, and alarm thresholds. Each record links one quality characteristic to one OT system with attributes that define how that specific characteristic is measured by that specific system.. Existence Justification: In manufacturing operations, a single quality characteristic (e.g., shaft diameter) can be measured by multiple OT systems across different production lines or process stages (inline CMM, vision system, manual gauge station). Conversely, a single OT system (e.g., a multi-sensor CMM) measures multiple quality characteristics simultaneously. Quality engineers actively configure and manage these measurement capability assignments, tracking which systems measure which characteristics along with collection frequency, SPC enablement, alarm thresholds, and MSA validation status for each pairing.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ADD CONSTRAINT `fk_quality_fmea_action_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ADD CONSTRAINT `fk_quality_fmea_action_quality_capa_id` FOREIGN KEY (`quality_capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_capa`(`quality_capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_apqp_project_id` FOREIGN KEY (`apqp_project_id`) REFERENCES `manufacturing_ecm`.`quality`.`apqp_project`(`apqp_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_ppap_submission_id` FOREIGN KEY (`ppap_submission_id`) REFERENCES `manufacturing_ecm`.`quality`.`ppap_submission`(`ppap_submission_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_spc_chart_id` FOREIGN KEY (`spc_chart_id`) REFERENCES `manufacturing_ecm`.`quality`.`spc_chart`(`spc_chart_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_quality_capa_id` FOREIGN KEY (`quality_capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_capa`(`quality_capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ADD CONSTRAINT `fk_quality_quality_audit_finding_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `manufacturing_ecm`.`quality`.`audit`(`audit_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ADD CONSTRAINT `fk_quality_quality_audit_finding_quality_capa_id` FOREIGN KEY (`quality_capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_capa`(`quality_capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ADD CONSTRAINT `fk_quality_apqp_project_apqp_plan_id` FOREIGN KEY (`apqp_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`apqp_plan`(`apqp_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ADD CONSTRAINT `fk_quality_apqp_deliverable_apqp_project_id` FOREIGN KEY (`apqp_project_id`) REFERENCES `manufacturing_ecm`.`quality`.`apqp_project`(`apqp_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ADD CONSTRAINT `fk_quality_msa_study_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ADD CONSTRAINT `fk_quality_msa_study_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ADD CONSTRAINT `fk_quality_msa_study_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ADD CONSTRAINT `fk_quality_msa_study_ppap_submission_id` FOREIGN KEY (`ppap_submission_id`) REFERENCES `manufacturing_ecm`.`quality`.`ppap_submission`(`ppap_submission_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_quality_capa_id` FOREIGN KEY (`quality_capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_capa`(`quality_capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_quality_capa_id` FOREIGN KEY (`quality_capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_capa`(`quality_capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_quality_capa_id` FOREIGN KEY (`quality_capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_capa`(`quality_capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_quality_capa_id` FOREIGN KEY (`quality_capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_capa`(`quality_capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ADD CONSTRAINT `fk_quality_plan_characteristic_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ADD CONSTRAINT `fk_quality_plan_characteristic_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ADD CONSTRAINT `fk_quality_plan_characteristic_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ADD CONSTRAINT `fk_quality_plan_characteristic_quality_characteristic_id` FOREIGN KEY (`quality_characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ADD CONSTRAINT `fk_quality_project_team_member_apqp_project_id` FOREIGN KEY (`apqp_project_id`) REFERENCES `manufacturing_ecm`.`quality`.`apqp_project`(`apqp_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ADD CONSTRAINT `fk_quality_gauge_loan_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ADD CONSTRAINT `fk_quality_measurement_capability_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ADD CONSTRAINT `fk_quality_measurement_capability_quality_characteristic_id` FOREIGN KEY (`quality_characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`quality` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`quality` SET TAGS ('dbx_domain' = 'quality');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` SET TAGS ('dbx_subdomain' = 'inspection_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_validation|phase_5_launch|production');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `aql_level` SET TAGS ('dbx_business_glossary_term' = 'Acceptable Quality Level (AQL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `aql_level` SET TAGS ('dbx_value_regex' = '^(0.065|0.1|0.15|0.25|0.4|0.65|1.0|1.5|2.5|4.0|6.5|10.0|15.0|25.0|40.0|65.0|100.0)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `cpk_minimum_required` SET TAGS ('dbx_business_glossary_term' = 'Minimum Required Process Capability Index - Centered (Cpk)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `cpk_minimum_required` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `customer_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `customer_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `destructive_test` SET TAGS ('dbx_business_glossary_term' = 'Destructive Test Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `destructive_test` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `dynamic_modification_rule` SET TAGS ('dbx_business_glossary_term' = 'Dynamic Modification Rule');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `dynamic_modification_rule` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `fai_required` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `fai_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_category` SET TAGS ('dbx_business_glossary_term' = 'Inspection Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_category` SET TAGS ('dbx_value_regex' = 'dimensional|visual|functional|chemical|mechanical|electrical|environmental|destructive|non_destructive');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_level` SET TAGS ('dbx_business_glossary_term' = 'Inspection Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_level` SET TAGS ('dbx_value_regex' = 'I|II|III|S-1|S-2|S-3|S-4');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_method_code` SET TAGS ('dbx_business_glossary_term' = 'Inspection Method Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_method_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Language Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `long_text` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Long Text');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,18}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `measurement_equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Equipment Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `measurement_equipment_type` SET TAGS ('dbx_value_regex' = 'cmm|caliper|micrometer|gauge|spectrometer|hardness_tester|vision_system|coordinate_measuring|torque_wrench|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `operation_number` SET TAGS ('dbx_business_glossary_term' = 'Operation Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `operation_number` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_group` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Group');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,8}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_group_counter` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Group Counter');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_group_counter` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'goods_receipt|goods_issue|in_process|final_inspection|first_article|supplier_audit|customer_return|periodic_inspection');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `revision_level` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `revision_level` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_business_glossary_term' = 'RoHS/REACH Compliance Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `sample_size_unit` SET TAGS ('dbx_business_glossary_term' = 'Sample Size Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `sample_size_unit` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|M2|M3|PC');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `sampling_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Sampling Procedure Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `sampling_procedure_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `skip_lot_enabled` SET TAGS ('dbx_business_glossary_term' = 'Skip-Lot Inspection Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `skip_lot_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `spc_enabled` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `spc_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|inactive|obsolete|under_review|released');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `supplier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `usage_decision_required` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `usage_decision_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `work_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,8}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Valid From Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Valid To Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` SET TAGS ('dbx_subdomain' = 'inspection_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `logistics_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Accepted Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `batch_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `defects_found` SET TAGS ('dbx_business_glossary_term' = 'Number of Defects Found');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `defects_found` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `dynamic_modification_rule` SET TAGS ('dbx_business_glossary_term' = 'Dynamic Modification Rule');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `dynamic_modification_rule` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_end_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection End Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_result_summary` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result Summary');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_result_summary` SET TAGS ('dbx_value_regex' = 'accepted|rejected|conditionally_accepted|pending|partially_accepted');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_stage` SET TAGS ('dbx_business_glossary_term' = 'Inspection Stage');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_stage` SET TAGS ('dbx_value_regex' = 'normal|tightened|reduced|skip');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_start_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = '01|04|05|06|08|09|10|11|12|13|14|15|89');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_type_description` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `is_first_article_inspection` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `is_first_article_inspection` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_origin` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Origin');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_origin` SET TAGS ('dbx_value_regex' = 'production_order|purchase_order|goods_receipt|delivery|manual|repetitive_manufacturing|returns|audit|in_process');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_quantity` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `lot_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `ncr_number` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `ncr_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `nonconforming_quantity` SET TAGS ('dbx_business_glossary_term' = 'Nonconforming Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `nonconforming_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `rework_quantity` SET TAGS ('dbx_business_glossary_term' = 'Rework Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `rework_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `sample_size` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scrap Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'created|in_inspection|results_recorded|usage_decision_made|completed|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `usage_decision_by` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Made By');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `usage_decision_code` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `usage_decision_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `usage_decision_description` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `usage_decision_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `usage_decision_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `vendor_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `vendor_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Work Center');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `work_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` SET TAGS ('dbx_subdomain' = 'inspection_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_result_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge / Measurement Equipment ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `aql_level` SET TAGS ('dbx_business_glossary_term' = 'Acceptable Quality Level (AQL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `attribute_result` SET TAGS ('dbx_business_glossary_term' = 'Attribute Inspection Result');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `attribute_result` SET TAGS ('dbx_value_regex' = 'pass|fail|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch / Lot Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `characteristic_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Characteristic Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `characteristic_type` SET TAGS ('dbx_value_regex' = 'variable|attribute|count');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `conformance_decision` SET TAGS ('dbx_business_glossary_term' = 'Conformance Decision');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `conformance_decision` SET TAGS ('dbx_value_regex' = 'accepted|rejected|conditional_accept|rework_required|scrap|pending');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `cp_index` SET TAGS ('dbx_business_glossary_term' = 'Process Capability Index (Cp)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `cpk_index` SET TAGS ('dbx_business_glossary_term' = 'Process Capability Index Centered (Cpk)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_category` SET TAGS ('dbx_business_glossary_term' = 'Inspection Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_category` SET TAGS ('dbx_value_regex' = 'incoming|in_process|final|first_article|audit|supplier|customer_return');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_operation_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Operation Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_stage` SET TAGS ('dbx_business_glossary_term' = 'Inspection Stage');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_stage` SET TAGS ('dbx_value_regex' = 'receiving|pre_production|in_process|post_process|final|shipping');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspector_name` SET TAGS ('dbx_business_glossary_term' = 'Inspector Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspector_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `lower_control_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Control Limit (LCL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Specification Limit (LSL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `measured_value` SET TAGS ('dbx_business_glossary_term' = 'Measured Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `ncr_number` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `nominal_value` SET TAGS ('dbx_business_glossary_term' = 'Nominal (Target) Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `retest_flag` SET TAGS ('dbx_business_glossary_term' = 'Retest Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `retest_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `retest_sequence` SET TAGS ('dbx_business_glossary_term' = 'Retest Sequence Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `sample_number` SET TAGS ('dbx_business_glossary_term' = 'Sample Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `sign_off_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspector Sign-Off Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `spc_rule_violated` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Rule Violated');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `spc_violation_flag` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Violation Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `spc_violation_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `upper_control_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` SET TAGS ('dbx_subdomain' = 'inspection_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `usage_decision_id` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Accepted Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approved_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `batch_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Comments');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `conditional_release_conditions` SET TAGS ('dbx_business_glossary_term' = 'Conditional Release Conditions');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_category` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_category` SET TAGS ('dbx_value_regex' = 'accept|reject|conditional_release|scrap|rework|return_to_supplier');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_code` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_date` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_description` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Decision Reversal Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_status` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_status` SET TAGS ('dbx_value_regex' = 'open|in_review|decided|reversed|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `decision_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `defect_code` SET TAGS ('dbx_business_glossary_term' = 'Defect Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `defect_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `defect_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_lot_created_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Created Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_lot_created_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_lot_origin` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Origin');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_lot_origin` SET TAGS ('dbx_value_regex' = 'goods_receipt|production_order|delivery|customer_complaint|audit|periodic_inspection|first_article|returns');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_quantity` SET TAGS ('dbx_business_glossary_term' = 'Inspection Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = 'incoming|in_process|final|first_article|periodic|audit|customer_return|supplier_return');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `ncr_number` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `ncr_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `quality_score` SET TAGS ('dbx_business_glossary_term' = 'Quality Score');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `quality_score` SET TAGS ('dbx_value_regex' = '^(100(.00?)?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `regulatory_hold` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Hold Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `regulatory_hold` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `rejected_quantity` SET TAGS ('dbx_business_glossary_term' = 'Rejected Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `rejected_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `requires_approval` SET TAGS ('dbx_business_glossary_term' = 'Requires Approval Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `requires_approval` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `responsible_quality_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Quality Engineer');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `responsible_quality_engineer` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scrap Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|OPCENTER_MES|MANUAL|TEAMCENTER');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `stock_posting_instruction` SET TAGS ('dbx_business_glossary_term' = 'Stock Posting Instruction');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `stock_posting_instruction` SET TAGS ('dbx_value_regex' = 'unrestricted|blocked|scrap|return_to_vendor|rework|conditional_release|quality_stock');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `stock_posting_status` SET TAGS ('dbx_business_glossary_term' = 'Stock Posting Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `stock_posting_status` SET TAGS ('dbx_value_regex' = 'pending|posted|failed|not_required');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `vendor_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `vendor_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `capa_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Capa Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `ecn_id` SET TAGS ('dbx_business_glossary_term' = 'Ecn Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `eco_id` SET TAGS ('dbx_business_glossary_term' = 'Eco Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Owner Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `action_owner` SET TAGS ('dbx_business_glossary_term' = 'CAPA Action Owner');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `action_owner_department` SET TAGS ('dbx_business_glossary_term' = 'Action Owner Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Actual Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `affected_part_description` SET TAGS ('dbx_business_glossary_term' = 'Affected Part Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `affected_part_number` SET TAGS ('dbx_business_glossary_term' = 'Affected Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `affected_process` SET TAGS ('dbx_business_glossary_term' = 'Affected Manufacturing Process');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'CAPA Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `customer_notified_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `customer_notified_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `defect_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `defect_category` SET TAGS ('dbx_value_regex' = 'dimensional|functional|cosmetic|material|process|documentation|safety|environmental|labeling|packaging');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_business_glossary_term' = 'CAPA Effectiveness Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_value_regex' = 'effective|partially_effective|not_effective|pending_verification');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `immediate_containment_action` SET TAGS ('dbx_business_glossary_term' = 'Immediate Containment Action');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `initiated_by` SET TAGS ('dbx_business_glossary_term' = 'CAPA Initiated By');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `initiated_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Initiation Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `initiated_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^CAPA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'CAPA Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `problem_statement` SET TAGS ('dbx_business_glossary_term' = 'Problem Statement');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `recurrence_capa_number` SET TAGS ('dbx_business_glossary_term' = 'Recurrence CAPA Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `recurrence_capa_number` SET TAGS ('dbx_value_regex' = '^CAPA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `regulatory_reporting_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `regulatory_reporting_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `revised_closure_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Revised Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `revised_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category (6M)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'man|machine|material|method|measurement|environment|management');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `root_cause_method` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis (RCA) Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `root_cause_method` SET TAGS ('dbx_value_regex' = '5_why|ishikawa|fault_tree|8d|pareto|fmea|brainstorming|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `source_reference_number` SET TAGS ('dbx_business_glossary_term' = 'CAPA Source Reference Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `source_type` SET TAGS ('dbx_business_glossary_term' = 'CAPA Source Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `source_type` SET TAGS ('dbx_value_regex' = 'ncr|customer_complaint|audit_finding|spc_alert|supplier_defect|field_failure|internal_observation|regulatory_finding|ppap_rejection|fai_failure');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'CAPA Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|open|root_cause_analysis|action_planning|implementation|verification|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Target Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'CAPA Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'CAPA Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'corrective|preventive|improvement');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Verification Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `verification_evidence` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Verification Evidence');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `verification_method` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Verification Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `verification_method` SET TAGS ('dbx_value_regex' = 'inspection|audit|spc_monitoring|process_validation|customer_feedback|production_run|document_review|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `hazard_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `action_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Action Actual Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `action_completed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `action_priority` SET TAGS ('dbx_business_glossary_term' = 'Action Priority (AP)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `action_priority` SET TAGS ('dbx_value_regex' = 'H|M|L');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `action_responsibility` SET TAGS ('dbx_business_glossary_term' = 'Action Responsibility Owner');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `action_target_date` SET TAGS ('dbx_business_glossary_term' = 'Action Target Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `action_target_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'FMEA Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `design_stage` SET TAGS ('dbx_business_glossary_term' = 'Design / Development Stage');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `design_stage` SET TAGS ('dbx_value_regex' = 'concept|preliminary_design|detailed_design|prototype|production|post_production');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `detection_control` SET TAGS ('dbx_business_glossary_term' = 'Current Detection Control');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `detection_rating` SET TAGS ('dbx_business_glossary_term' = 'Detection (D) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `detection_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `failure_cause` SET TAGS ('dbx_business_glossary_term' = 'Potential Cause of Failure');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `failure_effect` SET TAGS ('dbx_business_glossary_term' = 'Potential Effect of Failure');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Potential Failure Mode');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `function` SET TAGS ('dbx_business_glossary_term' = 'Item Function');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `initiated_date` SET TAGS ('dbx_business_glossary_term' = 'FMEA Initiation Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `initiated_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `item_name` SET TAGS ('dbx_business_glossary_term' = 'Item / System Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `item_number` SET TAGS ('dbx_business_glossary_term' = 'Item / Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `model_year_applicability` SET TAGS ('dbx_business_glossary_term' = 'Model Year / Product Generation Applicability');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^FMEA-[A-Z]{2,6}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `occurrence_rating` SET TAGS ('dbx_business_glossary_term' = 'Occurrence (O) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `occurrence_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `prepared_by` SET TAGS ('dbx_business_glossary_term' = 'Prepared By');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `prevention_control` SET TAGS ('dbx_business_glossary_term' = 'Current Prevention Control');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `process_step` SET TAGS ('dbx_business_glossary_term' = 'Process Step / Operation');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `recommended_action` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `regulatory_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Impact Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `regulatory_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_action_priority` SET TAGS ('dbx_business_glossary_term' = 'Revised Action Priority (AP)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_action_priority` SET TAGS ('dbx_value_regex' = 'H|M|L');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_detection_rating` SET TAGS ('dbx_business_glossary_term' = 'Revised Detection (D) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_detection_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_occurrence_rating` SET TAGS ('dbx_business_glossary_term' = 'Revised Occurrence (O) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_occurrence_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_rpn` SET TAGS ('dbx_business_glossary_term' = 'Revised Risk Priority Number (RPN)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_rpn` SET TAGS ('dbx_value_regex' = '^([1-9][0-9]{0,2}|1000)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Revised Severity (S) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revised_severity_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revision` SET TAGS ('dbx_business_glossary_term' = 'FMEA Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `rpn` SET TAGS ('dbx_business_glossary_term' = 'Risk Priority Number (RPN)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `rpn` SET TAGS ('dbx_value_regex' = '^([1-9][0-9]{0,2}|1000)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Characteristic Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Severity (S) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `severity_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System of Record');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'FMEA Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|released|obsolete|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `team_members` SET TAGS ('dbx_business_glossary_term' = 'FMEA Cross-Functional Team Members');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'FMEA Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'DFMEA|PFMEA|SFMEA|MFMEA');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `fmea_action_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) Action ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Fmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_category` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_category` SET TAGS ('dbx_value_regex' = 'recommended|implemented|planned|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_description` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_number` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_number` SET TAGS ('dbx_value_regex' = '^ACT-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_result_description` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Result Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_type` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `action_type` SET TAGS ('dbx_value_regex' = 'prevention|detection|correction|redesign|process_change|validation|verification|monitoring');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `actual_cost` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Actual Cost');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `actual_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch|post_launch');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Actual Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `control_type` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Control Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `control_type` SET TAGS ('dbx_value_regex' = 'design_change|process_change|additional_control|test_validation|inspection|poka_yoke|spc|training|procedure_update|supplier_change');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `effectiveness_confirmed` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Effectiveness Confirmed');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `effectiveness_confirmed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Estimated Cost');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `evidence_reference` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Evidence Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `failure_mode_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `fmea_type` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `fmea_type` SET TAGS ('dbx_value_regex' = 'DFMEA|PFMEA|SFMEA|MFMEA');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_detection_rating` SET TAGS ('dbx_business_glossary_term' = 'Initial Detection (D) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_detection_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_occurrence_rating` SET TAGS ('dbx_business_glossary_term' = 'Initial Occurrence (O) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_occurrence_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_rpn` SET TAGS ('dbx_business_glossary_term' = 'Initial Risk Priority Number (RPN)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_rpn` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-9][0-9]{1,2}|1000)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Initial Severity (S) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `initial_severity_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `ppap_required` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Required');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `ppap_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `process_step` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Process Step');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `related_ecn_number` SET TAGS ('dbx_business_glossary_term' = 'Related Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Responsible Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `responsible_owner` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Responsible Owner');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_detection_rating` SET TAGS ('dbx_business_glossary_term' = 'Revised Detection (D) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_detection_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_occurrence_rating` SET TAGS ('dbx_business_glossary_term' = 'Revised Occurrence (O) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_occurrence_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_rpn` SET TAGS ('dbx_business_glossary_term' = 'Revised Risk Priority Number (RPN)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_rpn` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-9][0-9]{1,2}|1000)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Revised Severity (S) Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `revised_severity_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `rpn_reduction_target` SET TAGS ('dbx_business_glossary_term' = 'Risk Priority Number (RPN) Reduction Target');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `rpn_reduction_target` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-9][0-9]{1,2}|1000)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|completed|verified|cancelled|overdue');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `target_date` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Target Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `target_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Verification Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'FMEA Action Verified By');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Fmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `characteristic_class` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Classification');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `characteristic_class` SET TAGS ('dbx_value_regex' = 'critical|significant|major|minor|none');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `control_chart_type` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Chart Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `control_chart_type` SET TAGS ('dbx_value_regex' = 'xbar_r|xbar_s|individuals_mr|p_chart|np_chart|c_chart|u_chart|cusum|ewma|none');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `control_method` SET TAGS ('dbx_business_glossary_term' = 'Control Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `control_method` SET TAGS ('dbx_value_regex' = 'spc|attribute_gauge|variable_gauge|visual_inspection|cmm|functional_test|go_no_go|poka_yoke|100_percent|sampling');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `cpk_minimum` SET TAGS ('dbx_business_glossary_term' = 'Minimum Process Capability Index (Cpk)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `cpk_minimum` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}.[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `customer_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `measurement_technique` SET TAGS ('dbx_business_glossary_term' = 'Measurement Technique');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Review Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `part_revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^CP-[A-Z0-9]{2,10}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'prototype|pre_launch|production');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = '1|2|3|4|5');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `prepared_by` SET TAGS ('dbx_business_glossary_term' = 'Prepared By');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `process_characteristic` SET TAGS ('dbx_business_glossary_term' = 'Process Characteristic');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `process_flow_reference` SET TAGS ('dbx_business_glossary_term' = 'Process Flow Diagram (PFD) Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `process_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Process Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `process_step_number` SET TAGS ('dbx_business_glossary_term' = 'Process Step Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `production_line` SET TAGS ('dbx_business_glossary_term' = 'Production Line');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `reaction_plan` SET TAGS ('dbx_business_glossary_term' = 'Reaction Plan');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `revision` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `sample_frequency` SET TAGS ('dbx_business_glossary_term' = 'Sample Frequency');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `sample_size` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'sap_qm|opcenter_mes|teamcenter_plm|manual|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `specification_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Specification Limit (LSL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `specification_nominal` SET TAGS ('dbx_business_glossary_term' = 'Specification Nominal Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `specification_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|active|superseded|obsolete|on_hold');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `work_instruction_reference` SET TAGS ('dbx_business_glossary_term' = 'Work Instruction / Standard Operating Procedure (SOP) Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` SET TAGS ('dbx_subdomain' = 'product_validation');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `apqp_project_id` SET TAGS ('dbx_business_glossary_term' = 'Apqp Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `annual_production_volume` SET TAGS ('dbx_business_glossary_term' = 'Annual Production Volume');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `appearance_approval_complete` SET TAGS ('dbx_business_glossary_term' = 'Appearance Approval Report (AAR) Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `appearance_approval_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Approval Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|conditionally_approved|rejected|pending');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `capability_study_complete` SET TAGS ('dbx_business_glossary_term' = 'Initial Process Capability Study Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `capability_study_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `control_plan_complete` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `control_plan_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `customer_engineer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Quality Engineer Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `customer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `design_record_complete` SET TAGS ('dbx_business_glossary_term' = 'Design Record Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `design_record_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `deviation_number` SET TAGS ('dbx_business_glossary_term' = 'Deviation / Interim Approval Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Approval Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `fai_complete` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `fai_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `manufacturing_process_description` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Process Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `material_test_results_complete` SET TAGS ('dbx_business_glossary_term' = 'Material and Performance Test Results Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `material_test_results_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `min_cpk_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Process Capability Index - Centered (Cpk) Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `msa_complete` SET TAGS ('dbx_business_glossary_term' = 'Measurement System Analysis (MSA) Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `msa_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Submission Notes');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `open_action_count` SET TAGS ('dbx_business_glossary_term' = 'Open Action Item Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `overall_ppap_completeness_pct` SET TAGS ('dbx_business_glossary_term' = 'Overall Production Part Approval Process (PPAP) Package Completeness Percentage');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `overall_ppap_completeness_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `part_revision_level` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `pfmea_complete` SET TAGS ('dbx_business_glossary_term' = 'Process Failure Mode and Effects Analysis (PFMEA) Complete Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `pfmea_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `production_run_quantity` SET TAGS ('dbx_business_glossary_term' = 'Significant Production Run Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `psw_number` SET TAGS ('dbx_business_glossary_term' = 'Part Submission Warrant (PSW) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `psw_signatory_name` SET TAGS ('dbx_business_glossary_term' = 'Part Submission Warrant (PSW) Signatory Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `psw_signed_date` SET TAGS ('dbx_business_glossary_term' = 'Part Submission Warrant (PSW) Signed Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `psw_signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_review|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `required_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Required Submission Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `required_submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `sample_quantity` SET TAGS ('dbx_business_glossary_term' = 'Sample Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|conditionally_approved|rejected|on_hold|withdrawn|expired');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_level` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_level` SET TAGS ('dbx_value_regex' = '1|2|3|4|5');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_number` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_number` SET TAGS ('dbx_value_regex' = '^PPAP-[A-Z0-9]{4,10}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_reason` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `submission_reason` SET TAGS ('dbx_value_regex' = 'new_part|engineering_change|tooling_change|process_change|supplier_change|material_change|correction_of_discrepancy|annual_revalidation|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `supplier_manufacturing_site` SET TAGS ('dbx_business_glossary_term' = 'Supplier Manufacturing Site');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `supplier_quality_engineer` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Engineer Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` SET TAGS ('dbx_subdomain' = 'product_validation');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_record_id` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Record ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Ppap Submission Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'FAI Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'FAI Approver Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `balloon_drawing_reference` SET TAGS ('dbx_business_glossary_term' = 'Balloon Drawing Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `characteristics_conforming` SET TAGS ('dbx_business_glossary_term' = 'Conforming Characteristics Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `characteristics_conforming` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `characteristics_nonconforming` SET TAGS ('dbx_business_glossary_term' = 'Non-Conforming Characteristics Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `characteristics_nonconforming` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'FAI Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `customer_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `deviation_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Deviation Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'FAI Disposition');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'approved|approved_with_deviation|rejected|interim_approval|pending_review|voided');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `drawing_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Drawing Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `drawing_revision` SET TAGS ('dbx_business_glossary_term' = 'Drawing Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `drawing_revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'FAI Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_number` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_number` SET TAGS ('dbx_value_regex' = '^FAI-[A-Z0-9]{2,10}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_reason` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Initiation Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_reason` SET TAGS ('dbx_value_regex' = 'new_part|design_change|process_change|supplier_change|tooling_change|production_interruption|customer_request|corrective_action');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_type` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_type` SET TAGS ('dbx_value_regex' = 'full|partial|delta|re-fai');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `form1_design_documentation_complete` SET TAGS ('dbx_business_glossary_term' = 'AS9102 Form 1 Design Documentation Complete');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `form1_design_documentation_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `form2_product_accountability_complete` SET TAGS ('dbx_business_glossary_term' = 'AS9102 Form 2 Product Accountability Complete');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `form2_product_accountability_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `form3_characteristic_accountability_complete` SET TAGS ('dbx_business_glossary_term' = 'AS9102 Form 3 Characteristic Accountability Complete');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `form3_characteristic_accountability_complete` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `functional_test_status` SET TAGS ('dbx_business_glossary_term' = 'Functional Test Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `functional_test_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|passed|failed|waived');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'FAI Inspection Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `inspection_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `inspection_standard` SET TAGS ('dbx_business_glossary_term' = 'FAI Inspection Standard');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `inspection_standard` SET TAGS ('dbx_value_regex' = 'AS9102|AIAG_PPAP|ISO_9001|customer_specific|internal');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `inspector_name` SET TAGS ('dbx_business_glossary_term' = 'FAI Inspector Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'FAI Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `material_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Material Certification Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `material_certification_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|received|verified|rejected');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `open_items_count` SET TAGS ('dbx_business_glossary_term' = 'Open FAI Items Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `open_items_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `part_revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = '1|2|3|4|5|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `psw_status` SET TAGS ('dbx_business_glossary_term' = 'Part Submission Warrant (PSW) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `psw_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|submitted|approved|rejected');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|Opcenter_MES|Teamcenter_PLM|manual|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `special_process_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Special Process Approval Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `special_process_approval_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|approved|rejected');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'FAI Record Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_progress|submitted|under_review|approved|rejected|closed|voided');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'FAI Submission Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `total_characteristics` SET TAGS ('dbx_business_glossary_term' = 'Total Inspection Characteristics Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `total_characteristics` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Work Center');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `spc_chart_id` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Chart ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `baseline_established_date` SET TAGS ('dbx_business_glossary_term' = 'SPC Baseline Established Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `baseline_established_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `baseline_sample_count` SET TAGS ('dbx_business_glossary_term' = 'SPC Baseline Sample Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `baseline_sample_count` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `center_line` SET TAGS ('dbx_business_glossary_term' = 'SPC Center Line (Grand Mean / Process Average)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `chart_number` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Chart Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `chart_number` SET TAGS ('dbx_value_regex' = '^SPC-[A-Z0-9]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `chart_type` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `chart_type` SET TAGS ('dbx_value_regex' = 'Xbar-R|Xbar-S|I-MR|p-chart|np-chart|c-chart|u-chart|CUSUM|EWMA');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `control_limit_method` SET TAGS ('dbx_business_glossary_term' = 'Control Limit Calculation Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `control_limit_method` SET TAGS ('dbx_value_regex' = '3-sigma|2-sigma|custom');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `cp_target` SET TAGS ('dbx_business_glossary_term' = 'Process Capability Index Target (Cp Target)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `cp_target` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `cpk_target` SET TAGS ('dbx_business_glossary_term' = 'Process Capability Index Centered Target (Cpk Target)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `cpk_target` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `detection_rule_set` SET TAGS ('dbx_business_glossary_term' = 'SPC Out-of-Control Detection Rule Set');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `detection_rule_set` SET TAGS ('dbx_value_regex' = 'Western Electric|Nelson|AIAG|Custom');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Effective Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `gauge_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Gauge Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `lcl` SET TAGS ('dbx_business_glossary_term' = 'Lower Control Limit (LCL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `lsl` SET TAGS ('dbx_business_glossary_term' = 'Lower Specification Limit (LSL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `msa_required` SET TAGS ('dbx_business_glossary_term' = 'Measurement System Analysis (MSA) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `msa_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `operation_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Operation Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `range_center_line` SET TAGS ('dbx_business_glossary_term' = 'Range / Spread Chart Center Line (R-bar / S-bar)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `range_lcl` SET TAGS ('dbx_business_glossary_term' = 'Range / Spread Chart Lower Control Limit (LCL-R)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `range_ucl` SET TAGS ('dbx_business_glossary_term' = 'Range / Spread Chart Upper Control Limit (UCL-R)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `recalculation_trigger` SET TAGS ('dbx_business_glossary_term' = 'Control Limit Recalculation Trigger');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `recalculation_trigger` SET TAGS ('dbx_value_regex' = 'manual|scheduled|process_change|engineering_change|automatic');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `revision_reason` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Revision Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `sampling_frequency` SET TAGS ('dbx_business_glossary_term' = 'SPC Sampling Frequency');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `sampling_frequency_unit` SET TAGS ('dbx_business_glossary_term' = 'SPC Sampling Frequency Unit');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `sampling_frequency_unit` SET TAGS ('dbx_value_regex' = 'parts|minutes|hours|shifts|days|batches');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `sampling_frequency_value` SET TAGS ('dbx_business_glossary_term' = 'SPC Sampling Frequency Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `sampling_frequency_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `sigma_level` SET TAGS ('dbx_business_glossary_term' = 'Sigma Level Target');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `sigma_level` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|suspended|archived');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `subgroup_size` SET TAGS ('dbx_business_glossary_term' = 'SPC Subgroup Size (n)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `subgroup_size` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `ucl` SET TAGS ('dbx_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `usl` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'SPC Chart Version Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `spc_sample_id` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Sample ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `employee_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge / Measurement Device ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `gauge_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `spc_chart_id` SET TAGS ('dbx_business_glossary_term' = 'Spc Chart Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `batch_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `center_line` SET TAGS ('dbx_business_glossary_term' = 'Control Chart Center Line');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `center_line` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `control_plan_number` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `control_plan_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `cp_index` SET TAGS ('dbx_business_glossary_term' = 'Process Capability Index (Cp)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `cp_index` SET TAGS ('dbx_value_regex' = '^d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `cpk_index` SET TAGS ('dbx_business_glossary_term' = 'Process Capability Index Centered (Cpk)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `cpk_index` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `data_source` SET TAGS ('dbx_business_glossary_term' = 'Data Source');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `data_source` SET TAGS ('dbx_value_regex' = 'MANUAL|AUTOMATED_GAUGE|MES|SCADA|IIoT_SENSOR');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `lower_control_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Control Limit (LCL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `lower_control_limit` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Specification Limit (LSL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `measured_value` SET TAGS ('dbx_business_glossary_term' = 'Measured Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `measured_value` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `operation_number` SET TAGS ('dbx_business_glossary_term' = 'Operation Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `operation_number` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `out_of_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Out-of-Control Signal Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `out_of_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sample_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Sample Sequence Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sample_sequence_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sample_status` SET TAGS ('dbx_business_glossary_term' = 'Sample Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sample_status` SET TAGS ('dbx_value_regex' = 'COLLECTED|VALIDATED|REJECTED|VOIDED');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sample_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Sample Collection Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sample_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sampling_frequency_code` SET TAGS ('dbx_business_glossary_term' = 'Sampling Frequency Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `sampling_frequency_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `shift_code` SET TAGS ('dbx_business_glossary_term' = 'Production Shift Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `shift_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `spec_violation_flag` SET TAGS ('dbx_business_glossary_term' = 'Specification Violation Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `spec_violation_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_mean` SET TAGS ('dbx_business_glossary_term' = 'Subgroup Mean (X-bar)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_mean` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_number` SET TAGS ('dbx_business_glossary_term' = 'Subgroup Identifier');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_range` SET TAGS ('dbx_business_glossary_term' = 'Subgroup Range (R)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_range` SET TAGS ('dbx_value_regex' = '^d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_size` SET TAGS ('dbx_business_glossary_term' = 'Subgroup Sample Size');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_size` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_std_dev` SET TAGS ('dbx_business_glossary_term' = 'Subgroup Standard Deviation (S)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `subgroup_std_dev` SET TAGS ('dbx_value_regex' = '^d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[a-zA-Z%°/]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `upper_control_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `upper_control_limit` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_value_regex' = '^-?d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `void_reason` SET TAGS ('dbx_business_glossary_term' = 'Sample Void Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `we_rule_violated` SET TAGS ('dbx_business_glossary_term' = 'Western Electric (WE) Rule Violated');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `we_rule_violated` SET TAGS ('dbx_value_regex' = 'NONE|WE1|WE2|WE3|WE4|WE5|WE6|WE7|WE8|MULTIPLE');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `work_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `zone_classification` SET TAGS ('dbx_business_glossary_term' = 'Western Electric Zone Classification');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `zone_classification` SET TAGS ('dbx_value_regex' = 'A|B|C|IN_CONTROL');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` SET TAGS ('dbx_original_name' = 'quality_audit');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Employee ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Audit End Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Audit Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `auditee_name` SET TAGS ('dbx_business_glossary_term' = 'Auditee Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `capa_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `capa_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'internal|external|third_party');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `certification_body` SET TAGS ('dbx_business_glossary_term' = 'Certification Body Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `certification_standard_version` SET TAGS ('dbx_business_glossary_term' = 'Certification Standard Version');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Audited Department Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `finding_summary` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Summary');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Audit Frequency');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|biennial|ad_hoc');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `lead_auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `major_nc_count` SET TAGS ('dbx_business_glossary_term' = 'Major Nonconformance (NC) Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `major_nc_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `minor_nc_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Nonconformance (NC) Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `minor_nc_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `next_audit_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `next_audit_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^QA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `objective` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Objective');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `observation_count` SET TAGS ('dbx_business_glossary_term' = 'Audit Observation Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `observation_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `open_findings_count` SET TAGS ('dbx_business_glossary_term' = 'Open Audit Findings Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `open_findings_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `overall_result` SET TAGS ('dbx_business_glossary_term' = 'Overall Audit Result');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `overall_result` SET TAGS ('dbx_value_regex' = 'conforming|minor_nonconformance|major_nonconformance|observation_only|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `process_area` SET TAGS ('dbx_business_glossary_term' = 'Audited Process Area');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `program_reference` SET TAGS ('dbx_business_glossary_term' = 'Audit Program Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `report_issued_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Report Issued Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `report_issued_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `risk_based_priority` SET TAGS ('dbx_business_glossary_term' = 'Risk-Based Audit Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `risk_based_priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `scheduled_end_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Audit End Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `scheduled_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `scheduled_start_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Audit Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `scheduled_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Scope');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `site_name` SET TAGS ('dbx_business_glossary_term' = 'Audit Site Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `standard` SET TAGS ('dbx_business_glossary_term' = 'Audit Standard / Criteria Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|on_hold|closed');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `team_members` SET TAGS ('dbx_business_glossary_term' = 'Audit Team Members');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `total_findings_count` SET TAGS ('dbx_business_glossary_term' = 'Total Audit Findings Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `total_findings_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'system|process|product|supplier|customer|regulatory|combined');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `quality_audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Auditor Employee ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `owner_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Finding Owner Employee ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `audit_scope` SET TAGS ('dbx_business_glossary_term' = 'Audit Scope');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `audit_type` SET TAGS ('dbx_business_glossary_term' = 'Audit Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'internal|external|supplier|customer|regulatory|certification|surveillance|process|product|system');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `auditee_name` SET TAGS ('dbx_business_glossary_term' = 'Auditee Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Auditor Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `capa_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `capa_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `closure_verification_method` SET TAGS ('dbx_business_glossary_term' = 'Closure Verification Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `closure_verification_method` SET TAGS ('dbx_value_regex' = 're_audit|document_review|process_observation|measurement_verification|management_review');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `closure_verified_by` SET TAGS ('dbx_business_glossary_term' = 'Closure Verified By');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `evidence_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Evidence Document Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `finding_description` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `finding_number` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `finding_number` SET TAGS ('dbx_value_regex' = '^AF-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `finding_title` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `finding_type` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `finding_type` SET TAGS ('dbx_value_regex' = 'nonconformity|major_nonconformity|minor_nonconformity|observation|opportunity_for_improvement|positive_finding');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `iso_clause_reference` SET TAGS ('dbx_business_glossary_term' = 'ISO Clause Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `objective_evidence` SET TAGS ('dbx_business_glossary_term' = 'Objective Evidence');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Finding Owner Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `process_area` SET TAGS ('dbx_business_glossary_term' = 'Process Area');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `raised_date` SET TAGS ('dbx_business_glossary_term' = 'Finding Raised Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `raised_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `regulatory_impact` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Impact Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `regulatory_impact` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `repeat_finding_reference` SET TAGS ('dbx_business_glossary_term' = 'Repeat Finding Reference Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `requirement_reference` SET TAGS ('dbx_business_glossary_term' = 'Requirement Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `response_due_date` SET TAGS ('dbx_business_glossary_term' = 'Response Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `response_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Finding Severity');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|major|minor|informational');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|under_review|response_submitted|capa_in_progress|pending_verification|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Target Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` SET TAGS ('dbx_subdomain' = 'product_validation');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `apqp_project_id` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Project ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `apqp_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Apqp Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `it_project_id` SET TAGS ('dbx_business_glossary_term' = 'It Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `actual_launch_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Production Launch Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `actual_launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_required');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `current_phase` SET TAGS ('dbx_business_glossary_term' = 'APQP Current Phase');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `current_phase` SET TAGS ('dbx_value_regex' = 'phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_validation|phase_5_production_launch|completed');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `customer_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Approval Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `customer_approval_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|submitted|approved|conditionally_approved|rejected');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `customer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `deliverables_completed` SET TAGS ('dbx_business_glossary_term' = 'Completed APQP Deliverables Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `deliverables_total` SET TAGS ('dbx_business_glossary_term' = 'Total APQP Deliverables Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `dfmea_status` SET TAGS ('dbx_business_glossary_term' = 'Design Failure Mode and Effects Analysis (DFMEA) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `dfmea_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_required');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `fai_required` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `fai_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `fai_status` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `fai_status` SET TAGS ('dbx_value_regex' = 'not_required|not_started|in_progress|completed_pass|completed_fail|waived');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `open_issues_count` SET TAGS ('dbx_business_glossary_term' = 'Open Issues Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `pfmea_status` SET TAGS ('dbx_business_glossary_term' = 'Process Failure Mode and Effects Analysis (PFMEA) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `pfmea_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_required');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `phase_gate_status` SET TAGS ('dbx_business_glossary_term' = 'APQP Phase Gate Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `phase_gate_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|gate_review_pending|gate_approved|gate_rejected|waived');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = '1|2|3|4|5');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_status` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_status` SET TAGS ('dbx_value_regex' = 'not_required|not_started|in_preparation|submitted|approved|conditionally_approved|rejected|resubmission_required');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `ppap_submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'APQP Project Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `program_manager` SET TAGS ('dbx_business_glossary_term' = 'APQP Program Manager');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `project_number` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Project Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `project_number` SET TAGS ('dbx_value_regex' = '^APQP-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `project_start_date` SET TAGS ('dbx_business_glossary_term' = 'APQP Project Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `project_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `project_type` SET TAGS ('dbx_business_glossary_term' = 'APQP Project Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `project_type` SET TAGS ('dbx_value_regex' = 'new_product|product_revision|process_change|supplier_change|regulatory_change|platform_extension');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `quality_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Quality Engineer');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'APQP Project Risk Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) / Registration Evaluation Authorization and Restriction of Chemicals (REACH) Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'APQP Project Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|on_hold|gate_review|customer_approval_pending|completed|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `target_launch_date` SET TAGS ('dbx_business_glossary_term' = 'Target Production Launch Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ALTER COLUMN `target_launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` SET TAGS ('dbx_subdomain' = 'product_validation');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `apqp_deliverable_id` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Deliverable ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `apqp_project_id` SET TAGS ('dbx_business_glossary_term' = 'Apqp Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Deliverable Approval Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|conditionally_approved|approved|rejected|not_required');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_plan_and_define|phase_2_product_design_and_development|phase_3_process_design_and_development|phase_4_product_and_process_validation|phase_5_feedback_assessment_and_corrective_action');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Deliverable Comments');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `completion_percentage` SET TAGS ('dbx_business_glossary_term' = 'Completion Percentage');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `completion_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `customer_approval_required` SET TAGS ('dbx_business_glossary_term' = 'Customer Approval Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `customer_approval_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `customer_approved_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Approved Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `customer_approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `customer_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `deliverable_name` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Deliverable Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `deliverable_number` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Deliverable Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `deliverable_number` SET TAGS ('dbx_value_regex' = '^APQP-DLV-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `deliverable_type` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Deliverable Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `deliverable_type` SET TAGS ('dbx_value_regex' = 'design_fmea|process_fmea|process_flow_diagram|control_plan|msa_study|capability_study|measurement_system_analysis|design_verification_plan|prototype_build_control_plan|pre_launch_control_plan|production_control_plan|first_article_inspection|ppap_s...');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `document_version` SET TAGS ('dbx_business_glossary_term' = 'Document Version');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `gate_review_required` SET TAGS ('dbx_business_glossary_term' = 'Gate Review Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `gate_review_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `open_issues_count` SET TAGS ('dbx_business_glossary_term' = 'Open Issues Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `open_issues_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `ppap_element_number` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Element Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|level_4|level_5|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Deliverable Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `responsible_owner` SET TAGS ('dbx_business_glossary_term' = 'Responsible Owner');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `revised_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Revised Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `revised_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Deliverable Risk Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'high|medium|low|not_assessed');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Deliverable Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|pending_review|approved|rejected|on_hold|cancelled|overdue');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_deliverable` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `applicable_industry_sector` SET TAGS ('dbx_business_glossary_term' = 'Applicable Industry Sector');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `applicable_material_type` SET TAGS ('dbx_business_glossary_term' = 'Applicable Material Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `applicable_material_type` SET TAGS ('dbx_value_regex' = 'raw_material|semi-finished|finished_good|purchased_component|all');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `aql_level` SET TAGS ('dbx_business_glossary_term' = 'Acceptable Quality Level (AQL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `aql_level` SET TAGS ('dbx_value_regex' = '0.065|0.10|0.15|0.25|0.40|0.65|1.0|1.5|2.5|4.0|6.5|10.0');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `capa_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `capa_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `catalog_code_group` SET TAGS ('dbx_business_glossary_term' = 'Quality Management (QM) Catalog Code Group');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `catalog_code_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `catalog_type` SET TAGS ('dbx_business_glossary_term' = 'Quality Catalog Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `catalog_type` SET TAGS ('dbx_value_regex' = 'defect_type|defect_cause|defect_location|defect_action');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'dimensional|surface|functional|material|assembly|electrical|cosmetic|documentation|packaging|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Defect Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `customer_standard_reference` SET TAGS ('dbx_business_glossary_term' = 'Customer Standard Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `default_disposition` SET TAGS ('dbx_business_glossary_term' = 'Default Defect Disposition');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `default_disposition` SET TAGS ('dbx_value_regex' = 'scrap|rework|use_as_is|return_to_supplier|sort|reinspect|pending_review');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `default_severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Default Failure Mode and Effects Analysis (FMEA) Severity Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `default_severity_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `defect_class` SET TAGS ('dbx_business_glossary_term' = 'Defect Class');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `defect_class` SET TAGS ('dbx_value_regex' = 'critical|major|minor|incidental');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `defect_family` SET TAGS ('dbx_business_glossary_term' = 'Defect Family');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `detection_method` SET TAGS ('dbx_business_glossary_term' = 'Defect Detection Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `detection_method` SET TAGS ('dbx_value_regex' = 'visual|dimensional|functional|destructive|non-destructive|automated|spc|gauge|cmm|x-ray|ultrasonic|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `external_code_mapping` SET TAGS ('dbx_business_glossary_term' = 'External Defect Code Mapping');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `iso_standard_reference` SET TAGS ('dbx_business_glossary_term' = 'ISO Standard Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `long_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Long Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `ncr_auto_create` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Auto-Create Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `ncr_auto_create` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `plant_applicability` SET TAGS ('dbx_business_glossary_term' = 'Plant Applicability');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `ppap_relevant` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `ppap_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `ppm_threshold` SET TAGS ('dbx_business_glossary_term' = 'Parts Per Million (PPM) Defect Threshold');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `ppm_threshold` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `process_stage` SET TAGS ('dbx_business_glossary_term' = 'Applicable Process Stage');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `process_stage` SET TAGS ('dbx_value_regex' = 'incoming|in-process|final|outgoing|field|supplier|design|assembly|machining|welding|painting|testing|packaging|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reportable Defect Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `rework_cost_category` SET TAGS ('dbx_business_glossary_term' = 'Rework Cost Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `rework_cost_category` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `rohs_reach_relevant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) / Registration Evaluation Authorization and Restriction of Chemicals (REACH) Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `rohs_reach_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `safety_critical` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Defect Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `safety_critical` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `short_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Short Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|OPCENTER_MES|TEAMCENTER_PLM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `spc_applicable` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `spc_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|obsolete|under_review');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` SET TAGS ('dbx_original_name' = 'quality_characteristic');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `aql_level` SET TAGS ('dbx_business_glossary_term' = 'Acceptable Quality Level (AQL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `aql_level` SET TAGS ('dbx_value_regex' = '0.065|0.10|0.15|0.25|0.40|0.65|1.0|1.5|2.5|4.0|6.5|10.0');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'variable|attribute');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `classification` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Classification');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `classification` SET TAGS ('dbx_value_regex' = 'critical|major|minor|informational');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `cp_minimum_required` SET TAGS ('dbx_business_glossary_term' = 'Minimum Required Process Capability Index (Cp)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `cp_minimum_required` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}.[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `cpk_minimum_required` SET TAGS ('dbx_business_glossary_term' = 'Minimum Required Process Capability Index (Cpk)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `cpk_minimum_required` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}.[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `ctq_flag` SET TAGS ('dbx_business_glossary_term' = 'Critical to Quality (CTQ) Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `ctq_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `decimal_places` SET TAGS ('dbx_business_glossary_term' = 'Decimal Places');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `decimal_places` SET TAGS ('dbx_value_regex' = '^[0-9]$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `destructive_test` SET TAGS ('dbx_business_glossary_term' = 'Destructive Test Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `destructive_test` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `drawing_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Drawing Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `drawing_revision` SET TAGS ('dbx_business_glossary_term' = 'Engineering Drawing Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `drawing_revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `gauge_type` SET TAGS ('dbx_business_glossary_term' = 'Gauge Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `gauge_type` SET TAGS ('dbx_value_regex' = 'caliper|micrometer|cmm|go_no_go_gauge|optical_comparator|profilometer|hardness_tester|tensile_tester|spectrometer|vision_system|torque_wrench|pressure_gauge|thermometer|multimeter|coordinate_measuring_machine|laser_scanner|ultrasonic_tester|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `group` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Group');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `lower_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Specification Limit (LSL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `lower_tolerance` SET TAGS ('dbx_business_glossary_term' = 'Lower Tolerance');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `nominal_value` SET TAGS ('dbx_business_glossary_term' = 'Nominal Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `regulatory_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Characteristic Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `regulatory_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Critical Characteristic Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `safety_critical_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `sampling_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Sampling Procedure Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `short_description` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Short Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `skip_lot_eligible` SET TAGS ('dbx_business_glossary_term' = 'Skip Lot Inspection Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `skip_lot_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|TEAMCENTER|OPCENTER|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `spc_chart_type` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Chart Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `spc_chart_type` SET TAGS ('dbx_value_regex' = 'xbar_r|xbar_s|individuals_mr|p_chart|np_chart|c_chart|u_chart|cusum|ewma');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `spc_enabled` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `spc_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|obsolete|under_review');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'dimensional|functional|visual|material|electrical|chemical|mechanical|thermal|geometric|surface');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'mm|cm|m|in|ft|kg|g|lb|N|Nm|MPa|GPa|bar|psi|°C|°F|K|V|A|Ω|Hz|%|ppm|μm|Ra|Rz|HRC|HB|HV|mm²|cm³|L|mL|lux|dB|');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `upper_tolerance` SET TAGS ('dbx_business_glossary_term' = 'Upper Tolerance');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `asset_register_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Register Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `it_asset_id` SET TAGS ('dbx_business_glossary_term' = 'It Asset Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `accuracy` SET TAGS ('dbx_business_glossary_term' = 'Gauge Accuracy');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `asset_tag_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Tag Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `assigned_location` SET TAGS ('dbx_business_glossary_term' = 'Assigned Location');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Certificate Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Interval (Days)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_lab_accreditation_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Laboratory Accreditation Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_lab_name` SET TAGS ('dbx_business_glossary_term' = 'Calibration Laboratory Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_status` SET TAGS ('dbx_business_glossary_term' = 'Calibration Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_status` SET TAGS ('dbx_value_regex' = 'calibrated|overdue|out_of_service|in_calibration|retired|lost');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_type` SET TAGS ('dbx_business_glossary_term' = 'Calibration Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `calibration_type` SET TAGS ('dbx_value_regex' = 'internal|external|on_site');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Gauge Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `is_reference_standard` SET TAGS ('dbx_business_glossary_term' = 'Reference Standard Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `is_reference_standard` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `last_msa_date` SET TAGS ('dbx_business_glossary_term' = 'Last Measurement System Analysis (MSA) Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `last_msa_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Gauge Manufacturer');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `measurement_range_max` SET TAGS ('dbx_business_glossary_term' = 'Measurement Range Maximum');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `measurement_range_min` SET TAGS ('dbx_business_glossary_term' = 'Measurement Range Minimum');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Gauge Model Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `msa_required` SET TAGS ('dbx_business_glossary_term' = 'Measurement System Analysis (MSA) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `msa_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Gauge Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `out_of_tolerance_action` SET TAGS ('dbx_business_glossary_term' = 'Out-of-Tolerance Action');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `out_of_tolerance_action` SET TAGS ('dbx_value_regex' = 'repair|replace|adjust|retire|escalate|use_as_is_with_restriction');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `purchase_cost` SET TAGS ('dbx_business_glossary_term' = 'Purchase Cost');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `purchase_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `purchase_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `recall_required` SET TAGS ('dbx_business_glossary_term' = 'Measurement Recall Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `recall_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `resolution` SET TAGS ('dbx_business_glossary_term' = 'Gauge Resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `responsible_person` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `rr_percent` SET TAGS ('dbx_business_glossary_term' = 'Gauge Repeatability and Reproducibility (Gauge R&R) Percentage');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `rr_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|Maximo|Manual|MindSphere|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Gauge Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|lost|scrapped|on_loan');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `traceability_standard` SET TAGS ('dbx_business_glossary_term' = 'Traceability Standard');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Gauge Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'CMM|caliper|micrometer|go_no_go|torque_wrench|height_gauge|dial_indicator|bore_gauge|surface_roughness_tester|hardness_tester|optical_comparator|force_gauge|pressure_gauge|thermometer|multimeter|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'mm|cm|m|in|ft|kg|g|lb|N|Nm|Pa|bar|psi|°C|°F|K|V|A|Ohm|Hz|rpm|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `gauge_calibration_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge Calibration ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Calibrated By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_record_id` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `adjustment_description` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `adjustment_performed` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Performed Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `adjustment_performed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `as_found_condition` SET TAGS ('dbx_business_glossary_term' = 'As-Found Condition');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `as_found_condition` SET TAGS ('dbx_value_regex' = 'in_tolerance|out_of_tolerance|damaged|unknown');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `as_found_value` SET TAGS ('dbx_business_glossary_term' = 'As-Found Measurement Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `as_left_condition` SET TAGS ('dbx_business_glossary_term' = 'As-Left Condition');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `as_left_condition` SET TAGS ('dbx_value_regex' = 'in_tolerance|out_of_tolerance|adjusted|repaired|condemned');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `as_left_value` SET TAGS ('dbx_business_glossary_term' = 'As-Left Measurement Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_event_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Event Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_event_number` SET TAGS ('dbx_value_regex' = '^CAL-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Interval (Days)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_lab_name` SET TAGS ('dbx_business_glossary_term' = 'Calibration Laboratory Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_lab_type` SET TAGS ('dbx_business_glossary_term' = 'Calibration Laboratory Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_lab_type` SET TAGS ('dbx_value_regex' = 'internal|external');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_procedure_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Procedure Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_result` SET TAGS ('dbx_business_glossary_term' = 'Calibration Result');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|void');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_standard_used` SET TAGS ('dbx_business_glossary_term' = 'Calibration Standard Used');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Calibration Certificate Issue Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `certificate_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Certificate Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Calibration Comments');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `lab_accreditation_number` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Accreditation Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Gauge Manufacturer');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `measurement_uncertainty` SET TAGS ('dbx_business_glossary_term' = 'Measurement Uncertainty');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Gauge Model Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `msa_study_reference` SET TAGS ('dbx_business_glossary_term' = 'Measurement System Analysis (MSA) Study Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `out_of_service_flag` SET TAGS ('dbx_business_glossary_term' = 'Out of Service Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `out_of_service_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `recall_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Measurement Recall Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `recall_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `reviewed_by` SET TAGS ('dbx_business_glossary_term' = 'Reviewed By');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|Maximo_EAM|Manual|MindSphere|Other');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `standard_traceability_reference` SET TAGS ('dbx_business_glossary_term' = 'Standard Traceability Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Gauge Calibration Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|overdue|withdrawn|expired|in_calibration|condemned');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `tolerance_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Lower Limit');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `tolerance_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Upper Limit');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `msa_study_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement System Analysis (MSA) Study ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Analyst Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge Identifier');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Ppap Submission Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `acceptability_decision` SET TAGS ('dbx_business_glossary_term' = 'MSA Acceptability Decision');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `acceptability_decision` SET TAGS ('dbx_value_regex' = 'acceptable|conditionally_acceptable|unacceptable|requires_improvement');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `analysis_method` SET TAGS ('dbx_business_glossary_term' = 'MSA Analysis Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `analysis_method` SET TAGS ('dbx_value_regex' = 'average_range|anova|range_method');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `bias_percent` SET TAGS ('dbx_business_glossary_term' = 'Bias Percentage');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `bias_value` SET TAGS ('dbx_business_glossary_term' = 'Bias Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `conducted_by` SET TAGS ('dbx_business_glossary_term' = 'Study Conducted By');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `confidence_level_percent` SET TAGS ('dbx_business_glossary_term' = 'Statistical Confidence Level Percentage');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `confidence_level_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'MSA Study Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `gauge_name` SET TAGS ('dbx_business_glossary_term' = 'Gauge Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `grr_basis` SET TAGS ('dbx_business_glossary_term' = '%GRR Calculation Basis');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `grr_basis` SET TAGS ('dbx_value_regex' = 'study_variation|tolerance');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `grr_percent` SET TAGS ('dbx_business_glossary_term' = 'Gauge Repeatability and Reproducibility Percentage (%GRR)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `grr_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `linearity_value` SET TAGS ('dbx_business_glossary_term' = 'Linearity Value');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `ndc` SET TAGS ('dbx_business_glossary_term' = 'Number of Distinct Categories (ndc)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `ndc` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `number_of_appraisers` SET TAGS ('dbx_business_glossary_term' = 'Number of Appraisers');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `number_of_appraisers` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `number_of_parts` SET TAGS ('dbx_business_glossary_term' = 'Number of Parts');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `number_of_parts` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `number_of_replicates` SET TAGS ('dbx_business_glossary_term' = 'Number of Replicates (Trials)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `number_of_replicates` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `part_revision_level` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `part_variation_percent` SET TAGS ('dbx_business_glossary_term' = 'Part Variation Percentage (%PV)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `part_variation_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `process_step` SET TAGS ('dbx_business_glossary_term' = 'Process Step');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `repeatability_percent` SET TAGS ('dbx_business_glossary_term' = 'Repeatability Percentage (Equipment Variation %EV)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `repeatability_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `reproducibility_percent` SET TAGS ('dbx_business_glossary_term' = 'Reproducibility Percentage (Appraiser Variation %AV)');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `reproducibility_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,3})?|[0-9]{1,2}(.[0-9]{1,3})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `restudy_reason` SET TAGS ('dbx_business_glossary_term' = 'Re-Study Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `restudy_reason` SET TAGS ('dbx_value_regex' = 'unacceptable_grr|gauge_modified|process_change|study_expired|customer_request|periodic_revalidation|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `restudy_required` SET TAGS ('dbx_business_glossary_term' = 'Re-Study Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `restudy_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|Opcenter_MES|Minitab|JMP|manual|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `stability_range` SET TAGS ('dbx_business_glossary_term' = 'Stability Range');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'MSA Study Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_progress|completed|approved|rejected|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `study_date` SET TAGS ('dbx_business_glossary_term' = 'MSA Study Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `study_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `study_number` SET TAGS ('dbx_business_glossary_term' = 'MSA Study Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `study_number` SET TAGS ('dbx_value_regex' = '^MSA-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `study_type` SET TAGS ('dbx_business_glossary_term' = 'MSA Study Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `study_type` SET TAGS ('dbx_value_regex' = 'gauge_r_and_r|linearity|bias|stability|attribute_agreement|destructive_r_and_r');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'MSA Study Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `tolerance` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Tolerance');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `total_observations` SET TAGS ('dbx_business_glossary_term' = 'Total Observations');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `total_observations` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `scrap_rework_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Scrap Rework Transaction ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `credit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `defect_location` SET TAGS ('dbx_business_glossary_term' = 'Defect Location');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `detection_stage` SET TAGS ('dbx_business_glossary_term' = 'Detection Stage');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `detection_stage` SET TAGS ('dbx_value_regex' = 'incoming_inspection|in_process|final_inspection|customer_return|field|audit');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Disposition');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'scrap|rework|repair|use_as_is|return_to_supplier|downgrade|pending');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `disposition_justification` SET TAGS ('dbx_business_glossary_term' = 'Disposition Justification');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `operation_description` SET TAGS ('dbx_business_glossary_term' = 'Operation Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `operation_number` SET TAGS ('dbx_business_glossary_term' = 'Operation Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `part_description` SET TAGS ('dbx_business_glossary_term' = 'Part Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number (Material Number)');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `quantity_affected` SET TAGS ('dbx_business_glossary_term' = 'Quantity Affected');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `quantity_affected` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `quantity_reworked` SET TAGS ('dbx_business_glossary_term' = 'Quantity Reworked');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `quantity_reworked` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `quantity_scrapped` SET TAGS ('dbx_business_glossary_term' = 'Quantity Scrapped');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `quantity_scrapped` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `reported_by` SET TAGS ('dbx_business_glossary_term' = 'Reported By');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Rework Completed Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_completed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_cost` SET TAGS ('dbx_business_glossary_term' = 'Rework Cost');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Rework Labor Hours');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_labor_hours` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_passed_inspection` SET TAGS ('dbx_business_glossary_term' = 'Rework Passed Inspection Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `rework_passed_inspection` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'machine|method|material|man|measurement|environment|design|supplier|unknown');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `scrap_cost` SET TAGS ('dbx_business_glossary_term' = 'Scrap Cost');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `scrap_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `scrap_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `shift_code` SET TAGS ('dbx_business_glossary_term' = 'Shift Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|OPCENTER_MES|MANUAL|MAXIMO|OTHER');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|completed|cancelled|pending_approval');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_date` SET TAGS ('dbx_business_glossary_term' = 'Transaction Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Scrap/Rework Transaction Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_value_regex' = '^SR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Transaction Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Transaction Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'scrap|rework|repair|downgrade|return_to_supplier');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|M|M2|M3|L|PC|SET|BOX|FT|LB');
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_quality_event_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Event ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `logistics_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `third_party_risk_id` SET TAGS ('dbx_business_glossary_term' = 'Third Party Risk Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `chargeback_flag` SET TAGS ('dbx_business_glossary_term' = 'Supplier Chargeback Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `chargeback_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `containment_action` SET TAGS ('dbx_business_glossary_term' = 'Containment Action');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `containment_status` SET TAGS ('dbx_business_glossary_term' = 'Containment Action Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `containment_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|verified');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `defect_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `defect_category` SET TAGS ('dbx_value_regex' = 'dimensional|material|functional|cosmetic|labeling|packaging|documentation|contamination|mixed_parts|wrong_part');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `detection_date` SET TAGS ('dbx_business_glossary_term' = 'Detection Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `detection_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `detection_stage` SET TAGS ('dbx_business_glossary_term' = 'Detection Stage');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `detection_stage` SET TAGS ('dbx_value_regex' = 'incoming_inspection|dock_audit|production_line|assembly|final_inspection|field_return|customer_complaint');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Material Disposition');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'return_to_supplier|scrap|rework|use_as_is|sort_and_use|conditional_release|pending');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `eight_d_submission_date` SET TAGS ('dbx_business_glossary_term' = '8D Report Submission Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `eight_d_submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `eight_d_submission_status` SET TAGS ('dbx_business_glossary_term' = '8D Report Submission Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `eight_d_submission_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|submitted|accepted|rejected|overdue');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `event_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Event Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `event_number` SET TAGS ('dbx_value_regex' = '^SQE-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Event Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'incoming_inspection_failure|supplier_ncr|scar|8d_response|field_return|audit_finding|dock_rejection|concession_request');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `nonconformance_cost` SET TAGS ('dbx_business_glossary_term' = 'Nonconformance Cost');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `nonconformance_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `nonconforming_quantity` SET TAGS ('dbx_business_glossary_term' = 'Nonconforming Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `part_revision_level` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `ppm_impact` SET TAGS ('dbx_business_glossary_term' = 'Parts Per Million (PPM) Impact');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|M|M2|M3|L|PC|SET|BOX|ROLL');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `regulatory_reportable_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reportable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `regulatory_reportable_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `responsible_sqe` SET TAGS ('dbx_business_glossary_term' = 'Responsible Supplier Quality Engineer (SQE)');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `scar_issued_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Corrective Action Request (SCAR) Issued Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `scar_issued_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `scar_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Corrective Action Request (SCAR) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `scar_number` SET TAGS ('dbx_value_regex' = '^SCAR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `scar_response_due_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Corrective Action Request (SCAR) Response Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `scar_response_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Event Severity');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|major|minor|observation');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|SAP_MM|ARIBA|TEAMCENTER|MANUAL');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Event Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|under_review|containment_active|8d_submitted|8d_accepted|8d_rejected|capa_in_progress|closed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_manufacturing_site` SET TAGS ('dbx_business_glossary_term' = 'Supplier Manufacturing Site');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_rating_impact` SET TAGS ('dbx_business_glossary_term' = 'Supplier Rating Impact');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `supplier_rating_impact` SET TAGS ('dbx_value_regex' = 'no_impact|minor_deduction|major_deduction|probation_triggered|suspension_triggered');
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ALTER COLUMN `total_received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Received Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `customer_complaint_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Complaint ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `incident_id` SET TAGS ('dbx_business_glossary_term' = 'Related Incident Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Affected Production Batch Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `complaint_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Complaint Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `complaint_number` SET TAGS ('dbx_value_regex' = '^CC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `complaint_type` SET TAGS ('dbx_business_glossary_term' = 'Complaint Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `complaint_type` SET TAGS ('dbx_value_regex' = 'field_failure|warranty_claim|oem_partner_complaint|safety_concern|regulatory_complaint|delivery_quality|cosmetic_defect|functional_defect|documentation_error|labeling_error');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `containment_action` SET TAGS ('dbx_business_glossary_term' = 'Containment Action (8D D3)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `containment_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Containment Action Completion Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `customer_approved_closure` SET TAGS ('dbx_business_glossary_term' = 'Customer Approved Closure Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `customer_approved_closure` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `customer_satisfaction_rating` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `customer_satisfaction_rating` SET TAGS ('dbx_value_regex' = 'very_satisfied|satisfied|neutral|dissatisfied|very_dissatisfied|not_rated');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `defect_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `defect_category` SET TAGS ('dbx_value_regex' = 'functional|dimensional|cosmetic|material|electrical|software|documentation|packaging|labeling|safety');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `eight_d_status` SET TAGS ('dbx_business_glossary_term' = '8D Problem-Solving Workflow Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `eight_d_status` SET TAGS ('dbx_value_regex' = 'not_started|D1_team_formed|D2_problem_described|D3_containment_active|D4_root_cause_identified|D5_corrective_actions_defined|D6_corrective_actions_implemented|D7_preventive_actions_defined|D8_closed');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `failure_date` SET TAGS ('dbx_business_glossary_term' = 'Failure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `failure_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Amount');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Affected Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Complaint Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `quantity_complained` SET TAGS ('dbx_business_glossary_term' = 'Quantity Complained');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|M|M2|M3|L|SET|LOT');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `received_date` SET TAGS ('dbx_business_glossary_term' = 'Complaint Received Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reportable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Quality Engineer');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'design|process|material|supplier|human_error|tooling|measurement|environment|software|unknown');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `safety_related` SET TAGS ('dbx_business_glossary_term' = 'Safety-Related Complaint Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `safety_related` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Affected Product Serial Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `source_channel` SET TAGS ('dbx_business_glossary_term' = 'Complaint Source Channel');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `source_channel` SET TAGS ('dbx_value_regex' = 'customer_portal|email|phone|field_service|sales_rep|oem_partner|regulatory_body|social_media|warranty_system');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|Salesforce_CRM|MindSphere|Manual|Opcenter_MES|Customer_Portal');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Complaint Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|containment_active|root_cause_analysis|corrective_action|pending_customer_approval|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Target Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Complaint Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `warranty_status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `warranty_status` SET TAGS ('dbx_value_regex' = 'in_warranty|out_of_warranty|warranty_disputed|goodwill|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` SET TAGS ('dbx_subdomain' = 'issue_resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` SET TAGS ('dbx_original_name' = 'quality_notification');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `quality_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `quality_capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `capa_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `capa_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `containment_action` SET TAGS ('dbx_business_glossary_term' = 'Containment Action');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `defect_category` SET TAGS ('dbx_business_glossary_term' = 'Defect Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `detection_stage` SET TAGS ('dbx_business_glossary_term' = 'Defect Detection Stage');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `detection_stage` SET TAGS ('dbx_value_regex' = 'Incoming Inspection|In-Process|Final Inspection|Customer|Field|Audit|Supplier');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `nonconforming_quantity` SET TAGS ('dbx_business_glossary_term' = 'Nonconforming Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[0-9]{10,12}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = '1|2|3|4');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `priority_description` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Priority Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `priority_description` SET TAGS ('dbx_value_regex' = 'Very High|High|Medium|Low');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reportable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `regulatory_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `reported_by` SET TAGS ('dbx_business_glossary_term' = 'Reported By');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `reported_by_department` SET TAGS ('dbx_business_glossary_term' = 'Reported By Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `required_end_date` SET TAGS ('dbx_business_glossary_term' = 'Required End Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `required_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `required_start_date` SET TAGS ('dbx_business_glossary_term' = 'Required Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `required_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `responsible_person` SET TAGS ('dbx_business_glossary_term' = 'Responsible Person');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|SALESFORCE_CRM|OPCENTER_MES|MANUAL');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'OSNO|NOPR|NOCO|NOPT|CLSD|DLFL');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|F1|F2|S1|S2');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `type_description` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Type Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `vendor_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` SET TAGS ('dbx_original_name' = 'quality_certificate');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Certificate ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `applicable_standards` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standards');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Certificate Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `authorized_signatory_name` SET TAGS ('dbx_business_glossary_term' = 'Authorized Signatory Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `authorized_signatory_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `authorized_signatory_title` SET TAGS ('dbx_business_glossary_term' = 'Authorized Signatory Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch / Lot Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `batch_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `ce_marking_applicable` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `ce_marking_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `customer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `customer_specific_requirements` SET TAGS ('dbx_business_glossary_term' = 'Customer-Specific Certificate Requirements');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `deviation_number` SET TAGS ('dbx_business_glossary_term' = 'Deviation / Waiver Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `document_storage_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Storage Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `issuing_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `issuing_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `issuing_plant_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Plant Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,40}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `overall_conformance_result` SET TAGS ('dbx_business_glossary_term' = 'Overall Conformance Result');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `overall_conformance_result` SET TAGS ('dbx_value_regex' = 'Conforming|Non_Conforming|Conditionally_Conforming');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `part_revision` SET TAGS ('dbx_value_regex' = '^[A-Z0-9.]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `production_order_number` SET TAGS ('dbx_business_glossary_term' = 'Production Order Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `production_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `quantity_certified` SET TAGS ('dbx_business_glossary_term' = 'Quantity Certified');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `quantity_certified` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Revision Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `revision_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9.]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_QM|Opcenter_MES|Teamcenter_PLM|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `specification_number` SET TAGS ('dbx_business_glossary_term' = 'Specification / Drawing Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Certificate Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Draft|Pending_Approval|Approved|Issued|Superseded|Revoked|Expired|Cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `superseded_by_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Certificate Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `test_results_summary` SET TAGS ('dbx_business_glossary_term' = 'Test Results Summary');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Certificate Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'CoC|CoA|MTR|FAI_Certificate|Inspection_Certificate|Conformity_Declaration|Test_Report|Other');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `qms_document_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Management System (QMS) Document ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `access_level` SET TAGS ('dbx_business_glossary_term' = 'Document Access Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `access_level` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Document Approval Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_submitted|pending|approved|rejected|conditionally_approved');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Document Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Document Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `change_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Document Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `distribution_scope` SET TAGS ('dbx_business_glossary_term' = 'Document Distribution Scope');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `distribution_scope` SET TAGS ('dbx_value_regex' = 'all_sites|specific_plant|specific_department|supplier|customer|external_regulatory|internal_only');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `document_category` SET TAGS ('dbx_business_glossary_term' = 'Document Category');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `document_category` SET TAGS ('dbx_value_regex' = 'quality_management|production|engineering|safety|environmental|regulatory_compliance|supplier_quality|customer_quality|laboratory|maintenance');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'QMS Document Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}-[A-Z]{2,6}-[0-9]{4,8}(-[A-Z0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `document_owner` SET TAGS ('dbx_business_glossary_term' = 'Document Owner');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'quality_manual|procedure|work_instruction|form|specification|standard|policy|record_template|control_plan|inspection_plan|sop|drawing|test_method|regulatory_submission');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Document Effective Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `electronic_signature_required` SET TAGS ('dbx_business_glossary_term' = 'Electronic Signature Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `electronic_signature_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Expiry Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `external_origin_flag` SET TAGS ('dbx_business_glossary_term' = 'External Origin Document Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `external_origin_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'Document File Format');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'pdf|docx|xlsx|pptx|dwg|dxf|xml|html|txt|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `iso_clause_reference` SET TAGS ('dbx_business_glossary_term' = 'ISO Clause Reference');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Document Language Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}(-[A-Z]{2,3})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Document Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `owner_department` SET TAGS ('dbx_business_glossary_term' = 'Document Owner Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `parent_document_number` SET TAGS ('dbx_business_glossary_term' = 'Parent Document Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `prepared_by` SET TAGS ('dbx_business_glossary_term' = 'Document Prepared By');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_value_regex' = 'iso_9001|iso_14001|iso_45001|iso_50001|iec_61131|iec_62443|osha|epa|rohs|reach|ce_marking|ul|nist|ansi|iatf_16949|as9100|none');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `retention_period_years` SET TAGS ('dbx_business_glossary_term' = 'Document Retention Period (Years)');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `retention_period_years` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Document Review Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `review_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Document Review Frequency (Months)');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `revision_level` SET TAGS ('dbx_business_glossary_term' = 'Document Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `revision_level` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `revision_reason` SET TAGS ('dbx_business_glossary_term' = 'Document Revision Reason');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_business_glossary_term' = 'RoHS/REACH Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter_plm|sap_qm|opcenter_mes|manual|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|pending_approval|approved|effective|superseded|obsolete|withdrawn|on_hold');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `storage_location_path` SET TAGS ('dbx_business_glossary_term' = 'Document Storage Location Path');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `superseded_document_number` SET TAGS ('dbx_business_glossary_term' = 'Superseded Document Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Document Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `training_required` SET TAGS ('dbx_business_glossary_term' = 'Training Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ALTER COLUMN `training_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` SET TAGS ('dbx_subdomain' = 'product_validation');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `apqp_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Plan ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `actual_launch_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Product Launch Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `actual_launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `apqp_readiness_score` SET TAGS ('dbx_business_glossary_term' = 'APQP Readiness Score');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `apqp_readiness_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `cross_functional_team` SET TAGS ('dbx_business_glossary_term' = 'Cross-Functional Team Members');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `current_phase` SET TAGS ('dbx_business_glossary_term' = 'Current APQP Phase');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `current_phase` SET TAGS ('dbx_value_regex' = 'phase_1_plan_and_define|phase_2_product_design_and_development|phase_3_process_design_and_development|phase_4_product_and_process_validation|phase_5_feedback_assessment_and_corrective_action');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `customer_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Approval Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `customer_approval_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|approved|conditionally_approved|rejected');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `customer_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `customer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `deliverables_completed` SET TAGS ('dbx_business_glossary_term' = 'Completed APQP Deliverables Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `deliverables_completed` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `deliverables_total` SET TAGS ('dbx_business_glossary_term' = 'Total APQP Deliverables Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `deliverables_total` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `dfmea_status` SET TAGS ('dbx_business_glossary_term' = 'Design Failure Mode and Effects Analysis (DFMEA) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `dfmea_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `fai_status` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `fai_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `msa_status` SET TAGS ('dbx_business_glossary_term' = 'Measurement System Analysis (MSA) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `msa_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `open_issues_count` SET TAGS ('dbx_business_glossary_term' = 'Open Issues Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `open_issues_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `pfmea_status` SET TAGS ('dbx_business_glossary_term' = 'Process Failure Mode and Effects Analysis (PFMEA) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `pfmea_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|approved|not_applicable');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `phase_gate_status` SET TAGS ('dbx_business_glossary_term' = 'Phase Gate Review Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `phase_gate_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|gate_review_pending|gate_approved|gate_rejected|closed');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Plan Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^APQP-[A-Z0-9]{2,10}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_owner` SET TAGS ('dbx_business_glossary_term' = 'APQP Plan Owner');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_owner_department` SET TAGS ('dbx_business_glossary_term' = 'Plan Owner Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_start_date` SET TAGS ('dbx_business_glossary_term' = 'APQP Plan Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'APQP Plan Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'new_product_introduction|engineering_change|supplier_change|process_change|capacity_expansion|regulatory_compliance');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_status` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_status` SET TAGS ('dbx_value_regex' = 'not_started|in_preparation|submitted|approved|conditionally_approved|rejected|interim_approval');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `ppap_submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'APQP Plan Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `product_family` SET TAGS ('dbx_business_glossary_term' = 'Target Product Family');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'APQP Plan Risk Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_business_glossary_term' = 'RoHS/REACH Applicability Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `rohs_reach_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Siemens_Teamcenter|Siemens_Opcenter|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'APQP Plan Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|on_hold|completed|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `target_launch_date` SET TAGS ('dbx_business_glossary_term' = 'Target Product Launch Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `target_launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_plan` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'APQP Plan Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` SET TAGS ('dbx_subdomain' = 'inspection_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` SET TAGS ('dbx_association_edges' = 'quality.inspection_plan,quality.quality_characteristic');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `plan_characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Characteristic ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Characteristic - Quality Characteristic Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Equipment ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Characteristic - Inspection Plan Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `quality_characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `aql_level` SET TAGS ('dbx_business_glossary_term' = 'Acceptable Quality Level');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `characteristic_class` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Classification');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `characteristic_count` SET TAGS ('dbx_business_glossary_term' = 'Inspection Characteristic Count');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `characteristic_count` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `cpk_minimum_required` SET TAGS ('dbx_business_glossary_term' = 'Minimum Required Cpk');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `inspection_method_code` SET TAGS ('dbx_business_glossary_term' = 'Inspection Method Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `recording_type` SET TAGS ('dbx_business_glossary_term' = 'Recording Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Sequence Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `skip_lot_eligible` SET TAGS ('dbx_business_glossary_term' = 'Skip Lot Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `spc_enabled` SET TAGS ('dbx_business_glossary_term' = 'SPC Enabled Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`plan_characteristic` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` SET TAGS ('dbx_subdomain' = 'product_validation');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` SET TAGS ('dbx_association_edges' = 'quality.apqp_project,workforce.employee');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `project_team_member_id` SET TAGS ('dbx_business_glossary_term' = 'Project Team Member Assignment ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `apqp_project_id` SET TAGS ('dbx_business_glossary_term' = 'Project Team Member - Apqp Project Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Project Team Member - Employee Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Resource Allocation Percentage');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `is_core_team` SET TAGS ('dbx_business_glossary_term' = 'Core Team Member Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `phase_responsibility` SET TAGS ('dbx_business_glossary_term' = 'APQP Phase Responsibility');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `team_role` SET TAGS ('dbx_business_glossary_term' = 'APQP Team Role');
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` SET TAGS ('dbx_association_edges' = 'quality.gauge,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `gauge_loan_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge Loan Identifier');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge Loan - Gauge Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge Loan - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `authorized_by` SET TAGS ('dbx_business_glossary_term' = 'Authorized By');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `custody_status` SET TAGS ('dbx_business_glossary_term' = 'Custody Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `expected_return_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Return Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `loan_end_date` SET TAGS ('dbx_business_glossary_term' = 'Loan End Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `loan_purpose` SET TAGS ('dbx_business_glossary_term' = 'Loan Purpose');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `loan_start_date` SET TAGS ('dbx_business_glossary_term' = 'Loan Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Loan Notes');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `return_condition` SET TAGS ('dbx_business_glossary_term' = 'Return Condition');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ALTER COLUMN `shipping_tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Shipping Tracking Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` SET TAGS ('dbx_subdomain' = 'risk_planning');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` SET TAGS ('dbx_association_edges' = 'quality.quality_characteristic,technology.ot_system');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `measurement_capability_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Capability ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Capability - Quality Characteristic Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Capability - Ot System Id');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `quality_characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `active_flag` SET TAGS ('dbx_business_glossary_term' = 'Active Configuration Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `alarm_threshold` SET TAGS ('dbx_business_glossary_term' = 'Alarm Threshold');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `collection_frequency` SET TAGS ('dbx_business_glossary_term' = 'Data Collection Frequency');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `data_format` SET TAGS ('dbx_business_glossary_term' = 'Measurement Data Format');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `gage_r_and_r_percentage` SET TAGS ('dbx_business_glossary_term' = 'Gage R&R Percentage');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `last_msa_date` SET TAGS ('dbx_business_glossary_term' = 'Last MSA Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `measurement_capability` SET TAGS ('dbx_business_glossary_term' = 'Measurement Capability Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `measurement_resolution` SET TAGS ('dbx_business_glossary_term' = 'Measurement Resolution');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `next_msa_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next MSA Due Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ALTER COLUMN `spc_enabled` SET TAGS ('dbx_business_glossary_term' = 'SPC Enabled Flag');
