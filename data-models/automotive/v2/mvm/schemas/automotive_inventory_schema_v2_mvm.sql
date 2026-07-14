-- Schema for Domain: inventory | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:40

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`inventory` COMMENT 'Inventory management for raw materials, components, WIP (Work in Progress), finished goods, and service parts across plants, warehouses, and dealer networks. Manages stock levels, inventory movements, cycle counting, MRP (Material Requirements Planning) execution, and SKU master data. Tracks inventory accuracy, turnover rates, obsolescence, and safety stock levels. Includes warehouse management (SAP WM), lot traceability, and serialized inventory for high-value components (ECU, batteries).';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`sku_master` (
    `sku_master_id` BIGINT COMMENT 'Unique surrogate key for each SKU master record.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Required for traceability report linking engineering part definitions to inventory SKUs for production planning and cost tracking.',
    `country_of_origin` STRING COMMENT 'ISO 3166‑1 alpha‑3 code of the country where the SKU was manufactured.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the SKU master record was created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for price fields.. Valid values are `^[A-Z]{3}$`',
    `customs_tariff_code` STRING COMMENT 'HS or tariff code used for import/export compliance.',
    `sku_master_description` STRING COMMENT 'Detailed textual description of the SKU, including functional characteristics.',
    `ean13` STRING COMMENT '13‑digit European Article Number for the SKU.. Valid values are `^d{13}$`',
    `effective_from` DATE COMMENT 'Date from which the SKU definition is valid.',
    `effective_until` DATE COMMENT 'Date until which the SKU definition remains valid; null if indefinite.',
    `expiration_date` DATE COMMENT 'Date after which the SKU is considered expired.',
    `hazardous_class` STRING COMMENT 'Regulatory hazard class (e.g., Class 1, Class 2) for the SKU.',
    `hazardous_flag` BOOLEAN COMMENT 'Indicates whether the SKU is classified as hazardous under regulatory standards.',
    `height_cm` DECIMAL(18,2) COMMENT 'Height dimension of the SKU in centimeters.',
    `last_price` DECIMAL(18,2) COMMENT 'Most recent purchase price recorded for the SKU.',
    `lead_time_days` STRING COMMENT 'Planned number of days from order to receipt of the SKU.',
    `length_cm` DECIMAL(18,2) COMMENT 'Length dimension of the SKU in centimeters.',
    `lot_controlled_flag` BOOLEAN COMMENT 'True if inventory of the SKU is managed by lot numbers.',
    `material_group` STRING COMMENT 'Grouping used for reporting and analysis of similar SKUs.',
    `material_type` STRING COMMENT 'Technical classification of the SKU (e.g., RAW, HALB, FERT).',
    `max_order_qty` DECIMAL(18,2) COMMENT 'Largest quantity that can be ordered in a single transaction.',
    `min_order_qty` DECIMAL(18,2) COMMENT 'Smallest quantity that can be ordered for the SKU.',
    `mrp_controller` STRING COMMENT 'Responsible planner or group for the SKUs MRP.',
    `mrp_type` STRING COMMENT 'Material Requirements Planning type that controls how the SKU is planned.. Valid values are `PD|VB|FO|... `',
    `procurement_type` STRING COMMENT 'Indicates whether the SKU is externally procured (E), internally produced (I), or mixed (M).. Valid values are `E|I|M`',
    `product_category` STRING COMMENT 'High‑level classification of the SKU (e.g., Engine, Body, Electrical).',
    `product_subcategory` STRING COMMENT 'Secondary classification within the product category.',
    `reorder_point_qty` DECIMAL(18,2) COMMENT 'Inventory level that triggers a replenishment order.',
    `safety_stock_qty` DECIMAL(18,2) COMMENT 'Minimum inventory level to protect against demand variability.',
    `serial_controlled_flag` BOOLEAN COMMENT 'True if each unit of the SKU is tracked by a unique serial number.',
    `shelf_life_days` STRING COMMENT 'Maximum number of days the SKU can be stored before it expires.',
    `sku_code` STRING COMMENT 'Business identifier used across the enterprise to reference the SKU.',
    `sku_master_status` STRING COMMENT 'Current lifecycle status of the SKU.. Valid values are `active|inactive|discontinued|pending`',
    `sku_name` STRING COMMENT 'Human‑readable name or title of the SKU.',
    `standard_price` DECIMAL(18,2) COMMENT 'Default price used for cost calculations and standard costing.',
    `tax_indicator` BOOLEAN COMMENT 'True if the SKU is subject to tax.',
    `unit_of_measure` STRING COMMENT 'Standard unit used for inventory transactions of the SKU.. Valid values are `EA|KG|L|M|CM|MM`',
    `upc` STRING COMMENT '12‑digit Universal Product Code for the SKU.. Valid values are `^d{12}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the SKU master record.',
    `valuation_class` STRING COMMENT 'Key used for accounting valuation of the SKU.',
    `volume_m3` DECIMAL(18,2) COMMENT 'Physical volume occupied by one unit of the SKU.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Net weight of a single unit of the SKU in kilograms.',
    `width_cm` DECIMAL(18,2) COMMENT 'Width dimension of the SKU in centimeters.',
    CONSTRAINT pk_sku_master PRIMARY KEY(`sku_master_id`)
) COMMENT 'SSOT for all Stock Keeping Unit (SKU) definitions across the enterprise. Owns the material master record for raw materials, production components, WIP sub-assemblies, finished vehicles, and service parts. Aligned with SAP MM material master (MARA/MARC). Captures SKU identity, classification, unit of measure, weight/dimensions, hazardous material flags, shelf-life, and MRP planning parameters. Referenced by all inventory movement and stock transactions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`storage_location` (
    `storage_location_id` BIGINT COMMENT 'Unique surrogate key for the storage location.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Safety audit reports require a location manager; linking storage_location to employee enables tracking responsible employee for each location.',
    `plant_id` BIGINT COMMENT 'Identifier of the plant to which the location belongs.',
    `warehouse_id` BIGINT COMMENT 'Identifier of the warehouse or distribution center containing the location.',
    `address_line1` STRING COMMENT 'Primary street address of the location.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, building).',
    `agv_routing_priority` STRING COMMENT 'Priority used by automated guided vehicles when selecting this location.',
    `aisle` STRING COMMENT 'Aisle designation within the zone.',
    `bin` STRING COMMENT 'Specific bin or shelf code for inventory placement.',
    `capacity_quantity` DECIMAL(18,2) COMMENT 'Maximum amount of material the location can hold.',
    `capacity_uom` STRING COMMENT 'Unit of measure for capacity (e.g., kg, m3, units).',
    `city` STRING COMMENT 'City where the location is situated.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code of the location.. Valid values are `USA|CAN|MEX|DEU|FRA|GBR`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was first created in the system.',
    `storage_location_description` STRING COMMENT 'Free‑form description or notes about the location.',
    `effective_from` DATE COMMENT 'Date when the location became active for inventory.',
    `effective_until` DATE COMMENT 'Date when the location is scheduled to be retired (null if indefinite).',
    `external_system_source` STRING COMMENT 'Source system that provides the master data for this location.. Valid values are `SAP_WM|Oracle_WMS|Custom`',
    `fire_safety_rating` STRING COMMENT 'Fire‑safety classification of the location.. Valid values are `A|B|C|D`',
    `hazardous_material_allowed` BOOLEAN COMMENT 'True if hazardous parts may be stored in this location.',
    `inventory_accuracy_percent` DECIMAL(18,2) COMMENT 'Measured accuracy of inventory records for this location.',
    `is_default_location` BOOLEAN COMMENT 'Indicates if this is the default location for new stock of its type.',
    `last_inventory_count_date` DATE COMMENT 'Date of the most recent physical inventory count.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude of the location.',
    `location_code` STRING COMMENT 'External code used in ERP/WMS to identify the location.',
    `location_name` STRING COMMENT 'Human‑readable name of the storage location.',
    `location_type` STRING COMMENT 'Category describing the physical storage configuration.. Valid values are `bulk|rack|floor|cold_chain|automated|quarantine`',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude of the location.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the location.',
    `rack` STRING COMMENT 'Rack identifier where the bin is located.',
    `state` STRING COMMENT 'State or province of the location.',
    `storage_location_status` STRING COMMENT 'Current operational status of the location.. Valid values are `active|inactive|maintenance|closed`',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether the location is climate‑controlled.',
    `temperature_range_celsius` STRING COMMENT 'Allowed temperature range for the location (e.g., "0-5").',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `used_capacity_percentage` DECIMAL(18,2) COMMENT 'Current utilization of the location expressed as a percentage of total capacity.',
    `zone` STRING COMMENT 'Logical zone within the warehouse (e.g., receiving, bulk, cold).',
    CONSTRAINT pk_storage_location PRIMARY KEY(`storage_location_id`)
) COMMENT 'Master record for all physical and logical storage locations within plants, warehouses, distribution centers, and dealer parts depots. Captures location hierarchy (plant → warehouse → storage type → storage bin), location type (bulk, rack, floor, cold-chain), capacity constraints, and WM (Warehouse Management) configuration. Aligned with SAP WM storage location and bin master. Enables precise bin-level inventory tracking and AGV routing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` (
    `stock_balance_id` BIGINT COMMENT 'System-generated unique identifier for each stock balance record.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: stock_balance records inventory per SKU; linking to sku_master provides authoritative SKU attributes and removes redundant material_number.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: stock_balance also references a storage location; adding storage_location_id FK normalizes location data.',
    `batch_number` STRING COMMENT 'Identifier of the production batch when batch management is active.',
    `blocked_stock_qty` BIGINT COMMENT 'Quantity that is blocked due to quality or administrative reasons.',
    `consignment_stock_qty` BIGINT COMMENT 'Quantity owned by a supplier but stored at the plant.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the valuation price.. Valid values are `USD|EUR|JPY|CNY|GBP|CHF`',
    `expiration_date` DATE COMMENT 'Date after which the material is considered expired or unusable.',
    `goods_movement_type` STRING COMMENT 'SAP movement type code indicating the nature of the transaction (e.g., receipt, issue, transfer).. Valid values are `101|102|201|202|301|311`',
    `in_transit_stock_qty` BIGINT COMMENT 'Quantity that is currently being transferred between locations.',
    `is_serialized` BOOLEAN COMMENT 'Indicates whether the material is managed at the serial number level.',
    `last_movement_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent goods movement affecting this stock record.',
    `lifecycle_status` STRING COMMENT 'Current status of the stock quantity (e.g., unrestricted, blocked).. Valid values are `unrestricted|quality_inspection|blocked|consignment|in_transit|safety`',
    `lot_number` STRING COMMENT 'Lot identifier for traceability of the material.',
    `manufacturing_date` DATE COMMENT 'Date the material was produced or assembled.',
    `physical_location_hierarchy` STRING COMMENT 'Concatenated path representing plant, warehouse, aisle, and bin (e.g., PL01/WH02/AIS03/BIN04).',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant or site where the stock is held.',
    `purchase_order_number` STRING COMMENT 'Most recent purchase order that affected the stock balance.',
    `quality_inspection_stock_qty` BIGINT COMMENT 'Quantity currently under quality inspection.',
    `quality_status` STRING COMMENT 'Result of the latest quality inspection for the stock batch.. Valid values are `passed|failed|pending`',
    `quantity_on_hand` BIGINT COMMENT 'Total physical quantity of the material available at the location.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the stock balance record was first created in the data lake.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the stock balance record.',
    `safety_stock_qty` BIGINT COMMENT 'Reserved quantity to protect against demand variability.',
    `serial_number` STRING COMMENT 'Serial number of the individual unit when serialization is enabled.',
    `stock_category` STRING COMMENT 'Broad classification of the stock for reporting (e.g., raw material, finished good).. Valid values are `raw_material|component|finished_good|service_part|spare_part`',
    `supplier_code` STRING COMMENT 'Code of the primary supplier for the material.',
    `unit_of_measure` STRING COMMENT 'Unit in which the stock quantity is measured (e.g., EA, KG, L).',
    `unrestricted_stock_qty` BIGINT COMMENT 'Quantity that is free for use or sale.',
    `valuation_area_code` STRING COMMENT 'Accounting valuation area for inventory valuation purposes.',
    `valuation_price` DECIMAL(18,2) COMMENT 'Monetary value per unit for the material based on the valuation type.',
    `valuation_type` STRING COMMENT 'Method used for inventory valuation.. Valid values are `standard|moving_average|fifo|lifo`',
    CONSTRAINT pk_stock_balance PRIMARY KEY(`stock_balance_id`)
) COMMENT 'Current on-hand stock balance snapshot for each SKU at each storage location, plant, and valuation area. Captures unrestricted stock, quality inspection stock, blocked stock, consignment stock, in-transit stock, and safety stock levels. Aligned with SAP MM stock overview (MMBE / MARD). Supports MRP execution, inventory turnover analysis, and obsolescence monitoring. Updated by every goods movement transaction.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` (
    `goods_movement_id` BIGINT COMMENT 'Unique identifier for each goods movement transaction.',
    `dealer_repair_order_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_repair_order. Business justification: Parts consumption tracking in aftersales: goods movements for parts issued or returned against a dealer repair order must reference that repair order for warranty cost recovery, parts usage reporting,',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Goods movement postings require a cost‑center for internal cost allocation; finance cost_center is the authoritative source for reporting.',
    `party_id` BIGINT COMMENT 'Identifier of the customer for goods issue movements.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Identifier of the purchase order associated with a goods receipt.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier for goods receipt movements.',
    `reversal_of_movement_goods_movement_id` BIGINT COMMENT 'Identifier of the original goods movement that this record reverses.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.batch_record. Business justification: goods_movement tracks batch movements; linking to batch_record centralizes batch attributes.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Normalize source storage location reference; replace string with FK to storage_location',
    `stock_transfer_order_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_transfer_order. Business justification: A stock_transfer_order governs the physical movement of stock, and each physical movement event is recorded as a goods_movement. One stock transfer order can produce multiple goods movement postings (',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Goods issue postings at vehicle delivery and goods receipt for returns/trade-ins are directly tied to a vehicle_order in automotive ERP (SAP SD/MM integration). Auditors and logistics teams require th',
    `work_center_id` BIGINT COMMENT 'Identifier of the Automated Guided Vehicle that executed the movement, when applicable.',
    `amount_local` DECIMAL(18,2) COMMENT 'Value of the movement in the plants local currency.',
    `amount_usd` DECIMAL(18,2) COMMENT 'Value of the movement converted to US dollars for consolidated reporting.',
    `base_uom` STRING COMMENT 'Unit of measure associated with the quantity field.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the goods movement record was initially created.',
    `currency` STRING COMMENT 'Three‑letter ISO currency code for monetary values.',
    `delivery_note_number` STRING COMMENT 'Delivery document number for goods issue movements.',
    `destination_plant` STRING COMMENT 'Plant receiving the material.',
    `destination_storage_location` STRING COMMENT 'Storage location in the destination plant where the material is placed.',
    `goods_movement_status` STRING COMMENT 'Current status of the goods movement record.. Valid values are `posted|reversed|pending`',
    `inspection_document_number` STRING COMMENT 'Identifier of the quality inspection document associated with the movement.',
    `is_automated` BOOLEAN COMMENT 'True if the movement was performed automatically by a system (e.g., AGV).',
    `is_lot_tracked` BOOLEAN COMMENT 'True if the material is tracked by lot.',
    `is_serial_tracked` BOOLEAN COMMENT 'True if the material is tracked by serial number.',
    `line_sequence` STRING COMMENT 'Ordering number of this line within the goods movement document.',
    `location_zone` STRING COMMENT 'Specific zone or area within the warehouse for the storage location.',
    `lot_number` STRING COMMENT 'Lot number used for traceability of batch‑controlled items.',
    `movement_reason` STRING COMMENT 'Business reason prompting the inventory movement.. Valid values are `Production|Sales|Repair|Scrap|Transfer`',
    `posting_date` DATE COMMENT 'Calendar date on which the goods movement was posted.',
    `posting_timestamp` TIMESTAMP COMMENT 'Exact date and time when the movement was posted.',
    `quality_inspection_status` STRING COMMENT 'Outcome of any quality inspection linked to the movement.. Valid values are `passed|failed|not_required`',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of material moved, expressed in the base unit of measure.',
    `reversal_indicator` BOOLEAN COMMENT 'True if this record represents a reversal of a previous movement.',
    `source_plant` STRING COMMENT 'Plant where the material originated.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the record.',
    `valuation_type` STRING COMMENT 'Inventory valuation method used for this movement.. Valid values are `Standard|MovingAverage|FIFO|LIFO`',
    `warehouse_number` STRING COMMENT 'Identifier of the warehouse where the movement occurs.',
    CONSTRAINT pk_goods_movement PRIMARY KEY(`goods_movement_id`)
) COMMENT 'Transactional record of every inventory movement event including goods receipts (GR), goods issues (GI), stock transfers, returns, and scrapping. Aligned with SAP MM material document (MSEG/MKPF). Captures movement type, quantity, source and destination storage locations, reference document (purchase order, production order, delivery), posting date, and batch/serial number. Provides full audit trail for lot traceability and IATF 16949 compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` (
    `stock_transfer_order_id` BIGINT COMMENT 'Unique identifier for the stock transfer order.',
    `dealership_id` BIGINT COMMENT 'Employee responsible for picking the material.',
    `plant_id` BIGINT COMMENT 'Identifier of the plant receiving the stock.',
    `parts_order_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_parts_order. Business justification: When a dealer submits an aftersales parts order, a stock transfer order is created to move parts from central warehouse to the service center. This named fulfillment process (dealer parts replenishmen',
    `replenishment_order_id` BIGINT COMMENT 'Foreign key linking to inventory.replenishment_order. Business justification: A replenishment_order triggers the physical movement of stock, which is executed via a stock_transfer_order in the warehouse management system. One replenishment order can generate one or more stock t',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: A stock transfer order moves a specific SKU between storage locations. sku_master is the SSOT for all SKU definitions. stock_transfer_order currently stores material_number (STRING) and material_descr',
    `source_plant_id` BIGINT COMMENT 'Identifier of the plant where stock is sourced.',
    `storage_location_id` BIGINT COMMENT 'Warehouse bin where the material will be placed.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Dealer-to-dealer or plant-to-dealer stock transfers are routinely triggered by a specific customer vehicle_order (locate-and-transfer process). Automotive allocation teams must trace which vehicle_ord',
    `warehouse_id` BIGINT COMMENT 'Warehouse bin from which the material is taken.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to manufacturing.work_center. Business justification: JIS/JIT stock transfers in automotive target specific work centers for sequenced part delivery. stock_transfer_order has is_jis and is_jit flags but no work_center FK. Linking to work_center enables l',
    `agv_code` BIGINT COMMENT 'Identifier of the AGV assigned to execute the transfer.',
    `batch_number` STRING COMMENT 'Batch identifier for the material batch being moved.',
    `confirmation_status` STRING COMMENT 'Result of the confirmation step before execution.. Valid values are `pending|confirmed|rejected`',
    `cost_amount` DECIMAL(18,2) COMMENT 'Internal cost associated with moving the stock.',
    `cost_center_code` STRING COMMENT 'Internal cost‑center responsible for the transfer expense.',
    `cost_currency` STRING COMMENT 'Three‑letter ISO currency code for the cost amount.',
    `execution_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the stock transfer was completed.',
    `execution_start_timestamp` TIMESTAMP COMMENT 'Timestamp when physical movement of stock began.',
    `handling_instructions` STRING COMMENT 'Free‑text instructions for special handling during transfer.',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the material is classified as hazardous.',
    `is_jis` BOOLEAN COMMENT 'Indicates if the transfer follows Just‑In‑Sequence sequencing.',
    `is_jit` BOOLEAN COMMENT 'Indicates if the transfer supports Just‑In‑Time replenishment.',
    `lot_number` STRING COMMENT 'Lot or batch identifier for traceability.',
    `movement_reason_code` STRING COMMENT 'Reason code explaining why the stock is being transferred.. Valid values are `stock_replenishment|production|maintenance|scrap|return|adjustment`',
    `priority` STRING COMMENT 'Business priority assigned to the transfer order.. Valid values are `low|medium|high|critical`',
    `project_number` STRING COMMENT 'Project identifier if the transfer is linked to a specific project.',
    `quantity` DECIMAL(18,2) COMMENT 'Amount of material to be moved.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the record was first captured.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `serial_number_flag` BOOLEAN COMMENT 'Indicates whether the material is tracked by serial number.',
    `special_handling_flag` BOOLEAN COMMENT 'True if any non‑standard handling procedures apply.',
    `stock_transfer_order_status` STRING COMMENT 'Current processing status of the transfer order.. Valid values are `draft|planned|released|in_progress|completed|cancelled`',
    `temperature_control_required` BOOLEAN COMMENT 'Indicates whether temperature‑controlled handling is required.',
    `transfer_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the transfer order was created in the system.',
    `transfer_order_number` STRING COMMENT 'External reference number assigned to the transfer order.',
    `transfer_type` STRING COMMENT 'Category of stock movement represented by the order.. Valid values are `plant_to_plant|plant_to_warehouse|warehouse_to_warehouse|replenishment|return|adjustment`',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the transfer quantity.. Valid values are `EA|KG|L|M|BOX|PACK`',
    CONSTRAINT pk_stock_transfer_order PRIMARY KEY(`stock_transfer_order_id`)
) COMMENT 'Warehouse Management transfer order governing the physical movement of stock between storage bins, storage types, or plants. Aligned with SAP WM transfer order (LT0A). Captures source and destination bin, transfer quantity, movement reason, AGV assignment, picker assignment, confirmation status, and execution timestamps. Supports JIT/JIS sequencing for line-side replenishment and inter-plant stock balancing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` (
    `mrp_requirement_id` BIGINT COMMENT 'System-generated unique identifier for the MRP requirement record.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: MRP requirements must identify the specific inbound part (supplier part record) as the source of supply. Replaces the denormalized text field source_of_supply with a proper FK. MRP planners use this',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: MRP requirements in automotive are generated from production plans per vehicle model. Parts planners must trace which models production schedule drives a requirement for capacity planning and supplie',
    `plant_id` BIGINT COMMENT 'Identifier of the internal planner or user who created/maintained the requirement.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the preferred supplier for the material, if known.',
    `production_schedule_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_schedule. Business justification: Production schedules drive MRP demand signals in automotive. Linking mrp_requirement to production_schedule enables schedule-driven material planning, supplier calloff generation, and capacity-materia',
    `scheduling_agreement_id` BIGINT COMMENT 'Foreign key linking to supply.scheduling_agreement. Business justification: In automotive JIT/JIS environments, MRP requirements are fulfilled via scheduling agreements rather than discrete POs. Linking mrp_requirement to scheduling_agreement enables planners to identify whic',
    `service_campaign_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_campaign. Business justification: Recall and service campaigns generate MRP requirements for specific parts at scale. Campaign-driven demand planning is a named automotive business process — planners must trace MRP requirements back t',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: MRP requirements are generated per material/SKU — the relationship between an MRP planned requirement and the SKU it covers is fundamental. mrp_requirement currently stores material_number (STRING) as',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Link MRP requirement to storage_location for proper location tracking',
    `batch_flag` BOOLEAN COMMENT 'Indicates whether the material is managed in batches.',
    `demand_source` STRING COMMENT 'Origin of the demand that generated the requirement.. Valid values are `forecast|sales_order|production|stock_transfer`',
    `exception_message` STRING COMMENT 'System-generated message describing any planning exception for the requirement.',
    `lead_time_days` STRING COMMENT 'Planned procurement or production lead time expressed in days.',
    `lot_size` DECIMAL(18,2) COMMENT 'Minimum production or procurement lot size applicable to the material.',
    `mrp_requirement_status` STRING COMMENT 'Current processing state of the requirement.. Valid values are `planned|released|cancelled|exception`',
    `planning_horizon_days` STRING COMMENT 'Number of days covered by the planning run that produced this requirement.',
    `planning_scenario` STRING COMMENT 'Planning run scenario used to generate the requirement (e.g., MPS, MRP, DRP).. Valid values are `MPS|MRP|DRP`',
    `priority_code` STRING COMMENT 'Business priority assigned to the requirement for planning urgency.. Valid values are `high|medium|low`',
    `quantity_required` DECIMAL(18,2) COMMENT 'Total quantity of the material required for the planning horizon.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the requirement record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the requirement record.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level that triggers a new procurement proposal.',
    `requirement_date` DATE COMMENT 'Date by which the material is needed to meet production schedules.',
    `requirement_number` STRING COMMENT 'Business identifier assigned to the requirement by the MRP run.. Valid values are `^[A-Z0-9]{1,20}$`',
    `requirement_type` STRING COMMENT 'Indicates whether the requirement is independent (external demand) or dependent (internal component need).. Valid values are `independent|dependent`',
    `safety_stock` DECIMAL(18,2) COMMENT 'Buffer stock maintained to protect against demand variability and supply delays.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the required quantity.. Valid values are `EA|KG|L|M`',
    CONSTRAINT pk_mrp_requirement PRIMARY KEY(`mrp_requirement_id`)
) COMMENT 'MRP (Material Requirements Planning) planned requirement record generated by SAP MRP run (MD04/MD05). Captures dependent and independent demand requirements for each SKU, planned order proposals, reorder points, lot sizes, lead times, and exception messages. Drives procurement requisitions and production orders. Supports safety stock calculation, demand smoothing, and supply gap analysis across the manufacturing network.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` (
    `finished_vehicle_stock_id` BIGINT COMMENT 'System-generated unique identifier for each finished vehicle stock record.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: Dealer allocation and order-to-delivery matching requires linking each stocked finished vehicle to its exact build configuration (trim, color, options, market). Inventory planners and sales ops use th',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Vehicle approval: link each finished VIN to its homologation record required for market entry.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Vehicle sales invoicing requires linking each finished vehicle (VIN) to its sales invoice for reconciliation of inventory and revenue.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Dealer sales assignment report tracks which sales rep is responsible for each finished vehicle allocation.',
    `powertrain_variant_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_variant. Business justification: Finished vehicle stock reporting by powertrain variant (ICE vs EV vs hybrid) is critical for dealer allocation, EV incentive tracking, and production mix analysis. The existing powertrain_type text co',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer to which the vehicle is allocated.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Finished vehicles are physically stored at specific locations (vehicle compounds, PDI centers, dealer lots, port storage areas) which are modeled as storage_location records. finished_vehicle_stock cu',
    `vehicle_allocation_id` BIGINT COMMENT 'Foreign key linking to dealer.vehicle_allocation. Business justification: OEM logistics and allocation reconciliation process: a finished vehicle stock record must trace back to the dealer allocation event that claimed it. Allocation planners and logistics teams use this li',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Allocation report requires linking each finished vehicle to the specific sales order it fulfills, enabling real‑time order fulfillment tracking.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Needed for Finished Vehicle Stock report linking each inventory vehicle to its VIN registry for warranty, recall, and regulatory compliance.',
    `aging_days` STRING COMMENT 'Number of days the vehicle has been in its current status.',
    `allocation_date` DATE COMMENT 'Date the vehicle was assigned to a dealer.',
    `batch_number` STRING COMMENT 'Internal production batch number associated with the vehicle.',
    `body_style` STRING COMMENT 'Physical body configuration (e.g., sedan, SUV, truck).',
    `color` STRING COMMENT 'Paint color of the vehicle as defined by the manufacturer.',
    `delivery_date` DATE COMMENT 'Actual date the vehicle left the plant or compound for the dealer/customer.',
    `emission_standard` STRING COMMENT 'Regulatory emission classification (e.g., Euro 6, EPA Tier 3).',
    `expected_delivery_date` DATE COMMENT 'Planned delivery date based on logistics schedule.',
    `hold_code` STRING COMMENT 'Code indicating why a vehicle is on hold (e.g., quality, finance).',
    `hold_reason` STRING COMMENT 'Free‑text explanation for the hold code.',
    `location_type` STRING COMMENT 'Category of the current location.. Valid values are `compound|yard|warehouse|dealer|in_transit`',
    `lot_number` STRING COMMENT 'Batch identifier used for traceability of the vehicle batch.',
    `msrp` DECIMAL(18,2) COMMENT 'Standard retail price set by the manufacturer for the vehicle configuration.',
    `production_date` DATE COMMENT 'Calendar date when the vehicle completed assembly (EOL).',
    `production_line` STRING COMMENT 'Specific line or bay within the plant that produced the vehicle.',
    `recall_flag` BOOLEAN COMMENT 'Indicates whether the vehicle is subject to a safety recall (true) or not (false).',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the stock record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the stock record.',
    `stock_status` STRING COMMENT 'Current lifecycle status of the vehicle within inventory.. Valid values are `in_production|pdi_pending|pdi_complete|allocated|in_transit|delivered`',
    `trim_level` STRING COMMENT 'Specific trim or equipment level of the vehicle (e.g., Sport, Limited).',
    `vin` STRING COMMENT 'Globally unique 17‑character identifier assigned to each vehicle.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `warranty_end_date` DATE COMMENT 'Date when the vehicle warranty period expires.',
    `warranty_start_date` DATE COMMENT 'Date when the vehicle warranty period begins.',
    CONSTRAINT pk_finished_vehicle_stock PRIMARY KEY(`finished_vehicle_stock_id`)
) COMMENT 'Finished vehicle inventory record tracking completed vehicles from end-of-line (EOL) through PDI (Pre-Delivery Inspection), compound storage, and dealer allocation. Captures VIN, model/trim/color configuration, plant of manufacture, current compound or yard location, stock status (in-production, PDI-pending, PDI-complete, allocated, in-transit, delivered), hold codes, and aging days. Bridges manufacturing and logistics domains for vehicle order fulfillment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` (
    `service_parts_stock_id` BIGINT COMMENT 'Unique identifier for the service parts stock record.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Service parts issuance logs the technician receiving parts; required for service cost accounting and warranty traceability.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Aftersales parts management requires knowing which vehicle model a stocked service part applies to, enabling fitment validation, supersession management, and model-specific demand forecasting. Dealers',
    `service_part_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_part. Business justification: Physical stock records for service parts must reference the aftersales part catalog to enforce warranty eligibility, supersession rules, and lifecycle status during cycle counts and parts issuance. Af',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Service parts are SKUs tracked in sku_master as the enterprise SSOT for all material definitions. service_parts_stock tracks location-specific operational inventory data (quantities, stock levels, cyc',
    `storage_location_id` BIGINT COMMENT 'Unique identifier of the warehouse or dealer location where the stock is held.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: SERVICE PARTS INVENTORY: Tying service parts to the spare‑parts catalog eliminates redundancy and supports warranty and compliance reporting.',
    `warehouse_id` BIGINT COMMENT 'FK to inventory.warehouse',
    `aisle` STRING COMMENT 'Aisle identifier within the warehouse layout.',
    `batch_number` STRING COMMENT 'Identifier for the manufacturing batch of the part.',
    `bin_number` STRING COMMENT 'Alphanumeric identifier of the storage bin or pallet location.',
    `cost_per_unit` DECIMAL(18,2) COMMENT 'Standard cost of a single unit of the part in the local currency.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency for cost values.. Valid values are `USD|EUR|JPY|CAD|GBP`',
    `cycle_count_status` STRING COMMENT 'Current status of the scheduled cycle count for the location.. Valid values are `due|overdue|completed`',
    `expiration_date` DATE COMMENT 'Date after which the part should not be used (e.g., perishable components).',
    `inventory_status` STRING COMMENT 'Overall lifecycle status of the stock record.. Valid values are `active|inactive|blocked`',
    `last_cost_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent cost update for the part.',
    `last_count_date` DATE COMMENT 'Date of the most recent physical inventory count.',
    `last_issue_date` DATE COMMENT 'Date when the most recent stock issue (dispatch) was recorded.',
    `last_receipt_date` DATE COMMENT 'Date when the most recent stock receipt was recorded.',
    `lead_time_days` STRING COMMENT 'Average number of days from order placement to receipt for this part.',
    `lot_number` STRING COMMENT 'Batch or lot identifier for traceability of the part.',
    `max_stock_level` STRING COMMENT 'Upper bound for stock to avoid over‑stocking.',
    `min_stock_level` STRING COMMENT 'Safety stock threshold below which replenishment is triggered.',
    `obsolescence_date` DATE COMMENT 'Effective date when the part becomes obsolete.',
    `obsolescence_reason` STRING COMMENT 'Reason for obsolescence (e.g., discontinued, replaced by new model).',
    `obsolescence_status` STRING COMMENT 'Indicates whether the part is active, pending obsolescence, or obsolete.. Valid values are `active|obsolete|pending`',
    `part_revision` STRING COMMENT 'Revision identifier indicating engineering change level of the part.',
    `quantity_available` STRING COMMENT 'Units available for allocation to orders (excluding reserved stock).',
    `quantity_committed` STRING COMMENT 'Units already committed to pending service orders.',
    `quantity_on_hand` STRING COMMENT 'Total number of units physically present in the location.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the stock record was initially created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the stock record.',
    `reorder_point` STRING COMMENT 'Inventory level that triggers a replenishment order.',
    `safety_stock` STRING COMMENT 'Buffer quantity kept to protect against demand variability.',
    `serial_number_flag` BOOLEAN COMMENT 'Indicates whether the part is tracked by individual serial numbers.',
    `shelf` STRING COMMENT 'Shelf identifier within the aisle for the part.',
    `supersession_part_number` STRING COMMENT 'Part number that supersedes this part in the product lifecycle.',
    `valuation_method` STRING COMMENT 'Inventory valuation method applied to the part stock.. Valid values are `standard|fifo|lifo|average`',
    `warranty_expiration_date` DATE COMMENT 'Date when the parts warranty coverage ends.',
    `warranty_status` STRING COMMENT 'Current warranty coverage status of the part.. Valid values are `in_warranty|out_of_warranty`',
    CONSTRAINT pk_service_parts_stock PRIMARY KEY(`service_parts_stock_id`)
) COMMENT 'After-sales service parts inventory record tracking spare parts and accessories across the central parts distribution center (PDC), regional warehouses, and dealer parts rooms. Captures part number, supersession chain, current stock level by location, min/max replenishment levels, fill rate, backorder quantity, and obsolescence classification. Supports dealer parts ordering, warranty repair fulfillment, and TSB (Technical Service Bulletin) parts pre-positioning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` (
    `replenishment_order_id` BIGINT COMMENT 'Unique identifier for the replenishment order.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Replenishment request workflow records the planner who initiates the order; needed for approval routing and audit trails.',
    `storage_location_id` BIGINT COMMENT 'Identifier of the consuming location (line‑side, assembly station, dealer parts room).',
    `mrp_requirement_id` BIGINT COMMENT 'Foreign key linking to inventory.mrp_requirement. Business justification: MRP requirements (generated by SAP MRP runs) are the planning trigger that creates replenishment orders. One mrp_requirement can generate one replenishment_order (or be fulfilled by an existing one). ',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Replenishment orders are budgeted and expensed against a cost center for internal cost control.',
    `primary_replenishment_storage_location_id` BIGINT COMMENT 'Identifier of the supplying storage location (warehouse, supermarket, PDC).',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier or internal source providing the material.',
    `production_schedule_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_schedule. Business justification: Automotive supplier calloffs are generated from production schedules. Linking replenishment_order to production_schedule supports calloff traceability, schedule-change impact analysis on open replenis',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: replenishment_order requests stock for a SKU; linking to sku_master centralizes SKU attributes.',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Timestamp when the replenishment was physically received at the destination.',
    `batch_number` STRING COMMENT 'Batch identifier for the replenished material.',
    `cost_per_unit` DECIMAL(18,2) COMMENT 'Standard cost of a single unit of the SKU at the time of order.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the replenishment order record was first created in the system.',
    `event_timestamp` TIMESTAMP COMMENT 'The moment the replenishment request was generated (e.g., pull signal from the shop floor).',
    `fulfillment_status` STRING COMMENT 'Current fulfillment state of the order.. Valid values are `pending|in_progress|completed|failed`',
    `is_critical` BOOLEAN COMMENT 'Indicates if the SKU is a critical component requiring priority handling.',
    `last_modified_by` STRING COMMENT 'User identifier who last modified the replenishment order record.',
    `lead_time_days` STRING COMMENT 'Planned number of days from order release to delivery.',
    `lot_number` STRING COMMENT 'Lot identifier for batch‑controlled items, if applicable.',
    `max_stock_level` STRING COMMENT 'Maximum allowable inventory level for the SKU at the source location.',
    `min_stock_level` STRING COMMENT 'Minimum desired inventory level for the SKU at the source location.',
    `notes` STRING COMMENT 'Free‑form comments or special instructions for the replenishment.',
    `order_number` STRING COMMENT 'External reference number assigned to the replenishment order.',
    `order_status` STRING COMMENT 'Current processing state of the replenishment order.. Valid values are `draft|open|released|fulfilled|cancelled`',
    `order_type` STRING COMMENT 'Methodology used to trigger the replenishment (e.g., kanban, min‑max, JIT pull, JIS sequence).. Valid values are `kanban|min_max|jit_pull|jis_sequence`',
    `priority_level` STRING COMMENT 'Business priority assigned to the order to influence fulfillment sequencing.. Valid values are `low|medium|high|critical`',
    `promised_delivery_date` DATE COMMENT 'Date promised by the supplying location for delivery.',
    `replenishment_method` STRING COMMENT 'Whether the order was generated automatically by the system or entered manually.. Valid values are `automatic|manual`',
    `requested_delivery_date` DATE COMMENT 'Date by which the consuming location expects the replenishment.',
    `requested_quantity` STRING COMMENT 'Quantity of the SKU requested for replenishment.',
    `safety_stock_quantity` STRING COMMENT 'Quantity of the SKU kept as safety stock at the source location.',
    `serial_number` STRING COMMENT 'Serial number for individually tracked high‑value components (e.g., ECUs, batteries).',
    `trigger_source` STRING COMMENT 'Origin of the trigger that generated the replenishment request.. Valid values are `production_schedule|reorder_point|manual|system`',
    `uom` STRING COMMENT 'Unit of measure for the requested quantity (e.g., each, kilogram, liter, box).. Valid values are `EA|KG|L|M|BOX`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the replenishment order record.',
    `created_by` STRING COMMENT 'User identifier who initially created the replenishment order record.',
    CONSTRAINT pk_replenishment_order PRIMARY KEY(`replenishment_order_id`)
) COMMENT 'Internal replenishment order triggering stock movement from a supplying storage location (warehouse, supermarket, PDC) to a consuming location (line-side, assembly station, dealer parts room). Captures replenishment type (kanban, min-max, JIT pull, JIS sequence), trigger source, requested SKU and quantity, source and destination locations, priority, requested delivery time, and fulfillment status. Supports lean manufacturing pull systems and dealer parts replenishment cycles.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`warehouse` (
    `warehouse_id` BIGINT COMMENT 'Primary key for warehouse',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer parts warehouse management: a warehouse record representing a dealer-owned parts facility must reference its owning dealership for network capacity planning, franchise compliance audits (parts_',
    `parent_warehouse_id` BIGINT COMMENT 'Self-referencing FK on warehouse (parent_warehouse_id)',
    `address_line1` STRING COMMENT 'First line of the warehouse street address.',
    `address_line2` STRING COMMENT 'Second line of the warehouse street address (optional).',
    `capacity_cubic_m` DECIMAL(18,2) COMMENT 'Total usable volume capacity in cubic meters.',
    `capacity_sqft` DECIMAL(18,2) COMMENT 'Total usable floor space in square feet.',
    `city` STRING COMMENT 'City where the warehouse is located.',
    `close_date` DATE COMMENT 'Date when the warehouse ceased operations (null if still active).',
    `warehouse_code` STRING COMMENT 'External code used to reference the warehouse in ERP and logistics systems.',
    `country` STRING COMMENT 'Three‑letter ISO country code where the warehouse resides.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the warehouse record was first created in the system.',
    `warehouse_description` STRING COMMENT 'Free‑form description providing additional details about the warehouse.',
    `effective_from` DATE COMMENT 'Date from which the warehouse information is considered effective.',
    `effective_until` DATE COMMENT 'Date until which the warehouse information remains effective (null for open‑ended).',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude of the warehouse (decimal degrees).',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude of the warehouse (decimal degrees).',
    `manager_email` STRING COMMENT 'Contact email address for the warehouse manager.',
    `manager_name` STRING COMMENT 'Full name of the person responsible for warehouse operations.',
    `manager_phone` STRING COMMENT 'Contact phone number for the warehouse manager.',
    `warehouse_name` STRING COMMENT 'Human‑readable name of the warehouse.',
    `open_date` DATE COMMENT 'Date when the warehouse began operations.',
    `operating_hours` STRING COMMENT 'Standard daily operating hours (e.g., 08:00-17:00).',
    `postal_code` STRING COMMENT 'Postal/ZIP code for the warehouse address.',
    `region` STRING COMMENT 'Higher‑level geographic region grouping (e.g., North America, EMEA).',
    `security_level` STRING COMMENT 'Security classification of the warehouse based on access controls and monitoring.',
    `state` STRING COMMENT 'State or province of the warehouse location.',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether the warehouse provides temperature‑controlled storage.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the warehouse record.',
    `warehouse_status` STRING COMMENT 'Current lifecycle status of the warehouse.',
    `warehouse_type` STRING COMMENT 'Category of warehouse based on its primary function.',
    `zone` STRING COMMENT 'Internal zone or area identifier within the warehouse complex.',
    CONSTRAINT pk_warehouse PRIMARY KEY(`warehouse_id`)
) COMMENT 'Master reference table for warehouse. Referenced by warehouse_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_reversal_of_movement_goods_movement_id` FOREIGN KEY (`reversal_of_movement_goods_movement_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`goods_movement`(`goods_movement_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_stock_transfer_order_id` FOREIGN KEY (`stock_transfer_order_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`stock_transfer_order`(`stock_transfer_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_replenishment_order_id` FOREIGN KEY (`replenishment_order_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`replenishment_order`(`replenishment_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_mrp_requirement_id` FOREIGN KEY (`mrp_requirement_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`mrp_requirement`(`mrp_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_primary_replenishment_storage_location_id` FOREIGN KEY (`primary_replenishment_storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ADD CONSTRAINT `fk_inventory_warehouse_parent_warehouse_id` FOREIGN KEY (`parent_warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`inventory` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`inventory` SET TAGS ('dbx_domain' = 'inventory');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` SET TAGS ('dbx_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'SKU Master Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `customs_tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_description` SET TAGS ('dbx_business_glossary_term' = 'SKU Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `ean13` SET TAGS ('dbx_business_glossary_term' = 'EAN‑13 Barcode');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `ean13` SET TAGS ('dbx_value_regex' = '^d{13}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `hazardous_class` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Class');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `hazardous_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `height_cm` SET TAGS ('dbx_business_glossary_term' = 'Height (Centimeters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `last_price` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `length_cm` SET TAGS ('dbx_business_glossary_term' = 'Length (Centimeters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `lot_controlled_flag` SET TAGS ('dbx_business_glossary_term' = 'Lot Controlled Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `material_type` SET TAGS ('dbx_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `max_order_qty` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `min_order_qty` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `mrp_controller` SET TAGS ('dbx_business_glossary_term' = 'MRP Controller');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'MRP Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `mrp_type` SET TAGS ('dbx_value_regex' = 'PD|VB|FO|...');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'E|I|M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Product Category');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `product_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Product Subcategory');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `reorder_point_qty` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `safety_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `serial_controlled_flag` SET TAGS ('dbx_business_glossary_term' = 'Serial Controlled Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_business_glossary_term' = 'Shelf Life (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_code` SET TAGS ('dbx_business_glossary_term' = 'SKU Code (Stock Keeping Unit)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_status` SET TAGS ('dbx_business_glossary_term' = 'SKU Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_name` SET TAGS ('dbx_business_glossary_term' = 'SKU Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `standard_price` SET TAGS ('dbx_business_glossary_term' = 'Standard Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `tax_indicator` SET TAGS ('dbx_business_glossary_term' = 'Tax Indicator');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|CM|MM');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'UPC Barcode');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `upc` SET TAGS ('dbx_value_regex' = '^d{12}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `valuation_class` SET TAGS ('dbx_business_glossary_term' = 'Valuation Class');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Volume (Cubic Meters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (Kilograms)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `width_cm` SET TAGS ('dbx_business_glossary_term' = 'Width (Centimeters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` SET TAGS ('dbx_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location ID (SLID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier (PID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Identifier (WID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1 (ADDR1)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2 (ADDR2)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `agv_routing_priority` SET TAGS ('dbx_business_glossary_term' = 'AGV Routing Priority (AGV_PRIO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `aisle` SET TAGS ('dbx_business_glossary_term' = 'Aisle Identifier (AISLE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `bin` SET TAGS ('dbx_business_glossary_term' = 'Bin Identifier (BIN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `capacity_quantity` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity Quantity (SCQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `capacity_quantity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `capacity_uom` SET TAGS ('dbx_business_glossary_term' = 'Capacity Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `capacity_uom` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City (CITY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO3)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = 'USA|CAN|MEX|DEU|FRA|GBR');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_description` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Description (SLD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date (EFD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date (EUD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `external_system_source` SET TAGS ('dbx_business_glossary_term' = 'External System Source (ESS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `external_system_source` SET TAGS ('dbx_value_regex' = 'SAP_WM|Oracle_WMS|Custom');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `fire_safety_rating` SET TAGS ('dbx_business_glossary_term' = 'Fire Safety Rating (FSR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `fire_safety_rating` SET TAGS ('dbx_value_regex' = 'A|B|C|D');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `hazardous_material_allowed` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Allowed Flag (HMAF)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `inventory_accuracy_percent` SET TAGS ('dbx_business_glossary_term' = 'Inventory Accuracy Percentage (IAP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `is_default_location` SET TAGS ('dbx_business_glossary_term' = 'Default Location Flag (DLF)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `last_inventory_count_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inventory Count Date (LICD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude (LAT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code (SLC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_name` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Name (SLN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Type (SLT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'bulk|rack|floor|cold_chain|automated|quarantine');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude (LON)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code (POSTAL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `rack` SET TAGS ('dbx_business_glossary_term' = 'Rack Identifier (RACK)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `state` SET TAGS ('dbx_business_glossary_term' = 'State/Province (STATE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_status` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Status (SLS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_status` SET TAGS ('dbx_value_regex' = 'active|inactive|maintenance|closed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag (TCF)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `temperature_range_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Range Celsius (TRC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `used_capacity_percentage` SET TAGS ('dbx_business_glossary_term' = 'Used Capacity Percentage (UCP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `used_capacity_percentage` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `zone` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Zone (WZ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` SET TAGS ('dbx_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `stock_balance_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Balance ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `blocked_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'Blocked Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `consignment_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'Consignment Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CHF');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `goods_movement_type` SET TAGS ('dbx_business_glossary_term' = 'Goods Movement Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `goods_movement_type` SET TAGS ('dbx_value_regex' = '101|102|201|202|301|311');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `in_transit_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'In‑Transit Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `is_serialized` SET TAGS ('dbx_business_glossary_term' = 'Is Serialized');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `last_movement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Goods Movement Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Stock Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'unrestricted|quality_inspection|blocked|consignment|in_transit|safety');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `manufacturing_date` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `physical_location_hierarchy` SET TAGS ('dbx_business_glossary_term' = 'Physical Location Hierarchy');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quality_inspection_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quality_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quality_status` SET TAGS ('dbx_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_business_glossary_term' = 'Quantity On Hand');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `safety_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `stock_category` SET TAGS ('dbx_business_glossary_term' = 'Stock Category');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `stock_category` SET TAGS ('dbx_value_regex' = 'raw_material|component|finished_good|service_part|spare_part');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `unrestricted_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'Unrestricted Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_area_code` SET TAGS ('dbx_business_glossary_term' = 'Valuation Area Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_price` SET TAGS ('dbx_business_glossary_term' = 'Valuation Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_type` SET TAGS ('dbx_business_glossary_term' = 'Valuation Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_type` SET TAGS ('dbx_value_regex' = 'standard|moving_average|fifo|lifo');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` SET TAGS ('dbx_subdomain' = 'stock_transactions');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `goods_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Movement ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `dealer_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `reversal_of_movement_goods_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Reversal Of Movement ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Source Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `stock_transfer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Transfer Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'AGV Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `amount_local` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `amount_usd` SET TAGS ('dbx_business_glossary_term' = 'USD Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `base_uom` SET TAGS ('dbx_business_glossary_term' = 'Base Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `currency` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `destination_plant` SET TAGS ('dbx_business_glossary_term' = 'Destination Plant (PLT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `destination_storage_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Storage Location (SL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `goods_movement_status` SET TAGS ('dbx_business_glossary_term' = 'Movement Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `goods_movement_status` SET TAGS ('dbx_value_regex' = 'posted|reversed|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `inspection_document_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Document Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `is_automated` SET TAGS ('dbx_business_glossary_term' = 'Automated Movement Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `is_lot_tracked` SET TAGS ('dbx_business_glossary_term' = 'Lot Tracked Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `is_serial_tracked` SET TAGS ('dbx_business_glossary_term' = 'Serial Tracked Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `line_sequence` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `location_zone` SET TAGS ('dbx_business_glossary_term' = 'Location Zone');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `movement_reason` SET TAGS ('dbx_business_glossary_term' = 'Movement Reason (Reason)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `movement_reason` SET TAGS ('dbx_value_regex' = 'Production|Sales|Repair|Scrap|Transfer');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `posting_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Posting Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_value_regex' = 'passed|failed|not_required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity (Qty)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `source_plant` SET TAGS ('dbx_business_glossary_term' = 'Source Plant (PLT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `valuation_type` SET TAGS ('dbx_business_glossary_term' = 'Valuation Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `valuation_type` SET TAGS ('dbx_value_regex' = 'Standard|MovingAverage|FIFO|LIFO');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` SET TAGS ('dbx_subdomain' = 'stock_transactions');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_transfer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Transfer Order ID (STO_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Picker Employee Identifier (PICKER_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Plant Identifier (DST_PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `parts_order_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Parts Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `replenishment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `source_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Source Plant Identifier (SRC_PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Bin Identifier (DST_BIN_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Source Bin Identifier (SRC_BIN_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `agv_code` SET TAGS ('dbx_business_glossary_term' = 'Automated Guided Vehicle Identifier (AGV_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number (BATCH_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_business_glossary_term' = 'Transfer Confirmation Status (CONFIRM_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|rejected');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Transfer Cost Amount (COST_AMT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code (COST_CENTER_CD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code (COST_CURR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `execution_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Execution End Timestamp (EXEC_END_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `execution_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Execution Start Timestamp (EXEC_START_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Handling Instructions (HANDLING_INSTR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag (IS_HAZARDOUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `is_jis` SET TAGS ('dbx_business_glossary_term' = 'Just-In-Sequence Flag (IS_JIS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `is_jit` SET TAGS ('dbx_business_glossary_term' = 'Just-In-Time Flag (IS_JIT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number (LOT_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `movement_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Movement Reason Code (MOVE_REASON_CD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `movement_reason_code` SET TAGS ('dbx_value_regex' = 'stock_replenishment|production|maintenance|scrap|return|adjustment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Transfer Priority (PRIORITY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `project_number` SET TAGS ('dbx_business_glossary_term' = 'Project Number (PROJ_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Transfer Quantity (TRANSFER_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created Timestamp (AUDIT_CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated Timestamp (AUDIT_UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_business_glossary_term' = 'Serialized Material Flag (IS_SERIALIZED)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `special_handling_flag` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Flag (IS_SPECIAL_HANDLING)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_transfer_order_status` SET TAGS ('dbx_business_glossary_term' = 'Transfer Order Status (TO_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_transfer_order_status` SET TAGS ('dbx_value_regex' = 'draft|planned|released|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Required Flag (TEMP_CTRL_REQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Transfer Order Creation Timestamp (TO_CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_order_number` SET TAGS ('dbx_business_glossary_term' = 'Transfer Order Number (TO_NUM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_type` SET TAGS ('dbx_business_glossary_term' = 'Transfer Type (TO_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_type` SET TAGS ('dbx_value_regex' = 'plant_to_plant|plant_to_warehouse|warehouse_to_warehouse|replenishment|return|adjustment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|BOX|PACK');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` SET TAGS ('dbx_subdomain' = 'stock_transactions');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `mrp_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Requirement ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Planner ID (PLNR_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID (SUPP_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `service_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Service Campaign Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `batch_flag` SET TAGS ('dbx_business_glossary_term' = 'Batch Management Flag (BATCH_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `demand_source` SET TAGS ('dbx_business_glossary_term' = 'Demand Source (DEMAND_SRC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `demand_source` SET TAGS ('dbx_value_regex' = 'forecast|sales_order|production|stock_transfer');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `exception_message` SET TAGS ('dbx_business_glossary_term' = 'Exception Message (EXC_MSG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time in Days (LT_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `lot_size` SET TAGS ('dbx_business_glossary_term' = 'Lot Size Quantity (LOT_SZ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `mrp_requirement_status` SET TAGS ('dbx_business_glossary_term' = 'Requirement Lifecycle Status (REQ_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `mrp_requirement_status` SET TAGS ('dbx_value_regex' = 'planned|released|cancelled|exception');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `planning_horizon_days` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon (PLAN_HORIZON)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_business_glossary_term' = 'Planning Scenario (PLAN_SCEN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_value_regex' = 'MPS|MRP|DRP');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `priority_code` SET TAGS ('dbx_business_glossary_term' = 'Priority Code (PRIO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `priority_code` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `quantity_required` SET TAGS ('dbx_business_glossary_term' = 'Required Quantity (QTY_REQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point Quantity (ROP_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Requirement Date (REQ_DATE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_number` SET TAGS ('dbx_business_glossary_term' = 'MRP Requirement Number (REQ_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_type` SET TAGS ('dbx_business_glossary_term' = 'Requirement Type (REQ_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_type` SET TAGS ('dbx_value_regex' = 'independent|dependent');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `safety_stock` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity (SS_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` SET TAGS ('dbx_subdomain' = 'product_inventory');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Allocation Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `aging_days` SET TAGS ('dbx_business_glossary_term' = 'Aging Days');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `color` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `emission_standard` SET TAGS ('dbx_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `expected_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `hold_code` SET TAGS ('dbx_business_glossary_term' = 'Hold Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `hold_reason` SET TAGS ('dbx_business_glossary_term' = 'Hold Reason');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'Location Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'compound|yard|warehouse|dealer|in_transit');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `production_date` SET TAGS ('dbx_business_glossary_term' = 'Production Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `production_line` SET TAGS ('dbx_business_glossary_term' = 'Production Line');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `recall_flag` SET TAGS ('dbx_business_glossary_term' = 'Recall Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `stock_status` SET TAGS ('dbx_business_glossary_term' = 'Stock Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `stock_status` SET TAGS ('dbx_value_regex' = 'in_production|pdi_pending|pdi_complete|allocated|in_transit|delivered');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `trim_level` SET TAGS ('dbx_business_glossary_term' = 'Trim Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` SET TAGS ('dbx_subdomain' = 'product_inventory');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `service_parts_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Service Parts Stock ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Issued To Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `service_part_id` SET TAGS ('dbx_business_glossary_term' = 'Service Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Location ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `aisle` SET TAGS ('dbx_business_glossary_term' = 'Aisle');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `bin_number` SET TAGS ('dbx_business_glossary_term' = 'Bin Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `cost_per_unit` SET TAGS ('dbx_business_glossary_term' = 'Cost Per Unit');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CAD|GBP');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `cycle_count_status` SET TAGS ('dbx_business_glossary_term' = 'Cycle Count Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `cycle_count_status` SET TAGS ('dbx_value_regex' = 'due|overdue|completed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `inventory_status` SET TAGS ('dbx_business_glossary_term' = 'Inventory Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `inventory_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_cost_update_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Cost Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_count_date` SET TAGS ('dbx_business_glossary_term' = 'Last Count Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Last Issue Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Last Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `max_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stock Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `min_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Minimum Stock Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_date` SET TAGS ('dbx_business_glossary_term' = 'Obsolescence Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_reason` SET TAGS ('dbx_business_glossary_term' = 'Obsolescence Reason');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_status` SET TAGS ('dbx_business_glossary_term' = 'Obsolescence Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_status` SET TAGS ('dbx_value_regex' = 'active|obsolete|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `quantity_available` SET TAGS ('dbx_business_glossary_term' = 'Quantity Available');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `quantity_committed` SET TAGS ('dbx_business_glossary_term' = 'Quantity Committed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_business_glossary_term' = 'Quantity On Hand');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `safety_stock` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_business_glossary_term' = 'Serial Number Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `shelf` SET TAGS ('dbx_business_glossary_term' = 'Shelf');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `supersession_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supersession Part Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `valuation_method` SET TAGS ('dbx_business_glossary_term' = 'Valuation Method');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `valuation_method` SET TAGS ('dbx_value_regex' = 'standard|fifo|lifo|average');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warranty_status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warranty_status` SET TAGS ('dbx_value_regex' = 'in_warranty|out_of_warranty');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` SET TAGS ('dbx_subdomain' = 'stock_transactions');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `replenishment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order ID (ROID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Requested By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Storage Location Identifier (DSLI)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `mrp_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Mrp Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `primary_replenishment_storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Source Storage Location Identifier (SSLI)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier (SUP_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp (ADT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number (BN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `cost_per_unit` SET TAGS ('dbx_business_glossary_term' = 'Cost Per Unit (CPU)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Request Timestamp (RRT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `fulfillment_status` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Status (FS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `fulfillment_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|failed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Part Indicator (CPI)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By User (RLMU)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time in Days (LTD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `lot_number` SET TAGS ('dbx_business_glossary_term' = 'Lot Number (LOT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `max_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stock Level (XSL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `min_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Minimum Stock Level (MSL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes (NOTE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order Number (RON)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order Status (ROS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'draft|open|released|fulfilled|cancelled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order Type (ROT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'kanban|min_max|jit_pull|jis_sequence');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Priority Level (RPL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Promised Delivery Date (PDD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `replenishment_method` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Method (RM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `replenishment_method` SET TAGS ('dbx_value_regex' = 'automatic|manual');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date (RDD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `requested_quantity` SET TAGS ('dbx_business_glossary_term' = 'Requested Quantity (RQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity (SSQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number (SN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `trigger_source` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Trigger Source (RTS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `trigger_source` SET TAGS ('dbx_value_regex' = 'production_schedule|reorder_point|manual|system');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `uom` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `uom` SET TAGS ('dbx_value_regex' = 'EA|KG|L|M|BOX');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User (RCBU)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` SET TAGS ('dbx_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `parent_warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Warehouse Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `parent_warehouse_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `capacity_cubic_m` SET TAGS ('dbx_business_glossary_term' = 'Capacity Cubic M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `capacity_cubic_m` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `capacity_sqft` SET TAGS ('dbx_business_glossary_term' = 'Capacity Sqft');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `capacity_sqft` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Close Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_code` SET TAGS ('dbx_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `country` SET TAGS ('dbx_business_glossary_term' = 'Country');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_email` SET TAGS ('dbx_business_glossary_term' = 'Manager Email');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_name` SET TAGS ('dbx_business_glossary_term' = 'Manager Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_phone` SET TAGS ('dbx_business_glossary_term' = 'Manager Phone');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Open Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Region');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `state` SET TAGS ('dbx_business_glossary_term' = 'State');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_type` SET TAGS ('dbx_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `zone` SET TAGS ('dbx_business_glossary_term' = 'Zone');
