-- Schema for Domain: supply | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:24

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`supply` COMMENT 'Governs the inbound supply chain from tier-1 and tier-2 suppliers through to plant receiving. Owns supplier master data, RFQ (Request for Quotation) events, PPAP (Production Part Approval Process) records, JIT/JIS delivery schedules, inbound logistics, supplier performance metrics (PPM - Parts Per Million defect rates, OTD - On-Time Delivery), and CKD/SKD kit management for global assembly operations. Integrates with SAP MM and PTC Windchill.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` (
    `supplier_part_approval_id` BIGINT COMMENT 'System generated unique identifier for the supplier part approval record.',
    `employee_id` BIGINT COMMENT 'System identifier of the approver.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: PPAP approval records must be tied to the supplier entity in the supply domain for audit and traceability.',
    `approval_date` DATE COMMENT 'Date the approval decision was recorded.',
    `approval_number` STRING COMMENT 'External business identifier assigned to the approval record, often used in audit and reporting.',
    `approval_outcome` STRING COMMENT 'Result of the PPAP review: approved, interim approval, or rejected.. Valid values are `approved|interim_approval|rejected`',
    `approval_score` DECIMAL(18,2) COMMENT 'Numeric score (0‑100) reflecting overall assessment of the parts compliance.',
    `approver_name` STRING COMMENT 'Name of the engineer or manager who approved the part.',
    `capability_study_status` STRING COMMENT 'Status of the capability study element.. Valid values are `completed|pending|not_applicable`',
    `classification` STRING COMMENT 'Business classification indicating the importance of the part.. Valid values are `critical|major|minor|optional`',
    `comments` STRING COMMENT 'Free‑form notes entered by reviewers or approvers.',
    `control_plan_status` STRING COMMENT 'Status of the control plan element.. Valid values are `completed|pending|not_applicable`',
    `cost_usd` DECIMAL(18,2) COMMENT 'Approved cost of the part in US dollars.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the approval record was first created in the system.',
    `design_records_status` STRING COMMENT 'Status of the design records element within the PPAP package.. Valid values are `completed|pending|not_applicable`',
    `expiry_date` DATE COMMENT 'Date after which the approval is no longer valid.',
    `lead_time_days` STRING COMMENT 'Standard lead time in days for the part from supplier to plant.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle stage of the approval record.. Valid values are `draft|submitted|under_review|approved|rejected|expired`',
    `msa_status` STRING COMMENT 'Status of the MSA element.. Valid values are `completed|pending|not_applicable`',
    `overall_status` STRING COMMENT 'Aggregated status of the approval record.. Valid values are `active|inactive|expired|revoked`',
    `part_name` STRING COMMENT 'Human‑readable name or description of the part.',
    `part_number` STRING COMMENT 'Manufacturer part number of the component being approved.',
    `pfmea_status` STRING COMMENT 'Status of the Process FMEA element.. Valid values are `completed|pending|not_applicable`',
    `ppap_submission_level` STRING COMMENT 'Level of PPAP submission (1‑5) indicating the depth of documentation provided.. Valid values are `level_1|level_2|level_3|level_4|level_5`',
    `quality_rating` STRING COMMENT 'Quality rating assigned to the part after approval.. Valid values are `A|B|C|D|E|F`',
    `record_audit_created` TIMESTAMP COMMENT 'Audit timestamp for the creation event of the record.',
    `record_audit_updated` TIMESTAMP COMMENT 'Audit timestamp for the most recent modification of the record.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the part meets all applicable regulatory requirements.',
    `risk_level` STRING COMMENT 'Risk level associated with the part based on failure mode analysis.. Valid values are `high|medium|low`',
    `sample_parts_status` STRING COMMENT 'Status of the sample parts element.. Valid values are `completed|pending|not_applicable`',
    `submission_date` DATE COMMENT 'Date the supplier submitted the PPAP package.',
    `supplier_name` STRING COMMENT 'Legal name of the supplier organization.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the approval record.',
    CONSTRAINT pk_supplier_part_approval PRIMARY KEY(`supplier_part_approval_id`)
) COMMENT 'PPAP (Production Part Approval Process) record capturing the formal approval of a supplier-produced part for use in production. Includes approval ID, part number, supplier reference, PPAP submission level (1–5), submission date, approval date, approver, PPAP elements status (design records, PFMEA, control plan, MSA, capability study, sample parts), approval outcome (approved, interim approval, rejected), and expiry date. Mandated by IATF 16949 and AIAG PPAP standards for all production parts.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` (
    `supply_supplier_id` BIGINT COMMENT 'Unique identifier for the supply_supplier data product (auto-inserted pre-linking).',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Supplier Jurisdiction Registry links a supplier to the jurisdiction where it operates for tax and regulatory reporting.',
    `procurement_supplier_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_supplier (cross-domain duplicate reconciliation; procurement designated SSOT owner for supplier).',
    CONSTRAINT pk_supply_supplier PRIMARY KEY(`supply_supplier_id`)
) COMMENT 'Master record for all tier-1 and tier-2 suppliers in the automotive supply chain. Captures supplier identity, classification (direct/indirect, tier level), IATF 16949 certification status, DUNS number, geographic footprint, commodity codes, preferred currency, payment terms, and supplier lifecycle status (active, probation, disqualified). SSOT for supplier identity within the supply domain; integrates with SAP MM vendor master and PTC Windchill supplier collaboration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` (
    `supply_supplier_plant_id` BIGINT COMMENT 'Unique identifier for the supply_supplier_plant data product (auto-inserted pre-linking).',
    `procurement_supplier_plant_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_supplier_plant (cross-domain duplicate reconciliation; procurement designated SSOT owner for supplier_plant).',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link child plant to its supplier master for in‑domain hierarchy',
    CONSTRAINT pk_supply_supplier_plant PRIMARY KEY(`supply_supplier_plant_id`)
) COMMENT 'Represents the specific manufacturing or distribution plant/site of a supplier that ships parts to an OEM assembly plant. Captures plant address, plant code, production capabilities, capacity constraints, dock-to-dock lead time, customs zone, and plant-level quality certifications. Enables JIT/JIS scheduling at the plant-to-plant level and supports CKD/SKD kit origin tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_part` (
    `inbound_part_id` BIGINT COMMENT 'System-generated unique identifier for the inbound part record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Part Certification Management process stores the compliance document (e.g., type‑approval) associated with each inbound part.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Material receipt cost is allocated to a Cost Center for inventory valuation and variance analysis.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Inbound receipt process matches each received part to the engineering part master for quality verification and BOM reconciliation.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Regulatory Requirement Mapping report links each inbound part to the regulatory requirement it must satisfy for emissions and safety compliance.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Receiving process matches inbound parts to SKU master to create accurate stock records; essential for inventory posting.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Connect inbound part to internal supplier master for analytics',
    `average_cost` DECIMAL(18,2) COMMENT 'Weighted average purchase cost per unit of the part.',
    `commodity_group` STRING COMMENT 'High‑level classification of the part for procurement and reporting.. Valid values are `engine|transmission|chassis|electrical|interior|exterior`',
    `country_of_origin` STRING COMMENT 'Three‑letter ISO code of the country where the part was manufactured.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the inbound part record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the parts cost.. Valid values are `^[A-Z]{3}$`',
    `customs_tariff_code` STRING COMMENT 'HS‑8 tariff classification code used for import duties.. Valid values are `^[0-9]{8}$`',
    `effective_from` DATE COMMENT 'Date from which the part information is considered valid.',
    `effective_until` DATE COMMENT 'Date after which the part information is no longer valid (nullable).',
    `engineering_change_level` STRING COMMENT 'Level of engineering change applied to the part (e.g., A‑E).. Valid values are `A|B|C|D|E`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the part is classified as hazardous under regulatory rules.',
    `height_mm` DECIMAL(18,2) COMMENT 'Physical height of the part in millimetres.',
    `last_received_date` DATE COMMENT 'Date when the part was most recently received at the plant.',
    `last_received_quantity` STRING COMMENT 'Quantity of the part received on the most recent receipt.',
    `lead_time_days` STRING COMMENT 'Planned number of days from order placement to receipt.',
    `length_mm` DECIMAL(18,2) COMMENT 'Physical length of the part in millimetres.',
    `lifecycle_status` STRING COMMENT 'Current operational status of the part within the supply chain.. Valid values are `active|inactive|discontinued|pending`',
    `lot_size` STRING COMMENT 'Standard production batch size for the part.',
    `material_type` STRING COMMENT 'Category indicating whether the part is raw material, sub‑assembly, CKD kit, finished good, or service item.. Valid values are `raw|sub-assembly|ckd_kit|finished|service`',
    `minimum_order_quantity` STRING COMMENT 'Smallest quantity that can be ordered from the supplier.',
    `oem_part_number` STRING COMMENT 'Original Equipment Manufacturer part number used internally for cross‑reference.',
    `part_name` STRING COMMENT 'Human‑readable name or description of the purchased part.',
    `ppap_status` STRING COMMENT 'Current status of the Production Part Approval Process for the part.. Valid values are `approved|rejected|pending|under_review`',
    `price_uom` STRING COMMENT 'Unit of measure used for the price (e.g., each, kilogram).. Valid values are `EA|KG|L|M|SET`',
    `reorder_point_quantity` STRING COMMENT 'Inventory level that triggers a new purchase order.',
    `safety_stock_quantity` STRING COMMENT 'Buffer inventory quantity maintained to protect against supply variability.',
    `supplier_part_number` STRING COMMENT 'Identifier assigned by the external supplier to the part.',
    `unit_of_measure` STRING COMMENT 'Standard unit used for ordering and inventory management.. Valid values are `EA|KG|L|M|SET`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the record.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the part in kilograms.',
    `width_mm` DECIMAL(18,2) COMMENT 'Physical width of the part in millimetres.',
    CONSTRAINT pk_inbound_part PRIMARY KEY(`inbound_part_id`)
) COMMENT 'Master record for every purchased part number sourced from external suppliers. Captures OEM part number, supplier part number cross-reference, commodity group, material type (raw, sub-assembly, CKD kit), unit of measure, PPAP approval status, engineering change level, hazardous material flag, country of origin, and customs tariff code. Bridges SAP MM material master and PTC Windchill parts classification for supply-domain-owned purchased parts.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` (
    `sourcing_nomination_id` BIGINT COMMENT 'System-generated unique identifier for each sourcing nomination record.',
    `employee_id` BIGINT COMMENT 'Identifier of the internal commodity buyer responsible for the nomination.',
    `sourcing_employee_id` BIGINT COMMENT 'Identifier of the internal commodity buyer responsible for the nomination.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link sourcing nomination to internal supplier master',
    `comments` STRING COMMENT 'Additional notes or remarks entered by the buyer or sourcing team.',
    `commodity` STRING COMMENT 'High‑level classification of the part or commodity being nominated (e.g., ENGINE, HVAC, ELECTRICAL).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the nomination record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the target piece price.. Valid values are `USD|EUR|JPY|GBP|CAD|AUD`',
    `effective_end_date` DATE COMMENT 'Optional date when the nomination expires or is superseded.',
    `effective_start_date` DATE COMMENT 'Date from which the nomination becomes effective for planning purposes.',
    `is_jis` BOOLEAN COMMENT 'Indicates whether the nominated part is required under a JIS delivery strategy.',
    `is_jit` BOOLEAN COMMENT 'Indicates whether the nominated part is required under a JIT delivery strategy.',
    `kit_type` STRING COMMENT 'Specifies whether the part is supplied as a Completely Knocked Down (CKD) or Semi‑Knocked Down (SKD) kit, or not a kit.. Valid values are `CKD|SKD|none`',
    `model_year` STRING COMMENT 'Model year for which the part nomination applies.',
    `nominated_volume` DECIMAL(18,2) COMMENT 'Total quantity of the part the supplier is expected to deliver for the program.',
    `nomination_date` TIMESTAMP COMMENT 'Timestamp when the OEM formally recorded the nomination.',
    `nomination_number` STRING COMMENT 'Human‑readable business code assigned to the nomination for tracking and reference.',
    `nomination_status` STRING COMMENT 'Current lifecycle status of the nomination.. Valid values are `nominated|confirmed|withdrawn|rejected`',
    `part_number` STRING COMMENT 'Manufacturer part number or PLM identifier for the component subject to nomination.',
    `priority` STRING COMMENT 'Business priority assigned to the nomination for execution planning.. Valid values are `high|medium|low`',
    `program_code` STRING COMMENT 'Code identifying the vehicle program or platform associated with the nomination (e.g., SUV2025, EVX).',
    `region` STRING COMMENT 'Region code indicating the primary supply geography for the nominated part.. Valid values are `NAM|EME|APAC|LATAM|AFR`',
    `risk_rating` STRING COMMENT 'Qualitative assessment of supply risk for the nominated part.. Valid values are `low|medium|high`',
    `sor_reference` STRING COMMENT 'Reference code linking to the SOR document that defines functional and performance requirements.',
    `target_piece_price` DECIMAL(18,2) COMMENT 'Target unit price (per piece) the OEM aims to achieve with the nominated supplier.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the nomination record.',
    CONSTRAINT pk_sourcing_nomination PRIMARY KEY(`sourcing_nomination_id`)
) COMMENT 'Records the formal OEM decision to nominate a specific supplier for a given part or commodity within a model year program. Captures nomination date, program/platform code, nominated supplier, awarded annual volume, target piece price, SOR (Statement of Requirements) reference, nomination status (nominated, confirmed, withdrawn), and the responsible commodity buyer. Precedes the RFQ and PPAP process. SSOT for sourcing award decisions; distinct from procurement domains strategic sourcing strategy — this is the operational award record.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`rfq` (
    `rfq_id` BIGINT COMMENT 'System‑generated unique identifier for the RFQ record.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: RFQ generation is driven by engineering part definitions; linking to part_master enables accurate pricing and specification alignment.',
    `employee_id` BIGINT COMMENT 'Identifier of the internal buying organization or department originating the RFQ.',
    `rfq_employee_id` BIGINT COMMENT 'Identifier of the internal buying organization or department originating the RFQ.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Associate RFQ with internal supplier master',
    `approval_status` STRING COMMENT 'Current status of internal approval workflow.. Valid values are `PENDING|APPROVED|REJECTED`',
    `attachment_flag` BOOLEAN COMMENT 'Indicates whether supporting documents are attached to the RFQ.',
    `commodity_code` STRING COMMENT 'Standard industry code classifying the type of material or service requested.',
    `compliance_requirements` STRING COMMENT 'Regulatory or quality standards the supplier must meet (e.g., IATF 16949, ISO 14001).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the RFQ record was first created in the system.',
    `delivery_schedule_type` STRING COMMENT 'Preferred delivery methodology (Just‑In‑Time, Just‑In‑Sequence, or standard).. Valid values are `JIT|JIS|STANDARD`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Any discount the supplier proposes relative to the target price.',
    `issue_timestamp` TIMESTAMP COMMENT 'Date‑time when the RFQ was issued to suppliers.',
    `last_status_change_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent change to the RFQ status.',
    `net_price_amount` DECIMAL(18,2) COMMENT 'Net price after discounts, taxes, and fees.',
    `notes` STRING COMMENT 'Free‑form notes entered by the buyer.',
    `part_description` STRING COMMENT 'Free‑text description of the part or service requested.',
    `priority` STRING COMMENT 'Business priority assigned to the RFQ.. Valid values are `HIGH|MEDIUM|LOW`',
    `program_model_year` STRING COMMENT 'Vehicle program or model year for which the part is required.',
    `quantity_estimate` BIGINT COMMENT 'Projected annual volume the buyer expects to purchase.',
    `regulatory_approval_required` BOOLEAN COMMENT 'True if the part requires regulatory sign‑off before purchase.',
    `required_delivery_date` DATE COMMENT 'Date by which the part must be delivered to the plant.',
    `response_due_date` DATE COMMENT 'Last date on which suppliers may submit their quotations.',
    `rfq_number` STRING COMMENT 'Business‑visible RFQ number assigned by the sourcing system.',
    `rfq_status` STRING COMMENT 'Current lifecycle state of the RFQ.. Valid values are `draft|open|closed|awarded|cancelled|pending`',
    `rfq_type` STRING COMMENT 'Classification of the RFQ request.. Valid values are `NEW_PART|EXISTING_PART|SERVICE|MATERIAL`',
    `target_price_amount` DECIMAL(18,2) COMMENT 'Maximum price the buyer is willing to pay for the quoted item (gross).',
    `target_price_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the target price.',
    `tooling_description` STRING COMMENT 'Details of the tooling requirements, if any.',
    `tooling_required` BOOLEAN COMMENT 'Indicates whether new tooling is needed for the part.',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is expressed.. Valid values are `EA|KG|L|M|SET|BOX`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the RFQ record.',
    `created_by` STRING COMMENT 'User identifier of the employee who created the RFQ.',
    CONSTRAINT pk_rfq PRIMARY KEY(`rfq_id`)
) COMMENT 'Transactional record of a Request for Quotation event issued to one or more suppliers for a specific part, assembly, or service. Captures RFQ number, issue date, response due date, commodity, target price, annual volume estimate, program/model year, tooling requirements, and RFQ status (open, closed, awarded, cancelled). Integrates with SAP MM RFQ (ME41) and PTC Windchill supplier collaboration portal.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`rfq_response` (
    `rfq_response_id` BIGINT COMMENT 'System-generated unique identifier for the RFQ response record.',
    `rfq_id` BIGINT COMMENT 'Identifier of the original Request for Quotation to which this response belongs.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Associate RFQ response with internal supplier master',
    `amortization_term_months` STRING COMMENT 'Number of months over which the tooling cost is amortized.',
    `capacity_commitment` DECIMAL(18,2) COMMENT 'Maximum production capacity the supplier commits to deliver per period.',
    `capacity_unit` STRING COMMENT 'Unit for the capacity commitment (e.g., units_per_month).',
    `compliance_certifications` STRING COMMENT 'List of regulatory or industry certifications attached to the quotation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the RFQ response record was first created in the system.',
    `delivery_address` STRING COMMENT 'Physical address where the supplier will deliver the goods.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount offered on the quoted unit price.',
    `exceptions_to_sor` STRING COMMENT 'Supplier‑provided deviations or exceptions to the original SOR.',
    `freight_included` BOOLEAN COMMENT 'True if freight costs are included in the total price.',
    `is_preferred_supplier` BOOLEAN COMMENT 'Indicates whether the supplier is marked as a preferred source for this part.',
    `lead_time_days` STRING COMMENT 'Number of calendar days the supplier needs to deliver the quoted items after order confirmation.',
    `payment_terms` STRING COMMENT 'Standard payment condition offered by the supplier.. Valid values are `net30|net45|net60`',
    `quoted_currency` STRING COMMENT 'ISO 4217 currency code of the quoted price.',
    `quoted_quantity` DECIMAL(18,2) COMMENT 'Quantity of items the supplier is quoting for.',
    `quoted_unit_price` DECIMAL(18,2) COMMENT 'Price per unit quoted by the supplier.',
    `regulatory_approval_status` STRING COMMENT 'Status of any required regulatory approvals for the quoted part.. Valid values are `pending|approved|rejected`',
    `remarks` STRING COMMENT 'Additional free‑form comments from the supplier.',
    `response_number` STRING COMMENT 'External reference number assigned to the suppliers quotation response.',
    `response_source` STRING COMMENT 'Channel through which the supplier submitted the quotation.. Valid values are `email|portal|api`',
    `rfq_response_status` STRING COMMENT 'Current lifecycle status of the RFQ response.. Valid values are `submitted|under_review|accepted|rejected`',
    `shipping_method` STRING COMMENT 'Mode of transportation for delivering the goods.. Valid values are `air|sea|land`',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the supplier submitted the quotation.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Estimated tax component included in the quotation.',
    `tooling_cost` DECIMAL(18,2) COMMENT 'One‑time cost for tooling or molds required to produce the part.',
    `total_price` DECIMAL(18,2) COMMENT 'Total amount for the quoted quantity (unit price multiplied by quantity).',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the quoted quantity.. Valid values are `EA|KG|L`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the RFQ response record.',
    `validity_end_date` DATE COMMENT 'Last date on which the quoted terms are valid.',
    `validity_start_date` DATE COMMENT 'First date on which the quoted terms are valid.',
    `warranty_period_months` STRING COMMENT 'Length of warranty coverage offered by the supplier.',
    `warranty_type` STRING COMMENT 'Type of warranty provided.. Valid values are `standard|extended`',
    CONSTRAINT pk_rfq_response PRIMARY KEY(`rfq_response_id`)
) COMMENT 'Captures a suppliers formal quotation response to an RFQ. Records quoted unit price, tooling cost, amortization terms, lead time, capacity commitment, exceptions to SOR, validity period, and response status (submitted, under review, accepted, rejected). Supports competitive bid analysis and supplier selection decisions. One RFQ may have multiple responses from competing suppliers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` (
    `supply_purchase_order_id` BIGINT COMMENT 'Unique identifier for the supply_purchase_order data product (auto-inserted pre-linking).',
    `aftersales_model_year_program_id` BIGINT COMMENT 'Foreign key linking to product.model_year_program. Business justification: Purchase orders are tied to a specific model year program for budgeting, volume tracking, and compliance reporting.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: PO cost allocation required for budgeting and expense posting in Cost Center; finance tracks spend per cost center.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link purchase order to internal supplier master',
    CONSTRAINT pk_supply_purchase_order PRIMARY KEY(`supply_purchase_order_id`)
) COMMENT 'Legally binding procurement document issued to a supplier authorizing delivery of parts or materials at agreed price and schedule. Captures PO number, PO type (standard, blanket, scheduling agreement), supplier, plant, delivery terms (Incoterms), payment terms, total value, currency, and PO status (open, partially delivered, closed, cancelled). SSOT for purchase commitments; sourced from SAP MM (ME21N/ME22N).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` (
    `supply_po_line_id` BIGINT COMMENT 'Unique identifier for the supply_po_line data product (auto-inserted pre-linking).',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Each PO line expense must be posted to a GL account for financial reporting; GL account determines expense classification.',
    `order_line_id` BIGINT COMMENT 'Foreign key linking to sales.order_line. Business justification: FULFILLMENT MAPPING: Each PO line must reference the originating sales order line to reconcile parts consumption against sold vehicle configurations.',
    `procurement_po_line_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_po_line (cross-domain duplicate reconciliation; procurement designated SSOT owner for po_line).',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Purchase order line items specify the exact SKU to be received; linking enables automatic inventory allocation.',
    `supply_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.supply_purchase_order. Business justification: Connect PO line to its purchase order within supply domain',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link PO line to internal supplier master',
    CONSTRAINT pk_supply_po_line PRIMARY KEY(`supply_po_line_id`)
) COMMENT 'Individual line item within a purchase order representing a specific part number, quantity, unit price, delivery date, and plant destination. Captures line number, material number, ordered quantity, confirmed quantity, net price, delivery date, goods receipt quantity, and invoice quantity. Enables line-level tracking of delivery performance and invoice matching (3-way match) in SAP MM.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` (
    `supply_delivery_schedule_id` BIGINT COMMENT 'Unique identifier for the supply_delivery_schedule data product (auto-inserted pre-linking).',
    `procurement_delivery_schedule_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_delivery_schedule (cross-domain duplicate reconciliation; procurement designated SSOT owner for delivery_schedule).',
    `scheduling_agreement_id` BIGINT COMMENT 'Foreign key linking to supply.scheduling_agreement. Business justification: Delivery schedule is issued under a scheduling agreement; linking via scheduling_agreement_id enables traceability to the agreement.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Delivery schedule belongs to a supplier; adding supplier_id FK creates the required parent relationship and consolidates supplier reference.',
    CONSTRAINT pk_supply_delivery_schedule PRIMARY KEY(`supply_delivery_schedule_id`)
) COMMENT 'JIT/JIS delivery schedule line issued against a scheduling agreement, specifying exact quantities and delivery dates/times for a part to a plant dock. Captures schedule line date, time, required quantity, cumulative quantity, schedule type (firm, forecast, JIS sequence), dock door, and transmission status (sent, acknowledged, revised). Drives supplier production and logistics planning. Sourced from SAP MM schedule lines (EKET).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` (
    `supply_ppap_submission_id` BIGINT COMMENT 'Unique identifier for the supply_ppap_submission data product (auto-inserted pre-linking).',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: PPAP Compliance Tracking stores the PPAP package document reference in compliance_document for each PPAP submission.',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: REQUIRED: PPAP compliance dashboard requires each PPAP submission to be associated with the specific supplier contract governing the part.',
    `procurement_ppap_submission_id` BIGINT COMMENT 'SSOT reference foreign key.',
    CONSTRAINT pk_supply_ppap_submission PRIMARY KEY(`supply_ppap_submission_id`)
) COMMENT 'Production Part Approval Process submission record tracking the formal approval of a suppliers manufacturing process for a specific part. Captures PPAP level (1–5), submission date, part number, supplier, engineering change level, submission reason (new part, engineering change, tooling move), PPAP elements checklist status, PSW (Part Submission Warrant) status, and approval/rejection date. Integrates with PTC Windchill and SAP QM. SSOT for PPAP compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`ppap_element` (
    `ppap_element_id` BIGINT COMMENT 'System-generated unique identifier for the PPAP element record.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier responsible for the part associated with this PPAP element.',
    `supply_ppap_submission_id` BIGINT COMMENT 'Identifier of the parent PPAP submission that aggregates multiple elements.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the element was approved by the quality reviewer.',
    `compliance_standard` STRING COMMENT 'Regulatory or quality standard that the element satisfies (e.g., IATF 16949, AIAG PPAP).',
    `created_by_user` STRING COMMENT 'User identifier of the person who created the PPAP element record.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the PPAP element record was first created in the system.',
    `defect_rate_ppm` DECIMAL(18,2) COMMENT 'Measured parts‑per‑million defect rate associated with the element, if applicable.',
    `document_format` STRING COMMENT 'File format of the stored PPAP element document.. Valid values are `pdf|docx|xlsx|dwg`',
    `document_reference` STRING COMMENT 'Path or URL to the stored document that fulfills the PPAP element.',
    `due_date` DATE COMMENT 'Target date by which the element must be submitted for the PPAP package.',
    `element_code` STRING COMMENT 'Standardized code identifying the PPAP element type as defined by AIAG.',
    `element_name` STRING COMMENT 'Human‑readable name of the PPAP element (e.g., Design Records, PFMEA).',
    `element_type` STRING COMMENT 'Classification of the PPAP element according to AIAG PPAP element taxonomy.. Valid values are `design_records|pfmea|control_plan|msa|spc|psw`',
    `element_version` STRING COMMENT 'Version identifier of the element document (e.g., v1.0, revA).',
    `file_size_bytes` BIGINT COMMENT 'Size of the document file in bytes.',
    `is_confidential` BOOLEAN COMMENT 'Indicates whether the element contains confidential information requiring restricted handling.',
    `last_reviewed_by` STRING COMMENT 'User identifier of the most recent reviewer of the element.',
    `part_number` STRING COMMENT 'Manufacturer part number to which the PPAP element applies.',
    `part_revision` STRING COMMENT 'Revision identifier of the part version covered by the PPAP element.',
    `quality_metric` STRING COMMENT 'Outcome of the quality assessment for the element.. Valid values are `pass|fail|conditional`',
    `required_flag` BOOLEAN COMMENT 'Indicates whether the element is mandatory for the current PPAP submission.',
    `review_date` DATE COMMENT 'Date on which the element was last reviewed.',
    `reviewer_comments` STRING COMMENT 'Free‑text comments entered by the reviewer during evaluation.',
    `submission_status` STRING COMMENT 'Current status of the element within the PPAP workflow.. Valid values are `not_started|submitted|approved|rejected`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the PPAP element record.',
    CONSTRAINT pk_ppap_element PRIMARY KEY(`ppap_element_id`)
) COMMENT 'Individual PPAP element or deliverable within a PPAP submission, such as Design Records, PFMEA, Control Plan, MSA, SPC studies, or PSW. Captures element type (per AIAG PPAP standard), required flag, submission status (not started, submitted, approved, rejected), reviewer comments, and document reference. Enables granular tracking of PPAP completeness and compliance against IATF 16949 requirements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` (
    `inbound_shipment_id` BIGINT COMMENT 'System-generated unique identifier for the inbound shipment record.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: REQUIRED: Carrier performance & cost reporting uses inbound shipment data; linking enables carrier KPI aggregation.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Shipment Documentation process records the customs/compliance document attached to each inbound shipment.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: REQUIRED: Shipment‑to‑PO matching process uses PO ID to verify that inbound shipments correspond to the correct purchase order.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Receiving clerk records inbound shipment receipt; required for Receiving Activity Log.',
    `plant_id` BIGINT COMMENT 'Identifier of the OEM plant receiving the shipment.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Shipment Regulatory Check links inbound shipments to the regulatory_requirement governing hazardous material or import/export rules.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Shipment tracking per SKU is needed for logistics, ETA monitoring, and traceability of components to finished vehicles.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Associate inbound shipment with internal supplier master',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: LOGISTICS & WARRANTY: Associating inbound shipments with vehicle orders allows tracking of part receipt dates for warranty and delivery performance reporting.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Real date and time when the shipment was received at the dock.',
    `asn_number` STRING COMMENT 'Unique identifier supplied by the supplier to announce the shipment in advance.',
    `carrier_scac` STRING COMMENT 'Standard Carrier Alpha Code (four‑letter identifier) for the carrier.. Valid values are `^[A-Z]{4}$`',
    `container_count` STRING COMMENT 'Number of containers included in the shipment.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the freight cost.. Valid values are `^[A-Z]{3}$`',
    `customs_declaration_number` STRING COMMENT 'Identifier assigned by customs for the import declaration.',
    `delivery_window_end` TIMESTAMP COMMENT 'End of the agreed delivery time window at the receiving dock.',
    `delivery_window_start` TIMESTAMP COMMENT 'Start of the agreed delivery time window at the receiving dock.',
    `departure_timestamp` TIMESTAMP COMMENT 'Date and time when the shipment left the suppliers dock.',
    `estimated_arrival_timestamp` TIMESTAMP COMMENT 'Planned date and time of arrival at the receiving dock (ETA).',
    `freight_cost` DECIMAL(18,2) COMMENT 'Total cost charged by the carrier for transporting the shipment.',
    `hazardous_class` STRING COMMENT 'Classification of hazardous material according to UN/ADR standards.',
    `incoterm` STRING COMMENT 'International commercial term defining responsibility and cost allocation. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAT|DAP|DDP — 7 candidates stripped; promote to reference product]',
    `is_expedited` BOOLEAN COMMENT 'Indicates whether the shipment is expedited (true) or standard (false).',
    `is_hazardous` BOOLEAN COMMENT 'True if the shipment contains hazardous materials.',
    `last_status_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent change to the shipment status.',
    `material_group` STRING COMMENT 'Classification of the materials contained in the shipment.',
    `mode_of_transport` STRING COMMENT 'Primary mode used to move the shipment from supplier to plant.. Valid values are `road|rail|air|sea`',
    `pallet_count` STRING COMMENT 'Number of pallets used to load the shipment.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment record was first created in the system.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the shipment record.',
    `remarks` STRING COMMENT 'Free‑form comments or notes entered by logistics personnel.',
    `shipment_status` STRING COMMENT 'Current processing state of the inbound shipment.. Valid values are `in_transit|arrived|cleared|received|cancelled`',
    `temperature_control_required` BOOLEAN COMMENT 'True if the shipment must be kept within a temperature range.',
    `temperature_max_c` DECIMAL(18,2) COMMENT 'Upper bound of the required temperature range for the shipment.',
    `temperature_min_c` DECIMAL(18,2) COMMENT 'Lower bound of the required temperature range for the shipment.',
    `total_volume_m3` DECIMAL(18,2) COMMENT 'Aggregate volume of the shipment, expressed in cubic meters.',
    `total_weight_kg` DECIMAL(18,2) COMMENT 'Aggregate weight of all items in the shipment, expressed in kilograms.',
    CONSTRAINT pk_inbound_shipment PRIMARY KEY(`inbound_shipment_id`)
) COMMENT 'Tracks an inbound shipment of parts from a supplier plant to an OEM receiving dock. Captures ASN (Advance Shipping Notice) number, carrier, mode of transport (road, rail, air, sea), departure date/time, estimated arrival date/time, actual arrival date/time, total weight, total volume, number of containers/pallets, customs declaration number, and shipment status (in transit, arrived, cleared, received). Integrates with SAP MM inbound delivery (VL31N).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` (
    `supply_goods_receipt_id` BIGINT COMMENT 'Unique identifier for the supply_goods_receipt data product (auto-inserted pre-linking).',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: REQUIRED: Reconciliation report links internal goods receipt record to the external goods receipt entity for variance analysis.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: REQUIRED: Financial posting workflow requires each goods receipt to reference the purchase order it fulfills.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Goods receipt is processed by an employee; needed for Goods Receipt Register.',
    CONSTRAINT pk_supply_goods_receipt PRIMARY KEY(`supply_goods_receipt_id`)
) COMMENT 'Records the physical receipt and system confirmation of parts delivered by a supplier to an OEM plant. Captures GR document number, posting date, received quantity, accepted quantity, rejected quantity, storage location, batch number, GR type (standard, return, subsequent delivery), and posting status. Triggers inventory update and initiates 3-way invoice matching in SAP MM (MIGO). SSOT for inbound goods confirmation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` (
    `ckd_kit_id` BIGINT COMMENT 'System-generated unique identifier for the CKD/SKD kit record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: CKD Kit Certification process stores the compliance_document (type approval) linked to each kit.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: INCLUDE: CKD Kit Allocation also specifies the exact vehicle configuration (options, trim) the kit supports, requiring a FK to vehicle_configuration.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: INCLUDE: CKD Kit Allocation process links each kit to the vehicle model it builds, so a FK model_id replaces the denormalized vehicle_model string.',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - CKD kits are assembled at specific destination plants',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: REQUIRED: Kit shipment compliance audit ties each CKD kit to the governing supplier contract that defines pricing and delivery terms.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link CKD kit to internal supplier master',
    `actual_arrival_date` DATE COMMENT 'Actual date the kit was received at the target plant.',
    `compliance_certifications` STRING COMMENT 'List of certifications (e.g., CE, EPA) applicable to the kit.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the kit value.. Valid values are `^[A-Z]{3}$`',
    `dispatch_date` DATE COMMENT 'Date the kit was dispatched from the supplier or warehouse.',
    `effective_end_date` DATE COMMENT 'Date on which the kit record ceases to be effective (nullable for open‑ended).',
    `effective_start_date` DATE COMMENT 'Date from which the kit record becomes effective for planning and execution.',
    `expected_arrival_date` DATE COMMENT 'Planned date of arrival at the target assembly plant.',
    `export_customs_classification` STRING COMMENT 'Harmonized System code used for customs clearance of the exported kit.. Valid values are `^d{6,10}$`',
    `hazardous_material_description` STRING COMMENT 'Description of hazardous substances contained in the kit, if any.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the kit contains hazardous materials requiring special handling.',
    `incoterms` STRING COMMENT 'International commercial terms governing shipment responsibilities. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAT|DAP|DDP — promote to reference product]',
    `inspection_result` STRING COMMENT 'Outcome of the last inspection.. Valid values are `pass|fail|rework`',
    `kit_content_description` STRING COMMENT 'Narrative description of the parts and sub‑assemblies included in the kit.',
    `kit_number` STRING COMMENT 'Human‑readable identifier assigned to the kit for tracking and reference.',
    `kit_status` STRING COMMENT 'Current operational status of the kit within its lifecycle.. Valid values are `planned|assembled|shipped|in_transit|delivered|cancelled`',
    `kit_type` STRING COMMENT 'Indicates whether the kit is Completely Knocked Down (CKD) or Semi Knocked Down (SKD).. Valid values are `CKD|SKD`',
    `kit_value_usd` DECIMAL(18,2) COMMENT 'Monetary value of the kit in US dollars.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent inspection performed on the kit.',
    `model_year` STRING COMMENT 'Calendar year of the vehicle model for which the kit is intended.',
    `notes` STRING COMMENT 'Free‑form field for additional remarks or observations.',
    `packing_specification` STRING COMMENT 'Details of the packing method, materials, and dimensions used for the kit.',
    `ppap_document_reference` STRING COMMENT 'Reference or identifier of the PPAP documentation associated with the kit.',
    `ppap_status` STRING COMMENT 'Status of the Production Part Approval Process for the kit.. Valid values are `approved|rejected|pending`',
    `quality_status` STRING COMMENT 'Result of the final quality inspection for the kit.. Valid values are `passed|failed|pending`',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the kit record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the kit record.',
    `regulatory_approval_date` DATE COMMENT 'Date on which the required regulatory approval was granted.',
    `regulatory_approval_status` STRING COMMENT 'Current status of regulatory approvals required for the kit.. Valid values are `approved|pending|rejected`',
    `regulatory_body` STRING COMMENT 'Regulatory authority overseeing the kits compliance.. Valid values are `NHTSA|EPA|EURO_NCAP|CARB|DOT|SAE`',
    `resource_lifecycle_status` STRING COMMENT 'Overall lifecycle state of the kit as a master resource.. Valid values are `active|inactive|retired|blocked`',
    `seal_number` STRING COMMENT 'Security seal number applied to the container.. Valid values are `^[A-Z0-9]{6,}$`',
    `shipping_container_number` STRING COMMENT 'Unique identifier of the shipping container carrying the kit.. Valid values are `^[A-Z0-9]{11}$`',
    `shipping_method` STRING COMMENT 'Mode of transport used to move the kit to the destination plant.. Valid values are `sea|air|rail|road`',
    `special_instructions` STRING COMMENT 'Specific handling or assembly instructions associated with the kit.',
    `target_plant_code` STRING COMMENT 'Code of the assembly plant where the kit will be assembled.. Valid values are `^[A-Z0-9]{3,6}$`',
    `target_plant_name` STRING COMMENT 'Descriptive name of the target assembly plant.',
    `total_parts_count` STRING COMMENT 'Number of individual parts contained in the kit.',
    `total_volume_cbm` DECIMAL(18,2) COMMENT 'Aggregate volume of the kit in cubic meters.',
    `total_weight_kg` DECIMAL(18,2) COMMENT 'Aggregate weight of the kit in kilograms.',
    `tracking_number` STRING COMMENT 'Carrier‑provided tracking identifier for the shipment.',
    `warranty_period_months` STRING COMMENT 'Duration of the warranty coverage for the assembled vehicle derived from this kit.',
    `warranty_terms` STRING COMMENT 'Textual description of warranty conditions and exclusions.',
    CONSTRAINT pk_ckd_kit PRIMARY KEY(`ckd_kit_id`)
) COMMENT 'Master record for a Completely Knocked Down (CKD) or Semi Knocked Down (SKD) kit assembled for export to a global assembly operation. Captures kit number, kit type (CKD/SKD), target assembly plant, model year, vehicle configuration, kit content list, packing specification, export customs classification, and kit lifecycle status. Supports global assembly operations where vehicles are shipped as kits for local assembly.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` (
    `ckd_shipment_id` BIGINT COMMENT 'System-generated unique identifier for the CKD/SKD kit shipment record.',
    `ckd_kit_shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.ckd_kit_shipment. Business justification: REQUIRED: CKD kit planning and execution need a single linked record; linking eliminates duplicate identifiers and aligns logistics execution.',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - CKD shipments are destined for specific assembly plants',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link CKD shipment to internal supplier master',
    `actual_arrival_date` DATE COMMENT 'Real calendar date when the shipment was received at the destination plant.',
    `bill_of_lading` STRING COMMENT 'Document number that serves as a receipt for the shipped goods.',
    `ckd_shipment_status` STRING COMMENT 'Current lifecycle state of the shipment.. Valid values are `planned|in_transit|arrived|cleared|cancelled`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for total_value.',
    `customs_clearance_status` STRING COMMENT 'Current status of customs clearance for the shipment.. Valid values are `pending|cleared|rejected`',
    `departure_date` DATE COMMENT 'Calendar date on which the shipment departed the origin plant.',
    `departure_timestamp` TIMESTAMP COMMENT 'Date and time when the shipment left the origin plant.',
    `destination_plant_code` STRING COMMENT 'Code of the assembly plant receiving the CKD/SKD kits.',
    `estimated_arrival_date` DATE COMMENT 'Planned calendar date for arrival at the destination plant.',
    `export_declaration_number` STRING COMMENT 'Customs export declaration identifier for the shipment.',
    `freight_cost` DECIMAL(18,2) COMMENT 'Cost charged by the carrier for transporting the shipment.',
    `freight_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for freight_cost.',
    `freight_terms` STRING COMMENT 'Incoterm‑related freight payment terms.. Valid values are `prepaid|collect|third_party`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the shipment contains hazardous materials.',
    `incoterms` STRING COMMENT 'International commercial terms governing the shipment responsibilities. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DDP|FAS|FOB|CFR|CIF|DAT|DDU — promote to reference product]',
    `kit_count` BIGINT COMMENT 'Number of CKD/SKD kits included in the shipment.',
    `origin_plant_code` STRING COMMENT 'Code of the OEM source plant where the kits are shipped from.',
    `seal_number` STRING COMMENT 'Security seal identifier applied to the container.',
    `temperature_control_flag` BOOLEAN COMMENT 'Indicates if temperature control is required for the shipment.',
    `total_value` DECIMAL(18,2) COMMENT 'Monetary value of the shipment before any adjustments.',
    `tracking_number` STRING COMMENT 'Unique identifier used to track the shipment in carrier systems.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment.. Valid values are `sea|air|rail|road`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the shipment record.',
    `volume_m3` DECIMAL(18,2) COMMENT 'Total cubic meter volume of the shipment.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Gross weight of the shipment in kilograms.',
    CONSTRAINT pk_ckd_shipment PRIMARY KEY(`ckd_shipment_id`)
) COMMENT 'Transactional record of a CKD/SKD kit shipment from the OEM source plant to a global assembly destination. Captures shipment number, origin plant, destination assembly plant, vessel/flight number, bill of lading, export declaration number, departure date, estimated arrival date, kit count, total value, currency, and customs clearance status. Enables end-to-end tracking of global CKD/SKD supply flows.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` (
    `supplier_scorecard_id` BIGINT COMMENT 'System-generated unique identifier for each supplier scorecard record.',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - supplier scorecards are evaluated per receiving plant',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Connect supplier scorecard to internal supplier master',
    `compliance_score` DECIMAL(18,2) COMMENT 'Score measuring adherence to regulatory and internal compliance requirements.',
    `corrective_action_description` STRING COMMENT 'Free‑text description of actions the supplier must take to address deficiencies.',
    `corrective_action_flag` BOOLEAN COMMENT 'True when the supplier must undertake corrective actions.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the scorecard record was first created in the system.',
    `delivery_quantity_accuracy_pct` DECIMAL(18,2) COMMENT 'Ratio of delivered quantity to ordered quantity, expressed as a percent.',
    `evaluation_date` TIMESTAMP COMMENT 'Exact timestamp when the scorecard was completed.',
    `evaluation_period_end` DATE COMMENT 'Last calendar day of the period covered by the scorecard.',
    `evaluation_period_start` DATE COMMENT 'First calendar day of the period covered by the scorecard.',
    `evaluator_name` STRING COMMENT 'Full name of the internal evaluator responsible for the scorecard.',
    `notes` STRING COMMENT 'Additional comments or observations captured during the evaluation.',
    `otd_percentage` DECIMAL(18,2) COMMENT 'Percentage of deliveries that arrived on or before the agreed delivery date.',
    `overall_score` DECIMAL(18,2) COMMENT 'Aggregated weighted score combining all KPI values for the evaluation period.',
    `performance_tier` STRING COMMENT 'Categorical tier assigned based on the overall score.. Valid values are `preferred|approved|conditional|disqualified`',
    `ppap_on_time_completion_rate` DECIMAL(18,2) COMMENT 'Percentage of PPAP submissions completed within the agreed timeframe.',
    `ppm_defect_rate` DECIMAL(18,2) COMMENT 'Defect rate expressed in parts per million for supplied parts during the period.',
    `responsiveness_score` DECIMAL(18,2) COMMENT 'Score reflecting the suppliers responsiveness to inquiries and change requests.',
    `review_status` STRING COMMENT 'Indicates whether the scorecard is still being drafted, has been finalized, or has been reviewed by management.. Valid values are `draft|finalized|reviewed`',
    `risk_score` DECIMAL(18,2) COMMENT 'Composite risk rating derived from financial, operational, and compliance factors.',
    `scorecard_number` STRING COMMENT 'Human‑readable identifier assigned to the scorecard, used for reporting and audit trails.',
    `scoring_methodology_version` STRING COMMENT 'Identifier of the scoring model version used for this evaluation.',
    `supplier_scorecard_status` STRING COMMENT 'Current state of the scorecard in its lifecycle.. Valid values are `pending|completed|archived`',
    `sustainability_score` DECIMAL(18,2) COMMENT 'Score reflecting the suppliers environmental and sustainability initiatives.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the scorecard.',
    CONSTRAINT pk_supplier_scorecard PRIMARY KEY(`supplier_scorecard_id`)
) COMMENT 'Periodic (monthly/quarterly) performance evaluation record for a supplier across key KPIs including PPM (Parts Per Million defect rate), OTD (On-Time Delivery percentage), delivery quantity accuracy, PPAP on-time completion rate, responsiveness score, and overall supplier rating. Captures evaluation period, scoring methodology version, individual KPI values, weighted total score, performance tier (preferred, approved, conditional, disqualified), and corrective action flag.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` (
    `supplier_deviation_id` BIGINT COMMENT 'System-generated unique identifier for each supplier deviation record.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: REQUIRED: Deviation tracking report links a supplier deviation directly to the purchase order that triggered the deviation for root‑cause analysis.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Supplier deviations are part‑specific; associating with SKU allows impact analysis on stocked inventory quality.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link supplier deviation to internal supplier master',
    `approval_timestamp` TIMESTAMP COMMENT 'Date‑time when the deviation was approved or rejected by engineering.',
    `approved_by` BIGINT COMMENT 'Identifier of the engineering or quality manager who approved the deviation.',
    `authorized_cost` DECIMAL(18,2) COMMENT 'Monetary value of the authorized quantity for the deviation.',
    `comments` STRING COMMENT 'Free‑form notes entered by users regarding the deviation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the deviation record was first created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for the authorized cost.. Valid values are `^[A-Z]{3}$`',
    `supplier_deviation_description` STRING COMMENT 'Detailed explanation of the reason for the deviation and any special instructions.',
    `deviation_number` STRING COMMENT 'External reference number assigned to the deviation request, used for tracking and communication with suppliers.',
    `deviation_type` STRING COMMENT 'Category of the deviation (e.g., dimensional, material, process, documentation).. Valid values are `dimensional|material|process|documentation`',
    `disposition` STRING COMMENT 'Final handling instruction for the deviated parts.. Valid values are `use_as_is|rework|scrap`',
    `effective_timestamp` TIMESTAMP COMMENT 'Date‑time when the deviation became effective for production.',
    `engineering_approval_status` STRING COMMENT 'Current status of engineering review for the deviation.. Valid values are `pending|approved|rejected`',
    `expiration_timestamp` TIMESTAMP COMMENT 'Date‑time when the deviation expires and must no longer be used.',
    `is_temporary_flag` BOOLEAN COMMENT 'True if the deviation is a short‑term waiver; false if permanent.',
    `part_name` STRING COMMENT 'Human‑readable name or description of the part.',
    `part_number` STRING COMMENT 'Identifier of the part to which the deviation applies (OEM or supplier part number).',
    `priority` STRING COMMENT 'Business priority assigned to the deviation for handling urgency.. Valid values are `low|medium|high|critical`',
    `quality_hold_flag` BOOLEAN COMMENT 'Indicates whether the part is placed on quality hold pending deviation resolution.',
    `quantity_authorized` DECIMAL(18,2) COMMENT 'Number of units or amount of material approved for the deviation.',
    `related_ecn_number` STRING COMMENT 'Engineering Change Notice (ECN) identifier associated with the deviation, if any.',
    `related_ppap_status` STRING COMMENT 'Status of the Production Part Approval Process linked to this deviation.. Valid values are `pending|approved|rejected`',
    `request_timestamp` TIMESTAMP COMMENT 'Exact date‑time when the supplier submitted the deviation request.',
    `risk_rating` STRING COMMENT 'Risk assessment of the deviation impact on quality and delivery.. Valid values are `low|medium|high|critical`',
    `supplier_deviation_status` STRING COMMENT 'Overall lifecycle state of the deviation record.. Valid values are `open|approved|rejected|closed|cancelled`',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the authorized quantity.. Valid values are `pcs|kg|liter|meter|unit`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the deviation record.',
    `validity_end_date` DATE COMMENT 'Date after which the deviation is no longer valid.',
    `validity_start_date` DATE COMMENT 'Date from which the deviation is permitted to be used.',
    CONSTRAINT pk_supplier_deviation PRIMARY KEY(`supplier_deviation_id`)
) COMMENT 'Formal record of a supplier request for deviation or waiver to ship non-conforming parts or use an alternative process temporarily. Captures deviation number, part number, deviation type (dimensional, material, process), quantity authorized, validity period, engineering approval status, quality hold flag, and disposition (use-as-is, rework, scrap). Supports IATF 16949 non-conformance management and traceability.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` (
    `supply_corrective_action_id` BIGINT COMMENT 'Unique identifier for the supply_corrective_action data product (auto-inserted pre-linking).',
    `quality_corrective_action_id` BIGINT COMMENT 'SSOT reference to quality.quality_corrective_action (cross-domain duplicate reconciliation; quality designated SSOT owner for corrective_action).',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Corrective actions are assigned to a responsible employee; used in Corrective Action Tracker.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Corrective actions are issued by a supplier; adding supply_supplier_id FK provides the necessary parent link and resolves the silo.',
    `compliance_corrective_action_id` BIGINT COMMENT '',
    CONSTRAINT pk_supply_corrective_action PRIMARY KEY(`supply_corrective_action_id`)
) COMMENT 'Supplier corrective action request (SCAR) issued when a supplier fails to meet quality, delivery, or compliance requirements. Captures SCAR number, triggering event (PPM breach, OTD failure, audit finding), root cause category, 8D report reference, containment action, permanent corrective action, verification date, and closure status. Drives supplier development and continuous improvement programs.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` (
    `supplier_audit_id` BIGINT COMMENT 'System-generated unique identifier for each supplier audit.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Internal audits are performed by specific auditors; audit reports reference auditor employee.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Associate supplier audit with internal supplier master',
    `audit_date` DATE COMMENT 'Calendar date on which the audit took place.',
    `audit_location` STRING COMMENT 'Site, plant, or facility name where the audit took place.',
    `audit_method` STRING COMMENT 'Delivery method of the audit (on‑site, remote, or virtual).. Valid values are `on_site|remote|virtual`',
    `audit_number` STRING COMMENT 'External audit reference code assigned by the audit team.',
    `audit_report_document` STRING COMMENT 'Location of the detailed audit report (file path, URL, or document ID).',
    `audit_standard` STRING COMMENT 'Quality or environmental standard against which the audit is assessed.. Valid values are `IATF16949|ISO9001|ISO14001|ISO45001`',
    `audit_type` STRING COMMENT 'Classification of the audit (system, process, product, or layered process).. Valid values are `system|process|product|layered_process`',
    `auditor_email` STRING COMMENT 'Primary email contact for the auditor.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `auditor_name` STRING COMMENT 'Full legal name of the auditor conducting the audit.',
    `auditor_phone` STRING COMMENT 'Contact telephone number for the auditor.. Valid values are `^+?[0-9]{7,15}$`',
    `closure_date` DATE COMMENT 'Date on which the audit record was marked closed.',
    `closure_status` STRING COMMENT 'State of audit closure (open, closed, or pending).. Valid values are `open|closed|pending`',
    `comments` STRING COMMENT 'Additional observations, recommendations, or notes recorded by the auditor.',
    `findings_major_count` STRING COMMENT 'Number of major non‑conformities discovered during the audit.',
    `findings_minor_count` STRING COMMENT 'Number of minor non‑conformities discovered during the audit.',
    `findings_observation_count` STRING COMMENT 'Number of observation‑type findings (no immediate non‑conformance).',
    `lifecycle_status` STRING COMMENT 'Overall lifecycle stage of the audit (planned, in progress, completed, closed, or cancelled).. Valid values are `planned|in_progress|completed|closed|cancelled`',
    `overall_score` DECIMAL(18,2) COMMENT 'Aggregated audit score expressed as a percentage.',
    `re_audit_required` BOOLEAN COMMENT 'True if a subsequent audit must be scheduled to verify corrective actions.',
    `record_audit_created` TIMESTAMP COMMENT 'Date‑time when the audit record was initially captured.',
    `record_audit_updated` TIMESTAMP COMMENT 'Date‑time of the latest modification to the audit record.',
    `risk_rating` STRING COMMENT 'Overall risk classification derived from audit findings.. Valid values are `low|medium|high|critical`',
    `scope_description` STRING COMMENT 'Narrative description of the audit scope and boundaries.',
    CONSTRAINT pk_supplier_audit PRIMARY KEY(`supplier_audit_id`)
) COMMENT 'Record of a formal quality or process audit conducted at a supplier facility. Captures audit type (system audit, process audit, product audit, layered process audit), audit date, auditor name, scope, findings count by severity (major, minor, observation), overall audit score, re-audit required flag, and closure status. Supports IATF 16949 supplier monitoring and development obligations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` (
    `inbound_inspection_id` BIGINT COMMENT 'System-generated unique identifier for each inbound inspection record.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who performed the inspection.',
    `inspector_employee_id` BIGINT COMMENT 'Identifier of the employee who performed the inspection.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier that provided the inspected part.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Inspection results are linked to the SKU to ensure quality compliance for each vehicle configuration.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Inspection results are recorded per SKU to update quality status and determine stock availability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inspection record was first created in the system.',
    `defect_count` STRING COMMENT 'Total number of defects identified in the inspected sample.',
    `defect_rate_ppm` DECIMAL(18,2) COMMENT 'Defects per million units calculated for the inspected lot.',
    `defect_type_codes` STRING COMMENT 'Comma‑separated list of defect classification codes (e.g., surface, dimensional, functional).',
    `disposition` STRING COMMENT 'Action taken after inspection (accept, return to supplier, sort and use, or rework).. Valid values are `accept|return_to_supplier|sort_and_use|rework`',
    `inspection_location` STRING COMMENT 'Plant or line code where the inspection was carried out.',
    `inspection_lot_number` STRING COMMENT 'External identifier assigned by the plant for the inspection lot.',
    `inspection_method` STRING COMMENT 'Method used for the inspection (AQL sampling, 100% check, or skip‑lot).. Valid values are `aql_sampling|full_inspection|skip_lot`',
    `inspection_result` STRING COMMENT 'Overall outcome of the inspection based on defect criteria.. Valid values are `pass|fail|conditional_release`',
    `inspection_status` STRING COMMENT 'Current lifecycle status of the inspection record.. Valid values are `open|in_progress|completed|released|rejected|cancelled`',
    `inspection_timestamp` TIMESTAMP COMMENT 'Date and time when the inspection was performed at the plant.',
    `part_number` STRING COMMENT 'OEM-assigned part number of the component being inspected.',
    `part_revision` STRING COMMENT 'Engineering change revision identifier for the part.',
    `sample_size` STRING COMMENT 'Number of units selected for inspection according to the sampling plan.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the inspection record.',
    CONSTRAINT pk_inbound_inspection PRIMARY KEY(`inbound_inspection_id`)
) COMMENT 'Incoming quality inspection record for parts received from a supplier at an OEM plant. Captures inspection lot number, inspection date, part number, supplier, sample size, inspection method (AQL sampling, 100% check, skip-lot), number of defects found, defect type codes, inspection result (pass, fail, conditional release), and disposition (accept, return to supplier, sort and use). Integrates with SAP QM inspection lots.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`disruption` (
    `disruption_id` BIGINT COMMENT 'Primary key for disruption',
    `inbound_part_id` BIGINT COMMENT 'add column inbound_part_id (BIGINT) with FK to supply.inbound_part.inbound_part_id - disruptions affect specific inbound parts',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - supply disruptions impact specific manufacturing plants',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link disruption event to internal supplier master',
    CONSTRAINT pk_disruption PRIMARY KEY(`disruption_id`)
) COMMENT 'Records a supply disruption event where a supplier is unable to meet scheduled delivery commitments due to capacity issues, natural disasters, labor actions, logistics failures, or quality holds. Captures disruption type, affected parts, impacted plants, start date, expected resolution date, severity (critical, major, minor), mitigation actions taken (alternative sourcing, expedite, safety stock draw), and financial impact estimate. Supports supply risk management and business continuity planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` (
    `tooling_asset_id` BIGINT COMMENT 'Surrogate primary key uniquely identifying each tooling asset record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Tooling Certification process records the compliance_document (e.g., safety standard) for each tooling_asset.',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Tooling is capitalized as a Fixed Asset for depreciation and asset management in finance.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link tooling asset to internal supplier master',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'Capital cost incurred to acquire the tooling asset.',
    `acquisition_currency` STRING COMMENT 'Currency in which the acquisition cost is recorded.. Valid values are `USD|EUR|JPY|CNY|GBP|CHF`',
    `acquisition_date` DATE COMMENT 'Date the tooling asset was purchased or received.',
    `commissioning_date` DATE COMMENT 'Date the tooling asset entered production service.',
    `compliance_standard` STRING COMMENT 'Regulatory or quality standard applicable to the tooling.. Valid values are `IATF16949|ISO9001|ISO14001|EPA|NHTSA|CARB`',
    `condition` STRING COMMENT 'Current physical condition of the tooling asset.. Valid values are `new|good|fair|poor|scrapped`',
    `country_code` STRING COMMENT 'Three‑letter ISO country code of the tooling location.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the tooling asset record was first created in the system.',
    `depreciation_method` STRING COMMENT 'Accounting method used to depreciate the tooling asset.',
    `inspection_status` STRING COMMENT 'Result of the latest inspection.. Valid values are `passed|failed|pending`',
    `last_inspection_date` DATE COMMENT 'Date of the most recent condition inspection.',
    `maintenance_cost_total` DECIMAL(18,2) COMMENT 'Cumulative cost incurred for maintaining the tooling asset.',
    `maintenance_last_date` DATE COMMENT 'Date of the most recent maintenance activity.',
    `maintenance_next_date` DATE COMMENT 'Planned date for the next maintenance event.',
    `maintenance_type` STRING COMMENT 'Category of maintenance performed on the tooling.. Valid values are `preventive|corrective|predictive`',
    `next_inspection_due` DATE COMMENT 'Planned date for the next scheduled inspection.',
    `ownership_type` STRING COMMENT 'Indicates whether the tooling is owned by the OEM, the supplier, jointly owned, or leased.. Valid values are `OEM-owned|supplier-owned|joint-ownership|leased`',
    `part_number` STRING COMMENT 'OEM part number that this tooling is used to manufacture.',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant where the tooling is deployed.',
    `regulatory_approval_date` DATE COMMENT 'Date when regulatory approval was granted.',
    `regulatory_approval_required` BOOLEAN COMMENT 'Indicates if the tooling must obtain regulatory approval before use.',
    `regulatory_approval_status` STRING COMMENT 'Current status of the required regulatory approval.. Valid values are `approved|pending|rejected`',
    `status_change_date` DATE COMMENT 'Date when the current status became effective.',
    `supplier_location` STRING COMMENT 'Physical site or plant where the tooling asset is located at the supplier.',
    `tool_description` STRING COMMENT 'Free‑text description of the tooling asset, including dimensions and capabilities.',
    `tool_life_remaining` BIGINT COMMENT 'Remaining shots or cycles before the tool reaches end‑of‑life.',
    `tool_life_total` BIGINT COMMENT 'Maximum allowable shots or cycles before tool retirement.',
    `tool_life_type` STRING COMMENT 'Metric used to track tool life – either number of shots or operational cycles.. Valid values are `shots|cycles`',
    `tool_life_used` BIGINT COMMENT 'Cumulative shots or cycles the tool has already performed.',
    `tool_number` STRING COMMENT 'Manufacturer-assigned identifier for the tooling item (die, mold, fixture, gauge).',
    `tool_type` STRING COMMENT 'Classification of the tooling asset by its functional form.. Valid values are `die|mold|fixture|gauge|tooling_jig|other`',
    `tooling_asset_status` STRING COMMENT 'Operational status of the tooling asset.. Valid values are `active|under_repair|end_of_life|retired|inactive`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the tooling asset record.',
    `warranty_end_date` DATE COMMENT 'Date when the tooling warranty expires.',
    `warranty_provider` STRING COMMENT 'Entity that provides the warranty (OEM, supplier, third‑party).',
    `warranty_start_date` DATE COMMENT 'Date when the tooling warranty becomes effective.',
    CONSTRAINT pk_tooling_asset PRIMARY KEY(`tooling_asset_id`)
) COMMENT 'Master record for OEM-owned production tooling (dies, molds, jigs, fixtures, checking gauges) physically located at supplier facilities. Captures tool number, tool type, part number produced, supplier plant location, ownership classification (OEM-owned per IATF 16949 §8.5.3), acquisition cost, net book value, tool life capacity (shots/cycles), current utilization, last maintenance/inspection date, and lifecycle status (active, under repair, awaiting transfer, end-of-life). Supports tooling investment tracking, PPAP tooling records, and supplier exit/transition planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`price_agreement` (
    `price_agreement_id` BIGINT COMMENT 'System-generated unique identifier for the price agreement record.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Price agreements tie to a GL account to record purchase price variances and contract liabilities.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Price agreements are negotiated per part/SKU; linking provides pricing data for inventory valuation and costing.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Associate price agreement with internal supplier master',
    `actual_otd_percent` DECIMAL(18,2) COMMENT 'Measured on‑time delivery performance of the supplier for the current period.',
    `actual_ppm` DECIMAL(18,2) COMMENT 'Measured defect rate of supplied parts for the current period.',
    `agreement_number` STRING COMMENT 'External business identifier assigned to the price agreement by the OEM.',
    `agreement_type` STRING COMMENT 'Classification of the agreement indicating its primary purpose (e.g., price, cost, service, tooling).. Valid values are `price|cost|service|tooling`',
    `annual_price_reduction_commitment` DECIMAL(18,2) COMMENT 'Percentage reduction in price committed by the supplier each year.',
    `compliance_approval_status` STRING COMMENT 'Status of internal compliance review for the agreement.. Valid values are `approved|pending|rejected`',
    `compliance_document_ref` STRING COMMENT 'Reference identifier for the compliance documentation attached to the agreement.',
    `contract_scope` STRING COMMENT 'Narrative defining the parts, volumes, and geographic regions covered by the agreement.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the price agreement record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for the unit price.. Valid values are `^[A-Z]{3}$`',
    `price_agreement_description` STRING COMMENT 'Free‑form text describing the purpose, scope, and any special conditions of the agreement.',
    `early_termination_allowed` BOOLEAN COMMENT 'Indicates whether the agreement may be terminated before the end date without penalty.',
    `effective_end_date` DATE COMMENT 'Date on which the price agreement expires or is terminated; null if open‑ended.',
    `effective_start_date` DATE COMMENT 'Date on which the price agreement becomes binding.',
    `part_number` STRING COMMENT 'OEM part number to which the price agreement applies.',
    `payment_terms` STRING COMMENT 'Standard payment condition agreed for invoices under this price agreement.. Valid values are `net30|net45|net60|net90`',
    `penalty_clause` STRING COMMENT 'Text describing penalties for non‑compliance such as late delivery or quality breaches.',
    `price_adjustment_trigger` STRING COMMENT 'Condition that can trigger a price change during the agreement (material index, foreign exchange, or none).. Valid values are `material_index|foreign_exchange|none`',
    `price_agreement_status` STRING COMMENT 'Current lifecycle status of the price agreement.. Valid values are `active|expired|under_negotiation|draft|suspended`',
    `renewal_notice_period_days` STRING COMMENT 'Number of days notice required to exercise a renewal option.',
    `renewal_option` STRING COMMENT 'Specifies if the agreement auto‑renews, requires manual renewal, or does not renew.. Valid values are `auto|manual|none`',
    `target_otd_percent` DECIMAL(18,2) COMMENT 'Contractual target for supplier on‑time delivery performance.',
    `target_ppm` DECIMAL(18,2) COMMENT 'Maximum acceptable defect rate for supplied parts under the agreement.',
    `termination_notice_period_days` STRING COMMENT 'Number of days notice required to terminate the agreement early.',
    `tooling_amortization_terms` STRING COMMENT 'Terms describing how tooling costs are amortized over the agreement period.',
    `total_annual_volume` DECIMAL(18,2) COMMENT 'Maximum total quantity of the part that may be purchased under the agreement each year.',
    `unit_of_measure` STRING COMMENT 'Measurement unit used for the agreed price and volume (e.g., piece, kilogram).. Valid values are `piece|kg|liter|meter`',
    `unit_price` DECIMAL(18,2) COMMENT 'Negotiated price per unit of the part for the agreement period.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the price agreement record.',
    `version_number` STRING COMMENT 'Sequential version number of the agreement reflecting amendments.',
    CONSTRAINT pk_price_agreement PRIMARY KEY(`price_agreement_id`)
) COMMENT 'Formally agreed piece price and commercial terms between the OEM and a supplier for a specific part over a defined period. Captures agreement number, part number, supplier, effective date, expiry date, agreed unit price, currency, annual price reduction commitment (APR), tooling amortization terms, price adjustment triggers (material index, FX), and agreement status (active, expired, under negotiation). Distinct from the purchase order — this is the commercial price framework.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_event` (
    `inbound_event_id` BIGINT COMMENT 'Primary key for inbound_event',
    `inbound_shipment_id` BIGINT COMMENT 'add column inbound_shipment_id (BIGINT) with FK to supply.inbound_shipment.inbound_shipment_id - inbound events track status changes on inbound shipments',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - inbound supply events are received at specific plants',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Connect inbound event to internal supplier master',
    CONSTRAINT pk_inbound_event PRIMARY KEY(`inbound_event_id`)
) COMMENT 'Milestone and exception event log for inbound supply chain activities, capturing key status transitions such as ASN received, customs cleared, dock arrival, goods receipt posted, quality hold placed, or delivery rejected. Captures event type, event timestamp, location, part number, shipment reference, responsible party, and event notes. Enables end-to-end supply chain visibility and exception management across the inbound supply network.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`commodity_group` (
    `commodity_group_id` BIGINT COMMENT 'Unique surrogate identifier for the commodity group. _canonical_skip_reason: Entity is a reference lookup used for classification of purchased parts.',
    `parent_commodity_group_id` BIGINT COMMENT 'Identifier of the parent commodity group for hierarchical classification.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Associate commodity group with responsible supplier for governance',
    `applicable_regions` STRING COMMENT 'Comma‑separated list of ISO 3166‑1 alpha‑3 country codes where the commodity group is used.',
    `average_cost_usd` DECIMAL(18,2) COMMENT 'Average unit cost in US dollars for items within the commodity group.',
    `commodity_group_code` STRING COMMENT 'Business code used to identify the commodity group in source systems.',
    `commodity_category` STRING COMMENT 'High‑level category grouping similar commodity groups.. Valid values are `metal|plastic|electronic|chemical|textile`',
    `commodity_code` STRING COMMENT 'Unique alphanumeric code identifying the commodity group as defined in SAP MM.',
    `commodity_group_status` STRING COMMENT 'Current lifecycle status of the commodity group.. Valid values are `active|inactive|deprecated`',
    `commodity_group_type` STRING COMMENT 'Classification of the commodity group by its role in the supply chain.. Valid values are `raw_material|component|subassembly|finished_good`',
    `commodity_manager` STRING COMMENT 'Name of the internal manager responsible for the commodity group.',
    `compliance_standards` STRING COMMENT 'List of regulatory standards applicable to the commodity group. [ENUM-REF-CANDIDATE: REACH|RoHS|ISO9001|IATF16949|EPA|CARB — promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the commodity group record was first created in the source system.',
    `currency_code` STRING COMMENT 'Default currency used for cost references in this commodity group.. Valid values are `^[A-Z]{3}$`',
    `commodity_group_description` STRING COMMENT 'Detailed description of the commodity family, its typical applications and characteristics.',
    `effective_end_date` DATE COMMENT 'Date when the commodity group is retired or no longer valid.',
    `effective_from` DATE COMMENT 'Date from which the commodity group definition is valid.',
    `effective_start_date` DATE COMMENT 'Date when the commodity group becomes effective for use.',
    `effective_until` DATE COMMENT 'Date after which the commodity group definition is no longer valid (null if indefinite).',
    `hazardous_material_description` STRING COMMENT 'Description of the hazardous characteristics or classifications for the commodity group.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the commodity group contains hazardous materials.',
    `is_confidential` BOOLEAN COMMENT 'Indicates whether the commodity group contains confidential pricing or strategic information.',
    `is_global` BOOLEAN COMMENT 'Indicates whether the commodity group is applicable across all plants and regions.',
    `lead_time_max_days` STRING COMMENT 'Longest typical supplier lead time for items in this commodity group.',
    `lead_time_min_days` STRING COMMENT 'Shortest typical supplier lead time for items in this commodity group.',
    `commodity_group_name` STRING COMMENT 'Human‑readable name of the commodity family (e.g., Electronics, Castings).',
    `notes` STRING COMMENT 'Free‑form comments or additional information about the commodity group.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'True if the commodity group is subject to regulatory compliance requirements (e.g., REACH, RoHS).',
    `risk_factor` STRING COMMENT 'Comma‑separated list of primary supply‑chain risks (e.g., single source, geopolitical, regulatory).',
    `risk_score` DECIMAL(18,2) COMMENT 'Numerical risk rating (0‑100) for the commodity group based on supplier performance and material hazards.',
    `strategic_classification` STRING COMMENT 'Kraljic matrix classification indicating the strategic importance of the commodity.. Valid values are `strategic|leverage|bottleneck|non-critical`',
    `sustainability_score` DECIMAL(18,2) COMMENT 'Score reflecting environmental impact and sustainability of the commodity group.',
    `typical_price_range_high` DECIMAL(18,2) COMMENT 'Upper bound of typical unit price for items in this commodity group.',
    `typical_price_range_low` DECIMAL(18,2) COMMENT 'Lower bound of typical unit price for items in this commodity group.',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure used for the commodity group.. Valid values are `kg|piece|liter|meter`',
    `updated_by` STRING COMMENT 'User or system that performed the latest update to the commodity group record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the commodity group record.',
    `version_number` STRING COMMENT 'Version identifier for changes to the commodity group definition.',
    `volume_per_unit_cbm` DECIMAL(18,2) COMMENT 'Typical volume of a single unit within the commodity group, expressed in cubic meters.',
    `weight_per_unit_kg` DECIMAL(18,2) COMMENT 'Typical weight of a single unit within the commodity group, expressed in kilograms.',
    `created_by` STRING COMMENT 'User or system that initially created the commodity group record.',
    CONSTRAINT pk_commodity_group PRIMARY KEY(`commodity_group_id`)
) COMMENT 'Master reference table for commodity_group. ';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` (
    `supply_agreement_id` BIGINT COMMENT 'Primary key for the SupplyAgreement association',
    `procurement_supply_agreement_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_supply_agreement (cross-domain duplicate reconciliation; procurement designated SSOT owner for supply_agreement).',
    `sku_id` BIGINT COMMENT 'Foreign key linking to the vehicle SKU',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier master',
    `average_cost` DECIMAL(18,2) COMMENT 'Average unit cost charged by the supplier for the SKU',
    `effective_from` DATE COMMENT 'Date when the agreement becomes effective',
    `effective_until` DATE COMMENT 'Date when the agreement expires or is superseded',
    `lead_time_days` STRING COMMENT 'Number of days from order to delivery for this supplier‑SKU combination',
    `lifecycle_status` STRING COMMENT 'Current status of the supply agreement (active, pending, discontinued)',
    `price_uom` STRING COMMENT 'Unit of measure for the price (e.g., per part, per kit)',
    CONSTRAINT pk_supply_agreement PRIMARY KEY(`supply_agreement_id`)
) COMMENT 'Represents a contractual relationship between a supply_supplier and a vehicle SKU. Each record captures the terms under which a supplier provides parts for a specific SKU, including lead time, cost, pricing unit, lifecycle status, and the effective date range.. Existence Justification: A tier‑1 or tier‑2 supplier can provide parts for many vehicle SKUs, and a given SKU can be sourced from multiple suppliers. The business actively manages each supplier‑SKU pairing as a supply agreement, tracking lead times, costs, pricing units, lifecycle status, and effective dates.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` (
    `supplier_nomination_id` BIGINT COMMENT 'Primary key for the supplier_nomination association',
    `aftersales_model_year_program_id` BIGINT COMMENT 'Foreign key linking to the model year program',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier master',
    `currency_code` STRING COMMENT 'Currency of the price (ISO 4217)',
    `nominated_volume` BIGINT COMMENT 'Quantity of parts or services nominated for the program',
    `nomination_status` STRING COMMENT 'Current status of the nomination (e.g., pending, approved, rejected)',
    `risk_rating` STRING COMMENT 'Risk assessment rating for the supplier nomination',
    `target_piece_price` DECIMAL(18,2) COMMENT 'Agreed unit price for the nominated volume',
    CONSTRAINT pk_supplier_nomination PRIMARY KEY(`supplier_nomination_id`)
) COMMENT 'This association captures the contractual nomination of a supply_supplier to a model_year_program, including the volume, price, currency, status, and risk rating agreed for that program.. Existence Justification: A supplier can be nominated for multiple model year programs, providing volume and price terms for each. Conversely, each model year program sources parts from many suppliers. The nomination itself is managed as a contract with its own attributes (volume, price, status, risk).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` (
    `supplier_compliance_assignment_id` BIGINT COMMENT 'Primary key for the supplier_compliance_assignment association',
    `obligation_id` BIGINT COMMENT 'Reference to the compliance obligation assigned to the supplier',
    `supply_supplier_id` BIGINT COMMENT 'Reference to the supplier involved in the compliance assignment',
    `supplier_compliance_assignment_status` STRING COMMENT 'Current lifecycle status of the suppliers responsibility for the obligation (e.g., pending, in‑progress, completed)',
    CONSTRAINT pk_supplier_compliance_assignment PRIMARY KEY(`supplier_compliance_assignment_id`)
) COMMENT 'Represents the assignment of a compliance obligation to a supplier, capturing the status, effective period, and priority of the responsibility. Each record links one supplier to one compliance obligation and stores attributes that exist only in the context of this relationship.. Existence Justification: A supplier may be responsible for multiple regulatory compliance obligations, and a single compliance obligation often requires participation from multiple suppliers. The business actively tracks each supplier‑obligation link with status, effective dates, and priority, making the relationship a managed entity rather than a simple lookup.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` (
    `scheduling_agreement_id` BIGINT COMMENT 'System generated unique identifier for the scheduling agreement record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Approval of scheduling agreements requires a designated employee; used in Scheduling Agreement Approval Log report.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Scheduling agreements are created per engineering part to lock volume, price, and delivery cadence with the supplier.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link scheduling agreement to internal supplier master',
    `actual_otd_percent` DECIMAL(18,2) COMMENT 'Measured on‑time delivery performance for the agreement period.',
    `actual_ppm` DECIMAL(18,2) COMMENT 'Measured defect rate for parts delivered under the agreement.',
    `agreement_number` STRING COMMENT 'External business identifier assigned to the scheduling agreement (e.g., contract number).',
    `agreement_type` STRING COMMENT 'Classification of the scheduling agreement (e.g., framework, spot, consignment).. Valid values are `framework|spot|consignment|service|lease`',
    `approval_date` DATE COMMENT 'Date on which the agreement received formal approval.',
    `compliance_approval_status` STRING COMMENT 'Regulatory or quality compliance status of the agreement.. Valid values are `pending|approved|rejected`',
    `compliance_document_ref` STRING COMMENT 'Reference number of the attached compliance documentation.',
    `contract_scope` STRING COMMENT 'High‑level description of the parts, services, or components covered.',
    `contract_version` STRING COMMENT 'Version identifier for the agreement when amendments are made.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the scheduling agreement record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for pricing.. Valid values are `USD|EUR|JPY|CNY|GBP`',
    `delivery_rhythm` STRING COMMENT 'Scheduled frequency of deliveries defined in the agreement.. Valid values are `daily|weekly|biweekly|monthly`',
    `scheduling_agreement_description` STRING COMMENT 'Free‑text description of the purpose, scope and key terms of the agreement.',
    `early_termination_allowed` BOOLEAN COMMENT 'Flag indicating whether the agreement can be terminated before the end date.',
    `end_date` DATE COMMENT 'Date on which the agreement expires or is terminated (nullable for open‑ended contracts).',
    `kanban_flag` BOOLEAN COMMENT 'Indicates whether the agreement uses a Kanban pull system for JIT deliveries.',
    `part_description` STRING COMMENT 'Human‑readable description of the part covered by the agreement.',
    `payment_terms` STRING COMMENT 'Standard payment condition agreed with the supplier.. Valid values are `net30|net45|net60|cash|prepaid`',
    `penalty_clause` STRING COMMENT 'Text describing penalties for missed deliveries or quality breaches.',
    `price_per_unit` DECIMAL(18,2) COMMENT 'Agreed price for one unit of the supplied part.',
    `release_horizon_weeks` STRING COMMENT 'Number of weeks in advance that delivery forecasts must be submitted.',
    `renewal_notice_period_days` STRING COMMENT 'Notice period required to exercise renewal option.',
    `renewal_option` BOOLEAN COMMENT 'Indicates if the agreement includes an automatic renewal provision.',
    `scheduling_agreement_status` STRING COMMENT 'Current lifecycle status of the scheduling agreement.. Valid values are `draft|active|suspended|terminated|expired`',
    `start_date` DATE COMMENT 'Date on which the agreement becomes binding.',
    `target_otd_percent` DECIMAL(18,2) COMMENT 'Target percentage for on‑time deliveries defined in the agreement.',
    `target_ppm` DECIMAL(18,2) COMMENT 'Maximum allowable defect rate for supplied parts.',
    `termination_notice_period_days` STRING COMMENT 'Number of days notice required to terminate the agreement early.',
    `total_annual_volume` DECIMAL(18,2) COMMENT 'Planned total quantity of parts to be supplied over the contract year.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the volume (e.g., pieces, kilograms).. Valid values are `pcs|kg|liter|meter|unit`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the scheduling agreement record.',
    CONSTRAINT pk_scheduling_agreement PRIMARY KEY(`scheduling_agreement_id`)
) COMMENT 'Long-term supply agreement with a supplier defining the framework for JIT/JIS delivery of parts over a model year or contract period. Captures agreement number, validity start/end dates, target annual volume, release horizon (firm/forecast weeks), delivery rhythm (daily, weekly), Kanban flag, and agreement status. The scheduling agreement is the backbone of JIT supply in SAP MM (ME31L/ME32L).';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ADD CONSTRAINT `fk_supply_supplier_part_approval_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` ADD CONSTRAINT `fk_supply_supply_supplier_plant_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ADD CONSTRAINT `fk_supply_sourcing_nomination_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ADD CONSTRAINT `fk_supply_rfq_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ADD CONSTRAINT `fk_supply_rfq_response_rfq_id` FOREIGN KEY (`rfq_id`) REFERENCES `vibe_automotive_v1`.`supply`.`rfq`(`rfq_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ADD CONSTRAINT `fk_supply_rfq_response_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ADD CONSTRAINT `fk_supply_supply_purchase_order_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ADD CONSTRAINT `fk_supply_supply_po_line_supply_purchase_order_id` FOREIGN KEY (`supply_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_purchase_order`(`supply_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ADD CONSTRAINT `fk_supply_supply_po_line_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` ADD CONSTRAINT `fk_supply_supply_delivery_schedule_scheduling_agreement_id` FOREIGN KEY (`scheduling_agreement_id`) REFERENCES `vibe_automotive_v1`.`supply`.`scheduling_agreement`(`scheduling_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` ADD CONSTRAINT `fk_supply_supply_delivery_schedule_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
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
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ADD CONSTRAINT `fk_supply_scheduling_agreement_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`supply` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`supply` SET TAGS ('dbx_domain' = 'supply');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `supplier_part_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Approval ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `approval_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `approval_outcome` SET TAGS ('dbx_business_glossary_term' = 'Approval Outcome');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `approval_outcome` SET TAGS ('dbx_value_regex' = 'approved|interim_approval|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `approval_score` SET TAGS ('dbx_business_glossary_term' = 'Approval Score');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Approver Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `capability_study_status` SET TAGS ('dbx_business_glossary_term' = 'Capability Study Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `capability_study_status` SET TAGS ('dbx_value_regex' = 'completed|pending|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `classification` SET TAGS ('dbx_business_glossary_term' = 'Classification');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `classification` SET TAGS ('dbx_value_regex' = 'critical|major|minor|optional');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `control_plan_status` SET TAGS ('dbx_value_regex' = 'completed|pending|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `design_records_status` SET TAGS ('dbx_business_glossary_term' = 'Design Records Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `design_records_status` SET TAGS ('dbx_value_regex' = 'completed|pending|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|rejected|expired');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `msa_status` SET TAGS ('dbx_business_glossary_term' = 'Measurement System Analysis (MSA) Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `msa_status` SET TAGS ('dbx_value_regex' = 'completed|pending|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `overall_status` SET TAGS ('dbx_business_glossary_term' = 'Overall Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `overall_status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|revoked');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `pfmea_status` SET TAGS ('dbx_business_glossary_term' = 'PFMEA Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `pfmea_status` SET TAGS ('dbx_value_regex' = 'completed|pending|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `ppap_submission_level` SET TAGS ('dbx_business_glossary_term' = 'PPAP Submission Level');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `ppap_submission_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|level_4|level_5');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `quality_rating` SET TAGS ('dbx_business_glossary_term' = 'Quality Rating');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `quality_rating` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E|F');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `sample_parts_status` SET TAGS ('dbx_business_glossary_term' = 'Sample Parts Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `sample_parts_status` SET TAGS ('dbx_value_regex' = 'completed|pending|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_supplier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` ALTER COLUMN `supply_supplier_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_supplier_plant');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `average_cost` SET TAGS ('dbx_business_glossary_term' = 'Average Cost');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `commodity_group` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `commodity_group` SET TAGS ('dbx_value_regex' = 'engine|transmission|chassis|electrical|interior|exterior');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin (ISO‑3)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO‑4217)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `customs_tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `customs_tariff_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `engineering_change_level` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Level');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `engineering_change_level` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `height_mm` SET TAGS ('dbx_business_glossary_term' = 'Height (mm)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `last_received_date` SET TAGS ('dbx_business_glossary_term' = 'Last Received Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `last_received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Last Received Quantity');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `length_mm` SET TAGS ('dbx_business_glossary_term' = 'Length (mm)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued|pending');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `lot_size` SET TAGS ('dbx_business_glossary_term' = 'Lot Size');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `material_type` SET TAGS ('dbx_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `material_type` SET TAGS ('dbx_value_regex' = 'raw|sub-assembly|ckd_kit|finished|service');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `oem_part_number` SET TAGS ('dbx_business_glossary_term' = 'OEM Part Number (OPN)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `ppap_status` SET TAGS ('dbx_business_glossary_term' = 'PPAP Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `ppap_status` SET TAGS ('dbx_value_regex' = 'approved|rejected|pending|under_review');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `price_uom` SET TAGS ('dbx_business_glossary_term' = 'Price Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `price_uom` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|SET');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `reorder_point_quantity` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point Quantity');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number (SPN)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|SET');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `width_mm` SET TAGS ('dbx_business_glossary_term' = 'Width (mm)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sourcing_nomination_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Nomination ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sourcing_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sourcing_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sourcing_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `commodity` SET TAGS ('dbx_business_glossary_term' = 'Commodity (Part Category)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CAD|AUD');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `is_jis` SET TAGS ('dbx_business_glossary_term' = 'Just‑In‑Sequence Requirement Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `is_jit` SET TAGS ('dbx_business_glossary_term' = 'Just‑In‑Time Requirement Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `kit_type` SET TAGS ('dbx_business_glossary_term' = 'Kit Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `kit_type` SET TAGS ('dbx_value_regex' = 'CKD|SKD|none');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `nominated_volume` SET TAGS ('dbx_business_glossary_term' = 'Nominated Volume');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `nomination_date` SET TAGS ('dbx_business_glossary_term' = 'Nomination Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `nomination_number` SET TAGS ('dbx_business_glossary_term' = 'Nomination Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `nomination_status` SET TAGS ('dbx_business_glossary_term' = 'Nomination Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `nomination_status` SET TAGS ('dbx_value_regex' = 'nominated|confirmed|withdrawn|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Nomination Priority');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Program Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Supply Region');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `region` SET TAGS ('dbx_value_regex' = 'NAM|EME|APAC|LATAM|AFR');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sor_reference` SET TAGS ('dbx_business_glossary_term' = 'Statement of Requirements Reference');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `target_piece_price` SET TAGS ('dbx_business_glossary_term' = 'Target Piece Price');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_id` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'RFQ Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'PENDING|APPROVED|REJECTED');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `attachment_flag` SET TAGS ('dbx_business_glossary_term' = 'Attachment Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `commodity_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirements');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'RFQ Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `delivery_schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `delivery_schedule_type` SET TAGS ('dbx_value_regex' = 'JIT|JIS|STANDARD');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `issue_timestamp` SET TAGS ('dbx_business_glossary_term' = 'RFQ Issue Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `last_status_change_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Status Change Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `net_price_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Price Amount');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'RFQ Notes');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `part_description` SET TAGS ('dbx_business_glossary_term' = 'Part Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'RFQ Priority');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'HIGH|MEDIUM|LOW');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `program_model_year` SET TAGS ('dbx_business_glossary_term' = 'Program / Model Year');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `quantity_estimate` SET TAGS ('dbx_business_glossary_term' = 'Estimated Quantity');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `regulatory_approval_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Required Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Required Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `response_due_date` SET TAGS ('dbx_business_glossary_term' = 'RFQ Response Due Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_number` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_status` SET TAGS ('dbx_business_glossary_term' = 'RFQ Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_status` SET TAGS ('dbx_value_regex' = 'draft|open|closed|awarded|cancelled|pending');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_type` SET TAGS ('dbx_business_glossary_term' = 'RFQ Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `rfq_type` SET TAGS ('dbx_value_regex' = 'NEW_PART|EXISTING_PART|SERVICE|MATERIAL');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `target_price_amount` SET TAGS ('dbx_business_glossary_term' = 'Target Price Amount');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `target_price_currency` SET TAGS ('dbx_business_glossary_term' = 'Target Price Currency');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `tooling_description` SET TAGS ('dbx_business_glossary_term' = 'Tooling Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `tooling_required` SET TAGS ('dbx_business_glossary_term' = 'Tooling Required Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|SET|BOX');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'RFQ Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `rfq_response_id` SET TAGS ('dbx_business_glossary_term' = 'RFQ Response ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `rfq_id` SET TAGS ('dbx_business_glossary_term' = 'RFQ ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `amortization_term_months` SET TAGS ('dbx_business_glossary_term' = 'Amortization Term (Months)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `capacity_commitment` SET TAGS ('dbx_business_glossary_term' = 'Capacity Commitment (CC)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `capacity_commitment` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `capacity_unit` SET TAGS ('dbx_business_glossary_term' = 'Capacity Unit');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `capacity_unit` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `compliance_certifications` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certifications');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `delivery_address` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `delivery_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `delivery_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `exceptions_to_sor` SET TAGS ('dbx_business_glossary_term' = 'Exceptions to Statement of Requirements');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `freight_included` SET TAGS ('dbx_business_glossary_term' = 'Freight Included Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `is_preferred_supplier` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net30|net45|net60');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `quoted_currency` SET TAGS ('dbx_business_glossary_term' = 'Quoted Currency (QC)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `quoted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Quoted Quantity (QQ)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `quoted_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Quoted Unit Price (QUP)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `response_number` SET TAGS ('dbx_business_glossary_term' = 'RFQ Response Number (RN)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `response_source` SET TAGS ('dbx_business_glossary_term' = 'Response Source');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `response_source` SET TAGS ('dbx_value_regex' = 'email|portal|api');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `rfq_response_status` SET TAGS ('dbx_business_glossary_term' = 'Response Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `rfq_response_status` SET TAGS ('dbx_value_regex' = 'submitted|under_review|accepted|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `shipping_method` SET TAGS ('dbx_business_glossary_term' = 'Shipping Method');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `shipping_method` SET TAGS ('dbx_value_regex' = 'air|sea|land');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount (TA)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `tooling_cost` SET TAGS ('dbx_business_glossary_term' = 'Tooling Cost (TC)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `total_price` SET TAGS ('dbx_business_glossary_term' = 'Total Quoted Price (TQP)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `warranty_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq_response` ALTER COLUMN `warranty_type` SET TAGS ('dbx_value_regex' = 'standard|extended');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_purchase_order');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `aftersales_model_year_program_id` SET TAGS ('dbx_business_glossary_term' = 'Model Year Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `supply_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_po_line');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` ALTER COLUMN `supply_delivery_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_delivery_schedule');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` ALTER COLUMN `procurement_delivery_schedule_id` SET TAGS ('dbx_ssot_owner' = 'procurement.procurement_delivery_schedule');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `supply_ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_ppap_submission');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `ppap_element_id` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `supply_ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'PPAP Submission Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Element Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `defect_rate_ppm` SET TAGS ('dbx_business_glossary_term' = 'Defect Rate (PPM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `document_format` SET TAGS ('dbx_business_glossary_term' = 'Document Format');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `document_format` SET TAGS ('dbx_value_regex' = 'pdf|docx|xlsx|dwg');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Document Reference');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Due Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `element_code` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `element_name` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `element_type` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Type (AIAG)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `element_type` SET TAGS ('dbx_value_regex' = 'design_records|pfmea|control_plan|msa|spc|psw');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `element_version` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Version');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_business_glossary_term' = 'File Size (Bytes)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `is_confidential` SET TAGS ('dbx_business_glossary_term' = 'Confidential Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `last_reviewed_by` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed By User');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `quality_metric` SET TAGS ('dbx_business_glossary_term' = 'Quality Metric Result');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `quality_metric` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `required_flag` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Required Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Review Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `reviewer_comments` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Reviewer Comments');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `submission_status` SET TAGS ('dbx_business_glossary_term' = 'PPAP Element Submission Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `submission_status` SET TAGS ('dbx_value_regex' = 'not_started|submitted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Plant ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `asn_number` SET TAGS ('dbx_business_glossary_term' = 'Advance Shipping Notice (ASN) Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `carrier_scac` SET TAGS ('dbx_business_glossary_term' = 'Carrier SCAC Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `carrier_scac` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `container_count` SET TAGS ('dbx_business_glossary_term' = 'Container Count');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `delivery_window_end` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window End');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `delivery_window_start` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window Start');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `estimated_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `hazardous_class` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Class');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `incoterm` SET TAGS ('dbx_business_glossary_term' = 'Incoterm');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `is_expedited` SET TAGS ('dbx_business_glossary_term' = 'Expedited Shipment Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `last_status_update_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Status Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `mode_of_transport` SET TAGS ('dbx_business_glossary_term' = 'Mode of Transport');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `mode_of_transport` SET TAGS ('dbx_value_regex' = 'road|rail|air|sea');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `pallet_count` SET TAGS ('dbx_business_glossary_term' = 'Pallet Count');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_business_glossary_term' = 'Shipment Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_value_regex' = 'in_transit|arrived|cleared|received|cancelled');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Required');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `total_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Total Volume (m³)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `total_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `supply_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_goods_receipt');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `ckd_kit_id` SET TAGS ('dbx_business_glossary_term' = 'CKD Kit Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `actual_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `compliance_certifications` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certifications');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `dispatch_date` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `expected_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `export_customs_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Customs Classification (HS Code)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `export_customs_classification` SET TAGS ('dbx_value_regex' = '^d{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `hazardous_material_description` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `inspection_result` SET TAGS ('dbx_value_regex' = 'pass|fail|rework');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `kit_content_description` SET TAGS ('dbx_business_glossary_term' = 'Kit Content Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `kit_number` SET TAGS ('dbx_business_glossary_term' = 'Kit Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `kit_status` SET TAGS ('dbx_business_glossary_term' = 'Kit Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `kit_status` SET TAGS ('dbx_value_regex' = 'planned|assembled|shipped|in_transit|delivered|cancelled');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `kit_type` SET TAGS ('dbx_business_glossary_term' = 'Kit Type (CKD/SKD)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `kit_type` SET TAGS ('dbx_value_regex' = 'CKD|SKD');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `kit_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Kit Value (USD)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `packing_specification` SET TAGS ('dbx_business_glossary_term' = 'Packing Specification');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `ppap_document_reference` SET TAGS ('dbx_business_glossary_term' = 'PPAP Document Reference');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `ppap_status` SET TAGS ('dbx_business_glossary_term' = 'PPAP Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `ppap_status` SET TAGS ('dbx_value_regex' = 'approved|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `quality_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `quality_status` SET TAGS ('dbx_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_value_regex' = 'NHTSA|EPA|EURO_NCAP|CARB|DOT|SAE');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `resource_lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Resource Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `resource_lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|blocked');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `seal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `shipping_container_number` SET TAGS ('dbx_business_glossary_term' = 'Shipping Container Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `shipping_container_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{11}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `shipping_method` SET TAGS ('dbx_business_glossary_term' = 'Shipping Method');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `shipping_method` SET TAGS ('dbx_value_regex' = 'sea|air|rail|road');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `target_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Target Assembly Plant Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `target_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `target_plant_name` SET TAGS ('dbx_business_glossary_term' = 'Target Assembly Plant Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `total_parts_count` SET TAGS ('dbx_business_glossary_term' = 'Total Parts Count');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `total_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Total Kit Volume (cbm)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `total_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Kit Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ALTER COLUMN `warranty_terms` SET TAGS ('dbx_business_glossary_term' = 'Warranty Terms');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `ckd_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'CKD Shipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `ckd_kit_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Ckd Kit Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `actual_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Date (ACT_ARRIVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `bill_of_lading` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `ckd_shipment_status` SET TAGS ('dbx_business_glossary_term' = 'Shipment Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `ckd_shipment_status` SET TAGS ('dbx_value_regex' = 'planned|in_transit|arrived|cleared|cancelled');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURRENCY)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status (CUSTOMS_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `departure_date` SET TAGS ('dbx_business_glossary_term' = 'Departure Date (DEPARTURE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Departure Timestamp (DEPARTURE_TS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `destination_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Plant Code (DEST_PLANT)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `estimated_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Date (EST_ARRIVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `export_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Export Declaration Number (EXPORT_DECL_NO)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost (FREIGHT_COST)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `freight_currency` SET TAGS ('dbx_business_glossary_term' = 'Freight Currency (FREIGHT_CURRENCY)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Terms (FREIGHT_TERMS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'prepaid|collect|third_party');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag (HAZMAT_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms (INCOTERMS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `kit_count` SET TAGS ('dbx_business_glossary_term' = 'Kit Count (KIT_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `origin_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Plant Code (ORIGIN_PLANT)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number (SEAL_NO)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `temperature_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Flag (TEMP_CTRL_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `total_value` SET TAGS ('dbx_business_glossary_term' = 'Total Shipment Value (TOTAL_VALUE)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Tracking Number (TRACKING_NO)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode (TRANSPORT_MODE)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'sea|air|rail|road');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Shipment Volume (VOLUME_M3)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Shipment Weight (WEIGHT_KG)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `supplier_scorecard_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Scorecard ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Compliance Score (CS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `corrective_action_flag` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `delivery_quantity_accuracy_pct` SET TAGS ('dbx_business_glossary_term' = 'Delivery Quantity Accuracy Percentage (DQAP)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `evaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Date (Timestamp)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `evaluation_period_end` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `evaluation_period_start` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `evaluator_name` SET TAGS ('dbx_business_glossary_term' = 'Evaluator Name (EN)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `evaluator_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `evaluator_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Evaluator Notes');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `otd_percentage` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Percentage (OTD)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `overall_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Supplier Score (OSS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `performance_tier` SET TAGS ('dbx_business_glossary_term' = 'Performance Tier (PT)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `performance_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|disqualified');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `ppap_on_time_completion_rate` SET TAGS ('dbx_business_glossary_term' = 'PPAP On‑Time Completion Rate (PPAP‑OTC)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `ppm_defect_rate` SET TAGS ('dbx_business_glossary_term' = 'Parts‑Per‑Million Defect Rate (PPM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `responsiveness_score` SET TAGS ('dbx_business_glossary_term' = 'Responsiveness Score (RS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `review_status` SET TAGS ('dbx_business_glossary_term' = 'Review Status (RS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `review_status` SET TAGS ('dbx_value_regex' = 'draft|finalized|reviewed');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `risk_score` SET TAGS ('dbx_business_glossary_term' = 'Supplier Risk Score (SRS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `scorecard_number` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Number (SCN)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `scorecard_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `scoring_methodology_version` SET TAGS ('dbx_business_glossary_term' = 'Scoring Methodology Version (SMV)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `supplier_scorecard_status` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `supplier_scorecard_status` SET TAGS ('dbx_value_regex' = 'pending|completed|archived');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `sustainability_score` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Score (SS)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `supplier_deviation_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Deviation ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Deviation Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `authorized_cost` SET TAGS ('dbx_business_glossary_term' = 'Authorized Cost');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Deviation Comments');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `supplier_deviation_description` SET TAGS ('dbx_business_glossary_term' = 'Deviation Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `deviation_number` SET TAGS ('dbx_business_glossary_term' = 'Deviation Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `deviation_type` SET TAGS ('dbx_business_glossary_term' = 'Deviation Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `deviation_type` SET TAGS ('dbx_value_regex' = 'dimensional|material|process|documentation');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Deviation Disposition');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'use_as_is|rework|scrap');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `effective_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Effective Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `engineering_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Engineering Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `engineering_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `expiration_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Expiration Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `is_temporary_flag` SET TAGS ('dbx_business_glossary_term' = 'Temporary Deviation Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Deviation Priority');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `quality_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Quality Hold Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `quantity_authorized` SET TAGS ('dbx_business_glossary_term' = 'Authorized Quantity');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `related_ecn_number` SET TAGS ('dbx_business_glossary_term' = 'Related Engineering Change Notice Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `related_ppap_status` SET TAGS ('dbx_business_glossary_term' = 'Related PPAP Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `related_ppap_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `request_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Deviation Request Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Deviation Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `supplier_deviation_status` SET TAGS ('dbx_business_glossary_term' = 'Deviation Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `supplier_deviation_status` SET TAGS ('dbx_value_regex' = 'open|approved|rejected|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'pcs|kg|liter|meter|unit');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` SET TAGS ('dbx_ssot_reference' = 'compliance.compliance_corrective_action');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ALTER COLUMN `supply_corrective_action_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_corrective_action');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `supplier_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Audit Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Auditor Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_location` SET TAGS ('dbx_business_glossary_term' = 'Audit Location');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_method` SET TAGS ('dbx_business_glossary_term' = 'Audit Method');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_method` SET TAGS ('dbx_value_regex' = 'on_site|remote|virtual');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_business_glossary_term' = 'Audit Reference Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_report_document` SET TAGS ('dbx_business_glossary_term' = 'Audit Report Document Reference');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_standard` SET TAGS ('dbx_business_glossary_term' = 'Audit Standard');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_standard` SET TAGS ('dbx_value_regex' = 'IATF16949|ISO9001|ISO14001|ISO45001');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_business_glossary_term' = 'Audit Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'system|process|product|layered_process');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_email` SET TAGS ('dbx_business_glossary_term' = 'Auditor Email Address');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Auditor Full Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_phone` SET TAGS ('dbx_business_glossary_term' = 'Auditor Phone Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9]{7,15}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `auditor_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Closure Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_business_glossary_term' = 'Audit Closure Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `closure_status` SET TAGS ('dbx_value_regex' = 'open|closed|pending');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Auditor Comments');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `findings_major_count` SET TAGS ('dbx_business_glossary_term' = 'Major Findings Count');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `findings_minor_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Findings Count');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `findings_observation_count` SET TAGS ('dbx_business_glossary_term' = 'Observation Findings Count');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Audit Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `overall_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Audit Score');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `re_audit_required` SET TAGS ('dbx_business_glossary_term' = 'Re‑Audit Required Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Audit Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ALTER COLUMN `scope_description` SET TAGS ('dbx_business_glossary_term' = 'Audit Scope Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inbound_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Inspection ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspector_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspector_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspector_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `defect_count` SET TAGS ('dbx_business_glossary_term' = 'Defect Count');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `defect_rate_ppm` SET TAGS ('dbx_business_glossary_term' = 'Defect Rate (PPM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `defect_type_codes` SET TAGS ('dbx_business_glossary_term' = 'Defect Type Codes');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Inspection Disposition');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'accept|return_to_supplier|sort_and_use|rework');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_location` SET TAGS ('dbx_business_glossary_term' = 'Inspection Location (Plant Code)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_method` SET TAGS ('dbx_business_glossary_term' = 'Inspection Method');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_method` SET TAGS ('dbx_value_regex' = 'aql_sampling|full_inspection|skip_lot');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_release');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|completed|released|rejected|cancelled');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `inspection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number (OEM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `sample_size` SET TAGS ('dbx_business_glossary_term' = 'Sample Size');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` ALTER COLUMN `disruption_id` SET TAGS ('dbx_business_glossary_term' = 'Disruption Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tooling_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Asset Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `acquisition_currency` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Currency');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `acquisition_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CHF');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_value_regex' = 'IATF16949|ISO9001|ISO14001|EPA|NHTSA|CARB');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `condition` SET TAGS ('dbx_business_glossary_term' = 'Tool Condition');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `condition` SET TAGS ('dbx_value_regex' = 'new|good|fair|poor|scrapped');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `inspection_status` SET TAGS ('dbx_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `maintenance_cost_total` SET TAGS ('dbx_business_glossary_term' = 'Total Maintenance Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `maintenance_last_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `maintenance_next_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Due Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `maintenance_type` SET TAGS ('dbx_value_regex' = 'preventive|corrective|predictive');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `next_inspection_due` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `ownership_type` SET TAGS ('dbx_value_regex' = 'OEM-owned|supplier-owned|joint-ownership|leased');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number Produced');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `regulatory_approval_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Required');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `status_change_date` SET TAGS ('dbx_business_glossary_term' = 'Status Change Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `supplier_location` SET TAGS ('dbx_business_glossary_term' = 'Supplier Location');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_description` SET TAGS ('dbx_business_glossary_term' = 'Tool Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_life_remaining` SET TAGS ('dbx_business_glossary_term' = 'Remaining Tool Life (Units)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_life_total` SET TAGS ('dbx_business_glossary_term' = 'Total Tool Life (Units)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_life_type` SET TAGS ('dbx_business_glossary_term' = 'Tool Life Measurement Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_life_type` SET TAGS ('dbx_value_regex' = 'shots|cycles');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_life_used` SET TAGS ('dbx_business_glossary_term' = 'Tool Life Used (Units)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_number` SET TAGS ('dbx_business_glossary_term' = 'Tool Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_type` SET TAGS ('dbx_business_glossary_term' = 'Tool Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tool_type` SET TAGS ('dbx_value_regex' = 'die|mold|fixture|gauge|tooling_jig|other');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tooling_asset_status` SET TAGS ('dbx_business_glossary_term' = 'Tooling Asset Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `tooling_asset_status` SET TAGS ('dbx_value_regex' = 'active|under_repair|end_of_life|retired|inactive');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `warranty_provider` SET TAGS ('dbx_business_glossary_term' = 'Warranty Provider');
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `price_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Price Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `actual_otd_percent` SET TAGS ('dbx_business_glossary_term' = 'Actual On‑Time Delivery Percentage');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `actual_ppm` SET TAGS ('dbx_business_glossary_term' = 'Actual Parts‑Per‑Million Defect Rate');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Agreement Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'price|cost|service|tooling');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `annual_price_reduction_commitment` SET TAGS ('dbx_business_glossary_term' = 'Annual Price Reduction Commitment (APR)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `compliance_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `compliance_approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `compliance_document_ref` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Reference');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `contract_scope` SET TAGS ('dbx_business_glossary_term' = 'Contract Scope');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `price_agreement_description` SET TAGS ('dbx_business_glossary_term' = 'Agreement Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `early_termination_allowed` SET TAGS ('dbx_business_glossary_term' = 'Early Termination Allowed');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net30|net45|net60|net90');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `penalty_clause` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `price_adjustment_trigger` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Trigger');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `price_adjustment_trigger` SET TAGS ('dbx_value_regex' = 'material_index|foreign_exchange|none');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `price_agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `price_agreement_status` SET TAGS ('dbx_value_regex' = 'active|expired|under_negotiation|draft|suspended');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `renewal_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `renewal_option` SET TAGS ('dbx_business_glossary_term' = 'Renewal Option');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `renewal_option` SET TAGS ('dbx_value_regex' = 'auto|manual|none');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `target_otd_percent` SET TAGS ('dbx_business_glossary_term' = 'Target On‑Time Delivery Percentage');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `target_ppm` SET TAGS ('dbx_business_glossary_term' = 'Target Parts‑Per‑Million Defect Rate');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `termination_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Termination Notice Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `tooling_amortization_terms` SET TAGS ('dbx_business_glossary_term' = 'Tooling Amortization Terms');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `total_annual_volume` SET TAGS ('dbx_business_glossary_term' = 'Total Annual Volume');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'piece|kg|liter|meter');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Agreed Unit Price');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Agreement Version Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` ALTER COLUMN `inbound_event_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Event Identifier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `parent_commodity_group_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Commodity Group ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `applicable_regions` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regions');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `average_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Average Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group Code (CGC)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_category` SET TAGS ('dbx_business_glossary_term' = 'Commodity Category');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_category` SET TAGS ('dbx_value_regex' = 'metal|plastic|electronic|chemical|textile');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_status` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_type` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group Type (CGT)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_type` SET TAGS ('dbx_value_regex' = 'raw_material|component|subassembly|finished_good');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_manager` SET TAGS ('dbx_business_glossary_term' = 'Commodity Manager');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `compliance_standards` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standards');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_description` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `hazardous_material_description` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `is_confidential` SET TAGS ('dbx_business_glossary_term' = 'Confidential Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `is_global` SET TAGS ('dbx_business_glossary_term' = 'Global Applicability Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `lead_time_max_days` SET TAGS ('dbx_business_glossary_term' = 'Maximum Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `lead_time_min_days` SET TAGS ('dbx_business_glossary_term' = 'Minimum Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `commodity_group_name` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group Name');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `risk_factor` SET TAGS ('dbx_business_glossary_term' = 'Key Risk Factors');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `risk_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Score');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `strategic_classification` SET TAGS ('dbx_business_glossary_term' = 'Strategic Classification (Kraljic Matrix)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `strategic_classification` SET TAGS ('dbx_value_regex' = 'strategic|leverage|bottleneck|non-critical');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `sustainability_score` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Score');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `typical_price_range_high` SET TAGS ('dbx_business_glossary_term' = 'Typical Price Range High');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `typical_price_range_low` SET TAGS ('dbx_business_glossary_term' = 'Typical Price Range Low');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'kg|piece|liter|meter');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `volume_per_unit_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume per Unit (cubic meters)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `weight_per_unit_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight per Unit (kg)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`commodity_group` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` SET TAGS ('dbx_association_edges' = 'supply.supply_supplier,product.sku');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supplyagreement - Supply Agreement Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Supplyagreement - Sku Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplyagreement - Supply Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `average_cost` SET TAGS ('dbx_business_glossary_term' = 'Average Cost');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_agreement` ALTER COLUMN `price_uom` SET TAGS ('dbx_business_glossary_term' = 'Price UOM');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` SET TAGS ('dbx_association_edges' = 'supply.supply_supplier,product.model_year_program');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `supplier_nomination_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Nomination - Supplier Nomination Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `aftersales_model_year_program_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Nomination - Model Year Program Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Nomination - Supply Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `nominated_volume` SET TAGS ('dbx_business_glossary_term' = 'Nominated Volume');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `nomination_status` SET TAGS ('dbx_business_glossary_term' = 'Nomination Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_nomination` ALTER COLUMN `target_piece_price` SET TAGS ('dbx_business_glossary_term' = 'Target Piece Price');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` SET TAGS ('dbx_association_edges' = 'supply.supply_supplier,compliance.compliance_obligation');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` ALTER COLUMN `supplier_compliance_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Compliance Assignment - Supplier Compliance Assignment Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Compliance Assignment - Compliance Obligation Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Compliance Assignment - Supply Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_compliance_assignment` ALTER COLUMN `supplier_compliance_assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Compliance Assignment - Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `actual_otd_percent` SET TAGS ('dbx_business_glossary_term' = 'Actual On‑Time Delivery (%)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `actual_ppm` SET TAGS ('dbx_business_glossary_term' = 'Actual Parts‑Per‑Million (PPM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Agreement Number');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Type');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'framework|spot|consignment|service|lease');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `compliance_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Approval Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `compliance_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `compliance_document_ref` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Reference');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `contract_scope` SET TAGS ('dbx_business_glossary_term' = 'Contract Scope');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `contract_version` SET TAGS ('dbx_business_glossary_term' = 'Contract Version');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `delivery_rhythm` SET TAGS ('dbx_business_glossary_term' = 'Delivery Rhythm');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `delivery_rhythm` SET TAGS ('dbx_value_regex' = 'daily|weekly|biweekly|monthly');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `scheduling_agreement_description` SET TAGS ('dbx_business_glossary_term' = 'Agreement Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `early_termination_allowed` SET TAGS ('dbx_business_glossary_term' = 'Early Termination Allowed');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `kanban_flag` SET TAGS ('dbx_business_glossary_term' = 'Kanban Flag');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `part_description` SET TAGS ('dbx_business_glossary_term' = 'Part Description');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net30|net45|net60|cash|prepaid');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `penalty_clause` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `price_per_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Per Unit');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `release_horizon_weeks` SET TAGS ('dbx_business_glossary_term' = 'Release Horizon (Weeks)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `renewal_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `renewal_option` SET TAGS ('dbx_business_glossary_term' = 'Renewal Option');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `scheduling_agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `scheduling_agreement_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|terminated|expired');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `target_otd_percent` SET TAGS ('dbx_business_glossary_term' = 'Target On‑Time Delivery (%)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `target_ppm` SET TAGS ('dbx_business_glossary_term' = 'Target Parts‑Per‑Million (PPM)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `termination_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Termination Notice Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `total_annual_volume` SET TAGS ('dbx_business_glossary_term' = 'Total Annual Volume');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'pcs|kg|liter|meter|unit');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
