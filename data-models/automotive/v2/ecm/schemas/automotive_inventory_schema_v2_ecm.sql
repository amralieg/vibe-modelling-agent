-- Schema for Domain: inventory | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:52

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`inventory` COMMENT 'Inventory management for raw materials, components, WIP (Work in Progress), finished goods, and service parts across plants, warehouses, and dealer networks. Manages stock levels, inventory movements, cycle counting, MRP (Material Requirements Planning) execution, and SKU master data. Tracks inventory accuracy, turnover rates, obsolescence, and safety stock levels. Includes warehouse management (SAP WM), lot traceability, and serialized inventory for high-value components (ECU, batteries).';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`sku_master` (
    `sku_master_id` BIGINT COMMENT 'Unique surrogate key for each SKU master record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Part compliance tracking: associate each SKU with its safety/EMC certification document for audits.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Required for traceability report linking engineering part definitions to inventory SKUs for production planning and cost tracking.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Product lifecycle management assigns a product owner; this FK supports owner accountability in change‑control and compliance reports.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Regulatory mapping: each part must satisfy specific regulatory requirements for reporting and certification.',
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
) COMMENT 'SSOT for all Stock Keeping Unit (SKU) definitions across the enterprise. Owns the material master record for raw materials, production components, WIP sub-assemblies, finished vehicles, and service parts. Aligned with SAP MM material master (MARA/MARC). Captures SKU identity, classification, unit of measure, weight/dimensions, hazardous material flags, shelf-life, and MRP planning parameters. Referenced by all inventory movement and stock transactions. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`storage_location` (
    `storage_location_id` BIGINT COMMENT 'Unique surrogate key for the storage location.',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_permit. Business justification: Hazardous material handling: storage locations need to be linked to the environmental permit governing emissions.',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: MAINTENANCE PLANNING: Mapping storage locations to functional locations enables maintenance schedules and OEE reports that require inventory location context.',
    `plant_id` BIGINT COMMENT 'Identifier of the plant to which the location belongs.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Safety audit reports require a location manager; linking storage_location to employee enables tracking responsible employee for each location.',
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
) COMMENT 'Master record for all physical and logical storage locations within plants, warehouses, distribution centers, and dealer parts depots. Captures location hierarchy (plant → warehouse → storage type → storage bin), location type (bulk, rack, floor, cold-chain), capacity constraints, and WM (Warehouse Management) configuration. Aligned with SAP WM storage location and bin master. Enables precise bin-level inventory tracking and AGV routing. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` (
    `stock_balance_id` BIGINT COMMENT 'System-generated unique identifier for each stock balance record.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Stock balance valuation amounts must be posted to a GL account for financial statements.',
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
) COMMENT 'Current on-hand stock balance snapshot for each SKU at each storage location, plant, and valuation area. Captures unrestricted stock, quality inspection stock, blocked stock, consignment stock, in-transit stock, and safety stock levels. Aligned with SAP MM stock overview (MMBE / MARD). Supports MRP execution, inventory turnover analysis, and obsolescence monitoring. Updated by every goods movement transaction. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` (
    `goods_movement_id` BIGINT COMMENT 'Unique identifier for each goods movement transaction.',
    `agv_movement_id` BIGINT COMMENT 'Identifier of the Automated Guided Vehicle that executed the movement, when applicable.',
    `batch_record_id` BIGINT COMMENT 'Foreign key linking to inventory.batch_record. Business justification: goods_movement tracks batch movements; linking to batch_record centralizes batch attributes.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Goods movement postings require a cost‑center for internal cost allocation; finance cost_center is the authoritative source for reporting.',
    `party_id` BIGINT COMMENT 'Identifier of the customer for goods issue movements.',
    `employee_id` BIGINT COMMENT 'Identifier of the system user who posted the movement.',
    `movement_type_id` BIGINT COMMENT 'Foreign key linking to inventory.inventory_movement_type. Business justification: Add FK to standardize movement type lookup, remove redundant free‑text column, and give inventory_movement_type an inbound reference.',
    `part_master_id` BIGINT COMMENT 'Identifier of the material or component being moved.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the system user who posted the movement.',
    `primary_party_id` BIGINT COMMENT 'Identifier of the customer for goods issue movements.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Identifier of the purchase order associated with a goods receipt.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier for goods receipt movements.',
    `production_order_id` BIGINT COMMENT 'Identifier of the production order linked to the movement.',
    `reversal_of_movement_goods_movement_id` BIGINT COMMENT 'Identifier of the original goods movement that this record reverses.',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: goods_movement may involve serialized components; linking to serialized_unit provides full component details.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Normalize source storage location reference; replace string with FK to storage_location',
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
    `reference_document_number` STRING COMMENT 'Number of the source document that triggered the movement, such as purchase order or production order.',
    `reference_document_type` STRING COMMENT 'Type of the reference document (Purchase Order, Production Order, Work Order, Delivery, Service Order).. Valid values are `PO|PR|WO|DO|SA`',
    `reversal_indicator` BOOLEAN COMMENT 'True if this record represents a reversal of a previous movement.',
    `source_plant` STRING COMMENT 'Plant where the material originated.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the record.',
    `valuation_type` STRING COMMENT 'Inventory valuation method used for this movement.. Valid values are `Standard|MovingAverage|FIFO|LIFO`',
    `warehouse_number` STRING COMMENT 'Identifier of the warehouse where the movement occurs.',
    CONSTRAINT pk_goods_movement PRIMARY KEY(`goods_movement_id`)
) COMMENT 'Transactional record of every inventory movement event including goods receipts (GR), goods issues (GI), stock transfers, returns, and scrapping. Aligned with SAP MM material document (MSEG/MKPF). Captures movement type, quantity, source and destination storage locations, reference document (purchase order, production order, delivery), posting date, and batch/serial number. Provides full audit trail for lot traceability and IATF 16949 compliance. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` (
    `stock_transfer_order_id` BIGINT COMMENT 'Unique identifier for the stock transfer order.',
    `storage_bin_id` BIGINT COMMENT 'Warehouse bin where the material will be placed.',
    `plant_id` BIGINT COMMENT 'Identifier of the plant receiving the stock.',
    `employee_id` BIGINT COMMENT 'Employee responsible for picking the material.',
    `primary_stock_employee_id` BIGINT COMMENT 'Employee responsible for picking the material.',
    `source_bin_id` BIGINT COMMENT 'Warehouse bin from which the material is taken.',
    `source_plant_id` BIGINT COMMENT 'Identifier of the plant where stock is sourced.',
    `stock_created_by_user_employee_id` BIGINT COMMENT 'User identifier of the person who created the transfer order.',
    `stock_updated_by_user_employee_id` BIGINT COMMENT 'User identifier of the last person who modified the transfer order.',
    `tertiary_stock_updated_by_user_employee_id` BIGINT COMMENT 'User identifier of the last person who modified the transfer order.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Transfer order creation is driven by a vehicle order; linking them supports the Transfer Order Planning report used in production logistics.',
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
    `material_description` STRING COMMENT 'Human‑readable description of the material.',
    `material_number` STRING COMMENT 'SAP material master number of the item being transferred.',
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
) COMMENT 'Warehouse Management transfer order governing the physical movement of stock between storage bins, storage types, or plants. Aligned with SAP WM transfer order (LT0A). Captures source and destination bin, transfer quantity, movement reason, AGV assignment, picker assignment, confirmation status, and execution timestamps. Supports JIT/JIS sequencing for line-side replenishment and inter-plant stock balancing. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` (
    `mrp_requirement_id` BIGINT COMMENT 'System-generated unique identifier for the MRP requirement record.',
    `employee_id` BIGINT COMMENT 'Identifier of the internal planner or user who created/maintained the requirement.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the internal planner or user who created/maintained the requirement.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the preferred supplier for the material, if known.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Planning under regulation: MRP calculations consider mandatory regulatory constraints for material planning.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Link MRP requirement to storage_location for proper location tracking',
    `batch_flag` BOOLEAN COMMENT 'Indicates whether the material is managed in batches.',
    `demand_source` STRING COMMENT 'Origin of the demand that generated the requirement.. Valid values are `forecast|sales_order|production|stock_transfer`',
    `exception_message` STRING COMMENT 'System-generated message describing any planning exception for the requirement.',
    `lead_time_days` STRING COMMENT 'Planned procurement or production lead time expressed in days.',
    `lot_size` DECIMAL(18,2) COMMENT 'Minimum production or procurement lot size applicable to the material.',
    `material_number` STRING COMMENT 'SAP master data identifier for the material (SKU).. Valid values are `^[A-Z0-9]{18}$`',
    `mrp_requirement_status` STRING COMMENT 'Current processing state of the requirement.. Valid values are `planned|released|cancelled|exception`',
    `planning_horizon_days` STRING COMMENT 'Number of days covered by the planning run that produced this requirement.',
    `planning_scenario` STRING COMMENT 'Planning run scenario used to generate the requirement (e.g., MPS, MRP, DRP).. Valid values are `MPS|MRP|DRP`',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant where the requirement applies.. Valid values are `^[A-Z0-9]{4}$`',
    `priority_code` STRING COMMENT 'Business priority assigned to the requirement for planning urgency.. Valid values are `high|medium|low`',
    `quantity_required` DECIMAL(18,2) COMMENT 'Total quantity of the material required for the planning horizon.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the requirement record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the requirement record.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level that triggers a new procurement proposal.',
    `requirement_date` DATE COMMENT 'Date by which the material is needed to meet production schedules.',
    `requirement_number` STRING COMMENT 'Business identifier assigned to the requirement by the MRP run.. Valid values are `^[A-Z0-9]{1,20}$`',
    `requirement_type` STRING COMMENT 'Indicates whether the requirement is independent (external demand) or dependent (internal component need).. Valid values are `independent|dependent`',
    `safety_stock` DECIMAL(18,2) COMMENT 'Buffer stock maintained to protect against demand variability and supply delays.',
    `source_of_supply` STRING COMMENT 'Indicates whether the material will be sourced internally or from external suppliers.. Valid values are `internal|external`',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the required quantity.. Valid values are `EA|KG|L|M`',
    CONSTRAINT pk_mrp_requirement PRIMARY KEY(`mrp_requirement_id`)
) COMMENT 'MRP (Material Requirements Planning) planned requirement record generated by SAP MRP run (MD04/MD05). Captures dependent and independent demand requirements for each SKU, planned order proposals, reorder points, lot sizes, lead times, and exception messages. Drives procurement requisitions and production orders. Supports safety stock calculation, demand smoothing, and supply gap analysis across the manufacturing network. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` (
    `cycle_count_id` BIGINT COMMENT 'System-generated unique identifier for the physical inventory cycle count event.',
    `employee_id` BIGINT COMMENT 'Employee who performed the physical count.',
    `plant_id` BIGINT COMMENT 'Manufacturing plant where the inventory is stored.',
    `primary_employee_id` BIGINT COMMENT 'Employee who performed the physical count.',
    `sku_id` BIGINT COMMENT 'Reference to the master SKU (product) being counted.',
    `storage_location_id` BIGINT COMMENT 'Reference to the physical storage location (warehouse, plant, or depot) where the count took place.',
    `abc_classification` STRING COMMENT 'ABC inventory classification driving count frequency.. Valid values are `A|B|C`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the count was approved.',
    `approved_by` BIGINT COMMENT 'Employee who approved the count after review.',
    `book_quantity` DECIMAL(18,2) COMMENT 'Quantity recorded in the system (book) prior to the count.',
    `compliance_iatf16949_flag` BOOLEAN COMMENT 'True if the count complies with IATF 16949 inventory control requirements.',
    `compliance_nhtsa_flag` BOOLEAN COMMENT 'True if the count satisfies NHTSA traceability obligations.',
    `cost_center_code` STRING COMMENT 'Internal cost center associated with the inventory location.',
    `count_date` DATE COMMENT 'Date on which the physical count was performed.',
    `count_document_number` STRING COMMENT 'External document number assigned by SAP MM for the inventory count (e.g., MI01/MI07).',
    `count_frequency_days` STRING COMMENT 'Number of days between scheduled counts for this SKU/location.',
    `count_status` STRING COMMENT 'Current lifecycle status of the count event.. Valid values are `planned|counted|posted|approved|rejected`',
    `count_type` STRING COMMENT 'Specifies whether the count is a full inventory, partial, or scheduled cycle count.. Valid values are `full|partial|cycle`',
    `counted_quantity` DECIMAL(18,2) COMMENT 'Quantity physically counted during the inventory event.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the count record was first created.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the count took place.',
    `inventory_category` STRING COMMENT 'High‑level classification of the inventory item.. Valid values are `raw_material|component|wip|finished_goods|service_part`',
    `is_locked` BOOLEAN COMMENT 'Indicates whether the count record is locked from further edits.',
    `is_obsolete` BOOLEAN COMMENT 'Indicates whether the SKU is marked as obsolete.',
    `last_count_date` DATE COMMENT 'Date of the most recent prior count for this SKU/location.',
    `lot_number` STRING COMMENT 'Batch or lot identifier for traceability of the counted material.',
    `method` STRING COMMENT 'Technique used to perform the count.. Valid values are `manual|automated|RFID`',
    `model_year` STRING COMMENT 'Model year of the vehicle or component associated with the SKU.',
    `next_scheduled_count_date` DATE COMMENT 'Planned date for the next cycle count based on ABC classification.',
    `physical_inventory_doc_type` STRING COMMENT 'SAP document type for the inventory count.. Valid values are `MI01|MI07`',
    `posted_by` BIGINT COMMENT 'Employee who posted the count results.',
    `posted_timestamp` TIMESTAMP COMMENT 'Date and time when the count was posted to inventory.',
    `recount_flag` BOOLEAN COMMENT 'Indicates whether a recount was required after the initial count.',
    `recount_number` STRING COMMENT 'Sequential number of the recount attempt, if applicable.',
    `remarks` STRING COMMENT 'Free‑text field for additional comments or observations.',
    `reorder_point_quantity` DECIMAL(18,2) COMMENT 'Quantity at which a replenishment order should be triggered.',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'Predefined safety stock level for the SKU at the location.',
    `serial_number_flag` BOOLEAN COMMENT 'Indicates whether the counted items are serialized (true) or not (false).',
    `storage_bin` STRING COMMENT 'Alphanumeric code of the specific bin or shelf within the location.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for quantity fields (e.g., EA for each, KG for kilograms).. Valid values are `EA|KG|L|M`',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to the count record.',
    `variance_percentage` DECIMAL(18,2) COMMENT 'Percentage variance calculated as (variance_quantity / book_quantity) * 100.',
    `variance_quantity` DECIMAL(18,2) COMMENT 'Difference between counted and book quantities (counted - book).',
    `variance_reason` STRING COMMENT 'Narrative explanation for any observed variance.',
    CONSTRAINT pk_cycle_count PRIMARY KEY(`cycle_count_id`)
) COMMENT 'Physical inventory cycle count event record for a specific SKU at a specific storage location. Aligned with SAP MM physical inventory document (MI01/MI07). Captures count date, counted quantity, book quantity, variance quantity, variance percentage, count status (planned, counted, posted, approved), counter identity, and recount flag. Supports inventory accuracy KPIs, ABC classification-driven count frequency, and IATF 16949 inventory control requirements. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`batch_record` (
    `batch_record_id` BIGINT COMMENT 'System-generated unique identifier for the batch record.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Batch certification: each production batch must reference the compliance document proving it meets standards.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: batch_record describes a material batch; linking to sku_master consolidates material master data.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Normalize batch record location; replace string with FK to storage_location',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Regulatory batch traceability mandates associating each batch with the vehicle order it supplies, required for the Batch‑to‑Vehicle compliance report.',
    `batch_classification` STRING COMMENT 'Category describing the type of batch.. Valid values are `raw|component|finished|service`',
    `batch_name` STRING COMMENT 'Human‑readable name or description for the batch.',
    `batch_number` STRING COMMENT 'External business identifier assigned to the batch by the manufacturer.',
    `batch_owner_department` STRING COMMENT 'Internal department responsible for the batch.',
    `batch_status` STRING COMMENT 'Current lifecycle status of the batch.. Valid values are `created|released|quarantined|consumed|archived`',
    `compliance_carb_flag` BOOLEAN COMMENT 'Indicates compliance with California Air Resources Board regulations where applicable.',
    `compliance_iatf16949_flag` BOOLEAN COMMENT 'True if the batch meets IATF 16949 traceability requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the batch record was first created in the system.',
    `expiration_status` STRING COMMENT 'Current status of the batch relative to its expiry date.. Valid values are `valid|near_expiry|expired`',
    `expiry_date` DATE COMMENT 'Date after which the batch is no longer usable for production or sale.',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the batch contains hazardous substances requiring special handling.',
    `last_inspection_user` STRING COMMENT 'User identifier of the employee who performed the latest inspection.',
    `lot_traceability_flag` BOOLEAN COMMENT 'Indicates whether the batch is required to be traceable for IATF 16949 compliance.',
    `manufacturing_date` DATE COMMENT 'Date on which the batch was produced.',
    `material_grade` STRING COMMENT 'Quality grade of the material as defined by internal standards.. Valid values are `A|B|C|D`',
    `production_site_code` STRING COMMENT 'Code of the plant or facility where the batch was manufactured.',
    `quality_inspection_date` DATE COMMENT 'Date when the latest quality inspection was performed.',
    `quality_inspection_status` STRING COMMENT 'Result of the most recent quality inspection for the batch.. Valid values are `pending|passed|failed|rework`',
    `quality_score` DECIMAL(18,2) COMMENT 'Numeric score (0‑100) representing overall quality assessment of the batch.',
    `quantity_in_base_units` DECIMAL(18,2) COMMENT 'Total quantity of material in the batch expressed in its base unit of measure.',
    `restricted_use_flag` BOOLEAN COMMENT 'Indicates whether the batch is subject to restricted‑use regulations (e.g., safety‑critical components).',
    `serial_number` STRING COMMENT 'Serial number for high‑value serialized items within the batch (e.g., ECUs, batteries).',
    `supplier_lot_reference` STRING COMMENT 'Reference number provided by the supplier for the original lot.',
    `tensile_strength_mpa` DECIMAL(18,2) COMMENT 'Measured tensile strength of the material in megapascals.',
    `unit_of_measure` STRING COMMENT 'Unit in which the batch quantity is measured.. Valid values are `kg|l|pcs|m|cm|g`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the batch record.',
    CONSTRAINT pk_batch_record PRIMARY KEY(`batch_record_id`)
) COMMENT 'Lot/batch master record for materials managed with batch traceability, including production components, chemicals, raw materials, and serialized high-value parts. Aligned with SAP MM batch master (MCH1/MCHA). Captures batch number, manufacturing date, expiry date, supplier lot reference, quality inspection status, batch classification characteristics (e.g., material grade, tensile strength), and restricted-use flags. Mandatory for IATF 16949 lot traceability and recall readiness. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` (
    `serialized_unit_id` BIGINT COMMENT 'Unique surrogate key for the serialized unit record.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Warranty & service diagnostics need to map each serialized component to the vehicle it is installed on for recall and repair actions.',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: REQUIRED: Warranty analysis of serialized units requires a reference to the official defect definition; defect_code_id provides this link for the Warranty Defect Impact Report.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Installation records need the employee who installed the serialized component for warranty and service history.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: serialized_unit belongs to a parent SKU; linking to sku_master removes redundant parent_sku field.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Serialized units are stored in locations; replace location_code with FK to storage_location',
    `associated_vin` STRING COMMENT 'VIN of the vehicle where the unit is installed, if applicable.',
    `batch_number` STRING COMMENT 'Manufacturing batch identifier.',
    `calibration_date` DATE COMMENT 'Date when the unit was last calibrated.',
    `calibration_due_date` DATE COMMENT 'Scheduled date for next calibration.',
    `capacity_ah` DECIMAL(18,2) COMMENT 'Battery capacity in ampere-hours, if applicable.',
    `compliance_status` STRING COMMENT 'Status of compliance with applicable regulations (e.g., safety, emissions).. Valid values are `compliant|non_compliant|pending|exempt`',
    `component_type` STRING COMMENT 'Category of the component represented by the serialized unit.. Valid values are `ECU|Battery|ADAS_Sensor|Transmission|Gearbox|Infotainment`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for purchase price.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `dimensions_mm` STRING COMMENT 'Physical dimensions (LxWxH) in millimeters.',
    `expiration_date` DATE COMMENT 'Date after which the component should not be used (e.g., for batteries).',
    `firmware_version` STRING COMMENT 'Version of firmware installed on the unit.',
    `health_status` STRING COMMENT 'Overall health assessment of the unit based on diagnostics.. Valid values are `good|fair|poor|critical`',
    `installation_status` STRING COMMENT 'Indicates whether the unit is installed in a vehicle or other equipment.. Valid values are `not_installed|installed_in_vehicle|installed_in_test|installed_in_service`',
    `is_defective` BOOLEAN COMMENT 'Indicates if the unit has been marked as defective.',
    `last_service_date` DATE COMMENT 'Date when the unit last underwent service or maintenance.',
    `lot_number` STRING COMMENT 'Batch or lot identifier for traceability.',
    `manufacture_date` DATE COMMENT 'Date the component was manufactured.',
    `purchase_price` DECIMAL(18,2) COMMENT 'Cost paid to acquire the component.',
    `receipt_date` DATE COMMENT 'Date the component was received into inventory.',
    `safety_certification_code` STRING COMMENT 'Code of safety certification (e.g., NCAP, FMVSS).',
    `serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for the component.',
    `serialized_unit_status` STRING COMMENT 'Current lifecycle status of the serialized unit.. Valid values are `in_stock|installed|returned|scrapped|reserved|under_repair`',
    `supplier_code` STRING COMMENT 'Identifier of the supplier that provided the component.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `voltage_nominal` DECIMAL(18,2) COMMENT 'Design nominal voltage of the component.',
    `warranty_end_date` DATE COMMENT 'Date when the warranty coverage for the unit expires.',
    `warranty_period_months` STRING COMMENT 'Duration of warranty in months.',
    `warranty_start_date` DATE COMMENT 'Date when the warranty coverage for the unit begins.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the component.',
    CONSTRAINT pk_serialized_unit PRIMARY KEY(`serialized_unit_id`)
) COMMENT 'Serialized inventory record for high-value, individually tracked components such as ECUs (Electronic Control Units), EV battery packs, ADAS sensor modules, and transmission assemblies. Captures serial number, parent SKU, current stock status, current storage location, installation status (in-stock, installed-in-vehicle, returned, scrapped), VIN association when installed, and warranty start date. Supports end-to-end component traceability from goods receipt through vehicle assembly to field service. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` (
    `wip_order_stock_id` BIGINT COMMENT 'Unique surrogate identifier for each WIP order stock line record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: WIP order stock consumption is charged to a cost center for work‑in‑process cost accounting.',
    `production_order_id` BIGINT COMMENT 'Identifier of the production order to which this WIP line belongs.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: wip_order_stock references component SKUs; linking to sku_master normalizes component data.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: WIP order stock staging location should reference storage_location entity',
    `backflush_flag` BOOLEAN COMMENT 'True if the component is backflushed automatically at operation completion.',
    `batch_number` STRING COMMENT 'Identifier of the manufacturing batch to which the component belongs.',
    `component_name` STRING COMMENT 'Human‑readable name or description of the component.',
    `cost_amount` DECIMAL(18,2) COMMENT 'Standard cost of the component at the time of issue.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the WIP line record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency for cost_amount.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `effective_date` DATE COMMENT 'Date from which the WIP line is considered active.',
    `expiration_date` DATE COMMENT 'Date after which the WIP line is no longer valid (e.g., component scrapped or re‑allocated).',
    `inventory_status` STRING COMMENT 'Current status of the component stock in the WIP area.. Valid values are `available|allocated|in_process|scrapped|reserved|on_hold`',
    `issued_quantity` DECIMAL(18,2) COMMENT 'Actual quantity of the component that has been issued to the shop floor for this line.',
    `line_sequence` STRING COMMENT 'Sequential number of the line within the production order.',
    `lot_number` STRING COMMENT 'Batch/lot identifier for traceability of the component.',
    `operation_sequence` STRING COMMENT 'Sequence number of the shop‑floor operation where the component is staged or consumed.',
    `remarks` STRING COMMENT 'Optional free‑text notes or comments about the WIP line.',
    `required_quantity` DECIMAL(18,2) COMMENT 'Quantity of the component that the production order plans to issue for the operation.',
    `scrap_quantity` DECIMAL(18,2) COMMENT 'Quantity of the component recorded as scrap for this line.',
    `serial_number_flag` BOOLEAN COMMENT 'True if the component is tracked at serial‑number level.',
    `uom` STRING COMMENT 'Measurement unit for quantities (e.g., each, kilogram).. Valid values are `EA|KG|L|M|PCS|SET`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the WIP line record.',
    `wip_order_stock_status` STRING COMMENT 'Current lifecycle state of the WIP line.. Valid values are `open|closed|released|cancelled|pending|completed`',
    CONSTRAINT pk_wip_order_stock PRIMARY KEY(`wip_order_stock_id`)
) COMMENT 'Work-in-Progress (WIP) inventory record tracking components and sub-assemblies staged or consumed against a specific production order on the shop floor. Aligned with SAP PP production order component stock (CO11N/COGI). Captures production order reference, operation sequence, component SKU, required quantity, issued quantity, backflush status, scrap quantity, and staging location. Provides real-time WIP visibility for MES integration and production cost accounting. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` (
    `finished_vehicle_stock_id` BIGINT COMMENT 'System-generated unique identifier for each finished vehicle stock record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Dealer sales assignment report tracks which sales rep is responsible for each finished vehicle allocation.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Fleet management and OTA update processes require joining inventory vehicle records with connected‑vehicle telemetry for status and compliance reporting.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer to which the vehicle is allocated.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Vehicle approval: link each finished VIN to its homologation record required for market entry.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Vehicle sales invoicing requires linking each finished vehicle (VIN) to its sales invoice for reconciliation of inventory and revenue.',
    `primary_dealership_id` BIGINT COMMENT 'Identifier of the dealer to which the vehicle is allocated.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Vehicle profitability analysis attributes each finished vehicle to a profit center for margin reporting.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Allocation report requires linking each finished vehicle to the specific sales order it fulfills, enabling real‑time order fulfillment tracking.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Delivery & Warranty Management report needs to tie each stocked VIN to its owning customer record.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Supports dealership allocation and program performance reports linking finished vehicles back to their engineering program.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Needed for Finished Vehicle Stock report linking each inventory vehicle to its VIN registry for warranty, recall, and regulatory compliance.',
    `aging_days` STRING COMMENT 'Number of days the vehicle has been in its current status.',
    `allocation_date` DATE COMMENT 'Date the vehicle was assigned to a dealer.',
    `batch_number` STRING COMMENT 'Internal production batch number associated with the vehicle.',
    `body_style` STRING COMMENT 'Physical body configuration (e.g., sedan, SUV, truck).',
    `color` STRING COMMENT 'Paint color of the vehicle as defined by the manufacturer.',
    `current_location_code` STRING COMMENT 'Identifier of the compound, yard, warehouse, or dealer where the vehicle is presently stored.',
    `delivery_date` DATE COMMENT 'Actual date the vehicle left the plant or compound for the dealer/customer.',
    `emission_standard` STRING COMMENT 'Regulatory emission classification (e.g., Euro 6, EPA Tier 3).',
    `expected_delivery_date` DATE COMMENT 'Planned delivery date based on logistics schedule.',
    `hold_code` STRING COMMENT 'Code indicating why a vehicle is on hold (e.g., quality, finance).',
    `hold_reason` STRING COMMENT 'Free‑text explanation for the hold code.',
    `location_type` STRING COMMENT 'Category of the current location.. Valid values are `compound|yard|warehouse|dealer|in_transit`',
    `lot_number` STRING COMMENT 'Batch identifier used for traceability of the vehicle batch.',
    `model_code` STRING COMMENT 'Manufacturers code representing the vehicle model (e.g., CX5, F150).',
    `msrp` DECIMAL(18,2) COMMENT 'Standard retail price set by the manufacturer for the vehicle configuration.',
    `plant_code` STRING COMMENT 'Identifier of the plant where the vehicle was assembled.',
    `powertrain_type` STRING COMMENT 'Primary propulsion technology of the vehicle.. Valid values are `EV|ICE|HEV|PHEV`',
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
) COMMENT 'Finished vehicle inventory record tracking completed vehicles from end-of-line (EOL) through PDI (Pre-Delivery Inspection), compound storage, and dealer allocation. Captures VIN, model/trim/color configuration, plant of manufacture, current compound or yard location, stock status (in-production, PDI-pending, PDI-complete, allocated, in-transit, delivered), hold codes, and aging days. Bridges manufacturing and logistics domains for vehicle order fulfillment. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` (
    `service_parts_stock_id` BIGINT COMMENT 'Unique identifier for the service parts stock record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Service parts inventory cost is allocated to a cost center for service department expense tracking.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Service parts issuance logs the technician receiving parts; required for service cost accounting and warranty traceability.',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to asset.spare_parts_catalog. Business justification: SERVICE PARTS INVENTORY: Tying service parts to the spare‑parts catalog eliminates redundancy and supports warranty and compliance reporting.',
    `storage_location_id` BIGINT COMMENT 'Unique identifier of the warehouse or dealer location where the stock is held.',
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
) COMMENT 'After-sales service parts inventory record tracking spare parts and accessories across the central parts distribution center (PDC), regional warehouses, and dealer parts rooms. Captures part number, supersession chain, current stock level by location, min/max replenishment levels, fill rate, backorder quantity, and obsolescence classification. Supports dealer parts ordering, warranty repair fulfillment, and TSB (Technical Service Bulletin) parts pre-positioning. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` (
    `replenishment_order_id` BIGINT COMMENT 'Unique identifier for the replenishment order.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Replenishment orders are budgeted and expensed against a cost center for internal cost control.',
    `storage_location_id` BIGINT COMMENT 'Identifier of the consuming location (line‑side, assembly station, dealer parts room).',
    `primary_replenishment_storage_location_id` BIGINT COMMENT 'Identifier of the supplying storage location (warehouse, supermarket, PDC).',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier or internal source providing the material.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Replenishment request workflow records the planner who initiates the order; needed for approval routing and audit trails.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: replenishment_order requests stock for a SKU; linking to sku_master centralizes SKU attributes.',
    `trade_compliance_record_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_compliance_record. Business justification: Import/export compliance: each replenishment order for imported parts must reference its trade compliance record.',
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
) COMMENT 'Internal replenishment order triggering stock movement from a supplying storage location (warehouse, supermarket, PDC) to a consuming location (line-side, assembly station, dealer parts room). Captures replenishment type (kanban, min-max, JIT pull, JIS sequence), trigger source, requested SKU and quantity, source and destination locations, priority, requested delivery time, and fulfillment status. Supports lean manufacturing pull systems and dealer parts replenishment cycles. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` (
    `consignment_stock_id` BIGINT COMMENT 'Unique surrogate key for each consignment stock record.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the supplier that owns the consigned inventory.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: consignment_stock holds supplier-owned stock for a SKU; linking to sku_master removes duplicate SKU identifier.',
    `aging_days` STRING COMMENT 'Number of days the consigned stock has been on‑hand since receipt.',
    `batch_number` STRING COMMENT 'Batch or lot identifier for the consigned material.',
    `consignment_number` STRING COMMENT 'External business identifier assigned to the consignment by the supplier or ERP.',
    `consignment_reference` STRING COMMENT 'Human‑readable label or reference code for the consignment stock.',
    `consignment_stock_status` STRING COMMENT 'Current operational status of the consignment record.. Valid values are `available|reserved|consumed|settled|blocked`',
    `consignment_type` STRING COMMENT 'Program type for the consignment (Just‑In‑Time, Just‑In‑Sequence, or standard).. Valid values are `JIT|JIS|standard`',
    `consumption_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity of the consigned stock that has been consumed/issued to production.',
    `contract_number` STRING COMMENT 'Reference to the supplier consignment contract or agreement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the consignment record was first created in the system.',
    `effective_from` DATE COMMENT 'Date when the consignment agreement becomes effective.',
    `effective_until` DATE COMMENT 'Date when the consignment agreement expires (null if open‑ended).',
    `is_batch_managed` BOOLEAN COMMENT 'Indicates whether the consigned item is managed in batches/lots.',
    `is_serialized` BOOLEAN COMMENT 'Indicates whether the consigned item is tracked by individual serial numbers.',
    `last_movement_date` DATE COMMENT 'Date of the most recent inventory transaction (e.g., issue, transfer).',
    `last_settlement_date` DATE COMMENT 'Date when the most recent settlement invoice was posted to the supplier.',
    `material_description` STRING COMMENT 'Text description of the material.',
    `material_number` STRING COMMENT 'SAP material master number for the consigned part.',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant where the consignment is stored.',
    `quantity_on_hand` DECIMAL(18,2) COMMENT 'Current physical quantity of the consigned stock available at the location.',
    `receipt_date` DATE COMMENT 'Date the consigned material was received at the plant.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level that triggers a replenishment request for the consigned item.',
    `safety_stock` DECIMAL(18,2) COMMENT 'Buffer quantity maintained to protect against demand variability and supply delays.',
    `serial_number` STRING COMMENT 'Serial number for serialized high‑value components (e.g., ECUs, batteries).',
    `settlement_due_quantity` DECIMAL(18,2) COMMENT 'Quantity that has been consumed but not yet invoiced to the supplier.',
    `settlement_status` STRING COMMENT 'Current status of the financial settlement for the consigned stock.. Valid values are `pending|settled|disputed`',
    `stock_category` STRING COMMENT 'Classification of the consigned item for reporting and planning.. Valid values are `raw_material|component|finished_goods|service_part|spare_part`',
    `storage_location` STRING COMMENT 'Warehouse or storage location identifier within the plant.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the quantity fields.. Valid values are `EA|KG|L|M|PCS|SET`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the consignment record.',
    `valuation_amount` DECIMAL(18,2) COMMENT 'Monetary value of the consigned quantity based on the selected valuation method.',
    `valuation_currency` STRING COMMENT 'ISO 4217 currency code for the valuation amount.. Valid values are `USD|EUR|JPY|GBP|CNY|CHF`',
    `valuation_method` STRING COMMENT 'Method used to calculate the monetary value of the consigned stock.. Valid values are `standard_cost|moving_average|fifo|lifo`',
    CONSTRAINT pk_consignment_stock PRIMARY KEY(`consignment_stock_id`)
) COMMENT 'Consignment inventory record for supplier-owned stock held at Automotive plant premises but not yet invoiced. Aligned with SAP MM consignment stock management (MBLB). Captures supplier, consignment SKU, quantity on-hand at each location, consumption postings, settlement-due quantity, and aging. Supports JIT/JIS supplier consignment programs, reduces working capital, and triggers automatic settlement upon consumption. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` (
    `inventory_valuation_id` BIGINT COMMENT 'System generated unique identifier for each inventory valuation record.',
    `asset_valuation_id` BIGINT COMMENT 'SSOT reference to asset.asset_valuation (resolves cross-domain duplicate of valuation).',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Inventory valuation reports are posted to a specific cost center for budgeting and variance analysis.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Valuation amounts must be posted to a GL account; linking ensures correct ledger posting.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profitability of inventory valuation is tracked per profit center to support P&L reporting.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: inventory_valuation records financial values per SKU; linking to sku_master provides authoritative SKU details.',
    `area` STRING COMMENT 'Logical area used for valuation (e.g., unrestricted, blocked, quality inspection).',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the valuation amounts.. Valid values are `USD|EUR|JPY|CNY|GBP|CHF`',
    `fiscal_year` STRING COMMENT 'Fiscal year (e.g., FY2025) to which the valuation belongs.',
    `last_valuation_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the valuation calculation was performed.',
    `moving_average_price` DECIMAL(18,2) COMMENT 'Weighted average price of the material based on receipt and issue movements, used when price control is moving average.',
    `obsolescence_flag` BOOLEAN COMMENT 'Indicates whether the material is considered obsolete and may require a write‑down.',
    `period` STRING COMMENT 'Reporting period identifier (e.g., Q1, Q2) for the valuation.',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant or warehouse where the inventory is located.',
    `price_control` STRING COMMENT 'Indicates whether the material is valued using standard price or moving average price.. Valid values are `standard|moving_average`',
    `price_variance` DECIMAL(18,2) COMMENT 'Difference between standard price and moving average price, useful for variance analysis.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the valuation record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the valuation record.',
    `standard_price` DECIMAL(18,2) COMMENT 'Fixed price defined for the material in the valuation class, used when price control is standard.',
    `total_stock_quantity` DECIMAL(18,2) COMMENT 'Aggregated quantity of the material on hand across the valuation area, expressed in base units.',
    `total_stock_value` DECIMAL(18,2) COMMENT 'Monetary value of the total stock quantity calculated using the applicable price (standard or moving average).',
    `valuation_class` STRING COMMENT 'Classification that determines the valuation method and account assignment.',
    `valuation_date` DATE COMMENT 'Date on which the inventory valuation is effective.',
    `valuation_number` STRING COMMENT 'External reference number assigned to the valuation run, used for audit and reporting.',
    `valuation_status` STRING COMMENT 'Current processing state of the valuation record.. Valid values are `draft|in_progress|finalized|reversed`',
    `write_down_amount` DECIMAL(18,2) COMMENT 'Financial amount to be written down from inventory value due to obsolescence or impairment.',
    CONSTRAINT pk_inventory_valuation PRIMARY KEY(`inventory_valuation_id`)
) COMMENT 'Inventory valuation record capturing the financial value of stock by SKU, plant, and valuation area. Aligned with SAP MM/CO material valuation (MBEW). Captures valuation class, price control (standard vs. moving average), standard price, moving average price, total stock value, price variance, and last valuation date. Supports COGS calculation, inventory write-down for obsolescence, and financial reporting under IFRS/US GAAP. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` (
    `safety_stock_policy_id` BIGINT COMMENT 'System-generated unique identifier for the safety stock policy record.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: safety_stock_policy defines policies per SKU; linking to sku_master eliminates redundant sku_code.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the safety stock policy record was first created.',
    `demand_variability_factor` DECIMAL(18,2) COMMENT 'Coefficient representing demand volatility used in safety stock calculation (percentage).',
    `effective_from` DATE COMMENT 'Date on which the policy becomes effective.',
    `effective_until` DATE COMMENT 'Date on which the policy expires or is superseded; null if open‑ended.',
    `last_recalculation_timestamp` TIMESTAMP COMMENT 'Date and time when the safety stock values were last computed.',
    `lead_time_days` STRING COMMENT 'Average number of days from order placement to receipt for the SKU.',
    `lifecycle_status` STRING COMMENT 'Stage of the policy within its approval and implementation lifecycle.. Valid values are `draft|approved|implemented|retired`',
    `location_code` STRING COMMENT 'Identifier of the warehouse or storage bin to which the policy is scoped.',
    `maximum_stock_level` DECIMAL(18,2) COMMENT 'Upper bound of inventory allowed for the SKU to avoid overstock.',
    `notes` STRING COMMENT 'Free‑form comments or rationale associated with the policy.',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant or production site where the policy is enforced.',
    `policy_number` STRING COMMENT 'Business-visible identifier or code assigned to the safety stock policy.',
    `policy_type` STRING COMMENT 'Category of inventory control the policy addresses.. Valid values are `safety_stock|reorder_point|max_stock`',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level that triggers a replenishment order for the SKU.',
    `review_cycle_days` STRING COMMENT 'Frequency, in days, at which the safety stock parameters are reviewed and potentially recalculated.',
    `safety_stock_method` STRING COMMENT 'Method used to determine safety stock (statistical, fixed amount, or dynamic algorithm).. Valid values are `statistical|fixed|dynamic`',
    `safety_stock_policy_status` STRING COMMENT 'Current operational state of the safety stock policy.. Valid values are `active|inactive|pending`',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'Calculated buffer quantity to be kept on hand for the SKU at the specified location.',
    `safety_stock_source` STRING COMMENT 'Origin of the safety stock values – generated by the system, entered manually, or supplied by an external tool.. Valid values are `system|manual|external`',
    `service_level_target` DECIMAL(18,2) COMMENT 'Desired fill‑rate or service level expressed as a percentage.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the policy record.',
    CONSTRAINT pk_safety_stock_policy PRIMARY KEY(`safety_stock_policy_id`)
) COMMENT 'Safety stock and reorder point policy record defining the minimum stock buffer for each SKU at each plant/location to protect against demand variability and supply disruptions. Captures safety stock quantity, reorder point, maximum stock level, replenishment lead time, demand variability factor, service level target, review cycle, and last recalculation date. Drives MRP safety stock parameters and supports supply chain resilience planning. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` (
    `abc_xyz_classification_id` BIGINT COMMENT 'Surrogate primary key for the ABC/XYZ classification record.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: abc_xyz_classification classifies SKUs; linking to sku_master removes duplicate sku_code.',
    `abc_class` STRING COMMENT 'ABC class based on annual consumption value.. Valid values are `A|B|C`',
    `abc_xyz_classification_status` STRING COMMENT 'Current lifecycle status of the classification record.. Valid values are `active|inactive|pending_review|retired`',
    `annual_consumption_value` DECIMAL(18,2) COMMENT 'Total monetary value of consumption for the SKU over the past year, in USD.',
    `classification_date` DATE COMMENT 'Date when the ABC/XYZ classification was assigned.',
    `classification_method` STRING COMMENT 'Method used to determine the ABC/XYZ class.. Valid values are `pareto|custom|automated`',
    `consumption_frequency_per_year` STRING COMMENT 'Number of times the SKU is consumed or used in a year.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the classification record was created in the system.',
    `cycle_count_frequency_days` STRING COMMENT 'Frequency in days for physical inventory cycle counting as driven by classification.',
    `effective_until` DATE COMMENT 'Date when the classification record ceases to be effective, if applicable.',
    `is_obsolete` BOOLEAN COMMENT 'True if the classification is considered obsolete due to changes in demand or product lifecycle.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next classification review.',
    `notes` STRING COMMENT 'Additional remarks or comments regarding the classification decision.',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'Recommended safety stock level for the SKU based on classification.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the classification record.',
    `xyz_class` STRING COMMENT 'XYZ class based on demand variability.. Valid values are `X|Y|Z`',
    CONSTRAINT pk_abc_xyz_classification PRIMARY KEY(`abc_xyz_classification_id`)
) COMMENT 'ABC/XYZ inventory classification record assigning each SKU a consumption value class (A=high value, B=medium, C=low) and demand variability class (X=stable, Y=variable, Z=irregular). Captures classification date, ABC class, XYZ class, annual consumption value, consumption frequency, classification method, and next review date. Drives cycle count frequency, safety stock policy, and obsolescence review prioritization per IATF 16949 inventory control best practices. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` (
    `obsolescence_review_id` BIGINT COMMENT 'System-generated unique identifier for the obsolescence review record.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or analyst who performed the review.',
    `reviewer_employee_id` BIGINT COMMENT 'Identifier of the employee or analyst who performed the review.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Obsolescence review location should be a FK to storage_location',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the review was approved; null if not yet approved.',
    `batch_number` STRING COMMENT 'Batch identifier if the SKU is managed by batch.',
    `compliance_carb_flag` BOOLEAN COMMENT 'Indicates whether the SKU meets California Air Resources Board (CARB) regulations.',
    `compliance_iatf16949_flag` BOOLEAN COMMENT 'Indicates whether the SKU complies with IATF 16949 quality standards.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the review record was initially created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the write‑down amount.. Valid values are `^[A-Z]{3}$`',
    `days_since_last_movement` STRING COMMENT 'Number of days elapsed since the last inventory movement.',
    `disposition_reason` STRING COMMENT 'Narrative explanation for the chosen disposition.',
    `eop_flag` BOOLEAN COMMENT 'Indicates whether the SKU is no longer in production (true) or still active (false).',
    `estimated_write_down_value` DECIMAL(18,2) COMMENT 'Financial amount projected to be written off for the obsolete inventory.',
    `expiration_date` DATE COMMENT 'Date after which the inventory item is considered expired or unusable.',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the obsolescence issue is considered critical for operations.',
    `last_movement_date` DATE COMMENT 'Date of the most recent inventory transaction for the SKU.',
    `lot_number` STRING COMMENT 'Lot identifier for traceability of the inventory item.',
    `manufacturing_date` DATE COMMENT 'Date the inventory item was produced.',
    `notes` STRING COMMENT 'Free‑form comments or observations captured by the reviewer.',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant or facility where the inventory is stored.. Valid values are `^[A-Z0-9]{2,5}$`',
    `recommended_disposition` STRING COMMENT 'Suggested action for the obsolete stock based on review analysis.. Valid values are `continue|markdown|scrap|return_to_supplier|donate`',
    `review_date` DATE COMMENT 'Date on which the obsolescence review was conducted.',
    `review_number` STRING COMMENT 'Human‑readable reference number for the review, used in reports and communications.',
    `review_status` STRING COMMENT 'Current lifecycle status of the review record.. Valid values are `draft|pending|approved|rejected`',
    `risk_score` STRING COMMENT 'Numeric risk rating (1‑5) assigned by the reviewer to quantify obsolescence impact.',
    `safety_stock_qty` STRING COMMENT 'Quantity of the SKU that must be retained as safety stock, regardless of obsolescence.',
    `sku` STRING COMMENT 'Identifier of the inventory item being evaluated for obsolescence.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `stock_quantity` STRING COMMENT 'Current on‑hand quantity of the SKU at the specified location.',
    `supplier_code` STRING COMMENT 'Identifier of the supplier that provided the material.. Valid values are `^[A-Z0-9]{3,10}$`',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the stock quantity (e.g., each, kilogram, liter, meter).. Valid values are `EA|KG|L|M`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the review record.',
    `valuation_price` DECIMAL(18,2) COMMENT 'Standard unit price used for inventory valuation calculations.',
    CONSTRAINT pk_obsolescence_review PRIMARY KEY(`obsolescence_review_id`)
) COMMENT 'Inventory obsolescence review record assessing slow-moving and excess stock for write-down or disposal decisions. Captures SKU, location, stock quantity, last movement date, days-since-last-movement, EOP (End of Production) flag, estimated write-down value, recommended disposition (continue holding, markdown, scrap, return-to-supplier, donate), reviewer identity, and approval status. Supports periodic inventory health reviews and financial provisioning for obsolete stock. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` (
    `kanban_card_id` BIGINT COMMENT 'System-generated unique identifier for the kanban card record.',
    `procurement_supplier_id` BIGINT COMMENT 'Identifier of the external supplier when the replenishment strategy is external.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: kanban_card signals replenishment for a SKU; linking to sku_master removes redundant sku_code.',
    `card_number` STRING COMMENT 'Human‑readable identifier printed on the physical or electronic kanban card.',
    `cards_in_circulation` STRING COMMENT 'Total number of active kanban cards for this SKU and work center combination.',
    `consuming_work_center` STRING COMMENT 'Identifier of the work center that consumes the material signaled by this kanban.',
    `container_quantity` STRING COMMENT 'Number of units of the SKU contained in one kanban container.',
    `container_type` STRING COMMENT 'Physical container format used for the kanban (e.g., bin, pallet, box).. Valid values are `bin|pallet|box|tote|crate`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the kanban card record was initially created in the system.',
    `kanban_card_description` STRING COMMENT 'Free‑form text describing special handling or notes for the kanban.',
    `effective_from` DATE COMMENT 'Date from which the kanban card becomes active for production planning.',
    `effective_until` DATE COMMENT 'Date after which the kanban card is retired; null if open‑ended.',
    `is_jis_enabled` BOOLEAN COMMENT 'Indicates whether the kanban is used in a JIS sequencing context.',
    `is_jit_enabled` BOOLEAN COMMENT 'Indicates whether the kanban participates in a JIT production flow.',
    `kanban_status` STRING COMMENT 'Current state of the kanban card (e.g., empty, in‑transit, full, blocked).. Valid values are `empty|in_transit|full|blocked`',
    `last_consumption_timestamp` TIMESTAMP COMMENT 'Timestamp when the downstream work center recorded consumption of the kanban‑linked material.',
    `last_signal_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent kanban signal (e.g., when the card turned empty).',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent update to the kanban card record.',
    `lead_time_days` STRING COMMENT 'Planned number of days from kanban signal to material arrival.',
    `lot_control_flag` BOOLEAN COMMENT 'Indicates whether the material is managed by lot/lot number.',
    `notes` STRING COMMENT 'Additional remarks or operational instructions related to the kanban.',
    `priority_level` STRING COMMENT 'Business priority assigned to the kanban card for production scheduling.. Valid values are `low|medium|high|critical`',
    `production_line` STRING COMMENT 'Identifier of the specific production line that consumes the kanban.',
    `reorder_point_qty` DECIMAL(18,2) COMMENT 'Inventory level at which a new kanban card is generated to trigger replenishment.',
    `replenishment_strategy` STRING COMMENT 'Method used to replenish the downstream inventory when the kanban signals empty.. Valid values are `internal|external|in_house_production`',
    `safety_stock_qty` DECIMAL(18,2) COMMENT 'Minimum safety stock quantity maintained for the SKU to protect against variability.',
    `serial_control_flag` BOOLEAN COMMENT 'Indicates whether the material is serialized (individual serial numbers tracked).',
    `signal_method` STRING COMMENT 'Mechanism used to convey the kanban signal (physical card, electronic signal, barcode scan).. Valid values are `physical|electronic|barcode`',
    `supply_area` STRING COMMENT 'Logical area or zone where the supply source for the kanban is located (e.g., warehouse, buffer, supplier dock).',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity fields (e.g., pieces, kilograms).. Valid values are `pcs|kg|liter|meter`',
    `version_number` STRING COMMENT 'Incremental version of the kanban record for change tracking.',
    CONSTRAINT pk_kanban_card PRIMARY KEY(`kanban_card_id`)
) COMMENT 'Kanban card master record governing pull-based replenishment signals for line-side and supermarket inventory in lean manufacturing environments. Captures kanban card number, associated SKU, supply area, consuming work center, container quantity, number of cards in circulation, replenishment strategy (internal, external, in-house production), kanban status (empty, in-transit, full), and signal method (physical, electronic, barcode). Supports JIT/JIS production systems and reduces WIP inventory. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` (
    `ckd_skd_kit_id` BIGINT COMMENT 'System-generated unique identifier for the CKD/SKD kit record.',
    `employee_id` BIGINT COMMENT 'Identifier of the user who last modified the kit record.',
    `primary_ckd_employee_id` BIGINT COMMENT 'Identifier of the user who created the kit record.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the user who created the kit record.',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: CKD kit planning requires associating each kit with the vehicle model it assembles, used in production scheduling and customs documentation.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: CKD/SKD kits are shipped per vehicle order; linking enables the Kit‑to‑Order allocation dashboard used by assembly planners.',
    `actual_arrival_date` DATE COMMENT 'Date the kit was received at the destination plant.',
    `bom_reference_number` STRING COMMENT 'Identifier of the BOM that defines the parts included in the kit.',
    `completeness_status` STRING COMMENT 'Indicates whether all required parts are present in the kit.. Valid values are `complete|partial|missing_parts`',
    `container_number` STRING COMMENT 'Identifier of the shipping container that holds the kit.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the kit record was first created in the system.',
    `customs_tariff_code` STRING COMMENT 'HS or tariff code used for customs duty calculation.',
    `customs_valuation_amount` DECIMAL(18,2) COMMENT 'Customs‑declared value of the kit for duty calculation.',
    `customs_valuation_currency` STRING COMMENT 'ISO 4217 currency code for the customs valuation.',
    `documentation_status` STRING COMMENT 'Current status of required export documentation.. Valid values are `pending|submitted|approved|rejected`',
    `expected_arrival_date` DATE COMMENT 'Planned date of arrival at the destination plant.',
    `export_country_code` STRING COMMENT 'ISO 3166‑1 alpha‑3 code of the country to which the kit is exported.. Valid values are `^[A-Z]{3}$`',
    `export_document_reference` STRING COMMENT 'Reference to export paperwork (e.g., commercial invoice, export license).',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the kit contains hazardous materials requiring special handling.',
    `inventory_accuracy_percent` DECIMAL(18,2) COMMENT 'Percentage indicating how accurately the kit quantity matches system records.',
    `is_jis_flag` BOOLEAN COMMENT 'True if the kit follows a JIS sequencing requirement.',
    `is_jit_flag` BOOLEAN COMMENT 'True if the kit is produced/shipped under a JIT strategy.',
    `is_obsolete_flag` BOOLEAN COMMENT 'True if the kit is marked obsolete and should not be used for production.',
    `kit_category` STRING COMMENT 'Classification of the kit as Completely Knocked Down (CKD), Semi‑Knocked Down (SKD), or a mixed configuration.. Valid values are `CKD|SKD|Mixed`',
    `kit_name` STRING COMMENT 'Human‑readable name or description of the kit, often reflecting vehicle model and configuration.',
    `kit_number` STRING COMMENT 'External business identifier assigned to the kit for tracking and customs documentation.',
    `kit_status` STRING COMMENT 'Current lifecycle status of the kit.. Valid values are `created|packed|shipped|in_transit|arrived|closed`',
    `last_inventory_count_date` DATE COMMENT 'Date of the most recent physical inventory count for the kit.',
    `lot_number` STRING COMMENT 'Lot identifier for traceability of the kit batch.',
    `missing_parts_list` STRING COMMENT 'Free‑text list of parts that are absent from a partially complete kit.',
    `packing_list_number` STRING COMMENT 'Reference number of the packing list generated for the kit shipment.',
    `serial_number_flag` BOOLEAN COMMENT 'True if individual parts in the kit are tracked by serial number.',
    `serial_numbers` STRING COMMENT 'Comma‑separated list of serial numbers for serialized components in the kit.',
    `shipping_date` DATE COMMENT 'Date the kit was loaded onto the outbound carrier.',
    `special_handling_instructions` STRING COMMENT 'Any additional handling notes (e.g., fragile, keep upright).',
    `supplier_code` STRING COMMENT 'Code of the supplier providing the kit components.',
    `target_assembly_plant_code` STRING COMMENT 'Code of the overseas assembly plant that will receive and assemble the kit.',
    `target_assembly_plant_name` STRING COMMENT 'Descriptive name of the destination assembly plant.',
    `temperature_control_required` BOOLEAN COMMENT 'Indicates whether the kit must be kept within a controlled temperature range during transport.',
    `total_volume_m3` DECIMAL(18,2) COMMENT 'Aggregate volume of the kit, expressed in cubic meters.',
    `total_weight_kg` DECIMAL(18,2) COMMENT 'Aggregate weight of all components in the kit, expressed in kilograms.',
    `transfer_price` DECIMAL(18,2) COMMENT 'Inter‑company transfer price applied to the kit for tax and profitability reporting.',
    `transfer_price_currency` STRING COMMENT 'ISO 4217 currency code for the transfer price.',
    `transfer_price_incoterms` STRING COMMENT 'Incoterm governing the transfer price responsibilities.. Valid values are `EXW|FCA|FOB|CFR|CIF|DDP`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the kit record.',
    `valuation_amount` DECIMAL(18,2) COMMENT 'Monetary valuation of the kit for accounting and customs purposes.',
    `valuation_currency` STRING COMMENT 'ISO 4217 currency code of the valuation amount.',
    CONSTRAINT pk_ckd_skd_kit PRIMARY KEY(`ckd_skd_kit_id`)
) COMMENT 'CKD (Completely Knocked Down) and SKD (Semi Knocked Down) kit inventory record for vehicles and assemblies exported to overseas assembly plants. Captures kit number, target assembly plant, kit BOM reference, packing list, container assignment, export documentation reference, kit completeness status, missing parts list, and customs valuation. Supports international manufacturing operations, transfer pricing, and customs compliance for cross-border kit shipments. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`adjustment` (
    `adjustment_id` BIGINT COMMENT 'System-generated unique identifier for the inventory adjustment transaction.',
    `employee_id` BIGINT COMMENT 'System user identifier who created the adjustment record.',
    `adjustment_updated_by_user_employee_id` BIGINT COMMENT 'System user identifier who last modified the adjustment record.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the employee who approved the inventory adjustment.',
    `quaternary_adjustment_updated_by_user_employee_id` BIGINT COMMENT 'System user identifier who last modified the adjustment record.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: inventory_adjustment adjusts quantities for a SKU; linking to sku_master consolidates SKU reference.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Adjustment records reference a storage location; replace string with FK',
    `tertiary_adjustment_employee_id` BIGINT COMMENT 'Identifier of the employee who approved the inventory adjustment.',
    `accounting_document_number` STRING COMMENT 'Financial document number generated for the adjustment in the general ledger.',
    `adjustment_number` STRING COMMENT 'Business identifier assigned to the adjustment for tracking and reference.',
    `adjustment_status` STRING COMMENT 'Current lifecycle status of the adjustment transaction.. Valid values are `draft|submitted|approved|rejected|posted|cancelled`',
    `adjustment_timestamp` TIMESTAMP COMMENT 'Date and time when the inventory adjustment event occurred in the business process.',
    `adjustment_type` STRING COMMENT 'Category describing why the inventory adjustment was performed.. Valid values are `count_variance|damage|theft|system_error|process_correction`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the adjustment was approved.',
    `approver_name` STRING COMMENT 'Full name of the employee who approved the adjustment.',
    `batch_number` STRING COMMENT 'Batch identifier when the adjustment applies to a specific production batch.',
    `comments` STRING COMMENT 'Optional free-text notes entered by the user.',
    `cost_center_code` STRING COMMENT 'Cost center to which the financial impact of the adjustment is charged.',
    `cost_currency` STRING COMMENT 'Three-letter ISO currency code for the cost impact amount.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `cost_impact_amount` DECIMAL(18,2) COMMENT 'Monetary impact of the adjustment on inventory valuation.',
    `effective_from` DATE COMMENT 'Start date when the adjustment becomes effective, if applicable.',
    `effective_until` DATE COMMENT 'End date when the adjustment ceases to be effective, if applicable.',
    `is_approved` BOOLEAN COMMENT 'Indicates if the adjustment has received final approval.',
    `is_manual` BOOLEAN COMMENT 'Flag indicating whether the adjustment was entered manually (true) or generated by an automated process (false).',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant where the adjustment took place.',
    `posting_date` DATE COMMENT 'Date on which the adjustment is posted to financial ledgers.',
    `project_number` STRING COMMENT 'Project identifier if the adjustment is linked to a specific internal project.',
    `quantity_adjusted` DECIMAL(18,2) COMMENT 'Signed quantity change; positive for additions, negative for reductions.',
    `reason_code` STRING COMMENT 'Standardized code representing the business reason for the adjustment.. Valid values are `RC01|RC02|RC03|RC04|RC05|RC06`',
    `reason_description` STRING COMMENT 'Free-text description providing additional context for the adjustment reason.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the adjustment record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the adjustment record.',
    `related_document_number` STRING COMMENT 'Reference to an external document (e.g., PPAP, audit report) linked to the adjustment.',
    `serial_number` STRING COMMENT 'Serial number of a uniquely tracked item affected by the adjustment.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount calculated for the adjustment, if applicable.',
    `tax_indicator` STRING COMMENT 'Indicates whether the adjustment is subject to tax.. Valid values are `taxable|non_taxable`',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the quantity adjusted.. Valid values are `EA|KG|L|M|BOX`',
    `valuation_area_code` STRING COMMENT 'Code representing the valuation area used for inventory accounting.',
    CONSTRAINT pk_adjustment PRIMARY KEY(`adjustment_id`)
) COMMENT 'Inventory adjustment transaction record capturing manual corrections to stock quantities resulting from cycle count variances, system reconciliation, damage write-offs, or process corrections. Captures adjustment type (count variance, damage, theft, system error, process correction), affected SKU/batch/serial, adjusted quantity (positive or negative), adjustment reason code, approver, financial impact, and posting date. Provides audit trail for inventory accuracy management and SOX compliance. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` (
    `warehouse_task_id` BIGINT COMMENT 'System-generated unique identifier for the warehouse execution task.',
    `order_line_id` BIGINT COMMENT 'Foreign key linking to sales.order_line. Business justification: Warehouse tasks are created to pick/pack specific order lines; the Order Line Fulfillment report requires this FK for performance tracking.',
    `employee_id` BIGINT COMMENT 'Identifier of the user who created the task record.',
    `primary_warehouse_employee_id` BIGINT COMMENT 'Identifier of the user who created the task record.',
    `storage_bin_id` BIGINT COMMENT 'Foreign key linking to inventory.bin. Business justification: Warehouse task source bin should reference bin entity',
    `warehouse_id` BIGINT COMMENT 'Identifier of the warehouse or distribution center where the task occurs.',
    `warehouse_updated_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified the task record.',
    `batch_number` STRING COMMENT 'Batch identifier when the material is batch‑controlled.',
    `completion_timestamp` TIMESTAMP COMMENT 'Timestamp when the task was successfully completed.',
    `cost_amount` DECIMAL(18,2) COMMENT 'Monetary cost associated with executing the task (labor, AGV usage, etc.).',
    `cost_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the task cost.. Valid values are `[A-Z]{3}`',
    `destination_bin_code` STRING COMMENT 'Warehouse bin code where the material is to be placed.',
    `exception_reason` STRING COMMENT 'Free-text description of why the task did not complete as planned.',
    `handling_instructions` STRING COMMENT 'Special instructions for handling the material (e.g., fragile, keep upright).',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the SKU is classified as hazardous and requires special handling.',
    `is_jis` BOOLEAN COMMENT 'Indicates if the task follows a JIS production sequence.',
    `is_jit` BOOLEAN COMMENT 'Indicates if the task is part of a JIT inventory strategy.',
    `lot_number` STRING COMMENT 'Lot identifier when the material is lot‑controlled.',
    `plant_code` STRING COMMENT 'Code of the manufacturing plant associated with the warehouse.',
    `priority` STRING COMMENT 'Business-assigned priority level for the task.. Valid values are `low|medium|high|critical`',
    `quantity` DECIMAL(18,2) COMMENT 'Number of units of the SKU to be moved or processed.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the task record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the task record.',
    `resource_code` BIGINT COMMENT 'Identifier of the operator (employee) or AGV unit assigned to the task.',
    `resource_type` STRING COMMENT 'Indicates whether the task is performed by a human operator or an automated guided vehicle.. Valid values are `operator|agv`',
    `serial_number_flag` BOOLEAN COMMENT 'True if the material is serialized and each unit has a unique serial number.',
    `sku_code` STRING COMMENT 'Master identifier of the material or component being moved.',
    `special_handling_flag` BOOLEAN COMMENT 'Indicates any additional non‑standard handling requirements.',
    `start_timestamp` TIMESTAMP COMMENT 'Timestamp when the operator or AGV began executing the task.',
    `task_created_timestamp` TIMESTAMP COMMENT 'Business event time when the warehouse task was generated/assigned.',
    `task_type` STRING COMMENT 'Category of the physical activity performed in the warehouse.. Valid values are `putaway|picking|replenishment|relocation|inventory_count`',
    `temperature_control_required` BOOLEAN COMMENT 'True if the material must be stored or moved under temperature-controlled conditions.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the quantity (e.g., pcs, kg).',
    `warehouse_task_status` STRING COMMENT 'Current lifecycle state of the task.. Valid values are `pending|in_progress|completed|exception|cancelled`',
    CONSTRAINT pk_warehouse_task PRIMARY KEY(`warehouse_task_id`)
) COMMENT 'Warehouse execution task record representing a discrete physical activity assigned to a warehouse operator or AGV (Automated Guided Vehicle), such as putaway, picking, replenishment, or relocation. Aligned with SAP EWM warehouse task. Captures task type, assigned resource (operator ID or AGV unit), source and destination bin, SKU and quantity, priority, creation time, start time, completion time, and exception reason if incomplete. Supports warehouse labor management and AGV fleet coordination. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`movement_type` (
    `movement_type_id` BIGINT COMMENT 'Surrogate primary key for each inventory movement type record. [canonical_skip_reason: REFERENCE_LOOKUP - classification table for movement types]',
    `gl_account_id` BIGINT COMMENT 'add column gl_account_id (BIGINT) with FK to finance.gl_account.gl_account_id - each movement type posts to specific GL accounts per SAP MM integration',
    `account_determination_relevant` BOOLEAN COMMENT 'Flag indicating whether the movement type triggers automatic account determination for financial posting.',
    `allowed_destination_location_type` STRING COMMENT 'Type of location permitted as the destination for this movement.',
    `allowed_source_location_type` STRING COMMENT 'Type of location permitted as the source for this movement (e.g., plant, warehouse, vendor).',
    `batch_management_required` BOOLEAN COMMENT 'Indicates if batch management must be maintained for movements of this type.',
    `movement_type_code` STRING COMMENT 'Alphanumeric code that uniquely identifies the movement type (e.g., 101 for goods receipt, 261 for goods issue).',
    `cost_center_required` BOOLEAN COMMENT 'Indicates if a cost center must be supplied when posting this movement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the movement type record was initially created in the source system.',
    `default_quantity_sign` STRING COMMENT 'Default sign (+1 or -1) applied to quantity for this movement type.',
    `movement_type_description` STRING COMMENT 'Human‑readable description of the movement type and its business purpose.',
    `direction` STRING COMMENT 'Indicates whether the movement adds stock (inbound), removes stock (outbound), or moves stock between locations (transfer).. Valid values are `inbound|outbound|transfer`',
    `effective_from` DATE COMMENT 'Date from which the movement type becomes valid for use.',
    `effective_until` DATE COMMENT 'Date after which the movement type is no longer valid (null if open‑ended).',
    `hazardous_material_allowed` BOOLEAN COMMENT 'Indicates whether hazardous materials may be moved using this movement type.',
    `inventory_accounting_relevant` BOOLEAN COMMENT 'Flag indicating whether the movement type affects inventory valuation and accounting.',
    `inventory_impact` STRING COMMENT 'Indicates whether the movement increases, decreases, or does not change stock levels.. Valid values are `increase|decrease|neutral`',
    `is_active` BOOLEAN COMMENT 'Indicates whether the movement type is currently active and usable in transactions.',
    `is_automated` BOOLEAN COMMENT 'Indicates whether postings of this movement type can be generated automatically by system processes.',
    `is_deprecated` BOOLEAN COMMENT 'True if the movement type is deprecated and should not be used for new transactions.',
    `is_jis` BOOLEAN COMMENT 'True if the movement type supports Just‑In‑Sequence production scheduling.',
    `is_jit` BOOLEAN COMMENT 'True if the movement type is used in Just‑In‑Time procurement processes.',
    `is_lot_tracked` BOOLEAN COMMENT 'True if lot (batch) tracking is mandatory for this movement type.',
    `is_serial_tracked` BOOLEAN COMMENT 'True if serial number tracking is mandatory for this movement type.',
    `movement_category` STRING COMMENT 'High‑level category grouping of movement types.. Valid values are `goods_receipt|goods_issue|transfer|physical_inventory|adjustment`',
    `movement_reason_code` STRING COMMENT 'Optional code that provides additional reason for the movement (e.g., scrap, rework).',
    `notes` STRING COMMENT 'Free‑form comments or additional information about the movement type.',
    `price_control` STRING COMMENT 'Method used for inventory valuation for this movement type.. Valid values are `standard|moving_average|none`',
    `profit_center_required` BOOLEAN COMMENT 'Indicates if a profit center must be supplied for this movement type.',
    `quality_inspection_required` BOOLEAN COMMENT 'Flag indicating whether a quality inspection record is mandatory for this movement.',
    `requires_approval` BOOLEAN COMMENT 'Indicates whether movements of this type must be approved before posting.',
    `reversal_allowed` BOOLEAN COMMENT 'Flag indicating whether this movement type can be reversed by another movement.',
    `reversal_movement_type_code` STRING COMMENT 'Code of the movement type that reverses this movement (e.g., 102 reverses 101).',
    `serial_number_required` BOOLEAN COMMENT 'Indicates if serial numbers must be captured for this movement type.',
    `special_stock_indicator` STRING COMMENT 'Identifies special stock categories (e.g., blocked stock, quality inspection stock) associated with the movement.. Valid values are `none|blocked|quality|consignment|project`',
    `system_defined` BOOLEAN COMMENT 'True if the movement type is delivered by SAP and cannot be deleted.',
    `tax_relevant` BOOLEAN COMMENT 'Flag indicating whether tax calculation is applicable for this movement.',
    `transaction_event` STRING COMMENT 'Business event that typically generates this movement type (e.g., purchase order receipt, production order issue).. Valid values are `purchase|production|sales|transfer|physical_inventory|adjustment`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the movement type record.',
    `valuation_class` STRING COMMENT 'Key used in valuation to determine price control and account assignment.',
    CONSTRAINT pk_movement_type PRIMARY KEY(`movement_type_id`)
) COMMENT 'Reference classification table defining all valid inventory movement types used in goods movement transactions. Captures movement type code, description, movement direction (inbound/outbound/transfer), account determination relevance, reversal movement type, and applicable business scenarios (e.g., 101=GR for PO, 261=GI for production order, 311=transfer posting). Aligned with SAP MM movement type configuration. Provides standardized classification for all goods movement transactions. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` (
    `dealer_sku_stock_id` BIGINT COMMENT 'Primary key for the DealerSkuStock association',
    `dealership_id` BIGINT COMMENT 'FK to the dealership record',
    `sku_master_id` BIGINT COMMENT 'FK to the SKU master record',
    `cost_per_unit` DECIMAL(18,2) COMMENT 'Cost per unit of the SKU for this dealership',
    `currency_code` STRING COMMENT 'Currency of the cost per unit',
    `lead_time_days` STRING COMMENT 'Lead time in days for replenishing the SKU at the dealership',
    `quantity_on_hand` BIGINT COMMENT 'Current quantity of the SKU available at the dealership',
    `reorder_point` BIGINT COMMENT 'Inventory level that triggers a reorder for the SKU at the dealership',
    `safety_stock` BIGINT COMMENT 'Safety stock quantity maintained for the SKU at the dealership',
    CONSTRAINT pk_dealer_sku_stock PRIMARY KEY(`dealer_sku_stock_id`)
) COMMENT 'Represents the inventory allocation of a specific SKU at a specific dealership. Each record captures operational stock attributes that are unique to the SKU‑dealership pairing.. Existence Justification: A SKU can be stocked at many dealership locations and a dealership stocks many SKUs. The business actively manages the stock level, reorder point, safety stock, lead time, cost and currency for each SKU at each dealership, creating a distinct inventory record per SKU‑dealership pair. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`warehouse` (
    `warehouse_id` BIGINT COMMENT 'Primary key for warehouse',
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
    `warehouse_status` STRING COMMENT 'Current lifecycle status of the warehouse.',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether the warehouse provides temperature‑controlled storage.',
    `warehouse_type` STRING COMMENT 'Category of warehouse based on its primary function.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the warehouse record.',
    `zone` STRING COMMENT 'Internal zone or area identifier within the warehouse complex.',
    CONSTRAINT pk_warehouse PRIMARY KEY(`warehouse_id`)
) COMMENT 'Master reference table for warehouse. Referenced by warehouse_id. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` (
    `inventory_hold_id` BIGINT COMMENT 'Unique identifier for the inventory hold record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Hold audit requires knowing which employee initiated the inventory hold; supports compliance and root‑cause analysis.',
    `recall_campaign_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_recall_campaign. Business justification: Recall management: holds placed due to a recall must reference the specific recall campaign.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: inventory_hold blocks stock for a SKU; linking to sku_master eliminates duplicate SKU identifier.',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to asset.spare_parts_catalog. Business justification: SPARE‑PART HOLD MANAGEMENT: Linking hold records to catalog items provides cost tracking and regulatory compliance for held spare parts.',
    `storage_location_id` BIGINT COMMENT 'Identifier of the warehouse or plant location where the hold applies.',
    `supplier_nonconformance_id` BIGINT COMMENT 'Identifier of the regulatory non-conformance case linked to the hold.',
    `actual_release_timestamp` TIMESTAMP COMMENT 'Date and time when the hold was actually released.',
    `batch_number` STRING COMMENT 'Batch or lot identifier for the inventory affected.',
    `comments` STRING COMMENT 'Free-text comments describing the hold context.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the hold record was created in the system.',
    `disposition_decision` STRING COMMENT 'Action to be taken after hold is released.. Valid values are `use_as_is|rework|scrap|return_to_supplier`',
    `expected_release_timestamp` TIMESTAMP COMMENT 'Planned date and time for hold release.',
    `hold_number` STRING COMMENT 'System-generated hold reference number.',
    `hold_source` STRING COMMENT 'Indicates whether the hold was generated automatically by the system or entered manually.. Valid values are `system|manual`',
    `hold_status` STRING COMMENT 'Current lifecycle status of the hold.. Valid values are `active|released|cancelled|expired`',
    `hold_type` STRING COMMENT 'Category of hold indicating reason source.. Valid values are `quality|engineering|regulatory|supplier|recall`',
    `initiating_department` STRING COMMENT 'Department that initiated the hold.. Valid values are `quality|engineering|procurement|production|logistics`',
    `is_critical_hold` BOOLEAN COMMENT 'Indicates if the hold is critical to production safety.',
    `lot_number` STRING COMMENT 'Lot identifier for traceability.',
    `quantity_held` DECIMAL(18,2) COMMENT 'Total quantity of items placed on hold.',
    `reason_code` STRING COMMENT 'Code representing specific reason for the hold as defined by quality or engineering.',
    `related_ecn_number` STRING COMMENT 'Reference to the ECN that triggered the hold, if applicable.',
    `related_ppap_status` STRING COMMENT 'Status of the supplier PPAP related to the hold.. Valid values are `failed|pending|approved`',
    `serial_number_end` STRING COMMENT 'Ending serial number in the range held.',
    `serial_number_start` STRING COMMENT 'Starting serial number in the range held (if serialized).',
    `start_timestamp` TIMESTAMP COMMENT 'Date and time when the hold became effective.',
    `unit_of_measure` STRING COMMENT 'Measurement unit for the held quantity.. Valid values are `EA|KG|L|SET`',
    `updated_by` STRING COMMENT 'User identifier who last modified the hold record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the hold record.',
    `created_by` STRING COMMENT 'User identifier who created the hold record.',
    CONSTRAINT pk_inventory_hold PRIMARY KEY(`inventory_hold_id`)
) COMMENT 'Inventory hold and block record restricting the use or movement of specific stock due to quality holds, engineering change notices (ECN), regulatory non-conformance, supplier PPAP failures, or recall investigations. Captures hold type, affected SKU/batch/serial range, quantity blocked, hold reason code, initiating department, hold start date, expected release date, and disposition decision (use-as-is, rework, scrap, return-to-supplier). Supports APQP/PPAP compliance and quality containment actions. [preservation_guardrail: verified]';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` (
    `storage_bin_id` BIGINT COMMENT 'Primary key for bin',
    `parent_bin_id` BIGINT COMMENT 'Self-referencing FK on bin (parent_bin_id)',
    `primary_storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Bin belongs to a storage location; add FK for hierarchy',
    `storage_location_id` BIGINT COMMENT 'Reference to the warehouse or plant location where the bin resides.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Bin is located within a warehouse; add FK to warehouse',
    `aisle` STRING COMMENT 'Aisle designation within the warehouse.',
    `barcode` STRING COMMENT 'Machine‑readable barcode identifier printed on the bin.',
    `bin_group` STRING COMMENT 'Logical grouping of bins for reporting or planning (e.g., zone, area).',
    `capacity_quantity` DECIMAL(18,2) COMMENT 'Maximum amount the bin can hold, expressed in the unit defined by capacity_unit.',
    `capacity_unit` STRING COMMENT 'Unit of measure for the bins capacity (e.g., kilograms, pieces).',
    `storage_bin_code` STRING COMMENT 'Business code assigned to the bin (e.g., alphanumeric location code).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the bin record was first created in the system.',
    `current_weight_kg` DECIMAL(18,2) COMMENT 'Current total weight of items stored in the bin.',
    `storage_bin_description` STRING COMMENT 'Free‑form description of the bin, its purpose, or special handling notes.',
    `effective_from` DATE COMMENT 'Date when the bin became operationally available.',
    `effective_until` DATE COMMENT 'Date when the bin is scheduled to be retired or decommissioned (null if open‑ended).',
    `hazardous_material_allowed` BOOLEAN COMMENT 'True if the bin may store hazardous components (e.g., batteries, chemicals).',
    `is_default` BOOLEAN COMMENT 'Indicates whether this bin is the default location for unspecified SKUs.',
    `is_reserved` BOOLEAN COMMENT 'True if the bin is reserved for a specific SKU or production order.',
    `last_inventory_count_date` DATE COMMENT 'Date of the most recent physical inventory count for the bin.',
    `last_inventory_count_quantity` DECIMAL(18,2) COMMENT 'Quantity recorded during the last inventory count.',
    `storage_bin_level` STRING COMMENT 'Vertical level of the bin on the rack.',
    `max_temperature_c` DECIMAL(18,2) COMMENT 'Maximum allowable temperature for temperature‑controlled bins.',
    `max_weight_kg` DECIMAL(18,2) COMMENT 'Maximum weight the bin can safely support.',
    `min_temperature_c` DECIMAL(18,2) COMMENT 'Minimum allowable temperature for temperature‑controlled bins.',
    `storage_bin_name` STRING COMMENT 'Human‑readable label or name of the bin used on warehouse floor.',
    `occupancy_percentage` DECIMAL(18,2) COMMENT 'Percentage of bin capacity currently utilized.',
    `owner_department` STRING COMMENT 'Business department responsible for the bin.',
    `rack` STRING COMMENT 'Rack designation within the aisle.',
    `reserved_for_sku` STRING COMMENT 'SKU identifier for which the bin is reserved (if any).',
    `storage_bin_status` STRING COMMENT 'Current lifecycle status of the bin.',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether the bin is climate‑controlled.',
    `storage_bin_type` STRING COMMENT 'Category of bin indicating its physical configuration or purpose.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the bin record.',
    CONSTRAINT pk_storage_bin PRIMARY KEY(`storage_bin_id`)
) COMMENT 'Master reference table for bin. Referenced by source_bin_id. [preservation_guardrail: verified]';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_batch_record_id` FOREIGN KEY (`batch_record_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`batch_record`(`batch_record_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_movement_type_id` FOREIGN KEY (`movement_type_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`movement_type`(`movement_type_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_reversal_of_movement_goods_movement_id` FOREIGN KEY (`reversal_of_movement_goods_movement_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`goods_movement`(`goods_movement_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_storage_bin_id` FOREIGN KEY (`storage_bin_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_bin`(`storage_bin_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_source_bin_id` FOREIGN KEY (`source_bin_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_bin`(`storage_bin_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ADD CONSTRAINT `fk_inventory_batch_record_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ADD CONSTRAINT `fk_inventory_batch_record_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ADD CONSTRAINT `fk_inventory_wip_order_stock_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ADD CONSTRAINT `fk_inventory_wip_order_stock_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_primary_replenishment_storage_location_id` FOREIGN KEY (`primary_replenishment_storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ADD CONSTRAINT `fk_inventory_safety_stock_policy_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ADD CONSTRAINT `fk_inventory_abc_xyz_classification_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ADD CONSTRAINT `fk_inventory_obsolescence_review_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ADD CONSTRAINT `fk_inventory_kanban_card_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ADD CONSTRAINT `fk_inventory_warehouse_task_storage_bin_id` FOREIGN KEY (`storage_bin_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_bin`(`storage_bin_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ADD CONSTRAINT `fk_inventory_warehouse_task_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ADD CONSTRAINT `fk_inventory_dealer_sku_stock_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ADD CONSTRAINT `fk_inventory_warehouse_parent_warehouse_id` FOREIGN KEY (`parent_warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ADD CONSTRAINT `fk_inventory_inventory_hold_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ADD CONSTRAINT `fk_inventory_inventory_hold_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ADD CONSTRAINT `fk_inventory_storage_bin_parent_bin_id` FOREIGN KEY (`parent_bin_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_bin`(`storage_bin_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ADD CONSTRAINT `fk_inventory_storage_bin_primary_storage_location_id` FOREIGN KEY (`primary_storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ADD CONSTRAINT `fk_inventory_storage_bin_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ADD CONSTRAINT `fk_inventory_storage_bin_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`inventory` SET TAGS ('dbx_pii_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`inventory` SET TAGS ('dbx_pii_domain' = 'inventory');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'SKU Master Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Product Owner Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_pii_business_glossary_term' = 'Country of Origin');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `customs_tariff_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Customs Tariff Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_description` SET TAGS ('dbx_pii_business_glossary_term' = 'SKU Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `ean13` SET TAGS ('dbx_pii_business_glossary_term' = 'EAN‑13 Barcode');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `ean13` SET TAGS ('dbx_pii_value_regex' = '^d{13}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `hazardous_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Class');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `hazardous_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `height_cm` SET TAGS ('dbx_pii_business_glossary_term' = 'Height (Centimeters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `last_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Purchase Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `length_cm` SET TAGS ('dbx_pii_business_glossary_term' = 'Length (Centimeters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `lot_controlled_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Controlled Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `material_group` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `material_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `max_order_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `min_order_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `mrp_controller` SET TAGS ('dbx_pii_business_glossary_term' = 'MRP Controller');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `mrp_type` SET TAGS ('dbx_pii_business_glossary_term' = 'MRP Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `mrp_type` SET TAGS ('dbx_pii_value_regex' = 'PD|VB|FO|...');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `procurement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Procurement Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `procurement_type` SET TAGS ('dbx_pii_value_regex' = 'E|I|M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `product_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Product Category');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `product_subcategory` SET TAGS ('dbx_pii_business_glossary_term' = 'Product Subcategory');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `reorder_point_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `safety_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `serial_controlled_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Controlled Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Shelf Life (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_code` SET TAGS ('dbx_pii_business_glossary_term' = 'SKU Code (Stock Keeping Unit)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_status` SET TAGS ('dbx_pii_business_glossary_term' = 'SKU Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_master_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|discontinued|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `sku_name` SET TAGS ('dbx_pii_business_glossary_term' = 'SKU Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `standard_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `tax_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Indicator');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M|CM|MM');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `upc` SET TAGS ('dbx_pii_business_glossary_term' = 'UPC Barcode');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `upc` SET TAGS ('dbx_pii_value_regex' = '^d{12}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `valuation_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Class');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `volume_m3` SET TAGS ('dbx_pii_business_glossary_term' = 'Volume (Cubic Meters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight (Kilograms)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ALTER COLUMN `width_cm` SET TAGS ('dbx_pii_business_glossary_term' = 'Width (Centimeters)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location ID (SLID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier (PID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Responsible Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Identifier (WID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 1 (ADDR1)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 2 (ADDR2)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `agv_routing_priority` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Routing Priority (AGV_PRIO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `aisle` SET TAGS ('dbx_pii_business_glossary_term' = 'Aisle Identifier (AISLE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `bin` SET TAGS ('dbx_pii_business_glossary_term' = 'Bin Identifier (BIN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `capacity_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Capacity Quantity (SCQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `capacity_uom` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City (CITY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code (ISO3)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_value_regex' = 'USA|CAN|MEX|DEU|FRA|GBR');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Description (SLD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date (EFD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date (EUD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `external_system_source` SET TAGS ('dbx_pii_business_glossary_term' = 'External System Source (ESS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `external_system_source` SET TAGS ('dbx_pii_value_regex' = 'SAP_WM|Oracle_WMS|Custom');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `fire_safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Fire Safety Rating (FSR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `fire_safety_rating` SET TAGS ('dbx_pii_value_regex' = 'A|B|C|D');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `hazardous_material_allowed` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Allowed Flag (HMAF)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `inventory_accuracy_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Accuracy Percentage (IAP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `is_default_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Default Location Flag (DLF)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `last_inventory_count_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inventory Count Date (LICD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude (LAT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Code (SLC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Name (SLN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Type (SLT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `location_type` SET TAGS ('dbx_pii_value_regex' = 'bulk|rack|floor|cold_chain|automated|quarantine');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude (LON)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code (POSTAL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `rack` SET TAGS ('dbx_pii_business_glossary_term' = 'Rack Identifier (RACK)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `state` SET TAGS ('dbx_pii_business_glossary_term' = 'State/Province (STATE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Status (SLS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `storage_location_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|maintenance|closed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Controlled Flag (TCF)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `temperature_range_celsius` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Range Celsius (TRC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `used_capacity_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Used Capacity Percentage (UCP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ALTER COLUMN `zone` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Zone (WZ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `stock_balance_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Balance ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `blocked_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Blocked Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `consignment_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Consignment Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CNY|GBP|CHF');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `goods_movement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Goods Movement Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `goods_movement_type` SET TAGS ('dbx_pii_value_regex' = '101|102|201|202|301|311');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `in_transit_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'In‑Transit Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `is_serialized` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Serialized');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `last_movement_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Goods Movement Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'unrestricted|quality_inspection|blocked|consignment|in_transit|safety');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `manufacturing_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `physical_location_hierarchy` SET TAGS ('dbx_pii_business_glossary_term' = 'Physical Location Hierarchy');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Purchase Order Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quality_inspection_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quality_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quality_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity On Hand');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `safety_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `stock_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Category');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `stock_category` SET TAGS ('dbx_pii_value_regex' = 'raw_material|component|finished_good|service_part|spare_part');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `supplier_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `unrestricted_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Unrestricted Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_area_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Area Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ALTER COLUMN `valuation_type` SET TAGS ('dbx_pii_value_regex' = 'standard|moving_average|fifo|lifo');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `goods_movement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Goods Movement ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `agv_movement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'AGV Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `batch_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Posted By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `movement_type_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Type Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `part_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Identifier (MAT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Posted By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `primary_party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Purchase Order ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `reversal_of_movement_goods_movement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Of Movement ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `amount_local` SET TAGS ('dbx_pii_business_glossary_term' = 'Local Currency Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `amount_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'USD Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `base_uom` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `destination_plant` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Plant (PLT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `destination_storage_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Storage Location (SL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `goods_movement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `goods_movement_status` SET TAGS ('dbx_pii_value_regex' = 'posted|reversed|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `inspection_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Document Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `is_automated` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Movement Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `is_lot_tracked` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Tracked Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `is_serial_tracked` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Tracked Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `line_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `location_zone` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Zone');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `movement_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Reason (Reason)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `movement_reason` SET TAGS ('dbx_pii_value_regex' = 'Production|Sales|Repair|Scrap|Transfer');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `posting_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|not_required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity (Qty)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Reference Document Number (RefDocNo)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `reference_document_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Reference Document Type (RefDocType)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `reference_document_type` SET TAGS ('dbx_pii_value_regex' = 'PO|PR|WO|DO|SA');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `source_plant` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Plant (PLT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `valuation_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `valuation_type` SET TAGS ('dbx_pii_value_regex' = 'Standard|MovingAverage|FIFO|LIFO');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_transfer_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Transfer Order ID (STO_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `storage_bin_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Bin Identifier (DST_BIN_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Plant Identifier (DST_PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Picker Employee Identifier (PICKER_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `primary_stock_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Picker Employee Identifier (PICKER_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `primary_stock_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `primary_stock_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `source_bin_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Bin Identifier (SRC_BIN_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `source_plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Plant Identifier (SRC_PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_created_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User Identifier (CREATED_BY_UID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_created_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_created_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_created_by_user_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_updated_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Identifier (UPDATED_BY_UID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_updated_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_updated_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `tertiary_stock_updated_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Identifier (UPDATED_BY_UID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `tertiary_stock_updated_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `tertiary_stock_updated_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `agv_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Guided Vehicle Identifier (AGV_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number (BATCH_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Confirmation Status (CONFIRM_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|confirmed|rejected');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `cost_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Cost Amount (COST_AMT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code (COST_CENTER_CD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `cost_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Currency Code (COST_CURR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `execution_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Execution End Timestamp (EXEC_END_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `execution_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Execution Start Timestamp (EXEC_START_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `handling_instructions` SET TAGS ('dbx_pii_business_glossary_term' = 'Handling Instructions (HANDLING_INSTR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag (IS_HAZARDOUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `is_jis` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-In-Sequence Flag (IS_JIS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `is_jit` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-In-Time Flag (IS_JIT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number (LOT_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `material_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Description (MAT_DESC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `material_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Number (MATNR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `movement_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Reason Code (MOVE_REASON_CD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `movement_reason_code` SET TAGS ('dbx_pii_value_regex' = 'stock_replenishment|production|maintenance|scrap|return|adjustment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Priority (PRIORITY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `project_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Project Number (PROJ_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Quantity (TRANSFER_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created Timestamp (AUDIT_CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated Timestamp (AUDIT_UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serialized Material Flag (IS_SERIALIZED)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `special_handling_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Special Handling Flag (IS_SPECIAL_HANDLING)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_transfer_order_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Order Status (TO_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `stock_transfer_order_status` SET TAGS ('dbx_pii_value_regex' = 'draft|planned|released|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Control Required Flag (TEMP_CTRL_REQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Order Creation Timestamp (TO_CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Order Number (TO_NUM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Type (TO_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `transfer_type` SET TAGS ('dbx_pii_value_regex' = 'plant_to_plant|plant_to_warehouse|warehouse_to_warehouse|replenishment|return|adjustment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M|BOX|PACK');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `mrp_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Requirements Planning (MRP) Requirement ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Planner ID (PLNR_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Planner ID (PLNR_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier ID (SUPP_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `batch_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Management Flag (BATCH_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `demand_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Demand Source (DEMAND_SRC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `demand_source` SET TAGS ('dbx_pii_value_regex' = 'forecast|sales_order|production|stock_transfer');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `exception_message` SET TAGS ('dbx_pii_business_glossary_term' = 'Exception Message (EXC_MSG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time in Days (LT_DAYS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `lot_size` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Size Quantity (LOT_SZ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `material_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Number (MATNR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `material_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{18}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `mrp_requirement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Requirement Lifecycle Status (REQ_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `mrp_requirement_status` SET TAGS ('dbx_pii_value_regex' = 'planned|released|cancelled|exception');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `planning_horizon_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Planning Horizon (PLAN_HORIZON)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_pii_business_glossary_term' = 'Planning Scenario (PLAN_SCEN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `planning_scenario` SET TAGS ('dbx_pii_value_regex' = 'MPS|MRP|DRP');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code (PLANT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `priority_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority Code (PRIO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `priority_code` SET TAGS ('dbx_pii_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `quantity_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Required Quantity (QTY_REQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `reorder_point` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point Quantity (ROP_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Planned Requirement Date (REQ_DATE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_number` SET TAGS ('dbx_pii_business_glossary_term' = 'MRP Requirement Number (REQ_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Requirement Type (REQ_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `requirement_type` SET TAGS ('dbx_pii_value_regex' = 'independent|dependent');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `safety_stock` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity (SS_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_pii_business_glossary_term' = 'Source of Supply (SUPPLY_SRC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_pii_value_regex' = 'internal|external');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `cycle_count_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Count Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Counter Employee Identifier (COUNTER_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Identifier (PLANT_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Counter Employee Identifier (COUNTER_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Keeping Unit Identifier (SKU_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Location Identifier (LOC_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `abc_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'ABC Classification (ABC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `abc_classification` SET TAGS ('dbx_pii_value_regex' = 'A|B|C');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp (APP_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By Employee Identifier (APPROVER_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `book_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Book Quantity (BQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `compliance_iatf16949_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'IATF 16949 Compliance Flag (IATF_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `compliance_nhtsa_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'NHTSA Compliance Flag (NHTSA_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code (CC_CODE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `count_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Count Date (CD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `count_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Count Document Number (CDN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `count_frequency_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Count Frequency (DAYS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `count_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Count Status (CS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `count_status` SET TAGS ('dbx_pii_value_regex' = 'planned|counted|posted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `count_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Count Type (CT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `count_type` SET TAGS ('dbx_pii_value_regex' = 'full|partial|cycle');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `counted_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Counted Quantity (CQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `inventory_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Category (INV_CAT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `inventory_category` SET TAGS ('dbx_pii_value_regex' = 'raw_material|component|wip|finished_goods|service_part');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `is_locked` SET TAGS ('dbx_pii_business_glossary_term' = 'Lock Flag (LOCK_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `is_obsolete` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolete Flag (OBSOLETE_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `last_count_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Count Date (LAST_CD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number (LOT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `method` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Count Method (CC_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `method` SET TAGS ('dbx_pii_value_regex' = 'manual|automated|RFID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `next_scheduled_count_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Scheduled Count Date (NEXT_CD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `physical_inventory_doc_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Physical Inventory Document Type (PID_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `physical_inventory_doc_type` SET TAGS ('dbx_pii_value_regex' = 'MI01|MI07');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `posted_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Posted By Employee Identifier (POSTED_BY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `posted_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Posted Timestamp (POSTED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `recount_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Recount Flag (RC_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `recount_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Recount Sequence Number (RC_NUM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `remarks` SET TAGS ('dbx_pii_business_glossary_term' = 'Remarks (RMKS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `reorder_point_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point Quantity (ROP_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity (SS_QTY)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number Flag (SN_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `storage_bin` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Bin Code (BIN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `variance_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Variance Percentage (VPCT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `variance_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Variance (QV)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ALTER COLUMN `variance_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Variance Reason (VR)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Classification');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_classification` SET TAGS ('dbx_pii_value_regex' = 'raw|component|finished|service');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_owner_department` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Owner Department');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `batch_status` SET TAGS ('dbx_pii_value_regex' = 'created|released|quarantined|consumed|archived');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `compliance_carb_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'CARB Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `compliance_iatf16949_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'IATF 16949 Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `expiration_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `expiration_status` SET TAGS ('dbx_pii_value_regex' = 'valid|near_expiry|expired');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `last_inspection_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inspection User');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `lot_traceability_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Traceability Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `manufacturing_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `material_grade` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Grade');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `material_grade` SET TAGS ('dbx_pii_value_regex' = 'A|B|C|D');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `production_site_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Site Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `quality_inspection_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_pii_value_regex' = 'pending|passed|failed|rework');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `quality_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Score');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `quantity_in_base_units` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity (Base Units)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `restricted_use_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Restricted Use Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `supplier_lot_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Lot Reference');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `tensile_strength_mpa` SET TAGS ('dbx_pii_business_glossary_term' = 'Tensile Strength (MPa)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'kg|l|pcs|m|cm|g');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Serialized Unit ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Installed By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `associated_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `associated_vin` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number (BN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `calibration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `calibration_due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Due Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `capacity_ah` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity (Ah)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending|exempt');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `component_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Type (CT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `component_type` SET TAGS ('dbx_pii_value_regex' = 'ECU|Battery|ADAS_Sensor|Transmission|Gearbox|Infotainment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (CC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_pii_business_glossary_term' = 'Dimensions (mm)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Firmware Version (FW)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `health_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Health Status (HS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `health_status` SET TAGS ('dbx_pii_value_regex' = 'good|fair|poor|critical');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `health_status` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `health_status` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `installation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Status (IS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `installation_status` SET TAGS ('dbx_pii_value_regex' = 'not_installed|installed_in_vehicle|installed_in_test|installed_in_service');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `is_defective` SET TAGS ('dbx_pii_business_glossary_term' = 'Defective Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `last_service_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Service Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number (LN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `manufacture_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacture Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `purchase_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Purchase Price (PP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `purchase_price` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `purchase_price` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `receipt_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `safety_certification_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Certification Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number (SN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `serialized_unit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status (LS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `serialized_unit_status` SET TAGS ('dbx_pii_value_regex' = 'in_stock|installed|returned|scrapped|reserved|under_repair');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `supplier_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Code (SC)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `voltage_nominal` SET TAGS ('dbx_pii_business_glossary_term' = 'Nominal Voltage (V)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `wip_order_stock_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Work-in-Progress Order Stock ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `production_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `backflush_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Backflush Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `component_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `cost_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Component Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `inventory_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `inventory_status` SET TAGS ('dbx_pii_value_regex' = 'available|allocated|in_process|scrapped|reserved|on_hold');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `issued_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Issued Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `line_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `operation_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Operation Sequence');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `remarks` SET TAGS ('dbx_pii_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `required_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Required Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `scrap_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Scrap Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `uom` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `uom` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M|PCS|SET');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `wip_order_stock_status` SET TAGS ('dbx_pii_business_glossary_term' = 'WIP Line Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ALTER COLUMN `wip_order_stock_status` SET TAGS ('dbx_pii_value_regex' = 'open|closed|released|cancelled|pending|completed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Finished Vehicle Stock ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `invoice_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `primary_dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `aging_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Aging Days');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `allocation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `color` SET TAGS ('dbx_pii_business_glossary_term' = 'Exterior Color');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `current_location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Location Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `delivery_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `emission_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `expected_delivery_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expected Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `hold_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `hold_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Reason');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `location_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `location_type` SET TAGS ('dbx_pii_value_regex' = 'compound|yard|warehouse|dealer|in_transit');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `model_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `msrp` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'EV|ICE|HEV|PHEV');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `production_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `production_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `recall_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `stock_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `stock_status` SET TAGS ('dbx_pii_value_regex' = 'in_production|pdi_pending|pdi_complete|allocated|in_transit|delivered');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `trim_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `vin` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `service_parts_stock_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Parts Stock ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Issued To Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Location ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `aisle` SET TAGS ('dbx_pii_business_glossary_term' = 'Aisle');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `bin_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bin Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `cost_per_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Per Unit');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CAD|GBP');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `cycle_count_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Count Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `cycle_count_status` SET TAGS ('dbx_pii_value_regex' = 'due|overdue|completed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `inventory_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `inventory_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|blocked');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_cost_update_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Cost Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_count_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Count Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_issue_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Issue Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `last_receipt_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `max_stock_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Stock Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `min_stock_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Stock Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Reason');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `obsolescence_status` SET TAGS ('dbx_pii_value_regex' = 'active|obsolete|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `part_revision` SET TAGS ('dbx_pii_business_glossary_term' = 'Part Revision');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `quantity_available` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Available');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `quantity_committed` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Committed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity On Hand');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `reorder_point` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `safety_stock` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `shelf` SET TAGS ('dbx_pii_business_glossary_term' = 'Shelf');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `supersession_part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Supersession Part Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `valuation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Method');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `valuation_method` SET TAGS ('dbx_pii_value_regex' = 'standard|fifo|lifo|average');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warranty_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ALTER COLUMN `warranty_status` SET TAGS ('dbx_pii_value_regex' = 'in_warranty|out_of_warranty');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `replenishment_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Order ID (ROID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Storage Location Identifier (DSLI)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `primary_replenishment_storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Storage Location Identifier (SSLI)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Identifier (SUP_ID)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Requested By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `trade_compliance_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade Compliance Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Delivery Timestamp (ADT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number (BN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `cost_per_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Per Unit (CPU)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Request Timestamp (RRT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `fulfillment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Fulfillment Status (FS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `fulfillment_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|completed|failed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Part Indicator (CPI)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Modified By User (RLMU)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time in Days (LTD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number (LOT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `max_stock_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Stock Level (XSL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `min_stock_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Stock Level (MSL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes (NOTE)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Order Number (RON)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Order Status (ROS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_status` SET TAGS ('dbx_pii_value_regex' = 'draft|open|released|fulfilled|cancelled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Order Type (ROT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `order_type` SET TAGS ('dbx_pii_value_regex' = 'kanban|min_max|jit_pull|jis_sequence');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Priority Level (RPL)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Promised Delivery Date (PDD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `replenishment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Method (RM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `replenishment_method` SET TAGS ('dbx_pii_value_regex' = 'automatic|manual');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Requested Delivery Date (RDD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `requested_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Requested Quantity (RQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity (SSQ)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number (SN)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `trigger_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Trigger Source (RTS)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `trigger_source` SET TAGS ('dbx_pii_value_regex' = 'production_schedule|reorder_point|manual|system');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `uom` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `uom` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M|BOX');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created By User (RCBU)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consignment_stock_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Consignment Stock ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `aging_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Aging (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consignment_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Consignment Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consignment_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Consignment Reference');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consignment_stock_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Consignment Stock Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consignment_stock_status` SET TAGS ('dbx_pii_value_regex' = 'available|reserved|consumed|settled|blocked');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consignment_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Consignment Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consignment_type` SET TAGS ('dbx_pii_value_regex' = 'JIT|JIS|standard');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `consumption_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Consumption Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `contract_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Contract Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `is_batch_managed` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Batch Managed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `is_serialized` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Serialized');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `last_movement_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Movement Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `last_settlement_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `material_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `material_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Material Number (SAP)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity On Hand');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `receipt_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `reorder_point` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `safety_stock` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `settlement_due_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement‑Due Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `settlement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `settlement_status` SET TAGS ('dbx_pii_value_regex' = 'pending|settled|disputed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `stock_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Category');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `stock_category` SET TAGS ('dbx_pii_value_regex' = 'raw_material|component|finished_goods|service_part|spare_part');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `storage_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M|PCS|SET');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `valuation_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `valuation_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Currency');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `valuation_currency` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|GBP|CNY|CHF');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `valuation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Method');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ALTER COLUMN `valuation_method` SET TAGS ('dbx_pii_value_regex' = 'standard_cost|moving_average|fifo|lifo');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `inventory_valuation_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Valuation ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `area` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Area');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CNY|GBP|CHF');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `last_valuation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Valuation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `moving_average_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Moving Average Price (Currency per Base Unit)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `obsolescence_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `period` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Period');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `price_control` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Control Indicator');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `price_control` SET TAGS ('dbx_pii_value_regex' = 'standard|moving_average');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `price_variance` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Variance (Currency per Base Unit)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `standard_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Price (Currency per Base Unit)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `total_stock_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Stock Quantity (Base Units)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `total_stock_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Stock Value (Currency)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `valuation_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Class');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `valuation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `valuation_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `valuation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `valuation_status` SET TAGS ('dbx_pii_value_regex' = 'draft|in_progress|finalized|reversed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ALTER COLUMN `write_down_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Write‑Down Amount (Currency)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_policy_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Policy Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `demand_variability_factor` SET TAGS ('dbx_pii_business_glossary_term' = 'Demand Variability Factor');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `last_recalculation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Recalculation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Policy Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'draft|approved|implemented|retired');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `location_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `maximum_stock_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Stock Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Policy Notes');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `policy_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Policy Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `policy_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Policy Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `policy_type` SET TAGS ('dbx_pii_value_regex' = 'safety_stock|reorder_point|max_stock');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `reorder_point` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `review_cycle_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Cycle (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Calculation Method');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_method` SET TAGS ('dbx_pii_value_regex' = 'statistical|fixed|dynamic');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_policy_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Policy Operational Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_policy_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Source');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `safety_stock_source` SET TAGS ('dbx_pii_value_regex' = 'system|manual|external');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `service_level_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Level Target (Percent)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`safety_stock_policy` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `abc_xyz_classification_id` SET TAGS ('dbx_pii_business_glossary_term' = 'ABC/XYZ Classification Record ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `abc_class` SET TAGS ('dbx_pii_business_glossary_term' = 'ABC Classification (A=High Value, B=Medium, C=Low)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `abc_class` SET TAGS ('dbx_pii_value_regex' = 'A|B|C');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `abc_xyz_classification_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Classification Record Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `abc_xyz_classification_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending_review|retired');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `annual_consumption_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Annual Consumption Value (USD)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `annual_consumption_value` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `classification_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Classification Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `classification_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Classification Method');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `classification_method` SET TAGS ('dbx_pii_value_regex' = 'pareto|custom|automated');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `consumption_frequency_per_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Consumption Frequency Per Year');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `cycle_count_frequency_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Cycle Count Frequency (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `is_obsolete` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolete Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `next_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Classification Notes');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity (Units)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `xyz_class` SET TAGS ('dbx_pii_business_glossary_term' = 'XYZ Classification (X=Stable, Y=Variable, Z=Irregular)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`abc_xyz_classification` ALTER COLUMN `xyz_class` SET TAGS ('dbx_pii_value_regex' = 'X|Y|Z');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `obsolescence_review_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Review ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reviewer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Reviewer ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `reviewer_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `compliance_carb_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'CARB Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `compliance_iatf16949_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'IATF 16949 Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `days_since_last_movement` SET TAGS ('dbx_pii_business_glossary_term' = 'Days Since Last Movement');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `disposition_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposition Reason');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `eop_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'End‑of‑Production Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `estimated_write_down_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Write‑Down Value');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `is_critical` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Obsolescence Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `last_movement_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Movement Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `manufacturing_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Notes');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,5}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `recommended_disposition` SET TAGS ('dbx_pii_business_glossary_term' = 'Recommended Disposition');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `recommended_disposition` SET TAGS ('dbx_pii_value_regex' = 'continue|markdown|scrap|return_to_supplier|donate');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `review_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Review Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `review_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `review_status` SET TAGS ('dbx_pii_value_regex' = 'draft|pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `risk_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolescence Risk Score');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `safety_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `sku` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `sku` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `stock_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `supplier_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `supplier_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ALTER COLUMN `valuation_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Price per Unit');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `kanban_card_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Kanban Card ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `card_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Kanban Card Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `card_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `card_number` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `cards_in_circulation` SET TAGS ('dbx_pii_business_glossary_term' = 'Cards In Circulation');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `consuming_work_center` SET TAGS ('dbx_pii_business_glossary_term' = 'Consuming Work Center');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `container_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Container Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `container_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `container_type` SET TAGS ('dbx_pii_value_regex' = 'bin|pallet|box|tote|crate');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `kanban_card_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Kanban Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `is_jis_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Just‑In‑Sequence Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `is_jit_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Just‑In‑Time Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `kanban_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Kanban Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `kanban_status` SET TAGS ('dbx_pii_value_regex' = 'empty|in_transit|full|blocked');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `last_consumption_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Consumption Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `last_signal_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Signal Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `lot_control_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Control Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Kanban Notes');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `production_line` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `reorder_point_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `replenishment_strategy` SET TAGS ('dbx_pii_business_glossary_term' = 'Replenishment Strategy');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `replenishment_strategy` SET TAGS ('dbx_pii_value_regex' = 'internal|external|in_house_production');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `safety_stock_qty` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `serial_control_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Control Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `signal_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Method');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `signal_method` SET TAGS ('dbx_pii_value_regex' = 'physical|electronic|barcode');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `supply_area` SET TAGS ('dbx_pii_business_glossary_term' = 'Supply Area Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'pcs|kg|liter|meter');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `ckd_skd_kit_id` SET TAGS ('dbx_pii_business_glossary_term' = 'CKD/SKD Kit Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `primary_ckd_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `primary_ckd_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `primary_ckd_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Procurement Supplier Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `model_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `actual_arrival_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `bom_reference_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials Reference Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `completeness_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Kit Completeness Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `completeness_status` SET TAGS ('dbx_pii_value_regex' = 'complete|partial|missing_parts');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `container_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `customs_tariff_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Customs Tariff Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `customs_valuation_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Customs Valuation Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `customs_valuation_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Customs Valuation Currency');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `documentation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Documentation Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `documentation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|submitted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `expected_arrival_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expected Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `export_country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Export Country Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `export_country_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `export_document_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Export Document Reference');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `inventory_accuracy_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Accuracy Percent');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `is_jis_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Just‑In‑Sequence Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `is_jit_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Just‑In‑Time Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `is_obsolete_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Obsolete Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `kit_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Kit Category (KIT_CAT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `kit_category` SET TAGS ('dbx_pii_value_regex' = 'CKD|SKD|Mixed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `kit_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Kit Name (KIT_NAME)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `kit_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Kit Number (KIT_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `kit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Kit Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `kit_status` SET TAGS ('dbx_pii_value_regex' = 'created|packed|shipped|in_transit|arrived|closed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `last_inventory_count_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inventory Count Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `missing_parts_list` SET TAGS ('dbx_pii_business_glossary_term' = 'Missing Parts List');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `packing_list_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Packing List Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `serial_numbers` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Numbers List');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `shipping_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Shipping Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_pii_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `supplier_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `target_assembly_plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Assembly Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `target_assembly_plant_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Assembly Plant Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Control Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `total_volume_m3` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Kit Volume (M3)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `total_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Kit Weight (KG)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `transfer_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `transfer_price_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Transfer Price Currency');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `transfer_price_incoterms` SET TAGS ('dbx_pii_business_glossary_term' = 'Incoterms for Transfer Price');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `transfer_price_incoterms` SET TAGS ('dbx_pii_value_regex' = 'EXW|FCA|FOB|CFR|CIF|DDP');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `valuation_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Kit Valuation Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ALTER COLUMN `valuation_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Kit Valuation Currency');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Adjustment ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_updated_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_updated_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_updated_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `quaternary_adjustment_updated_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `quaternary_adjustment_updated_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `quaternary_adjustment_updated_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `tertiary_adjustment_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `tertiary_adjustment_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `tertiary_adjustment_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `accounting_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounting Document Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Adjustment Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_status` SET TAGS ('dbx_pii_value_regex' = 'draft|submitted|approved|rejected|posted|cancelled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `adjustment_type` SET TAGS ('dbx_pii_value_regex' = 'count_variance|damage|theft|system_error|process_correction');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `approver_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Approver Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Comments');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `cost_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Currency');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `cost_currency` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `cost_impact_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Impact Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `is_approved` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Approved');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `is_manual` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Manual Adjustment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `posting_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `project_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Project Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `quantity_adjusted` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Adjusted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Reason Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `reason_code` SET TAGS ('dbx_pii_value_regex' = 'RC01|RC02|RC03|RC04|RC05|RC06');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `reason_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Adjustment Reason Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `related_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Related Document Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `tax_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Indicator');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `tax_indicator` SET TAGS ('dbx_pii_value_regex' = 'taxable|non_taxable');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|M|BOX');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ALTER COLUMN `valuation_area_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Area Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `warehouse_task_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Task Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `order_line_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_employee_ref' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `primary_warehouse_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `primary_warehouse_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `primary_warehouse_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `storage_bin_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Bin Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `warehouse_updated_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `warehouse_updated_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `warehouse_updated_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Task Completion Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `cost_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Task Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `cost_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Task Cost Currency');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `cost_currency` SET TAGS ('dbx_pii_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `destination_bin_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Bin Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `exception_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Task Exception Reason');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `handling_instructions` SET TAGS ('dbx_pii_business_glossary_term' = 'Handling Instructions');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `is_jis` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-In-Sequence Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `is_jit` SET TAGS ('dbx_pii_business_glossary_term' = 'Just-In-Time Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Task Priority');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Task Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `resource_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Resource Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `resource_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Resource Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `resource_type` SET TAGS ('dbx_pii_value_regex' = 'operator|agv');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `serial_number_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `sku_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Keeping Unit Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `special_handling_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Special Handling Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Task Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `task_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Task Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `task_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Task Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `task_type` SET TAGS ('dbx_pii_value_regex' = 'putaway|picking|replenishment|relocation|inventory_count');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Control Required Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `warehouse_task_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Task Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ALTER COLUMN `warehouse_task_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|completed|exception|cancelled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `movement_type_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Movement Type ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `account_determination_relevant` SET TAGS ('dbx_pii_business_glossary_term' = 'Account Determination Relevant');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `allowed_destination_location_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Allowed Destination Location Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `allowed_source_location_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Allowed Source Location Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `batch_management_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Management Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `movement_type_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Type Code (MT)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `cost_center_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `default_quantity_sign` SET TAGS ('dbx_pii_business_glossary_term' = 'Default Quantity Sign');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `movement_type_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Type Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `direction` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Direction');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `direction` SET TAGS ('dbx_pii_value_regex' = 'inbound|outbound|transfer');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `hazardous_material_allowed` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Allowed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `inventory_accounting_relevant` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Accounting Relevant');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `inventory_impact` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Impact');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `inventory_impact` SET TAGS ('dbx_pii_value_regex' = 'increase|decrease|neutral');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `is_automated` SET TAGS ('dbx_pii_business_glossary_term' = 'Automated Posting Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `is_deprecated` SET TAGS ('dbx_pii_business_glossary_term' = 'Deprecated Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `is_jis` SET TAGS ('dbx_pii_business_glossary_term' = 'Just‑In‑Sequence Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `is_jit` SET TAGS ('dbx_pii_business_glossary_term' = 'Just‑In‑Time Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `is_lot_tracked` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Tracking Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `is_serial_tracked` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Tracking Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `movement_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Category');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `movement_category` SET TAGS ('dbx_pii_value_regex' = 'goods_receipt|goods_issue|transfer|physical_inventory|adjustment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `movement_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Reason Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Movement Type Notes');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `price_control` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Control');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `price_control` SET TAGS ('dbx_pii_value_regex' = 'standard|moving_average|none');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `profit_center_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Quality Inspection Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `requires_approval` SET TAGS ('dbx_pii_business_glossary_term' = 'Requires Approval');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `reversal_allowed` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Allowed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `reversal_movement_type_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Reversal Movement Type Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `serial_number_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number Required');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `special_stock_indicator` SET TAGS ('dbx_pii_business_glossary_term' = 'Special Stock Indicator');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `special_stock_indicator` SET TAGS ('dbx_pii_value_regex' = 'none|blocked|quality|consignment|project');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `system_defined` SET TAGS ('dbx_pii_business_glossary_term' = 'System Defined Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `tax_relevant` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Relevant');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `transaction_event` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Event');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `transaction_event` SET TAGS ('dbx_pii_value_regex' = 'purchase|production|sales|transfer|physical_inventory|adjustment');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ALTER COLUMN `valuation_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Valuation Class');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` SET TAGS ('dbx_pii_association_edges' = 'inventory.sku_master,dealer.dealership');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `dealer_sku_stock_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealerskustock - Dealer Sku Stock Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealerskustock - Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealerskustock - Sku Master Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `cost_per_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit Cost');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_pii_business_glossary_term' = 'On Hand Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `reorder_point` SET TAGS ('dbx_pii_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ALTER COLUMN `safety_stock` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Stock');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `parent_warehouse_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Warehouse Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `parent_warehouse_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `capacity_cubic_m` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Cubic M');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `capacity_sqft` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Sqft');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `close_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Close Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `country` SET TAGS ('dbx_pii_business_glossary_term' = 'Country');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Manager Email');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Manager Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_name` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_name` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Manager Phone');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `open_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Open Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `operating_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `region` SET TAGS ('dbx_pii_business_glossary_term' = 'Region');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `security_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `state` SET TAGS ('dbx_pii_business_glossary_term' = 'State');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Controlled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `warehouse_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ALTER COLUMN `zone` SET TAGS ('dbx_pii_business_glossary_term' = 'Zone');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` SET TAGS ('dbx_pii_subdomain' = 'transaction_processing');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `inventory_hold_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Inventory Hold ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Initiated By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `recall_campaign_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Campaign Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Location ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `supplier_nonconformance_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Non-Conformance ID');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `actual_release_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Release Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `batch_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Comments');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `disposition_decision` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposition Decision');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `disposition_decision` SET TAGS ('dbx_pii_value_regex' = 'use_as_is|rework|scrap|return_to_supplier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `expected_release_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Expected Release Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `hold_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Number (HOLD_NO)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `hold_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Source');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `hold_source` SET TAGS ('dbx_pii_value_regex' = 'system|manual');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `hold_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `hold_status` SET TAGS ('dbx_pii_value_regex' = 'active|released|cancelled|expired');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `hold_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `hold_type` SET TAGS ('dbx_pii_value_regex' = 'quality|engineering|regulatory|supplier|recall');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `initiating_department` SET TAGS ('dbx_pii_business_glossary_term' = 'Initiating Department');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `initiating_department` SET TAGS ('dbx_pii_value_regex' = 'quality|engineering|procurement|production|logistics');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `is_critical_hold` SET TAGS ('dbx_pii_business_glossary_term' = 'Critical Hold Flag');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `lot_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Lot Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `quantity_held` SET TAGS ('dbx_pii_business_glossary_term' = 'Quantity Held');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Reason Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `related_ecn_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `related_ppap_status` SET TAGS ('dbx_pii_business_glossary_term' = 'PPAP Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `related_ppap_status` SET TAGS ('dbx_pii_value_regex' = 'failed|pending|approved');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `serial_number_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number End');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `serial_number_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number Start');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Hold Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|KG|L|SET');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` SET TAGS ('dbx_pii_subdomain' = 'material_master');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` SET TAGS ('dbx_pii_domain_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` SET TAGS ('dbx_pii_governance_verified' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_bin_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bin Identifier');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `parent_bin_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Bin Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `parent_bin_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `primary_storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Id');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `aisle` SET TAGS ('dbx_pii_business_glossary_term' = 'Aisle');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `barcode` SET TAGS ('dbx_pii_business_glossary_term' = 'Barcode');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `bin_group` SET TAGS ('dbx_pii_business_glossary_term' = 'Bin Group');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `capacity_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `capacity_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Capacity Unit');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_bin_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `current_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Weight Kg');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_bin_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `hazardous_material_allowed` SET TAGS ('dbx_pii_business_glossary_term' = 'Hazardous Material Allowed');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `is_default` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Default');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `is_reserved` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Reserved');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `last_inventory_count_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inventory Count Date');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `last_inventory_count_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Inventory Count Quantity');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_bin_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Level');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `max_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Temperature C');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `max_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Weight Kg');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `min_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Min Temperature C');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_bin_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `occupancy_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Occupancy Percentage');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `owner_department` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Department');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `rack` SET TAGS ('dbx_pii_business_glossary_term' = 'Rack');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `reserved_for_sku` SET TAGS ('dbx_pii_business_glossary_term' = 'Reserved For Sku');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_bin_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Controlled');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `storage_bin_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_bin` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
