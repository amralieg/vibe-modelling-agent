-- Schema for Domain: supply | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:42

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`supply` COMMENT 'Governs the inbound supply chain from tier-1 and tier-2 suppliers through to plant receiving. Owns supplier master data, RFQ (Request for Quotation) events, PPAP (Production Part Approval Process) records, JIT/JIS delivery schedules, inbound logistics, supplier performance metrics (PPM - Parts Per Million defect rates, OTD - On-Time Delivery), and CKD/SKD kit management for global assembly operations. Integrates with SAP MM and PTC Windchill.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` (
    `supply_supplier_id` BIGINT COMMENT 'Unique identifier for the supply_supplier data product (auto-inserted pre-linking).',
    `procurement_supplier_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_supplier (cross-domain duplicate reconciliation; procurement designated SSOT owner for supplier).',
    CONSTRAINT pk_supply_supplier PRIMARY KEY(`supply_supplier_id`)
) COMMENT 'Master record for all tier-1 and tier-2 suppliers in the automotive supply chain. Captures supplier identity, classification (direct/indirect, tier level), IATF 16949 certification status, DUNS number, geographic footprint, commodity codes, preferred currency, payment terms, and supplier lifecycle status (active, probation, disqualified). SSOT for supplier identity within the supply domain; integrates with SAP MM vendor master and PTC Windchill supplier collaboration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_part` (
    `inbound_part_id` BIGINT COMMENT 'System-generated unique identifier for the inbound part record.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Material receipt cost is allocated to a Cost Center for inventory valuation and variance analysis.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Receiving process matches inbound parts to SKU master to create accurate stock records; essential for inventory posting.',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Each inbound part in automotive is governed by a supplier contract defining piece price, PPAP requirements, and quality standards. Procurement teams need part-to-contract traceability for price valida',
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
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: A sourcing nomination formally records the OEM decision to nominate a supplier for a specific part. sourcing_nomination currently stores part_number as a STRING attribute. Normalizing this to inbound_',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: Sourcing nominations define supplier-to-plant supply relationships; the logistics lane (origin-destination corridor) is evaluated during sourcing decisions for freight cost estimation and carrier feas',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Automotive sourcing nominations are raised per vehicle model/program to nominate suppliers for specific commodities. Supply planners and commodity managers query nominations by vehicle model to manage',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Sourcing nominations are made at production line level — a supplier is nominated to supply a specific part for a specific line (e.g., seats for Line 2). Standard automotive SOR practice requires line-',
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
    `priority` STRING COMMENT 'Business priority assigned to the nomination for execution planning.. Valid values are `high|medium|low`',
    `program_code` STRING COMMENT 'Code identifying the vehicle program or platform associated with the nomination (e.g., SUV2025, EVX).',
    `risk_rating` STRING COMMENT 'Qualitative assessment of supply risk for the nominated part.. Valid values are `low|medium|high`',
    `sor_reference` STRING COMMENT 'Reference code linking to the SOR document that defines functional and performance requirements.',
    `target_piece_price` DECIMAL(18,2) COMMENT 'Target unit price (per piece) the OEM aims to achieve with the nominated supplier.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the nomination record.',
    CONSTRAINT pk_sourcing_nomination PRIMARY KEY(`sourcing_nomination_id`)
) COMMENT 'Records the formal OEM decision to nominate a specific supplier for a given part or commodity within a model year program. Captures nomination date, program/platform code, nominated supplier, awarded annual volume, target piece price, SOR (Statement of Requirements) reference, nomination status (nominated, confirmed, withdrawn), and the responsible commodity buyer. Precedes the RFQ and PPAP process. SSOT for sourcing award decisions; distinct from procurement domains strategic sourcing strategy — this is the operational award record.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` (
    `supply_purchase_order_id` BIGINT COMMENT 'Unique identifier for the supply_purchase_order data product (auto-inserted pre-linking).',
    `mrp_requirement_id` BIGINT COMMENT 'Foreign key linking to inventory.mrp_requirement. Business justification: Purchase orders in automotive are created to fulfill MRP requirements. Linking supply_purchase_order to mrp_requirement enables supply planners to trace demand-to-PO coverage, identify uncovered requi',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Purchase orders are tied to a specific model year program for budgeting, volume tracking, and compliance reporting.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: Supply execution POs and procurement finance POs represent the same transaction across system boundaries. Header-level reconciliation between supply chain and procurement finance systems is required f',
    `sourcing_nomination_id` BIGINT COMMENT 'Foreign key linking to supply.sourcing_nomination. Business justification: In automotive procurement, a supply purchase order is issued following a formal sourcing nomination. Linking supply_purchase_order to sourcing_nomination provides the upstream sourcing context (progra',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Supply POs in automotive are issued against a governing supplier contract for volume commitment tracking, contract spend analysis, and compliance verification. Procurement teams require PO-to-contract',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link purchase order to internal supplier master',
    CONSTRAINT pk_supply_purchase_order PRIMARY KEY(`supply_purchase_order_id`)
) COMMENT 'Legally binding procurement document issued to a supplier authorizing delivery of parts or materials at agreed price and schedule. Captures PO number, PO type (standard, blanket, scheduling agreement), supplier, plant, delivery terms (Incoterms), payment terms, total value, currency, and PO status (open, partially delivered, closed, cancelled). SSOT for purchase commitments; sourced from SAP MM (ME21N/ME22N).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` (
    `supply_po_line_id` BIGINT COMMENT 'Unique identifier for the supply_po_line data product (auto-inserted pre-linking).',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: A supply PO line represents a specific purchased part number on a purchase order. supply_po_line currently references inventory.sku_master cross-domain but has no in-domain link to inbound_part. Addin',
    `procurement_po_line_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_po_line (cross-domain duplicate reconciliation; procurement designated SSOT owner for po_line).',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Purchase order line items specify the exact SKU to be received; linking enables automatic inventory allocation.',
    `supply_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.supply_purchase_order. Business justification: Connect PO line to its purchase order within supply domain',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Link PO line to internal supplier master',
    CONSTRAINT pk_supply_po_line PRIMARY KEY(`supply_po_line_id`)
) COMMENT 'Individual line item within a purchase order representing a specific part number, quantity, unit price, delivery date, and plant destination. Captures line number, material number, ordered quantity, confirmed quantity, net price, delivery date, goods receipt quantity, and invoice quantity. Enables line-level tracking of delivery performance and invoice matching (3-way match) in SAP MM.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` (
    `delivery_schedule_id` BIGINT COMMENT 'Unique identifier for the supply_delivery_schedule data product (auto-inserted pre-linking).',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: A JIT/JIS delivery schedule line specifies exact quantities and delivery windows for a specific purchased part. supply_delivery_schedule currently has no in-domain part reference. Linking to inbound_p',
    `mrp_requirement_id` BIGINT COMMENT 'Foreign key linking to inventory.mrp_requirement. Business justification: Delivery schedule call-offs in automotive are generated directly from MRP requirements. Linking supply_delivery_schedule to mrp_requirement enables supply planners to trace which MRP demand signal tri',
    `procurement_po_line_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line. Business justification: Delivery schedule releases in automotive JIT operations are tied to specific procurement PO lines for quantity confirmation, three-way match, and goods receipt posting. Automotive supply planners and ',
    `procurement_purchase_order_id` BIGINT COMMENT 'SSOT reference to procurement.procurement_delivery_schedule (cross-domain duplicate reconciliation; procurement designated SSOT owner for delivery_schedule).',
    `production_schedule_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_schedule. Business justification: JIT/JIS call-off process: supplier delivery schedules are directly driven by the manufacturing production schedule. Supply planners reconcile delivery windows against scheduled production runs to ensu',
    `scheduling_agreement_id` BIGINT COMMENT 'Foreign key linking to supply.scheduling_agreement. Business justification: Delivery schedule is issued under a scheduling agreement; linking via scheduling_agreement_id enables traceability to the agreement.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: JIT/JIS delivery schedule call-offs drive creation of logistics shipments. Linking enables OTD compliance monitoring — verifying that scheduled deliveries were executed as actual shipments — critical ',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Delivery schedule belongs to a supplier; adding supplier_id FK creates the required parent relationship and consolidates supplier reference.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: In JIT/JIS automotive manufacturing, inbound part delivery schedules are triggered by confirmed vehicle orders. This link enables demand-driven supply scheduling — production planners use vehicle_orde',
    CONSTRAINT pk_delivery_schedule PRIMARY KEY(`delivery_schedule_id`)
) COMMENT 'JIT/JIS delivery schedule line issued against a scheduling agreement, specifying exact quantities and delivery dates/times for a part to a plant dock. Captures schedule line date, time, required quantity, cumulative quantity, schedule type (firm, forecast, JIS sequence), dock door, and transmission status (sent, acknowledged, revised). Drives supplier production and logistics planning. Sourced from SAP MM schedule lines (EKET).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` (
    `supply_ppap_submission_id` BIGINT COMMENT 'Unique identifier for the supply_ppap_submission data product (auto-inserted pre-linking).',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: Control plan is one of the 18 mandatory PPAP elements per AIAG PPAP standard. The supply-side PPAP submission must reference the quality control plan submitted as part of the PPAP package. This link e',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: A PPAP submission approves a suppliers manufacturing process for a specific purchased part number. Linking supply_ppap_submission to inbound_part enables traceability from part master to its PPAP app',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: PPAP submissions in automotive are explicitly required per part per vehicle model/program before production launch. Quality and supply teams track PPAP completion status by vehicle model for SOP readi',
    `procurement_po_line_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line. Business justification: PPAP submissions in automotive are triggered by specific procurement PO lines that carry a required PPAP level (ppap_level on procurement_po_line). Linking PPAP submission to the triggering PO line en',
    `production_bom_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_bom. Business justification: PPAP submissions must be validated against a specific production BOM version under IATF 16949/APQP. The PPAP confirms the suppliers part matches the BOM specification at a specific revision level. BO',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: PPAP submissions under IATF 16949/APQP are validated against the specific production line where the part will be used. The PPAP must confirm the suppliers process meets that lines quality gates, rob',
    `sourcing_nomination_id` BIGINT COMMENT 'Foreign key linking to supply.sourcing_nomination. Business justification: In automotive supply chains, a PPAP submission is formally triggered by a sourcing nomination — the OEM nominates a supplier for a part/program, and the PPAP process follows. Linking supply_ppap_submi',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: REQUIRED: PPAP compliance dashboard requires each PPAP submission to be associated with the specific supplier contract governing the part.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: A PPAP submission is the formal approval of a suppliers manufacturing process. It must reference the in-domain supply_supplier master. Currently only procurement.procurement_supplier is linked cross-',
    CONSTRAINT pk_supply_ppap_submission PRIMARY KEY(`supply_ppap_submission_id`)
) COMMENT 'Production Part Approval Process submission record tracking the formal approval of a suppliers manufacturing process for a specific part. Captures PPAP level (1–5), submission date, part number, supplier, engineering change level, submission reason (new part, engineering change, tooling move), PPAP elements checklist status, PSW (Part Submission Warrant) status, and approval/rejection date. Integrates with PTC Windchill and SAP QM. SSOT for PPAP compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` (
    `inbound_shipment_id` BIGINT COMMENT 'System-generated unique identifier for the inbound shipment record.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: REQUIRED: Carrier performance & cost reporting uses inbound shipment data; linking enables carrier KPI aggregation.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Receiving clerk records inbound shipment receipt; required for Receiving Activity Log.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: An inbound shipment carries a specific purchased part. While sku_master_id links to the inventory domains SKU master, inbound_part_id provides the supply-domain part master reference including lead_t',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: Inbound shipments travel on defined origin-to-plant lanes. Linking enables lane-level freight cost analysis, carrier assignment validation, and inbound logistics network optimization — standard supply',
    `plant_id` BIGINT COMMENT 'Identifier of the OEM plant receiving the shipment.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Inbound shipments are directed to a specific receiving storage location (dock, receiving bay, or staging area). Logistics and receiving teams use this link for dock scheduling, receiving capacity plan',
    `scheduling_agreement_id` BIGINT COMMENT 'Foreign key linking to supply.scheduling_agreement. Business justification: JIT/JIS inbound shipments in automotive are dispatched against scheduling agreements, not individual POs. Linking inbound_shipment to scheduling_agreement enables tracking of which scheduling agreemen',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Shipment tracking per SKU is needed for logistics, ETA monitoring, and traceability of components to finished vehicles.',
    `supply_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.supply_purchase_order. Business justification: An inbound shipment is dispatched to fulfill a supply purchase order. While inbound_shipment already references procurement.procurement_purchase_order cross-domain, the in-domain link to supply_purcha',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Associate inbound shipment with internal supplier master',
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
    `goods_movement_id` BIGINT COMMENT 'Foreign key linking to inventory.goods_movement. Business justification: A supplier goods receipt triggers a goods movement posting (e.g., movement type 101 in SAP). Linking GR to goods_movement enables reconciliation of received quantities against inventory postings, supp',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_shipment. Business justification: A goods receipt is the system confirmation of an inbound shipment arriving at the OEM receiving dock. Linking supply_goods_receipt to inbound_shipment creates the critical ASN-to-GR traceability chain',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: REQUIRED: Reconciliation report links internal goods receipt record to the external goods receipt entity for variance analysis.',
    `stock_balance_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_balance. Business justification: Goods receipt posting directly creates or updates a stock balance record. Inventory controllers and auditors trace GR documents to resulting stock balance changes for discrepancy resolution, month-end',
    `supply_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.supply_purchase_order. Business justification: A goods receipt confirms physical delivery against a purchase order. supply_goods_receipt already links to procurement.procurement_purchase_order cross-domain, but lacks an in-domain FK to supply_purc',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: A goods receipt must identify the delivering supplier for receiving dock operations, quality inspection routing, and supplier performance tracking (OTD measurement). Adding supply_supplier_id to suppl',
    CONSTRAINT pk_supply_goods_receipt PRIMARY KEY(`supply_goods_receipt_id`)
) COMMENT 'Records the physical receipt and system confirmation of parts delivered by a supplier to an OEM plant. Captures GR document number, posting date, received quantity, accepted quantity, rejected quantity, storage location, batch number, GR type (standard, return, subsequent delivery), and posting status. Triggers inventory update and initiates 3-way invoice matching in SAP MM (MIGO). SSOT for inbound goods confirmation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` (
    `supplier_scorecard_id` BIGINT COMMENT 'System-generated unique identifier for each supplier scorecard record.',
    `approved_vendor_list_id` BIGINT COMMENT 'Foreign key linking to procurement.approved_vendor_list. Business justification: Scorecard results directly drive AVL status changes — preferred, backup, or removal decisions in automotive sourcing. Procurement teams run formal AVL review processes triggered by scorecard threshold',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.audit. Business justification: Supplier performance scorecards in automotive incorporate audit results as a scored dimension. Linking supplier_scorecard to the quality audit that informed the evaluation period score supports IATF 1',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - supplier scorecards are evaluated per receiving plant',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: Supplier scorecards must be traceable to the procurement supplier master for contract renewal decisions, AVL status updates, and regulatory compliance reporting. Automotive procurement teams run score',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Scorecard results directly trigger penalty clause activation, contract renegotiation, and renewal decisions defined in the supplier contract. Automotive procurement requires scorecard-to-contract trac',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` (
    `scheduling_agreement_id` BIGINT COMMENT 'System generated unique identifier for the scheduling agreement record.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: A scheduling agreement governs JIT/JIS delivery of a specific part from a supplier. scheduling_agreement currently stores part_description as a STRING. Normalizing to inbound_part_id creates a proper ',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: Scheduling agreements define recurring supply delivery rhythm over a specific supplier-to-plant corridor (lane). Linking enables freight cost modeling, carrier assignment, and logistics network design',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Scheduling agreements in automotive are long-term supply contracts negotiated per vehicle model program. Supply chain teams track agreement coverage and volume commitments by model for production plan',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Scheduling agreements in automotive are line-specific contracts — a supplier is nominated to deliver parts for a specific production line with defined delivery rhythm tied to that lines takt time. SO',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Automotive scheduling agreements (JIT/JIS delivery rhythms) are executed under a master supplier contract governing pricing, volume commitments, and penalty clauses. Procurement compliance audits and ',
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
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ADD CONSTRAINT `fk_supply_sourcing_nomination_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ADD CONSTRAINT `fk_supply_sourcing_nomination_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ADD CONSTRAINT `fk_supply_supply_purchase_order_sourcing_nomination_id` FOREIGN KEY (`sourcing_nomination_id`) REFERENCES `vibe_automotive_v1`.`supply`.`sourcing_nomination`(`sourcing_nomination_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ADD CONSTRAINT `fk_supply_supply_purchase_order_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ADD CONSTRAINT `fk_supply_supply_po_line_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ADD CONSTRAINT `fk_supply_supply_po_line_supply_purchase_order_id` FOREIGN KEY (`supply_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_purchase_order`(`supply_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ADD CONSTRAINT `fk_supply_supply_po_line_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ADD CONSTRAINT `fk_supply_delivery_schedule_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ADD CONSTRAINT `fk_supply_delivery_schedule_scheduling_agreement_id` FOREIGN KEY (`scheduling_agreement_id`) REFERENCES `vibe_automotive_v1`.`supply`.`scheduling_agreement`(`scheduling_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ADD CONSTRAINT `fk_supply_delivery_schedule_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ADD CONSTRAINT `fk_supply_supply_ppap_submission_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ADD CONSTRAINT `fk_supply_supply_ppap_submission_sourcing_nomination_id` FOREIGN KEY (`sourcing_nomination_id`) REFERENCES `vibe_automotive_v1`.`supply`.`sourcing_nomination`(`sourcing_nomination_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ADD CONSTRAINT `fk_supply_supply_ppap_submission_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_scheduling_agreement_id` FOREIGN KEY (`scheduling_agreement_id`) REFERENCES `vibe_automotive_v1`.`supply`.`scheduling_agreement`(`scheduling_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_supply_purchase_order_id` FOREIGN KEY (`supply_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_purchase_order`(`supply_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ADD CONSTRAINT `fk_supply_supply_goods_receipt_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ADD CONSTRAINT `fk_supply_supply_goods_receipt_supply_purchase_order_id` FOREIGN KEY (`supply_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_purchase_order`(`supply_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ADD CONSTRAINT `fk_supply_supply_goods_receipt_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ADD CONSTRAINT `fk_supply_scheduling_agreement_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ADD CONSTRAINT `fk_supply_scheduling_agreement_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`supply` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`supply` SET TAGS ('dbx_domain' = 'supply');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_supplier');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Nomination Priority');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Program Code');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `sor_reference` SET TAGS ('dbx_business_glossary_term' = 'Statement of Requirements Reference');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `target_piece_price` SET TAGS ('dbx_business_glossary_term' = 'Target Piece Price');
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` SET TAGS ('dbx_subdomain' = 'procurement_operations');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_purchase_order');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `mrp_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Mrp Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Model Year Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `sourcing_nomination_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Nomination Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` SET TAGS ('dbx_subdomain' = 'procurement_operations');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `supply_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_po_line');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` SET TAGS ('dbx_subdomain' = 'procurement_operations');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `delivery_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_delivery_schedule');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `mrp_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Mrp Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `procurement_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_ssot_owner' = 'procurement.procurement_delivery_schedule');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`delivery_schedule` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `supply_ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_ppap_submission');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `procurement_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Production Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `sourcing_nomination_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Nomination Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` SET TAGS ('dbx_subdomain' = 'logistics_receiving');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Plant ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` SET TAGS ('dbx_subdomain' = 'logistics_receiving');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `supply_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for supply_goods_receipt');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `goods_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Movement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `stock_balance_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Balance Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `supplier_scorecard_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Scorecard ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `approved_vendor_list_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Vendor List Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` SET TAGS ('dbx_subdomain' = 'procurement_operations');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`supply`.`scheduling_agreement` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
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
