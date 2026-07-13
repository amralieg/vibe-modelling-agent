-- Schema for Domain: procurement | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-13 17:05:58

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`procurement` COMMENT 'Strategic sourcing and procurement operations for direct materials (production parts) and indirect materials (MRO, tooling, services). Manages supplier contracts, SOR (Statement of Requirements), purchase requisitions, purchase orders, goods receipt, invoice verification, and spend analytics. Includes global sourcing strategies, supplier development programs, and CapEx procurement workflows. Integrates with SAP MM and Ariba for procure-to-pay processes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier` (
    `supplier_id` BIGINT COMMENT 'Primary key for local procurement_supplier reference',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_supplier PRIMARY KEY(`supplier_id`)
) COMMENT 'Reference to SSOT owner supply.supply_supplier. Master record for all suppliers and vendors providing direct materials (production parts, raw materials) and indirect materials (MRO, tooling, services) to Automotive. Captures supplier identity, classification (tier-1, tier-2, tier-3), business registration details, DUNS number, tax identifiers, payment terms, currency, incoterms, preferred language, supplier status (active, blocked, under-development), IATF 16949 certification status, ISO 9001/14001 certification flags, geographic footprint, commodity specialization, and strategic sourcing category. SSOT for supplier identity within the procurement domain; integrates with SAP MM vendor master.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` (
    `purchase_requisition_id` BIGINT COMMENT 'Unique identifier for the purchase requisition.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Requisition cost allocation to cost center is required for pre‑PO budgeting and approval.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Requisition GL account enables automatic posting of approved requisitions to the ledger.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Required for Plant Requisition Allocation Report linking each requisition to its manufacturing plant.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: A purchase requisition is converted to a purchase order in the procure-to-pay workflow (is_converted_to_po: BOOLEAN flag already exists on purchase_requisition). purchase_requisition currently stores ',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Requisition planning and allocation reports need the SKU master to forecast demand and allocate inventory.',
    `supplier_id` BIGINT COMMENT 'Identifier of the selected vendor for the requisition (if known).',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Program‑specific purchase requisition; finance and engineering track spend per vehicle program.',
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
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `tax_code` STRING COMMENT 'Tax classification code applicable to the requisition.',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is expressed (e.g., EA, KG, L).',
    CONSTRAINT pk_purchase_requisition PRIMARY KEY(`purchase_requisition_id`)
) COMMENT 'Internal request to procure direct or indirect materials, tooling, or services. Captures requisition number, requestor, cost center, plant, material/service description, quantity, required delivery date, estimated value, account assignment category (cost center, project, asset), approval status, and conversion-to-PO status. Represents the demand signal that initiates the procure-to-pay cycle. Sourced from SAP MM MRP-generated or manually created purchase requisitions (BANF/EBAN).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` (
    `purchase_order_id` BIGINT COMMENT 'System-generated unique identifier for the purchase order record.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Purchase orders are issued by a specific legal entity (company code) for statutory procurement reporting, intercompany PO tracking, and financial consolidation. The purchasing_organization on the PO m',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Required for PO cost allocation report; finance tracks spend by cost center for each purchase order.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: GL account needed for posting PO amounts to the general ledger; mandatory for financial statements.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Incoming Inspection Planning: each PO is assigned an inspection plan used by quality to inspect received parts; standard practice in automotive manufacturing.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or site receiving the goods/services.',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the underlying procurement contract or framework agreement, if applicable.',
    `supplier_id` BIGINT COMMENT 'Unique identifier of the supplier (vendor) to which the purchase order is issued.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Purchase orders are linked to vehicle programs for cost allocation and program profitability analysis.',
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
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Aggregate tax amount applicable to the purchase order.',
    `tax_code` STRING COMMENT 'Code representing the tax jurisdiction and rate applied to the PO.',
    `total_quantity` BIGINT COMMENT 'Aggregate quantity of all line items on the purchase order.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the purchase order record.',
    CONSTRAINT pk_purchase_order PRIMARY KEY(`purchase_order_id`)
) COMMENT 'Legally binding procurement document issued to a supplier for delivery of direct materials, indirect materials, MRO, tooling, or services. Captures PO number, PO type (standard, blanket, consignment, subcontracting, service), supplier, plant, delivery date, incoterms, payment terms, total net value, currency, tax code, account assignment, approval workflow status, and GR/IR (Goods Receipt/Invoice Receipt) control flags. Core transactional entity of the procure-to-pay process. Sourced from SAP MM (EKKO/EKPO).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`po_line` (
    `po_line_id` BIGINT COMMENT 'Unique surrogate key for each purchase order line item.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Cost center allocation per PO line is required for internal cost reporting and variance analysis.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Each PO line maps to a specific expense GL account for detailed ledger posting.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Line‑level inspection: each PO line (material) follows a specific inspection plan defined by quality for incoming inspection.',
    `plant_id` BIGINT COMMENT 'FK to manufacturing.plant',
    `purchase_order_id` BIGINT COMMENT 'Identifier of the purchase order header to which this line belongs.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: PO receipt matching uses SKU master to update stock; PO lines must reference the exact SKU for inventory posting.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: PO lines specify the target storage location for ordered goods, enabling inbound logistics pre-assignment and warehouse slotting. The existing plain-text storage_location column is a denormalization',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: In SAP MM, purchase order lines can be created as release orders against a supplier contract (outline agreement). procurement_po_line currently stores contract_number as a denormalized STRING. Adding ',
    `supplier_id` BIGINT COMMENT 'Unique identifier of the vendor supplying the material.',
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
    `ssot_governance_note` STRING COMMENT '',
    `supplier_part_number` STRING COMMENT 'Vendors own part number for the material.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount calculated for the line.',
    `tax_code` STRING COMMENT 'Tax classification code applicable to the line.',
    `under_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowed percentage under the ordered quantity.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the ordered quantity.. Valid values are `EA|KG|L|M|SET`',
    CONSTRAINT pk_po_line PRIMARY KEY(`po_line_id`)
) COMMENT 'Individual line item within a purchase order, representing a specific material, service, or part number being procured. Captures line number, material number, short text, quantity ordered, unit of measure, net price, delivery date, storage location, batch management flag, PPAP level required, over/under-delivery tolerance, and line-level confirmation status. Enables granular spend tracking and goods receipt matching at the part level. Sourced from SAP MM PO item table (EKPO).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` (
    `supplier_contract_id` BIGINT COMMENT 'System-generated unique identifier for the supplier contract record.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Supplier contracts are legally binding under a specific company code (legal entity). Total contract value, penalty clauses, and payment terms are reported at company code level for financial planning,',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: Automotive supplier technical agreements contractually bind suppliers to specific design specifications (dimensional tolerances, material grades, performance targets). Linking supplier_contract to des',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Contractual spend must be mapped to a GL account for accruals and expense recognition.',
    `platform_id` BIGINT COMMENT 'Foreign key linking to vehicle.platform. Business justification: Automotive suppliers are awarded long-term contracts at the platform level (e.g., common chassis platform spanning multiple models). Platform-level sourcing contracts govern multi-model supply commitm',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Automotive supplier contracts (scheduling agreements, blanket orders) are frequently SKU-specific, defining annual volume commitments and pricing per part number. A FK to sku_master enables contract c',
    `supplier_id` BIGINT COMMENT 'Unique identifier of the supplier party associated with the contract.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Supplier contracts are scoped to specific vehicle programs, enabling contract compliance and program‑level spend tracking.',
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
    `ssot_governance_note` STRING COMMENT '',
    `supplier_contract_status` STRING COMMENT 'Current lifecycle state of the contract.. Valid values are `draft|active|suspended|terminated|expired`',
    `termination_notice_period_days` STRING COMMENT 'Number of days the buyer must notify the supplier before terminating the contract.',
    `total_contract_value` DECIMAL(18,2) COMMENT 'Aggregate monetary value of the contract over its full term.',
    `volume_commitment_quantity` BIGINT COMMENT 'Total quantity of goods or services the buyer commits to purchase under the contract.',
    `volume_commitment_uom` STRING COMMENT 'Unit of measure for the volume commitment (e.g., pieces, kilograms).. Valid values are `pcs|kg|liters|units|meters|hours`',
    CONSTRAINT pk_supplier_contract PRIMARY KEY(`supplier_contract_id`)
) COMMENT 'Long-term procurement contract (outline agreement) with a supplier covering pricing, volume commitments, delivery schedules, quality requirements, and commercial terms for direct or indirect materials. Captures contract type (value contract, quantity contract, scheduling agreement), validity period, target value, release order documentation requirement, price escalation clauses, penalty terms, and contract status. Supports blanket PO releases and scheduling agreement delivery lines. Sourced from SAP MM contract (EKKO with doc type MK/WK).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` (
    `goods_receipt_id` BIGINT COMMENT 'System-generated unique identifier for the goods receipt record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Goods receipts for cost-assigned POs (account assignment category K) post directly to a cost center. This FK replaces the denormalized cost_center_code attribute and enables cost center actual-spend r',
    `dealership_id` BIGINT COMMENT 'Identifier of the user who posted the goods receipt.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: In automotive incoming inspection, every GR against a PO triggers creation of a quality inspection lot (standard SAP QM flow). The GR already carries a denormalized inspection_lot_number; replacing ',
    `po_line_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line. Business justification: In SAP MM, goods receipts are posted at the PO line item level — each GR references a specific PO line (purchase_order_item). procurement_goods_receipt currently stores purchase_order_item as a denorm',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: In SAP MM, every goods receipt (MIGO) is posted against a specific purchase order. procurement_goods_receipt currently stores purchase_order_number as a denormalized STRING. Adding a proper FK procure',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Goods receipt posting updates stock balances; FK to SKU master ensures correct inventory item is credited.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Goods receipt documents record the physical storage location where inbound parts are placed. A proper FK to storage_location enables warehouse capacity utilization reports, inbound slotting optimizati',
    `supplier_id` BIGINT COMMENT 'Identifier of the supplier (vendor) from whom the goods were received.',
    `accounting_year` STRING COMMENT 'Fiscal year of the accounting document.',
    `batch_number` STRING COMMENT 'Batch or lot identifier for the received material, if applicable.',
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
    `ssot_governance_note` STRING COMMENT '',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component associated with the receipt.',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is measured.. Valid values are `EA|KG|L|M|PCS`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the goods receipt record.',
    `vendor_invoice_number` STRING COMMENT 'Invoice number supplied by the vendor for the received goods.',
    CONSTRAINT pk_goods_receipt PRIMARY KEY(`goods_receipt_id`)
) COMMENT 'Record of physical receipt of materials or services at an Automotive plant or warehouse against a purchase order or scheduling agreement. Captures GR document number, posting date, material document number, plant, storage location, received quantity, unit of measure, batch number, quality inspection lot reference, GR slip number, and movement type (101 standard GR, 103 GR blocked stock). Triggers inventory update and initiates three-way match for invoice verification. Sourced from SAP MM material document (MSEG/MKPF).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` (
    `supplier_invoice_id` BIGINT COMMENT 'Unique surrogate key for supplier invoice.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Supplier invoices are posted to a specific legal entity (company code) for statutory AP reporting, VAT filing, and intercompany reconciliation. In multi-entity automotive groups, company code determin',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Invoice cost allocation to cost center is required for budgeting and profitability analysis.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: AP invoice posting must reference a GL account to record expense in the ledger.',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_goods_receipt. Business justification: The 3-way match in SAP MM (PO-GR-Invoice) requires the invoice to reference the goods receipt. supplier_invoice currently stores goods_receipt_number as a denormalized STRING. Adding a proper FK procu',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: AP invoice posting generates a journal entry (debit expense/GR-IR, credit AP). Linking supplier_invoice to journal_entry enables three-way match reconciliation, period-close AP-to-GL tie-out, and audi',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: SAP MM invoice verification (MIRO) requires matching a supplier invoice to a purchase order as part of the 3-way match process (PO-GR-Invoice). supplier_invoice currently stores purchase_order_number ',
    `supplier_id` BIGINT COMMENT 'Identifier of the supplier who issued the invoice.',
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
    `ssot_governance_note` STRING COMMENT '',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`info_record` (
    `info_record_id` BIGINT COMMENT 'System-generated unique identifier for the purchasing info record.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Purchasing info records define the default GL account for automatic account determination when creating POs for a supplier-material combination. This link enables consistent expense/inventory classifi',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Purchasing Info Records (PIRs) are the ERP master records linking a suppliers price and lead time to a specific engineering part. BOM costing, make-vs-buy decisions, and supplier selection all requir',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Purchasing info records (Einkaufsinfosatz) define supplier-material pricing, lead times, and sourcing conditions per SKU. Every info record in automotive procurement is tied to a specific material. Th',
    `supplier_id` BIGINT COMMENT 'Unique identifier of the supplier (vendor) associated with this info record.',
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
) COMMENT 'Purchasing info record storing the commercial relationship between a supplier and a specific material or service category, including the last negotiated price, price validity period, planned delivery time, over/under-delivery tolerance, reminder days, and vendor evaluation score. Serves as the default pricing and delivery condition source when creating purchase orders. Sourced from SAP MM purchasing info record (EINE/EINA/ME11). [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` (
    `supplier_evaluation_id` BIGINT COMMENT 'System-generated unique identifier for each supplier evaluation record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Supplier evaluations are conducted per cost center to assess procurement spend efficiency and quality performance. Cost center managers use evaluation scores for supplier development budget allocation',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Automotive OEMs conduct model-specific supplier scorecards — e.g., PPM defect rate and on-time delivery measured per vehicle model (not just per plant). This drives model launch readiness decisions an',
    `plant_id` BIGINT COMMENT 'Identifier of the employee or system that performed the evaluation.',
    `supplier_id` BIGINT COMMENT 'Unique identifier of the supplier being evaluated.',
    `comments` STRING COMMENT 'Free‑text notes from the evaluator providing context or observations.',
    `compliance_status` STRING COMMENT 'Indicates whether the supplier meets regulatory and internal compliance requirements.. Valid values are `compliant|non_compliant|exempt`',
    `cost_score` DECIMAL(18,2) COMMENT 'Score (0‑100) for commercial performance (price competitiveness, invoice accuracy).',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the evaluation record was first created in the system.',
    `delivery_score` DECIMAL(18,2) COMMENT 'Score (0‑100) for delivery performance (OTD, schedule adherence).',
    `development_score` DECIMAL(18,2) COMMENT 'Score (0‑100) for development dimension (responsiveness, engineering change support).',
    `evaluation_date` DATE COMMENT 'Date on which the evaluation was performed.',
    `evaluation_method` STRING COMMENT 'How the evaluation data was collected (automated, manual, or mixed).. Valid values are `automated|manual|mixed`',
    `evaluation_number` STRING COMMENT 'Human‑readable identifier for the evaluation (e.g., EV‑2024‑Q1).',
    `evaluation_status` STRING COMMENT 'Current processing state of the evaluation record.. Valid values are `draft|in_progress|completed|approved|archived`',
    `evaluation_type` STRING COMMENT 'Frequency or trigger of the evaluation (annual, quarterly, or ad‑hoc).. Valid values are `annual|quarterly|ad_hoc`',
    `evaluation_version` STRING COMMENT 'Version number for the evaluation record to support revisions.',
    `failed_criteria_count` STRING COMMENT 'Number of criteria where the supplier fell below the required threshold.',
    `invoice_accuracy_pct` DECIMAL(18,2) COMMENT 'Percentage of invoices that match purchase order terms without discrepancies.',
    `on_time_delivery_pct` DECIMAL(18,2) COMMENT 'Percentage of deliveries arriving on or before the promised date.',
    `overall_score` DECIMAL(18,2) COMMENT 'Aggregated score (0‑100) summarising supplier performance.',
    `passed_criteria_count` STRING COMMENT 'Number of criteria where the supplier met or exceeded the threshold.',
    `period_end_date` DATE COMMENT 'Last day of the period covered by the evaluation.',
    `period_start_date` DATE COMMENT 'First day of the period covered by the evaluation.',
    `ppm_defect_rate` DECIMAL(18,2) COMMENT 'Parts‑per‑million defect rate observed during the period.',
    `price_variance_pct` DECIMAL(18,2) COMMENT 'Percentage difference between contracted price and actual invoiced price.',
    `quality_score` DECIMAL(18,2) COMMENT 'Score (0‑100) for quality dimension (PPM defect rate, PPAP compliance).',
    `recommended_action` STRING COMMENT 'Suggested strategic response based on evaluation results.. Valid values are `maintain|develop|reduce|disqualify`',
    `risk_level` STRING COMMENT 'Risk classification derived from evaluation outcomes.. Valid values are `low|medium|high|critical`',
    `ssot_governance_note` STRING COMMENT '',
    `supplier_category` STRING COMMENT 'Business classification of the supplier (e.g., Tier 1, Tier 2).. Valid values are `tier1|tier2|tier3|tier4`',
    `supplier_region` STRING COMMENT 'ISO‑3 country code of the suppliers primary operating location.. Valid values are `^[A-Z]{3}$`',
    `total_criteria_count` STRING COMMENT 'Number of evaluation criteria applied to the supplier.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the evaluation record.',
    CONSTRAINT pk_supplier_evaluation PRIMARY KEY(`supplier_evaluation_id`)
) COMMENT 'Periodic formal assessment of supplier performance across quality (PPM defect rate, PPAP compliance), delivery (OTD - On-Time Delivery, schedule adherence), commercial (price competitiveness, invoice accuracy), and development (responsiveness, engineering change support) dimensions. Captures evaluation period, overall score, sub-scores by criterion, evaluator, evaluation method (automated from SAP QM/MM or manual), and recommended action (maintain, develop, reduce, disqualify). Supports supplier development programs and strategic sourcing decisions.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ADD CONSTRAINT `fk_procurement_info_record_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ADD CONSTRAINT `fk_procurement_supplier_evaluation_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`procurement` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`procurement` SET TAGS ('dbx_domain' = 'procurement');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Program Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `account_assignment` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CHF');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `currency_rate` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `gr_ir_control_flag` SET TAGS ('dbx_business_glossary_term' = 'GR/IR Control Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount (PO_GROSS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms (International Commercial Terms)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `incoterms` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DDP');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `invoice_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount (PO_NET)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Date (PO_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number (PO_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_type` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Type (PO_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_type` SET TAGS ('dbx_value_regex' = 'standard|blanket|consignment|subcontract|service');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `procurement_purchase_order_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Status (PO_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `procurement_purchase_order_status` SET TAGS ('dbx_value_regex' = 'draft|released|approved|partially_received|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchase_group` SET TAGS ('dbx_business_glossary_term' = 'Purchase Group');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount (PO_TAX)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `total_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Line ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'K|P|U|F|M');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `batch_management_flag` SET TAGS ('dbx_business_glossary_term' = 'Batch Management Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `confirmation_date` SET TAGS ('dbx_business_glossary_term' = 'Line Confirmation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (WAERS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `invoice_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `is_blocked` SET TAGS ('dbx_business_glossary_term' = 'Blocked Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `is_deleted` SET TAGS ('dbx_business_glossary_term' = 'Soft Delete Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `last_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Last Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|confirmed|closed|canceled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price per Unit');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `over_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Over‑Delivery Tolerance (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `ppap_level` SET TAGS ('dbx_business_glossary_term' = 'PPAP Level Required');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `ppap_level` SET TAGS ('dbx_value_regex' = 'Level0|Level1|Level2|Level3|Level4');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `price_condition` SET TAGS ('dbx_business_glossary_term' = 'Price Condition Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `price_condition` SET TAGS ('dbx_value_regex' = 'Standard|Discount|Special');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `quantity_ordered` SET TAGS ('dbx_business_glossary_term' = 'Quantity Ordered');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `release_number` SET TAGS ('dbx_business_glossary_term' = 'Release Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `short_text` SET TAGS ('dbx_business_glossary_term' = 'Short Text');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Source of Supply');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_value_regex' = 'internal|external|consignment');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Under‑Delivery Tolerance (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (MEINS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|SET');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract ID (SCID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `platform_id` SET TAGS ('dbx_business_glossary_term' = 'Platform Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID (SID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Program Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Receipt User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `accounting_year` SET TAGS ('dbx_business_glossary_term' = 'Accounting Year');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `invoice_match_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Match Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `invoice_match_status` SET TAGS ('dbx_value_regex' = 'matched|unmatched|partial');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `is_blocked_stock` SET TAGS ('dbx_business_glossary_term' = 'Blocked Stock Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `is_quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = '101|103|105');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `procurement_goods_receipt_status` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `procurement_goods_receipt_status` SET TAGS ('dbx_value_regex' = 'posted|reversed|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `quality_inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Result');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `quality_inspection_result` SET TAGS ('dbx_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `quantity_received` SET TAGS ('dbx_business_glossary_term' = 'Quantity Received');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `receipt_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `receipt_type` SET TAGS ('dbx_business_glossary_term' = 'Receipt Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `receipt_type` SET TAGS ('dbx_value_regex' = 'standard|return|transfer');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `slip_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Slip Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `source_system_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Source System Load Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|PCS');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ALTER COLUMN `vendor_invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_city` SET TAGS ('dbx_pii_person_data' = 'true');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` SET TAGS ('dbx_subdomain' = 'vendor_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_evaluation_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Evaluation ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluator ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Comments');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|exempt');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `cost_score` SET TAGS ('dbx_business_glossary_term' = 'Cost Score');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `delivery_score` SET TAGS ('dbx_business_glossary_term' = 'Delivery Score');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `development_score` SET TAGS ('dbx_business_glossary_term' = 'Development Score');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Method');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_value_regex' = 'automated|manual|mixed');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_number` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_status` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_status` SET TAGS ('dbx_value_regex' = 'draft|in_progress|completed|approved|archived');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_type` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_type` SET TAGS ('dbx_value_regex' = 'annual|quarterly|ad_hoc');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `evaluation_version` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Version');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `failed_criteria_count` SET TAGS ('dbx_business_glossary_term' = 'Failed Criteria Count');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `invoice_accuracy_pct` SET TAGS ('dbx_business_glossary_term' = 'Invoice Accuracy Percentage');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `on_time_delivery_pct` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Percentage');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `overall_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Evaluation Score');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `passed_criteria_count` SET TAGS ('dbx_business_glossary_term' = 'Passed Criteria Count');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period End Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `ppm_defect_rate` SET TAGS ('dbx_business_glossary_term' = 'PPM Defect Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `price_variance_pct` SET TAGS ('dbx_business_glossary_term' = 'Price Variance Percentage');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `quality_score` SET TAGS ('dbx_business_glossary_term' = 'Quality Score');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `recommended_action` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `recommended_action` SET TAGS ('dbx_value_regex' = 'maintain|develop|reduce|disqualify');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_category` SET TAGS ('dbx_business_glossary_term' = 'Supplier Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_category` SET TAGS ('dbx_value_regex' = 'tier1|tier2|tier3|tier4');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_region` SET TAGS ('dbx_business_glossary_term' = 'Supplier Region');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_region` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `total_criteria_count` SET TAGS ('dbx_business_glossary_term' = 'Total Criteria Count');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
