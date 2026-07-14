-- Schema for Domain: procurement | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:23

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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` (
    `procurement_supplier_plant_id` BIGINT COMMENT 'Unique system-generated identifier for the supplier-plant relationship record.',
    `packaging_specification_id` BIGINT COMMENT 'Identifier of the packaging specification that the supplier must follow for deliveries to this plant.',
    `plant_id` BIGINT COMMENT 'Unique identifier of the manufacturing plant approved for the supplier.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier (vendor) linked to the plant.',
    `address_line1` STRING COMMENT 'First line of the suppliers delivery address for the plant.',
    `address_line2` STRING COMMENT 'Second line of the suppliers delivery address for the plant, if applicable.',
    `approval_date` DATE COMMENT 'Calendar date on which the supplier received approval for the plant.',
    `approval_status` STRING COMMENT 'Lifecycle status of the suppliers approval for this plant.. Valid values are `approved|pending|rejected|suspended`',
    `city` STRING COMMENT 'City component of the suppliers delivery address for the plant.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code of the delivery location.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the supplier‑plant record was first created.',
    `effective_end_date` DATE COMMENT 'Termination date of the suppliers authorization for the plant; null if open‑ended.',
    `effective_start_date` DATE COMMENT 'First date the supplier is authorized to supply the plant.',
    `freight_terms` STRING COMMENT 'Incoterm that defines cost and risk responsibilities for the shipment.. Valid values are `FOB|CIF|EXW|DDP`',
    `is_preferred_supplier` BOOLEAN COMMENT 'True if the supplier is designated as a preferred source for the plant.',
    `jis_delivery_flag` BOOLEAN COMMENT 'True if the supplier delivers parts in the production sequence (JIS) for this plant.',
    `jit_delivery_flag` BOOLEAN COMMENT 'True if the supplier delivers on a Just‑In‑Time basis for this plant.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent change to this record.',
    `lead_time_days` STRING COMMENT 'Typical number of days from purchase order issuance to receipt at the plant.',
    `minimum_order_quantity` STRING COMMENT 'Smallest quantity the plant will accept for a single delivery from this supplier.',
    `notes` STRING COMMENT 'Additional comments or special instructions related to the supplier‑plant relationship.',
    `postal_code` STRING COMMENT 'Postal/ZIP code of the suppliers delivery address.',
    `procurement_supplier_plant_status` STRING COMMENT 'Current operational status of the supplier‑plant association.. Valid values are `active|inactive|blocked`',
    `quality_rating` STRING COMMENT 'Internal quality score assigned to the supplier for deliveries to this plant.',
    `shipping_method` STRING COMMENT 'Standard mode of transportation used for deliveries to the plant.. Valid values are `truck|rail|ship|air`',
    `state_province` STRING COMMENT 'State or province component of the suppliers delivery address.',
    `supplier_contact_email` STRING COMMENT 'Email address of the suppliers plant liaison.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `supplier_contact_name` STRING COMMENT 'Name of the supplier representative responsible for deliveries to the plant.',
    `supplier_contact_phone` STRING COMMENT 'Telephone number for the suppliers plant liaison.',
    `unloading_point` STRING COMMENT 'Designated dock or bay where the suppliers goods are received at the plant.',
    CONSTRAINT pk_procurement_supplier_plant PRIMARY KEY(`procurement_supplier_plant_id`)
) COMMENT 'Association between a supplier and the Automotive manufacturing plants it is approved to supply. Captures plant-specific supplier data including delivery address, unloading point, JIT/JIS delivery flag, lead time, minimum order quantity, packaging specification reference, and plant-level approval status. Enables plant-level sourcing decisions and inbound logistics planning. Reflects SAP MM vendor-plant extension (LFM1/LFM2).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` (
    `sourcing_event_id` BIGINT COMMENT 'System-generated unique identifier for the sourcing event.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the primary supplier nominated in the event.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the internal buyer responsible for the event.',
    `sourcing_employee_id` BIGINT COMMENT 'Unique identifier of the internal buyer responsible for the event.',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the contract generated from the awarded event.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Sourcing events are launched per vehicle program to source components; required for program‑level sourcing reports.',
    `award_amount` DECIMAL(18,2) COMMENT 'Final contract value awarded to the selected supplier.',
    `award_currency_code` STRING COMMENT 'Currency of the award amount.. Valid values are `^[A-Z]{3}$`',
    `award_decision_date` DATE COMMENT 'Date on which the supplier award was formally decided.',
    `award_supplier_name` STRING COMMENT 'Legal name of the awarded supplier.',
    `buyer_department` STRING COMMENT 'Organizational department to which the buyer belongs.',
    `buyer_name` STRING COMMENT 'Full name of the internal buyer or procurement team.',
    `commodity_group` STRING COMMENT 'High-level classification of the goods or services being sourced (e.g., Powertrain, Electronics, MRO, Raw_Materials, Software, Services) [ENUM-REF-CANDIDATE: Powertrain|Electronics|MRO|Raw_Materials|Software|Services]',
    `confidentiality_level` STRING COMMENT 'Data classification level for the event record.. Valid values are `restricted|confidential|internal|public`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the sourcing event record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `sourcing_event_description` STRING COMMENT 'Free-text description providing context and objectives of the sourcing event.',
    `evaluation_method` STRING COMMENT 'Method used to rank and select suppliers.. Valid values are `weighted|lowest_price|best_value`',
    `evaluation_score` DECIMAL(18,2) COMMENT 'Numeric score resulting from the supplier evaluation process.',
    `event_number` STRING COMMENT 'External reference number assigned to the sourcing event, used in communications and reporting.',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the sourcing event was officially launched.',
    `event_type` STRING COMMENT 'Indicates whether the event is a Request for Quotation, Request for Information, or Request for Proposal.. Valid values are `RFQ|RFI|RFP`',
    `is_multi_source` BOOLEAN COMMENT 'Indicates whether the event is intended to select multiple suppliers.',
    `is_nda_required` BOOLEAN COMMENT 'True if a non-disclosure agreement is required from participants.',
    `sor_reference` STRING COMMENT 'Reference identifier for the SOR document linked to the event.',
    `sor_version` STRING COMMENT 'Version number of the SOR document used for this event.',
    `sourcing_event_status` STRING COMMENT 'Current lifecycle state of the sourcing event.. Valid values are `draft|open|closed|cancelled|awarded`',
    `sourcing_strategy` STRING COMMENT 'Chosen approach for supplier selection.. Valid values are `single_source|dual_source|competitive_bid|direct_negotiation`',
    `submission_deadline` DATE COMMENT 'Last date suppliers may submit their proposals.',
    `target_spend_amount` DECIMAL(18,2) COMMENT 'Estimated total spend the organization aims to achieve through this event.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the sourcing event record.',
    CONSTRAINT pk_sourcing_event PRIMARY KEY(`sourcing_event_id`)
) COMMENT 'Represents a formal strategic sourcing event initiated by Automotive procurement teams, including RFQ (Request for Quotation), RFI (Request for Information), and RFP (Request for Proposal) events. Captures event type, commodity group, target spend, SOR (Statement of Requirements) reference, sourcing strategy (single-source, dual-source, competitive bid), event status, award decision date, nominated suppliers, and responsible buyer. Supports global sourcing strategy execution and Ariba Sourcing integration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` (
    `supplier_quote_id` BIGINT COMMENT 'Unique system-generated identifier for each supplier quote.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: REQUIRED: Quotes for regulated components include a link to the suppliers compliance certificate, needed for part approval and downstream validation.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Supplier Quote Creation – created_by_employee_id identifies the employee who entered the quote, needed for quote provenance and compliance with pricing approval processes.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier who submitted the quote.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Quote evaluation compares quoted price against SKU master price list; linking quote to SKU enables price variance analysis.',
    `sourcing_event_id` BIGINT COMMENT 'Reference to the original sourcing request that this quote answers.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Supplier quotes are evaluated against a specific vehicle programs requirements; needed for quote comparison dashboards.',
    `amortization_rate_percent` DECIMAL(18,2) COMMENT 'Percentage rate applied to amortize tooling cost over the term.',
    `amortization_term_months` STRING COMMENT 'Number of months over which tooling cost is amortized.',
    `comments` STRING COMMENT 'Additional remarks or conditions supplied by the vendor.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the quote record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter currency identifier for the quoted amounts.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Monetary discount the supplier is offering on the base price.',
    `is_preferred` BOOLEAN COMMENT 'True if the supplier is marked as preferred for this part in the sourcing strategy.',
    `lead_time_days` STRING COMMENT 'Estimated number of days from order receipt to delivery.',
    `minimum_order_quantity` BIGINT COMMENT 'Smallest quantity the supplier will accept for this part.',
    `net_price` DECIMAL(18,2) COMMENT 'Final price per unit after applying discounts, excluding tax.',
    `payment_terms` STRING COMMENT 'Conditions under which payment must be made for the quoted items.. Valid values are `net_30|net_60|net_90|prepaid|cash_on_delivery|letter_of_credit`',
    `ppap_commitment_date` DATE COMMENT 'Date by which the supplier must complete Production Part Approval Process.',
    `quote_number` STRING COMMENT 'Human‑readable reference number assigned to the quote by the procurement system.',
    `quote_status` STRING COMMENT 'Indicates the processing stage of the quote within the sourcing workflow.. Valid values are `submitted|under_review|awarded|rejected`',
    `quote_type` STRING COMMENT 'Indicates whether the quote is a response to an RFQ, RFP, RFI, etc.. Valid values are `rfq|rfp|rfi|rfq_response`',
    `quoted_price` DECIMAL(18,2) COMMENT 'Base price per unit offered by the supplier.',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time the supplier formally submitted the quote.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Estimated tax to be added to the net price.',
    `tooling_cost` DECIMAL(18,2) COMMENT 'One‑time cost for tooling or molds required to produce the part.',
    `total_price` DECIMAL(18,2) COMMENT 'Final amount payable per unit after tax.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the quote record.',
    `validity_end_date` DATE COMMENT 'Date after which the quoted prices expire.',
    `validity_start_date` DATE COMMENT 'Date from which the quoted prices are considered valid.',
    CONSTRAINT pk_supplier_quote PRIMARY KEY(`supplier_quote_id`)
) COMMENT 'Supplier response to a sourcing event (RFQ/RFP), capturing quoted unit price, tooling cost, amortization terms, lead time, MOQ (minimum order quantity), payment terms, validity period, PPAP (Production Part Approval Process) commitment date, and quote status (submitted, under-review, awarded, rejected). Enables competitive bid analysis and total cost of ownership (TCO) evaluation. Linked to sourcing events and specific part numbers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` (
    `purchase_requisition_id` BIGINT COMMENT 'Unique identifier for the purchase requisition.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Requisition cost allocation to cost center is required for pre‑PO budgeting and approval.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Equipment Requisition initiates creation of a new equipment asset; linking requisition to equipment registry enables traceability from request to asset.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Requisition GL account enables automatic posting of approved requisitions to the ledger.',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Required for Procurement requisition generation from a won sales opportunity – experts expect a direct link to track which opportunity triggered the requisition.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Required for Plant Requisition Allocation Report linking each requisition to its manufacturing plant.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who created the requisition.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the selected vendor for the requisition (if known).',
    `purchase_approved_by_employee_id` BIGINT COMMENT 'Identifier of the employee who approved the requisition.',
    `purchase_employee_id` BIGINT COMMENT 'Identifier of the employee who created the requisition.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Requisition planning and allocation reports need the SKU master to forecast demand and allocate inventory.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Program‑specific purchase requisition; finance and engineering track spend per vehicle program.',
    `vendor_id` BIGINT COMMENT 'Identifier of the selected vendor for the requisition (if known).',
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
    `purchase_order_number` STRING COMMENT 'Reference number of the purchase order generated from this requisition.',
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
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: REQUIRED: PO must reference the compliance certification document for regulated parts (emissions, safety) to satisfy audit and legal reporting.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Required for PO cost allocation report; finance tracks spend by cost center for each purchase order.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Purchase Order Creation – created_by_employee_id logs the employee who created the PO, a mandatory field for PO creation audit and responsibility tracking.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Build‑to‑order procurement links PO to end‑customer for cost‑to‑serve and profitability reporting.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Capital Equipment Procurement process requires linking PO to the registered equipment asset for depreciation, warranty, and maintenance tracking.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: GL account needed for posting PO amounts to the general ledger; mandatory for financial statements.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Incoming Inspection Planning: each PO is assigned an inspection plan used by quality to inspect received parts; standard practice in automotive manufacturing.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or site receiving the goods/services.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier (vendor) to which the purchase order is issued.',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Needed for Line Delivery Schedule to allocate PO deliveries to specific production lines.',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the underlying procurement contract or framework agreement, if applicable.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Needed for Production scheduling report that ties each PO of parts to the specific vehicle order it supplies.',
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
    `supplier_name` STRING COMMENT 'Legal name of the supplier organization.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Aggregate tax amount applicable to the purchase order.',
    `tax_code` STRING COMMENT 'Code representing the tax jurisdiction and rate applied to the PO.',
    `total_quantity` BIGINT COMMENT 'Aggregate quantity of all line items on the purchase order.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the purchase order record.',
    CONSTRAINT pk_procurement_purchase_order PRIMARY KEY(`procurement_purchase_order_id`)
) COMMENT 'Legally binding procurement document issued to a supplier for delivery of direct materials, indirect materials, MRO, tooling, or services. Captures PO number, PO type (standard, blanket, consignment, subcontracting, service), supplier, plant, delivery date, incoterms, payment terms, total net value, currency, tax code, account assignment, approval workflow status, and GR/IR (Goods Receipt/Invoice Receipt) control flags. Core transactional entity of the procure-to-pay process. Sourced from SAP MM (EKKO/EKPO).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` (
    `procurement_po_line_id` BIGINT COMMENT 'Unique surrogate key for each purchase order line item.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Cost center allocation per PO line is required for internal cost reporting and variance analysis.',
    `employee_id` BIGINT COMMENT 'User identifier who created the PO line.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Each PO line maps to a specific expense GL account for detailed ledger posting.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Line‑level inspection: each PO line (material) follows a specific inspection plan defined by quality for incoming inspection.',
    `plant_id` BIGINT COMMENT 'FK to manufacturing.plant',
    `procurement_purchase_order_id` BIGINT COMMENT 'Identifier of the purchase order header to which this line belongs.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the vendor supplying the material.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: PO receipt matching uses SKU master to update stock; PO lines must reference the exact SKU for inventory posting.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: Supports Work Center Procurement Tracking, tying each PO line to the work center that will consume the material.',
    `account_assignment_category` STRING COMMENT 'Category indicating how costs are allocated (e.g., cost center, order).. Valid values are `K|P|U|F|M`',
    `batch_management_flag` BOOLEAN COMMENT 'True if the material is managed in batches.',
    `batch_number` STRING COMMENT 'Identifier of the batch when batch management is active.',
    `confirmation_date` TIMESTAMP COMMENT 'Date and time when the line was confirmed by the supplier.',
    `contract_number` STRING COMMENT 'Reference to a procurement contract governing this line.',
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
    `storage_location` STRING COMMENT 'Warehouse or storage bin where the material will be received.',
    `supplier_part_number` STRING COMMENT 'Vendors own part number for the material.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount calculated for the line.',
    `tax_code` STRING COMMENT 'Tax classification code applicable to the line.',
    `under_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowed percentage under the ordered quantity.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the ordered quantity.. Valid values are `EA|KG|L|M|SET`',
    CONSTRAINT pk_procurement_po_line PRIMARY KEY(`procurement_po_line_id`)
) COMMENT 'Individual line item within a purchase order, representing a specific material, service, or part number being procured. Captures line number, material number, short text, quantity ordered, unit of measure, net price, delivery date, storage location, batch management flag, PPAP level required, over/under-delivery tolerance, and line-level confirmation status. Enables granular spend tracking and goods receipt matching at the part level. Sourced from SAP MM PO item table (EKPO).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` (
    `supplier_contract_id` BIGINT COMMENT 'System-generated unique identifier for the supplier contract record.',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: Contracts embed quality control requirements; referencing the control plan ties contractual obligations to the actual quality control plan.',
    `employee_id` BIGINT COMMENT 'User identifier of the person who approved the contract.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Contractual spend must be mapped to a GL account for accruals and expense recognition.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier party associated with the contract.',
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
    `supplier_contract_status` STRING COMMENT 'Current lifecycle state of the contract.. Valid values are `draft|active|suspended|terminated|expired`',
    `termination_notice_period_days` STRING COMMENT 'Number of days the buyer must notify the supplier before terminating the contract.',
    `total_contract_value` DECIMAL(18,2) COMMENT 'Aggregate monetary value of the contract over its full term.',
    `volume_commitment_quantity` BIGINT COMMENT 'Total quantity of goods or services the buyer commits to purchase under the contract.',
    `volume_commitment_uom` STRING COMMENT 'Unit of measure for the volume commitment (e.g., pieces, kilograms).. Valid values are `pcs|kg|liters|units|meters|hours`',
    CONSTRAINT pk_supplier_contract PRIMARY KEY(`supplier_contract_id`)
) COMMENT 'Long-term procurement contract (outline agreement) with a supplier covering pricing, volume commitments, delivery schedules, quality requirements, and commercial terms for direct or indirect materials. Captures contract type (value contract, quantity contract, scheduling agreement), validity period, target value, release order documentation requirement, price escalation clauses, penalty terms, and contract status. Supports blanket PO releases and scheduling agreement delivery lines. Sourced from SAP MM contract (EKKO with doc type MK/WK).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` (
    `scheduling_agreement_line_id` BIGINT COMMENT 'System-generated unique identifier for the scheduling agreement line record.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Scheduling agreement lines are generated from purchase orders; linking to purchase_order provides parent reference and removes redundant order number fields.',
    `scheduling_agreement_id` BIGINT COMMENT 'Identifier of the parent scheduling agreement header to which this line belongs.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Scheduling agreements schedule deliveries of specific SKUs; linking to SKU master enables MRP and capacity planning.',
    `change_number` STRING COMMENT 'Identifier of the engineering change or amendment affecting this line.. Valid values are `^[0-9]{4}$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'Quantity that has been confirmed by the supplier for the delivery date.',
    `confirmed_quantity_unit` STRING COMMENT 'Unit of measure for the confirmed quantity.. Valid values are `EA|KG|L|M|M2|M3`',
    `creation_timestamp` TIMESTAMP COMMENT 'Date and time when the schedule line record was created in the system.',
    `cumulative_received_quantity` DECIMAL(18,2) COMMENT 'Total quantity received to date for this line across all deliveries.',
    `cumulative_received_quantity_unit` STRING COMMENT 'Unit of measure for the cumulative received quantity.. Valid values are `EA|KG|L|M|M2|M3`',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for the price.. Valid values are `USD|EUR|JPY|GBP|CNY|CAD`',
    `delivery_date` DATE COMMENT 'Planned calendar date for the delivery of the scheduled quantity.',
    `delivery_window_end` DATE COMMENT 'End date of the allowed delivery window for this line.',
    `delivery_window_start` DATE COMMENT 'Start date of the allowed delivery window for this line.',
    `effective_from` DATE COMMENT 'Date from which the schedule line becomes effective (often same as delivery_date).',
    `effective_until` DATE COMMENT 'Optional end date after which the schedule line is no longer valid.',
    `freight_terms` STRING COMMENT 'Terms defining freight responsibilities for the delivery.. Valid values are `FOB|CIF|EXW|DDP`',
    `incoterms_code` STRING COMMENT 'International commercial terms governing delivery responsibilities.. Valid values are `EXW|FCA|FOB|CFR|CIF|DDP`',
    `inspection_required` BOOLEAN COMMENT 'Indicates whether a quality inspection is required for this line.',
    `is_backorder` BOOLEAN COMMENT 'Flag indicating whether the line is currently backordered.',
    `is_late` BOOLEAN COMMENT 'Flag indicating whether the scheduled delivery is past its delivery date without receipt.',
    `last_received_timestamp` TIMESTAMP COMMENT 'Date and time when the most recent receipt for this line was recorded.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the schedule line.',
    `line_sequence` STRING COMMENT 'Sequential number of the line within the scheduling agreement, defining order of delivery lines.',
    `line_status` STRING COMMENT 'Current processing status of the schedule line.. Valid values are `open|closed|cancelled|pending`',
    `lot_number` STRING COMMENT 'Batch or lot identifier for traceability of the material.. Valid values are `^[A-Z0-9]+$`',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant or warehouse where the delivery is scheduled.. Valid values are `^[A-Z0-9]{4}$`',
    `price_per_unit` DECIMAL(18,2) COMMENT 'Agreed price for one unit of the material on this line.',
    `quality_status` STRING COMMENT 'Result of quality inspection for the received material.. Valid values are `accepted|rejected|pending`',
    `remarks` STRING COMMENT 'Free‑text field for additional notes or comments on the line.',
    `schedule_line_category` STRING COMMENT 'Indicates whether the line is a firm commitment or a forecasted quantity.. Valid values are `firm|forecast`',
    `scheduled_quantity` DECIMAL(18,2) COMMENT 'Quantity of material planned for delivery on the delivery date.',
    `scheduled_quantity_unit` STRING COMMENT 'Unit of measure for the scheduled quantity (e.g., each, kilogram).. Valid values are `EA|KG|L|M|M2|M3`',
    `supplier_material_number` STRING COMMENT 'Vendor-specific part number for the material.. Valid values are `^[A-Z0-9]+$`',
    `tax_rate_percent` DECIMAL(18,2) COMMENT 'Applicable tax rate expressed as a percentage for this line.',
    CONSTRAINT pk_scheduling_agreement_line PRIMARY KEY(`scheduling_agreement_line_id`)
) COMMENT 'Delivery schedule line within a scheduling agreement (JIT/JIS delivery plan) specifying the exact quantity and delivery date for a specific part number at a specific plant. Captures schedule line number, delivery date, scheduled quantity, confirmed quantity, cumulative received quantity, and schedule line category (firm, forecast). Critical for JIT and JIS production supply in automotive assembly operations. Sourced from SAP MM scheduling agreement delivery schedule (EKET).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` (
    `procurement_goods_receipt_id` BIGINT COMMENT 'System-generated unique identifier for the goods receipt record.',
    `employee_id` BIGINT COMMENT 'Identifier of the user who posted the goods receipt.',
    `procurement_receipt_user_employee_id` BIGINT COMMENT 'Identifier of the user who posted the goods receipt.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier (vendor) from whom the goods were received.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Goods receipt confirmation must reference the specific inbound shipment for traceability and audit compliance.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Goods receipt posting updates stock balances; FK to SKU master ensures correct inventory item is credited.',
    `accounting_document_number` STRING COMMENT 'Financial accounting document generated for the receipt.',
    `accounting_year` STRING COMMENT 'Fiscal year of the accounting document.',
    `batch_number` STRING COMMENT 'Batch or lot identifier for the received material, if applicable.',
    `cost_center_code` STRING COMMENT 'Cost center to which the receipt cost is charged.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the goods receipt record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary amounts.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total value of the receipt before taxes and discounts.',
    `inspection_lot_number` STRING COMMENT 'Reference to the quality inspection lot generated for this receipt.',
    `invoice_match_status` STRING COMMENT 'Three‑way match status between PO, receipt, and invoice.. Valid values are `matched|unmatched|partial`',
    `is_blocked_stock` BOOLEAN COMMENT 'True if the receipt created blocked stock (movement type 103).',
    `is_quality_inspection_required` BOOLEAN COMMENT 'Indicates whether a quality inspection is mandatory for this receipt.',
    `movement_type` STRING COMMENT 'SAP movement type code (e.g., 101 = standard receipt, 103 = blocked stock).. Valid values are `101|103|105`',
    `net_amount` DECIMAL(18,2) COMMENT 'Net value after taxes and discounts.',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant or warehouse where receipt took place.',
    `posting_date` DATE COMMENT 'Date on which the receipt was posted to financial accounting.',
    `procurement_goods_receipt_status` STRING COMMENT 'Current lifecycle status of the receipt.. Valid values are `posted|reversed|pending`',
    `profit_center_code` STRING COMMENT 'Profit center associated with the receipt.',
    `purchase_order_item` STRING COMMENT 'Line item number of the purchase order related to this receipt.',
    `purchase_order_number` STRING COMMENT 'Purchase order number against which the goods receipt is posted.',
    `quality_inspection_result` STRING COMMENT 'Outcome of the quality inspection for the receipt.. Valid values are `passed|failed|pending`',
    `quantity_received` DECIMAL(18,2) COMMENT 'Amount of material received, expressed in the unit of measure.',
    `receipt_number` STRING COMMENT 'External business identifier assigned to the goods receipt (e.g., GR document number).',
    `receipt_timestamp` TIMESTAMP COMMENT 'Date and time when the goods receipt event occurred in the plant.',
    `receipt_type` STRING COMMENT 'Classification of the receipt (e.g., standard receipt, return, stock transfer).. Valid values are `standard|return|transfer`',
    `slip_number` STRING COMMENT 'Physical slip or document number associated with the receipt.',
    `source_system_load_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was loaded from the source system into the lakehouse.',
    `storage_location` STRING COMMENT 'Specific storage location within the plant where goods were placed.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component associated with the receipt.',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is measured.. Valid values are `EA|KG|L|M|PCS`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the goods receipt record.',
    `vendor_invoice_number` STRING COMMENT 'Invoice number supplied by the vendor for the received goods.',
    CONSTRAINT pk_procurement_goods_receipt PRIMARY KEY(`procurement_goods_receipt_id`)
) COMMENT 'Record of physical receipt of materials or services at an Automotive plant or warehouse against a purchase order or scheduling agreement. Captures GR document number, posting date, material document number, plant, storage location, received quantity, unit of measure, batch number, quality inspection lot reference, GR slip number, and movement type (101 standard GR, 103 GR blocked stock). Triggers inventory update and initiates three-way match for invoice verification. Sourced from SAP MM material document (MSEG/MKPF).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` (
    `supplier_invoice_id` BIGINT COMMENT 'Unique surrogate key for supplier invoice.',
    `acquisition_id` BIGINT COMMENT 'Foreign key linking to asset.asset_acquisition. Business justification: Supplier Invoice for a newly acquired asset must be reconciled with the Asset Acquisition record for financial and asset register consistency.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Invoice cost allocation to cost center is required for budgeting and profitability analysis.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: AP invoice posting must reference a GL account to record expense in the ledger.',
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
    `goods_receipt_number` STRING COMMENT 'Identifier of the goods receipt linked to the invoice.',
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
    `purchase_order_number` STRING COMMENT 'Associated purchase order identifier.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_invoice_line` (
    `procurement_invoice_line_id` BIGINT COMMENT 'Unique identifier for the procurement_invoice_line data product (auto-inserted pre-linking).',
    `supplier_invoice_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_invoice. Business justification: A procurement invoice line is a line item of a supplier invoice; linking enables proper hierarchy and removes the need for duplicate invoice reference fields.',
    CONSTRAINT pk_procurement_invoice_line PRIMARY KEY(`procurement_invoice_line_id`)
) COMMENT 'Individual line item on a supplier invoice, matched against a specific PO line and goods receipt line. Captures invoice line number, material or service description, invoiced quantity, unit price, net amount, tax code, PO reference line, GR reference, quantity variance, price variance, and line-level match status. Supports granular three-way match reconciliation and dispute resolution at the part/service level.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`spend_category` (
    `spend_category_id` BIGINT COMMENT 'Primary key for spend_category reference lookup (role: REFERENCE_LOOKUP)',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Spend category GL mapping supports standardized chart‑of‑accounts reporting.',
    `parent_category_spend_category_id` BIGINT COMMENT 'Identifier of the immediate parent category in the hierarchy.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee responsible for the category.',
    `spend_employee_id` BIGINT COMMENT 'Identifier of the employee responsible for the category.',
    `category_code` STRING COMMENT 'Standardized code representing the spend category, aligned with UNSPSC or internal taxonomy.',
    `category_name` STRING COMMENT 'Human‑readable name of the spend category.',
    `commodity_group` STRING COMMENT 'Higher‑level grouping of related spend categories (e.g., Materials, Services, Capital).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the category record was created in the system.',
    `spend_category_description` STRING COMMENT 'Detailed description of the spend category purpose and scope.',
    `direct_indirect_flag` BOOLEAN COMMENT 'Indicates whether the spend category pertains to direct production parts or indirect materials/services.',
    `effective_from` DATE COMMENT 'Date when the category definition becomes effective.',
    `effective_until` DATE COMMENT 'Date when the category definition expires or is superseded (null if still active).',
    `external_reference` STRING COMMENT 'Reference to external taxonomy or system identifier (e.g., SAP material group).',
    `hierarchy_level` STRING COMMENT 'Depth level of the category within the spend taxonomy (root = 0).',
    `is_leaf` BOOLEAN COMMENT 'Flag indicating whether the category has no child categories.',
    `scope` STRING COMMENT 'Geographic scope of the category applicability.. Valid values are `global|regional|local`',
    `sourcing_strategy` STRING COMMENT 'Recommended sourcing approach for the category.. Valid values are `single_source|multiple_source|global|local|consortium|none`',
    `spend_category_status` STRING COMMENT 'Current lifecycle status of the spend category.. Valid values are `active|inactive|deprecated|pending`',
    `spend_category_type` STRING COMMENT 'Classification of spend type for budgeting and reporting.. Valid values are `commodity|service|capital|operating`',
    `strategic_flag` BOOLEAN COMMENT 'True if the category is considered strategic for sourcing and supplier management.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the category record.',
    `version_number` STRING COMMENT 'Incremental version of the category record for change tracking.',
    CONSTRAINT pk_spend_category PRIMARY KEY(`spend_category_id`)
) COMMENT 'Hierarchical classification taxonomy for procurement spend, organizing all purchased goods and services into commodity groups and sub-categories aligned with UNSPSC or Automotive-internal commodity codes. Captures category code, category name, parent category, commodity group, direct/indirect flag, strategic category flag, responsible category manager, and applicable sourcing strategy. Enables spend analytics, category management, and supplier rationalization. Reference data used across all procurement transactions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` (
    `approved_vendor_list_id` BIGINT COMMENT 'System-generated unique identifier for each approved vendor list record.',
    `material_id` BIGINT COMMENT 'Unique identifier of the material or part covered by the AVL.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier authorized in this AVL.',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the underlying supplier contract governing the AVL.',
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
    `material_id` BIGINT COMMENT 'Unique identifier of the material or service category covered by this info record.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier (vendor) associated with this info record.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` (
    `supplier_evaluation_id` BIGINT COMMENT 'System-generated unique identifier for each supplier evaluation record.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier being evaluated.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or system that performed the evaluation.',
    `supplier_evaluator_employee_id` BIGINT COMMENT 'Identifier of the employee or system that performed the evaluation.',
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
    `supplier_category` STRING COMMENT 'Business classification of the supplier (e.g., Tier 1, Tier 2).. Valid values are `tier1|tier2|tier3|tier4`',
    `supplier_region` STRING COMMENT 'ISO‑3 country code of the suppliers primary operating location.. Valid values are `^[A-Z]{3}$`',
    `total_criteria_count` STRING COMMENT 'Number of evaluation criteria applied to the supplier.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the evaluation record.',
    CONSTRAINT pk_supplier_evaluation PRIMARY KEY(`supplier_evaluation_id`)
) COMMENT 'Periodic formal assessment of supplier performance across quality (PPM defect rate, PPAP compliance), delivery (OTD - On-Time Delivery, schedule adherence), commercial (price competitiveness, invoice accuracy), and development (responsiveness, engineering change support) dimensions. Captures evaluation period, overall score, sub-scores by criterion, evaluator, evaluation method (automated from SAP QM/MM or manual), and recommended action (maintain, develop, reduce, disqualify). Supports supplier development programs and strategic sourcing decisions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` (
    `supplier_development_plan_id` BIGINT COMMENT 'Unique identifier for the supplier development plan.',
    `apqp_plan_id` BIGINT COMMENT 'Foreign key linking to quality.apqp_plan. Business justification: Supplier development is coordinated with APQP phases; linking ensures the development plan references the correct APQP plan.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: REQUIRED: Development plans are created to satisfy a particular compliance obligation, linking the plan to that obligation for tracking.',
    `employee_id` BIGINT COMMENT 'Identifier of the development engineer responsible for executing the plan.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier for which the development plan is created.',
    `supplier_approved_by_employee_id` BIGINT COMMENT 'Identifier of the person who approved the plan.',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the supplier contract associated with the development plan.',
    `supplier_employee_id` BIGINT COMMENT 'Identifier of the development engineer responsible for executing the plan.',
    `actual_metric_timestamp` DATE COMMENT 'Date when the actual metric was recorded.',
    `actual_metric_value` DECIMAL(18,2) COMMENT 'Current measured value of the primary KPI.',
    `actual_progress_percent` DECIMAL(18,2) COMMENT 'Current progress of the plan expressed as a percentage.',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the plan was approved.',
    `budget_status` STRING COMMENT 'Current budget status of the plan.. Valid values are `under_budget|on_budget|over_budget`',
    `change_reason` STRING COMMENT 'Reason for the latest version change of the plan.',
    `compliance_requirements` STRING COMMENT 'Regulatory or compliance requirements linked to the plan (e.g., IATF 16949).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the plan record was created.',
    `effective_from` DATE COMMENT 'Date when the plan becomes effective.',
    `effective_until` DATE COMMENT 'Planned end date of the plan (nullable for open‑ended).',
    `investment_amount` DECIMAL(18,2) COMMENT 'Total monetary investment committed to the development plan.',
    `investment_currency` STRING COMMENT 'Currency code of the investment amount (ISO 4217).',
    `investment_type` STRING COMMENT 'Source of the investment funding.. Valid values are `automotive_funded|supplier_funded|joint`',
    `is_capex` BOOLEAN COMMENT 'Indicates if the investment is classified as capital expenditure.',
    `is_oem` BOOLEAN COMMENT 'Indicates if the supplier is an original equipment manufacturer.',
    `last_review_date` DATE COMMENT 'Date of the most recent plan review.',
    `milestone_schedule` STRING COMMENT 'Structured representation of milestones and their target dates (e.g., JSON or delimited string).',
    `next_milestone_date` DATE COMMENT 'Date of the upcoming milestone.',
    `notes` STRING COMMENT 'Free‑text notes or comments regarding the plan.',
    `plan_code` STRING COMMENT 'External reference code for the development plan.',
    `plan_name` STRING COMMENT 'Descriptive name of the development plan.',
    `plan_type` STRING COMMENT 'Category of the development plan indicating its primary focus.. Valid values are `quality_improvement|capacity_ramp|technology_development|cost_reduction`',
    `plan_version` STRING COMMENT 'Version number of the plan for change tracking.',
    `priority` STRING COMMENT 'Priority level assigned to the development plan.. Valid values are `low|medium|high|critical`',
    `related_sop_date` DATE COMMENT 'Target date for Start of Production readiness associated with the plan.',
    `risk_level` STRING COMMENT 'Risk assessment level for the plan.. Valid values are `low|medium|high`',
    `supplier_development_plan_status` STRING COMMENT 'Current lifecycle status of the development plan.. Valid values are `draft|approved|in_progress|completed|on_hold|cancelled`',
    `target_metric_name` STRING COMMENT 'Name of the primary KPI the plan aims to improve (e.g., defect_rate, on_time_delivery).',
    `target_metric_unit` STRING COMMENT 'Unit of measure for the target metric (e.g., %, ppm).',
    `target_metric_value` DECIMAL(18,2) COMMENT 'Target value for the primary KPI.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the plan.',
    CONSTRAINT pk_supplier_development_plan PRIMARY KEY(`supplier_development_plan_id`)
) COMMENT 'Structured improvement program initiated for a supplier requiring capability development, quality improvement, or capacity expansion. Captures plan type (quality improvement, capacity ramp, technology development, cost reduction), target metrics, milestone schedule, responsible development engineer, investment commitment (Automotive-funded tooling or CapEx), and plan status. Tracks progress against agreed KPIs and supports SOP (Start of Production) readiness for new model launches.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` (
    `capex_requisition_id` BIGINT COMMENT 'System-generated unique identifier for the capital expenditure requisition.',
    `budget_line_id` BIGINT COMMENT 'Budget line item that funds the requisition.',
    `employee_id` BIGINT COMMENT 'Employee who created the CapEx requisition.',
    `capex_project_manager_employee_id` BIGINT COMMENT 'Employee responsible for overseeing the capital project.',
    `cost_center_id` BIGINT COMMENT 'Cost center responsible for the expense.',
    `department_id` BIGINT COMMENT 'Department responsible for the request.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Capex request posting requires a GL account to capture capital expenditures in the ledger.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where the asset will be used.',
    `primary_capex_employee_id` BIGINT COMMENT 'Employee who created the CapEx requisition.',
    `procurement_supplier_id` BIGINT COMMENT 'Supplier selected to provide the capital asset.',
    `supplier_quote_id` BIGINT COMMENT 'Identifier of the supplier quote linked to the requisition.',
    `vendor_id` BIGINT COMMENT 'Supplier selected to provide the capital asset.',
    `afe_number` STRING COMMENT 'Number of the AFE that authorizes the capital spend.',
    `approval_authority_level` STRING COMMENT 'Organizational level required to approve the requisition.. Valid values are `manager|director|vp|cfo|ceo`',
    `approval_date` DATE COMMENT 'Date the requisition received final approval.',
    `approved_budget` DECIMAL(18,2) COMMENT 'Budget amount approved for the requisition.',
    `asset_category` STRING COMMENT 'Category of the asset to be acquired (e.g., tooling, equipment, facility).. Valid values are `tooling|equipment|facility|software|infrastructure|other`',
    `asset_life_years` STRING COMMENT 'Estimated useful life of the asset for planning purposes.',
    `capex_requisition_status` STRING COMMENT 'Current processing status of the requisition.. Valid values are `draft|submitted|approved|rejected|closed|cancelled`',
    `capitalized_flag` BOOLEAN COMMENT 'Indicates whether the expense will be capitalized on the balance sheet.',
    `compliance_status` STRING COMMENT 'Overall compliance status with internal and external regulations.. Valid values are `compliant|non_compliant|pending`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the requisition record was created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary values.',
    `depreciation_life_years` STRING COMMENT 'Number of years over which the asset will be depreciated.',
    `depreciation_start_date` DATE COMMENT 'Date when depreciation of the asset begins.',
    `capex_requisition_description` STRING COMMENT 'Free‑text description providing business justification and details of the request.',
    `environmental_impact_assessment` STRING COMMENT 'Assessment of the environmental impact of the capital project.. Valid values are `low|medium|high|not_applicable`',
    `estimated_investment` DECIMAL(18,2) COMMENT 'Projected total cost of the capital investment.',
    `funding_source` STRING COMMENT 'Source of funds for the capital expenditure.. Valid values are `internal|external|loan|grant|other`',
    `justification_type` STRING COMMENT 'Reason for the CapEx request such as new model development, replacement, or capacity expansion.. Valid values are `new_model|replacement|capacity|maintenance|other`',
    `procurement_method` STRING COMMENT 'Method used to acquire the asset.. Valid values are `purchase|lease|internal|other`',
    `project_code` STRING COMMENT 'Code of the capital project or program to which the requisition belongs.',
    `regulatory_approval_required` BOOLEAN COMMENT 'Indicates if regulatory approval is needed for the asset.',
    `regulatory_approval_status` STRING COMMENT 'Current status of any required regulatory approvals.. Valid values are `pending|approved|rejected`',
    `request_date` DATE COMMENT 'Date the requisition was initially submitted.',
    `required_by_date` DATE COMMENT 'Date by which the asset is needed for production.',
    `requisition_number` STRING COMMENT 'External reference number assigned to the requisition for tracking and communication.',
    `risk_assessment` STRING COMMENT 'Risk level associated with the capital investment.. Valid values are `low|medium|high`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component associated with the approved budget.',
    `tax_code` STRING COMMENT 'Tax code applicable to the requisition.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the requisition record.',
    `wbs_element` STRING COMMENT 'WBS element code linking the requisition to project accounting hierarchy.',
    CONSTRAINT pk_capex_requisition PRIMARY KEY(`capex_requisition_id`)
) COMMENT 'Capital expenditure procurement request for tooling, dies, fixtures, production equipment, or plant infrastructure required for new model programs or capacity expansion. Captures CapEx project code, asset category, justification type (new model, replacement, capacity), estimated investment, approved budget, plant, cost center, WBS element, AFE (Authorization for Expenditure) number, approval authority level, and CapEx status. Distinct from standard MRO or direct material purchase requisitions due to asset capitalization workflow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` (
    `tooling_order_id` BIGINT COMMENT 'System-generated unique identifier for the tooling order.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Tooling orders are charged to a cost center for internal cost tracking and budgeting.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant that will use the tooling.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier providing the tooling.',
    `engineering_project_id` BIGINT COMMENT 'Identifier of the capital project associated with the tooling.',
    `tooling_registry_id` BIGINT COMMENT 'Foreign key linking to asset.tooling_registry. Business justification: Tooling Order fulfillment updates the Tool Registry; linking ensures tool lifecycle and cost are tracked from order to asset.',
    `amortization_method` STRING COMMENT 'Method used to amortize the tooling cost.. Valid values are `lump_sum|per_piece`',
    `amortization_rate_percent` DECIMAL(18,2) COMMENT 'Percentage rate applied for per‑piece amortization.',
    `amortization_term_months` STRING COMMENT 'Number of months over which the tooling cost is amortized.',
    `approval_status` STRING COMMENT 'Current approval state of the tooling order.. Valid values are `pending|approved|rejected`',
    `capital_expenditure_flag` BOOLEAN COMMENT 'True if the tooling order is treated as a capital expenditure.',
    `compliance_certification` STRING COMMENT 'Certification(s) (e.g., ISO 9001) associated with the tooling.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tooling order record was first captured in the lakehouse.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `depreciation_end_date` DATE COMMENT 'Projected end date of depreciation (nullable for open‑ended).',
    `depreciation_method` STRING COMMENT 'Method used to calculate depreciation for the tooling asset.. Valid values are `straight_line|reducing_balance|units_of_production`',
    `depreciation_start_date` DATE COMMENT 'Date when depreciation of the tooling begins.',
    `expected_life_months` STRING COMMENT 'Planned useful life of the tooling in months.',
    `net_amount` DECIMAL(18,2) COMMENT 'Net amount payable after tax and any discounts.',
    `order_number` STRING COMMENT 'External reference number assigned to the tooling order by the procurement system.',
    `order_timestamp` TIMESTAMP COMMENT 'Timestamp when the tooling order was created in the source system.',
    `ownership` STRING COMMENT 'Indicates whether the tooling is owned by the OEM or the supplier.. Valid values are `oem_owned|supplier_owned`',
    `part_number` STRING COMMENT 'Part number that the tooling will be used to produce.',
    `ppap_tryout_date` DATE COMMENT 'Date of the Production Part Approval Process (PPAP) tryout for the tooling.',
    `record_source_timestamp` TIMESTAMP COMMENT 'Timestamp from the source system when the record was created or last updated.',
    `regulatory_approval_status` STRING COMMENT 'Status of any regulatory approvals required for the tooling.. Valid values are `pending|approved|rejected`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component applied to the tooling order.',
    `tool_number` STRING COMMENT 'Manufacturer-assigned identifier for the specific tool.',
    `tooling_location` STRING COMMENT 'Plant or facility of the supplier where the tooling will be manufactured.',
    `tooling_order_status` STRING COMMENT 'Current processing state of the tooling order.. Valid values are `draft|released|approved|cancelled|closed`',
    `tooling_type` STRING COMMENT 'Category of tooling requested (e.g., die, mold, jig).. Valid values are `die|mold|jig|fixture|gauge|other`',
    `total_amount` DECIMAL(18,2) COMMENT 'Total gross monetary value of the tooling order before taxes and discounts.',
    `tryout_schedule_date` DATE COMMENT 'Planned date for the first production tryout of the tooling.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the tooling order record.',
    `warranty_period_months` STRING COMMENT 'Warranty duration provided by the supplier for the tooling.',
    CONSTRAINT pk_tooling_order PRIMARY KEY(`tooling_order_id`)
) COMMENT 'Purchase order specifically for supplier-owned or Automotive-owned tooling (dies, molds, jigs, fixtures, gauges) required for production of specific parts. Captures tooling type, tool number, associated part numbers, tooling ownership (OEM-owned vs supplier-owned), amortization method (lump sum vs per-piece), tooling location (supplier plant), tryout schedule, PPAP tryout date, and tooling approval status. Tooling orders follow a distinct procurement and capitalization workflow separate from production part POs.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` (
    `service_entry_sheet_id` BIGINT COMMENT 'Unique surrogate key for the service entry sheet record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Service entry costs are allocated to cost centers for service profitability analysis.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or site where the service was performed.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier providing the service.',
    `work_center_id` BIGINT COMMENT 'Identifier of the work center responsible for the service execution.',
    `acceptance_status` STRING COMMENT 'Current status of the service acceptance process.. Valid values are `pending|accepted|rejected|partial`',
    `acceptance_timestamp` TIMESTAMP COMMENT 'Date and time when the service entry sheet was accepted.',
    `acceptor_name` STRING COMMENT 'Name of the person who accepted the service entry sheet.',
    `account_assignment` STRING COMMENT 'Account assignment object (e.g., cost object, internal order) used for financial posting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service entry sheet record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the monetary amounts.',
    `service_entry_sheet_description` STRING COMMENT 'Free‑text description of the service performed.',
    `external_reference_code` STRING COMMENT 'Optional reference to an external system identifier.',
    `invoice_triggered` BOOLEAN COMMENT 'Indicates whether the service entry sheet has triggered invoice verification (true) or not (false).',
    `net_amount` DECIMAL(18,2) COMMENT 'Net monetary value after tax and any discounts.',
    `notes` STRING COMMENT 'Free‑form notes or comments entered by users.',
    `purchase_order_number` STRING COMMENT 'Reference to the service purchase order linked to this entry sheet.',
    `quantity_performed` DECIMAL(18,2) COMMENT 'Actual quantity of service units delivered (e.g., hours, days).',
    `service_category` STRING COMMENT 'Classification of the service type performed.. Valid values are `maintenance|repair|consulting|logistics|installation|other`',
    `service_date` DATE COMMENT 'Calendar date on which the service was performed (principal business event date).',
    `service_end_timestamp` TIMESTAMP COMMENT 'Date and time when the service execution completed.',
    `service_entry_sheet_status` STRING COMMENT 'Overall lifecycle status of the service entry sheet.. Valid values are `draft|submitted|approved|rejected|cancelled|closed`',
    `service_line_item` STRING COMMENT 'Identifier of the line item on the service purchase order.',
    `service_location` STRING COMMENT 'Physical location or facility where the service was performed.',
    `service_order_number` STRING COMMENT 'External service order number associated with the entry sheet.',
    `service_start_timestamp` TIMESTAMP COMMENT 'Date and time when the service execution began.',
    `sheet_number` STRING COMMENT 'Business identifier assigned to the service entry sheet by the source system.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component associated with the service total.',
    `tax_code` STRING COMMENT 'Tax code applicable to the service for tax calculation purposes.',
    `total_amount` DECIMAL(18,2) COMMENT 'Gross monetary value of the services before taxes and discounts.',
    `unit_of_measure` STRING COMMENT 'Unit in which the performed quantity is measured.. Valid values are `hour|day|service|unit|kg|liter`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the service entry sheet record.',
    CONSTRAINT pk_service_entry_sheet PRIMARY KEY(`service_entry_sheet_id`)
) COMMENT 'Confirmation document for services rendered by a supplier against a service purchase order, used for indirect procurement (maintenance services, contract labor, engineering services, logistics services). Captures service entry sheet number, service PO reference, service line items, actual quantities performed, acceptance status, acceptor name, acceptance date, and value accepted. Triggers invoice verification for service-based procurement. Sourced from SAP MM service entry sheet (ML81N/ESLH/ESLL).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_price_condition` (
    `procurement_price_condition_id` BIGINT COMMENT 'Unique identifier for the procurement_price_condition data product (auto-inserted pre-linking).',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: A procurement price condition is defined at the contract level; linking to supplier_contract provides contract context and avoids redundant contract reference columns.',
    CONSTRAINT pk_procurement_price_condition PRIMARY KEY(`procurement_price_condition_id`)
) COMMENT 'Negotiated pricing conditions and surcharges applicable to a supplier-material combination, including base price, freight surcharge, packaging surcharge, raw material index adjustment, currency exchange surcharge, and volume discount tiers. Captures condition type, validity period, scale basis, scale quantity, condition value, and currency. Enables accurate PO pricing and supports price variance analysis. Sourced from SAP MM condition records (KONP/KONH/MEK1).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_delivery_schedule` (
    `procurement_delivery_schedule_id` BIGINT COMMENT 'Unique identifier for the procurement_delivery_schedule data product (auto-inserted pre-linking).',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: A delivery schedule always belongs to a purchase order; adding purchase_order_id FK to procurement_delivery_schedule links the schedule to its parent order.',
    CONSTRAINT pk_procurement_delivery_schedule PRIMARY KEY(`procurement_delivery_schedule_id`)
) COMMENT 'Inbound delivery schedule communicated to suppliers specifying exact delivery windows, quantities, and dock assignments for JIT and JIS supply to assembly plants. Captures schedule type (firm, forecast, JIT call-off), delivery date and time window, dock door assignment, carrier, packaging type, number of containers, and schedule transmission status (EDI 830/862 sent). Enables synchronized inbound logistics and production line feeding. Distinct from scheduling agreement lines which are the contractual commitment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` (
    `supplier_nonconformance_id` BIGINT COMMENT 'System‑generated unique identifier for the supplier nonconformance record.',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - supplier nonconformances are detected at receiving plants',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier that provided the nonconforming part.',
    `sku_master_id` BIGINT COMMENT 'add column sku_master_id (BIGINT) with FK to inventory.sku_master.sku_master_id - nonconformances relate to specific materials/parts',
    `closure_status` STRING COMMENT 'Current status of the nonconformance record.. Valid values are `open|closed|cancelled|deferred`',
    `closure_timestamp` TIMESTAMP COMMENT 'Date‑time when the nonconformance was formally closed.',
    `containment_action` STRING COMMENT 'Immediate action taken to contain the defect (e.g., quarantine, segregation).',
    `corrective_action_due_date` DATE COMMENT 'Date by which the supplier must implement a corrective action.',
    `corrective_action_status` STRING COMMENT 'Current state of the supplier corrective action request (SCAR).. Valid values are `pending|in_progress|completed|failed`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the nonconformance record was first created in the lakehouse.',
    `defect_code` STRING COMMENT 'Standardized code that classifies the type of defect (e.g., surface, dimensional, functional).',
    `defect_description` STRING COMMENT 'Narrative description of the observed defect.',
    `detection_point` STRING COMMENT 'Location in the value chain where the nonconformance was detected.. Valid values are `incoming_inspection|line_side|warranty|post_sale`',
    `detection_timestamp` TIMESTAMP COMMENT 'Exact date‑time when the defect was first recorded.',
    `eight_d_report_reference` STRING COMMENT 'Identifier of the associated 8‑D problem‑solving report.',
    `nonconformance_number` STRING COMMENT 'Business‑visible identifier assigned to the nonconformance event, used in reporting and communication.',
    `part_description` STRING COMMENT 'Brief textual description of the part.',
    `part_number` STRING COMMENT 'Manufacturer part number (or SKU) of the component that failed inspection.',
    `ppm_count` DECIMAL(18,2) COMMENT 'Defect rate expressed in parts per million.',
    `rejected_quantity` BIGINT COMMENT 'Number of units rejected because of the defect.',
    `root_cause_category` STRING COMMENT 'High‑level classification of the root cause.. Valid values are `design|process|material|supplier|external|unknown`',
    `root_cause_description` STRING COMMENT 'Detailed explanation of the underlying cause of the defect.',
    `severity_level` STRING COMMENT 'Impact rating of the nonconformance on product quality and safety.. Valid values are `critical|major|minor|warning|info`',
    `total_inspected_quantity` BIGINT COMMENT 'Total number of units inspected during the detection event.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the record.',
    CONSTRAINT pk_supplier_nonconformance PRIMARY KEY(`supplier_nonconformance_id`)
) COMMENT 'Formal record of a supplier quality nonconformance event, capturing the rejected part number, defect description, defect code, PPM count, detection point (incoming inspection, line-side, warranty), containment action, 8D report reference, root cause category, corrective action due date, and closure status. Triggers supplier corrective action requests (SCAR) and feeds into supplier evaluation scoring. Integrates with SAP QM quality notification (QM10).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` (
    `spend_transaction_id` BIGINT COMMENT 'System-generated unique identifier for the spend transaction record.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Cost‑to‑serve analysis requires attributing each spend transaction to the owning customer for margin and service level reporting.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Spend Transaction for equipment maintenance must be allocated to the specific equipment; linking supports cost accounting and OEE analysis.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Spend transaction must be posted to a GL account for accurate financial reporting.',
    `invoice_id` BIGINT COMMENT 'Identifier of the supplier invoice linked to this spend.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or site where the spend was incurred.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Identifier of the purchase order that generated this spend transaction.',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier associated with the spend.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profit center tracking of spend transactions supports segment profitability reporting.',
    `purchase_requisition_id` BIGINT COMMENT 'Identifier of the purchase requisition that originated the transaction.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Spend analytics and cost‑to‑serve reports aggregate spend by SKU; FK to SKU master provides consistent material identification.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who approved the spend.',
    `spend_employee_id` BIGINT COMMENT 'Identifier of the employee who approved the spend.',
    `supplier_contract_id` BIGINT COMMENT 'Identifier of the supplier contract governing the transaction.',
    `accounting_date` DATE COMMENT 'Date used for posting the transaction to the general ledger.',
    `approval_status` STRING COMMENT 'Current approval state of the spend transaction.. Valid values are `approved|rejected|pending`',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the spend transaction received approval.',
    `commodity_code` STRING COMMENT 'Standard commodity classification code (e.g., UNSPSC) for the purchased item.',
    `cost_center_code` STRING COMMENT 'Internal cost‑center code used for allocating the spend.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the spend transaction record was first created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code of the transaction.. Valid values are `^[A-Z]{3}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency conversion rate to the corporate reporting currency at transaction time.',
    `fiscal_period` STRING COMMENT 'Fiscal period or month within the fiscal year (e.g., 2023Q1).',
    `fiscal_year` STRING COMMENT 'Fiscal year (e.g., FY2023) to which the spend is allocated.',
    `gl_account` STRING COMMENT 'GL account number used for financial posting of the spend.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total amount including net amount and tax.',
    `invoice_date` DATE COMMENT 'Date printed on the supplier invoice.',
    `is_blocked` BOOLEAN COMMENT 'Indicates whether the spend line is blocked for payment or further processing.',
    `is_service_line` BOOLEAN COMMENT 'True if the spend line represents a service rather than a material.',
    `is_tax_included` BOOLEAN COMMENT 'Flag indicating whether tax is already included in the unit price.',
    `net_amount` DECIMAL(18,2) COMMENT 'Total net spend amount (quantity × unit price) after discounts, before tax.',
    `payment_date` DATE COMMENT 'Date on which payment for the transaction was made or scheduled.',
    `payment_terms` STRING COMMENT 'Standard payment terms (e.g., Net 30, 2% 10 Net 30).',
    `project_code` STRING COMMENT 'Identifier of the internal project or initiative funded by the spend.',
    `quantity` DECIMAL(18,2) COMMENT 'Amount of material or service units purchased.',
    `receipt_number` STRING COMMENT 'Number of the goods receipt document linked to the spend.',
    `source_system_load_timestamp` TIMESTAMP COMMENT 'Timestamp when the source system record was loaded into the lakehouse.',
    `spend_category` STRING COMMENT 'High‑level classification of spend (direct, indirect, capital expenditure, or MRO).. Valid values are `direct|indirect|capex|mro`',
    `spend_subcategory` STRING COMMENT 'More granular classification within the spend category (e.g., raw material, tooling, consulting).',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component applied to the net amount.',
    `tax_code` STRING COMMENT 'Tax jurisdiction code applied to the transaction.',
    `transaction_number` STRING COMMENT 'Business-visible identifier assigned to the spend transaction (e.g., invoice or receipt number).',
    `transaction_status` STRING COMMENT 'Current lifecycle state of the spend transaction.. Valid values are `posted|pending|cancelled|reversed|draft|approved`',
    `transaction_timestamp` TIMESTAMP COMMENT 'Date and time when the spend transaction was recorded in the source system.',
    `unit_of_measure` STRING COMMENT 'UOM for the quantity (e.g., EA, KG, L).',
    `unit_price` DECIMAL(18,2) COMMENT 'Price per unit before taxes and discounts, in transaction currency.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the spend transaction record.',
    CONSTRAINT pk_spend_transaction PRIMARY KEY(`spend_transaction_id`)
) COMMENT 'Actuals-level spend record aggregating confirmed procurement spend by supplier, commodity, plant, cost center, and period. Captures transaction date, PO reference, invoice reference, material or service description, spend category, quantity, unit price, net spend amount, currency, tax amount, payment date, and spend classification (direct, indirect, CapEx, MRO). Serves as the foundational spend cube for category management, supplier rationalization, and savings tracking. Derived from confirmed goods receipts and posted invoices.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` (
    `savings_initiative_id` BIGINT COMMENT 'System-generated unique identifier for each savings initiative.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier associated with the savings initiative.',
    `employee_id` BIGINT COMMENT 'Identifier of the internal buyer or procurement owner responsible for the initiative.',
    `savings_employee_id` BIGINT COMMENT 'Identifier of the internal buyer or procurement owner responsible for the initiative.',
    `actual_savings_amount` DECIMAL(18,2) COMMENT 'Realized monetary savings after the initiative has been completed.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the initiative received formal approval.',
    `approved_by` BIGINT COMMENT 'Identifier of the employee who approved the initiative.',
    `baseline_spend` DECIMAL(18,2) COMMENT 'Annual spend amount for the commodity/supplier before any savings actions, expressed in the functional currency.',
    `commodity` STRING COMMENT 'Primary commodity or material group targeted by the initiative (e.g., steel, electronics).',
    `cost_center_code` STRING COMMENT 'Internal cost center responsible for the spend and savings.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the savings initiative record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for all monetary values in this record.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date when the initiative is considered closed; may be null for open‑ended initiatives.',
    `effective_start_date` DATE COMMENT 'Date when the initiative becomes active and savings can start to be realized.',
    `initiative_name` STRING COMMENT 'Descriptive name of the savings initiative for reporting and search.',
    `initiative_number` STRING COMMENT 'Business-visible identifier or code assigned to the savings initiative.',
    `initiative_type` STRING COMMENT 'Category of the initiative indicating the nature of the expected savings.. Valid values are `hard_savings|cost_avoidance|payment_term_improvement|process_improvement`',
    `notes` STRING COMMENT 'Additional comments, observations, or rationale related to the initiative.',
    `plant_code` STRING COMMENT 'Manufacturing plant or site linked to the initiative.',
    `program_year` STRING COMMENT 'Fiscal year to which the initiative is assigned for budgeting and reporting.',
    `region_code` STRING COMMENT 'Three‑letter code representing the geographic region of the initiative.. Valid values are `^[A-Z]{3}$`',
    `savings_initiative_status` STRING COMMENT 'Current lifecycle state of the initiative.. Valid values are `identified|approved|in_negotiation|realized|cancelled`',
    `savings_validation_method` STRING COMMENT 'Method used to verify that the reported savings are accurate and compliant.. Valid values are `internal_audit|external_audit|financial_system|management_review`',
    `target_savings_amount` DECIMAL(18,2) COMMENT 'Projected monetary savings to be achieved by the initiative.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the record.',
    CONSTRAINT pk_savings_initiative PRIMARY KEY(`savings_initiative_id`)
) COMMENT 'Procurement cost savings project tracking negotiated price reductions, value engineering changes, demand reduction, specification changes, or payment term improvements. Captures initiative type (hard savings, cost avoidance, payment terms), commodity, supplier, baseline spend, target savings amount, actual realized savings, savings validation method, responsible buyer, program year, and initiative status (identified, approved, in-negotiation, realized, cancelled). Supports procurement KPI reporting and annual savings target tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`payment_run` (
    `payment_run_id` BIGINT COMMENT 'Unique identifier for the payment run batch.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Payment run aggregates payments to a GL account for cash‑flow and reconciliation reporting.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier whose invoices are being paid in this run.',
    `approval_status` STRING COMMENT 'Approval workflow status for the run.. Valid values are `approved|pending|rejected`',
    `approved_by` STRING COMMENT 'User identifier who approved the payment run.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment run received approval.',
    `batch_number` STRING COMMENT 'Identifier of the batch within the automatic payment program.',
    `comments` STRING COMMENT 'Additional comments or remarks entered by the processor.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment run record was first created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for the payment run.',
    `currency_rate` DECIMAL(18,2) COMMENT 'Exchange rate applied to convert amounts to the reporting currency.',
    `payment_run_description` STRING COMMENT 'Free‑text description or notes for the payment run.',
    `discount_taken_flag` BOOLEAN COMMENT 'Indicates whether any discount was applied in the run.',
    `execution_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the automatic payment program finished processing.',
    `execution_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the automatic payment program started processing.',
    `fee_amount` DECIMAL(18,2) COMMENT 'Total processing fees charged for the run.',
    `is_automated` BOOLEAN COMMENT 'True if the run was generated by an automated schedule, false if manually triggered.',
    `number_of_invoices` STRING COMMENT 'Count of supplier invoices cleared in this payment run.',
    `payment_method` STRING COMMENT 'Instrument used to execute the payments.. Valid values are `ACH|wire|check|virtual_card|direct_deposit`',
    `processing_time_seconds` STRING COMMENT 'Total duration of the run in seconds (end minus start).',
    `reference` STRING COMMENT 'Reference number from external banking or clearing house, if applicable.',
    `run_date` DATE COMMENT 'Calendar date on which the payment run was executed.',
    `run_number` STRING COMMENT 'Business identifier assigned to the payment run by the source system.',
    `run_status` STRING COMMENT 'Current lifecycle status of the payment run.. Valid values are `scheduled|in_progress|completed|failed|cancelled`',
    `run_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the payment run was initiated.',
    `run_type` STRING COMMENT 'Classification of the run (e.g., regular scheduled, ad‑hoc, or correction).. Valid values are `regular|ad_hoc|correction`',
    `settlement_date` DATE COMMENT 'Date on which the funds are expected to settle in the suppliers account.',
    `settlement_status` STRING COMMENT 'Current settlement status of the payment run.. Valid values are `pending|settled|failed`',
    `status_reason` STRING COMMENT 'Free‑text explanation for the current status, e.g., error details.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount included in the payment run.',
    `total_discount_amount` DECIMAL(18,2) COMMENT 'Aggregate discount amount applied across all invoices in the run.',
    `total_discount_percent` DECIMAL(18,2) COMMENT 'Overall discount percentage applied across the run.',
    `total_gross_amount` DECIMAL(18,2) COMMENT 'Sum of all invoice gross amounts before any discounts or fees.',
    `total_invoices_amount` DECIMAL(18,2) COMMENT 'Aggregate gross amount of all invoices before discounts.',
    `total_net_amount` DECIMAL(18,2) COMMENT 'Net amount paid after discounts, taxes, and fees.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the payment run record.',
    `created_by` STRING COMMENT 'User identifier who created the payment run record.',
    CONSTRAINT pk_payment_run PRIMARY KEY(`payment_run_id`)
) COMMENT 'Automated payment execution batch for supplier invoice payments, capturing payment run date, payment method (ACH, wire, check, virtual card), bank account, total payment amount, currency, number of invoices cleared, discount taken, and payment run status. Represents the final step of the procure-to-pay cycle. Sourced from SAP FI automatic payment program (F110/PAYR). Distinct from individual supplier invoices — this is the payment execution event.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`vendor` (
    `vendor_id` BIGINT COMMENT 'Primary key for vendor',
    `parent_vendor_id` BIGINT COMMENT 'Self-referencing FK on vendor (parent_vendor_id)',
    `address_line1` STRING COMMENT 'Primary street address of the vendors headquarters or main office.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, building, etc.) for the vendor.',
    `bank_account_number` STRING COMMENT 'Vendors bank account number for payments.',
    `bank_name` STRING COMMENT 'Name of the financial institution holding the vendors account.',
    `city` STRING COMMENT 'City where the vendors primary location is situated.',
    `commodity_specialization` STRING COMMENT 'Specific commodity or product line the vendor specializes in.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code of the vendors primary location.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the vendor record was first created in the system.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit exposure approved for the vendor.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code used for vendor transactions.',
    `duns_number` STRING COMMENT 'Dun & Bradstreet unique identifier for the vendor organization.',
    `effective_end_date` DATE COMMENT 'Date after which the vendor record is no longer active (null for indefinite).',
    `effective_start_date` DATE COMMENT 'Date from which the vendor record becomes active.',
    `iatf16949_cert_expiry` DATE COMMENT 'Expiration date of the vendors IATF 16949 certification.',
    `iatf16949_certified` BOOLEAN COMMENT 'Indicates whether the vendor holds a valid IATF 16949 certification.',
    `incoterms` STRING COMMENT 'International commercial terms governing delivery responsibilities. [ENUM-REF-CANDIDATE: EXW|FCA|FAS|FOB|CFR|CIF|CPT|CIP|DAP|DPU|DDP — 11 candidates stripped; promote to reference product]',
    `iso14001_cert_expiry` DATE COMMENT 'Expiration date of the vendors ISO 14001 certification.',
    `iso14001_certified` BOOLEAN COMMENT 'Indicates whether the vendor holds ISO 14001 environmental management certification.',
    `iso9001_cert_expiry` DATE COMMENT 'Expiration date of the vendors ISO 9001 certification.',
    `iso9001_certified` BOOLEAN COMMENT 'Indicates whether the vendor is ISO 9001 certified.',
    `lead_time_days` STRING COMMENT 'Average number of days from order placement to delivery for the vendor.',
    `legal_name` STRING COMMENT 'Full legal name of the vendor entity for regulatory and tax purposes.',
    `max_order_quantity` STRING COMMENT 'Largest quantity that can be ordered from the vendor in a single transaction.',
    `min_order_quantity` STRING COMMENT 'Smallest quantity that can be ordered from the vendor.',
    `vendor_name` STRING COMMENT 'Legal business name of the vendor as used in contracts and purchase orders.',
    `notes` STRING COMMENT 'Free‑form comments or remarks about the vendor.',
    `onboarding_date` DATE COMMENT 'Date when the vendor was first onboarded into the procurement system.',
    `payment_terms` STRING COMMENT 'Standard payment terms agreed with the vendor (e.g., Net 30).',
    `postal_code` STRING COMMENT 'Postal/ZIP code for the vendors primary address.',
    `preferred_language` STRING COMMENT 'Language used for communication with the vendor.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary vendor contact used for electronic communication.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Name of the primary business contact for the vendor.',
    `primary_contact_phone` STRING COMMENT 'Telephone number of the primary vendor contact.. Valid values are `^+?[0-9]{7,15}$`',
    `state_province` STRING COMMENT 'State or province of the vendors primary location.',
    `supplier_category` STRING COMMENT 'High‑level classification of the vendors primary offering.. Valid values are `raw_material|components|services|logistics|software|other`',
    `swift_code` STRING COMMENT 'International bank identifier for cross‑border payments.',
    `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether the vendor is exempt from sales tax.',
    `tax_identification_number` STRING COMMENT 'Government‑issued tax identifier for the vendor.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the vendor record.',
    `vat_number` STRING COMMENT 'Value‑Added Tax registration number for the vendor.',
    `vendor_status` STRING COMMENT 'Current lifecycle status of the vendor master record.. Valid values are `active|inactive|suspended|pending|terminated`',
    `vendor_type` STRING COMMENT 'Classification of the vendor based on its role in the supply chain.. Valid values are `OEM|Tier1|Tier2|Distributor|ServiceProvider|Other`',
    `website_url` STRING COMMENT 'Public website address of the vendor.',
    CONSTRAINT pk_vendor PRIMARY KEY(`vendor_id`)
) COMMENT 'Master reference table for vendor. ';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` (
    `program_supplier_contract_id` BIGINT COMMENT 'Primary key for the ProgramSupplierContract association',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to the vehicle program',
    `contract_number` STRING COMMENT 'Unique identifier of the contract',
    `contract_type` STRING COMMENT 'Type of contract (e.g., supply, service, joint‑development)',
    `effective_end_date` DATE COMMENT 'Date when the contract expires or is terminated',
    `effective_start_date` DATE COMMENT 'Date when the contract becomes effective',
    `price_escalation_clause` STRING COMMENT 'Clause describing price escalation mechanisms',
    CONSTRAINT pk_program_supplier_contract PRIMARY KEY(`program_supplier_contract_id`)
) COMMENT 'Represents the contractual agreement between a vehicle development program and a supplier. Each record links one vehicle_program to one supplier and stores contract‑specific data that is relevant only to that pairing.. Existence Justification: Vehicle development programs engage multiple suppliers for parts, services, and components, and each supplier can provide for many different vehicle programs. The business creates and manages a contract for each program‑supplier pairing, capturing contract details such as number, type, effective dates, and price escalation clauses.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` (
    `procurement_supply_agreement_id` BIGINT COMMENT 'Primary key for the supply_agreement association',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier master',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to the spare parts catalog entry',
    `lead_time_days` STRING COMMENT 'Lead time in days for this supplier to deliver the part',
    `unit_price` DECIMAL(18,2) COMMENT 'Agreed price for the part from this supplier',
    CONSTRAINT pk_procurement_supply_agreement PRIMARY KEY(`procurement_supply_agreement_id`)
) COMMENT 'Represents the contractual relationship between a supplier and a spare part catalog entry. Each record links one supplier to one spare part and stores attributes that are specific to that supplier‑part combination, such as price and lead time.. Existence Justification: A supplier can provide many spare parts, and each spare part can be sourced from multiple approved suppliers. The business actively manages a supply agreement for each supplier‑part pair, capturing unit price, lead time, and contract identifier. These agreements are created, updated, and retired as part of procurement planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` (
    `supplier_regulatory_compliance_id` BIGINT COMMENT 'Primary key for the SupplierRegulatoryCompliance association',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to supplier',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to regulatory requirement',
    `compliance_deadline` DATE COMMENT 'Deadline by which the supplier must achieve compliance for this requirement',
    `compliance_status` STRING COMMENT 'Current compliance status of the supplier for the requirement (e.g., compliant, non‑compliant, pending)',
    `evidence_document_path` STRING COMMENT 'File path or URL to the evidence document supporting compliance',
    CONSTRAINT pk_supplier_regulatory_compliance PRIMARY KEY(`supplier_regulatory_compliance_id`)
) COMMENT 'This association captures the compliance relationship between a supplier and a regulatory requirement, including the suppliers compliance status, supporting evidence, and deadline for each requirement.. Existence Justification: Suppliers must meet multiple regulatory requirements, and each regulatory requirement applies to many suppliers. The compliance team actively tracks the status, evidence, and deadlines for each supplier‑requirement pair, creating a many‑to‑many operational entity.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` (
    `procurement_document_id` BIGINT COMMENT 'Primary key for procurement_document',
    `compliance_document_id` BIGINT COMMENT 'SSOT reference to compliance.compliance_document (cross-domain duplicate reconciliation; compliance designated SSOT owner for document).',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who approved the document.',
    `predecessor_procurement_document_id` BIGINT COMMENT 'Self-referencing FK on procurement_document (predecessor_procurement_document_id)',
    `procurement_supplier_id` BIGINT COMMENT 'Unique identifier of the supplier associated with the document.',
    `engineering_document_id` BIGINT COMMENT '',
    `approval_date` DATE COMMENT 'Date the document received final approval.',
    `confidentiality_level` STRING COMMENT 'Classification of the documents sensitivity.',
    `contract_term_months` STRING COMMENT 'Length of the contract in months.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the document record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary values.',
    `procurement_document_description` STRING COMMENT 'Free‑text description or summary of the documents purpose.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Monetary value of the discount applied.',
    `discount_rate` DECIMAL(18,2) COMMENT 'Discount percentage granted on the gross amount.',
    `document_number` STRING COMMENT 'Business-visible identifier or reference number assigned to the document.',
    `document_status` STRING COMMENT 'Current lifecycle state of the document.',
    `document_type` STRING COMMENT 'Classification of the procurement document (e.g., contract, purchase order, invoice, statement of requirements).',
    `document_version` STRING COMMENT 'Sequential version number of the document.',
    `effective_from` DATE COMMENT 'Date on which the document becomes legally binding.',
    `effective_until` DATE COMMENT 'Date on which the document expires or is no longer in effect; null for open‑ended agreements.',
    `file_checksum` STRING COMMENT 'SHA‑256 checksum used to verify file integrity.',
    `file_path` STRING COMMENT 'Storage location or URI of the digital document file.',
    `issue_date` DATE COMMENT 'Date the document was formally issued by the organization.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final payable amount after taxes and discounts.',
    `payment_due_date` DATE COMMENT 'Date by which payment must be received.',
    `payment_terms` STRING COMMENT 'Standard payment condition agreed for the document.',
    `procurement_category` STRING COMMENT 'Classification of spend (direct, indirect, capital expenditure, operating expenditure).',
    `received_date` DATE COMMENT 'Date the document was received by the counter‑party or internal stakeholder.',
    `renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract is set for automatic renewal.',
    `renewal_notice_period_days` STRING COMMENT 'Number of days prior to expiry that renewal notice must be issued.',
    `retention_period_days` STRING COMMENT 'Number of days the document must be retained before archival or deletion.',
    `signed_by` STRING COMMENT 'Full legal name of the individual who signed the document.',
    `signed_date` DATE COMMENT 'Date the document was signed by the authorized signatory.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax applied to the document.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate expressed as a percentage.',
    `total_amount` DECIMAL(18,2) COMMENT 'Gross monetary value of the document before taxes, discounts, or adjustments.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the document record.',
    CONSTRAINT pk_procurement_document PRIMARY KEY(`procurement_document_id`)
) COMMENT 'Master reference table for procurement_document. Referenced by document_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`approval_group` (
    `approval_group_id` BIGINT COMMENT 'Primary key for approval_group',
    `parent_approval_group_id` BIGINT COMMENT 'Self-referencing FK on approval_group (parent_approval_group_id)',
    `approval_level` STRING COMMENT 'Numeric level indicating the hierarchy of the group within the approval chain.',
    `approval_threshold_amount` DECIMAL(18,2) COMMENT 'Monetary amount that must be met or exceeded before the group can approve a purchase.',
    `approval_group_code` STRING COMMENT 'Business code that uniquely identifies the approval group within the organization.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the approval group record was first created in the system.',
    `department` STRING COMMENT 'Business department that owns and maintains the approval group.',
    `approval_group_description` STRING COMMENT 'Free‑form text describing the purpose, scope, and rules of the approval group.',
    `effective_from` DATE COMMENT 'Date when the approval group becomes active for use in procurement processes.',
    `effective_until` DATE COMMENT 'Date when the approval group is retired or no longer valid (null if open‑ended).',
    `escalation_policy` STRING COMMENT 'Policy that defines how approvals are escalated when thresholds are exceeded.',
    `is_system_defined` BOOLEAN COMMENT 'Indicates whether the approval group is a standard system‑defined group (true) or a custom user‑defined group (false).',
    `max_approvers` STRING COMMENT 'Maximum number of approvers allowed in this group for a single transaction.',
    `approval_group_name` STRING COMMENT 'Human‑readable name of the approval group used in procurement workflows.',
    `notes` STRING COMMENT 'Additional free‑form notes or comments about the approval group.',
    `region` STRING COMMENT 'Geographic region to which the approval group applies.',
    `requires_multi_approval` BOOLEAN COMMENT 'True if the group requires more than one approver for a transaction.',
    `approval_group_status` STRING COMMENT 'Current lifecycle status of the approval group.',
    `approval_group_type` STRING COMMENT 'Category of the approval group indicating its primary purpose (e.g., financial, operational).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the approval group record.',
    `created_by` STRING COMMENT 'User identifier of the person who initially created the approval group record.',
    CONSTRAINT pk_approval_group PRIMARY KEY(`approval_group_id`)
) COMMENT 'Master reference table for approval_group. Referenced by group_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` (
    `auto_approval_rule_id` BIGINT COMMENT 'Primary key for auto_approval_rule',
    `employee_id` BIGINT COMMENT 'Identifier of the user or team responsible for maintaining the rule.',
    `superseded_auto_approval_rule_id` BIGINT COMMENT 'Self-referencing FK on auto_approval_rule (superseded_auto_approval_rule_id)',
    `applies_to_purchase_category` STRING COMMENT 'Code of the purchase category (e.g., raw_materials, MRO) to which the rule applies.',
    `applies_to_supplier_segment` STRING COMMENT 'Supplier segment (e.g., tier‑1, strategic) for which the rule is relevant.',
    `approval_level` STRING COMMENT 'Numeric level indicating which approval tier the rule triggers (e.g., 1 = front‑line, 2 = manager).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the rule record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for the threshold amount.',
    `auto_approval_rule_description` STRING COMMENT 'Detailed description of the rule purpose and logic.',
    `effective_from` DATE COMMENT 'Date when the rule becomes active and enforceable.',
    `effective_until` DATE COMMENT 'Date when the rule expires; null indicates an open‑ended rule.',
    `escalation_time_hours` STRING COMMENT 'Maximum hours allowed before the rule escalates to the next approval level.',
    `execution_count` BIGINT COMMENT 'Cumulative number of times the rule has been evaluated.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether the rule must be satisfied for a purchase to be approved.',
    `last_executed_timestamp` TIMESTAMP COMMENT 'Timestamp of the last time the rule was evaluated against a purchase request.',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information or comments about the rule.',
    `priority` STRING COMMENT 'Numeric priority determining rule evaluation order; lower numbers evaluate first.',
    `rule_code` STRING COMMENT 'Business code that uniquely identifies the rule across systems.',
    `rule_name` STRING COMMENT 'Human‑readable name of the rule used in procurement configuration.',
    `rule_type` STRING COMMENT 'Classification of the rule logic (e.g., amount threshold, supplier rating).',
    `auto_approval_rule_status` STRING COMMENT 'Current lifecycle status of the rule.',
    `threshold_value` DECIMAL(18,2) COMMENT 'Numeric threshold value used by amount‑based rules (e.g., maximum purchase amount).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the rule.',
    CONSTRAINT pk_auto_approval_rule PRIMARY KEY(`auto_approval_rule_id`)
) COMMENT 'Master reference table for auto_approval_rule. Referenced by auto_approval_rule_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` (
    `procurement_approval_id` BIGINT COMMENT 'System-generated unique identifier for the procurement approval record.',
    `approval_group_id` BIGINT COMMENT 'Identifier of the approval group or committee responsible for this step.',
    `auto_approval_rule_id` BIGINT COMMENT 'Identifier of the rule that triggered automatic approval.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or user to whom the approval was delegated.',
    `procurement_approval_employee_id` BIGINT COMMENT 'Unique identifier of the employee or user who performed the approval.',
    `procurement_delegated_to_employee_id` BIGINT COMMENT 'Identifier of the employee or user to whom the approval was delegated.',
    `procurement_document_id` BIGINT COMMENT 'Unique identifier of the underlying procurement document (e.g., requisition ID, PO number).',
    `procurement_employee_id` BIGINT COMMENT 'Unique identifier of the employee or user who performed the approval.',
    `approval_action` STRING COMMENT 'Result of the approval decision for this step.. Valid values are `approved|rejected|escalated|withdrawn`',
    `approval_number` STRING COMMENT 'Human-readable identifier for the approval workflow instance.',
    `approval_status` STRING COMMENT 'Current lifecycle status of the approval record.. Valid values are `pending|in_progress|completed|cancelled`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the approval decision was recorded.',
    `approved_amount` DECIMAL(18,2) COMMENT 'Monetary amount that was approved in this step.',
    `approver_role` STRING COMMENT 'Organizational role of the individual responsible for this approval step.. Valid values are `procurement_manager|finance|legal|executive|operations|supply_chain`',
    `attachment_flag` BOOLEAN COMMENT 'Indicates whether supporting documents are attached to the approval record.',
    `attachment_url` STRING COMMENT 'Link to the location of attached supporting documentation.',
    `comments` STRING COMMENT 'Free-text comments provided by the approver regarding the decision.',
    `compliance_flag` BOOLEAN COMMENT 'True if the approval must satisfy regulatory or internal compliance requirements.',
    `compliance_requirements` STRING COMMENT 'Textual description of specific compliance criteria applicable to this approval.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the approval record was initially created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for the monetary amounts.. Valid values are `[A-Z]{3}`',
    `deadline` DATE COMMENT 'Date by which the approval decision must be completed.',
    `decision_reason` STRING COMMENT 'Explanation provided for the approval decision, especially if rejected.',
    `delegation_flag` BOOLEAN COMMENT 'Indicates whether the approval was delegated to another individual (True) or performed by the assigned approver (False).',
    `document_type` STRING COMMENT 'Type of procurement document subject to this approval.. Valid values are `requisition|purchase_order|contract|capex`',
    `escalation_reason` STRING COMMENT 'Reason for escalating the approval to a higher authority.',
    `expiration_timestamp` TIMESTAMP COMMENT 'Date and time when the approval request expires if no action is taken.',
    `is_auto_approved` BOOLEAN COMMENT 'Indicates whether the approval was granted automatically by system rules.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the procurement item is classified as critical for business operations.',
    `is_final_approval` BOOLEAN COMMENT 'True if this step represents the final required approval in the workflow.',
    `policy_code` STRING COMMENT 'Code identifying the delegation of authority policy applied to this approval.',
    `policy_version` STRING COMMENT 'Version identifier of the approval policy.',
    `risk_score` DECIMAL(18,2) COMMENT 'Numerical risk rating (0-100) associated with the procurement request.',
    `spend_amount` DECIMAL(18,2) COMMENT 'Monetary amount requested for the procurement document subject to approval.',
    `step_sequence` STRING COMMENT 'Sequential order of this approval step within the overall workflow.',
    `threshold_amount` DECIMAL(18,2) COMMENT 'Spend threshold that triggers this approval level according to delegation of authority policy.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the approval record.',
    CONSTRAINT pk_procurement_approval PRIMARY KEY(`procurement_approval_id`)
) COMMENT 'Workflow approval record for procurement documents requiring authorization (purchase requisitions, purchase orders, contracts, CapEx requisitions) based on spend thresholds, commodity type, or strategic significance. Captures document reference, approval step sequence, approver role, approver identity, approval action (approved, rejected, escalated), approval timestamp, comments, and delegation flag. Supports Automotives procurement governance and delegation of authority (DOA) policy enforcement.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` ADD CONSTRAINT `fk_procurement_procurement_supplier_parent_supplier_procurement_supplier_id` FOREIGN KEY (`parent_supplier_procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ADD CONSTRAINT `fk_procurement_procurement_supplier_plant_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ADD CONSTRAINT `fk_procurement_sourcing_event_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ADD CONSTRAINT `fk_procurement_sourcing_event_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ADD CONSTRAINT `fk_procurement_supplier_quote_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ADD CONSTRAINT `fk_procurement_supplier_quote_sourcing_event_id` FOREIGN KEY (`sourcing_event_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`sourcing_event`(`sourcing_event_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ADD CONSTRAINT `fk_procurement_scheduling_agreement_line_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_invoice_line` ADD CONSTRAINT `fk_procurement_procurement_invoice_line_supplier_invoice_id` FOREIGN KEY (`supplier_invoice_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_invoice`(`supplier_invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ADD CONSTRAINT `fk_procurement_spend_category_parent_category_spend_category_id` FOREIGN KEY (`parent_category_spend_category_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ADD CONSTRAINT `fk_procurement_approved_vendor_list_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ADD CONSTRAINT `fk_procurement_approved_vendor_list_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ADD CONSTRAINT `fk_procurement_info_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ADD CONSTRAINT `fk_procurement_supplier_evaluation_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ADD CONSTRAINT `fk_procurement_supplier_development_plan_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ADD CONSTRAINT `fk_procurement_supplier_development_plan_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_supplier_quote_id` FOREIGN KEY (`supplier_quote_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_quote`(`supplier_quote_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ADD CONSTRAINT `fk_procurement_tooling_order_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_price_condition` ADD CONSTRAINT `fk_procurement_procurement_price_condition_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_delivery_schedule` ADD CONSTRAINT `fk_procurement_procurement_delivery_schedule_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ADD CONSTRAINT `fk_procurement_supplier_nonconformance_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ADD CONSTRAINT `fk_procurement_payment_run_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ADD CONSTRAINT `fk_procurement_vendor_parent_vendor_id` FOREIGN KEY (`parent_vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ADD CONSTRAINT `fk_procurement_program_supplier_contract_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` ADD CONSTRAINT `fk_procurement_procurement_supply_agreement_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ADD CONSTRAINT `fk_procurement_supplier_regulatory_compliance_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ADD CONSTRAINT `fk_procurement_procurement_document_predecessor_procurement_document_id` FOREIGN KEY (`predecessor_procurement_document_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_document`(`procurement_document_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ADD CONSTRAINT `fk_procurement_procurement_document_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ADD CONSTRAINT `fk_procurement_approval_group_parent_approval_group_id` FOREIGN KEY (`parent_approval_group_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`approval_group`(`approval_group_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ADD CONSTRAINT `fk_procurement_auto_approval_rule_superseded_auto_approval_rule_id` FOREIGN KEY (`superseded_auto_approval_rule_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`auto_approval_rule`(`auto_approval_rule_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ADD CONSTRAINT `fk_procurement_procurement_approval_approval_group_id` FOREIGN KEY (`approval_group_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`approval_group`(`approval_group_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ADD CONSTRAINT `fk_procurement_procurement_approval_auto_approval_rule_id` FOREIGN KEY (`auto_approval_rule_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`auto_approval_rule`(`auto_approval_rule_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ADD CONSTRAINT `fk_procurement_procurement_approval_procurement_document_id` FOREIGN KEY (`procurement_document_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_document`(`procurement_document_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`procurement` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`procurement` SET TAGS ('dbx_domain' = 'procurement');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier` SET TAGS ('dbx_subdomain' = 'supplier_management');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `procurement_supplier_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Plant Association ID (SUPPLIER_PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `packaging_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Specification ID (PKG_SPEC_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID (PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID (SUPPLIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 1 (ADDR_LINE1)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 2 (ADDR_LINE2)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date (APPROVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Plant Approval Status (APPROVAL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected|suspended');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'Delivery City (CITY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Country Code (COUNTRY_CODE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `country_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EFFECTIVE_UNTIL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (EFFECTIVE_FROM)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Terms (FREIGHT_TERMS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'FOB|CIF|EXW|DDP');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `is_preferred_supplier` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Flag (PREFERRED_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `jis_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'JIS Delivery Flag (JIS_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `jit_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'JIT Delivery Flag (JIT_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp (LAST_UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (DAYS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Postal Code (POSTAL_CODE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `procurement_supplier_plant_status` SET TAGS ('dbx_business_glossary_term' = 'Relationship Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `procurement_supplier_plant_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `quality_rating` SET TAGS ('dbx_business_glossary_term' = 'Quality Rating (QUALITY_RATING)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `shipping_method` SET TAGS ('dbx_business_glossary_term' = 'Shipping Method (SHIPPING_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `shipping_method` SET TAGS ('dbx_value_regex' = 'truck|rail|ship|air');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'Delivery State/Province (STATE_PROV)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contact Email (CONTACT_EMAIL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contact Name (CONTACT_NAME)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contact Phone (CONTACT_PHONE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `supplier_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supplier_plant` ALTER COLUMN `unloading_point` SET TAGS ('dbx_business_glossary_term' = 'Unloading Point (UNLOADING_POINT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier (SUPPLIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Identifier (BUYER_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Identifier (BUYER_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier (CONTRACT_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `award_amount` SET TAGS ('dbx_business_glossary_term' = 'Award Amount (AWARD_AMT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `award_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Award Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `award_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `award_decision_date` SET TAGS ('dbx_business_glossary_term' = 'Award Decision Date (AWARD_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `award_supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Awarded Supplier Name (AWARD_SUPPLIER_NAME)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `buyer_department` SET TAGS ('dbx_business_glossary_term' = 'Buyer Department (DEPT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `buyer_name` SET TAGS ('dbx_business_glossary_term' = 'Buyer Name (BUYER_NAME)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `commodity_group` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group (COMMODITY_GRP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level (CONF_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_event_description` SET TAGS ('dbx_business_glossary_term' = 'Event Description (DESC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Method (EVAL_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_value_regex' = 'weighted|lowest_price|best_value');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `evaluation_score` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Score (EVAL_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `event_number` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Number (EVT_NO)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Launch Timestamp (EVENT_TS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Type (RFQ/RFI/RFP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'RFQ|RFI|RFP');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `is_multi_source` SET TAGS ('dbx_business_glossary_term' = 'Multi-Source Flag (MULTI_SOURCE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `is_nda_required` SET TAGS ('dbx_business_glossary_term' = 'NDA Required Flag (NDA_REQ)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sor_reference` SET TAGS ('dbx_business_glossary_term' = 'Statement of Requirements Reference (SOR_REF)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sor_version` SET TAGS ('dbx_business_glossary_term' = 'SOR Version (SOR_VER)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_event_status` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_event_status` SET TAGS ('dbx_value_regex' = 'draft|open|closed|cancelled|awarded');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Strategy (STRATEGY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'single_source|dual_source|competitive_bid|direct_negotiation');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `submission_deadline` SET TAGS ('dbx_business_glossary_term' = 'Submission Deadline (SUB_DEADLINE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `target_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Target Spend Amount (TARGET_SPEND)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `supplier_quote_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quote ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Source Event ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `amortization_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Amortization Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `amortization_term_months` SET TAGS ('dbx_business_glossary_term' = 'Amortization Term (Months)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Supplier Comments');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `is_preferred` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net_30|net_60|net_90|prepaid|cash_on_delivery|letter_of_credit');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `ppap_commitment_date` SET TAGS ('dbx_business_glossary_term' = 'PPAP Commitment Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `quote_number` SET TAGS ('dbx_business_glossary_term' = 'Quote Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `quote_status` SET TAGS ('dbx_business_glossary_term' = 'Quote Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `quote_status` SET TAGS ('dbx_value_regex' = 'submitted|under_review|awarded|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `quote_type` SET TAGS ('dbx_business_glossary_term' = 'Quote Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `quote_type` SET TAGS ('dbx_value_regex' = 'rfq|rfp|rfi|rfq_response');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `quoted_price` SET TAGS ('dbx_business_glossary_term' = 'Quoted Unit Price');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Quote Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `tooling_cost` SET TAGS ('dbx_business_glossary_term' = 'Tooling Cost');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `total_price` SET TAGS ('dbx_business_glossary_term' = 'Total Price');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Quote Validity End Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Quote Validity Start Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_scope' = 'mvm');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_mvm' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_mvm_scope' = 'keep');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requestor Employee ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_approved_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_approved_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_approved_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requestor Employee ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Program Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'K|P|U|F|M');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `batch_management_flag` SET TAGS ('dbx_business_glossary_term' = 'Batch Management Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `confirmation_date` SET TAGS ('dbx_business_glossary_term' = 'Line Confirmation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location (LGORT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Under‑Delivery Tolerance (%)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (MEINS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|SET');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract ID (SCID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By (AB)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID (SID)');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `scheduling_agreement_line_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `change_number` SET TAGS ('dbx_business_glossary_term' = 'Change Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `change_number` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `confirmed_quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Quantity Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `confirmed_quantity_unit` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|M2|M3');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `creation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `cumulative_received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Received Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `cumulative_received_quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Received Quantity Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `cumulative_received_quantity_unit` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|M2|M3');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|GBP|CNY|CAD');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `delivery_window_end` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window End Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `delivery_window_start` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window Start Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'FOB|CIF|EXW|DDP');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|FOB|CFR|CIF|DDP');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `is_backorder` SET TAGS ('dbx_business_glossary_term' = 'Backorder Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `is_late` SET TAGS ('dbx_business_glossary_term' = 'Late Delivery Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `last_received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Received Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `line_sequence` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|closed|cancelled|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number (Batch)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `lot_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]+$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `price_per_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Per Unit');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `quality_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `quality_status` SET TAGS ('dbx_value_regex' = 'accepted|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `schedule_line_category` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `schedule_line_category` SET TAGS ('dbx_value_regex' = 'firm|forecast');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `scheduled_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `scheduled_quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Quantity Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `scheduled_quantity_unit` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|M2|M3');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `supplier_material_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Material Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `supplier_material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]+$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ALTER COLUMN `tax_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Receipt User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_receipt_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Receipt User ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_receipt_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_receipt_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `accounting_document_number` SET TAGS ('dbx_business_glossary_term' = 'Accounting Document Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `accounting_year` SET TAGS ('dbx_business_glossary_term' = 'Accounting Year');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `invoice_match_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Match Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `invoice_match_status` SET TAGS ('dbx_value_regex' = 'matched|unmatched|partial');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_blocked_stock` SET TAGS ('dbx_business_glossary_term' = 'Blocked Stock Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = '101|103|105');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_goods_receipt_status` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_goods_receipt_status` SET TAGS ('dbx_value_regex' = 'posted|reversed|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `purchase_order_item` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Item');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Result');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_result` SET TAGS ('dbx_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quantity_received` SET TAGS ('dbx_business_glossary_term' = 'Quantity Received');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_type` SET TAGS ('dbx_business_glossary_term' = 'Receipt Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `receipt_type` SET TAGS ('dbx_value_regex' = 'standard|return|transfer');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `slip_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Slip Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `source_system_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Source System Load Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|PCS');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `vendor_invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `acquisition_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Acquisition Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `goods_receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Number');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_invoice_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_invoice_line` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_invoice_line` ALTER COLUMN `procurement_invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for procurement_invoice_line');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_invoice_line` ALTER COLUMN `supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` SET TAGS ('dbx_subdomain' = 'analytics_governance');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `parent_category_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Category Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Category Manager Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Category Manager Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code (UNSPSC or Internal)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `category_name` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `commodity_group` SET TAGS ('dbx_business_glossary_term' = 'Commodity Group');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_category_description` SET TAGS ('dbx_business_glossary_term' = 'Category Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `direct_indirect_flag` SET TAGS ('dbx_business_glossary_term' = 'Direct vs Indirect Spend Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `external_reference` SET TAGS ('dbx_business_glossary_term' = 'External Reference Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level (Depth)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `is_leaf` SET TAGS ('dbx_business_glossary_term' = 'Leaf Category Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Scope');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `scope` SET TAGS ('dbx_value_regex' = 'global|regional|local');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Preferred Sourcing Strategy');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'single_source|multiple_source|global|local|consortium|none');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_category_status` SET TAGS ('dbx_business_glossary_term' = 'Category Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_category_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_category_type` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `spend_category_type` SET TAGS ('dbx_value_regex' = 'commodity|service|capital|operating');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `strategic_flag` SET TAGS ('dbx_business_glossary_term' = 'Strategic Category Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Record Version Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approved_vendor_list_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Vendor List ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `material_id` SET TAGS ('dbx_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `material_id` SET TAGS ('dbx_business_glossary_term' = 'Material Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_evaluation_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Evaluation ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluator ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_evaluator_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluator ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_evaluator_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ALTER COLUMN `supplier_evaluator_employee_id` SET TAGS ('dbx_pii' = 'true');
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
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_development_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Development Plan ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `apqp_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Apqp Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_approved_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_approved_by_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_approved_by_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `actual_metric_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Metric Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `actual_metric_value` SET TAGS ('dbx_business_glossary_term' = 'Actual Metric Value');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `actual_progress_percent` SET TAGS ('dbx_business_glossary_term' = 'Actual Progress Percent');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `budget_status` SET TAGS ('dbx_business_glossary_term' = 'Budget Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `budget_status` SET TAGS ('dbx_value_regex' = 'under_budget|on_budget|over_budget');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirements');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `investment_amount` SET TAGS ('dbx_business_glossary_term' = 'Investment Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `investment_currency` SET TAGS ('dbx_business_glossary_term' = 'Investment Currency');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `investment_type` SET TAGS ('dbx_business_glossary_term' = 'Investment Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `investment_type` SET TAGS ('dbx_value_regex' = 'automotive_funded|supplier_funded|joint');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `is_capex` SET TAGS ('dbx_business_glossary_term' = 'Is CapEx');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `is_oem` SET TAGS ('dbx_business_glossary_term' = 'Is OEM Supplier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `milestone_schedule` SET TAGS ('dbx_business_glossary_term' = 'Milestone Schedule');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `next_milestone_date` SET TAGS ('dbx_business_glossary_term' = 'Next Milestone Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Plan Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Plan Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Plan Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Plan Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'quality_improvement|capacity_ramp|technology_development|cost_reduction');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Plan Priority');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `related_sop_date` SET TAGS ('dbx_business_glossary_term' = 'Related SOP Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_development_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Plan Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `supplier_development_plan_status` SET TAGS ('dbx_value_regex' = 'draft|approved|in_progress|completed|on_hold|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `target_metric_name` SET TAGS ('dbx_business_glossary_term' = 'Target Metric Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `target_metric_unit` SET TAGS ('dbx_business_glossary_term' = 'Target Metric Unit');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `target_metric_value` SET TAGS ('dbx_business_glossary_term' = 'Target Metric Value');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capex_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'CapEx Requisition Identifier (CAPEX_REQ_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `budget_line_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Line Identifier (BUDGET_LINE_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requestor Employee Identifier (REQ_EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capex_project_manager_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Project Manager Employee Identifier (PM_EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capex_project_manager_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capex_project_manager_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Identifier (COST_CENTER_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Department Identifier (DEPT_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier (PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `primary_capex_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requestor Employee Identifier (REQ_EMP_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `primary_capex_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `primary_capex_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Supplier Identifier (VENDOR_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `supplier_quote_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Quote Identifier (VENDOR_QUOTE_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Supplier Identifier (VENDOR_ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `afe_number` SET TAGS ('dbx_business_glossary_term' = 'Authorization for Expenditure Number (AFE_NO)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `approval_authority_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority Level (APPROVAL_LVL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `approval_authority_level` SET TAGS ('dbx_value_regex' = 'manager|director|vp|cfo|ceo');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date (APPROVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `approved_budget` SET TAGS ('dbx_business_glossary_term' = 'Approved Budget Amount (APPROVED_BUDGET_AMT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `asset_category` SET TAGS ('dbx_business_glossary_term' = 'Asset Category (ASSET_CAT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `asset_category` SET TAGS ('dbx_value_regex' = 'tooling|equipment|facility|software|infrastructure|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `asset_life_years` SET TAGS ('dbx_business_glossary_term' = 'Asset Useful Life (Years) (ASSET_LIFE_YRS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capex_requisition_status` SET TAGS ('dbx_business_glossary_term' = 'Requisition Status (REQ_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capex_requisition_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|rejected|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capitalized_flag` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Flag (CAPITALIZED_FLG)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status (COMPLIANCE_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURR_CD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `depreciation_life_years` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Life (Years) (DEP_LIFE_YRS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date (DEP_START_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `capex_requisition_description` SET TAGS ('dbx_business_glossary_term' = 'Requisition Description (REQ_DESC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `environmental_impact_assessment` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Assessment (ENV_IMPACT_ASSESSMENT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `environmental_impact_assessment` SET TAGS ('dbx_value_regex' = 'low|medium|high|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `estimated_investment` SET TAGS ('dbx_business_glossary_term' = 'Estimated Investment Amount (EST_INV_AMT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'Funding Source (FUND_SRC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `funding_source` SET TAGS ('dbx_value_regex' = 'internal|external|loan|grant|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `justification_type` SET TAGS ('dbx_business_glossary_term' = 'Justification Type (JUST_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `justification_type` SET TAGS ('dbx_value_regex' = 'new_model|replacement|capacity|maintenance|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `procurement_method` SET TAGS ('dbx_business_glossary_term' = 'Procurement Method (PROC_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `procurement_method` SET TAGS ('dbx_value_regex' = 'purchase|lease|internal|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `project_code` SET TAGS ('dbx_business_glossary_term' = 'Project Code (PRJ_CD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `regulatory_approval_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Required Flag (REG_APPROVAL_REQ_FLG)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status (REG_APPROVAL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `request_date` SET TAGS ('dbx_business_glossary_term' = 'Request Date (REQ_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `required_by_date` SET TAGS ('dbx_business_glossary_term' = 'Required By Date (REQ_BY_DATE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'CapEx Requisition Number (REQ_NO)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `risk_assessment` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Level (RISK_ASSESSMENT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `risk_assessment` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount (TAX_AMT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code (TAX_CD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure Element (WBS_ELM)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tooling_order_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `engineering_project_id` SET TAGS ('dbx_business_glossary_term' = 'Project Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tooling_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `amortization_method` SET TAGS ('dbx_business_glossary_term' = 'Amortization Method');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `amortization_method` SET TAGS ('dbx_value_regex' = 'lump_sum|per_piece');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `amortization_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Amortization Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `amortization_term_months` SET TAGS ('dbx_business_glossary_term' = 'Amortization Term (Months)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Tooling Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `capital_expenditure_flag` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure Indicator');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `compliance_certification` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certification');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `depreciation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation End Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|reducing_balance|units_of_production');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `depreciation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Start Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `expected_life_months` SET TAGS ('dbx_business_glossary_term' = 'Expected Tooling Life (Months)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Tooling Order Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Tooling Order Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `order_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Tooling Order Date and Time');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `ownership` SET TAGS ('dbx_business_glossary_term' = 'Tooling Ownership');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `ownership` SET TAGS ('dbx_value_regex' = 'oem_owned|supplier_owned');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Associated Part Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `ppap_tryout_date` SET TAGS ('dbx_business_glossary_term' = 'PPAP Tryout Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `record_source_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Source System Record Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tooling Order Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tool_number` SET TAGS ('dbx_business_glossary_term' = 'Tool Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tooling_location` SET TAGS ('dbx_business_glossary_term' = 'Tooling Supplier Plant');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tooling_order_status` SET TAGS ('dbx_business_glossary_term' = 'Tooling Order Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tooling_order_status` SET TAGS ('dbx_value_regex' = 'draft|released|approved|cancelled|closed');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tooling_type` SET TAGS ('dbx_business_glossary_term' = 'Tooling Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tooling_type` SET TAGS ('dbx_value_regex' = 'die|mold|jig|fixture|gauge|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `total_amount` SET TAGS ('dbx_business_glossary_term' = 'Tooling Order Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `tryout_schedule_date` SET TAGS ('dbx_business_glossary_term' = 'Tooling Tryout Schedule Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Tooling Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_id` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `acceptance_status` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `acceptance_status` SET TAGS ('dbx_value_regex' = 'pending|accepted|rejected|partial');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `acceptance_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `acceptor_name` SET TAGS ('dbx_business_glossary_term' = 'Acceptor Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `account_assignment` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External Reference ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `invoice_triggered` SET TAGS ('dbx_business_glossary_term' = 'Invoice Triggered Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `quantity_performed` SET TAGS ('dbx_business_glossary_term' = 'Quantity Performed');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_category` SET TAGS ('dbx_value_regex' = 'maintenance|repair|consulting|logistics|installation|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_date` SET TAGS ('dbx_business_glossary_term' = 'Service Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Service End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_status` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|rejected|cancelled|closed');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_line_item` SET TAGS ('dbx_business_glossary_term' = 'Service Line Item Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_location` SET TAGS ('dbx_business_glossary_term' = 'Service Location');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_order_number` SET TAGS ('dbx_business_glossary_term' = 'Service Order Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Service Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `sheet_number` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `total_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Amount (Gross)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'hour|day|service|unit|kg|liter');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_price_condition` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_price_condition` SET TAGS ('dbx_subdomain' = 'analytics_governance');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_price_condition` ALTER COLUMN `procurement_price_condition_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for procurement_price_condition');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_price_condition` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_delivery_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_delivery_schedule` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_delivery_schedule` ALTER COLUMN `procurement_delivery_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for procurement_delivery_schedule');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_delivery_schedule` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `supplier_nonconformance_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Nonconformance ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `closure_status` SET TAGS ('dbx_business_glossary_term' = 'Closure Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `closure_status` SET TAGS ('dbx_value_regex' = 'open|closed|cancelled|deferred');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `closure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Closure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `containment_action` SET TAGS ('dbx_business_glossary_term' = 'Containment Action');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date (CAD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `corrective_action_status` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `corrective_action_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|failed');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `defect_code` SET TAGS ('dbx_business_glossary_term' = 'Defect Code (DC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `defect_description` SET TAGS ('dbx_business_glossary_term' = 'Defect Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `detection_point` SET TAGS ('dbx_business_glossary_term' = 'Detection Point (DP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `detection_point` SET TAGS ('dbx_value_regex' = 'incoming_inspection|line_side|warranty|post_sale');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Detection Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `eight_d_report_reference` SET TAGS ('dbx_business_glossary_term' = '8‑D Report Reference');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `nonconformance_number` SET TAGS ('dbx_business_glossary_term' = 'Nonconformance Number (NCN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `part_description` SET TAGS ('dbx_business_glossary_term' = 'Part Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number (PN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `ppm_count` SET TAGS ('dbx_business_glossary_term' = 'Parts‑Per‑Million (PPM) Count');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `rejected_quantity` SET TAGS ('dbx_business_glossary_term' = 'Rejected Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root‑Cause Category (RCC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'design|process|material|supplier|external|unknown');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root‑Cause Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Severity Level');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|major|minor|warning|info');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `total_inspected_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Inspected Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` SET TAGS ('dbx_subdomain' = 'analytics_governance');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `spend_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `spend_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `spend_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `spend_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `accounting_date` SET TAGS ('dbx_business_glossary_term' = 'Accounting Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `commodity_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger Account');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `is_blocked` SET TAGS ('dbx_business_glossary_term' = 'Is Blocked');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `is_service_line` SET TAGS ('dbx_business_glossary_term' = 'Is Service Line');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `is_tax_included` SET TAGS ('dbx_business_glossary_term' = 'Is Tax Included');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `project_code` SET TAGS ('dbx_business_glossary_term' = 'Project Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `source_system_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Source System Load Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `spend_category` SET TAGS ('dbx_business_glossary_term' = 'Spend Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `spend_category` SET TAGS ('dbx_value_regex' = 'direct|indirect|capex|mro');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `spend_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Spend Subcategory');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Transaction Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_value_regex' = 'posted|pending|cancelled|reversed|draft|approved');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `transaction_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Transaction Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` SET TAGS ('dbx_subdomain' = 'analytics_governance');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_initiative_id` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `actual_savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Savings Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By (Employee ID)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `baseline_spend` SET TAGS ('dbx_business_glossary_term' = 'Baseline Spend (USD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `commodity` SET TAGS ('dbx_business_glossary_term' = 'Commodity');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_name` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_number` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_type` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_type` SET TAGS ('dbx_value_regex' = 'hard_savings|cost_avoidance|payment_term_improvement|process_improvement');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Initiative Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `program_year` SET TAGS ('dbx_business_glossary_term' = 'Program Year');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code (ISO 3166‑3)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_initiative_status` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_initiative_status` SET TAGS ('dbx_value_regex' = 'identified|approved|in_negotiation|realized|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_validation_method` SET TAGS ('dbx_business_glossary_term' = 'Savings Validation Method');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `savings_validation_method` SET TAGS ('dbx_value_regex' = 'internal_audit|external_audit|financial_system|management_review');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `target_savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Target Savings Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `payment_run_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Run ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Approved By');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Batch ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Comments');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `currency_rate` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `payment_run_description` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `discount_taken_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Taken Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `execution_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Execution End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `execution_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Execution Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Fee Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `is_automated` SET TAGS ('dbx_business_glossary_term' = 'Is Automated Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `number_of_invoices` SET TAGS ('dbx_business_glossary_term' = 'Number of Invoices');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'ACH|wire|check|virtual_card|direct_deposit');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `processing_time_seconds` SET TAGS ('dbx_business_glossary_term' = 'Processing Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `reference` SET TAGS ('dbx_business_glossary_term' = 'External Payment Run Reference');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `run_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `run_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `run_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `run_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `run_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `run_type` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `run_type` SET TAGS ('dbx_value_regex' = 'regular|ad_hoc|correction');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'pending|settled|failed');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `status_reason` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Status Reason');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Payment Run Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `total_discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `total_discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Total Discount Percent');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `total_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `total_invoices_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Invoices Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `total_net_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `parent_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Vendor Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `parent_vendor_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1 (AL1)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2 (AL2)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number (BAN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `bank_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Name (BN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City (CTY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `commodity_specialization` SET TAGS ('dbx_business_glossary_term' = 'Commodity Specialization (COMMOD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (CC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit (CL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `credit_limit` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CCY)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'DUNS Number (DUNS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `duns_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `duns_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EED)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (ESD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `iatf16949_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'IATF 16949 Certification Expiry (IATF_EXP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `iatf16949_certified` SET TAGS ('dbx_business_glossary_term' = 'IATF 16949 Certified (IATF)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms (IC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `iso14001_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Certification Expiry (ISO14001_EXP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `iso14001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Certified (ISO14001)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `iso9001_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certification Expiry (ISO9001_EXP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `iso9001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certified (ISO9001)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (LT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `legal_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Legal Name (VLN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `max_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity (MAXQ)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name (VN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes (NOTE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Date (OBD)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (PT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code (PC)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `preferred_language` SET TAGS ('dbx_business_glossary_term' = 'Preferred Language (PL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email (PCE)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name (PCN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone (PCP)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9]{7,15}$');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State/Province (ST)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `supplier_category` SET TAGS ('dbx_business_glossary_term' = 'Supplier Category (SCAT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `supplier_category` SET TAGS ('dbx_value_regex' = 'raw_material|components|services|logistics|software|other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `swift_code` SET TAGS ('dbx_business_glossary_term' = 'SWIFT/BIC Code (SWIFT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `swift_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `swift_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `tax_exempt_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Exempt Flag (TEF)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number (TIN)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vat_number` SET TAGS ('dbx_business_glossary_term' = 'VAT Registration Number (VAT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vat_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vat_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_status` SET TAGS ('dbx_business_glossary_term' = 'Vendor Status (VS)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending|terminated');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_type` SET TAGS ('dbx_business_glossary_term' = 'Vendor Type (VT)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_type` SET TAGS ('dbx_value_regex' = 'OEM|Tier1|Tier2|Distributor|ServiceProvider|Other');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`vendor` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Website URL (URL)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` SET TAGS ('dbx_association_edges' = 'engineering.vehicle_program,procurement.supplier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `program_supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Programsuppliercontract - Program Supplier Contract Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Programsuppliercontract - Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Programsuppliercontract - Vehicle Program Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ALTER COLUMN `price_escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Price Escalation Clause');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` SET TAGS ('dbx_association_edges' = 'procurement.supplier,asset.spare_parts_catalog');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement - Supply Agreement Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement - Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement - Spare Parts Catalog Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` SET TAGS ('dbx_association_edges' = 'procurement.supplier,compliance.regulatory_requirement');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ALTER COLUMN `supplier_regulatory_compliance_id` SET TAGS ('dbx_business_glossary_term' = 'Supplierregulatorycompliance - Supplier Regulatory Compliance Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplierregulatorycompliance - Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Supplierregulatorycompliance - Regulatory Requirement Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ALTER COLUMN `compliance_deadline` SET TAGS ('dbx_business_glossary_term' = 'Compliance Deadline');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ALTER COLUMN `evidence_document_path` SET TAGS ('dbx_business_glossary_term' = 'Evidence Document');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` SET TAGS ('dbx_subdomain' = 'analytics_governance');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `procurement_document_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Document Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `predecessor_procurement_document_id` SET TAGS ('dbx_business_glossary_term' = 'Predecessor Procurement Document Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `predecessor_procurement_document_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `engineering_document_id` SET TAGS ('dbx_ssot_reference' = 'engineering.engineering_document.engineering_document_id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `contract_term_months` SET TAGS ('dbx_business_glossary_term' = 'Contract Term Months');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `procurement_document_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `discount_rate` SET TAGS ('dbx_business_glossary_term' = 'Discount Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Document Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `document_status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `document_version` SET TAGS ('dbx_business_glossary_term' = 'Document Version');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `file_checksum` SET TAGS ('dbx_business_glossary_term' = 'File Checksum');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `file_path` SET TAGS ('dbx_business_glossary_term' = 'File Path');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `procurement_category` SET TAGS ('dbx_business_glossary_term' = 'Procurement Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `received_date` SET TAGS ('dbx_business_glossary_term' = 'Received Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewal Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `renewal_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period Days');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `retention_period_days` SET TAGS ('dbx_business_glossary_term' = 'Retention Period Days');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `signed_by` SET TAGS ('dbx_business_glossary_term' = 'Signed By');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `signed_by` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `signed_by` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Signed Date');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `total_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` SET TAGS ('dbx_subdomain' = 'analytics_governance');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_group_id` SET TAGS ('dbx_business_glossary_term' = 'Approval Group Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `parent_approval_group_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Approval Group Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `parent_approval_group_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_threshold_amount` SET TAGS ('dbx_business_glossary_term' = 'Approval Threshold Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_group_code` SET TAGS ('dbx_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Department');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_group_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `escalation_policy` SET TAGS ('dbx_business_glossary_term' = 'Escalation Policy');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `is_system_defined` SET TAGS ('dbx_business_glossary_term' = 'Is System Defined');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `max_approvers` SET TAGS ('dbx_business_glossary_term' = 'Max Approvers');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_group_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Region');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `requires_multi_approval` SET TAGS ('dbx_business_glossary_term' = 'Requires Multi Approval');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_group_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `approval_group_type` SET TAGS ('dbx_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approval_group` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` SET TAGS ('dbx_subdomain' = 'analytics_governance');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `auto_approval_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Auto Approval Rule Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `superseded_auto_approval_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Auto Approval Rule Id');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `superseded_auto_approval_rule_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `applies_to_purchase_category` SET TAGS ('dbx_business_glossary_term' = 'Applies To Purchase Category');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `applies_to_supplier_segment` SET TAGS ('dbx_business_glossary_term' = 'Applies To Supplier Segment');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `auto_approval_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `escalation_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Escalation Time Hours');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `execution_count` SET TAGS ('dbx_business_glossary_term' = 'Execution Count');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `last_executed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Executed Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Priority');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_business_glossary_term' = 'Rule Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `rule_name` SET TAGS ('dbx_business_glossary_term' = 'Rule Name');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_business_glossary_term' = 'Rule Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `auto_approval_rule_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Threshold Value');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` SET TAGS ('dbx_subdomain' = 'order_processing');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Approval ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approval_group_id` SET TAGS ('dbx_business_glossary_term' = 'Approval Group ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `auto_approval_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Auto-Approval Rule ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Delegated To ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_approval_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_approval_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_approval_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_delegated_to_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Delegated To ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_delegated_to_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_delegated_to_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_document_id` SET TAGS ('dbx_business_glossary_term' = 'Document Identifier');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `procurement_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approval_action` SET TAGS ('dbx_business_glossary_term' = 'Approval Action');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approval_action` SET TAGS ('dbx_value_regex' = 'approved|rejected|escalated|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approval_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Number');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Spend Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approver_role` SET TAGS ('dbx_business_glossary_term' = 'Approver Role');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `approver_role` SET TAGS ('dbx_value_regex' = 'procurement_manager|finance|legal|executive|operations|supply_chain');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `attachment_flag` SET TAGS ('dbx_business_glossary_term' = 'Attachment Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `attachment_url` SET TAGS ('dbx_business_glossary_term' = 'Attachment URL');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Approval Comments');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Required Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirements');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `deadline` SET TAGS ('dbx_business_glossary_term' = 'Approval Deadline');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `decision_reason` SET TAGS ('dbx_business_glossary_term' = 'Decision Reason');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `delegation_flag` SET TAGS ('dbx_business_glossary_term' = 'Delegation Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'requisition|purchase_order|contract|capex');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_business_glossary_term' = 'Escalation Reason');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `expiration_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Expiration Timestamp');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `is_auto_approved` SET TAGS ('dbx_business_glossary_term' = 'Auto-Approved Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Approval Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `is_final_approval` SET TAGS ('dbx_business_glossary_term' = 'Final Approval Flag');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `policy_code` SET TAGS ('dbx_business_glossary_term' = 'Approval Policy Code');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `policy_version` SET TAGS ('dbx_business_glossary_term' = 'Approval Policy Version');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `risk_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Score');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Requested Spend Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `step_sequence` SET TAGS ('dbx_business_glossary_term' = 'Approval Step Sequence');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `threshold_amount` SET TAGS ('dbx_business_glossary_term' = 'Approval Threshold Amount');
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
