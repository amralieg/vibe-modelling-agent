-- Schema for Domain: supply | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:55

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`supply` COMMENT 'Governs the inbound supply chain from tier-1 and tier-2 suppliers through to plant receiving. Owns supplier master data, RFQ (Request for Quotation) events, PPAP (Production Part Approval Process) records, JIT/JIS delivery schedules, inbound logistics, supplier performance metrics (PPM - Parts Per Million defect rates, OTD - On-Time Delivery), and CKD/SKD kit management for global assembly operations. Integrates with SAP MM and PTC Windchill.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` (
    `supplier_part_approval_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT '',
    `primary_employee_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `approval_date` DATE COMMENT '',
    `approval_number` STRING COMMENT '',
    `approval_outcome` STRING COMMENT '',
    `approval_score` DECIMAL(18,2) COMMENT '',
    `approver_name` STRING COMMENT '',
    `capability_study_status` STRING COMMENT '',
    `classification` STRING COMMENT '',
    `comments` STRING COMMENT '',
    `control_plan_status` STRING COMMENT '',
    `cost_usd` DECIMAL(18,2) COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `design_records_status` STRING COMMENT '',
    `expiry_date` DATE COMMENT '',
    `lead_time_days` STRING COMMENT '',
    `lifecycle_status` STRING COMMENT '',
    `msa_status` STRING COMMENT '',
    `overall_status` STRING COMMENT '',
    `part_name` STRING COMMENT '',
    `part_number` STRING COMMENT '',
    `pfmea_status` STRING COMMENT '',
    `ppap_submission_level` STRING COMMENT '',
    `quality_rating` STRING COMMENT '',
    `record_audit_created` TIMESTAMP COMMENT '',
    `record_audit_updated` TIMESTAMP COMMENT '',
    `regulatory_compliance_flag` BOOLEAN COMMENT '',
    `risk_level` STRING COMMENT '',
    `sample_parts_status` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `submission_date` DATE COMMENT '',
    `supplier_name` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_supplier_part_approval PRIMARY KEY(`supplier_part_approval_id`)
) COMMENT 'PPAP (Production Part Approval Process) record capturing the formal approval of a supplier-produced part for use in production. Includes approval ID, part number, supplier reference, PPAP submission level (1–5), submission date, approval date, approver, PPAP elements status (design records, PFMEA, control plan, MSA, capability study, sample parts), approval outcome (approved, interim approval, rejected), and expiry date. Mandated by IATF 16949 and AIAG PPAP standards for all production parts.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` (
    `supply_supplier_id` BIGINT COMMENT '',
    `jurisdiction_id` BIGINT COMMENT '',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.procurement_supplier SSOT owner for supplier entity',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    CONSTRAINT pk_supply_supplier PRIMARY KEY(`supply_supplier_id`)
) COMMENT 'Master record for all tier-1 and tier-2 suppliers in the automotive supply chain. Captures supplier identity, classification (direct/indirect, tier level), IATF 16949 certification status, DUNS number, geographic footprint, commodity codes, preferred currency, payment terms, and supplier lifecycle status (active, probation, disqualified). SSOT for supplier identity within the supply domain; integrates with SAP MM vendor master and PTC Windchill supplier collaboration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` (
    `supply_supplier_plant_id` BIGINT COMMENT '',
    `procurement_supplier_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier_plant owned by procurement domain via FK.',
    CONSTRAINT pk_supply_supplier_plant PRIMARY KEY(`supply_supplier_plant_id`)
) COMMENT 'Represents the specific manufacturing or distribution plant/site of a supplier that ships parts to an OEM assembly plant. Captures plant address, plant code, production capabilities, capacity constraints, dock-to-dock lead time, customs zone, and plant-level quality certifications. Enables JIT/JIS scheduling at the plant-to-plant level and supports CKD/SKD kit origin tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_part` (
    `inbound_part_id` BIGINT COMMENT '',
    `compliance_document_id` BIGINT COMMENT '',
    `cost_center_id` BIGINT COMMENT '',
    `part_master_id` BIGINT COMMENT '',
    `regulatory_requirement_id` BIGINT COMMENT '',
    `sku_master_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `average_cost` DECIMAL(18,2) COMMENT '',
    `commodity_group` STRING COMMENT '',
    `country_of_origin` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `customs_tariff_code` STRING COMMENT '',
    `effective_from` DATE COMMENT '',
    `effective_until` DATE COMMENT '',
    `engineering_change_level` STRING COMMENT '',
    `hazardous_material_flag` BOOLEAN COMMENT '',
    `height_mm` DECIMAL(18,2) COMMENT '',
    `last_received_date` DATE COMMENT '',
    `last_received_quantity` STRING COMMENT '',
    `lead_time_days` STRING COMMENT '',
    `length_mm` DECIMAL(18,2) COMMENT '',
    `lifecycle_status` STRING COMMENT '',
    `lot_size` STRING COMMENT '',
    `material_type` STRING COMMENT '',
    `minimum_order_quantity` STRING COMMENT '',
    `oem_part_number` STRING COMMENT '',
    `part_name` STRING COMMENT '',
    `ppap_status` STRING COMMENT '',
    `price_uom` STRING COMMENT '',
    `reorder_point_quantity` STRING COMMENT '',
    `safety_stock_quantity` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `supplier_part_number` STRING COMMENT '',
    `unit_of_measure` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `weight_kg` DECIMAL(18,2) COMMENT '',
    `width_mm` DECIMAL(18,2) COMMENT '',
    CONSTRAINT pk_inbound_part PRIMARY KEY(`inbound_part_id`)
) COMMENT 'Master record for every purchased part number sourced from external suppliers. Captures OEM part number, supplier part number cross-reference, commodity group, material type (raw, sub-assembly, CKD kit), unit of measure, PPAP approval status, engineering change level, hazardous material flag, country of origin, and customs tariff code. Bridges SAP MM material master and PTC Windchill parts classification for supply-domain-owned purchased parts.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` (
    `sourcing_nomination_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT '',
    `sourcing_buyer_employee_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `comments` STRING COMMENT '',
    `commodity` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `effective_end_date` DATE COMMENT '',
    `effective_start_date` DATE COMMENT '',
    `is_jis` BOOLEAN COMMENT '',
    `is_jit` BOOLEAN COMMENT '',
    `kit_type` STRING COMMENT '',
    `model_year` STRING COMMENT '',
    `nominated_volume` DECIMAL(18,2) COMMENT '',
    `nomination_date` TIMESTAMP COMMENT '',
    `nomination_number` STRING COMMENT '',
    `nomination_status` STRING COMMENT '',
    `part_number` STRING COMMENT '',
    `priority` STRING COMMENT '',
    `program_code` STRING COMMENT '',
    `region` STRING COMMENT '',
    `risk_rating` STRING COMMENT '',
    `sor_reference` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `target_piece_price` DECIMAL(18,2) COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_sourcing_nomination PRIMARY KEY(`sourcing_nomination_id`)
) COMMENT 'Records the formal OEM decision to nominate a specific supplier for a given part or commodity within a model year program. Captures nomination date, program/platform code, nominated supplier, awarded annual volume, target piece price, SOR (Statement of Requirements) reference, nomination status (nominated, confirmed, withdrawn), and the responsible commodity buyer. Precedes the RFQ and PPAP process. SSOT for sourcing award decisions; distinct from procurement domains strategic sourcing strategy — this is the operational award record.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`rfq` (
    `rfq_id` BIGINT COMMENT '',
    `part_master_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT '',
    `rfq_buyer_employee_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `approval_status` STRING COMMENT '',
    `attachment_flag` BOOLEAN COMMENT '',
    `commodity_code` STRING COMMENT '',
    `compliance_requirements` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `delivery_schedule_type` STRING COMMENT '',
    `discount_amount` DECIMAL(18,2) COMMENT '',
    `issue_timestamp` TIMESTAMP COMMENT '',
    `last_status_change_timestamp` TIMESTAMP COMMENT '',
    `net_price_amount` DECIMAL(18,2) COMMENT '',
    `notes` STRING COMMENT '',
    `part_description` STRING COMMENT '',
    `priority` STRING COMMENT '',
    `program_model_year` STRING COMMENT '',
    `quantity_estimate` BIGINT COMMENT '',
    `regulatory_approval_required` BOOLEAN COMMENT '',
    `required_delivery_date` DATE COMMENT '',
    `response_due_date` DATE COMMENT '',
    `rfq_number` STRING COMMENT '',
    `rfq_status` STRING COMMENT '',
    `rfq_type` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `target_price_amount` DECIMAL(18,2) COMMENT '',
    `target_price_currency` STRING COMMENT '',
    `tooling_description` STRING COMMENT '',
    `tooling_required` BOOLEAN COMMENT '',
    `unit_of_measure` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `created_by` STRING COMMENT '',
    CONSTRAINT pk_rfq PRIMARY KEY(`rfq_id`)
) COMMENT 'Transactional record of a Request for Quotation event issued to one or more suppliers for a specific part, assembly, or service. Captures RFQ number, issue date, response due date, commodity, target price, annual volume estimate, program/model year, tooling requirements, and RFQ status (open, closed, awarded, cancelled). Integrates with SAP MM RFQ (ME41) and PTC Windchill supplier collaboration portal.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`rfq_response` (
    `rfq_response_id` BIGINT COMMENT '',
    `rfq_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `amortization_term_months` STRING COMMENT '',
    `capacity_commitment` DECIMAL(18,2) COMMENT '',
    `capacity_unit` STRING COMMENT '',
    `compliance_certifications` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `delivery_address` STRING COMMENT '',
    `discount_percentage` DECIMAL(18,2) COMMENT '',
    `exceptions_to_sor` STRING COMMENT '',
    `freight_included` BOOLEAN COMMENT '',
    `is_preferred_supplier` BOOLEAN COMMENT '',
    `lead_time_days` STRING COMMENT '',
    `payment_terms` STRING COMMENT '',
    `quoted_currency` STRING COMMENT '',
    `quoted_quantity` DECIMAL(18,2) COMMENT '',
    `quoted_unit_price` DECIMAL(18,2) COMMENT '',
    `regulatory_approval_status` STRING COMMENT '',
    `remarks` STRING COMMENT '',
    `response_number` STRING COMMENT '',
    `response_source` STRING COMMENT '',
    `rfq_response_status` STRING COMMENT '',
    `shipping_method` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `submission_timestamp` TIMESTAMP COMMENT '',
    `tax_amount` DECIMAL(18,2) COMMENT '',
    `tooling_cost` DECIMAL(18,2) COMMENT '',
    `total_price` DECIMAL(18,2) COMMENT '',
    `unit_of_measure` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `validity_end_date` DATE COMMENT '',
    `validity_start_date` DATE COMMENT '',
    `warranty_period_months` STRING COMMENT '',
    `warranty_type` STRING COMMENT '',
    CONSTRAINT pk_rfq_response PRIMARY KEY(`rfq_response_id`)
) COMMENT 'Captures a suppliers formal quotation response to an RFQ. Records quoted unit price, tooling cost, amortization terms, lead time, capacity commitment, exceptions to SOR, validity period, and response status (submitted, under review, accepted, rejected). Supports competitive bid analysis and supplier selection decisions. One RFQ may have multiple responses from competing suppliers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` (
    `supply_purchase_order_id` BIGINT COMMENT 'Primary key for local supply_purchase_order reference',
    `procurement_purchase_order_id` BIGINT COMMENT 'FK reference to SSOT procurement.procurement_purchase_order',
    CONSTRAINT pk_supply_purchase_order PRIMARY KEY(`supply_purchase_order_id`)
) COMMENT 'Reference to SSOT owner procurement.procurement_purchase_order. Legally binding procurement document issued to a supplier authorizing delivery of parts or materials at agreed price and schedule. Captures PO number, PO type (standard, blanket, scheduling agreement), supplier, plant, delivery terms (Incoterms), payment terms, total value, currency, and PO status (open, partially delivered, closed, cancelled). SSOT for purchase commitments; sourced from SAP MM (ME21N/ME22N).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` (
    `supply_po_line_id` BIGINT COMMENT 'Primary key for local supply_po_line reference',
    `procurement_po_line_id` BIGINT COMMENT 'FK reference to SSOT procurement.procurement_po_line',
    CONSTRAINT pk_supply_po_line PRIMARY KEY(`supply_po_line_id`)
) COMMENT 'Reference to SSOT owner procurement.procurement_po_line. Individual line item within a purchase order representing a specific part number, quantity, unit price, delivery date, and plant destination. Captures line number, material number, ordered quantity, confirmed quantity, net price, delivery date, goods receipt quantity, and invoice quantity. Enables line-level tracking of delivery performance and invoice matching (3-way match) in SAP MM.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` (
    `supply_delivery_schedule_id` BIGINT COMMENT 'Primary key for local supply_delivery_schedule reference',
    `logistics_delivery_schedule_id` BIGINT COMMENT 'FK reference to SSOT logistics.logistics_delivery_schedule',
    CONSTRAINT pk_supply_delivery_schedule PRIMARY KEY(`supply_delivery_schedule_id`)
) COMMENT 'Reference to SSOT owner logistics.logistics_delivery_schedule. JIT/JIS delivery schedule line issued against a scheduling agreement, specifying exact quantities and delivery dates/times for a part to a plant dock. Captures schedule line date, time, required quantity, cumulative quantity, schedule type (firm, forecast, JIS sequence), dock door, and transmission status (sent, acknowledged, revised). Drives supplier production and logistics planning. Sourced from SAP MM schedule lines (EKET).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` (
    `supply_ppap_submission_id` BIGINT COMMENT 'Primary key for local supply_ppap_submission reference',
    `quality_ppap_submission_id` BIGINT COMMENT 'FK reference to SSOT quality.quality_ppap_submission',
    CONSTRAINT pk_supply_ppap_submission PRIMARY KEY(`supply_ppap_submission_id`)
) COMMENT 'Reference to SSOT owner quality.quality_ppap_submission. Production Part Approval Process submission record tracking the formal approval of a suppliers manufacturing process for a specific part. Captures PPAP level (1–5), submission date, part number, supplier, engineering change level, submission reason (new part, engineering change, tooling move), PPAP elements checklist status, PSW (Part Submission Warrant) status, and approval/rejection date. Integrates with PTC Windchill and SAP QM. SSOT for PPAP compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`ppap_element` (
    `ppap_element_id` BIGINT COMMENT '',
    `procurement_supplier_id` BIGINT COMMENT '',
    `supply_ppap_submission_id` BIGINT COMMENT '',
    `approved_timestamp` TIMESTAMP COMMENT '',
    `compliance_standard` STRING COMMENT '',
    `created_by_user` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `defect_rate_ppm` DECIMAL(18,2) COMMENT '',
    `document_format` STRING COMMENT '',
    `document_reference` STRING COMMENT '',
    `due_date` DATE COMMENT '',
    `element_code` STRING COMMENT '',
    `element_name` STRING COMMENT '',
    `element_type` STRING COMMENT '',
    `element_version` STRING COMMENT '',
    `file_size_bytes` BIGINT COMMENT '',
    `is_confidential` BOOLEAN COMMENT '',
    `last_reviewed_by` STRING COMMENT '',
    `part_number` STRING COMMENT '',
    `part_revision` STRING COMMENT '',
    `quality_metric` STRING COMMENT '',
    `required_flag` BOOLEAN COMMENT '',
    `review_date` DATE COMMENT '',
    `reviewer_comments` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT ppap_submission owned by quality domain via FK.',
    `submission_status` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_ppap_element PRIMARY KEY(`ppap_element_id`)
) COMMENT 'Individual PPAP element or deliverable within a PPAP submission, such as Design Records, PFMEA, Control Plan, MSA, SPC studies, or PSW. Captures element type (per AIAG PPAP standard), required flag, submission status (not started, submitted, approved, rejected), reviewer comments, and document reference. Enables granular tracking of PPAP completeness and compliance against IATF 16949 requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` (
    `inbound_shipment_id` BIGINT COMMENT '',
    `carrier_id` BIGINT COMMENT '',
    `compliance_document_id` BIGINT COMMENT '',
    `procurement_purchase_order_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `regulatory_requirement_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `actual_arrival_timestamp` TIMESTAMP COMMENT '',
    `asn_number` STRING COMMENT '',
    `carrier_scac` STRING COMMENT '',
    `container_count` STRING COMMENT '',
    `currency_code` STRING COMMENT '',
    `customs_declaration_number` STRING COMMENT '',
    `delivery_window_end` TIMESTAMP COMMENT '',
    `delivery_window_start` TIMESTAMP COMMENT '',
    `departure_timestamp` TIMESTAMP COMMENT '',
    `estimated_arrival_timestamp` TIMESTAMP COMMENT '',
    `freight_cost` DECIMAL(18,2) COMMENT '',
    `hazardous_class` STRING COMMENT '',
    `incoterm` STRING COMMENT '',
    `is_expedited` BOOLEAN COMMENT '',
    `is_hazardous` BOOLEAN COMMENT '',
    `last_status_update_timestamp` TIMESTAMP COMMENT '',
    `material_group` STRING COMMENT '',
    `mode_of_transport` STRING COMMENT '',
    `pallet_count` STRING COMMENT '',
    `record_created_timestamp` TIMESTAMP COMMENT '',
    `record_updated_timestamp` TIMESTAMP COMMENT '',
    `remarks` STRING COMMENT '',
    `shipment_status` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `temperature_control_required` BOOLEAN COMMENT '',
    `temperature_max_c` DECIMAL(18,2) COMMENT '',
    `temperature_min_c` DECIMAL(18,2) COMMENT '',
    `total_volume_m3` DECIMAL(18,2) COMMENT '',
    `total_weight_kg` DECIMAL(18,2) COMMENT '',
    CONSTRAINT pk_inbound_shipment PRIMARY KEY(`inbound_shipment_id`)
) COMMENT 'Tracks an inbound shipment of parts from a supplier plant to an OEM receiving dock. Captures ASN (Advance Shipping Notice) number, carrier, mode of transport (road, rail, air, sea), departure date/time, estimated arrival date/time, actual arrival date/time, total weight, total volume, number of containers/pallets, customs declaration number, and shipment status (in transit, arrived, cleared, received). Integrates with SAP MM inbound delivery (VL31N).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` (
    `supply_goods_receipt_id` BIGINT COMMENT 'Primary key for local supply_goods_receipt reference',
    `procurement_goods_receipt_id` BIGINT COMMENT 'FK reference to SSOT procurement.procurement_goods_receipt',
    CONSTRAINT pk_supply_goods_receipt PRIMARY KEY(`supply_goods_receipt_id`)
) COMMENT 'Reference to SSOT owner procurement.procurement_goods_receipt. Records the physical receipt and system confirmation of parts delivered by a supplier to an OEM plant. Captures GR document number, posting date, received quantity, accepted quantity, rejected quantity, storage location, batch number, GR type (standard, return, subsequent delivery), and posting status. Triggers inventory update and initiates 3-way invoice matching in SAP MM (MIGO). SSOT for inbound goods confirmation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` (
    `ckd_kit_id` BIGINT COMMENT '',
    `compliance_document_id` BIGINT COMMENT '',
    `configuration_id` BIGINT COMMENT '',
    `model_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `supplier_contract_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `actual_arrival_date` DATE COMMENT '',
    `compliance_certifications` STRING COMMENT '',
    `currency_code` STRING COMMENT '',
    `dispatch_date` DATE COMMENT '',
    `effective_end_date` DATE COMMENT '',
    `effective_start_date` DATE COMMENT '',
    `expected_arrival_date` DATE COMMENT '',
    `export_customs_classification` STRING COMMENT '',
    `hazardous_material_description` STRING COMMENT '',
    `hazardous_material_flag` BOOLEAN COMMENT '',
    `incoterms` STRING COMMENT '',
    `inspection_result` STRING COMMENT '',
    `kit_content_description` STRING COMMENT '',
    `kit_number` STRING COMMENT '',
    `kit_status` STRING COMMENT '',
    `kit_type` STRING COMMENT '',
    `kit_value_usd` DECIMAL(18,2) COMMENT '',
    `last_inspection_date` DATE COMMENT '',
    `model_year` STRING COMMENT '',
    `notes` STRING COMMENT '',
    `packing_specification` STRING COMMENT '',
    `ppap_document_reference` STRING COMMENT '',
    `ppap_status` STRING COMMENT '',
    `quality_status` STRING COMMENT '',
    `record_audit_created` TIMESTAMP COMMENT '',
    `record_audit_updated` TIMESTAMP COMMENT '',
    `regulatory_approval_date` DATE COMMENT '',
    `regulatory_approval_status` STRING COMMENT '',
    `regulatory_body` STRING COMMENT '',
    `resource_lifecycle_status` STRING COMMENT '',
    `seal_number` STRING COMMENT '',
    `shipping_container_number` STRING COMMENT '',
    `shipping_method` STRING COMMENT '',
    `special_instructions` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `target_plant_code` STRING COMMENT '',
    `target_plant_name` STRING COMMENT '',
    `total_parts_count` STRING COMMENT '',
    `total_volume_cbm` DECIMAL(18,2) COMMENT '',
    `total_weight_kg` DECIMAL(18,2) COMMENT '',
    `tracking_number` STRING COMMENT '',
    `warranty_period_months` STRING COMMENT '',
    `warranty_terms` STRING COMMENT '',
    CONSTRAINT pk_ckd_kit PRIMARY KEY(`ckd_kit_id`)
) COMMENT 'Master record for a Completely Knocked Down (CKD) or Semi Knocked Down (SKD) kit assembled for export to a global assembly operation. Captures kit number, kit type (CKD/SKD), target assembly plant, model year, vehicle configuration, kit content list, packing specification, export customs classification, and kit lifecycle status. Supports global assembly operations where vehicles are shipped as kits for local assembly.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` (
    `ckd_shipment_id` BIGINT COMMENT '',
    `ckd_kit_shipment_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `actual_arrival_date` DATE COMMENT '',
    `bill_of_lading` STRING COMMENT '',
    `ckd_shipment_status` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `customs_clearance_status` STRING COMMENT '',
    `departure_date` DATE COMMENT '',
    `departure_timestamp` TIMESTAMP COMMENT '',
    `destination_plant_code` STRING COMMENT '',
    `estimated_arrival_date` DATE COMMENT '',
    `export_declaration_number` STRING COMMENT '',
    `freight_cost` DECIMAL(18,2) COMMENT '',
    `freight_currency` STRING COMMENT '',
    `freight_terms` STRING COMMENT '',
    `hazardous_material_flag` BOOLEAN COMMENT '',
    `incoterms` STRING COMMENT '',
    `kit_count` BIGINT COMMENT '',
    `origin_plant_code` STRING COMMENT '',
    `seal_number` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `temperature_control_flag` BOOLEAN COMMENT '',
    `total_value` DECIMAL(18,2) COMMENT '',
    `tracking_number` STRING COMMENT '',
    `transport_mode` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `volume_m3` DECIMAL(18,2) COMMENT '',
    `weight_kg` DECIMAL(18,2) COMMENT '',
    CONSTRAINT pk_ckd_shipment PRIMARY KEY(`ckd_shipment_id`)
) COMMENT 'Transactional record of a CKD/SKD kit shipment from the OEM source plant to a global assembly destination. Captures shipment number, origin plant, destination assembly plant, vessel/flight number, bill of lading, export declaration number, departure date, estimated arrival date, kit count, total value, currency, and customs clearance status. Enables end-to-end tracking of global CKD/SKD supply flows.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` (
    `supplier_scorecard_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `compliance_score` DECIMAL(18,2) COMMENT '',
    `corrective_action_description` STRING COMMENT '',
    `corrective_action_flag` BOOLEAN COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `delivery_quantity_accuracy_pct` DECIMAL(18,2) COMMENT '',
    `evaluation_date` TIMESTAMP COMMENT '',
    `evaluation_period_end` DATE COMMENT '',
    `evaluation_period_start` DATE COMMENT '',
    `evaluator_name` STRING COMMENT '',
    `notes` STRING COMMENT '',
    `otd_percentage` DECIMAL(18,2) COMMENT '',
    `overall_score` DECIMAL(18,2) COMMENT '',
    `performance_tier` STRING COMMENT '',
    `ppap_on_time_completion_rate` DECIMAL(18,2) COMMENT '',
    `ppm_defect_rate` DECIMAL(18,2) COMMENT '',
    `responsiveness_score` DECIMAL(18,2) COMMENT '',
    `review_status` STRING COMMENT '',
    `risk_score` DECIMAL(18,2) COMMENT '',
    `scorecard_number` STRING COMMENT '',
    `scoring_methodology_version` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `supplier_scorecard_status` STRING COMMENT '',
    `sustainability_score` DECIMAL(18,2) COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_supplier_scorecard PRIMARY KEY(`supplier_scorecard_id`)
) COMMENT 'Periodic (monthly/quarterly) performance evaluation record for a supplier across key KPIs including PPM (Parts Per Million defect rate), OTD (On-Time Delivery percentage), delivery quantity accuracy, PPAP on-time completion rate, responsiveness score, and overall supplier rating. Captures evaluation period, scoring methodology version, individual KPI values, weighted total score, performance tier (preferred, approved, conditional, disqualified), and corrective action flag.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` (
    `supplier_deviation_id` BIGINT COMMENT '',
    `obligation_id` BIGINT COMMENT '',
    `procurement_purchase_order_id` BIGINT COMMENT '',
    `sku_master_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `approval_timestamp` TIMESTAMP COMMENT '',
    `approved_by` BIGINT COMMENT '',
    `authorized_cost` DECIMAL(18,2) COMMENT '',
    `comments` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `supplier_deviation_description` STRING COMMENT '',
    `deviation_number` STRING COMMENT '',
    `deviation_type` STRING COMMENT '',
    `disposition` STRING COMMENT '',
    `effective_timestamp` TIMESTAMP COMMENT '',
    `engineering_approval_status` STRING COMMENT '',
    `expiration_timestamp` TIMESTAMP COMMENT '',
    `is_temporary_flag` BOOLEAN COMMENT '',
    `part_name` STRING COMMENT '',
    `part_number` STRING COMMENT '',
    `priority` STRING COMMENT '',
    `quality_hold_flag` BOOLEAN COMMENT '',
    `quantity_authorized` DECIMAL(18,2) COMMENT '',
    `related_ecn_number` STRING COMMENT '',
    `related_ppap_status` STRING COMMENT '',
    `request_timestamp` TIMESTAMP COMMENT '',
    `risk_rating` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `supplier_deviation_status` STRING COMMENT '',
    `unit_of_measure` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `validity_end_date` DATE COMMENT '',
    `validity_start_date` DATE COMMENT '',
    CONSTRAINT pk_supplier_deviation PRIMARY KEY(`supplier_deviation_id`)
) COMMENT 'Formal record of a supplier request for deviation or waiver to ship non-conforming parts or use an alternative process temporarily. Captures deviation number, part number, deviation type (dimensional, material, process), quantity authorized, validity period, engineering approval status, quality hold flag, and disposition (use-as-is, rework, scrap). Supports IATF 16949 non-conformance management and traceability.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` (
    `supply_corrective_action_id` BIGINT COMMENT '',
    `quality_corrective_action_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT corrective_action owned by quality domain via FK.',
    CONSTRAINT pk_supply_corrective_action PRIMARY KEY(`supply_corrective_action_id`)
) COMMENT 'Supplier corrective action request (SCAR) issued when a supplier fails to meet quality, delivery, or compliance requirements. Captures SCAR number, triggering event (PPM breach, OTD failure, audit finding), root cause category, 8D report reference, containment action, permanent corrective action, verification date, and closure status. Drives supplier development and continuous improvement programs.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` (
    `supplier_audit_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `audit_date` DATE COMMENT '',
    `audit_location` STRING COMMENT '',
    `audit_method` STRING COMMENT '',
    `audit_number` STRING COMMENT '',
    `audit_report_document` STRING COMMENT '',
    `audit_standard` STRING COMMENT '',
    `audit_type` STRING COMMENT '',
    `auditor_email` STRING COMMENT '',
    `auditor_name` STRING COMMENT '',
    `auditor_phone` STRING COMMENT '',
    `closure_date` DATE COMMENT '',
    `closure_status` STRING COMMENT '',
    `comments` STRING COMMENT '',
    `findings_major_count` STRING COMMENT '',
    `findings_minor_count` STRING COMMENT '',
    `findings_observation_count` STRING COMMENT '',
    `lifecycle_status` STRING COMMENT '',
    `overall_score` DECIMAL(18,2) COMMENT '',
    `re_audit_required` BOOLEAN COMMENT '',
    `record_audit_created` TIMESTAMP COMMENT '',
    `record_audit_updated` TIMESTAMP COMMENT '',
    `risk_rating` STRING COMMENT '',
    `scope_description` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    CONSTRAINT pk_supplier_audit PRIMARY KEY(`supplier_audit_id`)
) COMMENT 'Record of a formal quality or process audit conducted at a supplier facility. Captures audit type (system audit, process audit, product audit, layered process audit), audit date, auditor name, scope, findings count by severity (major, minor, observation), overall audit score, re-audit required flag, and closure status. Supports IATF 16949 supplier monitoring and development obligations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` (
    `inbound_inspection_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT '',
    `primary_employee_id` BIGINT COMMENT '',
    `procurement_supplier_id` BIGINT COMMENT '',
    `sku_id` BIGINT COMMENT '',
    `sku_master_id` BIGINT COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `defect_count` STRING COMMENT '',
    `defect_rate_ppm` DECIMAL(18,2) COMMENT '',
    `defect_type_codes` STRING COMMENT '',
    `disposition` STRING COMMENT '',
    `inspection_location` STRING COMMENT '',
    `inspection_lot_number` STRING COMMENT '',
    `inspection_method` STRING COMMENT '',
    `inspection_result` STRING COMMENT '',
    `inspection_status` STRING COMMENT '',
    `inspection_timestamp` TIMESTAMP COMMENT '',
    `part_number` STRING COMMENT '',
    `part_revision` STRING COMMENT '',
    `sample_size` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_inbound_inspection PRIMARY KEY(`inbound_inspection_id`)
) COMMENT 'Incoming quality inspection record for parts received from a supplier at an OEM plant. Captures inspection lot number, inspection date, part number, supplier, sample size, inspection method (AQL sampling, 100% check, skip-lot), number of defects found, defect type codes, inspection result (pass, fail, conditional release), and disposition (accept, return to supplier, sort and use). Integrates with SAP QM inspection lots.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`disruption` (
    `disruption_id` BIGINT COMMENT '',
    `inbound_part_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    CONSTRAINT pk_disruption PRIMARY KEY(`disruption_id`)
) COMMENT 'Records a supply disruption event where a supplier is unable to meet scheduled delivery commitments due to capacity issues, natural disasters, labor actions, logistics failures, or quality holds. Captures disruption type, affected parts, impacted plants, start date, expected resolution date, severity (critical, major, minor), mitigation actions taken (alternative sourcing, expedite, safety stock draw), and financial impact estimate. Supports supply risk management and business continuity planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` (
    `tooling_asset_id` BIGINT COMMENT '',
    `compliance_document_id` BIGINT COMMENT '',
    `fixed_asset_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `acquisition_cost` DECIMAL(18,2) COMMENT '',
    `acquisition_currency` STRING COMMENT '',
    `acquisition_date` DATE COMMENT '',
    `commissioning_date` DATE COMMENT '',
    `compliance_standard` STRING COMMENT '',
    `condition` STRING COMMENT '',
    `country_code` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `depreciation_method` STRING COMMENT '',
    `inspection_status` STRING COMMENT '',
    `last_inspection_date` DATE COMMENT '',
    `maintenance_cost_total` DECIMAL(18,2) COMMENT '',
    `maintenance_last_date` DATE COMMENT '',
    `maintenance_next_date` DATE COMMENT '',
    `maintenance_type` STRING COMMENT '',
    `next_inspection_due` DATE COMMENT '',
    `ownership_type` STRING COMMENT '',
    `part_number` STRING COMMENT '',
    `plant_code` STRING COMMENT '',
    `regulatory_approval_date` DATE COMMENT '',
    `regulatory_approval_required` BOOLEAN COMMENT '',
    `regulatory_approval_status` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `status_change_date` DATE COMMENT '',
    `supplier_location` STRING COMMENT '',
    `tool_description` STRING COMMENT '',
    `tool_life_remaining` BIGINT COMMENT '',
    `tool_life_total` BIGINT COMMENT '',
    `tool_life_type` STRING COMMENT '',
    `tool_life_used` BIGINT COMMENT '',
    `tool_number` STRING COMMENT '',
    `tool_type` STRING COMMENT '',
    `tooling_asset_status` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `warranty_end_date` DATE COMMENT '',
    `warranty_provider` STRING COMMENT '',
    `warranty_start_date` DATE COMMENT '',
    CONSTRAINT pk_tooling_asset PRIMARY KEY(`tooling_asset_id`)
) COMMENT 'Master record for OEM-owned production tooling (dies, molds, jigs, fixtures, checking gauges) physically located at supplier facilities. Captures tool number, tool type, part number produced, supplier plant location, ownership classification (OEM-owned per IATF 16949 §8.5.3), acquisition cost, net book value, tool life capacity (shots/cycles), current utilization, last maintenance/inspection date, and lifecycle status (active, under repair, awaiting transfer, end-of-life). Supports tooling investment tracking, PPAP tooling records, and supplier exit/transition planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`price_agreement` (
    `price_agreement_id` BIGINT COMMENT '',
    `gl_account_id` BIGINT COMMENT '',
    `sku_id` BIGINT COMMENT '',
    `sku_master_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `actual_otd_percent` DECIMAL(18,2) COMMENT '',
    `actual_ppm` DECIMAL(18,2) COMMENT '',
    `agreement_number` STRING COMMENT '',
    `agreement_type` STRING COMMENT '',
    `annual_price_reduction_commitment` DECIMAL(18,2) COMMENT '',
    `compliance_approval_status` STRING COMMENT '',
    `compliance_document_ref` STRING COMMENT '',
    `contract_scope` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `price_agreement_description` STRING COMMENT '',
    `early_termination_allowed` BOOLEAN COMMENT '',
    `effective_end_date` DATE COMMENT '',
    `effective_start_date` DATE COMMENT '',
    `part_number` STRING COMMENT '',
    `payment_terms` STRING COMMENT '',
    `penalty_clause` STRING COMMENT '',
    `price_adjustment_trigger` STRING COMMENT '',
    `price_agreement_status` STRING COMMENT '',
    `renewal_notice_period_days` STRING COMMENT '',
    `renewal_option` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `target_otd_percent` DECIMAL(18,2) COMMENT '',
    `target_ppm` DECIMAL(18,2) COMMENT '',
    `termination_notice_period_days` STRING COMMENT '',
    `tooling_amortization_terms` STRING COMMENT '',
    `total_annual_volume` DECIMAL(18,2) COMMENT '',
    `unit_of_measure` STRING COMMENT '',
    `unit_price` DECIMAL(18,2) COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `version_number` STRING COMMENT '',
    CONSTRAINT pk_price_agreement PRIMARY KEY(`price_agreement_id`)
) COMMENT 'Formally agreed piece price and commercial terms between the OEM and a supplier for a specific part over a defined period. Captures agreement number, part number, supplier, effective date, expiry date, agreed unit price, currency, annual price reduction commitment (APR), tooling amortization terms, price adjustment triggers (material index, FX), and agreement status (active, expired, under negotiation). Distinct from the purchase order — this is the commercial price framework.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_event` (
    `inbound_event_id` BIGINT COMMENT '',
    `inbound_shipment_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    CONSTRAINT pk_inbound_event PRIMARY KEY(`inbound_event_id`)
) COMMENT 'Milestone and exception event log for inbound supply chain activities, capturing key status transitions such as ASN received, customs cleared, dock arrival, goods receipt posted, quality hold placed, or delivery rejected. Captures event type, event timestamp, location, part number, shipment reference, responsible party, and event notes. Enables end-to-end supply chain visibility and exception management across the inbound supply network.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`commodity_group` (
    `commodity_group_id` BIGINT COMMENT '',
    `parent_commodity_group_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `applicable_regions` STRING COMMENT '',
    `average_cost_usd` DECIMAL(18,2) COMMENT '',
    `commodity_group_code` STRING COMMENT '',
    `commodity_category` STRING COMMENT '',
    `commodity_code` STRING COMMENT '',
    `commodity_group_status` STRING COMMENT '',
    `commodity_group_type` STRING COMMENT '',
    `commodity_manager` STRING COMMENT '',
    `compliance_standards` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `commodity_group_description` STRING COMMENT '',
    `effective_end_date` DATE COMMENT '',
    `effective_from` DATE COMMENT '',
    `effective_start_date` DATE COMMENT '',
    `effective_until` DATE COMMENT '',
    `hazardous_material_description` STRING COMMENT '',
    `hazardous_material_flag` BOOLEAN COMMENT '',
    `is_confidential` BOOLEAN COMMENT '',
    `is_global` BOOLEAN COMMENT '',
    `lead_time_max_days` STRING COMMENT '',
    `lead_time_min_days` STRING COMMENT '',
    `commodity_group_name` STRING COMMENT '',
    `notes` STRING COMMENT '',
    `regulatory_compliance_flag` BOOLEAN COMMENT '',
    `risk_factor` STRING COMMENT '',
    `risk_score` DECIMAL(18,2) COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    `strategic_classification` STRING COMMENT '',
    `sustainability_score` DECIMAL(18,2) COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_commodity_group PRIMARY KEY(`commodity_group_id`)
) COMMENT 'Master reference table for commodity_group. ';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` (
    `supply_agreement_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'SSOT owner for supply_agreement entity. Other domains reference this via FK.',
    CONSTRAINT pk_supply_agreement PRIMARY KEY(`supply_agreement_id`)
) COMMENT 'Represents a contractual relationship between a supply_supplier and a vehicle SKU. Each record captures the terms under which a supplier provides parts for a specific SKU, including lead time, cost, pricing unit, lifecycle status, and the effective date range.. Existence Justification: A tier‑1 or tier‑2 supplier can provide parts for many vehicle SKUs, and a given SKU can be sourced from multiple suppliers. The business actively manages each supplier‑SKU pairing as a supply agreement, tracking lead times, costs, pricing units, lifecycle status, and effective dates.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` (
    `supplier_nomination_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    CONSTRAINT pk_supplier_nomination PRIMARY KEY(`supplier_nomination_id`)
) COMMENT 'This association captures the contractual nomination of a supply_supplier to a model_year_program, including the volume, price, currency, status, and risk rating agreed for that program.. Existence Justification: A supplier can be nominated for multiple model year programs, providing volume and price terms for each. Conversely, each model year program sources parts from many suppliers. The nomination itself is managed as a contract with its own attributes (volume, price, status, risk).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` (
    `supplier_compliance_assignment_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    CONSTRAINT pk_supplier_compliance_assignment PRIMARY KEY(`supplier_compliance_assignment_id`)
) COMMENT 'Represents the assignment of a compliance obligation to a supplier, capturing the status, effective period, and priority of the responsibility. Each record links one supplier to one compliance obligation and stores attributes that exist only in the context of this relationship.. Existence Justification: A supplier may be responsible for multiple regulatory compliance obligations, and a single compliance obligation often requires participation from multiple suppliers. The business actively tracks each supplier‑obligation link with status, effective dates, and priority, making the relationship a managed entity rather than a simple lookup.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_scheduling_agreement` (
    `supply_scheduling_agreement_id` BIGINT COMMENT '',
    `supply_supplier_id` BIGINT COMMENT '',
    `ssot_governance_note` STRING COMMENT 'References SSOT supplier owned by procurement domain via FK.',
    CONSTRAINT pk_supply_scheduling_agreement PRIMARY KEY(`supply_scheduling_agreement_id`)
) COMMENT 'Supply domain product: scheduling agreement';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ADD CONSTRAINT `fk_supply_supplier_part_approval_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` ADD CONSTRAINT `fk_supply_supply_supplier_plant_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ADD CONSTRAINT `fk_supply_sourcing_nomination_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ADD CONSTRAINT `fk_supply_rfq_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ADD CONSTRAINT `fk_supply_rfq_response_rfq_id` FOREIGN KEY (`rfq_id`) REFERENCES `vibe_automotive_v1`.`supply`.`rfq`(`rfq_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ADD CONSTRAINT `fk_supply_rfq_response_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ADD CONSTRAINT `fk_supply_ppap_element_supply_ppap_submission_id` FOREIGN KEY (`supply_ppap_submission_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_ppap_submission`(`supply_ppap_submission_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ADD CONSTRAINT `fk_supply_ckd_kit_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ADD CONSTRAINT `fk_supply_ckd_shipment_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ADD CONSTRAINT `fk_supply_supplier_scorecard_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ADD CONSTRAINT `fk_supply_supplier_deviation_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ADD CONSTRAINT `fk_supply_supply_corrective_action_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ADD CONSTRAINT `fk_supply_supplier_audit_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` ADD CONSTRAINT `fk_supply_disruption_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` ADD CONSTRAINT `fk_supply_disruption_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ADD CONSTRAINT `fk_supply_tooling_asset_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ADD CONSTRAINT `fk_supply_price_agreement_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` ADD CONSTRAINT `fk_supply_inbound_event_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` ADD CONSTRAINT `fk_supply_inbound_event_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ADD CONSTRAINT `fk_supply_commodity_group_parent_commodity_group_id` FOREIGN KEY (`parent_commodity_group_id`) REFERENCES `vibe_automotive_v1`.`supply`.`commodity_group`(`commodity_group_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ADD CONSTRAINT `fk_supply_commodity_group_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ADD CONSTRAINT `fk_supply_supply_agreement_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ADD CONSTRAINT `fk_supply_supplier_nomination_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` ADD CONSTRAINT `fk_supply_supplier_compliance_assignment_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_scheduling_agreement` ADD CONSTRAINT `fk_supply_supply_scheduling_agreement_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`supply` SET TAGS ('dbx_pii_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`supply` SET TAGS ('dbx_pii_domain' = 'supply');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` SET TAGS ('dbx_pii_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` SET TAGS ('dbx_pii_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` SET TAGS ('dbx_pii_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sourcing_buyer_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sourcing_buyer_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_buyer_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_buyer_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `delivery_address` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `delivery_address` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` SET TAGS ('dbx_pii_subdomain' = 'inbound_logistics');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` SET TAGS ('dbx_pii_subdomain' = 'inbound_logistics');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` SET TAGS ('dbx_pii_subdomain' = 'inbound_logistics');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` SET TAGS ('dbx_pii_subdomain' = 'inbound_logistics');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` SET TAGS ('dbx_pii_subdomain' = 'inbound_logistics');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` SET TAGS ('dbx_pii_subdomain' = 'inbound_logistics');
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` SET TAGS ('dbx_pii_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` SET TAGS ('dbx_pii_subdomain' = 'inbound_logistics');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` SET TAGS ('dbx_pii_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` SET TAGS ('dbx_pii_association_edges' = 'supply.supply_supplier,product.sku');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` SET TAGS ('dbx_pii_association_edges' = 'supply.supply_supplier,product.model_year_program');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` SET TAGS ('dbx_pii_subdomain' = 'supplier_quality');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` SET TAGS ('dbx_pii_association_edges' = 'supply.supply_supplier,compliance.compliance_obligation');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_scheduling_agreement` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_scheduling_agreement` SET TAGS ('dbx_pii_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_scheduling_agreement` SET TAGS ('dbx_pii_domain' = 'supply');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_scheduling_agreement` SET TAGS ('dbx_pii_ecm_scope' = 'true');
