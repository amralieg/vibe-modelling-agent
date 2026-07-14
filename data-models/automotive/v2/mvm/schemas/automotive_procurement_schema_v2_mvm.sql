-- Schema for Domain: procurement | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:41

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`procurement` COMMENT 'Strategic sourcing and procurement operations for direct materials (production parts) and indirect materials (MRO, tooling, services). Manages supplier contracts, SOR (Statement of Requirements), purchase requisitions, purchase orders, goods receipt, invoice verification, and spend analytics. Includes global sourcing strategies, supplier development programs, and CapEx procurement workflows. Integrates with SAP MM and Ariba for procure-to-pay processes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` (
    `procurement_supplier_id` BIGINT COMMENT 'System-generated unique identifier for the supplier master record.',
    `parent_supplier_procurement_supplier_id` BIGINT COMMENT 'Identifier of the parent organization in a corporate supplier hierarchy.',
    `address_line1` STRING COMMENT 'First line of the suppliers primary business address.',
    `bank_account_number` STRING COMMENT 'Suppliers bank account number for payments.',
    `bank_name` STRING COMMENT 'Name of the financial institution holding the suppliers account.',
    `certification_status` STRING COMMENT 'Current overall status of the suppliers certifications.. Valid values are `active|expired|pending`',
    `city` STRING COMMENT 'City component of the suppliers primary address.',
    `commodity_specialization` STRING COMMENT 'Specific commodity or material the supplier specializes in providing.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code of the suppliers primary location.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the supplier record was first created.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit amount approved for the supplier.',
    `currency_code` STRING COMMENT 'Default currency used for transactions with the supplier.',
    `deactivation_date` DATE COMMENT 'Date when the supplier record was marked inactive or blocked.',
    `duns_number` STRING COMMENT 'Dun & Bradstreet unique identifier for the supplier organization.',
    `iatf16949_cert_expiry` DATE COMMENT 'Expiration date of the suppliers IATF 16949 certification.',
    `iatf16949_certified` BOOLEAN COMMENT 'Indicates whether the supplier holds a valid IATF 16949 certification.',
    `incoterms` STRING COMMENT 'International commercial terms defining delivery responsibilities.. Valid values are `EXW|FOB|CIF|DAP|DDP`',
    `iso14001_cert_expiry` DATE COMMENT 'Expiration date of the ISO 14001 certification.',
    `iso14001_certified` BOOLEAN COMMENT 'Indicates whether the supplier holds an ISO 14001 environmental certification.',
    `iso9001_cert_expiry` DATE COMMENT 'Expiration date of the ISO 9001 certification.',
    `iso9001_certified` BOOLEAN COMMENT 'Indicates whether the supplier is ISO 9001 certified.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the supplier record.',
    `lead_time_days` STRING COMMENT 'Typical number of days from order placement to delivery.',
    `legal_name` STRING COMMENT 'Full legal registered name of the supplier entity.',
    `max_order_quantity` BIGINT COMMENT 'Largest quantity the supplier can deliver in a single order.',
    `min_order_quantity` BIGINT COMMENT 'Smallest quantity the supplier accepts per purchase order.',
    `procurement_supplier_name` STRING COMMENT 'Primary display name of the supplier used in procurement processes.',
    `onboarding_date` DATE COMMENT 'Date when the supplier was first approved for procurement.',
    `payment_terms` STRING COMMENT 'Standard payment condition agreed with the supplier.. Valid values are `net30|net45|net60|cash|prepaid`',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the suppliers primary address.',
    `preferred_language` STRING COMMENT 'Language used for communications with the supplier.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary procurement contact.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Name of the main contact person for procurement communications.',
    `primary_contact_phone` STRING COMMENT 'Telephone number of the primary procurement contact.',
    `procurement_supplier_status` STRING COMMENT 'Current operational status of the supplier record.. Valid values are `active|inactive|blocked|under_development`',
    `rating_score` DECIMAL(18,2) COMMENT 'Overall performance rating assigned by the procurement team.',
    `risk_score` DECIMAL(18,2) COMMENT 'Risk assessment score based on financial, compliance, and operational factors.',
    `state_province` STRING COMMENT 'State or province of the suppliers primary address.',
    `supplier_category` STRING COMMENT 'Broad business category describing the goods or services supplied.. Valid values are `raw_materials|components|services|logistics|technology`',
    `supplier_type` STRING COMMENT 'Classification of the supplier based on its position in the supply chain.. Valid values are `tier-1|tier-2|tier-3|internal|service`',
    `sustainability_score` DECIMAL(18,2) COMMENT 'Score reflecting the suppliers environmental and social sustainability performance.',
    `swift_code` STRING COMMENT 'International bank identifier for cross‑border payments.',
    `tax_identification_number` STRING COMMENT 'Government‑issued tax identifier for the supplier.',
    `vat_number` STRING COMMENT 'Value‑Added Tax registration number for the supplier.',
    `website_url` STRING COMMENT 'Public website address of the supplier.',
    CONSTRAINT pk_procurement_supplier PRIMARY KEY(`procurement_supplier_id`)
) COMMENT 'Master record for all suppliers and vendors providing direct materials (production parts, raw materials) and indirect materials (MRO, tooling, services) to Automotive. Captures supplier identity, classification (tier-1, tier-2, tier-3), business registration details, DUNS number, tax identifiers, payment terms, currency, incoterms, preferred language, supplier status (active, blocked, under-development), IATF 16949 certification status, ISO 9001/14001 certification flags, geographic footprint, commodity specialization, and strategic sourcing category. SSOT for supplier identity within the procurement domain; integrates with SAP MM vendor master.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` (
    `purchase_requisition_id` BIGINT COMMENT 'Unique identifier for the purchase requisition.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Purchase requisitions in automotive are raised for specific inbound parts to replenish production supply. Linking requisition to inbound_part enables part-level demand-driven procurement tracking, lea',
    `mrp_requirement_id` BIGINT COMMENT 'Foreign key linking to inventory.mrp_requirement. Business justification: In automotive MRP-driven procurement, purchase requisitions are automatically generated from MRP requirement records. This FK enables end-to-end demand-to-procurement traceability — a mandatory audit ',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.organization_account. Business justification: Corporate fleet customers trigger internal purchase requisitions via OEM procurement portals. Linking PR to organization_account enables volume commitment tracking, preferred-OEM-program eligibility r',
    `parts_inventory_id` BIGINT COMMENT 'Foreign key linking to dealer.parts_inventory. Business justification: Demand-driven dealer parts replenishment: when a dealer parts_inventory record hits reorder point, the resulting purchase requisition must trace back to the specific inventory record that triggered it',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Required for Plant Requisition Allocation Report linking each requisition to its manufacturing plant.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: In SAP MM, a purchase requisition is converted into a purchase order (is_converted_to_po flag already exists on the PR). The purchase_requisition table currently stores purchase_order_number as a deno',
    `production_schedule_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_schedule. Business justification: In automotive MRP (SAP PP→MM), production schedules drive MRP runs that generate purchase requisitions. Linking requisition back to originating production schedule enables S&OP reporting, schedule-dri',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Requisition planning and allocation reports need the SKU master to forecast demand and allocate inventory.',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: In SAP MM sourcing, a purchase requisition can be assigned a source of supply which may be a supplier contract (outline agreement). The purchase_requisition table has a source_of_supply STRING field t',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Equipment Requisition initiates creation of a new equipment asset; linking requisition to equipment registry enables traceability from request to asset.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: In automotive build-to-order, a confirmed vehicle order triggers purchase requisitions for specific components via order-driven MRP. Direct PR-to-vehicle-order traceability is required for delivery da',
    `account_assignment_category` STRING COMMENT 'Category indicating how the cost will be allocated (e.g., cost center, project).. Valid values are `cost_center|project|asset|order`',
    `approval_status` STRING COMMENT 'Current approval state of the requisition.. Valid values are `pending|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the requisition was approved.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for the estimated value.. Valid values are `^[A-Z]{3}$`',
    `estimated_value` DECIMAL(18,2) COMMENT 'Estimated monetary value of the requisition before approval.',
    `is_converted_to_po` BOOLEAN COMMENT 'Indicates whether the requisition has been converted into a purchase order.',
    `notes` STRING COMMENT 'Free‑text field for additional comments or special instructions.',
    `payment_terms` STRING COMMENT 'Standard payment terms (e.g., NET30) associated with the requisition.',
    `priority` STRING COMMENT 'Priority level assigned to the requisition for processing urgency.. Valid values are `low|medium|high|critical`',
    `procurement_type` STRING COMMENT 'Indicates whether the requisition is for direct materials, indirect, services, or capital assets.. Valid values are `direct|indirect|service|capital`',
    `purchase_group` STRING COMMENT 'Organizational group responsible for processing the requisition.',
    `purchase_requisition_status` STRING COMMENT 'Current lifecycle status of the requisition.. Valid values are `draft|submitted|approved|rejected|closed|cancelled`',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of the material or service requested.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the record was first captured in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `required_delivery_date` DATE COMMENT 'Date by which the material or service is needed.',
    `requisition_date` DATE COMMENT 'Date when the requisition was initially created.',
    `requisition_number` STRING COMMENT 'Business identifier assigned to the purchase requisition.',
    `source_of_supply` STRING COMMENT 'Specifies if the supply is internal, external vendor, or consignment.. Valid values are `internal|external|consignment`',
    `tax_code` STRING COMMENT 'Tax classification code applicable to the requisition.',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is expressed (e.g., EA, KG, L).',
    CONSTRAINT pk_purchase_requisition PRIMARY KEY(`purchase_requisition_id`)
) COMMENT 'Internal request to procure direct or indirect materials, tooling, or services. Captures requisition number, requestor, cost center, plant, material/service description, quantity, required delivery date, estimated value, account assignment category (cost center, project, asset), approval status, and conversion-to-PO status. Represents the demand signal that initiates the procure-to-pay cycle. Sourced from SAP MM MRP-generated or manually created purchase requisitions (BANF/EBAN).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` (
    `procurement_purchase_order_id` BIGINT COMMENT 'System-generated unique identifier for the purchase order record.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Incoming Inspection Planning: each PO is assigned an inspection plan used by quality to inspect received parts; standard practice in automotive manufacturing.',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: Automotive procurement pre-assigns inbound logistics lanes at PO creation for freight cost allocation, carrier compliance, and OTD tracking. Linking PO to lane enables landed cost calculation and inbo',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or site receiving the goods/services.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Needed for Line Delivery Schedule to allocate PO deliveries to specific production lines.',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the underlying procurement contract or framework agreement, if applicable.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Capital Equipment Procurement process requires linking PO to the registered equipment asset for depreciation, warranty, and maintenance tracking.',
    `account_assignment` STRING COMMENT 'Cost object (e.g., cost center, internal order) to which the PO costs are charged.',
    `approval_status` STRING COMMENT 'Current status of the internal approval workflow for the PO.. Valid values are `pending|approved|rejected`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the purchase order record was first inserted into the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter code of the currency used for the monetary amounts.. Valid values are `USD|EUR|JPY|CNY|GBP|CHF`',
    `currency_rate` DECIMAL(18,2) COMMENT 'Rate used to convert foreign currency amounts to the company code currency.',
    `delivery_date` DATE COMMENT 'Planned date by which the supplier should deliver the ordered items.',
    `goods_receipt_date` DATE COMMENT 'Date on which the ordered goods were physically received at the plant.',
    `gr_ir_control_flag` BOOLEAN COMMENT 'Indicates whether Goods Receipt/Invoice Receipt (GR/IR) posting is active for this PO.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total payable amount including net amount, taxes, and any surcharges.',
    `incoterms` STRING COMMENT 'Standardized trade terms defining delivery responsibilities and costs.. Valid values are `EXW|FCA|CPT|CIP|DAP|DDP`',
    `invoice_receipt_date` DATE COMMENT 'Date on which the suppliers invoice was recorded in the system.',
    `net_amount` DECIMAL(18,2) COMMENT 'Total amount of the purchase order before taxes, fees, and discounts.',
    `order_date` DATE COMMENT 'Date on which the purchase order was created or released.',
    `payment_terms` STRING COMMENT 'Negotiated terms governing when and how the supplier will be paid.',
    `po_number` STRING COMMENT 'Externally visible purchase order number assigned by the procurement system.',
    `po_type` STRING COMMENT 'Category of the purchase order indicating its procurement contract model.. Valid values are `standard|blanket|consignment|subcontract|service`',
    `procurement_purchase_order_status` STRING COMMENT 'Current lifecycle state of the purchase order within the procure-to-pay process.. Valid values are `draft|released|approved|partially_received|closed|cancelled`',
    `purchase_group` STRING COMMENT 'Organizational group responsible for processing the purchase order.',
    `purchasing_organization` STRING COMMENT 'Entity within the enterprise that conducts procurement activities.',
    `supplier_name` STRING COMMENT 'Legal name of the supplier organization.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Aggregate tax amount applicable to the purchase order.',
    `tax_code` STRING COMMENT 'Code representing the tax jurisdiction and rate applied to the PO.',
    `total_quantity` BIGINT COMMENT 'Aggregate quantity of all line items on the purchase order.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the purchase order record.',
    CONSTRAINT pk_procurement_purchase_order PRIMARY KEY(`procurement_purchase_order_id`)
) COMMENT 'Legally binding procurement document issued to a supplier for delivery of direct materials, indirect materials, MRO, tooling, or services. Captures PO number, PO type (standard, blanket, consignment, subcontracting, service), supplier, plant, delivery date, incoterms, payment terms, total net value, currency, tax code, account assignment, approval workflow status, and GR/IR (Goods Receipt/Invoice Receipt) control flags. Core transactional entity of the procure-to-pay process. Sourced from SAP MM (EKKO/EKPO).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` (
    `procurement_po_line_id` BIGINT COMMENT 'Unique surrogate key for each purchase order line item.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Procurement PO lines in automotive order specific inbound parts. While sku_master_id exists, linking directly to inbound_part enables PPAP level validation, lead time verification, engineering change ',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Line‑level inspection: each PO line (material) follows a specific inspection plan defined by quality for incoming inspection.',
    `plant_id` BIGINT COMMENT 'FK to manufacturing.plant',
    `procurement_purchase_order_id` BIGINT COMMENT 'Identifier of the purchase order header to which this line belongs.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the vendor supplying the material.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: PO receipt matching uses SKU master to update stock; PO lines must reference the exact SKU for inventory posting.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: PO lines in automotive procurement specify the destination storage location for inbound delivery (line-side buffer, incoming inspection area). This FK enables inbound logistics scheduling, capacity pl',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: In SAP MM, purchase order lines can reference a contract (scheduling agreement or value contract) at the line level, independent of the header-level contract reference. The procurement_po_line table c',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Supports Work Center Procurement Tracking, tying each PO line to the work center that will consume the material.',
    `account_assignment_category` STRING COMMENT 'Category indicating how costs are allocated (e.g., cost center, order).. Valid values are `K|P|U|F|M`',
    `batch_management_flag` BOOLEAN COMMENT 'True if the material is managed in batches.',
    `batch_number` STRING COMMENT 'Identifier of the batch when batch management is active.',
    `confirmation_date` TIMESTAMP COMMENT 'Date and time when the line was confirmed by the supplier.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the PO line record was created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the line amounts.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `delivery_date` DATE COMMENT 'Planned date for goods receipt as requested by the buyer.',
    `goods_receipt_date` DATE COMMENT 'Actual date when the material was received.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Line amount before tax (quantity * net_price).',
    `internal_order_number` STRING COMMENT 'Internal order linked to the PO line for project accounting.',
    `invoice_number` STRING COMMENT 'Reference number of the supplier invoice linked to this line.',
    `invoice_receipt_date` DATE COMMENT 'Date the supplier invoice was recorded.',
    `is_blocked` BOOLEAN COMMENT 'True if the line is currently blocked from processing.',
    `is_deleted` BOOLEAN COMMENT 'True if the line has been logically deleted.',
    `last_updated_by` STRING COMMENT 'User identifier who last modified the PO line.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the PO line.',
    `line_number` STRING COMMENT 'Sequential number of the line within the purchase order.',
    `line_status` STRING COMMENT 'Current processing status of the PO line.. Valid values are `open|confirmed|closed|canceled`',
    `net_amount` DECIMAL(18,2) COMMENT 'Line amount after tax (gross_amount - tax_amount).',
    `net_price` DECIMAL(18,2) COMMENT 'Net price (excluding tax) for a single unit of the material.',
    `over_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowed percentage over the ordered quantity.',
    `ppap_level` STRING COMMENT 'Production Part Approval Process level required for the part.. Valid values are `Level0|Level1|Level2|Level3|Level4`',
    `price_condition` STRING COMMENT 'Condition type that determines pricing logic for the line.. Valid values are `Standard|Discount|Special`',
    `purchasing_group` STRING COMMENT 'Buyer or group responsible for the procurement.',
    `quality_inspection_required` BOOLEAN COMMENT 'True if a quality inspection is mandatory for the received goods.',
    `quantity_ordered` DECIMAL(18,2) COMMENT 'Amount of material requested on this line.',
    `release_number` STRING COMMENT 'Release identifier for the purchase order (e.g., for multi‑release PO).',
    `remarks` STRING COMMENT 'Free‑form comments or notes entered by users.',
    `short_text` STRING COMMENT 'Brief free‑form text entered on the PO line.',
    `source_of_supply` STRING COMMENT 'Indicates whether the material is supplied internally, externally, or on consignment.. Valid values are `internal|external|consignment`',
    `supplier_part_number` STRING COMMENT 'Vendors own part number for the material.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount calculated for the line.',
    `tax_code` STRING COMMENT 'Tax classification code applicable to the line.',
    `under_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowed percentage under the ordered quantity.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the ordered quantity.. Valid values are `EA|KG|L|M|SET`',
    CONSTRAINT pk_procurement_po_line PRIMARY KEY(`procurement_po_line_id`)
) COMMENT 'Individual line item within a purchase order, representing a specific material, service, or part number being procured. Captures line number, material number, short text, quantity ordered, unit of measure, net price, delivery date, storage location, batch management flag, PPAP level required, over/under-delivery tolerance, and line-level confirmation status. Enables granular spend tracking and goods receipt matching at the part level. Sourced from SAP MM PO item table (EKPO).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` (
    `supplier_contract_id` BIGINT COMMENT 'System-generated unique identifier for the supplier contract record.',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: Automotive supplier contracts specify inbound logistics lanes (origin-destination pairs) governing delivery terms, incoterms, and carrier requirements. Procurement teams use this to enforce contractua',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier party associated with the contract.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the contract received formal approval.',
    `audit_trail_notes` STRING COMMENT 'Chronological notes of significant changes, approvals, or exceptions.',
    `compliance_requirements` STRING COMMENT 'List of regulatory or industry standards the contract must satisfy (e.g., IATF 16949, ISO 14001).',
    `contract_category` STRING COMMENT 'High‑level grouping of the contract purpose (e.g., direct material, indirect services, capital expenditure).. Valid values are `direct_material|indirect_material|service|capex`',
    `contract_description` STRING COMMENT 'Free‑text description summarizing the purpose and scope of the contract.',
    `contract_document_url` STRING COMMENT 'Link to the electronic version of the signed contract document.',
    `contract_number` STRING COMMENT 'External business identifier assigned to the contract by the organization or supplier.',
    `contract_scope` STRING COMMENT 'Defines the functional or product areas covered by the contract.',
    `contract_type` STRING COMMENT 'Classification of the contract based on its pricing and quantity structure.. Valid values are `value|quantity|scheduling|framework`',
    `contract_version` STRING COMMENT 'Sequential version number tracking amendments to the contract.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the contract record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO code of the currency used for contract amounts.. Valid values are `^[A-Z]{3}$`',
    `delivery_schedule_description` STRING COMMENT 'Narrative of agreed delivery cadence, lead times, and sequencing.',
    `effective_end_date` DATE COMMENT 'Date on which the contract expires or is scheduled to end; null for open‑ended contracts.',
    `effective_start_date` DATE COMMENT 'Date on which the contract becomes legally binding.',
    `governing_law` STRING COMMENT 'Legal jurisdiction whose laws govern the contract.',
    `is_master_agreement` BOOLEAN COMMENT 'Flag indicating whether this contract serves as a framework (master) agreement for multiple release orders.',
    `jurisdiction` STRING COMMENT 'ISO country code where the contract is executed or enforced.. Valid values are `^[A-Z]{3}$`',
    `last_amended_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent amendment to contract terms.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the contract record.',
    `payment_terms` STRING COMMENT 'Standard payment condition code (e.g., NET30, NET60).',
    `penalty_clause` STRING COMMENT 'Text describing penalties for late delivery, quality breaches, or other defaults.',
    `price_escalation_clause` STRING COMMENT 'Text describing any price adjustment mechanisms tied to indices or time.',
    `renewal_option` STRING COMMENT 'Indicates whether the contract renews automatically, requires manual action, or does not renew.. Valid values are `auto|manual|none`',
    `supplier_contract_status` STRING COMMENT 'Current lifecycle state of the contract.. Valid values are `draft|active|suspended|terminated|expired`',
    `termination_notice_period_days` STRING COMMENT 'Number of days the buyer must notify the supplier before terminating the contract.',
    `total_contract_value` DECIMAL(18,2) COMMENT 'Aggregate monetary value of the contract over its full term.',
    `volume_commitment_quantity` BIGINT COMMENT 'Total quantity of goods or services the buyer commits to purchase under the contract.',
    `volume_commitment_uom` STRING COMMENT 'Unit of measure for the volume commitment (e.g., pieces, kilograms).. Valid values are `pcs|kg|liters|units|meters|hours`',
    CONSTRAINT pk_supplier_contract PRIMARY KEY(`supplier_contract_id`)
) COMMENT 'Long-term procurement contract (outline agreement) with a supplier covering pricing, volume commitments, delivery schedules, quality requirements, and commercial terms for direct or indirect materials. Captures contract type (value contract, quantity contract, scheduling agreement), validity period, target value, release order documentation requirement, price escalation clauses, penalty terms, and contract status. Supports blanket PO releases and scheduling agreement delivery lines. Sourced from SAP MM contract (EKKO with doc type MK/WK).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` (
    `procurement_goods_receipt_id` BIGINT COMMENT 'System-generated unique identifier for the goods receipt record.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Goods receipts in automotive must be traceable to the specific inbound part received for quality inspection lot creation, hazardous material handling, customs tariff verification, and lot-size-based i',
    `plant_id` BIGINT COMMENT 'Identifier of the user who posted the goods receipt.',
    `procurement_po_line_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line. Business justification: In SAP MM, goods receipts are posted at the PO line item level (not just the header). The procurement_goods_receipt table currently stores purchase_order_item as a denormalized INT (line number), whic',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: In SAP MM, every goods receipt (movement type 101) is posted against a specific purchase order. The procurement_goods_receipt table currently stores purchase_order_number as a denormalized STRING, whi',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier (vendor) from whom the goods were received.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Goods receipt posting updates stock balances; FK to SKU master ensures correct inventory item is credited.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Goods receipt posting in automotive manufacturing requires recording the exact destination storage location (GR zone, quality hold, raw material store) for inventory accuracy, 3-way match reporting, a',
    `accounting_document_number` STRING COMMENT 'Financial accounting document generated for the receipt.',
    `accounting_year` STRING COMMENT 'Fiscal year of the accounting document.',
    `batch_number` STRING COMMENT 'Batch or lot identifier for the received material, if applicable.',
    `cost_center_code` STRING COMMENT 'Cost center to which the receipt cost is charged.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the goods receipt record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary amounts.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total value of the receipt before taxes and discounts.',
    `invoice_match_status` STRING COMMENT 'Three‑way match status between PO, receipt, and invoice.. Valid values are `matched|unmatched|partial`',
    `is_blocked_stock` BOOLEAN COMMENT 'True if the receipt created blocked stock (movement type 103).',
    `is_quality_inspection_required` BOOLEAN COMMENT 'Indicates whether a quality inspection is mandatory for this receipt.',
    `movement_type` STRING COMMENT 'SAP movement type code (e.g., 101 = standard receipt, 103 = blocked stock).. Valid values are `101|103|105`',
    `net_amount` DECIMAL(18,2) COMMENT 'Net value after taxes and discounts.',
    `posting_date` DATE COMMENT 'Date on which the receipt was posted to financial accounting.',
    `procurement_goods_receipt_status` STRING COMMENT 'Current lifecycle status of the receipt.. Valid values are `posted|reversed|pending`',
    `profit_center_code` STRING COMMENT 'Profit center associated with the receipt.',
    `quality_inspection_result` STRING COMMENT 'Outcome of the quality inspection for the receipt.. Valid values are `passed|failed|pending`',
    `quantity_received` DECIMAL(18,2) COMMENT 'Amount of material received, expressed in the unit of measure.',
    `receipt_number` STRING COMMENT 'External business identifier assigned to the goods receipt (e.g., GR document number).',
    `receipt_timestamp` TIMESTAMP COMMENT 'Date and time when the goods receipt event occurred in the plant.',
    `receipt_type` STRING COMMENT 'Classification of the receipt (e.g., standard receipt, return, stock transfer).. Valid values are `standard|return|transfer`',
    `slip_number` STRING COMMENT 'Physical slip or document number associated with the receipt.',
    `source_system_load_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was loaded from the source system into the lakehouse.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component associated with the receipt.',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is measured.. Valid values are `EA|KG|L|M|PCS`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the goods receipt record.',
    `vendor_invoice_number` STRING COMMENT 'Invoice number supplied by the vendor for the received goods.',
    CONSTRAINT pk_procurement_goods_receipt PRIMARY KEY(`procurement_goods_receipt_id`)
) COMMENT 'Record of physical receipt of materials or services at an Automotive plant or warehouse against a purchase order or scheduling agreement. Captures GR document number, posting date, material document number, plant, storage location, received quantity, unit of measure, batch number, quality inspection lot reference, GR slip number, and movement type (101 standard GR, 103 GR blocked stock). Triggers inventory update and initiates three-way match for invoice verification. Sourced from SAP MM material document (MSEG/MKPF).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` (
    `supplier_invoice_id` BIGINT COMMENT 'Unique surrogate key for supplier invoice.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer-specific AP reporting and three-way match: supplier invoices for parts ordered by or on behalf of a dealership must be reconciled at dealer level. OEM finance teams run dealer-level invoice agi',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Invoice cost allocation to cost center is required for budgeting and profitability analysis.',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_goods_receipt. Business justification: Three-way match (PO + GR + Invoice) is the cornerstone of automotive procurement invoice verification in SAP MM. The supplier_invoice table currently stores goods_receipt_number as a denormalized STRI',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: In SAP MM invoice verification (MIRO), every supplier invoice references a purchase order for two-way or three-way matching. The supplier_invoice table currently stores purchase_order_number as a deno',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier who issued the invoice.',
    `accounting_document_number` STRING COMMENT 'GL document number generated for the invoice.',
    `attachment_flag` BOOLEAN COMMENT 'Indicates if supporting documents are attached.',
    `blocking_reason` STRING COMMENT 'Reason why invoice is blocked from payment.',
    `comments` STRING COMMENT 'Free-text comments or notes attached to the invoice.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the invoice record was created in the data lake.',
    `currency_code` STRING COMMENT 'Three-letter currency code of the invoice amount.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to the invoice.',
    `due_date` DATE COMMENT 'Date by which payment must be made according to payment terms.',
    `ean_number` STRING COMMENT 'European Article Number for the supplied product (if applicable).',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Rate used to convert invoice currency to company currency.',
    `fiscal_year` STRING COMMENT 'Fiscal year of the invoice posting.. Valid values are `^[0-9]{4}$`',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total amount before taxes and discounts.',
    `internal_order_number` STRING COMMENT 'Internal order identifier for project-related expenses.',
    `invoice_currency_amount` DECIMAL(18,2) COMMENT 'Total amount in invoice currency before conversion.',
    `invoice_date` DATE COMMENT 'Date the supplier issued the invoice.',
    `invoice_number` STRING COMMENT 'Unique invoice number assigned by supplier.',
    `invoice_type` STRING COMMENT 'Indicates whether invoice is for goods, services, or both.. Valid values are `goods|services|both`',
    `line_item_count` STRING COMMENT 'Number of line items on the invoice.',
    `net_amount` DECIMAL(18,2) COMMENT 'Amount payable after taxes and discounts.',
    `payment_date` DATE COMMENT 'Date when payment was made.',
    `payment_method` STRING COMMENT 'Method used to settle the invoice.. Valid values are `bank_transfer|credit_card|check|cash|other`',
    `payment_reference` STRING COMMENT 'Reference number of the payment transaction.',
    `payment_status` STRING COMMENT 'Current payment status of the invoice.. Valid values are `paid|unpaid|partially_paid|blocked`',
    `payment_terms` STRING COMMENT 'Terms defining payment schedule (e.g., Net 30).',
    `posting_date` DATE COMMENT 'Date the invoice was posted to the general ledger.',
    `profit_center_code` STRING COMMENT 'Profit center linked to the invoice.',
    `reference` STRING COMMENT 'Reference number used by supplier for internal tracking.',
    `supplier_address_line` STRING COMMENT 'Street address of the supplier.',
    `supplier_city` STRING COMMENT 'City where the supplier is located.',
    `supplier_country_code` STRING COMMENT 'Three-letter ISO country code of the supplier.. Valid values are `^[A-Z]{3}$`',
    `supplier_invoice_status` STRING COMMENT 'Overall lifecycle status of the invoice.. Valid values are `open|closed|cancelled|reversed`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applied to the invoice.',
    `tax_code` STRING COMMENT 'Code representing tax jurisdiction and rate.',
    `tax_exempt_flag` BOOLEAN COMMENT 'Indicates if the invoice is tax-exempt.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate percentage.',
    `three_way_match_status` STRING COMMENT 'Result of PO/GR/Invoice three-way match.. Valid values are `matched|mismatched|pending`',
    `tolerance_check_result` STRING COMMENT 'Outcome of tolerance check on price/quantity differences.. Valid values are `within|exceeded|not_applicable`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the invoice record.',
    `vat_number` STRING COMMENT 'Suppliers VAT registration number.',
    CONSTRAINT pk_supplier_invoice PRIMARY KEY(`supplier_invoice_id`)
) COMMENT 'Supplier-submitted invoice for goods or services delivered to Automotive, processed through SAP MM invoice verification (Logistics Invoice Verification - LIV). Captures invoice number, supplier invoice reference, invoice date, posting date, gross amount, tax amount, currency, payment terms, due date, three-way match status (PO/GR/Invoice), tolerance check result, blocking reason, and payment status. Enables accounts payable processing and spend actuals capture. Sourced from SAP MM invoice document (RBKP/RSEG).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` (
    `approved_vendor_list_id` BIGINT COMMENT 'System-generated unique identifier for each approved vendor list record.',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.audit. Business justification: AVL approval and re-qualification in automotive supplier management is directly driven by supplier audit outcomes (IATF 16949 supplier audits). Procurement teams reference the qualifying audit when gr',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer vendor authorization compliance: OEMs maintain dealer-specific AVL entries to enforce which suppliers dealers may source warranty-eligible parts from. Compliance audits and warranty claim valid',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: AVL entries in automotive are per supplier-part combination — a supplier is approved to supply a specific part. Linking AVL to inbound_part completes the supplier-part approval record required for PPA',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: The AVL is fundamentally a supplier-to-part approval record required by IATF16949 and PPAP processes — each entry approves a specific supplier for a specific part (SKU). Without this FK, AVL cannot en',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the underlying supplier contract governing the AVL.',
    `supply_supplier_id` BIGINT COMMENT 'Unique identifier of the material or part covered by the AVL.',
    `approval_date` DATE COMMENT 'Date the approval becomes effective (start of validity).',
    `approval_status` STRING COMMENT 'Current status of the AVL entry indicating if the supplier is approved, conditionally approved, or disqualified.. Valid values are `approved|conditional|disqualified`',
    `avl_number` STRING COMMENT 'Unique alphanumeric code assigned to the approved vendor list entry.',
    `backup_supplier_flag` BOOLEAN COMMENT 'True if the supplier serves as a backup source for the material.',
    `compliance_status` STRING COMMENT 'Indicates whether the supplier-material combination meets regulatory and IATF 16949 requirements.. Valid values are `compliant|non_compliant|pending`',
    `created_by_user` STRING COMMENT 'User identifier who created the AVL record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the AVL record was first inserted into the lakehouse.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code used for any price‑related fields in the AVL.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `entry_date` DATE COMMENT 'Date the AVL record was initially created in the system.',
    `expiry_date` DATE COMMENT 'Date the AVL entry expires or must be re‑validated.',
    `last_review_date` DATE COMMENT 'Most recent date the AVL entry was reviewed for continued eligibility.',
    `lead_time_days` STRING COMMENT 'Standard supplier lead time in calendar days for the material.',
    `min_order_quantity` STRING COMMENT 'Minimum quantity that must be ordered per purchase order for this AVL.',
    `notes` STRING COMMENT 'Free‑form comments or observations about the AVL entry.',
    `ppap_approval_level` STRING COMMENT 'Production Part Approval Process level achieved for the supplier-material combination.. Valid values are `Level1|Level2|Level3|Level4|Level5`',
    `preferred_supplier_flag` BOOLEAN COMMENT 'True if the supplier is designated as a preferred source for the material.',
    `price_cap` DECIMAL(18,2) COMMENT 'Maximum unit price the supplier may charge for the material under this AVL.',
    `quality_rating_threshold` DECIMAL(18,2) COMMENT 'Minimum quality rating percentage the supplier must maintain for this material.',
    `regulatory_approval_required` BOOLEAN COMMENT 'True if additional regulatory approval (e.g., EPA, NHTSA) is required for the material.',
    `review_cycle_months` STRING COMMENT 'Number of months between mandatory AVL reviews.',
    `single_source_justification` STRING COMMENT 'Narrative explanation for why a single source supplier is required.',
    `source_list_flag` BOOLEAN COMMENT 'True if the AVL entry is reflected in SAP MM source list (EORD).',
    `updated_by_user` STRING COMMENT 'User identifier who last modified the AVL record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the AVL record.',
    CONSTRAINT pk_approved_vendor_list PRIMARY KEY(`approved_vendor_list_id`)
) COMMENT 'Formally approved supplier-material combination (AVL) authorizing a specific supplier to supply a specific part number or commodity to Automotive plants. Captures AVL entry date, approval status (approved, conditional, disqualified), PPAP approval level, quality rating threshold, preferred supplier flag, backup supplier flag, single-source justification, and expiry date. Governs which suppliers are eligible to receive purchase orders for specific materials. Integrates with SAP MM source list (EORD).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`info_record` (
    `info_record_id` BIGINT COMMENT 'System-generated unique identifier for the purchasing info record.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: The procurement info record (SAP PIR) holds supplier-material price, lead time, and ordering conditions for a specific part. Linking info_record to inbound_part completes the supplier-material combina',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Purchasing info records in automotive procurement define the inspection plan for a supplier-part combination. The info_record drives automatic inspection plan assignment on PO creation — a standard SA',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Purchasing info records in automotive procurement are keyed on supplier + material (SKU), storing negotiated price, lead time, and delivery conditions per part. Without a sku_master_id FK, info record',
    `supply_supplier_id` BIGINT COMMENT 'Unique identifier of the material or service category covered by this info record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the info record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the price.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `effective_from` DATE COMMENT 'Date on which the info record becomes effective.',
    `effective_until` DATE COMMENT 'Date on which the info record expires (null if open‑ended).',
    `info_record_number` STRING COMMENT 'Business identifier assigned to the info record, e.g., IR00001234.. Valid values are `^IR[0-9]{8}$`',
    `info_record_status` STRING COMMENT 'Current lifecycle status of the info record.. Valid values are `active|inactive|blocked|pending`',
    `info_record_type` STRING COMMENT 'Classification of the info record (standard, contract, or framework agreement).. Valid values are `standard|contract|framework`',
    `last_price_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent price change.',
    `lead_time_days` STRING COMMENT 'Planned delivery lead time in days from order to receipt.',
    `minimum_order_quantity` STRING COMMENT 'Minimum quantity that must be ordered under this info record.',
    `notes` STRING COMMENT 'Free‑form comments or special instructions related to the info record.',
    `order_quantity_uom` STRING COMMENT 'Unit of measure for the minimum order quantity.. Valid values are `EA|KG|L|M|PCS|BOX`',
    `over_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowed percentage over the ordered quantity.',
    `price_amount` DECIMAL(18,2) COMMENT 'Negotiated price per unit of the material or service.',
    `price_valid_from` DATE COMMENT 'Start date of the price validity period.',
    `price_valid_until` DATE COMMENT 'End date of the price validity period.',
    `procurement_category` STRING COMMENT 'Indicates whether the material is procured as direct or indirect.. Valid values are `direct|indirect`',
    `reminder_days` STRING COMMENT 'Number of days before price expiry to trigger a reminder.',
    `under_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowed percentage under the ordered quantity.',
    `updated_by` STRING COMMENT 'System user identifier who last updated the record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the info record.',
    `vendor_evaluation_score` DECIMAL(18,2) COMMENT 'Score (0‑5) reflecting supplier performance for this material.',
    `created_by` STRING COMMENT 'System user identifier who created the record.',
    CONSTRAINT pk_info_record PRIMARY KEY(`info_record_id`)
) COMMENT 'Purchasing info record storing the commercial relationship between a supplier and a specific material or service category, including the last negotiated price, price validity period, planned delivery time, over/under-delivery tolerance, reminder days, and vendor evaluation score. Serves as the default pricing and delivery condition source when creating purchase orders. Sourced from SAP MM purchasing info record (EINE/EINA/ME11).';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ADD CONSTRAINT `fk_procurement_procurement_supplier_parent_supplier_procurement_supplier_id` FOREIGN KEY (`parent_supplier_procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_po_line_id` FOREIGN KEY (`procurement_po_line_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_po_line`(`procurement_po_line_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ADD CONSTRAINT `fk_procurement_approved_vendor_list_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`procurement` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`procurement` SET TAGS ('dbx_domain' = 'procurement');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier (SUPPLIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `parent_supplier_procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Supplier Identifier (PARENT_SUPPLIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Supplier Address Line 1 (ADDRESS_LINE1)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number (BANK_ACCOUNT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `bank_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Name (BANK_NAME)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Overall Certification Status (CERTIFICATION_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'active|expired|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'Supplier City (CITY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `commodity_specialization` SET TAGS ('dbx_business_glossary_term' = 'Commodity Specialization (COMMODITY_SPECIALIZATION)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Country Code (COUNTRY_CODE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit (CREDIT_LIMIT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `credit_limit` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code (CURRENCY_CODE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `deactivation_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Deactivation Date (DEACTIVATION_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'DUNS Number (DUNS_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `duns_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `duns_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `iatf16949_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'IATF 16949 Certification Expiry Date (IATF16949_CERT_EXPIRY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `iatf16949_certified` SET TAGS ('dbx_business_glossary_term' = 'IATF 16949 Certification Flag (IATF16949_CERTIFIED)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms (INCOTERMS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `incoterms` SET TAGS ('dbx_value_regex' = 'EXW|FOB|CIF|DAP|DDP');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `iso14001_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Certification Expiry Date (ISO14001_CERT_EXPIRY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `iso14001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Certification Flag (ISO14001_CERTIFIED)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `iso9001_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certification Expiry Date (ISO9001_CERT_EXPIRY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `iso9001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certification Flag (ISO9001_CERTIFIED)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp (LAST_UPDATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Average Lead Time (LEAD_TIME_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `legal_name` SET TAGS ('dbx_business_glossary_term' = 'Legal Supplier Name (LEGAL_NAME)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `max_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity (MAX_ORDER_QUANTITY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MIN_ORDER_QUANTITY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `procurement_supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Name (SUPPLIER_NAME)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Onboarding Date (ONBOARDING_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (PAYMENT_TERMS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net30|net45|net60|cash|prepaid');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Postal Code (POSTAL_CODE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `preferred_language` SET TAGS ('dbx_business_glossary_term' = 'Preferred Language (PREFERRED_LANGUAGE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address (PRIMARY_CONTACT_EMAIL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Person Name (PRIMARY_CONTACT_NAME)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number (PRIMARY_CONTACT_PHONE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `procurement_supplier_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `procurement_supplier_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|under_development');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `rating_score` SET TAGS ('dbx_business_glossary_term' = 'Supplier Rating Score (RATING_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `risk_score` SET TAGS ('dbx_business_glossary_term' = 'Supplier Risk Score (RISK_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'Supplier State or Province (STATE_PROVINCE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `supplier_category` SET TAGS ('dbx_business_glossary_term' = 'Supplier Category (SUPPLIER_CATEGORY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `supplier_category` SET TAGS ('dbx_value_regex' = 'raw_materials|components|services|logistics|technology');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `supplier_type` SET TAGS ('dbx_business_glossary_term' = 'Supplier Type (SUPPLIER_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `supplier_type` SET TAGS ('dbx_value_regex' = 'tier-1|tier-2|tier-3|internal|service');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `sustainability_score` SET TAGS ('dbx_business_glossary_term' = 'Supplier Sustainability Score (SUSTAINABILITY_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `swift_code` SET TAGS ('dbx_business_glossary_term' = 'SWIFT/BIC Code (SWIFT_CODE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `swift_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `swift_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number (TAX_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `vat_number` SET TAGS ('dbx_business_glossary_term' = 'VAT Registration Number (VAT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `vat_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `vat_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Supplier Website URL (WEBSITE_URL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `mrp_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Mrp Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Organization Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `parts_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Parts Inventory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'cost_center|project|asset|order');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `estimated_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Value');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `is_converted_to_po` SET TAGS ('dbx_business_glossary_term' = 'Converted to Purchase Order Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Requisition Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Requisition Priority');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|service|capital');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_group` SET TAGS ('dbx_business_glossary_term' = 'Purchase Group');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|rejected|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Requested Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Required Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisition_date` SET TAGS ('dbx_business_glossary_term' = 'Requisition Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Requisition Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Source of Supply');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_value_regex' = 'internal|external|consignment');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `account_assignment` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CHF');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `currency_rate` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `gr_ir_control_flag` SET TAGS ('dbx_business_glossary_term' = 'GR/IR Control Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount (PO_GROSS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms (International Commercial Terms)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `incoterms` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DDP');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `invoice_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount (PO_NET)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Date (PO_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number (PO_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `po_type` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Type (PO_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `po_type` SET TAGS ('dbx_value_regex' = 'standard|blanket|consignment|subcontract|service');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `procurement_purchase_order_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Status (PO_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `procurement_purchase_order_status` SET TAGS ('dbx_value_regex' = 'draft|released|approved|partially_received|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `purchase_group` SET TAGS ('dbx_business_glossary_term' = 'Purchase Group');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount (PO_TAX)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `total_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `procurement_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Line ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'K|P|U|F|M');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `batch_management_flag` SET TAGS ('dbx_business_glossary_term' = 'Batch Management Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `confirmation_date` SET TAGS ('dbx_business_glossary_term' = 'Line Confirmation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (WAERS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `invoice_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `is_blocked` SET TAGS ('dbx_business_glossary_term' = 'Blocked Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `is_deleted` SET TAGS ('dbx_business_glossary_term' = 'Soft Delete Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `last_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Last Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|confirmed|closed|canceled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price per Unit');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `over_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Over‑Delivery Tolerance (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'PPAP Level Required');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = 'Level0|Level1|Level2|Level3|Level4');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `price_condition` SET TAGS ('dbx_business_glossary_term' = 'Price Condition Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `price_condition` SET TAGS ('dbx_value_regex' = 'Standard|Discount|Special');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `quantity_ordered` SET TAGS ('dbx_business_glossary_term' = 'Quantity Ordered');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `release_number` SET TAGS ('dbx_business_glossary_term' = 'Release Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `short_text` SET TAGS ('dbx_business_glossary_term' = 'Short Text');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Source of Supply');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_value_regex' = 'internal|external|consignment');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Under‑Delivery Tolerance (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (MEINS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|SET');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract ID (SCID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID (SID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp (AT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `audit_trail_notes` SET TAGS ('dbx_business_glossary_term' = 'Audit Trail Notes (ATN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirements (CR)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_category` SET TAGS ('dbx_business_glossary_term' = 'Contract Category (CC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_category` SET TAGS ('dbx_value_regex' = 'direct_material|indirect_material|service|capex');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_description` SET TAGS ('dbx_business_glossary_term' = 'Contract Description (CD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_document_url` SET TAGS ('dbx_business_glossary_term' = 'Contract Document URL (CDU)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number (CN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_scope` SET TAGS ('dbx_business_glossary_term' = 'Contract Scope (CS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type (CT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'value|quantity|scheduling|framework');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_version` SET TAGS ('dbx_business_glossary_term' = 'Contract Version (CV)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp (CT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CCY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `delivery_schedule_description` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Description (DSD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EED)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (ESD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `governing_law` SET TAGS ('dbx_business_glossary_term' = 'Governing Law (GL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `is_master_agreement` SET TAGS ('dbx_business_glossary_term' = 'Is Master Agreement (IMA)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction (JUR)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `last_amended_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Amended Timestamp (LAT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp (LUT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (PT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `penalty_clause` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause (PC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `price_escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Price Escalation Clause (PEC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `renewal_option` SET TAGS ('dbx_business_glossary_term' = 'Renewal Option (RO)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `renewal_option` SET TAGS ('dbx_value_regex' = 'auto|manual|none');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `supplier_contract_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status (CS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `supplier_contract_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|terminated|expired');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `termination_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Termination Notice Period (TNP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `total_contract_value` SET TAGS ('dbx_business_glossary_term' = 'Total Contract Value (TCV)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `volume_commitment_quantity` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Quantity (VCQ)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `volume_commitment_uom` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment UOM (VCU)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `volume_commitment_uom` SET TAGS ('dbx_value_regex' = 'pcs|kg|liters|units|meters|hours');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Receipt User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `accounting_document_number` SET TAGS ('dbx_business_glossary_term' = 'Accounting Document Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `accounting_year` SET TAGS ('dbx_business_glossary_term' = 'Accounting Year');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `invoice_match_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Match Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `invoice_match_status` SET TAGS ('dbx_value_regex' = 'matched|unmatched|partial');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_blocked_stock` SET TAGS ('dbx_business_glossary_term' = 'Blocked Stock Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = '101|103|105');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_goods_receipt_status` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_goods_receipt_status` SET TAGS ('dbx_value_regex' = 'posted|reversed|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Result');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_result` SET TAGS ('dbx_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quantity_received` SET TAGS ('dbx_business_glossary_term' = 'Quantity Received');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_type` SET TAGS ('dbx_business_glossary_term' = 'Receipt Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_type` SET TAGS ('dbx_value_regex' = 'standard|return|transfer');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `slip_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Slip Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `source_system_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Source System Load Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|PCS');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `vendor_invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `accounting_document_number` SET TAGS ('dbx_business_glossary_term' = 'Accounting Document Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `attachment_flag` SET TAGS ('dbx_business_glossary_term' = 'Attachment Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `blocking_reason` SET TAGS ('dbx_business_glossary_term' = 'Blocking Reason');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Due Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `ean_number` SET TAGS ('dbx_business_glossary_term' = 'EAN Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `invoice_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Currency Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number (INV_NO)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_value_regex' = 'goods|services|both');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `line_item_count` SET TAGS ('dbx_business_glossary_term' = 'Line Item Count');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|credit_card|check|cash|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `payment_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'paid|unpaid|partially_paid|blocked');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `reference` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice Reference');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_address_line` SET TAGS ('dbx_business_glossary_term' = 'Supplier Address Line');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_address_line` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_address_line` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_city` SET TAGS ('dbx_business_glossary_term' = 'Supplier City');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Country Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_invoice_status` SET TAGS ('dbx_value_regex' = 'open|closed|cancelled|reversed');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `tax_exempt_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Exempt Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_business_glossary_term' = 'Three-way Match Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_value_regex' = 'matched|mismatched|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `tolerance_check_result` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Check Result');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `tolerance_check_result` SET TAGS ('dbx_value_regex' = 'within|exceeded|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `vat_number` SET TAGS ('dbx_business_glossary_term' = 'VAT Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `vat_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approved_vendor_list_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Vendor List ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Effective Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|conditional|disqualified');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `avl_number` SET TAGS ('dbx_business_glossary_term' = 'Approved Vendor List Number (AVL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `backup_supplier_flag` SET TAGS ('dbx_business_glossary_term' = 'Backup Supplier Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `entry_date` SET TAGS ('dbx_business_glossary_term' = 'Entry Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `ppap_approval_level` SET TAGS ('dbx_business_glossary_term' = 'PPAP Approval Level');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `ppap_approval_level` SET TAGS ('dbx_value_regex' = 'Level1|Level2|Level3|Level4|Level5');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `preferred_supplier_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `price_cap` SET TAGS ('dbx_business_glossary_term' = 'Price Cap (Maximum Allowed Price)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `quality_rating_threshold` SET TAGS ('dbx_business_glossary_term' = 'Quality Rating Threshold (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `regulatory_approval_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Required');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `review_cycle_months` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle (Months)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `single_source_justification` SET TAGS ('dbx_business_glossary_term' = 'Single Source Justification');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `source_list_flag` SET TAGS ('dbx_business_glossary_term' = 'Source List Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Material Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Info Record Number (IRN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_number` SET TAGS ('dbx_value_regex' = '^IR[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_status` SET TAGS ('dbx_business_glossary_term' = 'Info Record Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_type` SET TAGS ('dbx_business_glossary_term' = 'Info Record Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_type` SET TAGS ('dbx_value_regex' = 'standard|contract|framework');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `last_price_update_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Price Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Planned Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Info Record Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `order_quantity_uom` SET TAGS ('dbx_business_glossary_term' = 'Order Quantity Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `order_quantity_uom` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|PCS|BOX');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `over_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Over‑Delivery Tolerance (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `price_amount` SET TAGS ('dbx_business_glossary_term' = 'Unit Price Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `price_valid_from` SET TAGS ('dbx_business_glossary_term' = 'Price Valid From Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `price_valid_until` SET TAGS ('dbx_business_glossary_term' = 'Price Valid Until Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `procurement_category` SET TAGS ('dbx_business_glossary_term' = 'Procurement Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `procurement_category` SET TAGS ('dbx_value_regex' = 'direct|indirect');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `reminder_days` SET TAGS ('dbx_business_glossary_term' = 'Reminder Days');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Under‑Delivery Tolerance (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `vendor_evaluation_score` SET TAGS ('dbx_business_glossary_term' = 'Vendor Evaluation Score');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
