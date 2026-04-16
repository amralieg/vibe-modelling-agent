-- Schema for Domain: quality | Business:  | Version: v1_mvm
-- Generated on: 2026-04-16 09:51:31

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`quality` COMMENT 'Manages the Quality Management System (QMS) including inspection plans, FAI (First Article Inspection), AQL/SPC/Six Sigma controls, NCR processing, CAPA workflows, FMEA analyses, APQP, PPAP documentation, and quality audits. Tracks PPM, Cp/Cpk indices, scrap rate, and yield across all production stages. Ensures compliance with ISO 9001.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`inspection_plan` (
    `inspection_plan_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a quality inspection plan record in the lakehouse silver layer.',
    `bop_id` BIGINT COMMENT 'Foreign key linking to engineering.bop. Business justification: Inspection plans are tied to a Bill of Process — quality checks are defined per manufacturing process step. Process engineers and quality teams align inspection points to specific BOP operations daily',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.characteristic. Business justification: Inspection plans are built around specific quality characteristics (CTQ features). This FK links the inspection plan master to the characteristic master, enabling direct traceability from the inspecti',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: Inspection plans are built against a specific BOM revision — quality engineers reference the BOM to define which components require inspection. This is a daily quality planning activity in manufacturi',
    `fmea_id` BIGINT COMMENT 'Foreign key linking to quality.fmea. Business justification: Inspection plans are developed based on FMEA risk assessments — high RPN characteristics from FMEA drive more stringent inspection requirements. This FK links the inspection plan to the FMEA that info',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: Inspection plans are created for specific products in the product hierarchy. Quality engineers reference the product hierarchy daily when setting up inspection plans for manufacturing operations.',
    `product_configuration_id` BIGINT COMMENT 'Foreign key linking to product.product_configuration. Business justification: Inspection plans may be specific to a product configuration/variant. In configurable product manufacturing, different configurations require different inspection criteria; this link enables configurat',
    `routing_id` BIGINT COMMENT 'Foreign key linking to production.routing. Business justification: Inspection plans define quality checks aligned with production routing operations. Quality engineers create inspection plans that mirror the manufacturing process flow for in-process verification.',
    `task_list_id` BIGINT COMMENT 'Foreign key linking to asset.task_list. Business justification: Inspection plans reference asset task lists that define the sequence of inspection steps to be performed on equipment. In SAP QM/PM, inspection plans are directly linked to task lists to reuse standar',
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
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Customer-specific inspection lots are created for goods produced against a customer order. Linking to the customer account enables customer-specific quality plans and traceability of inspection result',
    `batch_id` BIGINT COMMENT 'Foreign key linking to production.batch. Business justification: Every inspection lot is tied to a production batch for traceability. Quality departments use this link to accept or reject entire batches based on inspection results — a core SAP QM workflow.',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: Inspection lots are executed in accordance with control plan requirements. This FK links the transactional inspection event to the governing control plan that defines the inspection frequency, sample ',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Inspection lots are created at goods receipt in SAP QM and equivalent systems. The GR event physically triggers the inspection lot — quality cannot inspect without knowing what was received, when, and',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: Inspection lots are triggered for a specific product/material. Production and quality teams link every inspection lot to the product hierarchy to track quality results per product.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: An inspection lot is always governed by an inspection plan that defines the sampling method, AQL level, and characteristics to inspect. The inspection_plan_number and inspection_plan_version string fi',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.location. Business justification: Inspection lots are physically performed at a specific location (warehouse, receiving dock, production floor). Quality planners assign inspection lots to locations for resource scheduling and traceabi',
    `order_confirmation_id` BIGINT COMMENT 'Foreign key linking to order.order_confirmation. Business justification: Inspection lots are triggered by confirmed customer orders in manufacturing. Quality teams open inspection lots directly against order confirmations to validate goods before shipment — a daily QM/SD i',
    `production_order_cost_id` BIGINT COMMENT 'Foreign key linking to finance.production_order_cost. Business justification: Inspection lots are created for production orders. Linking to production_order_cost allows finance and quality to jointly analyze scrap/rework costs against the production orders actual cost, enablin',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Incoming goods inspections are triggered directly by purchase orders. Quality teams open inspection lots against specific POs to validate received materials before acceptance — a daily receiving inspe',
    `routing_operation_id` BIGINT COMMENT 'Foreign key linking to production.routing_operation. Business justification: In-process inspection lots are assigned to specific routing operations (e.g., weld inspection at op 30). This links quality gates directly to the production routing step where the check is performed.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: Inspection lots are triggered at specific work centers during in-process quality checks. Quality teams use this daily to trace which production station generated the lot and route inspectors according',
    `accepted_quantity` DECIMAL(18,2) COMMENT 'Quantity of material within the inspection lot that passed inspection and was accepted for unrestricted use or further processing. Used for yield calculation and stock posting to unrestricted stock.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
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
    `gauge_id` BIGINT COMMENT 'Identifier of the measurement instrument or gauge used to capture this result, enabling traceability to calibration records and Measurement System Analysis (MSA) studies.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Inspection results are child records of an inspection lot — each measured characteristic result belongs to a specific lot execution. The inspection_lot_number string field is redundant once the FK is ',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Inspection results captured on production equipment reference the specific measurement point defined on that asset. Quality engineers use this link to correlate inspection outcomes with asset measurem',
    `shop_order_operation_id` BIGINT COMMENT 'Foreign key linking to production.shop_order_operation. Business justification: Inspection results are recorded against the actual shop order operation being executed. Production supervisors and quality engineers use this to correlate defect data with specific manufacturing execu',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Inspection results are recorded in a specific unit of measure. Referencing the product UOM master ensures consistent measurement units across quality results and eliminates unit duplication.',
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
    `upper_control_limit` DECIMAL(18,2) COMMENT 'Statistical Process Control (SPC) upper control limit for the characteristic, calculated from process data (typically mean + 3 sigma). Triggers SPC alerts when exceeded.',
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'The maximum allowable value for the characteristic as defined in the engineering specification or drawing. Used for conformance determination and Cp/Cpk calculation.',
    `work_center_code` STRING COMMENT 'Code of the production work center or inspection station where the measurement was taken, enabling quality performance analysis at the work center level.',
    CONSTRAINT pk_inspection_result PRIMARY KEY(`inspection_result_id`)
) COMMENT 'Detailed measurement and characteristic result records captured during inspection lot execution. Stores individual measured values, attribute conformance decisions, SPC data points, Cp/Cpk indices per characteristic, and inspector sign-off. Enables traceability from lot to individual measurement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`usage_decision` (
    `usage_decision_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a single usage decision record within the Quality Management System. Serves as the primary key for the usage_decision data product.',
    `batch_id` BIGINT COMMENT 'Foreign key linking to production.batch. Business justification: Usage decisions (accept/reject/rework) are made at the batch level after inspection. Quality managers post usage decisions that directly update batch status in production — a fundamental QM-to-batch m',
    `capa_id` BIGINT COMMENT 'Foreign key linking to quality.quality_capa. Business justification: When a usage decision results in rejection or conditional release, a CAPA is typically initiated. This FK links the formal quality disposition (usage decision) to the corrective action record, providi',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Usage decisions (accept, reject, conditional release) are made against a specific goods receipt. The decision directly determines whether received stock is released to inventory or returned to supplie',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: A usage decision is formally made at the conclusion of an inspection lot — it is the disposition record for that lot (accept, reject, conditional release). The inspection_lot_number string field is re',
    `quarantine_hold_id` BIGINT COMMENT 'Foreign key linking to inventory.quarantine_hold. Business justification: When a usage decision results in rejection or conditional acceptance, a quarantine hold is placed on the inventory. Quality teams reference the hold record to track disposition status. This link drive',
    `accepted_quantity` DECIMAL(18,2) COMMENT 'Quantity of material from the inspection lot that is accepted and posted to unrestricted-use stock following the usage decision. May be less than the total inspection quantity when partial acceptance or split posting is applied.. Valid values are `^d+(.d{1,4})?$`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time at which the secondary approval for the usage decision was granted. Used for approval cycle time measurement and audit trail documentation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the quality manager or authorized approver who provided secondary approval for the usage decision, when requires_approval is true. Supports segregation of duties and audit trail compliance.',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`capa` (
    `capa_id` BIGINT COMMENT 'Unique system-generated identifier for the CAPA record within the Quality Management System.',
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: CAPAs are frequently initiated in response to customer complaints or audit findings. Linking CAPA to the customer account enables tracking of corrective actions per customer and supports 8D/customer-f',
    `cost_allocation_id` BIGINT COMMENT 'Foreign key linking to finance.cost_allocation. Business justification: CAPA actions incur real costs (rework, containment, supplier audits). Finance allocates these costs to a cost center or project via cost_allocation. Controllers use this link to report quality-related',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: CAPAs are initiated for specific defect types and should reference the standardized defect code master. This FK links the CAPA to the authoritative defect classification, enabling PPM analysis and def',
    `downtime_event_id` BIGINT COMMENT 'Foreign key linking to production.downtime_event. Business justification: CAPAs are frequently initiated in response to equipment downtime events that caused quality escapes. Quality engineers link CAPA records to the originating downtime event to drive root cause analysis ',
    `ecn_id` BIGINT COMMENT 'Foreign key linking to engineering.ecn. Business justification: Corrective actions often require engineering changes to resolve quality issues. CAPA systems link to ECNs when design modifications are needed to prevent recurrence.',
    `eco_id` BIGINT COMMENT 'Foreign key linking to engineering.eco. Business justification: CAPA corrective actions may trigger engineering change orders to implement design improvements. Quality teams track ECO implementation as part of CAPA closure verification.',
    `failure_record_id` BIGINT COMMENT 'Foreign key linking to asset.failure_record. Business justification: CAPAs are frequently triggered by asset failures. Quality engineers link a CAPA directly to the asset failure record that initiated the corrective action — standard in RCA-driven quality systems and r',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: CAPAs are frequently initiated from failed inspection lots. This FK provides direct traceability from the corrective action record back to the triggering inspection event. The existing source_referenc',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Corrective and preventive actions are frequently issued to suppliers for recurring defects. Procurement tracks open CAPAs per supplier as part of supplier development programs and qualification review',
    `work_order_operation_id` BIGINT COMMENT 'Foreign key linking to asset.work_order_operation. Business justification: Corrective actions in a CAPA often result in or reference a specific maintenance work order operation performed on equipment. Linking these allows quality and maintenance teams to confirm physical cor',
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
    CONSTRAINT pk_capa PRIMARY KEY(`capa_id`)
) COMMENT 'Corrective and Preventive Action (CAPA) record managing the full workflow from root cause analysis through action implementation and effectiveness verification. Tracks problem statement, root cause method (5-Why, Ishikawa), assigned owner, target closure date, verification evidence, and recurrence status. Supports ISO 9001 Clause 10.2 compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`fmea` (
    `fmea_id` BIGINT COMMENT 'Unique system-generated identifier for the FMEA record within the Quality Management System.',
    `asset_bom_id` BIGINT COMMENT 'Foreign key linking to asset.asset_bom. Business justification: FMEAs are performed against specific equipment or asset structures. Quality engineers reference the asset BOM to identify failure modes at the component level — a core requirement of AIAG FMEA methodo',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.characteristic. Business justification: FMEA records analyze failure modes for specific quality characteristics (CTQ features). This FK links the risk assessment to the characteristic being analyzed, enabling direct traceability from FMEA s',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: FMEAs are conducted for specific products or assemblies. Product engineers and quality teams create FMEAs per product in the hierarchy as part of APQP and design validation processes.',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`control_plan` (
    `control_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the Quality Control Plan record within the enterprise data platform.',
    `bop_id` BIGINT COMMENT 'Foreign key linking to engineering.bop. Business justification: Control plans are structured around the Bill of Process — each control plan step maps to a BOP operation. APQP/PPAP methodology explicitly requires control plans to reference the manufacturing process',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.quality_characteristic. Business justification: A control plan row defines controls for a specific quality characteristic (CTQ). The product_characteristic string field is redundant once the FK to quality_characteristic is established. process_char',
    `fmea_id` BIGINT COMMENT 'Foreign key linking to quality.fmea. Business justification: A control plan is derived from and references a Process FMEA (PFMEA) — the control methods and reaction plans in the control plan are designed to address failure modes identified in the FMEA. The pfme',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: Control plans define quality controls for a specific product/part. Manufacturing quality teams maintain control plans per product as a core APQP deliverable and production control document.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Control plans reference inspection plans for the specific inspection characteristics, sampling methods, and AQL levels to be applied during production. This FK links the process control definition to ',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: Control plans specify where on equipment measurements must be taken. Linking to the asset measurement point ensures control plan instructions align with the physical measurement locations defined in t',
    `product_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.product_specification. Business justification: Control plans enforce product specifications — acceptance criteria in the control plan are derived directly from engineering product specs. Quality engineers reference specs daily when authoring and r',
    `routing_id` BIGINT COMMENT 'Foreign key linking to production.routing. Business justification: Control plans document quality controls at each routing operation. APQP requirement linking process steps to inspection methods, reaction plans, and control methods.',
    `routing_operation_id` BIGINT COMMENT 'Foreign key linking to production.routing_operation. Business justification: Control plans define quality controls at each routing operation step. APQP/PPAP requires control plans to be aligned to specific process operations — quality engineers map each control point to a rout',
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
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: PPAP submissions are prepared for and approved by a specific customer in automotive/industrial manufacturing. The customer account is the approving authority — this link is mandatory in APQP/PPAP proc',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: PPAP submissions require a designated customer approver contact. Quality engineers coordinate approval directly with this person — tracking the contact is essential for submission status and follow-up',
    `contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: PPAP approval is often a contractual milestone — the contract specifies PPAP requirements and approval is a condition for releasing production volumes. Linking PPAP to the contract enables contract co',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: PPAP submissions require a completed and approved control plan as a mandatory PPAP element (Element 13 per AIAG PPAP manual). This FK directly links the PPAP submission package to the governing contro',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: PPAP submissions must reference the approved BOM revision — PPAP Element 2 (Design Records) requires the exact BOM. Automotive/industrial PPAP packages are always tied to a specific BOM revision.',
    `fmea_id` BIGINT COMMENT 'Foreign key linking to quality.fmea. Business justification: PPAP submissions require a completed PFMEA (Process FMEA) as a mandatory element (Element 3 per AIAG PPAP manual). This FK links the PPAP submission package to the governing FMEA, enabling automated v',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: PPAP submissions are made for specific parts/products to gain customer approval. Supplier quality teams submit PPAPs per product; this link is mandatory for automotive and industrial manufacturing.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: PPAP submissions reference the inspection plan as part of the measurement system and capability study documentation. This FK links the PPAP package to the inspection plan used during the production tr',
    `pricing_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.pricing_agreement. Business justification: PPAP submissions are often scoped to a specific customer pricing/supply agreement (part number, program). Linking ensures the submission is traceable to the commercial contract it supports — required ',
    `product_cost_estimate_id` BIGINT COMMENT 'Foreign key linking to finance.product_cost_estimate. Business justification: PPAP submissions in automotive/industrial manufacturing require cost sign-off alongside quality approval. The product cost estimate is formally referenced during PPAP to confirm the part can be produc',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: PPAP submissions are specific to a product variant — each variant configuration requires its own PPAP approval. Suppliers and quality teams submit and track PPAP per variant, not just per base product',
    `quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: PPAP submissions are prepared during quotation phase for new parts. Customers require PPAP approval before awarding production orders, linking quality validation to commercial quotation.',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: PPAP submissions are made by a specific supplier to qualify a part for production. Procurement and SQE teams manage PPAP approval as a prerequisite before issuing production purchase orders to that su',
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
    `supplier_manufacturing_site` STRING COMMENT 'Name or identifier of the specific manufacturing facility or plant at the supplier where the part is produced, as required on the Part Submission Warrant (PSW).',
    `supplier_quality_engineer` STRING COMMENT 'Name of the suppliers quality engineer responsible for preparing, coordinating, and submitting the PPAP package.',
    CONSTRAINT pk_ppap_submission PRIMARY KEY(`ppap_submission_id`)
) COMMENT 'Production Part Approval Process (PPAP) submission package record tracking the status and completeness of all required PPAP elements (design records, PFMEA, control plan, MSA, capability studies, FAI, etc.) for a given part and supplier. Captures submission level, customer approval status, and PSW (Part Submission Warrant) details.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`fai_record` (
    `fai_record_id` BIGINT COMMENT 'Unique system-generated identifier for the First Article Inspection (FAI) record. Serves as the primary key for this entity in the Databricks Silver Layer.',
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: First Article Inspection records are submitted to and approved by a specific customer. In industrial manufacturing, FAI is a customer-driven requirement — the customer account is the approval authorit',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: First Article Inspections are conducted against the requirements defined in the control plan. This FK links the FAI record to the governing control plan, providing traceability from the first article ',
    `drawing_id` BIGINT COMMENT 'Foreign key linking to engineering.drawing. Business justification: FAI records are performed against a specific engineering drawing revision. Inspectors measure dimensions and features directly from the drawing — AS9102 FAI standard requires the drawing reference to ',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: First Article Inspection records validate that manufactured parts conform to the engineering BOM. FAI is performed against a specific BOM revision — AS9102 and PPAP standards require this explicit BOM',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: First Article Inspection records are created for specific products to verify conformance before production. Quality engineers conduct FAI per product; this is a standard aerospace and industrial requi',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: A First Article Inspection is executed as an inspection lot (inspection_lot has is_first_article_inspection flag). Linking fai_record to the inspection_lot that captured the measurements enables full ',
    `order_confirmation_id` BIGINT COMMENT 'Foreign key linking to order.order_confirmation. Business justification: First Article Inspection records are tied to the first confirmed production order for a new part. Quality engineers reference the order confirmation to validate the FAI scope and customer requirements',
    `ppap_submission_id` BIGINT COMMENT 'Foreign key linking to quality.ppap_submission. Business justification: FAI is a required element of PPAP (fai_complete flag exists in ppap_submission). The FAI record should reference the PPAP submission package it belongs to, enabling traceability from PPAP package to F',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.po_line_item. Business justification: FAI is conducted on the first production sample from a specific PO line item. Linking FAI to the PO line provides traceability from the approved sample back to the exact procurement transaction and pa',
    `routing_id` BIGINT COMMENT 'Foreign key linking to production.routing. Business justification: First Article Inspection records validate that the production routing produces conforming parts. FAI explicitly references the approved routing to confirm the manufacturing process matches the qualifi',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: First Article Inspections are performed on parts from a specific supplier before series production begins. FAI approval is a procurement gate — purchase orders for production quantities are only relea',
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
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: In contract manufacturing, SPC charts are maintained per customer to demonstrate process capability compliance. Customers may mandate specific SPC reporting — linking enables customer-specific statist',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.quality_characteristic. Business justification: An SPC chart monitors a specific quality characteristic (CTQ). The characteristic_name and characteristic_type string fields are redundant once the FK to quality_characteristic is established, as thes',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: An SPC chart is defined within the context of a control plan — the control plan specifies the control chart type, sample size, and frequency. The control_plan_reference string field is redundant once ',
    `measurement_point_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_point. Business justification: SPC charts monitor process variation at specific measurement points on equipment. Quality engineers configure SPC charts against asset measurement points to detect equipment-driven variation — standar',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: SPC charts are configured for specific production or storage locations to monitor process variation at that physical point. Quality engineers assign charts to locations to ensure measurements are cont',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: SPC charts monitor process capability at a specific work center. Quality engineers configure and review SPC charts per machine/station — the work center is the primary dimension for statistical proces',
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
    CONSTRAINT pk_spc_chart PRIMARY KEY(`spc_chart_id`)
) COMMENT 'Statistical Process Control (SPC) chart master record defining the control chart configuration for a monitored process characteristic — chart type (Xbar-R, Xbar-S, p-chart, c-chart), subgroup size, sampling frequency, UCL/LCL control limits, and Cp/Cpk targets. Governs ongoing SPC monitoring in Siemens Opcenter MES Quality module.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`spc_sample` (
    `spc_sample_id` BIGINT COMMENT 'Unique system-generated identifier for each individual SPC data point record captured during production monitoring.',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.characteristic. Business justification: SPC samples are measurements of specific quality characteristics. While an indirect path exists via spc_sample → spc_chart → characteristic, a direct FK improves query performance for SPC analysis and',
    `gauge_id` BIGINT COMMENT 'Identifier of the measurement instrument or gauge used to collect the sample, enabling gauge R&R traceability and calibration status verification.. Valid values are `^[A-Z0-9-]{2,30}$`',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: SPC samples may be collected during an inspection lot execution. The inspection_lot_number string field is redundant once the FK to inspection_lot is established, enabling traceability from SPC data p',
    `measurement_reading_id` BIGINT COMMENT 'Foreign key linking to asset.measurement_reading. Business justification: SPC samples can be sourced directly from asset measurement readings captured by sensors or condition monitoring systems. Linking eliminates duplicate data entry and enables real-time SPC from asset te',
    `shift_id` BIGINT COMMENT 'Foreign key linking to production.shift. Business justification: SPC samples are collected during specific production shifts. Shift-level stratification is essential for identifying whether process variation is shift-dependent — a standard SPC analysis dimension in',
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
    `drawing_id` BIGINT COMMENT 'Foreign key linking to engineering.drawing. Business justification: Characteristics are ballooned and traced to specific engineering drawings — each measurable characteristic references the drawing callout. This is standard practice in dimensional inspection and contr',
    `product_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.product_specification. Business justification: Quality characteristics (dimensions, tolerances, properties) are derived from product specifications. Quality engineers trace each characteristic back to the engineering spec to ensure inspection crit',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Quality characteristics (dimensions, weights, voltages) are defined with a unit of measure. Referencing the product UOM master ensures standardized units across all quality characteristic definitions.',
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
    `upper_spec_limit` DECIMAL(18,2) COMMENT 'The maximum allowable value for the quality characteristic as defined in the engineering specification or customer requirement. Measurements exceeding this limit are non-conforming.',
    `upper_tolerance` DECIMAL(18,2) COMMENT 'The positive tolerance deviation from the nominal value (e.g., +0.05 mm). Together with lower_tolerance, defines the bilateral or unilateral tolerance band around the nominal value as specified on engineering drawings.',
    `work_center_code` STRING COMMENT 'Code identifying the production work center or process step where this characteristic is measured. Links the characteristic to the specific manufacturing operation in the routing or Bill of Process (BoP).',
    `valid_from` DATE COMMENT 'The date from which this quality characteristic definition is effective and may be used in inspection plans. Supports time-phased characteristic management aligned with engineering change notices (ECN/ECO).. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'The date after which this quality characteristic definition is no longer effective. Used to manage characteristic obsolescence aligned with engineering change orders (ECO) and product end-of-life.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_characteristic PRIMARY KEY(`characteristic_id`)
) COMMENT 'Master record for quality characteristics (CTQ — Critical to Quality features) defined for parts, assemblies, or processes. Captures characteristic name, type (dimensional, functional, visual, material), nominal value, tolerance limits, measurement unit, gauge type, and classification (critical, major, minor). Referenced by inspection plans, control plans, and SPC charts.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`gauge` (
    `gauge_id` BIGINT COMMENT 'Unique system-generated identifier for each gauge or measurement instrument master record in the Quality Management System.',
    `class_id` BIGINT COMMENT 'Foreign key linking to asset.class. Business justification: Gauges are classified as assets using the asset classification hierarchy. Asset management teams assign class to gauges for depreciation, inventory, and lifecycle tracking — a standard EAM practice in',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Gauges are physical assets requiring scheduled preventive maintenance. Quality and asset teams assign a maintenance plan to each gauge to ensure it remains fit for measurement use — standard practice ',
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
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: External gauge calibration services are procured from certified labs and invoiced via AP. The calibration record must reference the AP invoice to satisfy audit requirements (ISO 9001, IATF 16949) prov',
    `calibration_record_id` BIGINT COMMENT 'Foreign key linking to asset.calibration_record. Business justification: Gauge calibrations are asset calibration events. Asset management owns the calibration schedule and records; quality references these to validate measurement equipment certification before use.',
    `gauge_id` BIGINT COMMENT 'Unique identifier of the gauge or measurement instrument being calibrated, as registered in the measurement equipment master.',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`customer_complaint` (
    `customer_complaint_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each customer complaint record in the Quality Management System.',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Customer complaints in manufacturing are routinely tied to a specific shipped invoice — quality teams reference the AR invoice to identify the delivery, product batch, and customer billed. Claims, cre',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to sales.campaign. Business justification: A customer complaint may be traced back to a specific sales campaign (e.g., a promotional batch or product launch campaign) that generated the defective orders. Quality teams reference the originating',
    `capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: Customer complaints requiring corrective action reference a CAPA record. The capa_number string field is redundant once the FK to capa is established.',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Customer complaints are classified by standardized defect codes for consistent reporting and trend analysis. The defect_code string field is redundant once the FK to the defect_code master is establis',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: Customer complaints are filed against specific products. Customer quality teams log complaints per product to track field quality performance and trigger corrective actions per product line.',
    `installed_base_id` BIGINT COMMENT 'Foreign key linking to customer.installed_base. Business justification: Complaints in industrial manufacturing are frequently tied to a specific installed asset at the customer site. Linking to installed base enables root cause analysis against a known physical asset in t',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.line_item. Business justification: Complaints are raised against specific order line items (a particular product/quantity shipped). Quality teams need this link to identify defective batches tied to exact order lines — essential for ro',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Customer complaints are filed against a specific product variant — quality teams need to identify exactly which variant configuration is affected. This drives targeted root cause analysis and correcti',
    `quality_notification_id` BIGINT COMMENT 'Foreign key linking to quality.quality_notification. Business justification: Customer complaints are formally documented and managed through quality notifications in SAP QM. This FK links the customer complaint record to the quality notification raised to manage the issue inte',
    `returns_order_id` BIGINT COMMENT 'Foreign key linking to order.returns_order. Business justification: Customer complaints in manufacturing are directly linked to returns orders (RMAs). The complaint resolution process requires tracing back to the specific return transaction — used daily by customer se',
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.sales_territory. Business justification: Customer complaints are geographically scoped to a sales territory so quality managers can identify regional defect patterns, coordinate with territory sales reps on field returns, and report complain',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: For serialized products, customer complaints reference the exact serialized unit returned or reported defective. Quality engineers use this to trace manufacturing history, inspection results, and ship',
    `sla_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.sla_agreement. Business justification: Complaint resolution must be governed by the customers SLA agreement. Quality teams track whether response and resolution deadlines are met per contractual obligations — a core compliance requirement',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: When a customer complaint traces root cause to a purchased component, the complaint is linked to the responsible supplier. Procurement uses this to initiate supplier corrective actions and update supp',
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
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Quality notifications triggered by customer-reported issues must reference the originating customer account. This is standard in SAP QM-style workflows where notifications are customer-facing quality ',
    `asset_notification_id` BIGINT COMMENT 'Foreign key linking to asset.asset_notification. Business justification: Quality notifications triggered by equipment issues are often paired with or escalated from asset notifications. Maintenance and quality teams cross-reference these to coordinate response — a standard',
    `capa_id` BIGINT COMMENT 'Foreign key linking to quality.capa. Business justification: Quality notifications requiring corrective action reference a CAPA record. The capa_reference_number string field is redundant once the FK to capa is established.',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Quality notifications require a named customer contact as the reporter or point of escalation. Removing redundant reporter fields enforces 3NF and ensures contact data is maintained in one place.',
    `cost_allocation_id` BIGINT COMMENT 'Foreign key linking to finance.cost_allocation. Business justification: Quality notifications (defect alerts, non-conformances) trigger cost postings for scrap, rework, or containment. Finance links the notification to a cost allocation record to capture and report qualit',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Quality notifications are classified by standardized defect codes. The defect_code and defect_description string fields are redundant once the FK to the defect_code master is established.',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: Quality notifications (defect reports, deviations) are raised against a specific product. Quality and production teams use this link to track which products have open quality issues.',
    `inbound_delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_inbound_delivery. Business justification: Quality notifications for supplier defects are raised against the inbound delivery that brought the nonconforming material. Procurement and quality teams use this link to initiate supplier complaints,',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Quality notifications reference the inspection lot that triggered the quality problem. The inspection_lot_number string field is redundant once the FK to inspection_lot is established.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.line_item. Business justification: Quality notifications (defect alerts, deviations) are raised against specific order line items when a quality issue is detected during fulfillment. This link drives corrective action and potential del',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Supplier quality notifications reference the originating PO to enable traceability back to the procurement transaction. Buyers need the PO link to process returns, replacements, or financial deduction',
    `quarantine_hold_id` BIGINT COMMENT 'Foreign key linking to inventory.quarantine_hold. Business justification: Quality notifications (defect alerts, non-conformances) trigger quarantine holds on affected inventory. The notification record must reference the resulting hold to track containment action status. Us',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Quality notifications for supplier-caused defects are raised against the specific supplier. Procurement buyers act on these notifications to issue 8D requests, debit memos, or sourcing changes — stand',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: Quality notifications (defect alerts, deviations) are raised against the work center where the problem was detected. Production and quality teams use this to route corrective actions to the responsibl',
    `actual_closure_date` DATE COMMENT 'Date on which the quality notification was formally closed in SAP QM after all tasks, corrective actions, and verifications were completed. Used for cycle time and SLA compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `capa_required` BOOLEAN COMMENT 'Indicates whether a formal CAPA (Corrective and Preventive Action) must be initiated as a result of this quality notification. Drives CAPA workflow creation in the QMS.. Valid values are `true|false`',
    `containment_action` STRING COMMENT 'Description of the immediate containment action taken to prevent further nonconforming product from reaching the customer or next process step (e.g., quarantine, 100% inspection, production hold).',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or site where the quality notification originated. Supports multi-country regulatory compliance and geographic quality performance analysis.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the quality notification was first created in SAP QM. Marks the start of the notification lifecycle and is used for SLA (Service Level Agreement) response time measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `defect_category` STRING COMMENT 'Classification of the defect or quality problem into a standard category (e.g., Dimensional, Surface, Functional, Labeling, Documentation, Process, Material). Used for Pareto analysis and trend reporting.',
    `description` STRING COMMENT 'Detailed narrative description of the quality issue, defect, complaint, or improvement opportunity. Captures the full problem statement as entered by the originator.',
    `detection_stage` STRING COMMENT 'Stage in the production or supply chain process at which the quality defect or nonconformance was detected. Supports escape analysis and process improvement initiatives.. Valid values are `Incoming Inspection|In-Process|Final Inspection|Customer|Field|Audit|Supplier`',
    `material_description` STRING COMMENT 'Descriptive name of the affected material or component as maintained in the SAP material master, providing human-readable context for the notification.',
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
    `vendor_number` STRING COMMENT 'SAP vendor master number identifying the supplier responsible for the defective material or component, applicable for supplier defect notifications (Q3 type). Used for supplier quality performance tracking.',
    `work_center_code` STRING COMMENT 'SAP work center code identifying the specific production cell, line, or machine where the quality issue was detected or originated. Enables work-center-level defect analysis.',
    CONSTRAINT pk_quality_notification PRIMARY KEY(`quality_notification_id`)
) COMMENT 'SAP QM Quality Notification record used to formally document and manage quality problems, complaints, and improvement requests within the enterprise. Captures notification type (internal defect, customer complaint, supplier defect), priority, affected object (material, equipment, order), task list, and processing status. Central workflow trigger in SAP QM.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`quality`.`certificate` (
    `certificate_id` BIGINT COMMENT 'Unique surrogate identifier for the quality certificate record in the lakehouse silver layer.',
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Quality certificates (material certs, conformance certs) are issued to specific customers with shipments. Linking certificate to customer account enables traceability and supports customer audit reque',
    `address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Certificates are issued to a specific customer delivery/ship-to address. In manufacturing, certificates accompany physical shipments and must reference the correct destination address for compliance a',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Material/conformance certificates (CoC, CoA) are issued alongside customer shipments and tied to the AR invoice for that delivery. Quality and logistics teams use this link to retrieve the correct cer',
    `goods_issue_id` BIGINT COMMENT 'Foreign key linking to order.goods_issue. Business justification: Quality certificates (material certs, conformance certs) are issued at the point of goods issue/shipment. Linking certificate to goods_issue ensures the right certificate accompanies the right deliver',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Certificates of conformance accompany specific deliveries and are matched to the goods receipt document. Receiving inspection teams verify the certificate covers the exact batch/lot received before re',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: Quality certificates (material certs, conformance certs) are issued for specific products. Customers and auditors require product-level certificates; quality teams issue and store them per product.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Certificates of Conformance (CoC) and Certificates of Analysis (CoA) are issued based on inspection lot results. This FK links the certificate to the inspection event that validated the product qualit',
    `material_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.material_specification. Business justification: Material certificates reference the engineering material specification they certify compliance against. Quality and procurement teams verify that material certs match the approved material spec before',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Quality certificates (material certs, conformance certs) are issued for a specific product variant. Customers and regulatory bodies require certificates tied to the exact variant shipped — this is sta',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: For high-value or regulated serialized products (aerospace, medical), certificates are issued at the individual unit level. The certificate must reference the exact serialized unit to satisfy traceabi',
    `shipment_item_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment_item. Business justification: Quality certificates (e.g., material test reports, CoC) are issued per shipment item and must travel with the goods. Logistics teams attach certificates to specific shipment items for customs, custome',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Material and conformance certificates are issued by suppliers and must be tracked against the supplying entity. Procurement requires valid certificates (e.g., ISO, RoHS, material certs) before approvi',
    `usage_decision_id` BIGINT COMMENT 'Foreign key linking to quality.usage_decision. Business justification: Certificates of Conformance are issued following a formal acceptance usage decision. This FK provides direct traceability from the certificate to the quality disposition that authorized its issuance. ',
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
    `source_system` STRING COMMENT 'Operational system of record from which this quality certificate record originated (e.g., SAP QM, Siemens Opcenter MES), supporting data lineage and reconciliation.. Valid values are `SAP_QM|Opcenter_MES|Teamcenter_PLM|Manual|Other`',
    `specification_number` STRING COMMENT 'Engineering specification, drawing, or standard number against which the product was tested and certified.',
    `status` STRING COMMENT 'Current lifecycle status of the quality certificate, from initial draft through issuance, potential supersession, or revocation.. Valid values are `Draft|Pending_Approval|Approved|Issued|Superseded|Revoked|Expired|Cancelled`',
    `superseded_by_certificate_number` STRING COMMENT 'Certificate number of the replacement certificate when this certificate has been superseded, enabling version chain traceability.',
    `test_results_summary` STRING COMMENT 'Narrative or structured summary of key test results included on the certificate, such as dimensional, mechanical, chemical, or functional test outcomes.',
    `type` STRING COMMENT 'Classification of the quality certificate: Certificate of Conformance (CoC), Certificate of Analysis (CoA), Material Test Report (MTR), First Article Inspection (FAI) Certificate, Inspection Certificate, Declaration of Conformity, Test Report, or Other.. Valid values are `CoC|CoA|MTR|FAI_Certificate|Inspection_Certificate|Conformity_Declaration|Test_Report|Other`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the certified quantity (e.g., EA, KG, M, L, PC), aligned with SAP base unit of measure.. Valid values are `^[A-Z]{1,10}$`',
    CONSTRAINT pk_certificate PRIMARY KEY(`certificate_id`)
) COMMENT 'Quality certificate (Certificate of Conformance / Certificate of Analysis) record issued for a manufactured batch, lot, or shipment. Captures certificate type (CoC, CoA, material test report), issuing plant, part number, batch/lot number, test results summary, applicable standards met, authorized signatory, and customer-specific certificate requirements.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_capa_id` FOREIGN KEY (`capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`capa`(`capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_ppap_submission_id` FOREIGN KEY (`ppap_submission_id`) REFERENCES `manufacturing_ecm`.`quality`.`ppap_submission`(`ppap_submission_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_spc_chart_id` FOREIGN KEY (`spc_chart_id`) REFERENCES `manufacturing_ecm`.`quality`.`spc_chart`(`spc_chart_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_capa_id` FOREIGN KEY (`capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`capa`(`capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_capa_id` FOREIGN KEY (`capa_id`) REFERENCES `manufacturing_ecm`.`quality`.`capa`(`capa_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_usage_decision_id` FOREIGN KEY (`usage_decision_id`) REFERENCES `manufacturing_ecm`.`quality`.`usage_decision`(`usage_decision_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`quality` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`quality` SET TAGS ('dbx_domain' = 'quality');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `bop_id` SET TAGS ('dbx_business_glossary_term' = 'Bop Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Fmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `product_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ALTER COLUMN `task_list_id` SET TAGS ('dbx_business_glossary_term' = 'Task List Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `batch_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `order_confirmation_id` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `production_order_cost_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Cost Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `routing_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Operation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Accepted Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_result_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge / Measurement Equipment ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `shop_order_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Shop Order Operation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `upper_control_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Control Limit (UCL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `usage_decision_id` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `batch_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `capa_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `quarantine_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Quarantine Hold Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Accepted Quantity');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ALTER COLUMN `approved_by` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` SET TAGS ('dbx_original_name' = 'quality_capa');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `capa_id` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `downtime_event_id` SET TAGS ('dbx_business_glossary_term' = 'Downtime Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `ecn_id` SET TAGS ('dbx_business_glossary_term' = 'Ecn Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `eco_id` SET TAGS ('dbx_business_glossary_term' = 'Eco Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `failure_record_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `work_order_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Operation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `action_owner` SET TAGS ('dbx_business_glossary_term' = 'CAPA Action Owner');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `action_owner_department` SET TAGS ('dbx_business_glossary_term' = 'Action Owner Department');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Actual Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `affected_part_description` SET TAGS ('dbx_business_glossary_term' = 'Affected Part Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `affected_part_number` SET TAGS ('dbx_business_glossary_term' = 'Affected Part Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `affected_process` SET TAGS ('dbx_business_glossary_term' = 'Affected Manufacturing Process');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'CAPA Approved By');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Approval Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `customer_notified_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `customer_notified_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_business_glossary_term' = 'CAPA Effectiveness Rating');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `effectiveness_rating` SET TAGS ('dbx_value_regex' = 'effective|partially_effective|not_effective|pending_verification');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `immediate_containment_action` SET TAGS ('dbx_business_glossary_term' = 'Immediate Containment Action');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `initiated_by` SET TAGS ('dbx_business_glossary_term' = 'CAPA Initiated By');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `initiated_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Initiation Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `initiated_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^CAPA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'CAPA Priority');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `problem_statement` SET TAGS ('dbx_business_glossary_term' = 'Problem Statement');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `recurrence_capa_number` SET TAGS ('dbx_business_glossary_term' = 'Recurrence CAPA Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `recurrence_capa_number` SET TAGS ('dbx_value_regex' = '^CAPA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `regulatory_reporting_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Required Flag');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `regulatory_reporting_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `revised_closure_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Revised Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `revised_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category (6M)');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'man|machine|material|method|measurement|environment|management');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `root_cause_method` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis (RCA) Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `root_cause_method` SET TAGS ('dbx_value_regex' = '5_why|ishikawa|fault_tree|8d|pareto|fmea|brainstorming|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `source_reference_number` SET TAGS ('dbx_business_glossary_term' = 'CAPA Source Reference Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `source_type` SET TAGS ('dbx_business_glossary_term' = 'CAPA Source Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `source_type` SET TAGS ('dbx_value_regex' = 'ncr|customer_complaint|audit_finding|spc_alert|supplier_defect|field_failure|internal_observation|regulatory_finding|ppap_rejection|fai_failure');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'CAPA Status');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|open|root_cause_analysis|action_planning|implementation|verification|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Target Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'CAPA Title');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'CAPA Type');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'corrective|preventive|improvement');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Verification Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `verification_evidence` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Verification Evidence');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `verification_method` SET TAGS ('dbx_business_glossary_term' = 'Effectiveness Verification Method');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `verification_method` SET TAGS ('dbx_value_regex' = 'inspection|audit|spc_monitoring|process_validation|customer_feedback|production_run|document_review|other');
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `asset_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `bop_id` SET TAGS ('dbx_business_glossary_term' = 'Bop Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Fmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `product_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ALTER COLUMN `routing_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Operation Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Submission ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Fmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `pricing_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `product_cost_estimate_id` SET TAGS ('dbx_business_glossary_term' = 'Product Cost Estimate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `supplier_manufacturing_site` SET TAGS ('dbx_business_glossary_term' = 'Supplier Manufacturing Site');
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ALTER COLUMN `supplier_quality_engineer` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Engineer Name');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `fai_record_id` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Record ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `drawing_id` SET TAGS ('dbx_business_glossary_term' = 'Drawing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `order_confirmation_id` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Ppap Submission Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `routing_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `spc_chart_id` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Chart ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `measurement_point_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Point Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `spc_sample_id` SET TAGS ('dbx_business_glossary_term' = 'Statistical Process Control (SPC) Sample ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge / Measurement Device ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `gauge_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `measurement_reading_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Reading Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ALTER COLUMN `shift_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`defect_code` SET TAGS ('dbx_subdomain' = 'defect_management');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` SET TAGS ('dbx_subdomain' = 'inspection_control');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `drawing_id` SET TAGS ('dbx_business_glossary_term' = 'Drawing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `product_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `upper_spec_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Specification Limit (USL)');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `upper_tolerance` SET TAGS ('dbx_business_glossary_term' = 'Upper Tolerance');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` SET TAGS ('dbx_subdomain' = 'measurement_compliance');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Class Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` SET TAGS ('dbx_subdomain' = 'measurement_compliance');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `gauge_calibration_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge Calibration ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `calibration_record_id` SET TAGS ('dbx_business_glossary_term' = 'Calibration Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ALTER COLUMN `gauge_id` SET TAGS ('dbx_business_glossary_term' = 'Gauge ID');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `customer_complaint_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Complaint ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `installed_base_id` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `quality_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `returns_order_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `sla_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` SET TAGS ('dbx_subdomain' = 'defect_management');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` SET TAGS ('dbx_original_name' = 'quality_notification');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `quality_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `asset_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Notification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `capa_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Inbound Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `quarantine_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Quarantine Hold Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Closure Date');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
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
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `vendor_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Number');
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ALTER COLUMN `work_center_code` SET TAGS ('dbx_business_glossary_term' = 'Work Center Code');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` SET TAGS ('dbx_subdomain' = 'measurement_compliance');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Certificate ID');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `goods_issue_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `material_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Material Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `shipment_item_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ALTER COLUMN `usage_decision_id` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Id (Foreign Key)');
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
